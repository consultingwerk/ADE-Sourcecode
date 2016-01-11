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
    File        : dataextapi.p
    Purpose     : Support procedure for Data Object open client API.  
                  This is an extension of data.p, mainly to avoid that 
                  the ecode segment becomes too large, but this 
                  Open Client API can be skipped if not used 
                  (on client and normal appserver)     
    Syntax      : adm2/dataextapi.p
------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* Tell dataprop.i that this is the Super procedure */
  &SCOP ADMSuper dataextapi.p

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-findForCommit) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD findForCommit Procedure 
FUNCTION findForCommit RETURNS LOGICAL PRIVATE
  (pcColumns     AS CHARACTER,   
   pcValues      AS CHARACTER,    
   pcOperators   AS CHARACTER) FORWARD.

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

&IF DEFINED(EXCLUDE-createData) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE createData Procedure 
PROCEDURE createData :
/*------------------------------------------------------------------------------
  Purpose:     Create a record 
  Parameters:  
  Notes:       This is the Open Client API create
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
 DEFINE VARIABLE cDataReadFormat   AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cLargeColumns     AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE iLookup           AS INTEGER    NO-UNDO.

 DYNAMIC-FUNCTION("addRow":U IN TARGET-PROCEDURE,"":U).
 
 &SCOPED-DEFINE xp-assign
 {get DataReadFormat cDataReadFormat}
 {get DataDelimiter cDataDelimiter}
 {get RowObject hRowObject}
 {get UpdatableColumns cUpdatableColumns}
 {get LargeColumns cLargeColumns}
 .
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
 
 DO iloop = 1 TO NUM-ENTRIES(cLargeColumns):
   ASSIGN
     cColumn = ENTRY(iLoop,cLargeColumns)
     iLookup = LOOKUP(cColumn,pcColumnNames).
   IF iLookup > 0 THEN
     ENTRY(iLookup,pcColumnNames) = 'SKIP':U.
 END.

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

&IF DEFINED(EXCLUDE-deleteData) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE deleteData Procedure 
PROCEDURE deleteData :
/*------------------------------------------------------------------------------
  Purpose:     Delete a record 
  Parameters:  
  Notes:       This is the Open Client API delete
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
   ASSIGN 
     cKeyFields = 'RowObject.RowIdent'
     cKeyValues = ENTRY(iField,pcOldValues,cDataDelimiter). 
 END.

 {get RowObject hRowObject}.
 
 lFound = DYNAMIC-FUNCTION('findForCommit':U IN TARGET-PROCEDURE,
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

&IF DEFINED(EXCLUDE-updateData) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE updateData Procedure 
PROCEDURE updateData :
/*------------------------------------------------------------------------------
  Purpose:    Update a record 
  Parameters:  
  Notes:       This is the Open Client API for update 
------------------------------------------------------------------------------*/
 DEFINE INPUT         PARAMETER pcUpdateColumnNames AS CHARACTER  NO-UNDO.
 DEFINE INPUT         PARAMETER pcOldValues   AS CHARACTER  NO-UNDO.
 DEFINE INPUT-OUTPUT  PARAMETER pcNewValues   AS CHARACTER  NO-UNDO.
 DEFINE OUTPUT        PARAMETER pcError       AS CHARACTER  NO-UNDO.

 DEFINE VARIABLE cKeyFields        AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cKeyValues        AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cNewValueList     AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cLargeColumns AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE iLoop             AS INTEGER    NO-UNDO.
 DEFINE VARIABLE iField            AS INTEGER    NO-UNDO.
 DEFINE VARIABLE cKey              AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cValue            AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cNewValue         AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cOldValue         AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cDataDelimiter    AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE lFoundOnClient    AS LOGICAL    NO-UNDO.
 DEFINE VARIABLE hRowObject        AS HANDLE     NO-UNDO.
 DEFINE VARIABLE hCol              AS HANDLE     NO-UNDO.
 DEFINE VARIABLE lReopen           AS LOGICAL    NO-UNDO.
 DEFINE VARIABLE lCreated          AS LOGICAL    NO-UNDO.
 DEFINE VARIABLE lSave             AS LOGICAL    NO-UNDO.
 DEFINE VARIABLE lNoKeyFields      AS LOGICAL    NO-UNDO.
 DEFINE VARIABLE cColumn           AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cChangedColumns   AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cChangedValues    AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cDataReadFormat   AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE iLookup           AS INTEGER    NO-UNDO.
 DEFINE VARIABLE lFound            AS LOGICAL    NO-UNDO.
 DEFINE VARIABLE lChanged          AS LOGICAL    NO-UNDO.
 DEFINE VARIABLE cLargeError       AS CHARACTER  NO-UNDO.

 &SCOPED-DEFINE xp-assign
 {get KeyFields cKeyFields}
 {get DataDelimiter cDataDelimiter}
 {get DataReadFormat cDataReadFormat}
 {get LargeColumns cLargeColumns}
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
   ASSIGN
     cKeyFields = 'RowObject.RowIdent'
     cKeyValues = ENTRY(iField,pcOldValues,cDataDelimiter).   
 END.
 
 {get RowObject hRowObject}.

 lFound = DYNAMIC-FUNCTION('findForCommit':U IN TARGET-PROCEDURE,
                           cKeyFields,
                           cKeyValues,
                           '=':U).

 IF lFound THEN
 DO:
   DO iLoop = 1 TO NUM-ENTRIES(pcUpdateColumnNames):
     ASSIGN
       lchanged = FALSE
       hCol     = ?
       cColumn  = ENTRY(iLoop,pcUpdateColumnNames) 
       hCol     = hRowObject:BUFFER-FIELD(cColumn) NO-ERROR.
     IF VALID-HANDLE(hCol) THEN
     DO:
       ASSIGN
         cOldValue   = ENTRY(iLoop,pcOldValues,cDataDelimiter)
         cNewValue   = ENTRY(iLoop,pcNewValues,cDataDelimiter)
         cLargeError = ''.     
       
       IF CAN-DO(cLargeColumns,cColumn) THEN
       DO:
         IF cOldValue <> cNewValue THEN
         DO:
           /* copy the large object value to the old buffer-field */
           cLargeError = DYNAMIC-FUNCTION('assignBufferValueFromReference':U IN TARGET-PROCEDURE,
                                           hCol,
                                           cOldValue).
           
           IF cLargeError > '' THEN
           DO:
             pcError = SUBSTITUTE({fnarg messageNumber 94}, hCol:LABEL, cLargeError). 
             RETURN.                      
           END.     
           lChanged = TRUE.
         END.
       END.
       ELSE  DO:
         /* We do not assign the before image value to the RowObject if 
            the b-i value is similar to the formatted value, but the buffer-value 
            is not. This avoids error from the optimistic lock check in cases where 
            formatting has sent a different value out than really stored */                 
         IF hCol:STRING-VALUE = hCol:BUFFER-VALUE OR cOldValue <> hCol:STRING-VALUE THEN
            hCol:BUFFER-VALUE = cOldValue. 

         lChanged = COMPARE(cOldValue,'NE':U,cNewValue,'RAW':U).          

       END.
       IF lChanged THEN 
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

 DO iloop = 1 TO NUM-ENTRIES(cLargeColumns):
   ASSIGN
     cColumn = ENTRY(iLoop,cLargeColumns)
     iLookup = LOOKUP(cColumn,pcUpdateColumnNames).
   IF iLookup > 0 THEN
     ENTRY(iLookup,pcUpdateColumnNames) = 'SKIP':U.
 END.

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

/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-findForCommit) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION findForCommit Procedure 
FUNCTION findForCommit RETURNS LOGICAL PRIVATE
  (pcColumns     AS CHARACTER,   
   pcValues      AS CHARACTER,    
   pcOperators   AS CHARACTER):
/*------------------------------------------------------------------------------   
Purpose: Find the record for commit puropses.
         This is a private API and subject to change. There is chance that this API
         will be merged with findRowInCurrentBatch in the later release.

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
  Notes: 
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
  DEFINE VARIABLE lRebuild        AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE iRowsToBatch    AS INTEGER    NO-UNDO.
  
  &SCOPED-DEFINE xp-assign
  {get FirstResultrow cFirstResultRow}
  {get LastResultrow cLastResutlRow}
  {get FirstRowNum iFirstRowNum}
  {get LastRowNum iLastRowNum}
  {get RowsToBatch iRowsToBatch}
  {get RebuildOnRepos lRebuild}
  
  {set FirstResultrow ?}
  {set LastResultrow ?}
  {set FirstRowNum ?}
  {set LastRowNum ?}
    
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

