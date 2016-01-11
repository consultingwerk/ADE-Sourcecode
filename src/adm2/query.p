&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/**********************************************************************************/
/* Copyright (C) 2005-2007,2014 by Progress Software Corporation. All rights reserved. */
/* Prior versions of this work may contain portions contributed by                */
/* participants of Possenet.                                                      */             
/**********************************************************************************/
/*--------------------------------------------------------------------------
    File        : query.p
    Purpose     : Super procedure for ADM objects which retrieve data from
                  database tables.
    Syntax      : adm2/query.p
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
  /* Tell qryprop.i that this is the query super procedure. */
&SCOP ADMSuper query.p

/* Query core limitations used to define extents in logic */                                                    
&SCOPED-DEFINE MaxTables 18  /* core limit on number of joins */
&SCOPED-DEFINE MaxBreaks 16  /* core limit on number of BY  */

&SCOPED-DEFINE ReposRowNum 2000000

{src/adm2/custom/queryexclcustom.i}


/* allow for override of prefix for calculation functions */ 
&IF DEFINED(calculateprefix) = 0 &THEN
   &SCOPED-DEFINE calculateprefix Calculate
&ENDIF
/* This variable is needed at least temporarily in 9.1B/C so that a called
   fn can tell who the actual source was. */
   DEFINE VARIABLE ghTargetProcedure AS HANDLE     NO-UNDO.

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

&IF DEFINED(EXCLUDE-addNotFoundMessage) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD addNotFoundMessage Procedure 
FUNCTION addNotFoundMessage RETURNS LOGICAL
  ( pcFields AS CHAR,
    pcValues AS CHAR,
    pcOperators AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-addQueryWhere) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD addQueryWhere Procedure 
FUNCTION addQueryWhere RETURNS LOGICAL
  (pcWhere  AS CHARACTER,
   pcBuffer AS cHARACTER,
   pcAndOr  AS CHARACTER) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-bufferCompareDBToRO) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD bufferCompareDBToRO Procedure 
FUNCTION bufferCompareDBToRO RETURNS LOGICAL
  ( INPUT phRowObjUpd AS HANDLE,
    INPUT phBuffer    AS HANDLE,
    INPUT pcExcludes  AS CHARACTER,
    INPUT pcAssigns   AS CHARACTER )  FORWARD.

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

&IF DEFINED(EXCLUDE-bufferExclusiveLock) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD bufferExclusiveLock Procedure 
FUNCTION bufferExclusiveLock RETURNS LOGICAL PRIVATE
  ( pcBuffer     as character,
    pcMode       as character)  FORWARD.

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

&IF DEFINED(EXCLUDE-bufferRowident) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD bufferRowident Procedure 
FUNCTION bufferRowident RETURNS CHARACTER
  ( phBuffer as handle)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-checkReadOnlyAvailOnDelete) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD checkReadOnlyAvailOnDelete Procedure 
FUNCTION checkReadOnlyAvailOnDelete RETURNS LOGICAL
        (  ) FORWARD.

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

&IF DEFINED(EXCLUDE-columnDataType) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD columnDataType Procedure 
FUNCTION columnDataType RETURNS CHARACTER
  (pcColumn AS CHAR) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnDbColumn) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD columnDbColumn Procedure 
FUNCTION columnDbColumn RETURNS CHARACTER
  (pcColumn AS CHAR) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnPhysicalColumn) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD columnPhysicalColumn Procedure 
FUNCTION columnPhysicalColumn RETURNS CHARACTER
  (pcColumn AS CHAR) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnPhysicalTable) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD columnPhysicalTable Procedure 
FUNCTION columnPhysicalTable RETURNS CHARACTER
  (pcColumn AS CHAR) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnProps) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD columnProps Procedure 
FUNCTION columnProps RETURNS CHARACTER
  ( pcColList AS CHARACTER, pcPropList AS CHARACTER )  FORWARD.

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

&IF DEFINED(EXCLUDE-columnTable) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD columnTable Procedure 
FUNCTION columnTable RETURNS CHARACTER
  (pcColumn AS CHAR) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnValMsg) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD columnValMsg Procedure 
FUNCTION columnValMsg RETURNS CHARACTER
  (pcColumn AS CHAR) FORWARD.

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

&IF DEFINED(EXCLUDE-createBuffer) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD createBuffer Procedure 
FUNCTION createBuffer RETURNS HANDLE
  ( pcBuffer AS CHAR,
    pcPhysicalName AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-dbColumnDataName) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD dbColumnDataName Procedure 
FUNCTION dbColumnDataName RETURNS CHARACTER
  (pcDbColumn AS CHAR) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-dbColumnHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD dbColumnHandle Procedure 
FUNCTION dbColumnHandle RETURNS HANDLE
  (pcColumn AS CHAR) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-defineDataObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD defineDataObject Procedure 
FUNCTION defineDataObject RETURNS LOGICAL
  ( pcTableList AS CHARACTER,
    pcBaseQuery AS CHARACTER,
    pcColumnList AS CHARACTER,
    pcUpdatableColumns AS CHARACTER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-excludeColumns) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD excludeColumns Procedure 
FUNCTION excludeColumns RETURNS CHARACTER
  (iTable AS INTEGER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-firstBufferName) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD firstBufferName Procedure 
FUNCTION firstBufferName RETURNS CHARACTER PRIVATE
  (pcExpression AS CHAR)  /* expression */  FORWARD.

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

&IF DEFINED(EXCLUDE-newQuerySort) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD newQuerySort Procedure 
FUNCTION newQuerySort RETURNS CHARACTER
  ( pcQuery       AS CHAR,
    pcSort        AS CHAR,
    plDBColumns   AS LOG)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-newQueryValidate) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD newQueryValidate Procedure 
FUNCTION newQueryValidate RETURNS CHARACTER
   (pcQueryString AS CHAR,
    pcExpression  AS CHAR,
    pcBuffer      AS CHAR,
    pcAndOr       AS CHAR) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-newQueryWhere) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD newQueryWhere Procedure 
FUNCTION newQueryWhere RETURNS CHARACTER
  ( pcWhere AS CHAR)  FORWARD.

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

&IF DEFINED(EXCLUDE-prepareQuery) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD prepareQuery Procedure 
FUNCTION prepareQuery RETURNS LOGICAL
  (pcQuery AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-refreshRowident) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD refreshRowident Procedure 
FUNCTION refreshRowident RETURNS CHARACTER
  ( pcRowident AS CHAR)  FORWARD.

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

&IF DEFINED(EXCLUDE-resetQueryString) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD resetQueryString Procedure 
FUNCTION resetQueryString RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

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

&IF DEFINED(EXCLUDE-rowidWhere) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD rowidWhere Procedure 
FUNCTION rowidWhere RETURNS CHARACTER
  (pcWhere AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-rowidWhereCols) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD rowidWhereCols Procedure 
FUNCTION rowidWhereCols RETURNS CHARACTER
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
         HEIGHT             = 18.42
         WIDTH              = 58.86.
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


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-assignDBRow) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE assignDBRow Procedure 
PROCEDURE assignDBRow :
/*------------------------------------------------------------------------------
  Purpose:     Copies modified values from the RowObject row to the database
               records (which for an Update have already been retrieved 
               and locked).
               If the RowMod field is "A" for Add or "C" for Copy, the procedure
               creates the database record(s) first and then does the assign.
  Parameters:  phRowObjUpd - handle of the buffer to copy from.
  Notes:       The procedure only saves fields whose values were modified.
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER phRowObjUpd  AS HANDLE    NO-UNDO.
  
  DEFINE VARIABLE hRowBefore         AS HANDLE    NO-UNDO.
  DEFINE VARIABLE cUpdColumnsByTable AS CHARACTER NO-UNDO.
  DEFINE VARIABLE hRowUpdFld         AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hRowOldFld         AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hDBField           AS HANDLE    NO-UNDO.
  DEFINE VARIABLE iField             AS INTEGER   NO-UNDO.
  DEFINE VARIABLE iTable             AS INTEGER   NO-UNDO.
  DEFINE VARIABLE cFromField         AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cToField           AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cTables            AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cBuffers           AS CHARACTER NO-UNDO.
  DEFINE VARIABLE hBuffer            AS HANDLE    NO-UNDO.
  DEFINE VARIABLE cAssignList        AS CHARACTER NO-UNDO.
  DEFINE VARIABLE iAssigns           AS INTEGER   NO-UNDO.
  DEFINE VARIABLE lColumnChanged     AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE iBracket           AS INTEGER   NO-UNDO.
  DEFINE VARIABLE iExtent            AS INTEGER   NO-UNDO.
  DEFINE VARIABLE cRowIdent          AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cRowid             AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cExclude           AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cUpdColumns        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cColumnsByTable    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cColumns           AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lChanged           AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cNotChanged        AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cAssignFields      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cUseAssignFields   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDataColumns       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lAmbiguous         AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lCreate            AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lLarge             AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cLargeList         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iLarge             AS INTEGER    NO-UNDO.
  /* This procedure RETURNs immediately on an error, so at least ensure the code
     is the same..  This is difficult to change since this may be overridden 
     by customized code. Note that ERROR-STATUS need to be intact for caller..      
     The caller needs it !*/  
  &SCOP cleanup ~
    IF VALID-HANDLE(hRowBefore) THEN DELETE OBJECT hRowBefore.
  /* end preprocessor -------- */
  
  lCreate = phRowObjUpd:BUFFER-FIELD('RowMod':U):BUFFER-VALUE <> "U":U.
  /* get the 'before' record if this is an Update... */
  IF NOT lCreate THEN
  DO:
    CREATE BUFFER hRowBefore FOR TABLE phRowObjUpd.
    hRowBefore:FIND-FIRST('WHERE RowMod = "" AND RowNum = ':U +
                          STRING(phRowObjUpd:BUFFER-FIELD('RowNum':U):BUFFER-VALUE)).
  END.
  
  &SCOPED-DEFINE xp-assign
  {get UpdatableColumnsByTable cUpdColumnsByTable}
  {get DataColumnsByTable cColumnsByTable}
  {get DataColumns cDataColumns}
  {get BufferHandles cBuffers}  
  {get Tables cTables}          
  {get AssignList cAssignList}  
  .
  &UNDEFINE xp-assign
  DO iTable = 1 TO NUM-ENTRIES(cBuffers):
    ASSIGN
      hBuffer       = WIDGET-HANDLE(ENTRY(iTable, cBuffers))
      cExclude      = {fnarg excludeColumns iTable}
      cAssignFields = ENTRY(iTable, cAssignList, {&adm-tabledelimiter})
      cUpdColumns   = ENTRY(iTable,cUpdColumnsByTable, {&adm-tabledelimiter})
      cColumns      = ENTRY(iTable,cColumnsByTable, {&adm-tabledelimiter})
      cLargeList    = '':U
      cNotChanged   = '':U.
 
    IF cUpdColumns NE "":U THEN
    DO: 
      /* If this is an Add or a Copy then create the DB records first. */
      IF lCreate THEN
      DO:
        /* do on error to trap CREATE triggers that return ERROR */
        DO ON ERROR UNDO, LEAVE:
          lCreate = hBuffer:BUFFER-CREATE(). 
        END.
        /* Regular errors like sequences out of sequence may happen, but we 
           do support RETURN ERROR cMessages + "my-error-message" for create triggers.... 
           addMessage with unknown as the indicator to use error-status */    
        IF NOT lCreate THEN
        DO:
          {&cleanup}  /* delete dummy add rec and b-i handle */
          /* Return return-value and append  table as last CHR(3) entry */
          RETURN RETURN-VALUE 
                 + (IF RETURN-VALUE = '':U THEN '':U ELSE CHR(3))
                 + ENTRY(iTable, cTables).                                   
        END.
      END.  /* New record */   
      
      /* Build list of non-updatable and unchanged columns to use as 
         EXCEPT parameter to BUFFER-COPY */ 
      DO iField = 1 TO NUM-ENTRIES(cColumns):
        cFromField = ENTRY(iField,cColumns).
        IF LOOKUP(cFromField,cUpdColumns) > 0 THEN
        DO:
          ASSIGN
            hRowUpdFld = phRowObjUpd:BUFFER-FIELD(cFromField).
            lLarge     = CAN-DO('CLOB,BLOB':U,hRowUpdFld:DATA-TYPE).
          /* Compare with before image if this is an update */
          IF NOT lCreate THEN
          DO:
            ASSIGN
              hRowOldFld = hRowBefore:BUFFER-FIELD(cFromField).
            IF hRowUpdFld:DATA-TYPE = 'CLOB':U THEN 
              lChanged = DYNAMIC-FUNCTION('compareClobValues':U IN TARGET-PROCEDURE,
                                           hRowUpdFld,
                                           '<>':U,
                                           hRowOldFld,
                                           'RAW':U).
            ELSE IF hRowUpdFld:DATA-TYPE = 'CHARACTER':U THEN
              lChanged = COMPARE(hRowUpdFld:BUFFER-VALUE, 
                                 '<>':U, 
                                 hRowOldFld:BUFFER-VALUE, 
                                'RAW':U).
            ELSE
              lChanged = hRowUpdFld:BUFFER-VALUE <> hRowOldFld:BUFFER-VALUE.
          END.
          /* New records are compared with Default-string of the db field 
             We cannot copy all updatable columns, create trigger changes 
             wins if field is unchanged (old behavior!)  */
          ELSE 
          DO:
            /* If RowObject and db column name mapping is in the assignFields.
              (avoid call to mappedentry if possible.. function is expensive)  */
            IF cAssignFields <> '':U AND LOOKUP(cFromField,cAssignFields) > 0 THEN
              ASSIGN
                cToField  = DYNAMIC-FUNCTION('mappedEntry':U IN TARGET-PROCEDURE, 
                                cFromField,
                                cAssignFields, /* Assign list for one table */
                                TRUE,    /* lookup first, return second */
                                ",":U /* delimiter */ )
                /* cTofield is ? if not mapped  */
                cToField  = IF cToField <> ? THEN cToField ELSE cFromField
                iBracket  = INDEX(cToField, '[':U)
                iExtent   = IF iBracket > 0
                            THEN INT(SUBSTR(cToField, iBracket + 1,
                                     INDEX(cToField,']':U) - iBracket - 1))
                            ELSE 0
                cToField  = IF iBracket > 0 
                            THEN SUBSTR(cToField, 1, iBracket - 1)
                            ELSE cToField
                .
            
            ELSE 
              ASSIGN
                iExtent  = 0 
                cToField = cFromField
                .
       
            ASSIGN
              hDBField = hBuffer:BUFFER-FIELD(cToField)
              /* Check for changes by comparing save value and default-string.
                 We also save unchanged unknown values (when saved value, 
                 default-string and actual value all are unknown) in order 
                 to capture potential mandatory field errors. (the db value
                 is checked so that a trigger value can be kept).     
                 The BUFFER-RELEASE NO-ERROR (also tested buffer-validate) 
                 that otherwise will trigger this error does not suppress 
                 mandatory field messages... */
              lChanged = IF  hRowUpdFld:BUFFER-VALUE = ?
                         AND hDbField:DEFAULT-STRING = ?
                         AND hDbField:BUFFER-VALUE(iExtent) = ? 
                         THEN TRUE
                         /* LOBs cannot have default value, 
                            so any value means changed */ 
                         ELSE IF CAN-DO('CLOB,BLOB':U,hRowUpdFld:DATA-TYPE) 
                         THEN LENGTH(hRowUpdFld:BUFFER-VALUE) > 0
                         ELSE IF hRowUpdFld:DATA-TYPE = 'CHARACTER':U 
                         THEN COMPARE(hRowUpdFld:BUFFER-VALUE, 
                                      '<>':U, 
                                      hDbField:DEFAULT-STRING, 
                                     'RAW':U) 
                         /* default-string includes decimals, buffer-value does not */ 
                         ELSE IF hRowUpdFld:DATA-TYPE = 'DECIMAL':U 
                         THEN hRowUpdFld:BUFFER-VALUE <> DEC(hDbField:DEFAULT-STRING)
                         ELSE IF hRowUpdFld:DATA-TYPE = 'DATE':U 
                              AND hDbField:DEFAULT-STRING = 'TODAY':U 
                         THEN hRowUpdFld:BUFFER-VALUE <> TODAY
                         /* Raw cannot have INITIAL, so just check From value */ 
                         ELSE IF hRowUpdFld:DATA-TYPE = 'RAW':U 
                         THEN hRowUpdFld:BUFFER-VALUE <> ? 
                         /* in all other cases buffer-value and default-string 
                            can be compared directly 
                            (this includes datatime NOW is never NOW) */ 
                         ELSE hRowUpdFld:BUFFER-VALUE <> hDbField:DEFAULT-STRING
              .
         
          END. /* else ( NEW record) */

        END.
        ELSE 
          lChanged = FALSE.  
        /* The NotChanged list will be passed as EXCEPT to the BUFFER-COPY 
           Fromfield will be replaced by ToField if necessary when looping 
           through the assignFields later */ 
        IF NOT lChanged THEN
          cNotChanged = cNotChanged 
                      + (IF cNotChanged = '':U THEN '':U ELSE ',':U)
                      + cFromField.
       
       /* Keep track of changed LOBs in order to update separate as 
          they cannot be undone in subtrans */ 
        ELSE IF lLarge THEN 
          ASSIGN  /* don't trim; loop below expects blanks */
            cLargeList = cLargeList + ',' + cFromField.
      END. /* Updatabale column loop */

      /* Loop through the field mappings in order to assign directly 
         and in order to rename entries that are in the notchanged list
         and remove them from the assignlist.
         We use two variables; UseAssignFields is being changed while 
         AssignFields remain unchanged in order to be looped thru */ 
      cUseAssignFields = cAssignFields.
      DO iField = 1 TO NUM-ENTRIES(cAssignFields) BY 2:
        ASSIGN
          cFromField     = ENTRY(iField,cAssignFields)
          cToField       = ENTRY(iField + 1,cAssignFields)
          /* Is the FromField changed */
          lColumnChanged = LOOKUP(cFromField,cNotChanged) = 0
          /* is this a mapping to an extent */
          iBracket       = INDEX(cToField, '[':U).

        /* The mapping is ambiguous if both the TO and FROM exists in opposite 
           buffers. The third parameter to BUFFER-COPY does not handle this
          (May be a theoretical problem, may very well fail on read) */ 
        ASSIGN  /* use no-error as we expect error.. */
          lAmbiguous = LOOKUP(cToField,cDataColumns) > 0
                       AND VALID-HANDLE(hBuffer:BUFFER-FIELD(cFromField)) NO-ERROR.  
        
        /* If not changed or if assigned directly below then remove the fields 
           from the assignlist that will be used in buffer-copy. */ 
        IF NOT lColumnChanged OR iBracket > 0 OR lAmbiguous THEN
          cUseAssignFields = TRIM(REPLACE(",":U + cUseAssignFields + ",":U,
                                          ",":U + cFromField + ",":U + cToField + ",":U,
                                          ",":U),
                                          ",":U). 
        /* If bracket then remove the bracket from the Tofield for inclusion 
           in buffer-copy params or for buffer-field(<ToField>) and find the 
           extent for buffer-value  */
        IF iBracket > 0 THEN
          ASSIGN
            iExtent    = INT(SUBSTR(cToField, iBracket + 1,
                                  INDEX(cToField,']':U) - iBracket - 1))
            cToField   = SUBSTR(cToField, 1, iBracket - 1).
        ELSE 
          iExtent = 0. 
          
        /* If Not Changed or if assigned directly below then add fields 
           to the not changed list */
        IF NOT lColumnChanged OR iBracket > 0 OR lAmbiguous THEN
        DO:
          /* We need both fields in the exclude list to ensure that the tofield
             is not assigned from another rowobject field with the same name 
             and to ensure that the fromfield is not assigned to a db field with 
             the same name  (The assignFields could in fact always be in the 
             excludeList, since the buffer-copy assignList always ignores 
             anything in the exclude list, but since we need to remove arrays 
             we may as well do it this way)
             The check to avoid duplicate entries here is likely to be overkill 
             as buffer-copy probably handles multiple entries with less overhead*/ 
          IF LOOKUP(cToField,cNotChanged) = 0 THEN 
            /* This will also add extent fields to the exclude list, but that is 
               actually a safe guard even if the RowObject does not support them 
              (The RowObject may have been defined LIKE a table to workaround 
               size limitation)*/ 
             cNotChanged = cNotChanged 
                         + (IF cNotChanged = '':U THEN '':U ELSE ',':U)
                         + cToField.
          /* If bracket or ambiguous.. ensure from field is excluded */
          IF LOOKUP(cFromField,cNotChanged) = 0 THEN 
            cNotChanged = cNotChanged 
                        + (IF cNotChanged = '':U THEN '':U ELSE ',':U)
                        + cFromField.
        END.

        /* if changed and extent or ambiguous mapping then do an explicit 
           assign of the ToField from the FromField */
        IF lColumnChanged AND (iBracket > 0 OR lAmbiguous) THEN
        DO:
          ASSIGN
            hRowUpdFld = phRowObjUpd:BUFFER-FIELD(cFromField)
            hDBField   = hBuffer:BUFFER-FIELD(cToField).
          IF CAN-DO('CLOB,BLOB':U,hRowUpdFld:DATA-TYPE) THEN
          DO:
            COPY-LOB FROM hRowUpdFld:BUFFER-VALUE TO hDBField:BUFFER-VALUE(iExtent) 
                                                                       NO-ERROR.
            iLarge = LOOKUP(cFromField,cLargeList).
            IF iLarge > 0 THEN
               /* Loop below expects blanks */
               ENTRY(iLarge,cLargeList) = ''. 
          END.
          ELSE
            hDBField:BUFFER-VALUE(iExtent) = hRowUpdFld:BUFFER-VALUE NO-ERROR.

          IF ERROR-STATUS:ERROR THEN   
          DO:
            {&cleanup}  /* delete dummy add rec and b-i handle */
            /* Prepend a potential return-value and append the table as the last 
             CHR(3) entry */
            RETURN RETURN-VALUE 
                   + (IF RETURN-VALUE = '':U THEN '':U ELSE CHR(3))
                   + ENTRY(iTable, cTables).   
          END.
        END.
      END. /* iField = 1 to num-entries(assignFields) */
      
      hBuffer:BUFFER-COPY(phRowObjUpd,
                          cNotChanged 
                          + (IF cNotChanged <> '':U AND cExclude <> '':U 
                             THEN ",":U ELSE "":U)
                          + cExclude,
                          cUseAssignFields,
                          YES) /* NO-LOBS */
                          NO-ERROR. 
      IF ERROR-STATUS:ERROR THEN   
      DO:
        {&cleanup}  /* delete dummy add rec and b-i handle */
        /* Append the table as the last CHR(3) entry */
        RETURN RETURN-VALUE 
               + (IF RETURN-VALUE = '':U THEN '':U ELSE CHR(3))
               + ENTRY(iTable, cTables).   
      END.
      /* Deal with LOBs last to avoid STOP if other fields have error 
         as LOB cannot be undone in subtrans */ 
      DO iField = 1 TO NUM-ENTRIES(cLargeList):
        ASSIGN
          cFromField     = ENTRY(iField,cLargeList)
          /* Is the FromField changed */
          lColumnChanged = cFromField > '' AND LOOKUP(cFromField,cNotChanged) = 0.
        IF lColumnChanged THEN
        DO:
          ASSIGN
            hRowUpdFld = phRowObjUpd:BUFFER-FIELD(cFromField)
            hDBField   = hBuffer:BUFFER-FIELD(cFromField).
          COPY-LOB FROM hRowUpdFld:BUFFER-VALUE TO hDBField:BUFFER-VALUE NO-ERROR.
          /* this will currently never happen.. error in lob in subtrans throws STOP */  
          IF ERROR-STATUS:ERROR THEN   
          DO:
            {&cleanup}  /* delete dummy add rec and b-i handle */
            /* Append the table as the last CHR(3) entry */
            RETURN RETURN-VALUE 
                   + (IF RETURN-VALUE = '':U THEN '':U ELSE CHR(3))
                   + ENTRY(iTable, cTables).   
          END.
        END.
      END. /* iField = 1 to num-entries(cLargeList) */
    END. /* cUpdColumns <> '':u */      
    
    IF lCreate or hBuffer:is-partitioned THEN
    DO:
      /* Reference ROWID of the new row only AFTER the all field values have 
         been assigned as DataServers creates the record as soon as ROWID 
         is referenced! not-NULL fields will give errors 
         Use NO-ERROR to capture this */
      cRowid = STRING(hBuffer:ROWID) NO-ERROR.
        
      /* A DataServer record was not created . */
      IF cRowid = "":U THEN 
      DO:
        {&cleanup}  /* delete dummy add rec and b-i handle */
        RETURN ENTRY(iTable, cTables).
      END.
      cRowIdent = IF iTable = 1 
                  THEN cRowid
                  ELSE cRowIdent 
                       + ",":U 
                       + (IF hBuffer:AVAILABLE THEN cRowid ELSE "":U).
    END. /* new record */
  END.  /* DO iTable */

  IF lCreate or hBuffer:is-partitioned THEN
    ASSIGN 
      phRowObjUpd:BUFFER-FIELD('RowIdentIdx':U):BUFFER-VALUE = SUBSTR(cRowIdent, 1, xiRocketIndexLimit)
      phRowObjUpd:BUFFER-FIELD('RowIdent':U):BUFFER-VALUE = cRowIdent.
  
  {&cleanup}  /* delete dummy add rec and b-i handle */
  &UNDEFINE cleanup
  
  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-batchAvailable) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE batchAvailable Procedure 
PROCEDURE batchAvailable :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 DEFINE INPUT  PARAMETER pcMode AS CHARACTER  NO-UNDO.
 

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-batchServices) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE batchServices Procedure 
PROCEDURE batchServices :
/*------------------------------------------------------------------------------
  Purpose:     To group a sequence of SDO service requests into a single request
               and thereby minimize network messaging and improve performance.
  
  Parameters:
    INPUT pcServices - A character string containing a CHR(1) delimitted list of
                       SDO internal procedures and functions to be executed.  
                       Each entry consists of a CHR(2) delimitted list of INPUT
                       PARAMETER values with the first entry being the NAME of
                       the procedure or function to be executed.
    OUTPUT pcValues  - A character string containing a CHR(1) delimitted list of
                       CHR(2) delimitted strings of output values that result 
                       from the execution of the services listed in pcServices
                       (above).  There is a one-to-one correspondence between
                       the CHR(1) delimitted list of Services in pcServices 
                       (above) and the CHR(1) delimitted list in pcValues.  
                       Procedures with no output paramters have a NULL entry.
                       The return value of functions appear as the first entry 
                       of the corresponding CHR(2) delimitted list, followed
                       by any output parameters.
  
  Notes:       As shipped, batchServices only supports a limited list of services.
               This list consists of all "get" and "set" functions that don't
               require processing other than getting and setting the property in
               the ADMprops temp-table record as well as columnProps,
               initializeObject, openQuery and synchronizeProperties.
               Developers can extend the list by overriding batchServices with a
               local version that has an extended list then running SUPER.
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER pcServices AS CHARACTER                         NO-UNDO.
DEFINE OUTPUT PARAMETER pcValues   AS CHARACTER                         NO-UNDO.

  DEFINE VARIABLE iService         AS INTEGER                           NO-UNDO.
  DEFINE VARIABLE numServices      AS INTEGER                           NO-UNDO.
  DEFINE VARIABLE iValue           AS INTEGER                           NO-UNDO.
  DEFINE VARIABLE cRequest         AS CHARACTER                         NO-UNDO.
  DEFINE VARIABLE cService         AS CHARACTER                         NO-UNDO.
  DEFINE VARIABLE cDataType        AS CHARACTER                         NO-UNDO.
  DEFINE VARIABLE cValue           AS CHARACTER                         NO-UNDO.

  numServices = NUM-ENTRIES(pcServices, CHR(1)).
  DO iService = 1 TO numServices:  /* FOR EACH Service */

    ASSIGN cRequest = ENTRY(iService, pcServices, CHR(1))
           cService = ENTRY(1, cRequest, CHR(2)).

    CASE cService:

      WHEN "columnProps" THEN DO:
        pcValues = pcValues +
                      columnProps(INPUT ENTRY(2,cRequest,CHR(2)),
                                  INPUT ENTRY(3,cRequest,CHR(2))).
      END.

      WHEN "initializeObject" THEN DO:
        RUN initializeObject IN TARGET-PROCEDURE.
      END.
  
      WHEN "openQuery" THEN DO:
        pcValues = pcValues + STRING({fn openQuery}).
      END.

      WHEN "synchronizeProperties" THEN DO:
        RUN synchronizeProperties IN TARGET-PROCEDURE
                                 (INPUT ENTRY(2, cRequest, CHR(2)),
                                  OUTPUT cValue).
        pcValues = pcValues + cValue.
      END.

      OTHERWISE DO:
        /* See if it is a get- or set- property function */
        IF (cService BEGINS "get" AND NUM-ENTRIES(cRequest,CHR(2)) = 1) 
        OR (cService BEGINS "set" AND NUM-ENTRIES(cRequest,CHR(2)) = 2) THEN 
        DO:

          /* Get the datatype of the property */
          cDataType = DYNAMIC-FUNCTION("propertyType":U IN TARGET-PROCEDURE,
                                        SUBSTRING(cService,4)).
          IF cDataType EQ ? THEN  /* It wasn't found */
            RUN addMessage IN TARGET-PROCEDURE (SUBSTITUTE({fnarg messageNumber 60}, cService), ?, ?).
          ELSE IF cService BEGINS "s":U THEN DO:
            CASE cDataType:
              WHEN "CHARACTER":U THEN
                pcValues = pcValues +
                           STRING( DYNAMIC-FUNCTION (cService IN TARGET-PROCEDURE,
                                                     ENTRY(2,cRequest,CHR(2)) )).
              WHEN "INTEGER":U THEN
                pcValues = pcValues +
                           STRING( DYNAMIC-FUNCTION (cService IN TARGET-PROCEDURE,
                                             INTEGER(ENTRY(2,cRequest,CHR(2))) )).
              WHEN "LOGICAL":U THEN
                pcValues = pcValues +
                           STRING( DYNAMIC-FUNCTION (cService IN TARGET-PROCEDURE,
                                                     ENTRY(2,cRequest,CHR(2)) = "yes" )).
              WHEN "DECIMAL":U THEN
                pcValues = pcValues +
                           STRING( DYNAMIC-FUNCTION (cService IN TARGET-PROCEDURE,
                                             DECIMAL(ENTRY(2,cRequest,CHR(2))) )).
            END CASE.  /* Case on Signature */
          END.  /* setProperty case */
          ELSE   /* getProperty case */
            pcValues = pcValues + STRING( DYNAMIC-FUNCTION (cService IN TARGET-PROCEDURE)).
        END. /* If cService begins get or set */
        ELSE  /* Not a get or set function */
          RUN addMessage IN TARGET-PROCEDURE (SUBSTITUTE({fnarg messageNumber 60}, cService), ?, ?).
      END.  /* Otherwise do: */

    END CASE.  /* CASE on cService */

    IF iService NE numServices THEN
      ASSIGN pcValues = pcValues + CHR(1).

  END. /* DO iService = 1 TO numServices */

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
       cChangedFlds = DYNAMIC-FUNCTION('bufferCompareFields' IN TARGET-PROCEDURE,
                                         hRowObjUpd, 
                                         hRowObjUpd2,
                                         "ChangedFields,RowMod,RowIdent,RowIdentIdx,RowNum":U,
                                         "RAW":U).
     END.    /* END DO IF RowMod = U */
     ELSE IF hRowObjUpd:BUFFER-FIELD('RowMod':U):BUFFER-VALUE = "A":U THEN
     DO:
        /* For an Add, set ChangedFields to all fields no longer
           equal to their defined INITIAL value. Determine this by
           creating a RowObject record to compare against. */
       hRowObject:BUFFER-CREATE().
       cChangedFlds = DYNAMIC-FUNCTION('bufferCompareFields' IN TARGET-PROCEDURE,
                                        hRowObjUpd, 
                                        hRowObject,
                                        "ChangedFields,RowMod,RowIdent,RowIdentIdx,RowNum":U,
                                        "RAW":U).

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
  DEFINE VARIABLE hRowObjFld    AS HANDLE    NO-UNDO.
  DEFINE VARIABLE cASDivision   AS CHARACTER NO-UNDO.
  DEFINE VARIABLE lSubmitVal    AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE iChange       AS INTEGER   NO-UNDO.
  DEFINE VARIABLE cChanged      AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cChangedFlds  AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cChangedVals  AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cValue        AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cUpdatable    AS CHARACTER NO-UNDO.
  DEFINE VARIABLE lQueryContainer  AS LOGICAL NO-UNDO.
  DEFINE VARIABLE hQuery1           AS HANDLE     NO-UNDO.
  
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
                 cValue   = STRING(hRowObjUpd1:BUFFER-FIELD(cChanged):BUFFER-VALUE)
                 cChangedVals = cChangedVals 
                              + (IF iChange > 1 THEN CHR(1) ELSE "":U)
                              + cChanged 
                              + CHR(1) 
                              + (if cValue = ? then "?":U else cValue).
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

    /* if not SBO then return the latest version of the record to the client
       otherwise the SBO will take care of this for each SDO at the very end of the transaction */
    IF NOT lQueryContainer THEN
      RUN refreshBuffer IN TARGET-PROCEDURE (OUTPUT pocMessages, OUTPUT pocUndoIds).

  END. /* END transaction block. */ 

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

&IF DEFINED(EXCLUDE-bufferCopyDBToRO) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE bufferCopyDBToRO Procedure 
PROCEDURE bufferCopyDBToRO :
/*------------------------------------------------------------------------------
  Purpose:     Perform a BUFFER-COPY of a database buffer to a row object buffer.
               In particular, if an assign-list is used to map individual array
               elements from the database buffer to the row object buffer, this
               procedure will ensure that the values are copied properly.
  Parameters:  INPUT phRowObj AS HANDLE - Handle to the row object buffer that
                 is to be the target of the BUFFER-COPY.
               INPUT phBuffer AS HANDLE - Handle to the database buffer that is
                 to be the source of the BUFFER-COPY.
               INPUT pcExcludes AS CHARACTER - Comma-delimited list of fields to be
                 excluded from the BUFFER-COPY.
               INPUT pcAssigns AS CHARACTER - Comma-delimited list of field pairs to
                 be individually copied; The field pairs are mappings of fields 
                 from the target/source buffers where the field names differ.
  Notes:       The primary purpose of this procedure is to detect when individual
               array fields are referenced in the assign-list (pcAssigns) from 
               the database buffer and to ensure that they are copied properly.
               It is assumed that the database buffer is always the source of the
               BUFFER-COPY, so that the second field in the assign-list field pair
               is always where the individual array reference will be found 
               (e.g., pcAssigns = "ROfld1,DBfld[1]").
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER phRowObj   AS HANDLE    NO-UNDO.
  DEFINE INPUT PARAMETER phBuffer   AS HANDLE    NO-UNDO.              
  DEFINE INPUT PARAMETER pcExcludes AS CHARACTER NO-UNDO.  
  DEFINE INPUT PARAMETER pcAssigns  AS CHARACTER NO-UNDO.  
  DEFINE VARIABLE hField  AS HANDLE    NO-UNDO.  
  DEFINE VARIABLE hField2 AS HANDLE    NO-UNDO.
  DEFINE VARIABLE cTemp   AS CHARACTER NO-UNDO.
  DEFINE VARIABLE iCtr    AS INTEGER   NO-UNDO.
  DEFINE VARIABLE iExt    AS INTEGER   NO-UNDO.
  DEFINE VARIABLE iPos    AS INTEGER   NO-UNDO.

      /* If the assign-list (cAssigns) contains any individual array fields, we
         can not use BUFFER-COPY.  We must assign each field (pair) manually. */
      IF INDEX(pcAssigns, "[":U) NE 0 THEN
      DO:
        /* Copy everything but the assign-list fields. */
        phRowObj:BUFFER-COPY(phBuffer, pcExcludes).
        /* Manually assign the assign-list fields. */
        DO iCtr = 2 TO NUM-ENTRIES(pcAssigns) BY 2:
          ASSIGN cTemp = ENTRY(iCtr, pcAssigns)  /* DB field */
                 iPos = INDEX(cTemp, "[":U).        /* Position of left bracket */
          IF iPos > 0 THEN  /* Get extent value and base name for array field */
            ASSIGN iExt = INTEGER(ENTRY(1, SUBSTR(cTemp, iPos + 1), "]":U))
                   cTemp = SUBSTR(cTemp, 1, iPos - 1).
          ELSE
            ASSIGN iExt = 0.  /* non-array field */
          /* Assign field */
          ASSIGN hField = phRowObj:BUFFER-FIELD(ENTRY(iCtr - 1, pcAssigns))
                 hField2 = phBuffer:BUFFER-FIELD(cTemp)
                 hField:BUFFER-VALUE = hField2:BUFFER-VALUE(iExt).
        END.
      END.
      ELSE
        phRowObj:BUFFER-COPY(phBuffer, pcExcludes, pcAssigns).

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

  DEFINE VARIABLE hRowObjUpd       AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hQuery           AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cUndoIds        AS CHARACTER NO-UNDO.  
    
    {get RowObjUpd hRowObjUpd}.

     /* set up RowObjUpd query */
    CREATE QUERY hQuery.
    hQuery:SET-BUFFERS(hRowObjUpd).
    hQuery:QUERY-PREPARE('FOR EACH ' + hRowObjUpd:NAME + ' WHERE RowMod = "D"':U).
    hQuery:QUERY-OPEN().
    hQuery:GET-FIRST().

    DO WHILE hRowObjUpd:AVAILABLE:
      /* Check for conflicts and do the delete           
         prepares errors if not avail, locked or optimistic locking conflict */     
      RUN processDBRowForUpdate IN TARGET-PROCEDURE (output cUndoIds).
      if cUndoIds > "" then
        pocUndoIds = pocUndoIds + cUndoIds.
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
                         ' WHERE RowMod = "A" OR RowMod = "C" BY RowNum':U).
    
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
        /* Errors are now added to the message queue in refetchDbRow, 
           but we still check for return-value just in case.. */ 
        IF RETURN-VALUE <> '':U THEN
          RUN addMessage IN TARGET-PROCEDURE (RETURN-VALUE, ?, ?).
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
  DEFINE VARIABLE hQuery        AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cUndoIds      AS CHARACTER NO-UNDO.
 
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
      
      /* fetch buffers for update with exlusive lock, checks for conflicts
         and delete buffers that is to be deleted. 
         prepares errors if not avail, locked or optimistic locking conflict */     
      RUN processDBRowForUpdate IN TARGET-PROCEDURE (output cUndoIds).
      if cUndoIds > "" then
      DO:
        pocUndoIds = pocUndoIds + cUndoIds.
        UNDO Process-Update-Records-Blk, NEXT Process-Update-Records-Blk.
      END.
      
      /* If we haven't 'next'ed because of an error, do the update. */
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
        /* Errors are now added to the message queue in refetchDbRow, 
       but we still check for return-value just in case.. */ 
        IF RETURN-VALUE <> '':U THEN
          RUN addMessage IN TARGET-PROCEDURE (RETURN-VALUE, ?, ?).
        pocUndoIds = pocUndoIds + STRING(hRowObjUpd2:BUFFER-FIELD('RowNum':U):BUFFER-VALUE) + CHR(3) + ",":U.
      END.  /* if ERROR */
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
  
  RUN getLogicBuffer IN TARGET-PROCEDURE (OUTPUT hReturnBuffer).
  
  /* if in the scope of a by-reference call to the DLP then use the DLP buffer */
  IF hReturnBuffer:TABLE-HANDLE = hRowObjUpd:TABLE-HANDLE THEN 
  DO:
    hRowObjUpd = hReturnBuffer.
    RUN getLogicBeforeBuffer IN TARGET-PROCEDURE (OUTPUT hRowObjUpdBI).
  END.
  ELSE
  DO:
    CREATE BUFFER hRowObjUpd   FOR TABLE hRowObjUpd.  
    CREATE BUFFER hRowObjUpdBI FOR TABLE hRowObjUpd.
  END.

  /* set up RowObjUpd query */
  CREATE QUERY hQuery.

  hQuery:SET-BUFFERS(hRowObjUpd).
  hQuery:QUERY-PREPARE('FOR EACH ':U + hRowObjUpd:NAME + ' WHERE RowMod <> ""':U).
  hQuery:QUERY-OPEN().
  hQuery:GET-FIRST().
  
  DO WHILE hRowObjUpd:AVAILABLE:
    
    /* Fetch the before image of the current record if this is an update */
    IF hRowObjUpd::RowMod = "U":U THEN
      hRowObjUpdBI:FIND-FIRST('WHERE RowMod = "" AND RowNum = ':U +
                                 STRING(hRowObjUpd::RowNum)).
    ELSE 
      hROwObjUpdBI:BUFFER-RELEASE. 

    IF hReturnBuffer <> hRowObjUpd THEN
      RUN setLogicBuffer IN TARGET-PROCEDURE
           (INPUT hRowObjUpd,
            INPUT IF hRowObjUpdBI:AVAILABLE THEN hRowObjUpdBI ELSE ?).
    
    IF CAN-DO("A,C,U":U,hRowObjUpd::RowMod) THEN
    DO:
      IF CAN-DO("A,C":U,hRowObjUpd::RowMod) THEN
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
    ELSE IF hRowObjUpd::RowMod = "D":U THEN
    DO:
      RUN VALUE('delete':U + pcLevel + xcFixedName) IN TARGET-PROCEDURE NO-ERROR.
      IF RETURN-VALUE NE "":U THEN
        cMessageList = cMessageList
                     + (IF NUM-ENTRIES(cMessageList,CHR(3)) > 0 THEN CHR(3) ELSE '':U) 
                     + RETURN-VALUE.
    END. /* Delete */

    IF hReturnBuffer <> hRowObjUpd THEN
    DO:
      RUN getLogicBuffer IN TARGET-PROCEDURE (OUTPUT hReturnBuffer).  
      hRowObjUpd:BUFFER-COPY(hReturnBuffer).     
      RUN clearLogicRows IN TARGET-PROCEDURE.
    END.

    hQuery:GET-NEXT.

  END.
    
  IF hReturnBuffer <> hRowObjUpd THEN   
  DO:
    DELETE OBJECT hRowObjUpd. 
    DELETE OBJECT hRowObjUpdBI. 
  END.

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

DEFINE VARIABLE lLocalHook        AS LOGICAL    NO-UNDO.
DEFINE VARIABLE cHook             AS CHARACTER  NO-UNDO.
DEFINE VARIABLE hLogicObject      AS HANDLE     NO-UNDO.
DEFINE VARIABLE hRowObjUpdTable   AS HANDLE     NO-UNDO.
DEFINE VARIABLE cReturn           AS CHARACTER  NO-UNDO.

   {get RowObjUpdTable hRowObjUpdTable}.
   {get DataLogicObject hLogicObject}.
   
   /* If the table hook is ONLY in the Logical Object or in this class then 
      we pass the table by reference.
      If the hook is local then we don't as we currently assume that this 
      means that there is no use of the DLP OR that it does its own 
      calls to the DLP low level hooks with a clearLogicRows clean up that 
      would mess with the by-reference table.  */
   
   ASSIGN
     cHook      = pcValType + "TransactionValidate":U
     lLocalHook = LOOKUP(cHook,TARGET-PROCEDURE:INTERNAL-ENTRIES) > 0.
   
   IF NOT lLocalHook AND VALID-HANDLE(hLogicObject) THEN 
     RUN runTableEvent IN TARGET-PROCEDURE (TABLE-HANDLE hRowObjUpdTable BY-REFERENCE,
                                            cHook).
   ELSE
     RUN VALUE(cHook) IN TARGET-PROCEDURE.

   cReturn = RETURN-VALUE.

   RETURN cReturn.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-compareDBRow) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE compareDBRow Procedure 
PROCEDURE compareDBRow :
/*------------------------------------------------------------------------------
  Purpose:     Does a buffer-compare of the current RowObjUpd row to the
               database records it is derived from. If any fields have been
               changed the the name of the first table with changed fields
               is returned in the RETURN-VALUE of the procedure.

  Parameters:  <none>

  Notes:       The dynamic buffer-compare does not return the names of fields
               which were changed, so this information is not available to put
               into a message. The procedure returns the first table name which
               has fields which don't match.
------------------------------------------------------------------------------*/

  DEFINE VARIABLE hBuffer           AS HANDLE    NO-UNDO.
  DEFINE VARIABLE cBuffers          AS CHARACTER NO-UNDO.
  DEFINE VARIABLE iTable            AS INTEGER   NO-UNDO.
  DEFINE VARIABLE hRowObjUpd        AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hRowObjFld        AS HANDLE    NO-UNDO.
  DEFINE VARIABLE cAssigns          AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cRowIdent         AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cExclude          AS CHARACTER NO-UNDO.
  DEFINE VARIABLE lSame             AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE cCLOBColumns      AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cTables           AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cTable            AS CHARACTER NO-UNDO.
  
  &SCOPED-DEFINE xp-assign
  {get BufferHandles cBuffers}        /* DB buffer handles */
  {get Tables cTables}        /* DB buffer names  */
  {get AssignList cAssigns}           /* List of fields whose names were changed */
  {get RowObjUpd hRowObjUpd}
  {get CLOBColumns cCLOBColumns}
  .
  &UNDEFINE xp-assign
  
  cRowIdent = hRowObjUpd:BUFFER-FIELD('RowIdent':U):BUFFER-VALUE.

  DO iTable = 1 TO NUM-ENTRIES(cBuffers):
    IF ENTRY(iTable, cRowIdent) NE "":U THEN /* allow for outer join w/ no rec */
    DO:
      cTable = entry(iTable,cTables).   
      /* only compare exclusive locked tables */
      IF dynamic-function("bufferExclusiveLock":U in target-procedure,cTable,hRowObjUpd::RowMod) then
      do:      
        assign                       
          hBuffer  = WIDGET-HANDLE(ENTRY(iTable, cBuffers))
          /* don't compare with same named unused fields in other tables */ 
          cExclude = {fnarg excludeColumns iTable}.
        
        /* If array elements are present, we must compare them manually.
           We also do this if there are CLOBColumns, since buffer-compare 
           currently cannot compare CLOBs */
        IF INDEX(cAssigns, "[":U) > 0 OR cCLOBColumns > '' THEN 
          lSame = DYNAMIC-FUNCTION('bufferCompareDBToRO':U IN TARGET-PROCEDURE,
                                      hRowObjUpd, 
                                      hBuffer, 
                                      cExclude, 
                                      ENTRY(iTable, cAssigns, {&adm-tabledelimiter})).
        ELSE
          lSame = hBuffer:BUFFER-COMPARE(hRowObjUpd, 
                                         'BINARY':U,
                                         cExclude, 
                                         ENTRY(iTable, cAssigns, {&adm-tabledelimiter})).
           
        IF NOT lSame THEN
          RETURN cTable.
      end. /* if bufferExclusiveLock */
    END.    /* END DO IF cRowIdent NE "" */
  END.      /* END DO iTable */
  RETURN.
       
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-createObjects) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE createObjects Procedure 
PROCEDURE createObjects :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE iLoop           AS INTEGER    NO-UNDO.
  DEFINE VARIABLE hBuffer         AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hQuery          AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cBufferHandles  AS CHAR       NO-UNDO.   
  DEFINE VARIABLE cDBNames        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lStatic         AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lNoBuffer       AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cCurTables      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cTables         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cPhysicalTables AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cTable          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cPhysical       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cAsDivision     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cQueryContext   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lNewQuery       AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lOk             AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cDBName         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iAlias          AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iError          AS INTEGER    NO-UNDO.
  DEFINE VARIABLE lShowMsg        AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cMessage        AS CHARACTER  NO-UNDO.
  
  &SCOPED-DEFINE xp-assign
  {get Tables cTables}
  {get PhysicalTables cPhysicalTables}.
  &UNDEFINE xp-assign
  
  IF cTables = '':U THEN
    RETURN.

  IF cPhysicalTables = '':U THEN
  DO:
    cPhysicalTables = cTables.
    {set PhysicalTables cPhysicalTables}.
  END.

  {get QueryHandle hQuery}.  
  IF VALID-HANDLE(hQuery) THEN 
    lStatic = LOOKUP("STATIC":U, hQuery:ADM-DATA, CHR(1)) > 0.

  IF NOT lStatic THEN 
  DO:
    DELETE OBJECT hQuery NO-ERROR.
    CREATE QUERY hQuery.
    lNewQuery = TRUE.  /* we need to prepare the query */

    &SCOPED-DEFINE xp-assign
    {set QueryHandle hQuery}
    /* Cater for change of tables during the objects lifetime and 
       delete old buffer handles */
    {get BufferHandles cBufferHandles}.
    &UNDEFINE xp-assign
    
    DO iLoop = 1 TO NUM-ENTRIES(cBufferHandles):
      hBuffer = WIDGET-HANDLE(ENTRY(iLoop,cBufferHandles)).
      DELETE OBJECT hBuffer.
    END.
    DO iLoop = 1 TO NUM-ENTRIES(cTables):
      ASSIGN
        cTable    = ENTRY(iLoop,cTables)
        cPhysical = ENTRY(iLoop,cPhysicalTables). 
      
      hBuffer = DYNAMIC-FUNCTION('createBuffer':U IN TARGET-PROCEDURE,
                                  ENTRY(NUM-ENTRIES(cTable,'.':U),cTable,'.':U),
                                  cPhysical).  
      
      if not valid-handle(hBuffer) then
      do:
        iError = if num-entries(cTable,".") = 2 or num-dbs = 1 then 104 else 105.                
        cMessage =  substitute({fnarg messageNumber iError},cPhysical).      
        lShowMsg = true.
        if {fn getManageReadErrors} then  
        do:
           run addMessage in target-procedure(substitute({fnarg messageNumber iError},cPhysical),cTable,?).
           /* ensure error is written to log if remote */
           if session:remote then
              lShowMsg = session:remote.
        end.   
        if lShowMsg then
           run showMessageProcedure in target-procedure(cMessage, output lShowMsg /*dummy*/).  
        return.
      end.

      IF iLoop = 1 THEN 
      DO:
        lOk = hQuery:SET-BUFFERS(hBuffer) NO-ERROR.
        /* Any message means that it is futile to continue adding to the query  */
        IF NOT lok THEN 
        DO:
          IF VALID-HANDLE(hBuffer) THEN
            DELETE OBJECT hBuffer.     
          return. 
        END.
      END.
      ELSE 
        hQuery:ADD-BUFFER(hBuffer).
    END.
  END.
  
  cBufferHandles = ?.
  DO iLoop = 1 TO hQuery:NUM-BUFFERS:
    ASSIGN 
      hBuffer        = hQuery:GET-BUFFER-HANDLE(iLoop)
      cBufferHandles = (IF iLoop = 1 
                        THEN "":U 
                        ELSE cBufferHandles + ",":U)  
                     + STRING(hBuffer).
      
      ALS-BLK:
      DO:
        cDBName = "":U. /* Reset variable */
        /* Check to see if the dbname is connected as an alias */
        DO iAlias = 1 TO NUM-ALIASES:
          IF LDBNAME(ALIAS(iAlias)) EQ hBuffer:DBNAME AND
             CAN-DO(cTables,ALIAS(iAlias) + ".":U + hBuffer:NAME) THEN DO: 
            cDBName = ALIAS(iAlias).
            LEAVE ALS-BLK.
          END.
        END.  
      END.
      cDBNames = cDBNames + (IF iLoop = 1 THEN "":U ELSE ",":U) 
                          + (IF cDBName EQ "":U THEN hBuffer:DBNAME ELSE cDBName).
  END. /* iTable = 1 to num-buffers */
  
  &SCOPED-DEFINE xp-assign
  {set DBNames cDBNames}
  {set BufferHandles cBufferHandles}
  .
  &UNDEFINE xp-assign
  
  /* setQueryWhere will store data in QueryContext if called early (context) */
  IF hQuery:NUM-BUFFERS > 0 THEN
  DO:   
    {get QueryContext cQueryContext}.
    IF cQueryContext > '':U OR lNewQuery THEN
    DO:
      {fnarg prepareQuery cQueryContext}. 
      {set QueryContext '':U}.
    END.
  END.    

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-dataAvailable) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE dataAvailable Procedure 
PROCEDURE dataAvailable :
/*------------------------------------------------------------------------------
  Purpose:     dataAvailable is an event procedure that generates a dependent 
               query dynamically based on the ForeignFields property.  This 
               event occurs when a Data-Source publishes "dataAvailable" because
               it has new data available and a dependant object need to react.
 
  Parameters:
    INPUT pcRelative - a flag decribing the newly available record.
  
        SAME           - The current record is being resent because it has been 
                          updated.  This procedure ignores this type.
        VALUE-CHANGED - A target SmartDataObject has changed the position.  
                          This procedure needs to set QueryPosition property 
                          then change pcRelative to "DIFFERENT" before passing 
                          it along to other target procedures so as to appear as
                          if the change occured in this procedure.
         RESET        - Request to reset statuses and foreignfields and refresh
                        visual objects and panels in all objects in the data-link 
                        chain. This was introduced in 9.1C because in some cases 
                        'same' does too little and 'different' too much. 
                        It achieves the same as 'different' except that queries 
                        will only be reopened if foreign values has changed.   
         DIFFERENT    - Request to reapply foreign Fields and reopen the query.
         TRANSFER     - Signal to call the open client fetchFirstBatch API. 
                        Called internally from a parent that has a ReadHandler 
                        defined that receives records as they are transferred 
                        from the database.
   
   ---      
         FIRST        - 
         NEXT         -
         PREV         -
         LAST         -
  
  Notes:       This is a special version of DataAvailable for SmartDataObjects
               with a dependency on another SmartDataObject. So the code is 
               different from that for a Viewer, for example. If there are no 
               ForeignFields, then it is being run because of a reposition in 
               one of its targets (a SmartDataBrowser, normally), in which 
               case it just passes on the event to other targets.
------------------------------------------------------------------------------*/

 DEFINE INPUT PARAMETER pcRelative AS CHARACTER NO-UNDO.
 
 DEFINE VARIABLE cForeignFields AS CHARACTER NO-UNDO.
 DEFINE VARIABLE cSourceFields  AS CHARACTER NO-UNDO INIT "":U.
 DEFINE VARIABLE cLocalFields   AS CHARACTER NO-UNDO INIT "":U.
 DEFINE VARIABLE cValues        AS CHARACTER NO-UNDO.
 DEFINE VARIABLE hDataSource    AS HANDLE    NO-UNDO.
 DEFINE VARIABLE iField         AS INTEGER   NO-UNDO.      
 DEFINE VARIABLE cQuery         AS CHARACTER NO-UNDO.  
 DEFINE VARIABLE cWhere         AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE hQuery         AS HANDLE    NO-UNDO.
 DEFINE VARIABLE cPosition      AS CHARACTER NO-UNDO.
 DEFINE VARIABLE iCurrent       AS INTEGER   NO-UNDO.  
 DEFINE VARIABLE cNewPos        AS CHARACTER NO-UNDO.
 DEFINE VARIABLE lNewSource     AS LOGICAL   NO-UNDO.
 DEFINE VARIABLE lNewModeSource AS LOGICAL   NO-UNDO.
 DEFINE VARIABLE cASDivision    AS CHARACTER NO-UNDO.
 DEFINE VARIABLE hSource        AS HANDLE    NO-UNDO.
 DEFINE VARIABLE cCurrentValues AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE lFetched       AS LOGICAL    NO-UNDO.
 DEFINE VARIABLE lNewMode       AS LOGICAL    NO-UNDO.
 DEFINE VARIABLE lOneToOne      AS LOGICAL    NO-UNDO.
 DEFINE VARIABLE hSourceRow     AS HANDLE     NO-UNDO.
 DEFINE VARIABLE iCount         AS INTEGER    NO-UNDO.
 DEFINE VARIABLE hNewQuery      AS HANDLE     NO-UNDO.
 DEFINE VARIABLE cNewBatchInfo     AS CHAR       NO-UNDO.

 /* If the same row is being resent because of an update, we don't want to react 
    to that, so just skip it if it's not a different row. */
 
  IF pcRelative = "SAME":U THEN RETURN.
 
  &SCOPED-DEFINE xp-assign
  {get QueryHandle hQuery}    /* Points to the database query */
  {get ForeignFields cForeignFields}.

  &UNDEFINE xp-assign
  /* Get the foreign fields, which map the Data Source's RowObject fields
     to this object's database fields and prepare the Query
     using that value. setQueryWhere will open the query. */
  IF cForeignFields = "":U OR pcRelative = "VALUE-CHANGED":U THEN
  DO:
    
      
      /* If there were no ForeignFields, a Browser has repositioned the query.
       Just pass along the event to other targets. Set QueryPosition
       property first if that has changed. */
    {get QueryPosition cPosition}. /* current First/Last etc. before repos */
    iCurrent = hQuery:CURRENT-RESULT-ROW.  /* *new* current row. */
    
    IF cPosition EQ 'FirstRecord':U AND /* moved away from first */
      iCurrent NE 1 THEN  
        cNewPos = IF pcRelative = "Last":U THEN 'LastRecord':U     
                  ELSE 'NotFirstOrLast':U.   
    ELSE IF cPosition EQ 'NotFirstOrLast':U THEN    /* moved to first/last */
      cNewPos = IF iCurrent EQ 1 THEN 'FirstRecord':U
                ELSE IF pcRelative = "Last":U THEN 'LastRecord':U  
                ELSE "":U.       /* Moved to some other row */
    ELSE IF cPosition EQ 'LastRecord':U AND   /* moved away from last */
      pcRelative NE "Last":U AND pcRelative NE "Next":U THEN
        cNewPos = IF iCurrent = 1 THEN 'FirstRecord':U
                  ELSE 'NotFirstOrLast':U.   
       
    IF cNewPos NE "":U THEN    /* We changed relative position...*/
      {set QueryPosition cNewPos}.
    
    ASSIGN pcRelative = "DIFFERENT":U WHEN pcRelative = "VALUE-CHANGED":U.    
   /* Now let other targets (if any) know about the new position. */
    PUBLISH 'dataAvailable':U FROM TARGET-PROCEDURE (pcRelative).
    {set NewBatchInfo '':U}.
    RETURN.
  END.  /* END DO IF FF = "" */
  
  {get DataSource hDataSource}.
  
  IF VALID-HANDLE(hDataSource) THEN
  DO:
    ghTargetProcedure = TARGET-PROCEDURE.   
    /* NewRow is true also when saved an uncommitted */ 
    {get NewRow  lNewSource hDataSource}.

    ghTargetProcedure = TARGET-PROCEDURE.  /* just in case ..*/ 
    /* NewMode is only true when in addmode (closeQuery below) */ 
    {get NewMode lNewModeSource hDataSource}.
    ghTargetProcedure = ?.
  END.

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
  IF cValues NE ? THEN cValues = SUBSTR(cValues, INDEX(cValues, CHR(1)) + 1).
      
  /* NOT (lNewModeSoure = FALSE) to include ? when source closed */
  /* cValues = ? indicated No row available in the Source.  */
  /* If we are in new mode then we cannot close the query 
     This may happen when a commit fails in an SBO (one to one particularly)  */
  {get NewMode lNewMode}. 
  IF NOT lNewMode AND NOT (lNewModeSource = FALSE) OR cValues = ? THEN
    {fn closeQuery}.      /* Close the previous query. */
    
  {get ForeignValues cCurrentvalues}.
  
  /* If an outside object manages the temp-tables it can set this to true 
     to avoid reopening the query here (sbo.p fetchContainedRows)
     We only check this if we are sure the foreignfield are the same  */
  IF cCurrentValues = cValues THEN
    {get DataIsFetched lFetched}.

  /* Save FF values for later querying, except when 'RESET'
     RESET indicates that ForeignValues has NOT changed, but it may also be 
     from a DataContainer during initialization when openOnInit is false,
     so we must NOT set the value. The data.p override uses hasForeignKeyChanged
     to check whether a 'RESET' can be passed up here, so it must match with 
     the values that id used to open the query. If new source we need to store 
     it as in this case foreignvalues has changed */
  

  IF pcRelative <> 'RESET':U
  OR lNewSource
  /* child of previously initialized dataSource (This may need another look) */ 
  OR (VALID-HANDLE(hDataSource) AND DYNAMIC-FUNCTION('getObjectInitialized':U IN hDataSource)) THEN   
  DO:
    &SCOPED-DEFINE xp-assign
    {get ASDivision cASDivision}
    {get UpdateFromSource lOneToOne}
     .
    &UNDEFINE xp-assign

    /* If this is a 1-to-1 SDO, get the RowObject of its DataSource and retrieve all */
    /* related records by creating a temporary join to the parent's RowObject */
    IF lOneToOne = TRUE AND cASDivision <> "CLIENT":U THEN
    DO:
      &SCOPED-DEFINE xp-assign
      {get RowObject hSourceRow hDataSource}
      {get NewBatchInfo cNewBatchInfo hDataSource}.
      &UNDEFINE xp-assign
      
      CREATE BUFFER hSourceRow FOR TABLE hSourceRow BUFFER-NAME "SourceRow":U.

      DO iCount = 1 TO NUM-ENTRIES(cLocalFields):
         cWhere = (IF iCount > 1 THEN cWhere + " AND ":U ELSE "") +
                  ENTRY(iCount, cLocalFields) + " = SourceRow.":U +
                  ENTRY(iCount, cSourceFields).
      END.
      IF cNewBatchInfo > "" AND cNewBatchInfo <> ? AND cNewBatchInfo <> "ALL":U THEN
        cQuery = "FOR EACH SourceRow WHERE ":U + cNewBatchInfo + ", ":U.
      ELSE
        cQuery = "FOR EACH SourceRow, ":U.

      ASSIGN
        cQuery = cQuery + REPLACE(hQuery:PREPARE-STRING, "FOR EACH ":U, "FIRST ":U)
        cQuery = DYNAMIC-FUNCTION( "newWhereClause":U IN TARGET-PROCEDURE,
                                   hQuery:GET-BUFFER-HANDLE(1):NAME,
                                   cWhere,   /* expression to be added */
                                   cQuery,   /* original query */
                                   "AND":U ).
/*           cQuery = REPLACE(cQuery, " WHERE ":U, " OUTER-JOIN WHERE ":U).  */
      /* set up a temporary 1-to-1 query */
      CREATE QUERY hNewQuery.
      hNewQuery:ADD-BUFFER(hSourceRow).
      DO iCount = 1 TO hQuery:NUM-BUFFERS:
        hNewQuery:ADD-BUFFER(hQuery:GET-BUFFER-HANDLE(iCount)).
      END.
      hNewQuery:QUERY-PREPARE(cQuery).

      /* plug in the new query */
      {set QueryHandle hNewQuery}.
    END.
    ELSE DO:
      {set ForeignValues cValues}.  
      DYNAMIC-FUNCTION("assignQuerySelection":U IN TARGET-PROCEDURE, 
                        cLocalFields,
                        cValues,
                        '':U).  
    END.
  END.

  IF pcRelative = 'TRANSFER':U THEN 
  DO:
    RUN fetchFirstBatch IN TARGET-PROCEDURE.
  END.  

  /* If 'reset' updateQueryPosition -> to update panels and republish.*/ 
  ELSE IF pcRelative = 'RESET':U OR lFetched = TRUE OR lNewSource OR cValues = ? THEN
  DO:
    RUN updateQueryPosition IN TARGET-PROCEDURE.
    /* From 9.1C we republish 'reset' also when lFetched = true,
       in 9.1B we did not republish in this case as 'reset' did not exist.*/  
    PUBLISH 'DataAvailable':U FROM TARGET-PROCEDURE('RESET':U).
    {set NewBatchInfo '':U}.
  END.  
  ELSE DO:
    {fn openQuery}.
  END.

  /* clean-up and restore */
  {set QueryHandle hQuery}.
  DELETE OBJECT hSourceRow NO-ERROR.
  DELETE OBJECT hNewQuery NO-ERROR.

  /* Turn off this in any case */
  {set DataIsFetched FALSE}.

  RETURN.
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
  DEFINE VARIABLE hQuery  AS HANDLE     NO-UNDO.
  DEFINE VARIABLE iBuffer AS INTEGER    NO-UNDO.
  
  {get QueryHandle hQuery}.
                             /* dynamic */
  IF VALID-HANDLE(hQuery) AND hQuery:NAME = '':U THEN
  DO:
    DO iBuffer = 1 TO hQuery:NUM-BUFFERS:
      DELETE OBJECT hQuery:GET-BUFFER-HANDLE(iBuffer) NO-ERROR.
    END.
    DELETE OBJECT hQuery NO-ERROR.
  END.

  RUN SUPER.
  
  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fetchCurrentBatch) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE fetchCurrentBatch Procedure 
PROCEDURE fetchCurrentBatch :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/   
   DEFINE VARIABLE iRowsReturned   AS INTEGER    NO-UNDO.
   DEFINE VARIABLE hQuery          AS HANDLE     NO-UNDO.
   DEFINE VARIABLE lFillBatch      AS LOGICAL    NO-UNDO.
   DEFINE VARIABLE hDataQuery      AS HANDLE     NO-UNDO.
   {set FetchOnOpen '':U}.
   /* close query to avoid openQuery wiping out all batchprops */ 
   {get DataHandle hDataQuery}.
   hdataQuery:QUERY-CLOSE.

   {fn openQuery}.
   {fnarg emptyRowObject '':U}.
   {get FillBatchOnRepos lFillBatch}.

   RUN transferRows IN TARGET-PROCEDURE (NO,
                                         'Current':U,
                                         "":U,
                                         lFillBatch,
                                         ?,
                                         OUTPUT iRowsReturned).
   
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fetchDBRowForUpdate) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE fetchDBRowForUpdate Procedure 
PROCEDURE fetchDBRowForUpdate :
/*------------------------------------------------------------------------------
  Purpose:     Retrieves with EXCLUSIVE-LOCK the database records associated 
               with the current RowObjUpd record, as identified by a list of 
               RowIds in the RowIdent field of that record.
               
               IF the RowMod field is "D" for Delete, deletes the DB record(s).
 
  Parameters:  <none>
 
  Notes:       If one or more of the database records cannot be locked (for any
               reason - most likely because it is locked by another user, but
               perhaps because it has been deleted), the table name of the 
               first unlockable record is returned as the return value.
             - The lockBufferForUpdate checks the NoLockReadOnlyTables to decide
               if read only tables also need to be locked and included in 
               optimistic lock comparison.    
------------------------------------------------------------------------------*/
  DEFINE VARIABLE iTable           AS INTEGER   NO-UNDO.
  DEFINE VARIABLE hRowObjUpd       AS HANDLE    NO-UNDO.
  DEFINE VARIABLE rRowid           AS ROWID     NO-UNDO.
  DEFINE VARIABLE hBuffer          AS HANDLE    NO-UNDO.
  DEFINE VARIABLE cBuffers         AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cTables          AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cTable           AS CHARACTER NO-UNDO.
  DEFINE VARIABLE hRowIdent        AS HANDLE    NO-UNDO.
  DEFINE VARIABLE cRowIdent        AS CHARACTER NO-UNDO.
  DEFINE VARIABLE hRowMod          AS HANDLE    NO-UNDO.
  DEFINE VARIABLE lDelSuccess      AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE hQuery           AS HANDLE    NO-UNDO.
  DEFINE VARIABLE cUpdTbls         AS CHARACTER NO-UNDO.
  DEFINE VARIABLE iDelCnt          AS INTEGER   NO-UNDO.
  DEFINE VARIABLE lFirstRecDeleted AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE lSchemaValidate  AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE hLogicObject     AS HANDLE    NO-UNDO.
  DEFINE VARIABLE cDelMessage      AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cAsDivision      AS CHARACTER NO-UNDO.
  DEFINE VARIABLE rRowidList       AS ROWID     EXTENT {&maxtables} NO-UNDO.
  DEFINE VARIABLE lOneToOne        AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE lCheck           AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE lOk              AS LOGICAL   NO-UNDO.
  define variable cNewIdent        as character no-undo.
  
  &SCOPED-DEFINE xp-assign
  {get BufferHandles cBuffers}     /* DB Buffer handles. */
  {get RowObjUpd hRowObjUpd} 
  {get Tables cTables}             /* DB query buffer/Table names. */
  {get UpdatableColumnsByTable cUpdTbls}.
  &UNDEFINE xp-assign
  
  ASSIGN hRowIdent = hRowObjUpd:BUFFER-FIELD('RowIdent':U)
         cRowIdent = hRowIdent:BUFFER-VALUE
         hRowMod   = hRowObjUpd:BUFFER-FIELD('RowMod':U).
     
  DO iTable = 1 TO NUM-ENTRIES(cRowIdent):     
    hBuffer = WIDGET-HANDLE(ENTRY(iTable, cBuffers)).
    IF ENTRY(iTable, cRowIdent) NE "":U THEN  /* allow for outer-join w/no rec*/
    DO:
      ASSIGN
        rRowid = TO-ROWID(ENTRY(iTable, cRowIdent))
        cTable = entry(iTable,cTables).      
      if dynamic-function("bufferExclusiveLock":U  in target-procedure,cTable,hRowObjUpd::RowMod) then 
      do: 
        lok = hBuffer:FIND-BY-ROWID(rRowid, EXCLUSIVE-LOCK, NO-WAIT) no-error.
        if not lok then
        do:
            /* a partitioned table may have moved if partition values have been changed
               check if it can be found by keys and refrehs the rowident and 
               return conflict error if it exist   */
            if hBuffer:is-partitioned then 
            do:
                cNewIdent =  DYNAMIC-FUNCTION("bufferRowident":U IN TARGET-PROCEDURE, hBuffer). 
                if cNewIdent > ? then
                do:
                    cRowIdent = cNewIdent.
                    hRowIdent:BUFFER-VALUE = cRowIdent.
                    RETURN entry(iTable, cTables) + ",":U + "<conflict>":U. 
                end.     
            end.      
            RETURN entry(iTable, cTables).
        end. 
      end.  
      else do:
        lok = hBuffer:FIND-BY-ROWID(rRowid, NO-LOCK) no-error.
        if not lok then
            entry(iTable, cRowIdent) = "".
      end.  
    END.
  end.
  
  /* Check first whether we care if the database record has been
     changed by another user. This is a settable instance property. */
  {get CheckCurrentChanged lCheck}.
  IF lCheck THEN
  DO:
    RUN compareDBRow IN TARGET-PROCEDURE.
    IF RETURN-VALUE NE "":U THEN /* Table name that didn't compare is returned. */
      RETURN RETURN-VALUE + ",":U + "<conflict>":U. 
  END.
  
  /* delete */
  IF hRowMod:BUFFER-VALUE = "D":U THEN
  DO:  
    DO iTable = 1 TO NUM-ENTRIES(cRowIdent):
      hBuffer = WIDGET-HANDLE(ENTRY(iTable, cBuffers)).
      IF ENTRY(iTable, cRowIdent) NE "":U  /* allow for outer-join w/ no rec*/
      /* Table has no enabled fields, so it's not updatable and can't be deleted. */
      and ENTRY(iTable, cUpdTbls, {&adm-tabledelimiter}) > "":U THEN
      do:
        DO ON ERROR UNDO, LEAVE:
          lDelSuccess = hBuffer:BUFFER-DELETE() NO-ERROR.
          /* The above statement does not support schema delete validation,
             so check for error 7347. */
          lSchemaValidate = ERROR-STATUS:GET-NUMBER(1) = 7347.
          
          /* The DO ON ERROR will ensure that the RETURN below sends message 
             7374 back to the user if no static delete function is found. 
             (There will also be an error message HERE (server log) about no 
              existing functions, but no-error is intentionally avoided on the 
              function calls to ensure that the error status from the delete 
             (for example the val msg) is intact */
          IF lSchemaValidate THEN
          DO ON ERROR UNDO, LEAVE:
            {get DataLogicObject hLogicObject}.
            IF VALID-HANDLE( hLogicObject) THEN 
                  /* Run Delete<Table>static in Logic Procedure */
              lDelSuccess = DYNAMIC-FUNCTION("delete":U + ENTRY(iTable, cTables) + "Static":U IN TARGET-PROCEDURE, rRowid). 
            ELSE /* Run Delete<Table>static in Logic Procedure */
              lDelSuccess = DYNAMIC-FUNCTION("deleteRecordStatic":U IN TARGET-PROCEDURE, iTable). 
          END.
        END.
        IF NOT (lDelSuccess) = TRUE THEN
        DO:
          cDelMessage = IF RETURN-VALUE <> '':U THEN RETURN-VALUE ELSE ERROR-STATUS:GET-MESSAGE(1).
            /* Signal that Delete failed. Support return-value from triggers */
          RETURN ENTRY(iTable, cTables) 
                 + (IF cDelMessage <> '':U THEN ',':U + cDelMessage ELSE '':U)
                 + ",Delete":U.  
        END.
        ELSE DO:
          IF iTable = 1 THEN
              /* If you delete the first record in a join, then you must
                       always delete the result list entry and remove the row
                       from the query. */
             lFirstRecDeleted = yes.
          iDelCnt = iDelCnt + 1.
        END.
      END.    /* END DO IF RowIdent NE "" */
      /* If there is no record for this buffer then do a release to clear
             out any leftover record in case code looks at it later. */
      ELSE hBuffer:BUFFER-RELEASE() NO-ERROR.
    END.      /* END DO iTable */
    /* sendRows currently does not reopen the query when running locally, so 
             we do a delete-result-list-entry so transferRows does not find this 
             row in the result list when determining where to start retrieving records 
             for the next batch. */
    &SCOPED-DEFINE xp-assign
    {get AsDivision cAsDivision}
    {get UpdateFromSource lOneToOne}.
    &UNDEFINE xp-assign                            
    IF cAsDivision = '':U AND NOT (lOneToOne = TRUE) THEN
    DO:
      /* Only delete result list entry if all records in the row are deleted,
         or if the first record in the row is deleted. */
      IF lFirstRecDeleted OR (iDelCnt = NUM-ENTRIES(cRowIdent)) THEN
      DO:
        {get QueryHandle hQuery}.
        IF hQuery:IS-OPEN THEN
        DO:
          DO iTable = 1 TO NUM-ENTRIES(cRowIdent):
            IF ENTRY(iTable, cRowIdent) NE "":U THEN  /* allow for outer-join w/no rec*/
               rRowIDList[iTable] = TO-ROWID(ENTRY(iTable, cRowIdent)) NO-ERROR.
          END.
          lOk = hQuery:REPOSITION-TO-ROWID(rRowidList) no-error.
          if lok THEN
              hQuery:DELETE-RESULT-LIST-ENTRY().
        END.
      END.
    END.
  END.  /* END DO IF "D"elete */
  
  RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fetchFirst) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE fetchFirst Procedure 
PROCEDURE fetchFirst :
/*------------------------------------------------------------------------------
  Purpose:      Repositions the database query to the first row.
  
  Parameterss:  <none>
  
  Notes:        Requests rows to be transferred from the database query
                if the RowObject query is empty.
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hQuery        AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hBuffer       AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hColumn       AS HANDLE    NO-UNDO.
  DEFINE VARIABLE lHidden       AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE cRowIdent     AS CHARACTER NO-UNDO.
  DEFINE VARIABLE lSkipRowIdent AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE rRowIDs       AS ROWID EXTENT 19 NO-UNDO.
  DEFINE VARIABLE iRow          AS INTEGER   NO-UNDO.
  DEFINE VARIABLE lOK           AS LOGICAL   NO-UNDO.
  
    /* IF this object is currently hidden, then just return. This effectively
       makes the link inactive. */

/* NOTE: THIS IS temporarily removed because fetchFirst is invoked from
   openQuery before the browser is first viewed, so this makes it fail.
   I have to refine this logic, which is here to simulate the deactivation
   of the Navigation link.
    {get ObjectHidden lHidden}.
    IF lHidden THEN RETURN.
*/
    
    {get QueryHandle hQuery}.
    hBuffer = hQuery:GET-BUFFER-HANDLE(1).
    IF NOT hQuery:IS-OPEN THEN    /* NOTE: This points to the database Query */
      hQuery:QUERY-OPEN().     /* After an openQuery we must open T-T. */ 
    /* Check the RowIdent property first; if this is set, it means to set the
       initial position to that rowid. */
    &SCOPED-DEFINE xp-assign
    {get QueryRowIdent cRowIdent}
    {set QueryRowIdent ?}.   /* Immediately reset once we have the value. */
    &UNDEFINE xp-assign
    IF cRowIdent NE ? AND cRowIdent NE "":U THEN
    DO:
      &SCOPED-DEFINE xp-assign
      {get SkipQueryRowIdent lSkipRowident}
      {set SkipQueryRowIdent FALSE}.   /* Immediately reset  */
      &UNDEFINE xp-assign
      rRowIDs = ?.       /* Fill in this array with all the rowids. */
      DO iRow = 1 TO NUM-ENTRIES(cRowIdent):
        rRowIDs[iRow] = TO-ROWID(ENTRY(iRow, cRowIdent)).
      END.        /* END DO iRow */
      lOK = hQuery:REPOSITION-TO-ROWID(rRowIDs).
      IF lOK THEN
      DO:
        hQuery:GET-NEXT().
        IF lSkipRowIdent THEN
          hQuery:GET-NEXT().

      END.
    END.    /* END DO cRowIdent */
    ELSE hQuery:GET-FIRST() NO-ERROR.
    IF hBuffer:AVAILABLE THEN  /*  ...unless no records satisfy the query. */
      {set QueryPosition 'FirstRecord':U}.   
    ELSE 
      {set QueryPosition 'NoRecordAvailable':U}.
    PUBLISH 'dataAvailable':U FROM TARGET-PROCEDURE ("FIRST":U).    
    {set NewBatchInfo '':U}.
  RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fetchFirstBatch) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE fetchFirstBatch Procedure 
PROCEDURE fetchFirstBatch :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/   
   DEFINE VARIABLE iRowsReturned  AS INTEGER    NO-UNDO.
   DEFINE VARIABLE hQuery         AS HANDLE     NO-UNDO.
   
   {set FetchOnOpen ''}.
   {fn openQuery}.
   
   RUN transferRows IN TARGET-PROCEDURE (NO,
                                         'FIRST':U,
                                         "":U,
                                         NO,
                                         ?,
                                         OUTPUT iRowsReturned).
   
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fetchLast) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE fetchLast Procedure 
PROCEDURE fetchLast :
/*------------------------------------------------------------------------------
  Purpose:     Repositions the database query to the last row.
  
  Parameters:  <none>
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hQuery     AS HANDLE  NO-UNDO.
  DEFINE VARIABLE hBuffer    AS HANDLE  NO-UNDO.
  DEFINE VARIABLE lHidden    AS LOGICAL NO-UNDO.
  
    /* IF this object is currently hidden, then just return. This effectively
       makes the link inactive. */
    {get ObjectHidden lHidden}.
    IF lHidden THEN RETURN.
 
    {get QueryHandle hQuery}.
    IF NOT hQuery:IS-OPEN THEN RETURN. 
    ASSIGN hBuffer    = hQuery:GET-BUFFER-HANDLE(1).
    
    hQuery:GET-LAST().
    IF hBuffer:AVAILABLE THEN
      {set QueryPosition 'LastRecord':U}.
    
    /* Signal row change in any case. */
    PUBLISH 'dataAvailable':U FROM TARGET-PROCEDURE ("LAST":U).
    {set NewBatchInfo '':U}.
  RETURN.  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fetchLastBatch) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE fetchLastBatch Procedure 
PROCEDURE fetchLastBatch :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/   
   DEFINE VARIABLE iRowsReturned  AS INTEGER    NO-UNDO.
   DEFINE VARIABLE hQuery         AS HANDLE     NO-UNDO.
   
   {set FetchOnOpen ''}.
   {fn openQuery}.
   
   RUN transferRows IN TARGET-PROCEDURE (NO,
                                         'LAST':U,
                                         "":U,
                                         NO,
                                         ?,
                                         OUTPUT iRowsReturned).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fetchNext) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE fetchNext Procedure 
PROCEDURE fetchNext :
/*------------------------------------------------------------------------------
  Purpose:     Repositions the database query to the next row.
  
  Parameters:  <none>
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hQuery       AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hBuffer      AS HANDLE    NO-UNDO.
  DEFINE VARIABLE lHidden      AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE iCnt         AS INTEGER   NO-UNDO.
  DEFINE VARIABLE iFirstRow    AS INTEGER   NO-UNDO.
  DEFINE VARIABLE iLastRow     AS INTEGER   NO-UNDO.
  DEFINE VARIABLE cLastDbRowId AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cQueryPos    AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cRow         AS CHARACTER NO-UNDO.

   /* IF this object is currently hidden, then just return. This effectively
       makes the link inactive. */
    {get ObjectHidden lHidden}.
    IF lHidden THEN RETURN.
 
    {get QueryHandle hQuery}.
    IF NOT hQuery:IS-OPEN         
      THEN RETURN.
      
    hBuffer = hQuery:GET-BUFFER-HANDLE(1).  
    
    {get QueryPosition cQueryPos}.  /* Return if already at end. */
    IF cQueryPos = 'LastRecord':U THEN 
      RETURN.
    
    hQuery:GET-NEXT().
    IF NOT hBuffer:AVAILABLE THEN
    DO:                                 /* No data so reget the last row. */
      hQuery:GET-LAST().
      {set QueryPosition 'LastRecord':U}.
    END.
    ELSE DO:
      /* We need to get the rowids set when the query was opened for the 
         last row of the query, we then need to compare that to this row
         to determine if we are on the last row.  If we are on the last
         row we need to set QueryPosition to 'LastRecord' */
      {get LastDbRowIdent cLastDbRowId}.
      DO iCnt = 1 TO hQuery:NUM-BUFFERS:  /* Assemble the list of rowids */
        ASSIGN hBuffer = hQuery:GET-BUFFER-HANDLE(iCnt)
               cRow   = cRow + 
                    (IF cRow NE "":U THEN ",":U ELSE "":U)
                      + STRING(hBuffer:ROWID).      
      END.  /* do iCnt 1 to num-buffers */
      IF cLastDbRowId = cRow THEN 
        {set QueryPosition 'LastRecord':U}.
      ELSE IF cQueryPos = 'FirstRecord':U THEN
        {set QueryPosition 'NotFirstOrLast':U}.
    END.  /* else do */
 
    /* Signal row change in any case. */
    PUBLISH 'dataAvailable':U FROM TARGET-PROCEDURE ("NEXT":U).
    {set NewBatchInfo '':U}.
  RETURN.  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fetchNextBatch) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE fetchNextBatch Procedure 
PROCEDURE fetchNextBatch :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/   
   DEFINE VARIABLE iRowsReturned   AS INTEGER    NO-UNDO.
   DEFINE VARIABLE hQuery          AS HANDLE     NO-UNDO.
   DEFINE VARIABLE lFillBatch      AS LOGICAL    NO-UNDO.
   DEFINE VARIABLE hDataQuery      AS HANDLE     NO-UNDO.
   
   &SCOPED-DEFINE xp-assign
   {set FetchOnOpen '':U}
   {get DataHandle hDataQuery}.
   &UNDEFINE xp-assign
   
   /* close query to avoid openQuery wiping out all batchprops */ 
   hdataQuery:QUERY-CLOSE.
   {fn openQuery}.
   {fnarg emptyRowObject '':U}.
   {get FillBatchOnRepos lFillBatch}.

   RUN transferRows IN TARGET-PROCEDURE (NO,
                                         'Next':U,
                                         "":U,
                                         lFillBatch,
                                         ?,
                                         OUTPUT iRowsReturned).
   
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fetchPrev) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE fetchPrev Procedure 
PROCEDURE fetchPrev :
/*------------------------------------------------------------------------------
  Purpose:     Repositions the database query to the previous row.
  
  Parameters:  <none>
------------------------------------------------------------------------------*/

  DEFINE VARIABLE hQuery     AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hBuffer    AS HANDLE    NO-UNDO.
  DEFINE VARIABLE lHidden    AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE cQueryPos  AS CHARACTER NO-UNDO.
    
    /* IF this object is currently hidden, then just return. This effectively
       makes the link inactive. */
    {get ObjectHidden lHidden}.
    IF lHidden THEN 
      RETURN.
 
    {get QueryHandle hQuery}.
    ASSIGN hBuffer    = hQuery:GET-BUFFER-HANDLE(1).
    IF (NOT hQuery:IS-OPEN)      
        THEN RETURN.
        
    hQuery:GET-PREV().
    
    /* If we have moved to the first record or away from the last, then
       signal a change of record position state. */
    IF hQuery:QUERY-OFF-END THEN
    DO:
      hQuery:GET-FIRST().
      {set QueryPosition 'FirstRecord':U}.
    END.
    ELSE DO:
      {get QueryPosition cQueryPos}.
      IF cQueryPos = 'LastRecord':U THEN
        {set QueryPosition 'NotFirstOrLast':U}.
      IF hQuery:CURRENT-RESULT-ROW = 1 THEN
        {set QueryPosition 'FirstRecord':U}.
    END.   /* ELSE DO IF NOT OFF-END */
        
    /* Signal row change in any case. */
    PUBLISH 'dataAvailable':U FROM TARGET-PROCEDURE ("PREV":U).
    {set NewBatchInfo '':U}.
  RETURN.  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fetchPrevBatch) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE fetchPrevBatch Procedure 
PROCEDURE fetchPrevBatch :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/   
   DEFINE VARIABLE iRowsReturned   AS INTEGER    NO-UNDO.
   DEFINE VARIABLE hQuery          AS HANDLE     NO-UNDO.
   DEFINE VARIABLE lFillBatch      AS LOGICAL    NO-UNDO.
   DEFINE VARIABLE hDataQuery      AS HANDLE     NO-UNDO.

   &SCOPED-DEFINE xp-assign
   {set FetchOnOpen '':U}
   {get DataHandle hDataQuery}.
   &UNDEFINE xp-assign
   
   /* close query to avoid openQuery wiping out all batchprops */ 
   hdataQuery:QUERY-CLOSE.

   {fn openQuery}.
   {fnarg emptyRowObject '':U}.
   {get FillBatchOnRepos lFillBatch}.

   RUN transferRows IN TARGET-PROCEDURE (NO,
                                         'Prev':U,
                                         "":U,
                                         lFillBatch,
                                         ?,
                                         OUTPUT iRowsReturned).
   
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-initializeEntityDetails) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeEntityDetails Procedure 
PROCEDURE initializeEntityDetails :
/*------------------------------------------------------------------------------
  Purpose:    Retrieve entityDetails from the Repository and set properties
              from it.    
  Parameters: <none> 
  Notes:      This is currently only called if asdivision <> 'client'. 
              'Client' proxys get these properties from the server as first 
              time props.
Note Date: 2002/07/07                  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cKeyTableEntityFields   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cKeyTableEntityValues   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cKeyTableEntityMnemonic AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cKeyTableEntityObjField AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lHasObjectField         AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE iLookup                 AS INTEGER    NO-UNDO.
  DEFINE VARIABLE lAuditEnabled           AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lFetchHasAudit          AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lFetchHasComment        AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lFetchAutoComment       AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lHasAudit               AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lHasComment             AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lHasAutoComment         AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cEntityFields           AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cKeyTable               AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cPhysicalTables         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cTables                 AS CHARACTER  NO-UNDO.

 IF VALID-HANDLE(gshGenManager) THEN  
 DO:
   &SCOPED-DEFINE xp-assign
   {get EnabledTables cKeyTable}
   {get PhysicalTables cPhysicalTables}
   {get Tables cTables}
   {get FetchHasComment lFetchHasComment}
   {get FetchHasAudit   lFetchHasAudit}
   {get FetchAutoComment lFetchAutoComment}
   .
   &UNDEFINE xp-assign
   /* First enabled .. */
   cKeyTable = ENTRY(1,cKeyTable).

   /* The Physical Table name need to be passed to the Repository */ 
   IF cKeyTable <> '':U THEN
     cKeyTable = ENTRY(LOOKUP(cKeyTable,cTables),cPhysicalTables).
   
   /* if no enabled use the first table */
   ELSE
     cKeyTable = ENTRY(1,cPhysicalTables).

   IF cKeyTable <> "":U THEN
   DO:     
     cKeyTable = cKeyTable
               + ',entity_mnemonic,table_has_object_field,entity_object_field,entity_key_field'
               + (IF lFetchHasAudit    THEN ',HasAudit':U   ELSE '':U)
               + (IF lFetchHasComment  THEN ',HasComment':U ELSE '':U)
               + (IF lFetchAutoComment THEN ',HasAutoComment':U ELSE '':U)
               + ",auditing_enabled".

     RUN getEntityDetail IN gshGenManager
                        (INPUT  cKeyTable,
                         OUTPUT cKeyTableEntityFields,
                         OUTPUT cKeyTableEntityValues) NO-ERROR.
     IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN
     DO:
       {checkerr.i &display-error = "YES"}
     END.
     IF cKeyTableEntityFields <> "":U THEN 
     DO:
       iLookup = LOOKUP("entity_mnemonic",cKeyTableEntityFields,CHR(1)).
       IF iLookup > 0 THEN
         ASSIGN cKeyTableEntityMnemonic = ENTRY(iLookup,cKeyTableEntityValues,CHR(1)).
 
       iLookup = LOOKUP("table_has_object_field",cKeyTableEntityFields,CHR(1)).
       IF iLookup > 0 THEN
         ASSIGN lHasObjectField = CAN-DO("TRUE,YES",ENTRY(iLookup,cKeyTableEntityValues,CHR(1) )).
      
       iLookup = LOOKUP("auditing_enabled",cKeyTableEntityFields,CHR(1)).
       IF iLookup > 0 THEN
         ASSIGN lAuditEnabled = CAN-DO("TRUE,YES",ENTRY(iLookup,cKeyTableEntityValues,CHR(1) )).

       IF lHasObjectField THEN
       DO:
         IF LOOKUP("entity_object_field",cKeyTableEntityFields,CHR(1)) <> 0 THEN 
           ASSIGN cKeyTableEntityObjField = ENTRY( LOOKUP("entity_object_field",cKeyTableEntityFields,CHR(1)) ,cKeyTableEntityValues,CHR(1) ).
       END.
       ELSE
         IF LOOKUP("entity_key_field",cKeyTableEntityFields,CHR(1)) <> 0 THEN 
           ASSIGN cKeyTableEntityObjField = ENTRY( LOOKUP("entity_key_field",cKeyTableEntityFields,CHR(1)) ,cKeyTableEntityValues,CHR(1) ).
       
       iLookup = IF lFetchHasAudit 
                 THEN LOOKUP("HasAudit",cKeyTableEntityFields,CHR(1)) 
                 ELSE 0.

       IF iLookup > 0 THEN
         ASSIGN lHasAudit = CAN-DO("TRUE,YES",ENTRY(iLookup,cKeyTableEntityValues,CHR(1) )).

       iLookup= IF lFetchHasComment 
                THEN LOOKUP("HasComment",cKeyTableEntityFields,CHR(1))
                ELSE 0.

       IF iLookup > 0 THEN
         ASSIGN lHasComment = CAN-DO("TRUE,YES",ENTRY(iLookup,cKeyTableEntityValues,CHR(1) )).

       iLookup= IF lFetchAutoComment 
                THEN LOOKUP("HasAutoComment",cKeyTableEntityFields,CHR(1))
                ELSE 0. 
       IF iLookup > 0 THEN
         ASSIGN lHasAutoComment = CAN-DO("TRUE,YES",ENTRY(iLookup,cKeyTableEntityValues,CHR(1) )).

       cEntityFields = (IF lHasAudit THEN 'HasAudit,':U ELSE '':U)
                        +
                       (IF lHasComment THEN 'HasComment,':U ELSE '':U)
                        +
                       (IF lHasAutoComment THEN 'AutoComment':U ELSE '':U).
        &SCOPED-DEFINE xp-assign
        {set KeyTableId  cKeyTableEntityMnemonic}
        {set KeyFields  cKeyTableEntityObjField}
        {set AuditEnabled lAuditEnabled}.
        &UNDEFINE xp-assign

     END.
   END. /* KeyTable <> '' */
   /* This needs to be set in any case to make sure that this procedure is not run again */
   {set EntityFields cEntityFields}.
 END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-initializeObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeObject Procedure 
PROCEDURE initializeObject :
/*------------------------------------------------------------------------------
  Purpose:     Initialization code for query object.
  
  Parameters:  <none>
  
  Notes:       The query is not opened if we have a DataSource. This is because
               a DataSource means the object is dependent on data from another
               object. In this case the Data-Target (this procedure) waits
               until the dataAvailable event tells it to open its query. 
               Instead, this procedure RUNs dataAvailable to see if its 
               DataSource is already running with a row available for it;
               in that case the dataAvailable will open the query.
              -------------  
   DEPRECATED in adm2 - NOT CALLED FROM data class  
              --------------
              Logic to call openQuery or dataAvailable is here in the unlikely 
              case that objects exists that inherits directly from this class. 
  ------------------------------------------------------------------------------*/
  DEFINE VARIABLE hDataSource     AS HANDLE    NO-UNDO.
  DEFINE VARIABLE cUIBMOde        AS CHARACTER NO-UNDO.
  DEFINE VARIABLE lOpenOnInit     AS LOGICAL   NO-UNDO.
  
  /* Don't open query in design mode  */
  &SCOPED-DEFINE xp-assign
  {get UIBMode cUIBMode}
  {get OpenOnInit lOpenOnInit}  /* Suppress normal automatic openQuery */
  {get DataSource hDataSource}
  {set ObjectInitialized YES}
   .
  &UNDEFINE xp-assign
  
  IF (NOT cUIBMode BEGINS "Design":U) THEN 
  DO:
    IF lOpenOnInit THEN
    DO:
      IF hDataSource = ? THEN 
        {fn openQuery}.
      ELSE 
        RUN dataAvailable IN TARGET-PROCEDURE (?).  /* Don't know if different row. */
    END.
  END.

  RETURN.
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
  Notes:  The order of the 3 input lists are similar to various query 
          manipulation methods, while the single similar output parameters is in
          the order they are supposed to be used.. 
       -  The caller is responsible to ensure that entries that is found in a 
          buffer is not checked again against another table as the same 
          unqualifed column may be found in several tables.
       -  Unqualified columns are ALWAYS assumed to be database references also
          when buffer is RowObject. (This is due to the fact that this is used 
          from findRowWhere -> findRowObjectWhere -> and we do not want to keep 
          changing qualifiers through the calls, so we follow the rule of the 
          outer ..)                      
          
  PRIVATE - Not sufficiently self contained, since the table resolution is not 
            embedded here. 'salesrep' would be resolved both for order and 
            customer. This could be fixed by checking all tables in one call, 
            but this would be even more expensive 
            (only for the unqualified fields not on the SDO though)  
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
  DEFINE VARIABLE cResolvedColumn AS CHARACTER  NO-UNDO.

  pcColumn     = ENTRY(piColumn,pcColumnList).

  /* if buffer 'RowObject' we change all column references to RowObject names,
     but unqualified columns are assumed to be db reference    */
  IF pcBuffer = 'RowObject':U THEN
  DO:
    IF NOT (pcColumn BEGINS "RowObject":U + ".":U) THEN        
       pcColumn =  DYNAMIC-FUNCTION("dbColumnDataName":U IN TARGET-PROCEDURE,
                                     pcColumn).   

  END.
  ELSE DO:
    /* Convert rowObject reference to db reference */
    IF pcColumn BEGINS "RowObject":U + ".":U THEN        
      pcColumn =  DYNAMIC-FUNCTION("columnDBColumn":U IN TARGET-PROCEDURE,
                                    ENTRY(2,pcColumn,".":U)).                                      
         
   /* If unqualified add buffer to column and check if it is a match. 
      We want to return the column as found in list, otherwise we could just 
      have added pcBuffer and used the check below.    
      NOTE: columnTable only checks server if qualified*/   
    IF NUM-ENTRIES(pcColumn,'.':U) = 1 THEN
    DO:
      /* May need server call if not in SDO! */
      IF {fnarg columnTable "pcBuffer + '.':U + pcColumn"} <> pcBuffer THEN 
        pcColumn = '':U.  
    END. 
   
    /* Wrong buffer or wrong qualification? */    
    ELSE IF NOT (pcColumn BEGINS pcBuffer + ".":U) THEN 
    DO: 
      /* If the column db qualification does not match the query's 
        check to see if it is the correct table after all */                                
      IF NUM-ENTRIES(pcColumn,".":U) - 1 <> NUM-ENTRIES(pcBuffer,".":U) THEN
      DO:           
        /* May go to server if this column is not in the rowobject! */ 
        IF {fnarg columnTable pcColumn} <> pcBuffer THEN 
          pcColumn = '':U.  
      END.
      ELSE /* wrong buffer */
        pcColumn = '':U. 
    END. /* column not matching buffer  */    
  
    /* else if the column is in NOT in the RowObject, we check if it is
       exists in table on server (expensive!) */
    ELSE IF {fnarg dbColumnDataName pcColumn} = '':U THEN
    DO:
      /* Server call! */
      IF {fnarg columnTable pcColumn} <> pcBuffer THEN 
        pcColumn = '':U.  
    END.
  END.

  IF pcColumn > '':U THEN

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
                        
        
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-processDBRowForUpdate) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE processDBRowForUpdate Procedure 
PROCEDURE processDBRowForUpdate :
/*------------------------------------------------------------------------------
  Purpose:  fetches buffers for update with exlusive lock, checks for conflicts
            and deletes buffers that is to be deleted and collects and prepares 
            errors if not avail, locked or optimistic locking conflict 
              
  Parameters:  
   output pocUndoIds - list of any RowObject ROWNUM whose changes need to be 
                        undone as the result of errors in the form of:
             "RowNumCHR(3)<adm-error-string>,..." 
              where <adm-error-flag> is blank or adm-fields-changed for conflict
  Notes:    A wrapper for fetchDBRowForUpdate that also does error handling.    
------------------------------------------------------------------------------*/
  DEFINE OUTPUT PARAMETER pocUndoIds AS CHARACTER   NO-UNDO.
  
  DEFINE VARIABLE hRowObjUpd   AS HANDLE    NO-UNDO.
  DEFINE VARIABLE cErrorType   AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cErrorTable  AS CHARACTER NO-UNDO.
  DEFINE VARIABLE iNumEntries  AS INTEGER   NO-UNDO.
  DEFINE VARIABLE cReturnValue AS CHARACTER NO-UNDO. 
  DEFINE VARIABLE cDeleteMsg   AS CHARACTER NO-UNDO. 
  DEFINE VARIABLE hRowObjUpd2  AS HANDLE    NO-UNDO.
  DEFINE VARIABLE cRowNum      AS CHARACTER NO-UNDO. 
 
  RUN fetchDBRowForUpdate IN TARGET-PROCEDURE.
  IF RETURN-VALUE NE "":U THEN
  DO:
    cReturnValue = RETURN-VALUE.
    {get RowObjUpd hRowObjUpd}.
 
    assign
      iNumEntries  = NUM-ENTRIES(cReturnValue)
      cErrorTable  = entry(1,cReturnValue)     
      cErrorType  = if iNumEntries > 1 then 
                    entry(iNumEntries,cReturnValue)
                    else 'lock':U
      cRowNum     = STRING(hRowObjUpd:BUFFER-FIELD('RowNum':U):BUFFER-VALUE).
    
    if cErrorType = "lock":U then
    do: 
      RUN addMessage IN TARGET-PROCEDURE ({fnarg messageNumber 18}, ?, cErrorTable).
      pocUndoIds = pocUndoIds + cRowNum + CHR(3) + ",":U.     
    end.                 
    /* fetchDbRowForUpdate will return "Delete" as LAST element of the 
       return-value if the Delete failed. */
    else if cErrorType = "Delete":U then
    do:
      if num-entries(cReturnValue) = 2 THEN
         cDeleteMsg = {fnarg messageNumber 23}.
      ELSE /* support return-value from triggers */
        ASSIGN 
          cDeleteMsg = cReturnValue 
          ENTRY(NUM-ENTRIES(cDeleteMsg),cDeleteMsg) = "":U
          ENTRY(1,cDeleteMsg) = "":U
          cDeleteMsg = TRIM(cDeleteMsg,",":U).
      RUN addMessage IN TARGET-PROCEDURE (cDeleteMsg, ?, cErrorTable).
      pocUndoIds = pocUndoIds + cRowNum + CHR(3) + ",":U.     
    END. /* if entry(num-entries(return-value) = 'delete' */ 
     /* Table name that didn't compare is returned with <conflict> as last entry. */
    else if cErrorType = "<conflict>" then 
    DO:
      RUN addMessage IN TARGET-PROCEDURE
                  (SUBSTITUTE({fnarg messageNumber 8}, '':U /* No field names available. */) , ?, 
                   cErrorTable  /* Table name that didn't compare */).
      pocUndoIds = pocUndoIds + cRowNum + CHR(3) + "ADM-FIELDS-CHANGED":U + ",":U.
      
      if hRowObjUpd:buffer-field('RowMod':U):buffer-value = "D" then
        hRowObjUpd2 = hRowObjUpd.
      else do:
        /* Get the changed version of the record in order to copy
           the new database values into it to pass back to the client.*/
        CREATE BUFFER hRowObjUpd2 FOR TABLE hRowObjUpd.
        hRowObjUpd2:FIND-FIRST('WHERE RowMod = "U" AND RowNum = ':U + cRowNum).
      end.
      RUN refetchDBRow IN TARGET-PROCEDURE (INPUT hRowObjUpd2) NO-ERROR.            
      if hRowObjUpd2 <> hRowObjUpd then
        delete object hRowObjUpd2.
   
      IF ERROR-STATUS:ERROR THEN
      DO:
        /* Errors are now added to the message queue in refetchDbRow, 
           but we still check for return-value just in case.. */ 
        IF RETURN-VALUE <> '':U THEN
          RUN addMessage IN TARGET-PROCEDURE (RETURN-VALUE, ?, ?).
        pocUndoIds = pocUndoIds + cRowNum + CHR(3) + ",":U.     
      END.  /* If ERROR */
    end. /* <conflict> */  
  end. /* return-value <> '' */ 
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-refetchDBRow) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE refetchDBRow Procedure 
PROCEDURE refetchDBRow :
/*------------------------------------------------------------------------------
  Purpose:     Re-reads the current database record(s) to get any field values
               which may have been changed by update triggers, and repopulates 
               the RowObjUpd row with those values.
  
  Parameters:
    INPUT phRowObjUpd - handle of the Update temp-table buffer to be used. Note 
                        that this is required because the caller uses two 
                        different buffers in some cases.
------------------------------------------------------------------------------*/  
  DEFINE INPUT PARAMETER phRowObjUpd    AS HANDLE    NO-UNDO.
  
  DEFINE VARIABLE cBuffers       AS CHARACTER NO-UNDO.
  DEFINE VARIABLE hBuffer        AS HANDLE    NO-UNDO.
  DEFINE VARIABLE iTable         AS INTEGER   NO-UNDO.
  DEFINE VARIABLE rRowid         AS ROWID     NO-UNDO.
  DEFINE VARIABLE hRowIdent      AS HANDLE    NO-UNDO.
  DEFINE VARIABLE cRowIdent      AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cAssigns       AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cExclude       AS CHARACTER NO-UNDO.
  DEFINE VARIABLE lFound         AS LOG       NO-UNDO.
  DEFINE VARIABLE hRowObject     AS HANDLE    NO-UNDO.
  DEFINE VARIABLE cColumns       AS CHARACTER NO-UNDO.
  DEFINE VARIABLE iColumn        AS INTEGER   NO-UNDO.
  DEFINE VARIABLE hColumn        AS HANDLE    NO-UNDO.
  DEFINE VARIABLE iCalc          AS INTEGER   NO-UNDO.
  DEFINE VARIABLE cCalcCol       AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cCalculatedColumns AS CHARACTER NO-UNDO.
  DEFINE VARIABLE rRORowid       AS ROWID      NO-UNDO.
  DEFINE VARIABLE cTables        AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cTable         AS CHARACTER NO-UNDO.
  
  &SCOPED-DEFINE xp-assign
  {get BufferHandles cBuffers}       /* Database buffer handles */
  {get Tables cTables}               /* DB buffer names  */
    /* This is the list of fields whose RowObject names are different from
     the database names. */
  {get AssignList cAssigns}.
  &UNDEFINE xp-assign
  
  ASSIGN hRowIdent   = phRowObjUpd:BUFFER-FIELD('RowIdent':U)
         cRowIdent   = hRowIdent:BUFFER-VALUE.
  
  IF NUM-ENTRIES(cRowident) > 1 THEN
  DO:
    /* Refresh rowids for 'readonly' tables in the join */
    cRowIdent = DYNAMIC-FUNCTION('refreshRowident':U IN TARGET-PROCEDURE,
                                  cRowIdent).
    hRowIdent:BUFFER-VALUE = cRowIdent.
  END. /* Num-entries(cRowIdent) > 1 */
  DO iTable = 1 TO NUM-ENTRIES(cBuffers):   
    IF ENTRY(iTable, cRowIdent) NE "":U THEN
    DO:         
      ASSIGN hBuffer = WIDGET-HANDLE(ENTRY(iTable, cBuffers))
             rRowid  = TO-ROWID(ENTRY(iTable, cRowIdent))
             cTable = entry(iTable,cTables)
             lFound  = FALSE. /* buffer-release ERROR will undo - not set lfound*/

      /* Due to a core issue, FIND-BY-ROWID will *not* fire WRITE triggers. 
         Releasing the buffer will properly fire any WRITE triggers and will 
         return false if any trigger returned an error..*/
      DO ON ERROR UNDO, LEAVE:
        lFound = hBuffer:BUFFER-RELEASE() NO-ERROR.
      END.
      
      IF NOT lFound THEN
      DO:
        RUN addMessage IN TARGET-PROCEDURE 
              (IF RETURN-VALUE = '':U THEN ? ELSE RETURN-VALUE,?,?).  
        RETURN ERROR.
      END.
      
      if dynamic-function("bufferExclusiveLock":U in target-procedure,cTable,phRowObjUpd::RowMod) then 
        lFound = hBuffer:FIND-BY-ROWID(rRowid, EXCLUSIVE-LOCK, NO-WAIT).
      else
        lFound = hBuffer:FIND-BY-ROWID(rRowid, NO-LOCK).
      
      /* See comments above... 
         find-by-rowid will fire triggers when called from the transaction block,
         if the trigger returns ERROR find-by-rowid will return false
         A return-value will be returned to the user thru adm messaging */ 
      IF NOT lFound THEN 
      DO:
        RUN addMessage IN TARGET-PROCEDURE 
                (IF hBuffer:LOCKED 
                 THEN {fnarg messageNumber 18} 
                 ELSE RETURN-VALUE,
                 ?,
                 cTable).  
        RETURN ERROR. 
      END.

      cExclude = {fnarg excludeColumns iTable}.
      IF INDEX(cAssigns, "[":U) = 0 THEN
        phRowObjUpd:BUFFER-COPY(hBuffer, cExclude /* exclude-list */,
          ENTRY(iTable, cAssigns, {&adm-tabledelimiter})).  /* Get changed fld names if any */
      ELSE  /* If array elements are present, we must assign them manually. */
        RUN BufferCopyDBToRO(phRowObjUpd, hBuffer, cExclude,
          ENTRY(iTable, cAssigns, {&adm-tabledelimiter})).
    END.
    ELSE DO: 
      /* If the rowid is blank, blank the fields */
      {get DataColumnsByTable cColumns}.
      cColumns = ENTRY(iTable,cColumns,{&adm-tabledelimiter}).
      
      DO iColumn = 1 TO NUM-ENTRIES(cColumns):
        ASSIGN
          hColumn = phRowObjUpd:BUFFER-FIELD(ENTRY(iColumn,cColumns))
          hColumn:BUFFER-VALUE = '':U.  /* This sets non-char fields to ? */
      END. /* do icolumn = 1 to num-entries */
    END.    
  END.    /* END DO iTable */
  
  /* If there are calculated fields, make sure they are updated */
  {get CalculatedColumns cCalculatedColumns}.
  IF cCalculatedColumns > '':U THEN
  DO:        
    {get RowObject hRowObject}.           /* Buffer handle for RowObject table */
    rRORowid = hRowObject:ROWID.
    hRowObject:BUFFER-CREATE().           /* Create "dummy" RowObject record */ 
    hRowObject:BUFFER-COPY(phRowObjUpd).  /* Copy RowObjUpd to RowObject */
    RUN Data.Calculate IN TARGET-PROCEDURE NO-ERROR.  /* Updates RowObject */
    IF ERROR-STATUS:GET-NUMBER(1) = 6456 THEN
    DO:
      DO iCalc = 1 TO NUM-ENTRIES(cCalculatedColumns):
        cCalcCol = ENTRY(iCalc,cCalculatedColumns).
        hRowObject:BUFFER-FIELD(cCalcCol):BUFFER-VALUE
           = DYNAMIC-FUNCTION('{&calculateprefix}':U + cCalcCol IN TARGET-PROCEDURE) NO-ERROR.                   
      END.
    END.
    phRowObjUpd:BUFFER-COPY(hRowObject).  /* Copy updated RowObject to RowObjUpd */
    hRowObject:BUFFER-DELETE().           /* Clean up */
    IF rRORowid <> ? AND rRORowid <> hRowObject:ROWID THEN
      hRowObject:FIND-BY-ROWID(rRORowid).  
  END.

  RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-releaseDBRow) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE releaseDBRow Procedure 
PROCEDURE releaseDBRow :
/*------------------------------------------------------------------------------
  Purpose:     Releases the database records following an update.
  
  Parameters:  <none>
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cBuffers AS CHARACTER NO-UNDO.
  DEFINE VARIABLE hBuffer  AS HANDLE    NO-UNDO.
  DEFINE VARIABLE iTable   AS INTEGER   NO-UNDO.
  
  {get BufferHandles cBuffers}.
  DO iTable = 1 TO NUM-ENTRIES(cBuffers):
    hBuffer = WIDGET-HANDLE(ENTRY(iTable, cBuffers)).
    IF hBuffer:AVAILABLE THEN hBuffer:BUFFER-RELEASE().
  END.   /* END DO iTable */
  
  RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-transferDBRow) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE transferDBRow Procedure 
PROCEDURE transferDBRow :
/*------------------------------------------------------------------------------
  Purpose:     This procedure buffer-copies the database record(s) for the
               current query row into the RowObject temp-table.
               
  Parameters:
    INPUT pcRowIdent - comma-separated list consisting of the RowId of the 
                       RowObject record followed by the RowIds of the
                       database record(s); if unknown or blank, then the 
                       database records have already been retrieved.
    INPUT piRowNum   - integer value to assign to the RowNum
                       field in the RowObject temp-table record.
     
  Notes:       This procedure replaces the transferRowFromDB function from V9.0.
               It can be localized to perform additional custom operations
               each time a row is tramsferred from the database to the 
               RowObject table.
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pcRowIdent AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER piRowNum   AS INTEGER   NO-UNDO.
  
  DEFINE VARIABLE iTable           AS INTEGER   NO-UNDO.
  DEFINE VARIABLE hBuffer          AS HANDLE    NO-UNDO.
  DEFINE VARIABLE cBuffers         AS CHARACTER NO-UNDO.
  DEFINE VARIABLE hRowObject       AS HANDLE    NO-UNDO.
  DEFINE VARIABLE rRowid           AS ROWID     NO-UNDO.
  DEFINE VARIABLE hField           AS HANDLE    NO-UNDO.
  DEFINE VARIABLE cAssigns         AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cExclude         AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cColumns         AS CHARACTER NO-UNDO.
  DEFINE VARIABLE hColumn          AS HANDLE    NO-UNDO.
  DEFINE VARIABLE iColumn          AS INTEGER   NO-UNDO.
  DEFINE VARIABLE iLoop            AS INTEGER   NO-UNDO.
  DEFINE VARIABLE cRowUserProp     AS CHARACTER NO-UNDO.  
  DEFINE VARIABLE iCalc            AS INTEGER   NO-UNDO.
  DEFINE VARIABLE cCalcCol         AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cCalculatedColumns AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cDefs             AS CHARACTER  NO-UNDO.

  {get BufferHandles cBuffers}.   /* List of DB Buffer Handles */

  IF NOT (PROGRAM-NAME(2) BEGINS 'transferDBRow':U) THEN
    {set SkiptransferDBRow TRUE}.
      
  {get RowObject hRowObject}.     /* Buffer handle for the RowObject table. */
  
  IF pcRowIdent = ? THEN
     pcRowIdent = "":U.
  IF pcRowIdent NE "":U THEN
    /* In this case (called from doCreateUpdate, e.g.), we need to
       re-retrieve a row that is no longer in the RowObject table.
       The RowIds if the db records are passed in to us. 
       Note that the first entry in pcRowIdent is ignored because it
       the RowId of the RowObject record itself. */
  DO iTable = 2 TO NUM-ENTRIES(pcRowIdent):
    ASSIGN hBuffer = WIDGET-HANDLE(ENTRY(iTable - 1, cBuffers)).
           rRowid = TO-ROWID(ENTRY(iTable, pcRowIdent)).
    hBuffer:FIND-BY-ROWID(rRowid) NO-ERROR.
  END.   /* END DO iTable */
   
  /* Buffer-Copy the database record(s) into the RowObject buffer. */
  pcRowIdent = "":U.
  /* First assign the RowNum and RowMod fields. */
  ASSIGN hField = hRowObject:BUFFER-FIELD('RowNum':U)
         hField:BUFFER-VALUE = piRowNum
         hField = hRowObject:BUFFER-FIELD('RowMod':U)
         hField:BUFFER-VALUE = "":U.
  
  &SCOPED-DEFINE xp-assign
  /* This is the list of fields whose RowObject names are different from
     the database names. */
  {get AssignList cAssigns}
  /* If there is more than one table in the query, we build an exclude list 
     in order to guarantee that buffer-copy only copies fields from the 
     intentional source. Excluding all fieldnames from all other tables 
     prevents a potential overwrite from an unintentional table. */
  {get DataColumnsByTable cColumns}.
  &UNDEFINE xp-assign
    
  DO iTable = 1 TO NUM-ENTRIES(cBuffers):
    IF iTable NE 1 THEN
      pcRowIdent = pcRowIdent + ",":U.
    hBuffer = WIDGET-HANDLE(ENTRY(iTable, cBuffers)).
    /* Allow for an outer join without a rec in every buffer. */
    IF hBuffer:AVAILABLE THEN
    DO:
      /* Exclude all fieldnames from all other tables to prevent a potential 
         overwrite from an unintentional table. */ 
      cExclude = {fnarg excludeColumns iTable}.
      /*
      /* Remove the columns from the iTable table from the excludelist */
      IF NUM-ENTRIES(cBuffers) > 1 THEN
      ASSIGN
        ENTRY(iTable,cColumns,{&adm-tabledelimiter}) = "":U
        cExclude = TRIM(REPLACE(cExclude,{&adm-tabledelimiter},",":U),",":U). 
         */
      IF INDEX(cAssigns, "[":U) = 0 THEN
        hRowObject:BUFFER-COPY
                     (hBuffer,
                      cExclude,
                      ENTRY(iTable, cAssigns, {&adm-tabledelimiter})).
      ELSE  /* If array elements are present, we must assign them manually. */
        RUN BufferCopyDBToRO
                   (hRowObject, 
                    hBuffer,
                    cExclude,
                    ENTRY(iTable, cAssigns, {&adm-tabledelimiter})).
      pcRowIdent = pcRowIdent + STRING(hBuffer:ROWID).
    END.    /* END DO IF AVAILABLE */
    ELSE DO:
      /* If no record available blank the fields */
      {get DataColumnsByTable cColumns}.
      cColumns = ENTRY(iTable,cColumns,{&adm-tabledelimiter}).
      
      DO iColumn = 1 TO NUM-ENTRIES(cColumns):
        ASSIGN
          hColumn = hRowObject:BUFFER-FIELD(ENTRY(iColumn,cColumns))
          hColumn:BUFFER-VALUE = '':U.  /* This sets non-char fields to ? */
      END. /* do icolumn = 1 to num-entries */
    END.
  END.      /* END DO iTable */
  
  {src/adm2/entityfields.i &rowobject=hRowObject &rowUserProp=cRowUserProp}
  
  ASSIGN hField = hRowObject:BUFFER-FIELD('RowIdentIdx':U)
         hField:BUFFER-VALUE = SUBSTR(pcRowIdent, 1, xiRocketIndexLimit)
         hField = hRowObject:BUFFER-FIELD('RowIdent':U)
         hField:BUFFER-VALUE = pcRowIdent
         hField = hRowObject:BUFFER-FIELD('RowUserProp':U)
         hField:BUFFER-VALUE = cRowUserProp NO-ERROR.
    
  RUN Data.Calculate IN TARGET-PROCEDURE NO-ERROR.
  IF ERROR-STATUS:GET-NUMBER(1) = 6456 THEN
  DO:
    {get CalculatedColumns cCalculatedColumns}.
    DO iCalc = 1 TO NUM-ENTRIES(cCalculatedColumns):
      cCalcCol = ENTRY(iCalc,cCalculatedColumns).
      hRowObject:BUFFER-FIELD(cCalcCol):BUFFER-VALUE
             = DYNAMIC-FUNCTION('{&calculateprefix}':U + cCalcCol IN TARGET-PROCEDURE) NO-ERROR.                   
     END.
  END.

  /* Erase everything from error-status from the run no-error   
     TRUE NO-ERROR  also works... but    */
  iloop = iloop NO-ERROR.

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-transferRows) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE transferRows Procedure 
PROCEDURE transferRows :
/*-----------------------------------------------------------------------------
  Purpose:     
  Parameters:  
   plAppend   - True indicates that we are appending to a resultset. 
                This flag ensures that we only change the batch property 
                in the end we are appending. Note that we may append to our 
                own local RowObject TT or to a resultset on the client
              - This is NOT the direct opposite of RebuildOnRepos. Prev and 
                next requests for a GUI client are for example always appending.
                A FIRST request should never be appending.           
   pcMode     - The mode defines how this new batch is added to an existing 
                batch. 
                - 'FIRST' - first batch.                                  
                - 'LAST'  - last batch. 
                - 'NEXT'  - next batch.
                - 'PREV'  - previous batch
                - 'REPOSITION[-FROM]'- Reposition use passed Rowident or expression, 
                   - sendRows with rowident and plNext=NO
                - 'REPOSITION-AFTER'- Reposition use passed Rowident or expression, 
                   - sendRows with rowident and plNext=YES 
                - 'REPOSITION-TO'  - Reposition use passed Rowident or expression.
                   - sendRows with rowident and plNext=NO and negative rowstoreturn
                - 'REPOSITION-BEFORE' - Reposition use passed Rowident or expression.
                   - sendRows with rowident and plNext=YES and negative rowstoreturn
                - 'REFRESH' indicates a refresh of current data.                                                                
   pcPosition  - This indicates which new record to position to in the new
                 batch of data for REFRESH and REPOSITION.                    
                 - RowNum;Rowident for pcPosition "REFRESH"
                 - Rowident or a Query String for "REPOSITION"                                  
   plFillBatch  - TRUE indicates that the batch should be filled with records
                  to the number specified in piRowstoReturn.  
                  This applies to 'prev', 'next' or 'reposition' request when 
                  plAppend is false. A 'prev' will behave almost as a 'first' 
                  while the others almost as a 'last', the position will 
                  be on the actual 'new' record.          
   pirowsToReturn - Number of requested records                                                   
                  - ?  Use RowsToBatch property
                  - 0  Read all records from current    
   OUTPUT pirowsReturned - The number of records actually added to the RowObject
                           Temp-table.
                                 
      Notes: Although Last and FirstResultRow currently is read here to 
             find the starting rownumber   
             The database query must be positioned BEFORE the first record that
              is to be read. We (currently) move forward in the query also when 
              pcMode is 'BOTTOM' (last or previous request). 
            - If pcMode <> 'Top' we ensure that the RowNum is high, also when 
              plAppend is false, since future 'prev' requests may need to 
              append record with lower Row Numbers.    
            - The 'TOP' or 'BOTTOM' also decides when to publish 
              DataAvailable('TRANSFER') when TransferChildrenForAll is false.       
----------------------------------------------------------------------------*/ 
 DEFINE INPUT  PARAMETER plAppend        AS LOGICAL    NO-UNDO.
 DEFINE INPUT  PARAMETER pcMode          AS CHARACTER  NO-UNDO. 
 DEFINE INPUT  PARAMETER pcPosition      AS CHARACTER  NO-UNDO.
 DEFINE INPUT  PARAMETER plFillBatch     AS LOGICAL    NO-UNDO.
 DEFINE INPUT  PARAMETER piRowsToReturn  AS INTEGER    NO-UNDO.
 DEFINE OUTPUT PARAMETER piRowsReturned  AS INTEGER    NO-UNDO.

 DEFINE VARIABLE hRowObject   AS HANDLE     NO-UNDO.
 
 DEFINE VARIABLE cLastResult     AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cFirstResult    AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cToColumn       AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cToVaLue        AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cRowIdent       AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE hQuery          AS HANDLE     NO-UNDO.
 DEFINE VARIABLE lSkipAPI        AS LOGICAL    NO-UNDO.
 DEFINE VARIABLE iBuffer         AS INTEGER    NO-UNDO.
 DEFINE VARIABLE hFirstBuffer    AS HANDLE     NO-UNDO.
 DEFINE VARIABLE cToPosition     AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE lOk             AS LOGICAL    NO-UNDO.
 DEFINE VARIABLE lRefresh        AS LOGICAL    NO-UNDO.
 DEFINE VARIABLE lFromTop        AS LOGICAL    NO-UNDO.
 DEFINE VARIABLE cStartRow       AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE rRowidList      AS ROWID EXTENT {&maxtables}  NO-UNDO.
 DEFINE VARIABLE lPos            AS LOGICAL    NO-UNDO.
 DEFINE VARIABLE lFound          AS LOGICAL    NO-UNDO.

 IF piRowsToReturn = ? THEN
   {get RowsToBatch piRowsToReturn}. 

  /* Ensure plFillbatch only is set when applicable to simplify logic below */ 
 IF plAppend THEN 
 DO:
   plFillbatch = FALSE.
   /* Maybe we can support these later, but it need some more work 
      ('reposition' is the same as 'reposition-from')  */ 
   IF pcMode BEGINS "Reposition-" AND pcPosition <> "Reposition-from":U THEN 
   DO:
      MESSAGE SUBSTITUTE({fnarg messageNumber 68}, QUOTER(pcMode)).
      RETURN.
   END.   
 END.
 
 &SCOPED-DEFINE xp-assign
 {get RowObject hRowObject}
 {get QueryHandle hQuery}. 
 &UNDEFINE xp-assign
  
 hFirstBuffer = hQuery:GET-BUFFER-HANDLE(1).

 /* Historically there has been problems with the buffer being available 
    and not in synch with the query. This problem was in sendRows and may 
    not be present here, but serious testing is required to ensure this 
    including dataServers.  */
 hFirstBuffer:BUFFER-RELEASE().

 &SCOPED-DEFINE xp-assign
 {get LastResultRow cLastResult}
 {get FirstResultRow cFirstResult}.
 &UNDEFINE xp-assign
                    
 /* Appending last is a big unlimited next... */ 
 IF plAppend AND pcMode = 'Last':U THEN
   ASSIGN 
     pcMode = 'Next':U
     piRowsToReturn = 0.
 /* Previous with no history is treated as last */
 ELSE IF pcMode = 'Prev':U AND cFirstResult  = ? THEN
   ASSIGN 
     pcMode = 'Last':U.

 CASE pcMode:
   WHEN 'First':U THEN 
   DO:
     hQuery:GET-FIRST.
     hQuery:REPOSITION-BACKWARDS(1).
     ASSIGN
       lFromTop = TRUE.
   END.
   WHEN 'Last':U THEN
   DO:
     hQuery:GET-LAST. 
     hQuery:REPOSITION-BACKWARDS(piRowsToReturn).
     ASSIGN
       lFromTop  = FALSE. 
   END.
   /* The rest of the modes does not reposition but sets cStartRow   */ 
   WHEN 'Next':U THEN
     ASSIGN
       lFromTop  = TRUE
       cStartRow = IF cLastResult = ? THEN ? 
                   ELSE ENTRY(2,cLastResult,';':U).
   WHEN 'Prev':U THEN
     ASSIGN
       lFromTop  = FALSE
       cStartRow = IF cFirstResult = ? THEN ? 
                   ELSE ENTRY(2,cFirstResult,';':U).
   WHEN 'Refresh':U THEN
   do:
      ASSIGN       
         lFromTop    = TRUE
         lRefresh    = TRUE
         cStartRow   = substring(pcPosition,index(pcPosition,';') + 1) /* ENTRY(2,pcPosition,';':U) */
         cToValue    = ENTRY(1,pcPosition,';':U)
         cToColumn   = "RowNum":U.
      IF INDEX(cStartRow,' ':U) > 0 THEN
      DO:
         cStartRow = DYNAMIC-FUNCTION('firstRowIds':U IN TARGET-PROCEDURE,
                                      cStartRow).  
         /* no record found */
         IF cStartRow = ? THEN
            RETURN.
      END.
   end.
   WHEN 'Current':U THEN
     ASSIGN
       lFromTop       = TRUE
       lRefresh       = TRUE
       cStartRow      = IF cFirstResult = ? THEN ? 
                        ELSE ENTRY(2,cFirstResult,';':U)
       cToColumn      = "Rowident":U
       cToValue       = ENTRY(2,cLastResult,';':U)
       plFillBatch    = IF cToValue > '':U THEN FALSE ELSE plFillBatch
       piRowsToReturn = IF cToValue > '':U THEN 0 ELSE piRowsToReturn.

   WHEN 'Reposition':U OR 
   WHEN 'Reposition-from':U OR 
   WHEN 'Reposition-after':U OR
   WHEN 'Reposition-to':U OR 
   WHEN 'Reposition-before':U THEN  
   DO:      
     IF INDEX(pcPosition,' ':U) > 0 THEN
     DO:
       pcPosition = DYNAMIC-FUNCTION('firstRowIds':U IN TARGET-PROCEDURE,
                                      pcPosition).  
       /* no record found */
       IF pcPosition = ? THEN
          RETURN.
     END.
     lFromTop = CAN-DO('Reposition,Reposition-from,Reposition-after':U,pcMode).
     IF NOT plAppend THEN
       ASSIGN
         cStartRow = pcPosition.
     ELSE DO:
       ASSIGN
         cStartRow     = IF cLastResult = ? THEN ? 
                         ELSE ENTRY(2,cLastResult,';':U)
         cToValue      = pcPosition.
       /* If appending and pcPosition is a rowident we do a direct repos here 
          to ensure that the record actually will be encountered in the batch
          (Otherwise we would read the whole batch) */ 
       IF INDEX(pcPosition,' ':U) = 0 THEN
       DO:
         DO iBuffer = 1 TO NUM-ENTRIES(cToValue):
           rRowIDList[iBuffer] = TO-ROWID(ENTRY(iBuffer, cToValue)) NO-ERROR.
         END.
         lFound = hQuery:REPOSITION-TO-ROWID(rRowidList) NO-ERROR.    
         IF NOT lFound THEN
           RETURN.
         /* if no startrow we have to go back to the first/top */ 
         IF cStartRow  = ? THEN
         DO:
           hQuery:GET-FIRST.
           hQuery:REPOSITION-BACKWARDS(1).
         END.
       END.
     END.
   END.
 END.
 
 IF cStartRow > '':U THEN
 DO:
   DO iBuffer = 1 TO NUM-ENTRIES(cStartRow):
     rRowIDList[iBuffer] = TO-ROWID(ENTRY(iBuffer, cStartRow)) NO-ERROR.
   END.
   lFound = hQuery:REPOSITION-TO-ROWID(rRowidList) NO-ERROR.    
   IF lFound THEN
   DO:     
     IF lFromTop THEN
     DO:
       IF pcMode = "NEXT":U OR pcMode = "REPOSITION-AFTER":U 
       /* Append search is the same as NEXT batch, the actual search is the 
          to value (also note that we only support one mode for append .
                   see error message at top)*/
       OR (pcMode BEGINS "REPOSITION":U AND plAppend) THEN
         hQuery:REPOSITION-FORWARD(1). 

       /* Check if we need to start higher to fill the batch */
       IF plFillBatch THEN
       DO:
         lPos = hQuery:REPOSITION-FORWARD(piRowsToReturn).
         /* We do not have enough records to fill the batch, so set TOvalue*/
         IF NOT lPos THEN
         DO:
           IF NOT lRefresh THEN /* for REFRESH, ToValue is already set to RowNum */
             cToValue  = cStartRow.
           IF pcMode = "NEXT":U OR pcMode = "REPOSITION-AFTER":U THEN
             cToPosition     = "AFTER":U.
         END.
         hQuery:REPOSITION-BACKWARD(piRowsToReturn). 
       END.
     END.
     ELSE DO:
       IF pcMode = "PREV":U OR pcMode = "REPOSITION-BEFORE":U THEN 
       DO:
         hQuery:REPOSITION-BACKWARD(piRowsToReturn). 
         ASSIGN
           cToValue        = cStartRow 
           cToPosition     = "BEFORE":U. 
       END.
       ELSE IF pcMode = "REPOSITION-TO":U THEN
       DO:
         hQuery:REPOSITION-BACKWARD(piRowsToReturn - 1). 
         ASSIGN
           cToValue       = cStartRow. 
       END.
     END. /* not from top */
   END.
   ELSE DO: 
     {set PositionForClient ?}.
     RETURN.
   END.
 END.

 IF cToValue > "":U AND cToColumn = "":U THEN
   cToColumn = "Rowident":U.
 
 RUN transferRowsFromDB IN TARGET-PROCEDURE 
                  (plAppend,
                   lFromTop,
                   cToColumn,
                   cToValue,
                   cToPosition,
                   plFillBatch,
                   YES,  /* open and position */
                   piRowsToReturn,
                   OUTPUT piRowsReturned).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-transferRowsFromDB) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE transferRowsFromDB Procedure 
PROCEDURE transferRowsFromDB PRIVATE :
/*------------------------------------------------------------------------------
    Purpose: Transfer database data to new RowObject rows navigating forward
             from the current position of the database query. 
  Parameters:  
   plAppend   - True indicates that we are appending to a resultset. 
                This flag ensures that we only change the batch property 
                in the end we are appending. We may append to our own local 
                RowObject TT or to a resultset on a client.
              - This is NOT the opposite of RebuildOnRepos. Prev and next 
                requests for a GUI client are always appending. A FIRST request 
                is never appending.           
  plFromTop   - Yes indicates that we are appending at the end (from the top),
                typically a next, first or reposition request. It may also 
                be a request for last if plAppend = yes.  
                No indicates that we are appending at the top, typically a 
                next with the current FIRSTposition as the end point 
                (To the top..). Also used for last request when append is
                false. This flag also tells whether the Row number to start
                on is to be read from the LastResultRow or the FirstResultRow.                 
 pcColumns    - RowObject column names used to find a particular row that
                we want to position to or in the case of a previous request 
                want to position BEFORE. 
               - ROwNum  - This is used as an indication of refresh that
                 starts the numbering on a particular row. (as it makes no sense
                 to search on a RowNum )
 pcValues     - The value(s) that corresponds to the pcColumns, delimited by 
                CHR(1).               
 pcPosition   - BLank indicates that the record specified in pcColumns and 
                pcValues is to be positioned at.  
                'Before' indicates that it defines the limit and that we are 
                positioning before it. This is typically set for a PREV 
                requests that starts higher to fill the batch.
                'After' indicates that it that we are positioning after it.
                This is typically set for NEXT requests                 
 plFillBatch  - This means that we continue to fill the batch after the record 
                has been encountered.     
 plOpen       - Yes indicates that the query should be opened and repositioned.                
 piRowsToReturn - Number of records to return 
                  0 - is no limit. 
                  if plAppend is YES and plFromTop is yes then this indicates  
                  how many recors to add AFTER the record is found as All 
                  records before it also need to be added.   
                                         
 OUTPUT piRowsReturned - The number of records actually added to the RowObject
                         Temp-table in this call.
 OUTPUT prRowId        - The rowid of the first or last NEW record added to 
                         the RowObject Temp-table in this call.
                                  
       Notes: The database query should be Positioned before this is called. 
            - The query is navigated in forward direction for ALL requests
              Positioning need to take this into account. A PREVious request 
              will thus need to pass the values that was the starting point 
              for the request as the stop value in the case where there are 
              fewer records than the indicated piRowsToReturn. The inclusive 
              flag should be set to NO to indicate that it should stop here 
              or be set to YES in order to fill the batch.                         
------------------------------------------------------------------------------*/
 DEFINE INPUT  PARAMETER plAppend       AS LOGICAL  NO-UNDO.
 DEFINE INPUT  PARAMETER plFromTop      AS LOGICAL  NO-UNDO.
 DEFINE INPUT  PARAMETER pcColumns      AS CHARACTER  NO-UNDO. 
 DEFINE INPUT  PARAMETER pcValues       AS CHARACTER  NO-UNDO.
 DEFINE INPUT  PARAMETER pcPosition     AS CHARACTER  NO-UNDO.
 DEFINE INPUT  PARAMETER plFillBatch    AS LOGICAL    NO-UNDO.
 DEFINE INPUT  PARAMETER plOpen         AS LOGICAL    NO-UNDO.
 DEFINE INPUT  PARAMETER piRowsToReturn AS INTEGER    NO-UNDO.
 DEFINE OUTPUT PARAMETER piRowsReturned AS INTEGER    NO-UNDO.

 DEFINE VARIABLE lAppendSearch    AS LOGICAL    NO-UNDO.
 DEFINE VARIABLE cToRowident      AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE lRefresh         AS LOGICAL    NO-UNDO.
 DEFINE VARIABLE hRowIdent        AS HANDLE     NO-UNDO.
 DEFINE VARIABLE hRowIdentIdx     AS HANDLE     NO-UNDO.
 DEFINE VARIABLE hRowNum          AS HANDLE     NO-UNDO.
 DEFINE VARIABLE hRowUserProp     AS HANDLE     NO-UNDO.
 DEFINE VARIABLE hRowObject       AS HANDLE     NO-UNDO.
 DEFINE VARIABLE lFirst           AS LOGICAL    NO-UNDO.
 DEFINE VARIABLE hQuery           AS HANDLE     NO-UNDO.
 DEFINE VARIABLE cLastResult      AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cFirstResult     AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE lSkipApi         AS LOGICAL    NO-UNDO.
 DEFINE VARIABLE lStop            AS LOGICAL    NO-UNDO.
 DEFINE VARIABLE iLoopCount       AS INTEGER    NO-UNDO.
 DEFINE VARIABLE iRownum          AS INTEGER    NO-UNDO.
 DEFINE VARIABLE lok              AS LOGICAL    NO-UNDO.
 DEFINE VARIABLE hBuffer          AS HANDLE     EXTENT {&MaxTables} NO-UNDO.
 DEFINE VARIABLE cExclude         AS CHARACTER  EXTENT {&MaxTables} NO-UNDO.
 DEFINE VARIABLE cAssignArray     AS CHARACTER  EXTENT {&MaxTables} NO-UNDO.
 DEFINE VARIABLE cColumns         AS CHARACTER  EXTENT {&MaxTables} NO-UNDO.
 DEFINE VARIABLE cAssigns         AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cRowident        AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE iBuffer          AS INTEGER    NO-UNDO.
 DEFINE VARIABLE cEntityFields    AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cRowUserProp     AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE lNoCalc          AS LOGICAL    NO-UNDO.
 DEFINE VARIABLE lFieldCalc       AS LOGICAL    NO-UNDO.
 DEFINE VARIABLE hDataSource      AS HANDLE     NO-UNDO.
 DEFINE VARIABLE cNewFirstResult  AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cNewLastResult   AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cLastDBrowident  AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE hReadHandler     AS HANDLE     NO-UNDO.
 DEFINE VARIABLE cReadFormat      AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cReadcolumns     AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE hReadBuffer      AS HANDLE     NO-UNDO.
 DEFINE VARIABLE lChildrenForAll  AS LOGICAL    NO-UNDO.
 DEFINE VARIABLE cDelimiter       AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE iRowPos          AS INTEGER    NO-UNDO.
 DEFINE VARIABLE rRowid           AS ROWID      NO-UNDO.
 DEFINE VARIABLE hDataQuery       AS HANDLE     NO-UNDO.
 DEFINE VARIABLE cAsDivision      AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cCalculatedColumns AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE iCalc              AS INTEGER    NO-UNDO.
 DEFINE VARIABLE cCalcCol           AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE iCol               AS INTEGER    NO-UNDO.
 DEFINE VARIABLE cColumnsByTable    AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE hColumn            AS HANDLE     NO-UNDO. 
 DEFINE VARIABLE lQueryContainer    AS LOGICAL    NO-UNDO.
 DEFINE VARIABLE hContainer         AS HANDLE     NO-UNDO. 
 DEFINE VARIABLE cContainerName     AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cUniqueObjectName  AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cBufferHandles     AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE lOneToOne          AS LOGICAL    NO-UNDO.
 DEFINE VARIABLE hFirstBuffer       AS HANDLE     NO-UNDO.
 DEFINE VARIABLE cFFList            AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE iCount             AS INTEGER    NO-UNDO.
 DEFINE VARIABLE cROQuery           AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cField             AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cCondition         AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cNewBatchInfo      AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE lLastFound         AS LOGICAL    NO-UNDO.

 &SCOPED-DEFINE xp-assign
 {get QueryHandle hQuery}
 {get BufferHandles cBufferHandles}
 {get RowObject hRowObject}
 {get CalculatedColumns cCalculatedColumns}
 {get EntityFields cEntityFields}
  /* maps RowObject names that are different from the database names. */
 {get AssignList cAssigns}
 {set PositionForClient ?}.
 &UNDEFINE xp-assign
 
 {get UpdateFromSource lOneToOne}.

 ASSIGN           /* Search for Rownum is a refresh..*/   
   hBuffer[1]      = WIDGET-HANDLE(ENTRY(1, cBufferHandles))
   cExclude[1]     = {fnarg excludeColumns 1}
   cAssignArray[1] = ENTRY(1, cAssigns, {&adm-tabledelimiter})
   hRowIdent       = hRowObject:BUFFER-FIELD('RowIdent':U)
   hRowIdentIdx    = hRowObject:BUFFER-FIELD('RowIdentIdx':U)
   hRowNum         = hRowObject:BUFFER-FIELD('RowNum':U) 
   hRowUserProp    = hRowObject:BUFFER-FIELD('RowUserProp':U) 

   lRefresh      = CAN-DO(pcColumns,"RowNum":U)  
                  /* appending from top start counting FROM the search! */
   lAppendSearch = plAppend AND plFromTop AND pcColumns > '':U AND NOT lRefresh
   cToRowident   = IF LOOKUP("Rowident":U,pcColumns) > 0
                   THEN ENTRY(LOOKUP("Rowident":U,pcColumns),pcValues,CHR(1))
                   ELSE "":U.  
 {get DataColumnsByTable cColumnsByTable}. /* used for outer join*/     
 DO iBuffer = 2 TO NUM-ENTRIES(cBufferHandles):
   ASSIGN
     cAssignArray[iBuffer] = ENTRY(iBuffer, cAssigns, {&adm-tabledelimiter})
     hBuffer[iBuffer] = WIDGET-HANDLE(ENTRY(iBuffer, cBufferHandles))
     cExclude[iBuffer] = {fnarg excludeColumns iBuffer}
     cColumns[iBuffer] = ENTRY(iBuffer,cColumnsByTable, {&adm-tabledelimiter}).
 END.
    
 {get DataReadHandler hReadhandler}.
 IF VALID-HANDLE(hReadHandler) THEN
 DO: 
   /* we need to know if this data object is contained in a SBO */
   /* If so, we need to provide a unique name in 'receiveData' which */
   /* is <SBOname>,<ThisObjectName> */
   &SCOPED-DEFINE xp-assign
   {get ObjectName cUniqueObjectName}
   {get QueryContainer lQueryContainer}.
   &UNDEFINE xp-assign
   IF lQueryContainer THEN DO:
     {get ContainerSource hContainer}.
     {get ObjectName cContainerName hContainer}.
     cUniqueObjectName = cContainerName + '.':U + cUniqueObjectName.
   END.
   &SCOPED-DEFINE xp-assign
   {get DataReadColumns cReadColumns}
   {get DataReadFormat cReadFormat}
   {get DataReadBuffer hReadBuffer}
   {get TransferChildrenForAll lChildrenForAll}
   {get DataDelimiter cDelimiter}.
   &UNDEFINE xp-assign
   IF VALID-HANDLE(hReadBuffer) THEN
     hReadBuffer:BUFFER-CREATE().
 END.
 /* Always check if we are starting on the first record of the dataset. */ 
 lFirst = NOT hQuery:REPOSITION-BACKWARDS(1).
 IF NOT lFirst THEN hQuery:REPOSITION-FORWARDS(1).

 /* ready, Go! */
 hQuery:GET-NEXT. 
 /* Set cLastResult and cFirstResult to unknown if they need to be reset in 
    this request. The logic below uses the unknown value as the flag to 
    store new values in the batch properties*/ 
 &SCOPED-DEFINE xp-assign
 {get LastResultRow cLastResult}
 {get FirstResultRow cFirstResult}.
 &UNDEFINE xp-assign
 /* If this SDO is a 1-to-1 participant the DB query has been joined */
 /* with the RowObject table of its DataSource SDO. We need a reference to */
 /* that buffer (to support possible future outer-join of the child) . */
 IF lOneToOne = TRUE THEN
   hFirstBuffer = hQuery:GET-BUFFER-HANDLE(1).
 ELSE DO:
   hFirstBuffer = hBuffer[1].
   
   /* Save the NewBatchInfo property for use by 1-to-1 clients */
   /* The default is 'ALL'. NewBatchInfo is set to blank after it has been used */
   /* to signify that the RowObject TT for parent and child(ren) are synchronized */
   cNewBatchInfo = "ALL":U.
   IF plFromTop THEN DO:
     IF cLastResult <> ? THEN
        cNewBatchInfo = "RowNum > '":U + ENTRY(1, cLastResult, ";":U) + "'":U.
   END.
   ELSE DO:
     IF cFirstResult <> ? THEN
       cNewBatchInfo = "RowNum < '":U + ENTRY(1, cFirstResult, ";":U) + "'":U.
   END.
   {set NewBatchInfo cNewBatchInfo}.

   IF lRefresh THEN
     iRowNum = INTEGER(ENTRY(LOOKUP("RowNum":U,pcColumns),pcValues,CHR(1))) - 1.
   ELSE DO: 
     /* Start at 0, no matter what, if we know we are at the top */   
     IF lFirst THEN
       iRowNum = 0. 

     /*  A no append reposition needs a high rownum. (this gives high number for 
         no appending next also....  ) */ 
     ELSE IF plFromTop AND NOT plAppend THEN
       iRowNum = {&ReposRowNum}.  

     ELSE IF plFromTop THEN 
       iRowNum = IF cLastResult = ? THEN 0 
                                    ELSE INTEGER(ENTRY(1,cLastResult,';':U)).
     ELSE /* AT top (not from top), ensure no negative numbers and
             substract rowsToReturn.. */   
       iRowNum = MAX(0,IF cFirstResult = ? THEN 
                         {&ReposRowNum} 
                       ELSE INTEGER(ENTRY(1,cFirstResult,';':U))
                            - (piRowsToReturn + 1)).

     IF plAppend AND hBuffer[1]:AVAIL THEN
     DO:
       IF plFromTop THEN 
         cLastResult = ?.     
       ELSE 
         cFirstResult = ?.
     END.
     ELSE IF NOT plAppend THEN 
     DO:
       ASSIGN 
         cFirstResult = ? 
         cLastResult  = ?.
       /* If we are not appending then ensure that First and last Row is reset
          so they do not have the values from a previous batch */  
       IF hBuffer[1]:AVAILABLE THEN
       DO: 
         &SCOPED-DEFINE xp-assign
         {set FirstRowNum ?}
         {set LastRowNum ?}.
         &UNDEFINE xp-assign
       END.
       ELSE DO:
         &SCOPED-DEFINE xp-assign
         {set FirstRowNum 0}
         {set LastRowNum 0}.
         &UNDEFINE xp-assign
       END.
     END.
   END. 
 END.    /* NOT 1-to-1 */

 {get ASDivision cASDivision}.
 
 /* WARNING: use extreme caution in this loop!
    Additional procedure, function calls or dyn handle refs is FORBIDDEN. 
    Ensure new processing does not decrease NUMBER of RECORDS PER SECOND */
 {get SkipTransferDBRow lSkipApi}. 
 DO WHILE hFirstBuffer:AVAILABLE 
   AND NOT lStop
   AND (iLoopCount < piRowsToReturn OR piRowsToReturn = 0):  
      
   hRowObject:BUFFER-CREATE().
   ASSIGN
     piRowsReturned = piRowsReturned + 1
     iLoopCount     = IF NOT lAppendSearch THEN iLoopCount + 1
                      ELSE 0. /* start on one when appendsearch is off */

   /* Use the parent's RowObject RowNum to avoid conflicts */
   IF lOneToOne = TRUE THEN
     iRowNum = hFirstBuffer:BUFFER-FIELD('RowNum':U):BUFFER-VALUE.
   ELSE
     iRowNum = iRowNum + 1.
   
   IF lSkipAPi THEN
   DO:
     /* testing indicates that it is more efficient to check cRowident 
        below in one place */  
     IF hBuffer[1]:AVAILABLE THEN
     DO:
       IF INDEX(cAssignArray[1],'[':U) = 0 THEN
         hRowObject:BUFFER-COPY(hBuffer[1],cExclude[1],cAssignArray[1]).
       ELSE
         RUN BufferCopyDBToRO (hRowObject, 
                               hBuffer[1],
                               cExclude[1],
                               cAssignArray[1]).  
     END.    
     ELSE DO:
       DO iCol = 1 TO NUM-ENTRIES(cColumns[1]):
         ASSIGN
           hColumn = hRowObject:BUFFER-FIELD(ENTRY(iCol,cColumns[1]))
           hColumn:BUFFER-VALUE = '':U.  /* This sets non-char fields to ? */
       END. /* do icolumn = 1 to num-entries */
     END.    
     cRowident = IF hBuffer[1]:AVAIL 
                    THEN STRING(hBuffer[1]:ROWID)
                    ELSE '':U.
     
     DO iBuffer = 2 TO NUM-ENTRIES(cBufferHandles):     
       IF hBuffer[iBuffer]:AVAIL THEN
       DO:
         IF INDEX(cAssignArray[iBuffer],'[':U) = 0 THEN 
           hRowObject:BUFFER-COPY(hBuffer[iBuffer],cExclude[iBuffer],cAssignArray[ibuffer]).
         ELSE
          RUN BufferCopyDBToRO (hRowObject,hBuffer[iBuffer],cExclude[iBuffer],cAssignArray[iBuffer]).  
       END.
       ELSE DO:
         DO iCol = 1 TO NUM-ENTRIES(cColumns[iBuffer]):
           ASSIGN
            hColumn = hRowObject:BUFFER-FIELD(ENTRY(iCol,cColumns[ibuffer]))
            hColumn:BUFFER-VALUE = '':U.  /* This sets non-char fields to ? */
         END. /* do icolumn = 1 to num-entries */
       END.
       cRowIdent = cRowident + ',':U + IF hBuffer[iBuffer]:AVAIL 
                                      THEN STRING(hBuffer[iBuffer]:ROWID)
                                      ELSE '':U.
     END.             
     
     {src/adm2/entityfields.i 
         &rowobject=hRowObject 
         &rowUserProp=cRowUserProp
         &entityFields= cEntityfields}     
     ASSIGN 
       hRowIdent:BUFFER-VALUE    = cRowIdent
       hRowIdentIdx:BUFFER-VALUE = SUBSTR(cRowIdent, 1, xiRocketIndexLimit)
       hRowNum:BUFFER-VALUE      = iRowNum
       hRowUserProp:BUFFER-VALUE = cRowUserProp.
       
     IF NOT lNoCalc THEN
     DO:
       IF NOT lFieldCalc THEN
       DO:  
         RUN Data.Calculate IN TARGET-PROCEDURE NO-ERROR.
         lNoCalc = ERROR-STATUS:GET-NUMBER(1) = 6456.
       END.
       IF (lNoCalc OR lFieldCalc) AND cCalculatedColumns > '':U THEN
       DO:
         DO iCalc = 1 TO NUM-ENTRIES(cCalculatedColumns):
           cCalcCol = ENTRY(iCalc,cCalculatedColumns).
           hRowObject:BUFFER-FIELD(cCalcCol):BUFFER-VALUE
             = DYNAMIC-FUNCTION('{&calculateprefix}':U + cCalcCol IN TARGET-PROCEDURE) NO-ERROR.
           ASSIGN
             lNoCalc    = FALSE
             lFieldCalc = TRUE.
         END.
       END.
     END.
   END.
   ELSE DO:
     RUN transferDBRow IN TARGET-PROCEDURE
         ("":U /* Signal to use the current db row */, iRowNum).    
     cRowIdent = hROwident:BUFFER-VALUE.
     {get SkipTransferDBRow lSkipApi}.
   END.
   
   /* If are the child (0) in a 1-TO-0 relationship we don't want to go here */
   IF cToRowident = cRowident AND 
      cRowIdent <> '':U  /* Skip if in a 1-TO-0 child */ THEN
   DO:
     IF NOT plFillBatch AND NOT lAppendSearch THEN
     DO:
       IF pcPosition = 'BEFORE':U THEN
       DO:
         hRowObject:BUFFER-DELETE().
         ASSIGN
           rRowId         = hRowObject:ROWID
           piRowsReturned = piRowsReturned - 1
           iRowNum        = iRowNum - 1
           iRowPos        = iRowNum.
         hRowObject:FIND-FIRST('WHERE RowNum = ':U +  STRING(iRowNum)) NO-ERROR.
         /* keep in synch..  the logic below that repositions forward to 
           identify last is not called when cLastResult = ?, but..   */
         hQuery:GET-PREV. 
         LEAVE. /* avoid run readHandler logic below */
       END.
       ELSE IF pcPosition = 'AFTER':U THEN
         ASSIGN
           iRowPos = iRowNum + 1
           iLoopCount = piRowsToReturn - 1.
       ELSE 
         ASSIGN
           rRowId     = hRowObject:ROWID
           lLastFound = TRUE.
     END.
     ELSE IF pcPosition = 'BEFORE':U THEN
       iRowPos = iRowNum - 1.
     ELSE IF pcPosition = 'AFTER':U THEN
       iRowPos = iRowNum + 1.
     ELSE 
       rRowId = hRowObject:ROWID.
     /* Start counting, include current */
     IF lAppendSearch THEN 
       ASSIGN
         iLoopCount    = 1   
         lAppendSearch = FALSE.
   END.
   
   IF VALID-HANDLE(hReadHandler) THEN
   DO:          
     IF VALID-HANDLE(hReadBuffer) THEN
     DO:
       hReadBuffer:BUFFER-COPY(hRowObject).  
       RUN receiveBuffer IN hReadHandler 
          (cUniqueObjectName,
           hReadBuffer).
     END.
     ELSE DO:
       RUN receivedata IN hReadHandler 
           (cUniqueObjectName,
            cReadColumns,
            DYNAMIC-FUNCTION('colStringValues' IN TARGET-PROCEDURE,
                             cReadColumns,
                             cReadFormat,
                             cDelimiter)
           ).
     END.
     IF RETURN-VALUE = 'adm-error':u OR ERROR-STATUS:ERROR THEN
     DO:
       lStop = TRUE.
       {get DataSource hDataSource}.
       IF VALID-HANDLE(hDataSource) THEN
         RUN removeLink IN TARGET-PROCEDURE (hDataSource,'Data':U,TARGET-PROCEDURE).
     END.
     IF lChildrenForAll THEN 
       PUBLISH 'DataAvailable':U FROM TARGET-PROCEDURE ('TRANSFER':U).     
   END.  /* if valid readhandler */
   IF cNewFirstResult = '':U THEN
   DO:
     ASSIGN  /*  .if...else rRowid. usually ?, but NOT in the case where
                  toRowident was also the FIRST record in this loop  */
       rRowId          = IF plFromTop AND cToRowident = '':U THEN hRowObject:ROWID ELSE rRowid
       cNewFirstResult = STRING(iRowNum) + ';':U + hRowIdent:BUFFER-VALUE.   
     /* If we have encountered the first record in the dataset, we set 
        all first props disregarding whther we are forward or appending */    
     IF lFirst THEN 
     DO:
       &SCOPED-DEFINE xp-assign
       {set FirstResultRow cNewFirstResult}
       {set FirstRowNum iRowNum}.
       &UNDEFINE xp-assign
     END.
     /* Otherwise set the Firstbatch unless we are appending forward
       (cFirstResult is set to unkwown above if not appendong or backward) */ 
     ELSE IF cFirstResult = ? THEN
       {set FirstResultRow cNewFirstResult}.     
   END.
   
   IF lLastFound THEN
     LEAVE.
   IF NOT lStop AND (iLoopCount < piRowsToReturn OR piRowsToReturn = 0) THEN
     hQuery:GET-NEXT.
 END. /* do while */
 
 IF piRowsReturned > 0 THEN
 DO:
   ASSIGN  
     /* if positioning is not indicated by now then we want to position to the 
        last row */   
     rRowId        = IF rRowId = ? AND iRowPos = 0 THEN hRowObject:ROWID ELSE rRowId
     cNewLastResult = STRING(iRowNum) + ';':U + hRowIdent:BUFFER-VALUE.
   /* If we are off end then set all batch properties disregarding whther we
      are appending or forward  */
   IF hQuery:QUERY-OFF-END THEN
   DO:
     &SCOPED-DEFINE xp-assign
     {set LastResultRow cNewLastResult}
     {set LastRowNum iRowNum}.
     &UNDEFINE xp-assign
     hQuery:GET-PREV. /* get back to the last ( probably not needed ...)  */
   END.
   /* else check if we are at the end unless we are appending data to the 
      beginning of existing data 
      (cLastResult is not set to ? above if value is to be kept) */
   ELSE IF cLastResult = ? THEN 
   DO: 
       {set LastResultRow cNewLastResult}.      
     /* Did we get-last on open? */
     {get LastDbRowIdent cLastDbRowIdent}.
     /* if no lastDbrowIdent then look ahead */
     IF cLastDbRowident = '':U THEN
     DO:
       hQuery:REPOSITION-FORWARD(1). /* We only get here if we are NOT off end */
       IF hQuery:QUERY-OFF-END THEN 
         {set LastRowNum iRowNum}.
       hQuery:GET-PREV.  /* get back to the current ( probably not needed)   */
     END. /* LastDbrowIdent = ''  */

     ELSE IF cLastDbRowident = ENTRY(2,cNewLastResult,';':U) THEN
       {set LastRowNum iRowNum}.
   END. /* lastResult = ? (try to find last) */
 END.
 
 IF iRowPos > 0 THEN
 DO:
   hRowObject:FIND-FIRST('WHERE RowNum = ':U +  STRING(iRowPos)) NO-ERROR.
   rRowId  = hRowObject:ROWID. 
 END.
 
 IF plOpen THEN 
 DO:
   {get DataHandle hDataQuery}. 
   IF rRowId <> ? THEN
   DO:
     hDataQuery:QUERY-OPEN.
     hDataQuery:REPOSITION-TO-ROWID(rRowId).   
     IF NOT hRowObject:AVAIL THEN
        hDataQuery:GET-NEXT.
        
     IF cAsDivision = 'SERVER':U THEN
       {set PositionForClient hRowident:BUFFER-VALUE}.
     IF NOT lChildrenForAll AND VALID-HANDLE(hReadHandler) THEN
       PUBLISH 'DataAvailable':U FROM TARGET-PROCEDURE ('TRANSFER':U).     
   END.
 END.

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
  DEFINE VARIABLE hContainer     AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hTarget        AS HANDLE     NO-UNDO.
  DEFINE VARIABLE lSBO           AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE hMaster        AS HANDLE     NO-UNDO.

  {get ContainerSource hContainer}.
  IF VALID-HANDLE(hContainer) THEN
    {get QueryObject lSBO hContainer}.
  
  hTarget = TARGET-PROCEDURE.

  /* if this is the master of an SBO we need to use the SBO to find 
    foreignfields and parent */
  IF lSBO THEN 
  DO:
    {get MasterDataObject hMaster hContainer}.
    IF hMaster = TARGET-PROCEDURE THEN
      hTarget = hContainer.
  END.
  
  &SCOPED-DEFINE xp-assign
  {get DataSource hDataSource hTarget}
  {get ForeignFields cForeignFields hTarget}.
  &UNDEFINE xp-assign
  
  IF NOT VALID-HANDLE(hDataSource) OR cForeignFields = '':U OR cForeignFields = ? THEN
    RETURN FALSE.
  
  DO iField = 1 TO NUM-ENTRIES(cForeignFields) BY 2:
    cLocalFields = cLocalFields +  /* 1st of each pair is local db query fld  */
    (IF cLocalFields NE "":U THEN ",":U ELSE "":U) +
      ENTRY(iField, cForeignFields).
    cSourceFields = cSourceFields +   /* 2nd of pair is source RowObject fld */
    (IF cSourceFields NE "":U THEN ",":U ELSE "":U) +
      ENTRY(iField + 1, cForeignFields).
  END.

  ghTargetProcedure = TARGET-PROCEDURE.   
  cForeignValues = {fnarg colValues cSourceFields hDataSource} NO-ERROR.
  ghTargetProcedure = ?.
  
  /* Throw away the RowIdent entry returned by colValues*/
  IF cForeignValues NE ? THEN 
    cForeignValues = SUBSTR(cForeignValues, INDEX(cForeignValues, CHR(1)) + 1).
  /* set all values to unknown if not avail parent if more than one field... 
    (should rather set the query to where false..)  */
  ELSE IF NUM-ENTRIES(cForeignFields) > 2 THEN
    cForeignValues = RIGHT-TRIM(FILL('?' + CHR(1),INT(NUM-ENTRIES(cForeignFields) / 2)),',').
  
  {set ForeignValues cForeignValues}. 

  RETURN DYNAMIC-FUNCTION("assignQuerySelection":U IN hTarget, 
                           cLocalFields,
                           cForeignValues,
                           '':U).  

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-addNotFoundMessage) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION addNotFoundMessage Procedure 
FUNCTION addNotFoundMessage RETURNS LOGICAL
  ( pcFields AS CHAR,
    pcValues AS CHAR,
    pcOperators AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose: Add an error message for record not found based on keys and values 
           in the same format as findRowWhere and other query functions...  
  
  pcFields   - Column names (Comma separated)                    
  pcValues   - corresponding Values (CHR(1) separated)
 pcOperators - FUTURE not currently added to message 
                Operator - one for all columns
                                - blank - defaults to (EQ)  
                                - Use slash to define alternative string operator
                                  EQ/BEGINS etc..
                              - comma separated for each column/value        
    Notes: The message is for unique finds.  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cTables   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cKeyerror AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iLoop     AS INTEGER    NO-UNDO.
  
  {get Tables cTables}.

  DO iLoop = 1 TO NUM-ENTRIES(pcFields):
    cKeyError = cKeyError + ' ':U +  
                {fnarg columnLabel ENTRY(iLoop,pcFields)}
                + ' ':U
                + IF NUM-ENTRIES(pcValues,CHR(1)) >= iLoop
                  THEN ENTRY(iLoop,pcValues,CHR(1))
                  ELSE ' ':U  .

  END. /* do iloop = 1 to num-entries(cKeyFields) */ 
   
  /* MESSAGE 29: &1 was not found with &2 */ 
  RUN addMessage IN TARGET-PROCEDURE 
      (SUBSTITUTE({fnarg messageNumber 29},cTables,cKeyError),?,?).
  
  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-addQueryWhere) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION addQueryWhere Procedure 
FUNCTION addQueryWhere RETURNS LOGICAL
  (pcWhere  AS CHARACTER,
   pcBuffer AS cHARACTER,
   pcAndOr  AS CHARACTER):
/*------------------------------------------------------------------------------
   Purpose:    Adds any string-expression to the query's where clause and stores
               the result in the QueryString property.  Returns TRUE if
               successful, FALSE if an appropriate buffer name for the 
               where-clause can't be located.
 
   Parameters: 
     pcWhere     - Expression to add (may also be an "OF" phrase)  
     pcBuffer    - optional buffer specification
     pcAndOr     - Specifies the operator that is used to add the new
                   expression to existing expression(s)
                   - AND (default) 
                   - OR         
   Notes:      This procedure is designed to run on the client in order to be 
               called several times before it is used and will operate on the
               attribute QueryString.
               openQuery takes care of the preparation of the QueryString 
               attribute.
               Returns False if it can't find get a buffer name to associate
               with the Where-Clause.
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cTables      AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cQueryString AS CHARACTER NO-UNDO.
  DEFINE VARIABLE hBuffer      AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hQuery       AS HANDLE    NO-UNDO.

  /* The QueryString contains data if the query is being currently worked on 
     by this method or assignQuerySelection over many calls. */
  {get QueryString cQueryString}.      
  /* If no QueryString find the current query */ 
  IF cQueryString = "":U OR cQueryString = ? THEN
    {get QueryStringDefault cQueryString}.   

  cQueryString = DYNAMIC-FUNCTION ('newQueryValidate':U IN TARGET-PROCEDURE,
                                   cQueryString,pcWhere,pcBuffer,pcAndOr).
 
  IF cQueryString <> ? THEN
    {set QueryString cQueryString}.

  RETURN cQueryString <> ?.
   
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-bufferCompareDBToRO) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION bufferCompareDBToRO Procedure 
FUNCTION bufferCompareDBToRO RETURNS LOGICAL
  ( INPUT phRowObjUpd AS HANDLE,
    INPUT phBuffer    AS HANDLE,
    INPUT pcExcludes  AS CHARACTER,
    INPUT pcAssigns   AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:    Perform a BUFFER-COMPARE of a database buffer to a RowObjectUpd 
              buffer.  In particular, if an assign-list is used to map 
              individual array elements from the database buffer to the 
              RowObjectUpd buffer, this procedure will ensure that the values 
              are compared correctly.
  Parameters: INPUT phRowObjUpd AS HANDLE - Handle to the RowObjectUpd buffer
              INPUT phBuffer    AS HANDLE - Handle to the database buffer
              INPUT pcExcludes  AS CHAR   - Comma-delimited list of fields to 
                                            be excluded from the BUFFER-COMPARE
              INPUT pcAssigns   AS CHAR   - Comma-delimited list of field pairs
                                            to be individually compared; The 
                                            field pairs are mappings of fields
                                            from the target/source buffers where
                                            the field names differ.
 Notes: The primary purpose of this procedure is to detect when 
        individual array fields are referenced in the assign-list (pcAssigns) 
        from the database buffer and ensure that they are compared properly. 
       - We RIGHT-TRIM the database value to ignore possible trailing blanks.         
         Trailing blanks in db fields is an accident and is ignored in 
         the SDO's normal buffer-compare used when there are no clobs or arrays
         It is, however, a quite common  problem (substring in import?). 
         The field value has lost the trailing in the SDO before image and the 
         optimistic lock comparison would fail and always prevent save of data 
         if the value is changed by the client. 
         (The fact that it is an accident means that we don't care if the 
          trailing blank actually had been changed in the meantime)
------------------------------------------------------------------------------*/
DEFINE VARIABLE cField            AS CHARACTER  NO-UNDO.
DEFINE VARIABLE hField            AS HANDLE     NO-UNDO.
DEFINE VARIABLE hField2           AS HANDLE     NO-UNDO.
DEFINE VARIABLE iCtr              AS INTEGER    NO-UNDO.
DEFINE VARIABLE iExt              AS INTEGER    NO-UNDO.
DEFINE VARIABLE iPos              AS INTEGER    NO-UNDO.
DEFINE VARIABLE lSame             AS LOGICAL    NO-UNDO.
DEFINE VARIABLE cCLOBColumns      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cLargeColumns     AS CHARACTER  NO-UNDO.

  &SCOPED-DEFINE xp-assign
  {get CLOBColumns cCLOBColumns}
  {get LargeColumns cLargeColumns}
  .
  &UNDEFINE xp-assign
  
  /* Do the complex field by field comparisons if  there is an assignlist or 
     a CLOB. (This test is somewhat redundant as this is normally only called 
     when this is the case) */
   
  IF INDEX(pcAssigns, "[":U) NE 0 OR cCLOBColumns <> '' THEN
  DO:
    lSame = phBuffer:BUFFER-COMPARE(phRowObjUpd,
                                    'BINARY':U,
                                    pcExcludes,
                                    ?,
                                    YES /* no-lobs*/ ).
    IF lSame THEN 
    DO:
      CompareAssigns:
      DO iCtr = 2 TO NUM-ENTRIES(pcAssigns) BY 2:
        ASSIGN cField = ENTRY(iCtr, pcAssigns)
               iPos   = INDEX(cField, "[":U).
        IF iPos > 0 THEN
          ASSIGN iExt   = INTEGER(ENTRY(1, SUBSTR(cField, iPos + 1), "]":U))
                 cField = SUBSTR(cField, 1, iPos - 1).
        ELSE 
          ASSIGN iExt = 0.

        ASSIGN hField  = phRowObjUpd:BUFFER-FIELD(ENTRY(iCtr - 1, pcAssigns))
               hField2 = phBuffer:BUFFER-FIELD(cField).
        
        /* Remove from LargeColumns list which is compared below */
        iPos = LOOKUP(hField:NAME,cLargeColumns).
        IF iPos > 0 THEN
           ENTRY(iPos,cLargeColumns) = ''.

        IF hField:DATA-TYPE = 'CLOB':U THEN
          lSame = DYNAMIC-FUNCTION('compareClobValues':U IN TARGET-PROCEDURE,
                                    hField,'=',hField2,'RAW').

        ELSE IF hField:DATA-TYPE = 'CHARACTER':U THEN
          lSame = COMPARE(right-trim(hField:BUFFER-VALUE),
                          "=":U,
                          right-trim(hField2:BUFFER-VALUE(iExt)),
                          "RAW":U).

        ELSE 
          lSame = hField:BUFFER-VALUE = hField2:BUFFER-VALUE(iExt).

        IF NOT lSame THEN 
          LEAVE CompareAssigns.
      END.  /* CompareAssigns: Do iCtl to Num-Entries(pcAssigns) */
      
      IF lSame THEN
      DO:
        CompareLarge:
        DO iCtr = 1 TO NUM-ENTRIES(cLargeColumns):

          cField = ENTRY(iCtr,cLargeColumns).
          
          /* Anticipate blank entries as LargeColumns entires was removed 
             if encountered in the comparison of assignfields above,
             also ensure the field is not excluded (which usually means it 
             is in another db buffer)  */ 
          IF cField <> '':U AND NOT CAN-DO(pcExcludes,cField) THEN
          DO:
            /* The names matches, the comparison of mapped columns is done above*/  
            ASSIGN 
              hField  = phRowObjUpd:BUFFER-FIELD(cField)
              hField2 = phBuffer:BUFFER-FIELD(cField).
            IF hField:DATA-TYPE = 'CLOB':U THEN
              lSame = DYNAMIC-FUNCTION('compareClobValues':U IN TARGET-PROCEDURE,
                                        hField,'=',hField2,'RAW').

            ELSE IF hField:DATA-TYPE = 'CHARACTER':U THEN
              lSame = COMPARE(right-trim(hField:BUFFER-VALUE),
                              "=":U,
                              right-trim(hField2:BUFFER-VALUE(iExt)),
                              "RAW":U).

            ELSE 
              lSame = hField:BUFFER-VALUE = hField2:BUFFER-VALUE(iExt).
    
            IF NOT lSame THEN 
              LEAVE CompareLarge.
          END.
        END. /* CompareLarge: do iCtr - 1 */
      END.   /* If lSame (still...)  */
    END.  /* If lSame */
  END.  /* If arrays or large columns are present */
  ELSE 
    lSame = phBuffer:BUFFER-COMPARE(phRowObjUpd, 
                                   'BINARY':U,
                                    pcExcludes, 
                                    pcAssigns).
  RETURN lSame.   /* Function return value. */

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
DEFINE VARIABLE cChangedFlds   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE lChanged       AS LOGICAL    NO-UNDO.
DEFINE VARIABLE cName          AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cDataType      AS CHARACTER  NO-UNDO.
     
   IF NOT LOOKUP(pcOption, "RAW,CASE-SENSITIVE,CASE-INSENSITIVE":U) > 0 THEN
     pcOption = "CASE-INSENSITIVE":U.
            
   DO iVar = 1 TO phBuffer1:NUM-FIELDS: 
     cName = phBuffer1:BUFFER-FIELD(iVar):NAME.

     IF LOOKUP(cName, pcExclude) > 0 THEN 
        NEXT.
     cDataType = phBuffer1:BUFFER-FIELD(iVar):DATA-TYPE.
     IF cDataType = 'CHARACTER':U THEN
       lChanged = COMPARE(phBuffer1:BUFFER-FIELD(iVar):BUFFER-VALUE, 
                          '<>':U, 
                          phBuffer2:BUFFER-FIELD(cName):BUFFER-VALUE,
                          pcOption).
     ELSE IF cDataType = 'CLOB' THEN
       lChanged = DYNAMIC-FUNCTION('compareClobValues':U in TARGET-PROCEDURE,
                                   phBuffer1:BUFFER-FIELD(iVar), 
                                   '<>':U, 
                                   phBuffer2:BUFFER-FIELD(cName),
                                   pcOption).
     ELSE 
       lChanged = phBuffer1:BUFFER-FIELD(iVar):BUFFER-VALUE 
                  <> phBuffer2:BUFFER-FIELD(cName):BUFFER-VALUE.
     
     IF lChanged THEN
         cChangedFlds = cChangedFlds 
                      + (IF cChangedFlds > "" THEN "," ELSE "") 
                      + cName.
   END.
   RETURN cChangedFlds.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-bufferExclusiveLock) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION bufferExclusiveLock Procedure 
FUNCTION bufferExclusiveLock RETURNS LOGICAL PRIVATE
  ( pcBuffer     as character,
    pcMode       as character) :
/*------------------------------------------------------------------------------
  Purpose: return true if buffer should be exclusive locked for update   
           Yes - buffer should be exclusive locked (default also for joined
                 read-only tables)
           No  - buffer is read only and should also remain no-locked
    cBuffer    -  tabke name (of SDO query) 
     Notes:      Private
                 The public NoLockReadOnlyTables property is used to define 
                 which read only tables that can remain unlocked. 
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cTables               AS CHARACTER   NO-UNDO.
  DEFINE VARIABLE cUpdColsByTable       AS CHARACTER   NO-UNDO.
  DEFINE VARIABLE iTable                AS INTEGER     NO-UNDO.
  DEFINE VARIABLE cNoLockReadOnlyTables AS CHARACTER   NO-UNDO.

  &SCOPED-DEFINE xp-assign
  {get Tables cTables}             /* DB Table names. */
  {get UpdatableColumnsByTable cUpdColsByTable}
  {get NoLockReadOnlyTables cNoLockReadOnlyTables}
   .
  &UNDEFINE xp-assign  
  
  iTable = LOOKUP(pcBuffer,cTables).
  if entry(iTable, cUpdColsByTable, {&adm-tabledelimiter}) = "":U 
  and (cNoLockReadOnlyTables = 'all':U 
       or lookup(pcBuffer,cNoLockReadOnlyTables) > 0
       or (pcMode = "D":U and {fn checkReadOnlyAvailOnDelete} = false)
       ) then
    return false.    
  
  return true.

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
  
  {get BaseQuery cDefaultQuery}.

  RETURN DYNAMIC-FUNCTION('bufferHasOuterJoin':U IN TARGET-PROCEDURE,
                           pcBuffer,cDefaultQuery).

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-bufferRowident) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION bufferRowident Procedure 
FUNCTION bufferRowident RETURNS CHARACTER 
  (phBuffer as handle) :
/*------------------------------------------------------------------------------
  Purpose: Return current rowids for SDO RowObjUpd buffer using key fields.
    Notes: To be used to if rowid is not reliable  (partitioned table) 
------------------------------------------------------------------------------*/
    define variable cKeyFields    as character no-undo.
    define variable cQueryFields  as character no-undo.
    define variable cValues      as character no-undo.
    define variable cQueryString  as character no-undo.
    define variable cFieldName    as character no-undo.
    define variable cValue        as character no-undo. 
    define variable hFld          as handle    no-undo.  
    define variable cntr          as integer   no-undo.
    define variable cRowident     as character no-undo.
    
    {get KeyFields cKeyFields}.
    {get QueryWhere cQueryString}.    
    
    if cKeyFields = "" or cKeyFields = ? then 
       return ?.
       
    do cntr = 1 to num-entries(cKeyFields):
       cFieldName = entry(cntr,cKeyFields).
       /* should not be qualified, but it is settable */ 
       if num-entries(cFieldName,".") > 1 then
           cFieldName = entry(num-entries(cFieldName,"."),cKeyFields).

       hFld = phBuffer:buffer-field (cFieldName) no-error.
       if not valid-handle(hFld) then
           return ?.
      
       assign 
           cFieldName   = "RowObject.":U + cFieldName  /* qualify for mapping */
           cValue       = hFld:buffer-value    
           cValues      = cValues
                        + (if cntr = 1 then "":U else chr(1))
                        + (if cValue <> ? then cValue else "?":U)
           cQueryFields = cQueryFields 
                        + (if cntr = 1 then "":U else ",":U)
                        + cFieldName.
    end.     
    
    cQueryString = DYNAMIC-FUNCTION('newQueryString':U IN TARGET-PROCEDURE,
                                     cQueryFields,
                                     cValues,
                                     "=":U,
                                     cQueryString,
                                     ?).
    return dynamic-function('firstRowIds':U in target-procedure,cQueryString).                                   

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-checkReadOnlyAvailOnDelete) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION checkReadOnlyAvailOnDelete Procedure 
FUNCTION checkReadOnlyAvailOnDelete RETURNS LOGICAL
        (  ):
/*------------------------------------------------------------------------------
Purpose: Decides if availability of read only tables should be included in optimistic 
         lock check for deletions.
         The default is FALSE due to the fact that it is common to delete such 
         tables in begin transaction hooks to avoid conflicts with database triggers.                                                                                                                                                     
  Notes: The optimistic lock check for deletions that was introduced in 10.1 caused 
         issues in existing apps. The default behavior was thus changed to NOT onclude 
         deleted read-only tables in 10.2B and this function was added to allow this 
         default to be overridden (and keep the behavior introduced in 10.1).                                                                                                                                                     
        ------------------------------------------------------------------------------*/
    return false.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-closeQuery) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION closeQuery Procedure 
FUNCTION closeQuery RETURNS LOGICAL
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:     Closes the database query.

  Parameters:  <none>
  
  Notes:       closeQuery should not be executed on the client side of a 
               split SmartDataObject because the database query only exists
               on the server side.  No harm will be done, but nothing will
               be closed.
------------------------------------------------------------------------------*/

  DEFINE VARIABLE hQuery AS HANDLE NO-UNDO.
  
  {get QueryHandle hQuery}.
  IF VALID-HANDLE (hQuery) THEN
  DO:
    hQuery:QUERY-CLOSE().
    RETURN TRUE.
  END.
  ELSE RETURN FALSE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnDataType) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION columnDataType Procedure 
FUNCTION columnDataType RETURNS CHARACTER
  (pcColumn AS CHAR):
/*------------------------------------------------------------------------------
  Purpose:     Returns the data-type of a database column.  
   Parameters:  pcColumn - Database fieldname.  
               Can be in the form of: DB.TBL.FLDNM, TBL.FLDNM or FLDNM.  
               (If not qualifed the FIRST ref in query will be used)
  Notes:       Is capable of processing a pcColumn specified with brackets.
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hField AS HANDLE NO-UNDO.
  
  hField = {fnarg dbColumnHandle pccolumn}.       
  RETURN IF VALID-HANDLE(hField) THEN hField:DATA-TYPE ELSE ?.  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnDbColumn) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION columnDbColumn Procedure 
FUNCTION columnDbColumn RETURNS CHARACTER
  (pcColumn AS CHAR):
/*----------------------------------------------------------------------------
  Purpose:   Returns the qualified database name ([DB.]TBL.FLDNM) mapped to 
             the RowObject column specified in pcColumn
  Parameter: pcColumn - Rowobject name to look up
-----------------------------------------------------------------------------*/
   DEFINE VARIABLE cName               AS CHARACTER  NO-UNDO.
   DEFINE VARIABLE cAssignList         AS CHARACTER  NO-UNDO.
   DEFINE VARIABLE cDataColumnsByTable AS CHARACTER  NO-UNDO.
   DEFINE VARIABLE cTables             AS CHARACTER  NO-UNDO.
   DEFINE VARIABLE iTable              AS INTEGER    NO-UNDO.
   DEFINE VARIABLE cAssign             AS CHARACTER  NO-UNDO.
   
   IF pcColumn BEGINS "RowObject.":U THEN
     pcColumn = ENTRY(2,pcColumn,".":U). 

   &SCOPED-DEFINE xp-assign
   {get Tables cTables}    /* List of database tables in the object */
   /* If the RowObject name is different from dbname it's in the assign-list,
      which is in the form RowObjectfield,DBField[,...]{&adm-tabledelimiter}... --
      with each {&adm-tabledelimiter}-delimited group corresponding to a Table. */  
   {get AssignList cAssignList}
   /* comma-separated list of Rowobject columns delimited by {&adm-tabledelimiter}
      corresponding to a Table.*/  
   {get DataColumnsByTable cDataColumnsByTable}.
   &UNDEFINE xp-assign
   
   DO iTable = 1 TO NUM-ENTRIES(cTables):
     cAssign = ENTRY(iTable, cAssignList, {&adm-tabledelimiter}). /*Flds for one table */
     IF cAssign <> '':U THEN
     DO:
       /* If the RowObject name is different from dbname it's in the assignList*/
       cName = DYNAMIC-FUNCTION('mappedEntry':U IN TARGET-PROCEDURE, 
                                pcColumn,
                                cAssign, /*Flds for one table */
                                TRUE, /* lookup first of pair return second */
                                ",":U /* delimiter */ ).  
       IF cName NE ? THEN
         RETURN ENTRY(iTable, cTables) /* [db.]tablename */
                + ".":U
                + cName.               /* database field name */
     END.  /* cAssign <> '' */
     
     IF CAN-DO(ENTRY(iTable, cDataColumnsByTable, {&adm-tabledelimiter}),pcColumn) THEN
       RETURN ENTRY(iTable, cTables)  /* [db.]tablename */
              + ".":U
              + pcColumn.             /* field name is column name */
   END.     /* END DO iTable... */
   
   RETURN "":U.    
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnPhysicalColumn) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION columnPhysicalColumn Procedure 
FUNCTION columnPhysicalColumn RETURNS CHARACTER
  (pcColumn AS CHAR):
/*----------------------------------------------------------------------------
  Purpose:   Returns the qualified physical name ([DB.]TBL.FLDNM) mapped to 
             the RowObject column specified in pcColumn
  Parameter: pcColumn - Rowobject name to look up
-----------------------------------------------------------------------------*/
  DEFINE VARIABLE cPhysicalTables AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cTables         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cBufferColumn   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cTableName      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cPhysTableName  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cPhysicalColumn AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iTable          AS INTEGER    NO-UNDO.

  /* Resolve the buffer column first */
  cBufferColumn = {fnarg columnDbColumn pcColumn}.  
  IF cBufferColumn > '':U THEN
  DO:
    &SCOPED-DEFINE xp-assign
    {get PhysicalTables cPhysicalTables}
    {get Tables cTables}.
    &UNDEFINE xp-assign
    ASSIGN
      cTableName      = SUBSTR(cBufferColumn,1,R-INDEX(cBufferColumn,'.':U) - 1)
      iTable          = LOOKUP(cTableName,cTables)
      cPhysTableName  = ENTRY(iTable,cPhysicalTables)
      cPhysicalColumn = REPLACE(cBufferColumn,
                                cTableName + '.':U,
                                cPhysTableName + '.':U).

  END.
  RETURN cPhysicalColumn.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnPhysicalTable) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION columnPhysicalTable Procedure 
FUNCTION columnPhysicalTable RETURNS CHARACTER
  (pcColumn AS CHAR):
/*------------------------------------------------------------------------------
  Purpose:     Returns [dbname.]table of a rowobject or database column.  
  Parameters:  pcColumn - Database fieldname.  
               Can be in the form of: DB.TBL.FLDNM, TBL.FLDNM or FLDNM.  
               (If not qualifed the FIRST ref in query will be used)
  Notes:     - Use to ensure and fix a column reference according to 
               the query's use of database qualification. 
               (See dbColumnHandle for rules). 
             - Supports a pcColumn specified with brackets.              
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cPhysicalTables     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cTables             AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cTableName          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cPhysicalTableName  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iTable          AS INTEGER    NO-UNDO.

  /* Resolve the table from the passed column */
  cTableName = {fnarg columnTable pcColumn}.  
  IF cTableName > '':U THEN
  DO:

    {get PhysicalTables cPhysicalTables}.
    {get Tables cTables}.
    IF cPhysicalTables > '':U THEN
      ASSIGN
        iTable             = LOOKUP(cTableName,cTables)
        cPhysicalTableName = ENTRY(iTable,cPhysicalTables).
    ELSE 
      cPhysicalTableName = cTableName.
  END.
  RETURN cPhysicalTableName.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnProps) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION columnProps Procedure 
FUNCTION columnProps RETURNS CHARACTER
  ( pcColList AS CHARACTER, pcPropList AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:     Returns a list of all requested properties for all the requested
               columns of the RowObject table.  If the pcColList parameter is 
               "*", then all the columns in the RowObject Column List.
  
  Parameters:
    INPUT pcColList  - comma-seperated list of column names for which properties
                       are to be returned.  "*" indicates all of the columns in
                       the DataObject.
    INPUT pcPropList - comma-separated list of properties to be returned.
                       Valid list items are: DataType, Extent, Format, Help,
                       Initial, Label, Modified, PrivateData,
                       QuerySelection, ReadOnly, StringValue,ValExp, ValMsg
                       and Width.
  
  Notes:       Returns a character string of <col1Props> CHR(3) <col2Props> ...
               where each <colnProps> is of the form:
                  <columnName> CHR(4) Prop1Value> CHR(4) Prop2Value ... 
------------------------------------------------------------------------------*/

  DEFINE VARIABLE iCol       AS INTEGER   NO-UNDO.
  DEFINE VARIABLE iProp      AS INTEGER   NO-UNDO.
  DEFINE VARIABLE iColCount  AS INTEGER   NO-UNDO.
  DEFINE VARIABLE iPropCount AS INTEGER   NO-UNDO.
  DEFINE VARIABLE cColumn    AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cProp      AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cColProps  AS CHARACTER NO-UNDO INIT "":U.
  DEFINE VARIABLE cPropValue AS CHARACTER NO-UNDO.
  
  IF pcColList = "*":U THEN
    {get DataColumns pcColList}.
  
  ASSIGN iColCount  = NUM-ENTRIES(pcColList)
         iPropCount = NUM-ENTRIES(pcPropList).
         
  DO iCol = 1 TO iColCount:
    cColumn = TRIM(ENTRY(iCol, pcColList)).
    cColProps = cColProps + cColumn + CHR(4).
    DO iProp = 1 TO iPropCount:
      cProp = TRIM(ENTRY(iProp, pcPropList)).
      /* Note that for now at least we suppress errors and leave it up
       to the caller to make sure that all column names and properties 
       are valid.*/
      cPropValue = STRING(dynamic-function 
          ("column":U + cProp IN TARGET-PROCEDURE, cColumn)) NO-ERROR.
      cColProps = cColProps + 
        (IF cPropValue = ? THEN "" ELSE cPropValue) +
          (IF iProp < iPropCount THEN CHR(4) ELSE "":U).
    END.  /* END DO iProp */
    cColProps = cColProps + (IF iCol < iColCount THEN CHR(3) ELSE "":U).
  END.    /* END DO iCol  */
  
  RETURN cColProps.

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
    {get Tables cBufferList}.    
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

&IF DEFINED(EXCLUDE-columnTable) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION columnTable Procedure 
FUNCTION columnTable RETURNS CHARACTER
  (pcColumn AS CHAR):
/*------------------------------------------------------------------------------
  Purpose:     Returns [dbname.]table or buffer of a database column.  
  Parameters:  pcColumn - Database fieldname.  
               Can be in the form of: DB.TBL.FLDNM, TBL.FLDNM or FLDNM.  
               (If not qualifed the FIRST ref in query will be used)
  Notes:     - Use to ensure and fix a column reference according to 
               the query's use of database qualification. 
               (See dbColumnHandle for rules). 
             - Data.p overrides this for unqualified (RowObject) columns, but
               calls this for qualified fields.   
             - Is capable of processing a pcColumn specified with brackets.              
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hField AS HANDLE NO-UNDO.
  DEFINE VARIABLE lUseDbQual   AS LOGICAL   NO-UNDO.

 {get UseDbQualifier lUseDbQual}.

  hField = {fnarg dbColumnHandle pccolumn}.       
  RETURN IF VALID-HANDLE(hField)
         THEN (IF lUseDbQual THEN hField:DBNAME + ".":U ELSE "":U) 
               + hField:TABLE 
         ELSE "":U.  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnValMsg) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION columnValMsg Procedure 
FUNCTION columnValMsg RETURNS CHARACTER
  (pcColumn AS CHAR):
/*------------------------------------------------------------------------------
  Purpose:     Returns the validation message of a database column.  
  Parameters:  pcColumn - Database fieldname.  
               Can be in the form of: DB.TBL.FLDNM, TBL.FLDNM or FLDNM.  
               (If not qualifed the FIRST ref in query will be used)
  Notes:       Is capable of processing a pcColumn specified with brackets.
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hField AS HANDLE NO-UNDO.
  
  hField = {fnarg dbColumnHandle pccolumn}.       
  RETURN IF VALID-HANDLE(hField) THEN hField:VALIDATE-MESSAGE ELSE ?.  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-colValues) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION colValues Procedure 
FUNCTION colValues RETURNS CHARACTER
  ( pcViewColList AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:     Formats into character strings (using the field format 
               specification) a row of values from the current row of the 
               database Query for the specified column list.

  Parameters:
    pcViewColList- comma-separated list of column names whose values are to be
                   returned.
  
  Notes:       Passes back a CHR(1)-separated list of formatted values preceded
               by the RowIdent code (a comma-separated list) as the first value 
               in all cases.
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cColValues AS CHARACTER NO-UNDO INIT "":U.
  DEFINE VARIABLE iCol       AS INTEGER   NO-UNDO.
  DEFINE VARIABLE hColumn    AS HANDLE    NO-UNDO.
  DEFINE VARIABLE iColCount  AS INTEGER   NO-UNDO.
  DEFINE VARIABLE hBuffer    AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hQuery     AS HANDLE    NO-UNDO.
  DEFINE VARIABLE iTable     AS INTEGER   NO-UNDO.
  
  iColCount = NUM-ENTRIES(pcViewColList).
  {get QueryHandle hQuery}.
  hBuffer = hQuery:GET-BUFFER-HANDLE(1).
  
  IF hBuffer:AVAILABLE THEN 
  DO:
    /* First pass back a list of the buffer ROWIDs from the db rec(s);
       note that this always begins with a comma to indicate that there
       is no temp-table ROWID (since the temp-table is not being used. */
    DO iTable = 1 TO hQuery:NUM-BUFFERS:
      hBuffer = hQuery:GET-BUFFER-HANDLE(iTable).
      cColValues = cColValues + ",":U + STRING(hBuffer:ROWID).
    END.
    
    columnLoop:
    DO iCol = 1 TO iColCount:
      cColValues = cColValues + CHR(1).
      DO iTable = 1 TO hQuery:NUM-BUFFERS:  /* Search buffers until the column found. */
        hBuffer = hQuery:GET-BUFFER-HANDLE(iTable).
        hColumn = hBuffer:BUFFER-FIELD(ENTRY(iCol, pcViewColList)) NO-ERROR.
        IF VALID-HANDLE(hColumn) THEN
        DO:
          cColValues = cColValues + RIGHT-TRIM(STRING(hColumn:BUFFER-VALUE)).
          NEXT columnLoop.
        END. /* END DO IF VALID-HANDLE */
      END.   /* END DO iTable          */
    END.     /* END DO iCol            */
    RETURN cColValues.       
  END.
  ELSE RETURN ?.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-createBuffer) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION createBuffer Procedure 
FUNCTION createBuffer RETURNS HANDLE
  ( pcBuffer AS CHAR,
    pcPhysicalName AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose: Create a buffer  
    Notes: Called by create objects to create buffers for the query 
           Overridden by the data logic procedure for temp-tables that 
           are used in the query      
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hBuffer AS HANDLE  NO-UNDO.
  CREATE BUFFER hBuffer FOR TABLE pcPhysicalName BUFFER-NAME pcBuffer NO-ERROR.
  RETURN hBuffer.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-dbColumnDataName) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION dbColumnDataName Procedure 
FUNCTION dbColumnDataName RETURNS CHARACTER
  (pcDbColumn AS CHAR):
/*------------------------------------------------------------------------------
  Purpose:   Returns the RowObject fieldname of a database fieldname  
  Parameter: pcDbColumn - Qualified database fieldname (In the form of either
                          DB.TBL.FLDNM or TBL.FLDNM or FLDNM.)
  Notes:     Returns '' if not mapped to a RowObject
             An unqualified oolumn are resolved as the first match in tables
------------------------------------------------------------------------------*/
   DEFINE VARIABLE cName               AS CHARACTER NO-UNDO.
   DEFINE VARIABLE cAssignList         AS CHARACTER NO-UNDO.
   DEFINE VARIABLE cDataColumnsByTable AS CHARACTER NO-UNDO.
   DEFINE VARIABLE cTableColumns       AS CHARACTER NO-UNDO.
   DEFINE VARIABLE cAssign             AS CHARACTER NO-UNDO.
   DEFINE VARIABLE cTables             AS CHARACTER NO-UNDO.
   DEFINE VARIABLE cTable              AS CHARACTER NO-UNDO.
   DEFINE VARIABLE iTable              AS INTEGER   NO-UNDO.
   DEFINE VARIABLE iIterate            AS INTEGER    NO-UNDO.
   DEFINE VARIABLE cColumn             AS CHARACTER NO-UNDO.
   DEFINE VARIABLE lNoQual             AS LOGICAL   NO-UNDO.
   
   &SCOPED-DEFINE xp-assign
   {get Tables cTables}
   /* comma-separated list of Rowobject columns delimited by {&adm-tabledelimiter}
      correspon ding to a Table.*/    
   {get DataColumnsByTable cDataColumnsByTable}
   /* comma-separated list source and dRowobject column pairs delimited by {&adm-tabledelimiter}
      corresponding to a Table.*/    
   {get AssignList cAssignList}.
   &UNDEFINE xp-assign

   IF NUM-ENTRIES(pcDbColumn, ".":U) > 1 THEN
     ASSIGN       
       cTable   = SUBSTR(pcDbColumn,1,R-INDEX(pcDbcolumn,".":U) - 1)
       cTable   = {fnarg resolveBuffer cTable} /* ensure correct qualification*/
       iTable   = LOOKUP(cTable, cTables) /* Get the table num  */
       cColumn  = ENTRY(NUM-ENTRIES(pcDbColumn, ".":U), pcDbColumn, ".":U)
       iIterate = iTable
     .   
   ELSE 
     ASSIGN
       lNoQual  = TRUE
       iTable   = 1
       cColumn  = pcDbColumn
       iIterate = NUM-ENTRIES(cTables)
     .
   /* iTable is set to 1 if not qualified or to the actual tablenumber if 
      qualified above. NOTE: LEAVE of loop at bottom if lNoQual = false  */
   IF iTable > 0 THEN
   DO iTable = iTable TO iIterate:
     ASSIGN
       cAssign       = ENTRY(iTable, cAssignList, {&adm-tabledelimiter})
       cTableColumns = ENTRY(iTable, cDataColumnsByTable, {&adm-tabledelimiter}).
     
     /* This function would work without this statement as this would 
        have been resolved below.. This gives a slight perfromance gain
        for the unmapped cases which are asssumed to be more common */ 
     IF CAN-DO(cTableColumns,cColumn) 
     AND (cAssign = '':U OR CAN-DO(cAssign,cColumn) = FALSE) THEN
       RETURN cColumn.
      
     /* Check to see if this column is on left side in the Assign List pairs, 
        meaning that it has been given a new name in the RowObject table. */
     cName  = DYNAMIC-FUNCTION('mappedEntry':U IN TARGET-PROCEDURE, 
                                cColumn, 
                                cAssign, 
                                FALSE, /* lookup second return first */
                                ",":U /* delimiter */ ).
     IF cName NE ? THEN
       RETURN cName.
       
     /* If the column is in this table's part of DataColumnsByTable,
        and it isn't a RowObject column that is mapped to another dbfield
        the RowObject column name is the same as the database field name. */
     IF CAN-DO(cTableColumns,cColumn)
     AND DYNAMIC-FUNCTION('mappedEntry':U IN TARGET-PROCEDURE,
                           cColumn, 
                           cAssign, 
                           TRUE,
                           ",":U) = ? THEN
       RETURN cColumn.

     /* if qualified then we only look in one entry */ 
     IF NOT lNoQual THEN 
       RETURN "":U.
   END.  /* END DO iTable */ 
          
   RETURN "":U.
   
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-dbColumnHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION dbColumnHandle Procedure 
FUNCTION dbColumnHandle RETURNS HANDLE
  (pcColumn AS CHAR):
/*------------------------------------------------------------------------------
  Purpose:     Returns the handle of a database column.
  Parameters: 
    pcColumn - Database fieldname.  Can be in the form of: DB.TBL.FLDNM,
               TBL.FLDNM or FLDNM. Find first field if not qualified. 
  Notes:       Is capable of processing a pcColumn specified with brackets.
               Used by columnDataType, ColumnValMsg, and ColumnTable.
------------------------------------------------------------------------------*/
  DEFINE VARIABLE i          AS INTEGER   NO-UNDO.
  DEFINE VARIABLE cDbName    AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cBuffer    AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cFieldName AS CHARACTER NO-UNDO.
  DEFINE VARIABLE hBuffer    AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hField     AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hQuery     AS HANDLE    NO-UNDO.
  DEFINE VARIABLE iLBracket  AS INT       NO-UNDO.
  DEFINE VARIABLE iAlias     AS INTEGER   NO-UNDO.
       
  {get QueryHandle hQuery}.
  IF NOT VALID-HANDLE(hQuery) THEN
    RETURN ?.
     
  /* Sanity check */
  IF pcColumn = "":U THEN
    RETURN ?.

  ASSIGN 
    cDBName    = IF NUM-ENTRIES(pcColumn,".":U) = 3 
                 THEN ENTRY(1,pcColumn,".":U)
                 ELSE ? 
    cBuffer    = IF NUM-ENTRIES(pcColumn,".":U) > 1 
                 THEN ENTRY(NUM-ENTRIES(pcColumn,".":U) - 1,pcColumn,".":U)
                 ELSE ?
    cFieldName = ENTRY(NUM-ENTRIES(pcColumn,".":U),pcColumn,".":U)
    iLBracket  = R-INDEX(cFieldName,'[':U)
                 /* Remove extent bracket from fieldname */ 
    cFieldName = IF iLBracket > 0 
                 THEN SUBSTR(cFieldName,1,iLBracket - 1)  
                 ELSE cFieldName.
    
  BUF-BLK:
  DO i = 1 TO hQuery:NUM-BUFFERS:
    hBuffer = hQuery:GET-BUFFER-HANDLE(i). 
     
    IF cBuffer <> ? AND hBuffer:NAME   <> cBuffer THEN NEXT.    
    IF cDbName <> ? AND hBuffer:DBNAME <> cDbName THEN 
    ALS-BLK:
    DO:
      /* If buffer's DBNAME attribute doesn't match the dbname of the column
         check to see if the dbname is connected as an alias */
      DO iAlias = 1 TO NUM-ALIASES:
        IF ALIAS(iAlias) EQ cDbName AND 
           LDBNAME(ALIAS(iAlias)) EQ hBuffer:DBNAME THEN 
          LEAVE ALS-BLK.
      END.  
      NEXT BUF-BLK.
    END.
    ASSIGN
      hField = hBuffer:BUFFER-FIELD(cFieldName) NO-ERROR.    
   
    IF VALID-HANDLE(hField) THEN RETURN hField.
    
  END. /* do i = 1 to hQuery:num-buffers */
  RETURN ?.  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-defineDataObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION defineDataObject Procedure 
FUNCTION defineDataObject RETURNS LOGICAL
  ( pcTableList AS CHARACTER,
    pcBaseQuery AS CHARACTER,
    pcColumnList AS CHARACTER,
    pcUpdatableColumns AS CHARACTER) :
/*------------------------------------------------------------------------------
  Purpose: This is a convenience function which will let the user define the dynamic 
           data object properties. The properties defined by this function are:
           Tables,BaseQuery,DataColumns,DataColumsByTable,UpdatableColumnsByTable,AssignList
             
           Parameters:
           1. pcTableList is a comma separated list of tables. If the table 
              names are database qualified then the column list also needs to 
              be database qualified.
           
           2. pcBaseQuery is the query for the dynamic SDO
              
           3. ColumnList is a comma separated list of qualified columns in the 
              format: TableName.ColumnName[.RemanedColmnName] 
              Where
                TableName: would be the database table name
                ColumnName: would be the field name
                RenamedColumnName: Would be the renamed field name. This is optional.
           
           4. UpdatableColumns is comma separated list of logical values with 
              following special cases i.e "YES" or "NO" or "YES,NO,YES,NO"
              
              If the value is "YES" then all the columns are updatable.
              If the value is "NO" then all the columns are not updatable.
              If the value id "YES,NO,YES,YES" then the individual columns will 
              have the specified value
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cTableList                    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cPhysicalTableList            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iNumEntry                     AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cColumnName                   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFieldName                    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cTableName                    AS CHARACTER  NO-UNDO.  
  DEFINE VARIABLE cPhysicalTableName            AS CHARACTER  NO-UNDO.  
  DEFINE VARIABLE iBufferEntries                AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cAssignName                   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lUpdatable                    AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cUpdatable                    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iDBQual                       AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iArrayPos                     AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cDataColumns                  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cUpdatableDataColumns         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDataColumnsByTable           AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cUpdatableDataColumnsByTable  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cAssignColumnsByTable         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lDatabaseQualifiedTableNames  AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lResult                       AS LOGICAL    NO-UNDO.

  DEFINE VARIABLE caDataColumns                 AS CHARACTER  EXTENT {&MaxTables} NO-UNDO.
  DEFINE VARIABLE caUpdatableDataColumns        AS CHARACTER  EXTENT {&MaxTables} NO-UNDO.
  DEFINE VARIABLE caAssignColumns               AS CHARACTER  EXTENT {&MaxTables} NO-UNDO.

  /* Check if the table name is database qualified */
  cTableName = ENTRY(1, pcTableList, ",":U).
  IF (NUM-ENTRIES(cTableName, ".":U) > 1 )THEN
    lDatabaseQualifiedTableNames = YES.
  ELSE
    lDatabaseQualifiedTableNames = NO.
  
  IF (lDatabaseQualifiedTableNames) THEN
    iDBQual = 1.
  ELSE
    iDBQual = 0.


  DO iNumEntry = 1 TO NUM-ENTRIES(pcTableList, ",":U):
    cTableName = ENTRY(iNumEntry, pcTableList).
    IF (NUM-ENTRIES(cTableName, " ":U) > 1 )  THEN
    DO:
      DO WHILE INDEX('  ':U,cTableName) > 0:
        cTableName = REPLACE(cTableName,'  ':U,' ':U). 
      END.
      iBufferEntries = NUM-ENTRIES(cTableName, " ":U).
      IF NOT (    iBufferEntries = 2 
              OR (iBufferEntries = 3 AND ENTRY(2,cTableName,' ':U) = 'FOR':U)) THEN
      DO:
        MESSAGE
          "The table reference '" + ENTRY(1, pcTableList) + "' passed to defineDataObject is not valid." SKIP 
          "To define a buffer use syntax 'BufferName [FOR] TableName'"
          VIEW-AS ALERT-BOX INFO BUTTONS OK.
        RETURN FALSE.
      END.
      ASSIGN
        cPhysicalTableName = ENTRY(iBufferEntries,cTableName, " ":U)
        cTableName         = ENTRY(1,cTableName, " ":U).       
    END.
    ELSE 
      cPhysicalTableName = cTableName.

    ASSIGN
      cTableList         = cTableList 
                         + (IF iNumEntry = 1 THEN '':U ELSE ',':U)
                         + cTableName 
      cPhysicalTableList = cPhysicalTableList 
                         + (IF iNumEntry = 1 THEN '':U ELSE ',':U)
                         + cPhysicalTableName. 
  END.
  /* Let us loop thru the ColumnList and populate the data */
  DO iNumEntry = 1 TO NUM-ENTRIES(pcColumnList, ",":U):

    /* Initialize the values */
    ASSIGN cColumnName = ?
           cTableName = ?
           cFieldName = ?
           cFieldName = ?
           lUpdatable = NO
           cUpdatable = pcUpdatableColumns
           ERROR-STATUS:ERROR = NO.

    /* Set the table, field, assignName values */
    cColumnName = ENTRY(iNumEntry, pcColumnList, ",":U) NO-ERROR.
    IF ( ERROR-STATUS:ERROR OR cColumnName = '':U OR cColumnName = ?) THEN
      RETURN FALSE.
    
    ASSIGN
      cTableName = (IF iDBQual = 1 
                    THEN ENTRY(1, cColumnName, ".":U) + '.':U
                    ELSE '':U) 
                 +  ENTRY((iDBQual + 1), cColumnName, ".":U) 
      cFieldName = ENTRY((iDBQual + 2), cColumnName, ".":U) NO-ERROR.
    
    IF (ERROR-STATUS:ERROR) THEN
      RETURN FALSE.

    cAssignName = ENTRY((iDBQual + 3), cColumnName, ".":U) NO-ERROR.
    ERROR-STATUS:ERROR = NO.
    IF cAssignName > '':U THEN
      cColumnName = cAssignName.
    ELSE 
      cColumnName = cFieldName.

    /* Make sure that the table name or the field name is not blank or null */
    IF ( cTableName = '':U OR cTableName = ? ) THEN
      RETURN FALSE.
    IF ( cColumnName = '':U OR cColumnName = ? ) THEN
      RETURN FALSE.
    /* Find out if the column is updatable */
    IF ( NUM-ENTRIES(cUpdatable, ",":U) > 1 ) THEN
      cUpdatable = ENTRY(iNumEntry, pcUpdatableColumns, ",":U) NO-ERROR.
    IF ( TRIM(cUpdatable) = "YES":U) THEN
      lUpdatable = YES.
    IF (ERROR-STATUS:ERROR) THEN
      RETURN FALSE.
    iArrayPos = LOOKUP(cTableName, cTableList, ",":U).
    IF ( iArrayPos <= 0 ) THEN
      RETURN FALSE.
    
    ASSIGN 
      caDataColumns[iArrayPos] = caDataColumns[iArrayPos] + ",":U + cColumnName
      cDataColumns = cDataColumns + ",":U + cColumnName.

    IF (lUpdatable) THEN
      ASSIGN 
        caUpdatableDataColumns[iArrayPos] = caUpdatableDataColumns[iArrayPos] 
                                            + ",":U + cColumnName
        cUpdatableDataColumns = cUpdatableDataColumns + ",":U + cColumnName.
    IF (cAssignName > '':U) THEN
      ASSIGN 
        caAssignColumns[iArrayPos] = caAssignColumns[iArrayPos] + ",":U + 
          cAssignName + ",":U + cFieldName.
  END.
  
  DO iNumEntry = 1 TO NUM-ENTRIES(cTableList, ",":U):
    IF ( iNumEntry = 1) THEN
      ASSIGN 
        cDataColumnsByTable = TRIM(caDataColumns[iNumEntry], ",":U)
        cUpdatableDataColumnsByTable = TRIM(caUpdatableDataColumns[iNumEntry], ",":U)
        cAssignColumnsByTable = TRIM(caAssignColumns[iNumEntry], ",":U).
    ELSE
      ASSIGN 
        cDataColumnsByTable = cDataColumnsByTable + ";":U 
                              + TRIM(caDataColumns[iNumEntry], ",":U)
        cUpdatableDataColumnsByTable = cUpdatableDataColumnsByTable + ";":U 
                                       + TRIM(caUpdatableDataColumns[iNumEntry], ",":U)
        cAssignColumnsByTable = cAssignColumnsByTable + ";":U 
                                + TRIM(caAssignColumns[iNumEntry], ",").
  END.
  
  ASSIGN cDataColumns = TRIM(cDataColumns, ",":U)
         cUpdatableDataColumns = TRIM(cUpdatableDataColumns, ",":U).
        
  &SCOPED-DEFINE xp-assign
  {set Tables cTableList}
  {set PhysicalTables cPhysicalTableList}
  {set DataColumnsByTable cDataColumnsByTable}
  {set UpdatableColumnsByTable cUpdatableDataColumnsByTable}
  {set AssignList cAssignColumnsByTable}
  {set BaseQuery pcBaseQuery}
  {set DataColumns cDataColumns}

  /* currently derived from - bytable
  {set UpdatableColumns cUpdatableDataColumns}
  */
  
  {get Tables cTableList}

    .
  &UNDEFINE xp-assign
  
  RETURN (cTableList > '':U).   

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-excludeColumns) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION excludeColumns Procedure 
FUNCTION excludeColumns RETURNS CHARACTER
  (iTable AS INTEGER) :   
/*-----------------------------------------------------------------------------
  Purpose: Returns a comma separated list of columns that should be used
           as the exclude parameter for BUFFER-COPY and BUFFER-COMPARE from
           the database.
Parameter: The number of the table in the query. 
    Notes: This protects the Target from being unintentionally overwritten 
           by unmapped not used columns with the same name, but are supposed 
           to be referencing a previously copyed or compared table or not at 
           all. We simply remove all the columns that represents the table 
           that we are copying comparing to from the {&adm-tabledelimiter} separated 
           DataColumnsByTable. 
           DataColumnsByTable stores calculated fields in the last entry, 
           so we always exclude those.  
           Used by refetchDbRow, transferDbRow and compareDbRow 
-----------------------------------------------------------------------------*/
  DEFINE VARIABLE cExclude AS CHAR   NO-UNDO.
    
  {get DataColumnsByTable cExclude}.
    
  /* Remove the columns from the iTable table from the excludelist */
  ENTRY(iTable,cExclude,{&adm-tabledelimiter}) = "":U.
     
  RETURN TRIM(REPLACE(cExclude,{&adm-tabledelimiter},",":U),",":U).      

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-firstBufferName) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION firstBufferName Procedure 
FUNCTION firstBufferName RETURNS CHARACTER PRIVATE
  (pcExpression AS CHAR)  /* expression */ :
/*------------------------------------------------------------------------------
  Purpose:     Returns the first buffer reference in a where-clause expression.
  Parameters:  pcExpression - a string expression
  Notes:       In order to be recognized as a buffer name, it must contain at
               least one ".", otherwise the return value is ?.
------------------------------------------------------------------------------*/
 DEFINE VARIABLE i           AS INTEGER    NO-UNDO.
 DEFINE VARIABLE cWord       AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE iQuoteStart AS INTEGER    NO-UNDO.
 DEFINE VARIABLE iQuoteEnd   AS INTEGER    NO-UNDO.
 DEFINE VARIABLE cExpression AS CHARACTER  NO-UNDO.
 define variable de          as decimal no-undo.
  
 IF NUM-ENTRIES(pcExpression,".":U) = 1 THEN RETURN ?.

 /* Remove quoted words from this to avoid problems with periods inside quotes*/
 cExpression = REPLACE(pcExpression,"'":U,'"':U).
 DO WHILE INDEX(cExpression,'"':U) > 0:
   ASSIGN
     iQuoteStart = INDEX(cExpression,'"':U)
     iQuoteEnd   = INDEX(SUBSTR(cExpression,iQuoteStart + 1),'"':U).
   
   IF iQuoteStart > 0 AND iQuoteEnd > 0 THEN
     SUBSTR(cExpression,iQuoteStart,iQuoteEnd + 1) = '<>':U.
   ELSE 
     LEAVE.
 END. /* do while quotes in the index  */
 
 /* Replace operators and parenthesis with blanks to simplify the word search */
 ASSIGN
   cExpression = REPLACE(cExpression,"(":U," ":U)
   cExpression = REPLACE(cExpression,")":U," ":U)
   cExpression = REPLACE(cExpression,"=":U," ":U)
   cExpression = REPLACE(cExpression,">=":U," ":U)
   cExpression = REPLACE(cExpression,"<=":U," ":U)
   cExpression = REPLACE(cExpression,">":U," ":U)
   cExpression = REPLACE(cExpression,"<":U," ":U).

 DO i = 1 TO NUM-ENTRIES(cExpression," ":U): 
   cWord = ENTRY(i,cExpression," ":U).
   /* The '.' might be a decimal point. (unquoted decimals have american format)   */
   if num-entries(cWord,".":U) = 2 then 
   do:      
       de = decimal(replace(cWord,".":U,session:numeric-decimal-point)) no-error. 
       if not error-status:error then
           next.
   end.

   IF NUM-ENTRIES(cWord,".":U) = 2 THEN 
     RETURN ENTRY(1,cWord,".":U). 
   
   IF NUM-ENTRIES(cWord,".":U) = 3 THEN
     RETURN ENTRY(1,cWord,".":U) + ".":U + ENTRY(2,cWord,".":U).     
 END. /* i = 1 to num-entries cExpression  */
 
 RETURN ?.

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
            to a function such as colValues in an SBO who needs to know who
            the *real* caller object is.
    Notes:  
------------------------------------------------------------------------------*/

  RETURN ghTargetProcedure.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-newQuerySort) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION newQuerySort Procedure 
FUNCTION newQuerySort RETURNS CHARACTER
  ( pcQuery       AS CHAR,
    pcSort        AS CHAR,
    plDBColumns   AS LOG) :
/*------------------------------------------------------------------------------
  Purpose   :  Insert sort criteria (BY phrase) in a QueryString.
  Parameters:
    pcQuery    - Query to add sort to (current sort will be replaced)        
    pcSort     - new sort expression.
                 - [BY ] column [DESCENDING | TOGGLE ] [ BY ... ]  
                 - TOGGLE sort option specifies that the column should be 
                   sorted opposite of the current sort. The option can be 
                   specified for any column in the sort.      
                 - Use RowObject as qualifier to specify data object's column 
                   names.
    plDbColumns - YES - the query is a db query 
                        columns qualifed with 'RowObject.' will be renamed to 
                        the mapped db field.
                  NO  - columns not qualifed with 'RowObject.' will be renamed 
                        to the mapped RowObject column.  
                                      
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
 DEFINE VARIABLE iIdxPos           AS INTEGER    NO-UNDO.
 DEFINE VARIABLE iLength           AS INTEGER    NO-UNDO.
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
 DEFINE VARIABLE cTmpQuery         AS CHARACTER  NO-UNDO. 
  
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
     NOTE: - spaces in comma separated list is only allowed for sortoption
           - db columns not in SDO currently not supported.  */ 

 IF NUM-ENTRIES(pcSort) > 1 AND INDEX(pcSort,' BY ':U) = 0 THEN
 DO:
   lCommaIsSep = TRUE.
   DO iNum = 1 TO NUM-ENTRIES(pcSort):
     ASSIGN
       cSortEntry  = ENTRY(iNum,pcSort)
       cColumn     = ENTRY(1,cSortEntry,' ').

     IF cColumn BEGINS 'RowObject.':U THEN
       NEXT.

     IF NOT plDBColumns THEN
       cColumn = {fnarg dbColumnDataName cColumn}.
     ELSE 
       cColumn = {fnarg columnDbColumn cColumn}.
     
     IF cColumn = '' THEN
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
 ELSE 
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
         cSortEntry = RIGHT-TRIM(cSortEntry).
    
     IF cSortEntry BEGINS 'RowObject.':U THEN
     DO:
       IF plDbColumns THEN 
       DO:
         /* Calculated field not supported on server.
            It might have been better to just apply it and let progress give 
            the error, but for backwards compatibility (browse sort)
            we fail if a calc field is specifically referenced  */
         cColumn = {fnarg columnDbColumn cSortEntry}.
         IF cColumn = '' THEN 
           RETURN ?.
       END.
       ELSE 
         cColumn = ENTRY(2,cSortEntry,'.':U).
     END.
     ELSE IF NOT plDbColumns THEN 
       cColumn = {fnarg dbColumnDataName cSortEntry}.
     
     /* if plDbcolumns or mapping not found use sort as-is 
        This could be a valid expression f.ex substr used to avoid max index 
        size errors from sort 
        (note that rowobject.<calcfield> is RETURNED above)  */
     IF cColumn = '' THEN
       cColumn = cSortEntry.
     
     /* loop 1 is for new sort loop 2 for old sort */
     CASE iCase:
       WHEN 1 THEN
         ASSIGN 
           cNewColumn[iNum] = cColumn
           cNewOption[iNum] = cOption
           iNewEntries      = iNum.
       WHEN 2 THEN
       DO:
         ASSIGN 
           cOldColumn[iNum] = cColumn
           cOldOption[iNum] = cOption
           iOldEntries      = iNum.
       END.
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
     DO:
       /* if different qualifications compare the DataColumn names.. 
         (we only check if this is the case for db queries. If a rowobject 
          qualifier is used in old or new sort the new sort is used)  */
       IF plDbColumns 
       AND ENTRY(NUM-ENTRIES(cNewColumn[iNum],'.':U),cNewColumn[iNum],'.':U)
       <> ENTRY(NUM-ENTRIES(cOldColumn[iNum],'.':U),cOldcolumn[iNum],'.':U) THEN
       DO:
         IF {fnarg dbColumnDataName cNewColumn[iNum]} <> {fnarg dbColumnDataName cOldColumn[iNum]} THEN
           lDiffColumns = TRUE.
       END.
       ELSE 
         lDiffColumns = TRUE.
     END. 
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

&IF DEFINED(EXCLUDE-newQueryValidate) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION newQueryValidate Procedure 
FUNCTION newQueryValidate RETURNS CHARACTER
   (pcQueryString AS CHAR,
    pcExpression  AS CHAR,
    pcBuffer      AS CHAR,
    pcAndOr       AS CHAR): 
/*------------------------------------------------------------------------------
  Purpose: Inserts a new expression to the passed prepare string if the 
           buffer reference, usually extracted from the expression, is valid.
           (RETURNS ? if error. After an error message has been shown).  
Parameter:  pcQueryString - Complete query string that the expression is
                            going to be added to.
            pcExpression  - The new expression to add to the query.
                            The FIRST field reference is used as buffer 
                            reference unless pcBuffer is defined. 
            pcBuffer      - Optional buffer reference. 
            pcAndOr       - Operator used to append if querystring already
                            has an expression. 
                            default to '='      
    Notes: The function avoids duplicate logic in add- and setQueryWhere and 
           acts as a wrapper for newWhereClause with some significant
           additions and differences. 
            - The buffer reference is usually extracted from the new expression.
            - pcBuffer is optional and thus not the first parameter.
            - The buffer reference is validated and qualification does not
              need to match the original query.
            - Displays error message and returns ? if the buffer is unknown or
              ambiguous. This will probably be changed to use addmessage, when
              we have a more complete error/message service. The function is 
              used in setQuerywhere and addQueryWhere and will almost certainly
              happen on the client.(data.p setQueryWhere -> newQueryWhere->this)           
            
            If no buffer is found in the expression or passed the last 
            entry in the Tables property is used.
            
Author's note: Here's how the order of the parameters were decided, in case 
               someone (including myself) wonders...   
             - The parameters are the same as newWhereClause, but pcBuffer is
               optional (very optional), so it's seems wrong to have it first.
             - The parameters use and meaning are more similar to addQueryWhere 
               with one additional (pcQueryString), so the additional one was 
               added first and the rest follows as in addQueryWhere.                                                                                                        
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cBuffer         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cTables         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cError          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lExpression     AS LOGICAL    NO-UNDO.
  

  /* Unless buffer is defined, use the first buffer reference in the expression*/
  IF pcBuffer = ? OR pcBuffer = "":U THEN 
    ASSIGN
      pcBuffer    = {fnarg firstBufferName pcExpression}
      lExpression = TRUE. /* Show expression if error */
 
  /* If no buffer passed or found above use the last of the object's Tables */ 
  IF pcBuffer = ? THEN
  DO:
    {get Tables cTables}.
    cBuffer = ENTRY(NUM-ENTRIES(cTables),cTables). 
    /* Add the passed where clause to the existing one */  
  END. /* pcBuffer = ? */
  ELSE DO: /* if passed buffer or found in expression 
              Ensure correct qualification */
    cBuffer = {fnarg resolveBuffer pcBuffer}.
       
    IF cBuffer = "":U OR cBuffer = ? THEN
    DO:            
      cError  = STRING(30)  
                + ",":U
                + pcBuffer  /* this is the buffer that was unresolved */
                + ",":U
                /* show expression if the buffer was extracted from it */ 
                + (IF lExpression 
                   THEN CHR(10) + "(":U + pcExpression + ")":U 
                   ELSE "":U).    

      {fnarg showMessage cError}.

      RETURN ?.                 
    END. /* Handle error - cbuffer is blank or unknown */
  END. /* else (a buffer ref is found or passed) */
  
  /* Add the expression to the query */
  RETURN DYNAMIC-FUNCTION('newWhereClause':U IN TARGET-PROCEDURE,
                           cBuffer,pcExpression,pcQueryString,pcAndOr). 

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-newQueryWhere) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION newQueryWhere Procedure 
FUNCTION newQueryWhere RETURNS CHARACTER
  ( pcWhere AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose: Returns a new query 
Parameter: pcWhere - see setQueryWhere               
    Notes: FOR INTERNAL USE ONLY 
           This functions exists only to be able to have the same logic in 
           setQueryWhere in data.p and query.p.     
           Returns unknown if the buffer reference is invalid. 
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cQueryText     AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cQuery         AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cBlank         AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cTables        AS CHARACTER NO-UNDO.
  
  pcWhere = LEFT-TRIM(pcWhere).
  IF pcWhere BEGINS "FOR ":U OR pcWhere BEGINS "PRESELECT ":U THEN
    cQuery = pcWhere.
  
  ELSE DO:     
    {get OpenQuery cQueryText}.
    IF pcWhere <> "":U AND pcWhere <> ? AND pcWhere <> '?':U THEN
      /* Add the passed where clause to the existing one. Shows error and 
         returns ? if buffer in expression is unknown/ambiguous*/  
      cQuery  = DYNAMIC-FUNCTION('newQueryValidate':U IN TARGET-PROCEDURE,
                                  cQueryText,pcWhere,?,?).

    ELSE /* If they passed a blank argument, just use the original query. */
      cQuery = cQueryText.
  END. /* else do (no "FOR ") */
  
  IF cQuery <> ? THEN
  DO:
    /* This overrides manipulations made by other methods, so make sure 
       the properties set by these other methods and used by openQuery are blank.  */
    &SCOPED-DEFINE xp-assign
    {set QueryString cBlank}  
    {set QueryColumns cBlank}.
    &UNDEFINE xp-assign
  END.

  RETURN cQuery.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-openQuery) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION openQuery Procedure 
FUNCTION openQuery RETURNS LOGICAL
    (  ) :
/*------------------------------------------------------------------------------
  Purpose:    General logic for opening the database query either for a 
              SmartDataObject or for another query object.
  Parameters: <none>
  Notes:      The QueryString will be used to prepareQuery if not blank 
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hQuery       AS HANDLE    NO-UNDO.
  DEFINE VARIABLE lCheckLast   AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE cQueryString AS CHARACTER NO-UNDO.
  DEFINE VARIABLE lError       AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE iCnt         AS INTEGER   NO-UNDO.
  DEFINE VARIABLE hBuffer      AS HANDLE    NO-UNDO.
  DEFINE VARIABLE cRow         AS CHARACTER NO-UNDO.
  DEFINE VARIABLE lReturn      AS LOG       NO-UNDO.
  DEFINE VARIABLE cFetchOnOpen AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cFindFunc    AS CHARACTER NO-UNDO.
  DEFINE VARIABLE lUpdateFromSource AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cAsDivision       AS CHARACTER  NO-UNDO.

  {get QueryHandle hQuery}.
  hQuery:QUERY-CLOSE().

  &SCOPED-DEFINE xp-assign
  {get AsDivision cAsDivision}
  /* currently implemented in data class... */
  {get UpdateFromSource lUpdateFromSource}.   
  &UNDEFINE xp-assign

  /* UpdateFromSource SDOs (1-to-1) depend on their data source to manage batching. */
  /* In doing so, the child's DB query is temporarily replaced with a join to the  */
  /* parent, so all batching properties as well as the current query string are reset */
  IF lUpdateFromSource = TRUE AND cASDivision <> "CLIENT":U THEN 
  DO:
    &SCOPED-DEFINE xp-assign
    {set QueryString '':U}
    {set FirstRowNum ?}
    {set LastRowNum ?}
    {set FirstResultRow ?}
    {set LastResultRow ?}
    {set RowsToBatch 0}.
    &UNDEFINE xp-assign
  END.

  /* Is there an unprepared query string? */
  {get QueryString cQueryString}. 

  IF cQueryString <> "":U THEN    
    lError = NOT {fnarg prepareQuery cQueryString}.
  ELSE IF hQuery:PREPARE-STRING = ? THEN
    lError = NOT {fnarg prepareQuery '':U}.

  IF lError OR NOT hQuery:QUERY-OPEN() THEN 
    lReturn = FALSE. /* NOTE: WHEN would this fail? error? */

  ELSE DO:
     /* CheckLastOnOpen specifies that LastDbRowIdent should be set.
        This is really obsolete as LastRowNum now is reliable, and 
        query and data no longer checks this, but the LastDbRowIdent 
        may still be used by customers. () */
     {get CheckLastOnOpen lCheckLast}.     
     IF lCheckLast THEN 
     DO:
       hQuery:GET-LAST.
       DO iCnt = 1 TO hQuery:NUM-BUFFERS:  /* Assemble the list of rowids */
         ASSIGN hBuffer = hQuery:GET-BUFFER-HANDLE(iCnt)
                cRow   = cRow + 
                    (IF cRow NE "":U THEN ",":U ELSE "":U)
                      + STRING(hBuffer:ROWID).      
         {set LastDbRowIdent cRow}.         
       END.
       /* Ensure the query cursor is consistent with when this is not done 
          (transferRows etc. relies on this)*/
       hQuery:GET-FIRST.
       hQuery:REPOSITION-BACKWARD(1).
     END. 
     ELSE 
       {set LastDbRowIdent cRow}. /* blank*/ 

     {get fetchOnOpen cFetchOnOpen}.
     IF cFetchOnOpen <> '':U THEN
     DO:
       IF LOOKUP(cFetchOnOpen,'FIRST,LAST':U) > 0 THEN
         RUN VALUE('fetch':U + cFetchOnOpen) IN TARGET-PROCEDURE.
       ELSE DO: 
         cFindFunc = ENTRY(1,cFetchOnOpen,CHR(2)).
         CASE cFindFunc:
           WHEN 'FindRowFromObject':U THEN
             DYNAMIC-FUNCTION(cFindFunc IN TARGET-PROCEDURE,
                              ENTRY(2,cFetchOnOpen,CHR(2)),
                              ENTRY(3,cFetchOnOpen,CHR(2)),
                              ENTRY(4,cFetchOnOpen,CHR(2))).
         END CASE.
       END.
     END.

     lReturn = TRUE.  
  END.   /* END DO IF QUERY-OPEN */                       

  /* Some visual objects that shows more than one record may need to know 
     that the query changed, this cannot be detected through the ordinary
     publish "dataAvailable" from the navigation methods. 
     The SmartSelect populates its list on this event and OCX objects
     like lists and Tree-views may also need to subscribe to this event. */
  PUBLISH "queryOpened":U FROM TARGET-PROCEDURE.

  RETURN lReturn.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-prepareQuery) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION prepareQuery Procedure 
FUNCTION prepareQuery RETURNS LOGICAL
  (pcQuery AS CHAR) :
/*------------------------------------------------------------------------------
     Purpose: Prepare the database query either for a SmartDataObject or 
              for another query object.              
  Parameters: pcQuery  - Complete query expression 
       Notes: This should normally not be called directly. There are basically 
              3 ways that it is used (2 from openQuery): 
              1: addQueryWhere, assignQuerywhere manipulates a client side
                 property that openQuery will check and use as input to this 
                 method.                
              2: setQueryWhere will call this method (if on server). It will
                 also blank properties used by 1 in order to ensure that 
                 openQuery does NOT call this in that case.
              3. openQuery will also call it if he query is unprepared when 
                 it is called. This function uses the OpenQuery - BaseQuery 
                 if called with blank or ? parameter. 
   Note date: 2002/07/02                        
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hQuery   AS HANDLE NO-UNDO.         
  DEFINE VARIABLE lOk      AS LOGICAL NO-UNDO.
  DEFINE VARIABLE cMessage AS CHARACTER NO-UNDO.
  DEFINE VARIABLE lDummy   AS LOGICAL NO-UNDO.
  DEFINE VARIABLE lShowMsg AS LOGICAL NO-UNDO.
  
  {get QueryHandle hQuery}.   

  IF pcQuery = '':U OR pcQuery = ? THEN
    {get OpenQuery pcQuery}.
  
  lOk = hQuery:QUERY-PREPARE(pcQuery) no-error.
 
  if not lok then 
  do: 
     cMessage = substitute({fnarg messageNumber 106},trim(error-status:get-message(1))). 
     
     lShowMsg = true.
     if {fn getManageReadErrors} then 
     do:         
        RUN addMessage in target-procedure(cMessage,?,?).
        /* if remote ensure error is written to log file */
        lShowMsg = session:remote.  
     end.
     if lShowMsg then
       RUN showMessageProcedure in target-procedure(cMessage, output lDummy).      
  end.    
  RETURN lOk.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-refreshRowident) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION refreshRowident Procedure 
FUNCTION refreshRowident RETURNS CHARACTER
  ( pcRowident AS CHAR) :
/*------------------------------------------------------------------------------
   Purpose: Returns a refreshed list of rowids for the readonly tables 
            in the current query.
Parameters: pcRowident - RowIdent of a row in  the current query.  
     Notes: Used internally by refetchDbRow in order to make changes to 
            foreignfields reflected in correctly joined tables.  
            
            The refresh applies to read-only tables that are at the 
            end of the join (no updatable tables further down in the join). 
            The first Rowid is NOT refreshed.  
             
            It is assuming that SDOs are used correctly,            
            - Only one copy of the record that's being updated in the query,
              which means one-to-one updates if many updatable records.   
            
            There are several changes that still require an open query to be
            reflected.             
            - Changes in a child record that changes or makes a parent 
              relationship invalid is NOT reflected and will still require 
              a complete open query.
            
            - Changes that makes an inner-join invalid will blank out Rowids 
              for ALL read-only tables, even if some of them still was valid. 
              Note that if the query was reopened this row would disappear from 
              the query. Normally an application would of course validate that 
              no invalid keys are entered, but a value could also be changed so 
              that it was filtered away.   
               
            - Two updatable tables will not reflect changes in relationships
              to each other.                 
------------------------------------------------------------------------------*/
 DEFINE VARIABLE cColumns      AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE iTable        AS INTEGER    NO-UNDO.
 DEFINE VARIABLE iFirstROTable AS INTEGER    NO-UNDO.
 DEFINE VARIABLE cTables       AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cBufferQuery  AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cQueryWhere   AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cQuery        AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE iPos          AS INTEGER    NO-UNDO.
 DEFINE VARIABLE cRowident     AS CHARACTER  NO-UNDO.

 {get UpdatableColumnsByTable cColumns}.
 
 /* Nothing to refresh if only one table */
 IF NUM-ENTRIES(cColumns,{&adm-tabledelimiter}) = 1 THEN 
   RETURN pcRowIdent.
 
 {get Tables cTables}.
 /* Search from the last table to find the upper table of ONLY read only tables 
   (readonly table that are BEFORE updatable tables CANNOT be refreshed)
    excluding the first table in the join */ 
 
 DO iTable = NUM-ENTRIES(cTables) TO 2 BY -1:
   IF ENTRY(iTable,cColumns,{&adm-tabledelimiter}) <> '':U THEN
     LEAVE.
   iFirstROTable = iTable.
 END.
 
 /* No readonly table found  */ 
 IF iFirstRoTable = 0 THEN
   RETURN pcRowident.
 
 /* Build a query that uniquely identifies all non-refreshable tables from
    the passed Rowident */
 cQuery = 'FOR ':U.   
 DO iTable = 1 TO iFirstROTable - 1:   
   cQuery = cQuery
            + 'EACH ':U 
            + ENTRY(iTable,cTables) 
            + ' WHERE ROWID(':U 
            + ENTRY(iTable,cTables) 
            + ') = to-rowid(~'':U
            + ENTRY(iTable, pcRowIdent)
            + '~'),':U.
    
 END. /* do iTable = 1 to iFirstROTable -1 */
 
 {get QueryWhere cQueryWhere}.
 ASSIGN 
   /* Find the WhereClause of the first RO table */
   cBufferQuery  = DYNAMIC-FUNCTION('bufferWhereClause':U IN TARGET-PROCEDURE,
                                     ENTRY(iFirstROTable,cTables),
                                     cQueryWhere)
   /* Use it to find where to 'break' the query */
   iPos          = INDEX(cQueryWhere,cBufferQuery)
   
   /* Add the query built above that uniquely identifies non-refreshable tables 
      in front of the where clauses for the read only tables(s) */  
   cQuery        = cQuery + SUBSTR(cQueryWhere,iPos)
   
   /* The refreshed rowids is the first row for this query */  
   cRowident     = {fnarg firstRowids cQuery}.
 
 /* The query did not find any records; This may have many reasons,
    one of them being a change of a keyfield that makes an inner join fail, 
    we ALWAYS return non-refreshable rowidents, so we just blank the readonly.*/
 IF cRowIdent = ? THEN
 DO:
   DO iTable = iFirstROTable TO NUM-ENTRIES(pcRowident):
     ENTRY(iTable,pcRowident) = '':U. 
   END.
   RETURN pcRowIdent. 
 END.

 RETURN REPLACE(cRowident,'?':U,'':U).
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
  DEFINE VARIABLE hContainer    AS HANDLE     NO-UNDO.

  &SCOPED-DEFINE xp-assign
  {get ForeignValues cForeignValues}
  {get ForeignFields cForeignFields}.
  &UNDEFINE xp-assign
  
  IF cForeignFields = '':U THEN
  DO:
    {get ContainerSource hContainer}.
    {get ForeignFields cForeignFields hContainer} NO-ERROR.
    IF cForeignFields = '':U OR cForeignFields = ? THEN
      RETURN FALSE.
  END.

  /* 1st of each pair is local db query fld  */
  DO iField = 1 TO NUM-ENTRIES(cForeignFields) BY 2:
    cLocalFields = cLocalFields +  
      (IF cLocalFields NE "":U THEN ",":U ELSE "":U)
        + ENTRY(iField, cForeignFields).
  END. /*  DO iField -- find list of local part of Foreign Fields */  
  
  RETURN DYNAMIC-FUNCTION('removeQuerySelection':U IN 
                           (IF VALID-HANDLE(hContainer) 
                            THEN hContainer 
                            ELSE TARGET-PROCEDURE),
                           cLocalFields,
                           '=':U).
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-resetQueryString) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION resetQueryString Procedure 
FUNCTION resetQueryString RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose: data-source interface for resetting the query to default.
    Notes: setQueryWhere is not implemented in DataView.
------------------------------------------------------------------------------*/
{set QueryWhere ''}.
  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-resolveBuffer) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION resolveBuffer Procedure 
FUNCTION resolveBuffer RETURNS CHARACTER
  ( pcBuffer AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose: Resolves the correct qualified buffer name of the passed buffer 
           reference.  
Parameter: Buffer name, qualifed or unqualified.          
    Notes: Returns blank if the buffer cannot be resolved in the SDO. 
           Returns unknown if the table reference is ambiguous, (More than 
           one table in the SDO matches the unqualifed input parameter).
         - Used internally (columnTable and others) to resolve cases where the 
           passed column name's qualification is different from the object's.
         - There's no reference to the query handle in order to resolve this
           on the client.     
------------------------------------------------------------------------------*/
   DEFINE VARIABLE cTableList      AS CHARACTER  NO-UNDO.
   DEFINE VARIABLE lUseDBQualifier AS LOGICAL    NO-UNDO.
   DEFINE VARIABLE cDBTable        AS CHARACTER  NO-UNDO.
   DEFINE VARIABLE cDBNames        AS CHARACTER  NO-UNDO.
   DEFINE VARIABLE iTable          AS INTEGER    NO-UNDO.
   DEFINE VARIABLE iEntry          AS INTEGER    NO-UNDO.

   {get Tables cTableList}.
    
   /* if the table part matches Tables, just return it */  
   IF CAN-DO(cTableList,pcBuffer) THEN
     RETURN pcBuffer.

   &SCOPED-DEFINE xp-assign
   {get UseDBQualifier lUseDBQualifier}
   {get DBNames cDBNames}.
   &UNDEFINE xp-assign

   /* If DB Qualifier in parameter, but not in object */
   IF NUM-ENTRIES(pcBuffer,".":U) = 2 AND NOT lUseDBQualifier THEN
   DO iTable = 1 TO NUM-ENTRIES(cTableList):
     cDBTable = ENTRY(iTable,cDBNames) + ".":U + ENTRY(iTable,cTableList).
      /* We found a Match, set cTable and leave the loop  */
     IF pcBuffer = cDBTable THEN
       RETURN ENTRY(iTable,cTableList).
   END. /* do iTable if .. DBQualified parameter, but not in object */
   ELSE IF NUM-ENTRIES(pcBuffer,".":U) = 1 AND lUseDBQualifier THEN
   DO:
     /* We check all entries to ensure that this is unambiguos.*/  
     DO iTable = 1 TO NUM-ENTRIES(cTableList):
       cDBTable = ENTRY(iTable,cDBNames) + ".":U + pcBuffer.
       IF cDBTable = ENTRY(iTable,cTableList) THEN
       DO: 
         /* We already found an entry so return ? to signal amibiguity. */
         IF iEntry <> 0 THEN
           RETURN ?. 
         ELSE 
           iEntry = iTable. 
       END. /* iTable,dbname + pcBuffer = iTable,cTableList */
     END. /* Do iTable = 1 to num-entries(cTables) */
     
     IF iEntry <> 0 THEN 
       RETURN ENTRY(iEntry,cTableList).
   END. /* else if .. no DBQual parameter, but DBqual in object  */
   
   /* We only get here if we're not able to resolve the table */ 
   RETURN "":U. 

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-rowidWhere) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION rowidWhere Procedure 
FUNCTION rowidWhere RETURNS CHARACTER
  (pcWhere AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:    Returns the ROWID (converted to a character string) of the first 
              database query row satisfying the where clause.  In the case of a 
              join, only the rowid of the first table in the join will be 
              returned and the expression in pcWhere can only reference that 
              table.
 
  Parameters:
    pcWhere - The where clause to apply to the database query to fetch the
              first record whose ROWID will be returned.
            -   
  
  Notes:      The ROWID is returned as a string both in anticipation of it
              being used as an argument to fetchRowIdent, and also to allow
              this function to be invoked from outside Progress.
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cTables     AS CHAR   NO-UNDO.
  DEFINE VARIABLE cQueryWhere AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cBuffer     AS CHARACTER NO-UNDO.
  
  &SCOPED-DEFINE xp-assign
  {get Tables cTables}
  {get QueryWhere cQueryWhere}.
  &UNDEFINE xp-assign

  ASSIGN
    cBuffer     = ENTRY(1,cTables)     
    cQueryWhere = DYNAMIC-FUNCTION('newWhereClause':U IN TARGET-PROCEDURE,
                                    cBuffer,pcWhere,cQueryWhere,"":U).
    
  RETURN ENTRY(1,DYNAMIC-FUNCTION('firstRowIds':U IN TARGET-PROCEDURE,
                                    cQueryWhere)
               ).
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-rowidWhereCols) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION rowidWhereCols Procedure 
FUNCTION rowidWhereCols RETURNS CHARACTER
  (pcColumns     AS CHARACTER,   
   pcValues      AS CHARACTER,    
   pcOperators   AS CHARACTER):
/*------------------------------------------------------------------------------   
     Purpose: Returns a list of rowids    
              Adds column/value pairs to the corresponding buffer's where-clause. 
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
---------------------------------------------------------------------------*/
  DEFINE VARIABLE cQueryString AS CHAR NO-UNDO.
  DEFINE VARIABLE cRowids      AS CHAR NO-UNDO.

  cQueryString = DYNAMIC-FUNCTION('newQueryString':U IN TARGET-PROCEDURE,
                                  pcColumns,
                                  pcValues,
                                  pcOperators,
                                  ?,
                                  ?).
  
  cRowids = DYNAMIC-FUNCTION('firstRowIds':U IN TARGET-PROCEDURE,
                              cQueryString).
  
  RETURN cRowids.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

