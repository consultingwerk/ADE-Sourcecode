&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
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
/*---------------------------------------------------------------------------------
  File: lookupqp.p

  Description:  Generic Lookup Data Build

  Purpose:      GenericLookup Data Build.
                This routine should be run server side.
                Copes with multiple lookups at once.

  Parameters:   input-output temp-table of lookup quries to build
                Table is updated with query results

  History:
  --------
  (v:010000)    Task:        7065   UserRef:    
                Date:   15/11/2000  Author:     Anthony Swindells

  Update Notes: Created from Template aftemprocp.p

  (v:010002)    Task:    90000166   UserRef:    
                Date:   24/07/2001  Author:     Mark Davies

  Update Notes: Check if query returned more than one record, if more could be found, flag the record to indicate so.

  (v:010001)    Task:   101000025   UserRef:    
                Date:   08/30/2001  Author:     Mark Davies

  Update Notes: Combo's key field values are not formatted correctly and thus 
                fail to find the correct entry in the list. This only happens 
                for non-character values.
  Modified: 12/04/2001      Mark Davies (MIP)
            Removed hard-coded check for 50 max records in Dynamic Combo.
            
----------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       lookupqp.p
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000


/* MIP object identifying preprocessor */
&glob   mip-structured-procedure    yes

/* input-output temp-table for combo boxes / selection lists whose list items pairs
   need to be built
*/
{src/adm2/globals.i}
{src/adm2/ttlookup.i}
{src/adm2/ttdcombo.i}

DEFINE INPUT-OUTPUT PARAMETER TABLE FOR ttLookup.
DEFINE INPUT-OUTPUT PARAMETER TABLE FOR ttDCombo.
DEFINE INPUT  PARAMETER pcWidgetNames  AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER pcWidgetValues AS CHARACTER  NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-insertExpression) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD insertExpression Procedure 
FUNCTION insertExpression RETURNS CHARACTER
  (pcWhere      AS CHAR,   
   pcExpression AS CHAR,     
   pcAndOr      AS CHAR) FORWARD.

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
              specified the third token as in "FOR EACH order".

  Notes:       PRIVATE, used internally in query.p only.
------------------------------------------------------------------------------*/
  pcWhere = LEFT-TRIM(pcWhere).

  /* Remove double blanks */
  DO WHILE INDEX(pcWhere,"  ":U) > 0:
    pcWhere = REPLACE(pcWhere,"  ":U," ":U).
  END.

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
         HEIGHT             = 10.43
         WIDTH              = 61.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

RUN populateLookups.
RUN populateCombos.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-populateCombos) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE populateCombos Procedure 
PROCEDURE populateCombos :
/*------------------------------------------------------------------------------
  Purpose:     This procedure will populate Dynamic Combos
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hQuery                      AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hBufferList                 AS HANDLE EXTENT 20 NO-UNDO.
  DEFINE VARIABLE hBuffer                     AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hKeyField                   AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hDescFields                 AS HANDLE EXTENT 9 NO-UNDO.
  DEFINE VARIABLE iLoop                       AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iBuffer                     AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cField                      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cKeyValue                   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDescription                AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDescValues                 AS CHARACTER  EXTENT 9 NO-UNDO.
  DEFINE VARIABLE lFirst                      AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cEmptyValue                 AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lOk                         AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lParentQueryResolved        AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cOldQuery                   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cNewQuery                   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cParentFilterQuery          AS CHARACTER  NO-UNDO.
  
  /* Read records in passed in temp-table and work out list-item pairs plus current default value */
  COMBO_LOOP:
  FOR EACH  ttDCombo
      WHERE ttDCombo.iBuildSequence < 99999
      EXCLUSIVE-LOCK
      BY ttDCombo.iBuildSequence:
   
    /* remove decimals with commas for Europe */
    IF VALID-HANDLE(gshSessionManager) THEN
      ttDCombo.cForEach = DYNAMIC-FUNCTION("fixQueryString":U IN gshSessionManager, INPUT ttDCombo.cForEach).
  
    /* define empty value based on data type of combo */
    IF ttDCombo.cWidgetType = "":U THEN
      ASSIGN ttDCombo.cWidgetType = "Decimal":U.     /* default to decimal if not set-up */
    CASE ttDCombo.cWidgetType:
      WHEN "Character":U THEN
        ASSIGN cEmptyValue = ".":U.
      WHEN "Decimal":U THEN
        ASSIGN cEmptyValue = "0":U.
      WHEN "Integer":U THEN
        ASSIGN cEmptyValue = "0":U.
      WHEN "Date":U THEN
        ASSIGN cEmptyValue = "?":U.
      OTHERWISE
        ASSIGN cEmptyValue = "0":U.
    END CASE.
  
    IF ttDCombo.cListItemDelimiter = "":U THEN
      ASSIGN ttDCombo.cListItemDelimiter = ",":U.   /* Default to comma delimiter */
  
    /* check if european format and if so and this is a decimal widget and the delimiter is a
       comma, then set the delimiter to chr(3) because comma is a decimal separator in european
       format
    */
    IF SESSION:NUMERIC-DECIMAL-POINT = ",":U AND
       ttDCombo.cWidgetType = "Decimal":U AND
       ttDCombo.cListItemDelimiter = ",":U THEN
      ASSIGN ttDCombo.cListItemDelimiter = CHR(3).  
  
    /* Reset list item pairs and current value in case being re-run for some reason, plus field handles */
    ASSIGN
      ttDCombo.cListItemPairs = "":U
      ttDCombo.cCurrentDescValue = "":U
      hBuffer = ?
      hKeyField = ?
      cKeyValue = "":U
      cKeyValues         = "":U      
      cDescriptionValues = "":U.

    DO iLoop = 1 TO NUM-ENTRIES(ttDCombo.cDescFieldNames):
      ASSIGN
        hDescFields[iLoop] = ?
        cDescValues[iLoop] = "":U
        .
    END.
  
    /* Create a query */
    CREATE QUERY hQuery NO-ERROR.
  
    buffer-loop:
    DO iLoop = 1 TO NUM-ENTRIES(ttDCombo.cBufferList):
      CREATE BUFFER hBufferList[iLoop] FOR TABLE ENTRY(iLoop,ttDCombo.cBufferList) NO-ERROR.
      IF ERROR-STATUS:ERROR THEN NEXT buffer-loop.
      hQuery:ADD-BUFFER(hBufferList[iLoop]) NO-ERROR.
    END. /* buffer-loop */
  
    /* Before preparing the Query - Check if combo is 
       dependant on any other Widget - If so get the
       new query value and only then prepare the query.
       This will ensure that the correct - downsized
       list is returned. This will only happen on the
       initial call from the displayFields in viewer.p.
       When it is called from the combo super procedure
       it would already have the parent filter query in
       the query string of the table */
    
    cOldQuery = ttDCombo.cForEach. /* This is just a backup method */
    
    lParentQueryResolved = FALSE.
    IF pcWidgetNames <> "":U AND 
       pcWidgetNames <> "ComboAutoRefresh":U THEN DO:
      RUN returnParentFieldValues (INPUT ttDCombo.cParentField,
                                   INPUT ttDCombo.cParentFilterQuery,
                                   OUTPUT cParentFilterQuery).
      IF cParentFilterQuery <> "":U AND
         cParentFilterQuery <> ? THEN DO:
        cNewQuery = DYNAMIC-FUNCTION("newWhereClause",
                                     ENTRY(NUM-ENTRIES(cBufferList),cBufferList),
                                     cParentFilterQuery,
                                     ttDCombo.cForEach,
                                     "AND":U).
        ttDCombo.cForEach = cNewQuery.
      END.
      IF cOldQuery <> cNewQuery THEN
        lParentQueryResolved = TRUE.
    END.
    
    /* Prepare the query */
    lOk = hQuery:QUERY-PREPARE(ttDCombo.cForEach).
    /* If something went wrong with realizing the ParentFilterQuery
       revert back to the normal query */
    IF NOT lOk THEN DO:
      ttDCombo.cForEach = cOldQuery.
      lOk = hQuery:QUERY-PREPARE(ttDCombo.cForEach).
    END.
        

    /* Open the query */
    hQuery:QUERY-OPEN() NO-ERROR.
  
    /* get handle of key field */
    iBuffer = LOOKUP(ENTRY(1,ttDCombo.cKeyFieldName,".":U),ttDCombo.cBufferList).
    IF iBuffer > 0 THEN
      hBuffer = hBufferList[iBuffer].
    ELSE
      hBuffer = hBufferList[1].
    hKeyField = hBuffer:BUFFER-FIELD(ENTRY(2,ttDCombo.cKeyFieldName,".":U)) NO-ERROR.
  
    /* get handles of all description fields */
    DO iLoop = 1 TO NUM-ENTRIES(ttDCombo.cDescFieldNames):
      ASSIGN cField = ENTRY(iLoop,ttDCombo.cDescFieldNames).       
      iBuffer = LOOKUP(ENTRY(1,cField,".":U),ttDCombo.cBufferList).
      IF iBuffer > 0 THEN
        hBuffer = hBufferList[iBuffer].
      ELSE
        hBuffer = hBufferList[1].
      hDescFields[iLoop] = hBuffer:BUFFER-FIELD(ENTRY(2,cField,".":U)) NO-ERROR.
    END.
  
    /* do a quick check to see if query ok */
    ASSIGN lFirst = YES.
    hQuery:GET-FIRST() NO-ERROR.
    IF VALID-HANDLE(hBufferList[1]) AND hBufferList[1]:AVAILABLE = YES THEN 
    query-loop:
    REPEAT:
      IF lFirst THEN
      DO:
        hQuery:GET-FIRST().
        ASSIGN lFirst = NO.
      END.
      ELSE    
        hQuery:GET-NEXT().
      IF hQuery:QUERY-OFF-END THEN LEAVE.
  
      /* Reset field values */
      ASSIGN
        cKeyValue = "":U
        .    
      DO iLoop = 1 TO NUM-ENTRIES(ttDCombo.cDescFieldNames):
        ASSIGN
          cDescValues[iLoop] = "":U
          .
      END.
  
      /* get values of all fields */
      cKeyValue = TRIM(STRING(hKeyField:BUFFER-VALUE,ttDCombo.cKeyFormat)) NO-ERROR. 
      IF cKeyValue = "":U OR cKeyValue = ? THEN
        ASSIGN cKeyValue = "?":U.
      cKeyValue = REPLACE(cKeyValue, ttDCombo.cListItemDelimiter, "":U).
  
      DO iLoop = 1 TO NUM-ENTRIES(ttDCombo.cDescFieldNames):
        cDescValues[iLoop] = STRING(hDescFields[iLoop]:BUFFER-VALUE) NO-ERROR.
        IF cDescValues[iLoop] = "":U OR cDescValues[iLoop] = ? THEN
          ASSIGN cDescValues[iLoop] = "?":U.
        cDescValues[iLoop] = REPLACE(cDescValues[iLoop], ttDCombo.cListItemDelimiter, " ":U).
      END.
  
      ASSIGN
        cDescription = "":U.
  
      /* Build description from list of description values */
      IF ttDCombo.cDescSubstitute = "":U THEN
      DO iLoop = 1 TO NUM-ENTRIES(ttDCombo.cDescFieldNames):
        ASSIGN
          ttDCombo.cDescSubstitute = ttDCombo.cDescSubstitute + (IF ttDCombo.cDescSubstitute = "":U THEN "":U ELSE " / ":U) +
                                   "&":U + STRING(iLoop)
          .
      END.
  
      ASSIGN cDescription = SUBSTITUTE(ttDCombo.cDescSubstitute,
                                       cDescValues[1],
                                       cDescValues[2],
                                       cDescValues[3],
                                       cDescValues[4],
                                       cDescValues[5],
                                       cDescValues[6],
                                       cDescValues[7],
                                       cDescValues[8],
                                       cDescValues[9])
  
      .
      ASSIGN ttDCombo.cKeyValues         = IF ttDCombo.cKeyValues <> "":U THEN ttDCombo.cKeyValues + ttDCombo.cListItemDelimiter + cKeyValue ELSE cKeyValue
             ttDCombo.cDescriptionValues = IF ttDCombo.cDescriptionValues <> "":U THEN ttDCombo.cDescriptionValues + ttDCombo.cListItemDelimiter + cDescription ELSE cDescription.
      IF ttDCombo.cListItemPairs <> "":U THEN ttDCombo.cListItemPairs = ttDCombo.cListItemPairs + ttDCombo.cListItemDelimiter.
      ttDCombo.cListItemPairs = ttDCombo.cListItemPairs + cDescription + ttDCombo.cListItemDelimiter + cKeyValue.
      
      /* This is a safeguard for Error 444 - due to changes made somewhere in 
         adm2 (datavis.p - I think) it runs displayField in viewer.p twice but 
         the first time no field/widgets are available on the viewer and this
         causes the parent filter query to fail and then resulting in a major
         crash - the second time displayFields is called the fields/widgets
         are available on the viewer and the parent filter query can then be
         resolved - this is a fix for issue #3335 
         This code here will ensure that only one record is read the first 
         time to avoid issues with the combo's list-item-pairs */
      IF lParentQueryResolved = FALSE AND
         ttDCombo.cParentField <> "":U AND 
         pcWidgetNames <> "ComboAutoRefresh":U THEN
        LEAVE query-loop.
    END.  /* query-loop */
    
    /* Now run through the flags and put put in the extra values */
    CASE ttDCombo.cFlag:
      WHEN "N" THEN /* blank is a none option */
      DO:
        cEmptyValue = ttDCombo.cFlagValue.
        ASSIGN
          ttDCombo.cListItemPairs = "<None>":U 
                     + ttDCombo.cListItemDelimiter
                     + cEmptyValue
                     + (IF ttDCombo.cListItemPairs = "":U THEN "":U ELSE ttDCombo.cListItemDelimiter)
                     + ttDCombo.cListItemPairs
          ttDCombo.cDescriptionValues = "<None>":U + IF ttDCombo.cDescriptionValues <> "":U THEN ttDCombo.cListItemDelimiter + ttDCombo.cDescriptionValues ELSE "":U
          ttDCombo.cKeyValues         = cEmptyValue + IF ttDCombo.cKeyValues <> "":U THEN ttDCombo.cListItemDelimiter + ttDCombo.cKeyValues ELSE "":U
        .
      END.
      WHEN "A" THEN /* blank is an all option */
      DO:
        cEmptyValue = ttDCombo.cFlagValue.
        ASSIGN
          ttDCombo.cListItemPairs = "<All>":U 
                     + ttDCombo.cListItemDelimiter
                     + cEmptyValue
                     + (IF ttDCombo.cListItemPairs = "":U THEN "":U ELSE ttDCombo.cListItemDelimiter)
                     + ttDCombo.cListItemPairs
          ttDCombo.cDescriptionValues = "<All>":U + IF ttDCombo.cDescriptionValues <> "":U THEN ttDCombo.cListItemDelimiter + ttDCombo.cDescriptionValues ELSE "":U
          ttDCombo.cKeyValues         = cEmptyValue + IF ttDCombo.cKeyValues <> "":U THEN ttDCombo.cListItemDelimiter + ttDCombo.cKeyValues ELSE "":U
        .
      END.
    END CASE.
    /* Make sure that the string contains PAIRS */ 
    IF ttDCombo.cListItemPairs = "":U OR NUM-ENTRIES(ttDCombo.cListItemPairs, ttDCombo.cListItemDelimiter) MOD 2 <> 0 THEN
      ASSIGN
        ttDCombo.cListItemPairs = ttDCombo.cListItemDelimiter
      .
  
    /* now see if we can find the default value specified and prime the current description */
    ASSIGN
      iLoop = LOOKUP(ttDCombo.cCurrentKeyValue, ttDCombo.cListItemPairs, ttDCombo.cListItemDelimiter).
    IF iLoop > 1 THEN
      ASSIGN
        ttDCombo.cCurrentDescValue = ENTRY(iLoop - 1,ttDCombo.cListItemPairs, ttDCombo.cListItemDelimiter)
        .
    ELSE
      ASSIGN
        ttDCombo.cCurrentDescValue = "":U.
  
    /* tidy up */
    hQuery:QUERY-CLOSE() NO-ERROR.
    DELETE OBJECT hQuery NO-ERROR.
    ASSIGN hQuery = ?.
  
    buffer-loop2:
    DO iLoop = 1 TO NUM-ENTRIES(ttDCombo.cBufferList):
      DELETE OBJECT hBufferList[iLoop] NO-ERROR.
      ASSIGN hBufferList[iLoop] = ?.
    END. /* buffer-loop2 */
  
  END.  /* FOR EACH ttDCombo: */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-populateLookups) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE populateLookups Procedure 
PROCEDURE populateLookups :
/*------------------------------------------------------------------------------
  Purpose:     This procedure will populate Dynamic Lookups
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hQuery                      AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hBufferList                 AS HANDLE EXTENT 20 NO-UNDO.
  DEFINE VARIABLE hBuffer                     AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hReturnFields               AS HANDLE EXTENT 50 NO-UNDO.
  DEFINE VARIABLE iLoop                       AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iBuffer                     AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cField                      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cRowid                      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cValue                      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cEmptyValue                 AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lOk                         AS LOGICAL    NO-UNDO.
  
  /* Read records in passed in temp-table and work out list-item pairs plus current default value */
  FOR EACH ttLookup:
  
    /* define empty value based on data type of combo */
    IF ttLookup.cWidgetType = "":U THEN
      ASSIGN ttLookup.cWidgetType = "Decimal":U.     /* default to decimal if not set-up */
    CASE ttLookup.cWidgetType:
      WHEN "Character":U THEN
        ASSIGN cEmptyValue = ".":U.
      WHEN "Decimal":U THEN
        ASSIGN cEmptyValue = "0":U.
      WHEN "Integer":U THEN
        ASSIGN cEmptyValue = "0":U.
      WHEN "Date":U THEN
        ASSIGN cEmptyValue = "?":U.
      OTHERWISE
        ASSIGN cEmptyValue = "0":U.
    END CASE.
  
    /* Reset list item pairs and current value in case being re-run for some reason, plus field handles */
    ASSIGN
      ttLookup.cFoundDataValues = "":U
      ttLookup.cRowIdent = "":U
      hBuffer = ?
      .    
    DO iLoop = 1 TO NUM-ENTRIES(ttLookup.cFieldList):
      ASSIGN
        hReturnFields[iLoop] = ?
        .
    END.
  
    /* Create a query */
    CREATE QUERY hQuery NO-ERROR.
  
    buffer-loop:
    DO iLoop = 1 TO NUM-ENTRIES(ttLookup.cBufferList):
      CREATE BUFFER hBufferList[iLoop] FOR TABLE ENTRY(iLoop,ttLookup.cBufferList) NO-ERROR.
      IF ERROR-STATUS:ERROR THEN NEXT buffer-loop.
      hQuery:ADD-BUFFER(hBufferList[iLoop]) NO-ERROR.
    END. /* buffer-loop */
  
    /* Prepare the query */
  
    /* remove decimals with commas for Europe */
    IF VALID-HANDLE(gshSessionManager) THEN
      ttLookup.cForEach = DYNAMIC-FUNCTION("fixQueryString":U IN gshSessionManager, INPUT ttLookup.cForEach).
  
    lOk = hQuery:QUERY-PREPARE(ttLookup.cForEach).
  
    /* Open the query */
    hQuery:QUERY-OPEN() NO-ERROR.
  
    /* get handles of all return fields */
    DO iLoop = 1 TO NUM-ENTRIES(ttLookup.cFieldList):
      ASSIGN cField = ENTRY(iLoop,ttLookup.cFieldList).       
      iBuffer = LOOKUP(ENTRY(1,cField,".":U),ttLookup.cBufferList).
      IF iBuffer > 0 THEN
        hBuffer = hBufferList[iBuffer].
      ELSE
        hBuffer = hBufferList[1].
      hReturnFields[iLoop] = hBuffer:BUFFER-FIELD(ENTRY(2,cField,".":U)) NO-ERROR.
    END.
  
    /* Retrieve 1st record - should only be one */
    hQuery:GET-FIRST() NO-ERROR.
    IF VALID-HANDLE(hBufferList[1]) AND hBufferList[1]:AVAILABLE = YES THEN 
    DO:
      DO iLoop = 1 TO NUM-ENTRIES(ttLookup.cFieldList):
        cValue = "":U.
        cValue = STRING(hReturnFields[iLoop]:BUFFER-VALUE) NO-ERROR.
        IF cValue = "":U OR cValue = ? THEN
          ASSIGN cValue = "?":U.
        ASSIGN 
          ttLookup.cFoundDataValues = ttLookup.cFoundDataValues +
                                      (IF iLoop = 1 THEN "":U ELSE CHR(1)) +
                                      cValue.
      END.
      /* Store rowids of buffers */
      DO iLoop = 1 TO NUM-ENTRIES(ttLookup.cBufferList):
        IF VALID-HANDLE(hBufferList[iLoop]) THEN
          ASSIGN
            cRowid = STRING(hBufferList[iLoop]:ROWID) NO-ERROR.
        ELSE
          ASSIGN cRowid = "?":U.              
        IF cRowID = "":U OR cRowId = ? THEN ASSIGN cRowid = "?":U.
        ASSIGN  
          ttLookup.cRowIdent = ttLookup.cRowIdent +
                               (IF iLoop = 1 THEN "":U ELSE ",":U) + cRowid
                               .
      END.
    END.
    
    /* Check if more records could be found */
    hQuery:GET-NEXT() NO-ERROR.
    IF VALID-HANDLE(hBufferList[1]) AND hBufferList[1]:AVAILABLE = YES THEN 
      ASSIGN ttLookup.lMoreFound = TRUE.
  
    /* tidy up */
    hQuery:QUERY-CLOSE() NO-ERROR.
    DELETE OBJECT hQuery NO-ERROR.
    ASSIGN hQuery = ?.
  
    buffer-loop2:
    DO iLoop = 1 TO NUM-ENTRIES(ttLookup.cBufferList):
      DELETE OBJECT hBufferList[iLoop] NO-ERROR.
      ASSIGN hBufferList[iLoop] = ?.
    END. /* buffer-loop2 */
  
  END.  /* FOR EACH ttLookup: */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-returnParentFieldValues) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE returnParentFieldValues Procedure 
PROCEDURE returnParentFieldValues :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcParentField       AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pcParentFilterQuery AS CHARACTER  NO-UNDO.
  DEFINE OUTPUT PARAMETER pcNewQuery          AS CHARACTER  NO-UNDO.
  
  DEFINE VARIABLE iLoop             AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iField            AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cField            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cValue            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSubs             AS CHARACTER  NO-UNDO EXTENT 9.
  DEFINE VARIABLE cSDFFieldName     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hSDFHandle        AS HANDLE     NO-UNDO.

  DEFINE BUFFER b_ttDCombo FOR ttDCombo.

  DO iLoop = 1 TO NUM-ENTRIES(pcWidgetNames,CHR(3)):
    ASSIGN
        iField = LOOKUP(ENTRY(iLoop,pcWidgetNames,CHR(3)), pcParentField)
        cField = ENTRY(iField,pcParentField)
        NO-ERROR.
    /* Check if the combo depends on anothed combo - 
       in some instances were a new record is being
       added - the parent combo's field value will
       be blank - in cases like this, we need to 
       make the value that of the first entry in
       the combo's list-items */
    IF CAN-FIND(FIRST b_ttDCombo
                WHERE b_ttDCombo.cWidgetName = cField) THEN DO:
      FIND FIRST b_ttDCombo
           WHERE b_ttDCombo.cWidgetName = cField
           NO-LOCK NO-ERROR.
      IF b_ttDCombo.cCurrentKeyValue <> "":U THEN
        cValue = b_ttDCombo.cCurrentKeyValue.
      ELSE
        cValue = ENTRY(1,b_ttDCombo.cKeyValues,CHR(1)).
      IF iField > 0 AND iField <= 9 THEN
        ASSIGN cSubs[iField] = TRIM(cValue).
    END.
    ELSE DO:
      IF iField > 0 AND iField <= 9 THEN
        ASSIGN cValue        = ENTRY(iLoop,pcWidgetValues,CHR(3))
               cSubs[iField] = TRIM(cValue).
    END.
  END.
  pcNewQuery = SUBSTITUTE(pcParentFilterQuery,cSubs[1],cSubs[2],cSubs[3],cSubs[4],cSubs[5],cSubs[6],cSubs[7],cSubs[8],cSubs[9]).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

/* ************************  Function Implementations ***************** */

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
 Notes:       The new expression is embedded in parenthesis, but no parentheses
              are placed around the existing one.  
              Lock keywords must be unabbreviated or without -lock (i.e. SHARE
              or EXCLUSIVE.)   
              Any keyword in comments may cause problems.
              This is PRIVATE to query.p.   
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
    cTable        = whereClauseBuffer(pcWhere)
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

&IF DEFINED(EXCLUDE-newWhereClause) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION newWhereClause Procedure 
FUNCTION newWhereClause RETURNS CHARACTER
  (pcBuffer     AS CHAR,   
   pcExpression AS char,  
   pcWhere      AS CHAR,
   pcAndOr      AS CHAR):
/*------------------------------------------------------------------------------
  Purpose:     Inserts a new expression to query's prepare string for a specified 
               buffer.
  Parameters:  pcBuffer     - Which buffer.
               pcExpression - The new expression. 
               pcWhere      - The current query prepare string.
               pcAndOr      - Specifies what operator is used to add the new
                              expression to existing expression(s)
                              - AND (default) 
                              - OR                                                
  Notes:       This is a utility function that doesn't use any properties.             
------------------------------------------------------------------------------*/
 DEFINE VARIABLE iComma      AS INT    NO-UNDO. 
 DEFINE VARIABLE iCount      AS INT    NO-UNDO.
 DEFINE VARIABLE iStart      AS INT    NO-UNDO.
 DEFINE VARIABLE iLength     AS INT    NO-UNDO.
 DEFINE VARIABLE iEnd        AS INT    NO-UNDO.
 DEFINE VARIABLE cWhere      AS CHAR   NO-UNDO.
 DEFINE VARIABLE cString     AS CHAR   NO-UNDO.
 DEFINE VARIABLE cFoundWhere AS CHAR   NO-UNDO.
 DEFINE VARIABLE cNextWhere  AS CHAR   NO-UNDO.
 DEFINE VARIABLE hQuery      AS HANDLE NO-UNDO.

  /* Astra2  - fix European decimal format issues with Astra object numbers in query string
     FYI: fixQueryString is a function in smartcustom.p
  */
  IF VALID-HANDLE(gshSessionManager) THEN
    pcWhere = DYNAMIC-FUNCTION("fixQueryString":U IN gshSessionManager, INPUT pcWhere). /* Astra2 */

 ASSIGN
   cString = pcWhere
   iStart  = 1.          

 DO WHILE TRUE:

   iComma  = INDEX(cString,","). 

   /* If a comma was found we split the string into cFoundWhere and cNextwhere */  
   IF iComma <> 0 THEN 
     ASSIGN
       cFoundWhere = cFoundWhere + SUBSTR(cString,1,iComma)
       cNextWhere  = SUBSTR(cString,iComma + 1)     
       iCount      = iCount + iComma.       
   ELSE 

     /* cFoundWhere is blank if this is the first time or if we have moved on 
        to the next buffers where clause
        If cFoundwhere is not blank the last comma that was used to split 
        the string into cFoundwhere and cNextwhere was not a join, 
        so we must set them together again.   
     */     
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
       cFoundWhere = RIGHT-TRIM(cFoundWhere,",.":U) 
       iLength     = LENGTH(cFoundWhere).

     IF whereClauseBuffer(cFoundWhere) = pcBuffer  THEN
     DO:   
       SUBSTR(pcWhere,iStart,iLength) = insertExpression(cFoundWhere,
                                                         pcExpression,
                                                         pcAndOr).           
       LEAVE.
     END.
     ELSE
       /* We're moving on to the next whereclause so reset cFoundwhere */ 
       ASSIGN      
         cFoundWhere = "":U                     
         iStart      = iCount + 1.      

     /* No table found and we are at the end so we need to get out of here */  
     IF iComma = 0 THEN 
     DO:
       /* (Buffer is not in query) Is this a run time error ? */.
       LEAVE.    
     END.
   END. /* if iComma = 0 or can-do(EACH,FIRST,LAST */
   cString = cNextWhere.  
 END. /* do while true. */
 RETURN pcWhere.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

