&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*********************************************************************
* Copyright (C) 2005 by Progress Software Corporation. All rights    *
* reserved.  Prior versions of this work may contain portions        *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*--------------------------------------------------------------------------
    File        : dataext.p
    Purpose     : Support procedure for Data Object.  This is an extension
                  of data.p.  The extension is necessary to avoid an overflow
                  of the action segment.  From 9.1B this extension file contains
                  all of the get and set property functions. 
                  From Dynamics 2.1/ v10 it also includes the do* procedures. 
                  These will probably be rolled back into data.p when segment 
                  size increases. (rolled? )

    Syntax      : adm2/dataext.p
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

&IF DEFINED(EXCLUDE-getCacheDuration) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getCacheDuration Procedure 
FUNCTION getCacheDuration RETURNS INTEGER
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

&IF DEFINED(EXCLUDE-getCurrentRowModified) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getCurrentRowModified Procedure 
FUNCTION getCurrentRowModified RETURNS LOGICAL
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDataDelimiter) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getDataDelimiter Procedure 
FUNCTION getDataDelimiter RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

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

&IF DEFINED(EXCLUDE-getDataModified) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getDataModified Procedure 
FUNCTION getDataModified RETURNS LOGICAL
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDataReadBuffer) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getDataReadBuffer Procedure 
FUNCTION getDataReadBuffer RETURNS HANDLE
  ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDataReadColumns) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getDataReadColumns Procedure 
FUNCTION getDataReadColumns RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDataReadFormat) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getDataReadFormat Procedure 
FUNCTION getDataReadFormat RETURNS CHARACTER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDataReadHandler) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getDataReadHandler Procedure 
FUNCTION getDataReadHandler RETURNS HANDLE
  ( )  FORWARD.

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

&IF DEFINED(EXCLUDE-getDynamicData) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getDynamicData Procedure 
FUNCTION getDynamicData RETURNS LOGICAL
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getForeignFieldsContainer) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getForeignFieldsContainer Procedure 
FUNCTION getForeignFieldsContainer RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

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

&IF DEFINED(EXCLUDE-getIndexInfoTables) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getIndexInfoTables Procedure 
FUNCTION getIndexInfoTables RETURNS CHARACTER
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

&IF DEFINED(EXCLUDE-getIsRowObjectExternal) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getIsRowObjectExternal Procedure 
FUNCTION getIsRowObjectExternal RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getIsRowObjUpdExternal) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getIsRowObjUpdExternal Procedure 
FUNCTION getIsRowObjUpdExternal RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

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

&IF DEFINED(EXCLUDE-getQueryOpen) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getQueryOpen Procedure 
FUNCTION getQueryOpen RETURNS LOGICAL
  (  )  FORWARD.

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

&IF DEFINED(EXCLUDE-getRowIdent) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getRowIdent Procedure 
FUNCTION getRowIdent RETURNS CHARACTER
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

&IF DEFINED(EXCLUDE-getRunDataLogicProxy) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getRunDataLogicProxy Procedure 
FUNCTION getRunDataLogicProxy RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getSchemaLocation) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getSchemaLocation Procedure 
FUNCTION getSchemaLocation RETURNS CHARACTER
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

&IF DEFINED(EXCLUDE-getShareData) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getShareData Procedure 
FUNCTION getShareData RETURNS LOGICAL
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getUseStaticOnFetch) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getUseStaticOnFetch Procedure 
FUNCTION getUseStaticOnFetch RETURNS LOGICAL
  (  )  FORWARD.

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

&IF DEFINED(EXCLUDE-setAsynchronousSDO) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setAsynchronousSDO Procedure 
FUNCTION setAsynchronousSDO RETURNS LOGICAL
  ( lAsynchronousSDO AS LOGICAL )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setCacheDuration) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setCacheDuration Procedure 
FUNCTION setCacheDuration RETURNS LOGICAL
  ( piCacheDuration AS INTEGER  )  FORWARD.

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

&IF DEFINED(EXCLUDE-setDataDelimiter) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setDataDelimiter Procedure 
FUNCTION setDataDelimiter RETURNS LOGICAL
  ( pcDelimiter AS CHAR )  FORWARD.

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

&IF DEFINED(EXCLUDE-setDataReadBuffer) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setDataReadBuffer Procedure 
FUNCTION setDataReadBuffer RETURNS LOGICAL
  ( phBuffer AS HANDLE )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setDataReadColumns) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setDataReadColumns Procedure 
FUNCTION setDataReadColumns RETURNS LOGICAL
  ( pcColumns AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setDataReadFormat) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setDataReadFormat Procedure 
FUNCTION setDataReadFormat RETURNS LOGICAL
  ( pcFormat AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setDataReadHandler) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setDataReadHandler Procedure 
FUNCTION setDataReadHandler RETURNS LOGICAL
  ( phHandle AS HANDLE )  FORWARD.

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

&IF DEFINED(EXCLUDE-setDynamicData) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setDynamicData Procedure 
FUNCTION setDynamicData RETURNS LOGICAL
  ( plDynamic AS LOGICAL  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setIsRowObjectExternal) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setIsRowObjectExternal Procedure 
FUNCTION setIsRowObjectExternal RETURNS LOGICAL
  ( plExternal AS LOGICAL)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setIsRowObjUpdExternal) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setIsRowObjUpdExternal Procedure 
FUNCTION setIsRowObjUpdExternal RETURNS LOGICAL
  ( plExternal AS LOGICAL)  FORWARD.

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

&IF DEFINED(EXCLUDE-setLastDbRowIdent) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setLastDbRowIdent Procedure 
FUNCTION setLastDbRowIdent RETURNS LOGICAL
  ( pcLastDbRowIdent AS CHARACTER )  FORWARD.

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

&IF DEFINED(EXCLUDE-setRowObjUpd) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setRowObjUpd Procedure 
FUNCTION setRowObjUpd RETURNS LOGICAL
  ( phRowObjUpd AS HANDLE )  FORWARD.

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

&IF DEFINED(EXCLUDE-setRunDataLogicProxy) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setRunDataLogicProxy Procedure 
FUNCTION setRunDataLogicProxy RETURNS LOGICAL
  ( plRunProxy AS LOGICAL )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setSchemaLocation) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setSchemaLocation Procedure 
FUNCTION setSchemaLocation RETURNS LOGICAL
  (pcSchemaLocation AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setServerSubmitValidation) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setServerSubmitValidation Procedure 
FUNCTION setServerSubmitValidation RETURNS LOGICAL
  ( plSubmit AS LOGICAL )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setShareData) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setShareData Procedure 
FUNCTION setShareData RETURNS LOGICAL
  ( plShareData AS LOGICAL )  FORWARD.

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
         HEIGHT             = 21.91
         WIDTH              = 53.8.
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


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-doBuildUpd) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE doBuildUpd Procedure 
PROCEDURE doBuildUpd :
/*------------------------------------------------------------------------------
  Purpose:     Transfers changed rows into the Update Temp-Table and returns
               it to the caller (the Commit function).

  Parameters:  None

  Notes:       For each existing row to be updated, there is already a "before"
               copy in the RowObjUpd table, so we create an "after" row.
               There is already a row in RowObjUpd for each Added/Copied row, 
               so we just update it with the latest values.
               There is already a row in RowObjUpd for each Deleted row, so
               we don't need to do anything for these rows.
------------------------------------------------------------------------------*/
DEFINE VARIABLE hRowObject AS HANDLE     NO-UNDO.
DEFINE VARIABLE hRowObjUpd AS HANDLE     NO-UNDO.
DEFINE VARIABLE hQuery     AS HANDLE     NO-UNDO.
DEFINE VARIABLE lAuto      AS LOGICAL    NO-UNDO.
    
  &SCOPED-DEFINE xp-assign
  {get RowObject hRowObject}    
  {get RowObjUpd hRowObjUpd}
  .
  &UNDEFINE xp-assign

  /* local buffer to the RowObject table to eliminate repositioning problems */
  CREATE BUFFER hRowObject  FOR TABLE hRowObject.

  CREATE QUERY  hQuery.
  hQuery:SET-BUFFERS(hRowObject).
  hQuery:QUERY-PREPARE('FOR EACH ' + hRowObject:NAME + ' WHERE RowMod = "U"':U).
  hQuery:QUERY-OPEN().
  hQuery:GET-FIRST().
  DO WHILE NOT hQuery:QUERY-OFF-END:
      hRowObjUpd:BUFFER-CREATE().
      hRowObjUpd:BUFFER-COPY(hRowObject).
      hQuery:GET-NEXT().
  END.
  hQuery:QUERY-CLOSE().

  hQuery:QUERY-PREPARE('FOR EACH ':U + hRowObject:NAME + 
                       ' WHERE RowMod = "A" OR RowMod = "C"':U).
  hQuery:QUERY-OPEN().
  hQuery:GET-FIRST().
  DO WHILE NOT hQuery:QUERY-OFF-END:
      hRowObjUpd:FIND-FIRST('WHERE RowNum = ':U + 
                            STRING(hRowObject:BUFFER-FIELD('RowNum':U):BUFFER-VALUE)).
      hRowObjUpd:BUFFER-COPY(hRowObject).
      hQuery:GET-NEXT().
  END.
  
  /* if this is an AutoCommit SDO, only one record is being processed, so leave it */
  /* available to be backwards compatible with earlier releases of the ADM */
  {get AutoCommit lAuto}.
  IF NOT lAuto THEN 
    hRowObjUpd:BUFFER-RELEASE.

  DELETE OBJECT hRowObject.
  DELETE OBJECT hQuery.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-doCreateUpdate) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE doCreateUpdate Procedure 
PROCEDURE doCreateUpdate :
/*------------------------------------------------------------------------------
  Purpose:     FINDs the specified row to be updated and creates a "backup" 
               (a before-image) copy of it in the RowObjUpd table, to support
               Undo.  Run from submitRow when it receives a set of value 
               changes from a UI object.

  Parameters:
    INPUT  pcRowIdent  - encoded "key" of the row to be updated.
    INPUT  pcValueList - the list of changes made.  A CHR(1) delimited list
                         of FieldName/NewValue pairs.
    OUTPUT plReopen    - true if the row was new (either a copy or an add),
                         so reopen RowObject query.
    OUTPUT pcMessage   - error messages.
 
  Notes:       Run from submitRow.  Returns error message or "". 
               If the row is not available in the RowObject temp-table
               (this would be because the SmartDataObject was not the 
               DataSource) this routine FINDs the database record(s) using 
               the RowIdent key before applying the changes, unless it's a 
               new row.
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER pcRowIdent  AS CHARACTER NO-UNDO.
DEFINE INPUT  PARAMETER pcValueList AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER plReopen    AS LOGICAL   NO-UNDO.
DEFINE OUTPUT PARAMETER pcMessage   AS CHARACTER NO-UNDO.

DEFINE VARIABLE hRowObject  AS HANDLE     NO-UNDO.
DEFINE VARIABLE hRowObjUpd  AS HANDLE     NO-UNDO.
DEFINE VARIABLE hDataQuery  AS HANDLE     NO-UNDO.
DEFINE VARIABLE iNextRowNum AS INTEGER    NO-UNDO.
DEFINE VARIABLE rRowObject  AS ROWID      NO-UNDO.

  &SCOPED-DEFINE xp-assign
  {get RowObject hRowObject}    
  {get RowObjUpd hRowObjUpd}
  /* get the "Data" (RowObject) query handle */
  {get DataHandle hDataQuery}
  .
  &UNDEFINE xp-assign

  /* We postpone RowObjUpd table creation for dynamic SDOs until really needed, 
     which will be now... */ 
  IF NOT VALID-HANDLE(hRowObjUpd) THEN
  DO:
    {fn createRowObjUpdTable}.
    {get RowObjUpd hRowObjUpd}.
  END.
  
  CREATE BUFFER hRowObjUpd FOR TABLE hRowObjUpd.
   
  rRowObject = TO-ROWID(ENTRY(1, pcRowIdent)) NO-ERROR.

  /* If it is empty, re-FIND the db rec(s), unless it's a newly */
  /* added row (no db rowids in RowIdent).                    */
  IF (NOT hDataQuery:IS-OPEN OR hDataQuery:NUM-RESULTS = 0) AND
      NUM-ENTRIES(pcRowIdent) > 1 AND ENTRY(2, pcRowIdent) NE "":U THEN
  DO:
    /* Now create a RowObject record and assign a RowNum to it. */
    hRowObject:BUFFER-CREATE().
    {get LastRowNum iNextRowNum}.
    iNextRowNum = iNextRowNum + 1.
    hRowObject:BUFFER-FIELD('RowNum':U):BUFFER-VALUE = iNextRowNum.
    /* This creates a temp-table row from the db recs. */
    RUN transferDBRow IN TARGET-PROCEDURE(pcRowIdent, iNextRowNum). 
    {set LastRowNum inextRowNum}.
  END. /* END DO if no query */
  /* Note that a similar find has been added to v10 submitRow, which calls this.
     This is kept just in case although this really is a very, very, very 
     internal procedure..  */ 
  ELSE 
  IF NOT hRowObject:AVAILABLE OR rRowObject NE hRowObject:ROWID THEN 
    hRowObject:FIND-BY-ROWID(rRowObject).
  
  /* First check to see if there's already a saved pre-change version 
     of the record; this would be so if the same row is changed 
     multiple times before commit. */
  hRowObjUpd:FIND-FIRST('WHERE RowNum = ':U + 
                        STRING(hRowObject:BUFFER-FIELD('RowNum':U):BUFFER-VALUE))
                        NO-ERROR.
  DO TRANSACTION:
    IF NOT hRowObjUpd:AVAILABLE THEN
    DO:
      hRowObjUpd:BUFFER-CREATE().
      hRowObjUpd:BUFFER-COPY(hRowObject).
    END.        /* END DO IF NO ROU available */

    /* If this isn't an add/copy then  flag it as update. */
    IF hRowObject:BUFFER-FIELD('RowMod':U):BUFFER-VALUE NE "A":U AND 
       hRowObject:BUFFER-FIELD('RowMod':U):BUFFER-VALUE NE "C":U
    THEN 
        hRowObject:BUFFER-FIELD('RowMod':U):BUFFER-VALUE = "U":U. 
    ELSE 
        plReopen = TRUE.            /* Tell caller to reopen query. */
  END.     /* END TRANSACTION */

  pcMessage = "".   /* "Success" output value. */

  DELETE OBJECT hRowObjUpd.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-doEmptyTempTable) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE doEmptyTempTable Procedure 
PROCEDURE doEmptyTempTable :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       Cannot use EMPTY-TEMP-TABLE method within a TRANSACTION if the
               Temp-table is UNDO
------------------------------------------------------------------------------*/
DEFINE VARIABLE hRowObject AS HANDLE     NO-UNDO.
DEFINE VARIABLE hQuery     AS HANDLE     NO-UNDO.

  {get RowObject hRowObject}.    
  CREATE BUFFER hRowObject FOR TABLE hRowObject.

  CREATE QUERY  hQuery.
  hQuery:SET-BUFFERS(hRowObject).
  hQuery:QUERY-PREPARE('FOR EACH ' + hRowObject:NAME).
  hQuery:QUERY-OPEN().

  DO TRANSACTION:
      hQuery:GET-FIRST().
      DO WHILE NOT hQuery:QUERY-OFF-END:
          hRowObject:BUFFER-DELETE().
          hQuery:GET-NEXT().
      END.
  END.

  DELETE OBJECT hQuery.
  DELETE OBJECT hRowObject.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-doReturnToAddMode) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE doReturnToAddMode Procedure 
PROCEDURE doReturnToAddMode :
/*------------------------------------------------------------------------------
  Purpose:    Return current record to addmode after an unsuccesful commit   
  Parameters:  <none>
  Notes:      This is only used by the SBO to return to addmode when an Add 
              failed when AutoCommit. Since the SDO has AutoCommit doReturnUpd
              does not remove the ROwObjUpd.
           -  This logic is expected to become obsolete as ROwObjUpd records 
              for add/copy really are created too early.                      
------------------------------------------------------------------------------*/
DEFINE VARIABLE hRowObject AS HANDLE     NO-UNDO.
DEFINE VARIABLE hRowObjUpd AS HANDLE     NO-UNDO.

  &SCOPED-DEFINE xp-assign
  {get RowObject hRowObject}
  {get RowObjUpd hRowObjUpd}
  .
  &UNDEFINE xp-assign
  
  IF hRowObject:AVAILABLE AND VALID-HANDLE(hRowObjUpd) THEN
  DO:
     CREATE BUFFER hRowObjUpd FOR TABLE hRowObjUpd.

     hRowObjUpd:FIND-FIRST('WHERE RowNum = ':U +
                           string(hRowObject:BUFFER-FIELD('RowNum':U):BUFFER-VALUE) +
                           ' AND (RowMod = "A" OR RowMod = "C")':U) NO-ERROR.
     IF hRowObjUpd:AVAILABLE THEN
         hRowObjUpd:BUFFER-DELETE().

     DELETE OBJECT hRowObjUpd.
  END.

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-doReturnUpd) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE doReturnUpd Procedure 
PROCEDURE doReturnUpd :
/*------------------------------------------------------------------------------
  Purpose:     RUN from Commit on the client side to get back the Update 
               (RowObjUpd) table (from the server side) and undo any failed 
               changes or return final versions of record values to the client.
 
  Parameters:  
    INPUT cUndoIds - list of any RowObject Rownum whose changes were 
                     rejected by a commit. Delimited list of the form:
               "RowNumCHR(3)ADM-ERROR-STRING,RowNumCHR(3)ADM-ERROR-STRING,..."
           - A '?' as RowNum means do NOT reposition, but stay on current record. 
            
  Notes:   - If the error string in cUndoIds is "ADM-FIELDS-CHANGED", then
             another user has changed at least one field value.  In this 
             case, RowObjUpd fields will contain the refreshed db values 
             and we pass those values back to the client.
           - If not autocommit we may also reposition here, but otherwise the caller 
             both has the rowident and has more info. (submitCommit knows whether 
             a reopen is required, deleteRow just uses fetchNext if required) 
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pcUndoIds AS CHARACTER NO-UNDO.

  DEFINE VARIABLE hRowObject      AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hRowObject2     AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hRowObjUpd      AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hRowObjUpd2     AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hQuery          AS HANDLE     NO-UNDO.
 
  DEFINE VARIABLE lAutoCommit     AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE hDataQuery      AS HANDLE    NO-UNDO.
  DEFINE VARIABLE lQueryContainer AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE lBrowsed        AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE hMsgSource      AS HANDLE    NO-UNDO.
  DEFINE VARIABLE iCurrentRowNum  AS INTEGER   NO-UNDO.
  DEFINE VARIABLE iRowNum         AS INTEGER   NO-UNDO.
  DEFINE VARIABLE lCommitOk       AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE lQueryOpened    AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE iTempRowNum     AS INTEGER   NO-UNDO.
  DEFINE VARIABLE cFirstError     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cErrorType      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cKeyFields      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDataDelimiter  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iLoop           AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iLoop2          AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cKeyValues      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hRowObjUpdTable AS HANDLE     NO-UNDO.
  DEFINE VARIABLE lHasRecords     AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE hReadHandler     AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cReadFormat      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cReadcolumns     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hReadBuffer      AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cContainerName     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cUniqueObjectName  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cCommittedAction   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDataAvailMode     AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE cLargeColumns      AS CHARACTER   NO-UNDO.
  DEFINE VARIABLE cColumn            AS CHARACTER   NO-UNDO.
  DEFINE VARIABLE cSkipColumns       AS CHARACTER   NO-UNDO.
  DEFINE VARIABLE iLookup            AS INTEGER     NO-UNDO.

  &SCOPED-DEFINE xp-assign
  {get AutoCommit lAutoCommit}
  {get RowObject hRowObject}    
  {get RowObjUpd hRowObjUpd}
  {get RowObjUpdTable hRowObjUpdTable}
  {get ObjectName cUniqueObjectName}
  .
  &UNDEFINE xp-assign
  
  /* May be called from SBO when no table is defined (dynamic sdo with no updates)*/   
  IF NOT VALID-HANDLE(hRowObjUpdTable) THEN
    RETURN.

  lHasRecords = hRowObjUpdTable:HAS-RECORDS.

  /* local buffers */
  CREATE BUFFER hRowObject2 FOR TABLE hRowObject.
  CREATE BUFFER hRowObjUpd2 FOR TABLE hRowObjUpd. 

  /* set up RowObjUpd query */
  CREATE QUERY hQuery.
  hQuery:SET-BUFFERS(hRowObjUpd).

  /* Find out whether this SDO is inside an SBO or other Query Object. 
     If so, we will refer to that object to check for error messages. 
     We also adjust the object name passed back to the OpenAPI callback routines
     to guaranree uniqueness */
  {get QueryContainer lQueryContainer}.  
  IF lQueryContainer THEN 
  DO:
    {get ContainerSource hMsgSource}.
    {get ObjectName cContainerName hMsgSource}.
    cUniqueObjectName = cContainerName + '.':U + cUniqueObjectName.
  END.
  ELSE 
    hMsgSource = TARGET-PROCEDURE.

  lCommitOk = NOT DYNAMIC-FUNCTION('anyMessage':U IN hMsgSource) AND (pcUndoIds = "":U).

  /* we need this whether or not CommitOK */
  {get DataDelimiter cDataDelimiter}.

  /* Blank if no error.. */ 
  /* Commit successful. */
  IF lCommitOk THEN
  DO:

    &SCOPED-DEFINE xp-assign
     {set LastCommitErrorType '':U}
     {set LastCommitErrorKeys '':U}
     {get DataReadHandler hReadhandler}
     .
    &UNDEFINE xp-assign   
    
    IF VALID-HANDLE(hReadHandler) THEN
    DO:  

     &SCOPED-DEFINE xp-assign   
      {get DataReadColumns cReadColumns}
      {get DataReadFormat cReadFormat}
      {get DataReadBuffer hReadBuffer}
      .
     &UNDEFINE xp-assign  
     
    END.

    /* Delete ALL RowObjUpd records, but before the delete, move updated versions of records
       back into the RowObject table for the client to see (they may have new values from CREATE 
       or WRITE triggers or other server side logic) "A" = Add, "C" = Copy, "U" = update. */
    hQuery:QUERY-PREPARE('FOR EACH ' + hRowObjUpd:NAME).
    hQuery:QUERY-OPEN().
    hQuery:GET-FIRST().
    DO WHILE hRowObjUpd:AVAILABLE:
      ASSIGN
        cCommittedAction = hRowObjUpd:BUFFER-FIELD('RowMod':U):BUFFER-VALUE
        cCommittedAction = IF cCommittedAction = "A":U THEN "ADD":U 
                             ELSE IF cCommittedAction = "C":U THEN "COPY":U
                               ELSE IF cCommittedAction = "U":U THEN "UPDATE":U 
                                 ELSE IF cCommittedAction = "D":U THEN "DELETE":U 
                                   ELSE "":U.
      IF LOOKUP(cCommittedAction, "ADD,COPY,UPDATE":U) > 0 THEN
      DO:
        hRowObject2:FIND-FIRST('WHERE RowNum = ':U +
                               string(hRowObjUpd:BUFFER-FIELD('RowNum':U):BUFFER-VALUE)) NO-ERROR.
        IF hRowObject2:AVAILABLE THEN
        DO:
          hRowObject2:BUFFER-COPY(hRowObjUpd).
          hRowObject2:BUFFER-FIELD('RowMod':U):BUFFER-VALUE = "":U.
        END.
      END. /* can-do('A,C,U',RowObjUpd.Rowmod)  */

      /* Open API callback. */
      /* We only do this if we got here from 'commitData' (AutoCommit is OFF). */
      /* Otherwise the individual APIs (updateData, createData etc.) return the new values directly */
      IF NOT lAutoCommit AND VALID-HANDLE(hReadHandler) AND cCommittedAction > "":U THEN
      DO:          
        IF VALID-HANDLE(hReadBuffer) THEN
        DO:
          hReadBuffer:BUFFER-CREATE().
          hReadBuffer:BUFFER-COPY(hRowObjUpd).  
          RUN receiveCommittedBuffer IN hReadHandler 
             ( cUniqueObjectName,
               hReadBuffer ).
        END.
        ELSE DO:
          {get LargeColumns cLargeColumns}.
          cSkipColumns = cReadColumns.
          DO iloop = 1 TO NUM-ENTRIES(cLargeColumns):
            ASSIGN
              cColumn = ENTRY(iLoop,cLargeColumns)
              iLookup = LOOKUP(cColumn,cSkipColumns).
            IF iLookup > 0 THEN
              ENTRY(iLookup,cSkipColumns) = 'SKIP':U.
          END.
            
          RUN receiveCommittedData IN hReadHandler 
              ( cUniqueObjectName,
                cReadColumns,
                (IF LOOKUP(cCommittedAction, "ADD,COPY,UPDATE":U) > 0 THEN
                  DYNAMIC-FUNCTION('colStringValuesAnyRow' IN TARGET-PROCEDURE,
                                    hRowObject2,
                                    cSkipColumns,
                                    cReadFormat,
                                    cDataDelimiter)
                 ELSE hRowObjUpd:BUFFER-FIELD('RowIdent':U):BUFFER-VALUE),
                cCommittedAction ).
        END.
      END.
      hRowObjUpd:BUFFER-DELETE().
      hQuery:GET-NEXT().
    END. /* for each RowObjUpd */
    hQuery:QUERY-CLOSE().
  END.  /* Commit successful. */
  ELSE DO:    /* Commit not successful. */
    /* log the error type (the first encountered error) */ 
    ASSIGN
      cFirstError = ENTRY(1,pcUndoIds)
      cFirstError = TRIM(ENTRY(2,cFirstError,CHR(3))) NO-ERROR.
    CASE cFirstError:
      WHEN 'ADM-FIELDS-CHANGED':U THEN
         cErrorType = 'Conflict':U. 
      OTHERWISE
        cErrorType = 'Error':U. 
    END.
    {set LastCommitErrorType cErrorType}.

    /* log the key values of all failed records */
    {get KeyFields cKeyFields}.
    DO iLoop = 1 TO NUM-ENTRIES(pcUndoIds):
                      /* there is a trailing ',' in pcUndoIds */
      IF ENTRY(iLoop, pcUndoIds) = '':U THEN LEAVE. 
      hRowObject2:FIND-FIRST('WHERE RowNum = ':U + ENTRY(1, ENTRY(iLoop, pcUndoIds), CHR(3))) NO-ERROR.
      IF hRowObject2:AVAILABLE THEN
      DO iLoop2 = 1 TO NUM-ENTRIES(cKeyFields):
        cKeyValues = cKeyValues + (IF cKeyValues = "" THEN "" ELSE cDataDelimiter) +
                     string(hRowObject2:buffer-field(ENTRY(iLoop2, cKeyFields)):BUFFER-VALUE).
      END.
    END.
    {set LastCommitErrorKeys cKeyValues}.
    
    /* If not autocommit we want to know where we shall position to after */    
    IF NOT lAutoCommit THEN 
    DO:
      /* Keep track of where we are for no AutoCommit repositioning logic below */
      iCurrentRowNum = IF hRowObject:AVAILABLE THEN 
                         hRowObject:BUFFER-FIELD('RowNum':U):BUFFER-VALUE 
                       ELSE ?.  /* ? if not avail */ 
      
      /* We noramlly reposition to the firstr entry passed in, note that a 
         value of '?' in the first RowNum entry  means that we must stay where 
         we are */  
      IF pcUndoIds <> '':U THEN
        iRowNum = INTEGER(ENTRY(1, ENTRY(1, pcUndoIds, ",":U), CHR(3))).
      
      /* Do we need to restore deleted records? */
      hRowObjUpd:FIND-FIRST('WHERE RowMod = "D"':U) NO-ERROR.
      IF hRowObjUpd:AVAILABLE THEN 
      DO:
        /* If nowhere to reposition to yet, then position to the first undeleted row */ 
        IF iRowNum = 0 THEN 
          iRowNum = hRowObjUpd:BUFFER-FIELD('RowNum':U):BUFFER-VALUE.

        /* Restore deleted records */
        RUN doUndoDelete IN TARGET-PROCEDURE. 
        {fnarg openDataQuery '':U}.
        lQueryOpened = TRUE.  /* Must reposition below  */ 
      END.          
    END. /* not autocommit  */

    /* Go through each 'U' copy and use it to find the 'before-image' for delete
       or refresh also copy the contents to rowObject if adm-fields-changed */
    hQuery:QUERY-PREPARE('FOR EACH ' + hRowObjUpd:NAME + ' WHERE RowMod = "U"':U).
    hQuery:QUERY-OPEN().
    hQuery:GET-FIRST().
    DO WHILE hRowObjUpd:AVAILABLE:
      iTempRowNum = hRowObjUpd:BUFFER-FIELD('RowNum':U):BUFFER-VALUE.
      /* Refreshing the update record if required (changed data was reset on server).*/
      IF INDEX(pcUndoIds,STRING(iTempRowNum) + CHR(3) + "ADM-FIELDS-CHANGED":U) <> 0 THEN
      DO:
        hRowObject:FIND-FIRST('WHERE RowNum = ':U + STRING(iTempRowNum)).
        /* Copy the refreshed db field values to row object. */
        hRowObject:BUFFER-COPY(hRowObjUpd,'RowMod':U).
        
        hRowObjUpd2:FIND-FIRST('WHERE RowNum = ':U + STRING(iTempRowNum) + ' AND RowMod = ""').
          /* Copy the refreshed db field values to the pre-commit row.
             Don't copy over the RowMod (that could change what the
             record is used for). And don't copy over ChangedFields. Leave
             that as the client set it. */
        hRowObjUpd2:BUFFER-COPY(hRowObjUpd,'RowMod,ChangedFields':U).
      END. /* UndoIds matches RowNum and ADM-FIELDS-CHANGED */

      /* The pre-commit update record (RowMod = "") contains the right values for
         an undo, so we no longer need the commit copy (RowMod = "U") of
         the update record. */
      hRowObjUpd:BUFFER-DELETE().
      hQuery:GET-NEXT().
    END. /* for each RowObjUpd .. RowMod = "U" */     
    hQuery:QUERY-CLOSE().

    /* Failed AutoCommit Add, copy and Delete should also be removed.
       Non AutoCommit currently need to be kept as they are creted on save
       not on the actual commit, but an Autocommit SBO also has the SDO in 
       non autocommit and calls doReturnToAddMode to get rid of the RowObjUpd 
       in cases where it was in add mode before the save.*/
    IF lAutoCommit THEN
    DO:
      hQuery:QUERY-PREPARE('FOR EACH ':U + hRowObjUpd:NAME + 
                           ' WHERE RowMod = "A" OR RowMod = "C" OR RowMod = "D"':U).
      hQuery:QUERY-OPEN().
      hQuery:GET-FIRST().
      DO WHILE hRowObjUpd:AVAILABLE:
        hRowObjUpd:BUFFER-DELETE().
        hQuery:GET-NEXT().
      END.
      hQuery:QUERY-CLOSE().
    END.    
  END.  /* commit not successful */

  IF lHasRecords THEN
  DO:
      /* Deal with reopen, reposition and publish dataavailable for non auto commit */
      IF NOT lAutoCommit THEN
      DO:
        &SCOPED-DEFINE xp-assign
        {get QueryContainer lQueryContainer}
        {get DataQueryBrowsed lBrowsed}
        .
        &UNDEFINE xp-assign
        
        IF lCommitOk THEN
        DO:
          {set RowObjectState 'NoUpdates':U}.
          /* If not Autocommit changes can be to more than one record, so if object
             is being browsed then ensure all records in the browser are refreshed 
             correctly.*/
          IF lBrowsed THEN
            PUBLISH 'refreshBrowse':U FROM TARGET-PROCEDURE.
          /* The SBO does publish dataavailable, when all objects have been returned,
             so don't do it here. */
          IF NOT lQueryContainer THEN
            PUBLISH "dataAvailable":U FROM TARGET-PROCEDURE ('SAME':U). 
        END. /* CommitOk */
        ELSE DO:
          hRowObject:FIND-FIRST('WHERE RowNum = ':U +
                                (IF iRowNum = ? OR iRowNum = 0 
                                    THEN STRING(iCurrentRowNum) 
                                    ELSE STRING(iRowNum))) NO-ERROR.

          /* just in case the above failed (RowNum 0 and no current rec maybe.. ) */
          IF NOT hRowObject:AVAILABLE THEN
            hRowObject:FIND-FIRST() NO-ERROR.

          /* If we have changed position we need to reposition the query also if
             we are not browsed (fetchNext etc. assumes that the query is synched) */
          IF lQueryOpened
          OR hRowObject:AVAILABLE AND 
            hRowObject:BUFFER-FIELD('RowNum':U):BUFFER-VALUE <> iCurrentRowNum  THEN 
          DO:
            {get DataHandle hDataQuery}.
            hDataQuery:REPOSITION-TO-ROWID(hRowObject:ROWID) NO-ERROR.
            /* if not browsed, get-next to get the buffer */
            IF (ERROR-STATUS:GET-MESSAGE(1) = '':U) AND NOT lBrowsed THEN 
              hDataQuery:GET-NEXT.
          END. 

          hRowObject2:FIND-FIRST('WHERE RowMod <> ""':U) NO-ERROR.
          IF NOT hRowObject2:AVAILABLE THEN
            {set RowObjectState 'NoUpdates':U}.

          RUN updateQueryPosition IN TARGET-PROCEDURE.         

         IF NOT lQueryContainer THEN 
         DO:
            PUBLISH "dataAvailable":U FROM TARGET-PROCEDURE
               /* not avail is overkill as there always is a rowObject in 
                  an undo, but.. */
               (IF NOT hRowObject:AVAILABLE OR 
                   hRowObject:BUFFER-FIELD('RowNum':U):BUFFER-VALUE <> iCurrentRowNum   
                THEN 'DIFFERENT':U                  
                ELSE 'SAME':U).
            {set NewBatchInfo '':U}.
          END.   
        END.  /* not ok  */
      END. /* not autocommit */
  END.

  DELETE OBJECT hQuery.
  DELETE OBJECT hRowObjUpd2.
  DELETE OBJECT hRowObject2.

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-doUndoDelete) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE doUndoDelete Procedure 
PROCEDURE doUndoDelete :
/*------------------------------------------------------------------------------
  Purpose:     Restore deleted rows. 
  Parameters:  <none>
 
  Notes:       This is separated because: 
               - a failed commit should restore this, otherwise the user has to 
                 undo to correct mistakes. 
               - The regualar undo need to restore these.
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hRowObject      AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hRowObjUpd      AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hQuery          AS HANDLE     NO-UNDO.
  DEFINE VARIABLE iFirstRowNum    AS INTEGER   NO-UNDO.
  DEFINE VARIABLE iLastRowNum     AS INTEGER   NO-UNDO.
  DEFINE VARIABLE cLastResultRow  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFirstResultRow AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hRowNum         AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hRowident       AS HANDLE     NO-UNDO.
  DEFINE VARIABLE lNew            AS LOGICAL    NO-UNDO.

  &SCOPED-DEFINE xp-assign
  {get RowObjUpd hRowObjUpd}
  {get RowObject hRowObject}
  &UNDEFINE xp-assign
  .

  IF NOT VALID-HANDLE(hRowObjUpd) THEN
    RETURN.

  CREATE BUFFER hRowObjUpd FOR TABLE hRowObjUpd.
  CREATE BUFFER hRowObject FOR TABLE hRowObject.

  CREATE QUERY hQuery.
  hQuery:SET-BUFFERS(hRowObjUpd).
  /* Start from last so the first delete is avail when we are finished */ 
  hQuery:QUERY-PREPARE('FOR EACH ' + hRowObjUpd:NAME + 
                       ' WHERE RowMod = "D" BY RowNum DESCENDING':U).
  hQuery:QUERY-OPEN().
  hQuery:GET-FIRST().
  ASSIGN
    hRowNum   = hRowObjUpd:BUFFER-FIELD('RowNum':U)
    hRowIdent = hRowObjUpd:BUFFER-FIELD('RowIdent':U).

  DO WHILE NOT hQuery:QUERY-OFF-END:
    lNew = hRowIdent:BUFFER-VALUE = '':U.
    
    hRowObject:BUFFER-CREATE().
    hRowObject:BUFFER-COPY(hRowObjUpd).
    hRowObject:BUFFER-FIELD('RowMod':U):BUFFER-VALUE = IF lNew THEN 'A':U ELSE '':U.

    /* Reset the firstRowNum if the undeleted record is before the current */
    {get FirstRowNum iFirstRowNum}.
    IF hRowNum:BUFFER-VALUE < iFirstRowNum THEN
       {set FirstRowNum hRowNum:BUFFER-VALUE}.
    
    IF NOT lNew THEN
    DO:
      /* Reset the firstResultRow if the undeleted record is before the current */
      {get FirstResultRow cFirstResultRow}.
      iFirstRowNum = INT(ENTRY(1,cFirstResultRow,";":U)).
      IF hRowNum:BUFFER-VALUE < iFirstRowNum THEN
      DO:
        cFirstResultRow = hRowNum:BUFFER-VALUE + ";":U + hRowIdent:BUFFER-VALUE.
        {set FirstResultRow cFirstResultRow}.
      END.
    END. /* Not new */

    /* Reset the LastRowNum if the undeleted record is after the current */
    {get LastRowNum iLastRowNum}.
    IF hRowObjUpd:BUFFER-FIELD('RowNum':U):BUFFER-VALUE > iLastRowNum THEN
    DO:
      &SCOPED-DEFINE xp-assign        
      {set LastRowNum hRowObjUpd:BUFFER-FIELD('RowNum':U):BUFFER-VALUE}
      {set LastDbRowIdent hRowObjUpd:BUFFER-FIELD('RowIdent':U):BUFFER-VALUE}
      .
      &UNDEFINE xp-assign             
    END.
    
    IF NOT lNew THEN
    DO:
      /* Reset the LastResultRow if the undeleted record is after the current */
      {get LastResultRow cLastResultRow}.
      iLastRowNum = INT(ENTRY(1,cLastResultRow,";":U)).
      IF hRowNum:BUFFER-VALUE > iLastRowNum THEN
      DO:
        cLastResultRow = hRowNum:BUFFER-VALUE + ";":U
                       + hRowObjUpd:BUFFER-FIELD('RowIdent':U):BUFFER-VALUE.
        {set LastResultRow cLastResultRow}.
      END.
    END. /* not new */
    hRowObjUpd:BUFFER-DELETE().
    hQuery:GET-NEXT().
  END.

  DELETE OBJECT hQuery.
  DELETE OBJECT hRowObjUpd.
  DELETE OBJECT hRowObject. 

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-doUndoRow) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE doUndoRow Procedure 
PROCEDURE doUndoRow :
/*------------------------------------------------------------------------------
  Purpose:  Rollback using the before image RowObjUpd record    
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE hRowObject AS HANDLE     NO-UNDO.
DEFINE VARIABLE hRowObjUpd AS HANDLE     NO-UNDO.

  &SCOPED-DEFINE xp-assign
  {get RowObject hRowObject}
  {get RowObjUpd hRowObjUpd}
  .
  &UNDEFINE xp-assign
  IF hRowObject:AVAILABLE AND VALID-HANDLE(hRowObjUpd) THEN
  DO:

    hRowObjUpd:FIND-FIRST('WHERE RowMod = "" AND RowNum = ':U +
                           string(hRowObject:BUFFER-FIELD('RowNum':U):BUFFER-VALUE))
                           NO-ERROR.
    
    IF hRowObjUpd:AVAILABLE THEN
    DO:
      hRowObject:BUFFER-COPY(hRowObjUpd).
      hRowObjUpd:BUFFER-DELETE().
    END.
  END.

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-doUndoTrans) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE doUndoTrans Procedure 
PROCEDURE doUndoTrans :
/*------------------------------------------------------------------------------
  Purpose:     Does the buffer delete and copy operations to restore the
               RowObject temp-table when an Undo occurs.  New RowObject records
               (added or copied, RowObject.RowMod = "A"/"C") are deleted, modified 
               records (RowObject.RowMod = "U") are restored to their original 
               states and deleted records (RowObjUpd.RowMod = "D") are recreated.  
               The RowObjUpd table is emptied.

  Parameters:  <none>
 
  Notes:       Invoked from the event procedure undoTransaction.
               doUndoTrans is run on the client side.
               This code is currently operating directly on RowObject 
               as it always FINDs after the looping.
               The caller (f.ex undoTransaction) must check the position 
               before it reopens the query and reposition to it. 
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hRowObject      AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hRowObjUpd      AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hQuery          AS HANDLE     NO-UNDO.
  DEFINE VARIABLE iLastRowNum     AS INTEGER   NO-UNDO.
  DEFINE VARIABLE lLastRowInBatch AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE lAny            AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cRowMod         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE rRowid          AS ROWID      NO-UNDO.

  &SCOPED-DEFINE xp-assign              
  {get RowObject hRowObject}    
  {get RowObjUpd hRowObjUpd}
  .
  &UNDEFINE xp-assign
  
  rRowid = hRowObject:ROWID.

  RUN doUndoDelete IN TARGET-PROCEDURE. 
  /* doUndoDelete may change LastRowNum */
  {get LastRowNum iLastRowNum}.
  
  CREATE QUERY hQuery.
  hQuery:SET-BUFFERS(hRowObject).
  hQuery:QUERY-PREPARE('FOR EACH ' + hRowObject:NAME + ' WHERE RowMod > ""':U).
  hQuery:QUERY-OPEN().
  hQuery:GET-FIRST().
  DO WHILE NOT hQuery:QUERY-OFF-END:
    cRowMod = hRowObject:BUFFER-FIELD('RowMod':U):BUFFER-VALUE.

    /* new record */
    IF cRowMod = "A":U OR cRowMod = "C":U THEN
    DO:
      lAny = TRUE.
      /* If a new record is last, we know that we have the original new 
         record in the batch, because that's the requirement for a new record 
         to be marked as last. */
      IF hRowObject:BUFFER-FIELD('RowNum':U):BUFFER-VALUE = iLastRowNum THEN
        lLastRowInBatch = TRUE.
      hRowObject:BUFFER-DELETE().
    END.
    /* updated record */
    ELSE IF cRowMod = "U":U THEN
    DO:
      hRowObjUpd:FIND-UNIQUE('WHERE RowMod = "" AND RowNum = ':U + 
                             STRING(hRowObject:BUFFER-FIELD('RowNum':U):BUFFER-VALUE))
                             NO-ERROR.
      IF hRowObjUpd:AVAILABLE THEN 
      DO:
        lAny = TRUE.
        hRowObject:BUFFER-COPY(hRowObjUpd).
      END.
    END.
    hQuery:GET-NEXT().
  END.  /* for each RowObject */
  
  DELETE OBJECT hQuery.
  
  /* We have undone an Added record that was last and know that the real last
     is in the batch */  
  IF lLastRowInBatch THEN
  DO:
    hRowObject:FIND-LAST() NO-ERROR.
    IF hRowObject:AVAILABLE THEN
    DO:
      &SCOPED-DEFINE xp-assign                 
      {set LastRowNum hRowObject:BUFFER-FIELD('RowNum':U):BUFFER-VALUE}
      {set LastDbRowIdent '':U}  /* not needed if lastrownum is set */
      .    
      &UNDEFINE xp-assign 
    END.
  END. /* lLastrowInbatch */

  IF VALID-HANDLE(hRowObjUpd) THEN
    /* For repositioning, locate the first Update or Delete record thats being
       undone and position there. */
    hRowObjUpd:FIND-FIRST('WHERE RowObjUpd.RowMod = "" OR RowObjUpd.RowMod = "D"':U +
                          ' USE-INDEX RowNum':U) NO-ERROR.
  
  IF VALID-HANDLE(hRowObjUpd) AND hRowObjUpd:AVAILABLE THEN
      hRowObject:FIND-UNIQUE('WHERE RowNum = ':U +
                             STRING(hRowObjUpd:BUFFER-FIELD('RowNum':U):BUFFER-VALUE)) NO-ERROR.
  
  /* If there aren't any, but lAny is true then we are undoing an Add.
     In that case, position to the last record in the batch. */
  ELSE IF lAny THEN
    hRowObject:FIND-LAST() NO-ERROR.
  ELSE IF rRowid <> ? THEN /* just in case this was called with no trans */
    hRowObject:FIND-BY-ROWID(rRowid) NO-ERROR.

  ELSE  /* this would only happen of no RowObject was avail before this started */
    hRowObject:FIND-FIRST() NO-ERROR.

  IF NOT hRowObject:AVAILABLE THEN
  DO:
    &SCOPED-DEFINE xp-assign              
    {set FirstRowNum ?}
    {set LastRowNum ?}
    .
    &UNDEFINE xp-assign
  END.

  RUN updateQueryPosition IN TARGET-PROCEDURE.
    
  IF VALID-HANDLE(hRowObjUpd) THEN 
    hRowObjUpd:EMPTY-TEMP-TABLE.
  
  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-doUndoUpdate) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE doUndoUpdate Procedure 
PROCEDURE doUndoUpdate :
/*------------------------------------------------------------------------------
  Purpose:     Supports a cancelRow by copying the current RowObjUpd record back 
               to the current RowObject record. 
  Parameters:  
  Notes:       From 9.1C the rollback of updates is really no longer needed by 
               the visual objects, the only case where it would happen was 
               with AutoCommit off, but it would roll back ALL changes, which
               was quite confusing if changes had been done in several steps. 
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hRowObject    AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hRowObjUpd    AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hDataQuery    AS HANDLE    NO-UNDO.
  DEFINE VARIABLE rRowObject    AS ROWID     NO-UNDO.
  DEFINE VARIABLE lNewMode      AS LOGICAL   NO-UNDO.
 
  &SCOPED-DEFINE xp-assign              
  {get RowObject hRowObject}   
  {get RowObjUpd hRowObjUpd}
  .
  &UNDEFINE xp-assign
  
  IF hRowObject:AVAILABLE THEN
  DO:
    IF VALID-HANDLE(hRowObjUpd) THEN

      hRowObjUpd:FIND-UNIQUE('WHERE RowMod = "" AND RowNum = ':U +
                              string(hRowObject:BUFFER-FIELD('RowNum':U):BUFFER-VALUE))
                             NO-ERROR.
    
    IF VALID-HANDLE(hRowObjUpd) AND hRowObjUpd:AVAILABLE THEN  /* may not be there if never saved */
    DO:
      hRowObject:BUFFER-COPY(hRowObjUpd).
      hRowObjUpd:BUFFER-DELETE().
      PUBLISH 'dataAvailable':U FROM TARGET-PROCEDURE ("SAME":U). 
    END.
    ELSE DO:

      /* Check new mode to avoid deleting new uncommitted records in updatemode*/
      {get NewMode lNewMode}.
      IF lNewMode 
      AND (hRowObject:BUFFER-FIELD('RowMod':U):BUFFER-VALUE = "A":U 
           OR 
           hRowObject:BUFFER-FIELD('RowMod':U):BUFFER-VALUE = "C":U) THEN
      DO:
        hRowObject:BUFFER-DELETE().

        /* Tell a browse updateSource to get rid of the insert-row */
        PUBLISH 'cancelNew':U FROM TARGET-PROCEDURE.

        &SCOPED-DEFINE xp-assign              
        /* Re-establish the current row */
        {get DataHandle hDataQuery}
        {get CurrentRowid rRowObject}
        .
        &UNDEFINE xp-assign
        
        IF hDataQuery:IS-OPEN AND rRowObject <> ? THEN 
        DO:
          hDataQuery:REPOSITION-TO-ROWID(rRowObject) NO-ERROR.
          /* Next needed if not browser (Data-Target) */
          IF NOT hRowObject:AVAILABLE AND ERROR-STATUS:GET-MESSAGE(1) = '':U THEN  
            hDataQuery:GET-NEXT() NO-ERROR.
        END.  /* IF the query is open */
      END.  /* DO IF "A"/"C" */
    END.  /* if NOT avail RowObjUpd */
  END.  /* if avail rowobject */

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

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

&IF DEFINED(EXCLUDE-getCacheDuration) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getCacheDuration Procedure 
FUNCTION getCacheDuration RETURNS INTEGER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  Specifies the number of seconds the cache is valid. 
            > 0 - use caching 
            0 - don't cache (share).
            ? - indicates that the data is valid throughout the session. 
   Params:  <none>
    Notes:  The duration is applied when no instances are using the cached data. 
          - New instances that has ShareData set to true will disregard this 
            property if another instance still is running. 
          - The property applies to a client proxy running against a stateless
            appserver or when ForceClientProxy = yes.
------------------------------------------------------------------------------*/

  DEFINE VARIABLE iCacheDuration AS INTEGER NO-UNDO.
  {get CacheDuration iCacheDuration}.
  RETURN iCacheDuration.

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

&IF DEFINED(EXCLUDE-getCurrentRowModified) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getCurrentRowModified Procedure 
FUNCTION getCurrentRowModified RETURNS LOGICAL
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:     Returns TRUE if any values in the current RowObject row
               have been modified.  If there is no current Rowobject record,
               then getCurrentRowModified returns ?.
   
  Parameters:  NOT IN USE BY ADM
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

&IF DEFINED(EXCLUDE-getDataDelimiter) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getDataDelimiter Procedure 
FUNCTION getDataDelimiter RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose: Delimiter for 'open' APIs receiveData and input-output in 
           updateData and createData  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cDelimiter AS CHARACTER  NO-UNDO.
  {get DataDelimiter cDelimiter}.
  RETURN cDelimiter.

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

&IF DEFINED(EXCLUDE-getDataReadBuffer) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getDataReadBuffer Procedure 
FUNCTION getDataReadBuffer RETURNS HANDLE
  ( ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
 DEFINE VARIABLE hBuffer AS HANDLE     NO-UNDO.
 {get DataReadBuffer hBuffer}.

 RETURN hBuffer.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDataReadColumns) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getDataReadColumns Procedure 
FUNCTION getDataReadColumns RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cColumns AS CHARACTER  NO-UNDO.
  {get DataReadColumns cColumns}.

  RETURN cColumns.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDataReadFormat) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getDataReadFormat Procedure 
FUNCTION getDataReadFormat RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  Format for columns passed to receiveData and for output in 
            updateData and createData 
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cFormat AS CHARACTER  NO-UNDO.
  {get DataReadFormat cFormat}.
  RETURN cFormat.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDataReadHandler) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getDataReadHandler Procedure 
FUNCTION getDataReadHandler RETURNS HANDLE
  ( ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
 DEFINE VARIABLE hHandle AS HANDLE     NO-UNDO.
 {get DataReadHandler hHandle}.

 RETURN hHandle.

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
                              01 = CHARACTER
                              02 = DATE
                              03 = LOGICAL
                              04 = INTEGER
                              05 = DECIMAL
                              06 = Reserved for FLOAT OR DOUBLE in the future
                              07 = RECID
                              08 = RAW
                              09 = Reserved for IMAGE in the future
                              10 = HANDLE
                              13 = ROWID
                              18 = BLOB
                              19 = CLOB        
                              34 = DATETIME
                              40 = DATETIME-TZ                          
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cSignature AS CHARACTER NO-UNDO INIT "":U.
  DEFINE VARIABLE iCol       AS INTEGER   NO-UNDO.
  DEFINE VARIABLE hRowObject AS HANDLE    NO-UNDO.
  DEFINE VARIABLE cDataType  AS CHARACTER NO-UNDO.
  DEFINE VARIABLE hColumn    AS HANDLE    NO-UNDO.
  
  {get RowObject hRowObject}.
  IF VALID-HANDLE(hRowObject) THEN
  DO iCol = 1 TO hRowObject:NUM-FIELDS:
    hColumn = hRowObject:BUFFER-FIELD(iCol).
    cDataType = hColumn:DATA-TYPE.
    cSignature = cSignature +
      (IF     cDataType = 'CHARACTER':U   THEN '01':U
      ELSE IF cDataType = 'DATE':U        THEN '02':U
      ELSE IF cDataType = 'LOGICAL':U     THEN '03':U
      ELSE IF cDataType = 'INTEGER':U     THEN '04':U
      ELSE IF cDataType = 'DECIMAL':U     THEN '05':U
      /* Note: Float/Double reserved for possible future use. */
      ELSE IF cDataType = 'FLOAT':U OR 
              cDataType = 'DOUBLE':U      THEN '06':U
      ELSE IF cDataType = 'RECID':U       THEN '07':U
      ELSE IF cDataType = 'RAW':U         THEN '08':U
      ELSE IF cDataType = 'HANDLE':U      THEN '10':U
      ELSE IF cDataType = 'ROWID':U       THEN '13':U 
      ELSE IF cDataType = 'BLOB':U        THEN '18':U 
      ELSE IF cDataType = 'CLOB':U        THEN '19':U 
      ELSE IF cDataType = 'DATETIME':U    THEN '34':U 
      ELSE IF cDataType = 'DATETIME-TZ':U THEN '40':U 
      ELSE '00':U).
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
  DEFINE VARIABLE lQueryObject AS LOGICAL   NO-UNDO.

  cDBNames = SUPER().  
  IF cDBNames = ? THEN
  DO: 
    {get ContainerSource hContainer}.
    /* Only use ASDivision from query containers, where its value is consistent. IZ 4319 */
    {get queryObject lQueryObject hContainer} NO-ERROR.
    IF lQueryObject THEN
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
      /* Check again as this is should be retrieved at start up from the calls 
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

&IF DEFINED(EXCLUDE-getDynamicData) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getDynamicData Procedure 
FUNCTION getDynamicData RETURNS LOGICAL
  (  ) :
/*------------------------------------------------------------------------------
  Purpose: Returns true if this dataobject is using dynamic defined temp-tables  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE lDynamic AS LOGICAL    NO-UNDO.
  {get DynamicData lDynamic}.

  RETURN lDynamic.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getForeignFieldsContainer) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getForeignFieldsContainer Procedure 
FUNCTION getForeignFieldsContainer RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
DEFINE VARIABLE cObjectName     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cCurrField      AS CHARACTER NO-UNDO.
DEFINE VARIABLE cForFields      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE hSource         AS HANDLE     NO-UNDO.
DEFINE VARIABLE iCol            AS INTEGER    NO-UNDO.
DEFINE VARIABLE cObjectFF       AS CHARACTER  NO-UNDO.

  &SCOPED-DEFINE xp-assign
  {get ObjectName cObjectName}
  {get ContainerSource hSource}.
  &UNDEFINE xp-assign
  {get ForeignFields cForFields hSource}.

  /* Check that the foreign field referenced is contained within this SDO */
  DO iCol = 1 TO NUM-ENTRIES(cForFields) BY 2:
    cCurrField = ENTRY(iCol, cForFields).
    IF NUM-ENTRIES(cCurrField,".") > 1 
        AND ENTRY(1,cCurrField, ".":U) = cObjectName THEN
      cObjectFF = cObjectFF + (IF cObjectFF = "" THEN "" ELSE ",") + 
                  cCurrField + "," + ENTRY(iCol + 1, cForFields).
  END.

  /* no FF match our Object Name */
  RETURN cObjectFF. 

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
  DEFINE VARIABLE hBuffer     AS HANDLE    NO-UNDO.
  DEFINE VARIABLE lHasNewRow  AS LOGICAL    NO-UNDO.

  {get RowObjUpd hTable}.

  IF NOT VALID-HANDLE(hTable) THEN
    RETURN FALSE.

  CREATE BUFFER hBuffer FOR TABLE hTable.
  hBuffer:FIND-FIRST("WHERE RowMod = 'A' or RowMod = 'C'":U) NO-ERROR.
  lHasNewRow = hBuffer:AVAILABLE.
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
  DEFINE VARIABLE cUseTables    AS CHAR   NO-UNDO.
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
  DEFINE VARIABLE lQueryObject  AS LOGICAL NO-UNDO.

  &SCOPED-DEFINE xpIndexInformation
  {get IndexInformation cInfo}.
  &UNDEFINE xpIndexInformation
  
  IF cInfo = ? OR cInfo = '':U THEN
  DO:
    cInfo = ''. /* make sure it's not unknown as we append data to it */
    {get ContainerSource hContainer}.
    /* Only use ASDivision from query containers, where its value is consistent. IZ 4319 */
    {get queryObject lQueryObject hContainer} NO-ERROR.
    IF lQueryObject THEN
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
      /* It should have been found above, but in case not go and get it */  
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
      &SCOPED-DEFINE xp-assign
      {get Tables cTableList}
      {get IndexInfoTables cUseTables}
       .
      &UNDEFINE xp-assign
      /* getIndexInfoTables is not a true property, customer can of course 
         add it or simply overrride the function  */ 
      IF cUseTables = '<ALL>':U THEN
        cUseTables = cTableList.
      
      /* Replace database fieldname with DataColumName */ 
      DO iTable = 1 TO NUM-ENTRIES(cTableList):
        cTable  = ENTRY(iTable,cTableList). 
        IF CAN-DO(cUseTables,cTable) OR cUseTables = '' THEN
        DO:
          cTableIndexes = DYNAMIC-FUNCTION('indexInformation':U IN TARGET-PROCEDURE,
                                           'Info(':U + STRING(iTable) + ')', /* info for table  */
                                           'yes',    /* table separator (no field qualifier) */
                                            ?).       /* Use query data */
          DO iIndex = 1 TO NUM-ENTRIES(cTableIndexes,CHR(1)):
            cIndex = ENTRY(iIndex,cTableIndexes,CHR(1)).
            DO iField = 5 TO NUM-ENTRIES(cIndex) BY 2:
              cField  = cTable + ".":U + ENTRY(iField,cIndex).
              /* Is there a mapped RowObject Column? */
              cColumn = {fnarg dbColumnDataName cField}.
              IF cColumn > '':U THEN 
                ENTRY(iField,cIndex) = cColumn.
              ELSE 
                ENTRY(iField,cIndex) = cField.
            END. /* iField = 5 to num-entries by 2 */
            ENTRY(iIndex,cTableIndexes,CHR(1)) = cIndex.
          END. /* iIndex = 1 to num indexes in tableindexes */
        END. /* If CAN-DO(cUseTables,cTable) OR cUseTables = '' */ 
        ELSE 
          cTableIndexes = ''.
        cInfo = cInfo 
              + (IF iTable = 1 then '' ELSE CHR(2)) 
              + cTableIndexes.
      END. /* iTable = 1 to num tables */    
    END. /* else not 'client' */    
    /* Store it for next time */
    {set IndexInformation cInfo}.
  END. /* if cInfo = ? or cInfo = '' */
  RETURN cInfo.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getIndexInfoTables) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getIndexInfoTables Procedure 
FUNCTION getIndexInfoTables RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose: Return the table(s) that need(s) to have IndexInformation on 
           the client.      
    Notes: The IndexInformation is used to resolve position requests on the 
           client and only need info for the table that are uniquely 
           represented in one record in the query, so this property defaults to 
           the EnabledTables or the first table in order to reduce the size of
           the IndexInformation, which is at risk of blowing up the size of the 
           context passed to the client. The EnabledTables have to be unique 
           also if more than one (one-to-one). The first table for read-only SDOs
           is a (best) guess though.. 
         - This is (currently) NOT defined as a property, since it would be 
           overridden only in the rather unlikely case where indexinformation 
           for other tables than the unique table is needed on the client.
         - The function can be overridden in the case someone relied on 
           the fact that all indexinformation used to be passed to the client 
           in previous versions.  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cTableList AS CHARACTER  NO-UNDO.

  {get EnabledTables cTableList}.
  IF cTableList = '' THEN
  DO:
    {get Tables cTableList}.
    cTableList = ENTRY(1,cTableList).
  END.

  RETURN cTableList.

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

&IF DEFINED(EXCLUDE-getIsRowObjectExternal) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getIsRowObjectExternal Procedure 
FUNCTION getIsRowObjectExternal RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE lVar AS LOGICAL NO-UNDO.
  {get IsRowObjectExternal lVar}.
  RETURN lVar.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getIsRowObjUpdExternal) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getIsRowObjUpdExternal Procedure 
FUNCTION getIsRowObjUpdExternal RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose: Indicates that the rowObjUpd table has been passed from 
           somewhere else (usually the client)   
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE lExternal AS LOGICAL NO-UNDO.
  {get IsRowObjUpdExternal lExternal}.
  RETURN lExternal.

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
   Params:  This is defined in the Entity Control for Dynamics, while 
            standard ADM (or a static SDO with no corresponding Entity in 
            the Repository) uses the indexInformation to figure out the default 
            KeyFields list. 
            - This is currently restricted to cases where: 
              - The First Table in the join is the Only enabled table.
              - All the fields of the index is present is the SDO.             
            
              The following index may be selected.                                     
              1. Primary index if unique.
              2. First Unique index. 
            
            There's currently no check whether the field is mandatory.  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cKeyFields     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hAppServer     AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cASDivision    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cContAsDiv     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hContainer     AS HANDLE     NO-UNDO.
  DEFINE VARIABLE lQueryObject   AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lUseRepository AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lAsHasStarted  AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lClient        AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cIndexInfo     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cEnabledTables AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cTables        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cUniqueList    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cPrimaryList   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cColumnList    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iIdx           AS INTEGER    NO-UNDO.

  cKeyFields = SUPER().
  
  IF cKeyFields = "":U THEN
  DO:    
    {get ContainerSource hContainer}.
    /* If SBO (query container) then use its ASDivision . (IZ 4319) */
    {get QueryObject lQueryObject hContainer} NO-ERROR.
    IF lQueryObject THEN
      {get ASDivision cContASDiv hContainer} NO-ERROR.
    ELSE 
      {get ASDivision cASDivision}.
    
    /* If we're on the client then the AppServer may not have returned this 
       property value yet. */
    IF cContASDiv = 'Client':U OR cASDivision = 'Client':U THEN
    DO:
      lClient = TRUE.
      /* This is one of the "first-time" properties, so there is no point 
         in attempting to retrieve this AGAIN if AsHasStarted is true.
         This will also retrieve the IndexInformation, which is needed to 
         derive the key if not defined in entity control  */
      {get AsHasStarted lAsHasStarted}.
      IF NOT lAsHasStarted THEN
      DO:
        IF cContASDiv = 'Client':U THEN
          RUN startServerObject IN hContainer.
        ELSE 
         /* This will retrieve all Server properties  */
          {get ASHandle hAppServer}.        
        /* We may need to unbind if this call did the bind (getASHandle) */
        RUN unbindServer IN TARGET-PROCEDURE (?). 
        cKeyFields = SUPER().
      END. /* not AsHasStarted */
    END. /* on client */

    IF cKeyFields = '':U THEN
    DO:
      IF NOT lClient THEN
      DO:
        /* This property is a Dynamics Entity prop, so retrieve it from the 
           Entity Control data if we're on the server (or running locally) */
        {get UseRepository lUseRepository}.
        IF lUseRepository THEN 
        DO:
          RUN initializeEntityDetails IN TARGET-PROCEDURE.
          cKeyFields = SUPER().
        END.
      END. /* not on client */

      IF cKeyFields = '':U THEN
      DO:
        &SCOPED-DEFINE xp-assign
        {get EnabledTables cEnabledTables}
        {get Tables cTables}
         .
        &UNDEFINE xp-assign
        /* Currently we only create a default KeyFields when omly one table
           or ONE enabled table and it's the FIRST table  */
        IF NUM-ENTRIES(cTables) = 1 
        OR (NUM-ENTRIES(cEnabledTables) = 1 
            AND cEnabledTables = ENTRY(1,cTables)) THEN
        DO:
          {get IndexInformation cIndexInfo}.
          IF cIndexInfo <> ? THEN
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
      END. /* cKeyFields = '':U */
    END.  /* cKeyFields = '':U */
  END.  /* cKeyFields = '':U (initially) */
  
  RETURN cKeyFields.
      
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
  DEFINE VARIABLE cKeyTableId    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hAppServer     AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cASDivision    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cContAsDiv     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hContainer     AS HANDLE     NO-UNDO.
  DEFINE VARIABLE lQueryObject   AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lUseRepository AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lAsHasStarted  AS LOGICAL    NO-UNDO.

  cKeyTableId = SUPER().
  
  IF cKeyTableId = "":U THEN
  DO:    
    {get ContainerSource hContainer}.
    /* If SBO (query container) then use its ASDivision . (IZ 4319) */
    {get QueryObject lQueryObject hContainer} NO-ERROR.
    IF lQueryObject THEN
      {get ASDivision cContASDiv hContainer} NO-ERROR.
    ELSE 
      {get ASDivision cASDivision}.
    
    /* If we're on the client then the AppServer may not have returned this 
       property value yet. */
    IF cContASDiv = 'Client':U OR cASDivision = 'Client':U THEN
    DO:
      /* This is one of the "first-time" properties, so there is no point 
         in attempting to retrieve this if AsHasStarted is true.  
        (Static SDOs may have blank values in Dynamics if the Entities are 
         not defined in the Repository, causing invalid handle (ashandle) errors
         when this then was called as part of obtainContextForServer 
         - initializeServerObject) */
      {get AsHasStarted lAsHasStarted}.
      IF NOT lAsHasStarted THEN
      DO:
        IF cContASDiv = 'Client':U THEN
          RUN startServerObject IN hContainer.
        ELSE 
         /* This will retrieve all Server properties including KeyTable */
          {get ASHandle hAppServer}.

        /* re-read property, since the previous call will retrieve context 
           when AsHasStarted = false  */
        cKeyTableId = SUPER().

        /* We should have got it now, but if something is wrong let's just go 
           and get it ourselves... */ 
        IF cKeyTableId = '':U THEN 
        DO:
          /* get in case we just called startServerObject in the SBO above  */
          {get ASHandle hAppServer}.
          IF VALID-HANDLE(hAppServer) AND hAppServer <> TARGET-PROCEDURE THEN 
          DO:
            cKeyTableId = DYNAMIC-FUNCTION("getKeyTableId":U IN hAppServer).
            IF cKeyTableId <> '':U THEN
              {set KeyTableId cKeyTableId}. 
          END.     /* END DO IF Valid A/S handle */      
        END.
        /* We may need to unbind if this call did the bind (getASHandle) */
        RUN unbindServer IN TARGET-PROCEDURE (?). 
      END. /* not AsHasStarted */
    END.
    ELSE DO: /* server or local connection */
      /* This property is a Dynamics Entity prop, so we need to retrieve it from 
         the Entity Control data. There's nothing more to do for non-dynamics. */
      {get UseRepository lUseRepository}.
      IF lUseRepository THEN 
      DO:
        RUN initializeEntityDetails IN TARGET-PROCEDURE.
        cKeyTableId = SUPER().
      END.
    END.
  END.           /* END DO IF OpenQuery not yet defined locally. */
  
  RETURN cKeyTableId.
      
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
  DEFINE VARIABLE hRowObjUpd  AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hRowMod     AS HANDLE     NO-UNDO.
  DEFINE VARIABLE lNewMode    AS LOGICAL    NO-UNDO.

  &SCOPED-DEFINE xp-assign
  {get RowObject hRowObject}
  {get RowObjUpd hRowObjUpd}.
  &UNDEFINE xp-assign
  
  IF NOT VALID-HANDLE(hRowObject) OR NOT hRowObject:AVAILABLE THEN
    RETURN ?.   

  /* create a buffer for the upd table (avoid messing with the real one)
     and see if it has a corresponding record */
  IF VALID-HANDLE(hRowObjUpd) THEN
  DO:
    CREATE BUFFER hRowObjUpd FOR TABLE hRowObjUpd.
  
    /* find the corresponding rowObjUpd -- buffer that is */
    DYNAMIC-FUNCTION('findRowObjUpd':U IN TARGET-PROCEDURE,
                      hRowObject, 
                      hRowObjUpd).
  
  END. /* valid rowObjUpd */

  /* if the rowmod is 'A' or 'C' with no corresponding upd record then this 
     new record has not been saved and NewMode must be true */
  ASSIGN
    hRowMod  = hRowObject:BUFFER-FIELD('RowMod':U)
    lNewMode = (hRowMod:BUFFER-VALUE = "A":U OR hRowMod:BUFFER-VALUE = "C":U) 
               AND 
               (NOT VALID-HANDLE(hRowObjUpd) OR NOT hRowObjUpd:AVAILABLE). 
  
  /* Delete the locally created buffer (no-error as it may not have been created) */
  DELETE OBJECT hRowObjUpd NO-ERROR.

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
  DEFINE VARIABLE cQuery        AS CHARACTER NO-UNDO.
  DEFINE VARIABLE hAppServer    AS HANDLE    NO-UNDO.
  DEFINE VARIABLE cASDivision   AS CHARACTER NO-UNDO.
  DEFINE VARIABLE hContainer    AS HANDLE    NO-UNDO.
  DEFINE VARIABLE lQueryObject  AS LOGICAL   NO-UNDO.
  
  cQuery = SUPER().
  IF cQuery = "":U THEN
  DO:
     {get ContainerSource hContainer}.
     /* Only use ASDivision from query containers, where its value is consistent. IZ 4319 */
     {get queryObject lQueryObject hContainer} NO-ERROR.
     IF lQueryObject THEN
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

&IF DEFINED(EXCLUDE-getQueryOpen) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getQueryOpen Procedure 
FUNCTION getQueryOpen RETURNS LOGICAL
  (  ) :
/*------------------------------------------------------------------------------
    Purpose:  Returns TRUE if the Query is currently open.
 Parameters:  <none>
      Notes:  Overrides query to resolve this on the client when this is 
              not the server side object.
           -  The need to check the rowobject query is important for the case 
              when it is 'client'. 
           -  From the dataobject's perspective the server side query is less 
              important as an object state, but the Database query is open a 
              (little) while before the rowObject query, so it is still checked 
              in that case. 
 ----------------------------------------------------------------------------*/    
  DEFINE VARIABLE hDataQuery  AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cAsDivision AS CHARACTER  NO-UNDO.

  {get AsDivision cAsDivision}.

  IF cAsDivision = 'Client':U THEN
  DO:
    {get DataHandle hDataQuery}.
    RETURN IF NOT VALID-HANDLE(hDataQuery) 
           THEN NO 
           ELSE hDataQuery:IS-OPEN.   
  END.
  ELSE 
    RETURN SUPER(). 

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
            /* unbind if this call did the bind (getASHandle) */
            RUN unbindServer IN TARGET-PROCEDURE (?). 
          END.
          {set QueryContext cQuery}.
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

  &SCOPED-DEFINE xpRowObjectTable
  {get RowObjectTable hTable}.
  &UNDEFINE xpRowObjectTable
  
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

&IF DEFINED(EXCLUDE-getRunDataLogicProxy) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getRunDataLogicProxy Procedure 
FUNCTION getRunDataLogicProxy RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  If TRUE, only the "_cl.r" version of the data logic procedure 
            will be run. If it cannot be found, the associated Data Object 
            is not run.
------------------------------------------------------------------------------*/
  DEFINE VARIABLE lRunProxy AS LOGICAL NO-UNDO.
  {get RunDataLogicProxy lRunProxy}.
  RETURN lRunProxy.


END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getSchemaLocation) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getSchemaLocation Procedure 
FUNCTION getSchemaLocation RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  The Schema Location decides how the ROwObject is defined in dynamic 
            SDOs
            - 'ENT' or Blank - Default (from Entity Cache)
            - 'DLP' - Use DataLogicProcedure
            - 'BUF' - Use the buffer in the query  
            
   Notes: - If using ENTity cache all fields must exist in the entity cache.
          - If using DLP any missing field will be searched for in the buffer   
          - Setting it to 'DLP' or 'BUF', (no difference) for static SDOs avoids
            getting format and labels from the Entity cache. Static SDOs will 
            not fail if a field is missing from the entities or an Entity is 
            missing.
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cSchemaLocation AS CHARACTER NO-UNDO.
  {get SchemaLocation cSchemaLocation}.
  RETURN cSchemaLocation.

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

&IF DEFINED(EXCLUDE-getShareData) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getShareData Procedure 
FUNCTION getShareData RETURNS LOGICAL
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  Specifies whether the data in this object can be shared with other 
            instances.
   Params:  <none>
    Notes:  The current default is no.   
------------------------------------------------------------------------------*/
  DEFINE VARIABLE lShareData AS LOGICAL NO-UNDO.
  {get ShareData lShareData}.
  RETURN lShareData.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getUseStaticOnFetch) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getUseStaticOnFetch Procedure 
FUNCTION getUseStaticOnFetch RETURNS LOGICAL
  (  ) :
/*------------------------------------------------------------------------------
  Purpose: Indicates that server fetch must use the static TT. 
    Notes: This is required when there are code that sets data in the static 
           RowObject table during the fetch operation. This is true if the 
           SDO has a default calculated field.
           It could also need to be set to true if there are overrides in any of
           the fetch event procedures, like sendRows and transferDbRow.        
------------------------------------------------------------------------------*/
  
 RETURN CAN-DO(TARGET-PROCEDURE:INTERNAL-ENTRIES,'Data.Calculate':U). 

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getViewTables) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getViewTables Procedure 
FUNCTION getViewTables RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose: Override Dataview  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hRowObject AS HANDLE     NO-UNDO.
  {get RowObject hRowObject}.
  
  RETURN IF VALID-HANDLE(hRowObject) THEN hRowObject:NAME ELSE 'RowObject':U.
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

&IF DEFINED(EXCLUDE-setCacheDuration) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setCacheDuration Procedure 
FUNCTION setCacheDuration RETURNS LOGICAL
  ( piCacheDuration AS INTEGER  ) :
/*------------------------------------------------------------------------------
  Purpose:  Specifies the number of seconds the cache is valid. 
   Params:  piCacheDuration AS INTEGER 
            > 0 - use caching 
            0 - don't cache (share).
            ? - indicates that the data is valid throughout the session. 
    Notes:  The duration is applied when no instances are using the cached data. 
          - New instances that has ShareData set to true will disregard this 
            property if another instance still is running. 
          - The property applies to a client proxy running against a stateless
            appserver or when ForceClientProxy = yes.
------------------------------------------------------------------------------*/

  {set CacheDuration piCacheDuration}.
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

&IF DEFINED(EXCLUDE-setDataDelimiter) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setDataDelimiter Procedure 
FUNCTION setDataDelimiter RETURNS LOGICAL
  ( pcDelimiter AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose: Delimiter for values passed to receiveData and output for the 
           input-output in updateData and createData  
    Notes:  
------------------------------------------------------------------------------*/
  {set DataDelimiter pcDelimiter}.
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

&IF DEFINED(EXCLUDE-setDataReadBuffer) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setDataReadBuffer Procedure 
FUNCTION setDataReadBuffer RETURNS LOGICAL
  ( phBuffer AS HANDLE ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  {set DataReadBuffer phBuffer}.
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setDataReadColumns) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setDataReadColumns Procedure 
FUNCTION setDataReadColumns RETURNS LOGICAL
  ( pcColumns AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  {set DataReadColumns pcColumns}.
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setDataReadFormat) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setDataReadFormat Procedure 
FUNCTION setDataReadFormat RETURNS LOGICAL
  ( pcFormat AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  Format for columns passed to receiveData and for output in 
            updateData and createData 
    Notes:  
------------------------------------------------------------------------------*/
  {set DataReadFormat pcFormat}.
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setDataReadHandler) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setDataReadHandler Procedure 
FUNCTION setDataReadHandler RETURNS LOGICAL
  ( phHandle AS HANDLE ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  {set DataReadHandler phHandle}.
  RETURN TRUE.

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

&IF DEFINED(EXCLUDE-setDynamicData) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setDynamicData Procedure 
FUNCTION setDynamicData RETURNS LOGICAL
  ( plDynamic AS LOGICAL  ) :
/*------------------------------------------------------------------------------
  Purpose: Set to true if this dataobject is using dynamic defined temp-tables  
    Notes: This should only be set by the data object itself  
------------------------------------------------------------------------------*/
  {set DynamicData plDynamic}.
  
  RETURN TRUE.   

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setIsRowObjectExternal) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setIsRowObjectExternal Procedure 
FUNCTION setIsRowObjectExternal RETURNS LOGICAL
  ( plExternal AS LOGICAL) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  {set IsRowObjectExternal plExternal}.
  
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setIsRowObjUpdExternal) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setIsRowObjUpdExternal Procedure 
FUNCTION setIsRowObjUpdExternal RETURNS LOGICAL
  ( plExternal AS LOGICAL) :
/*------------------------------------------------------------------------------
  Purpose: Indicates that the rowObjUpd table has been passed from 
           somewhere else (usually the client)   
    Notes:  
------------------------------------------------------------------------------*/
  {set IsRowObjUpdExternal plExternal}.
  
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
       Notes:  (See getOpenQuery for the original where clause.)
               The Where clause is stored locally on the client
           -   From 9.1D02 this is done also for state-aware objects since 
               the context always is passed to the server in all data requests.               
 ------------------------------------------------------------------------------*/
  DEFINE VARIABLE cQueryWhere     AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cAsDivision     AS CHARACTER NO-UNDO.
  DEFINE VARIABLE iField          AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cLocalFields    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cForeignFields  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSourceFields   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cValues         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lOK             AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lInitialized    AS LOGICAL    NO-UNDO.

  {get AsDivision cAsDivision}.
  IF cAsDivision = 'CLIENT':U THEN 
  DO:
    cQueryWhere = {fnarg newQueryWhere pcWhere}.
    /* Store the query locally */     
    IF cQueryWhere <> ? THEN
      {set QueryContext cQueryWhere}.

    lOK = cQueryWhere <> ?.
  END. /* client */
  ELSE
    lOK = SUPER(pcWhere).

  /* apply foreign field values if they exist (issue 8056), unless this is 
     context setting before the object is initialized (Mainly a WEBspeed issue,
     since AsDivision is not set on WebSpeed) */
  IF cAsDivision <> 'SERVER' THEN 
  DO:     
    &SCOPED-DEFINE xp-assign
    {get ForeignFields cForeignFields}
    {get ObjectInitialized lInitialized}
    .
    &UNDEFINE xp-assign
    
    IF lInitialized AND cForeignFields > "" AND cForeignFields <> ? THEN 
    DO:
      {get ForeignValues cValues}.
      IF cValues <> ? THEN
      DO:
        DO iField = 1 TO NUM-ENTRIES(cForeignFields) BY 2:
          cLocalFields = cLocalFields +  /* 1st of each pair is local db query fld  */
          (IF cLocalFields NE "":U THEN ",":U ELSE "":U) +
            ENTRY(iField, cForeignFields).
          cSourceFields = cSourceFields +   /* 2nd of pair is source RowObject fld */
          (IF cSourceFields NE "":U THEN ",":U ELSE "":U) +
            ENTRY(iField + 1, cForeignFields).
        END.
        lOK = DYNAMIC-FUNCTION("assignQuerySelection":U IN TARGET-PROCEDURE,
                          cLocalFields,
                          cValues,
                          '':U).
        IF cAsDivision = 'CLIENT' THEN
        DO:
          cQueryWhere = {fn getQueryString}.  /* this version now includes FF */
          IF cQueryWhere <> ? THEN
            {set QueryContext cQueryWhere}.
        END.
      END.
    END.
  END.

  RETURN lOK.

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

  &SCOPED-DEFINE xpRowObjectState
  {set RowObjectState pcState}.
  &UNDEFINE xpRowObjectState
  
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
  DEFINE VARIABLE hRowobject   AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hDataHandle  AS HANDLE    NO-UNDO.
  DEFINE VARIABLE cDefs        AS CHAR      NO-UNDO.

  /* Support non-persistent callers that want to return the TT directly
     The TT will be prepared in 
      initializeObject -> createObjects -> (defineTempTables) or (prepareRowObject). */ 
  IF phTable:PREPARED = FALSE THEN
  DO:
    &SCOPED-DEFINE xp-assign
    {set IsRowObjectExternal TRUE}
    {get DataFieldDefs cDefs}.
    &UNDEFINE xp-assign
    /* if a static TT recieves an unprepared we prepare the new TT from
       the old one immediately */
    IF cDefs > '':U THEN
      {fnarg prepareRowObject phTable}.
  END.
  ELSE DO:
    {get RowObject hRowObject}.    /* Existing temp-table buffer. */
    
    /* We ensure that query and buffer handle properties is correct also */
    IF NOT VALID-HANDLE(hRowObject) 
    OR hRowObject <> phTable:DEFAULT-BUFFER-HANDLE THEN
    DO:
      DELETE OBJECT hRowObject  NO-ERROR. 
      hRowObject = phTable:DEFAULT-BUFFER-HANDLE.
      
      &SCOPED-DEFINE xp-assign
      {set RowObject hRowObject}     /* Point to new buffer. */    
      {get DataQueryString cQueryString}
      {get DataHandle hDataHandle}.  /* Query handle */
      &UNDEFINE xp-assign
      DELETE OBJECT hDataHandle NO-ERROR.  
      CREATE QUERY hDataHandle.
      {set DataHandle hDataHandle}. 
      hDataHandle:SET-BUFFERS(hRowObject).   
      
      /* if DataQueryString is "", set it */
      IF cQueryString = "":U THEN
      DO:
        cQueryString = " FOR EACH ":U + hRowObject:table + " ":U .
        {set DataQueryString cQueryString}.
      END.

      hDataHandle:QUERY-PREPARE(cQueryString).
      
    END. /* not valid hRowObject */
  END.

  &SCOPED-DEFINE xpRowObjectTable
  {set RowObjectTable phTable}.
  &UNDEFINE xpRowObjectTable  
  
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setRowObjUpd) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setRowObjUpd Procedure 
FUNCTION setRowObjUpd RETURNS LOGICAL
  ( phRowObjUpd AS HANDLE ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  {set RowObjUpd phRowObjUpd}.
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
          -  setting the TT before initialization marks it as external, 
             IsRowObjUpdExternal, which ensures that it wont be created during 
             initialization 
------------------------------------------------------------------------------*/
 DEFINE VARIABLE hRowobjUpd   AS HANDLE     NO-UNDO.
 DEFINE VARIABLE hBuffer      AS HANDLE     NO-UNDO.
 DEFINE VARIABLE lInitialized AS LOGICAL    NO-UNDO.

 &SCOPED-DEFINE xp-assign
 {get RowObjUpd hRowObjUpd}    /* Existing temp-table buffer. */
 {get ObjectInitialized lInitialized}.
 &UNDEFINE xp-assign
  
 /* We ensure that buffer property is correct also.     
    Note: we used to also delete the old RowObjUpd, but that caused
    problems running locally with an SBO as it corrupted the  
    default-buffer-handle of the caller. 
    The RowObjUpd TT should/is deleted when required so the buffer delete
    is not needed here */
 IF NOT VALID-HANDLE(hRowObjUpd) 
 OR hRowObjUpd <> phTable:DEFAULT-BUFFER-HANDLE THEN
   {set RowObjUpd phTable:DEFAULT-BUFFER-HANDLE}. /* Point to new buffer. */    
 
 &SCOPED-DEFINE xpRowObjUpdTable
 {set RowObjUpdTable phTable}.
 &UNDEFINE xpRowObjUpdTable  
 
 /* If the TT is set before initialization mark it as external, so 
    it wont be created during initialization */
 IF NOT lInitialized THEN
   {set IsRowObjUpdExternal TRUE}.

 RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setRunDataLogicProxy) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setRunDataLogicProxy Procedure 
FUNCTION setRunDataLogicProxy RETURNS LOGICAL
  ( plRunProxy AS LOGICAL ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  If TRUE, only the "_cl.r" version of the data logic procedure 
            will be run. If it cannot be found, the associated Data Object 
            is not run.
------------------------------------------------------------------------------*/
  {set RunDataLogicProxy plRunProxy}.

  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setSchemaLocation) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setSchemaLocation Procedure 
FUNCTION setSchemaLocation RETURNS LOGICAL
  (pcSchemaLocation AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose:  The Schema Location decides how the ROwObject is defined in dynamic 
            SDOs
            - 'ENT' or Blank - Default (from Entity Cache)
            - 'DLP' - Use DataLogicProcedure
            - 'BUF' - Use the buffer in the query  
            
   Notes: - If using ENTity chahe all fields must exist in the entity cache
          - If using DLP any missing field will be searched for in the buffer   
          - Setting it to 'DLP' or 'BUF', (no difference) for static SDOs avoids
            getting format and labels from the Entity cache. Static SDOs will 
            not fail if a field is missing from the entities or an Entity is 
            missing.
------------------------------------------------------------------------------*/
  {set SchemaLocation pcSchemaLocation}.
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setServerSubmitValidation) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setServerSubmitValidation Procedure 
FUNCTION setServerSubmitValidation RETURNS LOGICAL
  ( plSubmit AS LOGICAL ) :
/*------------------------------------------------------------------------------
  Purpose:  Sets the value of the property which signals whether the
            column and RowObject Validation procedures done as part of
            client validation should be executed on the server. 
            It is *no* by default; an SDO which uses client
            validation and which may be run from the open client interface
            should set it to *yes*, either in the SDO itself or at runtime.
            If it is *no* when serverCommit executes, then serverCommit 
            will execute SubmitValidation itself.
   Params:  plSubmit AS LOGICAL  -- yes if client validation should be executed
              in the server SDO.
   Notes:   As a security measure, if the property has been set to *yes*,
            it cannot be reset to *no*.
------------------------------------------------------------------------------*/
  DEFINE VARIABLE lCurrentValue AS LOGICAL NO-UNDO.
  
  /* Cannot be set to NO */
  IF plSubmit = NO THEN
  DO:
    {get ServerSubmitValidation lCurrentValue}.
    IF lCurrentValue = YES THEN
      RETURN FALSE. 
  END.
  
  &SCOPED-DEFINE xpServerSubmitValidation
  {set ServerSubmitValidation plSubmit}.
  &UNDEFINE xpServerSubmitValidation
  
  RETURN TRUE.  /* signal that the property was reset successfully. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setShareData) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setShareData Procedure 
FUNCTION setShareData RETURNS LOGICAL
  ( plShareData AS LOGICAL ) :
/*------------------------------------------------------------------------------
  Purpose:  Specifies whether the data in this object can be shared with other 
            instances.
   Params:  ShareData as logical  
    Notes:  The current default is no.   
------------------------------------------------------------------------------*/
  {set ShareData plShareData}.
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

