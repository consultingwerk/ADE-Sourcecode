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
    File        : query.p
    Purpose     : Super procedure for ADM objects which retrieve data from
                  database tables.

    Syntax      : adm2/query.p

    Modified    : IZ 1569 : Foreign fields requires field to exist in target
                  SDO RowObject.
                  Fix : Renamed function columnHandle to dbColumnHandle and
                  updated all references to it here.
    Modified    : IZ 4050 Gikas A. Gikas
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
  /* Tell qryprop.i that this is the query super procedure. */
&SCOP ADMSuper query.p
&SCOPED-DEFINE MaxTables 18
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

&IF DEFINED(EXCLUDE-addQueryWhere) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD addQueryWhere Procedure 
FUNCTION addQueryWhere RETURNS LOGICAL
  (pcWhere  AS CHARACTER,
   pcBuffer AS cHARACTER,
   pcAndOr  AS CHARACTER) FORWARD.

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

&IF DEFINED(EXCLUDE-bufferWhereClause) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD bufferWhereClause Procedure 
FUNCTION bufferWhereClause RETURNS CHARACTER
  (pcBuffer AS CHAR,
   pcWhere  AS CHAR)  FORWARD.

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

&IF DEFINED(EXCLUDE-removeQuerySelection) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD removeQuerySelection Procedure 
FUNCTION removeQuerySelection RETURNS LOGICAL
  (pcColumns   AS CHARACTER,
   pcOperators AS CHARACTER) FORWARD.

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
         HEIGHT             = 15
         WIDTH              = 56.
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

  Parameters:
    INPUT phRowObjUpd - handle of the buffer to copy from.
  
  Notes:       The procedure copies over only those fields whose values were
               actually modified, unless this is a copied record, in which
               case we want to save all the fields that were enabled for update.
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
  DEFINE VARIABLE iEntry             AS INTEGER   NO-UNDO.
  DEFINE VARIABLE iBracket           AS INTEGER   NO-UNDO.
  DEFINE VARIABLE iExtent            AS INTEGER   NO-UNDO.
  DEFINE VARIABLE hRowMod            AS HANDLE    NO-UNDO.
  DEFINE VARIABLE cRowIdent          AS CHARACTER NO-UNDO.
  DEFINE VARIABLE lCreate            AS LOGICAL   NO-UNDO.
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


  /* get the 'before' record if this is an Update... */
  IF phRowObjUpd:BUFFER-FIELD('RowMod':U):BUFFER-VALUE = "U":U THEN
  DO:
    CREATE BUFFER hRowBefore FOR TABLE phRowObjUpd.
    hRowBefore:FIND-FIRST('WHERE RowMod = "" AND RowNum = ':U +
                          STRING(phRowObjUpd:BUFFER-FIELD('RowNum':U):BUFFER-VALUE)).
  END.
  ELSE DO: /* if new create a rowObject and compare with this to identify
              which fields have been actively changed  */ 
    {get RowObject hRowBefore}.
    CREATE BUFFER hRowBefore FOR TABLE hRowBefore.
    hRowBefore:BUFFER-CREATE(). 
  END.

  /* This will get the list of Updatable Columns with CHR(1) delimiters between
     columns from different tables. */
  {get UpdatableColumnsByTable cUpdColumnsByTable}.
  {get DataColumnsByTable cColumnsByTable}.
  {get DataColumns cDataColumns}.
  {get BufferHandles cBuffers}.    /* handles of database record buffers */  
  {get Tables cTables}.            /* names of database tables */
  {get AssignList cAssignList}.    /* assign syntax for modified field names */
  hRowMod = phRowObjUpd:BUFFER-FIELD('RowMod':U).  
  DO iTable = 1 TO NUM-ENTRIES(cBuffers):
    ASSIGN
      hBuffer       = WIDGET-HANDLE(ENTRY(iTable, cBuffers))
      cExclude      = {fnarg excludeColumns iTable}
      cAssignFields = ENTRY(iTable, cAssignList, CHR(1))
      cUpdColumns   = ENTRY(iTable,cUpdColumnsByTable, CHR(1))
      cColumns      = ENTRY(iTable,cColumnsByTable, CHR(1))
      cNotChanged   = '':U.
 
    /* This table has enabled fields, so update it. */
    IF cUpdColumns NE "":U THEN
    DO: 
      /* If this is an Add or a Copy then create the DB records first. */
      IF hRowMod:BUFFER-VALUE = "A":U OR hRowMod:BUFFER-VALUE = "C":U THEN
      DO:
        /* Use NO-ERROR to trap CREATE trigger return ERROR */
        DO ON ERROR UNDO, LEAVE:
          lCreate = hBuffer:BUFFER-CREATE(). 
        END.
        /* Probably not very likely that anyone would code trigger errors in a 
           create trigger (?), as no data has yet been assigned, but we do 
           support passing a return-value from the trigger as a message to the 
           client, but an ERROR is required to undo the create, so the trigger
           would need to have the following error handling. 
           RETURN ERROR cMessages + "my-error-message". 
           Regular errors is more likely (sequences out of sequence...eh.)
           and will be brought to the client if the caller calls 
           addMessage with unknown as the indicator to use error-status */    
        IF NOT lCreate THEN
          /* Prepend a potential return-value and append the table as the last 
             CHR(3) entry */
          RETURN RETURN-VALUE 
                 + (IF RETURN-VALUE = '':U THEN '':U ELSE CHR(3))
                 + ENTRY(iTable, cTables).                                   
      END.       /* END DO IF "A" or "C" */   
      
      DO iField = 1 TO NUM-ENTRIES(cColumns):
        ASSIGN
          cFromField = ENTRY(iField,cColumns).
          IF LOOKUP(cFromField,cUpdColumns) > 0 THEN
            ASSIGN
              hRowUpdFld = phRowObjUpd:BUFFER-FIELD(cFromField)
              hRowOldFld = hRowBefore:BUFFER-FIELD(cFromField)
              lChanged   = IF hRowUpdFld:DATA-TYPE = "CHARACTER":U 
                           THEN COMPARE(hRowUpdFld:BUFFER-VALUE, 
                                        '<>':U, 
                                        hRowOldFld:BUFFER-VALUE, 
                                        'case-sensitive':U) 
                           ELSE hRowUpdFld:BUFFER-VALUE <> hRowOldFld:BUFFER-VALUE.
          ELSE 
            lChanged = FALSE.
  
          /* The fromfield will be replaced by ToField if different when 
             looping through the assignFields */ 
        IF NOT lChanged THEN
          cNotChanged = cNotChanged 
                      + (IF cNotChanged = '':U THEN '':U ELSE ',':U)
                      + cFromField.
      END.
      /* Loop through the field mappings in order to identify fields that 
         must be assigned directly (extents) and in order to rename entries 
         that are in the notchanged list and remove them from the assinglist.
         We need two variables; the UseAssignFields is being changed while 
         AssignFields need to remain unchanged in order to be looped */ 
      cUseAssignFields = cAssignFields.
      DO iField = 1 TO NUM-ENTRIES(cAssignFields) BY 2:
        ASSIGN
          cFromField   = ENTRY(iField,cAssignFields)
          cToField     = ENTRY(iField + 1,cAssignFields)
          /* Is the FromField unchanged */
          iEntry       = LOOKUP(cFromField,cNotChanged)
          /* is this a mapping to an extent */
          iBracket     = INDEX(cToField, '[':U).
        /* We check whether the mapping truly is unambiguous, because the third 
           parameter to buffer-copy does not care about the order and may thus
           behave different when data is read to the rowObject than when being
           saved to the db if the mapping is ambiguous. It is in reality very 
           unlikely that the buffer-copy in data read would handle this properly
           and an ambiguous mapping would also be very awkward, but we cannot 
           exclude that there are cases where it could happen, for example when 
           the SDO is mapped to many tables and/or the table has unmapped fields
           and/or when using the Object Generator.             
          (The mapping is ambiguous if both the TO and FROM exists in 
           the opposite buffers, use no-error to avoid the expected
           error message ) */ 
        ASSIGN
          lAmbiguous   = LOOKUP(cToField,cDataColumns) > 0
                         AND VALID-HANDLE(hBuffer:BUFFER-FIELD(cFromField)) NO-ERROR.  
        
        /* If not changed or if assigned directly below then remove the fields 
           from the assignlist that will be used in buffer-copy. */ 
        IF iEntry > 0 OR iBracket > 0 OR lAmbiguous THEN
          cUseAssignFields = TRIM(REPLACE(",":U + cUseAssignFields + ",":U,
                                          ",":U + cFromField + ",":U + cToField + ",":U,
                                          ",":U),
                                          ",":U). 
        /* If bracket then remove the bracketfrom the Tofield for inclusion 
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
        IF iEntry > 0 OR iBracket > 0 OR lAmbiguous THEN
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
               as some may have defined the RowObject using LIKE to be able to 
               use one SDO against a large table. */ 
             cNotChanged = cNotChanged 
                         + (IF cNotChanged = '':U THEN '':U ELSE ',':U)
                         + cToField.
          /* The fromfield is of course in the list if entry <> 0 */
          IF iEntry = 0 AND LOOKUP(cFromField,cNotChanged) = 0 THEN 
            cNotChanged = cNotChanged 
                        + (IF cNotChanged = '':U THEN '':U ELSE ',':U)
                        + cFromField.
        END.

        /* if changed and extent or ambiguous mapping then do an explicit 
           assign of the ToField from the FromField */
        IF iEntry = 0 AND (iBracket > 0 OR lAmbiguous) THEN
        DO:
          ASSIGN
            hRowUpdFld = phRowObjUpd:BUFFER-FIELD(cFromField)
            hDBField   = hBuffer:BUFFER-FIELD(cToField)
            hDBField:BUFFER-VALUE(iExtent) = hRowUpdFld:BUFFER-VALUE NO-ERROR.
          IF ERROR-STATUS:ERROR THEN   /* in case something's bad */
           /* Prepend a potential return-value and append the table as the last 
             CHR(3) entry */
            RETURN RETURN-VALUE 
                   + (IF RETURN-VALUE = '':U THEN '':U ELSE CHR(3))
                   + ENTRY(iTable, cTables).   
        END.
      END. /* iField = 1 to num-entries(assignFields) */
      hBuffer:BUFFER-COPY(phRowObjUpd,
                          cNotChanged 
                          + (IF cNotChanged <> '':U AND cExclude <> '':U 
                             THEN ",":U ELSE "":U)
                          + cExclude,
                          cUseAssignFields) NO-ERROR. 
      IF ERROR-STATUS:ERROR THEN   /* in case something's bad */
                  /* Prepend a potential return-value and append the table as the last 
                     CHR(3) entry */
        RETURN RETURN-VALUE 
               + (IF RETURN-VALUE = '':U THEN '':U ELSE CHR(3))
               + ENTRY(iTable, cTables).   

    END. /* cUpdColumns <> '':u */      

    IF hRowMod:BUFFER-VALUE = "A":U OR hRowMod:BUFFER-VALUE = "C":U THEN
    DO:
      /* We reference the ROWID of the new row only AFTER the field values have 
         been assigned. This is necessary because DataServers create the
         record as soon as the ROWID is referenced rather than at the end of the 
         transaction and this may cause errors if for example the fields are 
         not allowed to have NULL values in the DataServer have not yet been 
         assigned. */
      
        /* For DataServers, we need to capture errors when creating the record, 
           like duplicate key errors, because they will happen when we 
           reference ROWID */
      cRowid = STRING(hBuffer:ROWID) NO-ERROR.
        
        /* If the ROWID for the current buffer is blank, a DataServer 
           record was not created for some reason. */
      IF cRowid = "":U THEN 
        RETURN ENTRY(iTable, cTables).

      cRowIdent = IF iTable = 1 
                  THEN cRowid
                  ELSE cRowIdent 
                       + ",":U 
                       + (IF hBuffer:AVAILABLE THEN cRowid ELSE "":U).
    END. /* new record */
  END.  /* DO iTable */

  IF hRowMod:BUFFER-VALUE = "A":U OR hRowMod:BUFFER-VALUE = "C":U THEN
  DO:
    ASSIGN 
      phRowObjUpd:BUFFER-FIELD('RowIdentIdx':U):BUFFER-VALUE = SUBSTR(cRowIdent, 1, xiRocketIndexLimit)
      phRowObjUpd:BUFFER-FIELD('RowIdent':U):BUFFER-VALUE = cRowIdent.

    hRowBefore:BUFFER-DELETE().   
  END.

  DELETE OBJECT hRowBefore NO-ERROR.
    
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

  DEFINE VARIABLE hBuffer    AS HANDLE    NO-UNDO.
  DEFINE VARIABLE cBuffers   AS CHARACTER NO-UNDO.
  DEFINE VARIABLE iTable     AS INTEGER   NO-UNDO.
  DEFINE VARIABLE hRowObjUpd AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hRowObjFld AS HANDLE    NO-UNDO.
  DEFINE VARIABLE cAssigns   AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cRowIdent  AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cExclude   AS CHARACTER NO-UNDO.
  DEFINE VARIABLE lSame      AS LOGICAL   NO-UNDO.
  
  {get BufferHandles cBuffers}.       /* DB buffer handles */
  {get AssignList cAssigns}.          /* List of fields whose names were changed */
  {get RowObjUpd hRowObjUpd}.
  
  cRowIdent = hRowObjUpd:BUFFER-FIELD('RowIdent':U):BUFFER-VALUE.

  DO iTable = 1 TO NUM-ENTRIES(cBuffers):
    IF ENTRY(iTable, cRowIdent) NE "":U THEN /* allow for outer join w/ no rec */
    DO:
      ASSIGN
        hBuffer  = WIDGET-HANDLE(ENTRY(iTable, cBuffers))
        /* don't compare with field form other tables that have the same 
           name, but are not used */ 
        cExclude = {fnarg excludeColumns iTable}.
      
      IF INDEX(cAssigns, "[":U) = 0 THEN 
        lSame = hBuffer:BUFFER-COMPARE(hRowObjUpd, 
                                       'case-sensitive':U,
                                       cExclude, 
                                       ENTRY(iTable, cAssigns, CHR(1))).
      ELSE    /* If array elements are present, we must assign them manually. */
        lSame = bufferCompareDBToRO(hRowObjUpd, 
                                   hBuffer, 
                                   cExclude, 
                                   ENTRY(iTable, cAssigns, CHR(1))).
      IF NOT lSame THEN
      DO:
        {get Tables cBuffers}.
        RETURN ENTRY(iTable, cBuffers).
      END.  /* END DO IF AVAILABLE */
    END.    /* END DO IF cRowIdent NE "" */
  END.      /* END DO iTable */
  RETURN.
       
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

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
           (Currently the Navigation actions are disabled whenever a state
            that may disallow continuation is set to true, but if a less modal 
            dialog could be achieved by calling this from fetch* methods.)
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
                        will NOT be reopened.   
         DIFFERENT    - Request to reapply foreign Fields.  
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
 DEFINE VARIABLE iValue         AS INTEGER   NO-UNDO.      
 DEFINE VARIABLE cValue         AS CHARACTER NO-UNDO.  
 DEFINE VARIABLE lCharacter     AS LOGICAL   NO-UNDO.
 DEFINE VARIABLE cFieldName     AS CHARACTER NO-UNDO.
 DEFINE VARIABLE cFieldType     AS CHARACTER NO-UNDO.  
 DEFINE VARIABLE cQuery         AS CHARACTER NO-UNDO.  
 DEFINE VARIABLE hQuery         AS HANDLE    NO-UNDO.
 DEFINE VARIABLE cPosition      AS CHARACTER NO-UNDO.
 DEFINE VARIABLE iCurrent       AS INTEGER   NO-UNDO.  
 DEFINE VARIABLE cNewPos        AS CHARACTER NO-UNDO.
 DEFINE VARIABLE lNewSource     AS LOGICAL   NO-UNDO.
 DEFINE VARIABLE lNewModeSource AS LOGICAL   NO-UNDO.
 DEFINE VARIABLE cASDivision    AS CHARACTER NO-UNDO.
 DEFINE VARIABLE hSource        AS HANDLE    NO-UNDO.
 DEFINE VARIABLE cObjectName    AS CHARACTER NO-UNDO.
 DEFINE VARIABLE cCurrentValues AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE lFetched       AS LOGICAL    NO-UNDO.
 DEFINE VARIABLE lNewMode       AS LOGICAL    NO-UNDO.
 /* If the same row is being resent because of an update, we don't want to react 
    to that, so just skip it if it's not a different row. */
 
  IF pcRelative = "SAME":U THEN RETURN.
 
  /* Get the foreign fields, which map the Data Source's RowObject fields
     to this object's database fields and prepare the Query
     using that value. setQueryWhere will open the query. */
  {get ForeignFields cForeignFields}.
  IF cForeignFields = "":U OR pcRelative = "VALUE-CHANGED":U THEN
  DO:
    
      
      /* If there were no ForeignFields, a Browser has repositioned the query.
       Just pass along the event to other targets. Set QueryPosition
       property first if that has changed. */
    {get QueryHandle hQuery}.   /* Points to the database query */
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
    {set ForeignValues cValues}.  
    DYNAMIC-FUNCTION("assignQuerySelection":U IN TARGET-PROCEDURE, 
                      cLocalFields,
                      cValues,
                      '':U).  
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
  END.  
  ELSE DO:
    {fn openQuery}.
  END.

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
------------------------------------------------------------------------------*/
  DEFINE VARIABLE iTable           AS INTEGER   NO-UNDO.
  DEFINE VARIABLE hRowObjUpd       AS HANDLE    NO-UNDO.
  DEFINE VARIABLE rRowid           AS ROWID     NO-UNDO.
  DEFINE VARIABLE hBuffer          AS HANDLE    NO-UNDO.
  DEFINE VARIABLE cBuffers         AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cTables          AS CHARACTER NO-UNDO.
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
  DEFINE VARIABLE cDelMessage      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cAsDivision      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE rRowidList       AS ROWID    EXTENT {&maxtables} NO-UNDO.

  {get BufferHandles cBuffers}.    /* DB Buffer handles. */
  {get RowObjUpd hRowObjUpd}.
  {get Tables cTables}.            /* DB Table names. */
  {get UpdatableColumnsByTable cUpdTbls}.
  ASSIGN hRowIdent = hRowObjUpd:BUFFER-FIELD('RowIdent':U)
         cRowIdent = hRowIdent:BUFFER-VALUE
         hRowMod   = hRowObjUpd:BUFFER-FIELD('RowMod':U).
  DO iTable = 1 TO NUM-ENTRIES(cRowIdent):
    hBuffer = WIDGET-HANDLE(ENTRY(iTable, cBuffers)).
    IF ENTRY(iTable, cRowIdent) NE "":U THEN  /* allow for outer-join w/ no rec*/
    DO:
      rRowid = TO-ROWID(ENTRY(iTable, cRowIdent)).
      IF NOT hBuffer:FIND-BY-ROWID(rRowid, EXCLUSIVE-LOCK, NO-WAIT) THEN
      DO:
        IF hRowMod:BUFFER-VALUE = "D":U AND iTable > 1 THEN
          NEXT.
        ELSE
          RETURN ENTRY(iTable, cTables).
      END.
      IF hRowMod:BUFFER-VALUE = "D":U THEN
      DO:
        IF ENTRY(iTable, cUpdTbls, CHR(1)) = "":U THEN
          /* Table has no enabled fields, so it's not updatable
             and can't be deleted. */
          NEXT.
        ELSE DO ON ERROR UNDO, LEAVE:
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
      END.  /* END DO IF "D"elete */
    END.    /* END DO IF RowIdent NE "" */
    /* If there is no record for this buffer then do a release to clear
       out any leftover record in case code looks at it later. */
    ELSE hBuffer:BUFFER-RELEASE() NO-ERROR.
  END.      /* END DO iTable */
  
  /* sendRows currently does not reopen the query when running locally, so 
     we do a delete-result-list-entry so transferRows does not find this 
     row in the result list when determining where to start retrieving records 
     for the next batch. */
  {get AsDivision cAsDivision}.
  IF cAsDivision = '':U THEN
  DO:
    /* Only delete result list entry if all records in the row are deleted,
     or if the first record in the row is deleted. */
    IF lFirstRecDeleted OR (iDelCnt = NUM-ENTRIES(cRowIdent)) THEN
    DO:
      {get QueryHandle hQuery}.
      DO iTable = 1 TO NUM-ENTRIES(cRowIdent):
        rRowIDList[iTable] = TO-ROWID(ENTRY(iTable, cRowIdent)) NO-ERROR.
      END.
      IF hQuery:REPOSITION-TO-ROWID(rRowidList) THEN
        hQuery:DELETE-RESULT-LIST-ENTRY().
    END.
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
    {get QueryRowIdent cRowIdent}.
    {set QueryRowIdent ?}.   /* Immediately reset once we have the value. */
    IF cRowIdent NE ? AND cRowIdent NE "":U THEN
    DO:
      {get SkipQueryRowIdent lSkipRowident}.
      {set SkipQueryRowIdent FALSE}.   /* Immediately reset  */
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
   
   {set FetchOnOpen '':U}.
   /* close query to avoid openQuery wiping out all batchprops */ 
   {get DataHandle hDataQuery}.
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
   {set FetchOnOpen '':U}.
   /* close query to avoid openQuery wiping out all batchprops */ 
   {get DataHandle hDataQuery}.
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
  DEFINE VARIABLE lHasAudit               AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lHasComment             AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lHasAutoComment         AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cEntityFields           AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cKeyTable               AS CHARACTER  NO-UNDO.

 IF VALID-HANDLE(gshGenManager) THEN  
 DO:
   {get EnabledTables cKeyTable}.
   /* First enabled .. */
   cKeyTable = ENTRY(1,cKeyTable).
 
   /* if no enabled use the first table */
   IF cKeyTable = '':U THEN
     cKeyTable = ENTRY(1,{fn getTables}).
  
   IF cKeyTable <> "":U THEN
   DO:
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
      
       iLookup= LOOKUP("HasAudit",cKeyTableEntityFields,CHR(1)). 
       IF iLookup > 0 THEN
         ASSIGN lHasAudit = CAN-DO("TRUE,YES",ENTRY(iLookup,cKeyTableEntityValues,CHR(1) )).
      
       iLookup= LOOKUP("HasComment",cKeyTableEntityFields,CHR(1)). 
       IF iLookup > 0 THEN
         ASSIGN lHasComment = CAN-DO("TRUE,YES",ENTRY(iLookup,cKeyTableEntityValues,CHR(1) )).
      
       iLookup= LOOKUP("HasAutoComment",cKeyTableEntityFields,CHR(1)). 
       IF iLookup > 0 THEN
         ASSIGN lHasAutoComment = CAN-DO("TRUE,YES",ENTRY(iLookup,cKeyTableEntityValues,CHR(1) )).

       IF lHasObjectField THEN
         IF LOOKUP("entity_object_field",cKeyTableEntityFields,CHR(1)) <> 0 THEN 
           ASSIGN cKeyTableEntityObjField = ENTRY( LOOKUP("entity_object_field",cKeyTableEntityFields,CHR(1)) ,cKeyTableEntityValues,CHR(1) ).
       ELSE
         IF LOOKUP("entity_key_field",cKeyTableEntityFields,CHR(1)) <> 0 THEN 
           ASSIGN cKeyTableEntityObjField = ENTRY( LOOKUP("entity_key_field",cKeyTableEntityFields,CHR(1)) ,cKeyTableEntityValues,CHR(1) ).
       cEntityFields = (IF lHasAudit THEN 'HasAudit,':U ELSE '':U)
                        +
                       (IF lHasComment THEN 'HasComment,':U ELSE '':U)
                        +
                       (IF lHasAutoComment THEN 'AutoComment':U ELSE '':U).
 
        {set EntityFields cEntityFields}.  
        {set KeyTableId cKeyTableEntityMnemonic}.
        {set KeyFields  cKeyTableEntityObjField}.
     END.
   END. /* KeyTable <> '' */
 END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-initializeObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeObject Procedure 
PROCEDURE initializeObject :
/*------------------------------------------------------------------------------
  Purpose:     Initialization code for query objects.
  
  Parameters:  <none>
  
  Notes:       The query is not opened if we have a DataSource. This is because
               a DataSource means the object is dependent on data from another
               object. In this case the Data-Target (this procedure) waits
               until the dataAvailable event tells it to open its query. 
               Instead, this procedure RUNs dataAvailable to see if its 
               DataSource is already running with a row available for it;
               in that case the dataAvailable will open the query.
  ------------------------------------------------------------------------------*/

  DEFINE VARIABLE hDataSource     AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hContainerSrc   AS HANDLE    NO-UNDO.
  DEFINE VARIABLE lQueryContainer AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE cUIBMOde        AS CHARACTER NO-UNDO.
  DEFINE VARIABLE lOpenOnInit     AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE lQuery          AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cAsDivision     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lIsFetchPending AS LOGICAL    NO-UNDO.

  RUN SUPER.

  IF RETURN-VALUE = "ADM-ERROR":U THEN 
    RETURN "ADM-ERROR":U.
  
  {get AsDivision cAsDivision}.
  IF VALID-HANDLE(gshGenManager) AND cAsDivision <> 'CLIENT':U THEN
    RUN initializeEntityDetails IN TARGET-PROCEDURE.

  /* Don't open query in design mode  */
  {get UIBMode cUIBMode}.
  {get OpenOnInit lOpenOnInit}.  /* Suppress normal automatic openQuery */
  {get ContainerSource hContainerSrc}.

  IF VALID-HANDLE(hContainerSrc) THEN
  DO:
    IF cAsDivision = 'CLIENT':U THEN
      lIsFetchPending = {fn IsFetchPending hContainerSrc}.
    {get QueryObject lQueryContainer hContainerSrc}.
  END.

  IF (NOT cUIBMode BEGINS "Design":U) THEN 
  DO:
  /* Also, don't open the query or run dataavailable if we're inside a 
       container such as an SBO; in that case it gets our data for us. */  
    IF NOT (lQueryContainer = TRUE) AND NOT lIsFetchPending THEN
    DO:
      {get DataSource hDataSource}.
      {get QueryObject lQuery hDataSource} NO-ERROR.
      IF lOpenOnInit THEN
      DO:
        IF  hDataSource = ? OR NOT lQuery THEN 
          {fn openQuery}.
        ELSE 
          RUN dataAvailable IN TARGET-PROCEDURE (?).  /* Don't know if different row. */
      END.
      ELSE IF VALID-HANDLE(hDataSource)
      AND DYNAMIC-FUNCTION('getObjectInitialized':U IN hDataSource)
      AND cAsDivision = 'CLIENT':U   THEN
        /* child of previously initialized dataSource. */
        RUN dataAvailable IN TARGET-PROCEDURE ('RESET':U).
     END.
  END.

  RETURN.
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
  DEFINE VARIABLE iCalc            AS INTEGER   NO-UNDO.
  DEFINE VARIABLE cCalcCol         AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cCalculatedColumns AS CHARACTER NO-UNDO.
  
  {get BufferHandles cBuffers}.      /* Database buffer handles */
  
    /* This is the list of fields whose RowObject names are different from
     the database names. */
  {get AssignList cAssigns}.
  
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
      ASSIGN hBuffer  = WIDGET-HANDLE(ENTRY(iTable, cBuffers))
             rRowid = TO-ROWID(ENTRY(iTable, cRowIdent))
             lFound = hBuffer:FIND-BY-ROWID(rRowid).
      /* find-by-rowid will fire triggers when called from the transaction block,
         if the trigger returns ERROR find-by-rowid will return false
         A return-value will be returned to the user thru adm messaging */ 
      IF NOT lFound THEN 
        RETURN ERROR RETURN-VALUE.

      cExclude = {fnarg excludeColumns iTable}.
      IF INDEX(cAssigns, "[":U) = 0 THEN
        phRowObjUpd:BUFFER-COPY(hBuffer, cExclude /* exclude-list */,
          ENTRY(iTable, cAssigns, CHR(1))).  /* Get changed fld names if any */
      ELSE  /* If array elements are present, we must assign them manually. */
        RUN BufferCopyDBToRO(phRowObjUpd, hBuffer, cExclude,
          ENTRY(iTable, cAssigns, CHR(1))).
     
      /* If there are calculated fields, make sure they are updated */
      {get CalculatedColumns cCalculatedColumns}.
      IF cCalculatedColumns > '':U THEN
      DO:        
        {get RowObject hRowObject}.           /* Buffer handle for RowObject table */
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
      END.
    END.
    ELSE DO: 
      /* If the rowid is blank, blank the fields */
      {get DataColumnsByTable cColumns}.
      cColumns = ENTRY(iTable,cColumns,CHR(1)).
      
      DO iColumn = 1 TO NUM-ENTRIES(cColumns):
        ASSIGN
          hColumn = phRowObjUpd:BUFFER-FIELD(ENTRY(iColumn,cColumns))
          hColumn:BUFFER-VALUE = '':U.  /* This sets non-char fields to ? */
      END. /* do icolumn = 1 to num-entries */
    END.    
  END.    /* END DO iTable */
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
   DEFINE VARIABLE lHide            AS LOGICAL   NO-UNDO.
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
       {get HideOnInit lHide hFilterContainer}. 
     
       /* Workaround to make it visible if it's hideoninit */
       IF lHide THEN 
        RUN destroyObject in hFilterContainer.
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
  
  /* This is the list of fields whose RowObject names are different from
     the database names. */
  {get AssignList cAssigns}.
  
  /* If there is more than one table in the query, we build an exclude list 
     in order to guarantee that buffer-copy only copies fields from the 
     intentional source. Excluding all fieldnames from all other tables 
     prevents a potential overwrite from an unintentional table. */
  {get DataColumnsByTable cColumns}.
    
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
        ENTRY(iTable,cColumns,CHR(1)) = "":U
        cExclude = TRIM(REPLACE(cExclude,CHR(1),",":U),",":U). 
         */
      IF INDEX(cAssigns, "[":U) = 0 THEN
        hRowObject:BUFFER-COPY
                     (hBuffer,
                      cExclude,
                      ENTRY(iTable, cAssigns, CHR(1))).
      ELSE  /* If array elements are present, we must assign them manually. */
        RUN BufferCopyDBToRO
                   (hRowObject, 
                    hBuffer,
                    cExclude,
                    ENTRY(iTable, cAssigns, CHR(1))).
      pcRowIdent = pcRowIdent + STRING(hBuffer:ROWID).
    END.    /* END DO IF AVAILABLE */
    ELSE DO:
      /* If no record available blank the fields */
      {get DataColumnsByTable cColumns}.
      cColumns = ENTRY(iTable,cColumns,CHR(1)).
      
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
                This flag ensures that we only changes the batch property 
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
                  tot he number specified in piRowstoReturn.  
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
      MESSAGE "TransferRows does not support mode "
               + QUOTER(pcMode) + " when appending.".
      RETURN.
   END.   
 END.
 

 {get RowObject hRowObject}. 
 {get QueryHandle hQuery}.  
  
 hFirstBuffer = hQuery:GET-BUFFER-HANDLE(1).

 /* Historically there has been problems with the buffer being available 
    and not in synch with the query. This problem was in sendRows and may 
    not be present here, but serious testing is required to ensure this 
    including dataServers.  */
 hFirstBuffer:BUFFER-RELEASE().

 {get LastResultRow cLastResult}.
 {get FirstResultRow cFirstResult}.
 
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
     ASSIGN       
       lFromTop    = TRUE
       lRefresh    = TRUE
       cStartRow   = ENTRY(2,pcPosition,';':U)
       cToValue    = ENTRY(1,pcPosition,';':U)
       cToColumn   = "RowNum":U.

   WHEN 'Current':U THEN
     ASSIGN
       lFromTop       = TRUE
       lRefresh       = TRUE
       cStartRow      = IF cFirstResult = ? THEN ? 
                        ELSE ENTRY(2,cFirstResult,';':U)
       cToColumn      = "Rowident":U
       cToValue       = ENTRY(2,cLastResult,';':U)
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
           ASSIGN 
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
 pcValues     - The value(s) that corresponds to the pcColumns, separated
                by CHR(1).               
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

 {get QueryHandle hQuery}.
 {get RowObject hRowObject}.
 {get CalculatedColumns cCalculatedColumns}.
 {get EntityFields cEntityFields}.  
  /* maps RowObject names that are different from the database names. */
 {get AssignList cAssigns}.
 {set PositionForClient ?}.
 
 ASSIGN           /* Search for Rownum is a refresh..*/   
   hBuffer[1]      = hQuery:GET-BUFFER-HANDLE(1)
   cExclude[1]     = {fnarg excludeColumns 1}
   cAssignArray[1] = ENTRY(1, cAssigns, CHR(1))
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
 DO iBuffer = 2 TO hQuery:NUM-BUFFERS:
   ASSIGN
     cAssignArray[iBuffer] = ENTRY(iBuffer, cAssigns, CHR(1))
     hBuffer[iBuffer] = hQuery:GET-BUFFER-HANDLE(iBuffer)
     cExclude[iBuffer] = {fnarg excludeColumns iBuffer}
     cColumns[iBuffer] = ENTRY(iBuffer,cColumnsByTable, CHR(1)).
 END.
 {get DataReadHandler hReadhandler}.
 IF VALID-HANDLE(hReadHandler) THEN
 DO:
   {get DataReadColumns cReadColumns}.
   {get DataReadFormat cReadFormat}.
   {get DataReadBuffer hReadBuffer}.
   {get TransferChildrenForAll lChildrenForAll}.
   {get DataDelimiter cDelimiter}.
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
 {get LastResultRow cLastResult}.
 {get FirstResultRow cFirstResult}.
 
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
     iRowNum = MAX(0,IF cFirstResult = ? THEN {&ReposRowNum} 
                     ELSE INTEGER(ENTRY(1,cFirstResult,';':U))
                   - (piRowsToReturn + 1)).

   IF plAppend AND hBuffer[1]:AVAIL THEN
   DO:
     IF plFromTop THEN cLastResult = ?.     
     ELSE cFirstResult = ?.
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
       {set FirstRowNum ?}.
       {set LastRowNum ?}.
     END.
     ELSE DO:
       {set FirstRowNum 0}.
       {set LastRowNum 0}.
     END.
   END.
 END.
 /* WARNING: use extreme caution in this loop!
    Additional procedure, function calls or dyn handle refs is FORBIDDEN. 
    Ensure new processing does not decrease NUMBER of RECORDS PER SECOND*/
 {get SkipTransferDBRow lSkipApi}.
 DO WHILE hBuffer[1]:AVAILABLE 
   AND NOT lStop
   AND (iLoopCount < piRowsToReturn OR piRowsToReturn = 0):         
   hRowObject:BUFFER-CREATE().
   ASSIGN
     piRowsReturned = piRowsReturned + 1
     iLoopCount     = IF NOT lAppendSearch THEN iLoopCount + 1
                      ELSE 0 /* start on one when appendsearch is off */
     iRowNum        = iRowNum + 1.   
   IF lSkipAPi THEN
   DO:
     /* testing indicates that it is more efficient to check cRowident 
        below in one place */  
     IF INDEX(cAssignArray[1],'[':U) = 0 THEN
        hRowObject:BUFFER-COPY(hBuffer[1],cExclude[1],cAssignArray[1]).
     ELSE
        RUN BufferCopyDBToRO (hRowObject, 
                              hBuffer[1],
                              cExclude[1],
                              cAssignArray[1]).  
     cRowident = STRING(hBuffer[1]:ROWID).
     DO iBuffer = 2 TO hQuery:NUM-BUFFERS:     
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
   IF cToRowident = cRowident THEN
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
         LEAVE.
       END.
       ELSE IF pcPosition = 'AFTER':U THEN
         ASSIGN
          iRowPos = iRowNum + 1
          iLoopCount = piRowsToReturn - 1.
       ELSE DO:
         rRowId = hRowObject:ROWID.
         LEAVE.
       END.
     END.
     ELSE IF pcPosition = 'BEFORE':U THEN
       iRowPos = iRowNum - 1.
     ELSE IF pcPosition = 'AFTER':U THEN
       ASSIGN
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
          ({fn getObjectName},
           hReadBuffer).
     END.
     ELSE DO:
       RUN receivedata IN hReadHandler 
           ({fn getObjectName},
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
       {set FirstResultRow cNewFirstResult}.     
       {set FirstRowNum iRowNum}.
     END.
     /* Otherwise set the Firstbatch unless we are appending forward
       (cFirstResult is set to unkwown above if not appendong or backward) */ 
     ELSE IF cFirstResult = ? THEN
       {set FirstResultRow cNewFirstResult}.     
   END.
  
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
     {set LastResultRow cNewLastResult}. 
     {set LastRowNum iRowNum}.
     hQuery:GET-PREV. /* get back to the last ( probably not needed ...)  */
   END.
   /* else check if we are at the end unless we are appending data to the 
      beginning of existing data (cLastRow is set above depending on old
      value) */
   ELSE DO: 
     /*  set lastResultRoe unless we are appending data to the beginning of 
         existing data (cLastRow is set above depending on old value) */
     IF cLastResult = ? THEN 
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
   END. /* lastrowNum ? (try to find last) */
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
     {get AsDivision cAsDivision}.
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
  DO:
    {get QueryWhere cQueryString}.    
     /* If no current Query find the defined base query */ 
     IF cQueryString = "":U OR cQueryString = ? THEN
       {get OpenQuery cQueryString}.       
  END. /* cQueryString = "":U */
  
  cQueryString = DYNAMIC-FUNCTION ('newQueryValidate':U IN TARGET-PROCEDURE,
                                   cQueryString,pcWhere,pcBuffer,pcAndOr).
 
  IF cQueryString <> ? THEN
    {set QueryString cQueryString}.

  RETURN cQueryString <> ?.
   
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
   Notes:   This procedure is designed to run on the client and to be 
            called several times to build up the the query's where clause 
            (storing intermediate results in the QueryString property) before 
            it is finally used in a Query-Prepare method. 
            openQuery takes care of the preparation of the QueryString property.
            The QueryColumns property is used to ensure that each column and 
            operator only will be added once to the QueryString. The property is 
            also used to store the offset and length of the corresponding values.
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cQueryString   AS CHARACTER NO-UNDO.
    
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
  DEFINE VARIABLE cDataType      AS CHAR      NO-UNDO.
  DEFINE VARIABLE cQuote         AS CHAR      NO-UNDO.    
  DEFINE VARIABLE cValue         AS CHAR      NO-UNDO.  
  DEFINE VARIABLE cOperator      AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cStringOp      AS CHARACTER NO-UNDO.
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
  DEFINE VARIABLE cBufferDiffs   AS CHAR      NO-UNDO.
  DEFINE VARIABLE iBufPos        AS INTEGER   NO-UNDO.
  DEFINE VARIABLE iColPos        AS INTEGER   NO-UNDO.
  DEFINE VARIABLE iWhereBufPos   AS INTEGER   NO-UNDO.
          
  {get Tables cBufferList}.    
   
  /* The QueryString contains data if the query is being currently worked on 
     by this method or addQuerywhere over many calls. */
  {get QueryString cQueryString}.      
  /* If no QueryString find the current query */ 
  IF cQueryString = "":U OR cQueryString = ? THEN
  DO:
    {get QueryWhere cQueryString}.    
     /* If no current Query find the defined base query */ 
     IF cQueryString = "":U OR cQueryString = ? THEN
       {get OpenQuery cQueryString}.       
  END. /* cQueryString = "":U */
  IF cQueryString = "":U OR cQueryString = ? THEN
    RETURN FALSE.

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
    cAndOr       = "AND":U /* We only support and */
    cBufferDiffs = LEFT-TRIM(FILL(",0",NUM-ENTRIES(cBufferList)),","). 
  
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
        
      cColumn     = ENTRY(iColumn,pcColumns).
      
      /* Convert rowObject reference to db reference */
      IF cColumn BEGINS "RowObject" + "." THEN        
        cColumn =  DYNAMIC-FUNCTION("columnDBColumn":U IN TARGET-PROCEDURE,
                                    ENTRY(2,cColumn,".":U)) NO-ERROR.                                      
      
      /* Unqualified fields will use the first buffer that has a match
         because the columnDataType below searches all buffers in the query */           
      ELSE IF INDEX(cColumn,".":U) = 0 THEN       
        cColumn = cBuffer + ".":U + cColumn.
      
      /* Wrong buffer? */
      IF NOT (cColumn BEGINS cBuffer + ".":U) THEN 
      DO: 
        /* If the column db qualification does not match the query's we do 
           an additionl check to see if it is the correct table after all */                                
        IF NUM-ENTRIES(cColumn,".":U) - 1 <> NUM-ENTRIES(cBuffer,".":U) THEN
        DO:
          IF {fnarg columnTable cColumn} <> cBuffer THEN 
            NEXT ColumnLoop.  
        END.
        ELSE
          NEXT ColumnLoop.
      END.

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
        cColumnName = ENTRY(NUM-ENTRIES(cColumn,".":U),cColumn,".":U)              
        cDataType   = {fnarg columnDataType cColumn}.

      IF cDataType <> ? THEN
      DO:
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
         
          /* We are quoting ALL values to ensures that decimals behave 
             in both american and european format. 
             This works also with ? as the dynamic query handles quoted unknown 
             values as unknown for all data-types except character of course */ 
          cQuote     = (IF cDataType = "CHARACTER":U AND cValue = "?" 
                        THEN "":U 
                        ELSE "'":U)   

          cUsedNums  = cUsedNums
                      + (IF cUsedNums = "":U THEN "":U ELSE ",":U)
                      + STRING(iColumn) 
          
          /* The Column and operator are unique entries so we must mak sure that  
             that blank or different styles doesn't get misinterpreted  */
          cQueryColOp = cOperator
          cQueryColOp = cStringOp WHEN cDataType = "CHARACTER"            
          cQueryColOp = TRIM(     IF cQueryColOp = "GE":U THEN ">=":U
                             ELSE IF cQueryColOp = "LE":U THEN "<=":U
                             ELSE IF cQueryColOp = "LT":U THEN "<":U
                             ELSE IF cQueryColOp = "GT":U THEN ">":U
                             ELSE IF cQueryColOp = "EQ":U THEN "=":U
                             ELSE    cQueryColOp)
                        
          /* Have the column and operator been added to the querystring
             (by this function) */  
          iPos        = LOOKUP(cColumnName + ".":U + cQueryColOp,cQueryBufCols)
          
        /* From 9.1B the quotes are included in the value to avoid problems
           when replacing unquoted ? to a quoted value */ 
          cValue      = cQuote + cValue + cQuote.
      
        /* If the column + operator was found in the list
           we build a list of the new values to use when we insert the data
           into the QueryString further down.
           We also build a list of the changed numbers, to check if any change 
           has occured. (The list of new values cannot be checked because any 
           data may be new data and we don't know the old value) */         
        IF iPos > 0 THEN
        DO:        
          ASSIGN
            ENTRY(INT((iPos - 1) / 3 + 1),cChangedValues,CHR(1)) = cValue    
            iLowestChanged = MIN(iPos,IF iLowestChanged = 0 
                                      THEN iPos 
                                      ELSE iLowestChanged)
            cChangedList  = cChangedList 
                          + (IF cChangedList = "":U THEN "":U ELSE ",":U)
                          + STRING(INT((iPos - 1) / 3 + 1)).     
        END. /* IF ipos > 0 */   
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
                      + (IF cDataType = "CHARACTER":U  
                         THEN cStringOp
                         ELSE cOperator)
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
      END. /* if cDatatype <> ? */          
    END. /* do iColumn = 1 to num-entries(pColumns) */  
    
    /* Get the buffers position in the where clause (always the
       first entry in a dynamic query because there's no 'of <external>')*/ 
    ASSIGN
      iWhereBufPos = INDEX(cQueryString + " "," ":U + cBuffer + " ":U)
      iPos         = INDEX(cQueryString,      " ":U + cBuffer + ",":U)
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
         cQueryColumns = cQueryColumns 
                         + (IF cQueryColumns = "":U THEN "":U ELSE ":":U)
                         + cBuffer + ":" + cQueryBufCols.
      
      ELSE /* There is already a entry for this buffer */
        ENTRY(iBufPos + 1,cQueryColumns,":":U) = cQueryBufCols.        
    END. /* cQueryBufCols <> '' */

  END. /* do iBuffer = 1 to hQuery:num-buffers */
  
  {set QueryColumns cQueryColumns}.
  {set QueryString cQueryString}.
  
  RETURN TRUE. 

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
    Notes:    The primary purpose of this procedure is to detect when 
              individual array fields are referenced in the assign-list 
              (pcAssigns) from the database buffer and the ensure that they
              are compared properly.  
------------------------------------------------------------------------------*/
DEFINE VARIABLE cTemp    AS CHARACTER NO-UNDO.
DEFINE VARIABLE hField   AS HANDLE    NO-UNDO.
DEFINE VARIABLE hField2  AS HANDLE    NO-UNDO.
DEFINE VARIABLE iCtr     AS INTEGER   NO-UNDO.
DEFINE VARIABLE iExt     AS INTEGER   NO-UNDO.
DEFINE VARIABLE iPos     AS INTEGER   NO-UNDO.
DEFINE VARIABLE lSame    AS LOGICAL   NO-UNDO.

  IF INDEX(pcAssigns, "[":U) NE 0 THEN
  DO:
    lSame = phBuffer:BUFFER-COMPARE(phRowObjUpd,
                                    'case-sensitive':U,
                                    pcExcludes).
    IF lSame THEN DO:
      CompareAssigns:
      DO iCtr = 2 TO NUM-ENTRIES(pcAssigns) BY 2:
        ASSIGN cTemp = ENTRY(iCtr, pcAssigns)
               iPos  = INDEX(cTemp, "[":U).
        IF iPos > 0 THEN
            ASSIGN iExt = INTEGER(ENTRY(1, SUBSTR(cTemp, iPos + 1), "]":U))
                   cTemp = SUBSTR(cTemp, 1, iPos - 1).
        ELSE ASSIGN iExt = 0.
        ASSIGN hField = phRowObjUpd:BUFFER-FIELD(ENTRY(iCtr - 1, pcAssigns))
               hField2 = phBuffer:BUFFER-FIELD(cTemp).
        lSame = hField:BUFFER-VALUE = hField2:BUFFER-VALUE(iExt).
        IF NOT lSame THEN LEAVE CompareAssigns.
      END.  /* Do iCtl to Num-Entries(pcAssigns) */
    END.  /* If lSame */
  END.  /* If array fields are present */
  ELSE lSame = phBuffer:BUFFER-COMPARE(phRowObjUpd, 
                                       'case-sensitive':U,
                                       pcExcludes, 
                                       pcAssigns).

  RETURN lSame.   /* Function return value. */

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
                              1. QueryString, 2 QueryWhere 3 OpenQuery.    
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

 /* If unkown value is passed used the existing query string */
 IF pcWhere = ? THEN
 DO:
   /* The QueryString contains data if the query is being currently worked on 
      by this method or addQuerywhere over many calls. */
   {get QueryString pcWhere}.      
   /* If no QueryString find the current query */ 
   IF pcWhere = "":U OR pcWhere = ? THEN
   DO:
     {get QueryWhere pcWhere}.    
      /* If no current Query find the defined base query */ 
     IF pcWhere = "":U OR pcWhere = ? THEN
        {get OpenQuery pcWhere}.       
    END. /* cQueryString = "":U */
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
     
     IF {fnarg whereClauseBuffer cFoundWhere} = pcBuffer THEN
       RETURN cFoundWhere.
     
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
   DEFINE VARIABLE cName               AS CHARACTER NO-UNDO.
   DEFINE VARIABLE cAssignList         AS CHARACTER NO-UNDO.
   DEFINE VARIABLE cDataColumnsByTable AS CHARACTER NO-UNDO.
   DEFINE VARIABLE cTables             AS CHARACTER NO-UNDO.
   DEFINE VARIABLE iTable              AS INTEGER   NO-UNDO.
  
   IF pcColumn BEGINS "RowObject.":U THEN
     pcColumn = ENTRY(2,pcColumn,".":U). 

   {get Tables cTables}.   /* List of database tables in the object */
   
   /* If the RowObject name is different from dbname it's in the assign-list,
      which is in the form RowObjectfield,DBField[,...]CHR(1)... --
      with each CHR(1)-delimited group corresponding to a Table. */  
   {get AssignList cAssignList}.

   /* comma-separated list of Rowobject columns delimited by CHR(1)
      corresponding to a Table.*/  
   {get DataColumnsByTable cDataColumnsByTable}.
  
   DO iTable = 1 TO NUM-ENTRIES(cTables):
     
     /* If the RowObject name is different from dbname it's in the assignList*/
     cName = DYNAMIC-FUNCTION('mappedEntry':U IN TARGET-PROCEDURE, 
                    pcColumn,
                    ENTRY(iTable, cAssignList, CHR(1)), /*Flds for one table */
                    TRUE, /* lookup first of pair return second */
                    ",":U /* delimiter */ ).  
     IF cName NE ? THEN
       RETURN ENTRY(iTable, cTables) /* [db.]tablename */
              + ".":U
              + cName.               /* database field name */
     /* Is the column in this table's part of DataColumnsByTable? */
     ELSE IF CAN-DO(ENTRY(iTable, cDataColumnsByTable, CHR(1)),pcColumn) THEN
       RETURN ENTRY(iTable, cTables)  /* [db.]tablename */
              + ".":U
              + pcColumn.             /* field name is column name */
   END.     /* END DO iTable... */
   
   RETURN "":U.    
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
  
  {get QueryString cQueryString}.  
  {get QueryColumns cQueryColumns}.
  
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
  Purpose:     Returns [dbname.]table of a database column.  
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

&IF DEFINED(EXCLUDE-dbColumnDataName) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION dbColumnDataName Procedure 
FUNCTION dbColumnDataName RETURNS CHARACTER
  (pcDbColumn AS CHAR):
/*------------------------------------------------------------------------------
  Purpose:   Returns the RowObject fieldname of a database fieldname  
  Parameter: pcDbColumn - Qualified database fieldname (In the form of either
                          DB.TBL.FLDNM or TBL.FLDNM or FLDNM.)
  Notes:     Returns '' if not mapped to a RowObject
------------------------------------------------------------------------------*/
   DEFINE VARIABLE cName               AS CHARACTER NO-UNDO.
   DEFINE VARIABLE cAssignList         AS CHARACTER NO-UNDO.
   DEFINE VARIABLE cDataColumnsByTable AS CHARACTER NO-UNDO.
   DEFINE VARIABLE cAssign             AS CHARACTER NO-UNDO.
   DEFINE VARIABLE cTables             AS CHARACTER NO-UNDO.
   DEFINE VARIABLE cTable              AS CHARACTER NO-UNDO.
   DEFINE VARIABLE iTable              AS INTEGER   NO-UNDO.
   DEFINE VARIABLE cColumn             AS CHARACTER NO-UNDO.
   
   {get Tables cTables}.
   
   /* comma-separated list of Rowobject columns delimited by CHR(1)
        corresponding to a Table.*/    
   {get DataColumnsByTable cDataColumnsByTable}.
   {get AssignList cAssignList}.
   
   IF NUM-ENTRIES(pcDbColumn, ".":U) = 1 THEN
   DO:
     /* No Table qualifier so search all entries in AssignList. */
     DO iTable = 1 TO NUM-ENTRIES(cTables):
       ASSIGN
         cAssign = ENTRY(iTable, cAssignList, CHR(1)) /* Flds for 1 table */
         /* Check first to see if this column is in the Assign List, meaning 
            that it has been given a new name in the RowObject table. */
         cName   = DYNAMIC-FUNCTION('mappedEntry':U IN TARGET-PROCEDURE, 
                                    pcDbColumn, 
                                    cAssign, 
                                    FALSE, /* lookup second return first */
                                    ",":U /* delimiter */ ).
       
       IF cName NE ? THEN
         RETURN cName.
       
       /* If the column is in this table's part of DataColumnsByTable,
          and it isn't a RowObject column that is mapped to another dbfield
          the RowObject column name is the same as the database field name. */
       ELSE 
       IF CAN-DO(ENTRY(iTable, cDataColumnsByTable, CHR(1)),pcDbColumn)
       AND DYNAMIC-FUNCTION('mappedEntry':U IN TARGET-PROCEDURE,
                            pcDbColumn, 
                            cAssign, 
                            TRUE,
                            ",":U) = ? THEN
         RETURN pcDbColumn.

     END.  /* END DO iTable */ 
   END.    /* END DO IF NUM-ENTRIES = 1 */
   ELSE DO:
     ASSIGN       
       cTable = SUBSTR(pcDbColumn,1,R-INDEX(pcDbcolumn,".") - 1)
       cTable = {fnarg resolveBuffer cTable} /* ensure correct qualification*/
       iTable  = LOOKUP(cTable, cTables). /* Get the entry in AssignList */
     
     IF iTable NE 0 THEN                    /* sanity check */
     DO:    
       ASSIGN
         cColumn = ENTRY(NUM-ENTRIES(pcDbColumn, ".":U), pcDbColumn, ".":U)
         cName = DYNAMIC-FUNCTION('mappedEntry':U IN TARGET-PROCEDURE,
                    cColumn,
                    ENTRY(iTable, cAssignList, CHR(1)),  /* Flds for 1 table */
                    FALSE, /* lookup second entry of pair */
                    ",":U).  
       
       IF cName <> ? THEN
         RETURN cName. 
       ELSE
       IF CAN-DO(ENTRY(iTable, cDataColumnsByTable, CHR(1)),cColumn) THEN
         RETURN cColumn.

     END.  /* END DO IF itable NE 0 */
   END. /* else (pcDbColumn is qualified)  */

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
    
  DO i = 1 TO hQuery:NUM-BUFFERS:
    hBuffer = hQuery:GET-BUFFER-HANDLE(i). 
     
    IF cBuffer <> ? AND hBuffer:NAME   <> cBuffer THEN NEXT.    
    IF cDbName <> ? AND hBuffer:DBNAME <> cDbName THEN NEXT.  
    
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
  DEFINE VARIABLE iNumEntry                     AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cColumnName                   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFieldName                    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cTableName                    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cAssignName                   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lUpdatable                    AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cUpdatable                    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iCounter                      AS INTEGER    NO-UNDO.
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
  IF ( NUM-ENTRIES(pcTableList, ",":U) > 0 ) THEN
  DO:
    cTableName = ENTRY(1, pcTableList, ",":U) NO-ERROR.
    IF (NUM-ENTRIES(cTableName, ".":U) > 1 )THEN
      lDatabaseQualifiedTableNames = YES.
    ELSE
      lDatabaseQualifiedTableNames = NO.
  END.
  IF (lDatabaseQualifiedTableNames) THEN
    iCounter = 1.
  ELSE
    iCounter = 0.

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

    cTableName = ENTRY((iCounter + 1), cColumnName, ".":U) NO-ERROR.
    cFieldName = ENTRY((iCounter + 2), cColumnName, ".":U) NO-ERROR.
    IF (ERROR-STATUS:ERROR) THEN
      RETURN FALSE.

    cAssignName = ENTRY((iCounter + 3), cColumnName, ".":U) NO-ERROR.
    ERROR-STATUS:ERROR = NO.

    IF cAssignName > '' THEN
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
    iArrayPos = LOOKUP(cTableName, pcTableList, ",":U).
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

  DO iNumEntry = 1 TO NUM-ENTRIES(pcTableList, ",":U):
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
        
  DYNAMIC-FUNCTION("setTables":U IN TARGET-PROCEDURE, 
                              pcTableList).
  DYNAMIC-FUNCTION("setDataColumns":U IN TARGET-PROCEDURE, 
                              cDataColumns ).
  DYNAMIC-FUNCTION("setDataColumnsByTable":U IN TARGET-PROCEDURE, 
                             cDataColumnsByTable).

  /* currently derived from - bytable
  DYNAMIC-FUNCTION("setUpdatableColumns":U IN TARGET-PROCEDURE, 
                             cUpdatableDataColumns). 
  */

  DYNAMIC-FUNCTION("setUpdatableColumnsByTable":U IN TARGET-PROCEDURE, 
                              cUpdatableDataColumnsByTable).
  DYNAMIC-FUNCTION("setAssignList":U IN TARGET-PROCEDURE, 
                             cAssignColumnsByTable).
  DYNAMIC-FUNCTION("setBaseQuery" IN TARGET-PROCEDURE, 
                             pcBaseQuery).

  RETURN (DYNAMIC-FUNCTION("getTables" IN TARGET-PROCEDURE) > '':U).   /* Function return value. */

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
           that we are copying comparing to from the chr(1) separated 
           DataColumnsByTable. 
           DataColumnsByTable stores calculated fields in the last entry, 
           so we always exclude those.  
           Used by refetchDbRow, transferDbRow and compareDbRow 
-----------------------------------------------------------------------------*/
  DEFINE VARIABLE cExclude AS CHAR   NO-UNDO.
    
  {get DataColumnsByTable cExclude}.
    
  /* Remove the columns from the iTable table from the excludelist */
  ENTRY(iTable,cExclude,CHR(1)) = "":U.
     
  RETURN TRIM(REPLACE(cExclude,CHR(1),",":U),",":U).      

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
 DEFINE VARIABLE iNumeric    AS INTEGER    NO-UNDO.

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
   
   IF NUM-ENTRIES(cWord,".":U) >= 2 THEN 
   DO:
     /* This '.' might be a decimal delimiter or decimal sign, 
        if the first entry is integer it cannot be a buffer name ... */
     iNumeric = INT(ENTRY(1,cWord)) NO-ERROR.
     IF NOT ERROR-STATUS:ERROR THEN
       NEXT.
   END.

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

  pcQueryString = {fnarg fixQueryString pcQueryString}.
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

&IF DEFINED(EXCLUDE-indexInformation) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION indexInformation Procedure 
FUNCTION indexInformation RETURNS CHARACTER
   (pcQuery       AS CHAR,
    plUseTableSep AS LOG,
    pcIndexInfo   AS CHAR):
/*------------------------------------------------------------------------------
   Purpose: Return index Information for all buffers in the query.
            Each index is separated with chr(1).
            Field information is either qualifed with db and table 
            or the chr(2) is used as table separator.
            
Parameters: pcQuery - What information? 
                - 'All'             All indexed fields 
                - 'Standard' or ''  All indexed fields excluding word indexes    
                - 'Word'            Word Indexed 
                - 'Unique'          Unique indexes 
                - 'NonUnique'       Non Unique indexes 
                - 'Primary'         Primary index
                - 'Info'            All info (meaningless if pcIndexInfo <> ?)               
           
           plUseTableSep - Use table separator.  
           
                - Yes   Use table separator 
                - No    Don't use table separator 
                       (if pcIndexinfo = ? fieldnames will be qualifed
                        otherwise they will remain as in pcInddexInfo)
          
          pcIndexInfo - Query or previously retrieved info. Enables the 
                         function to be used with no database connection.    
                - ? use query - if plUseTableSep = yes the field will be 
                                returned qualified.     
                -  Index info in EXACT SAME FORMAT as returned from this 
                   function earlier with indexInformation('info',yes,?).
                   
                   See Notes below for delimiters. 
     Notes: Returned delimiters
            - qualifed      - semicolon is index separator 
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
  DEFINE VARIABLE iNumBuffers  AS INT    NO-UNDO.
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
    cIdxDlm     = CHR(1)
    iNumBuffers = IF VALID-HANDLE(hQuery)
                  THEN hQuery:NUM-BUFFERS
                  ELSE NUM-ENTRIES(pcIndexInfo,cTblDlm).

  /* If no table separator find qualifier rule */   
  IF NOT plUseTableSep THEN
     {get UseDBQualifier lUseDBQual}.
 
  DO iBuff = 1 TO iNumBuffers:
    
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
         LEAVE IndexBlock. /* No trick .. this is DEFAULT 
                             Explicit for the Progress illiterate */
      
      CASE pcQuery:
        WHEN 'Standard':U OR WHEN '':U THEN
          lFound = ENTRY(4,cIndexInfo) = "0":U.
          
        WHEN "Info":U OR WHEN "All" THEN
          lFound = TRUE.
          
        WHEN "Word":U THEN
          lFound = ENTRY(4,cIndexInfo) = "1":U.
          
        WHEN "Unique":U THEN
          lFound = ENTRY(3,cIndexInfo) = "1":U.
          
        WHEN "NonUnique":U THEN
          lFound = ENTRY(3,cIndexInfo) = "0":U AND 
                   ENTRY(4,cIndexInfo) = "0":U.
          
        WHEN "Primary" THEN
          lFound = ENTRY(2,cIndexInfo) = "1":U.
          
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
    IF plUseTableSep AND iBuff LT iNumBuffers THEN 
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
           
  ASSIGN 
    cTable        = {fnarg whereClauseBuffer pcWhere}
    iTblPos       = INDEX(pcWhere,cTable) + LENGTH(cTable,"CHARACTER":U)
    
    iWherePos     = INDEX(pcWhere," WHERE ":U) + 6    
    iByPos        = INDEX(pcWhere," BY ":U)    
    iUseIdxPos    = INDEX(pcWhere," USE-INDEX ":U)    
    iIdxRePos     = INDEX(pcWhere + " ":U," INDEXED-REPOSITION ":U)    
    iOuterPos     = INDEX(pcWhere + " ":U," OUTER-JOIN ":U)     
    iLockPos      = MAX(INDEX(pcWhere + " ":U," NO-LOCK ":U),
                        INDEX(pcWhere + " ":U," SHARE-LOCK ":U),
                        INDEX(pcWhere + " ":U," EXCLUSIVE-LOCK ":U),
                        INDEX(pcWhere + " ":U," SHARE ":U),
                        INDEX(pcWhere + " ":U," EXCLUSIVE ":U)
                        )    
    iInsertPos    = LENGTH(pcWhere) + 1 
                    /* We must insert before the leftmoust keyword,
                       unless the keyword is Before the WHERE keyword */ 
    iInsertPos    = MIN(
                      (IF iLockPos   > iWherePos THEN iLockPos   ELSE iInsertPos),
                      (IF iOuterPos  > iWherePos THEN iOuterPos  ELSE iInsertPos),
                      (IF iUseIdxPos > iWherePos THEN iUseIdxPos ELSE iInsertPos),
                      (IF iIdxRePos  > iWherePos THEN iIdxRePos  ELSE iInsertPos),
                      (IF iByPos     > iWherePos THEN iByPos     ELSE iInsertPos)
                       )                                                        
    lWhere        = INDEX(pcWhere," WHERE ":U) > 0 
    cWhereOrAnd   = (IF NOT lWhere          THEN " WHERE ":U 
                     ELSE IF pcAndOr = "":U OR pcAndOr = ? THEN " AND ":U 
                     ELSE " ":U + pcAndOr + " ":U) 
    iOfPos        = INDEX(pcWhere," OF ":U).
  
  IF LEFT-TRIM(pcExpression) BEGINS "OF ":U THEN 
  DO:   
    /* If there is an OF in both the join and existing query we replace the 
       table unless they are the same */      
    IF iOfPos > 0 THEN 
    DO:
      ASSIGN
        /* Find the table in the old join */               
        cRelTable  = ENTRY(1,LEFT-TRIM(SUBSTRING(pcWhere,iOfPos + 4))," ":U)      
        /* Find the table in the new join */       
        cJoinTable = SUBSTRING(LEFT-TRIM(pcExpression),3).
      
      IF cJoinTable <> cRelTable THEN
        ASSIGN 
         iRelTblPos = INDEX(pcWhere + " ":U," ":U + cRelTable + " ":U) 
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
     pcColumns   - Column names (Comma separated)                    
                   Fieldname of a table in the query in the form of 
                   TBL.FLDNM or DB.TBL.FLDNM),
                   (RowObject.FLDNM should be used for SDO's)  
                   If the fieldname isn't qualified it checks the tables in 
                   the TABLES property and assumes the first with a match.
                   
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
           without the replace functionality ... 
           (It should not have been duplicated, but... )     
------------------------------------------------------------------------------*/
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
  DEFINE VARIABLE cDataType      AS CHAR      NO-UNDO.
  DEFINE VARIABLE cQuote         AS CHAR      NO-UNDO.    
  DEFINE VARIABLE cValue         AS CHAR      NO-UNDO.  
  DEFINE VARIABLE cOperator      AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cStringOp      AS CHARACTER NO-UNDO.
                    
  {get Tables cBufferList}.    
   
  /* If unkown value is passed used the existing query string */
  IF pcQueryString = ? THEN
  DO:
    /* The QueryString contains data if the query is being currently worked on 
       by this method or addQuerywhere over many calls. */
    {get QueryString pcQueryString}.      
    /* If no QueryString find the current query */ 
    IF pcQueryString = "":U OR pcQueryString = ? THEN
    DO:
      {get QueryWhere pcQueryString}.    
      /* If no current Query find the defined base query */ 
       IF pcQueryString = "":U OR pcQueryString = ? THEN
         {get OpenQuery pcQueryString}.       
    END. /* cQueryString = "":U */
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
        
      cColumn     = ENTRY(iColumn,pcColumns).
      
      /* Convert rowObject reference to db reference */
      IF cColumn BEGINS "RowObject" + "." THEN        
        cColumn =  DYNAMIC-FUNCTION("columnDBColumn":U IN TARGET-PROCEDURE,
                                    ENTRY(2,cColumn,".":U)) NO-ERROR.                                      
      
      /* Unqualified fields will use the first buffer that has a match
         because the columnDataType below searches all buffers in the query */           
      ELSE IF INDEX(cColumn,".":U) = 0 THEN       
        cColumn = cBuffer + ".":U + cColumn.
      
      /* Wrong buffer? */
      IF NOT (cColumn BEGINS cBuffer + ".":U) THEN 
      DO: 
        /* If the column db qualification does not match the query's we do 
           an additionl check to see if it is the correct table after all */                                
        IF NUM-ENTRIES(cColumn,".":U) - 1 <> NUM-ENTRIES(cBuffer,".":U) THEN
        DO:
          IF {fnarg columnTable cColumn} <> cBuffer THEN 
            NEXT ColumnLoop.  
        END.
        ELSE
          NEXT ColumnLoop.
      END.

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
        cColumnName = ENTRY(NUM-ENTRIES(cColumn,".":U),cColumn,".":U)              
        cDataType   = {fnarg columnDataType cColumn}.

      IF cDataType <> ? THEN
      DO:
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
          cBufWhere  = cBufWhere 
                       + (If cBufWhere = "":U 
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
                       + cQuote
          cUsedNums  = cUsedNums
                       + (IF cUsedNums = "":U THEN "":U ELSE ",":U)
                       + STRING(iColumn).

      END. /* if cDatatype <> ? */          
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
    {set QueryString cBlank}.  
    {set QueryColumns cBlank}.
  END.

  RETURN cQuery.   /* Function return value. */

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
 
  /* fix European decimal format issues with in query string */
 pcWhere = {fnarg fixQueryString pcWhere}.
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

  {get QueryHandle hQuery}.
  hQuery:QUERY-CLOSE().

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
        This Property will be checked against the current records Rowident
        in fetch* procedures in order to set the QueryPosition correctly. 
        This was origianlly done to guarantee that 'LastRecord' always was
        correct. T
        the SECOND time its been read */
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
  DEFINE VARIABLE hQuery AS HANDLE NO-UNDO.         
  
  {get QueryHandle hQuery}.   
  IF pcQuery = '':U OR pcQuery = ? THEN
    {get OpenQuery pcQuery}.
 
  /* Fix European decimal format issues with in query string */
  pcQuery = {fnarg fixQueryString pcQuery}.
  RETURN hQuery:QUERY-PREPARE(pcQuery).

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
            The first Rowid is of course NEVER refreshed.  
             
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
 IF NUM-ENTRIES(cColumns,CHR(1)) = 1 THEN 
   RETURN pcRowIdent.
 
 {get Tables cTables}.
 /* Search from the last table to find the upper table of ONLY read only tables 
   (readonly table that are BEFORE updatable tables CANNOT be refreshed)
    excluding the first table in the join */ 
 
 DO iTable = NUM-ENTRIES(cTables) TO 2 BY -1:
   IF ENTRY(iTable,cColumns,CHR(1)) <> '':U THEN
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

  {get ForeignValues cForeignValues}.    
  {get ForeignFields cForeignFields}.
  
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
                   Fieldname of a table in the query in the form of 
                   TBL.FLDNM or DB.TBL.FLDNM (only if qualified with db is specified),
                   (RowObject.FLDNM should be used for SDO's)  
                   If the fieldname isn't qualified it checks the tables in 
                   the TABLES property and assumes the first with a match.              
     pcOperators - Operator - one for all columns
                              - blank - defaults to (EQ)  
                              - Use slash to define alternative string operator
                                EQ/BEGINS etc..
                            - comma separated for each column/value

  Notes:       This procedure modifies the QueryString property and is designed 
               to run on the client and called several times before QueryString
               is used in a QUERY-PREPARE method to modify the database query.
               
               openQuery will prepare the query using the QueryString property.
               
               The removal of the actual field expression is done by the help 
               of the position and length stored in the QueryColumns property. 
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cQueryString   AS CHARACTER NO-UNDO.
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

  {get Tables cBufferList}.    
  {get QueryString cQueryString}.
  {get QueryColumns cQueryColumns}.
    
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
        
         
      /* Convert rowObject reference to db reference */
      IF cColumn BEGINS "RowObject" + "." THEN        
        cColumn =  DYNAMIC-FUNCTION("columnDBColumn":U IN TARGET-PROCEDURE,
                                    ENTRY(2,cColumn,".":U)) NO-ERROR.                                      
      
      /* Unqualified fields will use the first buffer that has a match
         because the columnDataType below searches all buffers in the query */           
      ELSE IF INDEX(cColumn,".":U) = 0 THEN       
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

      cColumnName = ENTRY(NUM-ENTRIES(cColumn,".":U),cColumn,".":U).
      
        
      cQueryColOp = cOperator.
      
      cQueryColOp = TRIM(     IF cQueryColOp = "GE":U THEN ">=":U
                             ELSE IF cQueryColOp = "LE":U THEN "<=":U
                             ELSE IF cQueryColOp = "LT":U THEN "<":U
                             ELSE IF cQueryColOp = "GT":U THEN ">":U
                             ELSE IF cQueryColOp = "EQ":U THEN "=":U
                             ELSE    cQueryColOp).
      
      cStringOp   = IF NUM-ENTRIES(pcOperators) = 1 
                    AND NUM-ENTRIES(pcOperators,"/":U) = 2  
                    THEN ENTRY(2,pcOperators,"/":U)
                    ELSE "":U.                                                 
      
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
                            + STRING(iColumn). 
     
      END. /* IF ipos > 0 */           
    END. /* do icolumn = 1 to  */ 
    
    /* Get the buffers position in the where clause (always the
       first entry in a dynamic query because there's no 'of <external>')*/ 
    ASSIGN
      iWhereBufPos = INDEX(cQueryString + " "," ":U + cBuffer + " ":U)
      iPos         = INDEX(cQueryString,      " ":U + cBuffer + ",":U)
      iWhereBufPos = (IF iWhereBufPos > 0 AND iPos > 0
                      THEN MIN(iPos,iWhereBufPos) 
                      ELSE MAX(iPos,iWhereBufPos))
                      + 1
      iDiff        = 0
      cNewCols     = "":U.                          

    IF iLowestChanged > 0 THEN 
    DO iColumn = 1 TO NUM-ENTRIES(cQueryBufCols) - 2 BY 3:       
      
      ASSIGN
        iValPos      = INT(ENTRY(iColumn + 1,cQueryBufCols))
        iValLength   = INT(ENTRY(iColumn + 2,cQueryBufCols))
        iValPos      = iValPos - iDiff.
      
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
          cWord       = ENTRY(iNumWords - 1,cQuerySplit1," ":U).
             
         /* if columnname has parenthesis this is the beginning of an exp */
         IF cWord BEGINS "(":U THEN
         DO:
           /* We are removing the first column/value pair in the parenthesis*/
           IF cQuerySplit2 BEGINS "AND":U THEN
           DO:
             /* Remove the previous word (columnname), but keep parenthesis */
             ENTRY(iNumWords - 1,cQuerySplit1," ":U) = "(":U.
             
             /* Remove AND in right part */
             ENTRY(1,cQuerySplit2," ":U) = "":U.
             cQuerySplit2 = LEFT-TRIM(cQuerySplit2," ":U).
           END.  /* if cquerysplit2 begins and */
           ELSE IF cQuerySplit2 BEGINS ") ":U THEN
           DO:
             /* Remove columnname and parenthesises around the expression */
             ENTRY(iNumWords - 1,cQuerySplit1," ":U) = "":U.
             cQuerySplit1 = RIGHT-TRIM(cQuerySplit1," ":U).
             cQuerySplit2 = LEFT-TRIM(SUBSTR(cQuerySplit2,2)," ":U).
             
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
           /* Now remove the prev word (columnname) */
           ENTRY(iNumWords - 1,cQuerySplit1," ":U) = "":U.
           
           /* Remove blanks in order to find the prev word */
           cQuerySplit1 = RIGHT-TRIM(cQuerySplit1," ":U).
           
           /* Now remove AND */
           ENTRY(iNumWords - 2,cQuerySplit1," ":U) = "":U.          
           
           /* If we removed the last column/value pair,
              we leave no space between the parenthesis */
           IF cQuerySplit2 BEGINS ")":U THEN 
             cQuerySplit1 = RIGHT-TRIM(cQuerySplit1).  
         END.  
         /* Keep track of shrinkage */          
         iDiff = iDiff + (LENGTH(cQueryString) 
                           - LENGTH(cQuerySplit1 + cQuerySplit2)).   
         
         cQueryString = cQuerySplit1 + cQuerySplit2.  
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
      ASSIGN
        ENTRY(iBufPos,cQueryColumns,":":U) = "":U
        ENTRY(iBufPos + 1,cQueryColumns,":":U) = "":U
        cQueryColumns = TRIM(REPLACE(cQueryColumns,":::":U,":":U),":":U).
  END.  
  {set QueryColumns cQueryColumns}.
  {set QueryString cQueryString}.
  
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

   {get UseDBQualifier lUseDBQualifier}.
   {get DBNames cDBNames}.

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
  
  {get Tables cTables}.
  {get QueryWhere cQueryWhere}.

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

