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
    File        : data.p
    Purpose     : Super Procedure for all SmartDataObjects
    Syntax      : adm2/data.p
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* Tell dataattr.i that this is the Super procedure. */
   &SCOP ADMSuper data.p
   
  {src/adm2/custom/dataexclcustom.i}
  
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
  {src/adm2/ttsdoout.i}

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

&IF DEFINED(EXCLUDE-bufferCompareFields) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD bufferCompareFields Procedure 
FUNCTION bufferCompareFields RETURNS CHARACTER
  ( INPUT phBuffer1 AS HANDLE,
    INPUT phBuffer2 AS HANDLE,
    INPUT pcExclude AS CHAR,
    INPUT pcOption  AS CHAR )  FORWARD.

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

&IF DEFINED(EXCLUDE-findRow) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD findRow Procedure 
FUNCTION findRow RETURNS LOGICAL
  (pcKeyValues AS CHAR)  FORWARD.

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

&IF DEFINED(EXCLUDE-findRowInCurrentBatch) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD findRowInCurrentBatch Procedure 
FUNCTION findRowInCurrentBatch RETURNS LOGICAL
  (pcColumns     AS CHARACTER,   
   pcValues      AS CHARACTER,    
   pcOperators   AS CHARACTER) FORWARD.

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

&IF DEFINED(EXCLUDE-isDataQueryComplete) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD isDataQueryComplete Procedure 
FUNCTION isDataQueryComplete RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

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
FUNCTION newRowObject RETURNS LOGICAL PRIVATE
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

&IF DEFINED(EXCLUDE-prepareQuery) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD prepareQuery Procedure 
FUNCTION prepareQuery RETURNS LOGICAL
  (pcQuery AS CHAR)  FORWARD.

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

&IF DEFINED(EXCLUDE-submitRow) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD submitRow Procedure 
FUNCTION submitRow RETURNS LOGICAL
  ( pcRowIdent AS CHARACTER, pcValueList AS CHARACTER )  FORWARD.

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
         HEIGHT             = 18.24
         WIDTH              = 55.8.
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

&IF DEFINED(EXCLUDE-bufferCollectChanges) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE bufferCollectChanges Procedure 
PROCEDURE bufferCollectChanges :
/*------------------------------------------------------------------------------
  Purpose:     Construct the changed value list. This list is actually stored in the 
               before version of the record for an update.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hRowObject    AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hRowObjUpd    AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hRowObjUpd2   AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hQuery        AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cChangedFlds  AS CHARACTER NO-UNDO INIT "":U.
  DEFINE VARIABLE cUpdatable    AS CHARACTER NO-UNDO.

  &SCOPED-DEFINE xp-assign
  {get UpdatableColumns cUpdatable}
  {get RowObjUpd hRowObjUpd}
  {get RowObject hRowObject}.
  &UNDEFINE xp-assign
  
  CREATE BUFFER hRowObject  FOR TABLE hRowObject.
  CREATE BUFFER hRowObjUpd  FOR TABLE hRowObjUpd.
  CREATE BUFFER hRowObjUpd2 FOR TABLE hRowObjUpd.

  /* set up RowObjUpd query */
  CREATE QUERY hQuery.
  hQuery:SET-BUFFERS(hRowObjUpd).
  hQuery:QUERY-PREPARE('FOR EACH ' + hRowObjUpd:NAME + 
                       ' WHERE RowMod = "A" OR RowMod = "C" OR RowMod = "U"':U).
  hQuery:QUERY-OPEN().
  hQuery:GET-FIRST().

  DO WHILE hRowObjUpd:AVAILABLE:
     cChangedFlds = "".
     IF hRowObjUpd:BUFFER-FIELD('RowMod':U):BUFFER-VALUE = "U":U THEN
     DO:
       hRowObjUpd2:FIND-FIRST('WHERE RowMod = "" AND RowNum = ':U +
                              STRING(hRowObjUpd:BUFFER-FIELD('RowNum':U):BUFFER-VALUE)).
         /* As of 9.1A, we no longer rely on ChangedFields being set
            before this point. Calculate it here so it includes any
            application-generated values. */    
       cChangedFlds = bufferCompareFields(hRowObjUpd, hRowObjUpd2,
                                          "ChangedFields,RowMod,RowIdent,RowIdentIdx,RowNum":U,
                                          "CASE-SENSITIVE":U).
     END.    /* END DO IF RowMod = U */
     ELSE IF hRowObjUpd:BUFFER-FIELD('RowMod':U):BUFFER-VALUE = "A":U THEN
     DO:
        /* For an Add, set ChangedFields to all fields no longer
           equal to their defined INITIAL value. Determine this by
           creating a RowObject record to compare against. */
       hRowObject:BUFFER-CREATE().
       cChangedFlds = bufferCompareFields(hRowObjUpd, hRowObject,
                                         "ChangedFields,RowMod,RowIdent,RowIdentIdx,RowNum":U,
                                         "CASE-SENSITIVE":U).
     END.      /* END DO If "A" for Add */
     ELSE            /* use all enabled fields for copy */ 
       cChangedFlds = cUpdatable.
        /* Now assign the list of fields into the ROU record. 
           (Put it in the before record as well for an Update.) 
           This list will be used by query.p code to ASSIGN changes
           back to the database. */
     IF hRowObjUpd:BUFFER-FIELD('RowMod':U):BUFFER-VALUE = "U":U THEN
       hRowObjUpd2:BUFFER-FIELD('ChangedFields':U):BUFFER-VALUE = cChangedFlds.

     hRowObjUpd:BUFFER-FIELD('ChangedFields':U):BUFFER-VALUE = cChangedFlds.
     /* if a row was temporarily created to supply initial values for the
        Add operation BUFFER-COMPARE, delete it now. */
     IF hRowObjUpd:BUFFER-FIELD('RowMod':U):BUFFER-VALUE = "A":U AND hRowObject:AVAILABLE THEN
       hRowObject:BUFFER-DELETE(). 

     hQuery:GET-NEXT().
  END.     /* END FOR EACH */
  
  DELETE OBJECT hQuery.
  DELETE OBJECT hRowObject.
  DELETE OBJECT hRowObjUpd.
  DELETE OBJECT hRowObjUpd2.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-bufferCommit) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE bufferCommit Procedure 
PROCEDURE bufferCommit :
/*------------------------------------------------------------------------------
  Purpose:     Update procedure executed on the server side of a split 
               SmartDataObject, called from the client Commit function.
               Commit passes a set up RowObjUpdate records both have changes to
               be committed and their pre-change copies (before-images).  
               commitRows verifies that the records have not been changed 
               since they were read, and then commits the changes to the 
               database.
  Parameters:
    OUTPUT cMessages - a CHR(3) delimited string of accumulated messages from
                       server.
    OUTPUT cUndoIds  - list of any RowObject ROWIDs whose changes need to be 
                       undone as the result of errors in the form of:
               "RowNumCHR(3)ADM-ERROR-STRING,RowNumCHR(3)ADM-ERROR-STRING,..."

 Notes:        If another user has modified the database records since the 
               original was read, the new database values are copied into the 
               RowObjUpd record and returned to Commit so the UI object can 
               diaply them.
           -   We need to identify where the hooks are because if a hook is 
               ONLY in the Logical Object then the TT need to be transfered 
               back and forth. If the hook is local then we cannot transfer 
               here asa the local then would change a different TT. 
               It there for some reason should be hooks both locally and in 
               the logic procedure the local hook would be a complete 
               overrride or it would need to do the transfer itself  
------------------------------------------------------------------------------*/
  DEFINE OUTPUT PARAMETER pocMessages AS CHARACTER NO-UNDO.
  DEFINE OUTPUT PARAMETER pocUndoIds  AS CHARACTER NO-UNDO INIT "":U.
  
  DEFINE VARIABLE hRowObject    AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hRowObjUpd    AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hRowObjUpd1   AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hRowObjUpd2   AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hRowObjFld    AS HANDLE    NO-UNDO.
  DEFINE VARIABLE cASDivision   AS CHARACTER NO-UNDO.
  DEFINE VARIABLE lSubmitVal    AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE iChange       AS INTEGER   NO-UNDO.
  DEFINE VARIABLE cChanged      AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cChangedFlds  AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cChangedVals  AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cUpdatable    AS CHARACTER NO-UNDO.
  DEFINE VARIABLE lQueryContainer  AS LOGICAL NO-UNDO.
  DEFINE VARIABLE hQuery1           AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hQuery2          AS HANDLE     NO-UNDO.
  
  {get ASDivision cASDivision}.
  /* 9.1B: Find out if our Container is itself a Query Object.
     If it is, it's an SBO or other object that handles the transaction
     for us, in which case we will not run pre/post transaction ourselves. */
  {get QueryContainer lQueryContainer}.
  /* TransactionValidate is maintained for backward (pre 9.1A) compatibility; 
     the new procedure for this slot before the transaction is 
     preTransactionValidate. ChangedFields is calculated further down and will 
     picked up fields changed in these hooks.  
     NOTE: The principle is (as with fieldValidate and rowobjectValidate) that 
     this application object returns an error message if there is one;     
     trigger errors get captured below. */

  IF NOT lQueryContainer THEN
  DO:
    RUN TransactionValidate IN TARGET-PROCEDURE NO-ERROR. 
    IF NOT ERROR-STATUS:ERROR AND RETURN-VALUE NE "":U THEN
    DO:
      RUN prepareErrorsForReturn IN TARGET-PROCEDURE 
                                (INPUT RETURN-VALUE, INPUT cASDivision, 
                                 INPUT-OUTPUT pocMessages).
      RETURN.      /* Bail out if application code rejected the txn. */
    END.   /* END DO IF RETURN-VALUE NE "" */

    RUN bufferValidate IN TARGET-PROCEDURE ("pre":U).
    IF RETURN-VALUE NE "":U THEN
    DO:
      RUN prepareErrorsForReturn IN TARGET-PROCEDURE
                                (INPUT RETURN-VALUE, INPUT cASDivision, 
                                 INPUT-OUTPUT pocMessages).
      RETURN.      /* Bail out if application code rejected the txn. */
    END.   /* END DO IF RETURN-VALUE NE "" */

  END.       /* END DO IF Container (SBO) is not doing the Commit. */

  RUN bufferCollectChanges IN TARGET-PROCEDURE.  /* Collect ChangedFields */

  {get RowObjUpd hRowObjUpd}.
  /* If this is the server side and the ServerSubmitValidation property
     has been set to *yes*, then we execute that normally client side 
     validation here to make sure that it has been done. */
  IF cASDivision = "Server":U THEN 
  DO:
    {get ServerSubmitValidation lSubmitVal}.
    IF lSubmitVal THEN
    DO:

      &SCOPED-DEFINE xp-assign
      {get UpdatableColumns cUpdatable}
      {get RowObject hRowObject}
      .
      &UNDEFINE xp-assign
      
      CREATE BUFFER hRowObjUpd1  FOR TABLE hRowObjUpd.

      /* set up RowObjUpd query */
      CREATE QUERY hQuery1.
      hQuery1:SET-BUFFERS(hRowObjUpd1).
      hQuery1:QUERY-PREPARE('FOR EACH ' + hRowObjUpd1:NAME +
                           ' WHERE RowMod = "A" OR RowMod = "C" OR RowMod = "U"':U).
      hQuery1:QUERY-OPEN().
      hQuery1:GET-FIRST().

      DO WHILE hRowObjUpd1:AVAILABLE:
        /* Validation procs look at RowObject, so we have to create a row
           temporarily for it to use. This will be deleted below. */
        DO TRANSACTION:
          hRowObject:BUFFER-CREATE().     
          hRowObject:BUFFER-COPY(hRowObjUpd1).
        END.
        
        ASSIGN
          cChangedFlds = hRowObjUpd1:BUFFER-FIELD('ChangedFields':U):BUFFER-VALUE
          cChangedVals = "".

        DO iChange = 1 TO NUM-ENTRIES(cChangedFlds):
          ASSIGN cChanged = ENTRY(iChange, cChangedFlds)
                 cChangedVals = cChangedVals 
                              + (IF cChangedVals NE "":U THEN CHR(1) ELSE "":U)
                              + cChanged 
                              + CHR(1) 
                              + STRING(hRowObjUpd1:BUFFER-FIELD(cChanged):BUFFER-VALUE).
        END.    /* END DO iChange */

        /* Now pass the values and column list to the client validation. */
        RUN submitValidation IN TARGET-PROCEDURE (INPUT cChangedVals, cUpdatable).
        DO TRANSACTION:
          hRowObject:BUFFER-DELETE(). 
        END.
        hQuery1:GET-NEXT().
      END.      /* END FOR EACH RowObjUpd */  

      DELETE OBJECT hRowObjUpd1.
      DELETE OBJECT hQuery1.

      /* Exit if any error messages were generated. This means that
         all messages associated with the "client" SubmitValidation will
         be accumulated, but the update transaction will not be attempted
         if there are any prior errors. */
      IF {fn anyMessage} THEN
      DO:
        RUN prepareErrorsForReturn IN TARGET-PROCEDURE 
                                  (INPUT "":U, INPUT cASDivision, 
                                   INPUT-OUTPUT pocMessages).
        RETURN.
      END.  /* END IF anyMessage */
    END.   /* END DO IF SUbMitVal */
  END.   /* END DO IF Server */
 
  TRANS-BLK:
  DO TRANSACTION ON ERROR UNDO, LEAVE:
    /* This user-defined validation hook is for code to be executed
       inside the transaction, but before any updates occur. */
    RUN bufferValidate IN TARGET-PROCEDURE ("begin":U).   
    IF RETURN-VALUE NE "":U THEN
    DO:
      RUN prepareErrorsForReturn IN TARGET-PROCEDURE 
                                (INPUT RETURN-VALUE, INPUT cASDivision, 
                                 INPUT-OUTPUT pocMessages).
      UNDO, RETURN.      /* Bail out if application code rejected the txn. */
    END.   /* END DO IF RETURN-VALUE NE "" */

    RUN bufferProcessUpdate IN TARGET-PROCEDURE (INPUT-OUTPUT pocMessages, INPUT-OUTPUT pocUndoIds).    
    RUN bufferProcessDelete IN TARGET-PROCEDURE (INPUT-OUTPUT pocMessages, INPUT-OUTPUT pocUndoIds).
    RUN bufferProcessNew IN TARGET-PROCEDURE (INPUT-OUTPUT pocMessages, INPUT-OUTPUT pocUndoIds).
    
    IF pocUndoIds NE "":U THEN
      UNDO Trans-Blk, LEAVE Trans-Blk.

    RUN bufferValidate IN TARGET-PROCEDURE ("end":U).  
    IF RETURN-VALUE NE "":U THEN
    DO:
      RUN prepareErrorsForReturn IN TARGET-PROCEDURE
                                (INPUT RETURN-VALUE, INPUT cASDivision, 
                                 INPUT-OUTPUT pocMessages).
      UNDO, RETURN.      /* Bail out if application code rejected the txn. */
    END.   /* END DO IF RETURN-VALUE NE "" */

    /* return the latest version of the record to the client */
    CREATE BUFFER hRowObjUpd2  FOR TABLE hRowObjUpd.    
    CREATE QUERY hQuery2.
    hQuery2:SET-BUFFERS(hRowObjUpd2).
    hQuery2:QUERY-PREPARE('FOR EACH ' + hRowObjUpd2:NAME +
                         ' WHERE RowMod = "A" OR RowMod = "C" OR RowMod = "U"':U).
    hQuery2:QUERY-OPEN().
    hQuery2:GET-FIRST().
    DO WHILE hRowObjUpd2:AVAILABLE:
      RUN refetchDBRow IN TARGET-PROCEDURE (hRowObjUpd2) NO-ERROR.   
             /* Support return-value from triggers (from RefetchDbRow)*/ 
      IF ERROR-STATUS:ERROR THEN
        RUN addMessage IN TARGET-PROCEDURE
             (IF RETURN-VALUE <> '':U THEN RETURN-VALUE ELSE ?, ?, ?).
      hQuery2:GET-NEXT().
    END.
    DELETE OBJECT hRowObjUpd2.
    DELETE OBJECT hQuery2.
  END.          /* END transaction block. */ 
    
    /* RELEASE the database record(s). */
  RUN releaseDBRow IN TARGET-PROCEDURE.

  /* Add a message to indicate the update has been cancelled. */
  IF pocUndoIds NE "":U THEN
    RUN addMessage IN TARGET-PROCEDURE ({fnarg messageNumber 15},?,?).

  /* This user-defined validation hook is for code to be executed
     outside the transaction, after all updates occur. */
  IF NOT lQueryContainer THEN
  DO:
    RUN bufferValidate IN TARGET-PROCEDURE ("post":U).    
    IF RETURN-VALUE NE "":U THEN
    DO:
      RUN prepareErrorsForReturn IN TARGET-PROCEDURE
                                (INPUT RETURN-VALUE, INPUT cASDivision, 
                                 INPUT-OUTPUT pocMessages).
      RETURN.      /* Bail out if application code rejected the txn. */
    END.   /* END DO IF RETURN-VALUE NE "" */
  END.       /* END DO IF Container (SBO) is not doing the commit for us. */

  /* If we're not on an AppServer, the messages will be available to the
     caller, so don't "fetch" them (which would also delete them). */
  RUN prepareErrorsForReturn IN TARGET-PROCEDURE
                            (INPUT RETURN-VALUE, INPUT cASDivision, 
                             INPUT-OUTPUT pocMessages).
  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-bufferProcessDelete) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE bufferProcessDelete Procedure 
PROCEDURE bufferProcessDelete PRIVATE :
/*------------------------------------------------------------------------------
  Purpose:     Code to handle DELETE operations (RowMod = "D")
  Parameters:  
  Notes:       This should only be called as part of a commit transaction, 
               (bufferCommit), so it's made PRIVATE
------------------------------------------------------------------------------*/
  DEFINE INPUT-OUTPUT PARAMETER pocMessages AS CHARACTER NO-UNDO.
  DEFINE INPUT-OUTPUT PARAMETER pocUndoIds  AS CHARACTER NO-UNDO.

  DEFINE VARIABLE hRowObjUpd    AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hQuery           AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cDeleteMsg       AS CHARACTER NO-UNDO.  

    {get RowObjUpd hRowObjUpd}.

     /* set up RowObjUpd query */
    CREATE QUERY hQuery.
    hQuery:SET-BUFFERS(hRowObjUpd).
    hQuery:QUERY-PREPARE('FOR EACH ' + hRowObjUpd:NAME + ' WHERE RowMod = "D"':U).
    hQuery:QUERY-OPEN().
    hQuery:GET-FIRST().

    DO WHILE hRowObjUpd:AVAILABLE:
      /* This will procedure will do the Delete (looking at RowMod) */
      RUN fetchDBRowForUpdate IN TARGET-PROCEDURE.
      IF RETURN-VALUE NE "":U THEN
      DO:
        /* fetchDbRowForUpdate will return "Delete" as LAST element of the 
           return-value if the Delete and not the FIND EXCLUSIVE-LOCK failed. */
        IF ENTRY(NUM-ENTRIES(RETURN-VALUE),RETURN-VALUE) = "Delete":U THEN
        DO:
          IF NUM-ENTRIES(RETURN-VALUE) = 2 THEN
            cDeleteMsg = {fnarg messageNumber 23}.
          ELSE /* support return-value from triggers */
            ASSIGN 
              cDeleteMsg = RETURN-VALUE 
              ENTRY(NUM-ENTRIES(cDeleteMsg),cDeleteMsg) = "":U
              ENTRY(1,cDeleteMsg) = "":U
              cDeleteMsg = TRIM(cDeleteMsg,",":U).
        END. /* if entry(num-entries(return-value) = 'delete' */ 
        ELSE /* locked record */
          cDeleteMsg = {fnarg messageNumber 18}.

        RUN addMessage IN TARGET-PROCEDURE
              (cDeleteMsg, ?, ENTRY(1,RETURN-VALUE)).
        pocUndoIds = pocUndoIds + string(hRowObjUpd:BUFFER-FIELD('RowNum':U):BUFFER-VALUE) + CHR(3) + ",":U.
      END.      /* END DO IF RETURN-VALUE NE "" */
      hQuery:GET-NEXT().
    END.        /* END FOR EACH block */

    DELETE OBJECT hQuery.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-bufferProcessNew) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE bufferProcessNew Procedure 
PROCEDURE bufferProcessNew PRIVATE :
/*------------------------------------------------------------------------------
  Purpose:     Code to handle ADD/COPY operations
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/  
  DEFINE INPUT-OUTPUT PARAMETER pocMessages AS CHARACTER NO-UNDO.
  DEFINE INPUT-OUTPUT PARAMETER pocUndoIds  AS CHARACTER NO-UNDO.

  DEFINE VARIABLE hRowObjUpd       AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hQuery           AS HANDLE     NO-UNDO.

    {get RowObjUpd hRowObjUpd}.
/*     CREATE BUFFER hRowObjUpd FOR TABLE hRowObjUpd.  */
  
     /* set up RowObjUpd query */
    CREATE QUERY hQuery.
    hQuery:SET-BUFFERS(hRowObjUpd).
    hQuery:QUERY-PREPARE('FOR EACH ' + hRowObjUpd:NAME + 
                         ' WHERE RowMod = "A" OR RowMod = "C"':U).
    hQuery:QUERY-OPEN().
  
    REPEAT:
      hQuery:GET-NEXT().
      IF hQuery:QUERY-OFF-END THEN LEAVE.

      /* This procedure will do the record Create (looking at RowMod) */
      RUN assignDBRow IN TARGET-PROCEDURE (INPUT hRowObjUpd).
      IF RETURN-VALUE NE "":U THEN  /* returns table name in error. */
      DO:
        /* If the add failed, clear the rowident field because the rowid 
           assigned to it after the BUFFER-CREATE in assignDBRow is now invalid 
           due to the failure. */
        ASSIGN 
          hRowObjUpd:BUFFER-FIELD('RowIdent':U):BUFFER-VALUE = "" 
          hRowObjUpd:BUFFER-FIELD('RowIdentIdx':U):BUFFER-VALUE = "".
        /* If BUFFER-CREATE faile because of a CREATE trigger we add return-value
           before the table name, otherwise set the first parameter of addMessage
           to ? to retrieve errors from error-status */
        RUN addMessage IN TARGET-PROCEDURE                                  
                          (IF NUM-ENTRIES(RETURN-VALUE,CHR(3)) > 1                 
                           THEN ENTRY(1,RETURN-VALUE,CHR(3))                           
                           ELSE ?,                                                   
                           ?,                                                        
                           ENTRY(NUM-ENTRIES(RETURN-VALUE, CHR(3)),RETURN-VALUE,CHR(3))       
                           ).                                                        
         pocUndoIds = pocUndoIds + STRING(hRowObjUpd:BUFFER-FIELD('RowNum':U):BUFFER-VALUE) + CHR(3) + ",":U.
         UNDO, NEXT. /* The FOR EACH block is undone and nexted. */
      END.    /* END DO IF ERROR-STATUS:ERROR OR cErrorMsgs NE "":U */
      /* Pass back the final values to the client. Note - because we
         want to get values changed by the db trigger, we copy *all*
         fields, not just the ones that are enabled in the Data Object. */
      RUN refetchDBRow In TARGET-PROCEDURE (INPUT hRowObjUpd) NO-ERROR.      
      /* if a database trigger returns error it will be catched here */
      IF ERROR-STATUS:ERROR THEN
      DO:
        pocUndoIds = pocUndoIds + STRING(hRowObjUpd:BUFFER-FIELD('RowNum':U):BUFFER-VALUE) + CHR(3) + ",":U.
        RUN addMessage IN TARGET-PROCEDURE 
            /* Support return-value from triggers (from RefetchDbRow)*/ 
            (IF RETURN-VALUE <> '':U THEN RETURN-VALUE ELSE ?, ?, ?).
        UNDO, NEXT. /* The FOR EACH block is undone and nexted. */
      END.

    END.  /* END REPEAT for Adds. */

    DELETE OBJECT hQuery.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-bufferProcessUpdate) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE bufferProcessUpdate Procedure 
PROCEDURE bufferProcessUpdate PRIVATE :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT-OUTPUT PARAMETER pocMessages AS CHARACTER NO-UNDO.
  DEFINE INPUT-OUTPUT PARAMETER pocUndoIds  AS CHARACTER NO-UNDO.

  DEFINE VARIABLE hRowObjUpd    AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hRowObjUpd2   AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hQuery           AS HANDLE     NO-UNDO.
  DEFINE VARIABLE lCheck        AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE cASDivision   AS CHARACTER NO-UNDO.

    {get ASDivision cASDivision}.
    {get RowObjUpd hRowObjUpd}.

    CREATE BUFFER hRowObjUpd2 FOR TABLE hRowObjUpd.

      /* set up RowObjUpd query */
    CREATE QUERY hQuery.
    hQuery:SET-BUFFERS(hRowObjUpd).
    hQuery:QUERY-PREPARE('FOR EACH ' + hRowObjUpd:NAME + ' WHERE RowMod = ""':U).
    hQuery:QUERY-OPEN().

    /* First locate each pre-change record. Find corresponding database record
       and do a buffer-compare to make sure it hasn't been changed. */
    Process-Update-Records-Blk:
    REPEAT:
      hQuery:GET-NEXT().
      IF hQuery:QUERY-OFF-END THEN LEAVE Process-Update-Records-Blk.

       /* For each table in the join, update its fields if on the enabled list.
         NOTE: at present at least we don't check whether fields in this table
         have actually been modified in this record. */
      RUN fetchDBRowForUpdate IN TARGET-PROCEDURE.
      IF RETURN-VALUE NE "":U THEN
      DO:
        RUN addMessage IN TARGET-PROCEDURE ({fnarg messageNumber 18}, ?, RETURN-VALUE).
        pocUndoIds = pocUndoIds + string(hRowObjUpd:BUFFER-FIELD('RowNum':U):BUFFER-VALUE) + CHR(3) + ",":U.
        UNDO Process-Update-Records-Blk, NEXT Process-Update-Records-Blk.
      END.
        /* Check first whether we care if the database record has been
           changed by another user. This is a settable instance property. */
      {get CheckCurrentChanged lCheck}.
      IF lCheck THEN
      DO:
          RUN compareDBRow IN TARGET-PROCEDURE.
          IF RETURN-VALUE NE "":U THEN /* Table name that didn't compare is returned. */
          DO:
            RUN addMessage IN TARGET-PROCEDURE
                  (SUBSTITUTE({fnarg messageNumber 8}, '':U /* No field names available. */) , ?, 
                   RETURN-VALUE  /* Table name that didn't compare */).
            pocUndoIds = pocUndoIds + string(hRowObjUpd:BUFFER-FIELD('RowNum':U):BUFFER-VALUE) + 
                         CHR(3) + "ADM-FIELDS-CHANGED":U + ",":U.
            /* Get the changed version of the record in order to copy
               the new database values into it to pass back to the client.*/
            hRowObjUpd2:FIND-FIRST('WHERE RowMod = "U" AND RowNum = ':U +
                                   STRING(hRowObjUpd:BUFFER-FIELD('RowNum':U):BUFFER-VALUE)).
            RUN refetchDBRow IN TARGET-PROCEDURE (INPUT hRowObjUpd2) NO-ERROR.
            IF ERROR-STATUS:ERROR THEN
            DO:
              RUN addMessage IN TARGET-PROCEDURE
                   /* Support return-value from triggers (from RefetchDbRow)*/ 
                   (IF RETURN-VALUE <> '':U THEN RETURN-VALUE ELSE ?, ?, ?).
              pocUndoIds = pocUndoIds + STRING(hRowObjUpd2:BUFFER-FIELD('RowNum':U):BUFFER-VALUE) + CHR(3) + ",":U.
            END.  /* If ERROR */
            IF cASDivision = 'Server':U THEN
              pocMessages = LEFT-TRIM(pocMessages + CHR(3) + 
                                      DYNAMIC-FUNCTION('fetchMessages':U IN TARGET-PROCEDURE) , CHR(3)).

            /* Don't try to write values to db. Just process next update record. */
            NEXT Process-Update-Records-Blk.
          END.  /* END DO IF compareDBRow returned a table value */
      END.    /* END DO IF CheckCurrentChanged */

      DO:   /* If we haven't 'next'ed because of an error, do the update. */
          /* Now find the changed version of the record, move its fields to the
             database record(s) which were found above, and report any errors
             (which would be database triggers at this point). */
          hRowObjUpd2:FIND-FIRST('WHERE RowMod = "U" AND RowNum = ':U +
                                 STRING(hRowObjUpd:BUFFER-FIELD('RowNum':U):BUFFER-VALUE)).
          /* Copy the ChangedFields to this buffer too */
          ASSIGN hRowObjUpd2:BUFFER-FIELD('ChangedFields':U):BUFFER-VALUE = 
                       hRowObjUpd:BUFFER-FIELD('ChangedFields':U):BUFFER-VALUE.
          RUN assignDBRow IN TARGET-PROCEDURE (INPUT hRowObjUpd2).
          IF RETURN-VALUE NE "":U THEN  /* returns table name in error. */
          DO:
            RUN addMessage IN TARGET-PROCEDURE (?, ?, RETURN-VALUE).
            pocUndoIds = pocUndoIds + STRING(hRowObjUpd:BUFFER-FIELD('RowNum':U):BUFFER-VALUE) + CHR(3) + ",":U.
            UNDO, NEXT. /* The FOR EACH block is undone and nexted. */
          END.   /* END DO IF RETURN-VALUE NE "" */
          
          /* Pass back the final values to the client. Note - because we
             want to get values changed by the db trigger, we copy *all*
             fields, not just the ones that are enabled in the Data Object. */
          RUN refetchDBRow IN TARGET-PROCEDURE (INPUT hRowObjUpd2) NO-ERROR.
          IF ERROR-STATUS:ERROR THEN
          DO:
            RUN addMessage IN TARGET-PROCEDURE 
                   /* Support return-value from triggers (from RefetchDbRow)*/ 
                  (IF RETURN-VALUE <> '':U THEN RETURN-VALUE ELSE ?, ?, ?).
            pocUndoIds = pocUndoIds + STRING(hRowObjUpd2:BUFFER-FIELD('RowNum':U):BUFFER-VALUE) + CHR(3) + ",":U.
          END.  /* if ERROR */
      END.  /* END DO the update for this row if no error */
    END.  /* END FOR EACH RowObjUpd */
   
    DELETE OBJECT hQuery.
    DELETE OBJECT hRowObjUpd2.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-bufferTransactionValidate) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE bufferTransactionValidate Procedure 
PROCEDURE bufferTransactionValidate :
/*------------------------------------------------------------------------------
  Purpose: General logic for the commit/transaction hooks that does a dynmaic
           'for each' and fires the relevant low level record hooks.
  Parameters:  pcLevel - The level/place from which this hook is fired, used to fire the 
                         correct low level hook.
                             
                         Pre   - Before the transaction is started
                         Begin - At the beginning/top of transaction
                         End   - At end of transaction
                         Post  - After the transaction is started
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcLevel  AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE hQuery        AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hRowObjUpd    AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hRowObjUpdBI  AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cMessageList  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hReturnBuffer AS HANDLE     NO-UNDO.
  DEFINE VARIABLE xcFixedName   AS CHARACTER  NO-UNDO INIT 'TransValidate':U.
  DEFINE VARIABLE hLogicObject  AS HANDLE     NO-UNDO.

  &SCOPED-DEFINE xp-assign
  {get RowObjUpd hRowObjUpd}
  {get DataLogicObject hLogicObject}
  .
  &UNDEFINE xp-assign
  
  IF NOT VALID-HANDLE(hLogicObject) THEN
    RETURN.
  
  CREATE BUFFER hRowObjUpd   FOR TABLE hRowObjUpd.
  CREATE BUFFER hRowObjUpdBI FOR TABLE hRowObjUpd.


  /* set up RowObjUpd query */
  CREATE QUERY hQuery.
  hQuery:SET-BUFFERS(hRowObjUpd).
  hQuery:QUERY-PREPARE('FOR EACH ' + hRowObjUpd:NAME + ' WHERE RowMod <> ""':U).
  hQuery:QUERY-OPEN().
  hQuery:GET-FIRST().
  
  DO WHILE hRowObjUpd:AVAILABLE:
    
    /* Fetch the before image of the current record if this is an update */
    IF hRowObjUpd:BUFFER-FIELD('RowMod':U):BUFFER-VALUE = "U":U THEN
      hRowObjUpdBI:FIND-FIRST('WHERE RowMod = "" AND RowNum = ':U +
                                 STRING(hRowObjUpd:BUFFER-FIELD('RowNum':U):BUFFER-VALUE)).
    ELSE 
      hROwObjUpdBI:BUFFER-RELEASE. 
    
    RUN setLogicBuffer IN TARGET-PROCEDURE
           (INPUT hRowObjUpd,
            INPUT IF hRowObjUpdBI:AVAILABLE THEN hRowObjUpdBI ELSE ?).

    IF CAN-DO("A,C,U":U,hRowObjUpd:BUFFER-FIELD('RowMod':U):BUFFER-VALUE) THEN
    DO:
      IF CAN-DO("A,C":U,hRowObjUpd:BUFFER-FIELD('RowMod':U):BUFFER-VALUE) THEN
      DO:
        RUN VALUE('create':U + pcLevel + xcFixedName) IN TARGET-PROCEDURE NO-ERROR.
        IF RETURN-VALUE NE "":U THEN
          cMessageList = cMessageList
                       + (IF NUM-ENTRIES(cMessageList,CHR(3)) > 0 THEN CHR(3) ELSE '':U) 
                       + RETURN-VALUE.
      END.

      RUN VALUE('write':U + pcLevel + xcFixedName) IN TARGET-PROCEDURE NO-ERROR.
      IF RETURN-VALUE NE "":U THEN
        cMessageList = cMessageList
                     + (IF NUM-ENTRIES(cMessageList,CHR(3)) > 0 THEN CHR(3) ELSE '':U) 
                     + RETURN-VALUE.
    END. /* Add, Copy, Update */
    ELSE IF hRowObjUpd:BUFFER-FIELD('RowMod':U):BUFFER-VALUE = "D":U THEN
    DO:
      RUN VALUE('delete':U + pcLevel + xcFixedName) IN TARGET-PROCEDURE NO-ERROR.
      IF RETURN-VALUE NE "":U THEN
        cMessageList = cMessageList
                     + (IF NUM-ENTRIES(cMessageList,CHR(3)) > 0 THEN CHR(3) ELSE '':U) 
                     + RETURN-VALUE.
    END. /* Delete */

    RUN getLogicBuffer IN TARGET-PROCEDURE (OUTPUT hReturnBuffer).
     
    hRowObjUpd:BUFFER-COPY(hReturnBuffer).
    
    RUN clearLogicRows IN TARGET-PROCEDURE.
    
    hQuery:GET-NEXT.

  END.
   
  DELETE OBJECT hRowObjUpd. 
  DELETE OBJECT hRowObjUpdBI. 
  DELETE OBJECT hQuery. 
  
  ERROR-STATUS:ERROR = NO.
  RETURN cMessageList.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-bufferValidate) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE bufferValidate Procedure 
PROCEDURE bufferValidate :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  INPUT pcValType AS CHARACTER -- "Pre", "Begin", "End", "Post"
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pcValType AS CHAR   NO-UNDO.

DEFINE VARIABLE lLogicHook        AS LOGICAL    NO-UNDO.
DEFINE VARIABLE lLocalHook        AS LOGICAL    NO-UNDO.
DEFINE VARIABLE cHook             AS CHARACTER  NO-UNDO.
DEFINE VARIABLE hLogicObject      AS HANDLE     NO-UNDO.
DEFINE VARIABLE hRowObjUpdTable   AS HANDLE     NO-UNDO.
DEFINE VARIABLE cReturn           AS CHARACTER  NO-UNDO.

   {get RowObjUpdTable hRowObjUpdTable}.
   {get DataLogicObject hLogicObject}.
   
   /* We need to identify where the hook is because if the hook is ONLY in 
      the Logical Object then the TT need to be transfered back and forth.
      If the hook is local then we cannot transfer here asa th elocal then would
      change a different TT. It there for some reason should be hooks both
      locally and in the logic procedure the local hook would be a complete 
      overrride or it would need to do the transfer itself  */
   
   ASSIGN
     cHook      = pcValType + "TransactionValidate":U
     lLocalHook = LOOKUP(cHook,TARGET-PROCEDURE:INTERNAL-ENTRIES) > 0
     lLogicHook = VALID-HANDLE(hLogicObject) 
                  AND LOOKUP(cHook,hLogicObject:INTERNAL-ENTRIES) > 0.
   
   IF NOT lLocalHook AND lLogicHook THEN
     RUN setLogicRows IN TARGET-PROCEDURE (INPUT TABLE-HANDLE hRowObjUpdTable).

   RUN VALUE(cHook) IN TARGET-PROCEDURE.
   cReturn = RETURN-VALUE.
   
   IF NOT lLocalHook AND lLogicHook THEN
     RUN getLogicRows IN TARGET-PROCEDURE (OUTPUT TABLE-HANDLE hRowObjUpdTable).

   RETURN cReturn.

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
 DEFINE VARIABLE cPositionForClient  AS CHARACTER  NO-UNDO.

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

      {get ServerFileName cServerFileName}.
      cContext = {fn obtainContextForServer}.
      RUN adm2/sendrows.p ON hAppService
                         (cServerFileName,
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

&IF DEFINED(EXCLUDE-commitData) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE commitData Procedure 
PROCEDURE commitData :
/*------------------------------------------------------------------------------
  Purpose:     To commit multiple DB updates
  Parameters:  pcError: Possible commit Erros
  Notes:       This is the Open Client API version of commitTransaction
------------------------------------------------------------------------------*/
  DEFINE OUTPUT PARAMETER pcError AS CHAR NO-UNDO.

  {fn Commit}. 

  IF {fn anyMessage} THEN 
  DO: 
    pcError = {fn fetchMessages}.
    RUN undoTransaction IN TARGET-PROCEDURE.
  END.

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

&IF DEFINED(EXCLUDE-copyColumns) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE copyColumns Procedure 
PROCEDURE copyColumns :
/*------------------------------------------------------------------------------
  Purpose:     Called from copyRow to move column values to the new row.
  
  Parameters:
    INPUT pcViewColList - Comma delimited list of column names
    INPUT phDataQuery   - Handle to the RowObject query.
  
  Notes:       copyColumns exists primarily to remove code from the function
               copyRow, to reduce the size of the r-code action segment.
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER pcViewColList   AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER phDataQuery     AS HANDLE    NO-UNDO.
  
  DEFINE VARIABLE cVals      AS CHARACTER NO-UNDO INIT "":U.
  DEFINE VARIABLE iCol       AS INTEGER   NO-UNDO.
  DEFINE VARIABLE hCol       AS HANDLE    NO-UNDO.
  DEFINE VARIABLE iValue     AS INTEGER   NO-UNDO.
  DEFINE VARIABLE cArrayVal  AS CHARACTER NO-UNDO.
  DEFINE VARIABLE hRowObject AS HANDLE    NO-UNDO.
 
  hRowObject= phDataQuery:GET-BUFFER-HANDLE(1).
  IF phDataQuery:IS-OPEN THEN  /* Don't copy from RowObject if not used.*/
  DO iCol = 1 TO hRowObject:NUM-FIELDS:
    hCol = hRowObject:BUFFER-FIELD(iCol).
    /* Copy arrays a value at a time, into a CHR(1) - delimited list,
       with array elements separated by CHR(2). */
    IF hCol:EXTENT NE 0 THEN 
    DO:
      cArrayVal = "":U.
      DO iValue = 1 TO hCol:EXTENT:
        cArrayVal = cArrayVal +
                    (IF iValue > 1 THEN CHR(2) ELSE "":U) +
                    IF hCol:BUFFER-VALUE(iValue) = ? THEN "":U
                    ELSE hCol:BUFFER-VALUE[iValue].
      END.   /* END DO iValue */
      cVals = cVals + (IF iCol > 1 THEN CHR(1) ELSE "":U) + cArrayVal.
    END.     /* END DO for EXTENT */
    ELSE cVals = cVals
                 + (IF iCol > 1 THEN CHR(1) ELSE "":U)
                 +  IF hCol:BUFFER-VALUE = ? THEN "":U ELSE hCol:BUFFER-VALUE.
  END.       /* END DO iCol */
  ELSE    /* DO IF NOT IS-OPEN - get current vals from db rec */
    cVals = {fnarg colValues pcViewColList}.
      
  /* Now create the new record */
  hRowObject:BUFFER-CREATE().
  
  /* Move all the copied values into it. */
  IF phDataQuery:IS-OPEN THEN
  DO iCol = 1 TO hRowObject:NUM-FIELDS:
    hCol = hRowObject:BUFFER-FIELD(iCol).
    IF hCol:EXTENT NE 0 THEN 
    DO:
      cArrayVal = ENTRY(iCol, cVals, CHR(1)).
      DO iValue = 1 TO hCol:EXTENT:
        hCol:BUFFER-VALUE[iValue] = ENTRY(iValue, cArrayVal, CHR(2)).
      END.   /* END DO iValue */
    END.     /* END DO Extent */
    ELSE hCol:BUFFER-VALUE = ENTRY(iCol, cVals, CHR(1)) NO-ERROR. 
  END.       /* END DO iCol   */

  /* set RowNum, RowIdent and navigation Properties etc*/  
  {fnarg newRowObject 'Copy':U}.
 
  RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-createData) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE createData Procedure 
PROCEDURE createData :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 DEFINE INPUT         PARAMETER pcColumnNames AS CHARACTER  NO-UNDO.
 DEFINE INPUT-OUTPUT  PARAMETER pcNewValues   AS CHARACTER  NO-UNDO.
 DEFINE OUTPUT        PARAMETER pcError       AS CHARACTER  NO-UNDO.

 DEFINE VARIABLE cNewValueList     AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE iLoop             AS INTEGER    NO-UNDO.
 DEFINE VARIABLE cDataDelimiter    AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE lFoundOnClient    AS LOGICAL    NO-UNDO.
 DEFINE VARIABLE hRowObject        AS HANDLE     NO-UNDO.
 DEFINE VARIABLE hCol              AS HANDLE     NO-UNDO.
 DEFINE VARIABLE lSave             AS LOGICAL    NO-UNDO.
 DEFINE VARIABLE cUpdatableColumns AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cColumn           AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE iColumn           AS INTEGER    NO-UNDO.
 DEFINE VARIABLE cNewValue         AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cDataReadFormat AS CHARACTER  NO-UNDO.
 
 
 DYNAMIC-FUNCTION("addRow":U IN TARGET-PROCEDURE,"":U).
 
 &SCOPED-DEFINE xp-assign
 {get DataReadFormat cDataReadFormat}
 {get DataDelimiter cDataDelimiter}
 {get RowObject hRowObject}
 {get UpdatableColumns cUpdatableColumns}.
 &UNDEFINE xp-assign 
 
 DO iLoop = 1 TO NUM-ENTRIES(cUpdatableColumns):
   ASSIGN
     hCol    = ?
     cColumn = ENTRY(iLoop,cUpdatableColumns)
     iColumn = LOOKUP(cColumn,pcColumnNames)
     hCol    = hRowObject:BUFFER-FIELD(cColumn) NO-ERROR.
   IF VALID-HANDLE(hCol) AND iColumn > 0 THEN
     ASSIGN
       cNewValue       = ENTRY(iColumn,pcNewValues,cDataDelimiter)      
       cNewValueList   = cNewValueList 
                       + (IF cNewValueList = '':U THEN '':U ELSE CHR(1))
                       + cColumn
                       + CHR(1)
                       + (IF cNewValue <> ? THEN cNewValue ELSE '?':U).
 END.

 lSave = DYNAMIC-FUNCTION('submitRow':U IN TARGET-PROCEDURE,
                           STRING(hRowObject:ROWID),
                           cNewValueList).

 IF {fn anyMessage} THEN
   pcError = {fn fetchMessages}.
 
 pcNewValues = DYNAMIC-FUNCTION('colStringValues':U IN TARGET-PROCEDURE,
                                 pcColumnNames,
                                cDataReadFormat,
                                cDataDelimiter). 

 IF NOT lSave THEN  
    DYNAMIC-FUNCTION('cancelRow':U IN TARGET-PROCEDURE).  

 RETURN.

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
  DEFINE VARIABLE lOpenOnInit          AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lInitialized         AS LOGICAL    NO-UNDO.

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
    {get OpenOnInit lOpenOnInit}.
    
    /* No need to do more here it will be done on the server */
    IF lOpenOnInit THEN
      RETURN.
    
    /* If we have no logic procedure or repository manger, calculatedcolumns 
       need to be defined on server. We call it here if stand-alone design mode
       or just RETURN if runtime or inside a container */ 
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
  ELSE /* db connected, create buffers queries etc..*/
    RUN SUPER.

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
  DEFINE VARIABLE lOpen             AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE hDataReadHandler  AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cSourceFields  AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cLocalFields   AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cValues        AS CHARACTER NO-UNDO.
  DEFINE VARIABLE hDataSource    AS HANDLE    NO-UNDO.
  DEFINE VARIABLE iField         AS INTEGER   NO-UNDO.      
  DEFINE VARIABLE hRowObject     AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cASDivision    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lFound         AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cNewBatchInfo     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lOneToOne      AS LOGICAL    NO-UNDO.

  {get ObjectInitialized lInitted}.
  /* Ignore if we haven't been initialized yet; also, 
     if for some reason this object is in addmode.
    (Called from cancelRow in the first of two SDOs in SBOs for example) 
     updated row (pcRelative = 'SAME') requires no reset.*/
  IF (NOT lInitted) OR (pcRelative = "SAME":U) THEN 
    RETURN.  
  
  {get ForeignFields cForeignFields}.

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
       keep 'reset' to avoid an attempt to reopen ( the hasForeignKey 
       check would fail) */
    {get OpenOnInit lOpen}.
    IF NOT lOpen THEN
    DO:
      {get ContainerSource hContainer}.
      IF VALID-HANDLE(hContainer) THEN       
        lOpen =  NOT {fn isFetchPending hContainer}.
      ELSE 
        lOpen = TRUE.
    END.
    IF lOpen THEN
    DO:
      {get RowObjectState cRowObjectState}.
      /* there are logic in query.p that makes this into 'reset' again 
         if the source is in newMode or not available */ 
      IF cRowObjectState = 'NoUpdates':U 
      AND {fn hasForeignKeyChanged}  THEN
        pcRelative = 'DIFFERENT':U.
    END.
  END. /* reset */

  &SCOPED-DEFINE xp-assign
  {get ASDivision cASDivision}
  {get UpdateFromSource lOneToOne}
  {get RowObject hRowObject}
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

&IF DEFINED(EXCLUDE-deleteData) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE deleteData Procedure 
PROCEDURE deleteData :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 DEFINE INPUT         PARAMETER pcColumnNames AS CHARACTER  NO-UNDO.
 DEFINE INPUT         PARAMETER pcOldValues   AS CHARACTER  NO-UNDO.
 DEFINE OUTPUT        PARAMETER pcError       AS CHARACTER  NO-UNDO.

 DEFINE VARIABLE cKeyFields     AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cKeyValues     AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cNewValueList  AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE iLoop          AS INTEGER    NO-UNDO.
 DEFINE VARIABLE iField         AS INTEGER    NO-UNDO.
 DEFINE VARIABLE cKey           AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cValue         AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cDataDelimiter AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE lFoundOnClient AS LOGICAL    NO-UNDO.
 DEFINE VARIABLE hRowObject     AS HANDLE     NO-UNDO.
 DEFINE VARIABLE hCol           AS HANDLE     NO-UNDO.
 DEFINE VARIABLE lReopen        AS LOGICAL    NO-UNDO.
 DEFINE VARIABLE lCreated       AS LOGICAL    NO-UNDO.
 DEFINE VARIABLE lSave          AS LOGICAL    NO-UNDO.
 DEFINE VARIABLE lNoKeyFields   AS LOGICAL    NO-UNDO.
 DEFINE VARIABLE lFound         AS LOGICAL    NO-UNDO.

 {get KeyFields cKeyFields}.
 {get DataDelimiter cDataDelimiter}.

 DO iLoop = 1 TO NUM-ENTRIES(cKeyFields):
   ASSIGN
     cKey     = ENTRY(iLoop,cKeyFields)
     iField   = LOOKUP(cKey,pcColumnNames).
   
   IF iField = 0 THEN
   DO:
     lNoKeyFields = TRUE.
     LEAVE.
   END.
   
   ASSIGN 
     cValue     = ENTRY(iField,pcOldValues,cDataDelimiter). 
     cKeyValues = cKeyValues 
                  + (IF iloop = 1 THEN '':U ELSE CHR(1))
                  +  cValue.
 END.

 IF lNoKeyFields THEN
 DO:
   iField = LOOKUP('RowIdent':U,pcColumnNames).
   IF iField = 0 THEN
   DO:
     pcError = "Missing one or some of the '" 
               + REPLACE(cKeyFields,',',' ') + "' or RowIdent in list of columnns.".
     RETURN.
   END.
   cValue     = ENTRY(iField,pcOldValues,cDataDelimiter).   
 END.

 {get RowObject hRowObject}.
 
  /* Currently we need the RowObject with all fields from the db */
 IF lNoKeyFields THEN
 DO:
   DYNAMIC-FUNCTION('fetchRowident':U IN TARGET-PROCEDURE,cValue,'':U).
   lFound = cValue = hRowObject:BUFFER-FIELD('Rowident':U):BUFFER-VALUE NO-ERROR.
 END.
 ELSE
   lFound = DYNAMIC-FUNCTION('findRowWhere':U IN TARGET-PROCEDURE,
                             cKeyFields,
                             cKeyValues,
                             '=':U).
 IF lFound THEN
   DYNAMIC-FUNCTION('deleteRow':U IN TARGET-PROCEDURE,
                     STRING(hRowObject:ROWID)).
 ELSE 
   DYNAMIC-FUNCTION('addNotFoundMessage':U IN TARGET-PROCEDURE,
                     IF lNoKeyFields THEN 'ROWIDENT':U ELSE cKeyFields,
                     IF lNoKeyFields THEN cValue ELSE cKeyValues,
                    '=':U).

 IF {fn anyMessage} THEN
   pcError = {fn fetchMessages}.
  
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
    .
    &UNDEFINE xp-assign
    
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
          ttSchema.column_name            = hColumn:NAME
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
        /* Loop through each column and get its TT record and assign fields based on table list */
        DO iColumn = 1 TO NUM-ENTRIES(cColumnsForThisTable):
               FIND FIRST ttSchema WHERE ttSchema.column_name = ENTRY(iColumn, cColumnsForThisTable) NO-ERROR.
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
                   /* Remarked out as it is set above */
    /*                ttSchema.calculated_field = NO. /* Previously assigned all fields as calculated, now overwrite fields with tables to NOT calcualted */ */
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
  Notes:    -  The external tool's exportData will do a call back to the SDO's
               tableout procedure for the actual retrieval of the data.    
            -  Always excludes rowobject specific fields,
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

&IF DEFINED(EXCLUDE-fetchBatch) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE fetchBatch Procedure 
PROCEDURE fetchBatch :
/*------------------------------------------------------------------------------
  Purpose:     To transfer another "batch" of rows from the database query to 
               the RowObject Temp-Table query, without changing the current 
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

  DEFINE INPUT PARAMETER plForwards  AS LOGICAL NO-UNDO.
  
  DEFINE VARIABLE hDataQuery    AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hRowNum       AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hRowIdent     AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hObject       AS HANDLE    NO-UNDO.
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

     {get ServerFileName cServerFileName}.
     cContext = {fn obtainContextForServer}.   
  
     RUN adm2/fetchdefs.p ON hAppservice (cServerFileName,
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
    PUBLISH 'dataAvailable':U FROM TARGET-PROCEDURE 
       (IF lReposAvail THEN "REPOSITIONED":U ELSE "FIRST":U).     
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
    PUBLISH 'dataAvailable':U FROM TARGET-PROCEDURE
        (IF lReposAvail THEN "Repositioned":U ELSE "LAST":U).      
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
  DEFINE VARIABLE cRowObjectState       AS CHARACTER   NO-UNDO.
  DEFINE VARIABLE cFirstResultRow       AS CHARACTER   NO-UNDO.
  DEFINE VARIABLE cLastResultRow        AS CHARACTER   NO-UNDO.
  DEFINE VARIABLE cQueryRowIdent        AS CHARACTER   NO-UNDO.
  DEFINE VARIABLE iLastRowNum           AS INTEGER     NO-UNDO.
  DEFINE VARIABLE iFirstRowNum          AS INTEGER     NO-UNDO.
  DEFINE VARIABLE cLastRowNum           AS CHARACTER   NO-UNDO.
  DEFINE VARIABLE cQueryWhere           AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cQueryString          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cQueryColumns         AS CHARACTER  NO-UNDO.
  
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

  &SCOPED-DEFINE xp-assign 
  {get CheckCurrentChanged lCheckCurrentChanged}
  {get RowObjectState cRowObjectState}
  {get FirstResultRow cFirstResultRow}
  {get LastResultRow cLastResultRow}
  {get QueryRowIdent cQueryRowIdent}
  {get LastRowNum iLastRowNum} 
  {get FirstRowNum iFirstRowNum} 
  {get PositionForClient cPositionForClient}
  &UNDEFINE xp-assign
  
          /* Rebuild the context string to look like: 
              prop1 CHR(4) val1 CHR(3) prop2 CHR(4) val2 CHR(3) ...                  */
    pcContext =
        "CheckCurrentChanged":U + CHR(4) +
            (IF lCheckCurrentChanged THEN "Yes":U ELSE "No":U)     + CHR(3) +
        "RowObjectState":U + CHR(4) + 
            (IF cRowObjectState = ? THEN "?":U ELSE cRowObjectState) + CHR(3) +
        "FirstResultRow":U + CHR(4) + 
            (IF cFirstResultRow = ? THEN "?":U ELSE cFirstResultRow) + CHR(3) +
        "LastResultRow":U + CHR(4) + 
            (IF cLastResultRow = ? THEN "?":U ELSE cLastResultRow)   + CHR(3) +
        "LastRowNum":U + CHR(4) + 
            (IF iLastRowNum = ? THEN "?":U ELSE STRING(iLastRowNum))   + CHR(3) +
        "FirstRowNum":U + CHR(4) + 
            (IF iFirstRowNum = ? THEN "?":U ELSE STRING(iFirstRowNum))   + CHR(3) +
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
      &UNDEFINE xp-assign
      
       pcContext = pccontext + CHR(3)                               
                 + "Tables":U + CHR(4) + cTables 
                 + CHR(3)  
                 + "PhysicalTables":U + CHR(4) + cPhysicalTables 
                 + CHR(3)  
                 + "BaseQuery":U + CHR(4) + cBaseQuery 
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
    RUN showMessageProcedure IN TARGET-PROCEDURE("33,":U + cLogicProc, 
                                                 OUTPUT cDummy).
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
  DEFINE VARIABLE cAppService     AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cSvrFileName    AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cUIBMode        AS CHARACTER NO-UNDO.
  DEFINE VARIABLE hSource         AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hContainer      AS HANDLE    NO-UNDO.
  DEFINE VARIABLE lQueryContainer AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE cDynamicSDO     AS CHARACTER NO-UNDO.
  DEFINE VARIABLE lOpenOnInit     AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE hAppService     AS HANDLE    NO-UNDO.
  DEFINE VARIABLE lWait           AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE lInitialized    AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE hDataSource     AS HANDLE    NO-UNDO.
  DEFINE VARIABLE lQuerySource    AS LOGICAL   NO-UNDO.
  
  DEFINE VARIABLE cContAppservice AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hRowObjectTable AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cAsDivision     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cReturn         AS CHARACTER  NO-UNDO.

  /* If the object has a Partition named, then connect to it. */
  /* Skip all this if we're in design mode. */
  {get UIBMode cUIBMode}.
  IF cUIBMode = "":U THEN
  DO:
    /* ensure that initialization only happens once */
    {get ObjectInitialized lInitialized}.
    IF lInitialized THEN
      RETURN.

    /* If this object's Container is itself a query, set a prop
       to indicate that; this tells us if we're in an SBO. */
    {get ContainerSource hContainer}.
    IF VALID-HANDLE (hContainer) THEN
      {get QueryObject lQueryContainer hContainer} NO-ERROR.
    
    IF lQueryContainer = YES THEN
    DO:
      {get ASDivision cASDivision hContainer}.
      
      &SCOPED-DEFINE xp-assign
      {set QueryContainer YES}   /* by default it's NO */
      {set ASDivision cASDivision}
      .
      &UNDEFINE xp-assign
    END.

    {get DataSource hDataSource}.
    {get QueryObject lQuerySource hDataSource} NO-ERROR.

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
          IF (TARGET-PROCEDURE:FILE-NAME MATCHES '*_cl.*':U OR
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
  END.       /* END IF not UIBMode   */
    
  {get AsDivision cAsDivision}.

  /* Create temptables if dynamic, unless we are inside an SBO in which case
     the SBO will run createObjects from its createObjects. */
  IF NOT lQueryContainer OR cAsDivision = 'SERVER':U THEN
  DO:
    RUN createObjects IN TARGET-PROCEDURE NO-ERROR.
    IF ERROR-STATUS:ERROR OR RETURN-VALUE <> '':U THEN
      RETURN 'ADM-ERROR':U.
  END.

  /* Retrieve stored filter information */  
  IF cAsDivision <> 'SERVER':U AND VALID-HANDLE (hContainer) THEN
    RUN retrieveFilter IN TARGET-PROCEDURE.
  
  {get OpenOnInit lOpenOnInit}.  
  /* Set openOnInit false if a datacontainer can handle the server request*/ 
  IF VALID-HANDLE(hContainer) AND VALID-HANDLE(hAppservice) AND hAppService <> SESSION  THEN
  DO:
    /* Check AppServer properties to see if the object has no current or future 
       server bindings and is using a stateless operating mode. */   
    IF  {fn hasNoServerBinding} 
    /* check if the container is an unitialized dataContainer */ 
    AND {fn isFetchPending hContainer}  THEN
    DO:
      {set openOnInit FALSE}.
      lWait = TRUE.
    END.
  END.
  
  /* If not managed by a DataContainer or an SBO ensure that any ad-hoc 
     appserver request from this object keeps the connection until the data 
     request has completed */
  IF NOT lWait AND NOT lQueryContainer THEN
    {set BindScope 'data':U}. 

  RUN SUPER.   
  cReturn = RETURN-VALUE.
  
  IF lQueryContainer THEN 
    {get OpenOnInit lOpenOnInit hContainer}.
  
  /* If the query is not opened at initialize, we must ensure that 
     queryposition is correct. This is managed from the container if 
     queryContainer (SBO). */
  IF NOT lOpenOnInit THEN
    RUN updateQueryPosition IN TARGET-PROCEDURE.

  /* set back from before super or from container*/
  {set OpenOnInit lOpenOnInit}.

  /* If no query container and no fetch pending in datacontainer and still 
     no TT defined then we will go to the server and get it. 
     This will typically be the case in dynamic data objects when OpenOnInit 
     is false either in this object or in a datasource object */   
  IF cAsDivision = 'CLIENT':U AND NOT lQueryContainer AND NOT lWait THEN
  DO:
    {get RowObjectTable hRowObjectTable}.
    IF NOT VALID-HANDLE(hRowObjectTable) THEN
    DO:
      RUN fetchDefinitions IN TARGET-PROCEDURE NO-ERROR.
      IF ERROR-STATUS:ERROR OR RETURN-VALUE <> '':U THEN
        cReturn = 'ADM-ERROR'.
    END.
  END.
            
  RUN unbindServer IN TARGET-PROCEDURE('unconditional':U).

  IF cRETURN = "ADM-ERROR":U THEN
    RETURN "ADM-ERROR":U.
  ELSE 
    RETURN.
   
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
   
   DEFINE VARIABLE cRowObjectState AS CHARACTER  NO-UNDO.
   DEFINE VARIABLE lNew            AS LOGICAL    NO-UNDO.
   DEFINE VARIABLE lDataModified   AS LOGICAL    NO-UNDO.
   
   /* No need to check a pending update was found somewhere else or */
   /* this SDO is a 1-to-1 child */
   IF NOT plUpdate AND NOT {fn getUpdateFromSource} THEN
   DO:

     &SCOPED-DEFINE xp-assign
     {get RowObjectState cRowObjectState}
     {get DataModified lDataModified}
     /* We can use NewRow and not newMode, as RowObjectstate 'RowUpdated' also 
        is included.  */
     {get NewRow lNew}
     &UNDEFINE xp-assign
     
     plUpdate = (cRowObjectState = 'RowUpdated':U) 
                 OR (lNew = TRUE) /* unknown is no (NewRow is sometimes ?) */
                 OR (lDataModified = TRUE)
     . 
   
     IF NOT plUpdate THEN 
       PUBLISH 'isUpdatePending':U FROM TARGET-PROCEDURE (INPUT-OUTPUT plUpdate).
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
               The event is republished up the groupAssignSource and
               the DataSource, which will run LinkstateHandler if they 
               found that they can deactivate the link 
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pcState  AS CHARACTER NO-UNDO.
  
  DEFINE VARIABLE cTargets         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iTarget          AS INTEGER    NO-UNDO.
  DEFINE VARIABLE hTarget          AS HANDLE     NO-UNDO.
  DEFINE VARIABLE lRePublish       AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cObjectType      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hContainer       AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hGASource        AS HANDLE     NO-UNDO.  
  DEFINE VARIABLE lHidden          AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lVisualSource    AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lToggleTargets   AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lActiveTarget    AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lInitialized     AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE hSourceProcedure AS HANDLE     NO-UNDO.
  
  {get ObjectInitialized lInitialized}.
  IF NOT linitialized THEN
     RETURN.

  /* Ignore 'activeTarget' and 'inactiveTarget' published from child SDOs/SBOs 
     to only reach the navigationSource */
  IF NOT CAN-DO('active,inactive':U,pcState ) THEN
    RETURN.

  hSourceProcedure = SOURCE-PROCEDURE. 
  {get ObjectType cObjectType SOURCE-PROCEDURE}.
  IF cObjectType = 'SUPER':U THEN
     hSourceProcedure = {fn getTargetProcedure SOURCE-PROCEDURE}. 

  {get ContainerHandle hContainer hSourceProcedure}.
  lVisualSource = VALID-HANDLE(hContainer).
  IF lVisualSource THEN
  DO:
    /* Ignore this if it's from a GA Target. 
      (it is published up through the GA-link and will reach us from the source)*/ 
    {get GroupAssignSource hGaSource hSourceProcedure} NO-ERROR.
    IF VALID-HANDLE(hGaSource) THEN
       RETURN.
    
   /* Ignore an 'inactive' message from a visual object if it or any of the 
       GAtargets are visible (or will become visible) */
   IF pcState = 'inactive':U THEN
    DO:
      {get GroupAssignHidden lHidden hSourceProcedure} NO-ERROR.
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
    lToggleTargets = {fn canNavigate hSourceProcedure} NO-ERROR. 
    IF lToggleTargets = ? THEN 
      lToggleTargets = TRUE.
  END.
  
  IF lToggleTargets THEN
  DO:
    /* We keep the SDB active since it is to be disabled on changes
       from below and it also is more of a hazzle to reposition it if we 
       did disable it */
    {get ObjectType cObjectType hSourceProcedure}.
    IF cObjectType <> 'SmartDataBrowser':U THEN
    DO:
      RUN linkStateHandler IN hSourceProcedure 
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
      IF hTarget = hSourceProcedure THEN
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
        IF NOT lVisualSource THEN
          RETURN.

        lActiveTarget = TRUE.
        LEAVE.
      END.
    END. /* DataTarget loop */
  END. /* state = 'inactive' ans lToggleSource  */
  /* active */
  ELSE IF pcState = 'active':U AND NOT lVisualSource THEN
  DO:
    /* No need to republish an active message from a non-visual target if the 
       link already is active */
    IF NOT DYNAMIC-FUNCTION('isLinkInactive':U IN TARGET-PROCEDURE,
                            'DataSource':U,?) THEN
      RETURN.
  END.

  /* If not toggleDataTargets or any active target found for an 'inactive' 
     state then append 'target' so the DataSource ignores it, but the 
     Navigationsource reacts to it */ 
  IF NOT lToggleTargets OR lActiveTarget THEN
    pcState = pcstate + 'Target':U.
  
  PUBLISH 'linkState':U FROM TARGET-PROCEDURE (pcState). 

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
  Parameters: Yes there are parameters.  
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pcState   AS CHARACTER  NO-UNDO.
  DEFINE INPUT PARAMETER phObject  AS HANDLE     NO-UNDO.
  DEFINE INPUT PARAMETER pcLink    AS CHARACTER  NO-UNDO.
 
  DEFINE VARIABLE lDataInactive   AS LOGICAL NO-UNDO.

  IF pcstate = 'active':U AND pcLink = 'DataSource':U  THEN
  DO:
    /* if the source is inactive then just wait for the dataavailable
       that it will publish when it becomes active */ 
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
                   For a 'POSITION' request the position information is 
                   appended (cKeyField + ",":U + cFieldName)  
                   
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
 DEFINE INPUT-OUTPUT PARAMETER pcRunNames AS CHARACTER  NO-UNDO.
 DEFINE INPUT-OUTPUT PARAMETER pcQualNames     AS CHARACTER  NO-UNDO.
 DEFINE INPUT-OUTPUT PARAMETER pcQueryFields AS CHARACTER  NO-UNDO.
 DEFINE INPUT-OUTPUT PARAMETER pcQueries       AS CHARACTER  NO-UNDO.
 DEFINE INPUT-OUTPUT PARAMETER pcTempTables    AS CHARACTER  NO-UNDO.
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
 DEFINE VARIABLE lQueryOpen       AS LOGICAL    NO-UNDO.

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
   /* If the query is open then it must have been opened in initializeObject,
      so just return */ 
   {get QueryOpen lQueryOpen}.   
   IF lQueryOpen THEN
     RETURN.

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
 
 {get ObjectName cObjectName}.
 cQualName = cQualName + cObjectName.
 iPrepare = LOOKUP(cQualName,pcQualNames).
 
 IF NOT lPosition AND NOT lVisualtargets AND NOT lSkip THEN 
 DO:
   IF pcSourceName <> ? AND pcSourceName <> '':U THEN
   DO:
     {get ForeignFields cForeignFields}.
     cForeignFields = pcSourceName + ',':U + cForeignFields. 
     cMode = 'Child':U.
   END.
   ELSE IF CAN-DO(pcOptions,'Batch':U) THEN
     cMode = 'Batch':U.
 END.
 
 /***********  Not yet 
 IF lUseRepository THEN
  {get LogicalObjectName cRunName}.
 /* If logicalObjectname is blank use serverfilename. This is the case if 
    we do not use the Repository OR if the file isn't in the Repository
  */  
 IF cRunName = '':U THEN
  ***************/
 IF iPrepare = 0 THEN
 DO:
   IF lPosition AND NOT lSkip THEN
   DO:
     &SCOPED-DEFINE xp-assign
     {get FirstRowNum iFirstRowNum} 
     {get LastRowNum iLastRowNum}
     . 
     &UNDEFINE xp-assign
     
     /* If we have all data on the client, just return */  
     IF iFirstRowNum <> ? AND iLastRowNum <> ? THEN
        RETURN.

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
   
   IF NOT lSkip THEN 
     cQuery = {fnarg prepareForFetch cMode}.
   ELSE 
     cQuery = 'SKIP':U.
   
   &SCOPED-DEFINE xp-assign
     {get RowObjectTable hRowObjectTable}
     {get ServerFileName cRunName} 
   &UNDEFINE xp-assign   
     lFirst          = (pcHandles = '':U)  
     pcHandles       = pcHandles
                     + (IF lFirst THEN '':U ELSE ',':U)
                     + STRING(TARGET-PROCEDURE)
     pcQueries       = pcQueries
                     + (IF lFirst THEN '':U ELSE CHR(1))
                     + cQuery
     pcTempTables    = pcTempTables
                     + (IF lFirst THEN '':U ELSE ',':U)
                     + (IF VALID-HANDLE(hRowObjectTable) 
                        THEN STRING(hRowObjectTable)
                        ELSE '?':U)
     pcQualNames     = pcQualNames
                     + (IF lFirst THEN '':U ELSE ',':U)
                     + cQualName
     pcRunNames = pcRunNames
                     + (IF lFirst THEN '':U ELSE ',':U)
                     + cRunName
     pcQueryFields = pcQueryFields
                     + (IF lFirst THEN '':U ELSE CHR(1))
                     + IF cForeignFields <> ? 
                       THEN cForeignFields ELSE '':u
     .   
  
 END. /* not prepared */

 IF lPosition THEN
 DO:
   IF iPrepare > 0  THEN
     ENTRY(iPrepare,pcQueryFields,CHR(1)) = 
           ENTRY(iPrepare,pcQueryFields,CHR(1)) 
           + CHR(2)
           + pcSourceName.
   ELSE DO:
     pcQueryFields = pcQueryFields
                   + CHR(2)
                   + pcSourceName.
   END.
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
             INPUT-OUTPUT pcTempTables).  

     ELSE IF lVisualTargets AND cContainerType > '':U THEN
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
             INPUT-OUTPUT pcTempTables).  
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
      gone */ 
  hDataQuery:GET-PREV. 
  IF NOT hRowObject:AVAIL THEN
    hdataQuery:GET-FIRST.

  rRowid = hRowObject:ROWID.

  /* This special calling sequence tells sendRows to retrieve a new copy
     of the record pointed to by cRowIdent, give it the number iRowNum,
     and add it to the existing RowObject table. */
  RUN sendRows IN TARGET-PROCEDURE
                (iRowNum, 
                 cRowIdent, 
                 FALSE /* no Next */, 
                 1 /* Get just 1 row */, 
                 OUTPUT iRows).  
  
  /* If nothing to refresh resort to plan B */
  IF iRows = 0 THEN
  DO:
    /* get rid of the non existing row from the browse */
    PUBLISH 'DeleteComplete':U FROM TARGET-PROCEDURE. 
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
DEFINE VARIABLE cRUnAttribute                   AS CHARACTER    NO-UNDO.
DEFINE VARIABLE cFieldNames                     AS CHARACTER    NO-UNDO.
DEFINE VARIABLE cFieldValues                    AS CHARACTER    NO-UNDO.
DEFINE VARIABLE cFieldOperators                 AS CHARACTER    NO-UNDO.
DEFINE VARIABLE cEmptyString                    AS CHARACTER    NO-UNDO.
DEFINE VARIABLE lSuccess                        AS LOGICAL      NO-UNDO.
DEFINE VARIABLE cAssignQuerySelection           AS CHARACTER    NO-UNDO.
DEFINE VARIABLE cAddQueryWhere                  AS CHARACTER    NO-UNDO.
DEFINE VARIABLE cQuerySort                      AS CHARACTER    NO-UNDO.
DEFINE VARIABLE cManualAssignQuerySelection     AS CHARACTER    NO-UNDO.
DEFINE VARIABLE cManualAddQueryWhere            AS CHARACTER    NO-UNDO.
DEFINE VARIABLE cManualSetQuerySort             AS CHARACTER    NO-UNDO.
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
DEFINE VARIABLE cTableName                      AS CHARACTER    NO-UNDO.
DEFINE VARIABLE cQualifiedFieldList             AS CHARACTER    NO-UNDO.
DEFINE VARIABLE cQualifiedField                 AS CHARACTER    NO-UNDO.
DEFINE VARIABLE cField                          AS CHARACTER    NO-UNDO.
DEFINE VARIABLE cQueryString                    AS CHARACTER    NO-UNDO.
DEFINE VARIABLE cNewQueryString                 AS CHARACTER    NO-UNDO.
DEFINE VARIABLE lFilterActive                   AS LOGICAL      NO-UNDO.

/* RETRIEVAL OF FILTER IS DEPENDANT UPON LINKS WHICH ONLY EXIST CLIENT-SIDE */
    IF (SESSION:REMOTE OR SESSION:CLIENT-TYPE = "WEBSPEED":U) THEN RETURN.
    IF VALID-HANDLE(gshProfileManager) THEN
    DO: 
        {get LogicalObjectName cSdoName}.
        IF cSdoName EQ "":U OR cSdoName EQ ? THEN 
          ASSIGN cSdoName = TARGET-PROCEDURE:FILE-NAME. 

        {get ContainerSource hContainerSource}.

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
            
            /* clear the existing selection, get the sort first  */
            &SCOPED-DEFINE xp-assign
            {get QuerySort    cQuerySort}           
            {set QueryWhere   cEmptyString}
            .
            &UNDEFINE xp-assign
            
            IF cQuerySort > '':U THEN
              {set QuerySort cQuerySort}.

            loop-1:
            DO iLoop = 1 TO NUM-ENTRIES(cManualAddQueryWhere, CHR(4)):
              cEntry = ENTRY(iLoop, cManualAddQueryWhere, CHR(4)).      
              
              IF NUM-ENTRIES(cEntry, CHR(3)) <> 3 THEN 
                NEXT loop-1.
              
              cBuffer = ENTRY(2,cEntry,CHR(3)).
              
              IF cBuffer = "?":U THEN 
                cBuffer = "":U.

              DYNAMIC-FUNCTION("addQueryWhere" IN TARGET-PROCEDURE, ENTRY(1,cEntry,CHR(3)),
                                                                    cBuffer,
                                                                    ENTRY(3,cEntry,CHR(3))). 
            END.
            
            /* Set FilterActive property true if filter was applied */
            IF cFieldNames <> "":U THEN 
              {set FilterActive TRUE}.
           
            /* assign the retrieved criteria */                                              
    
            lSuccess = DYNAMIC-FUNC("assignQuerySelection":U IN TARGET-PROCEDURE,
                                     cFieldNames,
                                     cFieldValues,
                                     cFieldOperators).
            
            /* If we've filtered on any OUTER-JOINs, we need to remove the OUTER-JOIN keyword. *  
             * Otherwise, the filter isn't going to be effective.                              */
            {get QueryString  cQueryString}.
            IF  INDEX(cQueryString, "OUTER-JOIN":U) > 0
            AND NUM-ENTRIES(cFieldNames) > 0
            AND VALID-HANDLE(gshSessionManager) THEN 
            DO:
              DO iCnt = 1 TO NUM-ENTRIES(cFieldNames):
                 ASSIGN 
                   cField = ENTRY(iCnt, cFieldNames).

                 IF NUM-ENTRIES(cField, ".":U) = 1 THEN
                   ASSIGN 
                     cTableName      = {fnarg columnTable cField}
                     cTableName      = IF NUM-ENTRIES(cTableName, ".":U) = 2 /* Remove db qualifier if one has been returned */
                                       THEN ENTRY(2, cTableName, ".":U)
                                       ELSE cTableName
                     cQualifiedField = cTableName + ".":U + cField.
                 ELSE
                   ASSIGN cQualifiedField = cField. /* Already in the correct format */

                 ASSIGN cQualifiedFieldList  = cQualifiedFieldList + cQualifiedField + ",":U.
              END.
              ASSIGN
                cQualifiedFieldList = RIGHT-TRIM(cQualifiedFieldList, ",":U)
                cNewQueryString     = DYNAMIC-FUNCTION("filterEvaluateOuterJoins":U IN gshSessionManager, INPUT cQueryString, INPUT cQualifiedFieldList).

              /* The OUTER-JOIN keyword has now been removed.  Update the query if necessary. */
              IF cNewQueryString <> cQueryString THEN
                {set queryString cNewQueryString}.
            END.         
        END.
        ELSE IF cManualAddQueryWhere > '':U THEN
        DO:
          /* Ensure any manualaddquerywhere statements are actioned set-up in 
             initializeobject of an sdo clear the existing selection */
          &SCOPED-DEFINE xp-assign
          {get QuerySort    cQuerySort}           
          {set QueryWhere   cEmptyString}               
           /* re-apply any manual mods to queryWhere */
           .
          &UNDEFINE xp-assign
            
          IF cQuerySort > '':U THEN
            {set QuerySort cQuerySort}.

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
    END.
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
         -  A more consistent and balanced set of functions and methods for 
            context management has been implemented.
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
          hDataQuery:QUERY-CLOSE().
            
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
        {set QueryRowident ?}.
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
   
  RUN setPropertyList IN TARGET-PROCEDURE (pcContext).
    
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

  IF DYNAMIC-FUNCTION("anyMessage":U IN TARGET-PROCEDURE) THEN
  DO:
    /* Add the update cancelled message */
    RUN addMessage IN TARGET-PROCEDURE({fnarg messageNumber 15},?,?).
    RUN doReturnToAddMode IN TARGET-PROCEDURE.
    RETURN "ADM-ERROR":U.    /* If there were any Data messages */
  END.
  ELSE DO:
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
    
    rRowObject = TO-ROWID(ENTRY(1,pcRowIdent)).
    
    {get RowObject hRowObject}.
    
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
          /* From 9.1B+ we also publish uncommitted changes. */ 
        cState = (IF NOT plReopen     THEN 'SAME':U
                  ELSE IF lAutoCommit THEN 'DIFFERENT':U
                  /* we use 'RESET' for uncommitted new records, as this 
                     will reset panels and only reopen if child has 
                     no changes */
                  ELSE                     'RESET':U).  

        /* Note that submitForeignKey currently still is getting
           the ForeignFields from the parent instead of from the ForeignValues 
           if the source is NewRow and RowObjectState is 'RowUpdated'.
           This is probably not necessary now as 'reset' sets Foreignvalues.*/
        PUBLISH "dataAvailable":U FROM TARGET-PROCEDURE (cState).
        {set NewBatchInfo '':U}.
      END.
    END. /* Return = '' (Successful commit or not autocommit) */
    ELSE DO: 

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
  DEFINE VARIABLE lObjectFound    AS LOGICAL    NO-UNDO.
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
        /* if child runs stand-alone foreign fields don't matter */
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
                                    + cValue 
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
  Purpose:     To do validation on each of the columns of the a new RowObject 
               record, and on the record as a whole,  before committing it 
               to the database.

  Parameters:
    INPUT pcValueList  - A CHR(1) delimited list of Column Name<->value pairs
                         that need validation before committing a transaction.
    INPUT pcUpdColumns - A comma delimited list of the SmartDataObject columns
                         that are updatable.

  Notes:       There are three types of validation performed:
                 1) Newly entered data meets the format criteria.
                 2) Newly entered data is in an updatable field.
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
  
  DEFINE VARIABLE iColNum        AS INTEGER   NO-UNDO.
  DEFINE VARIABLE cColName       AS CHARACTER NO-UNDO.
  DEFINE VARIABLE hCol           AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hRowObject     AS HANDLE    NO-UNDO.
  DEFINE VARIABLE cValue         AS CHAR      NO-UNDO.
  DEFINE VARIABLE hLogicObject   AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hValRowObject  AS HANDLE     NO-UNDO.
  DEFINE VARIABLE lLocalVal      AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lLocalFieldVal AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lAnyFieldVal   AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cDataFieldDefs AS CHARACTER  NO-UNDO.

  &SCOPED-DEFINE xp-assign
  {get RowObject hRowObject}
  {get DataLogicObject hLogicObject}
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
      /* Verify that they're not trying to update a non-enabled field. */
      IF LOOKUP(cColName, pcUpdColumns) = 0 THEN
          RUN addMessage IN TARGET-PROCEDURE (SUBSTITUTE({fnarg messageNumber 54}, cColName), cColName, ?).
      ELSE DO:
         cValue = ENTRY(iColNum + 1, pcValueList,CHR(1)).
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
       hRowObject:BUFFER-COPY(hValRowObject).
    
    RUN clearLogicRows IN TARGET-PROCEDURE.
  END.

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-tableOut) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE tableOut Procedure 
PROCEDURE tableOut :
/*------------------------------------------------------------------------------
  Purpose:     Output requested fields of SDO in standard temp-table
  Parameters:  input field list
               input include object fields yes/no
               input maximum records to process
               output temp-table of data from sdo
               output number of records extracted
  
  Notes:       Temp table is defined in afttsdoout.i
               Fields passed in are checked with a can-do so support * for all
               or !field to exclude a field, e.g.
               "!RowNum,!RowIdent,!RowMod, *" would use all non SDO specific
               fields.
               For fields passed in - do NOT use a table prefix
               The temp table contains a record per record/field combination               
------------------------------------------------------------------------------*/

DEFINE INPUT  PARAMETER pcFieldList                AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER plIncludeObj               AS LOGICAL    NO-UNDO.
DEFINE INPUT  PARAMETER piMaxRecords               AS INTEGER    NO-UNDO.
DEFINE OUTPUT PARAMETER TABLE FOR ttTable.
DEFINE OUTPUT PARAMETER iExtractedRecs            AS INTEGER    NO-UNDO.

DEFINE VARIABLE iRowNum                           AS INTEGER    NO-UNDO.
DEFINE VARIABLE iColNum                           AS INTEGER    NO-UNDO.
DEFINE VARIABLE iPosn                             AS INTEGER    NO-UNDO.
DEFINE VARIABLE iField                            AS INTEGER    NO-UNDO.
DEFINE VARIABLE lAvailable                        AS LOGICAL    NO-UNDO.
DEFINE VARIABLE hQuery                            AS HANDLE     NO-UNDO.
DEFINE VARIABLE hBuffer                           AS HANDLE     NO-UNDO.
DEFINE VARIABLE hBufferField                      AS HANDLE     NO-UNDO.
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
DEFINE VARIABLE cWantedFieldHandles AS CHARACTER  NO-UNDO.

DEFINE VARIABLE hBrowser            AS HANDLE                   NO-UNDO.
DEFINE VARIABLE hBrowseColumn       AS HANDLE                   NO-UNDO.
DEFINE VARIABLE hDataTarget         AS HANDLE                   NO-UNDO.
DEFINE VARIABLE cDataTargets        AS CHARACTER                NO-UNDO.
DEFINE VARIABLE cColumnNames        AS CHARACTER                NO-UNDO.
DEFINE VARIABLE cColumnHandles      AS CHARACTER                NO-UNDO.
DEFINE VARIABLE hNavSource          AS HANDLE                   NO-UNDO.

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

ASSIGN cHiddenFields = "":U
       cNewFieldList = "":U.

/* Check if security on fields have been set */
IF INDEX(cSecuredFields,"Hidden":U) > 0 THEN
    DO iLoop = 1 TO NUM-ENTRIES(cSecuredFields):
        IF ENTRY(iLoop + 1,cSecuredFields) = "Hidden":U THEN
            ASSIGN cHiddenFields = IF cHiddenFields = "":U 
                                   THEN ENTRY(iLoop,cSecuredFields)
                                   ELSE cHiddenFields + ",":U + ENTRY(iLoop,cSecuredFields).
        iLoop = iLoop + 1. /* Skip One */
    END.

/* Now Remove the hidden fields from pcFieldList */
IF INDEX(pcFieldList,"*":U) > 0 THEN 
DO:
    /* Now add ! to every field to exclude them */
    DO iLoop = 1 TO NUM-ENTRIES(cHiddenFields):
        ENTRY(iLoop,cHiddenFields) = "!":U + ENTRY(iLoop,cHiddenFields).
    END.
    pcFieldList = RIGHT-TRIM(pcFieldList,",*":U) + cHiddenFields + ",*":U.
END.
ELSE DO:
    DO iLoop = 1 TO NUM-ENTRIES(pcFieldList):
        cFieldName = ENTRY(iLoop,pcFieldList).
        IF LOOKUP(cFieldName,cHiddenFields) > 0 THEN
            NEXT.
        cNewFieldList = IF cNewFieldList = "":U
                        THEN cFieldName
                        ELSE cNewFieldList + ",":U + cFieldName.
    END.
    ASSIGN pcFieldList = cNewFieldList.
END.

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
        AND {fnarg instanceOf 'Browser' hDataTarget} THEN
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
        ASSIGN hBrowseColumn  = hBrowser:GET-BROWSE-COLUMN(iLoop)
               cColumnNames   = cColumnNames + hBrowseColumn:NAME + ",":U
               cColumnHandles = cColumnHandles + STRING(hBrowseColumn) + ",":U
               .
    END.    /* loop through browser columns */
    ASSIGN cColumnNames   = RIGHT-TRIM(cColumnNames, ",":U)
           cColumnHandles = RIGHT-TRIM(cColumnHandles, ",":U)
           .
END.    /* valid browser. */

/* Ensure temp-table is empty to start */
EMPTY TEMP-TABLE ttTable.

ASSIGN iRowNum = 0
       iColNum = 0.

/* set rows to batch very high as we will read all the data */
&SCOPED-DEFINE xp-assign
{get rowsToBatch iRowsToBatch}
{set rowsToBatch piMaxRecords}
.
&UNDEFINE xp-assign

/* start at the beginning */
RUN fetchFirst IN TARGET-PROCEDURE.

/* check if any records */
lAvailable = DYNAMIC-FUNCTION('getQueryPosition':U IN TARGET-PROCEDURE) <> "NoRecordAvailable":U.
 
IF lAvailable THEN
DO:
  ASSIGN iNumRecords = 1
         hQuery      = DYNAMIC-FUNCTION('getDataHandle':U IN TARGET-PROCEDURE)
         hBuffer     = hQuery:GET-BUFFER-HANDLE(1).

  /* loop through sdo fields and create TT records for field labels, names, datatypes and widths */

  field-loop:
  DO iField = 1 TO hBuffer:NUM-FIELDS:

    hBufferField = hBuffer:BUFFER-FIELD(iField).
    
    IF plIncludeObj = NO AND INDEX(hBufferField:NAME, "_obj":U) > 0 THEN NEXT field-loop.

    IF CAN-DO(pcFieldList, hBufferField:NAME) THEN 
    DO:
      ASSIGN iColNum       = iColNum + 1
             iPosn         = LOOKUP(hBufferField:NAME, pcFieldList)
             hBrowseColumn = ?.

      IF VALID-HANDLE(hBrowser) THEN
          ASSIGN hBrowseColumn = WIDGET-HANDLE(ENTRY(LOOKUP(hBufferField:NAME, cColumnNames), cColumnHandles)) NO-ERROR.

      /* While we're getting the labels, names etc. build the list of field handles we need to extract.   *
       * This prevents us from looping through every single field in the buffer if the user only wanted 1 *
       * when we're extracting the data later on.                                                         */
      ASSIGN cWantedFieldHandles = cWantedFieldHandles + STRING(hBufferField) + CHR(3).

      /* Store labels in row 0 */
      CREATE ttTable.
      ASSIGN ttTable.iRow  = 0
             ttTable.iCol  = (IF iPosn = 0 THEN iColNum ELSE iPosn) /* use sdo col posittion if fields passed in as */
             ttTable.cCell = IF VALID-HANDLE(hBrowseColumn) 
                             THEN TRIM(hBrowseColumn:LABEL)
                             ELSE TRIM(hBufferField:COLUMN-LABEL).

      /* Store field names in row 1 */
      CREATE ttTable.
      ASSIGN ttTable.iRow  = 1
             ttTable.iCol  = (IF iPosn = 0 THEN iColNum ELSE iPosn) /* use sdo col posittion if fields passed in as */
             ttTable.cCell = TRIM(hBufferField:NAME).

      /* Store datatypes in row 2 */
      CREATE ttTable.
      ASSIGN ttTable.iRow = 2
             ttTable.iCol = (IF iPosn = 0 THEN iColNum ELSE iPosn) /* use sdo col posittion if fields passed in as */
             ttTable.cCell = TRIM(hBufferField:DATA-TYPE).

      /* Store widths in row 3 */
      CREATE ttTable.
      ASSIGN ttTable.iRow = 3
             ttTable.iCol = (IF iPosn = 0 THEN iColNum ELSE iPosn) /* use sdo col posittion if fields passed in as */
             ttTable.cCell = TRIM(STRING(hBufferField:WIDTH-CHARS)).
    END. /* This field is requested */
  END. /* Loop through the buffer fields */

  ASSIGN cWantedFieldHandles = RIGHT-TRIM(cWantedFieldHandles, CHR(3))
         iRowNum             = 9.  /* >9 = data */

  /* now loop through all available records */

  REPEAT WHILE lAvailable:
    
    IF NOT hBuffer:AVAILABLE THEN LEAVE.
    
    ASSIGN iRowNum = iRowNum + 1.

    field-loop2:
    DO iField = 1 TO NUM-ENTRIES(cWantedFieldHandles, CHR(3)):

      CREATE ttTable.
      ASSIGN hBufferField  = WIDGET-HANDLE(ENTRY(iField, cWantedFieldHandles, CHR(3)))
             iPosn         = LOOKUP(hBufferField:NAME, pcFieldList)
             ttTable.iRow  = iRowNum
             ttTable.iCol  = (IF iPosn = 0 THEN iField ELSE iPosn)
             ttTable.cCell = TRIM(hBufferField:STRING-VALUE).
    END. /* Loop through the buffer fields */

    ASSIGN cQueryPosition = DYNAMIC-FUNCTION('getQueryPosition':U IN TARGET-PROCEDURE)
           lAvailable     = NOT CAN-DO("LastRecord,OnlyRecord":U, cQueryPosition)
           iNumRecords    = iNumRecords + 1.

    IF lAvailable AND iNumRecords <= piMaxRecords THEN
        RUN fetchNext IN TARGET-PROCEDURE.
    ELSE
        ASSIGN lAvailable = NO.
  END. /* Loop through all available records */ 

END.  /* lAvailable = true */

/* to here */

/* reposition back to previously selected record */
IF cRowIdent <> ? AND cRowIdent <> "":U THEN
  DYNAMIC-FUNCTION('fetchRowIdent' IN TARGET-PROCEDURE, cRowIdent, '':U) NO-ERROR.

/* tidy up */
ASSIGN hQuery         = ?
       hBuffer        = ?
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

&IF DEFINED(EXCLUDE-updateData) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE updateData Procedure 
PROCEDURE updateData :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 DEFINE INPUT         PARAMETER pcUpdateColumnNames AS CHARACTER  NO-UNDO.
 DEFINE INPUT         PARAMETER pcOldValues   AS CHARACTER  NO-UNDO.
 DEFINE INPUT-OUTPUT  PARAMETER pcNewValues   AS CHARACTER  NO-UNDO.
 DEFINE OUTPUT        PARAMETER pcError       AS CHARACTER  NO-UNDO.

 DEFINE VARIABLE cKeyFields     AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cKeyValues     AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cNewValueList  AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE iLoop          AS INTEGER    NO-UNDO.
 DEFINE VARIABLE iField         AS INTEGER    NO-UNDO.
 DEFINE VARIABLE cKey           AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cValue         AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cNewValue      AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cOldValue      AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cDataDelimiter AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE lFoundOnClient AS LOGICAL    NO-UNDO.
 DEFINE VARIABLE hRowObject     AS HANDLE     NO-UNDO.
 DEFINE VARIABLE hCol           AS HANDLE     NO-UNDO.
 DEFINE VARIABLE lReopen        AS LOGICAL    NO-UNDO.
 DEFINE VARIABLE lCreated       AS LOGICAL    NO-UNDO.
 DEFINE VARIABLE lSave          AS LOGICAL    NO-UNDO.
 DEFINE VARIABLE lNoKeyFields   AS LOGICAL    NO-UNDO.
 DEFINE VARIABLE cColumn        AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cChangedColumns AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cChangedValues  AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cDataReadFormat AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE lFound          AS LOGICAL    NO-UNDO.

 &SCOPED-DEFINE xp-assign
 {get KeyFields cKeyFields}
 {get DataDelimiter cDataDelimiter}
 {get DataReadFormat cDataReadFormat}
  .
 &UNDEFINE xp-assign

 DO iLoop = 1 TO NUM-ENTRIES(cKeyFields):
   ASSIGN
     cKey     = ENTRY(iLoop,cKeyFields)
     iField   = LOOKUP(cKey,pcUpdateColumnNames).
   
   IF iField = 0 THEN
   DO:
     lNoKeyFields = TRUE.
     LEAVE.
   END.
   
   ASSIGN 
     cValue     = ENTRY(iField,pcOldValues,cDataDelimiter). 
     cKeyValues = cKeyValues 
                  + (IF iloop = 1 THEN '':U ELSE CHR(1))
                  +  cValue.
 END.

 IF lNoKeyFields THEN
 DO:
   iField = LOOKUP('RowIdent':U,pcUpdateColumnNames).
   IF iField = 0 THEN
   DO:
     pcError = "'" + REPLACE(cKeyFields,',',' ') + "' or 'RowIdent' need to be in column list passed to UpdateData to be able to find a record.".
     RETURN.
   END.
   cValue     = ENTRY(iField,pcOldValues,cDataDelimiter).   
 END.
 
 {get RowObject hRowObject}.

 /* Currently we need the RowObject with all fields from the db */
 IF lNoKeyFields THEN
 DO:
   DYNAMIC-FUNCTION('fetchRowident':U IN TARGET-PROCEDURE,cValue,'':U).
   lFound = cValue = hRowObject:BUFFER-FIELD('Rowident':U):BUFFER-VALUE NO-ERROR.
 END.
 ELSE
   lFound = DYNAMIC-FUNCTION('findRowWhere':U IN TARGET-PROCEDURE,
                             cKeyFields,
                             cKeyValues,
                             '=':U).
 IF lFound THEN
 DO:
   DO iLoop = 1 TO NUM-ENTRIES(pcUpdateColumnNames):
     ASSIGN
       hCol    = ?
       cColumn = ENTRY(iLoop,pcUpdateColumnNames) 
       hCol    = hRowObject:BUFFER-FIELD(cColumn) NO-ERROR.
     IF VALID-HANDLE(hCol) THEN
     DO:
       ASSIGN
         cOldValue = ENTRY(iLoop,pcOldValues,cDataDelimiter)
         cNewValue = ENTRY(iLoop,pcNewValues,cDataDelimiter).     
       
       /* We do not assign the before image value to the RowObject if 
          the b-i value is similar to the formatted value, but the buffer-value 
          is not. This avoids error from the optimistic lock check in cases where 
          formatting has sent a different value out than really stored */            
       IF hCol:STRING-VALUE = hCol:BUFFER-VALUE OR cOldValue <> hCol:STRING-VALUE THEN
         hCol:BUFFER-VALUE = cOldValue. 
       
       IF COMPARE(cOldValue,'NE':U,cNewValue,'case-sensitive':U) THEN          
         cNewValueList  = cNewValueList 
                       + (IF cNewValueList = '':U THEN '':U ELSE CHR(1))
                       + cColumn
                       + CHR(1)
                       + (IF cNewValue <> ? THEN cNewValue ELSE '?':U).
     END.
   END.
   
   lSave = DYNAMIC-FUNCTION('submitRow':U IN TARGET-PROCEDURE,
                             STRING(hRowObject:ROWID),
                             cNewValueList).
 END.
 ELSE 
   DYNAMIC-FUNCTION('addNotFoundMessage':U IN TARGET-PROCEDURE,
                    IF lNoKeyFields THEN 'ROWIDENT':U ELSE cKeyFields,
                    IF lNoKeyFields THEN cValue ELSE cKeyValues,
                    '=':U).

 IF {fn anyMessage} THEN  
   pcError = {fn fetchMessages}.

 IF lFound AND hROwObject:AVAIL THEN
   pcNewValues = DYNAMIC-FUNCTION('colStringValues':U IN TARGET-PROCEDURE,
                                   pcUpdateColumnNames,
                                   cDataReadFormat,
                                   cDataDelimiter). 

 /* Future .. not yet used.. 
    If not present on the client remove any trace of the update*/
 IF lCreated THEN 
   hRowObject:BUFFER-DELETE(). 

 /* If unsuccessful save the before-image record is still here, so get rid of it */ 
 IF NOT lSave THEN  
   DYNAMIC-FUNCTION('resetRow':U IN TARGET-PROCEDURE,STRING(hRowObject:ROWID)).

 RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-updateManualForeignFields) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE updateManualForeignFields Procedure 
PROCEDURE updateManualForeignFields :
/*------------------------------------------------------------------------------
  Purpose:   Get foreign fields and values and setManualAssignQuerySelection 
             so that filter does not lose info  
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* This has been commented out for the following reasons:
    1. It's no longer necessary as 'setQueryWhere' now re-applies foreign field values
    2. It may override previously saved values in 'ManualAssignQuerySelection'
*/

/*   DEFINE VARIABLE cForeignFields      AS CHARACTER    NO-UNDO.                                   */
/*   DEFINE VARIABLE cLocalFields        AS CHARACTER    NO-UNDO.                                   */
/*   DEFINE VARIABLE cSourceFields       AS CHARACTER    NO-UNDO.                                   */
/*   DEFINE VARIABLE iField              AS INTEGER      NO-UNDO.                                   */
/*   DEFINE VARIABLE cValues             AS CHARACTER    NO-UNDO.                                   */
/*   DEFINE VARIABLE cField              AS CHARACTER    NO-UNDO.                                   */
/*                                                                                                  */
/*     DEBUGGER:INITIATE().                                                                         */
/*     DEBUGGER:SET-BREAK().                                                                        */
/*   {get ForeignFields cForeignFields}.                                                            */
/*   IF cForeignFields <> "" THEN                                                                   */
/*   DO:                                                                                            */
/*      DO iField = 1 TO NUM-ENTRIES(cForeignFields) BY 2:                                          */
/*             cLocalFields = cLocalFields +  /* 1st of each pair is local db query fld  */         */
/*                 (IF cLocalFields NE "":U THEN ",":U ELSE "":U) + ENTRY(iField, cForeignFields).  */
/*      END.                                                                                        */
/*                                                                                                  */
/*                                                                                                  */
/*      ASSIGN                                                                                      */
/*        cField = IF NUM-ENTRIES(cLocalFields, ".") > 1 THEN                                       */
/*             ENTRY(2, cLocalFields, ".") ELSE cLocalFields.                                       */
/*                                                                                                  */
/*        cValues = {fnarg colValues cField} NO-ERROR.                                              */
/*         /* Throw away the RowIdent entry returned by colValues*/                                 */
/*      IF cValues NE ? THEN                                                                        */
/*          cValues = SUBSTR(cValues, INDEX(cValues, CHR(1)) + 1).                                  */
/*                                                                                                  */
/*      DYNAMIC-FUNCTION("setManualAssignQuerySelection":U IN TARGET-PROCEDURE,                     */
/*                       cLocalFields + CHR(3) + cValues + CHR(3) + '':U).                          */
/*   END.                                                                                           */

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
           The main purpose of this function is to eliminate duplication, 
           errors and minimize messaging (setQueryPosition PUBLISHes)
           in fetchFirst, fetchPrev, fetchNext and fetchLast.   
    Notes: data.p should update LastRowNum, FirstRowNum properties and call this. 
         - The properties LastRowNum and FirstRowNum stores the 
           RowObject.RowNum of the first and last record in the database query. 
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hRowObject   AS HANDLE  NO-UNDO.
  DEFINE VARIABLE iLastRowNum  AS INT     NO-UNDO.
  DEFINE VARIABLE iFirstRowNum AS INT     NO-UNDO.  
  DEFINE VARIABLE hRowNum      AS HANDLE  NO-UNDO.
  DEFINE VARIABLE lLast        AS LOGICAL NO-UNDO.
  DEFINE VARIABLE cQueryPos    AS CHAR    NO-UNDO.
  DEFINE VARIABLE cFFields     AS CHAR    NO-UNDO.
  DEFINE VARIABLE cFValues     AS CHAR    NO-UNDO.
  DEFINE VARIABLE lNew         AS LOGICAL NO-UNDO.
  DEFINE VARIABLE hDataSource  AS HANDLE  NO-UNDO.
  DEFINE VARIABLE hDataTarget  AS HANDLE  NO-UNDO.
  DEFINE VARIABLE lQuery       AS LOGICAL NO-UNDO.

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
     /* Check for a DataSource.  If there is a data source then we test
        foreign key values, we could also have checked queryPosition..
        but this is what Add uses, and this QueryPos is used to disable Add 
        in toolbar .. */
     {get DataSource hDataSource}.

     /* Check to see if we're in an sbo and, if so, use that to get the 
        ForeignFields */
     IF NOT VALID-HANDLE(hDataSource) THEN 
     DO:
       {get ContainerSource hDataTarget}.
       /* Determine if the appropriate data-target to use is the container
          or the target-procedure (i.e. the sdo) */
       IF VALID-HANDLE(hDataTarget) THEN 
       DO:
         {get QueryObject lQuery hDataTarget}.
         IF lQuery THEN
           {get DataSource hDataSource hDataTarget}.
         ELSE 
           hDataTarget = TARGET-PROCEDURE.
       END.
     END. /* not valid DataSource  (check if container is SBO DataTarget)  */
     ELSE
       hDataTarget = TARGET-PROCEDURE.
     
     IF VALID-HANDLE(hDataSource) THEN 
     DO:
       /* Check and see if any foreign fields are used */
       {get ForeignFields cFFields hDataTarget}.
       IF cFFields <> ? THEN 
       DO:
         /* get the values for the foreign fields */
         {get ForeignValues cFValues hDataTarget}.
         IF cFvalues = ? THEN
            /* No Foreign values */
           cQueryPos = 'NoRecordAvailableExt':U.
       END. /* cFFields <> ? */
       IF cQueryPos = '':U THEN
       DO:
         /* Check if dataSource has an unsaved new record 
            Use no-error in case the datasource is a container with 
            ExternalForegnKey  */
         {get NewMode lNew hDataSource} NO-ERROR.
         IF lNew THEN
           cQueryPos = 'NoRecordAvailableExt':U.
       END. /* cQueryPos = '' */
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
  Purpose:     To passes along update-related messages (to its 
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
      IF cRowid = ? THEN cRowid = "":U.  /* NOTE: On 2nd txn add. Is this OK? */
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

&IF DEFINED(EXCLUDE-applyContextFromServer) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION applyContextFromServer Procedure 
FUNCTION applyContextFromServer RETURNS LOGICAL
  ( pcContext AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose: Apply context returned from server after a server call
    Notes: Mostly to be consistent with sbo and also to have specific 
           entry for override ( setPropertyList can be used anywhere)
       Typical usage:    
           cContext = obtainContextForServer()
           run <remotecall> (input-output cContext). 
           applyContextFromServer(ccontext)               
------------------------------------------------------------------------------*/  
  DEFINE VARIABLE cServerOperatingMode AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lAsHasStarted        AS LOGICAL    NO-UNDO.

  {get AsHasStarted lAsHasStarted}.
  IF NOT lAsHasStarted THEN
    {get ServerOperatingMode cServerOperatingMode}.
 
  RUN setPropertyList IN TARGET-PROCEDURE (pcContext).
  
  IF NOT lAsHasStarted THEN
  DO:
    /* We assume that the Appserver now has started */
    {set AsHasStarted TRUE}.
    /* Override the actual state if the instance property is force stateful */
    IF cServerOperatingMode = "STATE-RESET":U THEN
      {set ServerOperatingMode cServerOperatingMode}. 
  END.

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

&IF DEFINED(EXCLUDE-bufferCompareFields) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION bufferCompareFields Procedure 
FUNCTION bufferCompareFields RETURNS CHARACTER
  ( INPUT phBuffer1 AS HANDLE,
    INPUT phBuffer2 AS HANDLE,
    INPUT pcExclude AS CHAR,
    INPUT pcOption  AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
DEFINE VARIABLE iVar           AS INTEGER    NO-UNDO.
DEFINE VARIABLE cChangedFlds AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cName          AS CHARACTER  NO-UNDO.

     DO iVar = 1 TO phBuffer1:NUM-FIELDS: 
       cName = phBuffer1:BUFFER-FIELD(iVar):NAME.
       IF LOOKUP(cName, pcExclude) > 0  
         THEN NEXT.
       IF phBuffer1:BUFFER-FIELD(iVar):DATA-TYPE = "CHARACTER":U THEN 
       DO:
         IF NOT LOOKUP(pcOption, "RAW,CASE-SENSITIVE,CASE-INSENSITIVE":U) > 0 THEN
           pcOption = "CASE-INSENSITIVE":U.
         IF COMPARE(phBuffer1:BUFFER-FIELD(iVar):BUFFER-VALUE, '<>', 
                    phBuffer2:BUFFER-FIELD(cName):BUFFER-VALUE, pcOption) THEN
           cChangedFlds = cChangedFlds + (IF cChangedFlds > "" THEN "," ELSE "") + cName.
       END.
       ELSE IF phBuffer1:BUFFER-FIELD(iVar):BUFFER-VALUE <> phBuffer2:BUFFER-FIELD(cName):BUFFER-VALUE  
         THEN cChangedFlds = cChangedFlds + (IF cChangedFlds > "" THEN "," ELSE "") + cName.
     END.

     RETURN cChangedFlds.

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
 RUN doUndoUpdate IN TARGET-PROCEDURE.
 {set DataModified FALSE}.

 /* Tell the data-targets that we're back in business, if we're NOT in a SBO */
 IF NOT {fn getQueryContainer} AND lNew THEN 
 DO:
   PUBLISH "dataAvailable":U FROM TARGET-PROCEDURE ('DIFFERENT':U).
   {set NewBatchInfo '':U}.
 END.
   
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
    {get ServerFileName cServerFileName}.
    {get RowObjUpdTable hRowObjUpd}.
    
    RUN adm2/commit.p ON hAppService
        (cServerFileName,
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
    Notes: It is rather likely that the DataContainer role and client container
           role will be in separate objects in the future.      
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
  DEFINE VARIABLE lNextNeeded    AS LOGICAL   NO-UNDO INIT no.
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
      /*  future..need to change data rowObjectstate to dynamically use 
                  the existance of rowObjUpd.rowmod <> '' and sbo 
                  rowObjectState to only look in SDOs to make this work.                     
      hRowObjUpd:BUFFER-DELETE().
      */
      lNewDeleted = TRUE.
    
    hUpdRowMod:BUFFER-VALUE = "D".
  END.   /* END DO IF ENTRY(1) */
  ELSE DO:
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
        /*  future..need to change data rowObjectstate to dynamically use 
                   the existance of rowObjUpd.rowmod <> '' and sbo 
                   rowObjectState to only look in SDOs to make this work.                     
           hRowObjUpd:BUFFER-DELETE(). */
        lNewDeleted = TRUE.
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
          PUBLISH "updateState":U FROM TARGET-PROCEDURE('delete':U).
          {set RowObjectState 'RowUpdated':U}.
          lNextNeeded = FALSE. /* we don't need another batch (IZ 10746) */
        END.
      END.
    
      /* NextNeeded = false if the browse 'autopositioned', also if we deleted 
         the only or last record don't try to fetch another batch. */
      IF lNextNeeded AND {fnarg rowAvailable 'NEXT':U} AND NOT lNewDeleted THEN
        RUN fetchNext IN TARGET-PROCEDURE.
      ELSE 
      DO:    
        RUN updateQueryPosition IN TARGET-PROCEDURE.
        PUBLISH 'dataAvailable':U FROM TARGET-PROCEDURE ('different':U).   
        {set NewBatchInfo '':U}.
      END.
    END. /* not lUpdFromSource */ 
  END.  /* END DO IF NOT AutoCommit OR Success from Commit */
  /* In the event of a failed delete, doreturnUpd has deleted the
     Update temp-table row. */
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
   hRowObject:EMPTY-TEMP-TABLE.

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

  {get AsDivision cAsDivision}.
  {get QueryOpen lQueryOpen}.

 /* We do not support calling this on server before the query is opened 
   (This is to protect the client against bad batch properties, since 
    this call opens the query and obtainContextforCclient will return
    data properties) */ 
  IF cAsDivision = 'SERVER':U AND NOT lQueryOpen THEN
    RETURN ?.

  lOnClient = {fnarg findRowObjectUseRowident pcRowident}.
  
  IF NOT lOnClient THEN
    lFromServer = {fnarg fetchRowWhere pcRowident}.
  
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
            from code that first checks if the record is on the client.            Called from fetchRowident and findRowWhere. 
          - Used by fetchRowident and findRowWhere  
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
  
  /* If RebuildOnReposition, flush out the current set of RowObject records 
     and reset the associated flags. */
  IF lRebuild THEN 
    {fnarg emptyRowObject '':U}. 
  
  /* Set browser refreshable = false */
  IF lBrowsed THEN
    PUBLISH 'fetchDataSet':U FROM TARGET-PROCEDURE ('BatchStart':U).
  
  {get RebuildOnRepos lRebuild}.
  /* We use special signals appended to the passed query to tell whether this 
     is an appending search or a rebuild with fillbatch.  */
  IF NOT lRebuild THEN
    cSpecial = "+":U.
  ELSE IF lBrowsed THEN
  DO: 
    {get fillBatchOnRepos lFillBatch}.
    /* append '-' to indicate go back from found position to fill batch, 
       (almost makes sense doesn't it?) */ 
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

&IF DEFINED(EXCLUDE-findRowFromObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION findRowFromObject Procedure 
FUNCTION findRowFromObject RETURNS LOGICAL
  ( pcColumns AS CHAR,
    pcValColumns AS CHAR,
    phObject AS HANDLE) :
/*------------------------------------------------------------------------------
  Purpose: Find a row using values from another object 
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cValues AS CHARACTER  NO-UNDO.

  cValues = {fnarg colValues pcValColumns phObject}.

  ENTRY(1,cValues,CHR(1)) = '':U.  
  cValues = LEFT-TRIM(cValues,CHR(1)).

  IF cValues <> ? THEN
    RETURN DYNAMIC-FUNCTION ('findRowWhere':U IN TARGET-PROCEDURE,
                              pcColumns,
                              cValues,
                              '':U). 
  RETURN FALSE. 

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-findRowInCurrentBatch) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION findRowInCurrentBatch Procedure 
FUNCTION findRowInCurrentBatch RETURNS LOGICAL
  (pcColumns     AS CHARACTER,   
   pcValues      AS CHARACTER,    
   pcOperators   AS CHARACTER):
/*------------------------------------------------------------------------------   
Purpose: Find and reposition to a row within the current batch where the 
         current batch is on a separate client and NOT in this SDO.
         The major difference between this function and findRowWhere and 
         fetchRowIdent is that the batch information (context) is not changed.            
Parameters: 
       pcColumns   - Column names (Comma separated)                    
                     Fieldname of a table in the query in the form of 
                     TBL.FLDNM or DB.TBL.FLDNM (only if qualified with db),
                     (RowObject.FLDNM should be used for SDO's)  
                     If the fieldname isn't qualified it checks the tables in 
                     the TABLES property and assumes the first with a match.
       pcValues    - corresponding Values (CHR(1) separated)
       pcOperators - Operator - one for all columns
                                - blank - defaults to (EQ)  
                                - Use slash to define alternative string operator
                                  EQ/BEGINS etc..
                              - comma separated for each column/value                              
  Notes: This API assumes that the requested record is within the current 
         batch and that the batc properties is is set as part of context before 
         this is called.
      -  The API is dedicated for open client calls, for instance when a 
         reposition requires new child data, but the current batch of data not 
         is going to be changed on the client. 
      -  The batch properties will NOT be in synch with the actual data after 
         this request.             
      -  Supports passing 'RowObject.Rowident' as the column name for 
         repositioning to a specific list of ROWIDs (call fetchRowident).  
         (the operator is assumed to be EQ in that case)  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cFirstResultRow AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cLastResutlRow  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iFirstRowNum    AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iLastRowNum     AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cRows           AS CHARACTER  NO-UNDO INIT ?.
  DEFINE VARIABLE lFound          AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lQueryOpen      AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lRebuild        AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE iRowsToBatch    AS INTEGER    NO-UNDO.
  {get QueryOpen lQueryOpen}.
  IF lQueryOpen THEN
  DO:
    MESSAGE 'The findRowInCurrentBatch() function can not be called with data in the object'
      VIEW-AS ALERT-BOX WARNING.
    RETURN ?.       
  END.

  &SCOPED-DEFINE xp-assign
  {get FirstResultrow cFirstResultRow}
  {get LastResultrow cLastResutlRow}
  {get FirstRowNum iFirstRowNum}
  {get LastRowNum iLastRowNum}
    
  /* Enforce creation of just one RowObject record, but current values 
     must be reset below */
  {get RowsToBatch iRowsToBatch}
  {get RebuildOnRepos lRebuild}
  {set RowsToBatch 1}
  {set RebuildOnRepos TRUE}
  .
  &UNDEFINE xp-assign
  /* Special case to find the row using the fetch row ident */
  IF pcColumns = "RowObject.RowIdent":U THEN
  DO:
    cRows = DYNAMIC-FUNCTION('fetchRowident':U IN TARGET-PROCEDURE,
                              pcValues,'':U).
    lFound = cRows <> ?.
  END.

  ELSE 
    lFound =  DYNAMIC-FUNCTION('findRowWhere':U IN TARGET-PROCEDURE,
                               pcColumns,
                               pcValues,
                               pcOperators).

  /* Set the batch properties back as they were */
  &SCOPED-DEFINE xp-assign
  {set FirstResultrow cFirstResultRow}
  {set LastResultrow cLastResutlRow}
  {set FirstRowNum iFirstRowNum}
  {set LastRowNum iLastRowNum}
  {set RowsToBatch iRowsToBatch}
  {set RebuildOnRepos lRebuild}
  .
  &UNDEFINE xp-assign
  
  RETURN lFound.

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
     Purpose: check if a record is in the current Rowobject table
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
                    - LAST        
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
 DEFINE VARIABLE lRange         AS LOGICAL    NO-UNDO.
 DEFINE VARIABLE iFirstRowNum   AS INTEGER    NO-UNDO.
 DEFINE VARIABLE iLastRowNum    AS INTEGER    NO-UNDO.
 DEFINE VARIABLE cKeyFields     AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cField         AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE iField         AS INTEGER    NO-UNDO.
 DEFINE VARIABLE cUniqueIndexes AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE lIndexUsed     AS LOGICAL    NO-UNDO.
 DEFINE VARIABLE cIndexInfo     AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cTableIndexes  AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cIndex         AS CHARACTER  NO-UNDO.
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
     ASSIGN
       cWhere  = cWhere 
               + (If cWhere = "":U 
                  THEN "":U 
                  ELSE " ":U + "AND":U + " ":U)
               + cColumn 
               + " ":U
               + cOperator
               + " ":U
               + cValue
       lRange  =  IF NOT lRange 
                  THEN NOT(CAN-DO('=,EQ':U,cOperator))
                  ELSE lRange.
   /* If range is used and we don't have the first record we 
      don't know and have to go to the server  
      We could actually detect a FOUND condition if the OTHER fields used 
      equality on a unique index... but for now this will have to do   */  
   IF lRange AND iFirstRowNum = ? THEN
      RETURN ?.

   /* If operator EQ contains, send the request straight to the server because
      RowObject does not inherit indices */
   IF cOperator EQ 'Contains' THEN 
     RETURN ?.
 END.
 
 cQueryString = {fn getDataQueryString}.

 cQueryString = DYNAMIC-FUNCTION('insertExpression' IN TARGET-PROCEDURE,
                                 cQueryString,
                                 cWhere,
                                'AND':U).
 {get RowObject hRowObject}.

 rCurrent = hRowObject:ROWID.
 /* Create local buffer */
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
   ELSE IF pcMode = 'LAST':U THEN
     hRowQuery:GET-LAST().
 END.

 lOK = hRowObjectBuf:AVAILABLE.

 /* If this is a 1-to-1 child there's no need for further determination of */
 /* having found the correct record. */
 IF {fn getUpdateFromSource} THEN
   lDefinite = TRUE.

 /* Note that we have already returned ? if range match and firstrownum is ? */
 /* We have all records on the client so we know the answer */
 ELSE IF iFirstRowNum <> ? AND iLastRowNum <> ? THEN 
   lDefinite = TRUE.

 /* If we found something and has the first record then this is the one */
 ELSE IF lOk AND iFirstRowNum <> ? THEN
   lDefinite = TRUE.

 /* If we have found something and there's no range, we have a definite answer
    if an unique index is used */    
 ELSE IF lok AND NOT lRange THEN
 DO:
   {get KeyFields cKeyFields}.
   IF cKeyFields <> '':U THEN
   DO:
     lIndexUsed = TRUE.
     KeyLoop:
     DO iField = 1 TO NUM-ENTRIES(cKeyFields):
       cField = ENTRY(iField,cKeyFields).
       IF NOT CAN-DO(pcColumns,cField) THEN
       DO:
         lIndexUsed = FALSE.
         LEAVE Keyloop.
       END.
     END.
     IF lIndexUsed THEN
       lDefinite = TRUE.
   END.
   IF NOT lDefinite THEN
   DO:
     {get IndexInformation cIndexInfo}.
     cUniqueIndexes = DYNAMIC-FUNCTION('indexInformation':U IN TARGET-PROCEDURE,
                                       'unique':U,
                                        YES,
                                        cIndexInfo).
     cTableIndexes = ENTRY(1,cIndexInfo,CHR(2)).
     IndexLoop:
     DO iIndex = 1 TO NUM-ENTRIES(cTableIndexes,CHR(1)):
       cIndex = ENTRY(iIndex,cTableindexes,CHR(1)).
       lIndexUsed = TRUE.
       IndexKeyLoop:
       DO iField = 1 TO NUM-ENTRIES(cIndex):
         cField = ENTRY(iField,cIndex).
          IF NOT CAN-DO(pcColumns,cField) THEN
          DO:
            lIndexUsed = FALSE.
            LEAVE IndexKeyloop.
          END.
       END.
       IF lIndexUsed THEN 
       DO:
         lDefinite = TRUE.
         LEAVE IndexLoop. 
       END.
     END. /* indexLoop */
   END.
 END.

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

 /* If we get here we do not know enough whether we have a record or not */
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

  {get AsDivision cAsDivision}.
  {get QueryOpen lQueryOpen}.

  /* We do not support calling this on server before the query is opened 
     (This is to protect the client against bad batch properties, since 
      this call opens the query and obtainContextforCclient will return
      data properties) */ 

  IF cAsDivision = 'SERVER':U AND NOT lQueryOpen THEN
    RETURN ?.

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
       RETURN lOnCLient.
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
  cRowUserProp = {fnarg columnValue 'RowUserProp':U} NO-ERROR.
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
  cRowUserProp = {fnarg columnValue 'RowUserProp':U} NO-ERROR.
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
           RowObjectState = 'ROwUpdated'.
Note date: 2002/02/01            
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

 &SCOPED-DEFINE xp-assign 
 {get ForeignFields cForeignFields}
 {get ForeignValues cCurrentValues}  
 {get DataSource    hDataSource}
 .
 &UNDEFINE xp-assign
  
 IF NOT VALID-HANDLE(hDataSource) THEN
   RETURN FALSE.

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
 DEFINE VARIABLE iColumn      AS INTEGER    NO-UNDO.
 DEFINE VARIABLE cColumn      AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cOperator    AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cStringOp    AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cDataType    AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cQuote       AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cValue       AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cWhere       AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cQueryString AS CHARACTER  NO-UNDO.

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
     cValue     = IF CAN-DO("INTEGER,DECIMAL":U,cDataType) AND cValue = "":U 
                  THEN "0":U 
                  ELSE IF cDataType = "DATE":U and cValue = "":U
                  THEN "?":U 
                  ELSE IF cValue = ? /*This could happen if only one value*/
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
FUNCTION newRowObject RETURNS LOGICAL PRIVATE
  (pcMode AS CHARACTER) :
/*------------------------------------------------------------------------------
   Purpose: Assign some general RowObject fields and update LastRowNum,
            FirstRowNum when a new RowObject has been created . 
Parameters: pcMode - char  - A(dd) or C(opy)     
     Notes: The main purpose for this procedure is to ensure that copy and add
            behaves similar. 
            The buffer must be created first.  
            Currently defined as PRIVATE. 
            Used in procedure copyColumns and function addRow().  
------------------------------------------------------------------------------*/
 DEFINE VARIABLE cQueryPos     AS CHAR       NO-UNDO.
 DEFINE VARIABLE hColumn       AS HANDLE     NO-UNDO.
 DEFINE VARIABLE hRowObject    AS HANDLE     NO-UNDO.
 DEFINE VARIABLE iLastRow      AS INT        NO-UNDO.
 DEFINE VARIABLE cBlank        AS CHAR       NO-UNDO.
 DEFINE VARIABLE hLogicObject  AS HANDLE     NO-UNDO.
 DEFINE VARIABLE hNewRowObject AS HANDLE     NO-UNDO.
 DEFINE VARIABLE rRowid        AS ROWID      NO-UNDO.
 DEFINE VARIABLE lBrowsed      AS LOGICAL    NO-UNDO.
 DEFINE VARIABLE cTargets      AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cDTList       AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cUSList       AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE hDTarget      AS HANDLE     NO-UNDO.
 DEFINE VARIABLE hUSource      AS HANDLE     NO-UNDO.
 DEFINE VARIABLE cType         AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cNew          AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE iVar          AS INTEGER    NO-UNDO.

 &SCOPED-DEFINE xp-assign
 {get RowObject hRowObject}
 {get DataQueryBrowsed lBrowsed}
 {get DataLogicObject hLogicObject}
 . 
 &UNDEFINE xp-assign
 
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
 
 /* Fix for issue 5931. ************************************************/
 /* When a browser is a DataTarget we need to make sure that it gets an */
 /* 'updateState' message before the SDO publishes 'dataAvailable'. */
 /* Otherwise, the browser may respond to 'dataAvailable' for the new */
 /* record when it gets re-enabled causing a RecordState of */
 /* 'NoRecordAvailable' (which would cause state problems with child objects). */

 /* The following solution is a temporary, targeted approach to the source of */
 /* the problem (browse widget) so that system stability is maintained. */
 /* A more thorough implementation should be considered */
 /* where 'UpdateState' is generally published before 'dataAvailable' so */
 /* that visual objects can correctly respond (or refuse to respond) to */
 /* dataAvailable from their DataSource */
 
 /* If we don't have a browse attached to the query then don't do anything */

 IF lBrowsed THEN 
 DO:

   /* determine the current update source */
   {get UpdateSource cUSList}.
   DO iVar = 1 TO NUM-ENTRIES(cUSList):
     hUSource = WIDGET-HANDLE(ENTRY(iVar, cUSList)).
     IF VALID-HANDLE(hUSource) THEN DO:
       {get NewRecord cNew hUSource}.
       IF LOOKUP(cNew, "ADD,COPY":U) > 0 THEN
         LEAVE.
       ELSE hUSource = ?.
     END.
     ELSE hUSource = ?.
   END.

   /* loop thru the DataTargets...*/
   {get DataTarget cDTList}.
   DO iVar = 1 TO NUM-ENTRIES(cDTList):
     hDTarget = widget-handle(ENTRY(iVar, cDTList)).
     IF VALID-HANDLE(hDTarget) THEN 
     DO:
       /* ...looking for any browser that is NOT the current UpdateSource */
       {get ObjectType cType hDTarget}.
       IF cType = "SmartDataBrowser":U AND hDTarget <> hUSource THEN    
         RUN 'updateState':U IN hDTarget('Update':U).
     END.
   END.
 END.
 /* End fix for issue 5931 **************************************/

 /* Notify dataSources. They will check NewRow and close the query */  
 PUBLISH "dataAvailable":U FROM TARGET-PROCEDURE ('DIFFERENT':U).    
 {set NewBatchInfo '':U}.

 /* Under certain circumstances (when focus between windows has been switched 
    by JUST clicking the browses and these windows are recently initialized) 
    the publish above causes a reposition of the query. 
    The browse is the suspect as this is implicit behavior when a browse is 
    refreshed/viewed. This event cannot be trapped and overridden in the browse.
    (It could have been prevented by disabling the browse before this for
    example by an earlier updateState though) */
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
 DEFINE VARIABLE cIndexInfo         AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cKeyFields         AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE lData              AS LOGICAL    NO-UNDO.
 DEFINE VARIABLE hRowObjUpdTable    AS HANDLE     NO-UNDO.
 DEFINE VARIABLE cKeyTableId        AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cEntityFields      AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cPositionForClient AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE lAuditEnabled      AS LOGICAL    NO-UNDO.
 DEFINE VARIABLE cAuditEnabled      AS CHARACTER  NO-UNDO.
 
 {get ServerFirstCall lFirstCall}.
 
 IF lFirstCall THEN
 DO:
   /* If stateless then send back QueryWhere as QueryContext, which will be 
      used to reset the context again and also by getQueryWhere to return 
      data without connecting. */   
   {get ServerOperatingMode cOperatingMode}.

   IF cOperatingMode = 'STATELESS':U THEN 
     {get QueryWhere cQueryWhere}.
   &SCOPED-DEFINE xp-assign
   {get IndexInformation cIndexInfo}
   {get OpenQuery cOpenQuery}
   {get DBNames cDBNames}
   {get KeyFields  cKeyFields}
   {get KeyTableId cKeyTableId}  /* After getKeyfields as it may be set there */
   {get EntityFields cEntityFields}
   {get AuditEnabled lAuditEnabled}
   /* Is this before or after a data request */
   {get QueryOpen lData}
    . 
   &UNDEFINE xp-assign
   IF NOT lData THEN
   DO:
     /* If not a query, existance of rowObjUpd indicates a commit, which is a data request*/ 
     {get RowObjUpdTable hRowObjUpdTable}.
     lData = hRowObjUpdTable:HAS-RECORDS.
   END.

   /* Turn off this as we may do another context request before we destroy, 
      which of course always is the case if we are state aware. */
   {set ServerFirstCall FALSE}.

   ASSIGN
     cOperatingMode = (IF cOperatingMode = ? THEN '?':U ELSE cOperatingMode)
     cIndexInfo     = (IF cIndexInfo     = ? THEN '?':U ELSE cIndexInfo)
     cOpenQuery     = (IF cOpenQuery     = ? THEN '?':U ELSE cOpenQuery)
     cDBNames       = (IF cDBNames       = ? THEN '?':U ELSE cDBNames)
     cKeyFields     = (IF cKeyFields     = ? THEN '?':U ELSE cKeyFields)
     cKeyTableId    = (IF cKeyTableId    = ? THEN '?':U ELSE cKeyTableId)
     cEntityFields  = (IF cEntityFields  = ? THEN '?':U ELSE cEntityFields)
     cAuditEnabled  = (IF lAuditEnabled  = ? THEN '?':U ELSE STRING(lAuditEnabled))
     cContext       =  "IndexInformation":U + CHR(4) + cIndexInfo
                    + CHR(3) 
                    + "ServerOperatingMode":U + CHR(4) + cOperatingMode
                    + CHR(3) 
                    /* Return as BaseQuery .. setOpenQuery does to much 
                       now when this may be returned as part of a data request */ 
                    + "BaseQuery":U + CHR(4) + cOpenQuery
                    + CHR(3) 
                    + "DBNames":U + CHR(4) + cDBNames
                    + CHR(3) 
                    + "KeyFields":U + CHR(4) + cKeyFields
                    + CHR(3) 
                    + "KeyTableId":U + CHR(4) + cKeyTableId
                    + CHR(3) 
                    + "EntityFields":U + CHR(4) + cEntityFields
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
  DEFINE VARIABLE cLogicalName         AS CHARACTER  NO-UNDO.
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

  {get ASHasStarted lASHasStarted}. 
  IF NOT lASHasStarted THEN
  DO:
    /* We don't run Initialize on the server object from the client anymore 
      (9.1B05) This has been moved to synchronizeProperties instead to reduce 
      the number of AppServer calls  
      RUN initializeObject IN hAppServer. */ 
         
     cPropertiesForServer = 
         /* AsHasStarted is sent to the server to tell if this is the first call 
            will return the properties we need to retrieve at start up.
            We may come up with something better later...  */
           "ServerFirstCall":U  + CHR(4) + "YES":U.
  END. /* First call, if not lASHasStarted */
  ELSE     
    RUN genContextList IN TARGET-PROCEDURE (OUTPUT cPropertiesForServer).
  
  &SCOPED-DEFINE xp-assign
  {get RebuildOnRepos lRebuild} 
  {get ServerSubmitValidation lSubmitVal}
  {get CheckCurrentChanged lCheck}
  {get UseRepository lUseRepository}
  {get DataFieldDefs cDefs}
  {get LogicalObjectName cLogicalName}
  {get DestroyStateless lDestroyStateless}
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
                          + "BaseQuery":U + CHR(4) + cBaseQuery 
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

  cPropertiesForServer = (IF cPropertiesForServer  <> ? 
                          AND cPropertiesForServer <> "":U 
                          THEN cPropertiesForServer + CHR(3)
                          ELSE "":U)
                        + "LogicalObjectName":U + CHR(4)
                        + (IF cLogicalName = ? THEN "?":U ELSE cLogicalName) 
                        + CHR(3)
                        + "DestroyStateless":U + CHR(4) 
                        + (IF lDestroyStateless THEN "YES":U ELSE "NO":U) 
                        + CHR(3)
                        + "QueryWhere":U + CHR(4) + cQueryWhere 
                        + CHR(3)  
                        + "RebuildOnRepos":U + CHR(4) + STRING(lRebuild)
                        + CHR(3)      
                        + "ServerSubmitValidation":U + CHR(4) + STRING(lSubmitVal)
                        + CHR(3) 
                        + "CheckCurrentChanged":U + CHR(4) + STRING(lCheck).
                          
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
                            + "EntityFields":U + CHR(4) + cEntityFields.
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
 DEFINE VARIABLE hDataQuery  AS HANDLE  NO-UNDO.
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
   hDataQuery:QUERY-OPEN().
   CASE pcPosition: 
     WHEN 'FIRST':U THEN
       hDataQuery:GET-FIRST().
     WHEN 'LAST':U THEN
       hDataQuery:GET-LAST().  
     
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
 
 /* Close the RowObject query and empty the current RowObject table. */
 {get DataHandle hDataQuery}.
 IF VALID-HANDLE(hDataQuery) THEN 
 DO: 
   IF hDataQuery:IS-OPEN THEN
     {fn closeQuery}.
   ELSE DO:
     {get DataQueryString cDataQueryString}.
     IF cDataQueryString NE hDataQuery:PREPARE-STRING THEN
        hDataQuery:QUERY-PREPARE({fnarg fixQueryString cDataQueryString}).
   END.  /* else do - query not open */
 END.  /* if valid hDataQuery */

 /* If this object can use a DataContainer then we run fetchContainedRows 
    in that in order to retrieve this objects data together with all child 
    objects data. */ 
 hDataContainer = {fn dataContainerHandle}.
 IF VALID-HANDLE(hDataContainer) THEN 
 DO:
   {get ObjectName cObjectName}.
   RUN fetchContainedData IN hDataContainer (INPUT cObjectName).
   RETURN RETURN-VALUE <> 'adm-error':U.
 END.     /* END DO IF parent is a CLient object. */
 ELSE 
 DO:
   /* If this is the client half of a divided DataObject, fetchFirst will
      retrieve the Temp-table across the connection. */
   {get ASDivision cASDivision}.
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
              - Batch - Specifes that this is part of fetching another 
                        batch and the temp-table and batch properties need to
                        remain.  
              - Child - Specifies that this is a child of the request initiator.
                        This currently results in a removal of ForeignFields                                  
    Notes:  This is used when more than one table is being fetched and has been 
            separated for code reuse in the different scenarios. It should only
            be used in loops where the 
            caller need to know the order of the 
            SDOs and their relation ships in order to pass the right options.
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cQuery         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cBaseQuery     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cQueryWhere    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cForeignFields AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hContainer     AS HANDLE     NO-UNDO.

  /* pcOptions = 'Batch' is used when batching in order to keep the temp-table
     and the batch properties  */  
  IF NOT CAN-DO(pcOptions,'Batch':U)THEN
    IF NOT {fn getUpdateFromSource}  THEN
      {fnarg emptyRowObject 'reset':U}.
  
  {get QueryString cQuery}.           
  /* A blank QueryString may indicate that QueryWhere has been set.
     The QueryWhere is stored on the client (also for state-aware objects),
     so we must ensure that it is sent to server if it has been set.*/  
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
       in QueryColumns, and the server's QueryColumns may not match.) */
    {fn removeForeignKey}.
    /* Reread the queryString after removal of Foreign Field */
    {get QueryString cQuery}.
  END. /* child */
  ELSE  
  DO:
    /* Even if this is the upper SDO (parent) in this request, it may actually
       be a child, in which case it is possible that the ForeignFields may 
       not yet have been appplied to the client's QueryString.
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
        {get QueryWhere cQuery}.   
    END.

  END. /* iSDO = iSDONum */

  RETURN cQuery.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-prepareQuery) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION prepareQuery Procedure 
FUNCTION prepareQuery RETURNS LOGICAL
  (pcQuery AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose:  Prepare the SmartDataObject's database query based with the
            passed parameter  
            The main purpose of this procedure is to isolate the query 
            preparation for client server, thus keeping that away from the 
            logic needed to clean up and keep track of the QueryString property.
Parameters: Complete query expression. 
     Notes: History of client and server query manipulation:            
            9.0A setQueryWhere    - prepares immediately   (data and query)
                 setQuerySort     - prepares immediately   (data and query
                 openQuery        - just open              (data and query)
            9.0B addQueryWhere    - stored in queryString prop on client (query)
                 assignQueryWhere - stored in queryString prop on client (query)
                 openQuery        - prepares if queryString is set, open
            
            Although the 'client' logic is kept this is no longer part of the 
            normal client - server operation. The Query is passed as part of 
            the context.               
------------------------------------------------------------------------------*/
   DEFINE VARIABLE cASDivision    AS CHARACTER NO-UNDO.
   DEFINE VARIABLE cOperatingMode AS CHARACTER NO-UNDO.
   DEFINE VARIABLE hAppServer     AS HANDLE    NO-UNDO.
   DEFINE VARIABLE lOk            AS LOGICAL   NO-UNDO.
   DEFINE VARIABLE cBlank         AS CHARACTER NO-UNDO.
   /* If this is the client half of a divided DataObject prepare the query
      on the server. */                                   
   {get ASDivision cASDivision}.
   IF cASDivision = 'Client':U THEN
   DO:
     {get ASHandle hAppServer}.
     IF VALID-HANDLE(hAppServer) THEN 
     DO:
       lOk = {fnarg prepareQuery pcQuery hAppServer}.
       
       /* If the prepare was a success we must ensure that the new queryWhere 
          is set in stateless SDOs, which depends on QueryContext both to keep 
          context and to return the current query in getQueryWhere. */    
       IF lOk THEN 
       DO:
         {get ServerOperatingMode cOperatingMode}.         
         IF cOperatingMode = 'STATELESS':U THEN
         DO:
           {set QueryContext pcQuery}.
         END.
       END. /* if lOk */
       RETURN lok. 
     END. /* valid-handle(hAppserver) */
     ELSE
      RETURN FALSE. /* No hAppServer (should we have a lost contact message?)*/

   END.   /* If client */
   ELSE  /* This is not the client */
     RETURN SUPER(pcQuery).

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
               Could only not work if the query has been reopened and the
               rowobject temp-table has been rebuilt - therefore changing the
               rowids. This should not happen (hopefully).
------------------------------------------------------------------------------*/
 DEFINE VARIABLE hRowObject AS HANDLE NO-UNDO.
 DEFINE VARIABLE rRowid     AS ROWID  NO-UNDO.
 
 rRowid = TO-ROWID(ENTRY(1,pcRowident)).
 IF rRowid <> ? THEN
 DO:
   {get RowObject hRowObject}.
    hRowObject:FIND-BY-ROWID(rRowid) NO-ERROR.
 END.
 RETURN VALID-HANDLE(hRowObject) AND hRowObject:AVAILABLE.
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
           without the dreaded ghTargetProcedure workaround to identify which 
           SDO to reset.
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
        {get DataTarget cTargets}.
        
        /* We disable the data links to dataobjects as there is no need to 
           retrieve child data on the server, since we are going to end up 
           on the same record */       
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

        /* enable data link to targets again */ 
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
           currently wrapped in an on stop block using no-error and a hard-coded
           message will be shown if the limit is encountered.
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
  DEFINE VARIABLE hColumn      AS HANDLE     NO-UNDO.
  DEFINE VARIABLE lSizeError   AS LOGICAL    NO-UNDO. /* if bfx size error was detected */
  DEFINE VARIABLE iNumCols     AS INTEGER    NO-UNDO.
  DEFINE VARIABLE lSubstitute  AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cMessage     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cColValue    AS CHARACTER  NO-UNDO EXTENT 9.
  
  {get DataHandle hDataQuery}.
  
  /* We are not opening the query from here .. */
  IF hDataQuery:IS-OPEN THEN
  DO:
    /* ? is CHR(1) */
    IF pcDelimiter = ? THEN
      pcDelimiter = CHR(1).
    /* Ensure blank delimiter is single space */ 
    ELSE IF pcDelimiter = "":U THEN
      pcDelimiter = " ":U.

    &SCOPED-DEFINE xp-assign
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

    ASSIGN
      rRowid        = hRowObject:ROWID 
      /* allow dashes, but don't mess with substitute format */
      pcFormat      = IF NOT lSubstitute 
                      THEN REPLACE(pcformat,"-":U,"":U) 
                      ELSE pcFormat
      /* Maximize performance, avoid regetting dynamic buffer fields in loop.*/
      hColumnExt[1] = hRowObject:BUFFER-FIELD(ENTRY(1,pcColumns)) WHEN iNumCols >= 1
      hColumnExt[2] = hRowObject:BUFFER-FIELD(ENTRY(2,pcColumns)) WHEN iNumCols >= 2
      hColumnExt[3] = hRowObject:BUFFER-FIELD(ENTRY(3,pcColumns)) WHEN iNumCols >= 3
      hColumnExt[4] = hRowObject:BUFFER-FIELD(ENTRY(4,pcColumns)) WHEN iNumCols >= 4
      hColumnExt[5] = hRowObject:BUFFER-FIELD(ENTRY(5,pcColumns)) WHEN iNumCols >= 5 
      hColumnExt[6] = hRowObject:BUFFER-FIELD(ENTRY(6,pcColumns)) WHEN iNumCols >= 6
      hColumnExt[7] = hRowObject:BUFFER-FIELD(ENTRY(7,pcColumns)) WHEN iNumCols >= 7
      hColumnExt[8] = hRowObject:BUFFER-FIELD(ENTRY(8,pcColumns)) WHEN iNumCols >= 8
      hColumnExt[9] = hRowObject:BUFFER-FIELD(ENTRY(9,pcColumns)) WHEN iNumCols >= 9
      NO-ERROR.
    
    /* Just in case the SDO is browsed, ensure refreshable is turned off */    
    PUBLISH 'fetchDataSet':U FROM TARGET-PROCEDURE ('BatchStart':U). 
    
    hDataQuery:GET-FIRST.
    
    IF hRowObject:AVAILABLE THEN 
    BuildBlock:
    DO iLoop = 1 TO IF iLastRowNum = ? THEN 2 ELSE 1: /* need two loops if batching */      
      IF iLoop = 2 THEN
      DO:
        RUN sendRows IN TARGET-PROCEDURE
              (?, 
               ?, 
               TRUE /* Jump to next row */, 
               0, /* All records (no need to waste the time on batching) */
               OUTPUT iReturnRows).

        IF iReturnRows > 0 THEN
        DO:
          IF NOT hRowObject:AVAILABLE THEN
            hDataQuery:GET-NEXT.
        END.
      END.
      DO WHILE hDataQuery:QUERY-OFF-END = FALSE:
        DO iCol = 1 TO NUM-ENTRIES(pcColumns):
          /* We preset uptil 9 column handles in the extent, so use the extent
             if applicable. */   
          hColumn = IF iCol <= 9 
                    THEN hColumnExt[iCol]
                    ELSE hRowObject:BUFFER-FIELD(ENTRY(iCol,pcColumns)) NO-ERROR.
          
          IF NOT VALID-HANDLE(hColumn) THEN
          DO:
            MESSAGE "The column '" + ENTRY(iCol,pcColumns) + "' passed to rowValues()"
              +     " was not found in the data object."
              VIEW-AS ALERT-BOX ERROR.
            RETURN ?.
          END.

          CASE pcFormat:
            WHEN '':u OR WHEN ? THEN
              cValue = hColumn:BUFFER-VALUE.
            WHEN 'Formatted':U THEN
              cValue = RIGHT-TRIM(hColumn:STRING-VALUE).
            WHEN 'TrimNumeric':U THEN
              cValue = IF CAN-DO('Decimal,Integer':U,hColumn:DATA-TYPE) 
                       THEN TRIM(hColumn:STRING-VALUE)
                       ELSE RIGHT-TRIM(hColumn:STRING-VALUE). 
            WHEN 'NoTrim':U THEN
              cValue = hColumn:STRING-VALUE.
            OTHERWISE /* Substitute format, collect all values in extent  */
              cColValue[iCol] = hColumn:BUFFER-VALUE.
          END.
          IF cValue = ? THEN
             cValue = '?':U.
          IF NOT lSubstitute THEN
          DO:
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
          END.
        END. /* do iCol = 1 to num-entries */         
        
        IF lSubstitute THEN
        DO:
          /* on stop undo, leave to avoid bfx error */
          DO ON STOP UNDO, LEAVE :
            ASSIGN
             cList = cList   
                     + pcDelimiter
                     + SUBSTITUTE(pcFormat,
                                  cColValue[1],cColValue[2],cColValue[3],
                                  cColValue[4],cColValue[5],cColValue[6],
                                  cColValue[7],cColValue[8],cColValue[9]) NO-ERROR.
        
          END. /* end assign block */         
          
          IF ERROR-STATUS:ERROR THEN 
          DO:
            ASSIGN
              lSizeError = TRUE
              cMessage   = ERROR-STATUS:GET-MESSAGE(1). 
            LEAVE BuildBlock.
          END.
        END. /* Subst */
        hDataQuery:GET-NEXT.
      END. /* BuildBlock: do while Query-off-end = false */    
    END. /* if hRowObject:avail do iLoop   */
    
    IF rRowid <> ? THEN
    DO:  
      hDataQuery:REPOSITION-TO-ROWID(rRowid). 
      IF NOT hRowObject:AVAILABLE THEN
        hDataQuery:GET-NEXT.
    END.

    /* In case the SDO is browsed, ensure refreshable is turned back on */    
    PUBLISH 'fetchDataSet':U FROM TARGET-PROCEDURE ('BatchEnd':U).     
  END. /* queryopen */
  
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
    INPUT pcRowIdent  - "key" with row number to update, plus a list of the 
                        ROWID(s) of the db record(s) the RowObject is derived 
                        from.
    INPUT pcValueList - CHR(1) delimited list of alternating column names 
                        and values to be assigned.
------------------------------------------------------------------------------*/
  DEFINE VARIABLE lReopen        AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE cErrorMessages AS CHARACTER NO-UNDO INIT "":U.
  DEFINE VARIABLE cUpdColumns    AS CHARACTER NO-UNDO.
    
  /* NOTE: check here to make sure that the RowIdent passed in 
     matched the current ROWID or could be repositioned to removed in 9.1B.
     There is no supported case where repositioning should be necessary,
     and the new SBO does not always have the correct RowIdent. */
  
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

