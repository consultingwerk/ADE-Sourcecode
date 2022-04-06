&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/***********************************************************************
* Copyright (C) 2006-2007 by Progress Software Corporation. All rights *
* reserved.  Prior versions of this work may contain portions          *
* contributed by participants of Possenet.                             *
*                                                                      *
***********************************************************************/
/*--------------------------------------------------------------------------
    File        : dataquery.p
    Purpose     : Super procedure for dataquery class.
                  Contains common logic for data objects (query objects) 
    Syntax      : RUN start-super-proc("adm2/dataquery.p":U).

    Created     : 06/21/2006
    Notes       : The class is (sort of) abstract in the sense that it is not 
                  intended for direct instantiation, only subclassing. 
                  There may even be properties defined in this class that only 
                  have getters and setters implemented in subclasses
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */


&SCOP ADMSuper dataquery.p

/* Custom exclude file */
{src/adm2/custom/dataquerycustom.i}
  
{src/adm2/ttsdoout.i}
 
&SCOPED-DEFINE MaxBreaks 16  /* core limit on number of BY  */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-addForeignKey) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD addForeignKey Procedure 
FUNCTION addForeignKey RETURNS LOGICAL
  ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-assignBufferOuterJoin) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD assignBufferOuterJoin Procedure 
FUNCTION assignBufferOuterJoin RETURNS CHARACTER
  ( pcBuffer as char,
    pcQuery  as char) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-assignQuerySelection) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD assignQuerySelection Procedure 
FUNCTION assignQuerySelection RETURNS LOGICAL
  (pcColumns   AS CHARACTER,   
   pcValues    AS CHARACTER,    
   pcOperators AS CHARACTER) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-bufferHasOuterJoin) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD bufferHasOuterJoin Procedure 
FUNCTION bufferHasOuterJoin RETURNS logical
    ( pcBuffer as char,
      pcQuery  as char) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-bufferHasOuterJoinDefault) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD bufferHasOuterJoinDefault Procedure 
FUNCTION bufferHasOuterJoinDefault RETURNS LOGICAL
  ( pcBuffer as char) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-bufferWhereClause) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD bufferWhereClause Procedure 
FUNCTION bufferWhereClause RETURNS CHARACTER
  (pcBuffer AS CHAR,
   pcWhere  AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-calcBatchSize) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD calcBatchSize Procedure 
FUNCTION calcBatchSize RETURNS INTEGER
        ( piNeeded as int) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnQuerySelection) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD columnQuerySelection Procedure 
FUNCTION columnQuerySelection RETURNS CHARACTER
  ( pcColumn AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-compareClobValues) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD compareClobValues Procedure 
FUNCTION compareClobValues RETURNS LOGICAL
  ( phColumn1  AS HANDLE,
    pcOperator AS CHAR,
    phcolumn2  AS HANDLE,
    pcStrength AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-compareFieldValues) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD compareFieldValues Procedure 
FUNCTION compareFieldValues RETURNS LOGICAL
  ( phColumn1  AS HANDLE,
    piExtent1  AS INTEGER,
    pcOperator AS CHAR,
    phColumn2  AS HANDLE,
    piExtent2  AS INTEGER,
    pcStrength AS CHAR) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-findRow) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD findRow Procedure 
FUNCTION findRow RETURNS LOGICAL
  (pcKeyValues AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-firstRowids) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD firstRowids Procedure 
FUNCTION firstRowids RETURNS CHARACTER
  (pcQueryString AS CHARACTER )  FORWARD.

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

&IF DEFINED(EXCLUDE-getBLOBColumns) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getBLOBColumns Procedure 
FUNCTION getBLOBColumns RETURNS CHARACTER
  ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getBufferHandles) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getBufferHandles Procedure 
FUNCTION getBufferHandles RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getCLOBColumns) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getCLOBColumns Procedure 
FUNCTION getCLOBColumns RETURNS CHARACTER
  ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getCommitSource) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getCommitSource Procedure 
FUNCTION getCommitSource RETURNS HANDLE
  ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getCommitSourceEvents) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getCommitSourceEvents Procedure 
FUNCTION getCommitSourceEvents RETURNS CHARACTER
(  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getCommitTarget) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getCommitTarget Procedure 
FUNCTION getCommitTarget RETURNS CHARACTER
  ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getCommitTargetEvents) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getCommitTargetEvents Procedure 
FUNCTION getCommitTargetEvents RETURNS CHARACTER
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
  ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDataHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getDataHandle Procedure 
FUNCTION getDataHandle RETURNS HANDLE
  (  )  FORWARD.

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

&IF DEFINED(EXCLUDE-getDataModified) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getDataModified Procedure 
FUNCTION getDataModified RETURNS LOGICAL
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDataQueryBrowsed) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getDataQueryBrowsed Procedure 
FUNCTION getDataQueryBrowsed RETURNS LOGICAL
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDataQueryString) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getDataQueryString Procedure 
FUNCTION getDataQueryString RETURNS CHARACTER
  (  )  FORWARD.

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

&IF DEFINED(EXCLUDE-getFetchOnOpen) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getFetchOnOpen Procedure 
FUNCTION getFetchOnOpen RETURNS CHARACTER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getFillBatchOnRepos) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getFillBatchOnRepos Procedure 
FUNCTION getFillBatchOnRepos RETURNS LOGICAL
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getFilterActive) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getFilterActive Procedure 
FUNCTION getFilterActive RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

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

&IF DEFINED(EXCLUDE-getFilterSource) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getFilterSource Procedure 
FUNCTION getFilterSource RETURNS HANDLE
  ( )  FORWARD.

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

&IF DEFINED(EXCLUDE-getFirstRowNum) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getFirstRowNum Procedure 
FUNCTION getFirstRowNum RETURNS INTEGER
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

&IF DEFINED(EXCLUDE-getIgnoreTreeViewFilter) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getIgnoreTreeViewFilter Procedure 
FUNCTION getIgnoreTreeViewFilter RETURNS LOGICAL
  ( )  FORWARD.

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
    ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getLargeColumns) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getLargeColumns Procedure 
FUNCTION getLargeColumns RETURNS CHARACTER
  ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getLastRowNum) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getLastRowNum Procedure 
FUNCTION getLastRowNum RETURNS INTEGER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getNavigationSource) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getNavigationSource Procedure 
FUNCTION getNavigationSource RETURNS CHAR
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getNavigationSourceEvents) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getNavigationSourceEvents Procedure 
FUNCTION getNavigationSourceEvents RETURNS CHARACTER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getOpenOnInit) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getOpenOnInit Procedure 
FUNCTION getOpenOnInit RETURNS LOGICAL
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getPositionSource) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getPositionSource Procedure 
FUNCTION getPositionSource RETURNS HANDLE
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getPrimarySDOSource) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getPrimarySDOSource Procedure 
FUNCTION getPrimarySDOSource RETURNS HANDLE
  ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getPromptColumns) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getPromptColumns Procedure 
FUNCTION getPromptColumns RETURNS CHARACTER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getPromptOnDelete) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getPromptOnDelete Procedure 
FUNCTION getPromptOnDelete RETURNS LOGICAL
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getQueryColumns) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getQueryColumns Procedure 
FUNCTION getQueryColumns RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getQueryHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getQueryHandle Procedure 
FUNCTION getQueryHandle RETURNS HANDLE
  ( /* parameter-definitions */ )  FORWARD.

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

&IF DEFINED(EXCLUDE-getQuerySort) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getQuerySort Procedure 
FUNCTION getQuerySort RETURNS CHARACTER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getQuerySortDefault) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getQuerySortDefault Procedure 
FUNCTION getQuerySortDefault RETURNS CHARACTER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getQueryString) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getQueryString Procedure 
FUNCTION getQueryString RETURNS CHARACTER
  ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getRebuildOnRepos) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getRebuildOnRepos Procedure 
FUNCTION getRebuildOnRepos RETURNS LOGICAL
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getRowObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getRowObject Procedure 
FUNCTION getRowObject RETURNS HANDLE
  ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getRowsToBatch) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getRowsToBatch Procedure 
FUNCTION getRowsToBatch RETURNS INTEGER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getTables) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getTables Procedure 
FUNCTION getTables RETURNS CHARACTER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getToggleDataTargets) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getToggleDataTargets Procedure 
FUNCTION getToggleDataTargets RETURNS LOGICAL
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getToggleOuterJoin) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getToggleOuterJoin Procedure 
FUNCTION getToggleOuterJoin RETURNS LOGICAL
  (   )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getTransferChildrenForAll) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getTransferChildrenForAll Procedure 
FUNCTION getTransferChildrenForAll RETURNS LOGICAL
  (   )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getUpdatableColumns) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getUpdatableColumns Procedure 
FUNCTION getUpdatableColumns RETURNS CHARACTER
  (   )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getUpdatableWhenNew) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getUpdatableWhenNew Procedure 
FUNCTION getUpdatableWhenNew RETURNS CHARACTER
  (   )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getUpdateSource) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getUpdateSource Procedure 
FUNCTION getUpdateSource RETURNS CHARACTER
  ( )  FORWARD.

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

&IF DEFINED(EXCLUDE-indexInformation) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD indexInformation Procedure 
FUNCTION indexInformation RETURNS CHARACTER
   (pcQuery       AS CHAR,
    plUseTableSep AS LOG,
    pcIndexInfo   AS CHAR) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-insertExpression) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD insertExpression Procedure 
FUNCTION insertExpression RETURNS CHARACTER
  (pcWhere      AS CHAR,   
   pcExpression AS CHAR,     
   pcAndOr      AS CHAR) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-maskQuotes) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD maskQuotes Procedure 
FUNCTION maskQuotes RETURNS CHARACTER
  ( pcString      AS CHAR,
    pcReplaceChar AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-newQuerySort) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD newQuerySort Procedure 
FUNCTION newQuerySort RETURNS CHARACTER
  ( pcQuery       AS CHAR,
    pcSort        AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-newQueryString) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD newQueryString Procedure 
FUNCTION newQueryString RETURNS CHARACTER
  (pcColumns     AS CHARACTER,   
   pcValues      AS CHARACTER,    
   pcOperators   AS CHARACTER,
   pcQueryString AS CHARACTER,
   pcAndOr       AS CHARACTER) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-newWhereClause) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD newWhereClause Procedure 
FUNCTION newWhereClause RETURNS CHARACTER
  (pcBuffer     AS CHAR,   
   pcExpression AS char,  
   pcWhere      AS CHAR,
   pcAndOr      AS CHAR) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-removeBufferOuterJoin) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD removeBufferOuterJoin Procedure 
FUNCTION removeBufferOuterJoin RETURNS CHARACTER
  ( pcBuffer as char,
    pcQuery  as char) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-removeForeignKey) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD removeForeignKey Procedure 
FUNCTION removeForeignKey RETURNS LOGICAL
  ( )  FORWARD.

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

&IF DEFINED(EXCLUDE-replaceQuerySort) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD replaceQuerySort Procedure 
FUNCTION replaceQuerySort RETURNS CHARACTER
  ( pcQuery       AS CHAR,
    pcSort        AS CHAR)  FORWARD.

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

&IF DEFINED(EXCLUDE-resetQueryString) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD resetQueryString Procedure 
FUNCTION resetQueryString RETURNS LOGICAL
  (   )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-resolveColumn) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD resolveColumn Procedure 
FUNCTION resolveColumn RETURNS CHARACTER
  ( pcColumn AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-rowAvailable) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD rowAvailable Procedure 
FUNCTION rowAvailable RETURNS LOGICAL
  ( pcDirection  AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-rowValues) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD rowValues Procedure 
FUNCTION rowValues RETURNS CHARACTER
  ( pcColumns   AS CHAR,
    pcFormat    AS CHAR,
    pcDelimiter AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setAutoCommit) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setAutoCommit Procedure 
FUNCTION setAutoCommit RETURNS LOGICAL
  ( plAutoCommit AS LOGICAL )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setBufferHandles) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setBufferHandles Procedure 
FUNCTION setBufferHandles RETURNS LOGICAL
  ( pcBufferHandles AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setCommitSource) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setCommitSource Procedure 
FUNCTION setCommitSource RETURNS LOGICAL
  ( phObject AS HANDLE )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setCommitSourceEvents) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setCommitSourceEvents Procedure 
FUNCTION setCommitSourceEvents RETURNS LOGICAL
  ( pcEvents AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setCommitTarget) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setCommitTarget Procedure 
FUNCTION setCommitTarget RETURNS LOGICAL
  ( pcObject AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setCommitTargetEvents) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setCommitTargetEvents Procedure 
FUNCTION setCommitTargetEvents RETURNS LOGICAL
  ( pcEvents AS CHARACTER )  FORWARD.

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

&IF DEFINED(EXCLUDE-setDataColumns) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setDataColumns Procedure 
FUNCTION setDataColumns RETURNS LOGICAL
  ( pcColumns AS CHAR)  FORWARD.

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

&IF DEFINED(EXCLUDE-setDataModified) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setDataModified Procedure 
FUNCTION setDataModified RETURNS LOGICAL
  ( plDataModified AS LOGICAL )  FORWARD.

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

&IF DEFINED(EXCLUDE-setDataQueryString) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setDataQueryString Procedure 
FUNCTION setDataQueryString RETURNS LOGICAL
  (pcQueryString AS CHARACTER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setFetchOnOpen) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setFetchOnOpen Procedure 
FUNCTION setFetchOnOpen RETURNS LOGICAL
  ( pcFetchOnOpen AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setFillBatchOnRepos) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setFillBatchOnRepos Procedure 
FUNCTION setFillBatchOnRepos RETURNS LOGICAL
  ( plFlag AS LOGICAL )  FORWARD.

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

&IF DEFINED(EXCLUDE-setFilterSource) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setFilterSource Procedure 
FUNCTION setFilterSource RETURNS LOGICAL
  ( phObject AS HANDLE )  FORWARD.

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

&IF DEFINED(EXCLUDE-setFirstRowNum) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setFirstRowNum Procedure 
FUNCTION setFirstRowNum RETURNS LOGICAL
  ( piRowNum AS INTEGER )  FORWARD.

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
  ( pcValues AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setIgnoreTreeViewFilter) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setIgnoreTreeViewFilter Procedure 
FUNCTION setIgnoreTreeViewFilter RETURNS LOGICAL
  ( plIgnoreTreeViewFilter AS LOGICAL)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setIndexInformation) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setIndexInformation Procedure 
FUNCTION setIndexInformation RETURNS LOGICAL
  (pcInfo AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setLargeColumns) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setLargeColumns Procedure 
FUNCTION setLargeColumns RETURNS LOGICAL
  ( pcLargeColumns AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setLastRowNum) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setLastRowNum Procedure 
FUNCTION setLastRowNum RETURNS LOGICAL
  ( piLastRowNum AS INTEGER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setNavigationSource) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setNavigationSource Procedure 
FUNCTION setNavigationSource RETURNS LOGICAL
  ( pcObject AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setOpenOnInit) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setOpenOnInit Procedure 
FUNCTION setOpenOnInit RETURNS LOGICAL
  ( plOpen AS LOGICAL )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setPrimarySDOSource) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setPrimarySDOSource Procedure 
FUNCTION setPrimarySDOSource RETURNS LOGICAL
  ( phObject AS HANDLE )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setPromptColumns) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setPromptColumns Procedure 
FUNCTION setPromptColumns RETURNS LOGICAL
  (INPUT pcPromptColumns AS CHARACTER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setPromptOnDelete) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setPromptOnDelete Procedure 
FUNCTION setPromptOnDelete RETURNS LOGICAL
  (INPUT plPrompt AS LOGICAL)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setQueryColumns) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setQueryColumns Procedure 
FUNCTION setQueryColumns RETURNS LOGICAL
  ( cQueryColumns AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setQueryPosition) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setQueryPosition Procedure 
FUNCTION setQueryPosition RETURNS LOGICAL
  ( pcPosition AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setQuerySort) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setQuerySort Procedure 
FUNCTION setQuerySort RETURNS LOGICAL
  ( pcSort AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setQueryString) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setQueryString Procedure 
FUNCTION setQueryString RETURNS LOGICAL
  (pcQueryString AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setRebuildOnRepos) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setRebuildOnRepos Procedure 
FUNCTION setRebuildOnRepos RETURNS LOGICAL
  ( plRebuild AS LOGICAL )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setRowObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setRowObject Procedure 
FUNCTION setRowObject RETURNS LOGICAL
  ( phRowObject AS HANDLE )  FORWARD.

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

&IF DEFINED(EXCLUDE-setRowsToBatch) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setRowsToBatch Procedure 
FUNCTION setRowsToBatch RETURNS LOGICAL
  ( piRows AS INTEGER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setTables) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setTables Procedure 
FUNCTION setTables RETURNS LOGICAL
  ( pcTables AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setToggleDataTargets) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setToggleDataTargets Procedure 
FUNCTION setToggleDataTargets RETURNS LOGICAL
  ( plToggleDataTargets AS LOGICAL )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setTransferChildrenForAll) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setTransferChildrenForAll Procedure 
FUNCTION setTransferChildrenForAll RETURNS LOGICAL
  (plTransferChildrenForAll AS LOGICAL)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setUpdatableColumns) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setUpdatableColumns Procedure 
FUNCTION setUpdatableColumns RETURNS LOGICAL
  (pcColumns AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setUpdatableWhenNew) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setUpdatableWhenNew Procedure 
FUNCTION setUpdatableWhenNew RETURNS LOGICAL
  (pcUpdatableWhenNew AS CHARACTER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setUpdateSource) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setUpdateSource Procedure 
FUNCTION setUpdateSource RETURNS LOGICAL
  ( pcObject AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-sortExpression) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD sortExpression Procedure 
FUNCTION sortExpression RETURNS CHARACTER
  ( pcQueryString AS CHARACTER )  FORWARD.

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

&IF DEFINED(EXCLUDE-whereClauseBuffer) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-EXTERNAL whereClauseBuffer Procedure 
FUNCTION whereClauseBuffer RETURNS CHARACTER
  (pcWhere AS CHAR):
/*------------------------------------------------------------------------------
  Purpose:     Returns the buffername of a where clause expression. 
               This function avoids problems with leading or double blanks in 
               where clauses.
  Parameters:
    pcWhere - Complete where clause for ONE table with or without the FOR 
              keyword. The buffername must be the second token in the
              where clause as in "EACH order OF Customer" or if "FOR" is
              specified, the third token as in "FOR EACH order".
  
  Notes:      Used internally in query.p.
------------------------------------------------------------------------------*/
  pcWhere = LEFT-TRIM(pcWhere).
  
  /* Remove double blanks */
  DO WHILE INDEX(pcWhere,"  ":U) > 0:
    pcWhere = REPLACE(pcWhere,"  ":U," ":U).
  END.
  /* Get rid of potential line break characters */   
  pcWhere = REPLACE(pcWhere,CHR(10),'':U). 

  RETURN (IF NUM-ENTRIES(pcWhere," ":U) > 1 
          THEN ENTRY(IF pcWhere BEGINS "FOR ":U THEN 3 ELSE 2,pcWhere," ":U)
          ELSE "":U).
  
END.

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
         WIDTH              = 53.2.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB Procedure 
/* ************************* Included-Libraries *********************** */

{src/adm2/dataqueryprop.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-confirmCommit) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE confirmCommit Procedure 
PROCEDURE confirmCommit :
/*------------------------------------------------------------------------------
  Purpose: Checks the state of all data-targets too se if it's ok to commit.
           It's not OK to commit if a data-target is Modified or the 
           in these case the I-O parameter should return cancel = TRUE. 
           The visual objects (visual.p) will, however, offer the user the 
           opportunity to save/cancelRecord in order to be able to commit.   
                  
Parameters: INPUT-OUTPUT  pioCancel (logical) 
                 Will return true if it's NOT ok to commit.  
  Notes:   
------------------------------------------------------------------------------*/
   DEFINE INPUT-OUTPUT PARAMETER pioCancel AS LOGICAL NO-UNDO.  
   
   /* don't ask data-targets if already cancelled */  
   IF NOT pioCancel THEN
     PUBLISH "confirmCommit":U FROM TARGET-PROCEDURE (INPUT-OUTPUT pioCancel).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-confirmContinue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE confirmContinue Procedure 
PROCEDURE confirmContinue :
/*------------------------------------------------------------------------------
  Purpose: Checks the state of all data-targets too se if it's ok to continue.
           It's not OK to continue if a data-target is Modified or the 
           RowUpdateState equals 'rowUpdated', in these case the I-O parameter 
           should return cancel = TRUE. The visual objects (visual.p) 
           will, however, offer the user the opportunity to save/cancelRecord or 
           commit/undo in order to be able to continue.   
                  
Parameters: INPUT-OUTPUT  pioCancel (logical) 
                 Will return true if it's NOT ok to continue.  
  Notes:   This method should be called from any method that may change the 
           result set somewhere in the data-source chain like openQuery or 
           navigation actions.
           
           Currently called from the filter-source to see if new criteria can 
           be applied.  
                 
        -  Currently Navigation actions are disabled whenever a state
           that may disallow continuation is set to true. A less modal 
           could be achieved by always enable navigation and calling this 
           from fetch* methods.
------------------------------------------------------------------------------*/
   DEFINE INPUT-OUTPUT PARAMETER pioCancel AS LOGICAL NO-UNDO.  
   
   /* don't ask data-targets if already cancelled */  
   IF NOT pioCancel THEN
     PUBLISH "confirmContinue":U FROM TARGET-PROCEDURE (INPUT-OUTPUT pioCancel).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-confirmUndo) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE confirmUndo Procedure 
PROCEDURE confirmUndo :
/*------------------------------------------------------------------------------
  Purpose: Checks the state of all data-targets too se if it's ok to Undo.
           It's not OK to undo if a data-target is Modified or in AddMode.  
           In these case the I-O parameter should return cancel = TRUE. 
           The visual objects (visual.p) will, however, warn the user 
           that unsaved changes will be cancelled.   
                  
Parameters: INPUT-OUTPUT  pioCancel (logical) 
                 Will return true if it's NOT ok to commit.  
  Notes:   
------------------------------------------------------------------------------*/
   DEFINE INPUT-OUTPUT PARAMETER pioCancel AS LOGICAL NO-UNDO.  
   
   /* don't ask data-targets if already cancelled */  
   IF NOT pioCancel THEN
     PUBLISH "confirmUndo":U FROM TARGET-PROCEDURE (INPUT-OUTPUT pioCancel).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-exportData) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE exportData Procedure 
PROCEDURE exportData :
/*------------------------------------------------------------------------------
  Purpose:     Eports the contents of the SDO to an external source/tool 
  Parameters:  input 'Excel' or 'Crystal'.
               input field list or leave blank for all (no table prefix)
               input include object fields yes/no
               input use existing running excel yes/no
               input maximum records to process
  Notes:    -  The external tool's exportData will do a call back to the 
               data object's tableout procedure for the actual retrieval of the data.    
            -  Data: Always excludes rowobject specific fields,
               e.g. RowNum,RowIdent,RowMod
------------------------------------------------------------------------------*/
 DEFINE INPUT  PARAMETER pcExportType   AS CHARACTER  NO-UNDO.
 DEFINE INPUT  PARAMETER pcFieldList      AS CHARACTER  NO-UNDO.
 DEFINE INPUT  PARAMETER plIncludeObj     AS LOGICAL    NO-UNDO.
 DEFINE INPUT  PARAMETER plUseExisting    AS LOGICAL    NO-UNDO.
 DEFINE INPUT  PARAMETER piMaxRecords     AS INTEGER    NO-UNDO.
   
 DEFINE VARIABLE hObject AS HANDLE     NO-UNDO.

 DO ON STOP UNDO,LEAVE:
   RUN adm2/exportdata.p PERSISTENT SET hObject.
 END.
 IF VALID-HANDLE(hObject) THEN
 DO:
   RUN exportData IN hObject (TARGET-PROCEDURE,
                              pcExportType,
                              pcFieldList,
                              plIncludeObj,
                              plUseExisting,
                              piMaxRecords).

   RUN destroyObject IN hObject.
 END. 

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-filterContainerHandler) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE filterContainerHandler Procedure 
PROCEDURE filterContainerHandler :
/*------------------------------------------------------------------------------
  Purpose:     Adds the Filter link between itself and a Filter container.  
               Called from startFilter after the Filter container is 
               contructed.  
  Parameters:  phFilterContainer AS HANDLE - handle of the Filter container
  Notes:       The code to add the Filter link has been separated from 
               startFilter so that filterContainerHandler can be overridden
               to add other links between this object and the Filter container.
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER phFilterContainer AS HANDLE NO-UNDO.

  RUN addLink IN TARGET-PROCEDURE ( phFilterContainer , 'Filter':U , TARGET-PROCEDURE  ).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-isUpdateActive) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE isUpdateActive Procedure 
PROCEDURE isUpdateActive :
/*------------------------------------------------------------------------------
  Purpose: Received from container source to check if contained objects have 
           unsaved or uncommitted changes, including addMode.           
    Notes: This is published thru the container link from canExit for 
           close logic ( ok, cancel, exit).
          (It is very similar to canNavigate -> isUpdatePending which is 
           published thru the data link)
         - WE currently ONLY check rowObjectState as the other states are 
           checked in the visual objects.      
--------------------------------------------------------------------------------*/
  DEFINE INPUT-OUTPUT PARAMETER plActive AS LOGICAL NO-UNDO.
  DEFINE VARIABLE cRowObjectState AS CHARACTER  NO-UNDO.

  IF NOT plActive THEN 
  DO:
    {get RowObjectState cRowObjectState}.
    plActive = (cRowObjectState = 'RowUpdated':U).
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-isUpdatePending) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE isUpdatePending Procedure 
PROCEDURE isUpdatePending :
/*------------------------------------------------------------------------------
  Purpose:  Published through data-targets to check if any updates are pending.   
  Parameters: input-output plUpdate 
              Returns TRUE and stops the publishing if update is pending. 
  Notes:      New is included as a pending update. 
              Called from canNavigate, which is used by navigating objects to 
              check if they can trust an updateState('updatecomplete') message
          NB! This check is only valid from a DataSource point of view. 
              Use canNavigate to check an actual object.  
------------------------------------------------------------------------------*/
   DEFINE INPUT-OUTPUT PARAMETER plUpdate AS LOGICAL    NO-UNDO.

   DEFINE VARIABLE lNew            AS LOGICAL    NO-UNDO.
   DEFINE VARIABLE lDataModified   AS LOGICAL    NO-UNDO.
   DEFINE VARIABLE lFetched        AS LOGICAL    NO-UNDO.
   DEFINE VARIABLE cRowObjectState AS CHARACTER  NO-UNDO.
   /* No need to check a pending update was found somewhere else */
   IF NOT plUpdate THEN
   DO:

     &SCOPED-DEFINE xp-assign
     {get DataModified lDataModified}
     {get NewMode lNew}
     {get DataIsFetched lFetched}
      .
     &UNDEFINE xp-assign
     
      /* if child on client only for single parent then we cannot navigate 
         if the record has uncomitted changes, so updatepending need to be true */             
     IF lFetched = FALSE THEN
     DO:
       {get RowObjectState cRowObjectState}.
       plUpdate = (cRowObjectstate = 'RowUpdated':U).
     END.

     IF NOT plUpdate THEN
     DO:
       /* unknown is no (NewRow is sometimes ?) */
       plUpdate = (lNew = TRUE) OR (lDataModified = TRUE). 
     
       IF NOT plUpdate THEN 
         PUBLISH 'isUpdatePending':U FROM TARGET-PROCEDURE (INPUT-OUTPUT plUpdate).
     END.
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
  Purpose:     Run LinkStateHandler in source(pcState) if ToggleDataTargets
               And publish the state with a potential appended 'Target' 
               Recieved from DataTargets.                                
  Parameters:  pcState AS CHARACTER -- 'active'/'inactive'
               The event is republished up through a groupAssignSource and 
               a DataSource.
             - The logic is separated into processLinkState in order to allow 
               the data class to override this without duplicating all logic.     
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pcState  AS CHARACTER NO-UNDO.
  
  RUN processLinkState IN TARGET-PROCEDURE(SOURCE-PROCEDURE,pcState).
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-linkStateHandler) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE linkStateHandler Procedure 
PROCEDURE linkStateHandler :
/*------------------------------------------------------------------------------
  Purpose: Override inorder to run dataAvailable when a dataSource link 
           is made active      
  Parameters: see base version in smart.p
  Notes:   Publish dataavailable after a datasource link is activated in order
           to synchronize with the datasource if the link is inactive and the
           datasource does not have an inactive datasource link of its own in
           which case we'll just wait for its publish of dataavailable.                             
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pcState   AS CHARACTER  NO-UNDO.
  DEFINE INPUT PARAMETER phObject  AS HANDLE     NO-UNDO.
  DEFINE INPUT PARAMETER pcLink    AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE lDataInactive   AS LOGICAL    NO-UNDO.
   
  IF pcState = 'active':U AND pcLink = 'DataSource':U  THEN
  DO:
    /* if the source is inactive then wait for the dataavailable that it will 
       publish when it becomes active, otherwise check if this object's 
       datasource link was inactive in order to publish dataavailable after 
       the link has been activated  */ 
    IF NOT DYNAMIC-FUNCTION('isLinkInactive':U IN phObject,'DataSource':U,?) THEN 
      lDataInactive = DYNAMIC-FUNCTION('isLinkInactive':U IN TARGET-PROCEDURE,
                                       'DataSource':U,phObject).
  END.
  
  RUN SUPER(pcState,phObject,pcLink).

  IF lDataInactive THEN
    RUN dataAvailable IN TARGET-PROCEDURE('RESET':U).
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-printToCrystal) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE printToCrystal Procedure 
PROCEDURE printToCrystal :
/*------------------------------------------------------------------------------
  Purpose:     Transfers the contents of the SDO to Crystal
  Parameters:  input field list or leave blank for all (no table prefix)
               input include object fields yes/no
               input maximum records to process
  Notes:      
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pcFieldList            AS CHARACTER    NO-UNDO.
  DEFINE INPUT PARAMETER plIncludeObj           AS LOGICAL      NO-UNDO.
  DEFINE INPUT PARAMETER piMaxRecords           AS INTEGER      NO-UNDO.
  
  RUN exportData IN TARGET-PROCEDURE ('Crystal':U,
                                      pcFieldList,
                                      plIncludeObj,
                                      ?,  /* use existing currently ignored for Crystal*/
                                      piMaxRecords).

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-processLinkState) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE processLinkState Procedure 
PROCEDURE processLinkState :
/*------------------------------------------------------------------------------
  Purpose:     Processes the passed linkState event received from the passed 
               datatarget. 
               Publishes the state with a potential appended 'Target' 
  Parameters:  phDataTarget - Publisher of linkstate 
               pcState      - 'active'/'inactive'
      Notes:   Separated out of linkState primarily to allow data extentions to 
               override linkState without duplicating all logic. 
               See linkState for external info.            
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER phDataTarget AS HANDLE     NO-UNDO.
  DEFINE INPUT  PARAMETER pcState      AS CHARACTER  NO-UNDO.
  
  DEFINE VARIABLE cTargets         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iTarget          AS INTEGER    NO-UNDO.
  DEFINE VARIABLE hTarget          AS HANDLE     NO-UNDO.
  DEFINE VARIABLE lRePublish       AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cObjectType      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hContainer       AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hGASource        AS HANDLE     NO-UNDO.  
  DEFINE VARIABLE lHidden          AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lVisualTarget    AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lToggleTargets   AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lActiveTarget    AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lInitialized     AS LOGICAL    NO-UNDO.

  {get ObjectInitialized lInitialized}.
  IF NOT linitialized THEN
     RETURN.
     
  /* Convert message from data-target (to be ignored by nav-source) 
     (See how the child did this at the end of this procedure)  */
  if pcState = 'ActiveData':U then 
    pcState = 'Active':U.  
    
  /* Else ignore 'activeTarget' and 'inactiveTarget' published from child SDOs/SBOs 
     to only reach the navigationSource */     
  else IF NOT CAN-DO('active,inactive':U,pcState ) THEN
    RETURN.

  {get ContainerHandle hContainer phDataTarget}.
  lVisualTarget = VALID-HANDLE(hContainer).
  IF lVisualTarget THEN
  DO:
    /* Ignore this if it's from a GA Target. 
      (it is published up through the GA-link and will reach us from the source)*/ 
    {get GroupAssignSource hGaSource phDataTarget} NO-ERROR.
    IF VALID-HANDLE(hGaSource) THEN
       RETURN.
    
    /* Ignore an 'inactive' message from a visual object if it or any of the 
       GAtargets are visible (or will become visible) */
    IF pcState = 'inactive':U THEN
    DO:
      {get GroupAssignHidden lHidden phDataTarget} NO-ERROR.
      IF NOT lHidden THEN
        RETURN.
    END.
  END.
  
  /* Check if we are supposed to toggle DataTarget links active/inactive */ 
  {get ToggleDataTargets lToggleTargets}.
  
  /* If toggle and state is 'inactive' set to NOT toggle if cannavigate false*/ 
  IF lToggleTargets 
  AND pcState = 'inactive':U THEN 
  DO:                     
    lToggleTargets = {fn canNavigate phDataTarget} NO-ERROR. 
    IF lToggleTargets = ? THEN 
      lToggleTargets = TRUE.
  END.
  
  /* Turn on/off link to publisher */
  IF lToggleTargets THEN
  DO:
    /* We keep the SDB active since it is to be disabled on changes
       from below and it also is more of a hazzle to reposition it if we 
       did disable it */
    {get ObjectType cObjectType phDataTarget}.
    IF cObjectType <> 'SmartDataBrowser':U THEN
    DO:
      RUN linkStateHandler IN phDataTarget 
                  (pcState,TARGET-PROCEDURE,'DataSource':U).
    END.
  END.
  
  /* If 'inactive' we must verify that all the targets also are 'inactive' */         
  IF pcState = 'inactive':U AND lToggleTargets THEN
  DO:
    {get DataTarget cTargets}.
    DO iTarget = 1 TO NUM-ENTRIES(cTargets):
      hTarget = WIDGET-HANDLE(ENTRY(iTarget,cTargets)). 
      /* skip the publisher */
      IF hTarget = phDataTarget THEN
        NEXT.
      
      /* Is this a visual target?  */
      {get ContainerHandle hContainer hTarget}.
      IF VALID-HANDLE(hContainer) THEN
      DO:
        /* Don't check GATargets */
        {get GroupAssignSource hGaSOurce hTarget} NO-ERROR.
        IF NOT VALID-HANDLE(hGaSource) THEN
        DO:
          {get GroupAssignHidden lHidden hTarget} NO-ERROR.
          /* Ignore the message if 'inactive' and a visual object or any of
             its Group Assign targets are visible (or will become visible)*/
        END.
      END. /* valid Containerhandle  (visual) */
      ELSE 
        lHidden = DYNAMIC-FUNCTION('isLinkInactive':U IN hTarget,
                                   'DataSource':U,
                                   TARGET-PROCEDURE).
      
      IF NOT lHidden THEN
      DO:
        /* If an active target and the message is from a non-visual object 
           just get out as there is no need to republish */
        IF NOT lVisualTarget THEN
          RETURN.

        lActiveTarget = TRUE.
        LEAVE.
      END.
    END. /* DataTarget loop */      
  END. /* state = 'inactive' ans lToggleSource  */
  /* active */
  ELSE IF pcState = 'active':U AND NOT lVisualTarget THEN
  DO:
    /* No need to republish an active message from a non-visual target if the 
       link already is active */       
    IF NOT DYNAMIC-FUNCTION('isLinkInactive':U IN TARGET-PROCEDURE,
                            'DataSource':U,?) THEN
      RETURN.
                   
  END.
  
  if lVisualTarget then 
  do:  
    /* If not ToggleTargets or if any active target found for an 'inactive' 
       state then append 'target' so the DataSource ignores it, but the 
       Navigationsource reacts to it */     
    IF NOT lToggleTargets OR lActiveTarget THEN
      pcState = pcstate + 'Target':U.
  end.
  else do:
    /* append 'data' (from data object) in order to not activate the 
       navigationsource  (it's probably uneccesary to deactivate also...) */
    if pcState = 'active':U then
      pcState = pcState + "Data":U.   
    
  end.

  PUBLISH 'linkState':U FROM TARGET-PROCEDURE (pcState). 

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-startFilter) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE startFilter Procedure 
PROCEDURE startFilter :
/*------------------------------------------------------------------------------
  Purpose:     View/Start the filter-source
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   DEFINE VARIABLE hFilterSource    AS HANDLE    NO-UNDO.
   DEFINE VARIABLE hWindow          AS HANDLE    NO-UNDO.
   DEFINE VARIABLE lEnable          AS LOGICAL   NO-UNDO.
   DEFINE VARIABLE hFilterContainer AS HANDLE    NO-UNDO.
   DEFINE VARIABLE hMyContainer     AS HANDLE    NO-UNDO.
   DEFINE VARIABLE cFilterWindow    AS CHARACTER NO-UNDO.
      
   {get FilterSource hFilterSource}.
   
   IF VALID-HANDLE(hFilterSource) THEN 
   DO:
     {get ContainerSource hFilterContainer hFilterSource}.
     {get ContainerSource hMyContainer}.    
     IF hMyContainer <> hFilterContainer THEN
     DO:
       {set FilterWindow hFilterContainer:FILE-NAME}.
       {get DisableOnInit lEnable hFilterContainer}. 
       IF lEnable THEN 
       DO:
         {set DisableOnInit FALSE hFilterContainer}. 
         RUN enableObject IN hFilterSource.
       END.
     END.
   END.
   
   IF NOT VALID-HANDLE(hFilterContainer) THEN 
   DO:
     {get FilterWindow cFilterWindow}.     
     IF cFilterWindow <> '':U THEN
     DO:
       {get ContainerSource hMyContainer}.    
       {get ContainerHandle hWindow}.
      
       RUN constructObject IN hMyContainer (
             INPUT  cFilterWindow,
             INPUT  hWindow,
             INPUT  'HideOnInit' + CHR(4) + 'no' + CHR(3) 
                    + 
                    'DisableOnInit' + CHR(4) + 'no' + CHR(3) 
                    + 
                    'ObjectLayout' + CHR(4),
             OUTPUT hFilterContainer).
      /* filterContainerHandler adds the Filter link between this object
         and the Filter container */
       RUN filterContainerHandler IN TARGET-PROCEDURE ( hFilterContainer ).
       RUN initializeObject IN hFilterContainer.  
     END.
   END.    
   
   RUN viewObject IN hFilterContainer.
   
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-tableOut) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE tableOut Procedure 
PROCEDURE tableOut :
/*-----------------------------------------------------------------------------
  Purpose:     Output requested fields of SDO in standard temp-table
  Parameters:  pcFieldList    - input field list
                   - !exclude-1,!exclude-2,...,!exclude-n,*
                   - field-1,field-2,...,field-n,!exclude-1,...,!exclude-n

               plIncludeObj   - input include object fields yes/no
               piMaxRecords   - input maximum records to process
               ttTable        - output temp-table of data from sdo
               iExtractedRecs - output number of records extracted
  
  Notes:       Temp table is defined in afttsdoout.i
               Fields passed in are checked with a can-do so support * for all
               or !field to exclude a field, e.g.
               "!RowNum,!RowIdent,!RowMod, *" would use all non SDO specific
               fields.           
------------------------------------------------------------------------------*/

DEFINE INPUT  PARAMETER pcFieldList                AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER plIncludeObj               AS LOGICAL    NO-UNDO.
DEFINE INPUT  PARAMETER piMaxRecords               AS INTEGER    NO-UNDO.
DEFINE OUTPUT PARAMETER TABLE FOR ttTable.
DEFINE OUTPUT PARAMETER iExtractedRecs            AS INTEGER    NO-UNDO.

DEFINE VARIABLE iRowNum                           AS INTEGER    NO-UNDO.
DEFINE VARIABLE iColNum                           AS INTEGER    NO-UNDO.
DEFINE VARIABLE iField                            AS INTEGER    NO-UNDO.
DEFINE VARIABLE lAvailable                        AS LOGICAL    NO-UNDO.

DEFINE VARIABLE iRowsToBatch                      AS INTEGER    NO-UNDO.
DEFINE VARIABLE iNumRecords                       AS INTEGER    NO-UNDO.
DEFINE VARIABLE cRowIdent                         AS CHARACTER  NO-UNDO.

/* Variables for Security Check of Fields */
DEFINE VARIABLE cQueryPosition      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE hContainerHandle    AS HANDLE     NO-UNDO.
DEFINE VARIABLE cRunAttribute       AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cContainerName      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cSecuredFields      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cHiddenFields       AS CHARACTER  NO-UNDO.
DEFINE VARIABLE iLoop               AS INTEGER    NO-UNDO.
DEFINE VARIABLE cFieldName          AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cNewFieldList       AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cCanDoList          AS CHARACTER  NO-UNDO.

DEFINE VARIABLE hBrowser            AS HANDLE                   NO-UNDO.
DEFINE VARIABLE hBrowseColumn       AS HANDLE                   NO-UNDO.
DEFINE VARIABLE hDataTarget         AS HANDLE                   NO-UNDO.
DEFINE VARIABLE cDataTargets        AS CHARACTER                NO-UNDO.
DEFINE VARIABLE cColumnNames        AS CHARACTER                NO-UNDO.
DEFINE VARIABLE cColumnHandles      AS CHARACTER                NO-UNDO.
DEFINE VARIABLE hNavSource          AS HANDLE                   NO-UNDO.
DEFINE VARIABLE cColumn             AS CHARACTER                NO-UNDO.
DEFINE VARIABLE cDataColumns        AS CHARACTER                NO-UNDO.

DEFINE VARIABLE lLOBMessageDisplayed AS LOGICAL                  NO-UNDO.

/* Start of Security check */
ASSIGN hContainerHandle = TARGET-PROCEDURE.

IF VALID-HANDLE(gshSecurityManager) THEN
DO:
  {get ContainerSource hContainerHandle}.
  IF VALID-HANDLE(hContainerHandle) THEN 
  DO:
    {get LogicalObjectName cContainerName hContainerHandle} NO-ERROR.
    cRunAttribute = DYNAMIC-FUNCTION('getRunAttribute' IN hContainerHandle) NO-ERROR.  
    IF cContainerName = "":U THEN
        ASSIGN cContainerName = hContainerHandle:FILE-NAME.
  END.
  ELSE
    cContainerName = "":U.

  IF cContainerName <> "":U THEN
    ASSIGN cContainerName = REPLACE(cContainerName,"~\":U,"/":U)
           cContainerName = SUBSTRING(cContainerName,R-INDEX(cContainerName,"/":U) + 1,LENGTH(cContainerName)).

  RUN fieldSecurityGet IN gshSecurityManager (INPUT hContainerHandle, /* If not valid cContainerName will be used */
                                              INPUT cContainerName,
                                              INPUT cRunAttribute,
                                              OUTPUT cSecuredFields).
END.

/* Check if security on fields have been set */
IF INDEX(cSecuredFields,"Hidden":U) > 0 THEN
DO iLoop = 1 TO NUM-ENTRIES(cSecuredFields):
  IF ENTRY(iLoop + 1,cSecuredFields) = "Hidden":U THEN
    ASSIGN cHiddenFields = IF cHiddenFields = "":U 
                           THEN ENTRY(iLoop,cSecuredFields)
                           ELSE cHiddenFields + ",":U + ENTRY(iLoop,cSecuredFields).
           iLoop         = iLoop + 1. /* Skip One */
END.

{get DataColumns cDataColumns}.
IF LOOKUP('*':U, pcFieldList) > 0  THEN
  ENTRY(LOOKUP('*':U, pcFieldList),pcFieldList) = cDataColumns.

/* Remove hidden and _obj fields from pcFieldList */
DO iLoop = 1 TO NUM-ENTRIES(pcFieldList):
  cFieldName = ENTRY(iLoop,pcFieldList).
  IF CAN-DO(cDataColumns,cFieldName) THEN
  DO:
    /* We seem to have supported can-do in a previous variation of this
       (different loop logic, due to direct use of buffer ), 
       so use lookup to check if this entry is a wildcard entry.  */
    IF LOOKUP(cFieldName,cDataColumns) = 0 THEN
    DO:
      cCanDoList = ''.
      DO iField = 1 TO NUM-ENTRIES(cDataColumns):
        IF CAN-DO(ENTRY(iField,cDataColumns),cFieldName) 
        AND LOOKUP(ENTRY(iField,cDataColumns),cNewFieldList) = 0 THEN
          cCanDoList = cCanDoList 
                     + (IF cCanDoList = '' THEN '' ELSE ',')
                     + ENTRY(iField,cDataColumns).
      END.
      IF cCanDoList = '' THEN
        NEXT. 
      /* make the first entry the current field and extend the loop list
         with all found entries  */
      ASSIGN
        cFieldName = ENTRY(1,cCanDolist)
        ENTRY(iLoop,pcFieldList) = cCanDoList.
    END. /* lookup = 0  */

    IF LOOKUP(cFieldName,cHiddenFields) > 0 THEN
      NEXT.
  
    IF plIncludeObj = NO AND cFieldName MATCHES "*_obj":U THEN
      NEXT.
  
    cNewFieldList = IF cNewFieldList = "":U
                    THEN cFieldName
                    ELSE cNewFieldList + ",":U + cFieldName.
  END.
END.
pcFieldList = cNewFieldList.

ASSIGN piMaxRecords = (IF piMaxRecords > 0 THEN piMaxRecords ELSE 99999999)
       iNumRecords  = 0.

/* Store current position in query */
cRowident = DYNAMIC-FUNCTION('getRowIdent':U IN TARGET-PROCEDURE) NO-ERROR.

/* We need to do all this to ensure we don't pick up dataAvailable messages, queryPosition subscribes etc. */

PUBLISH 'fetchDataSet':U FROM TARGET-PROCEDURE ('BatchStart':U).

{get NavigationSource hNavSource}.
RUN linkStateHandler IN TARGET-PROCEDURE(INPUT "Inactive":U,
                                         INPUT hNavSource,
                                         INPUT "NavigationSource":U).

/* Get the browser handle that this request came from. If we are performing this request from a browser, *
 * then we must use the browser's column labels, particularly because they may have been translated.     */

{get DataTarget cDataTargets}.

DATA-TARGET-LOOP:
DO iLoop = 1 TO NUM-ENTRIES(cDataTargets):
    ASSIGN hDataTarget = WIDGET-HANDLE(ENTRY(iLoop, cDataTargets)) NO-ERROR.

    IF VALID-HANDLE(hDataTarget) THEN 
    DO:
        IF NOT VALID-HANDLE(hBrowser)
        AND {fn getObjectType hDataTarget} = 'SmartDataBrowser':U THEN
            {get BrowseHandle hBrowser hDataTarget}.

        /* While we're here, disable the data link to improve performance */
        RUN linkStateHandler IN hDataTarget (INPUT "inactive":U,
                                             INPUT TARGET-PROCEDURE,
                                             INPUT "dataSource":U).
    END.
END.

/* Once we have found the browser, build a list of the browse column names and their handles. This is because
 * the only way to retrieve the browser column handle is to use the GET-BROWSE-COLUMN() method, and this uses
 * an ordinal value. We can not depend on the order of the browser columns being the same as the prder of the 
 * fields in the DataObject, so we need to determine the browser column handle from our pre-built lists.    */
IF VALID-HANDLE(hBrowser) THEN 
DO:
    DO iLoop = 1 TO hBrowser:NUM-COLUMNS:
      /* local calc fields cannot be exported*/ 
      hBrowseColumn = hBrowser:GET-BROWSE-COLUMN(iLoop).
      IF hBrowseColumn:TABLE <> ? THEN
        ASSIGN cColumnNames   = cColumnNames 
                              + (IF INDEX(pcFieldList,'.':U) > 0
                                 THEN hBrowseColumn:TABLE + '.'
                                 ELSE '')
                              + hBrowseColumn:NAME + ",":U
               cColumnHandles = cColumnHandles + STRING(hBrowseColumn) + ",":U
               .
    END.    /* loop through browser columns */
    ASSIGN cColumnNames   = RIGHT-TRIM(cColumnNames, ",":U)
           cColumnHandles = RIGHT-TRIM(cColumnHandles, ",":U)
           .
END.    /* valid browser. */

/* Ensure temp-table is empty to start */
EMPTY TEMP-TABLE ttTable.

/* set rows to batch very high as we will read all the data */
&SCOPED-DEFINE xp-assign
{get rowsToBatch iRowsToBatch}
{set rowsToBatch piMaxRecords}
.
&UNDEFINE xp-assign

/* start at the beginning */
RUN fetchFirst IN TARGET-PROCEDURE.

/* check if any records */
lAvailable = {fnarg rowAvailable '':U}.
IF lAvailable THEN
DO:

  ASSIGN iNumRecords = 1 .
  /* loop through sdo fields and create TT records for field labels, names, datatypes and widths */

  field-loop:
  DO iField = 1 TO NUM-ENTRIES(pcFieldList):
    cColumn = ENTRY(iField,pcFieldList).
    
    ASSIGN iColNum       = iColNum + 1
           hBrowseColumn = ?.

    IF VALID-HANDLE(hBrowser) THEN
      ASSIGN hBrowseColumn = WIDGET-HANDLE(ENTRY(LOOKUP(cColumn, cColumnNames), cColumnHandles)) NO-ERROR.
    
    /* Store labels in row 0 */
    CREATE ttTable.
    ASSIGN ttTable.cCell = IF VALID-HANDLE(hBrowseColumn) 
                           THEN TRIM(hBrowseColumn:LABEL)
                           ELSE {fnarg columnColumnLabel cColumn}
           ttTable.iRow  = 0
           ttTable.iCol  = iColNum.

    /* Store field names in row 1 */
    CREATE ttTable.
    ASSIGN ttTable.cCell = cColumn
           ttTable.iRow  = 1
           ttTable.iCol  = iColNum.

    /* Store datatypes in row 2 */
    CREATE ttTable.
    ASSIGN ttTable.cCell = {fnarg columnDataType cColumn}
           ttTable.iRow  = 2
           ttTable.iCol  = iColNum.
    
    /* Store widths in row 3 */
    CREATE ttTable.
    ASSIGN ttTable.cCell = {fnarg columnWidth cColumn}
           ttTable.iRow  = 3
           ttTable.iCol  = iColNum.

    /* Store format in row 4 */
    CREATE ttTable.
    ASSIGN ttTable.cCell = {fnarg columnFormat cColumn}
           ttTable.iRow = 4
           ttTable.iCol  = iColNum.

  END. /* Loop through the requested fields */


  iRowNum = 9.  /* >9 = data */
 
  /* now loop through all available records */
  DO WHILE TRUE:
    
    ASSIGN iRowNum = iRowNum + 1.

    field-loop2:
    DO iField = 1 TO NUM-ENTRIES(pcFieldList):
      cColumn = ENTRY(iField,pcFieldList).
      
      CREATE ttTable.
      ASSIGN ttTable.iRow  = iRowNum
             ttTable.iCol  = iField.
      IF LOOKUP({fnarg columnDataType cColumn},'CLOB,BLOB,INT64,RAW':U) > 0 THEN
      DO:
         IF NOT lLOBMessageDisplayed THEN
         DO:
            MESSAGE SUBSTITUTE({fnarg MessageNumber 95},PROGRAM-NAME(1),
                                                     cColumn,
                                                     {fnarg columnDataType cColumn})
                    VIEW-AS ALERT-BOX WARNING.
            lLOBMessageDisplayed = YES.
         END.
         ttTable.cCell = "":U.
      END.
      ELSE
         ttTable.cCell = RIGHT-TRIM({fnarg columnStringValue cColumn}).
    END. /* Loop through the buffer fields */
    
    iNumRecords    = iNumRecords + 1.

    IF {fnarg rowAvailable 'NEXT':U} AND iNumRecords <= piMaxRecords THEN
      RUN fetchNext IN TARGET-PROCEDURE.
    ELSE
      LEAVE.
  END. /* Loop through all available records */ 
END.  /* lAvailable = true */

/* reposition back to previously selected record */
IF cRowIdent <> ? AND cRowIdent <> "":U THEN
  DYNAMIC-FUNCTION('fetchRowIdent' IN TARGET-PROCEDURE, cRowIdent, '':U) NO-ERROR.

iExtractedRecs = iNumRecords - 1.

/* Enable everything we disabled */
DATA-TARGET-LOOP:
DO iLoop = 1 TO NUM-ENTRIES(cDataTargets):
    ASSIGN hDataTarget = WIDGET-HANDLE(ENTRY(iLoop, cDataTargets)) NO-ERROR.

    IF VALID-HANDLE(hDataTarget) THEN
        RUN linkStateHandler IN hDataTarget (INPUT "active":U,
                                             INPUT TARGET-PROCEDURE,
                                             INPUT "dataSource":U).
END.

RUN linkStateHandler IN TARGET-PROCEDURE(INPUT "active":U,
                                         INPUT hNavSource,
                                         INPUT "NavigationSource":U).

PUBLISH 'fetchDataSet':U FROM TARGET-PROCEDURE ("BatchEnd":U).

RUN updateQueryPosition IN TARGET-PROCEDURE.
/* reset rows to batch back */
{set rowsToBatch iRowsToBatch}.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-transferToExcel) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE transferToExcel Procedure 
PROCEDURE transferToExcel :
/*------------------------------------------------------------------------------
  Purpose:     Transfers the contents of the SDO to Excel
  Parameters:  input field list or leave blank for all (no table prefix)
               input include object fields yes/no
               input use existing running excel yes/no
               input maximum records to process
  Notes:       Always excludes rowobject specific fields,
               e.g. RowNum,RowIdent,RowMod
               Uses tableout procedure defined in here also.
------------------------------------------------------------------------------*/
 DEFINE INPUT PARAMETER pcFieldList      AS CHARACTER            NO-UNDO.
 DEFINE INPUT PARAMETER plIncludeObj     AS LOGICAL              NO-UNDO.
 DEFINE INPUT PARAMETER plUseExisting    AS LOGICAL              NO-UNDO.
 DEFINE INPUT PARAMETER piMaxRecords     AS INTEGER              NO-UNDO.
 
 RUN exportData IN TARGET-PROCEDURE ('Excel':U,
                                     pcFieldList,
                                     plIncludeObj,
                                     plUseExisting,
                                     piMaxRecords).

 RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-updateQueryPosition) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE updateQueryPosition Procedure 
PROCEDURE updateQueryPosition :
/*------------------------------------------------------------------------------
  Purpose: Reset the QueryPosition property after a record navigation.  
    Notes: The assumption is that LastRowNum and FirstRowNum stores the 
           id of the first and last record in the database query when this is 
           called. 
         - Some of the logic here is duplicated in data's override.  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hRowObject   AS HANDLE     NO-UNDO.
  DEFINE VARIABLE iLastRow     AS INT        NO-UNDO.
  DEFINE VARIABLE iFirstRow    AS INT        NO-UNDO.  
  DEFINE VARIABLE lLast        AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cQueryPos    AS CHAR       NO-UNDO.
  DEFINE VARIABLE lNew         AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE hDataSource  AS HANDLE     NO-UNDO.
  DEFINE VARIABLE lQuery       AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE iROwNum      AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cParentPos   AS CHARACTER  NO-UNDO.
  
  {get RowObject hRowObject}.
  IF VALID-HANDLE(hRowObject) AND hRowObject:AVAILABLE THEN
  DO:
    &SCOPED-DEFINE xp-assign
    {get FirstRowNum iFirstRow}
    {get LastRowNum iLastRow}.
    &UNDEFINE xp-assign
     
    ASSIGN
      iRowNum   = INT(hRowObject:RECID)
      /* Are we on the last record?  */
      lLast     = (iRowNum = iLastRow)
      cQueryPos = IF iRowNum = iFirstRow                   
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
       the parent's queryPosition. */
    {get DataSource hDataSource}.     
    IF VALID-HANDLE(hDataSource) THEN 
    DO:
      {get QueryObject lQuery hDataSource}.
      IF lQuery THEN
      DO:
        {get QueryPosition cParentPos hDataSource}.
        IF cParentPos BEGINS 'NoRecordAvailable':U THEN
          cQueryPos = 'NoRecordAvailableExt':U.
        else 
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

&IF DEFINED(EXCLUDE-updateState) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE updateState Procedure 
PROCEDURE updateState :
/*------------------------------------------------------------------------------
  Purpose:     To pass along update-related messages (to its 
               Navigation-Source, e.g) and to adjust the DataModified property.
               
  Parameters:  
    INPUT pcState - A indicator of the state of a an updatable record. Valid
                    values are:
                      'UpdateBegin'    -  The user has indicated that an update
                                          will take place (either by pressing
                                          the Update button in a panel, or by
                                          entering an updatable field in a
                                          browser.)
                      'Update'         -  An update is in progress in another
                                          object (a viewer or browser.)
                      'UpdateEnd'      -  A save has completed (same as
                                          'UpdateComplete'.)
                      'UpdateComplete' -  Any changes to the RowObject
                                          Temp-Table have either been 
                                          committed or backed out.
                      'Reset'          -  Changes to the roewObject has been
                                          reset, passed on as 'UpdateComplete'  
                      'Delete'         -  An uncommitted delete, which we 
                                          pass on as 'update'.  
                      'Updatable'      - called from UpdateMode when switching modes                      
                        
   Notes:   -  The SmartDataObject also saves its own "copy" of the 
               DataModified property, set true when updateState is 'Update' 
               and false when updateState is 'UpdateComplete', so that it 
               can be queried by other objects (such as other dataTargets).  
            -  For visual objects the updateState is both a DataSourceEvent 
               and DataTargetEvent. In order to not bounce messages back to the 
               dataTargets that are both subscribers and publishers, we 
               set the CurrentUpdateSource so the DataTarget can avoid 
               republishing the event.                
               Note that even if we did send the message back to the visual
               object it would not get back to us as visual object only does 
               publish updatestate from internal events, including GAtargets    
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pcState AS CHARACTER NO-UNDO.
   
  DEFINE VARIABLE hDataSource       AS HANDLE    NO-UNDO.
  DEFINE VARIABLE lModified         AS LOGICAL   NO-UNDO INIT ?.
  DEFINE VARIABLE lAsynchronous     AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE lAutoCommit       AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE hContainerSource  AS HANDLE    NO-UNDO.
  DEFINE VARIABLE cUpdateSource     AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cTargetSrcEvents  AS CHARACTER NO-UNDO.
 
  /* Ensure that the browse is updated. This needs to be done even if Asynch. 
     Refresh will make the current record in the browse available, so although 
     it is possible to do this very late in submitRow  (after submitCommit 
     publish of data available) we really don't want to change position during 
     the update, so we wait until the update-source does setDataModified(false), 
     which will publish this. */ 
  IF pcState = 'UpdateComplete':U THEN
    PUBLISH 'refreshBrowse':U FROM TARGET-PROCEDURE.
  
  /* If a row is deleted when autoCommit is off it publishes 'delete' in order     
     NOT to disable its nav-source or browse data-target, but still get the 
     message to its data-source, (which in this case will be us). 
     Note: Navsources does not really need this anymore as they use 
           canNavigate  to check the validity of the message, but browsers still 
           disables on 'update' and does nothing on 'delete' and only use
           canNavigate to validate 'updateComplete'.
          (they could be changed to use canNavigate for all states)           
     The data source republishes this as 'update', so that all nav-source and 
     data-target browsers ABOVE the uncommitted delete is disabled. */          
  IF pcState = 'Delete':U THEN
    pcState = 'Update':U.

  /* Reset is passed as a workaround from visual objects to avoid that a 
     tableio with updatemode publishes updatemode('updateend'). */ 
  IF pcState = 'Reset':U THEN
    pcState = 'UpdateComplete':U.
  
  /* The setting of DataModified can probably be removed ....
     The sdo sets it to no in submitCommit and getDataModified always checks
     updateSources, canNavigate is used to check all children, so we don't need 
     to set this based on children (which would be wrong anyways with many 
     children in tree branches ) */  
  IF pcState = 'Update':U THEN
    lModified = yes.

  ELSE IF pcState = 'UpdateComplete':U THEN
    lModified = no.
    
  /* Ensure that Modified State is only set when valid state is sent. */
  IF lModified <> ? THEN
    {set DataModified lModified}.
  
  /* If the SOURCE is DataTarget that also subscribes, set currentUpdateSource
     so the source can avoid republish the event  */ 
  {get UpdateSource cUpdateSource}.
  IF CAN-DO(cUpdateSource,STRING(SOURCE-PROCEDURE)) THEN
     {set CurrentUpdateSource SOURCE-PROCEDURE}.
  PUBLISH 'updateState':U FROM TARGET-PROCEDURE (pcState).
  {set CurrentUpdateSource ?}.
  
  RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-addForeignKey) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION addForeignKey Procedure 
FUNCTION addForeignKey RETURNS LOGICAL
  ( ) :
/*------------------------------------------------------------------------------
  Purpose: Assign the ForeignKey to the query string. 
    Notes: The ForeignKey consists of ForeignKeys and ForeignValues. 
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cLocalFields   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSourceFields  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hDataSource    AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cForeignFields AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cForeignValues AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iField         AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cField         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cValue         AS CHARACTER  NO-UNDO.

  &SCOPED-DEFINE xp-assign
  {get DataSource hDataSource}
  {get ForeignFields cForeignFields}
  .
  &UNDEFINE xp-assign
  
  IF NOT VALID-HANDLE(hDataSource) OR cForeignFields = '':U OR cForeignFields = ? THEN
    RETURN FALSE.
  
  DO iField = 1 TO NUM-ENTRIES(cForeignFields) BY 2:
    ASSIGN
                      /* 2nd of each pair is parent fld  */
      cField         = ENTRY(iField + 1, cForeignFields)
      cForeignValues = cForeignValues 
                     + (IF iField = 1 THEN "":U ELSE CHR(1))
                       /* unknown is dealt with below */
                     + {fnarg columnValue cField hDataSource}
      cLocalFields   = cLocalFields 
                      /* 1st of each pair is local fld  */
                     + (IF iField = 1 THEN "":U ELSE ",":U)
                     + ENTRY(iField, cForeignFields)
      .
  END.

  /* set all values to unknown if not avail parent if more than one field... 
    (should rather close the query or something..)    
    Note that removeForeignKey sets ForeignValues to ? (unknown)
    and that dataAvaialble relies on this difference '?' versus ? to figure out 
    if DataisFetched by parent */  
  IF cForeignValues = ? then
  do: 
    if NUM-ENTRIES(cForeignFields) > 2 THEN
      cForeignValues = RIGHT-TRIM(FILL('?':U + CHR(1),INT(NUM-ENTRIES(cForeignFields) / 2)),',').
    else
      cForeignValues = '?'.
  end.
  {set ForeignValues cForeignValues}. 

  RETURN DYNAMIC-FUNCTION("assignQuerySelection":U IN TARGET-PROCEDURE, 
                           cLocalFields,
                           cForeignValues,
                           '':U).  

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-assignBufferOuterJoin) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION assignBufferOuterJoin Procedure 
FUNCTION assignBufferOuterJoin RETURNS CHARACTER
  ( pcBuffer as char,
    pcQuery  as char):
/*------------------------------------------------------------------------------
  Purpose:     assign outer-join to the specified buffer's where clause.
  Parameters:  pcBuffer     - Buffer.  
               pcQuery      - The query string to add to. 
                              ? or "" use and set QueryString
    Notes: The QueryString is not assigned if pcQuery parameter is passed.
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cBufferWhere AS CHAR   NO-UNDO.
 
  DEFINE VARIABLE cNewWhere    AS CHAR   NO-UNDO.
  DEFINE VARIABLE iWherePos     AS INT  NO-UNDO.
  DEFINE VARIABLE iOfPos        AS INT  NO-UNDO.
  DEFINE VARIABLE iRelTblPos    AS INT  NO-UNDO.  
  DEFINE VARIABLE iInsertPos    AS INT  NO-UNDO.    
   
  DEFINE VARIABLE iUseIdxPos    AS INT  NO-UNDO.        
  DEFINE VARIABLE iOuterPos     AS INT  NO-UNDO.        
  DEFINE VARIABLE iLockPos      AS INT  NO-UNDO.      
   
  DEFINE VARIABLE iByPos        AS INT  NO-UNDO.        
  DEFINE VARIABLE iIdxRePos     AS INT  NO-UNDO.        
  DEFINE VARIABLE cTmpQuery     AS CHARACTER   NO-UNDO.
  DEFINE VARIABLE lStore        AS LOGICAL     NO-UNDO.

  if pcQuery = "":U or pcQuery = ? then
  do:
     {get QueryString pcQuery}.      
     /* If no QueryString use the default */ 
     IF pcQuery = "":U OR pcQuery = ? THEN
     DO:
        {get QueryStringDefault pcQuery}.    
     END.
     lStore = true.
  end.
  
    /* Get rid of potential line break characters (query builder -> repository)*/   
  assign
     pcQuery    = REPLACE(pcQuery,CHR(10),' ':U)
     /* Find the buffer's 'expression-entry' in the query */
     cBufferWhere = DYNAMIC-FUNCTION('bufferWhereClause':U IN TARGET-PROCEDURE,
                                      pcBuffer,
                                      pcQuery).
  if cBufferWhere = "" 
  /* no outer join on first table */
  or left-trim(cBufferWhere) begins "FOR":U 
  or left-trim(cBufferWhere) begins "PRESELECT":U then
     return pcQuery.

  assign    

     /* We mask quoted strings to ensure the following table and keyword lookup
        only finds stuff in the expression(in lack of parsing) */ 
     cTmpQuery  = DYNAMIC-FUNCTION("maskQuotes":U IN TARGET-PROCEDURE,
                                    cBufferWhere,'':U)
     iWherePos   = INDEX(cTmpQuery," WHERE ":U) + 6    

     iByPos      = INDEX(cTmpQuery," BY ":U)    
     iUseIdxPos  = INDEX(cTmpQuery," USE-INDEX ":U)    
     iIdxRePos   = INDEX(cTmpQuery + " ":U," INDEXED-REPOSITION ":U)    
     iOuterPos   = INDEX(cTmpQuery + " ":U," OUTER-JOIN ":U)     
     iLockPos    = MAX(INDEX(cTmpQuery + " ":U," NO-LOCK ":U),
                      INDEX(cTmpQuery + " ":U," SHARE-LOCK ":U),
                      INDEX(cTmpQuery + " ":U," EXCLUSIVE-LOCK ":U),
                      INDEX(cTmpQuery + " ":U," SHARE ":U),
                      INDEX(cTmpQuery + " ":U," EXCLUSIVE ":U)
                      ) 
     iInsertPos  = LENGTH(cTmpQuery) + 1 
     
     /* We insert before the leftmoust keyword,
        unless the keyword is Before the WHERE keyword */ 
     iInsertPos  = MIN(
                      (IF iLockPos   > iWherePos THEN iLockPos   ELSE iInsertPos),
                      (IF iUseIdxPos > iWherePos THEN iUseIdxPos ELSE iInsertPos),
                      (IF iIdxRePos  > iWherePos THEN iIdxRePos  ELSE iInsertPos),
                      (IF iByPos     > iWherePos THEN iByPos     ELSE iInsertPos)
                     )         
      .
      
  if iOuterPos > 0 then
     return pcQuery.

  cNewWhere = cBufferWhere.
  SUBSTRING(cNewWhere,iInsertPos,0) = " OUTER-JOIN":U. 
  pcQuery = replace(pcQuery,cBufferWhere,cNewWhere).
  if lStore then
     {set QueryString pcQuery}.      

  return pcQuery.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-assignQuerySelection) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION assignQuerySelection Procedure 
FUNCTION assignQuerySelection RETURNS LOGICAL
  (pcColumns   AS CHARACTER,   
   pcValues    AS CHARACTER,    
   pcOperators AS CHARACTER):
/*------------------------------------------------------------------------------   
   Purpose: Assigns selection criteria to the query and distributes the 
            column/value pairs to the corresponding buffer's where-clause. 
            Each buffer's expression will always be embedded in parenthesis.
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
   Notes:  Can be called before initialization, but the alternative string 
           operator is not supported before the object is initialized. 
           (datatype is not known)   
         -  This procedure is designed to be called several times to build up
            the the query's where clause 
            (storing intermediate results in the QueryString property) before 
            it is finally used in a Query-Prepare method. 
         -  openDataQuery takes care of the preparation of the QueryString 
            property.
         -  The QueryColumns property is used to ensure that each column and 
            operator only will be added once to the QueryString. The property is 
            also used to store the offset and length of the corresponding values.
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cQueryString   AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cTmpQuery      AS CHARACTER NO-UNDO.  
  DEFINE VARIABLE cBufferList    AS CHAR      NO-UNDO.
  DEFINE VARIABLE cBuffer        AS CHARACTER NO-UNDO.
  
  /* We need the columns name and the parts */  
  DEFINE VARIABLE cColumn        AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cColumnName    AS CHARACTER NO-UNDO.
    
  DEFINE VARIABLE iBuffer        AS INTEGER   NO-UNDO.
  DEFINE VARIABLE iColumn        AS INTEGER   NO-UNDO.
  
  DEFINE VARIABLE cUsedNums      AS CHAR      NO-UNDO.
  
  /* Used to builds the column/value string expression */
  DEFINE VARIABLE cBufWhere      AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cValue         AS CHAR      NO-UNDO.  
  DEFINE VARIABLE cOperator      AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cAndOr         AS CHAR      NO-UNDO.
       
  /* Used to store and maintain offset and length */    
  DEFINE VARIABLE iValLength     AS INTEGER   NO-UNDO.
  DEFINE VARIABLE iValPos        AS INTEGER   NO-UNDO.
  DEFINE VARIABLE iExpPos        AS INTEGER   NO-UNDO.
  DEFINE VARIABLE iPos           AS INTEGER   NO-UNDO.
  DEFINE VARIABLE iDiff          AS INTEGER   NO-UNDO.
  DEFINE VARIABLE cQueryColumns  AS CHAR      NO-UNDO.
  DEFINE VARIABLE cQueryBufCols  AS CHAR      NO-UNDO.
  DEFINE VARIABLE cQueryColOp    AS CHAR      NO-UNDO.
  DEFINE VARIABLE cChangedValues AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cChangedList   AS CHARACTER NO-UNDO.
  DEFINE VARIABLE iOldEntries    AS INTEGER   NO-UNDO.
  DEFINE VARIABLE iLowestChanged AS INTEGER   NO-UNDO.
  DEFINE VARIABLE iBufPos        AS INTEGER   NO-UNDO.
  DEFINE VARIABLE iColPos        AS INTEGER   NO-UNDO.
  DEFINE VARIABLE iWhereBufPos   AS INTEGER   NO-UNDO.
          
  &SCOPED-DEFINE xp-assign
  {get QueryTables cBufferList}    
  {get QueryString cQueryString}.      
  &UNDEFINE xp-assign
  
  /* If no QueryString use the default */ 
  IF cQueryString = "":U OR cQueryString = ? THEN
  DO:

    {get QueryStringDefault cQueryString}.    
  END.

  {get QueryColumns cQueryColumns}.
  /* cQueryColumns has the form of:
        BufName1:columns_of_buf1:BufName2:columns_of_buf2...
      
        Each columns_of_buf has the form of:
        ColumnName.Operator,ValuePosition,ValueLength
        
        The Operator is one of: ">=", "<=","<", ">", "=", "BEGINS", etc.
        The ValuePosition refers to the character position of the value
        in an expression: ColumnName Opr Value
        (The quote is considered part of the value)
        The length of the value is the number of characters in the string
        that represents the value (including quotes) */

  ASSIGN
    /* We only support AND in this function */
    cAndOr       = "AND":U. 
    /* remove bad white space */   
    cQueryString = REPLACE(cQueryString,CHR(10),' ':U).
 
  DO iBuffer = 1 TO NUM-ENTRIES(cBufferList):  
    ASSIGN
      cBufWhere      = "":U
      cBuffer        = ENTRY(iBuffer,cBufferList)
      iBufPos        = LOOKUP(cBuffer,cQueryColumns,":":U)
      cQueryBufCols  = IF iBufPos > 0 
                       THEN ENTRY(iBufPos + 1,cQueryColumns,":":U) 
                       ELSE "":U
      iOldEntries    = NUM-ENTRIES(cQueryBufCols) / 3    
      cChangedValues = FILL(CHR(1),iOldEntries - 1)
      cChangedList   = "":U
      iLowestChanged = 0.
      
    ColumnLoop:    
    DO iColumn = 1 TO NUM-ENTRIES(pcColumns):
             
      IF CAN-DO(cUsedNums,STRING(iColumn)) THEN 
        NEXT ColumnLoop.      
        
      RUN obtainExpressionEntries IN TARGET-PROCEDURE
                         (cBuffer,
                          iColumn,
                          pcColumns,
                          pcValues,
                          pcOperators,
                          OUTPUT cColumn, 
                          OUTPUT cOperator,
                          OUTPUT cValue).
     
      IF cColumn = '':U THEN
        NEXT.

      ASSIGN
        cUsedNums  = cUsedNums
                   + (IF cUsedNums = "":U THEN "":U ELSE ",":U)
                   + STRING(iColumn) 
        /* The Column and operator are unique entries so we must mak sure that  
           that blank or different styles doesn't get misinterpreted  */
        cQueryColOp = cOperator
        cQueryColOp = TRIM(     IF cQueryColOp = "GE":U THEN ">=":U
                           ELSE IF cQueryColOp = "LE":U THEN "<=":U
                           ELSE IF cQueryColOp = "LT":U THEN "<":U
                           ELSE IF cQueryColOp = "GT":U THEN ">":U
                           ELSE IF cQueryColOp = "EQ":U THEN "=":U
                           ELSE    cQueryColOp)
        cColumnName = ENTRY(NUM-ENTRIES(cColumn,'.':U),cColumn,'.':U)  

        /* Have the column and operator been added to the querystring
           (by this function) */  
        iPos        = LOOKUP(cColumnName + ".":U + cQueryColOp,cQueryBufCols).
          
      /* If the column + operator was found in the list
         we build a list of the new values to use when we insert the data
         into the QueryString further down.
         We also build a list of the changed numbers, to check if any change 
         has occured. (The list of new values cannot be checked because any 
         data may be new data and we don't know the old value) */         
      IF iPos > 0 THEN
        ASSIGN
          ENTRY(INT((iPos - 1) / 3 + 1),cChangedValues,CHR(1)) = cValue    
          iLowestChanged = MIN(iPos,IF iLowestChanged = 0 
                                    THEN iPos 
                                    ELSE iLowestChanged)
          cChangedList  = cChangedList 
                        + (IF cChangedList = "":U THEN "":U ELSE ",":U)
                        + STRING(INT((iPos - 1) / 3 + 1)).     
      ELSE DO: /* This is a new column + operator so we build the new 
                  expression and add the column and offset info to the list 
                  that will be stored as a part of QueryColumns */   
        ASSIGN          
          cBufWhere  = cBufWhere 
                     + (If cBufWhere = "":U 
                        THEN "":U 
                        ELSE " ":U + cAndOr + " ":U)
                     + cColumn 
                     + " ":U
                     + cOperator
                     + " ":U
                     + cValue
                                             
         /* Calculate the temporary offset of this columns value. 
            We (Who are we?) will justify it after the expression has been 
            added to the whereclause, because even if we know the buffer's 
            position, the expression may or may not need and/where */
         iValPos   = LENGTH(cBufWhere) - LENGTH(cValue)         
                    
           /* Store the ColumName and operator with period as delimiter and 
              add the position and length as separate entries*/
         cQueryBufCols = cQueryBufCols 
                       + (IF cQueryBufCols <> "":U THEN ",":U ELSE "":U)
                       + cColumnName 
                       + ".":U 
                       + cQueryColOp 
                       + ",":U
                       + STRING(iValPos)  
                       + ",":U
                       + STRING(LENGTH(cValue))
           
           /* Ensure that the list used to log changes have correct number of
              entries (Probably only necessary if the SAME column and operator
                       appears a second time in the same call, which is unlikely)
                       */                
         cChangedValues = cChangedValues + CHR(1).                
      END. /* else do =(ipos = 0) */
    END. /* do iColumn = 1 to num-entries(pColumns) */  
    
    /* Get the buffers position in the where clause (always the
       first entry in a dynamic query because there's no 'of <external>')*/ 
    ASSIGN
      /* We mask quoted strings to ensure the following table lookup
         only finds stuff in the expression(in lack of parsing) */ 
      cTmpQuery   = DYNAMIC-FUNCTION("maskQuotes":U IN TARGET-PROCEDURE,
                                      cQueryString,'':U)
      iWhereBufPos = INDEX(cTmpQuery + " "," ":U + cBuffer + " ":U)
      iPos         = INDEX(cTmpQuery,      " ":U + cBuffer + ",":U)
      iWhereBufPos = (IF iWhereBufPos > 0 AND iPos > 0
                      THEN MIN(iPos,iWhereBufPos) 
                      ELSE MAX(iPos,iWhereBufPos))
                      + 1
      iDiff        = 0.                          

    /* We have a new expression */                               
    IF cBufWhere <> "":U THEN
    DO: 
      ASSIGN 
        cQueryString = DYNAMIC-FUNCTION('newWhereClause':U IN TARGET-PROCEDURE,
                                         cBuffer,
                                         cBufWhere,
                                         cQueryString,
                                         'AND':U) 
        /* get the offset of the new expression */
        iExpPos      = INDEX(cQuerystring,cBufwhere,iWhereBufPos).
      
      /* Store the offset from the buffer's offset */  
      DO iColumn =((iOldEntries + 1) * 3) - 2 TO NUM-ENTRIES(cQueryBufCols) BY 3:
        ENTRY(iColumn + 1,cQueryBufCols) = 
                            STRING(INT(ENTRY(iColumn + 1,cQueryBufCols)) 
                                   + (iExpPos - iWhereBufPos)
                                   ).                 
      END. /* do icolumn = 1 to num-entries */        
    END. /* if cbufwhere <> '' do */  
    
    IF iLowestChanged > 0 THEN 
    DO iColumn = iLowestChanged TO NUM-ENTRIES(cQueryBufCols) BY 3:       
      ASSIGN
        iValPos    = INT(ENTRY(iColumn + 1,cQueryBufCols))
        iValLength = INT(ENTRY(iColumn + 2,cQueryBufCols))
        iValPos    = iValPos + iDiff.                    
                     
      IF CAN-DO(cChangedList,STRING(INT((iColumn - 1) / 3 + 1))) THEN       
      DO:
        ASSIGN
          cValue     = ENTRY(INT((iColumn - 1) / 3 + 1),cChangedValues,CHR(1)) 
          SUBSTR(cQueryString,iValPos + iWhereBufPos,iValLength) = cValue
          idiff      = iDiff + (LENGTH(cValue) - iValLength)
          iValLength = LENGTH(cValue).   
      END. /* can-do(changelist,string(..) */          
      ASSIGN      
        ENTRY(iColumn + 1,cQueryBufCols) = STRING(iValPos)
        ENTRY(iColumn + 2,cQueryBufCols) = STRING(iVallength).      
    END. /* else if ilowestchanged do icolumn = ilowestChanged to num-entries */  
    
    /* If the buffer has no entry in QueryColumns we append the new entry 
       The order in Querycolumns is NOT dependent of the order in the query */              
    IF cQueryBufCols <> "":U THEN
    DO:    
      IF iBufPos = 0 THEN 
      DO:  
         cQueryColumns = cQueryColumns 
                         + (IF cQueryColumns = "":U THEN "":U ELSE ":":U)
                         + cBuffer + ":" + cQueryBufCols.
      
       /* if toggle outer join is true (default) and the default/design query 
          has outer join on this table then remove it */ 
        if {fn getToggleOuterJoin} and {fnarg bufferHasOuterJoinDefault cBuffer} then
           cQueryString = DYNAMIC-FUNCTION('removeBufferOuterJoin':U IN TARGET-PROCEDURE,
                                         cBuffer,
                                         cQueryString).
      end.                                    
      ELSE   /* There is already a entry for this buffer */
        ENTRY(iBufPos + 1,cQueryColumns,":":U) = cQueryBufCols. 
       
                
    END. /* cQueryBufCols <> '' */

  END. /* do iBuffer = 1 to hQuery:num-buffers */
  
  &SCOPED-DEFINE xp-assign
  {set QueryColumns cQueryColumns}
  {set QueryString cQueryString}.
  &UNDEFINE xp-assign
  
  RETURN TRUE. 

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-bufferHasOuterJoin) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION bufferHasOuterJoin Procedure 
FUNCTION bufferHasOuterJoin RETURNS logical
    ( pcBuffer as char,
      pcQuery  as char):
  /*------------------------------------------------------------------------------
    Purpose:     return true if theres is an outer-join in the specified 
                 buffer's where clause.
    Parameters:  pcBuffer     - Buffer in basequery.  
                 pcQuery      - The query string  
                                ? or "" use current query.
      Notes:  
  ------------------------------------------------------------------------------*/
   DEFINE VARIABLE cBufferWhere AS CHAR   NO-UNDO.
   DEFINE VARIABLE cMaskedWhere AS CHAR   NO-UNDO.
     
   if pcQuery = "":U or pcQuery = ? then
   do:
     {get QueryString pcQuery}.      
     /* If no QueryString use the default */ 
     IF pcQuery = "":U OR pcQuery = ? THEN
     DO:
        {get QueryStringDefault pcQuery}.    
     END.
   end.

   if index(pcQuery, "OUTER-JOIN":U) = 0 then
      return false.
     
   assign
     /* Find the buffer's 'expression-entry' in the query */
     cBufferWhere = DYNAMIC-FUNCTION('bufferWhereClause':U IN TARGET-PROCEDURE,
                                      pcBuffer,
                                      pcQuery)
       /* We mask quoted strings to ensure the following lookup
          only finds stuff in the expression(in lack of parsing) */ 
     cMaskedWhere   = DYNAMIC-FUNCTION("maskQuotes":U IN TARGET-PROCEDURE,
                                        cBufferWhere,'':U).

   return index(cMaskedWhere + " "," OUTER-JOIN ":U) > 0. 
  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-bufferHasOuterJoinDefault) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION bufferHasOuterJoinDefault Procedure 
FUNCTION bufferHasOuterJoinDefault RETURNS LOGICAL
  ( pcBuffer as char):
/*------------------------------------------------------------------------------
  Purpose: return true if the buffer has outer-join in the default query  
  Parameter:  pcBuffer - Buffer in object.  (no check)
    Notes:  
------------------------------------------------------------------------------*/
  
  DEFINE VARIABLE cDefaultQuery AS CHARACTER   NO-UNDO.
  
  {get DataQueryString cDefaultQuery}.

  RETURN DYNAMIC-FUNCTION('bufferHasOuterJoin':U IN TARGET-PROCEDURE,
                           pcBuffer,cDefaultQuery).

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-bufferWhereClause) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION bufferWhereClause Procedure 
FUNCTION bufferWhereClause RETURNS CHARACTER
  (pcBuffer AS CHAR,
   pcWhere  AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose:     Returns the complete query where clause for a specified buffer
               INCLUDING leading and trailing blanks.
               EXCLUDING commas and period.                            
  Parameters:  pcBuffer     - Buffer. See notes
               pcWhere      - A complete query:prepare-string.
                            - ? use the current query                              
  Notes:       This is supported as a 'utility function' that doesn't use any 
               properties. 
               if target-procedure = super the passed buffer's qualification 
               MUST match the query's. 
               If target-procedure <> super the buffer will be corrected 
               IF it exists in the object's query.  
            -  RETURNs the expression immediately when found. 
               RETURNs '' at bottom if nothing is found. 
------------------------------------------------------------------------------*/
 DEFINE VARIABLE iComma      AS INT        NO-UNDO. 
 DEFINE VARIABLE iCount      AS INT        NO-UNDO.
 DEFINE VARIABLE iStart      AS INT        NO-UNDO.
 DEFINE VARIABLE cString     AS CHAR       NO-UNDO.
 DEFINE VARIABLE cFoundWhere AS CHAR       NO-UNDO.
 DEFINE VARIABLE cNextWhere  AS CHAR       NO-UNDO.
 DEFINE VARIABLE cTargetType AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cBuffer     AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE iByPos      AS INT        NO-UNDO.        
 DEFINE VARIABLE iIdxRePos   AS INT        NO-UNDO.  
 DEFINE VARIABLE iOptionPos  AS INTEGER    NO-UNDO.
 DEFINE VARIABLE cTmpQuery   AS CHARACTER  NO-UNDO.

 /* If unkown value is passed used the existing query string */
 IF pcWhere = ? THEN
 DO:
   /* The QueryString contains data if the query is being currently worked on 
      by this method or addQuerywhere over many calls. */
   {get QueryString pcWhere}.      
   /* If no QueryString find the current query */ 
   IF pcWhere = "":U OR pcWhere = ? THEN
     {get QueryStringDefault pcWhere}.    
 END. /* pcWhere = ? */

 ASSIGN
   cString = RIGHT-TRIM(pcWhere," ":U)  
   iStart  = 1.

 /* Keep our promises and ensure that trailing blanks BEFORE the period are 
    returned, but remove the period and trailing blanks AFTER it. 
    If the length of right-trim with blank and blank + period is the same 
    then there is no period, so just use the passed pcWhere as is. 
    (Otherwise the remaining period is right-trimmed with comma further down)*/  
 IF LENGTH(cString) = LENGTH(RIGHT-TRIM(pcWhere,". ":U)) THEN
   cString = pcWhere.

 /* This is the guts of what used to be in newQueryWhere, which used to be 
    called without IN TARGET-PROCEDURE... so if target is a super we just keep 
    the old requirement of correct qual, otherwise we try to resolve it,
    but we continue the search also if it is not found in the current query 
    in order to support this and newQueryWhere as utilities for any buffer and 
    query.  */ 
 cTargetType = DYNAMIC-FUNCTION('getObjectType':U IN TARGET-PROCEDURE).
 
 IF cTargetType <> 'SUPER':U THEN
 DO:
   cBuffer = {fnarg resolveBuffer pcBuffer}. 
 
   IF cBuffer <> '':U AND cBuffer <> ? THEN
     pcBuffer = cBuffer.
 END. /* TARGET = SUPER */

 DO WHILE TRUE:
   iComma  = INDEX(cString,",":U). 
   
   /* If a comma was found we split the string into cFoundWhere and cNextwhere */  
   IF iComma <> 0 THEN 
     ASSIGN
       cFoundWhere = cFoundWhere + SUBSTR(cString,1,iComma)
       cNextWhere  = SUBSTR(cString,iComma + 1)     
       iCount      = iCount + iComma.       
   ELSE      
     /* cFoundWhere is blank if this is the first time or if we have moved on 
        to the next buffer's where clause
        If cFoundwhere is not blank the last comma that was used to split 
        the string into cFoundwhere and cNextwhere was not a join, so we set 
        them together again.  */     
     cFoundWhere = IF cFoundWhere = "":U 
                   THEN cString
                   ELSE cFoundWhere + cNextwhere.
          
   /* We have a complete table whereclause if there are no more commas
      or the next whereclause starts with each,first or last */    
   IF iComma = 0 
   OR CAN-DO("EACH,FIRST,LAST":U,ENTRY(1,TRIM(cNextWhere)," ":U)) THEN
   DO:
     /* Remove comma or period before inserting the new expression */
     ASSIGN
       cFoundWhere = RIGHT-TRIM(cFoundWhere,",.":U). 
       /* We mask quoted strings to ensure the following table and keyword lookup
          only finds stuff in the expression(in lack of parsing) */ 
       cTmpQuery   = DYNAMIC-FUNCTION("maskQuotes":U IN TARGET-PROCEDURE,
                                       cFoundWhere,'':U)
       .

     IF {fnarg whereClauseBuffer cTmpQuery} = pcBuffer THEN
     DO:
       ASSIGN
         iByPos        = INDEX(cTmpQuery," BY ":U)    
         iIdxRePos     = INDEX(cTmpQuery + " ":U," INDEXED-REPOSITION ":U)
         iOptionPos    = MIN(IF iByPos > 0     THEN iByPos     ELSE LENGTH(cFoundWhere),
                             IF iIdxRePos > 0  THEN iIdxRePos  ELSE LENGTH(cFoundWhere)
                            )
         .

       RETURN TRIM(SUBSTR(cFoundWhere,1,iOptionPos)).
     END.
     ELSE
       /* We're moving on to the next whereclause so reset cFoundwhere */ 
       ASSIGN      
         cFoundWhere = "":U                     
         iStart      = iCount + 1.      
     
     /* No table found and we are at the end so we need to get out of here */  
     IF iComma = 0 THEN 
       LEAVE.    
   END. /* if iComma = 0 or can-do(EACH,FIRST,LAST */
   cString = cNextWhere.  
 END. /* do while true. */

 RETURN '':U.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-calcBatchSize) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION calcBatchSize Procedure 
FUNCTION calcBatchSize RETURNS INTEGER
        ( piNeeded as int):
/*------------------------------------------------------------------------------
    Purpose: Calculate a new batch size that is dividible on the batchsize
             and large enough to include the needed number of rows.
    Notes:      
------------------------------------------------------------------------------*/
   DEFINE VARIABLE iRowsToBatch AS INTEGER    NO-UNDO.
   
   {get RowsToBatch iRowsToBatch}.
   if iRowsToBatch = ? or iRowsToBatch = 0 then 
     return iRowsToBatch.
   else  
     return piNeeded 
            + if (piNeeded modulo iRowsToBatch) = 0 
              then 0
              else iRowsToBatch - (piNeeded modulo iRowsToBatch).  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnQuerySelection) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION columnQuerySelection Procedure 
FUNCTION columnQuerySelection RETURNS CHARACTER
  ( pcColumn AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:     Returns a CHR(1) separated string with ALL operators and values 
               that has been added to the Query for this column using the 
               assignQuerySelection method. 
               
               Example: If the query contains 'custnum > 5 and custnum < 9' 
                        this function will return (chr(1) is shown as '|'): 
                        '>|5|<|9'    
                              
  Parameters:
   INPUT pcColumn - Fieldname of a table in the query in the form of 
                    TBL.FLDNM or DB.TBL.FLDNM (only if qualified with db),
                    If the fieldname isn't qualified it checks the tables in 
                    the TABLES property and assumes the first with a match.
 
  Notes:       The data returned reflects the QueryString/QueryColumns properties, 
               which is maintained by the assignQuerySelection. These values
               may not have been used in an openQuery yet.
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cQueryString   AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cBuffer        AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cBufferList    AS CHARACTER NO-UNDO.
  
  DEFINE VARIABLE cColumn        AS CHARACTER NO-UNDO.
    
  DEFINE VARIABLE iBuffer        AS INTEGER   NO-UNDO.
  DEFINE VARIABLE cValue         AS CHARACTER  NO-UNDO.  
  DEFINE VARIABLE cOperator      AS CHARACTER NO-UNDO.
        
  /* Used to store and maintain offset and length */    
  DEFINE VARIABLE iValLength     AS INTEGER   NO-UNDO.
  DEFINE VARIABLE iValPos        AS INTEGER   NO-UNDO.
  DEFINE VARIABLE cString        AS CHAR      NO-UNDO.
  DEFINE VARIABLE cQueryColumns  AS CHAR      NO-UNDO.
  DEFINE VARIABLE cQueryBufCols  AS CHAR      NO-UNDO.
  DEFINE VARIABLE iBufPos        AS INTEGER   NO-UNDO.
  DEFINE VARIABLE iColPos        AS INTEGER   NO-UNDO.
  DEFINE VARIABLE iPos           AS INTEGER   NO-UNDO.
  DEFINE VARIABLE iNumEnt        AS INTEGER   NO-UNDO.
  DEFINE VARIABLE cSelection     AS CHAR      NO-UNDO.
  DEFINE VARIABLE iWhereBufPos   AS INTEGER   NO-UNDO.
  
  &SCOPED-DEFINE xp-assign
  {get QueryString cQueryString}
  {get QueryColumns cQueryColumns}.
  &UNDEFINE xp-assign
  
  /* If the properties are blank we return immediately with blank */
  IF cQueryString = "":U OR cQueryColumns = "":U THEN 
    RETURN "":U.

  iNumEnt  = NUM-ENTRIES(pcColumn,".":U).
  
  /* If the column is qualified add the buffer part of it to the bufferlist
     which then will be the only entry in the list for the loop below */ 
  
  IF iNumEnt > 1 THEN
    ASSIGN
      cBufferList = SUBSTR(pcColumn,1,R-INDEX(pcColumn,".") - 1)
      cBufferList = {fnarg resolveBuffer cBufferList} 
      cColumn     = ENTRY(iNumEnt,pcColumn,".":U).
  
  ELSE DO:         
    cColumn = pcColumn.     
    {get QueryTables cBufferList}.    
  END.
  
  DO iBuffer = 1 TO NUM-ENTRIES(cBufferList):    
    ASSIGN
      cBuffer        = ENTRY(iBuffer,cBufferList)
      iBufPos        = LOOKUP(cBuffer,cQueryColumns,":":U)
      cQueryBufCols  = IF iBufPos > 0 
                       THEN ENTRY(iBufPos + 1,cQueryColumns,":":U) 
                       ELSE "":U
      iWhereBufPos   = INDEX(cQueryString + " ":U," ":U + cBuffer + " ":U)
      iPos           = INDEX(cQueryString,      " ":U + cBuffer + ",":U)
      iWhereBufPos   = (IF iWhereBufPos > 0 AND iPos > 0
                        THEN MIN(iPos,iWhereBufPos) 
                        ELSE MAX(iPos,iWhereBufPos))
                        + 1
      iColPos = 1.
      
    DO WHILE icolPos > 0:
      /* Add comma to cQueryBufCols to find first entry and search for ,column.*/
      iColPos = INDEX(",":U + cQueryBufCols,",":U + cColumn + ".":U,icolPos).
      IF iColpos > 0 THEN
      DO:
        ASSIGN
          iColPos    = iColPos + LENGTH(cColumn) + 1
          cString    = SUBSTR(cQueryBufCols,iColPos)
          cOperator  = ENTRY(1,cString)
          iValPos    = INT(ENTRY(2,cString)) 
          iValLength = INT(ENTRY(3,cString))
          cValue     = SUBSTR(cQueryString,iValPos + iWhereBufPos,iValLength)
           /* replace escaped single quotes */
          cValue     = (REPLACE(CValue,"~~'","'"))
          /* From 9.1B the quote is included in the pos/length */
          cValue     = IF NOT cValue BEGINS "'" THEN cValue
                       ELSE SUBSTR(cValue,2,LENGTH(cValue) - 2)
          cSelection = cSelection 
                       + CHR(1)
                       + cOperator
                       + CHR(1)
                       + cValue.                       
      END.  /* if icolpos > 0 */
    END. /* do while icolpos > 0 */    
    IF cSelection <> "":U THEN LEAVE.
  END. /* do ibuffer = 1 to num-entries */      
  
  RETURN LEFT-TRIM(cSelection,CHR(1)). 
  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-compareClobValues) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION compareClobValues Procedure 
FUNCTION compareClobValues RETURNS LOGICAL
  ( phColumn1  AS HANDLE,
    pcOperator AS CHAR,
    phcolumn2  AS HANDLE,
    pcStrength AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose: compare two CLOB buffer-fields  
    Notes: The core does not currently support compare of CLOBs 
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cLong1    AS LONGCHAR   NO-UNDO.
  DEFINE VARIABLE cLong2    AS LONGCHAR   NO-UNDO.
  DEFINE VARIABLE lUnknown1 AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lUnknown2 AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lEqual    AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lCompare  AS LOGICAL    NO-UNDO.

  ASSIGN
    lEqual    = CAN-DO('=,EQ':U,pcOperator)
    lUnknown1 = (phColumn1:BUFFER-VALUE = ?)
    lUnknown2 = (phColumn2:BUFFER-VALUE = ?).

  IF lUnknown1 AND lUnknown2 THEN
    lCompare = lEqual.
  ELSE IF lUnknown1 OR lUnknown2 THEN
    lCompare = NOT lEqual.
  ELSE IF LENGTH(phColumn1:BUFFER-VALUE) <> LENGTH(phColumn2:BUFFER-VALUE) THEN
    lCompare = NOT lEqual.

  ELSE DO:
    COPY-LOB FROM phColumn1:BUFFER-VALUE TO cLong1.
    COPY-LOB FROM phColumn2:BUFFER-VALUE TO cLong2.
    lCompare = COMPARE(cLong1,pcOperator,cLong2,pcStrength).
  END.

  RETURN lCompare.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-compareFieldValues) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION compareFieldValues Procedure 
FUNCTION compareFieldValues RETURNS LOGICAL
  ( phColumn1  AS HANDLE,
    piExtent1  AS INTEGER,
    pcOperator AS CHAR,
    phColumn2  AS HANDLE,
    piExtent2  AS INTEGER,
    pcStrength AS CHAR):
/*------------------------------------------------------------------------------
  Purpose: Compare the values of two field handles of same datatype  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE lSame   AS LOGICAL  NO-UNDO.
  DEFINE VARIABLE iExtent AS INTEGER  NO-UNDO.
 
  IF phColumn1:DATA-TYPE = 'CLOB':U THEN
    lSame = DYNAMIC-FUNCTION('compareClobValues':U IN TARGET-PROCEDURE,
                              phColumn1,pcOperator,phColumn2,pcStrength).

  ELSE IF phColumn1:DATA-TYPE = 'CHARACTER':U THEN   
    lSame = COMPARE(phColumn1:BUFFER-VALUE(piExtent1),
                    pcOperator,
                    phColumn2:BUFFER-VALUE(piExtent2),
                    pcStrength).
  ELSE DO:
    CASE pcOperator:
      WHEN "EQ":U OR WHEN "=":U THEN
        lSame = phColumn1:BUFFER-VALUE(piExtent1) EQ phColumn2:BUFFER-VALUE(piExtent2).
      WHEN "LT":U OR WHEN "<":U THEN
        lSame = phColumn1:BUFFER-VALUE(piExtent1) LT phColumn2:BUFFER-VALUE(piExtent2).
      WHEN "LE":U OR WHEN "<=":U THEN
        lSame = phColumn1:BUFFER-VALUE(piExtent1) LE phColumn2:BUFFER-VALUE(piExtent2).
      WHEN "GE":U OR WHEN ">=":U THEN
        lSame = phColumn1:BUFFER-VALUE(piExtent1) GE phColumn2:BUFFER-VALUE(piExtent2).
      WHEN "GT":U OR WHEN ">":U THEN
        lSame = phColumn1:BUFFER-VALUE(piExtent1) GT phColumn2:BUFFER-VALUE(piExtent2).
      WHEN "NE":U OR WHEN "<>":U THEN
        lSame = phColumn1:BUFFER-VALUE(piExtent1) NE phColumn2:BUFFER-VALUE(piExtent2).
      OTHERWISE
      DO:
        MESSAGE
            'Invalid operator "' + pcOperator + '":U for non-character field'
            + phColumn1:NAME + ' passed to ' + program-name(1).
        RETURN ?.
      END.
    END CASE.
  END.

  RETURN lSame.   

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-findRow) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION findRow Procedure 
FUNCTION findRow RETURNS LOGICAL
  (pcKeyValues AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose: Find and reposition to a row using the key.
Parameter: pcKeyFields - Comma or chr(1) separated list of keyfields. 
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cKeyFields AS CHAR   NO-UNDO.
  
  {get KeyFields cKeyFields}.
  
  /* If comma separated list replace with chr(1) */  
  IF NUM-ENTRIES(cKeyFields) > 1 AND INDEX(pcKeyValues,CHR(1)) = 0 THEN 
     pcKeyValues = REPLACE(pcKeyValues,",":U,CHR(1)).

  RETURN DYNAMIC-FUNCTION('findRowWhere':U IN TARGET-PROCEDURE, 
                          cKeyFields,
                          pcKeyValues,
                          "=":U). 
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-firstRowids) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION firstRowids Procedure 
FUNCTION firstRowids RETURNS CHARACTER
  (pcQueryString AS CHARACTER ) :
/*------------------------------------------------------------------------------
   Purpose:   Returns the ROWID (converted to a character string) of the first 
              query row satisfying the passed query prepare string.   
Parameters:
    pcWhere - A complete query where clause that matches the database query's 
              buffers.
     Notes:   Used by data class rowidwhere.
              Dataview findRowobjectwhere and findRowWhere  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hQuery      AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hBuffer     AS HANDLE    NO-UNDO.
  DEFINE VARIABLE cBuffer     AS CHAR      NO-UNDO.
  DEFINE VARIABLE cBufferList AS CHAR      NO-UNDO.
  DEFINE VARIABLE hRowQuery   AS HANDLE    NO-UNDO.
  DEFINE VARIABLE lOK         AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE i           AS INTEGER   NO-UNDO.
    
  DEFINE VARIABLE cRowIds    AS CHARACTER NO-UNDO.
  
  {get QueryHandle hQuery}.
    
  CREATE QUERY hRowQuery.     /* Get a query to do the "FIND" */
  
  /* Create buffers and add to the query. 
     we must create buffers to avoid conflict with the original query
     in case it's PRESELECT (non-indexed sort) */
  DO i = 1 TO hQuery:NUM-BUFFERS:
    ASSIGN
      hBuffer = hQuery:GET-BUFFER-HANDLE(i)
      cBuffer = hBuffer:NAME.
       
    CREATE BUFFER hBuffer FOR TABLE hBuffer BUFFER-NAME cBuffer.
    hRowQuery:ADD-BUFFER(hBuffer).
    cBufferList = cBufferList 
                  + (IF i = 1 THEN '':U ELSE ',':U)
                  + STRING(hBuffer). 
  END.  /* do i = 1 to */

  lOK = hRowQuery:QUERY-PREPARE(pcQueryString) NO-ERROR.
      
  IF lOK THEN lOK = hRowQuery:QUERY-OPEN().
  IF lOK THEN lOK = hRowQuery:GET-FIRST().
    
  /* Get the rowids and delete the temporary buffers */
  DO i = 1 TO NUM-ENTRIES(cBufferList):
    ASSIGN
      hBuffer = WIDGET-HANDLE(ENTRY(i,cBufferList))
      cRowids = cRowids 
              + (IF i = 1 THEN "":U ELSE ",":U)
              + (IF lOk AND hBuffer:AVAILABLE 
                 THEN STRING(hBuffer:ROWID)
                 ELSE '':U).
    DELETE OBJECT hBuffer.
  END. /* do i = 1 to hRowQuery:num-buffers */ 
  DELETE OBJECT hRowQuery.  
    
  RETURN IF lOk THEN cRowids ELSE ?.

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
------------------------------------------------------------------------------*/
  DEFINE VARIABLE lAuto AS LOGICAL NO-UNDO.

  &SCOPED-DEFINE xpAutoCommit
  {get AutoCommit lAuto}.
  &UNDEFINE xpAutoCommit
  RETURN lAuto.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getBLOBColumns) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getBLOBColumns Procedure 
FUNCTION getBLOBColumns RETURNS CHARACTER
  ( ) :
/*------------------------------------------------------------------------------
    Purpose:  Returns a comma-delimited list of the BLOB data-type 
              columnNames for the SmartDataObject. 
  Parameters:  
       Notes: This is a runtime property that on the first call will
              be resolved from DataColumns and RowObject definition. 
           -  Very expensive if requested before the first data request as
              it then may resolve each column's data-type on the server.
             (This should not be necessary though)   
           -  read-only  (no SET is implemented)    
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cBLOBColumns AS CHARACTER  NO-UNDO.

  &SCOPED-DEFINE xpBLOBColumns
  {get BLOBColumns cBLOBColumns}.
  &UNDEFINE xpBLOBColumns
  
  /* if unknown then resolve this from rowobject and datacolumn data-types */
  IF cBLOBColumns = ? THEN
  DO:
    {fn updateLargeColumns}.
    
    &SCOPED-DEFINE xpBLOBColumns
    {get BLOBColumns cBLOBColumns}.
    &UNDEFINE xpBLOBColumns
    
  END.

  RETURN cBLOBColumns.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getBufferHandles) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getBufferHandles Procedure 
FUNCTION getBufferHandles RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cBufferHandles AS CHARACTER  NO-UNDO.
                     
  {get BufferHandles cBufferHandles}.
  
  RETURN cBufferHandles.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getCLOBColumns) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getCLOBColumns Procedure 
FUNCTION getCLOBColumns RETURNS CHARACTER
  ( ) :
/*------------------------------------------------------------------------------
    Purpose:  Returns a comma-delimited list of the CLOB data-type 
              columnNames for the SmartDataObject. 
  Parameters:  
       Notes: This is a runtime property that on the first call will
              be resolved from DataColumns and RowObject definition. 
           -  Very expensive if requested before the first data request as
              it then may resolve each column's data-type on the server.
             (This should not be necessary though)     
          -  read-only  (no SET is implemented)    
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cCLOBColumns AS CHARACTER  NO-UNDO.

  &SCOPED-DEFINE xpCLOBColumns
  {get CLOBColumns cCLOBColumns}.
  &UNDEFINE xpCLOBColumns
  
  /* if unknown then resolve this from rowobject and datacolumn data-types */
  IF cCLOBColumns = ? THEN
  DO:
    {fn updateLargeColumns}.
    
    &SCOPED-DEFINE xpCLOBColumns
    {get CLOBColumns cCLOBColumns}.
    &UNDEFINE xpCLOBColumns
    
  END.

  RETURN cCLOBColumns.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getCommitSource) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getCommitSource Procedure 
FUNCTION getCommitSource RETURNS HANDLE
  ( ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the handle of the object's CommitSource.
   Params:  <none>
------------------------------------------------------------------------------*/

  DEFINE VARIABLE hSource AS HANDLE NO-UNDO.
  {get CommitSource hSource}.
  RETURN hSource.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getCommitSourceEvents) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getCommitSourceEvents Procedure 
FUNCTION getCommitSourceEvents RETURNS CHARACTER
(  ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the list of events this object subscribes to in its
            Commit-Source
   Params:  <none>
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cEvents AS CHARACTER NO-UNDO.
  {get CommitSourceEvents cEvents}.
  RETURN cEvents.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getCommitTarget) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getCommitTarget Procedure 
FUNCTION getCommitTarget RETURNS CHARACTER
  ( ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the handle of the object's CommitTarget, in character form.
   Params:  <none>
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cTarget AS CHARACTER NO-UNDO.
  {get CommitTarget cTarget}.
  RETURN cTarget.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getCommitTargetEvents) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getCommitTargetEvents Procedure 
FUNCTION getCommitTargetEvents RETURNS CHARACTER
(  ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the list of events this object subscribes to in its
            Commit-Target
   Params:  <none>
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cEvents AS CHARACTER NO-UNDO.
  {get CommitTargetEvents cEvents}.
  RETURN cEvents.

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
  ( ) :
/*------------------------------------------------------------------------------
  Purpose:     Returns a comma-delimited list of the columnNames for the 
               SmartDataObject. 
  Parameters:  
       Notes:   
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cColumns AS CHARACTER NO-UNDO.
  
  {get DataColumns cColumns}.
  RETURN cColumns.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDataHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getDataHandle Procedure 
FUNCTION getDataHandle RETURNS HANDLE
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the handle to the temp-table query
   Params:  <none>
------------------------------------------------------------------------------*/

  DEFINE VARIABLE hData AS HANDLE NO-UNDO.
  {get DataHandle hData}.
  RETURN hData.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDataIsFetched) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getDataIsFetched Procedure 
FUNCTION getDataIsFetched RETURNS LOGICAL
  (  ) :
/*------------------------------------------------------------------------------
   Purpose: Tells whether data for the query already is fetched
     This class: Used to manage prodataset children,
                 ?    -  default, set to true or false when data is retrieved.    
                 True -  used for a child's prodataset default retrieval, which
                         includes all children for all parents, which means that 
                         it never is necessary to request data from the server
                         for the child.
                 False - used on a child that only has data for one parent.
                         Set to false to override default prodataset retrieval.
     Query class: Default to no ( static sdo in initProps)
            The SBO sets this to true in the SDO when it has fethed 
            data on the SDOs behalf in order to prevent that the SDO does 
            another server call to fetch the data it already has. 
            This is checked in query.p dataAvailable and openQuery is skipped
            if its true. It's immediately turned off after it is checked.    
    Notes: Duplicated in sboext 
Note Date: 2005/10/1    
------------------------------------------------------------------------------*/
  DEFINE VARIABLE lFetched AS LOGICAL    NO-UNDO.
  {get DataIsFetched lFetched}.

  RETURN lFetched.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDataModified) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getDataModified Procedure 
FUNCTION getDataModified RETURNS LOGICAL
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:     Returns TRUE if the current RowObject record is BEING modified, 
  Parameters:  <none>  
  Notes:       We check updateTargets since this may be called from 
               the toolbar as a result of the updateSource's  
               setDataModifed -> publish updateState, BEFORE the updateState
               reaches us...                       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE lDataModified AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE cUpdateSource AS CHAR      NO-UNDO.
  DEFINE VARIABLE iSource       AS INTEGER   NO-UNDO.
  DEFINE VARIABLE hSource       AS HANDLE    NO-UNDO.

  {get UpdateSource cUpdateSource}.
  DO iSource = 1 TO NUM-ENTRIES(cUpdateSource):
    hSource = WIDGET-HANDLE(ENTRY(iSource,cUpdateSource)).
    IF VALID-HANDLE(hSource) and {fnarg instanceOf 'DataVisual':U hSource} THEN 
    DO:
      {get DataModified lDataModified hSource}.
      IF lDataModified THEN
        LEAVE.
    END.
  END.

  RETURN lDataModified.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDataQueryBrowsed) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getDataQueryBrowsed Procedure 
FUNCTION getDataQueryBrowsed RETURNS LOGICAL
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:      Returns TRUE if this SmartDataObject's Query is being browsed 
                by a SmartDataBrowser.
  
  Parameters:  <none>
  Notes:        This is used to prevent two SmartDataBrowsers from attempting 
                to browse the same query, which is not allowed.
------------------------------------------------------------------------------*/

  DEFINE VARIABLE lBrowsed AS LOGICAL NO-UNDO.

  &SCOPED-DEFINE xpDataQueryBrowsed
  {get DataQueryBrowsed lBrowsed}.
  &UNDEFINE xpDataQueryBrowsed
 
  RETURN lBrowsed.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDataQueryString) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getDataQueryString Procedure 
FUNCTION getDataQueryString RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns a string used to prepare the RowObject query  
    Notes:  This class treats this as a private property to store an
            override of default query from all default querytables.
          - Should only be accessed at runtime by other get functions.
            - getQueryStringDefault - first option 
            - getQueryTables        - second option after a valid query handle
          - Is intended to define and store base tables, join expressions and 
            sort and not for other query expressions, sinced a DataView  in
            principle has access to all records in the business entity. 
            The QueryString is used at runtime and can be manipulated with
            assignQueryString in initializeObject for filtering at start up.                                 
         Data class (does not have override, but has different use ) 
          - Used directly in the query for the RowObject. Typically not
            a design time property. 
          - Is manipulated for local sort, but currently not filtered. 
------------------------------------------------------------------------------*/  
  DEFINE VARIABLE cQueryString AS CHARACTER NO-UNDO.
  {get DataQueryString cQueryString}.
  RETURN cQueryString.    

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDataTable) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getDataTable Procedure 
FUNCTION getDataTable RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose: Return the name of the temp-table  
    Notes: As of current just return hardcoded value since the temp-table 
           may not be defined   
------------------------------------------------------------------------------*/

  RETURN "RowObject". 

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getFetchOnOpen) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getFetchOnOpen Procedure 
FUNCTION getFetchOnOpen RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose: Return what/whether a fetch should occur when the db query is opened
    Notes: A blank value means don't fetch on open, any other value is just 
           being run as fetch + <property value>
             
Note Date: 2002/4/11    
           No xp defined for query class (currently also to handle default)
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cFetchOnOpen  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cAsDivision   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lQueryCont    AS LOGICAL    NO-UNDO.
  
  &SCOPED-DEFINE xpFetchOnOpen 
  {get FetchOnOpen cFetchOnOpen}.
  &UNDEFINE xpFetchOnOpen 
     
  IF cFetchOnOpen = ? THEN
    cFetchOnOpen = 'First':U.
 
  RETURN cFetchOnOpen.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getFillBatchOnRepos) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getFillBatchOnRepos Procedure 
FUNCTION getFillBatchOnRepos RETURNS LOGICAL
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns (LOGICAL) a flag indicating whether fetchRowIdent should
            retrieve enough rows to fill a batch of records when repositioning
            to the end or near the end of the dataset where an entire batch
            wouldn't be retrieved.
   Params:  <none>
------------------------------------------------------------------------------*/

  DEFINE VARIABLE lFillBatch AS LOGICAL NO-UNDO.
  {get fillBatchOnRepos lFillBatch}.
  RETURN lFillBatch.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getFilterActive) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getFilterActive Procedure 
FUNCTION getFilterActive RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose: Return whether a filter is active.  
    Notes: It may be set to true explicitly or use the Querycolumns   
------------------------------------------------------------------------------*/
  DEFINE VARIABLE lFilterActive  AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cQueryColumns  AS CHARACTER  NO-UNDO.
  
  &SCOPED-DEFINE xpFilterActive 
  {get FilterActive lFilterActive}.
  &UNDEFINE xpFilterActive 
  {get QueryColumns cQueryColumns}.
 
  RETURN lfilterActive AND cQuerycolumns <> '':U.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getFilterAvailable) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getFilterAvailable Procedure 
FUNCTION getFilterAvailable RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose: Return whether a filter is available. 
    Notes: 
------------------------------------------------------------------------------*/
  DEFINE VARIABLE lFilterAvailable  AS LOGICAL    NO-UNDO.
  
  &SCOPED-DEFINE xpFilterAvailable 
  {get FilterAvailable lFilterAvailable}.
  &UNDEFINE xpFilterAvailable 
  
  RETURN lFilterAvailable.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getFilterSource) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getFilterSource Procedure 
FUNCTION getFilterSource RETURNS HANDLE
  ( ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the handle of the object's FilterSource.
   Params:  <none>
------------------------------------------------------------------------------*/

  DEFINE VARIABLE hSource AS HANDLE NO-UNDO.
  {get FilterSource hSource}.
  RETURN hSource.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getFilterWindow) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getFilterWindow Procedure 
FUNCTION getFilterWindow RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the Partition name which this object 
            will run on, if any.
   Params:  none
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cFilterWindow AS CHARACTER NO-UNDO.
  {get FilterWindow cFilterWindow}.
  RETURN cFilterWindow.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getFirstRowNum) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getFirstRowNum Procedure 
FUNCTION getFirstRowNum RETURNS INTEGER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the temp-table row number of the first row.
   Params:  <none>
------------------------------------------------------------------------------*/

  DEFINE VARIABLE iRow AS INTEGER NO-UNDO.
  {get FirstRowNum iRow}.
  RETURN iRow.

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
             - Overrides dataview as it always is stored as prop 
------------------------------------------------------------------------------*/
DEFINE VARIABLE cFields AS CHARACTER  NO-UNDO.

  &SCOPED-DEFINE xpForeignFields
  {get ForeignFields cFields}.
  &UNDEFINE xpForeignFields
  
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
  Purpose:     Retrieves the values of the most recently received ForeignField
               values received by dataAvailable.  The values are character
               strings formatted according to the field format specification and
               they are separated by the {&adm-tabledelimiter} character.

  Parameters:  <none>
  
  Notes:
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cForeignValues AS CHARACTER NO-UNDO.
  {get ForeignValues cForeignValues}.
  RETURN cForeignValues.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getIgnoreTreeViewFilter) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getIgnoreTreeViewFilter Procedure 
FUNCTION getIgnoreTreeViewFilter RETURNS LOGICAL
  ( ) :
/*------------------------------------------------------------------------------
  Purpose: Decides whether general filter criteria applied to a TreeView should 
           be applied to the data object. 
           A TRUE value overrides default behaviour and ignores the criteria. 
    Notes: This property supports the behaviour that previously was achieved by 
           adding an empty NoTreeFilter procedure stub to a static SDO. 
         - Data sources on TreeView nodes do not support the notion of 
           instances and instance attributes, so the property must typically be 
           defined at the master level.
         - Overridable in order to support the old internal-entries hack          
------------------------------------------------------------------------------*/
  DEFINE VARIABLE lIgnore AS LOGICAL     NO-UNDO.
  
  &SCOPED-DEFINE xpIgnoreTreeViewFilter
  {get IgnoreTreeViewFilter lIgnore}.
  &UNDEFINE xpIgnoreTreeViewFilter
  
  /* default to ? currently in order to support the old internal-entries hack */ 
  IF lIgnore = ? THEN
  DO:
    lIgnore =  LOOKUP("noTreeFilter":U,TARGET-PROCEDURE:INTERNAL-ENTRIES) > 0.
    /* store it for next get */
    {set IgnoreTreeViewFilter lIgnore}.
  END.

  RETURN lIgnore.    

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
   Params:  none                                    
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cKeyFields     AS CHAR  NO-UNDO.
  
  /* define the xp temporarily so we can go directly to the property buffer */
  &SCOPED-DEFINE xpKeyFields 
  {get KeyFields cKeyFields}.
  &UNDEFINE xpKeyFields 
   
  RETURN cKeyFields.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getKeyTableId) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getKeyTableId Procedure 
FUNCTION getKeyTableId RETURNS CHARACTER
    ( ) :
/*------------------------------------------------------------------------------
  Purpose: Get the KeyTable identifier (Dynamics FiveLetterAcronym) property
    Notes: This is a unique Table identifier across databases for all tables 
           used by the framework  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cKeyTableID AS CHARACTER  NO-UNDO.
  
  &SCOPED-DEFINE xpKeyTableId
  {get KeyTableId cKeyTableId}.
  &UNDEFINE xpKeyTableId

  RETURN cKeyTableID.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getLargeColumns) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getLargeColumns Procedure 
FUNCTION getLargeColumns RETURNS CHARACTER
  ( ) :
/*------------------------------------------------------------------------------
    Purpose:  Returns a comma-delimited list of the large data-type 
              columnNames for the SmartDataObject. 
  Parameters:  
       Notes: This is a runtime property that on the first call will
              be resolved from DataColumns and RowObject definition. 
           -  Very expensive if requested before the first data request as
              it then may resolve each column's data-type on the server.
             (This should not be necessary though)     
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cLargeColumns AS CHARACTER  NO-UNDO.

  &SCOPED-DEFINE xpLargeColumns
  {get LargeColumns cLargeColumns}.
  &UNDEFINE xpLargeColumns
  
  /* if unknown then resolve this from rowobject and datacolumn data-types */
  IF cLargeColumns = ? THEN
  DO:
    {fn updateLargeColumns}.
    
    &SCOPED-DEFINE xpLargeColumns
    {get LargeColumns cLargeColumns}.
    &UNDEFINE xpLargeColumns
    
  END.

  RETURN cLargeColumns.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getLastRowNum) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getLastRowNum Procedure 
FUNCTION getLastRowNum RETURNS INTEGER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the temp-table row number of the last row.
   Params:  <none>
------------------------------------------------------------------------------*/

  DEFINE VARIABLE iRow AS INTEGER NO-UNDO.
  {get LastRowNum iRow}.
  RETURN iRow.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getNavigationSource) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getNavigationSource Procedure 
FUNCTION getNavigationSource RETURNS CHAR
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:     Returns the handle of the query object's Navigation source.
  
  Parameters:  <none>
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cSource AS CHARACTER NO-UNDO.
  {get NavigationSource cSource}.
  RETURN cSource. 

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getNavigationSourceEvents) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getNavigationSourceEvents Procedure 
FUNCTION getNavigationSourceEvents RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:     Returns a comma-separated list of the events this object 
               needs to subscribe to in its NavigationSource.
  Parameters:  <none>
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cEvents AS CHARACTER NO-UNDO.
  {get NavigationSourceEvents cEvents}.
  RETURN cEvents.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getOpenOnInit) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getOpenOnInit Procedure 
FUNCTION getOpenOnInit RETURNS LOGICAL
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:    Returns TRUE if the query should be opened automatically when 
              the object is initialized.

  Parameters: <none>
------------------------------------------------------------------------------*/
  DEFINE VARIABLE lOpen AS LOGICAL NO-UNDO.
  {get OpenOnInit lOpen}.
  RETURN lOpen.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getPositionSource) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getPositionSource Procedure 
FUNCTION getPositionSource RETURNS HANDLE
  (  ) :
/*------------------------------------------------------------------------------
  Purpose: Return the DataView that positions this 
    Notes: The positioning Dataview is a child of this and the current record
           of it can uniquely identify a record in this. 
         - This is currently defined through an SDF target of this object.
           If this object has an SDF target then the viewer container's 
           datasource is indirectly the position source of this.
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hTarget         AS HANDLE     NO-UNDO.
  DEFINE VARIABLE iTarget         AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cTargetType     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cTargets        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hContainer      AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hPositionSource AS HANDLE     NO-UNDO.

  {get DataTarget cTargets}.
  IF cTargets <> '' THEN
  DO iTarget = 1 TO NUM-ENTRIES(cTargets):
    hTarget =  WIDGET-HANDLE(ENTRY(iTarget,cTargets)).
    {get ObjectType cTargetType hTarget}.
    IF cTargetType = 'SmartDataField':U THEN
    DO:
      {get ContainerSource hContainer hTarget}.
      IF VALID-HANDLE(hContainer) THEN
        {get DataSource hPositionSource hContainer}.
      /* return in any case (invalid container or container source is an
         exception )*/
      RETURN hPositionSource.
    END. /* SDF */
  END. /* iTarget loop through cTargets */

  RETURN ?.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getPrimarySDOSource) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getPrimarySDOSource Procedure 
FUNCTION getPrimarySDOSource RETURNS HANDLE
  ( ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the handle of the object's PrimarySDOSource.
   Params:  <none>
------------------------------------------------------------------------------*/

  DEFINE VARIABLE hSource AS HANDLE NO-UNDO.
  {get PrimarySDOSource hSource}.
  RETURN hSource.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getPromptColumns) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getPromptColumns Procedure 
FUNCTION getPromptColumns RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  Return a list of field values when prompting for a delete action
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cPromptColumns AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iCol           AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cColumn        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDataTable     AS CHARACTER  NO-UNDO.

  &SCOPED-DEFINE xpPromptColumns
  {get PromptColumns cPromptColumns}.
  &UNDEFINE xpPromptColumns
  IF cPromptColumns = '':U THEN
    cPromptColumns = (IF VALID-HANDLE(gshSessionManager) THEN
                       '(ALL)':U
                     ELSE
                       '(NONE)').
 
  RETURN cPromptColumns.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getPromptOnDelete) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getPromptOnDelete Procedure 
FUNCTION getPromptOnDelete RETURNS LOGICAL
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  Is the user to be prompted before a delete action executes?
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE lPrompt AS LOGICAL    NO-UNDO.
  {get PromptOnDelete lPrompt}.
  RETURN lPrompt.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getQueryColumns) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getQueryColumns Procedure 
FUNCTION getQueryColumns RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    DEFINE VARIABLE cQueryColumns AS CHARACTER NO-UNDO.
    {get QueryColumns cQueryColumns}.
    RETURN cQueryColumns.
    
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getQueryHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getQueryHandle Procedure 
FUNCTION getQueryHandle RETURNS HANDLE
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose: Interface for generic query processing  
    Notes: Used by generic query processing that originally was implemented 
           in the query class and worked on database queries and now have been 
           moved up to the dataview class to also handle temp-table and 
           prodataset queries.              
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hQuery AS HANDLE     NO-UNDO.
  {get DataHandle hQuery}.
  RETURN hQuery. 

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getQueryPosition) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getQueryPosition Procedure 
FUNCTION getQueryPosition RETURNS CHARACTER
  (   ) :
/*------------------------------------------------------------------------------
  Purpose:     Returns the QueryPosition property.

  Parameters:  <none>
  
  Notes:       Valid return values are:
               FirstRecord, LastRecord, NotFirstOrLast,OnlyRecord 
               NoRecordAvailable and NoRecordAvailableExt
             - Because the set publishes an event, this property is 
               overridable (no xp defined globally)
 -----------------------------------------------------------------------------*/
  DEFINE VARIABLE cPosition   AS CHARACTER NO-UNDO.
  DEFINE VARIABLE hDataSource AS HANDLE    NO-UNDO.
  DEFINE VARIABLE cParentPos  AS CHARACTER NO-UNDO.
  DEFINE VARIABLE lParentOk   AS LOGICAL   NO-UNDO.
  
  &SCOPED-DEFINE xpQueryPosition
  {get QueryPosition cPosition}.
  &UNDEFINE xpQueryPosition
  
  /* If Queryposition is not set yet then no record is available (yet)
     (We trust that an open with positioning runs updateQueryPosition) */ 
  if cPosition = '' then  
  do:
    {get DataSource hDataSource}.
    if valid-handle(hDataSource) then
    do: 
      {get QueryObject lParentOk hDataSource}.
      if lParentOk then 
      do:
        {get QueryPosition cParentPos hDataSource}.
        if cParentPos begins "NoRecordAvailable":U then        
          cPosition = "NoRecordAvailableExt":U.
      end.
    end.  
    
    if cPosition = '' then  
      cPosition = "NoRecordAvailable":U.  
  end.  
  
  RETURN cPosition.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getQuerySort) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getQuerySort Procedure 
FUNCTION getQuerySort RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose: Return the sort phrase.   
    Notes: Does NOT return the first BY keyword.  
    Data class    
           If a query is under work in the QueryString property this will 
           return this BY-phrase, otherwise it will return the BY-phrase in the 
           current or design query. 
           This should make this property safe to use in qbf objects that 
           may or may not have done query manipulation and may or may not 
           have opened the query. 
           It can also be used to retrieve the BY phrase before a setQueryWhere 
           (which overrides setQuerySort) and reset it after. 
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cQueryText AS CHAR NO-UNDO.
  DEFINE VARIABLE cSort      AS CHARACTER  NO-UNDO.
  /* If a query is under work, use that. */  
  {get QueryString cQueryText}.  
  cSort = {fnarg sortExpression cQueryText}.
  IF cSort > '':U THEN
    /* remove the first BY keyword */
    RETURN LEFT-TRIM(SUBSTR(cSort,3)).
  ELSE 
    RETURN "":U. 

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getQuerySortDefault) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getQuerySortDefault Procedure 
FUNCTION getQuerySortDefault RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose: Return the default sort phrase.   
    Notes: Does NOT return the first BY keyword.  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cQuery AS CHAR NO-UNDO.
  DEFINE VARIABLE cSort  AS CHARACTER  NO-UNDO.
  /* If a query is under work, use that. */  
  {get QueryStringDefault cQuery}.  
  cSort = {fnarg sortExpression cQuery}.
  IF cSort > '':U THEN
    /* remove the first BY keyword */
    RETURN LEFT-TRIM(SUBSTR(cSort,3)).
  ELSE 
    RETURN "":U. 

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getQueryString) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getQueryString Procedure 
FUNCTION getQueryString RETURNS CHARACTER
  ( ) :
/*------------------------------------------------------------------------------
  Purpose:     Returns the QueryString attribute used as working storage for 
               all query manipulation methods.
  Parameters:  <none>
  Notes:     - The method will always return a whereclause 
               If the QueryString property has not been set it will use 
               the current where clause - QueryWhere.
               If there's no current use the design where clause - OpenQuery. 
             - The openQuery will call prepareQuery with this property.     
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cQueryString AS CHARACTER NO-UNDO.
  {get QueryString cQueryString}.
  RETURN cQueryString. 
  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getRebuildOnRepos) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getRebuildOnRepos Procedure 
FUNCTION getRebuildOnRepos RETURNS LOGICAL
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the flag indicating whether the RowObject temp-table
            should be rebuilt if a fetchLast or other reposition is done
            which is outside the bounds of the current dataset.
   Params:  <none>
------------------------------------------------------------------------------*/

  DEFINE VARIABLE lRebuild AS LOGICAL NO-UNDO.
  {get RebuildOnRepos lRebuild}.
  RETURN lRebuild.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getRowObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getRowObject Procedure 
FUNCTION getRowObject RETURNS HANDLE
  ( ) :
/*------------------------------------------------------------------------------
  Purpose:     Returns the handle of the RowObject Temp-Table buffer.
  
  Parameters:  <none>
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hRowObject AS HANDLE NO-UNDO.  
  {get RowObject hRowObject}.
  RETURN hRowObject.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getRowsToBatch) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getRowsToBatch Procedure 
FUNCTION getRowsToBatch RETURNS INTEGER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the number of rows to be transferred from the database
            query into the RowObject temp-table at a time.
   Params:  <none>
    Notes:  set to 200 by default. 0 = ALL 
------------------------------------------------------------------------------*/
  DEFINE VARIABLE iRows AS INTEGER NO-UNDO.
  {get RowsToBatch iRows}.
  RETURN iRows.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getTables) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getTables Procedure 
FUNCTION getTables RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
   Purpose: The Tables defines the object's view of data.    
     Notes: The names in the list references to the tables as defined in the
            object and referenced in the query, so each entry must be unique. 
  DataView - The tables may include outer join tables currently not added to
             the physical query due to 4GL limitations that makes get-last
             and reposition unusable.   
           - Should only be accessed by getViewTables at runtime.           
  Dbaware (does not overrride, but uses tables differently)    
          - The names may be buffer names that differ from the actual physical 
            names.
          - The physical names is defined in the corresponding PhysicalTables 
            property.  
          - Qualified with database name if the query is defined with dbname.
          - From 9.1B this property is a design time property while it earlier 
            was resolved from the actual query.           
          - Several other properties have table delimiters and are depending of 
            the design time order of this property.              
          - The web2/webprop.i UNDEFINEs xpTables since it need to override 
            getTables()                    
------------------------------------------------------------------------------*/
 DEFINE VARIABLE cTables AS CHARACTER  NO-UNDO.
 {get Tables cTables}.
 RETURN cTables.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getToggleDataTargets) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getToggleDataTargets Procedure 
FUNCTION getToggleDataTargets RETURNS LOGICAL
  (  ) :
/*------------------------------------------------------------------------------
  Purpose: Returns true if dataTargets should be toggled on/of in LinkState
           based on the passed 'active' or 'inactive' parameter 
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE ltoggle AS LOGICAL    NO-UNDO.
  {get toggleDataTargets lToggle}.

  RETURN lToggle. 

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getToggleOuterJoin) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getToggleOuterJoin Procedure 
FUNCTION getToggleOuterJoin RETURNS LOGICAL
  (   ) :
/*------------------------------------------------------------------------------
  Purpose: Override in case someone relied on the old behavior that kept 
           outerjoin with criteria.  
    Notes: There is no set 
           This is implemented purely to allow someone that had worked around
           the old behavior in the UI (or maybe have trained their users 
           to spot the differences in the UI).  
         - WARNING: The data object (dataview or SDO) is a single view and 
           setting this to true basically makes the query wrong in that you'd 
           still get records with no children, while the filter would remove 
           records with children that did not match the criteria.
------------------------------------------------------------------------------*/

  RETURN TRUE. 

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getTransferChildrenForAll) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getTransferChildrenForAll Procedure 
FUNCTION getTransferChildrenForAll RETURNS LOGICAL
  (   ) :
/*------------------------------------------------------------------------------
  Purpose: This flag decides whether children for all records (of the batch) is 
           to be transferred from the database. 
    Notes: Currently only supported for read event handlers during a fetch. 
           The child SDO is only left with temp-table records for one parent 
           when the fetch*batch is finished.   
------------------------------------------------------------------------------*/
  DEFINE VARIABLE lTransferChildrenForAll AS LOGICAL    NO-UNDO.
  {get TransferChildrenForAll lTransferChildrenForAll}.
  RETURN lTransferChildrenForAll.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getUpdatableColumns) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getUpdatableColumns Procedure 
FUNCTION getUpdatableColumns RETURNS CHARACTER
  (   ) :
/*------------------------------------------------------------------------------
  Purpose:     Returns a comma delimited list of the Updatable Columns for the
               DataView.
  Parameters:  <none>
  Notes:        
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cColumns AS CHARACTER  NO-UNDO.
  
  {get UpdatableColumns cColumns}.
  RETURN cColumns.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getUpdatableWhenNew) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getUpdatableWhenNew Procedure 
FUNCTION getUpdatableWhenNew RETURNS CHARACTER
  (   ) :
/*------------------------------------------------------------------------------
  Purpose: Return a list of fields that only are updatable when new.
    Notes: The datavisual class EnabledWhenNew uses this as default.
         - submitRow (-> submitValidate data.p) checks that no changes are saved
           for these columns unless the record is new. 
         - There is no particular behavior for these columns unless they 
           also are UpdatableColumns.    
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cUpdatableWhenNew AS CHARACTER   NO-UNDO.
  {get UpdatableWhenNew cUpdatableWhenNew}.
  RETURN cUpdatableWhenNew.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getUpdateSource) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getUpdateSource Procedure 
FUNCTION getUpdateSource RETURNS CHARACTER
  ( ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the handle of the object's UpdateSource.
   Params:  <none>
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cSource AS CHARACTER NO-UNDO.
  {get UpdateSource cSource}.
  RETURN cSource.

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
  RETURN REPLACE(DYNAMIC-FUNCTION("indexInformation":U IN TARGET-PROCEDURE,
                           "WORD":U,
                           NO,
                           ?),
          CHR(1),",":U).
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-indexInformation) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION indexInformation Procedure 
FUNCTION indexInformation RETURNS CHARACTER
   (pcQuery       AS CHAR,
    plUseTableSep AS LOG,
    pcIndexInfo   AS CHAR):
/*------------------------------------------------------------------------------
   Purpose: Return index Information for buffers in the query.
            Each index is separated with chr(1).
            The information can be specified to either be returned with  
            fieldnames qualifed with table (and db) or to use chr(2) as table 
            separator.  
                        
Parameters: pcQuery - What information? 
                - 'All'             All indexed fields
                - 'Standard' or ''  All indexed fields excluding word indexes    
                - 'Word'            Word Indexed 
                - 'Unique'          Unique indexes 
                - 'NonUnique'       Non Unique indexes 
                - 'Primary'         Primary index           
                
                - 'Info'            All info (meaningless if pcIndexInfo <> ?) 
             
             All the commands can be specified for one specific buffer by 
             specifying the buffer number in parenthesis.
             Example: 'Info(1)' returns all info for first buffer  
           
           plUseTableSep - Use table separator.  
           
                - Yes   Use table separator 
                - No    Don't use table separator 
                       (if pcIndexinfo = ? fieldnames will be qualifed
                        otherwise they will remain as in pcIndexInfo)
          
          pcIndexInfo - Query or previously retrieved info. Enables the 
                         function to be used with no database connection.    
                - ? use query - if plUseTableSep = no the field will be 
                                returned qualified.     
                -  Index info in EXACT SAME FORMAT as returned from this 
                   function earlier with indexInformation('info',yes,?).
                   
                   See Notes below for delimiters. 
     Notes: Returned delimiters
            - qualified     - chr(1) as index separator 
            - non-qualifed  - chr(1) as index separator 
                              chr(2) as table separator        
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hQuery       AS HANDLE NO-UNDO.
  DEFINE VARIABLE hBuff        AS HANDLE NO-UNDO.
  DEFINE VARIABLE iBuff        AS INT    NO-UNDO.
  DEFINE VARIABLE iIdx         AS INT    NO-UNDO.
  DEFINE VARIABLE iField       AS INT    NO-UNDO.
  DEFINE VARIABLE cInfo        AS CHAR   NO-UNDO.
  DEFINE VARIABLE cFieldInfo   AS CHAR   NO-UNDO.
  DEFINE VARIABLE cIndexInfo   AS CHAR   NO-UNDO.
  DEFINE VARIABLE cIndexString AS CHAR   NO-UNDO.
  DEFINE VARIABLE lFound       AS LOG    NO-UNDO.
  DEFINE VARIABLE lFirstIdx    AS LOG    NO-UNDO.
  DEFINE VARIABLE cTblDlm      AS CHAR   NO-UNDO.
  DEFINE VARIABLE cIdxDlm      AS CHAR   NO-UNDO.
  DEFINE VARIABLE cField       AS CHAR   NO-UNDO.
  DEFINE VARIABLE cFieldList   AS CHAR   NO-UNDO.
  DEFINE VARIABLE iFirstEntry  AS INT    NO-UNDO.
  DEFINE VARIABLE iLastEntry   AS INT    NO-UNDO.
  DEFINE VARIABLE lUseDBQual   AS LOGICAL    NO-UNDO.
  
  /* We only use query if no previouisly processed info is passed */
  IF pcIndexInfo = ? THEN
  DO:
    {get QueryHandle hQuery}.
    IF NOT VALID-HANDLE(hQuery) THEN
      RETURN ?.
  END.
  
  ASSIGN
    cTblDlm     = CHR(2) 
    cIdxDlm     = CHR(1).

  /* request for single buffer */
  IF INDEX(pcQuery,"(":U) > 0 THEN
    ASSIGN
      /* get number inside parenthesis  */
      iFirstEntry = INT(RIGHT-TRIM(ENTRY(2,pcQuery,"(":U),")":U))
      pcQuery     = ENTRY(1,pcQuery,"(":U)
      iLastEntry  = iFirstEntry.
  ELSE 
    ASSIGN 
      iFirstEntry = 1
      iLastEntry  = IF VALID-HANDLE(hQuery)
                    THEN hQuery:NUM-BUFFERS
                    ELSE NUM-ENTRIES(pcIndexInfo,cTblDlm).
  /* If no table separator find qualifier rule */   
  IF NOT plUseTableSep THEN
    {get UseDBQualifier lUseDBQual}.
 
  DO iBuff = iFirstEntry TO iLastEntry:
    IF pcIndexInfo <> ? THEN
      cIndexString = ENTRY(iBuff,pcIndexInfo,cTblDlm).         
    ELSE
      hBuff  = hQuery:GET-BUFFER-HANDLE(iBuff).
    
    ASSIGN
      iIdx      = 0
      lFirstIdx = TRUE.
 
    IndexBlock:
    DO WHILE TRUE:
      ASSIGN
        iIdx         = iIdx + 1
        cIndexInfo   = IF pcIndexInfo = ? 
                       THEN hBuff:INDEX-INFORMATION(iIdx)
                          /* set to unknown when all entries 
                             have been parsed */
                       ELSE IF NUM-ENTRIES(cIndexString,cIdxDlm) >= iIdx  
                            THEN ENTRY(iIdx,cIndexString,cIdxDlm)        
                            ELSE ?.
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
                  "Function indexInformation() does not understand"
                  "parameter '" + pcQuery "'"
                    
          VIEW-AS ALERT-BOX ERROR.
          RETURN ?.
        END.
      END CASE. /* pcQuery */
        
      /* If pcQuery includes this index then .... */ 
      IF lFound THEN
      DO:
        cFieldList = "":U.
        /* if 'info' and use table separator we have all we need.
           Otherwise we loop through each field and refine the data */ 
        IF pcQuery <> "info":U OR NOT plUseTableSep THEN
        DO iField = 5 TO NUM-ENTRIES(cIndexInfo) BY 2:

          /* If no table separator and the buffer is valid 
             we qualify the field */ 
          cField = (IF NOT plUseTableSep AND VALID-HANDLE(hBuff)
                    THEN ((IF lUseDBQual THEN hBuff:DBNAME + ".":U
                                        ELSE "":U)
                          + hBuff:NAME + ".":U)
                    ELSE "":U)
                  + ENTRY(iField,cIndexInfo). 
          /* if 'info' just replace the field with the qualifed one */
          IF pcQuery = "Info":U THEN
            ENTRY(iField,cIndexInfo) = cField.

          ELSE 
            cFieldList = cFieldList 
                         + (IF cFieldList = "":U THEN "":U ELSE ",":U)
                         + cField.
        END.
        ASSIGN
          cInfo = cInfo 
                   /* don't add index delimiter for first index after 
                      the table separator or when empty */ 
                + (IF (plUseTableSep AND lFirstIdx) 
                   OR  cInfo = '':U 
                   THEN '':U 
                   ELSE cIdxDlm)
                   /* if 'info' just apppend all index info  */ 
                + (IF pcQuery = "Info":U 
                   THEN cIndexInfo
                   ELSE cFieldList)
          lFirstIdx = FALSE.
      END. /* if lFound */
    END. /* do while true */

    /* If no field qualifier add table delimiter unless this is the last buffer */
    IF plUseTableSep AND iBuff LT iLastEntry THEN 
      cInfo = cInfo + cTblDlm.

  END. /* do ibuff = 1 to num-buffers */  
  RETURN TRIM(cInfo,cTblDlm).
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-insertExpression) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION insertExpression Procedure 
FUNCTION insertExpression RETURNS CHARACTER
  (pcWhere      AS CHAR,   
   pcExpression AS CHAR,     
   pcAndOr      AS CHAR):                         
/*------------------------------------------------------------------------------
 Purpose:     Inserts an expression into ONE buffer's where-clause.
 Parameters:  
      pcWhere      - Complete where clause with or without the FOR keyword,
                     but without any comma before or after.
      pcExpression - New expression OR OF phrase (Existing OF phrase is replaced)
      pcAndOr      - Specifies what operator is used to add the new expression 
                     to existing ones.
                     - AND (default) 
                     - OR         
 Notes:     - The new expression is embedded in parenthesis, but no parentheses
              are placed around the existing one.  
            - Lock keywords must be unabbreviated or without -lock (i.e. SHARE
              or EXCLUSIVE.)   
            - Any keyword in comments may cause problems.              
------------------------------------------------------------------------------*/  
  DEFINE VARIABLE cTable        AS CHAR NO-UNDO.  
  DEFINE VARIABLE cRelTable     AS CHAR NO-UNDO.  
  DEFINE VARIABLE cJoinTable    AS CHAR NO-UNDO.  
  DEFINE VARIABLE cWhereOrAnd   AS CHAR NO-UNDO.  
  DEFINE VARIABLE iTblPos       AS INT  NO-UNDO.
  DEFINE VARIABLE iWherePos     AS INT  NO-UNDO.
  DEFINE VARIABLE lWhere        AS LOG  NO-UNDO.
  DEFINE VARIABLE iOfPos        AS INT  NO-UNDO.
  DEFINE VARIABLE iRelTblPos    AS INT  NO-UNDO.  
  DEFINE VARIABLE iInsertPos    AS INT  NO-UNDO.    
  
  DEFINE VARIABLE iUseIdxPos    AS INT  NO-UNDO.        
  DEFINE VARIABLE iOuterPos     AS INT  NO-UNDO.        
  DEFINE VARIABLE iLockPos      AS INT  NO-UNDO.      
  
  DEFINE VARIABLE iByPos        AS INT  NO-UNDO.        
  DEFINE VARIABLE iIdxRePos     AS INT  NO-UNDO.        
  DEFINE VARIABLE cTmpQuery     AS CHARACTER   NO-UNDO.

  /* Get rid of potential line break characters (query builder -> repository)*/   
  assign
    pcWhere    = REPLACE(pcWhere,CHR(10),' ':U)
    /* We mask quoted strings to ensure the following table and keyword lookup
       only finds stuff in the expression(in lack of parsing) */ 
    cTmpQuery  = DYNAMIC-FUNCTION("maskQuotes":U IN TARGET-PROCEDURE,
                                  pcWhere,'':U)
    cTable       = {fnarg whereClauseBuffer cTmpQuery}
    iTblPos     = INDEX(cTmpQuery,cTable) + LENGTH(cTable,"CHARACTER":U)    
    iWherePos   = INDEX(cTmpQuery," WHERE ":U) + 6    
    iByPos      = INDEX(cTmpQuery," BY ":U)    
    iUseIdxPos  = INDEX(cTmpQuery," USE-INDEX ":U)    
    iIdxRePos   = INDEX(cTmpQuery + " ":U," INDEXED-REPOSITION ":U)    
    iOuterPos   = INDEX(cTmpQuery + " ":U," OUTER-JOIN ":U)     
    iLockPos    = MAX(INDEX(cTmpQuery + " ":U," NO-LOCK ":U),
                      INDEX(cTmpQuery + " ":U," SHARE-LOCK ":U),
                      INDEX(cTmpQuery + " ":U," EXCLUSIVE-LOCK ":U),
                      INDEX(cTmpQuery + " ":U," SHARE ":U),
                      INDEX(cTmpQuery + " ":U," EXCLUSIVE ":U)
                      )    
    iInsertPos  = LENGTH(cTmpQuery) + 1 
                    /* We must insert before the leftmoust keyword,
                       unless the keyword is Before the WHERE keyword */ 
    iInsertPos  = MIN(
                      (IF iLockPos   > iWherePos THEN iLockPos   ELSE iInsertPos),
                      (IF iOuterPos  > iWherePos THEN iOuterPos  ELSE iInsertPos),
                      (IF iUseIdxPos > iWherePos THEN iUseIdxPos ELSE iInsertPos),
                      (IF iIdxRePos  > iWherePos THEN iIdxRePos  ELSE iInsertPos),
                      (IF iByPos     > iWherePos THEN iByPos     ELSE iInsertPos)
                     )                                                        
    lWhere      = INDEX(cTmpQuery," WHERE ":U) > 0 
    cWhereOrAnd = (IF NOT lWhere          THEN " WHERE ":U 
                   ELSE IF pcAndOr = "":U OR pcAndOr = ? THEN " AND ":U 
                   ELSE " ":U + pcAndOr + " ":U) 
    iOfPos      = INDEX(cTmpQuery," OF ":U).
  
  
  IF LEFT-TRIM(pcExpression) BEGINS "OF ":U THEN 
  DO:   
    /* If there is an OF in both the join and existing query we replace the 
       table unless they are the same */      
    IF iOfPos > 0 THEN 
    DO:
      ASSIGN
        /* Find the table in the old join */               
        cRelTable  = ENTRY(1,LEFT-TRIM(SUBSTRING(cTmpQuery,iOfPos + 4))," ":U)      
        /* Find the table in the new join */       
        cJoinTable = SUBSTRING(LEFT-TRIM(pcExpression),3).
      
      IF cJoinTable <> cRelTable THEN
        ASSIGN 
         iRelTblPos = INDEX(cTmpQuery + " ":U," ":U + cRelTable + " ":U) 
                      + 1                            
         SUBSTRING(pcWhere,iRelTblPos,LENGTH(cRelTable)) = cJointable. 
    END. /* if iOfPos > 0 */ 
    ELSE 
      SUBSTRING(pcWhere,iTblPos,0) = " ":U + pcExpression.                                                                
  END. /* if left-trim(pcExpression) BEGINS "OF ":U */
  ELSE             
    SUBSTRING(pcWhere,iInsertPos,0) = cWhereOrAnd 
                                      + "(":U 
                                      + pcExpression 
                                      + ")":U. 
                                            
  RETURN RIGHT-TRIM(pcWhere).
  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-maskQuotes) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION maskQuotes Procedure 
FUNCTION maskQuotes RETURNS CHARACTER
  ( pcString      AS CHAR,
    pcReplaceChar AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose: Utility function that masks all quoted strings in the passed string              
Parameters: pcString = string that might have embedded quoted strings. 
                     must be syntactically correct - paired single or double.  
            pcReplaceChar = single char to insert in quoted positions. 
    Notes: Used in various query manipulation before looking for keywords 
           (a function that could find a particular token outside of the 
            quotes would possibly be "better", but (too?) expensive... )   
------------------------------------------------------------------------------*/
  define variable iChr          as integer   no-undo.
  define variable iState        as integer   no-undo.
  define variable cQuote        as character no-undo.         
  define variable cChr          as character no-undo.   
  
  IF pcReplaceChar = ? OR pcReplaceChar = "":U THEN
    pcReplaceChar = '0':U.
  
  if index(pcString,"'":U) > 0 or index(pcString,'"':U) > 0 then 
  do:
    do iChr = 1 to length(pcString):
      cChr = substring(pcString,iChr,1).
      case iState:
        when 0 then 
        do:
          if cChr = '"':U or cChr = "'":U then  
            assign      
              iState = 1
              cQuote = cChr.
        end.  
        when 1 then /* start quote is found */
        do:
          if cChr = '~~':U then iState = 2. /* ignore next */
          if cChr = cQuote then iState = 3. /* possible end */
        end.  
        when 2 then /* prev char was tilde */ 
          iState = 1.
        when 3 then /* possible end quote was found */ 
        do:
          /* if another quote then we're still in quoted string */
          if cChr = cQuote then 
            iState = 1.
          else 
            iState = 0.    
        end.
      end case.        
      if iState > 0 then 
        substring(pcString,iChr,1) = pcReplaceChar.
    end.    
  end.
  RETURN pcString.   

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-newQuerySort) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION newQuerySort Procedure 
FUNCTION newQuerySort RETURNS CHARACTER
  ( pcQuery       AS CHAR,
    pcSort        AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose   :  Insert sort criteria (BY phrase) in a QueryString.
  Parameters:
    pcQuery    - Query to add sort to (current sort will be replaced)        
    pcSort     - new sort expression.
                 - [BY ] column [DESCENDING | TOGGLE ] [ BY ... ]  
                 - TOGGLE sort option specifies that the column should be 
                   sorted opposite of the current sort. The option can be 
                   specified for any column in the sort.      
                                      
 Notes: Unqualified columns are always resolved as db fields (searching 
        in query order) also when plDBColumns is false.
     -  We check each entry in the new sort criteria for several reasons: 
       - Avoid appserver hit if the specified sort already is set 
         (The browser bombards the SDO with sort options at start up..) 
       - Support of 'RowObject.' qualifications, so we need to rename 
         accordingly
       - The TOGGLE option requires check for current sort option and          
         that all columns are in same order   
------------------------------------------------------------------------------*/
 DEFINE VARIABLE cNewColumn AS CHARACTER EXTENT {&MaxBreaks} NO-UNDO.
 DEFINE VARIABLE cOldColumn AS CHARACTER EXTENT {&MaxBreaks} NO-UNDO.
 DEFINE VARIABLE cNewOption AS CHARACTER EXTENT {&MaxBreaks} NO-UNDO.
 DEFINE VARIABLE cOldOption AS CHARACTER EXTENT {&MaxBreaks} NO-UNDO.

 DEFINE VARIABLE cColumn           AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cOption           AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cSort             AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE iNum              AS INTEGER    NO-UNDO.
 DEFINE VARIABLE iByPos            AS INTEGER    NO-UNDO.
 
 DEFINE VARIABLE iCase             AS INTEGER    NO-UNDO.
 DEFINE VARIABLE iNumWords         AS INTEGER    NO-UNDO.
 DEFINE VARIABLE cSortEntry        AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cLastentry        AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE lCommaIsSep       AS LOGICAL    NO-UNDO.

 DEFINE VARIABLE iNewEntries       AS INTEGER    NO-UNDO.
 DEFINE VARIABLE iOldEntries       AS INTEGER    NO-UNDO.
 DEFINE VARIABLE cOldSort          AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cNewSort          AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE lDiffColumns      AS LOGICAL    NO-UNDO.
 DEFINE VARIABLE lToggled          AS LOGICAL    NO-UNDO.
 DEFINE VARIABLE cDataColumns      AS CHARACTER  NO-UNDO.
 
 IF pcQuery = '':U THEN
   RETURN '':U.

 ASSIGN           /* remove first BY if passed */
   pcSort       = IF LEFT-TRIM(pcSort) BEGINS "BY ":U 
                  THEN TRIM(SUBSTRING(LEFT-TRIM(pcSort),3)) 
                  ELSE TRIM(pcSort)
   cOldSort     = {fnarg sortExpression pcQuery}
   cOldSort     = IF cOldSort BEGINS "BY ":U 
                  THEN SUBSTRING(cOldSort,4) 
                  ELSE cOldSort.
 /* Backwards support for the accidental support of comma separated list.  
     In 10.0A the logic used to replace ' BY ' with commas to simplify 
     the processing. This accidentally allowed "support" for direct pass of a 
     comma separated list of sort entries... The use of comma did however mess 
     up when sort was specified with SUBSTR(field,1,199) to prevent index limit
     blowup. 
     NOTE: - spaces in comma separated list is only allowed for sortoption  */ 

 IF NUM-ENTRIES(pcSort) > 1 AND INDEX(pcSort,' BY ':U) = 0 THEN
 DO:
   {get DataColumns cDataColumns}.
   lCommaIsSep = TRUE.
   DO iNum = 1 TO NUM-ENTRIES(pcSort):
     ASSIGN
       cSortEntry  = ENTRY(iNum,pcSort)
       cColumn     = ENTRY(1,cSortEntry,' ')
       cColumn     = {fnarg resolveColumn cColumn}.
     IF LOOKUP(cColumn,cDataColumns) > 0 THEN
     DO:
       lCommaIsSep = FALSE. 
       LEAVE.
     END.
   END.

   IF lCommaIsSep THEN
     pcSort = REPLACE(pcSort,",":U," BY ":U).
 END.

 IF pcSort = '' AND cOldSort <> '' THEN
   lDiffColumns = TRUE.
 ELSE    /* loop 1 is for new sort loop 2 for old sort */
 DO iCase = 1 TO 2:

   CASE iCase:
     WHEN 1 THEN
       cSort = pcSort.
     WHEN 2 THEN
       cSort = cOldsort.
   END CASE.
   iNum = 0.

   DO WHILE cSort > '' :
     ASSIGN
       iNum    = iNum + 1
       cColumn = ''
       iByPos  = INDEX(cSort,' BY ').
     
     IF iCase = 2 AND iNum > iNewEntries THEN
     DO:
       lDiffColumns = TRUE.
       LEAVE.
     END.

     IF iByPos > 0 THEN
       ASSIGN
         cSortEntry = TRIM(SUBSTR(cSort,1,iByPos))
         cSort      = SUBSTR(cSort,iByPos + 4).
     ELSE 
       ASSIGN
         cSortEntry = cSort
         cSort      = ''.
     
     ASSIGN
       iNumWords     = NUM-ENTRIES(cSortEntry,' ':U)
       cLastEntry    = ENTRY(iNumWords,cSortEntry,' ':U)
       cOption       = (IF cLastEntry = SUBSTR('DESCENDING':U,1,MAX(4,LENGTH(cLastEntry))) 
                        THEN 'DESCENDING':U
                        ELSE IF cLastEntry = 'TOGGLE':U 
                             THEN cLastEntry
                             ELSE '')
       .

     IF cOption > '' THEN
       ASSIGN
         ENTRY(iNumWords,cSortEntry,' ') = ''
         cColumn = RIGHT-TRIM(cSortEntry).
     ELSE
       cColumn = cSortEntry.

     cColumn = {fnarg resolveColumn cColumn}.

     /* loop 1 is for new sort loop 2 for old sort */
     CASE iCase:
       WHEN 1 THEN
         ASSIGN 
           cNewColumn[iNum] = cColumn
           cNewOption[iNum] = cOption
           iNewEntries      = iNum.
       WHEN 2 THEN
         ASSIGN 
           cOldColumn[iNum] = cColumn
           cOldOption[iNum] = cOption
           iOldEntries      = iNum.
     END CASE.
   END. /* do while cSort > '' */   
 END. /* do icase = 1 to 2 */
 
 IF iOldEntries <> iNewEntries THEN
   lDiffColumns = TRUE.

 DO iNum = 1 TO iNewEntries:
   /* Keep track of whether the old sort criteria is the same as the new.
      This is a requirement for 'toggle' and is also used to avoid 
      server hit if the same sort criteria. (the query stays unchanged also 
      if qualifications does not match and stops resortQuery from resorting)
      We do not need to check this any more if an option already is toggled.*/ 
   IF NOT lDiffColumns AND NOT lToggled THEN
   DO:
     IF cOldColumn[iNum] = '':U THEN
       lDiffColumns = TRUE.
     ELSE IF cNewColumn[iNum] <> cOldColumn[iNum] THEN
       lDiffColumns = TRUE.
   END. /* NOT diff and NOT toggled */
   
   /* If sort option is toggle then swap descending/blank */
   IF cNewOption[iNum] = 'TOGGLE':U THEN
   DO:
     /* if already toggled or lDiffColumns (See above) ignore toggle  */
     IF lToggled OR lDiffColumns THEN
        cNewOption[iNum] = '':U.
     ELSE
     DO:
       IF cOldOption[iNum] = 'DESCENDING':U THEN
         cNewOption[iNum] = '':U.
       ELSE 
         cNewOption[iNum] = 'DESCENDING':U.
            /* We only support one toggling. */
       lToggled = TRUE.
     END.
   END. /* newoption[iNew] = toggle */
        
   /* if not toggled we must also include the sort option in the check
      of different sort (if same and not toggled we don't apply any sort at all) */
   IF NOT lToggled AND cOldOption[iNum] <> cNewOption[iNum] THEN
     lDiffColumns = TRUE.

   cNewSort = TRIM(cNewSort 
                    + " BY ":U 
                    + cNewColumn[iNum]
                    + ' ':U
                    + cNewOption[iNum]).
 END. /* iNum = 1 TO iNewEntries*/
 
 /* Skip sort if Same as old unless a sort option was toggled */ 
 IF lDiffColumns OR lToggled THEN
    pcQuery = DYNAMIC-FUNCTION("replaceQuerySort" IN TARGET-PROCEDURE,
                                pcQuery,
                                cNewSort).    
 RETURN pcQuery. 

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-newQueryString) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION newQueryString Procedure 
FUNCTION newQueryString RETURNS CHARACTER
  (pcColumns     AS CHARACTER,   
   pcValues      AS CHARACTER,    
   pcOperators   AS CHARACTER,
   pcQueryString AS CHARACTER,
   pcAndOr       AS CHARACTER):
/*------------------------------------------------------------------------------   
   Purpose: Returns a new query string to the passed query. 
            The tables in the passed query must match getTables().  
            Adds column/value pairs to the corresponding buffer's where-clause. 
            Each buffer's expression will always be embedded in parenthesis.
   Parameters: 
     pcColumns   - Qualified column names (Comma separated)                    
     pcValues    - corresponding Values (CHR(1) separated)
     pcOperators - Operator - one for all columns
                              - blank - defaults to (EQ)  
                              - Use slash to define alternative string operator
                                EQ/BEGINS etc..
                            - comma separated for each column/value
     pcQueryString - A complete querystring matching the queries tables.
                     MUST be qualifed correctly.
                     ? - use the existing query  
     pcAndOr       - AND or OR decides how the new expression is appended to 
                     the passed query (for each buffer!).                                               
   Notes:  This is basically the same logic as assignQuerySelection, but 
           without the replace functionality.
         - The alternative string operator is not supported before the object 
           is initialized. (datatype is not known)     
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cBufferList    AS CHAR       NO-UNDO.
  DEFINE VARIABLE cBuffer        AS CHARACTER  NO-UNDO.
  
  /* We need the columns name and the parts */  
  DEFINE VARIABLE cColumn        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cOperator      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cValue         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iColumn        AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iBuffer        AS INTEGER    NO-UNDO.
  
  DEFINE VARIABLE cUsedNums      AS CHAR       NO-UNDO.
  
  /* Used to builds the column/value string expression */
  DEFINE VARIABLE cBufWhere      AS CHARACTER  NO-UNDO.
                    
  {get QueryTables cBufferList}.    
   
  /* If unkown value is passed used the existing query string */
  IF pcQueryString = ? THEN
  DO:
    {get QueryString pcQueryString}.      
    /* If no QueryString find the current query */ 
    IF pcQueryString = "":U OR pcQueryString = ? THEN
      {get QueryStringDefault pcQueryString}.    
  END. /* pcQueryString = ? */

  IF pcAndOr = "":U OR pcAndOr = ? THEN pcAndOr = "AND":U.   
  
  DO iBuffer = 1 TO NUM-ENTRIES(cBufferList):  
    ASSIGN
      cBufWhere      = "":U
      cBuffer        = ENTRY(iBuffer,cBufferList).
      
    ColumnLoop:    
    DO iColumn = 1 TO NUM-ENTRIES(pcColumns):             
      
      IF CAN-DO(cUsedNums,STRING(iColumn)) THEN 
        NEXT ColumnLoop.      
      /* get the column, operator and correctly quoted value from the lists 
         if it maps to this buffer. */  
      RUN obtainExpressionEntries IN TARGET-PROCEDURE
                         (cBuffer,
                          iColumn,
                          pcColumns,
                          pcValues,
                          pcOperators,
                          OUTPUT cColumn, 
                          OUTPUT cOperator,
                          OUTPUT cValue).
      IF cColumn = '':U THEN
        NEXT.
      ASSIGN
        cUsedNums  = cUsedNums
                   + (IF cUsedNums = "":U THEN "":U ELSE ",":U)
                   + STRING(iColumn).
        cBufWhere  = cBufWhere 
                   + (If cBufWhere = "":U 
                      THEN "":U 
                      ELSE " ":U + "AND":U + " ":U)
                   + cColumn 
                   + " ":U
                   + cOperator
                   + " ":U
                   + cValue.
    END. /* do iColumn = 1 to num-entries(pColumns) */    
    
    /* We have a new expression */                               
    IF cBufWhere <> "":U THEN
      ASSIGN 
        pcQueryString = DYNAMIC-FUNCTION('newWhereClause':U IN TARGET-PROCEDURE,
                                          cBuffer,
                                          cBufWhere,
                                          pcQueryString,
                                          pcAndOr).  

  END. /* do iBuffer = 1 to hQuery:num-buffers */
  RETURN pcQueryString.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-newWhereClause) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION newWhereClause Procedure 
FUNCTION newWhereClause RETURNS CHARACTER
  (pcBuffer     AS CHAR,   
   pcExpression AS char,  
   pcWhere      AS CHAR,
   pcAndOr      AS CHAR):
/*------------------------------------------------------------------------------
  Purpose:     Inserts a new expression to query's prepare string for a 
               specified buffer.
  Parameters:  pcBuffer     - Buffer.  
               pcExpression - The new expression. 
               pcWhere      - The current query prepare string.
               pcAndOr      - Specifies what operator is used to add the new
                              expression to existing expression(s)
                              - AND (default) 
                              - OR                                                
  Notes:       This is supported as a 'utility function' that doesn't use any 
               properties. However, if target-procedure = super the passed 
               buffer's qualification MUST match the query's. 
               If target-procedure <> super the buffer will be corrected IF 
               it exists in the object's query, otherwise it needs to match 
------------------------------------------------------------------------------*/
 DEFINE VARIABLE iStart      AS INT    NO-UNDO.
 DEFINE VARIABLE iLength     AS INT    NO-UNDO.
 DEFINE VARIABLE cBufferWhere AS CHAR   NO-UNDO.
 
 /* Find the buffer's 'expression-entry' in the query */
 cBufferWhere = DYNAMIC-FUNCTION('bufferWhereClause':U IN TARGET-PROCEDURE,
                                 pcBuffer,
                                 pcWhere).
 
 /* if we found it, replace it with itself with the new expression inserted */
 IF cBufferWhere <> '':U THEN
   ASSIGN
     iStart  = INDEX(pcWhere,cBufferWhere)
     iLength = LENGTH(cBufferWhere)
     SUBSTR(pcWhere,iStart,iLength) = 
               DYNAMIC-FUNCTION('insertExpression':U IN TARGET-PROCEDURE,
                                 cBufferWhere,
                                 pcExpression,
                                 pcAndOr).           
 RETURN pcWhere.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-removeBufferOuterJoin) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION removeBufferOuterJoin Procedure 
FUNCTION removeBufferOuterJoin RETURNS CHARACTER
  ( pcBuffer as char,
    pcQuery  as char):
/*------------------------------------------------------------------------------
  Purpose:     removes the outer-join from the specified buffer's where clause.
   Parameters:  pcBuffer     - Buffer.  
               pcQuery      - The query string to add to. 
                              ? or "" use and set QueryString
    Notes: The QueryString is not assigned if pcQuery parameter is passed
------------------------------------------------------------------------------*/
 DEFINE VARIABLE iPos        AS INT    NO-UNDO.
 DEFINE VARIABLE cBufferWhere AS CHAR   NO-UNDO.
 DEFINE VARIABLE cNewWhere    AS CHAR   NO-UNDO.
 DEFINE VARIABLE cMaskedWhere AS CHAR   NO-UNDO.
 DEFINE VARIABLE lStore        AS LOGICAL     NO-UNDO.

 if pcQuery = "":U or pcQuery = ? then
 do:
     {get QueryString pcQuery}.      
     /* If no QueryString use the default */ 
     IF pcQuery = "":U OR pcQuery = ? THEN
     DO:
        {get QueryStringDefault pcQuery}.    
     END.
     lStore = true.
 end.

 if index(pcQuery, "OUTER-JOIN":U) > 0 then
 do: 
   assign
       /* Get rid of potential line break characters (query builder -> repository)*/   
       pcQuery    = REPLACE(pcQuery,CHR(10),' ':U)
        /* Find the buffer's 'expression-entry' in the query */
       cBufferWhere = DYNAMIC-FUNCTION('bufferWhereClause':U IN TARGET-PROCEDURE,
                                        pcBuffer,
                                        pcQuery)
       /* We mask quoted strings to ensure the following lookup
              only finds stuff in the expression  */ 
       cMaskedWhere   = DYNAMIC-FUNCTION("maskQuotes":U IN TARGET-PROCEDURE,
                                          cBufferWhere,'':U)
    
       iPos  = INDEX(cMaskedWhere + " "," OUTER-JOIN ":U).
           
   if iPos > 0 then 
   do:
       cNewWhere = cBufferWhere.
       substr(cNewWhere,iPos + 1,length('OUTER-JOIN':U) + 1) = "".
       pcQuery = replace(pcQuery,cBufferWhere,cNewWhere).
   end.
 end.

 if lStore then
     {set QueryString pcQuery}.   
 
 return pcQuery.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-removeForeignKey) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION removeForeignKey Procedure 
FUNCTION removeForeignKey RETURNS LOGICAL
  ( ) :
/*------------------------------------------------------------------------------
  Purpose: Remove the ForeignKey from the query string. 
    Notes: The ForeignKey consists of ForeignKeys and ForeignValues. 
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cLocalFields   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cForeignFields AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cForeignValues AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cQueryString   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iField         AS INTEGER    NO-UNDO.

  &SCOPED-DEFINE xp-assign
  {get ForeignValues cForeignValues}
  {get ForeignFields cForeignFields}.
  &UNDEFINE xp-assign
  
  /* 1st of each pair is local db query fld  */
  DO iField = 1 TO NUM-ENTRIES(cForeignFields) BY 2:
    cLocalFields = cLocalFields +  
      (IF cLocalFields NE "":U THEN ",":U ELSE "":U)
        + ENTRY(iField, cForeignFields).
  END. /*  DO iField -- find list of local part of Foreign Fields */  

  {set ForeignValues ?}.

  RETURN DYNAMIC-FUNCTION('removeQuerySelection':U IN TARGET-PROCEDURE,
                           cLocalFields,
                           '=':U).
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
     pcOperators - Operator - one for all columns
                              - blank - defaults to (EQ)  
                              - Use slash to define alternative string operator
                                EQ/BEGINS etc..
                            - comma separated for each column/value

  Notes:       This procedure modifies the QueryString property.               
               openQuery will prepare the query using this property.
               
               The removal of the actual field expression is done by the help 
               of the position and length stored in the QueryColumns property. 
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cQueryString   AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cTmpQuery      AS CHARACTER NO-UNDO.
  
  DEFINE VARIABLE cBufferList    AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cBuffer        AS CHARACTER NO-UNDO.
  
  /* We need the columns name and the parts */  
  DEFINE VARIABLE cColumn        AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cColumnName    AS CHARACTER NO-UNDO.
    
  DEFINE VARIABLE iBuffer        AS INTEGER   NO-UNDO.
  DEFINE VARIABLE iColumn        AS INTEGER   NO-UNDO.
  
  DEFINE VARIABLE cUsedNums      AS CHAR      NO-UNDO.
  
  DEFINE VARIABLE cOperator      AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cStringOp      AS CHARACTER NO-UNDO.
          
  /* Used to store and maintain offset and length */    
  DEFINE VARIABLE iValLength     AS INTEGER   NO-UNDO.
  DEFINE VARIABLE iValPos        AS INTEGER   NO-UNDO.
  DEFINE VARIABLE iPos           AS INTEGER   NO-UNDO.
  DEFINE VARIABLE iDiff          AS INTEGER   NO-UNDO.
  DEFINE VARIABLE cQueryColumns  AS CHAR      NO-UNDO.
  DEFINE VARIABLE cQueryBufCols  AS CHAR      NO-UNDO.
  DEFINE VARIABLE cNewCols       AS CHAR      NO-UNDO.
  DEFINE VARIABLE cQueryColOp    AS CHAR      NO-UNDO.
  DEFINE VARIABLE cRemoveList    AS CHARACTER NO-UNDO.
  DEFINE VARIABLE iOldEntries    AS INTEGER   NO-UNDO.
  DEFINE VARIABLE iLowestChanged AS INTEGER   NO-UNDO.
  DEFINE VARIABLE iBufPos        AS INTEGER   NO-UNDO.
  DEFINE VARIABLE iColPos        AS INTEGER   NO-UNDO.
  DEFINE VARIABLE iWhereBufPos   AS INTEGER   NO-UNDO.

  DEFINE VARIABLE cQuerySplit1   AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cQuerySplit2   AS CHARACTER NO-UNDO.
  DEFINE VARIABLE iNumWords      AS INTEGER   NO-UNDO.
  DEFINE VARIABLE cWord          AS CHARACTER NO-UNDO.

  &SCOPED-DEFINE xp-assign
  {get Tables cBufferList}    
  {get QueryString cQueryString}
  {get QueryColumns cQueryColumns}.
  &UNDEFINE xp-assign
    
  /* If no QueryString or QueryColumns just return now */ 
  IF cQueryString = "":U OR cQueryColumns = "":U THEN
    RETURN FALSE.
  
  DO iBuffer = 1 TO NUM-ENTRIES(cBufferList):
    ASSIGN
      cBuffer        = ENTRY(iBuffer,cBufferList)
      iBufPos        = LOOKUP(cBuffer,cQueryColumns,":":U)
      cQueryBufCols  = IF iBufPos > 0 
                       THEN ENTRY(iBufPos + 1,cQueryColumns,":":U) 
                       ELSE "":U
      iOldEntries    = NUM-ENTRIES(cQueryBufCols) / 3    
      cRemoveList    = "":U
      iLowestChanged = 0.
    
    ColumnLoop:    
    DO iColumn = 1 TO NUM-ENTRIES(pcColumns):
      IF CAN-DO(cUsedNums,STRING(iColumn)) THEN 
        NEXT ColumnLoop.      
      
      ASSIGN
        cColumn     = ENTRY(iColumn,pcColumns).
      
      /* Get the operator for this valuelist. 
         Make sure we handle '',? and '/begins' as default */                                                  
        cOperator   = IF pcOperators = "":U 
                      OR pcOperators BEGINS "/":U 
                      OR pcOperators = ?                       
                      THEN "=":U 
                      ELSE IF NUM-ENTRIES(pcOperators) = 1 
                           THEN ENTRY(1,pcOperators,"/":U)                                                 
                           ELSE ENTRY(iColumn,pcOperators).
        
      
      /* Unqualified fields will use the first buffer that has a match
         because the columnDataType below searches all buffers in the query */           
      IF INDEX(cColumn,".":U) = 0 THEN       
        cColumn = cBuffer + ".":U + cColumn.  
     
      /* Wrong buffer */
      IF NOT (cColumn BEGINS cBuffer + ".":U) THEN 
      DO: 
        /* If the column db qualification does not match the query's we do 
           an additionl check to see if it is the correct table after all */                                
        IF NUM-ENTRIES(cColumn,".":U) - NUM-ENTRIES(cBuffer,".":U) <> 1 THEN
        DO:
          IF {fnarg columnTable cColumn} <> cBuffer THEN 
            NEXT ColumnLoop.  
        END.
        ELSE
          NEXT ColumnLoop.
      END.
      ASSIGN
        cColumnName = ENTRY(NUM-ENTRIES(cColumn,".":U),cColumn,".":U)
        cQueryColOp = cOperator
        cQueryColOp = TRIM(IF cQueryColOp = "GE":U THEN ">=":U
                           ELSE IF cQueryColOp = "LE":U THEN "<=":U
                           ELSE IF cQueryColOp = "LT":U THEN "<":U
                           ELSE IF cQueryColOp = "GT":U THEN ">":U
                           ELSE IF cQueryColOp = "EQ":U THEN "=":U
                           ELSE    cQueryColOp)
      
        cStringOp   = IF NUM-ENTRIES(pcOperators) = 1 
                      AND NUM-ENTRIES(pcOperators,"/":U) = 2  
                      THEN ENTRY(2,pcOperators,"/":U)
                      ELSE "":U
       .                                                 
      
      /* First check if this was a string with stringoperator */  
      IF cStringOp <> "":U THEN  
        iPos        = LOOKUP(cColumnName + ".":U + cStringOp,cQueryBufCols).
      ELSE iPos = 0.
      
      IF iPos = 0 THEN
        iPos        = LOOKUP(cColumnName + ".":U + cQueryColOp,cQueryBufCols).
      
        /* If the column + operator was found in the list
           we build a list of the columns to remove from the QueryString further 
           down.
           We also build a list of the numbers to remove. */         
      IF iPos > 0 THEN
      DO:        
        ASSIGN
          iLowestChanged = MIN(iPos,IF iLowestChanged = 0 
                                    THEN iPos 
                                    ELSE iLowestChanged)
          cRemoveList   = cRemoveList 
                          + (IF cRemoveList = "":U THEN "":U ELSE ",":U)
                          + STRING(INT((iPos - 1) / 3 + 1))     
          cUsedNums     = cUsedNums
                          + (IF cUsedNums = "":U THEN "":U ELSE ",":U)
                          + STRING(iColumn)
          . 
     
      END. /* IF ipos > 0 */    
    END. /* do icolumn = 1 to  */ 
    
    /* Get the buffers position in the where clause (always the
       first entry in a dynamic query because there's no 'of <external>')*/ 
    ASSIGN
      /* We mask quoted strings to ensure the following table lookup
         only finds stuff in the expression(in lack of parsing) */ 
      cTmpQuery   = DYNAMIC-FUNCTION("maskQuotes":U IN TARGET-PROCEDURE,
                                      cQueryString,'':U)
      iWhereBufPos = INDEX(cTmpQuery + " "," ":U + cBuffer + " ":U)
      iPos         = INDEX(cTmpQuery,      " ":U + cBuffer + ",":U)
      iWhereBufPos = (IF iWhereBufPos > 0 AND iPos > 0
                      THEN MIN(iPos,iWhereBufPos) 
                      ELSE MAX(iPos,iWhereBufPos))
                      + 1
      iDiff        = 0
      cNewCols     = "":U
      .                          
    IF iLowestChanged > 0 THEN 
    DO iColumn = 1 TO NUM-ENTRIES(cQueryBufCols) - 2 BY 3:       
      
      ASSIGN
        iValPos      = INT(ENTRY(iColumn + 1,cQueryBufCols))
        iValLength   = INT(ENTRY(iColumn + 2,cQueryBufCols))
        iValPos      = iValPos - iDiff
        .
      /* Remove value, operator, columnname and eventual AND in the
         parenthesized expression. If it's the last expression in the parenthesis
         we also remove it and any AND/OR after or WHERE/AND/OR before. */
           
      IF CAN-DO(cRemoveList,STRING(INT((iColumn - 1) / 3 + 1))) THEN       
      DO:
         ASSIGN 
          /*Split query in two, remove value quotes and blanks */
          cQuerySplit1 = 
     RIGHT-TRIM(SUBSTR(cQueryString,1,iValPos + iWhereBufPos - 1)," '~"":U) 
          cQuerySplit2 =
     LEFT-TRIM(SUBSTR(cQueryString,iValPos + iWhereBufPos + iVallength)," '~"":U) 

          /* Count words in left part */
          iNumWords   = NUM-ENTRIES(cQuerySplit1," ":U)
         
          /* Remove Operator */ 
          ENTRY(iNumWords,cQuerySplit1," ":U) = "":U
           
          cQuerySplit1 = RIGHT-TRIM(cQuerySplit1," ":U)
          
          /* find columnname */
          cWord       = ENTRY(iNumWords - 1,cQuerySplit1," ":U)
          .

         /* if columnname has parenthesis this is the beginning of an exp */
         IF cWord BEGINS "(":U THEN
         DO:
           /* We are removing the first column/value pair in the parenthesis*/
           IF cQuerySplit2 BEGINS "AND":U THEN
           DO:
             ASSIGN
               /* Remove the previous word (columnname), but keep parenthesis */
               ENTRY(iNumWords - 1,cQuerySplit1," ":U) = "(":U
               /* Remove AND in right part */
               ENTRY(1,cQuerySplit2," ":U) = "":U
               cQuerySplit2 = LEFT-TRIM(cQuerySplit2," ":U)
               .
           END.  /* if cquerysplit2 begins and */
           ELSE IF cQuerySplit2 BEGINS ")":U THEN
           DO:
             ASSIGN
               /* Remove columnname and parenthesises around the expression */
               ENTRY(iNumWords - 1,cQuerySplit1," ":U) = "":U
               cQuerySplit1 = RIGHT-TRIM(cQuerySplit1," ":U)
               cQuerySplit2 = LEFT-TRIM(SUBSTR(cQuerySplit2,2)," ":U)
               cWord = ENTRY(iNumWords - 2,cQuerySplit1," ":U).
     
             /* Now remove AND or OR used to join an eventual expression */ 
             IF cQuerySplit2 BEGINS "AND ":U OR cQuerySplit2 BEGINS "OR ":U THEN
               ENTRY(1,cQuerySplit2," ":U) = "":U.
             
             /* There were no and after, so remove WHERE,AND or OR before */  
             ELSE IF CAN-DO("WHERE,AND,OR":U,cWord) THEN
               ENTRY(iNumWords - 2,cQuerySplit1," ":U) = "":U.                                  
             
             /* No where/and/or or and/or removed so add a blank before we join
                the splitted query  */
             ELSE cQuerySplit2 = " ":U + cQuerySplit2.
           
           END.             
         END. /* word begins '(' */ 
         ELSE 
         DO: 
           ASSIGN
             /* Now remove the prev word (columnname) */
             ENTRY(iNumWords - 1,cQuerySplit1," ":U) = "":U
             /* Remove blanks in order to find the prev word */
             cQuerySplit1 = RIGHT-TRIM(cQuerySplit1," ":U)
             /* Now remove AND */
             ENTRY(iNumWords - 2,cQuerySplit1," ":U) = "":U
             .          
           
           /* If we removed the last column/value pair,
              we leave no space between the parenthesis */
           IF cQuerySplit2 BEGINS ")":U THEN 
             cQuerySplit1 = RIGHT-TRIM(cQuerySplit1).  
         END. 
         ASSIGN
           /* Keep track of shrinkage */          
           iDiff = iDiff + (LENGTH(cQueryString) 
                         - LENGTH(cQuerySplit1 + cQuerySplit2))         
           cQueryString = cQuerySplit1 + cQuerySplit2
           .  
      END. /* if can-do(cRemoveList,... */       
      
      ELSE  /* not removed, store the position adjusted for shrinkage  */
        cNewCols = cNewCols 
                   + (IF cNewCols = "":U THEN "":U ELSE ",":U)
                   + ENTRY(icolumn,cQueryBufCols)
                   + ",":U
                   + STRING(iValPos)
                   + ",":U
                   + (ENTRY(iColumn + 2,cQueryBufCols)).
    
    END. /* else if ilowestchanged do icolumn = ilowestChanged to num-entries */  
    
    IF cNewCols <> "" THEN 
    DO:
      ENTRY(iBufPos + 1,cQueryColumns,":":U) = cNewCols.        
    END.
    ELSE IF iLowestChanged > 0 THEN
    do:
      ASSIGN
        ENTRY(iBufPos,cQueryColumns,":":U) = "":U
        ENTRY(iBufPos + 1,cQueryColumns,":":U) = "":U
        cQueryColumns = TRIM(REPLACE(cQueryColumns,":::":U,":":U),":":U).
      /* if toggle outer join is true (default) and the default/design query 
         has outer join on this table then add it back in */ 
      if {fn getToggleOuterJoin} and {fnarg bufferHasOuterJoinDefault cBuffer} then
         cQueryString = DYNAMIC-FUNCTION('assignBufferOuterJoin':U IN TARGET-PROCEDURE,
                                         cBuffer,
                                         cQueryString).

    end.

  END.  
  
  &SCOPED-DEFINE xp-assign
  {set QueryColumns cQueryColumns}
  {set QueryString cQueryString}.
  &UNDEFINE xp-assign
  
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-replaceQuerySort) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION replaceQuerySort Procedure 
FUNCTION replaceQuerySort RETURNS CHARACTER
  ( pcQuery       AS CHAR,
    pcSort        AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose   :  Replace/Insert sort criteria (BY phrase) in a QueryString.
  Parameters:
    pcQuery    - Query to add sort to (current sort will be replaced)        
    pcSort     - new sort expression.                
                                      
 Notes:   Intended for internal use by newQuerySort   
-------------------------------------------------------------------------------*/ 
 DEFINE VARIABLE iByPos            AS INTEGER    NO-UNDO.
 DEFINE VARIABLE iIdxPos           AS INTEGER    NO-UNDO.
 DEFINE VARIABLE cTmpQuery         AS CHARACTER  NO-UNDO. 
 DEFINE VARIABLE iLength           AS INTEGER    NO-UNDO.
 
 ASSIGN 
   /* We mask quoted strings to ensure the following keyword lookup
     only finds stuff in the expression(in lack of parsing) */ 
   cTmpQuery   = DYNAMIC-FUNCTION("maskQuotes":U IN TARGET-PROCEDURE,
                                   pcQuery,'':U)
   /* check for  indexed-reposition  */
   iIdxPos = INDEX(RIGHT-TRIM(cTmpQuery,". ") + " ":U," INDEXED-REPOSITION ":U)          

   /* If no INDEX-REPOSITION is found, set the iLength (where to end insert)
      to the end of where-clause. (right-trim periods and blanks to find 
      the true end of the expression) Otherwise iLength is the position of 
      INDEX-REPOSITION. */
   iLength = (IF iIdxPos = 0 
              THEN LENGTH(RIGHT-TRIM(cTmpQuery,". ":U)) + 1     
              ELSE iIdxPos)    
      
   /* Any By ? */ 
   iByPos  = INDEX(cTmpQuery," BY ":U)   
      
   /* Now find where we should start the insert; 
      We might have both a BY and an INDEXED-REPOSITION or only one of them 
      or none. So we make sure we use the MINIMUM of whichever of those 
      unless they are 0. */
   iByPos  = MIN(IF iByPos  = 0 THEN iLength ELSE iByPos,
                 IF iIdxPos = 0 THEN iLength ELSE iIdxPos) 
      
   SUBSTR(pcQuery,iByPos,iLength - iByPos) = IF pcSort <> '':U 
                                             THEN " ":U + pcSort
                                             ELSE "":U.  

 RETURN pcQuery.  

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-repositionRowObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION repositionRowObject Procedure 
FUNCTION repositionRowObject RETURNS LOGICAL
     ( pcRowIdent AS CHARACTER ):
 /*------------------------------------------------------------------------------
  Purpose:     Procedure to reposition the current rowobject record
               to the correct one. Used during updates to get around issues
               where the user has navigated to a different record in the
               SDO prior to pressing save.
  Parameters:  input rowident
  Notes:       We need to use entry 1 of the rowident which is the rowid of
               the rowobject temp-table record.
               This is NOT using reposition because we do not want the browser
               to reposition.
            -  This function is called from datavis objects as pointed out as the 
               purpose for this, but a datasource cannot be navigated to a 
               different record than its updatesource while the updatesource is 
               active. A hidden deactivated datatarget will synchronize to the 
               datasource when it becomes unhidden.         , 
               The function should thus ideally be removed, but the call may 
               give protection if the underlying temp-table is navigated without 
               using adm2 methods (or with this method....). 
             - The method should not be used standalone as it may cause the 
               very same problem that it is fixing as it does not signal any
               rowchange and assumes that it is called in a context where the 
               record that is being positioned to will be properly handled.
               (not to mention the record that is being positioned from..)  
             History:   
               It was added as part of the data class in Dynamics at a time 
               (9.1B - 9.1C) when SDOs sometimes did loose available record and 
               Dynamics supported link deactivation/activation that allowed 
               several viewers to share the source. (not supported now)
             Future:
               Multiple views of the same datasource may be implemented, but 
               hopefully without forcing the targets to reposition the source 
               before an update or cancel. (but rather as part of ) 
------------------------------------------------------------------------------*/
 DEFINE VARIABLE hRowObject AS HANDLE NO-UNDO.
 DEFINE VARIABLE rRowid     AS ROWID  NO-UNDO.
 
 {get RowObject hRowObject}.
 /* if the passed value is completely bogus so that TO-ROPWID fails then the 
    no-error will still suppress the error, but the find-by-rowid is never 
    executed and the record remains available. 
    We release the buffer first to ensure that the record only is available 
    if find is successful. */  
 hRowObject:buffer-release(). 
 hRowObject:FIND-BY-ROWID(TO-ROWID(pcRowident)) NO-ERROR.
 RETURN VALID-HANDLE(hRowObject) AND hRowObject:AVAILABLE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-resetQueryString) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION resetQueryString Procedure 
FUNCTION resetQueryString RETURNS LOGICAL
  (   ) :
/*------------------------------------------------------------------------------
  Purpose: Removes all filter and sort criteria from the querystring   
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cDefault AS CHARACTER  NO-UNDO.
  
  &SCOPED-DEFINE xp-assign
  {get QueryStringDefault cDefault}
  {set QueryString cDefault}
  {set QueryColumns '':U}
  .
  &UNDEFINE xp-assign
  
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-resolveColumn) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION resolveColumn Procedure 
FUNCTION resolveColumn RETURNS CHARACTER
  ( pcColumn AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose: Resolve column reference for query manipulation APIs 
    Notes: Qualifies unqualified columns or replaces 'RowObject' qualifier 
           with DataTable.  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cDataTable        AS CHARACTER  NO-UNDO.
  
  IF NUM-ENTRIES(pcColumn,'.':U) = 1 THEN 
  DO:
    {get DataTable cDataTable}. 
    pcColumn = cDataTable + '.':U + pcColumn.
  END.
  ELSE IF ENTRY(1,pcColumn,'.') = 'RowObject':U THEN
  DO:
    {get DataTable cDataTable}. 
    ENTRY(1,pcColumn,'.':U) = cDataTable.
  END.

  RETURN pcColumn.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-rowAvailable) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION rowAvailable Procedure 
FUNCTION rowAvailable RETURNS LOGICAL
  ( pcDirection  AS CHAR ) :
/*------------------------------------------------------------------------------
   Purpose: Check RowObject availability. 
            Encapsulates the different queryposition alternatives required to
            check for availability.
Parameters: pcDirection 
                   NEXT              Is there a next record available
                   PREV              Is there a prev record available
                   '', ?, or CURRENT Current record.
     Notes: This can be used in loops to simplify logic when navigating. 
            Simplifed example without dynamic-func and handles:
            -----------------------------------------                                          
            if rowAvailable('') then 
            do while true 
              run fetchNext.
              if not rowAvailable('next') then leave.  
            end.            
            ----------------------------------------
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cQueryPosition AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE xcOneOrNone    AS CHARACTER  NO-UNDO
      INIT 'OnlyRecord,NoRecordAvailable,NoRecordAvailableExt':U.

  {get QueryPosition cQueryPosition}.   
  CASE pcDirection:
    WHEN 'Next':U THEN
      RETURN NOT CAN-DO('LastRecord,':U + xcOneOrNone,cQueryPosition). 
    WHEN 'Prev':U THEN
      RETURN NOT CAN-DO('FirstRecord,':U + xcOneOrNOne,cQueryPosition).
    WHEN '':U OR WHEN 'Current':U OR WHEN ? THEN 
      RETURN NOT cQueryPosition BEGINS 'NoRecord':U. 
  END CASE.

  RETURN FALSE.  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-rowValues) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION rowValues Procedure 
FUNCTION rowValues RETURNS CHARACTER
  ( pcColumns   AS CHAR,
    pcFormat    AS CHAR,
    pcDelimiter AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose: Retrieve a list of data from ALL rows in the dataobject.     
  Parameters: 
    pcColumns - Comma separated list of RowObject column names.
    pcFormat  - Formatting option
                 blank or ?   - unformatted: columnValue()  
                'Formatted'   - Formatted without trailing blanks                                     
                'TrimNumeric' - Formatted without leading spaces for
                                numeric data (left justified).     
                'NoTrim'      - Formatted with leading and trailing blanks. 
                ' &1 &2 '     - &n, where the number references the column 
                                in pcColumns order, indicates that the column 
                                values should be substituted as specified 
                                instead of returned as delimiter separated
                                values. This allows formatting data to be mixed
                                with the returned values; f.ex: '&2 (&1)', 
                                '&2 / &1'  etc.. 
                                In order to build a list-item-pair list just 
                                ensure that the delimiter is in the format;
                                F. ex: '&2 (&1)' + ',' + '&1' where ',' also 
                                is passed as delimiter would return a paired
                                list where the second item of the pair is the 
                                column number one.   
              pcDelimiter     - Single char delimiter 
                                 ?      = chr(1) ! 
                                 blank  = single space !         
              
  Notes: - This function reads all data without publishing dataAvailable to its 
           data-targets. However, if the query is browsed that will still happen 
           when reposition-to-rowid is executed to get back to the current record.                             
         - This is intended for use by the SmartSelect or other non-browser
           widgets that need to show all rows of the SDO.   
         - Should only be used with smaller amounts of records/data, as all data 
           need to fit in the character return value. The limit is in theory 32K,
           in reality somewhat smaller. The concatination of the data is 
           currently wrapped in an on stop block using no-error. The Progress 
           error message will be shown if the limit is encountered.
         - Maximum 9 columns can be passed when a substitute format is specified   
------------------------------------------------------------------------------*/ 
  DEFINE VARIABLE hDataQuery   AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hRowObject   AS HANDLE     NO-UNDO.
  DEFINE VARIABLE rRowid       AS ROWID      NO-UNDO.
  DEFINE VARIABLE iLastRowNum  AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iCol         AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cValue       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cList        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iReturnRows  AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iLoop        AS INTEGER    NO-UNDO.
  DEFINE VARIABLE hColumnExt   AS HANDLE     NO-UNDO EXTENT 9.
  DEFINE VARIABLE cSub         AS CHARACTER  NO-UNDO EXTENT 9.
  DEFINE VARIABLE hColumn      AS HANDLE     NO-UNDO.
  DEFINE VARIABLE lSizeError   AS LOGICAL    NO-UNDO. /* if bfx size error was detected */
  DEFINE VARIABLE iNumCols     AS INTEGER    NO-UNDO.
  DEFINE VARIABLE lSubstitute  AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cSubstitute  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cMessage     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lRebuild     AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE iFirstRowNum AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cTable       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cColumn      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cColName     AS CHARACTER  NO-UNDO.
     
   /* It ain't pretty... but fast ..  
      This allows 9 fields from the buffer to be substituted without looping 
      through the fields */
   &SCOPED-DEFINE  formatvalue ~
      IF VALID-HANDLE(~{&hdl~}) ~
      THEN IF ~{&hdl~}:BUFFER-VALUE = ? THEN '?':U ~
           ELSE IF pcFormat = '' OR lSubstitute THEN ~{&hdl~}:BUFFER-VALUE ~
           ELSE IF pcformat = 'TrimNumeric':U AND CAN-DO('Decimal,Integer':U,~{&hdl~}:DATA-TYPE) ~
                THEN TRIM(~{&hdl~}:STRING-VALUE) ~
                ELSE IF pcformat = 'Formatted':U OR pcFormat = 'TrimNumeric':U ~
                     THEN RIGHT-TRIM(~{&hdl~}:STRING-VALUE) ~
                     ELSE ~{&hdl~}:STRING-VALUE ~
      ELSE ''
  &SCOPED-DEFINE hdl hColumnExt[~{&Num~}]
  
  &SCOPED-DEFINE Num 1
  &SCOPED-DEFINE formatvalue1 {&formatvalue}
  &SCOPED-DEFINE Num 2
  &SCOPED-DEFINE formatvalue2 {&formatvalue}
  &SCOPED-DEFINE Num 3
  &SCOPED-DEFINE formatvalue3 {&formatvalue}
  &SCOPED-DEFINE Num 4
  &SCOPED-DEFINE formatvalue4 {&formatvalue}
  &SCOPED-DEFINE Num 5 
  &SCOPED-DEFINE formatvalue5 {&formatvalue}
  &SCOPED-DEFINE Num 6 
  &SCOPED-DEFINE formatvalue6 {&formatvalue}
  &SCOPED-DEFINE Num 7
  &SCOPED-DEFINE formatvalue7 {&formatvalue}
  &SCOPED-DEFINE Num 8
  &SCOPED-DEFINE formatvalue8 {&formatvalue}
  &SCOPED-DEFINE Num 9
  &SCOPED-DEFINE formatvalue9 {&formatvalue}
  
  &UNDEFINE hdl
  
  /* We are not opening the query from here .. */
  {get DataHandle hDataQuery}.
  IF VALID-HANDLE(hDataQuery) AND hDataQuery:IS-OPEN THEN
  DO:
        /* ? is CHR(1) */
    IF pcDelimiter = ? THEN
      pcDelimiter = CHR(1).
    /* Ensure blank delimiter is single space */ 
    ELSE IF pcDelimiter = "":U THEN
      pcDelimiter = " ":U.

    &SCOPED-DEFINE xp-assign
    {get FirstRowNum iFirstRowNum}
    {get RowObject hRowObject}     
    {get LastRowNum iLastRowNum}
    .
    &UNDEFINE xp-assign 
    
    ASSIGN           /* if then else used as ? is allowed in format */
      lSubstitute = IF INDEX(pcFormat,'&':U) > 0 THEN TRUE ELSE FALSE  
      /* Used in WHEN, so must be set BEFORE Assign statement! */  
      iNumCols = NUM-ENTRIES(pcColumns). 
    
    IF lSubstitute AND iNumCols > 9 THEN
    DO:
      MESSAGE "The maximum number of columns that can be passed to rowValues()"
            +   " with a substitute format is 9."  
      VIEW-AS ALERT-BOX ERROR.
      RETURN ?.
    END.

    IF lSubstitute THEN 
      ASSIGN
        cSubstitute = pcFormat
        /* for default substitute we remove trailing banks in data */
        pcFormat    = 'Formatted':U.
    
    ELSE DO: 
       /* support dashes in format input parameter */
       pcFormat = REPLACE(pcformat,"-":U,"":U). 

      /* use substitute logic for any format in order to use the performance 
         preprocessor and avoid looping thru each column */   
       DO iCol = 1 TO MIN(9,iNumCols):
         cSubstitute = cSubstitute 
                     + (IF iCol = 1 THEN '' ELSE pcDelimiter)
                     +  '&':U + STRING(iCol).
       END.
    END.
    /* Maximize performance, avoid regetting dynamic buffer fields in row loop.
       (This loop is duplicated below inside the column loop for column 
        number 10 and higher )*/         
    DO iCol = 1 TO iNumCols:
      cColumn  = ENTRY(iCol,pcColumns).
      IF NUM-ENTRIES(cColumn,'.':U) > 1 THEN
        ASSIGN
          cTable   = ENTRY(1,cColumn,'.')
          cColName = ENTRY(2,cColumn,'.').
      ELSE 
        ASSIGN
          cTable   = ''  
          cColname = cColumn. 

      IF cTable = '' OR hRowObject:NAME = cTable THEN
        hColumnExt[iCol] = hRowObject:BUFFER-FIELD(cColname) NO-ERROR.  
      ELSE
        hColumnExt[iCol] = IF cTable = hRowObject:NAME 
                           THEN hRowObject:BUFFER-FIELD(cColName) 
                           ELSE {fnarg columnHandle cColumn} NO-ERROR.  
      
      IF ERROR-STATUS:GET-MESSAGE(1) > '' THEN
      DO:
        MESSAGE 
          ERROR-STATUS:GET-MESSAGE(1)
          VIEW-AS ALERT-BOX ERROR.
        RETURN ?.
      END.
      ELSE IF NOT VALID-HANDLE(hColumnExt[iCol]) THEN
      DO:
        MESSAGE 
         "Column " cColumn "not found in" {fn getObjectName} 
          VIEW-AS ALERT-BOX ERROR.
        RETURN ?.
      END.
    END. /* DO iCol = 1 TO iNumCol */

    rRowid        = hRowObject:ROWID. 
      /* Just in case the SDO is browsed, ensure refreshable is turned off */    
    PUBLISH 'fetchDataSet':U FROM TARGET-PROCEDURE ('BatchStart':U). 
    
    hDataQuery:GET-FIRST.
    IF hRowObject:AVAILABLE THEN 
    DO:
       /* We cannot call rowValues with data from the middle of the batch */
      IF iFirstRowNum = ? THEN
      DO:
        MESSAGE "The rowValues() function is being called while the first record of"
                " the result set is not present in the existing batch." skip
                IF {fn getRebuildOnRepos} 
                THEN "The RebuildOnRepos property must be FALSE in order to call rowValues()"
                   + " in an object that only has a batch of data."
                ELSE ""   
                VIEW-AS ALERT-BOX ERROR.

        RETURN ?.
      END.

      BuildBlock:
      DO iLoop = 1 TO IF iLastRowNum = ? THEN 2 ELSE 1: /* need two loops if batching */      
        IF iLoop = 2 THEN
          DYNAMIC-FUNCTION("retrieveBatch":U IN TARGET-PROCEDURE,
                           'NEXT':U,
                           0). /* all remaining data */
            
        DO WHILE hDataQuery:QUERY-OFF-END = FALSE:
  
          /* on stop undo, leave to avoid bfx error */
          DO ON STOP UNDO, LEAVE :
              /* Use local variable to avoid issues with -inp blowing up
                 the SUBSTITUTE() function.
               */
              ASSIGN cSub[1] = {&formatvalue1}
                     cSub[2] = {&formatvalue2}
                     cSub[3] = {&formatvalue3}
                     cSub[4] = {&formatvalue4}
                     cSub[5] = {&formatvalue5}.
              /* Break up assign stmt to avoind -inp errors
                 on the assign statement.
               */
              ASSIGN cSub[6] = {&formatvalue6}
                     cSub[7] = {&formatvalue7}
                     cSub[8] = {&formatvalue8}
                     cSub[9] = {&formatvalue9}.
              
              ASSIGN cList = cList + pcDelimiter
                           + SUBSTITUTE(cSubstitute,
                                        cSub[1], cSub[2], cSub[3],
                                        cSub[4], cSub[5], cSub[6],
                                        cSub[7], cSub[8], cSub[9]) NO-ERROR.
          END. /* end assign block */         
            
          IF ERROR-STATUS:ERROR THEN 
          DO:
            ASSIGN
              lSizeError = TRUE
              cMessage   = ERROR-STATUS:GET-MESSAGE(1). 
            LEAVE BuildBlock.
          END.
          
          IF iNumCols > 9 THEN
          DO iCol = 10 TO iNumCols:
            cColumn  = ENTRY(iCol,pcColumns).
            IF NUM-ENTRIES(cColumn,'.':U) > 1 THEN
              ASSIGN
                cTable   = ENTRY(1,cColumn,'.')
                cColName = ENTRY(2,cColumn,'.').
            ELSE 
              ASSIGN
                cTable   = ''  
                cColname = cColumn. 
      
            IF cTable = '' OR hRowObject:NAME = cTable THEN
              hColumnExt[iCol] = hRowObject:BUFFER-FIELD(cColname) NO-ERROR.  
            ELSE
              hColumnExt[iCol] = IF cTable = hRowObject:NAME 
                                 THEN hRowObject:BUFFER-FIELD(cColName) 
                                 ELSE {fnarg columnHandle cColumn} NO-ERROR.  
            
            IF ERROR-STATUS:GET-MESSAGE(1) > '' THEN
            DO:
              MESSAGE 
                ERROR-STATUS:GET-MESSAGE(1)
                VIEW-AS ALERT-BOX ERROR.
              RETURN ?.
            END.
            ELSE IF NOT VALID-HANDLE(hColumnExt[iCol]) THEN
            DO:
              MESSAGE 
               "Column " cColumn "not found in" {fn getObjectName} 
                VIEW-AS ALERT-BOX ERROR.
              RETURN ?.
            END.
          
            &SCOPED-DEFINE hdl hColumn
            cValue = {&formatvalue}.
            &UNDEFINE hdl 
            /* on stop undo, leave to avoid bfx error */
            DO ON STOP UNDO, LEAVE :
              ASSIGN
               cList = cList 
                     + pcDelimiter
                     + cValue NO-ERROR.
          
            END. /* end assign block */         
            
            IF ERROR-STATUS:ERROR THEN 
            DO:
              ASSIGN
                lSizeError = TRUE
                cMessage   = ERROR-STATUS:GET-MESSAGE(1). 
              LEAVE BuildBlock.
            END.
          END. /* do iCol = 9 to num-entries */         
          hDataQuery:GET-NEXT.
        END. /* BuildBlock: do while Query-off-end = false */    
      END.  /* do loop */
    END. /* if hRowObject:avail  */
    
    IF rRowid <> ? THEN
    DO:  
      hDataQuery:REPOSITION-TO-ROWID(rRowid). 
      IF NOT hRowObject:AVAILABLE THEN
        hDataQuery:GET-NEXT.
    END.

    /* In case the SDO is browsed, ensure refreshable is turned back on */    
    PUBLISH 'fetchDataSet':U FROM TARGET-PROCEDURE ('BatchEnd':U).     
  END. /* queryopen and valid */
  
  /* More than 32K in string error... */ 
  IF lSizeError THEN 
  DO:
    MESSAGE       
      cMessage SKIP
      VIEW-AS ALERT-BOX WARNING.                     

    RETURN ?.
  END.

  /* Ensure that only the first delimiter is removed; as opposed to the 
     left-trim(...,Separator). We may have space as delimiter and prepend the 
     delimiter above */
  RETURN SUBSTRING(cList,2).

  &UNDEFINE formatvalue
  &UNDEFINE formatvalue1
  &UNDEFINE formatvalue2
  &UNDEFINE formatvalue3
  &UNDEFINE formatvalue4
  &UNDEFINE formatvalue5
  &UNDEFINE formatvalue6
  &UNDEFINE formatvalue7
  &UNDEFINE formatvalue8
  &UNDEFINE formatvalue9
  &UNDEFINE num
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setAutoCommit) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setAutoCommit Procedure 
FUNCTION setAutoCommit RETURNS LOGICAL
  ( plAutoCommit AS LOGICAL ) :
/*------------------------------------------------------------------------------
  Purpose:  Sets the  flag on or off; when On, every call to submitRow
            will result in a Commit.
   Params:  plAutoCommit AS LOGICAL  -- If true,  is set On.
------------------------------------------------------------------------------*/
  &SCOPED-DEFINE xpAutoCommit
  {set AutoCommit plAutoCommit}.
  &UNDEFINE xpAutoCommit
  RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setBufferHandles) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setBufferHandles Procedure 
FUNCTION setBufferHandles RETURNS LOGICAL
  ( pcBufferHandles AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  {set BufferHandles pcBufferHandles}.
  
  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setCommitSource) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setCommitSource Procedure 
FUNCTION setCommitSource RETURNS LOGICAL
  ( phObject AS HANDLE ) :
/*------------------------------------------------------------------------------
  Purpose:  Sets the CommitSource link value.
   Params:  phObject AS HANDLE -- procedure handle of this object's CommitSource 
------------------------------------------------------------------------------*/

  {set CommitSource phObject}.
  RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setCommitSourceEvents) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setCommitSourceEvents Procedure 
FUNCTION setCommitSourceEvents RETURNS LOGICAL
  ( pcEvents AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Sets the list of events that this object wants to subscribe to
            in its Commit-Source.
   Params:  pcEvents AS CHARACTER -- list of events. Note that because it is
            a list, modifyListProperty should normally be used to add items. 
------------------------------------------------------------------------------*/

  {set CommitSourceEvents pcEvents}.
  RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setCommitTarget) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setCommitTarget Procedure 
FUNCTION setCommitTarget RETURNS LOGICAL
  ( pcObject AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Sets the CommitTarget link value.
   Params:  pcObject AS CHARACTER -- string form of procedure handle of this
              object's CommitTarget
------------------------------------------------------------------------------*/

  {set CommitTarget pcObject}.
  RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setCommitTargetEvents) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setCommitTargetEvents Procedure 
FUNCTION setCommitTargetEvents RETURNS LOGICAL
  ( pcEvents AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Sets the list of events that this object wants to subscribe to
            in its Commit-Target.
   Params:  pcEvents AS CHARACTER -- list of events. Note that because it is
            a list, modifyListProperty should normally be used to add items. 
------------------------------------------------------------------------------*/

  {set CommitTargetEvents pcEvents}.
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

&IF DEFINED(EXCLUDE-setDataColumns) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setDataColumns Procedure 
FUNCTION setDataColumns RETURNS LOGICAL
  ( pcColumns AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose:     Sets the comma-delimited list of the columnNames for the 
               SmartDataObject. 
  Parameters:  
       Notes:   
------------------------------------------------------------------------------*/
  IF pcColumns = '':U THEN
     RETURN FALSE.

  {set DataColumns pcColumns}.
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
 Purpose: Set to tell whether data for the query is or was fetched by parent.
   Notes: See details in getDataIsFetched  
------------------------------------------------------------------------------*/
  {set DataIsFetched plFetched}.
  
  RETURN TRUE.   

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setDataModified) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setDataModified Procedure 
FUNCTION setDataModified RETURNS LOGICAL
  ( plDataModified AS LOGICAL ) :
/*------------------------------------------------------------------------------
  Purpose: Backwards compatibility only to avoid error messages
    Notes:  
------------------------------------------------------------------------------*/
  &SCOPED-DEFINE xpDataModified
  {set DataModified plDataModified}.
  &UNDEFINE xpDataModified
  
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
  Purpose:     Sets a property flag indicating that this object's DataQuery
               is being browsed by a SmartDataBrowser.
 
  Parameters:
    INPUT plBrowsed - True if a SmartDataBrowser uses this SmartDataObject
                      as a Data-Source.
    
  Notes:       This is set by a SmartDataBrowser which is a Data-Target.
               The property is used to prevent multiple SmartDataBrowsers 
               from attempting to browse the same query, which is not 
               allowed.
------------------------------------------------------------------------------*/

  DEFINE VARIABLE lAlreadyBrowsed AS LOGICAL NO-UNDO.
  
  &SCOPED-DEFINE xpDataQueryBrowsed
  {get DataQueryBrowsed lAlreadyBrowsed}.
  &UNDEFINE xpDataQueryBrowsed

  IF plBrowsed AND lAlreadyBrowsed THEN 
    RETURN FALSE.

  &SCOPED-DEFINE xpDataQueryBrowsed
  {set DataQueryBrowsed plBrowsed}.
  &UNDEFINE xpDataQueryBrowsed

  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setDataQueryString) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setDataQueryString Procedure 
FUNCTION setDataQueryString RETURNS LOGICAL
  (pcQueryString AS CHARACTER) :
/*------------------------------------------------------------------------------
  Purpose:  Sets the string used to prepare the RowObject query  
    Notes:  This is set in data.i's Main block initially to: 
              FOR EACH RowObject INDEXED-REPOSITION
            If this needs to be changed to turn off INDEXED-REPOS on the 
            RowObject query, the container creating this SDO can override
            createObjects and set DataQueryString to:
              FOR EACH RowObject
------------------------------------------------------------------------------*/
  {set DataQueryString pcQueryString}.
  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setFetchOnOpen) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setFetchOnOpen Procedure 
FUNCTION setFetchOnOpen RETURNS LOGICAL
  ( pcFetchOnOpen AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose: Set whether a fetch should occur when the query is opened.                
Parameter: pcFetchOnOpen  -  
            Blank - don't do any fetch  
            First - run fetchFirst
            Last  - run FethcLast 
                    (not directly supported in the framework).       
            ?     - default         
    Notes: A stored value of undefined means use default (see getFetchOnOpen) 
------------------------------------------------------------------------------*/
  &SCOPED-DEFINE xpFetchOnOpen 
  {set FetchOnOpen pcFetchOnOpen}.
  &UNDEFINE xpFetchOnOpen 
  
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setFillBatchOnRepos) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setFillBatchOnRepos Procedure 
FUNCTION setFillBatchOnRepos RETURNS LOGICAL
  ( plFlag AS LOGICAL ) :
/*------------------------------------------------------------------------------
  Purpose:  Sets the flag on or off which indicates whether fetchRowIdent
            will fetch enough rows to fill a batch when repositioning to the 
            (or near the) end of a dataset
   Params:  plFlag AS LOGICAL  -- If true, the code will prompt.
------------------------------------------------------------------------------*/

  {set fillBatchOnRepos plFlag}.
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
  Purpose: Set a flag to indicate that filter is active.  
    Notes: the getFfilerActive also checks QueryColumns   
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
  IF cFilterWindow = '':U  OR cFilterWindow = ? THEN
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

&IF DEFINED(EXCLUDE-setFilterSource) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setFilterSource Procedure 
FUNCTION setFilterSource RETURNS LOGICAL
  ( phObject AS HANDLE ) :
/*------------------------------------------------------------------------------
  Purpose:  Sets the FilterSource link value.
   Params:  phObject AS HANDLE -- procedure handle of this object's FilterSource 
------------------------------------------------------------------------------*/

  {set FilterSource phObject}.
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

&IF DEFINED(EXCLUDE-setFirstRowNum) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setFirstRowNum Procedure 
FUNCTION setFirstRowNum RETURNS LOGICAL
  ( piRowNum AS INTEGER ) :
/*------------------------------------------------------------------------------
  Purpose:  sets the FirstRowNum property of the SDO.
   Params:  piRowNum AS INTEGER
    Notes:  
------------------------------------------------------------------------------*/

  {set FirstRowNum piRowNum}.
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
  Purpose:     Sets the Foreign Fields property of the object.
  
  Parameters: pcFields - comma-separated paired list of this objects db fields 
                         and the RowObject fields they map to in the parent.
      Notes:   In the case where the current ForeignFields already have been 
               used to add the key to the query, the fieldnames and the values 
               will be removed from the QueryString by this call.
------------------------------------------------------------------------------*/
  {fn removeForeignKey}.
  
  &SCOPED-DEFINE xpForeignFields
  {set ForeignFields pcFields}.
  &UNDEFINE xpForeignFields
  
  RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setForeignValues) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setForeignValues Procedure 
FUNCTION setForeignValues RETURNS LOGICAL
  ( pcValues AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose: Stores the ForeignValues 
    Notes: Internal use only, defined as function to be able to be set
           as part of context when join is done on server.
------------------------------------------------------------------------------*/
  {set ForeignValues pcValues }.
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setIgnoreTreeViewFilter) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setIgnoreTreeViewFilter Procedure 
FUNCTION setIgnoreTreeViewFilter RETURNS LOGICAL
  ( plIgnoreTreeViewFilter AS LOGICAL) :
/*------------------------------------------------------------------------------
  Purpose: Decides whether general filter criteria applied to a TreeView should 
           be applied to the data object. 
 Parameter: plIgnoreTreeViewFilter -         
            - TRUE  - overrides default behaviour and ignores the criteria.
            - FALSE - don't ignore filter
            - ? - (default) use the old noTreefilter check   
    Notes: This property supports the behaviour that previously was achieved by 
           adding an empty NoTreeFilter procedure stub to a static SDO. 
         - Data sources on TreeView nodes do not support the notion of 
           instances and instance attributes, so the property must typically be 
           defined at the master level.
------------------------------------------------------------------------------*/
  &SCOPED-DEFINE xpIgnoreTreeViewFilter
  {set IgnoreTreeViewFilter plIgnoreTreeViewFilter}.
  &UNDEFINE xpIgnoreTreeViewFilter
  
  RETURN TRUE.    

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setIndexInformation) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setIndexInformation Procedure 
FUNCTION setIndexInformation RETURNS LOGICAL
  (pcInfo AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose: Store the IndexInformation  
    Notes: See getIndexInformation 
------------------------------------------------------------------------------*/
  &SCOPED-DEFINE xpIndexInformation
  {set IndexInformation pcInfo}.
  &UNDEFINE xpIndexInformation
 
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setLargeColumns) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setLargeColumns Procedure 
FUNCTION setLargeColumns RETURNS LOGICAL
  ( pcLargeColumns AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose:    Sets the comma-delimited list of columns of large data-types
  Parameters: pcLargeColumns - comma-delimited list of column names
       Notes: Normally set from the first request to getLargeColumns   
------------------------------------------------------------------------------*/
  &SCOPED-DEFINE xpLargeColumns
  {set LargeColumns pcLargeColumns}.
  &UNDEFINE xpLargeColumns
  
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setLastRowNum) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setLastRowNum Procedure 
FUNCTION setLastRowNum RETURNS LOGICAL
  ( piLastRowNum AS INTEGER ) :
/*------------------------------------------------------------------------------
  Purpose: Sets the LastRowNum property in an SDO
   Params: piLastRowNum -- Rownum of the last row
    Notes:
------------------------------------------------------------------------------*/
  
  {set LastRowNum piLastRowNum}.
                              
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setNavigationSource) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setNavigationSource Procedure 
FUNCTION setNavigationSource RETURNS LOGICAL
  ( pcObject AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:     Sets the NavigationSource link value.
  
  Parameters:  
    pcObject - comma delimited string of the objects which should be made this 
               object's Navigation-Source.
------------------------------------------------------------------------------*/

  {set NavigationSource pcObject}.
  RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setOpenOnInit) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setOpenOnInit Procedure 
FUNCTION setOpenOnInit RETURNS LOGICAL
  ( plOpen AS LOGICAL ) :
/*------------------------------------------------------------------------------
  Purpose:     Sets the flag indicating whether the object's database query 
               should be opened automatically when the object is initialized -
               yes by default.
  
  Parameters:
    plOpen - True if the database query should be opened at initialization.
------------------------------------------------------------------------------*/

  {set OpenOnInit plOpen}.
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setPrimarySDOSource) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setPrimarySDOSource Procedure 
FUNCTION setPrimarySDOSource RETURNS LOGICAL
  ( phObject AS HANDLE ) :
/*------------------------------------------------------------------------------
  Purpose:  Sets the PrimarySDOSource link value.
   Params:  phObject AS HANDLE -- procedure handle of this object's PrimarySDOSource 
------------------------------------------------------------------------------*/

  {set PrimarySDOSource phObject}.
  RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setPromptColumns) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setPromptColumns Procedure 
FUNCTION setPromptColumns RETURNS LOGICAL
  (INPUT pcPromptColumns AS CHARACTER) :
/*------------------------------------------------------------------------------
  Purpose:  To set the a list of field values to display when prompted by
            a dialog box.  This is initially being used by confirmDelete
            in datavis.p
    Notes:  
    
          Values:
          '(NONE)'    - This is the default for security reasons.
          '(ALL)'     - All columns in the SDO.
          'fieldlist' - A comma delimited list of field names
          
    
------------------------------------------------------------------------------*/
  &SCOPED-DEFINE xpPromptColumns
  {set PromptColumns pcPromptColumns}.
  &UNDEFINE xpPromptColumns
  
  RETURN YES.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setPromptOnDelete) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setPromptOnDelete Procedure 
FUNCTION setPromptOnDelete RETURNS LOGICAL
  (INPUT plPrompt AS LOGICAL) :
/*------------------------------------------------------------------------------
  Purpose: Used to set whether or not the user is to be prompted 
           for a delete action to execute
    Notes:     
------------------------------------------------------------------------------*/
  {set PromptOnDelete plPrompt}.
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setQueryColumns) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setQueryColumns Procedure 
FUNCTION setQueryColumns RETURNS LOGICAL
  ( cQueryColumns AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  {set QueryColumns cQueryColumns}.
  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setQueryPosition) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setQueryPosition Procedure 
FUNCTION setQueryPosition RETURNS LOGICAL
  ( pcPosition AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:     Sets the Query Position property, and publishes an event to 
               tell others.
  
  Parameters:
    pcPosition - query position possible values are:
                 'FirstRecord', 'LastRecord', 'NotFirstOrLast' and 
                 'NoRecordAvailable'
------------------------------------------------------------------------------*/

    /* The property name does not have a property preprocessor
       to prevent it from being "set" directly, so that the event will 
       always be published, so the {set} syntax is not used. */

  &SCOPED-DEFINE xpQueryPosition
  {set QueryPosition pcPosition}.
  &UNDEFINE xpQueryPosition
  
  PUBLISH 'queryPosition':U FROM TARGET-PROCEDURE (pcPosition).
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setQuerySort) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setQuerySort Procedure 
FUNCTION setQuerySort RETURNS LOGICAL
  ( pcSort AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:     Sets or resets the sorting criteria (BY phrase) of the database
               query and stores the result in the QueryString property.
  Parameters:
    pcSort   - new sort (BY) clause.
             - [BY ] column [DESCENDING | TOGGLE ] [ BY ... ]  
             - TOGGLE sort option specifies that the column should be sorted
               opposite of the current sort. The option can be specified for 
               any column in the sort.      
             - Supports RowObject as qualifier to specify the sort with the 
               data object's column names.                    
  Notes:     - Use resetSort to apply sort criteria AND reopen the query if 
               it already is opened.
------------------------------------------------------------------------------*/
 DEFINE VARIABLE cQueryString      AS CHARACTER  NO-UNDO.

 {get QueryString cQueryString}.
 
 IF cQueryString = "":U THEN
   {get QueryStringDefault cQueryString}.

 cQueryString = DYNAMIC-FUNCTION('newQuerySort':U IN TARGET-PROCEDURE,
                                 cQueryString,
                                 pcSort).  
 IF cQueryString > '':U THEN
 DO:
   {set QueryString cQueryString}.
   RETURN TRUE. 
 END.
    
 RETURN FALSE.
    
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setQueryString) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setQueryString Procedure 
FUNCTION setQueryString RETURNS LOGICAL
  (pcQueryString AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose:     Sets the QueryString property used as working storage for the
               addQueryString, assignQuerySelection, removeQuerySelection, 
               setQueryWhere, setQuerySort etc.   
  Parameters:  pcQueryString - The string to store
        Note:  NEVER set this directly. It should only be maintained by other
               query manipulation methods.  
------------------------------------------------------------------------------*/
  {set QueryString pcQueryString}.
  RETURN TRUE. 
  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setRebuildOnRepos) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setRebuildOnRepos Procedure 
FUNCTION setRebuildOnRepos RETURNS LOGICAL
  ( plRebuild AS LOGICAL ) :
/*------------------------------------------------------------------------------
  Purpose:  Sets the Rebuild-On-Reposition flag
   Params:  plRebuild AS LOGICAL; if true, the RowObject temp-table will
            be rebuilt when a reposition is done which is outside the bounds
            of the current result set.
------------------------------------------------------------------------------*/
  {set RebuildOnRepos plRebuild}.
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setRowObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setRowObject Procedure 
FUNCTION setRowObject RETURNS LOGICAL
  ( phRowObject AS HANDLE ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  {set RowObject phRowObject}.
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
            there are uncommitted updates in the object. 
  Parameters: pcState - Can only be 'RowUpdated' OR 'NoUpdates'
    Notes:    When we get 'NoUpdates' and we have a Commit Panel; our 
              datasource have suppressed any 'UpdateComplete' events
              they have received until we are committed, so we send that
              updatestate event now.
            - As of current this might as well have been handled directly in 
              the rowObjectState event as we do not store the value. We would
              need to store it if we ever wanted to allow the UI to commit
              changes from several datasets though. We also need to store it 
              when/if we support no dataset TT based Dataviews.
------------------------------------------------------------------------------*/
  DEFINE VARIABLE lCommit AS LOG    NO-UNDO INIT ?.

  /* currently not needed, since we only support commit/submit across one 
     single entity 
  &SCOPED-DEFINE xpRowObjectState
  {set RowObjectState pcState}.
  &UNDEFINE xpRowObjectState
  */
  
  PUBLISH 'rowObjectState':U FROM TARGET-PROCEDURE (pcState).
  
  IF pcState = 'NoUpdates':U THEN
  DO:
    {get AutoCommit lCommit}.
    IF lCommit = NO THEN
      PUBLISH 'updateState':U FROM TARGET-PROCEDURE ('UpdateComplete':U).
  END.

  /* Tell container */ 
  PUBLISH 'UpdateActive':U FROM TARGET-PROCEDURE (pcState <> 'NoUpdates':U).

  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setRowsToBatch) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setRowsToBatch Procedure 
FUNCTION setRowsToBatch RETURNS LOGICAL
  ( piRows AS INTEGER ) :
/*------------------------------------------------------------------------------
  Purpose:     Sets the number of rows to be transferred from the database query
               into the RowObject temp-table at a time.
 
  Parameters:
    INPUT piRows - The desired number of RowObject records in a batch (default 
                   is 200)
  
  Notes:       Setting RowsToBatch to 0 indicates that ALL records should be 
               read.
------------------------------------------------------------------------------*/ 
  {set RowsToBatch piRows}.
  RETURN TRUE.
   
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setTables) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setTables Procedure 
FUNCTION setTables RETURNS LOGICAL
  ( pcTables AS CHAR) :
/*------------------------------------------------------------------------------
   Purpose: The Tables defines the object's view of data.    
     Notes: The names in the list references to the tables as defined in the
            object and referenced in the query, so each entry must be unique. 
  Dbaware (does not overrride, but uses tables differently)    
          - The names may be buffer names that differ from the actual physical 
            names.
          - The physical names is defined in the corresponding PhysicalTables 
            property.  
          - Qualified with database name if the query is defined with dbname.
          - From 9.1B this property is a design time property while it earlier 
            was resolved from the actual query.           
          - Several other properties have table delimiters and are depending of 
            the design time order of this property.              
          - The web2/webprop.i UNDEFINEs xpTables since it need to override 
            getTables()    
------------------------------------------------------------------------------*/
  {set Tables pcTables}.
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setToggleDataTargets) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setToggleDataTargets Procedure 
FUNCTION setToggleDataTargets RETURNS LOGICAL
  ( plToggleDataTargets AS LOGICAL ) :
/*------------------------------------------------------------------------------
  Purpose: Set to false if dataTargets should not be toggled on/of in 
           LinkStatebased based on the passed 'active' or 'inactive' parameter            
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE ltoggle AS LOGICAL    NO-UNDO.
  {set ToggleDataTargets plToggleDataTargets}.

  RETURN TRUE. 

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setTransferChildrenForAll) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setTransferChildrenForAll Procedure 
FUNCTION setTransferChildrenForAll RETURNS LOGICAL
  (plTransferChildrenForAll AS LOGICAL) :
/*------------------------------------------------------------------------------
  Purpose: This flag decides whether children for all records (of the batch) is 
           to be transferred from the database. 
    Notes: Currently only supported for read event handlers during a fetch. 
           The child SDO is only left with temp-table records for one parent 
           when the fetch*batch is finished.   
------------------------------------------------------------------------------*/
  {set TransferChildrenForAll plTransferChildrenForAll}.
  RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setUpdatableColumns) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setUpdatableColumns Procedure 
FUNCTION setUpdatableColumns RETURNS LOGICAL
  (pcColumns AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose:     Set the comma delimited list of the Updatable Columns for the
               DataView.
  Parameters:  pcColumns 
  ------------------------------------------------------------------------------*/
  {set UpdatableColumns pcColumns}.
  RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setUpdatableWhenNew) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setUpdatableWhenNew Procedure 
FUNCTION setUpdatableWhenNew RETURNS LOGICAL
  (pcUpdatableWhenNew AS CHARACTER) :
/*------------------------------------------------------------------------------
  Purpose: Set a list of fields that only are updatable when new.
    Notes: The fields must be UpdatableFields. 
           The datavisual class EnabledWhenNew uses this as default.
         - submitRow (-> submitValidate data.p) checks that no changes are saved
           for these columns unless the record is new. 
         - There is no particular behavior for these columns unless they 
           also are UpdatableColumns.    
------------------------------------------------------------------------------*/
  {set UpdatableWhenNew pcUpdatableWhenNew}.
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setUpdateSource) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setUpdateSource Procedure 
FUNCTION setUpdateSource RETURNS LOGICAL
  ( pcObject AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Sets the UpdateSource link value.
   Params:  phObject AS CHAR -- List of procedure handles of this object's 
                                UpdateSources
                                 
------------------------------------------------------------------------------*/
  {set UpdateSource pcObject}.
  RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-sortExpression) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION sortExpression Procedure 
FUNCTION sortExpression RETURNS CHARACTER
  ( pcQueryString AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose: Returns the sort expression of the passed querystring 
    Notes: Includes the first BY also (getQuerySort does not) and 
           removes extra spaces.
------------------------------------------------------------------------------*/
  DEFINE VARIABLE iByPos      AS INTEGER     NO-UNDO.
  DEFINE VARIABLE cExpression AS CHARACTER   NO-UNDO.
  DEFINE VARIABLE cTmpQuery   AS CHARACTER   NO-UNDO.
  /* We mask quoted strings to ensure the following BY keyword lookup
     only finds stuff in the expression(in lack of parsing) */ 
  cTmpQuery   = DYNAMIC-FUNCTION("maskQuotes":U IN TARGET-PROCEDURE,
                                  pcQueryString,'':U).
  /* Any BY ? */ 
  iByPos = INDEX(cTmpQuery + " ":U," BY ":U).
  IF iByPos > 0 THEN
  DO:
    /* Trim away blanks and period and remove indexed-reposition */
    cExpression = REPLACE(TRIM(SUBSTR(pcQueryString,iByPos)," .":U),
                          ' INDEXED-REPOSITION':U,
                          '':U).
    /* Remove extra blanks (this may be used to compare new and old 
       sort expression so it need to be consistent)*/
    DO WHILE INDEX(cExpression,'  ':U) > 0:
      cExpression = REPLACE(cExpression,'  ':U,' ':U).
    END.
  END.

  RETURN cExpression.

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
    Notes: Called from whichever is called first of getCLOB- -BLOB- or 
           -LargeColumns-  (lazy).      
           LargeDataColumns is not the sum of the other because:
          -  These properties returns the values in DataColumns order.                      
          -  LargeColumns could theoretically be set to also include other large
             columns independent of data type. 
          - PRIVATE   
------------------------------------------------------------------------------*/
    DEFINE VARIABLE cLargeColumns AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE cCLOBColumns  AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE cBLOBColumns  AS CHARACTER   NO-UNDO.
    
    DEFINE VARIABLE cDataColumns  AS CHARACTER   NO-UNDO.

    DEFINE VARIABLE hRowObject     AS HANDLE    NO-UNDO.
    DEFINE VARIABLE iColumn        AS INTEGER   NO-UNDO.
    DEFINE VARIABLE cColumn        AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cColumnRef     AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cBuffer        AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cDataType      AS CHARACTER NO-UNDO.
    DEFINE VARIABLE lHasLobs       AS LOGICAL   NO-UNDO.
    
    &SCOPED-DEFINE xp-assign
    {get DataColumns cDataColumns}
    {get RowObject hRowObject}
    &UNDEFINE xp-assign
    
    lHasLobs = TRUE.
    
    /* Set to blank in storage when no large columns */
    IF VALID-HANDLE(hRowObject) AND NOT hRowObject:HAS-LOBS 
    AND INDEX(cDataColumns,'.') = 0 THEN
      lHasLobs = FALSE. 
    
    IF lHasLobs THEN 
    DO:
      DO iColumn = 1 TO NUM-ENTRIES(cDataColumns):  
        ASSIGN 
          cDataType = ''
          cColumnRef = ENTRY(iColumn,cDataColumns).
        
        IF VALID-HANDLE(hRowObject) THEN 
        DO:
          IF NUM-ENTRIES(cColumnRef,'.':U) = 2 THEN
            ASSIGN
              cBuffer = ENTRY(1,cColumnRef,'.')
              cColumn = ENTRY(2,cColumnRef,'.').
          ELSE 
            ASSIGN
              cBuffer = ''
              cColumn = cColumnRef.

           IF (cBuffer = '' OR cBuffer = hRowObject:NAME) THEN
             cDataType = hRowobject:BUFFER-FIELD(cColumn):DATA-TYPE. 
        END.

        /* We avoid calling the function for performance, unless the rowobject 
           is not valid (called before the first data request...) or 
           the column is not in rowobject.
           The dataview class will check if viewtables in the dataset
           The data class function will do an appserver call if not able to resolve 
           the request on the client!  */ 
        IF cDataType = '' THEN
          cDataType = {fnarg columnDataType cColumnRef}.
  
        IF CAN-DO('CLOB,BLOB':U,cDataType) THEN
        DO:
          cLargeColumns = cLargeColumns + ',' + cColumnRef.
          CASE cDataType:
            WHEN 'CLOB':U THEN
              cCLOBColumns  = cCLOBColumns + ',' + cColumnRef.
            WHEN 'BLOB':U THEN
              cBLOBColumns  = cBLOBColumns + ',' + cColumnRef.
          END CASE.
        END. /* clob or blob */
      END. /* do iColumn = 1 */
      
      ASSIGN
        cLargeColumns = LEFT-TRIM(cLargeColumns,',':U)
        cCLOBColumns  = LEFT-TRIM(cCLOBColumns,',':U)
        cBLOBColumns  = LEFT-TRIM(cBLOBColumns,',':U).
    END. /* lhaslobs (may) */

    &SCOPED-DEFINE xp-assign 
    
        /* This is normally not allowed outside of the setfunction,    
       R&D Mode... 
       These are considered READ-ONLY, so there is no set functions, but for 
       performance reasons we do want to store them. (By not defining the xp 
       in the prop file they are safe from being changed by the set include. */ 
    &SCOPED-DEFINE xpCLOBColumns
    &SCOPED-DEFINE xpBLOBColumns
       
    /* Store the result (also blank), for future requests */  
    {set LargeColumns cLargeColumns}

    {set CLOBColumns  cCLOBColumns}
    {set BLOBColumns  cBLOBColumns}.
    
    &UNDEFINE xpBLOBColumns
    &UNDEFINE xpCLOBColumns
 
    &UNDEFINE xp-assign
    
   RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

