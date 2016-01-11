&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation ("PSC"),       *
* 14 Oak Park, Bedford, MA 01730, and other contributors as listed   *
* below.  All Rights Reserved.                                       *
*                                                                    *
* The Initial Developer of the Original Code is PSC.  The Original   *
* Code is Progress IDE code released to open source December 1, 2000.*
*                                                                    *
* The contents of this file are subject to the Possenet Public       *
* License Version 1.0 (the "License"); you may not use this file     *
* except in compliance with the License.  A copy of the License is   *
* available as of the date of this notice at                         *
* http://www.possenet.org/license.html                               *
*                                                                    *
* Software distributed under the License is distributed on an "AS IS"*
* basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. You*
* should refer to the License for the specific language governing    *
* rights and limitations under the License.                          *
*                                                                    *
* Contributors:                                                      *
*                                                                    *
*********************************************************************/
/*--------------------------------------------------------------------------
    File        : queryext.p
   Purpose     : Support procedure for Query Object.  This is an extension
                 of query.p.  The extension is necessary to avoid an overflow
                 of the action segment on AS400. This extension file contains
                 all of the get and set property functions. These functions 
                 will be rolled back into query.p when segment size increases.

    Syntax      : adm2/query.p

    Modified    : Jan 22, 2001 Version 9.1C
    Modified    : 10/24/2001          Mark Davied (MIP)
                  Added new property FilterAvailable and it's get and set
                  functions.
    Modified    : 02/27/2002          Gikas A. Gikas
                  Incidental bug fixed while working on IZ 4050
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
  /* Tell qryprop.i that this is the query super procedure. */
&SCOP ADMSuper query.p

{src/adm2/custom/queryexclcustom.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-getAssignList) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getAssignList Procedure 
FUNCTION getAssignList RETURNS CHARACTER
  (   )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getAuditEnabled) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getAuditEnabled Procedure 
FUNCTION getAuditEnabled RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getBaseQuery) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getBaseQuery Procedure 
FUNCTION getBaseQuery RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

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

&IF DEFINED(EXCLUDE-getCalcFieldList) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getCalcFieldList Procedure 
FUNCTION getCalcFieldList RETURNS CHARACTER
  (   )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getCalculatedColumns) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getCalculatedColumns Procedure 
FUNCTION getCalculatedColumns RETURNS CHARACTER
  ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getCheckLastOnOpen) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getCheckLastOnOpen Procedure 
FUNCTION getCheckLastOnOpen RETURNS LOGICAL
 (  )  FORWARD.

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

&IF DEFINED(EXCLUDE-getDataColumns) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getDataColumns Procedure 
FUNCTION getDataColumns RETURNS CHARACTER
  ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDataColumnsByTable) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getDataColumnsByTable Procedure 
FUNCTION getDataColumnsByTable RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

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

&IF DEFINED(EXCLUDE-getDBNames) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getDBNames Procedure 
FUNCTION getDBNames RETURNS CHARACTER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getEnabledTables) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getEnabledTables Procedure 
FUNCTION getEnabledTables RETURNS CHARACTER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getEntityFields) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getEntityFields Procedure 
FUNCTION getEntityFields RETURNS CHARACTER
  ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getFetchAutoComment) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getFetchAutoComment Procedure 
FUNCTION getFetchAutoComment RETURNS LOGICAL
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getFetchHasAudit) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getFetchHasAudit Procedure 
FUNCTION getFetchHasAudit RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getFetchHasComment) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getFetchHasComment Procedure 
FUNCTION getFetchHasComment RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

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

&IF DEFINED(EXCLUDE-getFirstResultRow) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getFirstResultRow Procedure 
FUNCTION getFirstResultRow RETURNS CHARACTER
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

&IF DEFINED(EXCLUDE-getLabel) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getLabel Procedure 
FUNCTION getLabel RETURNS CHARACTER
  (  )  FORWARD.

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

&IF DEFINED(EXCLUDE-getLastResultRow) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getLastResultRow Procedure 
FUNCTION getLastResultRow RETURNS CHARACTER
  (  )  FORWARD.

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

&IF DEFINED(EXCLUDE-getNewBatchInfo) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getNewBatchInfo Procedure 
FUNCTION getNewBatchInfo RETURNS CHARACTER
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

&IF DEFINED(EXCLUDE-getOpenQuery) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getOpenQuery Procedure 
FUNCTION getOpenQuery RETURNS CHARACTER
  ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getPhysicalTables) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getPhysicalTables Procedure 
FUNCTION getPhysicalTables RETURNS CHARACTER
       () FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getPositionForClient) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getPositionForClient Procedure 
FUNCTION getPositionForClient RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

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

&IF DEFINED(EXCLUDE-getQueryString) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getQueryString Procedure 
FUNCTION getQueryString RETURNS CHARACTER
  ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getQueryWhere) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getQueryWhere Procedure 
FUNCTION getQueryWhere RETURNS CHARACTER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getRequiredProperties) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getRequiredProperties Procedure 
FUNCTION getRequiredProperties RETURNS CHARACTER
  ( )  FORWARD.

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

&IF DEFINED(EXCLUDE-getTempTables) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getTempTables Procedure 
FUNCTION getTempTables RETURNS CHARACTER
  (  )  FORWARD.

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

&IF DEFINED(EXCLUDE-getUpdatableColumnsByTable) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getUpdatableColumnsByTable Procedure 
FUNCTION getUpdatableColumnsByTable RETURNS CHARACTER
  ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getUpdateFromSource) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getUpdateFromSource Procedure 
FUNCTION getUpdateFromSource RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getUseDBQualifier) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getUseDBQualifier Procedure 
FUNCTION getUseDBQualifier RETURNS LOGICAL
 (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getWordIndexedFields) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getWordIndexedFields Procedure 
FUNCTION getWordIndexedFields RETURNS CHARACTER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setAssignList) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setAssignList Procedure 
FUNCTION setAssignList RETURNS LOGICAL
  ( pcList AS CHAR   )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setAuditEnabled) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setAuditEnabled Procedure 
FUNCTION setAuditEnabled RETURNS LOGICAL
  ( lAuditEnabled AS LOGICAL )  FORWARD.

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

&IF DEFINED(EXCLUDE-setBaseQuery) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setBaseQuery Procedure 
FUNCTION setBaseQuery RETURNS LOGICAL
  ( pcBaseQuery AS CHARACTER)  FORWARD.

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

&IF DEFINED(EXCLUDE-setCalcFieldList) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setCalcFieldList Procedure 
FUNCTION setCalcFieldList RETURNS LOGICAL
  ( pcList AS CHAR   )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setCheckLastOnOpen) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setCheckLastOnOpen Procedure 
FUNCTION setCheckLastOnOpen RETURNS LOGICAL
 (pCheck AS LOGICAL)  FORWARD.

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

&IF DEFINED(EXCLUDE-setDataColumnsByTable) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setDataColumnsByTable Procedure 
FUNCTION setDataColumnsByTable RETURNS LOGICAL
  ( pcColumns AS CHAR )  FORWARD.

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

&IF DEFINED(EXCLUDE-setDBNames) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setDBNames Procedure 
FUNCTION setDBNames RETURNS LOGICAL
  (pcDBNames AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setEntityFields) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setEntityFields Procedure 
FUNCTION setEntityFields RETURNS LOGICAL
  ( cEntityFields AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setFetchAutoComment) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setFetchAutoComment Procedure 
FUNCTION setFetchAutoComment RETURNS LOGICAL
  ( plFetchAutoComment AS LOGICAL )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setFetchHasAudit) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setFetchHasAudit Procedure 
FUNCTION setFetchHasAudit RETURNS LOGICAL
  ( plFetchHasAudit AS LOGICAL )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setFetchHasComment) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setFetchHasComment Procedure 
FUNCTION setFetchHasComment RETURNS LOGICAL
  ( plFetchHasComment AS LOGICAL )  FORWARD.

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

&IF DEFINED(EXCLUDE-setFirstResultRow) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setFirstResultRow Procedure 
FUNCTION setFirstResultRow RETURNS LOGICAL
  ( pcFirstResultRow AS CHARACTER )  FORWARD.

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

&IF DEFINED(EXCLUDE-setKeyFields) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setKeyFields Procedure 
FUNCTION setKeyFields RETURNS LOGICAL
  ( pcKeyFields AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setKeyTableId) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setKeyTableId Procedure 
FUNCTION setKeyTableId RETURNS LOGICAL
  ( pcKeyTableId AS CHARACTER )  FORWARD.

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

&IF DEFINED(EXCLUDE-setLastResultRow) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setLastResultRow Procedure 
FUNCTION setLastResultRow RETURNS LOGICAL
  ( pcLastResultRow AS CHARACTER )  FORWARD.

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

&IF DEFINED(EXCLUDE-setNewBatchInfo) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setNewBatchInfo Procedure 
FUNCTION setNewBatchInfo RETURNS LOGICAL
  ( pcNewBatchInfo AS CHAR )  FORWARD.

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

&IF DEFINED(EXCLUDE-setOpenQuery) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setOpenQuery Procedure 
FUNCTION setOpenQuery RETURNS LOGICAL
  (pcQuery AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setPhysicalTables) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setPhysicalTables Procedure 
FUNCTION setPhysicalTables RETURNS LOGICAL
  ( pcPhysicalTables AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setPositionForClient) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setPositionForClient Procedure 
FUNCTION setPositionForClient RETURNS LOGICAL
  ( pcPositionForClient AS CHARACTER)  FORWARD.

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

&IF DEFINED(EXCLUDE-setQueryWhere) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setQueryWhere Procedure 
FUNCTION setQueryWhere RETURNS LOGICAL
  ( pcWhere AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setRequiredProperties) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setRequiredProperties Procedure 
FUNCTION setRequiredProperties RETURNS LOGICAL
  ( pcProperties AS CHAR )  FORWARD.

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

&IF DEFINED(EXCLUDE-setTempTables) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setTempTables Procedure 
FUNCTION setTempTables RETURNS LOGICAL
  ( pcTempTables AS CHAR )  FORWARD.

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

&IF DEFINED(EXCLUDE-setUpdatableColumnsByTable) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setUpdatableColumnsByTable Procedure 
FUNCTION setUpdatableColumnsByTable RETURNS LOGICAL
  ( pcColumns AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setUpdateFromSource) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setUpdateFromSource Procedure 
FUNCTION setUpdateFromSource RETURNS LOGICAL
  ( plUpdateFromSource AS LOGICAL )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-updateLargeColumns) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD updateLargeColumns Procedure 
FUNCTION updateLargeColumns RETURNS LOGICAL PRIVATE
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
         HEIGHT             = 17.57
         WIDTH              = 51.4.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB Procedure 
/* ************************* Included-Libraries *********************** */

{src/adm2/qryprop.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-getAssignList) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getAssignList Procedure 
FUNCTION getAssignList RETURNS CHARACTER
  (   ) :
/*------------------------------------------------------------------------------
  Purpose:    Returns the list of updatable columns whose names have been 
              modified in the SmartDataObject.

  Parameters: <none>

  Notes:      This string is of the form:
              <RowObjectFieldName>,<DBFieldName>[,...][{&adm-tabledelimiter}...]
              with a comma separated list of pairs of fields for each db table,
              and {&adm-tabledelimiter} between the lists of pairs.
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cList AS CHARACTER NO-UNDO.  
  {get AssignList cList}.
  RETURN cList.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getAuditEnabled) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getAuditEnabled Procedure 
FUNCTION getAuditEnabled RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns auditEnabled property value
    Notes:  
------------------------------------------------------------------------------*/
    DEFINE VARIABLE lAuditEnabled AS LOGICAL NO-UNDO.    
    {get AuditEnabled lAuditEnabled}.    
    RETURN lAuditEnabled.
  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getBaseQuery) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getBaseQuery Procedure 
FUNCTION getBaseQuery RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose: Returns the base query property 
    Notes: This is used internally by openQuery, and directly on client context 
           management. Because setOpenQuery also setOpenQuery and wipes out 
           all other query data it cannot be used when setting this when
           received from server  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cBaseQuery AS CHARACTER  NO-UNDO.
  {get BaseQuery cBaseQuery}.
  RETURN cBaseQuery.

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
                     
  &SCOPED-DEFINE xpBufferHandles 
  {get BufferHandles cBufferHandles}.
  &UNDEFINE xpbufferHandles 
  
  RETURN cBufferHandles.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getCalcFieldList) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getCalcFieldList Procedure 
FUNCTION getCalcFieldList RETURNS CHARACTER
  (   ) :
/*------------------------------------------------------------------------------
  Purpose:    ACCESS_LEVEL=PRIVATE
              Returns CalcFieldList which is a comma-separated list of 
              calculated field instance names and their master object names.  
              This is for use by the AppBuilder at design time and should 
              not be used by application code.
              
  Parameters: <none>

  Notes:      Value format:

              <InstaneName>,<MasterName>,...

------------------------------------------------------------------------------*/
  DEFINE VARIABLE cList AS CHARACTER NO-UNDO.  
  {get CalcFieldList cList}.
  RETURN cList.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getCalculatedColumns) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getCalculatedColumns Procedure 
FUNCTION getCalculatedColumns RETURNS CHARACTER
  ( ) :
/*------------------------------------------------------------------------------
  Purpose:     Returns a comma-delimited list of the calculated columns for the 
               SmartDataObject. 
  Parameters:  
       Notes:  Uses the DataColumsByTable property that stores fields for 
               different tables delimited by {&adm-tabledelimiter} where the last entry may be 
               calculated fields
  preprocessor - adm-tabledelimiter - defaults to ';'       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cColumns   AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cTables    AS CHARACTER  NO-UNDO.

  &SCOPED-DEFINE xp-assign
  {get DataColumnsByTable cColumns}
  {get Tables cTables}
  .   
  &UNDEFINE xp-assign

  IF NUM-ENTRIES(cColumns,{&adm-tabledelimiter}) > NUM-ENTRIES(cTables) THEN
    cColumns = ENTRY(NUM-ENTRIES(cTables)+ 1,cColumns,{&adm-tabledelimiter}).  
  ELSE 
    cColumns = "":U.

  RETURN cColumns. 

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getCheckLastOnOpen) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getCheckLastOnOpen Procedure 
FUNCTION getCheckLastOnOpen RETURNS LOGICAL
 (  ) :
/*------------------------------------------------------------------------------
  Purpose:    Returns the flag indicating whether a get-last should be performed 
              on an open in order for fetchNext to be able to detect that we are 
              on the last row. This is necessary to make the QueryPosition 
              attribute reliable.   

  Parameters: <none>
------------------------------------------------------------------------------*/
  DEFINE VARIABLE lCheck AS LOGICAL NO-UNDO.
  {get CheckLastOnOpen lCheck}.
  RETURN lCheck.

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

&IF DEFINED(EXCLUDE-getDataColumnsByTable) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getDataColumnsByTable Procedure 
FUNCTION getDataColumnsByTable RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:     Returns a comma-delimited list of the columnNames delimited 
               by {&adm-tabledelimiter} to identify which columns are from 
               which table 
  Parameters:  
       Notes:  Use DataColums to get a comma separated list        
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cColumns AS CHARACTER NO-UNDO.
  {get DataColumnsByTable cColumns}.
  
  RETURN cColumns.

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
    Notes: Duplicated in sboext 
Note Date: 2002/04/14     
------------------------------------------------------------------------------*/
  DEFINE VARIABLE lFetched AS LOGICAL    NO-UNDO.
  {get DataIsFetched lFetched}.

  RETURN lFetched.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDBNames) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getDBNames Procedure 
FUNCTION getDBNames RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
   Purpose:  Returns a comma delimited list of DBNames that corresponds 
             to the Tables in the Query Objects
Parameters:  <none>
     Notes: This does not have an xpTables preprocessor because getDBNames
            is overridden in data.p.   
------------------------------------------------------------------------------*/
DEFINE VARIABLE cNames AS CHARACTER  NO-UNDO.

  &SCOPED-DEFINE xpDBNames
  {get DBNames cNames}.
  &UNDEFINE xpDBNames
  
  RETURN cNames.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getEnabledTables) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getEnabledTables Procedure 
FUNCTION getEnabledTables RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns a list of the database tables which have enabled fields.
   Params:  <none>
    Notes:    
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cTables        AS CHAR  NO-UNDO.
  DEFINE VARIABLE cEnabledTables AS CHAR  NO-UNDO.
  DEFINE VARIABLE cUpdColumns    AS CHAR  NO-UNDO.
  DEFINE VARIABLE iVar           AS INT    NO-UNDO.
  
  {get Tables cTables}.
  
  /* get the list of enabled fields that are separated per table and
     use it to check which tables have enabled tables */
  {get UpdatableColumnsByTable cUpdColumns}.

  DO iVar = 1 TO NUM-ENTRIES(cTables):
    IF ENTRY(iVar,cUpdColumns,{&adm-tabledelimiter}) <> "":U THEN
      cEnabledTables = cEnabledTables 
                      + (IF cEnabledTables = "":U THEN "":U ELSE ",":U)
                      + ENTRY(iVar, cTables).
  END.

  RETURN cEnabledTables. 
  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getEntityFields) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getEntityFields Procedure 
FUNCTION getEntityFields RETURNS CHARACTER
  ( ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cEntityFields AS CHARACTER  NO-UNDO.
  {get EntityFields cEntityFields}.
  RETURN cEntityFields.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getFetchAutoComment) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getFetchAutoComment Procedure 
FUNCTION getFetchAutoComment RETURNS LOGICAL
  (  ) :
/*------------------------------------------------------------------------------
  Purpose: Set to true if auto comments should be retrieved with the 
           data. 
    Notes: This is used in transferRows and transferDbRow.
        -  These comments will be automatically displayed by visual objects and
           will be set to true by the visual object's LinkStateHandler if the 
           property value is unknown.
------------------------------------------------------------------------------*/
  DEFINE VARIABLE lFetchAutoComment AS LOGICAL    NO-UNDO.
  {get FetchAutoComment lFetchAutoComment}.
  RETURN lFetchAutoComment.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getFetchHasAudit) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getFetchHasAudit Procedure 
FUNCTION getFetchHasAudit RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose: Returns true if Audit exists flag should be retrieved with the data 
    Notes: This is used in transferRows and transferDbRow 
------------------------------------------------------------------------------*/
  DEFINE VARIABLE lFetchHasAudit AS LOGICAL NO-UNDO.
  {get FetchHasAudit lFetchHasAudit}.
  RETURN lFetchHasAudit.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getFetchHasComment) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getFetchHasComment Procedure 
FUNCTION getFetchHasComment RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose: Returns true if 'comments exists' flag should be retrieved with the 
           data. 
    Notes: This is used in transferRows and transferDbRow 
------------------------------------------------------------------------------*/
  DEFINE VARIABLE lFetchHasComment AS LOGICAL  NO-UNDO.
  {get FetchHasComment lFetchHasComment}.
  RETURN lFetchHasComment.

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
         - Unknown value indicates default which is blank on 'server' and
           'first' otherwise.
         - This is a replacement of the return that used to be in data.p 
           fetchFirst. The blank gives the same effect as it prevents 
           openQuery from calling fetchFirst.
             
Note Date: 2002/4/11             
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cFetchOnOpen  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cAsDivision   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lQueryCont    AS LOGICAL    NO-UNDO.
  
  &SCOPED-DEFINE xpFetchOnOpen 
  {get FetchOnOpen cFetchOnOpen}.
  &UNDEFINE xpFetchOnOpen 
  
  IF cFetchOnOpen = ? THEN
  DO:
    /* If inside an sbo we want openQuery to fetchfirst (as always), 
       so we do notneed ot chekc for the division */ 
    {get QueryContainer lQueryCont} NO-ERROR.
    IF NOT (lQueryCont EQ YES) THEN
    DO:
      {get AsDivision cAsDivision}.
      IF cAsDivision = 'Server':U THEN
         cFetchOnOpen = '':U.
    END.
    
    IF cFetchOnOpen = ? THEN
       cFetchOnOpen = 'First':U.
  END.

  RETURN cFetchOnOpen.

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

&IF DEFINED(EXCLUDE-getFirstResultRow) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getFirstResultRow Procedure 
FUNCTION getFirstResultRow RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the FirstResultRow (unknown if first row hasn't been
            fetched, 1 concatinated with the rowid if it has.)
    Notes:  
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cFirstResultRow AS CHARACTER NO-UNDO.
  {get FirstResultRow cFirstResultRow}.
  RETURN cFirstResultRow.

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

  DEFINE VARIABLE cValues AS CHARACTER NO-UNDO.
  {get ForeignValues cValues}.
  RETURN cValues.

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
   Params:  The indexInformation will be used to try to figure out the
            default KeyFields list, but this is currently restricted to cases 
            where: 
            - The First Table in the join is the Only enabled table.
            - All the fields of the index is present is the SDO.             
            The following index may be selected.                 
                     
            1. Primary index if unique.
            2. First Unique index. 
            
            There's currently no check whether the field is mandatory.                                      
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cKeyFields     AS CHAR  NO-UNDO.
  DEFINE VARIABLE cIndexInfo     AS CHAR  NO-UNDO.
  DEFINE VARIABLE cEnabledTables AS CHAR  NO-UNDO.
  DEFINE VARIABLE cTables        AS CHAR  NO-UNDO.
  DEFINE VARIABLE cUniqueList    AS CHAR  NO-UNDO.
  DEFINE VARIABLE cPrimaryList   AS CHAR  NO-UNDO.
  DEFINE VARIABLE cColumnList    AS CHAR  NO-UNDO.
  DEFINE VARIABLE iIDx           AS INT   NO-UNDO.
  
  /* temorary define the xp so we can go directly to the property buffer */
  &SCOPED-DEFINE xpKeyFields 
  {get KeyFields cKeyFields}.
  &UNDEFINE xpKeyFields 

  IF cKeyFields = "":U THEN
  DO:
    &SCOPED-DEFINE xp-assign
    {get EnabledTables cEnabledTables}
    {get Tables cTables}.
    &UNDEFINE xp-assign
    
    /* Currently we only create a default KeyFields when omly one table
       or ONE enabled table and it's the FIRST table  */
    IF NUM-ENTRIES(cTables) = 1 
    OR NUM-ENTRIES(cEnabledTables) = 1 AND cEnabledTables = ENTRY(1,cTables) THEN
    DO:
      {get IndexInformation cIndexInfo}.
      
      /* check again.... it may have been passed from the server together 
         with IndexInformation...  */
      &SCOPED-DEFINE xpKeyFields 
      {get KeyFields cKeyFields}.
      &UNDEFINE xpKeyFields 

      IF cIndexInfo <> ? AND cKeyFields = '':U THEN
      DO:
        ASSIGN
          /* Get the unique indexes from the IndexInformation function */
          cUniqueList  = DYNAMIC-FUNCTION('indexInformation' IN TARGET-PROCEDURE,
                                          'unique':U, /* query  */
                                          'yes':U,     /* table delimiter */
                                          cIndexInfo)
          /* only the first table's indexes*/ 
          cUniqueList = ENTRY(1,cUniqueList,CHR(2))
      
          /* Get the primary index(es) from the IndexInformation function */
          cPrimaryList = DYNAMIC-FUNCTION('indexInformation' IN TARGET-PROCEDURE,
                                          'primary':U, /* query  */
                                          'yes':U,     /* table delimiter */
                                          cIndexInfo)
        
          /* only the first table's indexes*/ 
          cPrimaryList = ENTRY(1,cPrimaryList,CHR(2))
          .

        /* if the primary index is unique and all fields in SDO 
          (fields not in the SDO is qualifed ) */
        IF LOOKUP(cPrimaryList,cUniqueList,CHR(1)) > 0 
        AND INDEX(cPrimaryList,'.':U) = 0 THEN
          cKeyFields = cPrimaryList.
        ELSE /* find the first unique index with all fields in SDO */  
        DO iIdx = 1 TO NUM-ENTRIES(cUniqueList,CHR(1)):
          cColumnList = ENTRY(iIdx,cUniquelist,CHR(1)).
          IF INDEX(cColumnList,'.':U) = 0 THEN
          DO:
            cKeyFields = cColumnList.
            LEAVE.
          END.
        END. /* do i = 1 to num-entries cUniqueList */
        IF cKeyFields > '' THEN
          {set KeyFields cKeyFields}.
      END. /* if indexinfo <> */
    END. /* cinfo <> ? */
  END. /* KeyFields = '' */

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

&IF DEFINED(EXCLUDE-getLabel) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getLabel Procedure 
FUNCTION getLabel RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose: Returns the LABEL defined for the Dataobject   
    Notes: Null ? implies label is not set, so get the first enabled table
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cLabel          AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cEnabledTables  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cTables         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cPhysicalTables AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iPos            AS INTEGER    NO-UNDO.

  &SCOPED-DEFINE xpLabel
  {get Label cLabel}.
  &UNDEFINE xpLabel
  
  IF cLabel = ? THEN 
  DO:
    &SCOPED-DEFINE xp-assign
    {get EnabledTables cEnabledTables}
    {get Tables cTables}
    {get PhysicalTables cPhysicalTables}
    .
    &UNDEFINE xp-assign
    
    IF cEnabledTables > '':U THEN
      iPos = LOOKUP(ENTRY(1,cEnabledTables),cTables).
    ELSE 
      iPos = 1.

    IF iPos > 0 THEN 
    DO:
      ASSIGN
        cLabel = ENTRY(iPos,cPhysicalTables).
       
      /* capitalize unless ugly name */
      IF INDEX(cLabel,'_':U) = 0 AND INDEX(cLabel,'-':U) = 0 AND LENGTH(cLabel) > 1 THEN
        cLabel = CAPS(SUBSTR(cLabel,1,1)) + LC(SUBSTR(cLabel,2)) NO-ERROR.

      IF cLabel <> '':U THEN
        {set LABEL cLabel}.
    END.

    IF cLabel = '':U OR cLabel = ? THEN
      cLabel = SUPER().

  END.

  RETURN cLabel.

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

&IF DEFINED(EXCLUDE-getLastResultRow) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getLastResultRow Procedure 
FUNCTION getLastResultRow RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the LastResultRow (unknown if last row hasn't been
            fetched, RowNum concatinated with the rowid if it has.)
    Notes:  
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cLastResultRow AS CHARACTER NO-UNDO.
  {get LastResultRow cLastResultRow}.
  RETURN cLastResultRow.

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

&IF DEFINED(EXCLUDE-getNewBatchInfo) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getNewBatchInfo Procedure 
FUNCTION getNewBatchInfo RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns a RowNum relationship defining the RowObject records of the
            last batch retrieved.
    Notes:  i.e. RowNum > '100' 
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cValue AS CHARACTER NO-UNDO.
  {get NewBatchInfo cValue}.
  RETURN cValue.

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

&IF DEFINED(EXCLUDE-getOpenQuery) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getOpenQuery Procedure 
FUNCTION getOpenQuery RETURNS CHARACTER
  ( ) :
/*------------------------------------------------------------------------------
  Purpose:    Returns the OPEN-QUERY preprocessor value, to allow it to be
              manipulated by setQueryWhere, for example
  Parameters: <none>  
  Notes:      This is important because no matter how the query is dynamically
              modified, it can be reset to its original state using this return
              value in a QUERY-PREPARE method.
            - getOpenQuery is called from the client on AppServer, so we are not
              using the xp preprocessor.
            - The actual value is stored in BaseQuery.. After the improvements
              to make the Appserver use one hit perrequest setOpenQuery cannot
              be used to store server context on the client, since it may be 
              returned AFTER the query has been changed and wipe out all query 
              data because it calls setQueryWhere('').    
------------------------------------------------------------------------------*/  
  DEFINE VARIABLE cQuery AS CHARACTER  NO-UNDO.
  
  {get BaseQuery cQuery}.
        
  RETURN cQuery.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getPhysicalTables) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getPhysicalTables Procedure 
FUNCTION getPhysicalTables RETURNS CHARACTER
       ():
/*------------------------------------------------------------------------------
   Purpose: Get the Physical names that corresponsd to the Tables that is used 
            to build the BaseQuery.  
     Notes: The names used in the query is defined in the corresponding Tables 
            property.  
          - Qualified with database name if the query is defined with dbname.
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cPhysicalTables AS CHARACTER  NO-UNDO.
  {get PhysicalTables cPhysicalTables}.
  RETURN cPhysicalTables.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getPositionForClient) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getPositionForClient Procedure 
FUNCTION getPositionForClient RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose: This property is set on the server and returned to the client so that
           it is able to position correctly in the new batch of data. The client
           need this information under certain cicumstances, for example when 
           other settings decides that a full batch of data always is needed. 
    Notes: set on server, used in clientSendRows only  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cPositionForClient AS CHARACTER  NO-UNDO.
    
  {get PositionForClient cPositionForClient}.

  RETURN cPositionForClient.

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
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:    Returns the handle of the database query.

  Parameters: <none>
------------------------------------------------------------------------------*/

  DEFINE VARIABLE hQuery AS HANDLE NO-UNDO.
  {get QueryHandle hQuery}.
  RETURN hQuery.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getQueryOpen) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getQueryOpen Procedure 
FUNCTION getQueryOpen RETURNS LOGICAL
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:     Returns TRUE if the Query Object's database query is currently 
               open.

  Parameters:  <none>
------------------------------------------------------------------------------*/
    
  DEFINE VARIABLE hQuery AS HANDLE NO-UNDO.
  
  {get QueryHandle hQuery}.
  RETURN IF NOT VALID-HANDLE(hQuery) THEN
      NO ELSE hQuery:IS-OPEN.   

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
                 FirstRecord, LastRecord, NotFirstOrLast or NoRecordAvailable
------------------------------------------------------------------------------*/

  /* The property does not have a field preprocessor to prevent it from being
     "set" directly, because it must also publish an event. So the code below
     must not use the {get} syntax. */

  DEFINE VARIABLE cPosition AS CHARACTER NO-UNDO.

  &SCOPED-DEFINE xpQueryPosition
  {get QueryPosition cPosition}.
  &UNDEFINE xpQueryPosition
  
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

  /* If not use the actual query */ 
  IF cQueryText = "":U THEN 
    {get QueryWhere cQueryText}.
  
  /* If not found so far use the designed query */ 
  IF cQueryText = "":U THEN 
    {get OpenQuery cQueryText}.
  
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

&IF DEFINED(EXCLUDE-getQueryWhere) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getQueryWhere Procedure 
FUNCTION getQueryWhere RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:     Returns the current where-clause for the database query.
               Returns ? if the query handle is undefined.

  Parameters:  <none>
------------------------------------------------------------------------------*/    
  DEFINE VARIABLE hQuery AS HANDLE NO-UNDO.
  {get QueryHandle hQuery}.
  
  RETURN IF VALID-HANDLE(hQuery) 
         THEN hQuery:PREPARE-STRING
         ELSE ?.  
  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getRequiredProperties) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getRequiredProperties Procedure 
FUNCTION getRequiredProperties RETURNS CHARACTER
  ( ) :
/*------------------------------------------------------------------------------
  Purpose: Gets the list of required properties   
    Notes: Currently used to identify the properties required to start a 
           dynamic data object             
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cRequiredProperties AS CHARACTER  NO-UNDO.
  {get RequiredProperties cRequiredProperties}.
  RETURN cRequiredProperties.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getTables) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getTables Procedure 
FUNCTION getTables RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
   Purpose:  Returns a comma delimited list of tables in the Query Objects
Parameters:  <none>
     Notes: The names in the list references to the tables as defined in the
            dataobject and referenced in the query, so each entry must be unique. 
            This means that the names may be buffer names that differ from the 
            actual physical names.
            The physical names is defined in the corresponding PhysicalTables 
            property.  
          - Qualified with database name if the query is defined with dbname.
          - From 9.1B this property is a design time property while it earlier 
            was resolved from the actual query. This was very expensive as the 
            function then always needed to be resolved on the server and it is 
            rather extensively used. 
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

&IF DEFINED(EXCLUDE-getTempTables) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getTempTables Procedure 
FUNCTION getTempTables RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
   Purpose:  Returns a comma delimited list of temp tables in the Query Objects
Parameters:  <none>
     Notes: The names in the list references those tables in the Physicaltables
            proeprty that are temp tables.
------------------------------------------------------------------------------*/
 DEFINE VARIABLE cTempTables AS CHARACTER  NO-UNDO.
 {get TempTables cTempTables}.
 RETURN cTempTables.
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
  Purpose:     Returns a comma delimited list of the Updatable Columns for this
               SmartDataObject.
  Parameters:  <none>
  Notes:       Uses the UpdatableColumnsByTable property which stores the
               the columns in different tables delimited by {&adm-tabledelimiter} instead of 
               comma in order to identify which columns are from which table 
               in the event of a join. For example, if the query is a join of 
               customer and order and the Name field from customer and the
               OrderNum and OrderData field from Order are Updatable, then the 
               property value will be equal to "Name{&adm-tabledelimiter}OrderNum,OrderDate".
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cColumns AS CHARACTER NO-UNDO.
  {get UpdatableColumnsByTable cColumns}.
  
  cColumns = REPLACE(cColumns,{&adm-tabledelimiter},",":U).
  
  /* There might be empty entries for some tables */
  DO WHILE INDEX(cColumns,",,":U) > 0:
    cColumns = REPLACE(cColumns,",,":U,",":U).
  END.

  /* There may be commas at the ends */ 
  RETURN TRIM(cColumns,",":U).

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getUpdatableColumnsByTable) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getUpdatableColumnsByTable Procedure 
FUNCTION getUpdatableColumnsByTable RETURNS CHARACTER
  ( ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
 DEFINE VARIABLE cColumns AS CHARACTER  NO-UNDO.
 
 {get UpdatableColumnsByTable cColumns}.
 
 RETURN cColumns.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getUpdateFromSource) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getUpdateFromSource Procedure 
FUNCTION getUpdateFromSource RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose: Returns true if this object should be updated as one-to-one 
           of the datasource updates (one-to-one) 
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE lUpdate AS LOGICAL    NO-UNDO.
  {get UpdateFromSource lUpdate}.
  RETURN lUpdate.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getUseDBQualifier) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getUseDBQualifier Procedure 
FUNCTION getUseDBQualifier RETURNS LOGICAL
 (  ) :
/*------------------------------------------------------------------------------
  Purpose: Return true if table references are qualified with db. 
    Notes: This property was originally implemented to be able to return 
           getTables() correctly when getTables() was resolved from the query 
           handle. 
           From 9.1B the Tables property is set at design time and will thus 
           always reflect the design time database qualification, so this 
           function is now changed to be resolved from getTables, the very same 
           function it was implemented to serve.
           (It is also used in other functions).  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cTables AS CHAR NO-UNDO.
  
  {get Tables cTables}.
  
  RETURN NUM-ENTRIES(ENTRY(1,cTables),".":U) > 1.   
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getWordIndexedFields) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getWordIndexedFields Procedure 
FUNCTION getWordIndexedFields RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose: Return a comma separated list of word indexed fields 
    Notes: Qualified with database and table name.
           We return database name from dynamic methods as all column* 
           methods are able to respond to that.
           This dbname is returned also if qualify with db name is false.
------------------------------------------------------------------------------*/
  RETURN 
     REPLACE(DYNAMIC-FUNCTION("indexInformation":U IN TARGET-PROCEDURE,
                              "WORD":U,
                              NO,
                              ?),
             CHR(1),",":U).

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setAssignList) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setAssignList Procedure 
FUNCTION setAssignList RETURNS LOGICAL
  ( pcList AS CHAR   ) :
/*------------------------------------------------------------------------------
  Purpose:    Sets the list of updatable columns whose names have been 
              modified in the SmartDataObject.

  Parameters: <none>

  Notes:      This string is of the form:
              <RowObjectFieldName>,<DBFieldName>[,...][{&adm-tabledelimiter}...]
              with a comma separated list of pairs of fields for each db table,
              and {&adm-tabledelimiter} between the lists of pairs.
------------------------------------------------------------------------------*/
  {set AssignList pcList}.
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setAuditEnabled) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setAuditEnabled Procedure 
FUNCTION setAuditEnabled RETURNS LOGICAL
  ( lAuditEnabled AS LOGICAL ) :
/*------------------------------------------------------------------------------
  Purpose:  Sets AuditEnabled property value
    Notes:  
------------------------------------------------------------------------------*/
    {set AuditEnabled lAuditEnabled}.
    RETURN TRUE.                               

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setAutoCommit) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setAutoCommit Procedure 
FUNCTION setAutoCommit RETURNS LOGICAL
  ( plCommit AS LOGICAL ) :
/*------------------------------------------------------------------------------
  Purpose:     Passes along a "set AutoCommit" to the object's Update-Target.
  
  Parameters:
    plCommit - True or False to be set in the Update-Target procedure.

  Notes:       There is no AutoCommit property in a query object, but the 
               AutoCommit setting may be passed from a SmartDataObject to its 
               Data-Targets. If one of those targets is a query object that 
               isn't also a SmartDataObject (e.g., a SmartDataBrowser that has 
               its own db query), then the setting must be passed to the 
               Update-Target, which is the actual DataObject. 
               In a SmartDataObject the version of setAutoCommit in data.p
               will be found in preference to this one and will set the 
               actual property.
------------------------------------------------------------------------------*/

  dynamic-function("assignLinkProperty":U IN TARGET-PROCEDURE,
    'Update-Target':U, 'AutoCommit':U, IF plCommit THEN 'yes':U ELSE 'No':U).

  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setBaseQuery) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setBaseQuery Procedure 
FUNCTION setBaseQuery RETURNS LOGICAL
  ( pcBaseQuery AS CHARACTER) :
/*------------------------------------------------------------------------------
  Purpose: Set the base query property 
    Notes: This is used internally by openQuery, and directly on client context 
           management. Because setOpenQuery calls setQueryWhere and wipes out 
           all other query data, it cannot be used to set the context when 
           received from server.      
------------------------------------------------------------------------------*/
  IF pcBaseQuery = '':U THEN
    RETURN FALSE.

  {set BaseQuery pcBaseQuery}.
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

  &SCOPED-DEFINE xpBufferHandles
  {set BufferHandles pcBufferHandles}.
  &UNDEFINE xpBufferHandles
  
  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setCalcFieldList) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setCalcFieldList Procedure 
FUNCTION setCalcFieldList RETURNS LOGICAL
  ( pcList AS CHAR   ) :
/*------------------------------------------------------------------------------
  Purpose:    ACCESS_LEVEL=PRIVATE
              Sets CalcFieldList which is a comma-separated list of 
              calculated field instance names and their master object names.  
              This is for use by the AppBuilder at design time and should 
              not be used by application code.

  Parameters: <none>

  Notes:      Value format:

              <InstaneName>,<MasterName>,...
------------------------------------------------------------------------------*/
  {set CalcFieldList pcList}.
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setCheckLastOnOpen) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setCheckLastOnOpen Procedure 
FUNCTION setCheckLastOnOpen RETURNS LOGICAL
 (pCheck AS LOGICAL) :
/*------------------------------------------------------------------------------
  Purpose:    Sets the flag indicating whether a get-last should be performed on 
              an open in order for fetchNext to be able to detect that we are on 
              the last row. This is necessary to make the QueryPosition 
              attribute reliable.
 
  Parameters:
    pCheck - True or False depending on whether the check should be done or not.
------------------------------------------------------------------------------*/
  
  {set CheckLastOnOpen pCheck}.
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

&IF DEFINED(EXCLUDE-setDataColumnsByTable) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setDataColumnsByTable Procedure 
FUNCTION setDataColumnsByTable RETURNS LOGICAL
  ( pcColumns AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  {set DataColumnsByTable pcColumns}.
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
    Notes: Duplicated in sboext 
Note Date: 2002/04/14    
------------------------------------------------------------------------------*/
  {set DataIsFetched plFetched}.
  
  RETURN TRUE.   

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setDBNames) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setDBNames Procedure 
FUNCTION setDBNames RETURNS LOGICAL
  (pcDBNames AS CHAR) :
/*------------------------------------------------------------------------------
   Purpose:  Sets the comma delimited list of DBNames that corresponds 
             to the Tables in the Query Objects
Parameters:  pcDBNames - Comma delimited list of each buffer's DBNAME. 
     Notes: FOR INTERNAL USE ONLY
            Function is required because this does not have an xpTables 
            preprocessor because getDBNames is overridden in data.p. 
            The function is also used when this property is passed from server 
            to client.    
------------------------------------------------------------------------------*/
  &SCOPED-DEFINE xpDBNames
  {set DBNames pcDBNames}.
  &UNDEFINE xpDBNames

  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setEntityFields) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setEntityFields Procedure 
FUNCTION setEntityFields RETURNS LOGICAL
  ( cEntityFields AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  {set EntityFields cEntityFields}.
  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setFetchAutoComment) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setFetchAutoComment Procedure 
FUNCTION setFetchAutoComment RETURNS LOGICAL
  ( plFetchAutoComment AS LOGICAL ) :
/*------------------------------------------------------------------------------
  Purpose: Set to true if auto comments should be retrieved with the 
           data. 
    Notes: This is used in transferRows and transferDbRow.
           These comments will be automatically displayed by visual objects and
           will be set to true by the visual object's LinkStateHandler if the 
           property value is unknown
------------------------------------------------------------------------------*/
  {set FetchAutoComment plFetchAutoComment}.
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setFetchHasAudit) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setFetchHasAudit Procedure 
FUNCTION setFetchHasAudit RETURNS LOGICAL
  ( plFetchHasAudit AS LOGICAL ) :
/*------------------------------------------------------------------------------
  Purpose: Set to true if Audit exists flag should be retrieved with the data 
    Notes: This is used in transferRows and transferDbRow 
------------------------------------------------------------------------------*/
  {set FetchHasAudit plFetchHasAudit}.
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setFetchHasComment) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setFetchHasComment Procedure 
FUNCTION setFetchHasComment RETURNS LOGICAL
  ( plFetchHasComment AS LOGICAL ) :
/*------------------------------------------------------------------------------
  Purpose: Set to true if 'comments exists' flag should be retrieved with the 
           data. 
    Notes: This is used in transferRows and transferDbRow 
------------------------------------------------------------------------------*/
  {set FetchHasComment plFetchHasComment}.
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setFetchOnOpen) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setFetchOnOpen Procedure 
FUNCTION setFetchOnOpen RETURNS LOGICAL
  ( pcFetchOnOpen AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose: Set whether a fetch should occur when the db query is opened.                
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

&IF DEFINED(EXCLUDE-setFirstResultRow) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setFirstResultRow Procedure 
FUNCTION setFirstResultRow RETURNS LOGICAL
  ( pcFirstResultRow AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Sets the FirstResultRow property which is unknow if the first
            row has not been fetched, otherwise 1 concatinated with the
            rowid if it has
   Params:  pcFirstResultRow -- Row-num:RowId of the first row
    Notes:  
------------------------------------------------------------------------------*/
  {set FirstResultRow pcFirstResultRow}.
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

&IF DEFINED(EXCLUDE-setKeyFields) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setKeyFields Procedure 
FUNCTION setKeyFields RETURNS LOGICAL
  ( pcKeyFields AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Sets the KeyFields property
   Params:  pcKeyFields -- Comma separated list of fields 
    Notes:  
------------------------------------------------------------------------------*/
   /* temorary define the xp so we can go directly to the property buffer */
  &SCOPED-DEFINE xpKeyFields 
  {set KeyFields pcKeyFields}.
  &UNDEFINE xpKeyFields 

  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setKeyTableId) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setKeyTableId Procedure 
FUNCTION setKeyTableId RETURNS LOGICAL
  ( pcKeyTableId AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Sets the KeyTableId property
   Params:  TableId - Table identifier  
    Notes:  Unique identifer of the table
            (In Dynamics Aka FLA (Five Letter Acronym) )
           This is also the dump name of the table 
------------------------------------------------------------------------------*/
  /* temporary define the xp so we can go directly to the property buffer */
  
  &SCOPED-DEFINE xpKeyTableId
  {set KeyTableId pcKeyTableId}.
  &UNDEFINE xpKeyTableId
   
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

&IF DEFINED(EXCLUDE-setLastResultRow) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setLastResultRow Procedure 
FUNCTION setLastResultRow RETURNS LOGICAL
  ( pcLastResultRow AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Sets the LastResultRow property which is unknown if the last
            row has not been fetched, otherwise its rownum concatinated
            with the rowid if it has
   Params:  pcLastResultRow -- Row-num:RowId of the last row
    Notes:  
------------------------------------------------------------------------------*/
  {set LastResultRow pcLastResultRow}.
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

&IF DEFINED(EXCLUDE-setNewBatchInfo) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setNewBatchInfo Procedure 
FUNCTION setNewBatchInfo RETURNS LOGICAL
  ( pcNewBatchInfo AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  {set NewBatchInfo pcNewBatchInfo}.
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

&IF DEFINED(EXCLUDE-setOpenQuery) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setOpenQuery Procedure 
FUNCTION setOpenQuery RETURNS LOGICAL
  (pcQuery AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose:    Sets the design Query value, to allow it to be manipulated 
              by setQueryWhere, for example

  Parameters: pcQuery - Query expression without open query <name>.
    Notes:    getOpenQuery is called from the client on AppServer, so we are not
              using the xp preprocessor.
            - The actual value is stored in BaseQuery.. After the improvements
              to make the Appserver use one hit per request setOpenQuery cannot
              be used to store the server context on the client since it may 
              be returned AFTER the query has been changed and wipe out all 
              query data because it calls setQueryWhere('').    
------------------------------------------------------------------------------*/
  {set BaseQuery pcQuery}.
        
  /* Just use the setQueryWhere to blank to apply this property to the query.
     setQueryWhere has all the required logic to prepare and set other  
     query props to blank. */ 
  RETURN {fnarg setQueryWhere '':U}.   

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setPhysicalTables) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setPhysicalTables Procedure 
FUNCTION setPhysicalTables RETURNS LOGICAL
  ( pcPhysicalTables AS CHAR) :
/*------------------------------------------------------------------------------
   Purpose: Sets the Physical names that corresponsd to the Tables that is used 
            to build the BaseQuery.  
     Notes: The names used inthe query is defined in the corresponding Tables 
            property.  
          - Qualified with database name if the query is defined with dbname.
------------------------------------------------------------------------------*/
  {set PhysicalTables pcPhysicalTables}.
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setPositionForClient) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setPositionForClient Procedure 
FUNCTION setPositionForClient RETURNS LOGICAL
  ( pcPositionForClient AS CHARACTER) :
/*------------------------------------------------------------------------------
  Purpose: This property is set on the server and returned to the client so that
           it is able to position correctly in the new batch of data. The client
           need this information under certain cicumstances, for example when 
           other settings decides that a full batch of data always is needed. 
    Notes: set on server, used in clientSendRows only  
------------------------------------------------------------------------------*/
  {set PositionForClient pcPositionForClient}.
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
             - ? means reset to Default sort (from BaseQuery).                  
  Notes:     - setQueryWhere wipes out anything done in setQuerySort.
             - addQuerywhere does not. 
             - Use resetSort to apply sort criteria AND reopen the query if 
               it already is opened.
------------------------------------------------------------------------------*/
 DEFINE VARIABLE cQueryText     AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cBaseQuery     AS CHARACTER  NO-UNDO.

 /* If a query is under work, use that. */  
 {get QueryString cQueryText}.
  
 IF cQueryText = "":U THEN 
 DO:
   {get QueryWhere cQueryText}.
   IF cQueryText = '':U OR cQueryText = ? THEN
     {get BaseQuery cQueryText}.
 END. /* no query under work */
 
 /* if ? get Default from BaseQuery */  
 IF pcSort = ? THEN
 DO:
   {get BaseQuery cBaseQuery}.
   pcSort = {fnarg sortExpression cBaseQuery}.
 END.

 cQueryText = DYNAMIC-FUNCTION('newQuerySort':U IN TARGET-PROCEDURE,
                                cQueryText,
                                pcSort,
                                YES). /* db columns */
 IF cQueryText > '':U THEN
 DO:
   {set QueryString cQueryText}.
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

&IF DEFINED(EXCLUDE-setQueryWhere) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setQueryWhere Procedure 
FUNCTION setQueryWhere RETURNS LOGICAL
  ( pcWhere AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:    Append a WHERE clause to the basic static database query 
              definition (on client or server side) or modifes the complete 
              where clause.  
 
Parameters:
    INPUT pcWhere - new WHERE clause (a logical expression without the 
                    leading WHERE keyword). 
  
  Notes:      NOTE that we always start with the base query definition 
              to do this. If the where-clause parameter is blank, we simply 
              reprepare the original query.
              Criteria appended with the other query manipulation methods 
              will be removed, INCLUDED sort criteria added with setQuerySort. 
  Parameters:
    pcWhere - new query expression or complete new where clause.  
              - An expression without the leading WHERE keyword.
                Will be added to the base query, if the base query has an 
                expression the new expression wil be appended with AND 
              - blank - reprepare the base query.
              - a complete query with the FOR keyword.
              
   Notes:     If pcWhere starts with "For " or "Preselect " then the existing 
              where clause is completely replaced with pcWhere.
              If pcWhere is blank, then the existing where clause is replaced
              with the design-time where clause.
              Otherwise pcWhere is added to the design-time where clause.
 ------------------------------------------------------------------------------*/
  DEFINE VARIABLE cQuery       AS  CHARACTER NO-UNDO.
  DEFINE VARIABLE hQuery       AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cAsDivision  AS CHARACTER  NO-UNDO.
  
  cQuery = {fnarg newQueryWhere pcWhere}.

  IF cQuery <> ? THEN
  DO:
    {get QueryHandle hQuery}.
    IF VALID-HANDLE(hQuery) THEN
      /* prepares the query with the new string */ 
      RETURN {fnarg prepareQuery cQuery}. 
    ELSE 
    DO:
      /* set QueryWhere may be called early to set context on server 
         So we use the queryContext temporarily, which is only is used 
         by createObjects. */ 
      {get AsDivision cAsDivision}.
      IF cAsDivision <> 'CLIENT':U THEN
      DO:
        IF cQuery = '':U  THEN
          {get BaseQuery cQuery}.
        {set QueryContext cQuery}.
        RETURN TRUE.
      END.
    END. /* not valid query */
  END. /* cQuery <> ? */

  RETURN FALSE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setRequiredProperties) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setRequiredProperties Procedure 
FUNCTION setRequiredProperties RETURNS LOGICAL
  ( pcProperties AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose: Sets the list of required properties   
    Notes: Currently used to identify the manadatory properites for a dynamic data 
           ojbect  
------------------------------------------------------------------------------*/
  {set RequiredProperties pcProperties}.
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
   Purpose: Set the Tables that is used to build the BaseQuery.  
     Notes: The names in the list references to the tables as defined in the
            dataobject and referenced in the query, so each entry must be unique. 
            This means that the names may be buffer names that differ from the 
            actual physical names.
            The physical names is defined in the corresponding PhysicalTables 
            property.  
          - Qualified with database name if the query is defined with dbname.
          - From 9.1B this property is a design time property while it earlier 
            was resolved from the actual query. This was very expensive as the 
            function then always needed to be resolved on the server and it is 
            rather extensively used. 
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

&IF DEFINED(EXCLUDE-setTempTables) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setTempTables Procedure 
FUNCTION setTempTables RETURNS LOGICAL
  ( pcTempTables AS CHAR ) :
/*------------------------------------------------------------------------------
   Purpose: Sets the Tables that is used to build the BaseQuery that are temp-tables.  
     Notes: The list of tempTables contain those tables as defined in the 
            PhysicalTables property that are temporary tables.  
          - Qualified with database name if the query is defined with dbname.
------------------------------------------------------------------------------*/
  {set TempTables pcTempTables}.
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

&IF DEFINED(EXCLUDE-setUpdatableColumnsByTable) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setUpdatableColumnsByTable Procedure 
FUNCTION setUpdatableColumnsByTable RETURNS LOGICAL
  ( pcColumns AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  {set UpdatableColumnsByTable pcColumns}.
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setUpdateFromSource) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setUpdateFromSource Procedure 
FUNCTION setUpdateFromSource RETURNS LOGICAL
  ( plUpdateFromSource AS LOGICAL ) :
/*------------------------------------------------------------------------------
  Purpose: Set to true if this object should be updated as one-to-one 
           of the datasource updates (one-to-one) 
    Notes:  
------------------------------------------------------------------------------*/
  {set UpdateFromSource plUpdateFromSource}.
  RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-updateLargeColumns) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION updateLargeColumns Procedure 
FUNCTION updateLargeColumns RETURNS LOGICAL PRIVATE
  (  ) :
/*------------------------------------------------------------------------------
  Purpose: Update properties that returns information about LOB columns
Parameter: pcLargeColumns - List of columns to set in LargeColumns  
    Notes: Called from whatever id called first of getCLOB- -BLOB- or 
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

    DEFINE VARIABLE hRowObject    AS HANDLE      NO-UNDO.
    DEFINE VARIABLE iColumn       AS INTEGER     NO-UNDO.
    DEFINE VARIABLE cColumn       AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE cDataType     AS CHARACTER   NO-UNDO.

    &SCOPED-DEFINE xp-assign
    {get DataColumns cDataColumns}
    {get RowObject hRowObject}
    .
    &UNDEFINE xp-assign
    
    /* Set to blank for storage and return when no large columns */
    DO iColumn = 1 TO NUM-ENTRIES(cDataColumns):
      cColumn = ENTRY(iColumn,cDataColumns).
      IF VALID-HANDLE(hRowObject) THEN
        cDataType = hRowobject:BUFFER-FIELD(cColumn):DATA-TYPE. 

      /* We avoid calling the function for performance, unless the rowobject 
         is not valid (called before the first data request...)
         The function will do an appserver call if not able to resolve 
         the request on the client!  */ 
      ELSE 
        cDataType = {fnarg columnDataType cColumn}.

      IF CAN-DO('CLOB,BLOB':U,cDataType) THEN
      DO:
        cLargeColumns = cLargeColumns + ',' + cColumn.
        CASE cDataType:
          WHEN 'CLOB':U THEN
            cCLOBColumns  = cCLOBColumns + ',' + cColumn.
          WHEN 'BLOB':U THEN
            cBLOBColumns  = cBLOBColumns + ',' + cColumn.
        END CASE.
      END.
    END.
    
    ASSIGN
      cLargeColumns = LEFT-TRIM(cLargeColumns,',':U)
      cCLOBColumns  = LEFT-TRIM(cCLOBColumns,',':U)
      cBLOBColumns  = LEFT-TRIM(cBLOBColumns,',':U).

    /* Store the result (also blank), for future requests */  
    {set LargeColumns cLargeColumns}.

    /* This is normally not allowed outside of the setfunction,    
       R&D Mode... 
       These are considered READ-ONLY, so there is no set functions, but for 
       performance reasons we do want to store them. (By not defining the xp 
       in the prop file they are safe from being changed by the set include. */ 
       
    &SCOPED-DEFINE xpCLOBColumns
    {set CLOBColumns  cCLOBColumns}.
    &UNDEFINE xpCLOBColumns
    &SCOPED-DEFINE xpBLOBColumns
    {set BLOBColumns  cBLOBColumns}.
    &UNDEFINE xpBLOBColumns
 
   RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

