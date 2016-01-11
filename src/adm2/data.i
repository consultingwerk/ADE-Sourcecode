&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12
/* Procedure Description
"Method Library for SmartDataObjects."
*/
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Method-Library 
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
    Library     : data.i - Basic include file for the V9 SmartData object

    Syntax      : {src/adm2/data.i}

    Modified    : August 4, 2000 Version 9.1B
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

&IF "{&ADMClass}":U = "":U &THEN
   &GLOB ADMClass data
&ENDIF

DEFINE VARIABLE giRowNum     AS INTEGER NO-UNDO INIT 0.
DEFINE VARIABLE ghDataQuery  AS HANDLE  NO-UNDO.

/* Added or Changed RowIdent temp-table */
DEFINE TEMP-TABLE ModRowIdent NO-UNDO
   FIELD RowIdent AS CHARACTER
   /* This field and index is added to fix the Rocket's index length limitation of 188 chars 
      Further in the code the RowIdentIdx field is deliberately trimmed to guaranteedly not 
      exceed this limit. The trimmed field is used for indexed search to keep the satisfactory 
      performance */
   FIELD RowIdentIdx AS CHARACTER
   INDEX RowIdentIdx RowIdentIdx
   .

&IF "{&ADMClass}":U = "data":U &THEN
  {src/adm2/dataprop.i}
&ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-canFindModRow) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD canFindModRow Method-Library 
FUNCTION canFindModRow RETURNS LOGICAL
  ( pcRowIdent AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-commit) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD commit Method-Library 
FUNCTION commit RETURNS LOGICAL
  ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Method-Library
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: INCLUDE-ONLY
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Method-Library ASSIGN
         HEIGHT             = 11.81
         WIDTH              = 49.8.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB Method-Library 
/* ************************* Included-Libraries *********************** */

  {src/adm2/query.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Method-Library 


/* ***************************  Main Block  *************************** */

  RUN start-super-proc("adm2/data.p":U).
  RUN start-super-proc("adm2/dataext.p":U).
  /* dataext.p is merely a simple "extension" of data.p.  This was necessary
     because functions don't have there own action segement and data.p got
     too big and had to be broken up.  All of the functions in dataext.p
     are get and set property functions.  */
  RUN start-super-proc("adm2/dataextcols.p":U).
  /* dataextcols.p is also a simple "extension" of data.p.  This was necessary
    because the action segment became to big on A400 also after the split in 
    data and dataext. We cannot just move randomly selected functions to 
    dataext.p, and all column properties did not fit. All of the functions in 
    dataextcols.p are column properties (column and assignColumn functions)  */

/* The prepreprocessor check involving DATA-FIELD-DEFS is used to provide
   backward compatibility with how Beta 2 code defined the preprocessor.
   It got changed for final release to support spaces in the include file's
   path or name. For final release, the preprocessor is a quoted file name. */
 DEFINE TEMP-TABLE RowObject
  /* Allow users to ommit the hardcoded RCODE-INFORMATION and put it in the 
     include instead. 
     This makes it possible to manually maintain the include using LIKE 
     and thus avoid -inp and -tok limitations 
   ----------------------------------------    
    LIKE  CUSTOMER {&TEMP-TABLE-OPTIONS}  
   --------------------------------------*/
 &IF '{&TEMP-TABLE-OPTIONS}' = '' &THEN
     RCODE-INFORMATION
 &ENDIF
  
 &IF '{&DATA-FIELD-DEFS}' BEGINS '"' &THEN
   {{&DATA-FIELD-DEFS}}
 &ELSE
   {&DATA-FIELD-DEFS}
 &ENDIF
   {src/adm2/robjflds.i}.
 
 DEFINE TEMP-TABLE RowObjUpd    NO-UNDO LIKE RowObject
   FIELD ChangedFields AS CHARACTER.
 DEFINE QUERY    qDataQuery           FOR RowObject SCROLLING.
 DEFINE VARIABLE cColumns             AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cContainerType       AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cQueryString         AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE hRowObject           AS HANDLE     NO-UNDO.

  {set QueryObject yes}.             /* All DataObjects are query objects.*/
  ghDataQuery = QUERY qDataQuery:HANDLE.  /* Temp-Table query */
  {set DataHandle ghDataQuery}.
  /* Set up the RowObject query to be opened dynamically. */
  {get DataQueryString cQueryString}.
  ghDataQuery:QUERY-PREPARE(cQueryString).  

  hRowObject = BUFFER RowObject:HANDLE.
  {set RowObject hRowObject}.  /* Handle of RowObject buffer.*/
  hRowObject = BUFFER RowObjUpd:HANDLE.
  {set RowObjUpd hRowObject}. /* Row Update buffer handle. */
  hRowObject = TEMP-TABLE RowObject:HANDLE.
  {set RowObjectTable hRowObject}.  /* 9.1B RowObject temp-table handle. */
  hRowObject = TEMP-TABLE RowObjUpd:HANDLE.
  {set RowObjUpdTable hRowObject}.  /* 9.1B RowObject temp-table handle. */
  
   /* Overrides query object setting */
  {set DataSourceEvents 'dataAvailable,confirmContinue,isUpdatePending':U}.

  /* Don't let this object be an Update-Target if its fields are not updatable*/
  {get UpdatableColumns cColumns}.   /* Fetch this prop, set in query.i */
  
  IF cColumns = "":U THEN
    RUN modifyListProperty(THIS-PROCEDURE, 'REMOVE':U, 'SupportedLinks':U,
        'Update-Target':U).

  /* _ADM-CODE-BLOCK-START _CUSTOM _INCLUDED-LIB-CUSTOM CUSTOM */
  {src/adm2/custom/datacustom.i}
  /* _ADM-CODE-BLOCK-END */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-doBuildUpd) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE doBuildUpd Method-Library 
PROCEDURE doBuildUpd :
/*------------------------------------------------------------------------------
  Purpose:     Transfers changed rows into the Update Temp-Table and returns
               it to the caller (the Commit function).

  Parameters:
    OUTPUT RowObjUpd - table containing updated records

  Notes:       This code, and other "do" procedures, need to be in the 
               SmartDataObject itself to allow the BUFFER-COPY operations. 
               They can be specialized by defining like-named procedures 
               in another support procedure. 
               For each existing row to be updated, there is already a "before"
               copy in the RowObjUpd table, so we create an "after" row.
               There is already a row in RowObjUpd for each Added/Copied row, 
               so we just update it with the latest values.
               There is already a row in RowObjUpd for each Deleted row, so
               we don't need to do anything for these rows.
------------------------------------------------------------------------------*/
  DEFINE BUFFER bRowObject FOR  RowObject. 
  DEFINE BUFFER bRowObjUpd FOR  RowObjUpd. 

  /*   DEFINE OUTPUT PARAMETER TABLE FOR RowObjUpd. NOTE: Removed in 9.1B */
 
  FOR EACH bRowObject WHERE bRowObject.RowMod = "U":U:   
    CREATE bRowObjUpd.
    BUFFER-COPY bRowObject TO bRowObjUpd.
  END. 

  FOR EACH bRowObject WHERE bRowObject.RowMod = "A":U 
                      OR    bRowObject.RowMod = "C":U:   
    FIND bRowObjUpd WHERE bRowObjUpd.RowNum = bRowObject.RowNum.
    BUFFER-COPY bRowObject TO bRowObjUpd.
  END.

  RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-doCreateUpdate) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE doCreateUpdate Method-Library 
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
  DEFINE OUTPUT PARAMETER plReopen    AS LOGICAL   NO-UNDO INIT no.
  DEFINE OUTPUT PARAMETER pcMessage   AS CHARACTER NO-UNDO.
 
  DEFINE VARIABLE iField        AS INTEGER   NO-UNDO.
  
  /* If the "Data" (Temp-Table) query is empty, re-FIND the db rec(s),
      unless it's a newly added row (no db rowids in RowIdent). */
  IF (NOT ghDataQuery:IS-OPEN OR ghDataQuery:NUM-RESULTS = 0) AND
      NUM-ENTRIES(pcRowIdent) > 1 AND ENTRY(2, pcRowIdent) NE "":U THEN
  DO:
    /* Now create a RowObject record and assign a RowNum to it. */
    CREATE RowObject.
    ASSIGN giRowNum = giRowNum + 1
           RowObject.RowNum = giRowNum.
    /* This creates a temp-table row from the db recs. */
    RUN transferDBRow In TARGET-PROCEDURE(pcRowIdent, giRowNum). 
  END.       /* END DO if no query */
  
  /* First check to see if there's already a saved pre-change version 
     of the record; this would be so if the same row is changed 
     multiple times before commit. */
  DO TRANSACTION:
    FIND RowObjUpd WHERE RowObjUpd.RowNum = RowObject.RowNum NO-ERROR.
    
    IF NOT AVAILABLE RowObjUpd THEN
    DO:
      CREATE RowObjUpd.
      BUFFER-COPY RowObject TO RowObjUpd.
    END.

    /* If this isn't an add/copy then */
    IF RowObject.RowMod NE "A":U AND RowObject.RowMod NE "C":U THEN 
      RowObject.RowMod = "U":U. /*  flag it as update. NOTE: double-chk*/
    ELSE 
      plReopen = true.            /* Tell caller to reopen query. */
  END.
  
  pcMessage = "".   /* "Success" output value. */


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-doEmptyModTable) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE doEmptyModTable Method-Library 
PROCEDURE doEmptyModTable :
/*------------------------------------------------------------------------------
  Purpose:     Empties the temp-table (ModRowIdent) that keeps track of added
               and modified records since the last openQuery().
 
  Parameters:  <none>
  
  Notes:       The ModRowIdent temp-table contains the rowIdents of records 
               already on the client process and its purpose is to prevent 
               sending duplicate records in upcoming batches.
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hModRowIdent AS HANDLE NO-UNDO.
  hModRowIdent = BUFFER ModRowIdent:HANDLE.
  hModRowIdent:EMPTY-TEMP-TABLE().
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-doEmptyTempTable) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE doEmptyTempTable Method-Library 
PROCEDURE doEmptyTempTable :
/*------------------------------------------------------------------------------
  Purpose:     Empties the RowObject temp-table when the database query is 
               being re-opened.
 
  Parameters:  <none>
  
  Notes:       Normally this is not necessary -- the EMPTY-TEMP-TABLE
               method can be used, which is faster. However, this must
               be used when a transaction is active, because EMPTY-TEMP-TABLE
               will not work in that case.
------------------------------------------------------------------------------*/

  DO TRANSACTION:
    FOR EACH RowObject:
      DELETE RowObject.
    END.
  END.
  RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-doReturnUpd) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE doReturnUpd Method-Library 
PROCEDURE doReturnUpd :
/*------------------------------------------------------------------------------
  Purpose:     RUN from Commit on the client side to get back the Update 
               (RowObjUpd) table (from the server side) and undo any failed 
               changes or return final versions of record values to the client.
 
  Parameters:  
    INPUT cUndoIds - list of any RowObject ROWIDs whose changes were
                     rejected by a commit. Delimited list of the form:
               "RowNumCHR(3)ADM-ERROR-STRING,RowNumCHR(3)ADM-ERROR-STRING,..."
            
  Notes:   - If the error string in cUndoIds is "ADM-FIELDS-CHANGED", then
             another user has changed at least one field value.  In this 
             case, RowObjUpd fields will contain the refreshed db values 
             and we pass those values back to the client.
           - If not autocommit we may also reposition here, but otherwise the caller 
             both has the rowident and has more info. (submitCommit knows whether 
             a reopen is required, deleteRow just uses fetchNext if required)       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pcUndoIds AS CHARACTER NO-UNDO.

  DEFINE BUFFER bRowObjUpd FOR RowObjUpd.
 
  DEFINE VARIABLE lAutoCommit     AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE hDataQuery      AS HANDLE    NO-UNDO.
  DEFINE VARIABLE lQueryContainer AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE lBrowsed        AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE hMsgSource      AS HANDLE    NO-UNDO.
  DEFINE VARIABLE rCurrentRowid   AS ROWID     NO-UNDO.
  DEFINE VARIABLE rErrorRowid     AS ROWID     NO-UNDO.
  DEFINE VARIABLE iUndoId         AS INTEGER   NO-UNDO.
  DEFINE VARIABLE iFirstUndoId    AS INTEGER   NO-UNDO.
  DEFINE VARIABLE iCnt            AS INTEGER   NO-UNDO.
  DEFINE VARIABLE lCommitOk       AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE cQueryPosition  AS CHARACTER NO-UNDO.
  DEFINE VARIABLE hContainer      AS HANDLE    NO-UNDO.
  DEFINE VARIABLE lUndoDelete     AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE lQueryOpened    AS LOGICAL   NO-UNDO.

  
  {get AutoCommit lAutoCommit}.
  /* Find out whether this SDO is inside an SBO or other Query Object. 
     If so, we will refer to that object to check for error messages. */
  {get QueryContainer lQueryContainer}.  
  
  IF lQueryContainer THEN
    {get ContainerSource hMsgSource}.
  ELSE 
    hMsgSource = THIS-PROCEDURE.

  lCommitOk = NOT DYNAMIC-FUNCTION('anyMessage':U IN hMsgSource) AND (pcUndoIds = "":U).
  
  /* Just keep track of where we are for no autocommit repositioning further
     down */
  rCurrentRowid = ROWID(RowObject). /* ? if not avail */ 
  
  /* Commit successful. */
  IF lCommitOk THEN
  DO:
       /* Move updated versions of records, including any values assigned by CREATE
       or WRITE triggers, back into the RowObject table for the client to see. 
       Adds and Copies are marked with an "A" or "C", Updates with "U". */
    FOR EACH RowObjUpd: 
      IF CAN-DO ("A,C,U":U,RowObjUpd.RowMod) THEN
      DO:    
        FIND RowObject WHERE RowObject.RowNum = RowObjUpd.RowNum.
        BUFFER-COPY RowObjUpd TO RowObject 
          ASSIGN RowObject.RowMod = "":U.
      END. /* can-do('A,C,U',RowObjUpd.Rowmod)  */
      /* Empty the update table. */
      DELETE RowObjUpd.
    END. /* for each RowObjUpd */
  END.  /* Commit successful. */
  ELSE DO:  /* Commit not successful. */
    /* If not autocommit we want to know which of the undoids we shall position to*/
    IF NOT lAutoCommit THEN 
    DO:
      IF pcUndoIds <> '':U THEN
      DO:
        /* loop through the passed list of undo info and find the lowest Rownum (<> 0) */
        DO iCnt = 1 TO NUM-ENTRIES(pcUndoIds, ",":U):
          iUndoId = INTEGER(ENTRY(1, ENTRY(iCnt, pcUndoIds, ",":U), CHR(3))).
          IF iUndoId > 0 THEN iFirstUndoId = IF iCnt = 1 
                                           THEN iUndoId 
                                           ELSE MIN(iFirstUndoId, iUndoId).
        END.
      END. /* Do i to Num entries */

      {get DataQueryBrowsed lBrowsed}.
      
      /* Restore deleted records */
      RUN doUndoDelete IN TARGET-PROCEDURE. 
      
      /* If deletes has been restored openQuery */ 
      IF rCurrentRowid <> ROWID(rowObject) THEN
      DO:
        rErrorRowid = ROWID(rowObject).
        {fnarg openDataQuery '':U}.
        lQueryOpened = TRUE. 
        
        /* We have found the first error so avoid find further down. */
        IF AVAIL RowObject AND iFirstUndoId = RowObject.RowNum THEN
          iFirstUndoId = 0.
      END.  
        
      /* We have the lowest RowNumber, so find the rowObject  */  
      IF iFirstUndoId <> 0 THEN
      DO:
        FIND RowObject WHERE RowObject.RowNum =  iFirstUndoId NO-ERROR.
        IF AVAIL RowObject THEN
        DO:
           FIND RowObjUpd WHERE RowObjUpd.RowNum =  RowObject.RowNum 
                          AND   RowObjUpd.RowMod <> '':U NO-ERROR. 
           ASSIGN 
             rErrorRowid = ROWID(RowObject).
        END. /* avail ROwObject */
      END. /* FistUndoId <> 0  */
    END. /* not autocommit  */

    /* Go through each 'U' copy and use it to find the 'before-image' for delete
       or refresh also copy the contents to rowObject if adm-fields-changed */
    FOR EACH RowObjUpd WHERE RowObjUpd.RowMod = "U":U:      
              
      /* Refreshing the update record if required (changed data was reset on server).*/
      IF INDEX(pcUndoIds,STRING(RowObjUpd.RowNum) + CHR(3) + "ADM-FIELDS-CHANGED":U) <> 0 THEN
      DO:
        FIND RowObject WHERE RowObject.RowNum = RowObjUpd.RowNum.

        /* Copy the refreshed db field values to row object. */
        BUFFER-COPY RowObjUpd EXCEPT RowMod TO RowObject.
        
        FIND bRowObjUpd WHERE bRowObjUpd.RowNum = RowObjUpd.RowNum
                        AND   bRowObjUpd.RowMod = "":U. 
          /* Copy the refreshed db field values to the pre-commit row.
             Don't copy over the RowMod (that could change what the
             record is used for). And don't copy over ChangedFields. Leave
             that as the client set it. */
        BUFFER-COPY RowObjUpd EXCEPT RowMod ChangedFields TO bRowObjUpd.
      END. /* UndoIds matches RowNum and ADM-FIELDS-CHANGED */

      /* The pre-commit update record (RowMod = "") contains the right values for
         an undo, so we no longer need the commit copy (RowMod = "U") of
         the update record. */
      DELETE RowObjUpd.
    END. /* for each RowObjUpd .. RowMod = "U" */            
    /* Failed AutoCommit Add, copy and Delete should also be removed.
       (non autocommit need to be kept to be able to Undo.) */
    IF lAutoCommit THEN
    FOR EACH RowObjUpd WHERE CAN-DO('A,C,D':U,RowObjUpd.RowMod):
      DELETE RowObjUpd.
    END. /* FOR EACH */
  END. /* Commit not successful */
  
  /* Deal with reopen, reposition and publish dataavailable for non auto commit */
  IF NOT lAutoCommit THEN
  DO:
    {get QueryContainer lQueryContainer}.

    IF lCommitOk THEN
    DO:
      /* If not Autocommit changes can be to more than one record, so if object
         is being browsed then ensure all records in the browser are refreshed 
         correctly.*/  
      PUBLISH 'refreshBrowser':U FROM TARGET-PROCEDURE.
      /* The SBO does publish dataavailable, when all objects have been returned,
         so don't do it here. Also only publish if the commit was ok. */
      IF NOT lQueryContainer THEN
        PUBLISH "dataAvailable":U FROM TARGET-PROCEDURE ('SAME':U). 
    END.
    ELSE DO:

      /* rErrorRowid is set above if failed by finding the record with 
         the help of pcUndoIds, reposition to it if it's not already there */  
      IF rErrorRowid <> ?  
      AND (lQueryOpened OR 
          (NOT AVAIL RowObject OR ROWID(RowObject) <> rErrorRowid)) THEN 
      DO:
        {get DataHandle hDataQuery}.
        hDataQuery:REPOSITION-TO-ROWID(rErrorRowid) NO-ERROR.
        
        /* if not browsed, get-next to get the buffer */
        IF (ERROR-STATUS:GET-MESSAGE(1) = '':U) AND (NOT AVAIL RowObject) THEN 
            hDataQuery:GET-NEXT.
        
        /* This will need some improvement in the future.. 
           This includes the reposition logic above.  
           See also undoTransaction.             
           The sbo runs doReturnUpd for failed SDOs, and if the SBO has
           AutoCommit it also need to run undoTransaction in the sdo,
           which also publish data available (when sbo has autocommit)
           So here we publish if the SBO does NOT have autocommit otherwise
           we leave it to undoTransaction */

      END. /* rErrorRowid <> ? */ 
      
      IF NOT CAN-FIND (FIRST RowObject WHERE RowObject.RowMod <> '':U) THEN
        {set RowObjectState 'NoUpdates':U}.

      RUN updateQueryPosition IN TARGET-PROCEDURE.         
      IF NOT lQueryContainer THEN
        PUBLISH "dataAvailable":U FROM TARGET-PROCEDURE
           (IF ROWID(rowObject) <> rCurrentRowid  
            THEN 'DIFFERENT':U                  
            ELSE 'SAME':U).
    END.  /* not ok  */
  END. /* not autocommit */
  RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-doUndoDelete) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE doUndoDelete Method-Library 
PROCEDURE doUndoDelete :
/*------------------------------------------------------------------------------
  Purpose:     Restore deleted rows. 
  Parameters:  <none>
 
  Notes:       This is separated because: 
               - a failed commit should restore this, otherwise the user has to 
                 undo to correct mistakes. 
               - The regualar undo need to restore these.
------------------------------------------------------------------------------*/  
  DEFINE VARIABLE iFirstRowNum    AS INTEGER   NO-UNDO.
  DEFINE VARIABLE iLastRowNum     AS INTEGER   NO-UNDO.
  
  /* Start from last so the first delete is avail when we are finished */ 
  FOR EACH RowObjUpd WHERE RowObjUpd.RowMod = "D":U BY RowNum DESCENDING:
    /* Make sure this is in the database */
    IF RowObjUpd.RowIdent <> '':U THEN
    DO:
      CREATE RowObject.
      BUFFER-COPY RowObjUpd TO RowObject.
    
      RowObject.RowMod = "":U.
    
      /* Reset the first or last num values if the undeleted record falls outside
         the current batch range. */
      {get FirstRowNum iFirstRowNum}.
      IF RowObjUpd.RowNum < iFirstRowNum THEN
        {set FirstRowNum RowObjUpd.RowNum}.
      {get LastRowNum iLastRowNum}.
      IF RowObjUpd.RowNum >= iLastRowNum THEN 
      DO:
        {set LastRowNum RowObjUpd.RowNum}.
        {set LastDbRowIdent RowObjUpd.RowIdent}.
      END.  /* If RowNum >= LastRowNum */
      DELETE RowObjUpd.
    END. /* RowIdent <> '' */
    ELSE /* This is a deleted new uncommitted record so just 
            set the RowMod and deal with it below */ 
      RowObjUpd.RowMod = "A":U.
  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-doUndoRow) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE doUndoRow Method-Library 
PROCEDURE doUndoRow :
/*------------------------------------------------------------------------------
  Purpose:  Rollback using the before image RowObjUpd record    
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE lBrowsed      AS LOGICAL   NO-UNDO.
  
  IF AVAIL RowObject THEN
  DO:
    FIND RowObjUpd WHERE RowObjUpd.RowNum = RowObject.RowNum
                   AND   RowObjUpd.RowMod = "":U NO-ERROR.
    
    IF AVAILABLE (RowObjUpd) THEN /* may not be there if never saved */
    DO:                               
      BUFFER-COPY RowObjUpd TO RowObject.
      DELETE RowObjUpd. 
      RETURN.
    END.   /* END DO IF AVAILABLE */

  END. 

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-doUndoTrans) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE doUndoTrans Method-Library 
PROCEDURE doUndoTrans :
/*------------------------------------------------------------------------------
  Purpose:     Does the buffer delete and copy operations to restore the
               RowObject temp-table when an Undo occurs.  New RowObject records
               (added or copied) are deleted, modified records are restored to 
               their original states and deleted records are recreated.  The
               RowObjUpd table is emptied.

  Parameters:  <none>
 
  Notes:       Invoked from the event procedure undoTransaction.
               doUndoTrans is run on the client side.
------------------------------------------------------------------------------*/
  DEFINE VARIABLE iLastRowNum     AS INTEGER   NO-UNDO.
  DEFINE VARIABLE lLastRowInBatch AS LOGICAL   NO-UNDO.
  /* Restore RowObject to its original state. To do this:
    delete any added/copied rows (RowObject.RowMod = "A"/"C"); 
     copy any updated rows (RowObject.RowMod = "U") back from RowObjUpd;
     and restore any deleted rows (RowObjUpd.RowMod = "D"). */
  
  RUN doUndoDelete IN TARGET-PROCEDURE. 
  
  {get LastRowNum iLastRowNum}.
  FOR EACH RowObject WHERE RowObject.RowMod = "A":U OR
                           RowObject.RowMod = "C":U:         
    /* If a new record is last, we know that we have the original new 
       record in the batch, because that's the requirement for a new record 
       to be marked as last. */
    IF RowObject.RowNum = iLastRowNum THEN
      lLastRowInBatch = TRUE.
    DELETE RowObject.
  END.
  
  FOR EACH RowObject WHERE RowObject.RowMod = "U":U:
    FIND RowObjUpd WHERE RowObjUpd.RowNum = RowObject.RowNum AND
                         RowObjUpd.RowMod = "":U.  /* before copy */
    BUFFER-COPY RowObjUpd TO RowObject.
  END.
  
    /* We have undone an Added record that was last and know that the real last
     is in the batch */  
  IF lLastRowInBatch THEN
  DO:
    FIND LAST RowObject NO-ERROR.
    IF AVAIL RowObject THEN
    DO:
      {set LastRowNum RowObject.RowNum}.
      {set LastDbRowIdent '':U}. /* We don't need this if we have lastRownum*/
    END.
  END. /* lLastrowInbatch */

  /* For repositioning, locate the first Update or Delete record thats being
     undone and position there. If there aren't any, then we are undoing an Add.
     In that case, position to the first record in the batch. */
  FIND FIRST RowObjUpd WHERE RowObjUpd.RowMod = "":U OR
                             RowObjUpd.RowMod = "D":U
                       USE-INDEX RowNum NO-ERROR.
  
  IF AVAILABLE RowObjUpd THEN
    FIND RowObject WHERE RowObject.RowNum = RowObjUpd.RowNum NO-ERROR.
  ELSE
    FIND FIRST RowObject NO-ERROR.

  IF NOT AVAILABLE RowObject THEN
  DO:
    {set FirstRowNum ?}.
    {set LastRowNum ?}.
  END.

  RUN updateQueryPosition IN TARGET-PROCEDURE.
    
  EMPTY TEMP-TABLE RowObjUpd.
  
  RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-doUndoUpdate) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE doUndoUpdate Method-Library 
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
  DEFINE VARIABLE hDataQuery    AS HANDLE    NO-UNDO.
  DEFINE VARIABLE rRowObject    AS ROWID     NO-UNDO.
  DEFINE VARIABLE lBrowsed      AS LOGICAL   NO-UNDO.
  
  IF AVAIL RowObject THEN
  DO:
    FIND RowObjUpd WHERE RowObjUpd.RowNum = RowObject.RowNum
                   AND   RowObjUpd.RowMod = "":U NO-ERROR.
    
    IF AVAILABLE (RowObjUpd) THEN /* may not be there if never saved */
    DO:                               
      BUFFER-COPY RowObjUpd TO RowObject.
      DELETE RowObjUpd. 
      PUBLISH 'dataAvailable':U FROM TARGET-PROCEDURE ("SAME":U). 
      RETURN.
    END.   /* END DO IF AVAILABLE */
    
    IF RowObject.RowMod = "A":U OR RowObject.RowMod = "C":U THEN
    DO:
      /* If a save was attempted, clean out the Update table. */
      FIND RowObjUpd WHERE RowObjUpd.RowNum = RowObject.RowNum NO-ERROR.
      IF AVAILABLE (RowObjUpd) THEN
        DELETE RowObjUpd.
      
      DELETE RowObject.  
      /* Tell a browse updateSource to get rid of the insert-row */
      PUBLISH 'cancelNew':U FROM TARGET-PROCEDURE.
      /* Re-establish the current row */
      {get DataHandle hDataQuery}.
      {get CurrentRowid rRowObject}.

      IF hDataQuery:IS-OPEN AND rRowObject <> ? THEN 
      DO:
        hDataQuery:REPOSITION-TO-ROWID(rRowObject) NO-ERROR.
        /* Next needed if not browser (Data-Target) */
        IF NOT AVAIL RowObject AND ERROR-STATUS:GET-MESSAGE(1) = '':U THEN  
          hDataQuery:GET-NEXT() NO-ERROR.
      END.  /* IF the query is open */
    END. /* DO IF "A"/"C" */
  END. /* if avail rowobject */

  RETURN.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-prepareErrorsForReturn) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE prepareErrorsForReturn Method-Library 
PROCEDURE prepareErrorsForReturn PRIVATE :
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
     pcMessages = LEFT-TRIM(pcMessages + CHR(3) + fetchMessages(),CHR(3)).
  
  RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-pushTableAndValidate) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pushTableAndValidate Method-Library 
PROCEDURE pushTableAndValidate :
/*------------------------------------------------------------------------------
  Purpose:     wrapper for pre and postTransactionValidate procedures when
               run from SBO.
  Parameters:  INPUT pcValType AS CHARACTER -- "Pre" or "Post",
               INPUT-OUTPUT TABLE FOR RowObjUpd.
  Notes:       
------------------------------------------------------------------------------*/
   DEFINE INPUT PARAMETER pcValType AS CHAR   NO-UNDO.
   DEFINE INPUT-OUTPUT PARAMETER TABLE FOR RowObjUpd.

   RUN VALUE(pcValType + "TransactionValidate":U) IN THIS-PROCEDURE NO-ERROR.

   RETURN RETURN-VALUE.   /* Return whatever we got from the val. proc. */
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-serverCommit) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE serverCommit Method-Library 
PROCEDURE serverCommit :
/*------------------------------------------------------------------------------
  Purpose:     Server-side update procedure executed on the server side of a
               split SmartDataObject, called from the cleint Commit function.
               Commit passes a set up RowObjUpdate records both have changes to
               be committed and their pre-change copies (before-images).  
               serverCommit verifies that the records have not been changed 
               since they were read, and then commits the changes to the database.
  
  Parameters:
    INPUT-OUTPUT TABLE RowObjUpd - The Update version of the RowObject 
                                   Temp-Table
    OUTPUT cMessages - a CHR(3) delimited string of accumulated messages from
                       server.
    OUTPUT cUndoIds  - list of any RowObject ROWIDs whose changes need to be 
                       undone as the result of errors in the form of:
               "RowNumCHR(3)ADM-ERROR-STRING,RowNumCHR(3)ADM-ERROR-STRING,..."

  Notes:       Returns false if any update errors are detected.
               If another user has modified the database records since the 
               original was read, the new database values are copied into the 
               RowObjUpd record and returned to Commit so the UI object can 
               diaply them.
------------------------------------------------------------------------------*/
  DEFINE INPUT-OUTPUT  PARAMETER TABLE FOR RowObjUpd.
  DEFINE OUTPUT PARAMETER pocMessages AS CHARACTER NO-UNDO.
  DEFINE OUTPUT PARAMETER pocUndoIds  AS CHARACTER NO-UNDO INIT "":U.
  
  DEFINE VARIABLE lCheck        AS LOGICAL   NO-UNDO.
  DEFINE BUFFER   bRowObjUpd    FOR RowObjUpd.
  DEFINE VARIABLE hRowObjUpd    AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hRowObjFld    AS HANDLE    NO-UNDO.
  DEFINE VARIABLE cASDivision   AS CHARACTER NO-UNDO.
  DEFINE VARIABLE lKillTrans    AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE lSubmitVal    AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE iChange       AS INTEGER   NO-UNDO.
  DEFINE VARIABLE cChanged      AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cChangedFlds  AS CHARACTER NO-UNDO INIT "":U.
  DEFINE VARIABLE cChangedVals  AS CHARACTER NO-UNDO INIT "":U.
  DEFINE VARIABLE cUpdatable    AS CHARACTER NO-UNDO.
  DEFINE VARIABLE lQueryContainer AS LOGICAL NO-UNDO INIT NO.
  DEFINE VARIABLE hContainerSource AS HANDLE NO-UNDO.
  DEFINE VARIABLE cDeleteMsg    AS CHARACTER NO-UNDO.
  DEFINE VARIABLE iEntry        AS INTEGER   NO-UNDO.

 &IF DEFINED(OPEN-QUERY-{&QUERY-NAME}) NE 0 &THEN  /* Skip when compiling templ*/
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
      RUN TransactionValidate IN THIS-PROCEDURE NO-ERROR. 
      IF NOT ERROR-STATUS:ERROR AND RETURN-VALUE NE "":U THEN
      DO:
        RUN prepareErrorsForReturn(INPUT RETURN-VALUE, INPUT cASDivision, 
                                   INPUT-OUTPUT pocMessages).
        RETURN.      /* Bail out if application code rejected the txn. */
      END.   /* END DO IF RETURN-VALUE NE "" */
      RUN preTransactionValidate IN THIS-PROCEDURE NO-ERROR. 
      IF NOT ERROR-STATUS:ERROR AND RETURN-VALUE NE "":U THEN
      DO:
        RUN prepareErrorsForReturn(INPUT RETURN-VALUE, INPUT cASDivision, 
                                   INPUT-OUTPUT pocMessages).
        RETURN.      /* Bail out if application code rejected the txn. */
      END.   /* END DO IF RETURN-VALUE NE "" */
  END.       /* END DO IF Container (SBO) is not doing the Commit. */

  /* Construct the changed value list. This list is actually stored in the 
     Before version of the record for an update. */
  {get UpdatableColumns cUpdatable}.
  hRowObjUpd = BUFFER RowObjUpd:HANDLE.

  FOR EACH RowObjUpd WHERE LOOKUP(RowObjUpd.RowMod,"A,C,U":U) NE 0:
     IF RowObjUpd.RowMod = "U":U THEN
     DO:
       FIND bRowObjUpd WHERE bRowObjUpd.RowNum = RowObjUpd.RowNum 
                       AND   bRowObjUpd.RowMod = "":U.
         /* As of 9.1A, we no longer rely on ChangedFields being set
            before this point. Calculate it here so it includes any
            application-generated values. */
       BUFFER-COMPARE RowObjUpd EXCEPT ChangedFields RowMod RowIdent RowNum
                   TO bRowObjUpd CASE-SENSITIVE SAVE cChangedFlds.
     END.    /* END DO IF RowMod = U */
     ELSE IF RowObjUpd.RowMod = "A":U THEN
     DO:
        /* For an Add, set ChangedFields to all fields no longer
           equal to their defined INITIAL value. Determine this by
           creating a RowObject record to compare against. */
       CREATE RowObject.
       BUFFER-COMPARE RowObjUpd EXCEPT ChangedFields RowMod RowIdent RowNum
                   TO RowObject CASE-SENSITIVE SAVE cChangedFlds. 
     END.      /* END DO If "A" for Add */
     ELSE                 /* use all enabled fields for a Copy. */
       cChangedFlds = cUpdatable.
        /* Now assign the list of fields into the ROU record. 
           (Put it in the before record as well for an Update.) 
           This list will be used by query.p code to ASSIGN changes
           back to the database. */
     IF RowObjUpd.RowMod = "U":U THEN
       bRowObjUpd.ChangedFields = cChangedFlds.
     RowObjUpd.ChangedFields = cChangedFlds.
     /* if a row was temporarily created to supply initial values for the
        Add operation BUFFER-COMPARE, delete it now. */
     IF RowObjUpd.RowMod = "A":U AND AVAILABLE(RowObject) THEN
       DELETE RowObject. 
  END.     /* END FOR EACH */

  /* If this is the server side and the ServerSubmitValidation property
     has been set to *yes*, then we execute that normally client side 
     validation here to make sure that it has been done. */
  IF cASDivision = "Server":U THEN 
  DO:
    {get ServerSubmitValidation lSubmitVal}.
    IF lSubmitVal THEN
    DO:
      
      FOR EACH RowObjUpd WHERE LOOKUP(RowObjUpd.RowMod, "A,C,U":U) NE 0:
        /* Validation procs look at RowObject, so we have to create a row
           temporarily for it to use. This will be deleted below. */
        DO TRANSACTION:
          CREATE RowObject.     
        END.
        BUFFER-COPY RowObjUpd TO RowObject.
        
        cChangedFlds = RowObjUpd.ChangedFields.
        DO iChange = 1 TO NUM-ENTRIES(cChangedFlds):
          ASSIGN cChanged = ENTRY(iChange, cChangedFlds)
                 hRowObjFld = hRowObjUpd:BUFFER-FIELD(cChanged)
                 cChangedVals = cChangedVals +
                   (IF cChangedVals NE "":U THEN CHR(1) ELSE "":U) +
                   cChanged + CHR(1) + STRING(hRowObjFld:BUFFER-VALUE).
        END.    /* END DO iChange */

        /* Now pass the values and column list to the client validation. */
        RUN submitValidation (INPUT cChangedVals, cUpdatable).
        DO TRANSACTION:
          DELETE RowObject. 
        END.
      END.      /* END FOR EACH RowObjUpd */
  
      /* Exit if any error messages were generated. This means that
         all messages associated with the "client" SubmitValidation will
         be accumulated, but the update transaction will not be attempted
         if there are any prior errors. */
      IF anyMessage() THEN
      DO:
        RUN prepareErrorsForReturn(INPUT "":U, INPUT cASDivision, 
                                   INPUT-OUTPUT pocMessages).
        RETURN.
      END.  /* END IF anyMessage */
    END.   /* END DO IF SUbMitVal */
  END.   /* END DO IF Server */

  TRANS-BLK:
  DO TRANSACTION ON ERROR UNDO, LEAVE:
    /* This user-defined validation hook is for code to be executed
       inside the transaction, but before any updates occur. */
    RUN beginTransactionValidate IN THIS-PROCEDURE NO-ERROR. 
    IF NOT ERROR-STATUS:ERROR AND RETURN-VALUE NE "":U THEN
    DO:
      RUN prepareErrorsForReturn(INPUT RETURN-VALUE, INPUT cASDivision, 
                                 INPUT-OUTPUT pocMessages).
      UNDO, RETURN.      /* Bail out if application code rejected the txn. */
    END.   /* END DO IF RETURN-VALUE NE "" */
    
    /* First locate each pre-change record. Find corresponding database record
       and do a buffer-compare to make sure it hasn't been changed. */
    Process-Update-Records-Blk:
    FOR EACH RowObjUpd WHERE RowObjUpd.RowMod = "":U:
        /* For each table in the join, update its fields if on the enabled list.
         NOTE: at present at least we don't check whether fields in this table
         have actually been modified in this record. */
      RUN fetchDBRowForUpdate IN TARGET-PROCEDURE.
      IF RETURN-VALUE NE "":U THEN
      DO:
        RUN addMessage In TARGET-PROCEDURE
          (messageNumber(18), ?, RETURN-VALUE).
        ASSIGN lKillTrans = yes
               pocUndoIds = pocUndoIds + STRING(RowObjUpd.RowNum) + CHR(3) + ",":U.
        UNDO Process-Update-Records-Blk, NEXT Process-Update-Records-Blk.
      END.

      DO:     /* If we didn't bail because record wasn't found, do the update.*/
        /* Check first whether we care if the database record has been
           changed by another user. This is a settable instance property. */
        {get CheckCurrentChanged lCheck}.
        IF lCheck THEN
        DO:
          RUN compareDBRow In TARGET-PROCEDURE.
          IF RETURN-VALUE NE "":U THEN /* Table name that didn't compare is returned. */
          DO:
            RUN addMessage IN TARGET-PROCEDURE
             (SUBSTITUTE(messageNumber(8), '':U /* No field names available. */) , ?, 
              RETURN-VALUE  /* Table name that didn't compare */).
            pocUndoIds = pocUndoIds + STRING(RowObjUpd.RowNum) + CHR(3) + "ADM-FIELDS-CHANGED":U + ",":U.
            /* Get the changed version of the record in order to copy
               the new database values into it to pass back to the client.*/
            FIND bRowObjUpd WHERE bRowObjUpd.RowNum = RowObjUpd.RowNum
                              AND bRowObjUpd.RowMod = "U":U.
            RUN refetchDBRow IN TARGET-PROCEDURE
                  (INPUT BUFFER bRowObjUpd:HANDLE) NO-ERROR.
            IF ERROR-STATUS:ERROR THEN
            DO:
              RUN addMessage IN TARGET-PROCEDURE
                   /* Support return-value from triggers (from RefetchDbRow)*/ 
                   (IF RETURN-VALUE <> '':U THEN RETURN-VALUE ELSE ?, ?, ?).
              lKillTrans = yes.
              pocUndoIds = pocUndoIds + STRING(bRowObjUpd.RowNum) + CHR(3) + ",":U.
            END.  /* If ERROR */
            IF cASDivision = 'Server':U THEN
              pocMessages = LEFT-TRIM(pocMessages + CHR(3) + DYNAMIC-FUNCTION('fetchMessages':U),CHR(3)).
              
            /* Don't try to write values to db. Just process next update record. */
            NEXT Process-Update-Records-Blk.
          END.  /* END DO IF compareDBRow returned a table value */
        END.    /* END DO IF CheckCurrentChanged */
        
        DO:   /* If we haven't 'next'ed because of an error, do the update. */
          /* Now find the changed version of the record, move its fields to the
             database record(s) which were found above, and report any errors
             (which would be database triggers at this point). */
          FIND bRowObjUpd WHERE bRowObjUpd.RowNum = RowObjUpd.RowNum
                          AND   bRowObjUpd.RowMod = "U":U.
          /* Copy the ChangedFields to this buffer too */
          ASSIGN bRowObjUpd.ChangedFields = RowObjUpd.ChangedFields
                 hRowObjUpd               = BUFFER bRowObjUpd:HANDLE.
          RUN assignDBRow IN TARGET-PROCEDURE (INPUT hRowObjUpd).
          IF RETURN-VALUE NE "":U THEN  /* returns table name in error. */
          DO:
            RUN addMessage IN TARGET-PROCEDURE (?, ?, RETURN-VALUE).
            lKillTrans = yes.
            pocUndoIds = pocUndoIds + STRING(RowObjUpd.RowNum) + CHR(3) + ",":U.
            UNDO, NEXT. /* The FOR EACH block is undone and nexted. */
          END.   /* END DO IF RETURN-VALUE NE "" */
          
          /* Pass back the final values to the client. Note - because we
             want to get values changed by the db trigger, we copy *all*
             fields, not just the ones that are enabled in the Data Object. */
          RUN refetchDBRow IN TARGET-PROCEDURE
                (INPUT BUFFER bRowObjUpd:HANDLE) NO-ERROR.
          IF ERROR-STATUS:ERROR THEN
          DO:
            RUN addMessage IN TARGET-PROCEDURE 
                   /* Support return-value from triggers (from RefetchDbRow)*/ 
                  (IF RETURN-VALUE <> '':U THEN RETURN-VALUE ELSE ?, ?, ?).
            lKillTrans = yes.
            pocUndoIds = pocUndoIds + STRING(bRowObjUpd.RowNum) + CHR(3) + ",":U.
          END.  /* if ERROR */
          
          /* Add a record to the ModRowIdent table */
          IF NOT CAN-FIND(FIRST ModRowIdent WHERE
                                ModRowIdent.RowIdentIdx = bRowObjUpd.RowIdentIdx
                                AND
                                ModRowIdent.RowIdent = bRowObjUpd.RowIdent) THEN
          DO:
            CREATE ModRowIdent.
            ASSIGN ModRowIdent.RowIdent = bRowObjUpd.RowIdent
                   ModRowIdent.RowIdentIdx = SUBSTR(bRowObjUpd.RowIdent, 1, xiRocketIndexLimit)
                   .
          END.  /* DO if ModRowIdent is already there */
        END.  /* END DO the update for this row if no error */
      END.  /* END DO if not no-rec-avail */
    END.  /* END FOR EACH RowObjUpd */

    /* This code to handle DELETE operations: */    
    FOR EACH RowObjUpd WHERE RowObjUpd.RowMod = "D":U:
      /* This will procedure will do the Delete (looking at RowMod) */
      RUN fetchDBRowForUpdate IN TARGET-PROCEDURE.
      IF RETURN-VALUE NE "":U THEN
      DO:
        /* fetchDbRowForUpdate will return "Delete" as LAST element of the 
           return-value if the Delete and not the FIND EXCLUSIVE-LOCK failed. */
        IF ENTRY(NUM-ENTRIES(RETURN-VALUE),RETURN-VALUE) = "Delete":U THEN
        DO:
          IF NUM-ENTRIES(RETURN-VALUE) = 2 THEN
            cDeleteMsg = messageNumber(23).
          ELSE /* support return-value from triggers */
            ASSIGN 
              cDeleteMsg = RETURN-VALUE 
              ENTRY(NUM-ENTRIES(cDeleteMsg),cDeleteMsg) = "":U
              ENTRY(1,cDeleteMsg) = "":U
              cDeleteMsg = TRIM(cDeleteMsg,",":U).
        END. /* if entry(num-entries(return-value) = 'delete' */ 
        ELSE /* locked record */
          cDeleteMsg = messageNumber(18).
        RUN addMessage IN TARGET-PROCEDURE
              (cDeleteMsg, ?, ENTRY(1,RETURN-VALUE)).
        ASSIGN lKillTrans = yes
               pocUndoIds = pocUndoIds + STRING(RowObjUpd.RowNum) + CHR(3) + ",":U.
      END.      /* END DO IF RETURN-VALUE NE "" */
    END.        /* END FOR EACH block */

    /* This code to handle ADD/COPY operations: */
    FOR EACH RowObjUpd WHERE RowObjUpd.RowMod = "A":U OR
                             RowObjUpd.RowMod = "C":U:  
      /* This procedure will do the record Create (looking at RowMod) */
      RUN assignDBRow IN TARGET-PROCEDURE (INPUT BUFFER RowObjUpd:HANDLE).
      IF RETURN-VALUE NE "":U THEN  /* returns table name in error. */
      DO:
        /* If the add failed, clear the rowident field because the rowid 
           assigned to it after the BUFFER-CREATE in assignDBRow is now invalid 
           due to the failure. */
        ASSIGN RowObjUpd.RowIdent = "" RowObjUpd.RowIdentIdx = "".
        /* If BUFFER-CREATE faile because of a CREATE trigger we add return-value
           before the table name, otherwise set the first parameter of addMessage
           to ? to retireve errors from error-status */
        RUN addMessage IN TARGET-PROCEDURE                                  
                        (IF NUM-ENTRIES(RETURN-VALUE,CHR(3)) > 1                 
                         THEN ENTRY(1,RETURN-VALUE,CHR(3))                           
                         ELSE ?,                                                   
                         ?,                                                        
                         ENTRY(NUM-ENTRIES(RETURN-VALUE, CHR(3)),RETURN-VALUE,CHR(3))       
                         ).                                                        
        lKillTrans = yes.
        pocUndoIds = pocUndoIds + STRING(RowObjUpd.RowNum) + CHR(3) + ",":U.
        UNDO, NEXT. /* The FOR EACH block is undone and nexted. */
      END.    /* END DO IF ERROR-STATUS:ERROR OR cErrorMsgs NE "":U */
      
      /* Pass back the final values to the client. Note - because we
         want to get values changed by the db trigger, we copy *all*
         fields, not just the ones that are enabled in the Data Object. */
      RUN refetchDBRow In TARGET-PROCEDURE
        (INPUT BUFFER RowObjUpd:HANDLE) NO-ERROR.      
      /* if a database trigger returns error it will be catched here */
      IF ERROR-STATUS:ERROR THEN
      DO:
        lKillTrans = yes.
        pocUndoIds = pocUndoIds + STRING(RowObjUpd.RowNum) + CHR(3) + ",":U.
        RUN addMessage IN TARGET-PROCEDURE 
            /* Support return-value from triggers (from RefetchDbRow)*/ 
            (IF RETURN-VALUE <> '':U THEN RETURN-VALUE ELSE ?, ?, ?).
        UNDO, NEXT. /* The FOR EACH block is undone and nexted. */
      END.

      /* Add a record to the ModRowIdent table */
      IF NOT CAN-FIND(FIRST ModRowIdent WHERE
                            ModRowIdent.RowIdentIdx = RowObjUpd.RowIdentIdx
                            AND
                            ModRowIdent.RowIdent = RowObjUpd.RowIdent) THEN
      DO:
        CREATE ModRowIdent.
        ASSIGN ModRowIdent.RowIdent = RowObjUpd.RowIdent
               ModRowIdent.RowIdentIdx = SUBSTR(RowObjUpd.RowIdent, 1, xiRocketIndexLimit)
               .
      END.  /* DO if ModRowIdent is already there */        
    END.  /* END FOR EACH block for Adds. */

    /* If errors of any kind, undo the transaction and leave. */
    IF pocUndoIds NE "":U OR lKillTrans THEN
      UNDO Trans-Blk, LEAVE Trans-Blk.

    /* This user-defined validation hook is for code to be executed
       inside the transaction, but after all updates occur. */
    RUN endTransactionValidate IN THIS-PROCEDURE NO-ERROR. 
    IF NOT ERROR-STATUS:ERROR AND RETURN-VALUE NE "":U THEN
    DO:
      RUN prepareErrorsForReturn(INPUT RETURN-VALUE, INPUT cASDivision, 
                                 INPUT-OUTPUT pocMessages).
      UNDO, RETURN.     /* Bail out if application code rejected the txn. */
    END.   /* END DO IF RETURN-VALUE NE "" */
  END.          /* END transaction block. */ 
  
  /* RELEASE the database record(s). */
  RUN releaseDBRow IN TARGET-PROCEDURE.
  
  /* Add a message to indicate the update has been cancelled. */
  IF pocUndoIds NE "":U OR lKillTrans THEN
    RUN addMessage IN TARGET-PROCEDURE (messageNumber(15),?,?).
  
&ENDIF          /* ENDIF QUERY defined */
  
  /* This user-defined validation hook is for code to be executed
     outside the transaction, after all updates occur. */
  IF NOT lQueryContainer THEN
  DO:
    RUN postTransactionValidate IN THIS-PROCEDURE NO-ERROR. 
    IF NOT ERROR-STATUS:ERROR AND RETURN-VALUE NE "":U THEN
    DO:
      RUN prepareErrorsForReturn(INPUT RETURN-VALUE, INPUT cASDivision, 
                                 INPUT-OUTPUT pocMessages).
      RETURN.      /* Bail out. */
    END.   /* END DO IF RETURN-VALUE NE "" */
  END.       /* END DO IF Container (SBO) is not doing the commit for us. */
        
    /* If we're not on an AppServer, the messages will be available to the
     caller, so don't "fetch" them (which would also delete them). */
  RUN prepareErrorsForReturn(INPUT RETURN-VALUE, INPUT cASDivision, 
                             INPUT-OUTPUT pocMessages).
  RETURN.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-serverSendRows) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE serverSendRows Method-Library 
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
 DEFINE OUTPUT PARAMETER TABLE          FOR RowObject.
 
 RUN sendRows IN TARGET-PROCEDURE (piStartRow, pcRowIdent, plNext,
   piRowsToReturn, OUTPUT piRowsReturned).
 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-canFindModRow) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION canFindModRow Method-Library 
FUNCTION canFindModRow RETURNS LOGICAL
  ( pcRowIdent AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:     Looks up a rowIdent value in the ModRowIdent temp-table and 
               returns TRUE if it is found or false if is isn't.
  
  Parameters:  pcRowIdent - The RowIdent value to look up.
------------------------------------------------------------------------------*/
RETURN CAN-FIND(FIRST ModRowIdent WHERE 
                                  ModRowIdent.RowIdentIdx = SUBSTRING(pcRowIdent, 1, xiRocketIndexLimit)
                                  AND
                                  ModRowIdent.RowIdent = pcRowIdent).

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-commit) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION commit Method-Library 
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
  DEFINE VARIABLE iRowNum         AS INTEGER   NO-UNDO.
  DEFINE VARIABLE iCnt            AS INTEGER   NO-UNDO.
  DEFINE VARIABLE cUndoIds        AS CHARACTER NO-UNDO.
  DEFINE VARIABLE hAppServer      AS HANDLE    NO-UNDO.
  DEFINE VARIABLE cMessages       AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cASDivision     AS CHARACTER NO-UNDO.
  DEFINE VARIABLE lBrowsed        AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE cContext        AS CHARACTER NO-UNDO.
  DEFINE VARIABLE iFirstUndoId    AS INTEGER   NO-UNDO.
  DEFINE VARIABLE iUndoId         AS INTEGER   NO-UNDO.
  
  /* Transfer modified and added rows to the update table. */
  RUN doBuildUpd. 
  
  /* If we're running across an AppServer connection, run serverCommit
     in that other object. Otherwise just run it in ourself. */
  {get ASDivision cASDivision}.
  IF cASDivision = 'Client':U THEN
    {get ASHandle hAppServer}.
  ELSE hAppServer = THIS-PROCEDURE.
  
  RUN serverCommit in hAppServer
    (INPUT-OUTPUT TABLE RowObjUpd, OUTPUT cMessages, OUTPUT cUndoIds).
  
 /* unbind if stateless  */ 
  RUN endClientDataRequest IN TARGET-PROCEDURE.
  
  /* If we're running with a separate AppServer DataObject, then we must
     append any error messages returned to the message log. Otherwise they
     are already there. */
  IF cASDivision = 'Client':U AND cMessages NE "" THEN
    RUN addMessage IN TARGET-PROCEDURE (cMessages, ?, ?).

  /* Return any rows to the client that have been changed by the server. */
  RUN doReturnUpd (INPUT cUndoIds).
  
  RETURN NOT anyMessage().  /* return success if no error msgs. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

