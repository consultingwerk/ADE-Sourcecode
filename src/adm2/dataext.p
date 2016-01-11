&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12
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
    File        : dataext.p
    Purpose     : Support procedure for Data Object.  This is an extension
                  of data.p.  The extension is necessary to avoid an overflow
                  of the action segment.  From 9.1B this extension file contains
                  all of the get and set property functions. These functions 
                  will be rolled back into data.p when segment size increases.

    Syntax      : adm2/dataext.p

    Modified    : December 7, 2000 Version 9.1B05
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* Tell dataprop.i that this is the Super procedure */
  &SCOP ADMSuper dataext.p

  DEFINE VARIABLE ghRowObject AS HANDLE    NO-UNDO. /* Handle of current TT rec.*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-getAsynchronousSDO) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getAsynchronousSDO Procedure 
FUNCTION getAsynchronousSDO RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

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

&IF DEFINED(EXCLUDE-getCheckCurrentChanged) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getCheckCurrentChanged Procedure 
FUNCTION getCheckCurrentChanged RETURNS LOGICAL
  (  )  FORWARD.

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

&IF DEFINED(EXCLUDE-getCurrentRowModified) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getCurrentRowModified Procedure 
FUNCTION getCurrentRowModified RETURNS LOGICAL
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

&IF DEFINED(EXCLUDE-getDataFieldDefs) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getDataFieldDefs Procedure 
FUNCTION getDataFieldDefs RETURNS CHARACTER
  (   )  FORWARD.

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

&IF DEFINED(EXCLUDE-getDataSignature) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getDataSignature Procedure 
FUNCTION getDataSignature RETURNS CHARACTER
  ( )  FORWARD.

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

&IF DEFINED(EXCLUDE-getDestroyStateless) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getDestroyStateless Procedure 
FUNCTION getDestroyStateless RETURNS LOGICAL
  ()  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDisconnectAppServer) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getDisconnectAppServer Procedure 
FUNCTION getDisconnectAppServer RETURNS LOGICAL
  ( )  FORWARD.

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

&IF DEFINED(EXCLUDE-getForeignValues) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getForeignValues Procedure 
FUNCTION getForeignValues RETURNS CHARACTER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getHasNewRow) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getHasNewRow Procedure 
FUNCTION getHasNewRow RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

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

&IF DEFINED(EXCLUDE-getInternalEntries) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getInternalEntries Procedure 
FUNCTION getInternalEntries RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

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

&IF DEFINED(EXCLUDE-getManualAddQueryWhere) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getManualAddQueryWhere Procedure 
FUNCTION getManualAddQueryWhere RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getManualAssignQuerySelection) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getManualAssignQuerySelection Procedure 
FUNCTION getManualAssignQuerySelection RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getManualSetQuerySort) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getManualSetQuerySort Procedure 
FUNCTION getManualSetQuerySort RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

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

&IF DEFINED(EXCLUDE-getOpenQuery) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getOpenQuery Procedure 
FUNCTION getOpenQuery RETURNS CHARACTER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getQueryContainer) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getQueryContainer Procedure 
FUNCTION getQueryContainer RETURNS LOGICAL
  (   )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getQueryContext) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getQueryContext Procedure 
FUNCTION getQueryContext RETURNS CHARACTER
  ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getQueryRowIdent) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getQueryRowIdent Procedure 
FUNCTION getQueryRowIdent RETURNS CHARACTER
  (  )  FORWARD.

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

&IF DEFINED(EXCLUDE-getRebuildOnRepos) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getRebuildOnRepos Procedure 
FUNCTION getRebuildOnRepos RETURNS LOGICAL
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getRowIdent) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getRowIdent Procedure 
FUNCTION getRowIdent RETURNS CHARACTER
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

&IF DEFINED(EXCLUDE-getRowObjectState) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getRowObjectState Procedure 
FUNCTION getRowObjectState RETURNS CHARACTER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getRowObjectTable) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getRowObjectTable Procedure 
FUNCTION getRowObjectTable RETURNS HANDLE
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getRowObjUpd) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getRowObjUpd Procedure 
FUNCTION getRowObjUpd RETURNS HANDLE
  ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getRowObjUpdTable) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getRowObjUpdTable Procedure 
FUNCTION getRowObjUpdTable RETURNS HANDLE
  (   )  FORWARD.

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

&IF DEFINED(EXCLUDE-getServerSubmitValidation) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getServerSubmitValidation Procedure 
FUNCTION getServerSubmitValidation RETURNS LOGICAL
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

&IF DEFINED(EXCLUDE-getUpdateFromSource) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getUpdateFromSource Procedure 
FUNCTION getUpdateFromSource RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

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

&IF DEFINED(EXCLUDE-setAsynchronousSDO) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setAsynchronousSDO Procedure 
FUNCTION setAsynchronousSDO RETURNS LOGICAL
  ( lAsynchronousSDO AS LOGICAL )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setAutoCommit) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setAutoCommit Procedure 
FUNCTION setAutoCommit RETURNS LOGICAL
  ( plFlag AS LOGICAL )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setCheckCurrentChanged) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setCheckCurrentChanged Procedure 
FUNCTION setCheckCurrentChanged RETURNS LOGICAL
  ( plCheck AS LOGICAL )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setClientProxyHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setClientProxyHandle Procedure 
FUNCTION setClientProxyHandle RETURNS LOGICAL
  ( pcClientProxy AS CHARACTER )  FORWARD.

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

&IF DEFINED(EXCLUDE-setDestroyStateless) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setDestroyStateless Procedure 
FUNCTION setDestroyStateless RETURNS LOGICAL
  (plDestroy AS LOGICAL)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setDisconnectAppserver) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setDisconnectAppserver Procedure 
FUNCTION setDisconnectAppserver RETURNS LOGICAL
  (plDisconnect AS LOGICAL)  FORWARD.

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

&IF DEFINED(EXCLUDE-setForeignValues) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setForeignValues Procedure 
FUNCTION setForeignValues RETURNS LOGICAL
  ( pcValues AS CHAR )  FORWARD.

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

&IF DEFINED(EXCLUDE-setLastDbRowIdent) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setLastDbRowIdent Procedure 
FUNCTION setLastDbRowIdent RETURNS LOGICAL
  ( pcLastDbRowIdent AS CHARACTER )  FORWARD.

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

&IF DEFINED(EXCLUDE-setManualAddQueryWhere) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setManualAddQueryWhere Procedure 
FUNCTION setManualAddQueryWhere RETURNS LOGICAL
  ( cString AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setManualAssignQuerySelection) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setManualAssignQuerySelection Procedure 
FUNCTION setManualAssignQuerySelection RETURNS LOGICAL
  ( cString AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setManualSetQuerySort) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setManualSetQuerySort Procedure 
FUNCTION setManualSetQuerySort RETURNS LOGICAL
  ( cString AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setQueryContext) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setQueryContext Procedure 
FUNCTION setQueryContext RETURNS LOGICAL
  (pcQueryContext AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setQueryRowIdent) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setQueryRowIdent Procedure 
FUNCTION setQueryRowIdent RETURNS LOGICAL
  ( pcRowIdent AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setQueryWhere) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setQueryWhere Procedure 
FUNCTION setQueryWhere RETURNS LOGICAL
  (pcWhere AS CHAR)  FORWARD.

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

&IF DEFINED(EXCLUDE-setRowObjectTable) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setRowObjectTable Procedure 
FUNCTION setRowObjectTable RETURNS LOGICAL
  ( phTable AS HANDLE )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setRowObjUpdTable) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setRowObjUpdTable Procedure 
FUNCTION setRowObjUpdTable RETURNS LOGICAL
   ( phTable AS HANDLE )  FORWARD.

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

&IF DEFINED(EXCLUDE-setServerSubmitValidation) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setServerSubmitValidation Procedure 
FUNCTION setServerSubmitValidation RETURNS LOGICAL
  ( plVal AS LOGICAL )  FORWARD.

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

&IF DEFINED(EXCLUDE-setUpdateFromSource) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setUpdateFromSource Procedure 
FUNCTION setUpdateFromSource RETURNS LOGICAL
  ( plUpdateFromSource AS LOGICAL )  FORWARD.

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
         HEIGHT             = 14.29
         WIDTH              = 55.2.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB Procedure 
/* ************************* Included-Libraries *********************** */

{src/adm2/dataprop.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-getAsynchronousSDO) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getAsynchronousSDO Procedure 
FUNCTION getAsynchronousSDO RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    DEFINE VARIABLE lAsynchronousSDO AS LOGICAL NO-UNDO.    
    {get AsynchronousSDO lAsynchronousSDO}.    
    RETURN lAsynchronousSDO.
  
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

&IF DEFINED(EXCLUDE-getCheckCurrentChanged) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getCheckCurrentChanged Procedure 
FUNCTION getCheckCurrentChanged RETURNS LOGICAL
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns a flag indicating whether the DataObject code should check
            whether the database row(s) being updated have been changed since read.
   Params:  <none>
    Notes:  TRUE by default.
------------------------------------------------------------------------------*/

  DEFINE VARIABLE lCheck AS LOGICAL NO-UNDO.
  {get CheckCurrentChanged lCheck}.
  RETURN lCheck.

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

&IF DEFINED(EXCLUDE-getCurrentRowModified) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getCurrentRowModified Procedure 
FUNCTION getCurrentRowModified RETURNS LOGICAL
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:     Returns TRUE if any values in the current RowObject row
               have been modified.  If there is no current Rowobject record,
               then getCurrentRowModified returns ?.
   
  Parameters:  <none>
------------------------------------------------------------------------------*/

  DEFINE VARIABLE hRowObject AS HANDLE NO-UNDO.
  DEFINE VARIABLE hRowMod    AS HANDLE NO-UNDO.
  
  {get RowObject hRowObject}.
  IF NOT hRowObject:AVAILABLE THEN RETURN ?.
  ELSE DO:
    hRowMod = hRowObject:BUFFER-FIELD('RowMod':U).
    RETURN hRowMod:BUFFER-VALUE = "U":U.  /* This means newly added rows return NO? */
  END.

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

&IF DEFINED(EXCLUDE-getDataFieldDefs) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getDataFieldDefs Procedure 
FUNCTION getDataFieldDefs RETURNS CHARACTER
  (   ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the name of the include file in which the field 
            definitions for this SDO's RowObject table are stored.
   Params:  <none>  
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cDefs AS CHARACTER NO-UNDO.
  {get DataFieldDefs cDefs}.
  RETURN cDefs.

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

&IF DEFINED(EXCLUDE-getDataModified) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getDataModified Procedure 
FUNCTION getDataModified RETURNS LOGICAL
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:     Returns TRUE if the current RowObject record is modified, 
               Returns no if there is no current RowObject.
  Parameters:  <none>  
  Notes:       We need to check updateTargets since this may be called from 
               the toolbar as a result of the updateSource's  
               setDataModifed -> publish updateState, BEFORE the updateState
               reaches us...                       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE lDataModified AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE cUpdateSource AS CHAR      NO-UNDO.
  DEFINE VARIABLE iSource       AS INTEGER   NO-UNDO.
  DEFINE VARIABLE hSource       AS HANDLE    NO-UNDO.

  &SCOPED-DEFINE xpDataModified
  {get DataModified lDataModified}.
  &UNDEFINE xpDataModified
  
  IF lDataModified = NO THEN
  DO:
    {get UpdateSource cUpdateSource}.
    DO iSource = 1 TO NUM-ENTRIES(cUpdateSource):
      hSource = WIDGET-HANDLE(ENTRY(iSource,cUpdateSource)).
      IF VALID-HANDLE(hSource) THEN 
      DO:
        {get DataModified lDataModified hSource}.
        IF lDataModified THEN
          LEAVE.
      END.
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
  
  Parametrers:  <none>
  
  Notes:        This is used to prevent two SmartDataBrowsers from attempting 
                to browse the same query, which is not allowed because 
                conflicts would occur.
------------------------------------------------------------------------------*/

  DEFINE VARIABLE lBrowsed AS LOGICAL NO-UNDO.
 
  ASSIGN ghProp = WIDGET-HANDLE(ENTRY(1, TARGET-PROCEDURE:ADM-DATA, CHR(1)))
         ghProp = ghProp:BUFFER-FIELD('DataQueryBrowsed':U)
         lBrowsed = ghProp:BUFFER-VALUE NO-ERROR.
 
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
  Purpose:  Returns the string used to prepare the RowObject query  
    Notes:  
------------------------------------------------------------------------------*/
  
  DEFINE VARIABLE cQueryString AS CHARACTER NO-UNDO.
  {get DataQueryString cQueryString}.
  RETURN cQueryString.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDataSignature) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getDataSignature Procedure 
FUNCTION getDataSignature RETURNS CHARACTER
  ( ) :
/*------------------------------------------------------------------------------
  Purpose:     Returns a character string value which is a list of integers 
               corresponding to the datatypes of the fields in the RowObject 
               Temp-Table, for use in comparing objects for equivalence.

  Parameters:  <none>
  
  Notes:       A SmartDataObject and a SmartDataBrowser which have the same 
               DataSignature will be compatible; the SmartDataObject's query 
               can be used by the Browser.  The integer values are the same 
               codes used in the _dtype field in the schema:
                               1 = CHARACTER
                               2 = DATE
                               3 = LOGICAL
                               4 = INTEGER
                               5 = DECIMAL
                               6 = Reserved for FLOAT OR DOUBLE in the future
                               7 = RECID
                               8 = RAW
                               9 = Reserved for IMAGE in the future
                              10 = HANDLE
                              13 = ROWID
                                  
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cSignature AS CHARACTER NO-UNDO INIT "":U.
  DEFINE VARIABLE iCol       AS INTEGER   NO-UNDO.
  DEFINE VARIABLE hRowObject AS HANDLE    NO-UNDO.
  DEFINE VARIABLE cDataType  AS CHARACTER NO-UNDO.
  DEFINE VARIABLE hColumn    AS HANDLE    NO-UNDO.
  
  {get RowObject hRowObject}.
  DO iCol = 1 TO hRowObject:NUM-FIELDS:
    hColumn = hRowObject:BUFFER-FIELD(iCol).
    cDataType = hColumn:DATA-TYPE.
    cSignature = cSignature +
      (IF     cDataType = 'CHARACTER':U THEN '1':U
      ELSE IF cDataType = 'DATE':U      THEN '2':U
      ELSE IF cDataType = 'LOGICAL':U   THEN '3':U
      ELSE IF cDataType = 'INTEGER':U   THEN '4':U
      ELSE IF cDataType = 'DECIMAL':U   THEN '5':U
      /* Note: Float/Double reserved for possible future use. */
      ELSE IF cDataType = 'FLOAT':U OR 
              cDataType = 'DOUBLE':U    THEN '6':U
      ELSE IF cDataType = 'RECID':U     THEN '7':U
      ELSE IF cDataType = 'RAW':U       THEN '8':U
      ELSE IF cDataType = 'HANDLE':U    THEN '10':U
      ELSE IF cDataType = 'ROWID':U     THEN '13':U 
      ELSE '0':U).
  END.
  
  RETURN cSignature.
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
     Notes: This override is just in case the property is referrenced before
            the sdo or sbo has copied the property from the server.           
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cDBNames    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hAsHandle   AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cAsDivision AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cContAsdiv  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hContainer  AS HANDLE     NO-UNDO.

  cDBNames = SUPER().  
  IF cDBNames = ? THEN
  DO: 
    {get ContainerSource hContainer}.
    {get ASDivision cContASDiv hContainer} NO-ERROR.
    IF cContASDiv = 'Client':U THEN
       RUN startServerObject IN hContainer.
    ELSE DO:
      {get ASDivision cASDivision}.  
      IF cASDivision = 'Client':U THEN
        {get ASHandle hAsHandle}.
    END.
    
    IF cContAsdiv = 'client':U OR cASDivision = 'Client':U THEN
    DO:
      /* Check again as this is should be retrieved at start up fromthe calls 
        above */
      cDBNames = SUPER().  
      /* Just in case something went wrong go and get it */
      IF cDbNames = ? THEN
      DO:
        {get Ashandle hAsHandle}.
        IF VALID-HANDLE(hAsHandle) AND hAsHandle NE TARGET-PROCEDURE THEN 
        DO:
          cDBNames = DYNAMIC-FUNCTION("getDBNames":U IN hAsHandle).
          {set DBNames cDBNames}.
        END.
      END.
      /* We may need to unbind if this call did the bind (getASHandle) */
      RUN unbindServer IN TARGET-PROCEDURE (?). 
    END. /* client */
  END. /* IF DBNames not yet defined locally. */

  RETURN cDBNames. 

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDestroyStateless) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getDestroyStateless Procedure 
FUNCTION getDestroyStateless RETURNS LOGICAL
  () :
/*------------------------------------------------------------------------------
  Purpose: Defines if the persistent sdo should be destroyed on stateless requests
    Notes: This is only possible to set to false in WebSpeed (default). 
------------------------------------------------------------------------------*/
  DEFINE VARIABLE lDestroy AS LOGICAL NO-UNDO.
  {get DestroyStateless lDestroy}.
  RETURN lDestroy.
  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDisconnectAppServer) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getDisconnectAppServer Procedure 
FUNCTION getDisconnectAppServer RETURNS LOGICAL
  ( ) :
/*------------------------------------------------------------------------------
  Purpose: Should the persistent sdo disconnect the AppServer.  
    Notes: This is only used for stateless WebSpeed SDO's that never are destroyed 
------------------------------------------------------------------------------*/
  DEFINE VARIABLE lDisconnect AS LOGICAL NO-UNDO.
  {get DisconnectAppServer lDisconnect}.
  RETURN lDisconnect.

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

&IF DEFINED(EXCLUDE-getForeignValues) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getForeignValues Procedure 
FUNCTION getForeignValues RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the ForeignValues  .
   Params:  none
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cForeignValues AS CHARACTER NO-UNDO.
  {get ForeignValues cForeignValues}.
  RETURN cForeignValues.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getHasNewRow) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getHasNewRow Procedure 
FUNCTION getHasNewRow RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hTable      AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hQuery      AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hBuffer     AS HANDLE    NO-UNDO.
  DEFINE VARIABLE lHasNewRow  AS LOGICAL    NO-UNDO.

  {get RowObjUpd hTable}.

  IF NOT VALID-HANDLE(hTable) THEN
    RETURN FALSE.

  CREATE BUFFER hBuffer FOR TABLE hTable BUFFER-NAME "bufRowObjUpd".
  CREATE QUERY hQuery. 
  hQuery:SET-BUFFERS(hBuffer).
  hQuery:QUERY-PREPARE("for each bufRowObjUpd where RowMod = 'A' or RowMod = 'C'").
  hQuery:QUERY-OPEN().
  hQuery:GET-FIRST().
  
  lHasNewRow = hBuffer:AVAILABLE.
  DELETE OBJECT hQuery.
  DELETE OBJECT hBuffer.

  RETURN lHasNewRow.

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
  DEFINE VARIABLE cInfo         AS CHAR   NO-UNDO.
  DEFINE VARIABLE cTableIndexes AS CHAR   NO-UNDO.
  DEFINE VARIABLE cTableList    AS CHAR   NO-UNDO.
  DEFINE VARIABLE cTable        AS CHAR   NO-UNDO.
  DEFINE VARIABLE cIndex        AS CHAR   NO-UNDO.
  DEFINE VARIABLE cField        AS CHAR   NO-UNDO.
  DEFINE VARIABLE cColumn       AS CHAR   NO-UNDO.
  DEFINE VARIABLE iIndex        AS INT    NO-UNDO.
  DEFINE VARIABLE iTable        AS INT    NO-UNDO.
  DEFINE VARIABLE iField        AS INT    NO-UNDO.
  DEFINE VARIABLE cAsDivision   AS CHAR   NO-UNDO.
  DEFINE VARIABLE cContAsDiv    AS CHAR   NO-UNDO.
  DEFINE VARIABLE hAppServer    AS HANDLE NO-UNDO.
  DEFINE VARIABLE hContainer    AS HANDLE NO-UNDO.

  &SCOPED-DEFINE xpIndexInformation
  {get IndexInformation cInfo}.
  &UNDEFINE xpIndexInformation
  
  IF cInfo = ? THEN
  DO:
    {get ContainerSource hContainer}.
    {get ASDivision cContASDiv hContainer} NO-ERROR.
    IF cContASDiv = 'Client':U THEN
       RUN startServerObject IN hContainer.
    
    ELSE DO:
      {get ASDivision cASDivision}.  
      IF cASDivision = 'Client':U THEN
        {get ASHandle hAppServer}.
    END.
    
    IF cContAsdiv = 'client':U OR cASDivision = 'Client':U THEN
    DO:
      /* This property should be retrieved by the above logic */
      &SCOPED-DEFINE xpIndexInformation
      {get IndexInformation cInfo}.
      &UNDEFINE xpIndexInformation
      /* It should have been found above, but in case sometihn is wrong let's
         go and get it */  
      IF cInfo = ? THEN
      DO:
        {get ASHandle hAppServer}.
        IF VALID-HANDLE(hAppServer) AND hAppserver <> TARGET-PROCEDURE THEN 
           {get IndexInformation cInfo hAppServer}. 
      END.
   
      /* We may need to unbind if this call did the bind (getASHandle) */
      RUN unbindServer IN TARGET-PROCEDURE (?). 
    END. /* do if client */
    ELSE DO: 
      
      cInfo = DYNAMIC-FUNCTION('indexInformation' IN TARGET-PROCEDURE,
                               'Info':U, /* all info */
                               'yes',    /* table separator */
                               ?).       /* Use query data */
      
      {get Tables cTableList}.

      /* Replace database fieldname with DataColumName */ 
      DO iTable = 1 TO NUM-ENTRIES(cInfo,CHR(2)):
        ASSIGN
          cTableIndexes = ENTRY(iTable,cInfo,CHR(2))
          cTable        = ENTRY(iTable,cTableList). 
        DO iIndex = 1 TO NUM-ENTRIES(cTableIndexes,CHR(1)):
          cIndex = ENTRY(iIndex,cTableIndexes,CHR(1)).
          DO iField = 5 TO NUM-ENTRIES(cIndex) BY 2:
            cField  = cTable + ".":U + ENTRY(iField,cIndex).
            /* Is there a mapped RowObject Column? */
            cColumn = {fnarg dbColumnDataName cField}.
            IF cColumn <> ? THEN 
              ENTRY(iField,cIndex) = cColumn.
            ELSE 
              ENTRY(iField,cIndex) = cField.
          END. /* iField = 5 to num-entries by 2 */
          ENTRY(iIndex,cTableIndexes,CHR(1)) = cIndex.
        END. /* iIndex = 1 to num indexes in tableindexes */
        ENTRY(iTable,cInfo,CHR(2)) = cTableIndexes.
      END. /* iTable = 1 to num tables */    
    END. /* else not 'client' */    
    
    /* Store it for next time */
    {set IndexInformation cInfo}.

  END. /* if cInfo = ? */
  
  RETURN cInfo.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getInternalEntries) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getInternalEntries Procedure 
FUNCTION getInternalEntries RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose: To pass back internal entries of SDO as internal-entries cannot be
           accessed for remote proxy procedures.
    Notes:  
------------------------------------------------------------------------------*/

  RETURN THIS-PROCEDURE:INTERNAL-ENTRIES.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getKeyTableId) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getKeyTableId Procedure 
FUNCTION getKeyTableId RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:     Returns the tableid for the KeyFields.
  Parameters:  <none>
  Notes:       This is normally the first enabled table, and is usually only
               used on the server side to join to comments/auditing etc
               This is also the dump name of that table
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cKeyTableId   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hAppServer    AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cASDivision   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cCOntAsDiv    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hContainer    AS HANDLE     NO-UNDO.
  
  cKeyTableId = SUPER().
  
  IF cKeyTableId = "":U THEN
  DO:
    {get ContainerSource hContainer}.
    {get ASDivision cContASDiv hContainer} NO-ERROR.
    IF cContASDiv = 'Client':U THEN
      RUN startServerObject IN hContainer.
    ELSE DO:
      {get ASDivision cASDivision}.
      /* If we're on the client then the AppServer haven't return this property 
         value yet. */
      IF cASDivision = 'Client':U THEN
       /* This will retrieve all Server properties including KeyTable */
        {get ASHandle hAppServer}.
    END.
    IF cContASDiv = 'Client':U OR cASDivision = 'Client':U THEN
    DO:
      cKeyTableId = SUPER().
      /* We should have got it now, but if something is wrong let's just go 
         and get it ourselves */ 
      IF cKeyTableId = '':U THEN 
      DO:
        {get AsHandle hAppServer}.
        IF VALID-HANDLE(hAppServer) AND hAppServer <> TARGET-PROCEDURE THEN 
        DO:
          cKeyTableId = DYNAMIC-FUNCTION("getKeyTableId":U IN hAppServer).
          IF cKeyTableId <> '':U THEN
            {set KeyTableId cKeyTableId}. 
        END.     /* END DO IF Valid A/S handle */      
      END.
       /* We may need to unbind if this call did the bind (getASHandle) */
      RUN unbindServer IN TARGET-PROCEDURE (?). 
    END.
  END.           /* END DO IF OpenQuery not yet defined locally. */
  
  RETURN cKeyTableId.
      
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

&IF DEFINED(EXCLUDE-getManualAddQueryWhere) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getManualAddQueryWhere Procedure 
FUNCTION getManualAddQueryWhere RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose: Retrieve manual calls to addquerywhere so that filter can reapply this
           when filter is changed, thus ensuring the original query stays intact. 
    Notes: Value is pcwhere + chr(3) + pcbuffer or empty or "?" + chr(3) + pcandor 
           Note that multiple entries are supported, seperated by chr(4).
------------------------------------------------------------------------------*/
    DEFINE VARIABLE cString AS CHARACTER NO-UNDO.
    {get ManualAddQueryWhere cString}.
    RETURN cString.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getManualAssignQuerySelection) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getManualAssignQuerySelection Procedure 
FUNCTION getManualAssignQuerySelection RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose: Retrieve manual calls to assignqueryselection so that filter can reapply this
           when filter is changed, thus ensuring the original query stays intact. 
    Notes: Value is pccolumns + chr(3) + pcvalues + chr(3) + pcoperators 
           Note that multiple entries are supported, seperated by chr(4).
------------------------------------------------------------------------------*/
    DEFINE VARIABLE cString AS CHARACTER NO-UNDO.
    {get ManualAssignQuerySelection cString}.
    RETURN cString.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getManualSetQuerySort) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getManualSetQuerySort Procedure 
FUNCTION getManualSetQuerySort RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose: Retrieve manual calls to setquerysort so that filter can reapply this
           when filter is changed, thus ensuring the original query stays intact. 
    Notes: Value is pcsort 
           Note that multiple entries are supported, seperated by chr(4).
------------------------------------------------------------------------------*/
    DEFINE VARIABLE cString AS CHARACTER NO-UNDO.
    {get ManualSetQuerySort cString}.
    RETURN cString.

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
  Notes:       The difference from getNewRow is that it also returns 
               true for saved and uncommitted new record and thus cannot be used
               to check the object's state.
               This uses the RowMod field in the Temp-Table to see if the 
               row's new (just as getNewRow) and in addition checks to see
               if the RowObjUpd is not avail, which indicates that this has 
               not been committed. 
               We do some double checking if a rowObjUpd is avail to ensure 
               that this is the right one.                 
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hRowObject  AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hRowObjUpd  AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hRowMod     AS HANDLE     NO-UNDO.
  DEFINE VARIABLE lNewMode    AS LOGICAL    NO-UNDO.

  {get RowObject hRowObject}.
  {get RowObjUpd hRowObjUpd}.
  
  IF NOT VALID-HANDLE(hRowObject) OR NOT hRowObject:AVAILABLE THEN
    RETURN ?.   

  IF NOT VALID-HANDLE(hRowObjUpd) THEN
    RETURN FALSE.

  /* Just replace the handle with a buffer, 
    (prohibits messing around with the real one) */
  CREATE BUFFER hRowObjUpd FOR TABLE hRowObjUpd.
  
  /* find the corresponding rowObjUpd -- buffer that is */
  DYNAMIC-FUNCTION('findRowObjUpd':U IN TARGET-PROCEDURE,
                    hRowObject, hRowObjUpd).
  
  ASSIGN
    hRowMod  = hRowObject:BUFFER-FIELD('RowMod':U)
    lNewMode = (hRowMod:BUFFER-VALUE = "A":U OR hRowMod:BUFFER-VALUE = "C":U) 
                AND (NOT hRowObjUpd:AVAILABLE). 
  
  /* Delete the locally created buffer */
  DELETE OBJECT hRowObjUpd.

  RETURN lNewMode.

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
               record or a copy of an existing record has never been written to
               the database.)  Returns ? if there is no current RowObject.

  Parameters:  <none>
  
  Notes:       This uses the RowMod field in the Temp-Table to see if the 
               row's new.
------------------------------------------------------------------------------*/

  DEFINE VARIABLE hRowObject AS HANDLE NO-UNDO.
  DEFINE VARIABLE hColumn    AS HANDLE NO-UNDO.
  
  {get RowObject hRowObject}.
  IF NOT VALID-HANDLE(hRowObject) OR NOT hRowObject:AVAILABLE THEN
    RETURN FALSE.

  ELSE DO:
    hColumn = hRowObject:BUFFER-FIELD('RowMod':U).
    IF hColumn:BUFFER-VALUE = "A":U OR
       hColumn:BUFFER-VALUE = "C":U THEN
      RETURN TRUE.
    ELSE RETURN FALSE.
  END.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getOpenQuery) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getOpenQuery Procedure 
FUNCTION getOpenQuery RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:     Returns the original design where-clause for the database query.
  Parameters:  <none>
  Notes:       This is normally not modified, and is retrieved at startup by
               a client-side SDO proxy or dynamic SDO, so if it's defined,
               just use the local value; otherwise ask the server-side SDO.
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cQuery      AS CHARACTER NO-UNDO.
  DEFINE VARIABLE hAppServer  AS HANDLE    NO-UNDO.
  DEFINE VARIABLE cASDivision AS CHARACTER NO-UNDO.
  DEFINE VARIABLE hContainer  AS HANDLE     NO-UNDO.
 
  cQuery = SUPER().
  IF cQuery = "":U THEN
  DO:
     {get ContainerSource hContainer}.
     {get ASDivision cASDivision hContainer} NO-ERROR.
     /* If we're on the client inside of a container then the container 
        haven't return this property from the appserver yet. */
     IF cASDivision = 'Client':U THEN
        RUN startServerObject IN hContainer.    
     ELSE DO:
       {get ASDivision cASDivision}.
       /* If we're on the client then the AppServer haven't return this property 
          value yet. */
       IF cASDivision = 'Client':U THEN
         /* This will retrieve all Server properties including openQuery */
         {get ASHandle hAppServer}.
     END.
     /* The property should now be available, so try again */ 
     cQuery = SUPER().

     /* We should have got it now, but if something is wrong let's just go 
        and get it ourselves */ 
     IF cAsDivision = 'client':U AND cQuery = '':U THEN 
     DO:
       {get ASHandle hAppServer}.
       IF VALID-HANDLE(hAppServer) AND hAppserver <> TARGET-PROCEDURE  THEN 
       DO:         
         cQuery = DYNAMIC-FUNCTION("getOpenQuery":U IN hAppServer).

         {set BaseQuery cQuery}. 
       END.     /* END DO IF Valid A/S handle */      
     END.
       
     /* We may need to unbind if this call did the bind (getASHandle) */
     RUN unbindServer IN TARGET-PROCEDURE (?). 
  END.           /* END DO IF OpenQuery not yet defined locally. */
  
  RETURN cQuery.
      
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getQueryContainer) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getQueryContainer Procedure 
FUNCTION getQueryContainer RETURNS LOGICAL
  (   ) :
/*------------------------------------------------------------------------------
  Purpose: Returns a flag indicating whether our Container is itself a
           QueryObject. Used to determine whether we're in an SBO which handles
           the transaction for us. 
   Params: <none>
------------------------------------------------------------------------------*/

  DEFINE VARIABLE lQuery AS LOG    NO-UNDO.
  {get QueryContainer lQuery}.
  RETURN lQuery.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getQueryContext) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getQueryContext Procedure 
FUNCTION getQueryContext RETURNS CHARACTER
  ( ) :
/*------------------------------------------------------------------------------
  Purpose: Returns the queryContext on the client 
Parameter:  
    Notes: For INTERNAL use only , exists as function so that it can be 
           accessed in generic calls.     
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cQueryContext AS CHARACTER  NO-UNDO.
  {get QueryContext cQueryContext}.
  RETURN cQueryContext.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getQueryRowIdent) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getQueryRowIdent Procedure 
FUNCTION getQueryRowIdent RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the property which holds a RowIdent to be used to
            position an SDO query when it if first opened.
    Params: <none>
    Notes:  Generally used to save the position of a query when it is
            closed so that position can be restored on re-open.
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cRowIdent AS CHARACTER NO-UNDO.
  {get QueryRowIdent cRowIdent}.
  RETURN cRowIdent.

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
  Parameters:  <none>
  Notes:       (See getOpenQuery for the original where clause.)
               The Where clause is stored locally on the client for statless 
               SDOs. 
               restartServerObject will use it  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cQuery         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hAppServer     AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cASDivision    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cOperatingMode AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lAsHasStarted  AS LOGICAL    NO-UNDO.

  {get ASDivision cASDivision}.
  IF cASDivision = 'Client':U THEN
  DO: 
    /* Check if the Query is stored locally 
      (only for stateless SDOs or all client SDOs in SBOs
       or for unstarted stateaware SDOs)  */
    {get QueryContext cQuery}.

    IF cQuery = ? THEN
    DO:
      /* If not Appserver has not started return the default query */ 
      {get AsHasStarted lAsHasStarted}.
      
      /* This code block has never been in use, but was almost added when the 
         logic to avoid server hits if not AsHasStarted was added, so it's kept 
         here for information and possible future considerations:
          ---------------  
          All code should currently handle queryWhere = ?, so this is probably
          not necessary (maybe even wrong since the query is not opened and 
         the querywhere is unknown )       
      IF NOT lAsHasStarted THEN
      DO:
        {get OpenQuery cQuery}. 
      END.  */

      /* This should never happen as this is part of the context, but 
         just in case let's support a direct appserver call */
      IF lAsHasStarted THEN
      DO: 
          
        {get ASHandle hAppServer}.
        IF VALID-HANDLE(hAppServer) AND hAppServer NE TARGET-PROCEDURE THEN 
        DO:
          cQuery = DYNAMIC-FUNCTION("getQueryWhere":U IN hAppServer).
          {get serverOperatingMode cOperatingMode}.
          /* We store the query locally for next time for stateless SDOs */
          IF cOperatingMode = 'STATELESS':U THEN
          DO:
            {set QueryContext cQuery}.
            /* unbind if this call did the bind (getASHandle) */
            RUN unbindServer IN TARGET-PROCEDURE (?). 
          END.
        END. /* valid appServer */
      END.
    END.  /* IF QueryWhere not yet defined locally. */
    
    RETURN cQuery.
  END. /* If 'Client' */
  
  ELSE RETURN SUPER().
      
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

&IF DEFINED(EXCLUDE-getRowIdent) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getRowIdent Procedure 
FUNCTION getRowIdent RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:     This is a comma delimited character string containing the ROWID 
               of the database record(s) that are the source of the RowObject 
               record.  
  Parameters:  <none>
  Notes:       This RowIdent key can be used to reposition to that row using
               fetchRowIdent.
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hDataQuery AS HANDLE NO-UNDO.
  DEFINE VARIABLE hRow       AS HANDLE NO-UNDO.
  
  {get DataHandle hDataQuery}.
  IF VALID-HANDLE(hDataQuery) THEN
  DO:
    hRow = hDataQuery:GET-BUFFER-HANDLE(1).
    IF VALID-HANDLE(hRow) AND hRow:AVAILABLE THEN
    DO:
      hRow = hRow:BUFFER-FIELD('RowIdent':U).
      RETURN hRow:BUFFER-VALUE.
    END.  /* END DO hRow */
    ELSE RETURN ?.
  END.  /* END DO hdataQuery */
  ELSE RETURN ?.

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
  
  ASSIGN ghProp = WIDGET-HANDLE(ENTRY(1, TARGET-PROCEDURE:ADM-DATA, CHR(1)))
         ghProp = ghProp:BUFFER-FIELD('RowObjectState':U)
         cState = ghProp:BUFFER-VALUE NO-ERROR.
 
  RETURN cState.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getRowObjectTable) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getRowObjectTable Procedure 
FUNCTION getRowObjectTable RETURNS HANDLE
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the Temp-Table handle of the RowObject table.
   Params:  none
   Notes:   Note that this is different from the RowObject property,
            which is the handle of the RowObject Buffer. This function
            does not use the {get} syntax because the setRowObjectTable
            function must also do other work.
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hTable AS HANDLE NO-UNDO.
  ASSIGN ghProp = WIDGET-HANDLE(ENTRY(1, TARGET-PROCEDURE:ADM-DATA, CHR(1)))
         ghProp = ghProp:BUFFER-FIELD('RowObjectTable':U)
         hTable = ghProp:BUFFER-VALUE NO-ERROR.
  RETURN hTable.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getRowObjUpd) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getRowObjUpd Procedure 
FUNCTION getRowObjUpd RETURNS HANDLE
  ( ) :
/*------------------------------------------------------------------------------
  Purpose:     Returns the handle of the RowObjUpd Temp-Table buffer where 
               Updates are stored.
  
  Parameters:  <none>
------------------------------------------------------------------------------*/

  DEFINE VARIABLE hRowObjUpd AS HANDLE NO-UNDO.
  
  {get RowObjUpd hRowObjUpd}.
  RETURN hRowObjUpd.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getRowObjUpdTable) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getRowObjUpdTable Procedure 
FUNCTION getRowObjUpdTable RETURNS HANDLE
  (   ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the handle to the RowObjUpd Temp-Table
   Params:  none
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hTable AS HANDLE NO-UNDO.
  
  &SCOPED-DEFINE xpRowObjUpdTable 
  {get RowObjUpdTable hTable}.
  &UNDEFINE xpRowObjUpdTable 
  
  RETURN hTable.

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

&IF DEFINED(EXCLUDE-getServerSubmitValidation) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getServerSubmitValidation Procedure 
FUNCTION getServerSubmitValidation RETURNS LOGICAL
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the value of the property which signals whether the
            column and RowObject Validation procedures done as part of
            client validation are to be executed on the server side. 
            If *yes*, normally when the SDO is being run through the 
            open client interface, then serverCommit will execute 
            SubmitValidation itself.
    Notes:  Because the set function verifies that the property is not
            reset from *yes* to *no* (for security purposes), the property 
            value is always accessed through the set and get functions.
------------------------------------------------------------------------------*/
  DEFINE VARIABLE lVal  AS LOGICAL NO-UNDO.

  &SCOPED-DEFINE xpServerSubmitValidation
  {get ServerSubmitValidation lVal}.
  &UNDEFINE xpServerSubmitValidation
  RETURN lVal.   /* Function return value. */

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
  Purpose: Returns a comma separated list of RowObject fields that are 
           mapped to database fields that has a word indexed.   
    Notes: This overrides query.p version completely.  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cIndexInfo  AS CHAR NO-UNDO.
  DEFINE VARIABLE cFieldList  AS CHAR NO-UNDO.
  DEFINE VARIABLE cColumnList AS CHAR NO-UNDO.
  DEFINE VARIABLE cColumn     AS CHAR NO-UNDO.
  DEFINE VARIABLE i           AS INT    NO-UNDO.
  
  /* The indexInformation contains all indexes for this dataobject */
  {get IndexInformation cIndexInfo}.

  IF cIndexInfo <> ? THEN
  DO:
    /* Get the word indexes from the IndexInformation function */
    cFieldList = DYNAMIC-FUNCTION('indexInformation' IN TARGET-PROCEDURE,
                                  'WORD':U, /* query  */
                                  'no':U,   /* no table delimiter */
                                  cIndexInfo).
 
    /* Remove qualifed columns (not in the SDO) and make the list comma 
       separated */
    DO i = 1 TO NUM-ENTRIES(cFieldList,CHR(1)):
      cColumn = ENTRY(i,cFieldList,CHR(1)).       
      IF INDEX(cColumn,".":U) = 0 THEN
        ASSIGN cColumnList = cColumnList 
                             + (IF cColumnList = "":U THEN "":U ELSE ",":U)
                             + cColumn.
    END. /* do i = 1 to num-entries cFieldList */
  END. /* cinfo <> ? */

  RETURN TRIM(cColumnList,",":U).

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setAsynchronousSDO) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setAsynchronousSDO Procedure 
FUNCTION setAsynchronousSDO RETURNS LOGICAL
  ( lAsynchronousSDO AS LOGICAL ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    {set AsynchronousSDO lAsynchronousSDO}.
    RETURN TRUE.                               

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setAutoCommit) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setAutoCommit Procedure 
FUNCTION setAutoCommit RETURNS LOGICAL
  ( plFlag AS LOGICAL ) :
/*------------------------------------------------------------------------------
  Purpose:  Sets the AutoCommit flag on or off; when On, every call to submitRow
            will result in a Commit.
   Params:  plFlag AS LOGICAL  -- If true, AutoCommit is set On.
------------------------------------------------------------------------------*/
  
  DEFINE VARIABLE lQuery AS LOGICAL NO-UNDO.
  /* IF The QueryObject property has been set off, then this object is just
     being used for update of another object's data. AutoCommit must be true
     because there is no temp-table to store uncommitted changes in. */
  IF NOT plFlag THEN
  DO:
    {get QueryObject lQuery}.
    IF NOT lQuery THEN 
      RETURN FALSE.
  END.   /* END IF NOT plFlag */
  &SCOPED-DEFINE xpAutoCommit
  {set AutoCommit plFlag}.
  &UNDEFINE xpAutoCommit
  RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setCheckCurrentChanged) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setCheckCurrentChanged Procedure 
FUNCTION setCheckCurrentChanged RETURNS LOGICAL
  ( plCheck AS LOGICAL ) :
/*------------------------------------------------------------------------------
  Purpose:  Sets a flag indicating whether the DataObject should check 
            if database record(s) have been changed since read, before 
            doing an update.
   Params:  plCheck AS LOGICAL -- YES if the code should check that the record
            has not been changed by another user and reject the change (default).
------------------------------------------------------------------------------*/

  {set CheckCurrentChanged plCheck}.
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setClientProxyHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setClientProxyHandle Procedure 
FUNCTION setClientProxyHandle RETURNS LOGICAL
  ( pcClientProxy AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose: To store the character version of the client-side SDO handle
   Params: The string containing the client-side SDO procedure handle
    Notes:  
------------------------------------------------------------------------------*/

  {set ClientProxyHandle pcClientProxy}.
  RETURN TRUE.

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

&IF DEFINED(EXCLUDE-setDataModified) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setDataModified Procedure 
FUNCTION setDataModified RETURNS LOGICAL
  ( plDataModified AS LOGICAL ) :
/*------------------------------------------------------------------------------
  Purpose: Backwards compatibility only to avoid error messages
    Notes: This is overridden   
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
  
  /* If the flag is already set, return false. */
  ASSIGN ghProp = WIDGET-HANDLE(ENTRY(1, TARGET-PROCEDURE:ADM-DATA, CHR(1)))
         ghProp = ghProp:BUFFER-FIELD('DataQueryBrowsed':U).
         
  IF plBrowsed THEN
  DO:
    lAlreadyBrowsed = ghProp:BUFFER-VALUE NO-ERROR.
    IF lAlreadyBrowsed THEN
      RETURN FALSE.
  END.   /* END DO IF plBrowsed */
 
  ASSIGN ghProp:BUFFER-VALUE = plBrowsed.
 
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

&IF DEFINED(EXCLUDE-setDestroyStateless) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setDestroyStateless Procedure 
FUNCTION setDestroyStateless RETURNS LOGICAL
  (plDestroy AS LOGICAL) :
/*------------------------------------------------------------------------------
  Purpose: Defines if the persistent sdo should be destroyed on stateless requests
    Notes: This is only possible to set to in WebSpeed (default). 
------------------------------------------------------------------------------*/
  {set DestroyStateless plDestroy}.
  RETURN TRUE.
  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setDisconnectAppserver) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setDisconnectAppserver Procedure 
FUNCTION setDisconnectAppserver RETURNS LOGICAL
  (plDisconnect AS LOGICAL) :
/*------------------------------------------------------------------------------
  Purpose: Defines if the persistent sdo should disconnect the AppServer.  
    Notes: This is only used for stateless WebSpeed SDO's that never are destroyed 
------------------------------------------------------------------------------*/
  {set DisconnectAppServer plDisconnect}.
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

&IF DEFINED(EXCLUDE-setLastDbRowIdent) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setLastDbRowIdent Procedure 
FUNCTION setLastDbRowIdent RETURNS LOGICAL
  ( pcLastDbRowIdent AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose: Sets the LastDbRowIdent property which is unknown if the last
           row has not been fetched, otherwise it is the database rowid(s)
           for the last row
   Params: pcLastDbRowIdent -- database RowId(s) of the last row
    Notes:   
    Notes:  
------------------------------------------------------------------------------*/
  {set LastDbRowIdent pcLastDbRowIdent}.
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
  Purpose: Sets the LastRowNum property which is unknown if the last
           row has not been fetched, otherwise it is the rownum of the 
           last row
   Params: pcLastRowNum -- Rownum of the last row
    Notes: LastRowNum is currently kept up to date on the server and passed
           to and from as part of context management. (The server only changes
           LastRowNum if the new one is higher). This is a problem on stateaware
           connections since new records are sorted last on the client, but the 
           context never is reset on the server after the last connection.  
           So we do a check here on the client for stateaware connections to 
           ensure that the lastrownum is not changed if already higher than the 
           passed number and the actual record with the high number exists and 
           is last. 
           There is an xp definition so the function is normally only called 
           from the context management both for sbos and sdos.             
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cOperatingMode AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDivision      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hRowObject     AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hQuery         AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hRowNum        AS HANDLE     NO-UNDO.
  DEFINE VARIABLE iCurrentLast   AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cQuery         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lKeepLast      AS LOGICAL    NO-UNDO.

  {get LastRowNum iCurrentLast}.
  IF iCurrentLast > piLastRowNum THEN
  DO:
    {get AsDivision cDivision}.
    {get ServerOperatingMode cOperatingMode}.  
    /* If we are on a stateaware client and the higher LastRowNum exists 
       we keep it. (see notes above)  */  
    IF cOperatingMode <> 'STATELESS':U AND cDivision = 'Client':U THEN
    DO:
      {get RowObject hRowObject}.    
      CREATE BUFFER hRowObject FOR TABLE hRowObject.
      CREATE QUERY  hQuery.
      
      hQuery:ADD-BUFFER(hRowObject).
      /* Although this is not intended to be a sanity check and local sort and
         queries also must setLastRowNum, they may do this with a function call 
         so we cannot just check for existance of the record, but have to 
         use the current query and get-last */          
      {get DataQueryString cQuery}.      
      hQuery:QUERY-PREPARE(cQuery).                           
      hQuery:QUERY-OPEN(). 
      hQuery:GET-LAST. 
      hRowNum   = hRowObject:BUFFER-FIELD('RowNum':U).
      lKeepLast = hRowObject:AVAILABLE AND hRowNum:BUFFER-VALUE = iCurrentLast.

      DELETE OBJECT hQuery.
      DELETE OBJECT hRowObject.

      IF lKeepLast THEN
        RETURN TRUE.
    END.
  END.
  
  {set LastRowNum piLastRowNum}.

  RETURN TRUE.
                              
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setManualAddQueryWhere) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setManualAddQueryWhere Procedure 
FUNCTION setManualAddQueryWhere RETURNS LOGICAL
  ( cString AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose: Store manual calls to addquerywhere so that filter can reapply this
           when filter is changed, thus ensuring the original query stays intact. 
    Notes: Value is pcwhere + chr(3) + pcbuffer or empty or "?" + chr(3) + pcandor 
           Note that multiple entries are supported, seperated by chr(4).
------------------------------------------------------------------------------*/
  {set ManualAddQueryWhere cString}.
  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setManualAssignQuerySelection) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setManualAssignQuerySelection Procedure 
FUNCTION setManualAssignQuerySelection RETURNS LOGICAL
  ( cString AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose: Store manual calls to assignqueryselection so that filter can reapply this
           when filter is changed, thus ensuring the original query stays intact. 
    Notes: Value is pccolumns + chr(3) + pcvalues + chr(3) + pcoperators 
           Note that multiple entries are supported, seperated by chr(4).
------------------------------------------------------------------------------*/
  {set ManualAssignQuerySelection cString}.
  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setManualSetQuerySort) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setManualSetQuerySort Procedure 
FUNCTION setManualSetQuerySort RETURNS LOGICAL
  ( cString AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose: Store manual calls to setquerysort so that filter can reapply this
           when filter is changed, thus ensuring the original query stays intact. 
    Notes: Value is pcsort 
           Note that multiple entries are supported, seperated by chr(4).
------------------------------------------------------------------------------*/
  {set ManualSetQuerySort cString}.
  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setQueryContext) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setQueryContext Procedure 
FUNCTION setQueryContext RETURNS LOGICAL
  (pcQueryContext AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose: Set the queryContext on the client 
Parameter: pcQueryContext - complete query string 
    Notes: For INTERNAL use only , exists as function so that it can be 
           accessed in generic set PROP calls.     
------------------------------------------------------------------------------*/
 
  {set QueryContext pcQueryContext}.
  RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setQueryRowIdent) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setQueryRowIdent Procedure 
FUNCTION setQueryRowIdent RETURNS LOGICAL
  ( pcRowIdent AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Sets the property which holds a RowIdent to be used to
            position an SDO query when it if first opened.
    Params: pcRowIdent AS CHARACTER -- Rowid or comma-separated list of
            Rowids of the database record(s) to be positioned to.
    Notes:  Generally used to save the position of a query when it is
            closed so that position can be restored on re-open.
------------------------------------------------------------------------------*/

  {set QueryRowIdent pcRowIdent}.
  RETURN true.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setQueryWhere) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setQueryWhere Procedure 
FUNCTION setQueryWhere RETURNS LOGICAL
  (pcWhere AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       (See getOpenQuery for the original where clause.)
               The Where clause is stored locally on the client for stateless 
               SDOs and SDOs within SBOs. 
               In stateless mode restartServerObject will pass it as part 
               of the context.  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cQueryWhere     AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cOperatingMode  AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cAsDivision     AS CHARACTER NO-UNDO.
  DEFINE VARIABLE hContainer      AS HANDLE    NO-UNDO.
  DEFINE VARIABLE lOk             AS LOGICAL   NO-UNDO. 
  DEFINE VARIABLE lQueryContainer AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE lAsBound        AS LOGICAL   NO-UNDO.

  {get AsDivision cAsDivision}.

  IF cAsDivision = 'CLIENT':U THEN 
  DO:
    {get ContainerSource hContainer}.      
    {get serverOperatingMode cOperatingMode}.
    IF VALID-HANDLE(hContainer) THEN
    DO:
      {get QueryObject lQueryContainer hContainer}.
      /* If SBO container and not stateless, check if container is stateless*/
      IF lQueryContainer THEN
         {get serverOperatingMode cOperatingMode hContainer}.
    END. /* valid container */
    
    /* 
    If 'client' and operatingmode is 'none' then we are most likely not 
    bound yet and can use queryContext even for stateaware connections 
    as the first connection have not yet happened and will be similar to 
    a stateless one and pass queryContext as   */ 
    lAsBound = ?. 
    IF cOperatingMode = 'NONE':U OR cOperatingMode = '':U THEN
      {get AsBound lAsBound}.

    /* We store the query locally for stateless as restartServerObject will 
       pass it, and we always store it locally for SBOs */
    IF lAsBound = FALSE OR cOperatingMode = 'STATELESS':U OR lQueryContainer THEN
    DO:
      cQueryWhere = {fnarg newQueryWhere pcWhere}.
      
      IF cQueryWhere <> ? THEN
        {set QueryContext cQueryWhere}.
      
      RETURN cQueryWhere <> ?.
    END. /* If Stateless */
  END. /* client */
  
  RETURN SUPER(pcWhere).

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
 
  Parameters:
    INPUT pcState - Can only be 'RowUpdated' OR 'NoUpdates'
    Notes:    When we get 'NoUpdates' and we have a Commit Panel; our 
              datasource have suppressed any 'UpdateComplete' events
              they have received until we are committed, so we send that
              updatestate event now.
------------------------------------------------------------------------------*/
  DEFINE VARIABLE lCommit AS LOG    NO-UNDO INIT ?.

  ASSIGN ghProp = WIDGET-HANDLE(ENTRY(1, TARGET-PROCEDURE:ADM-DATA, CHR(1)))
         ghProp = ghProp:BUFFER-FIELD('RowObjectState':U)
         ghProp:BUFFER-VALUE = pcState.
  
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

&IF DEFINED(EXCLUDE-setRowObjectTable) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setRowObjectTable Procedure 
FUNCTION setRowObjectTable RETURNS LOGICAL
  ( phTable AS HANDLE ) :
/*------------------------------------------------------------------------------
  Purpose: Sets the property which stores the RowObject temp-table handle.
   Params: phTable AS HANDLE -- temp-table handle
    Notes: This is the handle to the temp-table itself, not its buffer.
           Supports dynamic SDO (not valid RowObject) by also setting 
           RowObject and DataHandle if it is unknown or different.
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cQueryString AS CHARACTER NO-UNDO.
  DEFINE VARIABLE hRowobject   AS HANDLE NO-UNDO.
  DEFINE VARIABLE hDataHandle  AS HANDLE NO-UNDO.
  
  {get RowObject hRowObject}.    /* Existing temp-table buffer. */
  
  /* We ensure that query and buffer handle properties is correct also */
  IF NOT VALID-HANDLE(hRowObject) 
  OR hRowObject <> phTable:DEFAULT-BUFFER-HANDLE THEN
  DO:
    {set RowObject phTable:DEFAULT-BUFFER-HANDLE}. /* Point to new buffer. */    
    {get DataHandle hDataHandle}.  /* Query handle */
    
    DELETE OBJECT hDataHandle NO-ERROR.  
    DELETE OBJECT hRowObject  NO-ERROR. 

    CREATE QUERY hDataHandle.
    {set DataHandle hDataHandle}.
    
    /* Something should be done with the ghDataQuery variable in data.i  */ 
    hDataHandle:SET-BUFFERS(phTable:DEFAULT-BUFFER-HANDLE).
    {get DataQueryString cQueryString}.
                              /* Fix european format issues */
    hDataHandle:QUERY-PREPARE({fnarg fixQueryString cQueryString}).
  END. /* not valid hRowObject */

  &SCOPED-DEFINE xpRowObjectTable
  {set RowObjectTable phTable}.
  &UNDEFINE xpRowObjectTable  
  
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setRowObjUpdTable) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setRowObjUpdTable Procedure 
FUNCTION setRowObjUpdTable RETURNS LOGICAL
   ( phTable AS HANDLE ) :
/*------------------------------------------------------------------------------
    Purpose: Sets the property which stores the RowObject temp-table handle.
     Params: phTable AS HANDLE -- temp-table handle
      Notes: This is the handle to the temp-table itself, not its buffer.
             Supports dynamic SDO (not valid RowObject) by also setting 
             RowObject and DataHandle if it is unknown or different.
------------------------------------------------------------------------------*/
  
 DEFINE VARIABLE hRowobjUpd   AS HANDLE NO-UNDO.
 {get RowObjUpd hRowObjUpd}.    /* Existing temp-table buffer. */
  
 /* We ensure that query and buffer handle properties is correct also */
 IF NOT VALID-HANDLE(hRowObjUpd) 
 OR hRowObjUpd <> phTable:DEFAULT-BUFFER-HANDLE THEN
 DO:
   {set RowObjUpd phTable:DEFAULT-BUFFER-HANDLE}. /* Point to new buffer. */    
   DELETE OBJECT hRowObjUpd  NO-ERROR. 
 END.
 &SCOPED-DEFINE xpRowObjUpdTable
 {set RowObjUpdTable phTable}.
 &UNDEFINE xpRowObjUpdTable  
 
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

&IF DEFINED(EXCLUDE-setServerSubmitValidation) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setServerSubmitValidation Procedure 
FUNCTION setServerSubmitValidation RETURNS LOGICAL
  ( plVal AS LOGICAL ) :
/*------------------------------------------------------------------------------
  Purpose:  Sets the value of the property which signals whether the
            column and RowObject Validation procedures done as part of
            client validation should be executed on the server. 
            It is *no* by default; an SDO which uses client
            validation and which may be run from the open client interface
            should set it to *yes*, either in the SDO itself or at runtime.
            If it is *no* when serverCommit executes, then serverCommit 
            will execute SubmitValidation itself.
   Params:  plVal AS LOGICAL  -- yes if client validation should be executed
              in the server SDO.
   Notes:   As a security measure, if the property has been set to *yes*,
            it cannot be reset to *no*.
------------------------------------------------------------------------------*/
  DEFINE VARIABLE lVal AS LOGICAL NO-UNDO.
  
  {get ServerSubmitValidation lVal}.
  IF lVal = YES THEN
    RETURN plVal.   /* Cannot be reset from yes value to no. */
  ELSE DO:
    &SCOPED-DEFINE xpServerSubmitValidation
    {set ServerSubmitValidation lVal}.
    &UNDEFINE xpServerSubmitValidation
    RETURN TRUE.      /* signal that the property was reset successfully. */
  END.

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

