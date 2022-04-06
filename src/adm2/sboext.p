&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/***********************************************************************
* Copyright (C) 2005-2007 by Progress Software Corporation. All rights *
* reserved.  Prior versions of this work may contain portions          *
* contributed by participants of Possenet.                             *
*                                                                      *
***********************************************************************/
/*--------------------------------------------------------------------------
    File        : sboext.p
    Purpose     : Super procedure for sbo class.
    Purpose     : Support procedure for sbo class.  This is an extension
                  of sbo.p.  The extension is necessary to avoid an overflow
                  of the action segment. This extension file contains
                  all of the get and set property functions. These functions 
                  will be rolled back into sbo.p when segment size increases.
                  (getTargetProcedure is in sbo.p) 
    Syntax      : adm2/dataext.p  

    Modified    : January 22, 2001 -- Version 9.1C
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */


&SCOP ADMSuper sbo.p

DEFINE VARIABLE ghTargetProcedure AS HANDLE     NO-UNDO.
  
/* Custom exclude file */

  {src/adm2/custom/sboexclcustom.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-columnPropertyList) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD columnPropertyList Procedure 
FUNCTION columnPropertyList RETURNS CHARACTER PRIVATE
  ( pcProperty AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getAuditEnabled) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getAuditEnabled Procedure 
FUNCTION getAuditEnabled RETURNS LOGICAL
  (   )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getAutoCommit) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getAutoCommit Procedure 
FUNCTION getAutoCommit RETURNS LOGICAL
  (   )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getBLOBColumns) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getBLOBColumns Procedure 
FUNCTION getBLOBColumns RETURNS CHARACTER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getBlockDataAvailable) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getBlockDataAvailable Procedure 
FUNCTION getBlockDataAvailable RETURNS LOGICAL
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getBlockQueryPositiion) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getBlockQueryPositiion Procedure 
FUNCTION getBlockQueryPositiion RETURNS LOGICAL
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getCalcFieldList) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getCalcFieldList Procedure 
FUNCTION getCalcFieldList RETURNS CHARACTER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getCalculatedColumns) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getCalculatedColumns Procedure 
FUNCTION getCalculatedColumns RETURNS CHARACTER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getCascadeOnBrowse) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getCascadeOnBrowse Procedure 
FUNCTION getCascadeOnBrowse RETURNS LOGICAL
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getCLOBColumns) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getCLOBColumns Procedure 
FUNCTION getCLOBColumns RETURNS CHARACTER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getContainedDataColumns) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getContainedDataColumns Procedure 
FUNCTION getContainedDataColumns RETURNS CHARACTER
  (   )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getContainedDataObjects) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getContainedDataObjects Procedure 
FUNCTION getContainedDataObjects RETURNS CHARACTER
  (   )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getContextForServer) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getContextForServer Procedure 
FUNCTION getContextForServer RETURNS CHARACTER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getCurrentUpdateSource) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getCurrentUpdateSource Procedure 
FUNCTION getCurrentUpdateSource RETURNS HANDLE
(  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDataColumns) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getDataColumns Procedure 
FUNCTION getDataColumns RETURNS CHARACTER
  (   )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDataHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getDataHandle Procedure 
FUNCTION getDataHandle RETURNS HANDLE
  (   )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDataIsFetched) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getDataIsFetched Procedure 
FUNCTION getDataIsFetched RETURNS LOGICAL
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDataLogicObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getDataLogicObject Procedure 
FUNCTION getDataLogicObject RETURNS HANDLE
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDataLogicProcedure) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getDataLogicProcedure Procedure 
FUNCTION getDataLogicProcedure RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDataObjectNames) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getDataObjectNames Procedure 
FUNCTION getDataObjectNames RETURNS CHARACTER
  (   )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDataObjectOrdering) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getDataObjectOrdering Procedure 
FUNCTION getDataObjectOrdering RETURNS CHARACTER
  (   )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDataQueryBrowsed) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getDataQueryBrowsed Procedure 
FUNCTION getDataQueryBrowsed RETURNS LOGICAL
  (   )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDataTargetEvents) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getDataTargetEvents Procedure 
FUNCTION getDataTargetEvents RETURNS CHARACTER
  (   )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDynamicData) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getDynamicData Procedure 
FUNCTION getDynamicData RETURNS LOGICAL
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getFetchOnOpen) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getFetchOnOpen Procedure 
FUNCTION getFetchOnOpen RETURNS CHARACTER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getFilterActive) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getFilterActive Procedure 
FUNCTION getFilterActive RETURNS LOGICAL
  (   )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getFilterAvailable) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getFilterAvailable Procedure 
FUNCTION getFilterAvailable RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getFilterWindow) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getFilterWindow Procedure 
FUNCTION getFilterWindow RETURNS CHARACTER
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

&IF DEFINED(EXCLUDE-getForeignValues) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getForeignValues Procedure 
FUNCTION getForeignValues RETURNS CHARACTER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getLargeColumns) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getLargeColumns Procedure 
FUNCTION getLargeColumns RETURNS CHARACTER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getLastCommitErrorKeys) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getLastCommitErrorKeys Procedure 
FUNCTION getLastCommitErrorKeys RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getLastCommitErrorType) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getLastCommitErrorType Procedure 
FUNCTION getLastCommitErrorType RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getMasterDataObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getMasterDataObject Procedure 
FUNCTION getMasterDataObject RETURNS HANDLE
  (   )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getNewMode) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getNewMode Procedure 
FUNCTION getNewMode RETURNS LOGICAL
    () FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getNewRow) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getNewRow Procedure 
FUNCTION getNewRow RETURNS LOGICAL
    () FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getObjectMapping) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getObjectMapping Procedure 
FUNCTION getObjectMapping RETURNS CHARACTER
  (   )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getOpenOnInit) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getOpenOnInit Procedure 
FUNCTION getOpenOnInit RETURNS LOGICAL
  ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getQueryOpen) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getQueryOpen Procedure 
FUNCTION getQueryOpen RETURNS LOGICAL
  (   )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getQueryPosition) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getQueryPosition Procedure 
FUNCTION getQueryPosition RETURNS CHARACTER
  (   )  FORWARD.

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

&IF DEFINED(EXCLUDE-getRowsToBatch) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getRowsToBatch Procedure 
FUNCTION getRowsToBatch RETURNS INTEGER
  (   )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getRowUpdated) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getRowUpdated Procedure 
FUNCTION getRowUpdated RETURNS LOGICAL
    () FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getUpdatableColumns) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getUpdatableColumns Procedure 
FUNCTION getUpdatableColumns RETURNS CHARACTER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getUpdatableWhenNew) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getUpdatableWhenNew Procedure 
FUNCTION getUpdatableWhenNew RETURNS CHARACTER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getUpdateOrder) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getUpdateOrder Procedure 
FUNCTION getUpdateOrder RETURNS CHARACTER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getUpdateTables) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getUpdateTables Procedure 
FUNCTION getUpdateTables RETURNS CHARACTER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getWordIndexedFields) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getWordIndexedFields Procedure 
FUNCTION getWordIndexedFields RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setAutoCommit) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setAutoCommit Procedure 
FUNCTION setAutoCommit RETURNS LOGICAL
  ( plCommit AS LOGICAL )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setBlockDataAvailable) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setBlockDataAvailable Procedure 
FUNCTION setBlockDataAvailable RETURNS LOGICAL
  ( plBlockDataAvailable AS LOGICAL)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setBlockQueryPosition) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setBlockQueryPosition Procedure 
FUNCTION setBlockQueryPosition RETURNS LOGICAL
 ( plBlockQueryPosition AS LOGICAL)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setCascadeOnBrowse) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setCascadeOnBrowse Procedure 
FUNCTION setCascadeOnBrowse RETURNS LOGICAL
  ( plCascade AS LOGICAL )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setCommitSource) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setCommitSource Procedure 
FUNCTION setCommitSource RETURNS LOGICAL
  ( phSource AS HANDLE )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setContainedDataColumns) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setContainedDataColumns Procedure 
FUNCTION setContainedDataColumns RETURNS LOGICAL
  ( pcColumns AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setCurrentUpdateSource) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setCurrentUpdateSource Procedure 
FUNCTION setCurrentUpdateSource RETURNS LOGICAL
( phSource AS HANDLE )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setDataDelimiter) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setDataDelimiter Procedure 
FUNCTION setDataDelimiter RETURNS LOGICAL
  ( pcDelimiter AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setDataIsFetched) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setDataIsFetched Procedure 
FUNCTION setDataIsFetched RETURNS LOGICAL
  ( plFetched AS LOG)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setDataLogicObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setDataLogicObject Procedure 
FUNCTION setDataLogicObject RETURNS LOGICAL
  ( phDataLogicObject AS HANDLE )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setDataLogicProcedure) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setDataLogicProcedure Procedure 
FUNCTION setDataLogicProcedure RETURNS LOGICAL
  ( pcDataLogicProcedure AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setDataObjectNames) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setDataObjectNames Procedure 
FUNCTION setDataObjectNames RETURNS LOGICAL
  ( pcNames AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setDataObjectOrdering) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setDataObjectOrdering Procedure 
FUNCTION setDataObjectOrdering RETURNS LOGICAL
  ( pcOrdering AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setDataQueryBrowsed) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setDataQueryBrowsed Procedure 
FUNCTION setDataQueryBrowsed RETURNS LOGICAL
  ( plBrowsed AS LOGICAL )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setDataReadBuffer) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setDataReadBuffer Procedure 
FUNCTION setDataReadBuffer RETURNS LOGICAL
  ( phReadBuffer AS HANDLE )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setDataReadFormat) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setDataReadFormat Procedure 
FUNCTION setDataReadFormat RETURNS LOGICAL
  ( pcReadFormat AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setDataReadHandler) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setDataReadHandler Procedure 
FUNCTION setDataReadHandler RETURNS LOGICAL
  ( phReadHandler AS HANDLE )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setDynamicData) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setDynamicData Procedure 
FUNCTION setDynamicData RETURNS LOGICAL
  ( plDynamic AS LOGICAL  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setFetchAutoComment) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setFetchAutoComment Procedure 
FUNCTION setFetchAutoComment RETURNS LOGICAL
  ( plValue AS LOGICAL )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setFetchHasAudit) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setFetchHasAudit Procedure 
FUNCTION setFetchHasAudit RETURNS LOGICAL
  ( plValue AS LOGICAL )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setFetchHasComment) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setFetchHasComment Procedure 
FUNCTION setFetchHasComment RETURNS LOGICAL
  ( plValue AS LOGICAL )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setFetchOnOpen) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setFetchOnOpen Procedure 
FUNCTION setFetchOnOpen RETURNS LOGICAL
  ( pcValue AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setFilterActive) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setFilterActive Procedure 
FUNCTION setFilterActive RETURNS LOGICAL
  ( plFilterActive AS LOGICAL )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setFilterAvailable) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setFilterAvailable Procedure 
FUNCTION setFilterAvailable RETURNS LOGICAL
  ( plFilterAvailable AS LOGICAL )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setFilterWindow) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setFilterWindow Procedure 
FUNCTION setFilterWindow RETURNS LOGICAL
  ( pcObject AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setForeignFields) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setForeignFields Procedure 
FUNCTION setForeignFields RETURNS LOGICAL
  ( pcFields AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setForeignValues) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setForeignValues Procedure 
FUNCTION setForeignValues RETURNS LOGICAL
  ( pcValues AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setLastCommitErrorKeys) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setLastCommitErrorKeys Procedure 
FUNCTION setLastCommitErrorKeys RETURNS LOGICAL
  ( pcLastKeys AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setLastCommitErrorType) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setLastCommitErrorType Procedure 
FUNCTION setLastCommitErrorType RETURNS LOGICAL
  ( pcLastCommitErrorType AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setObjectMapping) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setObjectMapping Procedure 
FUNCTION setObjectMapping RETURNS LOGICAL
  ( pcMapping AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setOpenOnInit) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setOpenOnInit Procedure 
FUNCTION setOpenOnInit RETURNS LOGICAL
  ( plOpenOnInit AS LOGICAL  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setRowObjectState) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setRowObjectState Procedure 
FUNCTION setRowObjectState RETURNS LOGICAL
  ( pcState AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setUpdateOrder) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setUpdateOrder Procedure 
FUNCTION setUpdateOrder RETURNS LOGICAL
  ( INPUT pcOrder AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setUpdateTables) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setUpdateTables Procedure 
FUNCTION setUpdateTables RETURNS LOGICAL
  ( pcTables AS CHAR )  FORWARD.

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
         HEIGHT             = 28.1
         WIDTH              = 53.2.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB Procedure 
/* ************************* Included-Libraries *********************** */

{src/adm2/sboprop.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-columnPropertyList) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION columnPropertyList Procedure 
FUNCTION columnPropertyList RETURNS CHARACTER PRIVATE
  ( pcProperty AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose: General purpose function to retrieve and qualify get*Columns 
           properties from the contained SDOs    
    Notes: Private  
------------------------------------------------------------------------------*/ 
  DEFINE VARIABLE cObjectNames AS CHAR   NO-UNDO.
  DEFINE VARIABLE cObjectHdls  AS CHAR   NO-UNDO.
  DEFINE VARIABLE cSDOColumns  AS CHAR   NO-UNDO.
  DEFINE VARIABLE cObject      AS CHAR   NO-UNDO.
  DEFINE VARIABLE iObject      AS INT    NO-UNDO.
  DEFINE VARIABLE hObject      AS HANDLE NO-UNDO.
  DEFINE VARIABLE iColumn      AS INT    NO-UNDO.
  DEFINE VARIABLE cColumns     AS CHAR   NO-UNDO.

  &SCOPED-DEFINE xp-assign
  {get ContainedDataObjects cObjectHdls}
  {get DataObjectNames cObjectNames}.
  &UNDEFINE xp-assign
  
  DO iObject = 1 TO NUM-ENTRIES(cObjectHdls):
    ASSIGN 
      cObject = ENTRY(iObject, cObjectNames)
      hObject = WIDGET-HANDLE(ENTRY(iObject, cObjectHdls)).
    IF VALID-HANDLE(hObject) THEN
    DO:
      cSDOColumns = DYNAMIC-FUNCTION('get':U + pcProperty IN hObject).
      /* This is the form of the column list with SDO Name qualifiers. */
      DO iColumn = 1 TO NUM-ENTRIES(cSDOColumns):
        cColumns = cColumns
                    + (IF cColumns NE "":U THEN ",":U ELSE "":U) 
                    + cObject + ".":U + ENTRY(iColumn, cSDOColumns).
      END.  /* END DO iColumn */
    END.
  END.  /* END DO iObject */
  
  RETURN cColumns.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getAuditEnabled) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getAuditEnabled Procedure 
FUNCTION getAuditEnabled RETURNS LOGICAL
  (   ) :
/*------------------------------------------------------------------------------
  Purpose: SBO version of the AuditEnabled property function.  Checks 
           for a single DataSourceName, then a single UpdateTargetName,
           otherwise, it returns false.
   Params: 
     Note: Currently used by datavis getAuditEnabled.   
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cDataSourceNames   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cUpdateTargetNames AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hObject            AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hRequester         AS HANDLE     NO-UNDO.
  
  {get TargetProcedure hRequester SOURCE-PROCEDURE} NO-ERROR.  
  IF NOT VALID-HANDLE(hRequester) THEN
     hRequester = SOURCE-PROCEDURE.

  {get DataSourceNames cDataSourceNames hRequester} NO-ERROR.  

  IF NUM-ENTRIES(cDataSourceNames) = 1 THEN
    hObject = {fnarg dataObjectHandle cDataSourceNames}.
  ELSE DO:
    {get UpdateTargetNames cUpdateTargetNames hRequester} NO-ERROR.
    IF NUM-ENTRIES(cUpdateTargetNames) = 1 THEN
      hObject = {fnarg dataObjectHandle cUpdateTargetNames}.
  END.  /* else do */
  
  IF VALID-HANDLE(hObject) THEN
    RETURN {fn getAuditEnabled hObject}.
  ELSE
    RETURN FALSE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getAutoCommit) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getAutoCommit Procedure 
FUNCTION getAutoCommit RETURNS LOGICAL
  (   ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the SBO's AutoCommit property, which is false by default,
            but if set to true will do a Commit automatically after any change.
   Params:  <none>
    Notes:  The AutoCommit property for the contained SDOs is always set to
            false in any case, because they never initiate theor own Commit
            when contained in an SBO.
------------------------------------------------------------------------------*/

  DEFINE VARIABLE lCommit AS LOGICAL    NO-UNDO.
  {get AutoCommit lCommit}.
  RETURN lCommit.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getBLOBColumns) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getBLOBColumns Procedure 
FUNCTION getBLOBColumns RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns a list of all BLOB Columns of contained DataObjects, 
            qualified by their ObjectName.
   Params:  <none>
    Notes:  There is no actual BLOBColumns property in the SBO;
            the value is derived on the fly by querying the contained SDOs.
------------------------------------------------------------------------------*/
  RETURN {fnarg columnPropertyList 'BLOBColumns'}.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getBlockDataAvailable) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getBlockDataAvailable Procedure 
FUNCTION getBlockDataAvailable RETURNS LOGICAL
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  Retruns true if DataAvailable messages from contained SDOs are
           to be ignored and not republished 
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE lBlockDataAvailable AS LOGICAL    NO-UNDO.
  {get BlockDataAvailable lBlockDataAvailable}.
  RETURN lBlockDataAvailable.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getBlockQueryPositiion) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getBlockQueryPositiion Procedure 
FUNCTION getBlockQueryPositiion RETURNS LOGICAL
  (  ) :
/*------------------------------------------------------------------------------
  Purpose: Returns true if queryPosition messages, published from contained SDOs 
           are to be ignored.
    Notes:  
------------------------------------------------------------------------------*/
   DEFINE VARIABLE lBlockQueryPosition AS LOGICAL    NO-UNDO.
  {get BlockQueryPosition lBlockQueryPosition}.
  RETURN lBlockQueryPosition.
 

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getCalcFieldList) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getCalcFieldList Procedure 
FUNCTION getCalcFieldList RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:    ACCESS_LEVEL=PRIVATE
              Returns CalcFieldList for all SDOs of the SBO.  CalcFieldList is
              is a comma-separated list of calculated field instance names 
              and their master object names.  This is for use by the 
              AppBuilder at design time and should 
              not be used by application code.
  Parameters:  
       Notes:  See 'getCalcFieldList' in adm2/queryext.p
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cContained  AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cList       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iCount      AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iCount2     AS INTEGER    NO-UNDO.
  DEFINE VARIABLE hDO         AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cNameList   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cCalcList   AS CHARACTER  NO-UNDO.

  &SCOPED-DEFINE xp-assign
  {get ContainedDataObjects cContained}
  {get DataObjectNames cNameList}.
  &UNDEFINE xp-assign

  DO iCount = 1 TO NUM-ENTRIES(cContained):
    hDO = WIDGET-HANDLE(ENTRY(iCount, cContained)).
    {get CalcFieldList cCalcList hDO}.
    IF cCalcList > '' THEN
      DO iCount2 = 1 TO NUM-ENTRIES(cCalcList):
        cList = cList + (IF cList = "" THEN "" ELSE ",":U) +
                   ENTRY(iCount, cNameList) + "." + 
                   ENTRY(iCount2, cCalcList).
      END.
  END.

  RETURN cList. 

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getCalculatedColumns) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getCalculatedColumns Procedure 
FUNCTION getCalculatedColumns RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:     Returns a comma-delimited, SDO-qualified list of the calculated 
               columns for all contained SmartDataObjects. 
  Parameters:  
       Notes:  See 'getCalculatedColumns' in adm2/queryext.p
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cContained  AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cColumns    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iCount      AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iCount2     AS INTEGER    NO-UNDO.
  DEFINE VARIABLE hDO         AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cNameList   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cCalcList   AS CHARACTER  NO-UNDO.

  &SCOPED-DEFINE xp-assign
  {get ContainedDataObjects cContained}
  {get DataObjectNames cNameList}.
  &UNDEFINE xp-assign

  DO iCount = 1 TO NUM-ENTRIES(cContained):
    hDO = WIDGET-HANDLE(ENTRY(iCount, cContained)).
    {get CalculatedColumns cCalcList hDO}.
    IF cCalcList > '' THEN
      DO iCount2 = 1 TO NUM-ENTRIES(cCalcList):
        cColumns = cColumns + (IF cColumns = "" THEN "" ELSE ",":U) +
                   ENTRY(iCount, cNameList) + "." + 
                   ENTRY(iCount2, cCalcList).
      END.
  END.

  RETURN cColumns. 

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getCascadeOnBrowse) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getCascadeOnBrowse Procedure 
FUNCTION getCascadeOnBrowse RETURNS LOGICAL
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the property which determines whether data will be retrieved
            from a dependent SDO if the parent SDO has more than one row
            in its current dataset; if true (the default), data will be 
            retrieved for the first row in the parent dataset, otherwise not.
   Params:  <none>
------------------------------------------------------------------------------*/

  DEFINE VARIABLE lCascade AS LOG    NO-UNDO.
  {get CascadeOnBrowse lCascade}.
  RETURN lCascade.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getCLOBColumns) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getCLOBColumns Procedure 
FUNCTION getCLOBColumns RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns a list of all CLOB Columns of contained DataObjects, 
            qualified by their ObjectName.
   Params:  <none>
    Notes:  There is no actual CLOBColumns property in the SBO;
            the value is derived on the fly by querying the contained SDOs.
------------------------------------------------------------------------------*/
  RETURN {fnarg columnPropertyList 'CLOBColumns'}.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getContainedDataColumns) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getContainedDataColumns Procedure 
FUNCTION getContainedDataColumns RETURNS CHARACTER
  (   ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns a delimited list of all the DataColumns of all the Data
            Objects in this SBO.
    Params: <none>
    Notes:  The list of columns for each contained Data Object is comma-delimited,
            with a semicolon between lists for each Data Object (in the same
            order as the ContainedDataObjects property).
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cColumns AS CHARACTER   NO-UNDO.
  {get ContainedDataColumns cColumns}.
  RETURN cColumns.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getContainedDataObjects) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getContainedDataObjects Procedure 
FUNCTION getContainedDataObjects RETURNS CHARACTER
  (   ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns a list of the handles of the Data Objects contained
            in this SBO.
    Params: <none>
    Notes:  Used by a SDBrowser, for example, to be able to get names and
            column lists from the individual Data Objects at design time.
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cObjects AS CHARACTER NO-UNDO.
  {get ContainedDataObjects cObjects}.
  RETURN cObjects.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getContextForServer) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getContextForServer Procedure 
FUNCTION getContextForServer RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose: Returns a paired chr(4) delimited list of context properties and 
           values for this object.   
    Notes: Called from obtainContext to add the container's own context to the 
           context. 
         - Overrides containr in order to add updateOrder to context 
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cUpdateOrder AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cContext     AS CHARACTER  NO-UNDO.

  cContext = SUPER().
  
  {get UpdateOrder cUpdateOrder}.
  
  cContext = cContext 
           + (IF cContext = '' THEN '' ELSE CHR(4))
           + 'UpdateOrder':U + CHR(4) + cUpdateOrder.
  
  RETURN cContext.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getCurrentUpdateSource) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getCurrentUpdateSource Procedure 
FUNCTION getCurrentUpdateSource RETURNS HANDLE
(  ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the current updateSource 
    Notes:  This is just set temporarily in updateState before re-publishing 
            updateState, so that the updateSource/DataTarget can avoid a 
            republish when it is the original publisher.
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hSource AS HANDLE NO-UNDO.
  {get CurrentUpdateSource hSource}.
  RETURN hSource.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDataColumns) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getDataColumns Procedure 
FUNCTION getDataColumns RETURNS CHARACTER
  (   ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns a list of all the DataColumns of all the Data
            Objects in this SBO, each qualified by the SDO ObjectName.
    Params: <none>
    Notes:  The list of columns for each contained Data Object is comma-delimited,
            and qualified by Object Names, as an alternative to the
            ContainedDataColumns form of the list which divides the list by SDO.
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cColumns AS CHARACTER   NO-UNDO.
  {get DataColumns cColumns}.
  RETURN cColumns.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDataHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getDataHandle Procedure 
FUNCTION getDataHandle RETURNS HANDLE
  (   ) :
/*------------------------------------------------------------------------------
  Purpose:     This SBO version of getDataHandle is run from a browser
               to get the query from the contained Data object.
   Params:     <none>
   Returns:    HANDLE of matching SDO's RowObject query
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hRequester    AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hDataHandle   AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cMapping      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSourceName   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cTargets      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hMaster       AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hSource       AS HANDLE     NO-UNDO.

  /* If the hRequester is a super procedure (e.g. browser.p) 
     then we must ask it for its TARGET-PROCEDURE to identify the
     actual object making the request. Otherwise just use the SOURCE */
  {get TargetProcedure hRequester SOURCE-PROCEDURE} NO-ERROR.
  
  IF NOT VALID-HANDLE (hRequester) THEN
     hRequester = SOURCE-PROCEDURE.
  
  {get DataSourceNames cSourceName hRequester} NO-ERROR. /* design time */
  
  IF cSourceName = '':U OR cSourceName = ? THEN
  DO:

    {get DataTarget cTargets} NO-ERROR.     /* design time */
    /* If the requester is a linked DataTarget we addDataTarget. */
    IF CAN-DO(cTargets,STRING(hRequester)) THEN
    DO:
      RUN addDataTarget IN TARGET-PROCEDURE (hRequester).
      /* addDataTarget will set DataSourceNames in the requester, so let's get 
         it for the logic further down */
      {get DataSourceNames cSourceName hRequester}.
    END. /* can-do(cTargets, ) */
    ELSE DO: /* NOT linked... return the master's DataHandle  */  
      {get MasterDataObject hMaster} NO-ERROR.
      {get DataHandle hDataHandle hMaster} NO-ERROR.
      RETURN hDataHandle.
    END. /* else (no DataTarget) */
  END. /* no cSourceName */

  hSource = {fnarg DataObjectHandle cSourceName}  NO-ERROR.
 
  /* If the caller is the Browse Instance Property Dialog or some other
     procedure that needs to know which SDO we connected to, tell it. 
     This is not really required anymore  (after 91B05 )... */
  RUN assignBrowseQueryObject IN SOURCE-PROCEDURE (hSource) NO-ERROR.
  
  {get DataHandle hDataHandle hSource} NO-ERROR.
  RETURN hDataHandle.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDataIsFetched) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getDataIsFetched Procedure 
FUNCTION getDataIsFetched RETURNS LOGICAL
  (  ) :
/*------------------------------------------------------------------------------
   Purpose: The SBO sets this to true in the SDO when it has fethed 
            data on the SDOs behalf in order to prevent that the SDO does 
            another server call to fetch the data it already has. 
            This is checked in query.p dataAvailable and openQuery is skipped
            if its true. It's immediately turned off after it is checked.    
    Notes: Duplicated in queryext 
Note Date: 2002/04/14     
------------------------------------------------------------------------------*/
  DEFINE VARIABLE lFetched AS LOGICAL    NO-UNDO.
  {get DataIsFetched lFetched}.

  RETURN lFetched.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDataLogicObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getDataLogicObject Procedure 
FUNCTION getDataLogicObject RETURNS HANDLE
  (  ) :
/*------------------------------------------------------------------------------
  Purpose: Returns the handle of the logic procedure that contains business
           logic for the data object. 
    Notes: initializeLogicObject starts the logical object using the 
           DataLogicProcedure property and stores its handle in this property.
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hDataLogicObject AS HANDLE     NO-UNDO.
  {get DataLogicObject hDataLogicObject}.
  RETURN hDataLogicObject.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDataLogicProcedure) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getDataLogicProcedure Procedure 
FUNCTION getDataLogicProcedure RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose: Returns the name of the logic procedure that contains  business
           logic for the data object 
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cDataLogicProcedure AS CHARACTER  NO-UNDO.
  &SCOPED-DEFINE xpDataLogicProcedure
  {get DataLogicProcedure cDataLogicProcedure}.
  &UNDEFINE xpDataLogicProcedure    
   
  RETURN cDataLogicProcedure.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDataObjectNames) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getDataObjectNames Procedure 
FUNCTION getDataObjectNames RETURNS CHARACTER
  (   ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the ordered list of ObjectNames of contained SDOs.
   Params:  <none>
    Notes:  This property is normally changed through the SBO Instance
            Property Dialog. It should not be changed until after the
            Objectnames for the SDOs within the SBO have been set.
            This fn must be run to retrieve the value so that it can check
            whether the value is still valid, which may not be the case if
            objects have been removed, added, or replaced since the SBO
            was last saved. If it no longer matches the list of contained
            SDOs, then it is blanked out so the default value will be
            recalculated.
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cNames      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cTargets    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iTarget     AS INTEGER    NO-UNDO.
  DEFINE VARIABLE hTarget     AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cObjectName AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cContained  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lQuery      AS LOGICAL    NO-UNDO.
  
  &SCOPED-DEFINE xpDataObjectNames
  {get DataObjectNames cNames}.
  &UNDEFINE xpDataObjectNames   
  
  IF cNames NE "":U THEN
  DO:
    /* Verify that all the names are in the contained Data Objects
       and vice-versa. */
    {get ContainerTarget cTargets}.
    DO iTarget = 1 TO NUM-ENTRIES(cTargets):
        hTarget = WIDGET-HANDLE(ENTRY(iTarget, cTargets)).
        {get QueryObject lQuery hTarget} NO-ERROR.
        IF lQuery THEN
          /* QueryObject is considered the definition of an SDO. Verify that
              this is in the list. */
        DO:
            {get ObjectName cObjectName hTarget}.
            cContained = cContained + 
                (IF cContained = "":U THEN "":U ELSE ",":U) +
                  cObjectName.
        END.     /* END DO if lQuery */
    END.         /* END DO iTarget -- gather up the names. */
    IF NUM-ENTRIES(cNames) NE NUM-ENTRIES(cContained) THEN
        cNames = "":U.   /* One's been added or deleted, so start over. */
    ELSE DO iTarget = 1 TO NUM-ENTRIES(cNames):
        IF LOOKUP(ENTRY(iTarget, cNames), cContained) = 0 THEN
        DO:              /* One's been changed or replaced */
            cNames = "":U.
            LEAVE.
        END.      /* END DO IF no Lookup */
    END.          /* END DO iTarget -- compare names. */
  END.            /* END DO IF cNames wasn't already blank */
            
  RETURN cNames.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDataObjectOrdering) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getDataObjectOrdering Procedure 
FUNCTION getDataObjectOrdering RETURNS CHARACTER
  (   ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the mapping of the order of Update Tables as generated
            by the AppBuilder to the developer-defined update order.
   Params:  <none>
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cOrdering AS CHARACTER  NO-UNDO.
  {get DataObjectOrdering cOrdering}.
  RETURN cOrdering.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDataQueryBrowsed) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getDataQueryBrowsed Procedure 
FUNCTION getDataQueryBrowsed RETURNS LOGICAL
  (   ) :
/*------------------------------------------------------------------------------
  Purpose:  Maps the requesting Browser (or other such client object) to the
            SDO whose query it is browsing, and passes back the DataQueryBrowsed
            property value for that SDO.
    Notes:  Uses the ObjectMapping property to map Browsers to their SDOs.
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cMapping    AS CHARACTER NO-UNDO.
  DEFINE VARIABLE iEntry      AS INTEGER   NO-UNDO.
  DEFINE VARIABLE lBrowsed    AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE hDataObject AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hRequester  AS HANDLE    NO-UNDO.

  /* First get the handle of the requesting Object. We need to ask the SOURCE
     (which is a super procedure) for its Target-Procedure, using this fn. */
  {get TargetProcedure hRequester SOURCE-PROCEDURE} NO-ERROR.
  IF NOT VALID-HANDLE(hRequester) THEN
      RETURN ?.      /* If just design-time call, just bail out. */

  {get ObjectMapping cMapping}.
  
  IF cMapping = ? THEN
     RETURN FALSE.

  iEntry = LOOKUP(STRING(hRequester), cMapping).
  
  IF iEntry NE 0 THEN
  DO:
      hDataObject = 
              WIDGET-HANDLE(ENTRY(iEntry + 1, cMapping)).
      {get DataQueryBrowsed lBrowsed hDataObject}.
      RETURN lBrowsed.
  END.          /* END DO IF Browser found in list. */
  RETURN FALSE.    

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDataTargetEvents) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getDataTargetEvents Procedure 
FUNCTION getDataTargetEvents RETURNS CHARACTER
  (   ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the list of events this object class should be subscribed
            to in its Data-Targets.
   Params:  <none>
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cEvents AS CHARACTER  NO-UNDO.
  {get DataTargetEvents cEvents}.
  RETURN cEvents.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDynamicData) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getDynamicData Procedure 
FUNCTION getDynamicData RETURNS LOGICAL
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE lDynamic AS LOGICAL    NO-UNDO.
  {get DynamicData lDynamic}.

  RETURN lDynamic.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getFetchOnOpen) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getFetchOnOpen Procedure 
FUNCTION getFetchOnOpen RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  Used only to provide a consistent interface for all Data Objects
    Notes:  Not used for SBOs. See SDO implementation.
------------------------------------------------------------------------------*/

  RETURN ?.   /* Default value. Let SDO manage it. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getFilterActive) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getFilterActive Procedure 
FUNCTION getFilterActive RETURNS LOGICAL
  (   ) :
/*------------------------------------------------------------------------------
  Purpose:  SBO version of this property function, which turns around and
            gets the QueryPosition from the SDO to which the caller is mapped.
    Params: <none>
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cSDOs      AS CHAR    NO-UNDO.
  DEFINE VARIABLE iObject    AS INT     NO-UNDO.
  DEFINE VARIABLE hObject    AS HANDLE  NO-UNDO.
  DEFINE VARIABLE cObject    AS CHAR    NO-UNDO.
  DEFINE VARIABLE hRequester AS HANDLE  NO-UNDO.
  DEFINE VARIABLE lActive    AS LOGICAL NO-UNDO.

  /* The property may have been set explicitly */
  &SCOPED-DEFINE xpFilterActive
  {get FilterActive lActive}.
  &UNDEFINE xpFilterActive
  
  /* if the value has not been set check all the SDOs mapped to the caller */ 
  IF lActive = ? THEN                                                       
  DO:
    {get TargetProcedure hRequester SOURCE-PROCEDURE} NO-ERROR.
    IF NOT VALID-HANDLE(hRequester) THEN
       hRequester = SOURCE-PROCEDURE.

    {get DataSourceNames cSDOs hRequester} NO-ERROR.
    
    IF ERROR-STATUS:ERROR THEN
      {get NavigationTargetName cSDOs hRequester} NO-ERROR.
    
    /* If requester does not have DataSourceNames or NavigationTargetName then 
     * assume all SDOs */ 
    IF ERROR-STATUS:ERROR THEN
      {get DataObjectNames cSDOs}.

    DO iObject = 1 TO NUM-ENTRIES(cSDOs):
      ASSIGN
        cObject = ENTRY(iObject,cSDOs)
        hObject = {fnarg dataObjectHandle cObject}
        lActive = {fn getFilterActive hObject}
        .
      /* If one SDO has an active Filter we will return true */ 
      IF lActive THEN
          LEAVE.
    END.
  END.

  RETURN IF lActive = ? THEN FALSE ELSE lActive. 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getFilterAvailable) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getFilterAvailable Procedure 
FUNCTION getFilterAvailable RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose: Return whether a filter is available. 
    Notes: No xp preprocessor because the set also does a publish to toolbar 
------------------------------------------------------------------------------*/
  DEFINE VARIABLE lFilterAvailable  AS LOGICAL  NO-UNDO.
  
  &SCOPED-DEFINE xpFilterAvailable 
  {get FilterAvailable lFilterAvailable}.
  &UNDEFINE xpFilterAvailable 
  
  RETURN lFilterAvailable.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getFilterWindow) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getFilterWindow Procedure 
FUNCTION getFilterWindow RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose   Return the FilterWindow property which is the name of the filter 
            container.
   Params:  none  
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cFilterWindow AS CHARACTER NO-UNDO.
  {get FilterWindow cFilterWindow}.
  RETURN cFilterWindow.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getForeignFields) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getForeignFields Procedure 
FUNCTION getForeignFields RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  returns the ForeignFields property of the SBO
   Params:  <none>
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cFields AS CHARACTER  NO-UNDO.
  {get ForeignFields cFields}.
  RETURN cFields.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getForeignValues) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getForeignValues Procedure 
FUNCTION getForeignValues RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  returns the ForeignValues property of the SBO, which holds
            the current values of the Foreign Fields.
   Params:  <none>
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cValues AS CHARACTER  NO-UNDO.
  {get ForeignValues cValues}.
  RETURN cValues.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getLargeColumns) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getLargeColumns Procedure 
FUNCTION getLargeColumns RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns a list of all Large Columns of contained DataObjects, 
            qualified by their ObjectName.
   Params:  <none>
    Notes:  There is no actual LargeColumns property in the SBO;
            the value is derived on the fly by querying the contained SDOs.
------------------------------------------------------------------------------*/
  RETURN {fnarg columnPropertyList 'LargeColumns'}.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getLastCommitErrorKeys) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getLastCommitErrorKeys Procedure 
FUNCTION getLastCommitErrorKeys RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose: Returns a list of key values separated by 'DataDelimiter' identifying
           the records that fail to be committed on the last time data was committed.
           Blank  - indicates that the last commit was successful, 
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cLastCommitErrorKeys AS CHARACTER  NO-UNDO.
  
  {get LastCommitErrorKeys cLastCommitErrorKeys}.

  RETURN cLastCommitErrorKeys. 

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getLastCommitErrorType) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getLastCommitErrorType Procedure 
FUNCTION getLastCommitErrorType RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose: Returns the type of error encountered the last time data was committed.
           Blank  - indicates that the last commit was successful, 
           unknown - indicates that a commit never has been attempted after run
           Conflict - Locking conflict
           Error    - Unspecified 
    Notes: Currently used to identify a Conflict error after having used the 
           UpdateData API. More types may be added later.   
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cLastCommitErrorType AS CHARACTER  NO-UNDO.
  
  {get LastCommitErrorType cLastCommitErrorType}.

  RETURN cLastCommitErrorType. 

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getMasterDataObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getMasterDataObject Procedure 
FUNCTION getMasterDataObject RETURNS HANDLE
  (   ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the handle of the "Master" SDO, the one which has
            no data source of its own and is the parent to other SDOs.
   Params:  <none>
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hMaster AS HANDLE NO-UNDO.
  {get MasterDataObject hMaster}.
  RETURN hMaster.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getNewMode) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getNewMode Procedure 
FUNCTION getNewMode RETURNS LOGICAL
    ():
/*------------------------------------------------------------------------------
  Purpose:     This SBO version of getNewMode.
   Params:     <none>
   Returns:    TRUE if matching SDO is in NewMode
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hRequester    AS HANDLE     NO-UNDO.
  DEFINE VARIABLE lNew          AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cMapping      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSourceNames  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSource       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cTargets      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hMaster       AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hSource       AS HANDLE     NO-UNDO.
  DEFINE VARIABLE iObject       AS INTEGER    NO-UNDO.

  /* If the hRequester is a super procedure (e.g. browser.p) 
     then we must ask it for its TARGET-PROCEDURE to identify the
     actual object making the request. Otherwise just use the SOURCE */
  {get TargetProcedure hRequester SOURCE-PROCEDURE} NO-ERROR.
  
  IF NOT VALID-HANDLE (hRequester) THEN
     hRequester = SOURCE-PROCEDURE.
  
  {get DataSourceNames cSourceNames hRequester} NO-ERROR. /* design time */
  
  IF cSourceNames = '':U OR cSourceNames = ? THEN
  DO:
    {get DataTarget cTargets} NO-ERROR.  /* Avoid errors at design time */
    /* If the requester is a linked DataTarget we addDataTarget. */
    IF CAN-DO(cTargets,STRING(hRequester)) THEN
    DO:
      RUN addDataTarget IN TARGET-PROCEDURE (hRequester).
      /* addDataTarget will set DataSourceNames in the requester, so let's get 
         it for the logic further down */
      {get DataSourceNames cSourceNames hRequester}.
    END. /* can-do(cTargets, ) */
    ELSE DO: /* NOT linked... return the master's DataHandle  */  
      {get MasterDataObject hMaster} NO-ERROR.
      IF VALID-HANDLE(hMaster) THEN
      DO:
        {get NewMode lNew hMaster}.
        RETURN lNew.
      END.
    END.
   
  END. /* no cSourceName */
  
  /* The requester may potentially have more than one source.
    (An SDO that are getting foreign fields from different SDOs for example)*/
  DO iObject = 1 TO NUM-ENTRIES(cSourceNames):
    ASSIGN
      cSource  = ENTRY(iObject,cSourceNames) 
      hSource  = {fnarg DataObjectHandle cSource}.
    {get NewMode lNew hSource} NO-ERROR.
    IF lNew THEN 
      RETURN TRUE.
  END.

  /* if we get here the requester has no new sources */
  RETURN FALSE. 

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getNewRow) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getNewRow Procedure 
FUNCTION getNewRow RETURNS LOGICAL
    ():
/*------------------------------------------------------------------------------
  Purpose:     SBO version of getNewRow.
     Params:   <none>
   Returns:    TRUE if matching SDO is a NewRow
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hRequester    AS HANDLE     NO-UNDO.
  DEFINE VARIABLE lNew          AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cMapping      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSourceNames  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSource       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cTargets      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hMaster       AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hSource       AS HANDLE     NO-UNDO.
  DEFINE VARIABLE iObject       AS INTEGER    NO-UNDO.

  /* If the hRequester is a super procedure (e.g. browser.p) 
     then we must ask it for its TARGET-PROCEDURE to identify the
     actual object making the request. Otherwise just use the SOURCE */
  {get TargetProcedure hRequester SOURCE-PROCEDURE} NO-ERROR.
  
  IF NOT VALID-HANDLE (hRequester) THEN
     hRequester = SOURCE-PROCEDURE.
  
  {get DataSourceNames cSourceNames hRequester} NO-ERROR. /* design time */
  
  IF cSourceNames = '':U OR cSourceNames = ? THEN
  DO:
    {get DataTarget cTargets} NO-ERROR.  /* Avoid errors at design time */
    /* If the requester is a linked DataTarget we addDataTarget. */
    IF CAN-DO(cTargets,STRING(hRequester)) THEN
    DO:
      RUN addDataTarget IN TARGET-PROCEDURE (hRequester).
      /* addDataTarget will set DataSourceNames in the requester, so let's get 
         it for the logic further down */
      {get DataSourceNames cSourceNames hRequester}.
    END. /* can-do(cTargets, ) */
    ELSE DO: /* NOT linked... return the master's DataHandle  */  
      {get MasterDataObject hMaster} NO-ERROR.
      IF VALID-HANDLE(hMaster) THEN
      DO:
        {get NewRow lNew hMaster}.
        RETURN lNew.
      END.
    END.
   
  END. /* no cSourceName */
  
  /* The requester may potentially have more than one source.
    (An SDO that are getting foreign fields from different SDOs for example)*/
  DO iObject = 1 TO NUM-ENTRIES(cSourceNames):
    ASSIGN
      cSource  = ENTRY(iObject,cSourceNames) 
      hSource  = {fnarg DataObjectHandle cSource}.
    
    {get NewRow lNew hSource} NO-ERROR.
    IF lNew THEN 
      RETURN TRUE.
  END.

  /* if we get here the requester has no new sources */
  RETURN FALSE. 

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getObjectMapping) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getObjectMapping Procedure 
FUNCTION getObjectMapping RETURNS CHARACTER
  (   ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns a list of handles of Navigation-Source objects (panels)
            or other objects which are mapped to contained Data Objects,
            and the SDOs the SBO has connected them up to, per their
            NavigationTargetName property or setCurrentMappedObject request.
   Params:  <none>
    Notes:  Used by queryPosition to identify which Object a queryPosition event
            should get passed on to. 
            Format is hNavSource,hSDOTarget[,...]
            This property is intended for internal use only; application code
            can run getCurrentMappedObject to get back the name of the object
            they are currently linked to.
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cMapping AS CHAR   NO-UNDO.
  {get ObjectMapping cMapping}.
  RETURN cMapping.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getOpenOnInit) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getOpenOnInit Procedure 
FUNCTION getOpenOnInit RETURNS LOGICAL
  ( ) :
/*------------------------------------------------------------------------------
  Purpose: Decides if queries should be opened at initialization.    
Parameter: <none> 
    Notes: Yes - open query at initialization 
           No  - Don;t open query at initialization 
------------------------------------------------------------------------------*/
  DEFINE VARIABLE lOpenOnInit AS LOGICAL  NO-UNDO.
  {get OpenOnInit lOpenOnInit}.
  RETURN lOpenOnInit.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getQueryOpen) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getQueryOpen Procedure 
FUNCTION getQueryOpen RETURNS LOGICAL
  (   ) :
/*------------------------------------------------------------------------------
  Purpose:  SBO version of this property function, which turns around and
            gets the QueryOpen from the SDO to which the caller is mapped.
    Params: <none>
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cMapping   AS CHAR    NO-UNDO.
  DEFINE VARIABLE iObject    AS INT     NO-UNDO.
  DEFINE VARIABLE hObject    AS HANDLE  NO-UNDO.
  DEFINE VARIABLE lQueryOpen AS LOGICAL NO-UNDO.
  DEFINE VARIABLE hrequester AS HANDLE  NO-UNDO.

  {get TargetProcedure hRequester SOURCE-PROCEDURE} NO-ERROR.
  
  IF NOT VALID-HANDLE(hRequester) THEN
     hRequester = SOURCE-PROCEDURE.

  {get ObjectMapping cMapping}.
  iObject = LOOKUP(STRING(hRequester), cMapping).

  IF iObject = 0 THEN
    {get MasterDataObject hObject} NO-ERROR.
  
  ELSE hObject = WIDGET-HANDLE(ENTRY(iObject + 1, cMapping)).
    {get QueryOpen lQueryOpen hObject} NO-ERROR.  

  RETURN lQueryOpen.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getQueryPosition) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getQueryPosition Procedure 
FUNCTION getQueryPosition RETURNS CHARACTER
  (   ) :
/*------------------------------------------------------------------------------
  Purpose:  SBO version of this property function, which turns around and
            gets the QueryPosition from the SDO to which the caller is mapped.
    Params: <none>
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cMapping   AS CHAR   NO-UNDO.
  DEFINE VARIABLE iObject    AS INT    NO-UNDO.
  DEFINE VARIABLE hObject    AS HANDLE NO-UNDO.
  DEFINE VARIABLE cPosition  AS CHAR   NO-UNDO.
  DEFINE VARIABLE hrequester AS HANDLE NO-UNDO.

  {get TargetProcedure hRequester SOURCE-PROCEDURE} NO-ERROR.
  
  IF NOT VALID-HANDLE(hRequester) THEN
     hRequester = SOURCE-PROCEDURE.

  {get ObjectMapping cMapping}.
  iObject = LOOKUP(STRING(hRequester), cMapping).
  IF iObject = 0 THEN
    {get MasterDataObject hObject} NO-ERROR.
  
  ELSE hObject = WIDGET-HANDLE(ENTRY(iObject + 1, cMapping)).
    {get QueryPosition cPosition hObject} NO-ERROR.  
  RETURN cPosition.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getRowObjectState) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getRowObjectState Procedure 
FUNCTION getRowObjectState RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:     Retrieves the property value which signals whether there are
               uncommitted updates in the object.   
  Parameters:  <none>
  Note:        The two possible return values are: 'NoUpdates' and 'RowUpdated'
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cState   AS CHARACTER NO-UNDO.
  
  &SCOPED-DEFINE xpRowObjectState
  {get RowObjectState cState}.
  &UNDEFINE xpRowObjectState 
 
  RETURN cState.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getRowsToBatch) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getRowsToBatch Procedure 
FUNCTION getRowsToBatch RETURNS INTEGER
  (   ) :
/*------------------------------------------------------------------------------
  Purpose:  Maps the requesting Browser (or other such client object) to the
            SDO whose query it is browsing, and passes back the RowsToBatch
            property value for that SDO.
    Notes:  Uses the ObjectMapping property to map Browsers to their SDOs.
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cMapping     AS CHARACTER NO-UNDO.
  DEFINE VARIABLE iEntry       AS INTEGER   NO-UNDO.
  DEFINE VARIABLE iRowsToBatch AS INTEGER   NO-UNDO.
  DEFINE VARIABLE hDataObject  AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hRequester   AS HANDLE    NO-UNDO.

  /* First get the handle of the requesting Object. We need to ask the SOURCE
     (which is a super procedure) for its Target-Procedure, using this fn. */
  {get TargetProcedure hRequester SOURCE-PROCEDURE} NO-ERROR.
  IF NOT VALID-HANDLE(hRequester) THEN
      RETURN ?.      /* If just design-time call, just bail out. */

  {get ObjectMapping cMapping}.

  iEntry = LOOKUP(STRING(hRequester), cMapping).
  IF iEntry NE 0 AND iEntry NE ? THEN
  DO:
      hDataObject = WIDGET-HANDLE(ENTRY(iEntry + 1, cMapping)).
      {get RowsToBatch iRowsToBatch hDataObject}.
      RETURN iRowsToBatch.
  END.          /* END DO IF Browser found in list. */
  ELSE RETURN 0.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getRowUpdated) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getRowUpdated Procedure 
FUNCTION getRowUpdated RETURNS LOGICAL
    ():
/*------------------------------------------------------------------------------
  Purpose:     SBO version of getNewRow.
     Params:   <none>
   Returns:    TRUE if matching SDO is a NewRow
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hRequester    AS HANDLE     NO-UNDO.
  DEFINE VARIABLE lUpdated      AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cMapping      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSourceNames  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSource       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cTargets      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hMaster       AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hSource       AS HANDLE     NO-UNDO.
  DEFINE VARIABLE iObject       AS INTEGER    NO-UNDO.

  /* If the hRequester is a super procedure (e.g. browser.p) 
     then we must ask it for its TARGET-PROCEDURE to identify the
     actual object making the request. Otherwise just use the SOURCE */
  {get TargetProcedure hRequester SOURCE-PROCEDURE} NO-ERROR.
  
  IF NOT VALID-HANDLE (hRequester) THEN
     hRequester = SOURCE-PROCEDURE.
  
  {get DataSourceNames cSourceNames hRequester} NO-ERROR. /* design time */
  
  IF cSourceNames = '':U OR cSourceNames = ? THEN
  DO:
    {get DataTarget cTargets} NO-ERROR.  /* Avoid errors at design time */
    /* If the requester is a linked DataTarget we addDataTarget. */
    IF CAN-DO(cTargets,STRING(hRequester)) THEN
    DO:
      RUN addDataTarget IN TARGET-PROCEDURE (hRequester).
      /* addDataTarget will set DataSourceNames in the requester, so let's get 
         it for the logic further down */
      {get DataSourceNames cSourceNames hRequester}.
    END. /* can-do(cTargets, ) */
    ELSE DO: /* NOT linked... return the master's DataHandle  */  
      {get MasterDataObject hMaster} NO-ERROR.
      IF VALID-HANDLE(hMaster) THEN
      DO:
        {get RowUpdated lUpdated hMaster}.
        RETURN lUpdated.
      END.
    END.
   
  END. /* no cSourceName */
  
  /* The requester may potentially have more than one source.
    (An SDO that are getting foreign fields from different SDOs for example)*/
  DO iObject = 1 TO NUM-ENTRIES(cSourceNames):
    ASSIGN
      cSource  = ENTRY(iObject,cSourceNames) 
      hSource  = {fnarg DataObjectHandle cSource}.
    
    {get RowUpdated lUpdated hSource} NO-ERROR.
    IF lUpdated THEN 
      RETURN TRUE.
  END.

  /* if we get here the requester has no new sources */
  RETURN FALSE. 

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getUpdatableColumns) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getUpdatableColumns Procedure 
FUNCTION getUpdatableColumns RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns a list of all Updatable Columns of contained
            DataObjects, qualified by their ObjectName.
   Params:  <none>
    Notes:  There is no actual UpdatableColumns property in the SBO;
            the value is derived on the fly by querying the contained SDOs.
------------------------------------------------------------------------------*/
  RETURN {fnarg columnPropertyList 'UpdatableColumns':U}.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getUpdatableWhenNew) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getUpdatableWhenNew Procedure 
FUNCTION getUpdatableWhenNew RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns a list of all UpdatableWhenNew Columns of contained
            DataObjects, qualified by their ObjectName.
   Params:  <none>
    Notes:   
------------------------------------------------------------------------------*/
  RETURN {fnarg columnPropertyList 'UpdatableWhenNew':U}.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getUpdateOrder) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getUpdateOrder Procedure 
FUNCTION getUpdateOrder RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cOrder AS CHARACTER  NO-UNDO.
  {get UpdateOrder cOrder}.
  RETURN cOrder.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getUpdateTables) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getUpdateTables Procedure 
FUNCTION getUpdateTables RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cTables AS CHAR   NO-UNDO.
  {get UpdateTables cTables}.
  RETURN cTables.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getWordIndexedFields) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getWordIndexedFields Procedure 
FUNCTION getWordIndexedFields RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose: Return a comma separeted list of wordindexed fields 
    Notes: Qualifed with object name  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cContained  AS CHAR      NO-UNDO.
  DEFINE VARIABLE hSDO        AS HANDLE    NO-UNDO.
  DEFINE VARIABLE iSDO        AS INTEGER   NO-UNDO.
  DEFINE VARIABLE iField      AS INTEGER   NO-UNDO.
  DEFINE VARIABLE cField      AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cSDOFields  AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cFieldList  AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cObjectName AS CHARACTER NO-UNDO.
  
  DO iSDO = 1 TO NUM-ENTRIES(cContained):
    ASSIGN 
      hSDO        = WIDGET-HANDLE(ENTRY(iSDO,cContained))
      cSDOFields  = {fn getWordIndexedFields hSDO}
      cObjectName = {fn getObjectName hSDO}.

    DO iField = 1 TO NUM-ENTRIES(cSDOFields):
      ASSIGN
        cField = cObjectName + ".":U + ENTRY(iField,cSDOFields)
        ENTRY(iField,cSDOFields) = cField.
    END.

    cFieldList = cFieldList 
                  + (IF cFieldList = '':U THEN '':U ELSE ',':U)
                  + cSDOFields.
    RETURN cFieldList.
  END.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setAutoCommit) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setAutoCommit Procedure 
FUNCTION setAutoCommit RETURNS LOGICAL
  ( plCommit AS LOGICAL ) :
/*------------------------------------------------------------------------------
  Purpose:  Sets the SBO's AutoCommit property, which is false by default,
            but if set to true will do a Commit automatically after any change.
   Params:  plCommit AS LOGICAL
    Notes:  The AutoCommit property for the contained SDOs is always set to
            false in any case, because they never initiate theor own Commit
            when contained in an SBO.
------------------------------------------------------------------------------*/

  {set AutoCommit plCommit}.
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setBlockDataAvailable) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setBlockDataAvailable Procedure 
FUNCTION setBlockDataAvailable RETURNS LOGICAL
  ( plBlockDataAvailable AS LOGICAL) :
/*------------------------------------------------------------------------------
  Purpose: Set to true to block outgoing DataAvailable  
    Notes: Set to temporarily block outgoing messages during updates.     
------------------------------------------------------------------------------*/
 {set BlockDataAvailable plBlockDataAvailable}.
 RETURN TRUE.  

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setBlockQueryPosition) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setBlockQueryPosition Procedure 
FUNCTION setBlockQueryPosition RETURNS LOGICAL
 ( plBlockQueryPosition AS LOGICAL) :
/*------------------------------------------------------------------------------
  Purpose: Set to true to block outgoing queryPosition  
    Notes: 
------------------------------------------------------------------------------*/
 {set BlockQueryPosition plBlockQueryPosition}.
 RETURN TRUE.  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setCascadeOnBrowse) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setCascadeOnBrowse Procedure 
FUNCTION setCascadeOnBrowse RETURNS LOGICAL
  ( plCascade AS LOGICAL ) :
/*------------------------------------------------------------------------------
  Purpose:  Sets a property which determines whether data will be retrieved
            from a dependent SDO if the parent SDO has more than one row
            in its current dataset; if true (the default), data will be 
            retrieved for the first row in the parent dataset, otherwise not.
   Params:  plCascade AS LOGICAL
------------------------------------------------------------------------------*/

  {set CascadeOnBrowse plCascade}.
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setCommitSource) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setCommitSource Procedure 
FUNCTION setCommitSource RETURNS LOGICAL
  ( phSource AS HANDLE ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes: Override in order to set AutoCommit    
------------------------------------------------------------------------------*/
  DEFINE VARIABLE lOk AS LOGICAL    NO-UNDO.
  
  lOk = SUPER(phSource).
  
  /* turn off autocommit if a valid commitSource is set */
  IF lOk THEN
    {set AutoCommit NOT(VALID-HANDLE(phSource))}.

  RETURN lok.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setContainedDataColumns) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setContainedDataColumns Procedure 
FUNCTION setContainedDataColumns RETURNS LOGICAL
  ( pcColumns AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Sets a delimited list of all the DataColumns of all the Data
            Objects in this SBO.
    Params: pcColumns AS CHARACTER
    Notes:  The list of columns for each contained Data Object is comma-delimited,
            with a semicolon between lists for each Data Object (in the same
            order as the ContainedDataObjects property).
------------------------------------------------------------------------------*/

  {set ContainedDataColumns pcColumns}.
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setCurrentUpdateSource) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setCurrentUpdateSource Procedure 
FUNCTION setCurrentUpdateSource RETURNS LOGICAL
( phSource AS HANDLE ) :
/*------------------------------------------------------------------------------
  Purpose:  Set the current updateSource 
    Notes:  This is just set temporarily in updateState before re-publishing 
            updateState, so that the updateSource/DataTarget can avoid a 
            republish when it is the original publisher.
------------------------------------------------------------------------------*/
  {set CurrentUpdateSource phSource}.
  RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setDataDelimiter) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setDataDelimiter Procedure 
FUNCTION setDataDelimiter RETURNS LOGICAL
  ( pcDelimiter AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
DEFINE VARIABLE cContained AS CHARACTER  NO-UNDO.
DEFINE VARIABLE hObject    AS HANDLE     NO-UNDO.
DEFINE VARIABLE iCount     AS INTEGER    NO-UNDO.

  {get ContainedDataObjects cContained}.
  DO iCount = 1 TO NUM-ENTRIES(cContained):
    hObject = WIDGET-HANDLE(ENTRY(iCount, cContained)).
    IF VALID-HANDLE(hObject) THEN
      {set DataDelimiter pcDelimiter hObject}.
  END.

  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setDataIsFetched) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setDataIsFetched Procedure 
FUNCTION setDataIsFetched RETURNS LOGICAL
  ( plFetched AS LOG) :
/*------------------------------------------------------------------------------
  Purpose: The SBO sets this to true in the SDO when it has fethed 
           data on the SDOs behalf in order to prevent that the SDO 
           does another server call to fetch the data it already has. 
           The SDO checks it in dataAvailable and avoids openQuery if its true.
           It's immediately turned off after it is checked.    
    Notes: Duplicated in queryext 
Note Date: 2002/04/14    
------------------------------------------------------------------------------*/
  {set DataIsFetched plFetched}.
  
  RETURN TRUE.   

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setDataLogicObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setDataLogicObject Procedure 
FUNCTION setDataLogicObject RETURNS LOGICAL
  ( phDataLogicObject AS HANDLE ) :
/*------------------------------------------------------------------------------
  Purpose: Set the handle of the logic procedure that contains business
           logic for the data object. 
    Notes: initializeLogicObject starts the logical object using the 
           DataLogicProcedure properrty and stores its handle in this property.
------------------------------------------------------------------------------*/
  {set DataLogicObject phDataLogicObject}.
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setDataLogicProcedure) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setDataLogicProcedure Procedure 
FUNCTION setDataLogicProcedure RETURNS LOGICAL
  ( pcDataLogicProcedure AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose: Set the name of the logic procedure that contains business logic for 
           the data object. 
    Notes:  
------------------------------------------------------------------------------*/  
  IF pcDataLogicProcedure > '':U THEN     
  DO:
    &SCOPED-DEFINE xpDataLogicProcedure
    {set DataLogicProcedure pcDataLogicProcedure}.
    &UNDEFINE xpDataLogicProcedure    
    /* Add the datalogic procedure as a super  */
    RUN initializeLogicObject IN TARGET-PROCEDURE.
  END.
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setDataObjectNames) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setDataObjectNames Procedure 
FUNCTION setDataObjectNames RETURNS LOGICAL
  ( pcNames AS CHARACTER ) :
/*------------------------------------------------------------------------------
   Purpose:  Sets the ordered list of ObjectNames of contained SDOs.
   Params:  INPUT pcNames AS CHARACTER
    Notes:  This property is normally changed through the SBO Instance
            Property Dialog. It should not be changed until after the
            Objectnames for the SDOs within the SBO have been set.
            The get and set fns must be run to manipulate the value so that
            the get fn can verify that the current value is still valid.
------------------------------------------------------------------------------*/
  &SCOPED-DEFINE xpDataObjectNames
  {set DataObjectNames pcNames}.
  &UNDEFINE xpDataObjectNames
  
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setDataObjectOrdering) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setDataObjectOrdering Procedure 
FUNCTION setDataObjectOrdering RETURNS LOGICAL
  ( pcOrdering AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Set the mapping of the order of Update Tables as generated
            by the AppBuilder to the developer-defined update order.
   Params:  <none>
------------------------------------------------------------------------------*/
  {set DataObjectOrdering pcOrdering}.
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setDataQueryBrowsed) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setDataQueryBrowsed Procedure 
FUNCTION setDataQueryBrowsed RETURNS LOGICAL
  ( plBrowsed AS LOGICAL ) :
/*------------------------------------------------------------------------------
  Purpose:  SBO version of setDataQueryBrowsed locates the contained SDO
            which matches the calling Browser and sets the corresponding
            property in it. 
   Params:  plBrowsed as LOGICAL
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cMapping    AS CHARACTER NO-UNDO.
  DEFINE VARIABLE iEntry      AS INTEGER   NO-UNDO.
  DEFINE VARIABLE lBrowsed    AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE hDataObject AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hRequester  AS HANDLE    NO-UNDO.

  /* First get the handle of the requesting Object. We need to ask the SOURCE
     (which is a super procedure) for its Target-Procedure, using this fn. */
  {get TargetProcedure hRequester SOURCE-PROCEDURE}.

  {get ObjectMapping cMapping}.
  IF cMapping = ? THEN
     RETURN FALSE.

  iEntry = LOOKUP(STRING(hRequester), cMapping).
  IF iEntry NE 0 THEN
  DO:
      hDataObject = 
              WIDGET-HANDLE(ENTRY(iEntry + 1, cMapping)).
      {set DataQueryBrowsed plBrowsed hDataObject}.
      RETURN TRUE.
  END.          /* END DO IF Browser found in list. */
  
  RETURN FALSE.    

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setDataReadBuffer) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setDataReadBuffer Procedure 
FUNCTION setDataReadBuffer RETURNS LOGICAL
  ( phReadBuffer AS HANDLE ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
DEFINE VARIABLE cContained AS CHARACTER  NO-UNDO.
DEFINE VARIABLE hObject    AS HANDLE     NO-UNDO.
DEFINE VARIABLE iCount     AS INTEGER    NO-UNDO.

  {get ContainedDataObjects cContained}.
  DO iCount = 1 TO NUM-ENTRIES(cContained):
    hObject = WIDGET-HANDLE(ENTRY(iCount, cContained)).
    IF VALID-HANDLE(hObject) THEN
      {set DataReadBuffer phReadBuffer hObject}.
  END.

  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setDataReadFormat) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setDataReadFormat Procedure 
FUNCTION setDataReadFormat RETURNS LOGICAL
  ( pcReadFormat AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
DEFINE VARIABLE cContained AS CHARACTER  NO-UNDO.
DEFINE VARIABLE hObject    AS HANDLE     NO-UNDO.
DEFINE VARIABLE iCount     AS INTEGER    NO-UNDO.

  {get ContainedDataObjects cContained}.
  DO iCount = 1 TO NUM-ENTRIES(cContained):
    hObject = WIDGET-HANDLE(ENTRY(iCount, cContained)).
    IF VALID-HANDLE(hObject) THEN
      {set DataReadFormat pcReadFormat hObject}.
  END.

  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setDataReadHandler) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setDataReadHandler Procedure 
FUNCTION setDataReadHandler RETURNS LOGICAL
  ( phReadHandler AS HANDLE ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
DEFINE VARIABLE cContained AS CHARACTER  NO-UNDO.
DEFINE VARIABLE hObject    AS HANDLE     NO-UNDO.
DEFINE VARIABLE iCount     AS INTEGER    NO-UNDO.

  {get ContainedDataObjects cContained}.
  DO iCount = 1 TO NUM-ENTRIES(cContained):
    hObject = WIDGET-HANDLE(ENTRY(iCount, cContained)).
    IF VALID-HANDLE(hObject) THEN
      {set DataReadHandler phReadHandler hObject}.
  END.

  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setDynamicData) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setDynamicData Procedure 
FUNCTION setDynamicData RETURNS LOGICAL
  ( plDynamic AS LOGICAL  ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  {set DynamicData plDynamic}.
  
  RETURN TRUE.   

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setFetchAutoComment) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setFetchAutoComment Procedure 
FUNCTION setFetchAutoComment RETURNS LOGICAL
  ( plValue AS LOGICAL ) :
/*------------------------------------------------------------------------------
  Purpose:  SBO version of setFetchAutoComment locates the contained SDO
            which matches the calling Browser and sets the corresponding
            property in it. 
   Params:  plValue as LOGICAL
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cMapping    AS CHARACTER NO-UNDO.
  DEFINE VARIABLE iEntry      AS INTEGER   NO-UNDO.
  DEFINE VARIABLE lBrowsed    AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE hDataObject AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hRequester  AS HANDLE    NO-UNDO.

  /* First get the handle of the requesting Object. We need to ask the SOURCE
     (which is a super procedure) for its Target-Procedure, using this fn. */
  {get TargetProcedure hRequester SOURCE-PROCEDURE}.
  IF hRequester = ? THEN
    RETURN FALSE.

  {get ObjectMapping cMapping}.
  IF cMapping = ? THEN
     RETURN FALSE.

  iEntry = LOOKUP(STRING(hRequester), cMapping).
  IF iEntry NE 0 THEN
  DO:
      hDataObject = 
              WIDGET-HANDLE(ENTRY(iEntry + 1, cMapping)).
      {set FetchAutoComment plValue hDataObject}.
      RETURN TRUE.
  END.          /* END DO IF Browser found in list. */
  
  RETURN FALSE.    

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setFetchHasAudit) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setFetchHasAudit Procedure 
FUNCTION setFetchHasAudit RETURNS LOGICAL
  ( plValue AS LOGICAL ) :
/*------------------------------------------------------------------------------
  Purpose:  SBO version of setFetchHasAudit locates the contained SDO
            which matches the calling Browser and sets the corresponding
            property in it. 
   Params:  plValue as LOGICAL
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cMapping    AS CHARACTER NO-UNDO.
  DEFINE VARIABLE iEntry      AS INTEGER   NO-UNDO.
  DEFINE VARIABLE lBrowsed    AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE hDataObject AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hRequester  AS HANDLE    NO-UNDO.

  /* First get the handle of the requesting Object. We need to ask the SOURCE
     (which is a super procedure) for its Target-Procedure, using this fn. */
  {get TargetProcedure hRequester SOURCE-PROCEDURE}.
  IF hRequester = ? THEN
    RETURN FALSE.

  {get ObjectMapping cMapping}.
  IF cMapping = ? THEN
     RETURN FALSE.

  iEntry = LOOKUP(STRING(hRequester), cMapping).
  IF iEntry NE 0 THEN
  DO:
      hDataObject = 
              WIDGET-HANDLE(ENTRY(iEntry + 1, cMapping)).
      {set FetchHasAudit plValue hDataObject}.
      RETURN TRUE.
  END.          /* END DO IF Browser found in list. */
  
  RETURN FALSE.    

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setFetchHasComment) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setFetchHasComment Procedure 
FUNCTION setFetchHasComment RETURNS LOGICAL
  ( plValue AS LOGICAL ) :
/*------------------------------------------------------------------------------
  Purpose:  SBO version of setFetchHasComment locates the contained SDO
            which matches the calling Browser and sets the corresponding
            property in it. 
   Params:  plValue as LOGICAL
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cMapping    AS CHARACTER NO-UNDO.
  DEFINE VARIABLE iEntry      AS INTEGER   NO-UNDO.
  DEFINE VARIABLE lBrowsed    AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE hDataObject AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hRequester  AS HANDLE    NO-UNDO.

  /* First get the handle of the requesting Object. We need to ask the SOURCE
     (which is a super procedure) for its Target-Procedure, using this fn. */
  {get TargetProcedure hRequester SOURCE-PROCEDURE}.
  IF hRequester = ? THEN
    RETURN FALSE.

  {get ObjectMapping cMapping}.
  IF cMapping = ? THEN
     RETURN FALSE.

  iEntry = LOOKUP(STRING(hRequester), cMapping).
  IF iEntry NE 0 THEN
  DO:
      hDataObject = 
              WIDGET-HANDLE(ENTRY(iEntry + 1, cMapping)).
      {set FetchHasComment plValue hDataObject}.
      RETURN TRUE.
  END.          /* END DO IF Browser found in list. */
  
  RETURN FALSE.    

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setFetchOnOpen) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setFetchOnOpen Procedure 
FUNCTION setFetchOnOpen RETURNS LOGICAL
  ( pcValue AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  To provide a consistent interface for SBO and SDO objects
    Notes:  Not used for SBOs. See SDO implementation.
------------------------------------------------------------------------------*/

  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setFilterActive) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setFilterActive Procedure 
FUNCTION setFilterActive RETURNS LOGICAL
  ( plFilterActive AS LOGICAL ) :
/*------------------------------------------------------------------------------
  Purpose: Set a flag to indicate that a filter is active.  
    Notes: No xp preprocessor because the getFilterActive also checks the 
           callers DataTargetNames.   
------------------------------------------------------------------------------*/  
  &SCOPED-DEFINE xpFilterActive 
  {set FilterActive plFilterActive}.
  &UNDEFINE xpFilterActive 
      
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setFilterAvailable) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setFilterAvailable Procedure 
FUNCTION setFilterAvailable RETURNS LOGICAL
  ( plFilterAvailable AS LOGICAL ) :
/*------------------------------------------------------------------------------
  Purpose: Set a flag to indicate that filter is available.
    Notes: ALso update the FilterWindow property for StartFilter. 
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hFilterSource     AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cFilterWindow     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hFilterContainer  AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hMyContainer      AS HANDLE     NO-UNDO.

  &SCOPED-DEFINE xpFilterAvailable 
  {set FilterAvailable plFilterAvailable}.
  &UNDEFINE xpFilterAvailable 

  /* This info is used by startFilter */
  {get FilterWindow cFilterWindow}.
  IF cFilterWindow = '':U OR cFilterWindow = ? THEN
  DO:
    {get FilterSource hFilterSource}.
    IF VALID-HANDLE(hFilterSource) THEN
    DO:
      {get ContainerSource hFilterContainer hFilterSource}.
      {get ContainerSource hMyContainer}.    
      IF hMyContainer <> hFilterContainer AND VALID-HANDLE(hFilterContainer) THEN
        {set FilterWindow hFilterContainer:FILE-NAME}.
    END.
  END.

  /* The toolbar is subscribing to filteravailble from the navigation link*/
  IF plFilterAvailable THEN 
     PUBLISH "FilterState":U FROM TARGET-PROCEDURE ("FilterAvailable":U).
   
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setFilterWindow) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setFilterWindow Procedure 
FUNCTION setFilterWindow RETURNS LOGICAL
  ( pcObject AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Sets the FilterWindow property which is the name of the filter 
            container.
   Params:  pcObject -- Procedure name
    Notes:  
------------------------------------------------------------------------------*/
  {set FilterWindow pcObject}.
  RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setForeignFields) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setForeignFields Procedure 
FUNCTION setForeignFields RETURNS LOGICAL
  ( pcFields AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Sets the ForeignFields property
   Params:  pcFields AS CHARACTER
------------------------------------------------------------------------------*/

  {set ForeignFields pcFields}.
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setForeignValues) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setForeignValues Procedure 
FUNCTION setForeignValues RETURNS LOGICAL
  ( pcValues AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Sets the ForeignValues property
   Params:  pcValues AS CHARACTER
------------------------------------------------------------------------------*/

  {set ForeignValues pcValues}.
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setLastCommitErrorKeys) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setLastCommitErrorKeys Procedure 
FUNCTION setLastCommitErrorKeys RETURNS LOGICAL
  ( pcLastKeys AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose: Sets a list of key values separated by 'DataDelimiter' identifying
           the records that fail to be committed on the last time data was committed.
           Blank  - indicates that the last commit was successful, 
------------------------------------------------------------------------------*/

  {set LastCommitErrorKeys pcLastKeys}.

  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setLastCommitErrorType) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setLastCommitErrorType Procedure 
FUNCTION setLastCommitErrorType RETURNS LOGICAL
  ( pcLastCommitErrorType AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose: Set the type of error encountered the last time data was committed.
           Conflict - Locking conflict
           Error    - Unspecified 
    Notes: Currently used to identify a Conflict error after having used the 
           UpdateData API. More types may be added later.   
        -  This should only be set by data.p commit() 
------------------------------------------------------------------------------*/  

  {set LastCommitErrorType pcLastCommitErrorType}.
  
  RETURN TRUE.
  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setObjectMapping) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setObjectMapping Procedure 
FUNCTION setObjectMapping RETURNS LOGICAL
  ( pcMapping AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Sets a list of handles of Navigation-Source objects (panels)
            or other objects which are mapped to contained Data Objects,
            and the SDOs the SBO has connected them up to, per their
            NavigationTargetName property or setCurrentMappedObject request.
   Params:  pcMapping AS CHARACTER
    Notes:  Used e.g. by queryPosition to identify which Object a 
            queryPosition event should get passed on to. 
            Format is hSource,hSDOTarget[,...]
            This property is intended for internal use only. Application code
            can run get/setCurrentMappedObject to modify or read it.
------------------------------------------------------------------------------*/
  {set ObjectMapping pcMapping}.  

  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setOpenOnInit) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setOpenOnInit Procedure 
FUNCTION setOpenOnInit RETURNS LOGICAL
  ( plOpenOnInit AS LOGICAL  ) :
/*------------------------------------------------------------------------------
  Purpose: Set to false if queries should not be opened at initialization.    
Parameter: plOpenOnInit 
                 Yes - open query at initialization 
                 No  - Don;t open query at initialization 
    Notes:  
------------------------------------------------------------------------------*/
  {set OpenOnInit plOpenOnInit}.
  RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setRowObjectState) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setRowObjectState Procedure 
FUNCTION setRowObjectState RETURNS LOGICAL
  ( pcState AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Sets the RowObjectState property, which keeps track of whether
            there are uncommitted updates in the object. PUBLISHes the
            same event to (e.g.) a Commit Panel to reset itself.
 
  Parameters:
    INPUT pcState - Can only be 'RowUpdated' OR 'NoUpdates'
------------------------------------------------------------------------------*/
  &SCOPED-DEFINE xpRowObjectState
  {set RowObjectState pcState}.
  &UNDEFINE xpRowObjectState
  
  PUBLISH 'rowObjectState':U FROM TARGET-PROCEDURE (pcState).

  /* If this is the end of a Commit, then send the UpdateComplete message
     as well so that, for example, a Navigation panel which was disabled
     throughout the update process will be re-enabled. */
  IF pcState = 'NoUpdates':U THEN
      PUBLISH 'updateState':U FROM TARGET-PROCEDURE ('UpdateComplete':U).
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setUpdateOrder) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setUpdateOrder Procedure 
FUNCTION setUpdateOrder RETURNS LOGICAL
  ( INPUT pcOrder AS CHAR ) :
/*------------------------------------------------------------------------------
   Purpose:  Sets the ordered list of ObjectNames of contained SDOs.
   Params:  INPUT pcOrder AS CHARACTER
    Notes:  This property is normally changed through the SBO Instance
            Property Dialog. 
------------------------------------------------------------------------------*/
  {set UpdateOrder pcOrder}.
  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setUpdateTables) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setUpdateTables Procedure 
FUNCTION setUpdateTables RETURNS LOGICAL
  ( pcTables AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  {set UpdateTables pcTables}.  

  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

