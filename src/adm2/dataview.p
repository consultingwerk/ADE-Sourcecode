&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/**********************************************************************************/
/* Copyright (C) 2005,2006 by Progress Software Corporation. All rights reserved. */
/* Prior versions of this work may contain portions contributed by participants   */      
/* of Possenet.                                                                   */               
/******************************************************************************/
/*--------------------------------------------------------------------------
    File        : dataview.p
    Purpose     : Super procedure for dataview class.

    Syntax      : RUN start-super-proc("adm2/dataview.p":U).

    Created     : 03/01/2005
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* class property access thru getDataContainer */
DEFINE VARIABLE ghDataContainer AS HANDLE     NO-UNDO.

&SCOP ADMSuper dataview.p

{src/adm2/schemai.i}

/* Custom exclude file */
{src/adm2/custom/dataviewexclcustom.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-activateHiddenFetchChildren) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD activateHiddenFetchChildren Procedure 
FUNCTION activateHiddenFetchChildren RETURNS CHARACTER PRIVATE
  (   )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-addDatasetClone) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD addDatasetClone Procedure 
FUNCTION addDatasetClone RETURNS LOGICAL
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-addDatasetSource) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD addDatasetSource Procedure 
FUNCTION addDatasetSource RETURNS LOGICAL
  (   )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-addRow) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD addRow Procedure 
FUNCTION addRow RETURNS CHARACTER
  ( pcViewColList AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-anyNonAutoCommitChildInDataset) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD anyNonAutoCommitChildInDataset Procedure 
FUNCTION anyNonAutoCommitChildInDataset RETURNS LOGICAL PRIVATE
        (  ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-applyContextFromServer) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD applyContextFromServer Procedure 
FUNCTION applyContextFromServer RETURNS LOGICAL
  ( pcContext AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-assignColumnColumnLabel) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD assignColumnColumnLabel Procedure 
FUNCTION assignColumnColumnLabel RETURNS LOGICAL
  ( pcColumn      AS CHARACTER,
    pcColumnLabel AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-assignColumnFormat) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD assignColumnFormat Procedure 
FUNCTION assignColumnFormat RETURNS LOGICAL
  ( pcColumn AS CHARACTER,
    pcFormat AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-assignColumnHelp) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD assignColumnHelp Procedure 
FUNCTION assignColumnHelp RETURNS LOGICAL
  ( pcColumn AS CHARACTER,
    pcHelp   AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-assignColumnLabel) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD assignColumnLabel Procedure 
FUNCTION assignColumnLabel RETURNS LOGICAL
  ( pcColumn AS CHARACTER,
    pcLabel  AS CHARACTER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-assignColumnPrivateData) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD assignColumnPrivateData Procedure 
FUNCTION assignColumnPrivateData RETURNS LOGICAL
  ( pcColumn      AS CHARACTER, 
    pcPrivateData AS CHARACTER )  FORWARD.

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

&IF DEFINED(EXCLUDE-canFindParentOnClient) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD canFindParentOnClient Procedure 
FUNCTION canFindParentOnClient RETURNS LOGICAL
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-canFindWhereOnClient) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD canFindWhereOnClient Procedure 
FUNCTION canFindWhereOnClient RETURNS LOGICAL
  ( pcWhere AS CHAR )  FORWARD.

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

&IF DEFINED(EXCLUDE-childForeignFields) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD childForeignFields Procedure 
FUNCTION childForeignFields RETURNS CHARACTER
  ( pcChild AS CHAR )  FORWARD.

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

&IF DEFINED(EXCLUDE-columnColumnLabel) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD columnColumnLabel Procedure 
FUNCTION columnColumnLabel RETURNS CHARACTER
  ( pcColumn AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnDataType) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD columnDataType Procedure 
FUNCTION columnDataType RETURNS CHARACTER
  ( pcColumn AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnDefaultValue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD columnDefaultValue Procedure 
FUNCTION columnDefaultValue RETURNS CHARACTER
  ( pcColumn AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnFormat) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD columnFormat Procedure 
FUNCTION columnFormat RETURNS CHARACTER
  ( pcColumn AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD columnHandle Procedure 
FUNCTION columnHandle RETURNS HANDLE
  ( pcColumn AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnHelp) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD columnHelp Procedure 
FUNCTION columnHelp RETURNS CHARACTER
  ( pcColumn AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnInitial) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD columnInitial Procedure 
FUNCTION columnInitial RETURNS CHARACTER
  ( pcColumn AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnLabel) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD columnLabel Procedure 
FUNCTION columnLabel RETURNS CHARACTER
  ( pcColumn AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnLongCharValue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD columnLongCharValue Procedure 
FUNCTION columnLongCharValue RETURNS LONGCHAR
  ( pcColumn AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnName) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD columnName Procedure 
FUNCTION columnName RETURNS CHARACTER
  ( phHandle AS HANDLE)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnPrivateData) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD columnPrivateData Procedure 
FUNCTION columnPrivateData RETURNS CHARACTER
  ( pcColumn AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnReadOnly) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD columnReadOnly Procedure 
FUNCTION columnReadOnly RETURNS LOGICAL
  ( pcColumn AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnStringValue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD columnStringValue Procedure 
FUNCTION columnStringValue RETURNS CHARACTER
  ( pcColumn AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnTable) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD columnTable Procedure 
FUNCTION columnTable RETURNS CHAR
  ( pcColumn AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnValue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD columnValue Procedure 
FUNCTION columnValue RETURNS CHARACTER
  ( pcColumn AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnWidth) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD columnWidth Procedure 
FUNCTION columnWidth RETURNS DECIMAL
  ( pcColumn AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-colValues) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD colValues Procedure 
FUNCTION colValues RETURNS CHARACTER
  ( pcViewColList AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-compareTableValues) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD compareTableValues Procedure 
FUNCTION compareTableValues RETURNS CHARACTER
  ( phBufferOne AS HANDLE,
    phBufferTwo AS HANDLE)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-copyLargeColumnToFile) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD copyLargeColumnToFile Procedure 
FUNCTION copyLargeColumnToFile RETURNS LOGICAL
  ( pcColumn   AS CHAR,
    pcFileName AS CHARACTER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-copyLargeColumnToMemptr) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD copyLargeColumnToMemptr Procedure 
FUNCTION copyLargeColumnToMemptr RETURNS LOGICAL
  ( pcColumn AS CHAR,
    pmMemptr AS MEMPTR)  FORWARD.

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

&IF DEFINED(EXCLUDE-deleteRow) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD deleteRow Procedure 
FUNCTION deleteRow RETURNS LOGICAL
  ( pcRowIdent AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-destroyView) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD destroyView Procedure 
FUNCTION destroyView RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-findRowObjectUseRowIdent) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD findRowObjectUseRowIdent Procedure 
FUNCTION findRowObjectUseRowIdent RETURNS LOGICAL
  ( INPUT pcRowIdent AS CHARACTER )  FORWARD.

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

&IF DEFINED(EXCLUDE-findRowWhere) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD findRowWhere Procedure 
FUNCTION findRowWhere RETURNS LOGICAL
  (pcColumns     AS CHARACTER,   
   pcValues      AS CHARACTER,    
   pcOperators   AS CHARACTER) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-findUniqueRowWhere) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD findUniqueRowWhere Procedure 
FUNCTION findUniqueRowWhere RETURNS LOGICAL
  (pcColumns     AS CHARACTER,   
   pcValues      AS CHARACTER,    
   pcOperators   AS CHARACTER) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getAuditEnabled) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getAuditEnabled Procedure 
FUNCTION getAuditEnabled RETURNS LOGICAL
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getAutoCommit) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getAutoCommit Procedure 
FUNCTION getAutoCommit RETURNS LOGICAL
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getBusinessEntity) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getBusinessEntity Procedure 
FUNCTION getBusinessEntity RETURNS CHARACTER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDataContainerHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getDataContainerHandle Procedure 
FUNCTION getDataContainerHandle RETURNS HANDLE
  ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDatasetName) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getDatasetName Procedure 
FUNCTION getDatasetName RETURNS CHARACTER
  ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDatasetSource) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getDatasetSource Procedure 
FUNCTION getDatasetSource RETURNS HANDLE
  ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDataTable) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getDataTable Procedure 
FUNCTION getDataTable RETURNS CHARACTER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getForeignFields) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getForeignFields Procedure 
FUNCTION getForeignFields RETURNS CHARACTER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getHasFirst) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getHasFirst Procedure 
FUNCTION getHasFirst RETURNS LOGICAL
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getHasLast) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getHasLast Procedure 
FUNCTION getHasLast RETURNS LOGICAL
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getIndexInformation) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getIndexInformation Procedure 
FUNCTION getIndexInformation RETURNS CHARACTER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getKeyFields) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getKeyFields Procedure 
FUNCTION getKeyFields RETURNS CHARACTER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getKeyTableId) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getKeyTableId Procedure 
FUNCTION getKeyTableId RETURNS CHARACTER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getKeyWhere) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getKeyWhere Procedure 
FUNCTION getKeyWhere RETURNS CHARACTER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getNewMode) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getNewMode Procedure 
FUNCTION getNewMode RETURNS LOGICAL
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getNewRow) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getNewRow Procedure 
FUNCTION getNewRow RETURNS LOGICAL
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getQueryOpen) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getQueryOpen Procedure 
FUNCTION getQueryOpen RETURNS LOGICAL
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getQueryStringDefault) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getQueryStringDefault Procedure 
FUNCTION getQueryStringDefault RETURNS CHARACTER
  (   )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getQueryTables) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getQueryTables Procedure 
FUNCTION getQueryTables RETURNS CHARACTER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getRequestHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getRequestHandle Procedure 
FUNCTION getRequestHandle RETURNS HANDLE
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getResortOnSave) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getResortOnSave Procedure 
FUNCTION getResortOnSave RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getRowident) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getRowident Procedure 
FUNCTION getRowident RETURNS CHARACTER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getRowObjectState) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getRowObjectState Procedure 
FUNCTION getRowObjectState RETURNS CHARACTER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getRowParentChanged) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getRowParentChanged Procedure 
FUNCTION getRowParentChanged RETURNS LOGICAL
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getRowUpdated) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getRowUpdated Procedure 
FUNCTION getRowUpdated RETURNS LOGICAL
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getScrollable) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getScrollable Procedure 
FUNCTION getScrollable RETURNS LOGICAL
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getSubmitParent) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getSubmitParent Procedure 
FUNCTION getSubmitParent RETURNS LOGICAL
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getUndoDeleteOnSubmitError) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getUndoDeleteOnSubmitError Procedure 
FUNCTION getUndoDeleteOnSubmitError RETURNS CHARACTER
  ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getUndoOnConflict) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getUndoOnConflict Procedure 
FUNCTION getUndoOnConflict RETURNS CHARACTER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getUseDBQualifier) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getUseDBQualifier Procedure 
FUNCTION getUseDBQualifier RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getViewTables) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getViewTables Procedure 
FUNCTION getViewTables RETURNS CHARACTER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getWordIndexedFields) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getWordIndexedFields Procedure 
FUNCTION getWordIndexedFields RETURNS CHARACTER
  ( )  FORWARD.

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

&IF DEFINED(EXCLUDE-instanceOf) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD instanceOf Procedure 
FUNCTION instanceOf RETURNS LOGICAL
    ( INPUT pcClass AS CHARACTER )  FORWARD.

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

&IF DEFINED(EXCLUDE-isFetchedByParent) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD isFetchedByParent Procedure 
FUNCTION isFetchedByParent RETURNS logical
        (  ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-keyWhere) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD keyWhere Procedure 
FUNCTION keyWhere RETURNS CHARACTER
 (phBuffer AS HANDLE,
  pcQual   AS CHAR ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-obtainContextForServer) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD obtainContextForServer Procedure 
FUNCTION obtainContextForServer RETURNS CHARACTER
  (  )  FORWARD.

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

&IF DEFINED(EXCLUDE-openDataView) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD openDataView Procedure 
FUNCTION openDataView RETURNS LOGICAL
  (   )  FORWARD.

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

&IF DEFINED(EXCLUDE-openQueryAtPosition) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD openQueryAtPosition Procedure 
FUNCTION openQueryAtPosition RETURNS LOGICAL
  ( pcPosition AS CHAR  )  FORWARD.

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

&IF DEFINED(EXCLUDE-refreshSort) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD refreshSort Procedure 
FUNCTION refreshSort RETURNS LOGICAL
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-refreshViewTables) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD refreshViewTables Procedure 
FUNCTION refreshViewTables RETURNS LOGICAL
  (   )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-removeDatasetClone) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD removeDatasetClone Procedure 
FUNCTION removeDatasetClone RETURNS LOGICAL
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-reopenQuery) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD reopenQuery Procedure 
FUNCTION reopenQuery RETURNS LOGICAL
  (  )  FORWARD.

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

&IF DEFINED(EXCLUDE-resolveBuffer) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD resolveBuffer Procedure 
FUNCTION resolveBuffer RETURNS CHARACTER
  ( pcBuffer AS CHAR )  FORWARD.

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

&IF DEFINED(EXCLUDE-retrieveCurrent) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD retrieveCurrent Procedure 
FUNCTION retrieveCurrent RETURNS LOGICAL
  ( plRefresh AS LOG )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-retrieveData) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD retrieveData Procedure 
FUNCTION retrieveData RETURNS LOGICAL
  ( pcMode AS CHAR,
    plRefresh AS LOG,
    piNumRows AS INT)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-retrieveRows) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD retrieveRows Procedure 
FUNCTION retrieveRows RETURNS LOGICAL
  ( pcTables AS CHAR,
    pcQueries AS CHAR,
    pcPositionFields AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setBusinessEntity) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setBusinessEntity Procedure 
FUNCTION setBusinessEntity RETURNS LOGICAL
  ( pcBusinessEntity AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setDatasetName) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setDatasetName Procedure 
FUNCTION setDatasetName RETURNS LOGICAL
  ( pcName AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setDatasetSource) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setDatasetSource Procedure 
FUNCTION setDatasetSource RETURNS LOGICAL
  ( phSource AS HANDLE )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setDataTable) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setDataTable Procedure 
FUNCTION setDataTable RETURNS LOGICAL
  ( pcDataTable AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setResortOnSave) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setResortOnSave Procedure 
FUNCTION setResortOnSave RETURNS LOGICAL
  ( plResortOnSave AS LOGICAL )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setSubmitParent) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setSubmitParent Procedure 
FUNCTION setSubmitParent RETURNS LOGICAL
  ( plSubmitParent AS LOGICAL )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setUndoDeleteOnSubmitError) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setUndoDeleteOnSubmitError Procedure 
FUNCTION setUndoDeleteOnSubmitError RETURNS LOGICAL
  ( pcUndoDelete AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setUndoOnConflict) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setUndoOnConflict Procedure 
FUNCTION setUndoOnConflict RETURNS LOGICAL
  ( pcUndoOnConflict AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-submitData) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD submitData Procedure 
FUNCTION submitData RETURNS LOGICAL
  (  )  FORWARD.

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

&IF DEFINED(EXCLUDE-updateLargeColumns) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD updateLargeColumns Procedure 
FUNCTION updateLargeColumns RETURNS LOGICAL
  (  )  FORWARD.

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
         HEIGHT             = 27.29
         WIDTH              = 55.2.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB Procedure 
/* ************************* Included-Libraries *********************** */

{src/adm2/dataviewprop.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-buildDataRequest) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE buildDataRequest Procedure 
PROCEDURE buildDataRequest :
/*------------------------------------------------------------------------------
Purpose:      Build request info to be used as parameters for data 
              retrieval. 
Parameters: 
   phOwner   - The object that initiated this request.     
   pcDataSource    
             - Data source entity name in the case this request is from
               a data source. 
               This means that foreignfields need to be collected.
   pcViewerSource  
             - Viewer's data source entity name in the case 
               this request is passed through a containing viewer. 
               This means that this object probably has a link to an 
               SDF and position info need to be collected. The object
               may still be a child of another object on the viewer so 
               foreignfields are also collected. 
  INPUT-OUTPUT pcRequests   
  INPUT-OUTPUT pcDataTables 
  INPUT-OUTPUT pcQueries  
  INPUT-OUTPUT pcBatchSizes  
  INPUT-OUTPUT pcForeignFields  
              - Semi-colon separeted list of foreign values.
                The other object's (parent) field is qualified with 
                entity if different than this object's entity.
                The order is child,parent as stored in the property,
                opposite of how it is used in a prodataset relation
  INPUT-OUTPUT pcPositionFields
              - semi-colon separated list of position foreign values.
                (A single child relation on which smartviewer this 
                 object is dropped to lookup this table with an SDF)
                The other object's (child) field is qualified with 
                entity if different than this object's entity.
                The order is parent,child because... eh.. well..hmm
                it is similar to the foreignvalues in that THIS field
                is first and that it is opposite of how it is used in 
                a prodataset relation.    
  input-output pccontext              
        -- dataset information ---                                              
  
  INPUT-OUTPUT pcDatasetSources
  INPUT-OUTPUT pcEntities
  INPUT-OUTPUT pcEntityNames   
  
  Notes:    The requesting container will publish this or the object will 
            run this in itself before data retrieval.
            The object subscribes to this as datasource event and the event 
            is republished to reach all objects in the data-link chain.
            Objects that are top only will subscribe to its container's 
            event in initializeDataObjects and the container then publishes
            the event to collect the request info in fetchData. This includes 
            objects that have parents that are already initialized (on parent 
            containers).   
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER phOwner         AS HANDLE     NO-UNDO.
  DEFINE INPUT  PARAMETER pcDataSource    AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pcViewerSource  AS CHARACTER  NO-UNDO.
  DEFINE INPUT-OUTPUT PARAMETER pcRequests       AS CHARACTER  NO-UNDO.
  DEFINE INPUT-OUTPUT PARAMETER pcDataTables     AS CHARACTER  NO-UNDO.
  DEFINE INPUT-OUTPUT PARAMETER pcQueries        AS CHARACTER  NO-UNDO.
  DEFINE INPUT-OUTPUT PARAMETER pcBatchSizes     AS CHARACTER  NO-UNDO.
  DEFINE INPUT-OUTPUT PARAMETER pcForeignFields  AS CHARACTER  NO-UNDO.
  DEFINE INPUT-OUTPUT PARAMETER pcPositionFields AS CHARACTER  NO-UNDO.
  DEFINE INPUT-OUTPUT PARAMETER pcContext        AS CHARACTER  NO-UNDO.
  DEFINE INPUT-OUTPUT PARAMETER pcDatasetSources AS CHARACTER  NO-UNDO.
  DEFINE INPUT-OUTPUT PARAMETER pcEntities       AS CHARACTER  NO-UNDO.
  DEFINE INPUT-OUTPUT PARAMETER pcEntityNames    AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE cBusinessEntity   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hDatasetSource    AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cDatasetName      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDataTable        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDatasetTable     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cQuery            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cForeignFields    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cPositionFields   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iRowsToBatch      AS INTEGER    NO-UNDO.
  DEFINE VARIABLE lOpenOnInit       AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE hTarget           AS HANDLE     NO-UNDO.
  DEFINE VARIABLE iTarget           AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cTargetType       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lLocalField       AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cFieldName        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cKeyField         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDlm1             AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDlm2             AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iField            AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cField            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hDataSource       AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hContainer        AS HANDLE     NO-UNDO.
  DEFINE VARIABLE lInitialized      AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cBatch            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iSource           AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cParentTable      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cParentEntity     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cParentDataset    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lParentInEntity   AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lDataIsFetched    AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cRequest          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iEntity           AS INTEGER    NO-UNDO.
  DEFINE VARIABLE lSkip             AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cViewTables       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iTable            AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cTable            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cTargets          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hPositionSource   AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cPosSourceTables  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hPosSourceDSproc  AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cPosSourceDSName  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cQueryTables      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cQueryColumns     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cRequestQuery     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSortExpression   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lQueryOpen        AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cRequestDlm       AS CHARACTER  NO-UNDO.

  &SCOPED-DEFINE xp-assign
  {get BusinessEntity cBusinessEntity}
  {get DatasetName cDatasetName}
  {get DatasetSource hDatasetSource}
  {get DataTable cDataTable}
  {get ForeignFields cForeignFields}
  {get RowsToBatch iRowsToBatch}
  {get OpenOnInit lOpenOnInit}
  {get QueryString cQuery}
  {get ObjectInitialized lInitialized}
  {get DataSource hDataSource}
  {get DataIsFetched lDataIsFetched}
  {get DataTarget cTargets}
  {get ViewTables cViewTables}
  {get QueryOpen lQueryOpen}
  .
  &UNDEFINE xp-assign
  
  cRequestDlm = CHR(1).
  
  IF cBusinessEntity > '' AND cDataTable > '' THEN
  DO:
    IF cDatasetName = '' OR cDatasetName = ? THEN 
      cDatasetName = cBusinessEntity.
    /* allow pass-thru SDO (currently has function but no buffer-field) */
    IF VALID-HANDLE(hDataSource) THEN
      {get DataTable cParentTable hDataSource} NO-ERROR.
    
    /* Check if parent is DEFS (openoninit false ) and set DEFS on this object
       if it is. */
    IF NOT lInitialized THEN
    DO:
      IF phOwner <> TARGET-PROCEDURE THEN
        SUBSCRIBE PROCEDURE TARGET-PROCEDURE TO 'dataRequestComplete':U IN phOwner
          RUN-PROCEDURE 'startObject':U.
      IF lOpenOnInit AND VALID-HANDLE(hDataSource) AND pcDataSource > '' THEN
      DO:
        iSource = LOOKUP(pcDataSource + '.':U + cParentTable,pcDataTables).
        IF iSource > 0 THEN
          lOpenOnInit = ENTRY(iSource,pcRequests,cRequestDlm) <> 'DEFS':U.
      END.
      {get PositionSource hPositionSource}.
      
      IF VALID-HANDLE(hPositionSource) THEN  
      DO:
        &SCOPED-DEFINE xp-assign
        {get DatasetName cPosSourceDSName hPositionSource}
        {get ViewTables  cPosSourceTables hPositionSource}
        .
        &UNDEFINE xp-assign
        IF cPosSourceDSName = cDataSetName 
        AND LOOKUP(cDataTable,cPosSourceTables) > 0 THEN
        DO:
          IF iRowsToBatch <> 0 THEN
            lSkip = TRUE. 
        END.
      END.
    END. /* not initialized */
    ELSE 
    DO:
      /* don't open openoninit from parent request so just return as no chidren
         should be opened either (openoninit is is set to true when opened) */
      IF NOT lOpenOnInit AND VALID-HANDLE(hDataSource) AND pcDataSource > '' THEN
        RETURN. /* --------------------------------------> */ 

      {get PositionSource hPositionSource}.
      IF VALID-HANDLE(hPositionSource) AND pcViewerSource > '' THEN 
      DO:
        IF {fn isDataQueryComplete} THEN
          lSkip = TRUE.
        /* The phOwner's data flow will not open our query, so subscribe to 
            the request completion  */ 
        ELSE IF phOwner <> TARGET-PROCEDURE AND NOT VALID-HANDLE(hDataSource) THEN
        DO:
          SUBSCRIBE PROCEDURE TARGET-PROCEDURE TO 'dataRequestComplete':U IN phOwner
           RUN-PROCEDURE 'refreshDataQuery':U.
          IF LOOKUP(cDatasetName + '.':U + cDataTable,pcDataTables) > 0 THEN
            lSkip = TRUE.
        END.
      END.
    END. /* else (initialized)*/
    IF NOT lSkip THEN
    DO:
      IF lInitialized OR lOpenOnInit THEN
      DO:
        IF VALID-HANDLE(hDataSource) THEN 
        DO:
          /* parent not part of request, add the key and set isfetched flag off 
             as this object has to do its own requests */
          IF pcDataSource = '' THEN
          DO:
            {fn addForeignKey}.
            {get QueryString cQuery}.
            {set DataIsFetched FALSE}.
            ASSIGN
              cForeignFields = '' 
              cRequest = 'FIRST':U. /* FetchOnOpen..*/
          END.
          ELSE  
          DO:
            {fn removeForeignKey}.
            {get QueryString cQuery}.
  
            /*  foreign fields across business entities need to be qualified 
                we also set request to 'FIRST' (first batch on child for one parent)*/
            IF cForeignFields > '':U AND pcDataSource <> cDatasetName THEN
            DO: 
              {set DataIsFetched FALSE}.
              cRequest = 'FIRST':U. /* FetchOnOpen..*/
              DO iField = 2 TO NUM-ENTRIES(cForeignfields) BY 2:
                ENTRY(iField,cForeignFields) = pcDataSource + '.':U 
                                            + ENTRY(iField,cForeignFields).
              END.
            END.
            ELSE  /* default prodataset retrieval turned off  */
            IF lDataIsFetched = FALSE THEN
              cRequest = 'FIRST':U.
            ELSE /* unknown or true  (default - all children for all parents) */
              ASSIGN
                cRequest     = 'ALL':U
                iRowsToBatch = 0. /* no batching in default child retrieval*/
          END. 
        END. /* datasource */
        ELSE /* Default for top is first batch  
               (retrieveBatch will override this for the first table of the request) */
          ASSIGN
            cRequest = 'FIRST':U
            cForeignFields = '':U.
        
          /* Look for a single SDF target, an SDF source may have other targets, 
           typically another SDF source.
           if this is a request for all data then this info is irrelevant */         
        IF iRowsToBatch <> 0 THEN
        FieldLoop:
        DO iTarget = 1 TO NUM-ENTRIES(cTargets):
          hTarget =  WIDGET-HANDLE(ENTRY(iTarget,cTargets)).
          {get ObjectType cTargetType hTarget}.
          IF cTargetType = 'SmartDataField':U THEN
          DO:

            &SCOPED-DEFINE xp-assign
            {get LocalField lLocalField hTarget}
            {get FieldName cFieldName hTarget}
            {get KeyField cKeyField hTarget}
             .
            &UNDEFINE xp-assign

            /* there's not much we can do with a local field */
            IF NOT lLocalField THEN
            DO:
              IF pcViewerSource > '':U THEN  
                cPositionFields = cKeyField + ',':U
                                + (IF pcViewerSource <> cDatasetName
                                   THEN pcViewerSource + '.':U
                                   ELSE '':U)
                                + cFieldName.
              ELSE DO:
                {get ContainerSource hContainer hTarget}.
                {get DataSource hPositionSource hContainer}.
                /* avoid error if viewer run without its source */
                IF VALID-HANDLE(hDataSource) THEN
                  cRequest = 'WHERE ' + cKeyField + ' = ' 
                         + QUOTER({fnarg columnValue cFieldName hPositionSource}).
                
              END.
            END.
            LEAVE FieldLoop.
          END. /* SDF */
        END. /* if irowstobatch <> 0 do iTarget loop  */
        
        cBatch = STRING(iRowsToBatch).

        IF cQuery = '':U THEN
          {get QueryStringDefault cQuery}.

        &SCOPED-DEFINE xp-assign
        {get QueryTables cQueryTables}
        {get QueryColumns cQueryColumns}
         .
        &UNDEFINE xp-assign
        /* trim request query for tables not in expression or sort*/
        IF NUM-ENTRIES(cQueryTables) > 1 THEN
        DO:
          cSortExpression = {fnarg sortExpression cQuery}.
          DO iTable = 1 TO NUM-ENTRIES(cQueryTables):
            cTable = ENTRY(iTable,cQueryTables).
            /* Only pass secondary tables if explicitly in the query or 
               sort expression  */
            IF iTable = 1 
            OR INDEX(' ':U + cSortExpression,' ':U + cTable + '.':U) > 0
            OR INDEX(':':U + cQueryColumns,':' + cTable + ':':U) > 0 THEN
              cRequestQuery = cRequestQuery 
                    + (IF cRequestQuery = '':U THEN '':U ELSE ',':U)
                    + DYNAMIC-FUNCTION('bufferWhereClause':U IN TARGET-PROCEDURE,
                                        cTable,
                                        cQuery).
          END. /* DO iTable = 1 TO NUM-ENTRIES(cSortTables) */
          cQuery = LEFT-TRIM(cRequestQuery + ' ' + cSortExpression).
        END. 
      END.  /* open (already initialized or openoninit true )*/
      ELSE  /* don't open */
        ASSIGN 
          cBatch   = '?':U
          cRequest = 'DEFS':U
          cQuery   = 'DEFS':U.
    
      ASSIGN
        cDatasetTable = cDatasetName + '.':U + cDataTable 
        cDlm1 = (IF (pcDataTables = '':U) THEN '':U ELSE ',':U)
        cDlm2 = (IF (pcDataTables = '':U) THEN '':U ELSE cRequestDlm)
        pcDataTables     = pcDataTables  + cDlm1 + cDatasetTable
        pcBatchSizes     = pcBatchSizes  + cDlm1 + cBatch  
        pcContext        = pcContext     + cDlm2 + {fn obtainContextForServer}
        pcRequests       = pcRequests    + cDlm2 + cRequest
        pcQueries        = pcQueries     + cDlm2 + (IF cQuery = ? THEN '':U ELSE cQuery)
        /* Use semi-colon separators since there may be any number of fields 
           in the already comma-separated ForeignFields (theoretically also in 
           positionfields although not supported in default SDF implementation)*/
        pcForeignFields  = pcForeignFields + cDlm2 
                           + (IF cForeignFields > '':U THEN cForeignFields ELSE '':U)
        pcPositionFields = pcPositionFields + cDlm2 
                           + (IF cPositionFields > '':U THEN cPositionFields ELSE '':U)      
        .

      /* Add additional viewtables to list (except parent tables)         
        (Request 'ALL' = default dataset retrieval) */ 
      
      DO iTable = 2 TO NUM-ENTRIES(cViewTables):
        cTable = ENTRY(iTable,cViewTables).
        
        /* If the parent is in viewtables (ensure same entity), 
           we don't need to retrieve it.  */ 
        IF cParentTable = cTable THEN
        DO:
          &SCOPED-DEFINE xp-assign
          {get BusinessEntity cParentEntity hDataSource}
          {get DatasetName cParentDataset hDataSource}
          .
          &UNDEFINE xp-assign 
          lParentInEntity = (cParentEntity = cBusinessentity) 
                            AND 
                            (cParentDataset = cDatasetName). 
        END.
        ELSE 
          lParentInEntity = FALSE.
        
        
        /* reposition tables are retrieved on first request (not open)  */
        IF NOT lParentInEntity
        AND (NOT lQueryOpen 
             OR (VALID-HANDLE(hDatasetSource) 
                 AND NOT {fnarg isReposition cTable hDatasetSource})
             ) THEN
          ASSIGN
            cDlm1            = ',':U
            cDlm2            = cRequestDlm
            pcDataTables     = pcDataTables  + cDlm1 
                             + cDatasetName + '.':U + cTable
            pcBatchSizes     = pcBatchSizes  + cDlm1
                             + '0':U  
            pcRequests       = pcRequests    + cDlm2
                             + (IF cRequest = 'DEFS':U 
                                THEN 'DEFS':U 
                                ELSE 'ALL':U)
            pcQueries        = pcQueries     + cDlm2 
                             + (IF cRequest = 'DEFS':U 
                                THEN 'DEFS':U 
                                ELSE 'FOR EACH ':U + cTable)
            pcForeignFields  = pcForeignFields  + cDlm2 + '':U
            pcPositionFields = pcPositionFields + cDlm2 + '':U
            .

      END. /* iTable loop additional tables */   
      
      IF LOOKUP(cDatasetName,pcEntityNames) = 0 THEN
        ASSIGN
          cDlm1            = (IF (pcEntities = '':U) THEN '':U ELSE ',':U)
          pcEntities       = pcEntities    + cDlm1 + cBusinessEntity
          pcEntityNames    = pcEntityNames + cDlm1 + cDatasetName 
          pcDatasetSources = pcDatasetSources + cDlm1 
                           + (IF VALID-HANDLE(hDatasetSource) 
                              THEN STRING(hDatasetSource)
                              ELSE '?':U).
    END. /* not skip */
    
    PUBLISH "buildDataRequest":U FROM TARGET-PROCEDURE
                               (INPUT phOwner,
                                INPUT cDatasetName,
                                INPUT pcViewerSource,
                                INPUT-OUTPUT pcRequests, 
                                INPUT-OUTPUT pcDataTables,
                                INPUT-OUTPUT pcQueries,
                                INPUT-OUTPUT pcBatchSizes,
                                INPUT-OUTPUT pcForeignFields,
                                INPUT-OUTPUT pcPositionFields,
                                INPUT-OUTPUT pcContext,
                                INPUT-OUTPUT pcDatasetSources,
                                INPUT-OUTPUT pcEntities,
                                INPUT-OUTPUT pcEntityNames).
 
  END. /* IF cBusinessEntity > '' AND cDataTable > '' */

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-buildViewRequest) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE buildViewRequest Procedure 
PROCEDURE buildViewRequest :
/*------------------------------------------------------------------------------
Purpose:      Build request info to be used as parameters for data 
              retrieval. 
Parameters: plCheckAvail - only return for not avail views
            plRepos - include repos relations 
            OUTPUT pcDataTables             
            OUTPUT pcQueries -   
            OUTPUT pcPositionFields 
               - semi-colon separated list of position foreign values.
                (A single child relation on which smartviewer this 
                 object is dropped to lookup this table with an SDF)
                The other object's (child) field is qualified with 
                entity if different than this object's entity.
                The order is parent,child because... eh.. well..hmm
                it is similar to the foreignvalues in that THIS field
                is first and that it is opposite of how it is used in 
                a prodataset relation. 
                  
    Notes:
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER plCheckAvail     AS LOGICAL    NO-UNDO.
  DEFINE INPUT  PARAMETER plRepos          AS LOGICAL    NO-UNDO. 
  DEFINE OUTPUT PARAMETER pcDataTables     AS CHARACTER  NO-UNDO.
  DEFINE OUTPUT PARAMETER pcQueries        AS CHARACTER  NO-UNDO.
  DEFINE OUTPUT PARAMETER pcPositionFields AS CHARACTER  NO-UNDO.
  
  DEFINE VARIABLE cJoinTables     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hDatasetSource  AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cDataTable      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cKeyWhere       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iTable          AS INTEGER    NO-UNDO. 
  DEFINE VARIABLE hDataSource     AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cDatasetName    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cBusinessEntity AS CHARACTER  NO-UNDO.  
  DEFINE VARIABLE cParentDSName   AS CHARACTER  NO-UNDO. 
  DEFINE VARIABLE cParentEntity   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cParent         AS CHARACTER  NO-UNDO. 
  DEFINE VARIABLE iParent         AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cTable          AS CHARACTER  NO-UNDO.

  &scop xp-assign 
  {get DatasetSource hDatasetSource}
  {get DataTable cDataTable}
  {get ViewTables cJoinTables}
  {get DataSource hDataSource}
  {get BusinessEntity cBusinessEntity}
  {get DatasetName cDatasetName}  
   .
  &undefine xp-assign
  
  IF VALID-HANDLE(hDataSource) THEN 
  DO:
    &scop xp-assign 
    {get DatasetName cParentDSName hDataSource}
    {get BusinessEntity cParentEntity hDataSource}
    {get DataTable cParent hDataSource} 
    .
    &undefine xp-assign
    
    iParent = LOOKUP(cParent,cJoinTables).
    
    IF iParent > 0  
    AND cParentEntity = cBusinessentity 
    AND cParentDSName = cDatasetName THEN  
      cJoinTables = DYNAMIC-FUNCTION("deleteEntry" IN TARGET-PROCEDURE,
                                      iParent,
                                      cJoinTables,
                                      ",":U).
                                      
  END. /* valid datasource */
       
  IF VALID-HANDLE(hDatasetSource) THEN 
  DO:
    IF plCheckAvail THEN  
      {get KeyWhere cKeyWhere}.
      
    RUN buildViewRequest IN hDatasetSource
            (cDataTable,
             cKeyWhere,
             cJoinTables,
             plRepos,
             OUTPUT pcDataTables,
             OUTPUT pcQueries,
             OUTPUT pcPositionFields).
     
  END.
  ELSE DO:
    pcPositionFields = FILL(CHR(1),NUM-ENTRIES(cJoinTables) - 1).            
    DO iTable = 1 TO NUM-ENTRIES(cJoinTables):
      ASSIGN
        cTable       = ENTRY(iTable,cJoinTables)  
        pcDataTables = pcDataTables 
                     + (IF iTable = 1 THEN "" ELSE ",")
                     + cTable 
        pcQueries    = pcQueries  
                     + (IF iTable = 1 THEN "" ELSE CHR(1))
                     + "FOR EACH " + cTable.
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
  Purpose:   Save all dataset changes.   
  Parameters:  
  Notes:     This includes all child data in the dataset.  
             The term transaction is historical (SDO) and somewhat misleading 
             since the service decides whether the submitted records are 
             saved in one single transaction or multiple transactions   
------------------------------------------------------------------------------*/
  DEFINE VARIABLE lCancel       AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lOk           AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cKeyWhere     AS CHAR       NO-UNDO.

  /* Record changes that haven't been saved must be saved before a commit.*/
  /* Visual dataTargets subscribes to this */
  PUBLISH 'confirmCommit':U FROM TARGET-PROCEDURE (INPUT-OUTPUT lCancel).
  IF lCancel THEN 
    RETURN 'ADM-ERROR':U.
  
  {get keyWhere cKeyWhere}. 

  lOk = {fn submitData}.
  IF lOk THEN  
  DO:
    IF cKeyWhere = ? THEN
      cKeyWhere = ''.
    {fnarg openDataQuery cKeyWhere}.
    
    {fn reopenQuery}.
  END.
  ELSE DO:  
    /* Add the update cancelled message, unless messages already present 
      (from an unexpected server errror) */
    IF NOT {fn anyMessage} THEN 
      RUN addMessage IN TARGET-PROCEDURE({fnarg messageNumber 15},?,?).  
    
    RUN processSubmitException IN TARGET-PROCEDURE.
    /* show messages in update target */
    RUN processMessages IN TARGET-PROCEDURE. 
    
    {fn reopenQuery}.
  END.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-createObjects) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE createObjects Procedure 
PROCEDURE createObjects :
/*------------------------------------------------------------------------------
  Purpose:  CreateObjects defines the object and its handles    
  Notes:    Should only be called once at runtime
          -
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hDataContainer AS HANDLE     NO-UNDO.
  
  DEFINE VARIABLE cDataTable          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hRowObject             AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hDatasetSource      AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hDataHandle         AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cColumns            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iTable              AS INTEGER    NO-UNDO.
  DEFINE VARIABLE hChild              AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cChild              AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cUpdatableColumns   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cViewTables         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iCol                AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cTable              AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cQueryTables        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cTableColumns       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cContext            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hBuffer             AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cBufferHandles      AS CHARACTER  NO-UNDO.

  &SCOPED-DEFINE xp-assign 
  {get DatasetSource hDatasetSource}
  {get DataTable cDataTable}
  {get RowObject hRowObject}
  .
  &UNDEFINE xp-assign
  
  /* The intention is to support any TT by just setting the Rowobject 
     (as of current not supported as other logic still require a dataset) */
  IF NOT VALID-HANDLE(hRowObject) THEN  
  DO:
    IF NOT VALID-HANDLE(hDatasetSource) AND {fn addDatasetSource} THEN
      {get DatasetSource hDatasetSource}.

    IF VALID-HANDLE(hDatasetSource) AND cDataTable > '' THEN
    DO:
      cContext = {fnarg tableContext cDataTable hDatasetSource}. 
      IF cContext > '' THEN
        {fnarg applyContextFromServer cContext}.

      assign 
        hRowObject     = {fnarg createBuffer cDataTable hDatasetSource}
        cBufferHandles = string(hRowObject).
      {set RowObject hRowObject}.
      
    END.
  END.

  IF VALID-HANDLE(hRowObject) AND VALID-HANDLE(hDatasetSource) THEN
  DO:
    {get QueryTables cQueryTables}.
    CREATE QUERY hDataHandle.
    hDataHandle:ADD-BUFFER(hRowObject).
    /* Start on 2nd, the 1st table is the Datatable and is added above */
    DO iTable = 2 TO NUM-ENTRIES(cQueryTables):
      ASSIGN
        cChild = ENTRY(iTable,cQueryTables)
        hChild = {fnarg createBuffer cChild hDatasetSource}
        .
      IF VALID-HANDLE(hChild) THEN
        hDataHandle:ADD-BUFFER(hChild).
    END.

    {get UpdatableColumns cUpdatableColumns}.
   
    cColumns = {fnarg dataColumns cDataTable hDatasetSource}.
    /* if updatableColumns not defined (from context ..) then set them from
       columns */  
    IF cUpdatableColumns = ? THEN
      {set UpdatableColumns cColumns}.

    {get ViewTables cViewTables}.  
    /* Start on 2nd, the 1st table is the Datatable and is handled above */
    DO iTable = 2 TO NUM-ENTRIES(cViewTables):
      ASSIGN 
        cTable        = ENTRY(iTable,cViewTables)
        cTableColumns = {fnarg dataColumns cTable hDatasetSource} 
        cColumns     = cColumns 
                      + (IF cColumns <> '' AND cTableColumns <> '' THEN ',' ELSE '') 
                      + cTableColumns.
      
      if lookup(cTable,cQueryTables) > 0 then 
        hBuffer = hDataHandle:get-buffer-handle(cTable).
      else 
        hBuffer = {fnarg createBuffer cTable hDatasetSource}.
      
      cBufferHandles = cBufferHandles + ",":U
                     + string(hBuffer).   
                            
    END. /* do itable = 2 to num-entries */
    
    &SCOPED-DEFINE xp-assign
    {set DataColumns cColumns}
    {set BufferHandles cBufferHandles}
    {set DataHandle hDataHandle}
    .
    &UNDEFINE xp-assign
    
    IF hRowObject:TABLE-HANDLE:DYNAMIC OR VALID-HANDLE(hRowObject:TABLE-HANDLE:BEFORE-TABLE) THEN
      hRowObject:TABLE-HANDLE:TRACKING-CHANGES = TRUE.
  END. /* valid buffer and datasetsource */
  
  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-dataAvailable) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE dataAvailable Procedure 
PROCEDURE dataAvailable :
/*------------------------------------------------------------------------------
  Purpose:   Receives dataavailable events from data-source as well as 
             data-targets     
  Parameters:  pcMode  
                 DIFFERENT - open query  
                 RESET     - open query if foreign key changed
                 VALUE-CHANGED -  row change only (browse navigation) 
  
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcMode AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE hRowObject          AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hDataset            AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cTarget             AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hDataSource         AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cForeignFields      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hDataSetsource      AS HANDLE     NO-UNDO.
  DEFINE VARIABLE lInitialized        AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lOpen               AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lDataIsFetched      AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lClose              AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lQueryOpen          AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cFetchTree          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cParentPos          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lReset              AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lResort             AS LOGICAL    NO-UNDO.
  define variable cDataTable          as character  no-undo.

  &SCOPED-DEFINE xp-assign
  {get DataTarget cTarget}
  {get ObjectInitialized lInitialized}
  {get QueryOpen lQueryOpen}
  .
  &UNDEFINE xp-assign
  
  IF NOT lInitialized OR pcMode = 'SAME':U THEN 
    RETURN.

  /* Support browser publish of whatever.. */  
  IF CAN-DO(cTarget,STRING(SOURCE-PROCEDURE)) THEN
    pcMode = 'VALUE-CHANGED':U.

  IF pcMode <> 'VALUE-CHANGED':U THEN
  DO:
    ASSIGN
      lOpen  = true 
      lReset = pcMode <> ? and lookup(pcMode,'RESET,RESORT':U) > 0.
 
    {get DataSource hDataSource}.
    IF VALID-HANDLE(hDataSource)  THEN
    DO: 
      {get QueryPosition cParentPos hDataSource}.
      lOpen = not (cParentPos begins "NoRecordAvailable":U).
      IF lOpen THEN
      DO:
        /* if parent is in newmode set close flag */ 
        {get NewMode lClose hDataSource}.
        IF NOT lClose THEN
        DO:          
          IF lReset THEN
          DO:
            IF {fn hasForeignKeyChanged} THEN
              ASSIGN 
                lReset = FALSE
                pcMode = 'DIFFERENT':U.
          END.
          IF NOT lReset OR NOT lQueryOpen THEN 
            {fn addForeignKey}.
        END.
      END. /* if lOpen (parent avail) */
      /* set close flag if parent is new or not avail */
      ELSE do:
        lClose = lQueryOpen.
        {fn removeForeignKey}.
      end.  
    END. /* valid datasource */
  END. /* mode <> 'value-changed' */  

  /* This OpenOnInit flag is set to true unconditionally in opendataView, 
     so we can safely check this here.  
     This ensures that a child with openoninit false not is opened when 
     the parent navigates */
  IF lOpen THEN 
  DO:
    {get OpenOnInit lOpen}.
    /* we are on our own from now on and must retrieve data on next request */
    IF NOT lOpen THEN
      {set DataIsFetched NO}.     
  END.

  IF lClose THEN
    {fn closequery}.

  ELSE IF lOpen THEN
  DO:
    &SCOPED-DEFINE xp-assign
    {get DataIsFetched lDataIsFetched}   
    {get ObjectInitialized lInitialized}
    {get DatasetSource hDatasetSource}
    {get DataTable cDataTable}
    . 
    &UNDEFINE xp-assign  
    
    if valid-handle(hDatasetSource) 
    and lDataIsFetched = false 
    and lReset = false then
    do:
      if valid-handle(hDataSource) then
        /* don't open if this query has been fetched with the parent */ 
        lOpen = NOT {fn isFetchedByParent}.
    end.
    else 
      lOpen = not valid-handle(hDatasetSource).
    
    IF lOpen THEN
      {fn openQuery}.                                                 
    ELSE IF NOT lReset OR NOT lQueryOpen THEN
      {fn openDataView}.
    ELSE DO: 
      IF pcMode = 'RESORT':U THEN
      DO:
        {get RowObject hRowObject}.
        {fnarg openDataQuery STRING(hRowObject:ROWID)}.
      END.      
      RUN rowChanged IN TARGET-PROCEDURE(pcMode).
    END.
  END.
  ELSE 
    RUN rowChanged IN TARGET-PROCEDURE('DIFFERENT':U).
 
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
DEFINE INPUT PARAMETER pcFieldList    AS CHARACTER                    NO-UNDO.
DEFINE OUTPUT PARAMETER TABLE-HANDLE hTTSchema.

DEFINE VARIABLE iCol                    AS INTEGER    NO-UNDO.
DEFINE VARIABLE hColumn                 AS HANDLE     NO-UNDO.
DEFINE VARIABLE cUpdatableColumnList    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cDataColumns            AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cColumnRef              AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cColumnName             AS CHARACTER  NO-UNDO.

DEFINE VARIABLE iColumn                 AS INTEGER    NO-UNDO.
DEFINE VARIABLE iColumnSequence         AS INTEGER    NO-UNDO.
DEFINE VARIABLE iIndexSequence          AS INTEGER    NO-UNDO.
DEFINE VARIABLE iIdxFldSeq              AS INTEGER    NO-UNDO.
DEFINE VARIABLE cBusinessEntity         AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cWordIndexedFields      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cIndexInformation       AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cThisIndex              AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cLogicalSDOName         AS CHARACTER  NO-UNDO.
DEFINE VARIABLE hContainer              AS HANDLE     NO-UNDO.
DEFINE VARIABLE hEntityBuffer           AS HANDLE     NO-UNDO.
DEFINE VARIABLE hTranslatedBuffer       AS HANDLE     NO-UNDO.
DEFINE VARIABLE lTranslateColumnLabel   AS LOGICAL    NO-UNDO.
DEFINE VARIABLE cDataTable              AS CHARACTER  NO-UNDO.

    EMPTY TEMP-TABLE ttSchema.
    hTtSchema = TEMP-TABLE ttSchema:HANDLE.

    &SCOPED-DEFINE xp-assign
    {get DataTable cDataTable}
    {get LogicalObjectName cLogicalSDOName}
    {get UpdatableColumns cUpdatableColumnList}
    {get BusinessEntity cBusinessEntity}
    {get WordIndexedFields cWordIndexedFields}
    {get IndexInformation cIndexInformation}
    .
    &UNDEFINE xp-assign

    lTranslateColumnLabel = VALID-HANDLE(gshRepositoryManager).
    
    IF cLogicalSDOName EQ "":U OR cLogicalSDOName EQ ? THEN
        ASSIGN cLogicalSDOName = TARGET-PROCEDURE:FILE-NAME.

    DO iCol = 1 TO NUM-ENTRIES(pcFieldList):
       cColumnRef = ENTRY(iCol,pcFieldList).
       /* Currently only returns datatable columns */ 
       IF INDEX(cColumnRef,'.':U) > 0 
       AND NOT cColumnRef BEGINS cDataTable + '.' THEN
         NEXT.
       hColumn = {fnarg columnHandle cColumnRef}.
       /* If the buffer-field is not in the list of fields we want, */
       CREATE ttSchema.
       ASSIGN
          ttSchema.sdo_name               = cLogicalSDOName
          ttSchema.column_sequence        = iCol
          ttSchema.column_case_sensitive  = hColumn:CASE-SENSITIVE
          ttSchema.column_dataType        = hColumn:DATA-TYPE
          ttSchema.column_format          = hColumn:FORMAT
          ttSchema.column_label           = hColumn:COLUMN-LABEL           
          ttSchema.column_mandatory       = hColumn:MANDATORY
          ttSchema.column_name            = cColumnRef
          ttSchema.column_width_chars     = hColumn:WIDTH-CHARS
          ttSchema.column_updatable       = (LOOKUP(hColumn:NAME, cUpdatableColumnList) > 0)
          ttSchema.adm_column             = NO 
          /* initially assign all fields as calculated, except rowobject, then, when assigning the table name, assign calculated_field = NO  */
/*           ttSchema.calculated_field       = IF ttSchema.adm_column THEN NO ELSE YES  */
          /* Set calculated field flag based on field name being in calculatedColumns psuedo-property */
          ttSchema.calculated_field       = NO 
          ttSchema.word_index             = (LOOKUP(hColumn:NAME, cWordIndexedFields) > 0)
          ttSchema.COLUMN_indexed         = ttSchema.word_index
          ttSchema.sdo_order              = 1
          ttSchema.sdo_handle             = TARGET-PROCEDURE
          ttSchema.DATABASE_name          = cBusinessEntity
          ttSchema.TABLE_name             = hColumn:TABLE
          ttSchema.FIELD_name             = ttSchema.column_name
          .
    END.
    
    ASSIGN iIndexSequence  = 1
           iColumnSequence = 0.

    IF lTranslateColumnLabel THEN
    DO:
      hEntityBuffer = DYNAMIC-FUNCTION("getCacheEntityObject":U IN gshRepositoryManager, 
                                       cDataTable).
      IF VALID-HANDLE(hEntityBuffer) AND hEntityBuffer:AVAILABLE THEN
        ASSIGN hColumn = hEntityBuffer:BUFFER-FIELD("EntityBufferHandle":U)
               hTranslatedBuffer = IF VALID-HANDLE(hColumn) THEN WIDGET-HANDLE(hColumn:BUFFER-VALUE) ELSE ?.
      ELSE
        hTranslatedBuffer = ?.
      DO iCol = 1 TO NUM-ENTRIES(pcFieldList):
        cColumnRef = ENTRY(iCol,pcFieldList).
        FIND FIRST ttSchema WHERE ttSchema.column_name = cColumnRef NO-ERROR.
        IF AVAILABLE ttSchema THEN
        DO:
          /* Translate ttSchema.column_label */
          IF lTranslateColumnLabel AND VALID-HANDLE(hTranslatedBuffer) THEN
          DO:
            IF INDEX(cColumnRef,'.':U) > 0 THEN
              cColumnName = ENTRY(2,cColumnRef,'.':U).
            ELSE 
              cColumnName = cColumnRef.
            hColumn = hTranslatedBuffer:BUFFER-FIELD(cColumnName).                    
            IF VALID-HANDLE(hColumn) THEN
               ttSchema.column_label = hColumn:COLUMN-LABEL. /* Assign column_label from entity cache */
          END.
        END.
      END.
    END.
    IF cIndexinformation NE '' THEN
    DO iCol = 1 TO NUM-ENTRIES(cIndexinformation,CHR(1)):
        ASSIGN 
          cThisIndex = ENTRY(iCol,cIndexinformation,CHR(1))
          iIdxFldSeq = 0
          .            
        DO iColumn = 5 TO NUM-ENTRIES(cThisIndex):
            FIND FIRST ttSchema WHERE ttSchema.column_name = ENTRY(iColumn, cThisIndex) NO-ERROR.
            IF AVAILABLE ttSchema THEN
                ASSIGN iIdxFldSeq = iIdxFldSeq + 1
                       ttSchema.COLUMN_indexed = YES
                       ttSchema.INDEX_position = ttSchema.INDEX_position
                                               + (IF ttSchema.INDEX_position = '' THEN '' ELSE ',')
                                               + STRING(iIndexSequence) + '.' + STRING(iIdxFldSeq).
        END.
        iIndexSequence = iIndexSequence + 1.
    END.
   /* Lastly, mark all with no index as "None" */
    FOR EACH ttSchema WHERE INDEX_position = "":U:
      ttSchema.INDEX_position = "None":U.        
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
  Notes:       
------------------------------------------------------------------------------*/
 {fn destroyView}.
 
 RUN SUPER.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fetchBatch) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE fetchBatch Procedure 
PROCEDURE fetchBatch :
/*------------------------------------------------------------------------------
  Purpose:     To transfer another "batch" of rows from the data provider to 
               the Temp-Table query, without changing the current 
               record position.
  Parameters:
    INPUT plForwards - TRUE if we should retrieve a batch of rows after the current rows,
                       FALSE if before.
  Notes:       Run from a Browser to get another batch of rows from the database
               query appended to the RowObject temp-table query (when the 
               browser scrolls to the end).
               fetchBatch does some checking and sets up the proper parameters
               to sendRows, but sendRows is called to do the actual work.  
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER plForwards AS LOGICAL NO-UNDO.
 
  DEFINE VARIABLE hDataQuery AS HANDLE     NO-UNDO.
 
  DYNAMIC-FUNCTION('retrieveBatch':U IN TARGET-PROCEDURE,
                    IF plForwards THEN 'NEXT':U ELSE 'PREV':U,?).

  /* retrievebatch currently does a get-next or get-prev, which is not noticed
     by the browse, so we synch the browse here. 
    (See comment in retrievBatch explaining alternative approach that could 
     move reposition to retrieveBatch */  
  {get DataHandle hDataQuery}.
  /* this is a synch-browse statement.. moves cursor back 1 position, so
     the browser's implicit record-avail gets correct record. */
  hDataQuery:REPOSITION-BACKWARDS(1).

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
  DEFINE VARIABLE hDataQuery    AS HANDLE    NO-UNDO.
  DEFINE VARIABLE iRowNum       AS INTEGER   NO-UNDO.
  DEFINE VARIABLE lRebuild      AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE cRowState     AS CHARACTER NO-UNDO.
  DEFINE VARIABLE lCancel       AS LOGICAL    NO-UNDO.
 
  &SCOPED-DEFINE xp-assign
  {get DataHandle hDataQuery}
  {get FirstRowNum iRowNum}
  .
  &UNDEFINE xp-assign
  
  IF iRowNum = ? THEN       /* First row hasn't been retrieved yet. */      
  DO:
    {get RowObjectState cRowState}.
    IF cRowState = 'RowUpdated':U THEN 
      RUN confirmContinue IN TARGET-PROCEDURE (INPUT-OUTPUT lCancel).
    IF NOT lCancel THEN
      DYNAMIC-FUNCTION('retrieveBatch':U IN TARGET-PROCEDURE,'FIRST':U,?).
  END.   /* END IF iRowNum = ? */
  ELSE 
    hDataQuery:GET-FIRST().
 
  /* Update queryposition and publish dataAvailable whether there's a record 
     or not; if not, the recipients will close queries or clear frames. */
  RUN rowChanged IN TARGET-PROCEDURE ("FIRST":U).     
    
  RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fetchLast) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE fetchLast Procedure 
PROCEDURE fetchLast :
/*------------------------------------------------------------------------------
  Purpose:     To reposition the temp-table query to the last row of the dataset.
               If the last row has not yet been retrieved, then fetchLast gets 
               the last batch of records and repositions the temp-table query 
               to the last row.
  Parameters:  <none>
  Notes:       IF RebuildOnReposition is false and the last row has not been 
               fetch yet, fetchLast will ask for the rest of the data and 
               append it to the current data. 
               If RebuildOnReposition is true and the last row from the db query
               has not been fetch yet, all temp-table records are discarded and
               just the last batch is fetched.  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hDataQuery    AS HANDLE  NO-UNDO.
  DEFINE VARIABLE iLastRow      AS INTEGER NO-UNDO.
  DEFINE VARIABLE lReposAvail   AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE cRowState     AS CHARACTER NO-UNDO.
  DEFINE VARIABLE lOk           AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lCancel       AS LOGICAL    NO-UNDO.
    
  &SCOPED-DEFINE xp-assign
  {get DataHandle hDataQuery}
  {get LastRowNum iLastRow}
  .
  &UNDEFINE xp-assign
  
  IF iLastRow = ? THEN        /* Last row not been retrieved yet.*/
  DO:
    {get RowObjectState cRowState}.
    IF cRowState = 'RowUpdated':U THEN 
      RUN confirmContinue IN TARGET-PROCEDURE (INPUT-OUTPUT lCancel).

    IF lCancel THEN
      RETURN.
    
    RUN changeCursor IN TARGET-PROCEDURE('WAIT':U).   
    PUBLISH 'fetchDataSet':U FROM TARGET-PROCEDURE ('LastStart':U).
    lOk = DYNAMIC-FUNCTION('retrieveBatch':U IN TARGET-PROCEDURE,'LAST':U,?).
    PUBLISH 'fetchDataSet':U FROM TARGET-PROCEDURE ('LastEnd':U).  
    RUN changeCursor IN TARGET-PROCEDURE('':U).
    IF NOT lok THEN
      RETURN.
  END.
  ELSE
    hDataQuery:GET-LAST(). 

  /* Signal row change in any case. */
  RUN rowChanged IN TARGET-PROCEDURE("LAST":U).      
  
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
  DEFINE VARIABLE hDataQuery   AS HANDLE  NO-UNDO. 
  DEFINE VARIABLE hRowObject   AS HANDLE  NO-UNDO.
  DEFINE VARIABLE iRow         AS INTEGER NO-UNDO.
  DEFINE VARIABLE cQueryPos    AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cRowState    AS CHARACTER NO-UNDO.
  DEFINE VARIABLE lFirstDeleted AS LOGICAL  NO-UNDO.
  DEFINE VARIABLE lOk           AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lCancel       AS LOGICAL    NO-UNDO.

    {get DataHandle hDataQuery}.
    IF NOT hDataQuery:IS-OPEN THEN 
      RETURN.
      
    hRowObject = hDataQuery:GET-BUFFER-HANDLE(1).

    IF hRowObject:AVAILABLE THEN   /* Make sure we're positioned to some row. */
    DO:
      {get LastRowNum iRow}.
      /* Already on the last row. */
      IF iRow = INT(hRowObject:RECID) THEN 
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
    DO:    
      {get RowObjectState cRowState}.
      IF cRowState = 'RowUpdated':U THEN 
        RUN confirmContinue IN TARGET-PROCEDURE (INPUT-OUTPUT lCancel).
      IF NOT lCancel THEN
      DO:
        /* No data so ask the Query. */
        PUBLISH 'fetchDataSet':U FROM TARGET-PROCEDURE ('NextStart':U).
        lOk = DYNAMIC-FUNCTION('retrieveBatch':U IN TARGET-PROCEDURE,'NEXT',?).  
        PUBLISH 'fetchDataSet':U FROM TARGET-PROCEDURE ('NextEnd':U).
      END.
      IF NOT lok THEN
      DO:
        /* pretend nothing happened */
        hDataQuery:GET-PREV().
        RETURN.
      END.
    END.       /* END DO IF no next record AVAILABLE  */
    
    IF lFirstDeleted AND hRowObject:AVAILABLE THEN  
    DO:
      iRow = INT(hRowObject:RECID).
      {set FirstRowNum iRow}.
    END.

    RUN rowChanged IN TARGET-PROCEDURE("NEXT":U). 

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
  DEFINE VARIABLE hDataQuery   AS HANDLE  NO-UNDO.
  DEFINE VARIABLE hRowObject   AS HANDLE  NO-UNDO.
  DEFINE VARIABLE iRow         AS INTEGER NO-UNDO.
  DEFINE VARIABLE lAutoCommit  AS LOGICAL  NO-UNDO.
  DEFINE VARIABLE lRebuild     AS LOGICAL  NO-UNDO.
  DEFINE VARIABLE cRowState    AS CHARACTER NO-UNDO.
  DEFINE VARIABLE lCancel      AS LOG    NO-UNDO.
  DEFINE VARIABLE lOk          AS LOGICAL    NO-UNDO.

    {get DataHandle hDataQuery}.

    IF NOT hDataQuery:IS-OPEN        
      THEN RETURN.
      
    ASSIGN hRowObject = hDataQuery:GET-BUFFER-HANDLE(1).
        
    IF hRowObject:AVAILABLE THEN   /* Make sure we're positioned to some row. */
    DO:
      {get FirstRowNum iRow}.
      IF iRow = INT(hRowObject:RECID) THEN 
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
        {get RowObjectState cRowState}.
        IF cRowState = 'RowUpdated':U THEN 
          RUN confirmContinue IN TARGET-PROCEDURE (INPUT-OUTPUT lCancel).
        IF NOT lCancel THEN
        DO:
          PUBLISH 'fetchDataSet':U FROM TARGET-PROCEDURE ('PrevStart':U).
          lOk = DYNAMIC-FUNCTION('retrieveBatch':U IN TARGET-PROCEDURE,'PREV':U,?).
          PUBLISH 'fetchDataSet':U FROM TARGET-PROCEDURE ('NextEnd':U).
        END.
      END. /* if lRebuild */

      /*  no more records */
      IF NOT lok THEN
      DO:
        hDataQuery:GET-FIRST().        
        RETURN. 
      END. /* IF ReturnRows = 0 */
    END. /* IF not hRowObject:available */    
    RUN rowChanged IN TARGET-PROCEDURE ("PREV":U). 
   
  RETURN.  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-initializeObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeObject Procedure 
PROCEDURE initializeObject :
/*------------------------------------------------------------------------------
  Purpose:     initialize the dataview (before the data request).
  Parameters:  <none>
  Notes:       Initialization of the dataview may happen before the actual 
               data definition, data retrieval and query opening.  
             - The definitions may arrive together with the data later. 
             - When the dataview is on a container data are retrieved as part
               of the container's initialization after all dataviews has been
               initialized. 
             - An override can manipulate query properties or other request 
               related information, but should not assume that any table or 
               field definitions are available. The startObject captures the 
               event of first time retieval of definitions as well as data, 
               unless OpenOnInit is false.
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hContainerSource      AS HANDLE     NO-UNDO.
  DEFINE VARIABLE lOpen                 AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE hSource               AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hCommitSource         AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cDataTable            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cTables               AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lInitialized          AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lContainerInitialized AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lHideOnInit           AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cFetchOnOpen          AS CHARACTER  NO-UNDO.

  &SCOPED-DEFINE xp-assign
  {get ObjectInitialized lInitialized}
  {get ContainerSource hContainerSource}
  {get DataTable cDataTable}
  {get Tables cTables}
  {get DataSource hSource}
  {get CommitSource hCommitSource}
  {get HideOnInit lHideOnInit}.
  .
  &UNDEFINE xp-assign
  /* sorry not again */
  IF lInitialized THEN
    RETURN.
  
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

  /* If this object has a Commit-Source (a Commit Panel or the like) then
     we set the AutoCommit flag off.  */
  IF VALID-HANDLE(hCommitSource) THEN
    {set AutoCommit NO}.

  /* The tools will set Tables and DataQueryString, but this ensures runtime 
     default of single table retrieval for runtime instances that only 
     defines BusinessEntity and DataTable.   
     (getViewTables, getQueryTables and getQueryStringDefault will reflect this)
     This may very well change in the future (implementation and/or behavior)*/
  IF cTables = '':U THEN
    {set Tables cDataTable}.

  IF VALID-HANDLE(gshProfileManager) THEN
    RUN retrieveFilter IN TARGET-PROCEDURE.
  
  IF VALID-HANDLE(hContainerSource) THEN
    {get ObjectInitialized lContainerInitialized hContainerSource}.
  
  IF NOT VALID-HANDLE(hContainerSource) 
  OR lContainerInitialized THEN
  DO:
    {get FetchOnOpen cFetchOnOpen}.
    DYNAMIC-FUNCTION('retrieveData':U IN TARGET-PROCEDURE,cFetchOnOpen,YES,?).
    RUN startObject IN TARGET-PROCEDURE. 
  END.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-linkStateHandler) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE linkStateHandler Procedure 
PROCEDURE linkStateHandler :
/*------------------------------------------------------------------------------
  Purpose: Override in order to make scrollable if browser is linked
  Parameters: see base version in smart.p
  Notes:                          
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pcState   AS CHARACTER  NO-UNDO.
  DEFINE INPUT PARAMETER phObject  AS HANDLE     NO-UNDO.
  DEFINE INPUT PARAMETER pcLink    AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE cObjectType     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hDatasetSource     AS HANDLE     NO-UNDO.
   
  IF pcState = 'remove':U AND pcLink = 'DataTarget':U  THEN 
  DO:
    {get ObjectType cObjectType phObject}.
    IF cObjectType = 'SmartDataBrowser':U THEN
    DO:
      {get DatasetSource hDatasetSource}.
      IF VALID-HANDLE(hDatasetSource) THEN
        {fn removeDatasetClone}.     
    END.
  END.

  IF pcState = 'add':U AND pcLink = 'DataTarget':U  THEN 
  DO:
    {get ObjectType cObjectType phObject}.
    IF cObjectType = 'SmartDataBrowser':U THEN
       IF {fn getScrollable} = FALSE THEN 
        {fn addDatasetClone}.     
  END.
 
  RUN SUPER(pcState,phObject,pcLink).
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-obtainExpressionEntries) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE obtainExpressionEntries Procedure 
PROCEDURE obtainExpressionEntries :
/*------------------------------------------------------------------------------
  Purpose:    Obtain one entry of column, operator and value to add to a query 
              for a specific buffer from comma separated lists of columns
              buffers and values    
  Parameters: pcBuffer          - Buffer name to check against 
                                  - 'RowObject' means SDO query which means that 
                                     all columns will be returned with the 
                                     rowObject name. (see NOTES below) 
              piColumn          - Entry to lookup in the lists
              pcColumnList      - Comma separated list of columns 
                                  (see assignQuerySelection )
              pcValueList       - CHR(1) separated list of values 
              pcOperatorList    - Comma separate list of operators 
                                  or single operator for all columns             
                                  The single operator can have an optional 
                                  string operator 'ge/BEGINS 
              output pcColumn   - Column name, resolved with correct 
                                  qualification. 
              output pcOperator - Operator. 
              output pcValue    - Value (with quotes) 
                                - or '?' as ?                         
  Notes:  The optional string operator is not supported before the object is 
          initialized. (datatype is not known)   
       -  Unqualified columns are assumed to be datatable references  
       -  'RowObject' qualified columns are assumed to be datatable references  
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcBuffer       AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER piColumn       AS INTEGER    NO-UNDO.
  DEFINE INPUT  PARAMETER pcColumnList   AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pcValueList    AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pcOperatorList AS CHARACTER  NO-UNDO.

  DEFINE OUTPUT PARAMETER pcColumn    AS CHARACTER  NO-UNDO.
  DEFINE OUTPUT PARAMETER pcOperator  AS CHARACTER  NO-UNDO.
  DEFINE OUTPUT PARAMETER pcValue     AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE cStringOperator AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cQuote          AS CHARACTER  NO-UNDO.

  pcColumn = {fnarg resolveColumn "ENTRY(piColumn,pcColumnList)"}.  
  
  IF pcColumn BEGINS pcBuffer + ".":U THEN 
    ASSIGN
      pcValue         = (IF pcValueList <> ? 
                         THEN ENTRY(piColumn,pcValueList,CHR(1))  
                         ELSE "?":U)
      /* Add ~ to single quotes, as we use single quote around the value) */
      pcValue         = (IF pcValue <> "":U 
                         THEN REPLACE(pcValue,"'":U,"~~~'":U)
                         ELSE " ":U)  
      /* Get the operator for this valuelist. 
         Support '',? and '/begins' as default */                                                  
      pcOperator      = IF NUM-ENTRIES(pcOperatorList) > 1 
                        THEN ENTRY(piColumn,pcOperatorList) 
                        ELSE IF pcOperatorList BEGINS "/":U 
                             OR pcOperatorList = ?                       
                             OR pcOperatorList = '':U
                             THEN "=":U 
                             ELSE ENTRY(1,pcOperatorList,"/":U)  
      /* Look for optional string operator if only one entry in operator */          
      cStringOperator = IF NUM-ENTRIES(pcOperatorList,"/":U) = 2  
                        THEN ENTRY(2,pcOperatorList,"/":U)                                                 
                        ELSE ' ':U 
      pcOperator      = IF cStringOperator = '':U 
                        THEN pcOperator
                        ELSE IF {fnarg columnDataType pcColumn} = 'CHARACTER':U
                             THEN cStringOperator
                             ELSE pcOperator
      /* We are quoting ALL values except ? to ensure that decimals behave in both 
         american and european format and to avoid having to check the datatype
         unless absolutely necessary (only if stringoperator is defined).  
         Unknown values must not be quoted for characters, we do not support '?' 
         unquoted works for all types (Matches and begins does not compile
         with ? so they are quoted) */ 

      cQuote          = (IF pcValue = "?":U 
                         AND pcOperator <> 'BEGINS':U 
                         AND pcOperator <> 'MATCHES':U 
                         THEN "":U 
                         ELSE "'":U)   
     
      /* From 9.1B the quotes are included in the value to avoid problems
         when replacing unquoted ? to a quoted value */     
      pcValue         = cQuote + pcValue + cQuote
      .
  ELSE
    pcColumn = ''. 

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-processMessages) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE processMessages Procedure 
PROCEDURE processMessages :
/*------------------------------------------------------------------------------
    Purpose: Process messages looks for an updateTarget to show the 
             current messages and empty the error stack. 
             If no update target present the messages are currently just 
             messaged directly from here.  
    Notes: 
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cUpdateSource AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hUpdateSource AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cDummy        AS CHARACTER  NO-UNDO.   
  DEFINE VARIABLE cMessages     AS CHARACTER  NO-UNDO.
   
  {get UpdateSource cUpdateSource}. 
  hUpdateSource = WIDGET-HANDLE(ENTRY(1,cUpdateSource)).
  IF VALID-HANDLE (hUpdateSource) THEN      
    RUN showDataMessagesProcedure IN hUpdateSource (OUTPUT cDummy).
  
  ELSE DO:
    ASSIGN 
      cMessages = {fn fetchMessages}
      cMessages = REPLACE(cMessages,chr(3),"~n~n")
      /* we do not expect table and fields to be in a message handled here
         in particular not if there is no updatetarget, but add 
         spaces just in case */
      cMessages = REPLACE(cMessages,chr(4)," ").  
    MESSAGE cMessages  
         VIEW-AS ALERT-BOX ERROR.  
  END.  
  RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-processSubmitException) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE processSubmitException Procedure 
PROCEDURE processSubmitException :
/*------------------------------------------------------------------------------
  Purpose: Process data/errors after a submit error    
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hDatasetSource  AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cDataTable      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hChgAfter       AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hChgBefore      AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hQuery          AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cMessage        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hRowObject      AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hBefore         AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hAfter          AS HANDLE     NO-UNDO.
  DEFINE VARIABLE lHaschange      AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lMerge          AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cChangedFields  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lAutoCommit     AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cUndoDelete     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hChildDSSource  AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hTarget         AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cTargets        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iTarget         AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cUndoOnConflict AS CHARACTER  NO-UNDO.
            
  &SCOPED-DEFINE xp-assign
  {get DatasetSource hDatasetSource}
  {get DataTable cDataTable}
  {get RowObject hRowObject}
  {get AutoCommit lAutoCommit}
  .
  &UNDEFINE xp-assign
  
  CREATE BUFFER hAfter FOR TABLE hRowObject. 

  hChgAfter = {fnarg tableExceptionBuffer cDataTable hDatasetSource}.
  IF VALID-HANDLE(hChgAfter) THEN
  DO:
    hBefore    = hRowObject:BEFORE-BUFFER NO-ERROR. 
    CREATE QUERY hQuery.
    IF VALID-HANDLE(hBefore) THEN
    DO:
      hChgBefore = hChgAfter:BEFORE-BUFFER.

      hQuery:SET-BUFFERS(hChgBefore).
      hQuery:QUERY-PREPARE('FOR EACH ':U + hChgBefore:NAME ).
      hQuery:QUERY-OPEN().
      hQuery:GET-FIRST.

      DO WHILE hChgBefore:AVAIL:
        
        IF hChgBefore:DATA-SOURCE-MODIFIED THEN
        DO:
          hBefore:FIND-BY-ROWID(hChgBefore:ORIGIN-ROWID).
          
          hAfter:FIND-BY-ROWID(hBefore:AFTER-ROWID).
          hChgAfter:FIND-BY-ROWID(hChgBefore:AFTER-ROWID).
          cChangedFields = DYNAMIC-FUNCTION("compareTableValues":U IN TARGET-PROCEDURE,
                                            hAfter,
                                            hChgAfter).
          {get UndoOnConflict cUndoOnConflict}.
          
          /* autocommit always rejects/accepts changes, and keeps 
             screen changes, so 'before' is treated as 'all' */  
          IF cUndoOnConflict = 'BEFORE':U AND lAutoCommit THEN
            cUndoOnConflict = 'ALL':U.

          CASE cUndoOnConflict:
            WHEN 'NONE':U THEN
              IF lAutoCommit THEN
              DO TRANSACTION: /* avoid row-updated trigger when out of scope later */
                hBefore:REJECT-ROW-CHANGES().
              END.
            WHEN 'ALL':U THEN
            DO TRANSACTION: /* avoid row-updated trigger when out of scope later */
              hBefore:REJECT-ROW-CHANGES().
              hAfter:TABLE-HANDLE:TRACKING-CHANGES = FALSE. 
              hAfter:BUFFER-COPY(hChgAfter).
              hAfter:TABLE-HANDLE:TRACKING-CHANGES = TRUE. 
            END.

            WHEN 'MERGE':U THEN 
            DO TRANSACTION: /* avoid row-updated trigger when out of scope later */
              hChgAfter:BUFFER-COPY(hAfter,cChangedFields). 
              hBefore:REJECT-ROW-CHANGES().
              hAfter:TABLE-HANDLE:TRACKING-CHANGES = FALSE. 
              hAfter:BUFFER-COPY(hChgAfter).
              hAfter:TABLE-HANDLE:TRACKING-CHANGES = TRUE. 
            END.
            
            WHEN 'BEFORE':U THEN 
            DO TRANSACTION: /* avoid row-updated trigger when out of scope later */
              hChgAfter:TABLE-HANDLE:TRACKING-CHANGES = TRUE. 
              hChgAfter:BUFFER-COPY(hAfter).                
              hChgAfter:TABLE-HANDLE:TRACKING-CHANGES = FALSE. 
              hBefore:REJECT-ROW-CHANGES().
              hAfter:TABLE-HANDLE:TRACKING-CHANGES = FALSE. 
              hAfter:BUFFER-COPY(hChgBefore).
              hAfter:TABLE-HANDLE:TRACKING-CHANGES = TRUE.               
              hAfter:BUFFER-COPY(hChgAfter).
            END.

          END CASE.
          cMessage = SUBSTITUTE({fnarg messageNumber 8},cChangedFields).
          RUN addMessage IN TARGET-PROCEDURE(cMessage,?,cDataTable).
        END.
        else do:  
          IF hChgBefore:ERROR OR hChgBefore:REJECTED THEN
          DO:
            /* if rejected the record typically does not have an error-string 
	             (at least one error is expected to have error-string) */
            IF hChgBefore:ERROR-STRING > '' THEN 
              RUN addMessage IN TARGET-PROCEDURE(hChgBefore:ERROR-STRING,
                                                 ?,
                                                 cDataTable).
            /* if not AutoCommit then undo the deletion if it caused an error 
               and keep the deletion if it is only rejected, since it is likely
                to be another error that caused the rejections */ 
            IF NOT lAutoCommit AND hChgBefore:ROW-STATE = ROW-DELETED THEN
            DO:
              {get UndoDeleteOnSubmitError cUndoDelete}.
              CASE cUndoDelete:
                WHEN 'ERROR':U THEN
                  lMerge = hChgBefore:ERROR.
                WHEN 'ALL':U THEN
                  lMerge = TRUE.
                otherwise 
                  lMerge = false.
              END.
            END.
            else if lAutoCommit and hChgBefore:row-state = row-created then
            do transaction:
              hRowObject:TABLE-HANDLE:TRACKING-CHANGES = FALSE.
              hBefore:BUFFER-RELEASE.
              hBefore:FIND-BY-ROWID(hChgBefore:ORIGIN-ROWID).
              hAfter:FIND-BY-ROWID(hBefore:AFTER-ROWID).
              hAfter:buffer-copy(hBefore).
              hRowObject:TABLE-HANDLE:TRACKING-CHANGES = TRUE.
            end.
            else 
              lMerge = lAutoCommit.
          END. /* error */
          ELSE 
            lMerge = TRUE.
  
          IF lMerge THEN
          DO TRANSACTION: /* avoid row-updated trigger when out of scope later */
            hRowObject:TABLE-HANDLE:TRACKING-CHANGES = FALSE.
            hBefore:BUFFER-RELEASE.
            hBefore:FIND-BY-ROWID(hChgBefore:ORIGIN-ROWID).
            hChgBefore:MERGE-ROW-CHANGES(hBefore).
            hRowObject:TABLE-HANDLE:TRACKING-CHANGES = TRUE.
          END.
        end. /* else ( not lock conflict ) */
        hQuery:GET-NEXT.  
      END.
    END. /* valid rowobject:before */
    
    hQuery:SET-BUFFERS(hChgAfter).
    hQuery:QUERY-PREPARE('FOR EACH ':U + hChgAfter:NAME ).
    hQuery:QUERY-OPEN().
    hQuery:GET-FIRST.

    DO WHILE hChgAfter:AVAIL:
      /* if no before buffer (read-only) or if no before record then 
         just refresh data (result of SubmitParent). 
         It is assumed that the service returns correct data also if there is 
         an error of submit of another table or record */
      IF NOT VALID-HANDLE(hChgBefore) OR hChgAfter:ROW-STATE = 0 THEN
      DO:
        hAfter:FIND-UNIQUE('WHERE ':U 
                           + DYNAMIC-FUNCTION('KeyWhere':U IN TARGET-PROCEDURE,
                             hChgAfter,hAfter:NAME)
                           ) NO-ERROR.
        IF hAfter:AVAIL THEN 
        DO TRANSACTION: /* avoid row-updated trigger when out of scope later */
          hRowObject:TABLE-HANDLE:TRACKING-CHANGES = FALSE.
          hAfter:BUFFER-COPY(hChgAfter).
          hRowObject:TABLE-HANDLE:TRACKING-CHANGES = TRUE.
        END.
      END.
      hQuery:GET-NEXT.
    END.
    DELETE OBJECT hQuery.
       /*
              ttError.IsError    = hChgBefore:ERROR 
              ttError.IsRejected = hChgBefore:REJECTED
              ttError.IsConflict = hChgBefore:DATA-SOURCE-MODIFIED
      */   
    
  END.
 
  {fnarg removeTableExceptionBuffer cDataTable hDatasetSource}.
  
  /* this will be ignored if not true.. */
  IF NOT lAutoCommit THEN
    RUN rowObjectstate IN TARGET-PROCEDURE('NoUpdates').

  {get DataTarget cTargets}.
  DO iTarget = 1 TO NUM-ENTRIES(cTargets):
    hTarget = WIDGET-HANDLE(ENTRY(iTarget,cTargets)).
    IF {fnarg instanceOf 'DataView':U hTarget} THEN
    DO:
      {get DatasetSource hChildDSSource hTarget}.
      IF hChildDSSource = hDatasetSource THEN
        RUN processSubmitException IN hTarget.
    END.
  END.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-refreshDataQuery) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE refreshDataQuery Procedure 
PROCEDURE refreshDataQuery :
/*------------------------------------------------------------------------------
  Purpose: Open the data query     
  Parameters:  
  Notes:   buildDataRequest subscribes this to the requestor's 
           "dataRequestComplete" event in case the normal post request flow 
           won't open/refresh this object. 
           (for example for a lookup not opened at initialization)               
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cPublisherType AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hDatasetSource AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cContext       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDataTable     AS CHARACTER  NO-UNDO.

  &SCOPED-DEFINE xp-assign
  {get DatasetSource hDatasetSource}
  {get DataTable cDataTable}
  .
  &UNDEFINE xp-assign

  cContext = {fnarg tableContext cDataTable hDatasetSource}.

  {fnarg applyContextFromServer cContext}.

  cPublisherType = {fn getObjectType SOURCE-PROCEDURE} NO-ERROR.
  IF cPublisherType <> 'SUPER':U THEN
    UNSUBSCRIBE PROCEDURE TARGET-PROCEDURE TO 'DataRequestComplete':U IN SOURCE-PROCEDURE. 
   
  {fnarg openDataQuery ''}.
   
  RETURN.

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
               Browser to display the latest values.
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
  DEFINE VARIABLE lOk             AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lMessage        AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lTracking       AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cKeyWhere       AS CHARACTER  NO-UNDO.

   /* Nothing to refresh ..  */
  &SCOPED-DEFINE xp-assign
  {get NewRow lNewRow}    
  {get DataHandle hDataQuery}
  {get RowObject  hRowObject}
  {get RowObjectState cRowState}
  {get KeyWhere cKeyWhere}
  .
  &UNDEFINE xp-assign
  
  IF cRowState = 'RowUpdated':U THEN
  DO: /* if updates are in progress, can not continue */
     DYNAMIC-FUNCTION("showMessage":U IN TARGET-PROCEDURE, "24":U).
     RUN showMessageProcedure IN TARGET-PROCEDURE 
                 ('24':U, OUTPUT lMessage).
     RETURN.
  END.  /* if cRowState = rowupdated */
  
  IF lNewRow THEN 
    RETURN.  
  IF NOT hRowObject:AVAILABLE THEN
    RETURN.


  ASSIGN
    lTracking = hRowObject:TABLE-HANDLE:TRACKING-CHANGES
    hRowObject:TABLE-HANDLE:TRACKING-CHANGES = FALSE.
  
  hRowObject:BUFFER-DELETE().      /* remove the old copy of the row. */
  
  /** find the prev rec as we want to position to it in case the refresh is
      gone (so why not next? at least in a browse this is less slick and
      makes it easier to see that weird stuff happened...maybe...? ) */ 
  hDataQuery:GET-PREV. 
  IF NOT hRowObject:AVAIL THEN
    hdataQuery:GET-FIRST.

  rRowid = hRowObject:ROWID.

  /* deactivate links to child objects  */
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
  /**/

  lOk = DYNAMIC-FUNCTION('retrieveBatch':U IN TARGET-PROCEDURE,cKeyWhere,1).

  IF lTracking THEN
    hRowObject:TABLE-HANDLE:TRACKING-CHANGES = TRUE.

  /* reactivate links that was deactivated before the request */
  DO iTarget = 1 TO NUM-ENTRIES(cDisabled):
    hTarget = WIDGET-HANDLE(ENTRY(iTarget,cDisabled)).
    IF VALID-HANDLE(hTarget) THEN
       RUN linkStateHandler IN hTarget ("active":U,
                                         TARGET-PROCEDURE,
                                         "DataSource":U).
  END. /* do iTarget = 1 to */
  
  /* If nothing to refresh resort to plan B */
  IF NOT lOk THEN
  DO:
    /* Get rid of the non existing row from the browse 
      (this is probably only necessary when no reposition has been done) */
    PUBLISH 'refreshBrowse':U FROM TARGET-PROCEDURE.
    lDeleted  = TRUE.
    IF rRowid <> ? THEN
      hdataQuery:REPOSITION-TO-ROWID(rRowid).
  END.

  /* Tell everyone we have a new copy of the same row. */
  RUN rowChanged IN TARGET-PROCEDURE(IF lDeleted THEN 'DIFFERENT':U ELSE 'SAME':U).

  RETURN.
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
DEFINE VARIABLE cRUnAttribute                   AS CHARACTER    NO-UNDO.
DEFINE VARIABLE cFieldNames                     AS CHARACTER    NO-UNDO.
DEFINE VARIABLE cFieldValues                    AS CHARACTER    NO-UNDO.
DEFINE VARIABLE cFieldOperators                 AS CHARACTER    NO-UNDO.
DEFINE VARIABLE lSuccess                        AS LOGICAL      NO-UNDO.
DEFINE VARIABLE cAssignQuerySelection           AS CHARACTER    NO-UNDO.
DEFINE VARIABLE iLoop                           AS INTEGER      NO-UNDO.
DEFINE VARIABLE cEntry                          AS CHARACTER    NO-UNDO.
DEFINE VARIABLE iRowsToBatch                    AS INTEGER      NO-UNDO.
DEFINE VARIABLE lRebuildOnRepos                 AS LOGICAL      NO-UNDO.
DEFINE VARIABLE iCnt                            AS INTEGER      NO-UNDO.
DEFINE VARIABLE cField                          AS CHARACTER    NO-UNDO.
DEFINE VARIABLE lFilterActive                   AS LOGICAL      NO-UNDO.
DEFINE VARIABLE cColumnSelection                AS CHARACTER  NO-UNDO.
    
    IF VALID-HANDLE(gshProfileManager) THEN
    DO: 
      {get ContainerSource hContainerSource}.
      IF VALID-HANDLE(hContainerSource) THEN
      DO:
        {get ObjectName cSdoName}. 
        {get LogicalObjectName cContainerName hContainerSource}.
        IF cContainerName EQ "":U OR cContainerName EQ ? THEN
            ASSIGN cContainerName = hContainerSource:FILE-NAME.
        
        ASSIGN   /* Keep signature similar to sbo/sdo */ 
          cSdoSignature = cSdoName + ",":U + '':U + ",":U + cContainerName + ",":U + cRunAttribute
          rRowid        = ?.
        
        RUN getProfileData IN gshProfileManager (
            INPUT "BrwFilters":U,
            INPUT "FilterSet":U,
            INPUT cSdoSignature,
            INPUT NO,
            INPUT-OUTPUT rRowid,
            OUTPUT cFilterSettings).
        
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

        /* Store the current (default) rowsToBatch and rebuildOnRepos settings in case *
         * used in filter when resetting default SDO values.         */
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
      END. /* Valid container */
    END.  /* valid profile manager */
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-rowChanged) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE rowChanged Procedure 
PROCEDURE rowChanged :
/*------------------------------------------------------------------------------
  Purpose: Event procedure called on any change or reposition.      
  Parameters:  pcMode - Event modifier to pass along to data-targets.                         
                       (This modifier is currently just passed on to 
                        dataAvailable and is somewhat irrelevant for this
                        event)
                        
  Notes:   This event encapsulates the events that all linked objects 
           (data-targets and navigation-sources) subscribes to in order to 
           reflect the current state of the object.
         - This diagram shows how these two event reaches all involved objects 
           including indirectly linked objects like a data-target's tableio-source 
           
           updateQueryPosition  
            -> QueryPosition 
                [datavis]    - enable/disable 
                             -> [tableio] - reset 
                [navigation] - reset
           -> DataAvailable  
                [datavis]    - display 
                               - setDataValue[field] - findRowWhere
                                                       - rowChanged  
                [dataview]   - add foreign key 
                             - open* - fetch* 
                                       - rowChanged       
                                        
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcMode AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cValue          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hBuffer         AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hDatasetSource  AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cRelationfields AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iField          AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cChildField     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cParentField    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cParentValue    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cChildValue     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cWhere          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lPos            AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE hQuery          AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hQueryBuffer    AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hRowObject      AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cViewTables     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cQueryTables    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iTable          AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cTable          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cBufferHandles  AS character   NO-UNDO.
  
  /* Set QueryPosition from FirstRowNum, LastRowNum  */
  RUN updateQueryPosition IN TARGET-PROCEDURE.
  
  &SCOPED-DEFINE xp-assign
  {get DataHandle hQuery}
  {get QueryTables cQueryTables}
  {get ViewTables cViewTables}
  {get RowObject hRowObject}
  {get BufferHandles cBufferHandles}
  {get DatasetSource hDatasetSource}
   .
  &UNDEFINE xp-assign
  
  /* position view tables not in the query */
  IF VALID-HANDLE(hDatasetSource) THEN 
  DO iTable = 2 TO NUM-ENTRIES(cViewTables):
    cTable = ENTRY(iTable,cViewTables).
    IF LOOKUP(cTable,cQueryTables) = 0 THEN
    DO:
      hBuffer = widget-handle(entry(iTable,cBufferHandles)).
      IF hRowObject:AVAILABLE THEN
      DO:
        cRelationFields = DYNAMIC-FUNCTION("relationFields":U IN hDatasetSource,
                                            hRowObject:NAME,
                                            cTable).

        ASSIGN 
          lPos   = TRUE  /* assume correct position */
          cWhere = '':U.
        DO iField = 1 TO NUM-ENTRIES(cRelationFields) BY 2:
          ASSIGN
            cParentField = ENTRY(1,cRelationFields)
            cChildField  = ENTRY(2,cRelationFields)
            cParentValue = QUOTER(hRowObject:BUFFER-FIELD(ENTRY(2,cParentField,'.':U)):BUFFER-VALUE)
            cChildValue  = IF hBuffer:AVAIL 
                           THEN QUOTER(hBuffer:BUFFER-FIELD(ENTRY(2,cChildField,'.':U)):BUFFER-VALUE)
                           ELSE '?':U
            cWhere       = cWhere 
                         + (IF ifield = 1 THEN 'WHERE ':U ELSE ' AND ':U)
                         + cChildField + ' = ':U + cParentValue 
            lPos         = IF lPos THEN (cChildValue = cParentValue) ELSE FALSE.
        END.
        IF NOT lPos THEN
          hBuffer:FIND-UNIQUE(cWhere) NO-ERROR.
      END. /* rowobject avail */
      ELSE 
        hBuffer:BUFFER-RELEASE().
    END.  /* table not in query */
  END. /* do itable = 2 to num-entires viewtables */
  
  PUBLISH 'dataAvailable':U FROM TARGET-PROCEDURE (pcMode).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-rowObjectState) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE rowObjectState Procedure 
PROCEDURE rowObjectState :
/*------------------------------------------------------------------------------
  Purpose:    To pass on the flag which indicates when a SmartDataObject row 
              has been changed locally but not committed. This gets passed on 
              until it reaches the Commit Panel or other first Commit-Source. 
  Parameters:
    INPUT pcState - the new state
  
  Notes:    - The event is ignored for autocommit objects  
            - As of current we check the publisher and ignore the state 
              if it is from a separate entity instance. 
             (The event is published up the data-source chain so we may
              get this event from children on different enitities)
            - On the other hand, if the publisher is not an SDO we currently 
              accept the event.. (assuming this must be someone knowing 
              what their doing...as this would not be default).       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pcState AS CHARACTER NO-UNDO.
  
  DEFINE VARIABLE lAutoCommit        AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cPublisherType     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hDatasetSource     AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hPublisherDSSource AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cState             AS CHARACTER  NO-UNDO.

  &SCOPED-DEFINE xp-assign
  {get DatasetSource hDatasetSource}
  {get AutoCommit lAutoCommit}
  .
  &UNDEFINE xp-assign
  IF NOT lAutoCommit AND VALID-HANDLE(hDatasetSource) THEN
  DO:
    IF pcState = 'NoUpdates':U THEN 
    DO:
      {get RowObjectState cState}.
      IF cState <> pcState THEN
        RETURN.
    END.
    {get ObjectType cPublisherType SOURCE-PROCEDURE} NO-ERROR.
    IF cPublisherType = 'SmartDataObject':U THEN 
    DO:
      /* Actively ignore if from a separate entity */
      {get DatasetSource hPublisherDSSource SOURCE-PROCEDURE}.
      IF hPublisherDSSource <> hDataSetSource THEN
        RETURN.
    END. /* cPublisherType = 'SmartDataObject':U */
    {set RowObjectState pcState}.  
  END. 

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-startObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE startObject Procedure 
PROCEDURE startObject :
/*------------------------------------------------------------------------------
  Purpose: Start the object after data and/or definitions have been retrieved.
  Parameters:  <none>
  Notes:   This event completes the initialization of the object.  
         - Sets ObjectInitialized to true to reflect that definitions are 
           present and all handle properties are defined and that the object is 
           ready for action.  
         - It can be overridden to deal with logic that require that the
           definitions and handles are present (after SUPER). 
         - The dataview's initializeObject is a pre-request event that does not 
           retrieve data or definitions when the dataview instance is managed by
           a container and should only be overidden to manipulate query 
           properties or other request related information.
         - It will be called as part of object initialization either by the 
           container or by the object itself and should not be called by 
           application code. 
         - Framework code must ensure that initializeObject is being run and
           that the dataset (data is optional) are available in the 
           datacontainer before calling this.       
         - This may be called on receival of an asynchronous data request.  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hDataSource        AS HANDLE     NO-UNDO.
  DEFINE VARIABLE lParentInitialized AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lScrollable        AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lOpen              AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lOpened            AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cPublisherType     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cParent            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hDatasetSource     AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cDataTable         AS CHARACTER  NO-UNDO.

  &SCOPED-DEFINE xp-assign
  {get DataSource hDataSource}
  {get OpenOnInit lOpen}
   /* This completes the initialization, so set the flag accordingly */
  {set ObjectInitialized TRUE}
  .
  &UNDEFINE xp-assign
  
  cPublisherType = {fn getObjectType SOURCE-PROCEDURE} NO-ERROR.
  IF cPublisherType <> 'SUPER':U THEN
    UNSUBSCRIBE PROCEDURE TARGET-PROCEDURE TO 'DataRequestComplete':U IN SOURCE-PROCEDURE. 

  RUN createObjects IN TARGET-PROCEDURE.

  IF lOpen THEN 
  DO:
    IF VALID-HANDLE(hDataSource) THEN
    DO:
      &scoped-define xp-assign  
      {get ObjectInitialized lParentInitialized hDataSource}
      {get DataTable cParent hDataSource}.
      &undefine xp-assign
      
      &scoped-define xp-assign  
      {get DatasetSource hDatasetSource}
      {get DataTable cDataTable}.   
      &undefine xp-assign
      
      IF VALID-HANDLE(hDatasetSource) THEN
        DYNAMIC-FUNCTION('activateRelation':U IN hDatasetSource,
                         cParent,cDataTable).   
      /* If parent is not initted then just wait for its publish dataAvailable */
      
      IF lParentInitialized THEN
        RUN dataAvailable IN TARGET-PROCEDURE ('reset':U).
    END.
    ELSE DO: 
      {get Scrollable lScrollable}.
      /* Only open query for scrollable objects 
        (findRowwhere handles positioning for non-scrollable) */
      IF lScrollable THEN
        {fn openDataView}.
    END.
  END. /* openononit */

  /*
  ELSE 
    RUN rowChanged IN TARGET-PROCEDURE('RESET':U).
  */


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
  DEFINE VARIABLE rRowObject     AS ROWID   NO-UNDO.
  DEFINE VARIABLE hDataQuery     AS HANDLE  NO-UNDO.
  DEFINE VARIABLE hRowObject     AS HANDLE  NO-UNDO.
  DEFINE VARIABLE hCommitSource  AS HANDLE  NO-UNDO. 
  DEFINE VARIABLE hDatasetSource AS HANDLE  NO-UNDO.
  DEFINE VARIABLE lCancel        AS LOGICAL NO-UNDO.
  DEFINE VARIABLE cDataTable     AS CHARACTER  NO-UNDO.
  
  &SCOPED-DEFINE xp-assign
  {get CommitSource hCommitSource}
  {get DatasetSource hDatasetSource}
  {get DataTable cDataTable}.
  &UNDEFINE xp-assign
  
  IF VALID-HANDLE(hDatasetSource) THEN
  DO:
    /* If record changes haven't been saved, confirm that it is ok to Cancel 
       these also. 
       Make this check if it came from the Commit Panel, but skip if it 
       came locally or from an SBO. */
    IF SOURCE-PROCEDURE = hCommitSource THEN
    DO:
       /* Visual dataTargets subscribes to this */
      PUBLISH 'confirmUndo':U FROM TARGET-PROCEDURE (INPUT-OUTPUT lCancel).
      IF lCancel THEN RETURN 'ADM-ERROR':U.
    END.    /* END IF hSource  */
    
    {get DataHandle hDataQuery}.
    hRowObject = hDataQuery:GET-BUFFER-HANDLE(1).

    /* The rowid of new records may get reused if there are deleted records */
    IF hRowobject:ROW-STATE <> ROW-CREATED  THEN
      rRowObject = hRowObject:ROWID.
    
    RUN undoTransaction IN hDatasetSource (cDataTable).

    /* Now reopen the RowObject query, in order to refresh any dependent 
       SmartDataBrowser, reposition to the previously current row, and do
       dataAvailable to refresh that row in SmartDataViewers and other objects. */
    {fnarg openDataQuery STRING(rRowObject)}.
    /* The record we had may have been new and uncommitted.. and thus been 
       deleted as part of the undo, behave as normal delete and find next 
       or last if no recs after  */
    IF NOT hRowObject:AVAILABLE THEN
      hDataQuery:GET-FIRST().   /* next if needed (for Viewer, not Browser target)*/
    
    IF NOT hRowObject:AVAILABLE THEN
      hDataQuery:GET-LAST().   /* next if needed (for Viewer, not Browser target)*/

    {set RowObjectState 'NoUpdates':U}.
    {fn reopenQuery}.
  END.

  RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-activateHiddenFetchChildren) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION activateHiddenFetchChildren Procedure 
FUNCTION activateHiddenFetchChildren RETURNS CHARACTER PRIVATE
  (   ) :
/*------------------------------------------------------------------------------
  Purpose: Return all dependant childrent that are deactivated, but 
           that we are responsible to retrieve data for.     
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hTarget        AS HANDLE     NO-UNDO.
  DEFINE VARIABLE iTarget        AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cTarget        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDataTargets   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cChildren      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cGrandChildren AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lQuery         AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lIsFetched     AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lOpenOnInit    AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cInactiveLinks AS CHARACTER  NO-UNDO.

  {get DataTarget cDataTargets}.

  DO iTarget = 1 TO NUM-ENTRIES(cDataTargets):
    ASSIGN 
      cTarget = ENTRY(iTarget,cDataTargets)
      hTarget = WIDGET-HANDLE(cTarget).

    IF VALID-HANDLE(hTarget) THEN
    DO:
      {get QueryObject lQuery hTarget}.
      IF lQuery THEN
      DO:
        &SCOPED-DEFINE xp-assign
        {get DataIsFetched lIsFetched hTarget}
        {get InactiveLinks cInactiveLinks hTarget}
        {get OpenOnInit lOpenOnInit hTarget}.
        &UNDEFINE xp-assign
        
        IF lOpenOnInit THEN
        DO:
          cGrandChildren = {fn activateHiddenFetchChildren hTarget}.
          
          IF LOOKUP(STRING(TARGET-PROCEDURE),cInactiveLinks) > 0
          AND (lIsFetched <> FALSE OR cGrandChildren > '') THEN
          DO:
            cChildren = cChildren 
                      + (IF cChildren = '' THEN '' ELSE ',')
                      + STRING(hTarget).
            RUN linkStateHandler IN hTarget
                        ('ACTIVE':U,TARGET-PROCEDURE,'DataSource':U).
          END.
  
          IF cGrandChildren > '' THEN
            cChildren = cChildren 
                      + (IF cChildren = '' THEN '' ELSE ',')
                      + cGrandChildren.

        END. /* openoninit */
      END. /* queryobject */
    END. /* valid htarget*/ 
  END. /* cDataTargets */

  RETURN cChildren.   

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-addDatasetClone) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION addDatasetClone Procedure 
FUNCTION addDatasetClone RETURNS LOGICAL
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hDatasetSource AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hDataContainer AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cNewName       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hBuffer        AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cDataTable     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cTables        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hDataHandle    AS HANDLE     NO-UNDO.
  DEFINE VARIABLE iTable         AS INTEGER    NO-UNDO.
  DEFINE VARIABLE hChild         AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cChild         AS CHARACTER  NO-UNDO.


  {get DatasetSource hDatasetSource}.
  {get DataTable cDataTable}.

  IF VALID-HANDLE(hDatasetSource) THEN
  DO:
    {get DataContainerHandle hDataContainer}.
    cNewName = {fnarg cloneDataset hDatasetSource hDataContainer}.
    IF cNewName > '' THEN
    DO:
      {set DatasetName cNewName}.
      {fn addDatasetSource}.
      {get DatasetSource hDatasetSource}.
      IF VALID-HANDLE(hDatasetSource) THEN
      DO:
        hBuffer  = {fnarg dataTableHandle cDataTable hDatasetSource}.
        {set RowObject hBuffer}.
      END.
    END.
  END.

  IF VALID-HANDLE(hBuffer)  THEN
  DO:
    {get QueryTables cTables}.
    {get DataHandle hDataHandle}.
    hDataHandle:SET-BUFFERS(hBuffer).
    DO iTable = 2 TO NUM-ENTRIES(cTables):
      ASSIGN
        cChild = ENTRY(iTable,cTables)
        hChild = {fnarg dataTableHandle cChild hDatasetSource}
        .
      IF VALID-HANDLE(hChild) THEN
      DO:
        hDataHandle:ADD-BUFFER(hChild).
      END. 
    END.
    RETURN TRUE.
  END.

  RETURN FALSE. 

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-addDatasetSource) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION addDatasetSource Procedure 
FUNCTION addDatasetSource RETURNS LOGICAL
  (   ) :
/*------------------------------------------------------------------------------
 Purpose:    Attaches the dataset procedure to the dataview 
 Parameters:  <none>
 Notes:      This will be typically be called after the first data request at
             runtime, so the dataset will already be present in the 
             datacontainer .
           - At design time the datacontainer will call the service to
             retrieve the dataset.     
------------------------------------------------------------------------------*/
 DEFINE VARIABLE hDataContainer  AS HANDLE     NO-UNDO.
 DEFINE VARIABLE hRequestor      AS HANDLE     NO-UNDO.
 DEFINE VARIABLE cBusinessEntity AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cDataTable      AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cDataSetName    AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE hDatasetSource  AS HANDLE     NO-UNDO.
 DEFINE VARIABLE cRequestTable   AS CHARACTER  NO-UNDO.
 
 &SCOPED-DEFINE xp-assign
 {get BusinessEntity cBusinessEntity}
 {get DatasetName cDataSetName}
 {get RequestHandle hRequestor}
 {get DataContainerHandle hDataContainer}
 .
 &UNDEFINE xp-assign
 
 IF cDatasetName = '' THEN 
   cDatasetName = cBusinessEntity. 
   
 /* We allow no table for definitions (at design time) */
 IF cBusinessEntity > '' THEN 
 DO:
   RUN retrieveDataset IN hDataContainer
                         (hRequestor,
                          cBusinessEntity,
                          cDataSetName,
                          OUTPUT hDatasetSource) NO-ERROR.
   
   IF ERROR-STATUS:ERROR OR NOT VALID-HANDLE(hDatasetSource) THEN
   DO:
     /* Add the retrieve defs failed message */
     RUN addServerError IN TARGET-PROCEDURE('define':U,RETURN-VALUE,cBusinessEntity).
     /* show messages in update target */
     RUN processMessages IN TARGET-PROCEDURE. 
     RETURN FALSE.
   END. 
   
   {set DatasetSource hDatasetSource}.
 END.

 RETURN VALID-HANDLE(hDatasetSource).

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

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
------------------------------------------------------------------------------*/
  DEFINE VARIABLE iCol           AS INTEGER    NO-UNDO.
  DEFINE VARIABLE hColumn        AS HANDLE     NO-UNDO.
  DEFINE VARIABLE iColCount      AS INTEGER    NO-UNDO.
  DEFINE VARIABLE hRowObject     AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cColList       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cRowid         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hDataQuery     AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cForFields     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cForValues     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cField         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hDatasetSource AS HANDLE     NO-UNDO.
  DEFINE VARIABLE rRowid         AS ROWID      NO-UNDO.
  DEFINE VARIABLE cDataTable     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hDataHandle    AS HANDLE     NO-UNDO.
  DEFINE VARIABLE iBuf           AS INTEGER    NO-UNDO.
  &SCOPED-DEFINE xp-assign
  {get RowObject hRowObject}
  {get ForeignFields cForFields}
  {get DataColumns cColList}
  {get DatasetSource hDatasetSource}
  {get DataTable cDataTable}
  {get DataHandle hDataHandle}
  .
  &UNDEFINE xp-assign
  
  IF NOT VALID-HANDLE(hRowObject) OR NOT VALID-HANDLE(hDatasetSource) THEN
    RETURN ?.

  /* Save off the "current" rowid in case the add is cancelled. 
     If there's no RowObject record available, it's because we're
     being browsed from outside, so use the Browser's RowIdent. */
  IF hRowObject:AVAILABLE THEN
    {set CurrentRowid hRowObject:ROWID}. 
  ELSE /* currently used as getNewRow flag so set to blank if no 
          record avail  */
    {set CurrentRowid TO-ROWID('0x':U)}.

  rRowid = {fnarg createRow cDataTable hDatasetSource}.

  IF rRowid <> ? THEN
  DO:
    hRowObject:FIND-BY-ROWID(rRowid).
    DO ibuf = 2 TO hDataHandle:NUM-BUFFERS:
      hDataHandle:GET-BUFFER-HANDLE(iBuf):BUFFER-RELEASE.
    END.

    /* scope to control row-updated firing  (may change) */
    IF cForFields NE "":U THEN
    DO TRANSACTION:
      {get ForeignValues cForValues}.
      /* Each ForField pair is db name, RowObject name */
      DO iCol = 1 TO NUM-ENTRIES(cForFields) BY 2:
        cField = ENTRY(iCol, cForFields).
        hColumn = hRowObject:BUFFER-FIELD(ENTRY(NUM-ENTRIES(cField, ".":U), cField, ".":U)).
        IF VALID-HANDLE(hColumn) THEN  
          hColumn:BUFFER-VALUE = ENTRY(INT((iCol + 1) / 2), cForValues, CHR(1)).
      END.  /* END DO iCol */
    END.    /* END DO IF cForFields NE "" */

    run rowChanged in target-procedure("different":U).
 
    RETURN {fnarg colValues pcViewColList}.
  END. /* rRowid */

  RETURN ?.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-anyNonAutoCommitChildInDataset) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION anyNonAutoCommitChildInDataset Procedure 
FUNCTION anyNonAutoCommitChildInDataset RETURNS LOGICAL PRIVATE
        (  ):
/*------------------------------------------------------------------------------
    Purpose: Check if any of the children is non autocommit
    Notes:   This is considered a temporary function needed to check if 
             SubmitParent can be used for AutoCommit.
          -  The copyall mode needed for SubmitParent prevents it to be used 
             when only some data is to be saved.    
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cTargets            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hTarget             AS HANDLE     NO-UNDO. 
  DEFINE VARIABLE iTarget             AS INTEGER    NO-UNDO.
  DEFINE VARIABLE hDatasetSource      AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hDatasetSourceChild AS HANDLE     NO-UNDO.
  DEFINE VARIABLE lAutoCommit         AS LOGICAL    NO-UNDO.
  
  &scop xp-assign 
  {get DatasetSource hDatasetSource}
  {get DataTarget cTargets}.
  &undefine xp-assign
      
  DO iTarget = 1 TO NUM-ENTRIES(cTargets):
    hTarget = WIDGET-HANDLE(ENTRY(iTarget,cTargets)).
    IF VALID-HANDLE(hTarget) AND {fnarg instanceOf 'DataView' hTarget} THEN 
    DO:
      &scop xp-assign
      {get AutoCommit lAutoCommit hTarget}
      {get DatasetSource hDatasetSourceChild hTarget}
      . 
      &undefine xp-assign
      IF hDatasetSourceChild = hDatasetSource THEN 
      DO:
        IF NOT lAutoCommit THEN 
          RETURN TRUE.
        ELSE DO:
          IF {fn anyNonAutoCommitChildInDataset hTarget} THEN 
            RETURN TRUE.    
        END.    
      END. /* same dataset */
    END. /* dataview target */     
  END.
  
  RETURN FALSE.
         
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-applyContextFromServer) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION applyContextFromServer Procedure 
FUNCTION applyContextFromServer RETURNS LOGICAL
  ( pcContext AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose: Apply context returned from server after a server call
Parameter: CHR(4) separated paired list with attributename and value.
    Notes: Receives values returned from the service adapter's optional context
------------------------------------------------------------------------------*/
 DEFINE VARIABLE cValue             AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cProperty          AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE iLoop              AS INTEGER    NO-UNDO.

 DO iLoop = 1 TO NUM-ENTRIES(pcContext,CHR(4)) BY 2:
   ASSIGN
     cProperty = ENTRY(iLoop,pcContext,CHR(4))
     cValue    = ENTRY(iLoop + 1,pcContext,CHR(4))
     cValue    = IF cValue = '?' THEN ? ELSE cValue.
   DYNAMIC-FUNCTION("set":U + cProperty IN TARGET-PROCEDURE, cValue) NO-ERROR.  
 END.

 RETURN TRUE.    

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-assignColumnColumnLabel) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION assignColumnColumnLabel Procedure 
FUNCTION assignColumnColumnLabel RETURNS LOGICAL
  ( pcColumn      AS CHARACTER,
    pcColumnLabel AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:     Assign the columnlabel of the specified column.  
              
   Parameters: INPUT pcColumn 
                    - DataTable qualified column name.
                    - Unqualified column name of the DataTable.                    
                    - Column name qualified with "RowObject" is valid reference 
                      to the DataTable.   
              INPUT pcColumnLabel  - The new Column Label               
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hCol       AS HANDLE NO-UNDO.

  hCol = {fnarg columnHandle pcColumn}. 

  IF hCol NE ? THEN 
    hCol:COLUMN-LABEL = pcColumnLabel.  

  RETURN IF hCol = ? THEN FALSE ELSE TRUE.  

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-assignColumnFormat) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION assignColumnFormat Procedure 
FUNCTION assignColumnFormat RETURNS LOGICAL
  ( pcColumn AS CHARACTER,
    pcFormat AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:     Assign the FORMAT of the specified column.  
              
   Parameters: INPUT pcColumn 
                    - DataTable qualified column name.
                    - Unqualified column name of the DataTable.                    
                    - Column name qualified with "RowObject" is valid reference 
                      to the DataTable.   
              INPUT pcformat - new format         
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hCol       AS HANDLE NO-UNDO.

  hCol = {fnarg columnHandle pcColumn}. 

  IF hCol NE ? THEN 
    hCol:FORMAT = pcFormat.
  
  RETURN IF hCol = ? THEN FALSE ELSE TRUE.  

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-assignColumnHelp) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION assignColumnHelp Procedure 
FUNCTION assignColumnHelp RETURNS LOGICAL
  ( pcColumn AS CHARACTER,
    pcHelp   AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:     Assign the help string of the specified column.  
              
   Parameters: INPUT pcColumn 
                    - DataTable qualified column name.
                    - Unqualified column name of the DataTable.                    
                    - Column name qualified with "RowObject" is valid reference 
                      to the DataTable.   
               INPUT pcHelp - new help string         
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hCol       AS HANDLE NO-UNDO.

  hCol = {fnarg columnHandle pcColumn}. 
  
  IF hCol NE ? THEN 
    hCol:HELP = pcHelp.

  RETURN IF hCol = ? THEN FALSE ELSE TRUE.  

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-assignColumnLabel) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION assignColumnLabel Procedure 
FUNCTION assignColumnLabel RETURNS LOGICAL
  ( pcColumn AS CHARACTER,
    pcLabel  AS CHARACTER) :
/*------------------------------------------------------------------------------
      Purpose:  Assign the label of the specified column.  
              
   Parameters: INPUT pcColumn 
                    - DataTable qualified column name.
                    - Unqualified column name of the DataTable.                    
                    - Column name qualified with "RowObject" is valid reference 
                      to the DataTable.   
               INPUT pcLabel - New label       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hCol       AS HANDLE NO-UNDO.

  hCol = {fnarg columnHandle pcColumn}. 
  
  IF hCol NE ? THEN 
    hCol:LABEL = pcLabel.

  RETURN IF hCol = ? THEN FALSE ELSE TRUE.  

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-assignColumnPrivateData) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION assignColumnPrivateData Procedure 
FUNCTION assignColumnPrivateData RETURNS LOGICAL
  ( pcColumn      AS CHARACTER, 
    pcPrivateData AS CHARACTER ) :
/*------------------------------------------------------------------------------
      Purpose:  Assign the label of the specified column.  
              
   Parameters: INPUT pcColumn 
                    - DataTable qualified column name.
                    - Unqualified column name of the DataTable.                    
                    - Column name qualified with "RowObject" is valid reference 
                      to the DataTable.   
               INPUT pcPrivateData - New private data       
------------------------------------------------------------------------------*/
 DEFINE VARIABLE hCol       AS HANDLE NO-UNDO.

 hCol = {fnarg columnHandle pcColumn}. 
  
 IF hCol NE ? THEN 
   hCol:PRIVATE-DATA = pcPrivateData.

 RETURN IF hCol = ? THEN FALSE ELSE TRUE.  

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
  Notes:       cancelRow restores the original values of a modified row from 
               the before-image record.
------------------------------------------------------------------------------*/
 DEFINE VARIABLE lNew          AS LOG        NO-UNDO.
 DEFINE VARIABLE rRowid        AS ROWID      NO-UNDO.
 DEFINE VARIABLE hRowObject    AS HANDLE     NO-UNDO.
 DEFINE VARIABLE hBefore       AS HANDLE     NO-UNDO.
 DEFINE VARIABLE hDataquery    AS HANDLE     NO-UNDO.
 
 &SCOPED-DEFINE xp-assign
 {get NewMode lNew}
 {get RowObject hRowObject}
 {set DataModified FALSE}.
 .
 &UNDEFINE xp-assign
 
 IF lNew THEN 
 DO:
   hBefore = hRowObject:BEFORE-BUFFER.
   hBefore:FIND-BY-ROWID(hRowObject:BEFORE-ROWID).
   
   /* transaction works around core bug/behavior that may cause row-updated to 
      fire at unexpected places */
   /* no-error -- already exists errors seen when default values 
                  clashes with existing data (probably core bug?) */
   DO TRANSACTION:
     hBefore:REJECT-ROW-CHANGES NO-ERROR.  
   END.

   &SCOPED-DEFINE xp-assign
   {get DataHandle hDataQuery}
   {get CurrentRowid rRowid}
   .
   &UNDEFINE xp-assign
   /* Tell a browse updateSource to get rid of the insert-row */
   PUBLISH 'cancelNew':U FROM TARGET-PROCEDURE.
 
   IF hDataQuery:IS-OPEN AND rRowid <> ? THEN 
   DO:
     hDataQuery:REPOSITION-TO-ROWID(rRowid) NO-ERROR.
     /* Next needed if not browser (Data-Target) */
     IF NOT hRowObject:AVAILABLE AND ERROR-STATUS:GET-MESSAGE(1) = '':U THEN  
        hDataQuery:GET-NEXT() NO-ERROR.
   END.  /* IF the query is open */
   {set CurrentRowid ?}.
   RUN rowChanged IN TARGET-PROCEDURE('DIFFERENT':U).
 END.

 RETURN '':U. /* This used to return a cError variable for some forgotten reason*/

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-canFindParentOnClient) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION canFindParentOnClient Procedure 
FUNCTION canFindParentOnClient RETURNS LOGICAL
  (  ) :
/*------------------------------------------------------------------------------
  Purpose: Check parent availability on client 
    Notes: Would only return false if the key has changed...       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cForeignFields AS character  NO-UNDO.
  DEFINE VARIABLE hDataSource    AS HANDLE     NO-UNDO.
  DEFINE VARIABLE iField         AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cField         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cParentField   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cValue         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cParentWhere   AS CHARACTER  NO-UNDO.
  
  &scoped-define xp-assign
  {get DataSource hDataSource}
  {get ForeignFields cForeignFields}
  .
  &undefine xp-assign
  
  if cForeignFields > "":U and valid-handle(hDataSource) then
  do:
    cParentWhere = 'WHERE ':U. 
    do iField = 1 to num-entries(cForeignFields) by 2:
      assign
        cField       = entry(iField,cForeignFields)
        cParentField = entry(iField + 1,cForeignFields)
        cValue       = {fnarg columnValue cField}
        cParentWhere =  cParentWhere 
                     + (if iField = 1 then "" else " AND ")  
                     + cParentfield 
                     + " = "
                     + quoter(cValue).                   
    end.  
    return {fnarg canFindWhereOnClient cParentWhere hDataSource}. 
  end.   
  
  return false.  

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-canFindWhereOnClient) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION canFindWhereOnClient Procedure 
FUNCTION canFindWhereOnClient RETURNS LOGICAL
  ( pcWhere AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose: Check if a record is on client without changing current position
  pcWhere - where clause starting with WHERE (no 'for each table') 
    Notes:  
------------------------------------------------------------------------------*/ 
  DEFINE VARIABLE cDataTable AS CHARACTER  NO-UNDO.
  
  if not pcWhere begins 'WHERE ':U then  
    pcWhere = 'WHERE ':U + pcWhere.
  
  {get DataTable cDataTable}.
  
  pcWhere = 'FOR EACH ':U + cDataTable  + ' ':U + pcWhere.
  
  IF {fnarg firstRowids pcWhere} = ? THEN
    RETURN FALSE.
  ELSE 
    RETURN TRUE.

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
    Notes: Navigating objects will typically call this to check if the object
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
   DEFINE VARIABLE lQueryOpen      AS LOGICAL    NO-UNDO.

   &SCOPED-DEFINE xp-assign
   {get DataModified lDataModified}      
   /* Use NewMode refers to the current Object's state, NOT newRow */ 
   {get NewMode lNewMode}  
   {get QueryOpen lQueryOpen}
   .
   &UNDEFINE xp-assign
   IF NOT lQueryOpen THEN
     RETURN FALSE.

   /* Use = TRUE to ensure that unknown is treated similar to false */
   lUpdate = (lDataModified = TRUE) OR (lNewMode = TRUE). 
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

&IF DEFINED(EXCLUDE-childForeignFields) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION childForeignFields Procedure 
FUNCTION childForeignFields RETURNS CHARACTER
  ( pcChild AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose: Return the foreignfields for a child relation  
    Notes: returns comma separated pairs in child parent order
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hDatasetSource AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cForeignFields AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDataTable     AS CHARACTER  NO-UNDO.
  
  &scoped-define xp-assign
  {get DataTable cDataTable}
  {get DatasetSource hDatasetSource}
  .
  &undefine xp-assign
  /* pass child first as foreignfields is expressed in query order; child,parent */  
  IF VALID-HANDLE(hDatasetSource) THEN
    cForeignFields = DYNAMIC-FUNCTION("relationFields":U IN hDatasetSource,
                     pcChild,cDataTable). 
  
  RETURN cForeignFields.  

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-closeQuery) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION closeQuery Procedure 
FUNCTION closeQuery RETURNS LOGICAL
  (  ) :
/*------------------------------------------------------------------------------
  Purpose: Close the query 
    Notes:     
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hDataQuery     AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hDatasetSource AS HANDLE     NO-UNDO.
  DEFINE VARIABLE lIsFetched     AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cDataTable     AS CHARACTER  NO-UNDO.

  {get DataHandle hDataQuery}.
  IF VALID-HANDLE(hDataQuery) THEN
  DO:
    &SCOPED-DEFINE xp-assign
    {get DatasetSource hDatasetSource}
    {get DataIsFetched lIsFetched}
    {get DataTable cDataTable}
    {set FirstRowNum 0}
    {set LastRowNum 0}
     .
    &UNDEFINE xp-assign

    hDataQuery:QUERY-CLOSE().
    hDataQuery:get-buffer-handle(1):buffer-release.
    RUN rowChanged IN TARGET-PROCEDURE('DIFFERENT':U). 
    
    RETURN TRUE.  
  END.

  RETURN FALSE.  

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnColumnLabel) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION columnColumnLabel Procedure 
FUNCTION columnColumnLabel RETURNS CHARACTER
  ( pcColumn AS CHARACTER ) :
/*------------------------------------------------------------------------------
     Purpose: Returns the Progress ColumnLabel for a specified column.  
              
  Parameters: INPUT pcColumn 
                    - DataTable qualified column name.
                    - Unqualified column name of the DataTable.                    
                    - Column name qualified with "RowObject" is valid reference 
                      to the DataTable.   
      Notes:  This is the list oriented label, which is NOT the same as 
              the Label. 
              The Label is returned if columnlabel is not defined.  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hCol       AS HANDLE NO-UNDO.
  
  hCol = {fnarg columnHandle pcColumn}. 

  RETURN IF hCol = ?                   THEN ?
         ELSE IF hCol:COLUMN-LABEL = ? THEN {fnarg columnLabel pcColumn}
         ELSE                               hCol:COLUMN-LABEL.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnDataType) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION columnDataType Procedure 
FUNCTION columnDataType RETURNS CHARACTER
  ( pcColumn AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:     Returns the Progress datatype of a specified column.  
              
   Parameters: INPUT pcColumn 
                    - DataTable qualified column name.
                    - Unqualified column name of the DataTable.                    
                    - Column name qualified with "RowObject" is valid reference 
                      to the DataTable.   
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hCol       AS HANDLE NO-UNDO.

  hCol = {fnarg columnHandle pcColumn}. 

  RETURN IF hCol = ? THEN ? ELSE hCol:DATA-TYPE.     
  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnDefaultValue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION columnDefaultValue Procedure 
FUNCTION columnDefaultValue RETURNS CHARACTER
  ( pcColumn AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:    Returns the Progress help text for a specified column.  
   Parameters: INPUT pcColumn 
                    - DataTable qualified column name.
                    - Unqualified column name of the DataTable.                    
                    - Column name qualified with "RowObject" is valid reference 
                      to the DataTable.   
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hCol       AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cValue     AS CHARACTER  NO-UNDO.

  hCol = {fnarg columnHandle pcColumn}. 
  IF VALID-HANDLE(hCol) THEN
  DO:
    cValue = hCol:DEFAULT-STRING.
    /* The default-string returns literals for now and today, 
       We treat this as the anticipated default-value (datatype =run-type) */  
    IF hCol:DATA-TYPE BEGINS 'DATE':U THEN
    DO:
      CASE cValue: 
        WHEN 'TODAY':U THEN
          cValue = STRING(TODAY).
        WHEN 'NOW' THEN
          cValue = STRING(NOW).
      END CASE.
    END.
    RETURN cValue.
  END.
  
  RETURN ?. 

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnFormat) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION columnFormat Procedure 
FUNCTION columnFormat RETURNS CHARACTER
  ( pcColumn AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:    Returns the format for a specified column.  
   Parameters: INPUT pcColumn 
                    - DataTable qualified column name.
                    - Unqualified column name of the DataTable.                    
                    - Column name qualified with "RowObject" is valid reference 
                      to the DataTable.   
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hCol       AS HANDLE NO-UNDO.

  hCol = {fnarg columnHandle pcColumn}. 
  
  RETURN IF hCol = ? THEN ? ELSE hCol:FORMAT.  

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION columnHandle Procedure 
FUNCTION columnHandle RETURNS HANDLE
  ( pcColumn AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose:    Returns the handle of a temp-table column.  
  Parameters: INPUT pcColumn 
               - Unqualified column name of the DataTablefield.
               - Column name qualified with "RowObject".   
               - qualified temp-table column name. 
       Notes: Used by other column functions and the browse.  
------------------------------------------------------------------------------*/
 DEFINE VARIABLE hRowObject     AS HANDLE     NO-UNDO.
 DEFINE VARIABLE hColumn        AS HANDLE     NO-UNDO.
 DEFINE VARIABLE cDataTable     AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cTable         AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE hBuffer        AS HANDLE     NO-UNDO.
 DEFINE VARIABLE hDataset       AS HANDLE     NO-UNDO.
 DEFINE VARIABLE hQuery         AS HANDLE     NO-UNDO.
 DEFINE VARIABLE cViewTables    AS CHARACTER  NO-UNDO. 
 DEFINE VARIABLE iBuffer        AS INTEGER    NO-UNDO.
 DEFINE VARIABLE cBufferHandles AS CHARACTER  NO-UNDO.
 
 {get RowObject hBuffer}.
 IF NOT VALID-HANDLE(hBuffer) THEN
   RETURN ?.

 IF NUM-ENTRIES(pcColumn,".":U) = 2 THEN
 DO:
   IF pcColumn BEGINS 'RowObject.':U THEN
     pcColumn  = ENTRY(2,pcColumn,'.':U).
   ELSE DO:
     {get DataTable cDataTable}.
     IF cDataTable > '' THEN
     DO:
       cTable = ENTRY(1,pcColumn,'.':U).
       pcColumn  = ENTRY(2,pcColumn,'.':U).
       IF cTable <> cDataTable THEN
       DO:
         &SCOPED-DEFINE xp-assign
         {get DatasetSource hDataset}
         {get DataHandle hQuery}
         .
         &UNDEFINE xp-assign
         /* First check in query (defined in QueryTables) */
         hBuffer = hQuery:GET-BUFFER-HANDLE(cTable) NO-ERROR.
         IF NOT VALID-HANDLE(hBuffer) THEN
         DO:
           &scoped-define xp-assign
           {get ViewTables cViewTables}
           {get BufferHandles cBufferHandles}
           .
           &undefine xp-assign 
           iBuffer = LOOKUP(cTable,cViewTables).
           if iBuffer > 0 then 
             hBuffer = widget-handle(entry(iBuffer,cBufferHandles)).
           
         END. /* not in query */
       END.
     END. /* DataTable > '' */
   END.
 END.
 
 hColumn = hBuffer:BUFFER-FIELD(pcColumn) NO-ERROR.

 RETURN hColumn.   
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnHelp) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION columnHelp Procedure 
FUNCTION columnHelp RETURNS CHARACTER
  ( pcColumn AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:    Returns the Progress help text for a specified column.  
   Parameters: INPUT pcColumn 
                    - DataTable qualified column name.
                    - Unqualified column name of the DataTable.                    
                    - Column name qualified with "RowObject" is valid reference 
                      to the DataTable.   
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hCol       AS HANDLE NO-UNDO.

  hCol = {fnarg columnHandle pcColumn}. 
  
  RETURN IF hCol = ? THEN ? ELSE hCol:HELP.  

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnInitial) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION columnInitial Procedure 
FUNCTION columnInitial RETURNS CHARACTER
  ( pcColumn AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:   Returns the initial value for a specified field as a character
             string with the field FORMAT applied.
   Parameters: INPUT pcColumn 
                    - DataTable qualified column name.
                    - Unqualified column name of the DataTable.                    
                    - Column name qualified with "RowObject" is valid reference 
                      to the DataTable.   
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hCol       AS HANDLE NO-UNDO.

  hCol = {fnarg columnHandle pcColumn}. 
  
  RETURN IF hCol = ? THEN ? ELSE hCol:INITIAL.  

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnLabel) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION columnLabel Procedure 
FUNCTION columnLabel RETURNS CHARACTER
  ( pcColumn AS CHARACTER ) :
/*------------------------------------------------------------------------------
     Purpose: Returns the Progress ColumnLabel for a specified column.  
              
  Parameters: INPUT pcColumn 
                    - DataTable qualified column name.
                    - Unqualified column name of the DataTable.                    
                    - Column name qualified with "RowObject" is valid reference 
                      to the DataTable.   
      Notes:  The Name is returned if label not defined.  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hCol       AS HANDLE NO-UNDO.
  
  hCol = {fnarg columnHandle pcColumn}. 
  
  RETURN IF hCol = ?            THEN ? 
         ELSE IF hCol:LABEL = ? THEN hCol:NAME 
         ELSE                        hCol:LABEL.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnLongCharValue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION columnLongCharValue Procedure 
FUNCTION columnLongCharValue RETURNS LONGCHAR
  ( pcColumn AS CHARACTER ) :
/*------------------------------------------------------------------------------
     Purpose: Returns the LONGCHAR value of a specified column in the 
              DataView DataTable buffer. 
              
  Parameters: INPUT pcColumn 
                    - DataTable qualified column name.
                    - Unqualified column name of the DataTable.                    
                    - Column name qualified with "RowObject" is valid reference 
                      to the DataTable.   
       Note:   ? in a CLOB is returned as blank!      
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hCol       AS HANDLE   NO-UNDO.
  DEFINE VARIABLE cLongValue AS LONGCHAR NO-UNDO.

  hCol = {fnarg columnHandle pcColumn}. 
  
  CASE hCol:DATA-TYPE:
    WHEN 'CLOB':U THEN
    DO:
      IF LENGTH(hCol:BUFFER-VALUE) > 0 THEN 
        COPY-LOB FROM hCol:BUFFER-VALUE TO cLongValue NO-ERROR.
      ELSE 
        cLongValue = ''.
    END.
    WHEN 'BLOB':U THEN
    DO:
      IF hCol:BUFFER-VALUE <> ? THEN
      DO:
        COPY-LOB FROM hCol:BUFFER-VALUE TO cLongValue NO-ERROR.
      /* just show the default progress error, but set return value to ? */ 
        IF ERROR-STATUS:ERROR THEN
        DO:
          MESSAGE ERROR-STATUS:GET-MESSAGE(1)
                  VIEW-AS ALERT-BOX ERROR.
          cLongValue = ''.
        END.
      END.
    END.
    WHEN 'CHARACTER':U THEN
      cLongValue = hCol:BUFFER-VALUE.
    OTHERWISE 
      cLongValue = STRING(hCol:BUFFER-VALUE).

  END CASE.

  RETURN cLongValue.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnName) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION columnName Procedure 
FUNCTION columnName RETURNS CHARACTER
  ( phHandle AS HANDLE) :
/*------------------------------------------------------------------------------
  Purpose: Resolves the external unique name of the column from the passed 
           field handle.  
    Notes:    
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cName   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hColumn AS HANDLE     NO-UNDO.

  IF VALID-HANDLE(phHandle) THEN
  DO:
    /* Check if the handle can be found with this name  */  
    cName = phHandle:TABLE + '.':U + phHandle:NAME NO-ERROR.
    IF cName > '' THEN
      hColumn = {fnarg columnHandle cName}.
    
    IF phHandle = hColumn THEN
      RETURN cName.
  END.

  RETURN ''.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnPrivateData) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION columnPrivateData Procedure 
FUNCTION columnPrivateData RETURNS CHARACTER
  ( pcColumn AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:    Returns the Progress Private-Data attribute of a specified column. 
   Parameters: INPUT pcColumn 
                    - DataTable qualified column name.
                    - Unqualified column name of the DataTable.                    
                    - Column name qualified with "RowObject" is valid reference 
                      to the DataTable.   
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hCol       AS HANDLE NO-UNDO.

  hCol = {fnarg columnHandle pcColumn}. 

  RETURN IF hCol = ? THEN ? ELSE hCol:PRIVATE-DATA.  

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnReadOnly) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION columnReadOnly Procedure 
FUNCTION columnReadOnly RETURNS LOGICAL
  ( pcColumn AS CHARACTER ) :
/*------------------------------------------------------------------------------
      Purpose: Returns true if the specified column is read only
              
  Parameters: INPUT pcColumn 
                    - DataTable qualified column name.
                    - Unqualified column name of the DataTable.                    
                    - Column name qualified with "RowObject" is valid reference 
                      to the DataTable.   
  Notes:       A visualization may use this dynamically to determine whether 
               the field should be updatable on the screen.  Even still, there
               may be circumstances where it is desirable to have it updatable
               on the screen but if it is READ-ONLY in the SmartDataObject any
               changes sent back to the SmartDataObject will not be made in
               the RowObject temp-table and, therefore, in the database.
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cUpdatable   AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cColumns     AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cDataTable   AS CHARACTER  NO-UNDO.

  {get DataTable cDataTable}.

  IF NUM-ENTRIES(pcColumn,".":U) = 1 THEN
    ASSIGN
      pcColumn = cDataTable 
               + '.':U
               + pcColumn.
  ELSE IF pcColumn BEGINS "RowObject.":U THEN
    ASSIGN
      pcColumn = cDataTable 
               + '.':U
               + ENTRY(2,pcColumn,".":U).
             
  {get UpdatableColumns cUpdatable}.  

  RETURN LOOKUP(pcColumn,cUpdatable) > 0.
  

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnStringValue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION columnStringValue Procedure 
FUNCTION columnStringValue RETURNS CHARACTER
  ( pcColumn AS CHARACTER ) :
/*------------------------------------------------------------------------------
      Purpose: Returns the formatted value of the specified column.
  Parameters: INPUT pcColumn 
                    - DataTable qualified column name.
                    - Unqualified column name of the DataTable.                    
                    - Column name qualified with "RowObject" is valid reference 
                      to the DataTable.   
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hCol       AS HANDLE NO-UNDO.

  hCol = {fnarg columnHandle pcColumn}. 
  IF VALID-HANDLE(hCol) THEN
  DO:
    IF hCol:DATA-TYPE = 'CLOB':U OR hCol:DATA-TYPE = 'BLOB':U THEN
    DO:
      /* Design time error .. */
      MESSAGE SUBSTITUTE({fnarg MessageNumber 95},PROGRAM-NAME(1),
                                             hCol:NAME,
                                             hCol:DATA-TYPE)
              VIEW-AS ALERT-BOX ERROR.
      RETURN ?.
    END.
    RETURN hCol:STRING-VALUE.
  END.

  RETURN ?.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnTable) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION columnTable Procedure 
FUNCTION columnTable RETURNS CHAR
  ( pcColumn AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:    Returns the table for a specified column.  
   Parameters: INPUT pcColumn 
                    - DataTable qualified column name.
                    - Unqualified column name of the DataTable.                    
                    - Column name qualified with "RowObject" is valid reference 
                      to the DataTable.   
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hCol AS HANDLE NO-UNDO.

  hCol = {fnarg columnHandle pcColumn}. 
 
  RETURN IF hCol = ? THEN ? ELSE hCol:TABLE.  

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnValue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION columnValue Procedure 
FUNCTION columnValue RETURNS CHARACTER
  ( pcColumn AS CHARACTER ) :
/*------------------------------------------------------------------------------
      Purpose: Returns the unformatted value of the specified column.
  Parameters: INPUT pcColumn 
                    - DataTable qualified column name.
                    - Unqualified column name of the DataTable.                    
                    - Column name qualified with "RowObject" is valid reference 
                      to the DataTable.   
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hCol            AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hRowObject      AS HANDLE     NO-UNDO.
  DEFINE VARIABLE lDataTable      AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cColumnName     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cValue          AS CHARACTER  NO-UNDO.
  
  {get RowObject hRowObject}.
  IF NOT VALID-HANDLE(hRowObject) OR NOT hRowObject:AVAILABLE THEN
    RETURN ?.
   
  /* performance overrides reuse in this, function calls are expensive  */
  IF INDEX(pcColumn,'.':U) > 0 THEN
    ASSIGN 
      lDataTable  = ENTRY(1,pcColumn,'.':U) = hRowObject:NAME
      cColumnName = ENTRY(2,pcColumn,'.':U).
  ELSE
    ASSIGN
      lDataTable  = TRUE
      cColumnName = pcColumn.

  IF lDataTable THEN 
    hCol = hRowObject:BUFFER-FIELD(cColumnName) NO-ERROR.
  ELSE 
    hCol = {fnarg columnHandle pcColumn}. 

  IF VALID-HANDLE(hCol) THEN
  DO:
    IF hCol:DATA-TYPE = 'CLOB':U OR hCol:DATA-TYPE = 'BLOB':U THEN
    DO:
      /* Design time error .. */
      MESSAGE SUBSTITUTE({fnarg MessageNumber 95},PROGRAM-NAME(1),
                                             hCol:NAME,
                                             hCol:DATA-TYPE)
              VIEW-AS ALERT-BOX ERROR.
      RETURN ?.
    END.
    
    /* Expect no avail i.e. outer join */
    cValue = hCol:BUFFER-VALUE NO-ERROR.
 
    RETURN cValue.
  END.

  RETURN ?.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnWidth) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION columnWidth Procedure 
FUNCTION columnWidth RETURNS DECIMAL
  ( pcColumn AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:    Returns the width for a specified column.  
   Parameters: INPUT pcColumn 
                    - DataTable qualified column name.
                    - Unqualified column name of the DataTable.                    
                    - Column name qualified with "RowObject" is valid reference 
                      to the DataTable.   
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hCol       AS HANDLE NO-UNDO.

  hCol = {fnarg columnHandle pcColumn}. 
  
  RETURN IF hCol = ? THEN ? ELSE hCol:WIDTH.  

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-colValues) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION colValues Procedure 
FUNCTION colValues RETURNS CHARACTER
  ( pcViewColList AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:     Returns a CHR(1) delimited list of values for the requested
               columns (in pcViewColList) of the current row of the RowObject.
               The first value is the RowObect ROWID and RowIdent separated 
               with a comma.     
  Parameters:
    INPUT pcViewColList - Comma delimited list of RowObject column names
                        - SKIP means add blank value   
  Notes:       The form of the first value is:
                 <RowObject ROWID>,<DB Buffer1 ROWID>,<DB Buffer2 ROWID>,...
               This is used as a key to uniquely identify the row and its
               origins in the optimistic locking system.
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cColValues  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iCol        AS INTEGER    NO-UNDO.
  DEFINE VARIABLE hColumn     AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hBuffer     AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cBuffer     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iColCount   AS INTEGER    NO-UNDO.
  DEFINE VARIABLE hRowObject  AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hDataSource AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cValue      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cColumnRef  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cColumn     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lQueryOpen  AS LOGICAL    NO-UNDO.

  &SCOPED-DEFINE xp-assign
  {get RowObject hRowObject}     
  {get QueryOpen lQueryOpen}
  .
  &UNDEFINE xp-assign
  
  IF VALID-HANDLE(hrowObject) AND hRowObject:AVAILABLE AND lQueryOpen THEN 
  DO:    
    /* The first value passed back is always a "key" */
    ASSIGN 
      cColValues = STRING(hRowObject:ROWID) + CHR(1)
      iColCount  = NUM-ENTRIES(pcViewColList).
     
    DO iCol = 1 TO iColCount:
      cColumnRef = ENTRY(iCol, pcViewColList).
      IF cColumnRef <> 'SKIP':U THEN
      DO:
        ASSIGN
          cBuffer = (IF NUM-ENTRIES(cColumnRef ,'.':U) > 1 THEN
                     ENTRY(1,cColumnRef ,'.':U)
                     ELSE '':U)
          cColumn = (IF NUM-ENTRIES(cColumnRef ,'.':U) > 1 THEN
                     ENTRY(2,cColumnRef ,'.':U)
                     ELSE cColumnRef ).
        /* We don't call columnValue for performance, but there is 
           also a need to distinguish invalid column names from unknown values */
        IF cBuffer = hRowObject:NAME THEN
        DO:
          hColumn = hRowObject:BUFFER-FIELD(cColumn) NO-ERROR.
          IF hColumn:DATA-TYPE = 'CLOB':U OR hColumn:DATA-TYPE = 'BLOB':U THEN
          DO:
            /* Design time error .. */
            MESSAGE SUBSTITUTE({fnarg MessageNumber 95},PROGRAM-NAME(1),hColumn:NAME,hColumn:DATA-TYPE)
               VIEW-AS ALERT-BOX ERROR.
            RETURN ?.
          END.
          cValue  = RIGHT-TRIM(STRING(hColumn:BUFFER-VALUE)).

        END.
        ELSE IF NUM-ENTRIES(cColumnRef ,'.':U) > 1 THEN
        DO:
          cValue = {fnarg columnValue cColumnRef}.
          /* columnValue currently returns ? for invalid and unknown 
             (should probably just return '?' for unknown), so 
             check for validity */
          IF cValue = ? THEN 
          DO:
            hColumn = {fnarg columnHandle cColumnRef}.
            IF hColumn = ? THEN
              RETURN ?.
            /* just return blank for non available (unless logical or date)
               logicals are not very good at runtime conversions.. 
               date uses ? to display blank  */ 
            ELSE IF hColumn:DATA-TYPE = "LOGICAL":U THEN
              cValue = 'NO':U. 
            ELSE IF NOT hColumn:DATA-TYPE BEGINS "DATE":U THEN
              cValue = '':U.
          END.
        END.
        ELSE DO:
          /* If this is a <calc> field, make put a constant in so that the
             browser does not fail during displayFields */
          IF INDEX(ENTRY(iCol, pcViewColList), "<calc>":U) > 0 THEN
            cColValues = cColValues + CHR(4) + "<calc>":U + CHR(4). 
          ELSE 
            RETURN ?.
        END.       /* IF NOT VALID-HANDLE */
        cColValues = cColValues                         
                   + IF cValue = ? 
                     THEN "?":U 
                     ELSE cValue. 
      END. /* <> SKIP */
      IF iCol NE iColCount THEN cColValues = cColValues + CHR(1).
    END.  /* END iCol */
    RETURN cColValues.       
  END. /* valid and avail rowObject*/
  RETURN ?.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-compareTableValues) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION compareTableValues Procedure 
FUNCTION compareTableValues RETURNS CHARACTER
  ( phBufferOne AS HANDLE,
    phBufferTwo AS HANDLE) :
/*------------------------------------------------------------------------------
  Purpose:  Compare and return a list of the fields that have different 
            field values in two buffers.          
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE iField     AS INTEGER    NO-UNDO.
  DEFINE VARIABLE hFldOne    AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hFldTwo    AS HANDLE     NO-UNDO.
  DEFINE VARIABLE iExtent    AS INTEGER    NO-UNDO.
  DEFINE VARIABLE lExtent    AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE iNumItems  AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cFieldList AS CHARACTER  NO-UNDO.

  DO iField = 1 TO phBufferOne:NUM-FIELDS:
    hFldOne = phBufferOne:BUFFER-FIELD(iField).
    hFldTwo = phBufferTwo:BUFFER-FIELD(hFldOne:NAME) NO-ERROR.
    
    IF NOT VALID-HANDLE(hFldTwo) THEN
    DO:
      MESSAGE program-name(1) " cannot compare different tables."
        VIEW-AS ALERT-BOX ERROR.
      RETURN ?.
    END.
    
    ASSIGN
      lExtent   = hFldOne:EXTENT > 0
      iNumItems = IF NOT lExtent THEN 1 ELSE hFldOne:EXTENT.

    DO iExtent = 1 TO iNumItems: 
      IF NOT DYNAMIC-FUNCTION("compareFieldValues":U IN TARGET-PROCEDURE,
                              hFldOne,
                              IF lExtent THEN iExtent ELSE 0,
                              'EQ':U,
                              hFldTwo,
                              IF lExtent THEN iExtent ELSE 0,
                              'RAW':U) THEN 
      DO:
        ASSIGN cFieldList = cFieldList 
                          + (IF cFieldList = "":U THEN "":U ELSE ",":U) 
                          + hFldOne:NAME  
                          + IF lExtent THEN "[" + STRING(iExtent) + "]" ELSE "".

      END.
    END.  /* extent loop */
  END. /* field loop */

  RETURN cFieldList. 

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-copyLargeColumnToFile) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION copyLargeColumnToFile Procedure 
FUNCTION copyLargeColumnToFile RETURNS LOGICAL
  ( pcColumn   AS CHAR,
    pcFileName AS CHARACTER) :
/*------------------------------------------------------------------------------
   Purpose: Copy a large column to the passed filename. 
Parameters: pcColumn 
             - Unqualified column name of the field (qualified with table name).
            pcFileName - filename to copy the data to                      
     Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hCol       AS HANDLE NO-UNDO.
  
  hCol = {fnarg columnHandle pcColumn}. 
  
  IF VALID-HANDLE(hCol) THEN
  DO ON STOP UNDO,LEAVE ON ERROR UNDO,LEAVE:
    COPY-LOB FROM hCol:BUFFER-VALUE TO FILE pcFileName.
    RETURN TRUE.
  END.
  
  RETURN FALSE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-copyLargeColumnToMemptr) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION copyLargeColumnToMemptr Procedure 
FUNCTION copyLargeColumnToMemptr RETURNS LOGICAL
  ( pcColumn AS CHAR,
    pmMemptr AS MEMPTR) :
/*------------------------------------------------------------------------------
  Purpose: Copy the value of a large column to the passed Memptr
Parameters: pcColumn 
             - Unqualified column name of the field (qualified with table name).
               pcFileName - filename to copy the data to                      
            pmMemptr 
            - The memptr to copy the data to    
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hCol       AS HANDLE NO-UNDO.
  
  hCol = {fnarg columnHandle pcColumn}. 
    
  IF VALID-HANDLE(hCol) THEN
  DO ON STOP UNDO,LEAVE ON ERROR UNDO,LEAVE:
    COPY-LOB FROM hCol:BUFFER-VALUE TO pmMemptr.
    RETURN TRUE.
  END.
  
  RETURN FALSE.   

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
 ------------------------------------------------------------------------------*/
  DEFINE VARIABLE hRowObject     AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hFromBuffer    AS HANDLE     NO-UNDO.
  DEFINE VARIABLE iCol           AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cDispValues    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cColumn        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iPos           AS INTEGER    NO-UNDO.
  DEFINE VARIABLE hDatasetSource AS HANDLE     NO-UNDO.
  DEFINE VARIABLE rRowid         AS ROWID      NO-UNDO.
  DEFINE VARIABLE cDataTable     AS CHARACTER  NO-UNDO.

  &SCOPED-DEFINE xp-assign
   {get RowObject hRowObject}
   {get DatasetSource hDatasetSource}
   {get DataTable cDataTable}
     /* Save off the "current" rowid in case the add is cancelled. 
     (rowid can be referenced when not avail) */
   {set CurrentRowid hRowObject:ROWID}

   .
  &UNDEFINE xp-assign
  
  IF NOT VALID-HANDLE(hRowObject) OR NOT VALID-HANDLE(hDatasetSource) THEN
    RETURN ?.

  IF hRowObject:AVAILABLE THEN
  DO:
    cDispValues = {fnarg colValues pcViewColList}.
    CREATE BUFFER hFrombuffer FOR TABLE hRowObject. 
    hFromBuffer:FIND-FIRST('WHERE ROWID(':U + hFromBuffer:NAME + ')':U  
                          + ' = TO-ROWID("':U + STRING(hRowObject:ROWID) + '")':U)
                NO-ERROR.
  END.
  
  rRowid = {fnarg createRow cDataTable hDatasetSource}.
  
  IF rRowid <> ? THEN
  DO:
    hRowObject:FIND-BY-ROWID(rRowid).
    /* scope to control row-updated firing  (may change) */
    DO TRANSACTION:
      IF VALID-HANDLE(hFromBuffer) AND hFromBuffer:AVAILABLE THEN 
        hRowObject:BUFFER-COPY(hFrombuffer,hRowObject:KEYS).  
  
      cDispValues = {fnarg colValues pcViewColList}.
    
     /* Finally the signature of this function serves some purpose as it allows 
         us to override the key values in the display even if they cannot be added 
         to the record. */
      DO iCol = 1 TO NUM-ENTRIES(hRowObject:KEYS):
        ASSIGN
          cColumn = ENTRY(iCol,hRowObject:KEYS)
          iPos    = LOOKUP(hRowObject:NAME + '.':U + cColumn,pcViewColList).
        IF iPos > 0 THEN
          ENTRY(iPos + 1,cDispValues,CHR(1)) = hFromBuffer:BUFFER-FIELD(cColumn):BUFFER-VALUE.
      END. /* do icol = 1 to */
    END.
  END. /* rowid <> ?  */

  IF VALID-HANDLE(hFromBuffer) THEN 
    DELETE OBJECT hFromBuffer NO-ERROR. 
  
  run rowChanged in target-procedure("different":U).
  
  RETURN cDispValues.

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
  DEFINE VARIABLE hDataQuery     AS HANDLE    NO-UNDO.
  DEFINE VARIABLE iCol           AS INTEGER   NO-UNDO.
  DEFINE VARIABLE iValue         AS INTEGER   NO-UNDO.
  DEFINE VARIABLE lAutoCommit    AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE lBrowsed       AS LOGICAL   NO-UNDO.  
  DEFINE VARIABLE lNextNeeded    AS LOGICAL   NO-UNDO INIT no.
  DEFINE VARIABLE lSuccess       AS LOGICAL   NO-UNDO INIT yes.
  DEFINE VARIABLE rDataQuery     AS ROWID     NO-UNDO.
  DEFINE VARIABLE rRowBefore     AS ROWID     NO-UNDO.
  DEFINE VARIABLE lUpdFromSource AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE lRepos         AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE cMsg           AS CHAR      NO-UNDO.
  DEFINE VARIABLE lNewDeleted    AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE iFirstResult   AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iLastResult    AS INTEGER    NO-UNDO.
  DEFINE VARIABLE hRowIdent      AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hContainer     AS HANDLE     NO-UNDO.
  DEFINE VARIABLE lQueryContainer AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE hBeforeBuffer   AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cRowObjectState AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cKeyWhere       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cBIKeyWhere     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDeleteMsg      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hDatasetSource  AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cDataTable      AS CHARACTER  NO-UNDO.

  &SCOPED-DEFINE xp-assign    
  {get RowObject hRowObject}
  {get DataHandle hDataQuery}
  {get DataQueryBrowsed lBrowsed}
  {get DatasetSource hDatasetSource}
  {get DataTable cDataTable}
  .
  &UNDEFINE xp-assign
       
  IF NOT VALID-HANDLE(hDatasetSource) THEN
    RETURN FALSE.

  /* Extract the RowObject ROWID from the RowIdent passed. If it's
     a valid ROWID and found in the Temp-Table, delete that row.
     If that entry isn't defined, then we're doing a delete for
     a query this object isn't managing. Create a RowObjUpd record
     for it (no data needed, just the RowIdent field) and delete it. */

  /* This includes ? which means delete current from 9.1B */
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
    
  lNewDeleted = hRowObject:ROW-STATE = ROW-CREATED.
  
  {get AutoCommit lAutoCommit}.
  {get QueryPosition cQueryPos}.  /* Were we on the first/last record? */
   

  /* If browsed we check whether the next record will be available 
      after deleteComplete. (implicit delete-current-row) */
  IF lBrowsed THEN 
  DO:
    /* @TODO future prodataset this must change if offend trigger is used   */
    hDataQuery:GET-NEXT.      
    lNextNeeded = hDataQuery:QUERY-OFF-END. 
    /* Back to Current */
    hDataQuery:GET-PREV.
  END.
  ELSE lNextNeeded = TRUE.
      
  cKeyWhere = {fn getKeyWhere}.
  cBIKeyWhere = DYNAMIC-FUNCTION('keyWhere' IN TARGET-PROCEDURE,
                                 hRowobject,hRowobject:BEFORE-BUFFER:NAME).
  
  lSuccess = DYNAMIC-FUNCTION('deleteRow':U IN hDatasetSource,
                              cDataTable, 
                              ckeyWhere).

  IF lSuccess AND lAutoCommit AND NOT lNewDeleted THEN 
  DO: 
    lSuccess = {fn submitData}.
    /* If there were no errors, delete the RowObject copy of the row. */
  END.  /* END DO IF AutoCommit */
  
  /* If the delete was successful, publish the event (for browse), 
     and figure out the new position and set properties accordingly */
  IF lSuccess THEN
  DO:
    /* This will result in a delete-current-row in the browser, which will
       make the prev or first record available.  */
    PUBLISH 'deleteComplete':U FROM TARGET-PROCEDURE. /* Tell Browser, e.g */
 
    /* If new deleted or not browsed then it will not become available 
       on the deletecomplete */      
    IF NOT hRowObject:AVAILABLE THEN
       hDataQuery:GET-NEXT.
    IF NOT hRowObject:AVAIL THEN
      hDataQuery:GET-PREV.

    /* If we deleted the first then this must now be the first record */
    IF hRowObject:AVAIL THEN
    DO:
      IF cQueryPos = 'FirstRecord':U THEN
        {set FirstRowNum INT(hRowObject:RECID)}.        
       /* If we deleted the last then this must now be the last record */
      IF cQueryPos = 'LastRecord':U THEN
        {set LastRowNum INT(hRowObject:RECID)}.              
    END.
    /* Last record deleted */
    ELSE DO:

      &SCOPED-DEFINE xp-assign
      {set FirstRowNum 0}        
      {set LastRowNum 0}
      .
      &UNDEFINE xp-assign
      
    END.

    /* If there is a Commit-Source, signal that a row has been changed. */
    IF NOT lAutoCommit THEN 
    DO:           
      cRowObjectState = 'RowUpdated':U.
      IF lNewDeleted THEN
      DO:
        /* If the new deleted was the only uncommitted change then
           set RowObjectState to 'NoUpdates' */
        hRowObject:BEFORE-BUFFER:FIND-FIRST() NO-ERROR.
        IF NOT hRowObject:BEFORE-BUFFER:AVAIL THEN 
           cRowObjectState = 'NoUpdates':U.
      END.
      PUBLISH "updateState":U FROM TARGET-PROCEDURE('delete':U).
      {set RowObjectState cRowObjectState}.
      lNextNeeded = FALSE. /* we don't need another batch (IZ 10746) */
    END.
    /* NextNeeded = false if the browse 'autopositioned', also if we deleted 
       the only or last record don't try to fetch another batch. */
    IF lNextNeeded AND {fnarg rowAvailable 'NEXT':U} AND NOT lNewDeleted THEN
      RUN fetchNext IN TARGET-PROCEDURE.
    ELSE 
      RUN rowChanged IN TARGET-PROCEDURE('different':U).   
  END.  /* IF Success  */
  ELSE DO:
    cDeleteMsg = {fnarg messageNumber 23}.
    RUN addMessage IN TARGET-PROCEDURE (cDeleteMsg,?,'').
    /* newdeleted can only be stopped at the actual delete */
    IF NOT lNewDeleted THEN
    DO:
      RUN processSubmitException IN TARGET-PROCEDURE.

      /* the record was deleted and the reincarnation must be added to the query */
      {fnarg  openDataQuery "'WHERE ':U + cKeyWhere"}.
      /* rowid has changed..currently used by visual objects
         possibly also new data from server */
      RUN rowChanged IN TARGET-PROCEDURE('RESET':U).   
    END.
  END.
  RETURN lSuccess.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-destroyView) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION destroyView Procedure 
FUNCTION destroyView RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose: Destroy the table definitions
    Notes: Separated out of destroyObject for design time re-creation             
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hDatasetSource   AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hContainerSource AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hQuery           AS HANDLE     NO-UNDO.
  DEFINE VARIABLE iTable           AS INTEGER    NO-UNDO.
  DEFINE VARIABLE hBuffer          AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cBufferHandles   AS CHARACTER  NO-UNDO.
  &SCOPED-DEFINE xp-assign
  
  {get DatasetSource hDatasetSource}
  {get ContainerSource hContainerSource}
  {get BufferHandles cBufferHandles}
  {get DataHandle hQuery}

  {set DataColumns '':U}
  {set UpdatableColumns ?} /* default (all blank is read-only) */
  {set DatasetSource ?}
  {set RowObject ?}
  {set QueryString '':U}
  {set QueryColumns '':U}
  {set DataQueryString '':U}
  {set Tables '':U}
  {set BufferHandles '':U}
  /* destroy and reinitialize is not really supported, but not prevented */
  {set ObjectInitialized FALSE}
  .
  &UNDEFINE xp-assign

  DO iTable = 1 TO num-entries(cBufferHandles):
    hBuffer = widget-handle(entry(iTable,cBufferHandles)).
    {fnarg destroyBuffer hBuffer hDatasetSource} no-error.
  END.

  DELETE OBJECT hQuery NO-ERROR.
 
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-findRowObjectUseRowIdent) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION findRowObjectUseRowIdent Procedure 
FUNCTION findRowObjectUseRowIdent RETURNS LOGICAL
  ( INPUT pcRowIdent AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Repositions the query to the desired row, based on the corresponding
            record rowid (specified by pcRowIdent). If that row is found in the
            DataTable, it repositions the query to that row.

  Parameters:
              INPUT pcRowIdent   - string rowid of the DataTable temp-table.

  Notes:  Does not publish the change and will typically not work very well as
          an external separate command to position a DataView. (Use findRow or
          findRowWhere for repositioning)   

      -   ROWIDs are reused so there is also a risk of finding wrong data if
          used incorrectly, for example after a failed delete.
      -   This API exists to allow visual objects that used this to reposition
          SDOs to work against DataViews. 
      -   The Dataview’s RowIdent is currently a string of the temp-table ROWID,
          so there is no difference between this and repositionRowObject.
          (The two functions are different in SDOs)   
------------------------------------------------------------------------------*/
  {fnarg repositionRowObject pcRowIdent}.
  RETURN TRUE.   /* Function return value. */

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
       pcColumns   - Qualified column names (Comma separated)                    
       pcValues    - corresponding Values (CHR(1) separated)
       pcOperators - Operator - one for all columns
                                - blank - defaults to (EQ)  
                                - Use slash to define alternative string operator
                                  EQ/BEGINS etc..
                              - comma separated for each column/value
         pcMode     - FIRST
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
 DEFINE VARIABLE hRowObject     AS HANDLE     NO-UNDO.
 DEFINE VARIABLE hDataQuery     AS HANDLE     NO-UNDO.
 DEFINE VARIABLE rRowid         AS ROWID      NO-UNDO.
 DEFINE VARIABLE iFirstRowNum   AS INTEGER    NO-UNDO.
 DEFINE VARIABLE iLastRowNum    AS INTEGER    NO-UNDO.
 DEFINE VARIABLE cEqualColumns  AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE lDefinite      AS LOGICAL    NO-UNDO.
 DEFINE VARIABLE rCurrent       AS ROWID      NO-UNDO.
 DEFINE VARIABLE cDataTable     AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE iBuffer        AS INTEGER    NO-UNDO.
 DEFINE VARIABLE hBuffer        AS HANDLE     NO-UNDO.
 DEFINE VARIABLE hDatasetSource AS HANDLE     NO-UNDO.
 DEFINE VARIABLE cRowids        AS CHARACTER  NO-UNDO.

 {get DataHandle hDataQuery}.

 IF NOT VALID-HANDLE(hDataQuery) THEN
   RETURN ?.
 ELSE IF hDataQuery:IS-OPEN = FALSE THEN
   RETURN ?.
 
 IF pcColumns = '':U OR pcColumns = ? THEN
   RETURN NO.

 &SCOPED-DEFINE xp-assign  
 {get FirstRowNum iFirstRowNum}
 {get LastRowNum iLastRowNum}
 {get DataTable cDataTable}
 .
 &UNDEFINE xp-assign
  
 IF pcMode <> 'FIRST':U THEN
 DO:
   MESSAGE 
      SUBSTITUTE({fnarg messageNumber 58}, "findRowObjectWhere()", pcMode) SKIP       
      VIEW-AS ALERT-BOX ERROR.

   RETURN ?.
 END.

 /* This loop is just to identify the operators 
    (The pcoperators parameter supports some weird cases...) */
 DO iColumn = 1 TO NUM-ENTRIES(pcColumns):   
   RUN obtainExpressionEntries IN TARGET-PROCEDURE
         (cDataTable,
          iColumn,
          pcColumns,
          pcValues,
          pcOperators,
          OUTPUT cColumn, 
          OUTPUT cOperator,
          OUTPUT cValue). 
   
   IF cColumn > '':U AND cColumn BEGINS cDataTable + '.':U THEN
   DO:
     /* Build a list of the columns that has equality operators to check
        against the index information to decide whether the request can be 
        resolved on the client. */ 
     IF CAN-DO('=,EQ':U,cOperator) THEN 
       cEqualColumns = cEqualColumns
                     + (IF cEqualcolumns = '' THEN '' ELSE ',')
                     + cColumn.
   END. /* cColumn > '' */
 END. /* pcColumn loop */

 /* The request cannot be resolved on the client, if the first record of the 
    current query is not here and no equality match is used */ 
 IF iFirstRowNum = ? AND cEqualColumns = '':U THEN
   RETURN ?.
 
 {get QueryString cQueryString}.
 
 cQueryString = DYNAMIC-FUNCTION('newQueryString':U IN TARGET-PROCEDURE,
                                  pcColumns,
                                  pcValues,
                                  pcOperators,
                                  cQueryString,
                                  'AND':U). 
 {get RowObject hRowObject}.
 rCurrent = hRowObject:ROWID.
 /** pcMode = 'last' is not supported, returned with error message above */ 
 cRowids = {fnarg firstRowids cQueryString}. 

 lOk = (cRowids <> ?).
 
 /* if we have first and last or found something then the answer is definite */
 IF iFirstRownum <> ? AND (lOk OR iLastRowNum <> ?) THEN
   lDefinite = TRUE.
 /* else if we have found something with equality match then we have 
    a definite answer if a unique index is used 
    (the check for equalcolumns blank and unknown first is already done, so
     could be avoided here) */    
 ELSE IF lOk AND cEqualColumns > '' THEN
 DO:
   {get DatasetSource hDatasetSource}.
   lDefinite = DYNAMIC-FUNCTION('isUniqueId':U IN hDatasetSource,
                                cEqualColumns,cDataTable). 
 END. /* else (record was found, but columns need to be checked against index)*/

 /* If the request can be resolved on the client and we have a record then
    position the sdo's query to it */ 
 IF lDefinite AND lOk THEN 
 DO:
   /* the datatable is unique so we only need the first rowid if joined */
   rRowId = TO-ROWID(ENTRY(1,cRowids)).
   lOK = hDataQuery:REPOSITION-TO-ROWID(rRowid) NO-ERROR.  
   /* Repos only makes rec avail if browsed  */
   IF lOK AND NOT hRowObject:AVAIL THEN    
     hDataQuery:GET-NEXT().  
 END.
 ELSE  /* keep current record avail if not found */ 
   hRowObject:FIND-BY-ROWID(rCurrent) NO-ERROR.
 
 /* If definite then return yes or no (found or not) otherwise returm ?   */
 RETURN IF lDefinite THEN lOK ELSE ?. 

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
       pcColumns   - Qualified column names (Comma separated)                    
       pcValues    - corresponding Values (CHR(1) separated)
       pcOperators - Operator - one for all columns
                                - blank - defaults to (EQ)  
                                - Use slash to define alternative string operator
                                  EQ/BEGINS etc..
                              - comma separated for each column/value                                                     
---------------------------------------------------------------------------*/
  DEFINE VARIABLE cColumn          AS CHAR       NO-UNDO.
  DEFINE VARIABLE lOnClient        AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cQueryString     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hDataReadHandler AS HANDLE     NO-UNDO.
  DEFINE VARIABLE lQueryOpen       AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lParentOpen      AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lBrowsed         AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cTable           AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iTable           AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cSortTables      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cTableWhere      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cPosition        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hDataSource      AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cDatasetName     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cRowid           AS CHARACTER  NO-UNDO.
  
  IF {fn getScrollable} = FALSE THEN
  DO:
    {get DataQueryBrowsed lBrowsed}.
    IF NOT lBrowsed THEN
      RETURN DYNAMIC-FUNCTION('findUniqueRowWhere':U IN TARGET-PROCEDURE,
                               pcColumns,
                               pcValues,
                               pcOperators).  
    
  END.
  
  /* Don't search onclient if QueryOpen is false */   
  {get QueryOpen lQueryOpen}.
  /* if query is open check if the record already is on the client
    (Returns unknown if the request cannot be resolved on client) 
     No =  enough info to know record does not exist ) */
  
  lOnClient = ?. 
  IF lQueryOpen THEN 
    lOnCLient = DYNAMIC-FUNCTION('findRowObjectWhere':U IN TARGET-PROCEDURE,
                                  pcColumns,
                                  pcValues,
                                  pcOperators,
                                  'First':U).  
  /* ? means cannot be resolved on client */ 
  IF lOnClient = ? THEN
  DO:
    /* Add find criteria to default query as we don't want/need to include 
       querystring in server position request */
    cQueryString = DYNAMIC-FUNCTION('newQueryString':U IN TARGET-PROCEDURE,
                                     pcColumns,
                                     pcValues,
                                     pcOperators,
                                     {fn getQueryStringDefault},
                                     ?).
    {get QueryTables cSortTables}.

    /* Remove sort criteria and secondary tables if not searched */ 
    DO iTable = 1 TO NUM-ENTRIES(cSortTables):
      cTable = ENTRY(iTable,cSortTables).
      /* Only pass secondary tables if explicitly in the query expression  */
      IF iTable = 1 
      OR INDEX(',':U + pcColumns,',':U + cTable + '.':U) > 0 THEN
        ASSIGN 
          cPosition = cPosition 
                    + (IF iTable = 1 THEN '':U ELSE ',':U)
                    + DYNAMIC-FUNCTION('bufferWhereClause':U IN TARGET-PROCEDURE,
                                        cTable,
                                        cQueryString).
    END. /* DO iTable = 1 TO NUM-ENTRIES(cSortTables) */

    cPosition = SUBSTRING(cPosition,INDEX(cPosition,' WHERE ':U) + 1).
    
    DYNAMIC-FUNCTION('retrieveData':U IN TARGET-PROCEDURE,
                      cPosition,
                      NOT lQueryOpen, /* don't refresh if open */
                      ?).

    ASSIGN 
      /* Get the current query + find criteria 
         The QueryString we had from above is not sufficient in all cases as 
         we need the sort to be correct and also include the foreign 
         key to be sure to not find wrong record. (Even if a child 
         request should not be issued to server when DataIsFetched is true,
         could also be a problem if the server returned too much data for 
         some reason) */
      cQueryString = DYNAMIC-FUNCTION('newQueryString':U IN TARGET-PROCEDURE,
                                         pcColumns,
                                         pcValues,
                                         pcOperators,
                                         ?, /* default= querystring */
                                         ?)   
           
      /*  first rowid is sufficent for position as DataTable is unique*/
      cRowid = ENTRY(1,{fnarg firstRowids cQueryString}).
      
    IF cRowid <> ? THEN
      lOnClient = {fnarg openDataQuery cRowid}.
    
    {get DataQueryBrowsed lBrowsed}.
    IF lBrowsed THEN
      PUBLISH 'fetchDataSet':U FROM TARGET-PROCEDURE ('BatchEnd':U).
      
  END. /* lOnClient = ? */
  
  /* Signal change also when find failed, as foreignvalues of children 
     has been set to unknown in buildDatarequest and need to be reset.
     (mainly because dataAvailable uses unknown as fetchedbyparent signal) */  
  RUN rowChanged IN TARGET-PROCEDURE ('RESET':U).

  RETURN IF lOnCLient THEN TRUE ELSE FALSE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-findUniqueRowWhere) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION findUniqueRowWhere Procedure 
FUNCTION findUniqueRowWhere RETURNS LOGICAL
  (pcColumns     AS CHARACTER,   
   pcValues      AS CHARACTER,    
   pcOperators   AS CHARACTER):
/*------------------------------------------------------------------------------   
Purpose: Find and reposition to a row in the client DataTable  
Parameters: 
       pcColumns   - DataTable column names (Comma separated)                    
       pcValues    - corresponding Values (CHR(1) separated)
       pcOperators - Operator - one for all columns
                                - blank - defaults to (EQ)  
                                - Use slash to define alternative string operator
                                  EQ/BEGINS etc..
                              - comma separated for each column/value
 Notes:  Intended for non scrollable DataViews. 
       - Called from findRowwhere when not scrollable. 
       - Does not call service.                                               
---------------------------------------------------------------------------*/
 DEFINE VARIABLE cColumn    AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cOperator  AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE iColumn    AS INTEGER    NO-UNDO.
 DEFINE VARIABLE cDataTable AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cValue     AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cWhere     AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE hRowObject AS HANDLE     NO-UNDO.
 DEFINE VARIABLE lFound     AS LOGICAL    NO-UNDO.

 &SCOPED-DEFINE xp-assign
 {get DataTable cDataTable}
 {get RowObject hRowObject}
   .
 &UNDEFINE xp-assign

 IF NOT VALID-HANDLE(hRowObject) THEN
   RETURN FALSE.

 DO iColumn = 1 TO NUM-ENTRIES(pcColumns):             
   /* get the column, operator and correctly quoted value from the lists 
     if it maps to the DataTable. */  
   RUN obtainExpressionEntries IN TARGET-PROCEDURE
                         (cDataTable,
                          iColumn,
                          pcColumns,
                          pcValues,
                          pcOperators,
                          OUTPUT cColumn, 
                          OUTPUT cOperator,
                          OUTPUT cValue).
   IF cColumn = '':U THEN
   DO:
     MESSAGE 
       "Invalid column reference '" + entry(iColumn,pcColumns) + "'passed to findUniqueRowWhere().".
     RETURN FALSE.
   END.
       
   cWhere = cWhere 
          + (IF cWhere = "":U THEN "WHERE ":U ELSE " AND ":U)
          + cColumn 
          + " ":U
          + cOperator
          + " ":U
          + cValue.
 END. /* do iColumn = 1 to num-entries(pColumns) */        

 lFound = hRowObject:FIND-UNIQUE(cWhere) NO-ERROR.
 RUN rowChanged IN TARGET-PROCEDURE('RESET':U).

 RETURN lFound.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getAuditEnabled) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getAuditEnabled Procedure 
FUNCTION getAuditEnabled RETURNS LOGICAL
  (  ) :
/*------------------------------------------------------------------------------
  Purpose: Indicates whether auditing is enabled. 
           Used in Audit Action EnableRules to enable the Audit action in a 
           toolbar.
    Notes:  (Hardcoded to FALSE in DataView as it doesn't have default support
             for Auditing)    
------------------------------------------------------------------------------*/

  RETURN FALSE.   

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getAutoCommit) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getAutoCommit Procedure 
FUNCTION getAutoCommit RETURNS LOGICAL
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns a flag indicating whether a Commit happens on every 
            Record update.
   Params:  <none>
   Notes:
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hSource         AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hDatasetSource1 AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hDatasetSource2 AS HANDLE     NO-UNDO.
  DEFINE VARIABLE lAuto           AS LOGICAL    NO-UNDO.

  &SCOPED-DEFINE xpAutoCommit
  {get AutoCommit lAuto}.
  &UNDEFINE xpAutoCommit
  
  IF lAuto THEN
  DO:
    &SCOPED-DEFINE xp-assign
    {get DataSource hSource}
    {get DatasetSource hDatasetSource1}
     .
    &UNDEFINE xp-assign
    
    IF VALID-HANDLE(hSource) THEN 
    DO:
      /* datasetsource no-error, in case "wrong" type datasource */ 
      {get DatasetSource hDatasetSource2 hSource} NO-ERROR.
      IF hDatasetsource1 = hDatasetsource2 THEN 
        RETURN {fn getAutoCommit hSource}.
    END.
  END.
  RETURN lAuto.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getBusinessEntity) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getBusinessEntity Procedure 
FUNCTION getBusinessEntity RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose: The Business Entity that provides data to and accepts data from 
           the DataView.  
    Notes: This is a logical name that identifies the Busines Entity in the 
           Service. The actual realization of the Business Entity is the 
           responsibility of the Service and is irrelevant for the ADM. 
           It is, however, expected that the Service Adapter who handles 
           all ADM requests to the service is using a prodataset as the 
           data transport medium.    
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cBusinessEntity AS CHARACTER  NO-UNDO.
  {get BusinessEntity cBusinessEntity}.
  RETURN cBusinessEntity. 

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDataContainerHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getDataContainerHandle Procedure 
FUNCTION getDataContainerHandle RETURNS HANDLE
  ( ) :
/*------------------------------------------------------------------------------
  Purpose: Returns the datacontainer that handles all data requests.  
    Notes:  
------------------------------------------------------------------------------*/
  IF NOT VALID-HANDLE(ghDataContainer) THEN
        ghDataContainer = {fnarg getManagerHandle 'DataContainer':U}.
  
  RETURN ghDataContainer.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDatasetName) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getDatasetName Procedure 
FUNCTION getDatasetName RETURNS CHARACTER
  ( ) :
/*------------------------------------------------------------------------------
  Purpose:  Get the instance name of the object's DatasetSource.
   Params:  <none>
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cName AS CHARACTER NO-UNDO.
  {get DatasetName cName}.
  RETURN cName.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDatasetSource) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getDatasetSource Procedure 
FUNCTION getDatasetSource RETURNS HANDLE
  ( ) :
/*------------------------------------------------------------------------------
  Purpose: Returns the handle of the object's DatasetSource.
   Params:  <none>
    Notes: The DatasetSource is a procedure that encapsulates all access
           to the prodataset that holds the data for the DataView. 
         - There is currently no Dataset link, but the name -source is used 
           intentionally in the anticipation of a true link.     
------------------------------------------------------------------------------*/

  DEFINE VARIABLE hSource AS HANDLE NO-UNDO.
  {get DatasetSource hSource}.
  RETURN hSource.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDataTable) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getDataTable Procedure 
FUNCTION getDataTable RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cDataTable AS CHARACTER  NO-UNDO.
  {get DataTable cDataTable}.
  RETURN cDataTable. 

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getForeignFields) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getForeignFields Procedure 
FUNCTION getForeignFields RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:     Returns the property which holds the mapping of field's in 
               another DataSource to fields in this SMartDataObject's RowObject 
               temp-table, to open a dependent query.
  
  Parameters:  <none>
  
  Notes:       The property format is a comma-separated list, consisting of the
               first local db fieldname, followed by the matching source 
               temp-table field name, followed by more pairs if there is more 
               than one field to match.
------------------------------------------------------------------------------*/
DEFINE VARIABLE cFields             AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cDatasetName        AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cParentDatasetName  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cDataTable          AS CHARACTER  NO-UNDO.
DEFINE VARIABLE hDataSource         AS HANDLE     NO-UNDO.

  &SCOPED-DEFINE xpForeignFields
  {get ForeignFields cFields}.
  &UNDEFINE xpForeignFields
  
  IF cFields = ? OR cFields = '' THEN
  DO:
    {get DataSource hDataSource}.
    IF VALID-HANDLE(hdataSource) THEN
    DO:
      &SCOPED-DEFINE xp-assign
      {get DataTable cDataTable}
      {get DataSetName cDataSetName}
      .
      &UNDEFINE xp-assign
      {get DatasetName cParentdatasetName hDataSource} NO-ERROR.
      IF cDataSetName = cParentdatasetName THEN
         cFields = {fnarg childForeignFields cDataTable hDataSource}.

    END.
    IF cFields > '':U THEN
       &SCOPED-DEFINE xpForeignFields
      {set ForeignFields cFields}.
       &UNDEFINE xpForeignFields
  END.

  RETURN cFields.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getHasFirst) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getHasFirst Procedure 
FUNCTION getHasFirst RETURNS LOGICAL
  (  ) :
/*------------------------------------------------------------------------------
  Purpose: Returns true if the first record of the resultset is present  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hDatasetSource AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cDataTable     AS CHARACTER  NO-UNDO.

  &SCOPED-DEFINE xp-assign
  {get DatasetSource hDatasetSource}
  {get DataTable cDataTable}.
  &UNDEFINE xp-assign

  IF VALID-HANDLE(hDatasetSource) THEN
    RETURN {fnarg tablePrevContext cDataTable hDatasetSource} = ''.

  RETURN ?.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getHasLast) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getHasLast Procedure 
FUNCTION getHasLast RETURNS LOGICAL
  (  ) :
/*------------------------------------------------------------------------------
  Purpose: Returns true if the last record of the resultset is present  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hDatasetSource AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cDataTable     AS CHARACTER  NO-UNDO.

  &SCOPED-DEFINE xp-assign
  {get DatasetSource hDatasetSource}
  {get DataTable cDataTable}.
  &UNDEFINE xp-assign

  IF VALID-HANDLE(hDatasetSource) THEN
    RETURN {fnarg tableNextContext cDataTable hDatasetSource} = ''.

  RETURN ?.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getIndexInformation) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getIndexInformation Procedure 
FUNCTION getIndexInformation RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose: Return indexinFormation formatted as the 4GL index-information 
           attribute, but with RowObject column names and chr(1) as index 
           separator and chr(2) as table separator.  
    Notes: - Intended for internal use by other index info functions, which uses 
             this as input to indexInformation(). 
           - Unmapped columns are returned fully qualifed!      
           - This property can be used as input parameter to indexInformation() 
             for further refinement.
           - If the property is ? it calls the indexInformation() in query.p
             and stores the returned value for future calls.              
           - If a similar list with database fields are needed use 
             indexInformation() directly (if connected)             
------------------------------------------------------------------------------*/
  /*
  &SCOPED-DEFINE xpIndexInformation
  {get IndexInformation cInfo}.
  &UNDEFINE xpIndexInformation
  */
  RETURN DYNAMIC-FUNCTION('indexInformation':U IN TARGET-PROCEDURE,
                          'Info(1)', /* info for table  */
                           NO,       /* table separator (no field qualifier) */
                           ?).      /* Use query data */
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getKeyFields) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getKeyFields Procedure 
FUNCTION getKeyFields RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the comma-separated KeyFields property.
   Params:                                        
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hRowObject AS HANDLE NO-UNDO.
  {get RowObject hRowObject}.
  IF VALID-HANDLE(hRowObject) THEN
  DO:
    IF hRowObject:KEYS = 'ROWID':U THEN
      RETURN ''.

    RETURN hRowObject:KEYS.
  END.
  RETURN ?.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getKeyTableId) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getKeyTableId Procedure 
FUNCTION getKeyTableId RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose: The KeyTableId identifies the table for runtime access to related 
           data where the table is part of the foreign key 
           (auditing and comments ).
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cBusinessEntity AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDataTable      AS CHARACTER  NO-UNDO.
  
  &SCOPED-DEFINE xp-assign
  {get BusinessEntity cBusinessEntity}
  {get DataTable cDataTable}.
  &UNDEFINE xp-assign

  RETURN cBusinessEntity + '.':U + cDataTable.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getKeyWhere) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getKeyWhere Procedure 
FUNCTION getKeyWhere RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose: Returns where string with criteria uniquely identifying current 
           record   
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hRowObject AS HANDLE     NO-UNDO.
  {get RowObject hRowObject}.
  IF VALID-HANDLE(hRowObject) AND hRowObject:AVAIL THEN
    RETURN DYNAMIC-FUNCTION('keyWhere':U IN TARGET-PROCEDURE,hRowObject,'':U).
  ELSE
    RETURN '':U.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getNewMode) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getNewMode Procedure 
FUNCTION getNewMode RETURNS LOGICAL
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:     Returns TRUE if the current RowObject record is in new mode, 
               which is the same as the Object is in NewMode.   
              - (an add or a copy of an existing record has NOT been saved)                   
               Returns ? if there is no current RowObject.
  Parameters:  <none>  
  Notes:       The difference from getNewRow is that it returns true for any 
               saved and uncommitted new record and thus cannot be used
               to check whether we are in Add Mode.
               This uses the RowMod field in the Temp-Table to see if the 
               row's new (just as getNewRow) and in addition checks to see
               if the RowObjUpd is not valid or not avail, which indicates that 
               this has not been saved. 
               We do some double checking if a rowObjUpd is avail to ensure 
               that this is the right one.                 
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hRowObject  AS HANDLE     NO-UNDO.
  DEFINE VARIABLE rRowid      AS ROWID      NO-UNDO.

  {get RowObject hRowObject}.
  
  IF VALID-HANDLE(hRowObject) AND hRowObject:AVAILABLE 
  AND hRowObject:ROW-STATE = ROW-CREATED THEN
  DO:
    /* Stores current rec on add in order to repos on cancel and can 
       be used a newmode since it is set to "Ox" which is blank if no record 
       was avail on add and set to unknown on save and cancel  */
    {get CurrentRowid rRowid}.
    RETURN STRING(rRowid) <> ?. 
  END.

  RETURN FALSE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getNewRow) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getNewRow Procedure 
FUNCTION getNewRow RETURNS LOGICAL
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:     Returns TRUE if the current RowObject record is new - (an added
               record or a copy of an existing record has never been submitted 
               to the service)  

  Parameters:  <none>
  
  Notes:       This uses the RowMod field in the Temp-Table to see if the 
               row's new.
------------------------------------------------------------------------------*/

  DEFINE VARIABLE hRowObject AS HANDLE NO-UNDO.
  DEFINE VARIABLE hColumn    AS HANDLE NO-UNDO.
  
  {get RowObject hRowObject}.
  IF NOT VALID-HANDLE(hRowObject) OR NOT hRowObject:AVAILABLE THEN
    RETURN FALSE.

  RETURN hRowObject:ROW-STATE = ROW-CREATED. 
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getQueryOpen) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getQueryOpen Procedure 
FUNCTION getQueryOpen RETURNS LOGICAL
  (  ) :
/*------------------------------------------------------------------------------
    Purpose:  Returns TRUE if the Query is currently open.
 Parameters:  <none>
      Notes: 
----------------------------------------------------------------------------*/    
  DEFINE VARIABLE hDataQuery  AS HANDLE     NO-UNDO.
  
  {get DataHandle hDataQuery}.
  RETURN IF NOT VALID-HANDLE(hDataQuery) 
         THEN NO 
         ELSE hDataQuery:IS-OPEN.   

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getQueryStringDefault) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getQueryStringDefault Procedure 
FUNCTION getQueryStringDefault RETURNS CHARACTER
  (   ) :
/*------------------------------------------------------------------------------
  Purpose: Used to initiate or reset the QueryString, which defines the 
           query at runtime.
           Separates the logic to initiate the QueryString out of various
           query manipulation methods. 
    Notes: This allows the Dataview class to implement query manipulation 
           method that can be used by the data class.
        -  May be referenced before the dataset is retrieved and created.
           The DataQueryString may be set at design time to capture that 
           more than one table is in the sort and defines the base for 
           this function. 
        -  If the DataQueryString is not set the value is resolved from the 
           dataset using QueryTables or just from the datatable if no dataset. 
        -  QueryTables has similar logic using Tables as the design time storage
           and using the dataset for default. 
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cDataTable       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cQueryTables     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDataQueryString AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hDatasetSource   AS HANDLE     NO-UNDO.

  {get DataQueryString cDataQueryString}. 
  IF cDataQueryString > '':U THEN
    RETURN cDataQueryString.
  
  &SCOPED-DEFINE xp-assign
  {get DataTable cDataTable}
  {get QueryTables cQueryTables} 
  {get DatasetSource hDatasetSource}
  . 
  &UNDEFINE xp-assign
  
  /* The default dataset resolution cannot be used after initialization 
     as data then already has been retrieved using only the datatable. */
  IF VALID-HANDLE(hDatasetSource) AND NUM-ENTRIES(cQueryTables) > 1 THEN
    RETURN {fnarg dataQueryString cQueryTables hDatasetSource}.
  
  RETURN 'FOR EACH ':U + cDataTable. 

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getQueryTables) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getQueryTables Procedure 
FUNCTION getQueryTables RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose: Returns the tables that are (to be) used in the query and that
           can be used in sorting, filtering and browsing.             
    Notes: May be referenced before the dataset is retrieved and created.
         - The DataTable is always the first entry and all the other tables have 
           a many-to-one (or one-to-one) relationship to the DataTable.
         - The QueryTables may not include all ViewTables, but is always 
           included in ViewTables. 
         - The default difference is that it does not include the parent of a 
           one-to-many relation. 
         - Tables that cannot be inner-joined should not be included due to 
           a core 4GL limitation that makes get-last and reposition unusable
           on queries with outer-joins.
           The user can define the QueryTables at designtime. The result is 
           stored in the DataQueryString, from which this function resolves
           the tables again if the query is not yet defined.  
         - The dataset resolves the default if the handle and querystring is 
           not yet defined. (The DataTable is returned if not dataset exists).
         - Used in query manipulation   
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hQuery         AS HANDLE     NO-UNDO.
  DEFINE VARIABLE iTable         AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cTables        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cViewTables    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDataTable     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hDatasetSource AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cQueryString   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cChild         AS CHARACTER  NO-UNDO.

  {get DataHandle hQuery}.
  IF VALID-HANDLE(hQuery) AND hQuery:NUM-BUFFERS > 0 THEN
  DO: 
    DO iTable = 1 TO hQuery:NUM-BUFFERS: 
      cTables = cTables 
              + (IF cTables = '' THEN  '' ELSE ',')
              + hQuery:GET-BUFFER-HANDLE(iTable):NAME.
    END.
    RETURN cTables.
  END.
  
  /* Design-time querytable and sort definitions are stored in the 
     dataquerystring so resolve tables from that if it is defined */
  &SCOPED-DEFINE xp-assign
  {get DataQueryString cQueryString} 
  {get DataTable cDataTable}
  .
  &UNDEFINE xp-assign

  IF cDataTable > '' THEN 
  DO:
    IF cQueryString > '' THEN
    DO: 
      cTables = cDataTable.
      DO iTable = 2 TO NUM-ENTRIES(cQueryString):
        ASSIGN
          cChild  = ENTRY(iTable,cQueryString)
          cChild  = {fnarg whereClauseBuffer cChild}
          cTables = cTables 
                  + ','
                  + cChild.
      END.
      RETURN cTables.
    END. 
    
    /* Allow query to be undefined (important for designtime)
       The default dataset resolution cannot be used after initialization 
       as data then already has been retrieved using only the datatable.  */
    &SCOPED-DEFINE xp-assign
    {get ViewTables cViewTables}
    {get DataSetSource hDatasetSource}
    .
    &UNDEFINE xp-assign
    
    /* Allow querytables to be undefined (important for designtime) 
       A single ViewTables is the DataTable, so use default below as 
       queryTables must be in viewtables (A singe entry could be 
       default, but could also be override of default)  */
    IF VALID-HANDLE(hDatasetSource) AND NUM-ENTRIES(cViewTables) > 1 THEN
      RETURN {fnarg sortTables cDataTable hDatasetSource}.   
    ELSE 
      RETURN cDataTable.
  END.

  RETURN cDataTable. 

 END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getRequestHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getRequestHandle Procedure 
FUNCTION getRequestHandle RETURNS HANDLE
  (  ) :
/*------------------------------------------------------------------------------
  Purpose: Return the procedure handle that defines the scope of service 
           requests for this the object. 
    Notes: This is passed to the DataContainer to identify the requestor, 
           and will typically be resolved by the container's getRequestHandle, 
           which searches through parent container's to resolve this.            
        -  Returns the Dataview's own handle if no container is present or the 
           container's RequestHandle is ? because it cannot handle the request 
           either because it already is initialized or not defined to be a 
           data container.  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hContainerSource AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hRequestor       AS HANDLE     NO-UNDO.

  {get ContainerSource hContainerSource}.
  IF VALID-HANDLE(hContainerSource) THEN
  DO:
    {get RequestHandle hRequestor hContainerSource}.
    IF VALID-HANDLE(hRequestor) THEN
      RETURN hRequestor.
  END.

  RETURN TARGET-PROCEDURE.  

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getResortOnSave) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getResortOnSave Procedure 
FUNCTION getResortOnSave RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose: Decides whether to resort (reopen) the clcient query on save of row
            Yes - Resort and reopen the client query on save of a row. 
            No  - Do not resort on save of row.
    Notes: This applies to both AutoCommit and non-AutoCommit sources, but may 
           require an additional server request if the datasource is batching 
           and is thus ignored if batching and AutoCommit is set to false.  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE lResortOnSave AS LOGICAL    NO-UNDO.
  {get ResortOnSave lResortOnSave}.

  RETURN lResortOnSave.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getRowident) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getRowident Procedure 
FUNCTION getRowident RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose: Returns a unique identifier for current record  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hRowObject AS HANDLE     NO-UNDO.
  DEFINE VARIABLE iCol       AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cColumn    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cValues    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cKeys      AS CHARACTER  NO-UNDO.

  {get RowObject hRowObject}.
  /* @TODO future : possibly remove rowid dependency   
  IF hRowObject:AVAIL THEN
  DO:
    cKeys = hRowObject:KEYS.
    IF cKeys <> 'ROWID':U THEN 
    DO iCol = 1 TO NUM-ENTRIES(cKeys):
      cValues = cValues 
              + CHR(1)
              + hRowObject:BUFFER-FIELD(ENTRY(iCol,cKeys)):BUFFER-VALUE.    
    END.
    ELSE
      cValues = STRING(hRowObject:ROWID).
  END. /* avail */
  ELSE  
    cValues = ?.
  */  

  RETURN STRING(hRowObject:rowid). 

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getRowObjectState) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getRowObjectState Procedure 
FUNCTION getRowObjectState RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:     Signals whether there are uncommitted updates in the commit/submit
               scope of this object.
               Returns 'RowUpdated' if changesexists OR 'NoUpdates' if there are 
               no changes.
  Parameters:  <none>
  Note:        The two possible return values are: 'NoUpdates' and 'RowUpdated'
             - As of current we do not store the value, but resolve it from the 
               dataset, since this is also defines the commit scope.
               We would need to store it if we ever wanted to allow the UI to 
               commit changes from several datasets though. We also need to 
               store it when/if we support no dataset TT based Dataviews.
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cDataTable     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hDataSetSource AS HANDLE     NO-UNDO.
  DEFINE VARIABLE lAutoCommit    AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lHasChanges    AS LOGICAL    NO-UNDO.

  &SCOPED-DEFINE xp-assign
  {get DataTable cDataTable}
  {get DatasetSource hDatasetSource}
  {get AutoCommit lAutoCommit}
  .
  &UNDEFINE xp-assign
  
  IF NOT lAutoCommit AND VALID-HANDLE(hDatasetSource) THEN
    lHasChanges = {fnarg hasChanges cDataTable hDatasetSource}.
  
  /* not currently in use 
  &SCOPED-DEFINE xpRowObjectState
  {get RowObjectState cState}.
  &UNDEFINE xpRowObjectState
  */

  RETURN IF lHasChanges THEN 'RowUpdated':U ELSE 'NoUpdates':U.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getRowParentChanged) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getRowParentChanged Procedure 
FUNCTION getRowParentChanged RETURNS LOGICAL
  (  ) :
/*------------------------------------------------------------------------------
  Purpose: Returns true if the datasource key is changed
    Notes: 
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hRowObject         AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cForeignFields     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cForeignValues     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cOldValue          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cCurrentValue      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iField             AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cField             AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hField             AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hDataSource        AS HANDLE     NO-UNDO.
  
  {get RowObject hRowObject}.
  IF hRowObject:AVAIL = FALSE THEN 
    RETURN ?.
    
  &SCOPED-DEFINE xp-assign
  {get DataSource hDataSource}
  {get ForeignFields cForeignFields}
  {get ForeignValues cForeignValues}
  .
  &UNDEFINE xp-assign
  
  /* if there's no datasource then the foreignvalues does not matter */  
  IF VALID-HANDLE(hDataSource) THEN 
  DO:  
    DO iField = 1 TO NUM-ENTRIES(cForeignValues,CHR(1)):
      assign    /* local name is 1st of pair */       
        cField        = ENTRY((iField * 2) - 1,cForeignFields)
        cOldValue     = ENTRY(iField,cForeignValues,CHR(1))
        cCurrentValue = {fnarg columnValue cField}. 
      IF NOT COMPARE(cOldValue,"EQ":U,cCurrentValue,"RAW":U) THEN 
        RETURN TRUE.
    END. /* do ifield to num foreignvalues  */
  END. /* valid source */
  
  RETURN FALSE.  

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getRowUpdated) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getRowUpdated Procedure 
FUNCTION getRowUpdated RETURNS LOGICAL
  (  ) :
/*------------------------------------------------------------------------------
 Purpose:     Returns TRUE if the current record is saved, but not submitted 
              to the service
  Parameters:  <none>
  
  Notes:        
------------------------------------------------------------------------------*/

  DEFINE VARIABLE hRowObject AS HANDLE NO-UNDO.
  
  {get RowObject hRowObject}.
  IF NOT VALID-HANDLE(hRowObject) OR NOT hRowObject:AVAILABLE THEN
    RETURN FALSE.

  IF hRowObject:ROW-STATE = ROW-MODIFIED THEN
    RETURN TRUE.
  
  /* new is considered modified after save (NOT new mode) */
  IF hRowObject:ROW-STATE = ROW-CREATED THEN
    RETURN NOT {fn getNewMode}. 

  RETURN FALSE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getScrollable) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getScrollable Procedure 
FUNCTION getScrollable RETURNS LOGICAL
  (  ) :
/*------------------------------------------------------------------------------
  Purpose: Tells whether the object has scrollable data.    
    Notes: This is currently decided by the dataset relationship, but  
           can be overridden by a request for all data for the specific 
           table in which case isDataquerycomplete will be true.            
         - Returns unknown if called before definitions are retrieved. 
------------------------------------------------------------------------------*/  
  DEFINE VARIABLE hDatasetSource AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cDataTable     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lFirst         AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lLast          AS LOGICAL    NO-UNDO.

  &SCOPED-DEFINE xp-assign
  {get DatasetSource hDatasetSource}
  {get DataTable cDataTable}
  {get HasFirst lFirst}
  {get HasLast lLast}
  . 
  &UNDEFINE xp-assign
  
  IF lFirst OR lLast THEN
    RETURN TRUE.

  IF VALID-HANDLE(hDatasetSource) THEN
    RETURN {fnarg isScrollable cDataTable hDatasetSource}.
  
  /* We don't know this if no valid dataset */
  RETURN ?.  

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getSubmitParent) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getSubmitParent Procedure 
FUNCTION getSubmitParent RETURNS LOGICAL
  (  ) :
/*------------------------------------------------------------------------------
  Purpose: Decides whether parent record should be submitted together with this 
           object's changed records 
           Yes - submit parent record 
           No  - don't submit parent 
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE lSubmitParent AS LOGICAL    NO-UNDO.

  &SCOPED-DEFINE xpSubmitParent
  {get SubmitParent lSubmitParent}.
  &UNDEFINE xpSubmitParent
  
  /* ? means use default, which is yes here, but intended to be customized 
     (for example to be decided by service) */
  IF lSubmitParent = ? THEN
    lSubmitParent = YES.

  RETURN lSubmitParent.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getUndoDeleteOnSubmitError) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getUndoDeleteOnSubmitError Procedure 
FUNCTION getUndoDeleteOnSubmitError RETURNS CHARACTER
  ( ) :
/*------------------------------------------------------------------------------
  Purpose:  Decides whether to immediately undo deleted records after a failed 
            submit. 
          - ERROR - Only undo deletions that causes an error and keep deletions 
                  that was rejected just because the transaction failed. 
                  Allows immediate resubmit.  (Default)
          - NONE - Keep all deletions. Fix the problem and resave or use the 
                   UndoTransaction action to undo.       
          - ALL - Undo all deleted rec
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE pcUndoDelete AS CHARACTER  NO-UNDO.
  {get UndoDeleteOnSubmitError pcUndoDelete}.

  RETURN pcUndoDelete.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getUndoOnConflict) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getUndoOnConflict Procedure 
FUNCTION getUndoOnConflict RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose: Decides which client changes to undo when the save failed due to an 
           optimistic locking conflict. 
           - BEFORE - Overwrite before-image changes only. This mode keeps 
                      changes and allows resave. Requires Undo/Reset to show 
                      server changes.
           - NONE - Keeps all changes as well as the previous before-image 
                    record. A reread of data is thus required to save the record.       
           - CONFLICT - Loose only conflicting field changes.
           - ALL - Loose all changes on confliciting record.    
    Notes:  
------------------------------------------------------------------------------*/
 DEFINE VARIABLE cUndoOnConflict AS CHARACTER  NO-UNDO.
 {get UndoOnConflict cUndoOnConflict}.

 RETURN cUndoOnConflict.   

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getUseDBQualifier) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getUseDBQualifier Procedure 
FUNCTION getUseDBQualifier RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose: Use db-name in field list (Interface for generic query processing)  
    Notes: Used by generic query processing that originally was implemented 
           in the query class and worked on database queries and now have been 
           moved up to the dataview class to also handle temp-table and 
           prodataset queries.      
------------------------------------------------------------------------------*/
  RETURN FALSE.   

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getViewTables) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getViewTables Procedure 
FUNCTION getViewTables RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose: All tables that are included in the view including the DataTable 
    Notes: May be referenced before the dataset is retrieved and created and
           defines which tables to retrieve from the service.
         - The DataTable is always the first entry and all the other tables have 
           a many-to-one (or one-to-one) relationship to the DataTable.
         - QueryTables defines the tables in the query. 
         - This may include outer join tables currently not added to
           the physical query due to 4GL limitations that makes get-last
           and reposition unusable on outer-join queries.   
         - The user defines this at design time storing the value in 
           the Tables attribute, which is not to be accessed outside of here
           at runtime.
         - The Tables property must be defined at design time if the object
           need to retrieve more than just the DataTable as the dataset is 
           not available before the first request. 
         - The default is resolved from the dataset relationships, which  
           mainly is for design time.             
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hDatasetSource AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cDataTable     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cTables        AS CHARACTER  NO-UNDO.
  
  /* Set at design time to override default.
     (Currently set to datatable if not defined in initializeObject
      as runtime default, when only businessentity and datatable is defined)  */
  {get Tables cTables}.
  IF cTables > '' THEN
    RETURN cTables.

  /* Allow Tables to be undefined (important for designtime) */
  &SCOPED-DEFINE xp-assign
  {get DataSetSource hDatasetSource}
  {get DataTable cDataTable}
  .
  &UNDEFINE xp-assign
  
  IF VALID-HANDLE(hDatasetSource) AND cDataTable > '' THEN
    RETURN {fnarg viewTables cDataTable hDatasetSource}.   
  ELSE 
    RETURN cDataTable.

 END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getWordIndexedFields) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getWordIndexedFields Procedure 
FUNCTION getWordIndexedFields RETURNS CHARACTER
  ( ) :
/*------------------------------------------------------------------------------
  Purpose: Returns a comma separated list of fields that are word indexed.   
    Notes: 
------------------------------------------------------------------------------*/
  /* Get the word indexes from the IndexInformation function */
  RETURN DYNAMIC-FUNCTION('indexInformation' IN TARGET-PROCEDURE,
                          'WORD':U, /* query  */
                           NO,   /* no table delimiter */
                           ?).

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-hasActiveAudit) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION hasActiveAudit Procedure 
FUNCTION hasActiveAudit RETURNS LOGICAL
  (  ) :
/*------------------------------------------------------------------------------
  Purpose: Tell toolbar source that we have no active audit data 
    Notes: This is a record level value that is used to show a tick mark on 
           the Auditing action if the current record has auditing data. 
         - Overrides should be implemented if this information is available 
           in the Business Entity.            
------------------------------------------------------------------------------*/
  
  /* A custom dataview could return the logical value in a field 
     that follows a naming convention in the DataTable record 
  RETURN columnValue({fn getDataTable} + '.HasActiveAudit').
  */

  RETURN FALSE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-hasActiveComments) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION hasActiveComments Procedure 
FUNCTION hasActiveComments RETURNS LOGICAL
  (  ) :
/*------------------------------------------------------------------------------
  Purpose: Tell toolbar source that we have no active comments  
    Notes: This is a record level value that is used to show a tick mark on 
           the Comment action if the current record has comments. 
         - Overrides should be implemented if this information is available 
           in the Business Entity.            
------------------------------------------------------------------------------*/
  
  /* A custom dataview could for instance return the logical value in a field 
     that follows a naming convention in the DataTable record 
  RETURN columnValue({fn getDataTable} + '.HasActiveComment').
  */

  RETURN FALSE.

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
DEFINE VARIABLE cField          AS CHARACTER  NO-UNDO.
DEFINE VARIABLE hDataSource     AS HANDLE     NO-UNDO.
DEFINE VARIABLE cRowObjectState AS CHARACTER  NO-UNDO.
DEFINE VARIABLE hRowObjUpd      AS HANDLE     NO-UNDO.
DEFINE VARIABLE hRowObject      AS HANDLE     NO-UNDO.
DEFINE VARIABLE lNew            AS LOGICAL    NO-UNDO.
DEFINE VARIABLE lQueryOpen      AS LOGICAL    NO-UNDO.
DEFINE VARIABLE cDataTable      AS CHARACTER  NO-UNDO.

 &SCOPED-DEFINE xp-assign 
 {get ForeignFields cForeignFields}
 {get ForeignValues cCurrentValues}  
 {get DataSource hDataSource}
 {get QueryOpen lQueryOpen}
 {get DataTable cDataTable}
 {get RowObject hRowObject}
 .
 &UNDEFINE xp-assign
  
 IF NOT VALID-HANDLE(hDataSource) THEN
   RETURN FALSE.

 /* The table may have been emptied as a result of a parent, grandparent
    openQuery, so just return true if empty */  
 IF hRowObject:TABLE-HANDLE:HAS-RECORDS = FALSE THEN
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
 BeforeCheck:
 DO:
   /* New uncommitted does not constitute a change, but would fail the check 
      below */ 
   {get NewRow lNew}.
   IF lNew THEN
      RETURN FALSE.
   
   {get RowObject hRowObject hDataSource}.

   /* Find the corresponding rowObjUpd -- (really synchronize the buffers) 
      Check the before image values and RETURN this finding. 
      if no RowObjUpd record is available then the current parent has not 
      changed and we will use the general logic below   */
   IF VALID-HANDLE(hRowObject) THEN
   DO: 
     hRowObjUpd = hRowObject:BEFORE-BUFFER.
     IF VALID-HANDLE(hRowObjUpd) THEN
     DO:
       hRowObjUpd:FIND-BY-ROWID(hRowObject:BEFORE-ROWID) NO-ERROR.
       IF hRowObjUpd:AVAIL THEN
       DO:
         DO iField = 1 TO NUM-ENTRIES(cSourceFields):
           cField = ENTRY(iField,cSourceFields).
           /* We do not really support this, but this is not the place to handle 
              errors, so just leave it to the logic below */
           IF ENTRY(1,cField,'.') <> cDataTable THEN
             LEAVE beforeCheck.
           cField = ENTRY(2,cField,'.').
           hField = hRowObjUpd:BUFFER-FIELD(cField). 
           cParentValues = cParentValues + ',':U + hField:BUFFER-VALUE.
         END.
         cParentValues = LEFT-TRIM(cParentValues,',':U). 
         /* Return immediately */
         RETURN cParentValues <> cCurrentValues.
       END. /* hROwObjUpd avail */
     END.  /* valid-handle(hRowObjUpd) */
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

&IF DEFINED(EXCLUDE-instanceOf) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION instanceOf Procedure 
FUNCTION instanceOf RETURNS LOGICAL
    ( INPUT pcClass AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose: Override instanceOf to support SmartDataObject subtypes in 
           non repository
    Notes: This is currently only supported for DataView, Data and Query 
------------------------------------------------------------------------------*/
 IF pcClass = 'DataView':U THEN
   RETURN TRUE.

 RETURN SUPER(pcClass).

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-isDataQueryComplete) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION isDataQueryComplete Procedure 
FUNCTION isDataQueryComplete RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose: Returns true if the temp-table has all records.    
    Notes: This may be checked before the actual query is opened  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE lLast  AS LOGICAL NO-UNDO.
  DEFINE VARIABLE lFirst AS LOGICAL NO-UNDO.
  
  &SCOPED-DEFINE xp-assign
  {get HasFirst lFirst}
  {get HasLast lLast}
  . 
  &UNDEFINE xp-assign
  RETURN lFirst AND lLast.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-isFetchedByParent) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION isFetchedByParent Procedure 
FUNCTION isFetchedByParent RETURNS logical
	(  ):
/*------------------------------------------------------------------------------
    Purpose: Check if current parent has fetched this object's data 
    Notes: This is only called from dataAvailable when dataisfetched is false
------------------------------------------------------------------------------*/
  define variable lDataIsFetched  as logical   no-undo.
  define variable hParent         as handle    no-undo.
  define variable hDatasetSource  as handle    no-undo.
  define variable cParentPos      as character no-undo.
  define variable cFetchParentPos as character no-undo.
  define variable cDataTable      as character no-undo.
  define variable cFetchTree      as character no-undo.
  define variable iParent         as integer   no-undo.
  define variable iStart          as integer   no-undo.
  define variable cParentKeyWhere as character no-undo.
  define variable lIsFetched      as logical   no-undo.
  define variable lPropChanged    as logical   no-undo.
  
  &scop xp-assign 
  {get DataIsFetched lDataIsfetched}
  {get DataSource hParent}
  {get DatasetSource hDatasetSource}
  .
  &undefine xp-assign
  
  lIsFetched = valid-handle(hParent).
  
  if lDataIsFetched = false 
  and valid-handle(hParent)  
  and valid-handle(hDatasetSource) then 
  do:
    {get DataTable cDataTable}.
    /* We're currently only using this as a flag and turn it off below 
       (The positions of parent tree that fetched this table
        could be checked against parents querypos in future) */ 
    cFetchTree = {fnarg tableFetchTree cDataTable hDatasetSource}.    
    
    if cFetchTree = '' or cFetchTree = ? then
      lIsFetched = false. 
    
    /* FetchTree has the position of parents that this was received for 
       including its own */
    else
    /* check if position matches - replace with keywhere for resort */ 
    ParentLoop:
    do iParent = num-entries(cFetchTree,chr(1)) - 1 to 1 by -1:        
      cFetchParentPos = entry(iParent,cFetchTree,chr(1)).
      if cFetchParentPos = 'ALL':U then 
        cFetchParentPos = 'FIRST':U.  
        
      /* something is wrong */
      if not valid-handle(hParent) then 
      do: 
        lIsfetched = false.
        LEAVE ParentLoop.
      end.  
        
      {get QueryPosition cParentPos hParent}.
      cParentKeyWhere = 'WHERE (':U + {fn getKeyWhere hParent} + ')':U.          
      case cFetchParentPos:
        when 'FIRST':U then
        do:
          if lookup(cParentPos,'FirstRecord,OnlyRecord':U) = 0 then  
            lIsFetched = false.
        end.    
        when 'LAST':U then
        do:
          if lookup(cParentPos,'LastRecord,OnlyRecord':U) = 0 then  
            lIsFetched = false.
        end.    
        otherwise
          do:
            /* This is mainly a protection for non-default positioning. 
             we do not check next prev - batching is batching, 
             so we assume true */
          
          /* check position */
          if cFetchParentPos begins 'WHERE' then
          do:
            if cFetchParentPos <> cParentKeyWhere then
              lIsFetched = false. 
            else /* no need to check higher if key */
              leave ParentLoop.               
          end.  
        end.            
      end case.  
      
      if lIsfetched = false then
      do:
        if cFetchTree > '' then
          dynamic-function('assignTableFetchTree':U in hDatasetSource,
                            cDataTable,'').               
        leave ParentLoop.
      end.  
      else 
      do:
        entry(iParent,cFetchTree,chr(1)) = cParentKeyWhere.
        lPropChanged = true. 
      end.  
      {get DataSource hParent hParent}.
    end. /* do iParent */
    if lIsFetched and lPropChanged then
      dynamic-function('assignTableFetchTree':U in hDatasetSource,
                        cDataTable,cFetchTree).               
  end. /* lDataIsFetched = false and valid hParent and valid hDatasetSource */ 
 
  return lIsFetched.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-keyWhere) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION keyWhere Procedure 
FUNCTION keyWhere RETURNS CHARACTER
 (phBuffer AS HANDLE,
  pcQual   AS CHAR ):
/*------------------------------------------------------------------------------
  Purpose: Returns a query expression with the key field(s) and current
           value(s). 
 phBuffer: phBuffer - the buffer is typically the before-image or after-image
                      buffer.  
           pcQual   - Optional qualifier for the column reference.               
            
    Notes: Used to find a record without relying on rowid. 
           For example in deleteRow error handling, where prodataset methods 
           may reuse the rowids of a deleted record that need to be undeleted.   
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cKeyFields AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iField     AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cField     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cKeyWhere  AS CHARACTER  NO-UNDO.

  {get KeyFields cKeyFields}.
  IF cKeyFields = '' THEN 
     MESSAGE 'Table' 
             phBuffer:TABLE-HANDLE:NAME 
             'defined in' 
             phBuffer:TABLE-HANDLE:INSTANTIATING-PROCEDURE:FILE-NAME  
             'has no unique key.' SKIP
             program-name(2) 'operation cannot be performed.'
      VIEW-AS ALERT-BOX.           

  ELSE IF VALID-HANDLE(phBuffer) THEN
  DO iField = 1 TO NUM-ENTRIES(cKeyFields):
    ASSIGN
      cField     = ENTRY(iField,cKeyFields)
      cField     = ENTRY(NUM-ENTRIES(cField,'.'),cField,'.')
      cKeyWhere  = cKeyWhere 
                 + (IF iField > 1 THEN ' AND ' ELSE '')
                 + (IF pcQual > '' THEN pcQual ELSE phBuffer:NAME)
                 + '.' 
                 + cField
                 + ' = ' 
                 + QUOTER(phBuffer:BUFFER-FIELD(cField):BUFFER-VALUE,"'":U).


  END.

  RETURN cKeyWhere. 

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-obtainContextForServer) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION obtainContextForServer Procedure 
FUNCTION obtainContextForServer RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose: Return context to pass to the server 
    Notes: No default contrext. 
------------------------------------------------------------------------------*/

  RETURN ''.

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
Parameters: pcPosition - 
                     First  
                     Last   
                     WHERE <criteria>
                     <criteria>  (with ' ' or '=')
                     string(Rowid)   
               internal use only (see comments in retrieveBatch):              
                     NEXT    
                     PREV    
     Notes:  This function is responsible for keeping track of which record
             is first and last on the client and whether these also are 
             first and last of the complete result set. 
------------------------------------------------------------------------------*/
 DEFINE VARIABLE hDataQuery       AS HANDLE     NO-UNDO.
 DEFINE VARIABLE cQuery           AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cAsDivision      AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE iLastRownum      AS INTEGER    NO-UNDO.
 DEFINE VARIABLE iFirstRownum     AS INTEGER    NO-UNDO.
 DEFINE VARIABLE hRowObject       AS HANDLE     NO-UNDO.
 DEFINE VARIABLE lHasFirst        AS LOGICAL    NO-UNDO.
 DEFINE VARIABLE lHasLast         AS LOGICAL    NO-UNDO.
 DEFINE VARIABLE iLoop            AS INTEGER    NO-UNDO.         
 DEFINE VARIABLE lok              AS LOGICAL    NO-UNDO.
 DEFINE VARIABLE lWhere           AS LOGICAL    NO-UNDO.
 define variable lBrowsed         as logical    no-undo.

 &SCOPED-DEFINE xp-assign
 {get DataHandle hDataQuery}
 {get QueryString cQuery}  
 {get HasFirst lHasFirst}
 {get HasLast lHasLast}
 {get DataQueryBrowsed lBrowsed}
 /* we turn this on allways as it is used as a flag to prevent dataAvailable 
    untill an explicit open or find  */ 
 {set OpenOnInit TRUE}
  .
 &UNDEFINE xp-assign
 
 IF NOT lHasFirst THEN 
   {set FirstRowNum ?}. 

 IF NOT lHasLast THEN
   {set LastRowNum ?}. 
 
 IF VALID-HANDLE(hDataQuery) THEN
 DO:
   /* query-prepare empties browse even if it is set to not refreshable, so avoid
      if not necessary */
   IF cQuery = '' THEN
   DO:
     cQuery = {fn getQueryStringDefault}.
     {set QueryString cQuery}.
   END.
   
   IF cQuery <> hDataQuery:PREPARE-STRING THEN
     hDataQuery:QUERY-PREPARE(cQuery).

   hRowObject = hDataQuery:GET-BUFFER-HANDLE(1).
   
   hDataQuery:QUERY-OPEN().
   
   /* We need both first and last info so we do two positioning passes in order
      to do GET-LAST last if "LAST" is requested and do the GET-LAST first if
      it's not */
   DO iLoop = 1 TO 2:
     
     IF (pcPosition <> 'LAST':U AND iLoop = 1 AND lHasLast)
     OR (pcPosition =  'LAST':U AND iLoop = 2) THEN
     DO:
       hDataQuery:GET-LAST().
       IF lHasLast THEN
         {set LastRowNum INT(hRowObject:RECID)}.
     END.

     IF iLoop = 1 THEN
     DO:
       hDataQuery:GET-FIRST().
       IF NOT hRowObject:AVAIL THEN
       DO:
         /* get-last is not safe with outer join (if we want to support it) */
         {set FirstRowNum 0}.
         {set LastRowNum 0}.
       END.
       ELSE
       IF lHasFirst THEN
         {set FirstRowNum INT(hRowObject:RECID)}.
  
       IF pcPosition = 'FIRST':U THEN
         LEAVE.
       ELSE 
       IF pcPosition > '':U AND pcPosition <> 'LAST'  THEN
       DO:
         /* ensure reposition returns true also if searched record is current*/
         hRowObject:BUFFER-RELEASE().
         IF pcPosition BEGINS 'WHERE ':U THEN
           lWhere = TRUE.
         ELSE IF INDEX(pcPosition,' ') > 0 OR INDEX(pcPosition,'=') > 0 THEN 
           ASSIGN 
             pcPosition = 'WHERE ' + pcPosition
             lWhere     = TRUE.

         IF lWhere THEN
         DO:
           lOk = hRowObject:FIND-FIRST(pcPosition) NO-ERROR.
           /* show progress message for syntax error */
           IF ERROR-STATUS:GET-NUMBER(3) = 10041 THEN 
             MESSAGE 
               ERROR-STATUS:GET-MESSAGE(3) VIEW-AS ALERT-BOX ERROR.
           /* Synch the browse here (this is somewhat inconsistent since
              next,prev request currently relies on this being done elsewhere)*/
           IF hRowObject:AVAIL THEN   
             lOk = hDataQuery:REPOSITION-TO-ROWID(hRowObject:rowid) NO-ERROR.
         END.
         ELSE 
           lOk = hDataQuery:REPOSITION-TO-ROWID(TO-ROWID(pcPosition)) NO-ERROR.
         /* find and/or reposition  
            Problem: the record is avail after repos if browsed 
                     we need to get-next to position after repos otherwise
            Solution: only get-next if not avail            
            Problem 2: The record is avail but not positioned if join query
            Solution: check DataQueryBrowsed (not avail )*/
  
         IF lOk AND NOT lBrowsed THEN 
           hDataQuery:GET-NEXT(). 
             
         LEAVE.
       END.
     END.  /* iloop = 1 */
   END. /* iloop = 1 to 2 */

   hRowObject:TABLE-HANDLE:TRACKING-CHANGES = TRUE.
   
   /* Some visual objects that shows more than one record may need to know 
      that the query changed, this cannot be detected through the ordinary
      publish "dataAvailable" from the navigation methods. 
      The SmartSelect populates its list on this event and OCX objects
      like lists and Tree-views may also need to subscribe to this event. */
  
   PUBLISH "queryOpened":U FROM TARGET-PROCEDURE.
 END. /* valid hDataquery */
 
 RETURN IF VALID-HANDLE(hDataQuery) 
        THEN hDataQuery:IS-OPEN 
        ELSE FALSE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-openDataView) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION openDataView Procedure 
FUNCTION openDataView RETURNS LOGICAL
  (   ) :
/*------------------------------------------------------------------------------
  Purpose:  Opens the DataView on existing data.  
    Notes:  Existing data means data that already are on the client. 
            This method is an integral part of the DataView start up and
            data management, but can also be called separately to just refresh 
            or reset visual data-targets from existing data.    
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cFetchOnOpen    AS CHARACTER  NO-UNDO.
  
  {get FetchOnOpen cFetchOnOpen}.
  
  {fnarg openDataQuery cFetchOnOpen}. 

  RUN rowChanged IN TARGET-PROCEDURE('DIFFERENT':U).

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
  
  DEFINE VARIABLE cFetchOnOpen    AS CHARACTER  NO-UNDO.
  {get FetchOnOpen cFetchOnOpen}.
  
  RETURN {fnarg openQueryAtPosition cFetchOnOpen}.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-openQueryAtPosition) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION openQueryAtPosition Procedure 
FUNCTION openQueryAtPosition RETURNS LOGICAL
  ( pcPosition AS CHAR  ) :
/*------------------------------------------------------------------------------
  Purpose:     Opens the query based on the current QueryString and 
               positions to the indicated row.
  
  Parameters:  pcPosition - FIRST 
                            LAST 
                            WHERE <expression>
                            
------------------------------------------------------------------------------*/    
  DEFINE VARIABLE hDataSource     AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cParentPos      AS character   NO-UNDO.
  DEFINE VARIABLE lIsFetched      AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lOk             AS LOGICAL    NO-UNDO.

  &SCOPED-DEFINE xp-assign
  {get DataSource hDataSource}
  {get DataIsFetched lIsFetched}
  .
  &UNDEFINE xp-assign  
  
  /* Allow callers to pass expression without "WHERE"  */
  IF LOOKUP(pcPosition,'FIRST,LAST') = 0 AND NOT (pcPosition BEGINS 'WHERE') THEN
    pcPosition = 'WHERE ' + pcPosition.

  IF VALID-HANDLE(hDataSource) THEN
  DO:
    {get QueryPosition cParentPos hDataSource}. 
    IF cParentPos begins "NoRecordAvailable":U THEN
      RETURN FALSE. 
    
    /* Default retrieval for child is by parent, so set to yes if unknown and
       opened  */
    IF lIsFetched = ? THEN
      {get QueryOpen lIsFetched}.

    IF lIsFetched <> TRUE THEN
    DO:
      {set DataIsFetched FALSE}.
      {fn addForeignKey}.
    END.
  END. /* valid datasource */
 
  /* If data is fetched then any query change should be resolved locally
     (ALL valid queries retrieved by parent) */
  IF lIsFetched <> TRUE THEN
    DYNAMIC-FUNCTION('retrieveData':U IN TARGET-PROCEDURE,
                     pcPosition,
                     YES, /* refresh (unconditional empty) */
                     ?). 
  
  lOk = {fnarg openDataQuery pcPosition}.
  
  RUN rowChanged IN TARGET-PROCEDURE(IF pcPosition BEGINS 'WHERE':U 
                                     THEN 'DIFFERENT':U
                                     ELSE pcPosition).
 
  RETURN lOk.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-refreshQuery) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION refreshQuery Procedure 
FUNCTION refreshQuery RETURNS LOGICAL
  (  ) :
/*------------------------------------------------------------------------------
  Purpose: Refresh the current query 
    Notes: This is a refresh of the current query, so a never opened or closed 
           query will not be refreshed by this. 
         - Currently refreshes all dependant child queries.  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cKeyWhere AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lOpen     AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lOk       AS LOGICAL    NO-UNDO.
 
  &SCOPED-DEFINE xp-assign  
  {get KeyWhere cKeyWhere}
  {get QueryOpen lOpen}
  .
  &UNDEFINE xp-assign
  
  /* A never opened or closed query cannot be refreshed */ 
  IF NOT lOpen THEN 
    RETURN FALSE.

  lOk = {fnarg openQueryAtPosition cKeywhere}.  
  IF NOT lOk THEN
    RUN fetchFirst IN TARGET-PROCEDURE.

  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-refreshSort) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION refreshSort Procedure 
FUNCTION refreshSort RETURNS LOGICAL
  (  ) :
/*------------------------------------------------------------------------------
  Purpose: Reopens the current dataquery assuming value changes.
    Notes: The sort expression is expected to be the same as on previous open.
        -  May call service for data if batching, but disables all links
           before it does so.     
        -  Does NOT publish the change.  Use reopenQuery if publish needed         
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cKeyWhereOld AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cKeyWhereNew AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lQueryOpen   AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lHasFirst    AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lHasLast     AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lAutoCommit  AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE hQuery       AS HANDLE     NO-UNDO.
  DEFINE VARIABLE lServerSort  AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cState       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iTable       AS INTEGER    NO-UNDO.
  DEFINE VARIABLE hBuffer      AS HANDLE     NO-UNDO.
  DEFINE VARIABLE lMissingJoin AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lQueryOk     AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE hRowObject   AS HANDLE     NO-UNDO.
  
  &SCOPED-DEFINE xp-assign
  {get AutoCommit lAutoCommit}
  {get QueryOpen lQueryOpen}
  {get DataHandle hQuery}
  {get RowObject hRowObject}
  {get RowObjectState cState}
  /* use to identify innerjoin if outer is supported
     {get SortTables cSortTables} */
  {get KeyWhere cKeyWhereOld}.          
  &UNDEFINE xp-assign
  
  IF NOT lQueryOpen THEN
    RETURN FALSE.
  
  /* A key to one of the inner joined tables may have changed, possibly
     pointing to a record not on the client, in which case the opening 
     of the query to check the position is futile */
  IF hQuery:NUM-BUFFERS > 1 THEN
  DO: 
     /* We'll wrap this later..  */
     DEFINE VARIABLE cTables AS CHARACTER  NO-UNDO.
     DEFINE VARIABLE cDummy AS CHARACTER  NO-UNDO.
     RUN 'buildViewRequest':U IN TARGET-PROCEDURE
                   (YES, /* check availability */
                    NO, /* don't include repos */
                    OUTPUT cTables,
                    OUTPUT cDummy,
                    OUTPUT cDummy).
     IF cTables > "" then             
       lMissingJoin = TRUE.
  END.
  
  IF NOT lMissingJoin THEN 
  DO:
    lQueryOk = {fnarg openDataQuery cKeyWhereOld}.
    {get KeyWhere cKeyWhereNew}.
    IF cKeyWhereNew <> cKeyWhereOld THEN
      lQueryOk = FALSE.
  END.
  
  /* Resort on server if the local sort put us at the end of an 
     open batch.
     (Cannot resort on server if not autocommit and batching) */
  IF  (lQueryOk OR lMissingJoin)
  AND (lAutoCommit OR cState = 'NoUpdates':U) 
  AND NOT {fn isDataQueryComplete} THEN
  DO: 
    IF lQueryOk THEN 
    DO: 
      &SCOPED-DEFINE xp-assign
      {get HasLast lHasLast}
      {get HasFirst lHasFirst}
      .
      &UNDEFINE xp-assign
   
      IF NOT lHasFirst THEN
      DO:
        IF NOT hQuery:GET-PREV THEN
        DO:
          hQuery:GET-FIRST.
          lServerSort = TRUE.
        END.
        ELSE 
          hQuery:GET-NEXT.
      END.
  
      IF NOT lServerSort AND NOT lHasLast THEN 
      DO:
        IF NOT hQuery:GET-NEXT  THEN
        DO:
          hQuery:GET-LAST.
          lServerSort = TRUE.
        END.
        ELSE 
          hQuery:GET-PREV.
      END.    
    END.   
    
    IF lServerSort OR lMissingJoin THEN 
      lQueryOk = {fnarg retrieveCurrent NO}.
       
  END.
  ELSE DO: 
    /* refreshViewTables works on cureent record , so ensure it is avail */
    IF lMissingJoin THEN  
      lQueryOk = hRowObject:FIND-UNIQUE('where ':U + cKeyWhereOld).
    IF lQueryOk THEN 
    DO:  
      lQueryOk = {fn refreshViewTables}.
      
      IF lMissingJoin THEN 
        lQueryOk = {fnarg openDataQuery cKeyWhereOld}.
    END.   
  END.  
  RETURN lQueryOk.   

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-refreshViewTables) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION refreshViewTables Procedure 
FUNCTION refreshViewTables RETURNS LOGICAL
  (   ) :
/*------------------------------------------------------------------------------
  Purpose: Refreshes view tables after an update/undo where foreign 
           keys may have changed.             
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE iTables    AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cTables    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cQueries   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cPositions AS CHARACTER  NO-UNDO.
  
  RUN 'buildViewRequest':U IN TARGET-PROCEDURE
                   (YES, /* check availability */
                    NO, /* don't include repos */
                    OUTPUT cTables,
                    OUTPUT cQueries,
                    OUTPUT cPositions).
  IF cTables > '' THEN 
    DYNAMIC-FUNCTION('retrieveRows':U IN TARGET-PROCEDURE,
                      INPUT cTables,
                      INPUT cQueries,
                      INPUT cPositions).
                    
  RETURN TRUE.
  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-removeDatasetClone) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION removeDatasetClone Procedure 
FUNCTION removeDatasetClone RETURNS LOGICAL
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hDatasetSource AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hDataContainer AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cNewName       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hBuffer        AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cDataTable     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cTables        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hDataHandle    AS HANDLE     NO-UNDO.
  DEFINE VARIABLE iTable         AS INTEGER    NO-UNDO.
  DEFINE VARIABLE hChild         AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cChild         AS CHARACTER  NO-UNDO.

  {get DatasetSource hDatasetSource}.
  {get DataTable cDataTable}.

  IF VALID-HANDLE(hDatasetSource) THEN
  DO:
    {get DataContainerHandle hDataContainer}.

    cNewName = {fnarg originDataset hDatasetSource hDataContainer}.

    IF cNewName > '' THEN
    DO:
      {fnarg destroyDataset hDatasetSource hDataContainer}. 
      {set DatasetName cNewName}.
      {fn addDatasetSource}.
      {get DatasetSource hDatasetSource}.
      IF VALID-HANDLE(hDatasetSource) THEN
      DO:
        hBuffer  = {fnarg dataTableHandle cDataTable hDatasetSource}.
        {set RowObject hBuffer}.
      END.
    END.
  END.

  IF VALID-HANDLE(hBuffer) THEN
  DO:
    {get QueryTables cTables}.
    {get DataHandle hDataHandle}.
    hDataHandle:SET-BUFFERS(hBuffer).
    DO iTable = 2 TO NUM-ENTRIES(cTables):
      ASSIGN
        cChild = ENTRY(iTable,cTables)
        hChild = {fnarg dataTableHandle cChild hDatasetSource}
        .
      IF VALID-HANDLE(hChild) THEN
      DO:
        hDataHandle:ADD-BUFFER(hChild).
      END. 
    END.
    RETURN TRUE.
  END.

  RETURN FALSE. 

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-reopenQuery) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION reopenQuery Procedure 
FUNCTION reopenQuery RETURNS LOGICAL
  (  ) :
/*------------------------------------------------------------------------------
  Purpose: Reopen the query and resort child queries.  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE lOk AS LOGICAL    NO-UNDO.
  
  lOk = {fn refreshSort}.

  RUN rowChanged IN TARGET-PROCEDURE('RESORT':U).

  RETURN lOk.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-resetRow) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION resetRow Procedure 
FUNCTION resetRow RETURNS LOGICAL
  ( pcRowident AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose: Reset the specified rowobject record
          (to a state of unmodified from state modified in visual data target)   
Parameter: pcRowident 
               - Rowobject rowid 
               - ?  will reset current.    
    Notes: This is used to reset current row from a visual object's resetRecord. 
           The data class has logic to deal with rowobjupd records from failed 
           commits in the data class, the dataview rolls back immediately on
           failed submit. 
         Future (discussion)  
         - The setting of DataModified is a step towards removing the need to 
           call updateState after update from visual objects.  
         - But we may also want to remove DataModified completely from 
           data/dataview  as this is a state that can be detected from targets.   
------------------------------------------------------------------------------*/
  DEFINE VARIABLE lAutoCommit      AS LOGICAL  NO-UNDO.
  DEFINE VARIABLE hContainerSource AS HANDLE   NO-UNDO.
  
  IF {fnarg repositionRowobject pcRowident} THEN
  DO:
    {set DataModified FALSE}.
  END.

  RETURN TRUE. 

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-resolveBuffer) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION resolveBuffer Procedure 
FUNCTION resolveBuffer RETURNS CHARACTER
  ( pcBuffer AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose: Interface for generic query processing  
    Notes: Used by generic query processing that originally was implemented 
           in the query class and worked on database queries and now have been 
           moved up to the dataview class to also handle temp-table and 
           prodataset queries.              
------------------------------------------------------------------------------*/

  RETURN  pcBuffer.    

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
                  - ?  reset to default.  
    Notes: if the query is closed the passed sort expression will be stored
           in the QueryString.    
          - SOrts locally,..... 
------------------------------------------------------------------------------*/
  DEFINE VARIABLE lOpen          AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cOldSort       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cNewSort       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lOk            AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cKeyWhere      AS CHARACTER  NO-UNDO.

  /* if the query is open open we check the current sort to avoid resorting if 
     the same sort is applied (visual objects may request a specific sort 
     at initialization)   */
  {get QueryOpen lOpen}.
  IF lOpen THEN
    {get QuerySort cOldSort}.

  /* ? is default */
  IF pcSort = ? THEN
    {get QuerySortDefault pcSort}.

  /* Store the new sort (also if not opened) */
  lOk = {set QuerySort pcSort}.

  IF lOk AND lOpen THEN
  DO:
    {get QuerySort cNewSort}.
    IF cNewSort <> cOldSort THEN
    DO:
      {get KeyWhere cKeyWhere}.
      IF {fn isDataQueryComplete} THEN 
        lOk = {fnarg openDataQuery cKeyWhere}.   
      ELSE 
        {fnarg retrieveCurrent YES}.
    END.
  END.

  RETURN lOk.

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
                    - query expression  (forward)
        piNumRows - Number of records to retrieve 
                    Special values:
                    - ? - use RowstoBatch
                    - 0 - read all data (not already on client) 
               
    Notes: Passes FillBatch to the server/service
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cReopen    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hQuery     AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hRowObject AS HANDLE     NO-UNDO.
  
  CASE pcMode:
    WHEN 'PREV':U OR WHEN 'NEXT':U THEN
    DO:
      {get DataHandle hQuery}.
      /* position to beginning/end of batch */
      IF pcMode = 'PREV':U THEN
        hQuery:GET-FIRST.
      ELSE 
        hQuery:GET-LAST.

      {get KeyWhere cReopen}.
      IF cReopen > '' THEN 
        cReopen = 'WHERE ':U + cReopen. 
    END.
    OTHERWISE 
      cReopen = pcMode.
  END.

  DYNAMIC-FUNCTION('retrieveData':U IN TARGET-PROCEDURE,pcMode,NO,piNumRows). 
    
  {fnarg openDataQuery cReopen}.
    
  /* The following will not be noticed by the browse, and is relying on the 
     calling method (fetchNext,fetchPrev) publishing dataAvailable(pcmode) to 
     synchronize the browser.
     The fetchBatch calling procedure repositions forwards/backwards to synch
     the browse instead (called from browse).
     The reposition-forward could alternatively be moved into openDataQuery 
     and removed from fetchBatch. fetchnext,fetchprev would then need to be 
     changed to run rowChanged('repositioned') */
        
  IF pcMode = 'NEXT':U THEN
    hQuery:GET-NEXT.
  ELSE IF pcMode = 'PREV':U THEN
    hQuery:GET-PREV.
    
  {get RowObject hRowObject}.

  RETURN hRowObject:AVAIL.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-retrieveCurrent) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION retrieveCurrent Procedure 
FUNCTION retrieveCurrent RETURNS LOGICAL
  ( plRefresh AS LOG ) :
/*------------------------------------------------------------------------------
  Purpose: Retrieve data for a table, keeping current position. 
Parameter: plRefresh as log.             
           Yes - signal RowChanged while links are disabled 
           
           No  - no publish (The caller has the responsibility of refreshing)   
           
    Notes: Returns true if the current record is returned 
           Returns false and does a findFirst if unsuccessful.      
        -  Minimal impact retrieval intended for resort/refresh cases. 
        -  Disables data links to child query objects during retrieval.
             (retrieveData will add back DataIsFetched child links)
        -  Runs rowChanged('resort') so that DataIsFetched children that 
           also were retrieved can reopen query while also keeping current 
           positions.
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cTargets       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hTarget        AS HANDLE     NO-UNDO.
  DEFINE VARIABLE iTarget        AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cDisabled      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lQueryObject   AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lDataIsFetched AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cKeyWhere      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lOk            AS LOGICAL    NO-UNDO.

  {get KeyWhere cKeyWhere}.
  /* Only sort if record avail */
  IF cKeyWhere > "":U THEN
  DO:
    {get DataTarget cTargets}.        
    /* We disable the data links to dataobjects as there is no need to 
       retrieve child data on the server, since we are going to end up 
       on the same record  */       
    DO iTarget = 1 TO NUM-ENTRIES(cTargets):
      hTarget = WIDGET-HANDLE(ENTRY(iTarget,cTargets)).
      IF VALID-HANDLE(hTarget) THEN
      DO:
        {get QueryObject lQueryObject hTarget}.
        IF lQueryObject THEN 
        DO:
          lDataIsFetched = FALSE.
          /* no-error for SBO (dataview to SBO is not supported,
             but this is not the place to deal with that ) */
          {get DataIsFetched lDataIsFetched hTarget} NO-ERROR.
          IF lDataIsFetched <> TRUE THEN
          DO:
            RUN linkStateHandler IN hTarget ("inactive":U,
                                             TARGET-PROCEDURE,
                                             "DataSource":U).
            cDisabled = cDisabled
                      + (IF iTarget = 1 THEN '':U ELSE ',':U)
                      + STRING(hTarget).
          END.
        END. /* QueryObject*/
      END. /* valid datatarget */
    END. /* Do iTarget = 1 to NUM-ENTRIES(cTargets) */        
            
    DYNAMIC-FUNCTION('retrieveData':U IN TARGET-PROCEDURE,
                      cKeyWhere,
                      YES, /* refresh (unconditional empty) */
                      ?). 
    
    {fnarg openDataQuery cKeyWhere}.
    lOk = (cKeyWhere = {fn getKeyWhere}).
    
    IF plRefresh THEN
    DO:  
      /* reopen  */
      IF lOk THEN 
        RUN rowChanged IN TARGET-PROCEDURE('REOPEN':U).
      ELSE  /* gone! - just fetch first  */
        RUN fetchFirst IN TARGET-PROCEDURE.
    END.

    /* enable data link to targets again 
      (they will refresh themselves if position has changed ) */ 
    DO iTarget = 1 TO NUM-ENTRIES(cDisabled):
      hTarget = WIDGET-HANDLE(ENTRY(iTarget,cDisabled)).
      IF VALID-HANDLE(hTarget) THEN
        RUN linkStateHandler IN hTarget ("active":U,
                                         TARGET-PROCEDURE,
                                        "DataSource":U).
    END. /* do iTarget = 1 to */  

  END.
  
  RETURN lOk.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-retrieveData) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION retrieveData Procedure 
FUNCTION retrieveData RETURNS LOGICAL
  ( pcMode AS CHAR,
    plRefresh AS LOG,
    piNumRows AS INT) :
/*------------------------------------------------------------------------------
  Purpose: Retrieve  data   
parameter: pcMode - Tells where to start retrieving in relation to current 
                    batch (and typically current record).
                    Values:  
                    - 'NEXT'  - Retrieve next batch
                    - 'PREV'  - Retrieve prev batch
                    - 'LAST'  - Retrieve LAST batch 
                                  (APPEND if not RebuildOnRepos!)
                    - 'FIRST' - Retrieve FIRST batch. 
                    - query expression  (forward)
        plRefresh   - Empty temp-tables even when not rebuild          
        piNumRows - Number of records to retrieve 
                    Special values:                   
                    - ? - use RowstoBatch
                    - 0 - read all data (not already on client) 
                    - 1 - find of record not on client (ignores RebuildOnRepos and 
                          keeps batch)
                    
    Notes: Passes FillBatch to the server/service
------------------------------------------------------------------------------*/

   DEFINE VARIABLE cEntities       AS CHARACTER  NO-UNDO.
   DEFINE VARIABLE cEntityNames    AS CHARACTER  NO-UNDO.
   DEFINE VARIABLE cDatasetSources AS CHARACTER  NO-UNDO.
   DEFINE VARIABLE cDataTables     AS CHARACTER  NO-UNDO.
   DEFINE VARIABLE cQueries        AS CHARACTER  NO-UNDO.
   DEFINE VARIABLE cRequests       AS CHARACTER  NO-UNDO.
   DEFINE VARIABLE cForeignFields  AS CHARACTER  NO-UNDO.
   DEFINE VARIABLE cPositionFields AS CHARACTER  NO-UNDO.
   DEFINE VARIABLE cBatchSizes     AS CHARACTER  NO-UNDO.
   DEFINE VARIABLE cContext        AS CHARACTER  NO-UNDO.
   DEFINE VARIABLE hDatasetsource  AS HANDLE     NO-UNDO.
   DEFINE VARIABLE lRebuild        AS LOGICAL    NO-UNDO.
   DEFINE VARIABLE hQuery          AS HANDLE     NO-UNDO.
   DEFINE VARIABLE cTable          AS CHARACTER  NO-UNDO.
   DEFINE VARIABLE lFillBatch      AS LOGICAL    NO-UNDO.
   DEFINE VARIABLE lAppend         AS LOGICAL    NO-UNDO.
   DEFINE VARIABLE lRefresh        AS LOGICAL    NO-UNDO.
   DEFINE VARIABLE iChild          AS INTEGER    NO-UNDO.
   DEFINE VARIABLE hChild          AS HANDLE     NO-UNDO.
   
   DEFINE VARIABLE hDataSource     AS HANDLE     NO-UNDO.
   DEFINE VARIABLE hRequestor      AS HANDLE     NO-UNDO.
   DEFINE VARIABLE cHiddenChildren AS CHARACTER  NO-UNDO.
   
  &SCOPED-DEFINE xp-assign
  {get DatasetSource hDatasetSource}
  {get DataHandle hQuery}
  {get RebuildOnRepos lRebuild}
  .
  &UNDEFINE xp-assign
  
  cHiddenChildren = {fn activateHiddenFetchChildren}.
  /* run in this to collect own data */
  RUN buildDataRequest IN TARGET-PROCEDURE
                               (INPUT TARGET-PROCEDURE,  
                                INPUT '', /* datasource*/
                                INPUT '',  /* viewersource */
                                INPUT-OUTPUT cRequests,
                                INPUT-OUTPUT cDataTables,
                                INPUT-OUTPUT cQueries,
                                INPUT-OUTPUT cBatchSizes,
                                INPUT-OUTPUT cForeignFields,
                                INPUT-OUTPUT cPositionFields,
                                INPUT-OUTPUT cContext,
                                INPUT-OUTPUT cDatasetSources,
                                INPUT-OUTPUT cEntities,
                                INPUT-OUTPUT cEntityNames).

  DO iChild = 1 TO NUM-ENTRIES(cHiddenChildren):
    hChild = WIDGET-HANDLE(ENTRY(iChild,cHiddenChildren)).
    {get DataSource hDataSource hChild}.
    RUN linkStateHandler IN hChild
                          ('INACTIVE':U,hDataSource,'DataSource':U).
  END.

  CASE pcMode:
    WHEN 'FIRST':U THEN 
      ASSIGN 
        lAppend = FALSE
        lRefresh = TRUE.

    WHEN 'LAST':U THEN
    DO:
      IF NOT lRebuild AND NOT plRefresh THEN
        ASSIGN
          piNumRows = 0
          lAppend = TRUE
          lRefresh = FALSE.
      ELSE
        ASSIGN 
          lAppend = FALSE
          lRefresh = TRUE.
    END.
    WHEN 'PREV':U OR WHEN 'NEXT':U THEN
      ASSIGN 
        lAppend = TRUE
        lRefresh = plRefresh. /* retrieveBatch passes NO  
                                 could be overidden to pass a RebuildOnNav prop */ 

    OTHERWISE DO:
      
      /* If pinumrows = 1 ignore rebuild and fillbatch */   
      IF piNumRows = 1 THEN
        ASSIGN 
          lAppend = FALSE
          lRefresh = plRefresh.

      ELSE IF NOT lRebuild THEN 
        ASSIGN 
          lAppend = TRUE
          lRefresh = plRefresh.
      ELSE DO:
        ASSIGN 
          lAppend  = FALSE
          lRefresh = TRUE.
        /* Rebuild position request need to know whether to fill the batch */
        {get FillBatchOnRepos lFillBatch}.
      END.

      IF pcMode BEGINS 'FOR ':U THEN
        pcMode = SUBSTRING(pcMode,INDEX(pcMode,' WHERE ':U) + 1).
      ELSE IF NOT TRIM(pcMode) BEGINS 'WHERE' THEN
        pcMode = 'WHERE ':U + pcMode. 
    END.
  END CASE.

  IF piNumRows = ? THEN
    {get RowsToBatch piNumRows}.
  
  /* could be called from initializeObject with openininit false */
  IF ENTRY(1,cRequests,CHR(1)) <> 'DEFS' THEN
    ASSIGN
      ENTRY(1,cBatchsizes)      = STRING(piNumRows)
      ENTRY(1,cRequests,CHR(1)) = pcMode.
  
  {get RequestHandle hRequestor}.

  RUN retrieveData IN {fn getDataContainerHandle}
                         (hRequestor,
                          lRefresh,
                          lAppend,
                          /* only set from property in one case above */
                          lFillBatch,
                          cRequests,
                          cDataTables,
                          cQueries,
                          cBatchSizes,
                          cForeignFields,
                          cPositionFields,
                          cContext,
                          cDatasetSources,
                          cEntities,
                          cEntityNames) NO-ERROR.
 
  IF ERROR-STATUS:ERROR THEN
  DO:
    /* add fetch of data failed due to unexpected error message */ 
    RUN addServerError IN TARGET-PROCEDURE('retrieve':u,RETURN-VALUE,cEntities).
    /* show messages in update target */
    RUN processMessages IN TARGET-PROCEDURE.   
    RETURN FALSE.
  END.
  /* if valid source applycontext 
     (otherwuse startobject will applycontext after attaching dataset) */ 
  IF VALID-HANDLE(hDatasetSource) THEN
  DO:
    {get DataTable cTable}.
    cContext = {fnarg tableContext cTable hDatasetSource}.
    IF cContext > '' THEN
      {fnarg applyContextFromServer cContext}.
  END.

  PUBLISH "dataRequestComplete":U FROM TARGET-PROCEDURE.
  
  RETURN TRUE. 

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-retrieveRows) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION retrieveRows Procedure 
FUNCTION retrieveRows RETURNS LOGICAL
  ( pcTables AS CHAR,
    pcQueries AS CHAR,
    pcPositionFields AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose: Retrieve single rows   
    Notes:  
------------------------------------------------------------------------------*/
   DEFINE VARIABLE hRequstor       AS HANDLE     NO-UNDO.
   DEFINE VARIABLE cRequests       AS CHARACTER  NO-UNDO.
   DEFINE VARIABLE cBatchSizes     AS CHARACTER  NO-UNDO.
   DEFINE VARIABLE cForeignFields  AS CHARACTER  NO-UNDO. 
   DEFINE VARIABLE iTable          AS INTEGER    NO-UNDO.
   
   DEFINE VARIABLE hDatasetSource AS CHARACTER  NO-UNDO.
   DEFINE VARIABLE cEntity        AS CHARACTER  NO-UNDO.
   DEFINE VARIABLE cEntityName    AS CHARACTER  NO-UNDO.
   DEFINE VARIABLE hRequestor     AS HANDLE     NO-UNDO.
   
   &scoped-define xp-assign 
   {get RequestHandle hRequestor}
   {get DatasetSource hDatasetSource}
   {get BusinessEntity cEntity}
   {get DatasetName cEntityName}
   .
   &undefine xp-assign
   
   cForeignFields = FILL(CHR(1),NUM-ENTRIES(pcTables) - 1). 
   
   DO iTable = 1 TO NUM-ENTRIES(pcTables):
     ASSIGN /* qualify table for the datacontainer */
       ENTRY(iTable,pcTables) = cEntityName + "." + ENTRY(iTable,pcTables)  
       cRequests   = cRequests 
                   + (IF iTable = 1 THEN "" ELSE CHR(1))
                   + "FIND":U 
       cBatchSizes = cBatchSizes
                   + (IF iTable = 1 THEN "" ELSE ",")
                   + "1":U.
                
   END.   
    
   RUN retrieveData IN {fn getDataContainerHandle}
                         (hRequestor,
                          NO, 
                          NO,
                          NO,
                          cRequests,
                          pcTables,
                          pcQueries,
                          cBatchSizes,
                          cForeignFields,
                          pcPositionFields,
                          "",
                          STRING(hDatasetSource),
                          cEntity,
                          cEntityName) NO-ERROR.
   
   
   RETURN TRUE. 
  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setBusinessEntity) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setBusinessEntity Procedure 
FUNCTION setBusinessEntity RETURNS LOGICAL
  ( pcBusinessEntity AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  {set BusinessEntity pcBusinessEntity}.
  RETURN TRUE. 

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setDatasetName) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setDatasetName Procedure 
FUNCTION setDatasetName RETURNS LOGICAL
  ( pcName AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Set the instance name of the object's DatasetSource.
   Params:  <none>
------------------------------------------------------------------------------*/
  {set DatasetName pcName}.
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setDatasetSource) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setDatasetSource Procedure 
FUNCTION setDatasetSource RETURNS LOGICAL
  ( phSource AS HANDLE ) :
/*------------------------------------------------------------------------------
  Purpose:  Set the handle of the object's DaatasetSource.
   Params:  <none>
------------------------------------------------------------------------------*/
  {set DatasetSource phSource}.
  RETURN TRUE. 

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setDataTable) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setDataTable Procedure 
FUNCTION setDataTable RETURNS LOGICAL
  ( pcDataTable AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  {set DataTable pcDataTable}.
  RETURN TRUE. 

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setResortOnSave) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setResortOnSave Procedure 
FUNCTION setResortOnSave RETURNS LOGICAL
  ( plResortOnSave AS LOGICAL ) :
/*------------------------------------------------------------------------------
  Purpose: Decides whether to resort (reopen) the clcient query on save of row
Parameter: pl  
            Yes - Resort and reopen the client query on save of a row. 
            No  - Do not resort on save of row.
    Notes: This applies to both AutoCommit and non-AutoCommit sources, but may 
           require an additional server request if the datasource is batching 
           and is thus ignored if batching and AutoCommit is set to false.  
------------------------------------------------------------------------------*/
  {set ResortOnSave plResortOnSave}.

  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setSubmitParent) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setSubmitParent Procedure 
FUNCTION setSubmitParent RETURNS LOGICAL
  ( plSubmitParent AS LOGICAL ) :
/*------------------------------------------------------------------------------
  Purpose: Decides whether parent record should be submitted together with this 
           object's changed records 
  
  Parameter: plSubmit - logical
              Yes - submit parent record  
              No  - Don't submit parent
              ?   - use default (datacontainer - service)  
    Notes:  
------------------------------------------------------------------------------*/
  &SCOPED-DEFINE xpSubmitParent
  {set SubmitParent plSubmitParent}.
  &UNDEFINE xpSubmitParent
  
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setUndoDeleteOnSubmitError) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setUndoDeleteOnSubmitError Procedure 
FUNCTION setUndoDeleteOnSubmitError RETURNS LOGICAL
  ( pcUndoDelete AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  Decides whether to immediately undo deleted records after a failed 
            submit. 
Paramter - plUndoDelete 
          - ERROR - Only undo deletions that causes an error and keep deletions 
                  that was rejected just because the transaction failed. 
                  Allows immediate resubmit.  (Default)
          - NONE - Keep all deletions. Fix the problem and resave or use the 
                   UndoTransaction action to undo.       
          - ALL - Undo all deleted rec
    Notes:  
------------------------------------------------------------------------------*/
  {set UndoDeleteOnSubmitError pcUndoDelete}.

  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setUndoOnConflict) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setUndoOnConflict Procedure 
FUNCTION setUndoOnConflict RETURNS LOGICAL
  ( pcUndoOnConflict AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose: Decide which client changes to undo when the save failed due to an 
           optimistic locking conflict. 
Parameter: pcUndoOnConflict           
           - BEFORE - Overwrite before-image changes only. This mode keeps 
                      changes and allows resave. Requires Undo/Reset to show 
                      server changes.
           - NONE - Keeps all changes as well as the previous before-image 
                    record. A reread of data is thus required to save the record.       
           - CONFLICT - Loose only conflicting field changes.
           - ALL - Loose all changes on confliciting record.    
    Notes:  
------------------------------------------------------------------------------*/
 {set UndoOnConflict pcUndoOnConflict}.

 RETURN TRUE.   

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-submitData) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION submitData Procedure 
FUNCTION submitData RETURNS LOGICAL
  (  ) :
/*------------------------------------------------------------------------------
  Purpose: Submit ALL dataset changes to the server/service
           Returns True if all changes were successfully sumitted. 
           Returns False for error as well as record level data exceptions.
    Notes: This is intended to be wrapped in public calls, 
           It's being called from submitRow for single row autocommit and 
           external visual callers, like the toolbar commitsource, should call 
           commitTransaction, which does the necessary check for unsaved changes 
           before calling.
        -  The callers are expected to handle error messages. 
           Unexpected errors are added to the message stack here and can be 
           checked by anyMessages while data exceptions are stored in the dataset 
           to be dealt with in processSubmitException. 
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hDataset       AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hChangeDataset AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cEntityName    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDataTable     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lOk            AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cContext       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lSubmitParent  AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lAutoCommit    AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE hDataSource    AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hParentDataset AS HANDLE     NO-UNDO.

  &SCOPED-DEFINE xp-assign
  {get DatasetSource hDataset}
  {get BusinessEntity cEntityName}
  {get DataTable cDataTable}
  {get SubmitParent lSubmitParent}
  {get AutoCommit lAutoCommit}
  {get DataSource hDataSource}.
  &UNDEFINE xp-assign
 
  IF lSubmitParent THEN 
  DO: 
    IF NOT lAutoCommit AND VALID-HANDLE(hDataSource) THEN 
    DO:
      /* We assume that the parent is AutoCommit ... since this method 
         should be called from the top non AutoCommit object. (This could 
         also be a case of bad linking, but we turn it off also in that case
         even if that probably just should have been stopped) */ 
      {get ParentDataset hParentDataset hDataSource} NO-ERROR.
      IF hParentDataset = hDataset THEN  
        /* This is a rather questionable scenario, but just in case turn off parent
          (avoid error on merge with copyall mode) */  
        lSubmitParent = FALSE. 
    END.
    /* another questionable scenario, we cannot use copyall to create or merge 
       the dataset if some of the children are to be saved separately 
       so turn off submitParent */ 
    ELSE IF lAutoCommit AND {fn anyNonAutoCommitChildInDataset} THEN 
      lSubmitParent = FALSE.                   
  END. 
    
  cContext = {fn obtainContextForServer}.
    
  RUN submitDataset IN {fn getDataContainerHandle} 
                                 (hDataset,
                                  cEntityName, 
                                  cDataTable,
                                  lSubmitParent,
                                  lAutoCommit,
                                  INPUT cContext,
                                  OUTPUT lOk) NO-ERROR.
  IF ERROR-STATUS:ERROR THEN 
  DO:
    /* add "save failed due to unexpected error" message 
       Caller will deal with the actual messaging  */ 
    RUN addServerError IN TARGET-PROCEDURE('submit':u,RETURN-VALUE,cEntityName).
    lOk = FALSE. /* ... */    
  END.                                  
  ELSE 
  DO:
    cContext = {fnarg tableContext cDataTable hDataset}. 
    IF lok THEN
    DO:
      {set rowObjectState 'NoUpdates':U}.
    END.
    IF cContext > '' THEN
      {fnarg applyContextFromServer cContext}.
  END.
  RETURN lok. 

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
                         DataTarget's Rowident property
                      - ?  indicates current record.    
    INPUT pcValueList - CHR(1) delimited list of alternating column names 
                        and values to be assigned.
 Notes: All current default usage of this API is intended to save data to 
        current record, although the visual Rowident is passed.                       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE lNewMode        AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cErrorMessages  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cUpdColumns     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hRowObject      AS HANDLE     NO-UNDO.
  DEFINE VARIABLE rRowObject      AS ROWID      NO-UNDO.
  DEFINE VARIABLE lAutoCommit     AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lSuccess        AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cState          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lDummy          AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE iCol            AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cColumnref      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDataTable      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hDataSource     AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cForeignValues  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cForeignFields  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hDatasetSource  AS HANDLE     NO-UNDO.
  DEFINE VARIABLE lNewRow         AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lResortOnSave   AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cValue          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lQueryOk        AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lSubmitParent   AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE hParent         AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hParentDSSource AS HANDLE     NO-UNDO.
  DEFINE VARIABLE lParentChanged  AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lDataIsFetched  AS LOGICAL    NO-UNDO.
   
  rRowObject = TO-ROWID(ENTRY(1, pcRowIdent)) NO-ERROR.

  &SCOPED-DEFINE xp-assign
  {get RowObject hRowObject}
  {get DataTable cDataTable}
  {get DatasetSource hDatasetSource}
  {get DataSource hDataSource}
  .     
  &UNDEFINE xp-assign
  
  IF NOT VALID-HANDLE(hDatasetSource) THEN
    RETURN FALSE.
  
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
                     + (IF pcRowident = ? THEN '?':U ELSE pcRowident)
                    ),
          ?, 
          ?).
      RETURN FALSE.
    END.
  END. /* not avail or passed rowid mismatch */ 

  lSuccess = TRUE.  

  /* Verify that they're not trying to update a non-updatable field. 
     Also qualify unqualified columns with datatable  */
  {get UpdatableColumns cUpdColumns}.
  DO iCol = 1 TO NUM-ENTRIES(pcValueList,CHR(1)) BY 2:
    cColumnRef = ENTRY(iCol, pcValueList,CHR(1)).
    IF INDEX(cColumnRef,'.':U) = 0 THEN 
    DO:
      cColumnRef = cDataTable + '.' + cColumnRef.
      ENTRY(iCol,pcValueList,CHR(1)) = cColumnRef.
    END.
    IF LOOKUP(cColumnRef, cUpdColumns) = 0 THEN
    DO:
      lSuccess = FALSE.
      RUN addMessage IN TARGET-PROCEDURE (SUBSTITUTE({fnarg messageNumber 54}, cColumnRef), cColumnRef, ?).
    END. /* lookup column in upd = 0 */
  END. /* iColNum = 1 TO NUM-ENTRIES(p */
   
  /* Assign Foreign Key values if needed for new records. */
  IF lSuccess AND VALID-HANDLE(hDataSource) THEN
  DO:
    &SCOPED-DEFINE xp-assign
    {get ForeignFields cForeignFields}
    {get ForeignValues cForeignValues}
    {get NewRow lNewRow}
    .
    &UNDEFINE xp-assign
    IF lNewRow THEN
    DO:
      DO iCol = 1 TO NUM-ENTRIES(cForeignFields) BY 2:
        /* if foreignfield not already in list add foreignvalue */
        ASSIGN
          cColumnRef = ENTRY(iCol,cForeignFields)
          cValue     = DYNAMIC-FUNCTION('mappedEntry':U IN TARGET-PROCEDURE,
                                        cColumnRef,
                                        pcValueList,
                                        TRUE, /* after */
                                        CHR(1)).
        IF cValue = ? THEN
          ASSIGN cValue       = ENTRY(INT((iCol + 1) / 2), cForeignValues, CHR(1)) 
                 pcValueList  = cColumnRef + CHR(1) 
                                + (IF cValue = ? THEN "?" ELSE cValue)
                                + (IF pcValueList = "":U THEN "":U ELSE CHR(1)) 
                                + pcValueList.
      END. /* do iCol */
    END. /* new row*/
  END. /* valid datasource */
  
  IF lSuccess THEN
    lSuccess =  DYNAMIC-FUNCTION('updateRow':U IN hDatasetSource,
                                cDataTable,
                                {fn getKeyWhere},
                                 pcValueList).

  IF lSuccess THEN 
  DO:
    &SCOPED-DEFINE xp-assign 
    {get NewMode lNewMode}
    {get AutoCommit lAutoCommit}
    .
    &UNDEFINE xp-assign

    IF lAutoCommit THEN 
       /* Go ahead with the submit to the datacontainer -> service. */
      lSuccess  = {fn submitData}.
    ELSE 
      {set RowObjectState 'RowUpdated':U}.

    IF lSuccess THEN
    DO: 
      &SCOPED-DEFINE xp-assign
      {set DataModified FALSE}
      {set CurrentRowid ?} /* ensure newmode = false */
      {get ResortOnSave lResortOnSave}
      {get SubmitParent lSubmitParent}
      {get RowParentChanged lParentChanged}
      .
      &UNDEFINE xp-assign
            
            
      IF lAutoCommit AND lSubmitParent THEN
      DO:
        hParent = TARGET-PROCEDURE.
        ParentLoop:
        DO WHILE lSubmitParent:          
          {get DataSource hParent hParent}.
          IF VALID-HANDLE(hParent) THEN
          DO:
            {get DatasetSource hParentDsSource hParent}.       
            IF hParentDsSource <> hDatasetSource THEN
              LEAVE ParentLoop.
            IF NOT {fn getDataModified hParent} THEN
              RUN rowChanged IN hParent('SAME':U).        
            {get SubmitParent lSubmitParent hParent}.
          END.
          ELSE 
            LEAVE ParentLoop.
        END.
      END.
      
      IF (lResortOnSave OR lNewMode) THEN
      DO: 
        IF lParentChanged THEN
          lQueryOk = FALSE.
        ELSE  
          lQueryOk = {fn refreshSort}.
      END.
      
      IF NOT lQueryOk THEN  
      DO:
        /* This message is for cases when query criteria makes the record 
           not avail. One would expect the record to disappear if the 
           parent key changed... ? (a property could be considered, but 
           a different message is also needed) */                                     
        IF NOT lParentChanged  THEN  
          RUN showMessageProcedure IN TARGET-PROCEDURE 
                                     (INPUT "96":U, OUTPUT lDummy).
        ELSE DO:
          IF lAutoCommit THEN 
          DO: 
            /* if the record is moved to another parent and this parent is not 
               on client just get rid of the record */ 
            {get DataIsFetched lDataIsFetched}.             
            if  not (lDataIsFetched = FALSE)
            and not {fn canFindParentOnClient} then 
            do:     
              hRowObject:TABLE-HANDLE:tracking-changes = FALSE.
              hROwObject:buffer-delete.
              hRowObject:TABLE-HANDLE:tracking-changes = TRUE.
            end.   
          END.
 
          /* no point in positioning if parent changed as the record 
             will be outside the query criteria, but we need to reopen  */
          {fnarg openDataQuery ''}.
        END.
                                               
        RUN fetchFirst IN TARGET-PROCEDURE.     
      END.    
      ELSE DO:
        {fn refreshViewTables}.
        cState = (IF NOT lNewMode AND NOT lResortOnSave THEN 'SAME':U
                  ELSE IF lAutoCommit THEN 'DIFFERENT':U
                    /* we use 'RESET' for uncommitted new records, as this 
                       will reset panels and only reopen if child has 
                       no changes */
                  ELSE                     'RESET':U).  

        RUN rowChanged IN TARGET-PROCEDURE (cState).
      END.
    END. /* lSuccess (Successful commit or not autocommit) */
  END. /* lSuccess (from string to buffer) */ 
  
  IF NOT lSuccess THEN
  DO:
    /* Add the update cancelled message, unless messages already present 
      (from an unexpected server errror) */
    IF NOT {fn anyMessage} THEN 
      RUN addMessage IN TARGET-PROCEDURE({fnarg messageNumber 15},?,?).
    RUN processSubmitException IN TARGET-PROCEDURE.
  END.
  
  RETURN lSuccess.  

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
               - ?  will reset current.    
    Notes: This is currently no called directly from visual objects, as they 
           do not support undo of single record.  
         - undo of deleted rows is not handled here.
         Future (discussion)  
         - undo should be action in visual, but probably avoid specific action
           in toolbar and rather extend reset or undoTransaction. 
         - reset can be extended to be incremental and do an undo if already 
           reset.
           - reset - undo - undo all 
         - undoTransaction could take single record first      
------------------------------------------------------------------------------*/
  DEFINE VARIABLE lAutoCommit      AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE hContainerSource AS HANDLE     NO-UNDO.
  DEFINE VARIABLE rRowid           AS ROWID      NO-UNDO.
  DEFINE VARIABLE lDataModified    AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lResortOnSave    AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lNew             AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lRebuild         AS LOGICAL    NO-UNDO.
  define variable cKeyWhere        as character  no-undo.
  define variable hDatasetSource   as handle     no-undo.
  define variable cDataTable       as character  no-undo.
  
  /* don't assume rowid as param, call matching function */ 
  IF {fnarg repositionRowobject pcRowident} THEN
  DO:  
    &scop xp-assign
    {get DatasetSource hDatasetSource}
    {get DataTable cDataTable}
    {get KeyWhere cKeyWhere}.
    &undefine xp-assign
    
    if valid-handle(hDatasetSource) then 
      dynamic-function('undoRow':U in hDatasetSource,
                        cDataTable,cKeyWhere,NO /* don't undo create */).
       
  END.
  ELSE 
    RETURN FALSE.

  /*  ..what we really mean is; if not hasChanges then publish */
  IF {fn getRowObjectState} = 'NoUpdates':U THEN
    {set RowObjectState 'NoUpdates':U}.
  
  &scoped-define xp-assign
  {get NewRow lNew}
  {get ResortOnSave lResortOnSave}            
  {get DataModified lDataModified}
  .
  &undefine xp-assign
  
  /* An undo may change sort so reopen if ResortOnSave or NewRow */  
  IF lResortOnSave OR lNew THEN
  DO:
    /* if rebuild we may need to refresh data from server 
       to sort correctly (very small chance.. )*/
    {get RebuildOnRepos lRebuild}.
    IF lRebuild THEN 
      {fn refreshSort}.  
    ELSE 
      /* if not rebuild data is only appended and never discarded,
         so even if the undone change caused a resort the data 
         satisfying the old sort will be on the client,
         so just reopen */  
      {fnarg openDataQuery pcRowident}. 
  
  END. /* ResortOnSave or NewRow */  
  
  /* if modified don't call rowChanged -> publish. 
     The modifier (updatetarget) is responsible of ensuring 
     redisplay when the state is turned off */
  IF NOT lDataModified THEN
    RUN rowChanged IN TARGET-PROCEDURE('SAME':U).
  
  /* always true.. state is undone */
  RETURN TRUE. 

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-updateLargeColumns) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION updateLargeColumns Procedure 
FUNCTION updateLargeColumns RETURNS LOGICAL
  (  ) :
/*------------------------------------------------------------------------------
  Purpose: Update properties that returns information about LOB columns
    Notes: Called from whatever is called first of getCLOB- -BLOB- or 
           -LargeColumns-  (lazy).      
           LargeDataColumns is not the sum of the other because:
          -  These properties returns the values in DataColumns order.                      
          -  LargeColumns could theoretically be set to also include other large
             columns independent of data type. 
          - PRIVATE   
------------------------------------------------------------------------------*/
    DEFINE VARIABLE hDataSetSource AS HANDLE    NO-UNDO.
    DEFINE VARIABLE cTable         AS CHARACTER  NO-UNDO.

    &SCOPED-DEFINE xp-assign
    {get DataSetSource hDataSetSource}
    {get DataTable cTable}.
    &UNDEFINE xp-assign
    
    /* Set to blank in storage when no large columns */
    IF VALID-HANDLE(hDatasetSource) 
    AND NOT {fnarg viewHasLobs cTable hDataSetSource} THEN
    DO:         
      &SCOPED-DEFINE xp-assign 
     /* This is normally not allowed outside of the setfunction,    
        These are considered READ-ONLY, so there is no set functions, but for 
        performance reasons we do want to store them. (By not defining the xp 
        in the prop file they are safe from being changed by the set include).*/ 
      &SCOPED-DEFINE xpCLOBColumns
      &SCOPED-DEFINE xpBLOBColumns
      /* Store the result (also blank), for future requests */  
      {set LargeColumns ''}
      {set CLOBColumns  ''}
      {set BLOBColumns  ''}.
      
      &UNDEFINE xpBLOBColumns
      &UNDEFINE xpCLOBColumns
      
      &UNDEFINE xp-assign
    END.
    ELSE
      SUPER(). 

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

