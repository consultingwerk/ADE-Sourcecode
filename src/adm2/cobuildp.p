&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*********************************************************************
* Copyright (C) 2005 by Progress Software Corporation. All rights    *
* reserved.  Prior versions of this work may contain portions        *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*---------------------------------------------------------------------------------
  File: cobuildp.p

  Description:  Generic Combo/Selection List Data Build

  Purpose:      Generic Combo/Selection List Data Build.
                To populate list item pairs generically for combo boxes and selection lists.
                This routine should be run server side.
                Copes with multiple combo's / selection lists at once.

  Parameters:   input-output temp-table of widget information for data to build
                Table is updated with list item pairs built.

  History:
  --------
  (v:010000)    Task:        5653   UserRef:    
                Date:   29/05/2000  Author:     Anthony Swindells

  Update Notes: Created from Template aftemprocp.p

  (v:010001)    Task:        6010   UserRef:    
                Date:   13/06/2000  Author:     Anthony Swindells

  Update Notes: Astra 2 Login Window

  (v:010002)    Task:        6421   UserRef:    
                Date:   07/08/2000  Author:     Anthony Swindells

  Update Notes: Get combos on SDV's working

  (v:010003)    Task:        6610   UserRef:    
                Date:   25/10/2000  Author:     Peter Judge

  Update Notes: BUG/ Error checking only caters for default (comma) delimiter

  (v:010004)    Task:        7415   UserRef:    
                Date:   28/12/2000  Author:     Anthony Swindells

  Update Notes: Fix issues with European format decimals

-----------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       afcobuildp.p
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    010004


/* MIP object identifying preprocessor */
&glob   mip-structured-procedure    yes

/* input-output temp-table for combo boxes / selection lists whose list items pairs
   need to be built
*/
{src/adm2/globals.i}
{src/adm2/ttcombo.i}

DEFINE INPUT-OUTPUT PARAMETER TABLE FOR ttComboData.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



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
         HEIGHT             = 5.38
         WIDTH              = 40.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

DEFINE VARIABLE hQuery                      AS HANDLE     NO-UNDO.
DEFINE VARIABLE hBufferList                 AS HANDLE EXTENT 20 NO-UNDO.
DEFINE VARIABLE hBuffer                     AS HANDLE     NO-UNDO.
DEFINE VARIABLE hKeyField                   AS HANDLE     NO-UNDO.
DEFINE VARIABLE hDescFields                 AS HANDLE EXTENT 9 NO-UNDO.
DEFINE VARIABLE iDescExtent                 AS INT    EXTENT 9 NO-UNDO.         /* -- added by SiL to handle extents */
DEFINE VARIABLE iLoop                       AS INTEGER    NO-UNDO.
DEFINE VARIABLE iBuffer                     AS INTEGER    NO-UNDO.
DEFINE VARIABLE cField                      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cKeyValue                   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cDescription                AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cDescValues                 AS CHARACTER  EXTENT 9 NO-UNDO.
DEFINE VARIABLE lFirst                      AS LOGICAL    NO-UNDO.
DEFINE VARIABLE cEmptyValue                 AS CHARACTER  NO-UNDO.
DEFINE VARIABLE lOk                         AS LOGICAL    NO-UNDO.

/* Read records in passed in temp-table and work out list-item pairs plus current default value */
FOR EACH ttComboData:

  /* Process any filter set phrases in the query string */
  IF VALID-HANDLE(gshGenManager) THEN
    RUN processQueryStringFilterSets IN gshGenManager (INPUT  ttComboData.cForEach,
                                                       OUTPUT ttComboData.cForEach).

  /* define empty value based on data type of combo */
  IF ttComboData.cWidgetType = "":U THEN
    ASSIGN ttComboData.cWidgetType = "Decimal":U.     /* default to decimal if not set-up */
  CASE ttComboData.cWidgetType:
    WHEN "Character":U THEN
      ASSIGN cEmptyValue = ".":U.
    WHEN "Decimal":U THEN
      ASSIGN cEmptyValue = "0":U.
    WHEN "Integer":U THEN
      ASSIGN cEmptyValue = "0":U.
    WHEN "Date":U THEN
      ASSIGN cEmptyValue = "?":U.
    WHEN "DateTime":U THEN
      ASSIGN cEmptyValue = "?":U.
    WHEN "DateTime-Tz":U THEN
      ASSIGN cEmptyValue = "?":U.
    OTHERWISE
      ASSIGN cEmptyValue = "0":U.
  END CASE.

  IF ttComboData.cListItemDelimiter = "":U THEN
    ASSIGN ttComboData.cListItemDelimiter = ",":U.   /* Default to comma delimiter */

  /* check if european format and if so and this is a decimal widget and the delimiter is a
     comma, then set the delimiter to chr(3) because comma is a decimal separator in european
     format
  */
  IF SESSION:NUMERIC-DECIMAL-POINT = ",":U AND
     ttComboData.cWidgetType = "Decimal":U AND
     ttComboData.cListItemDelimiter = ",":U THEN
    ASSIGN ttComboData.cListItemDelimiter = CHR(3).  

  /* Reset list item pairs and current value in case being re-run for some reason, plus field handles */
  ASSIGN
    ttComboData.cListItemPairs = "":U
    ttComboData.cCurrentDescValue = "":U
    hBuffer = ?
    hKeyField = ?
    cKeyValue = "":U
    .    
  DO iLoop = 1 TO NUM-ENTRIES(ttComboData.cDescFieldNames):
    ASSIGN
      hDescFields[iLoop] = ?
      cDescValues[iLoop] = "":U
      .
  END.

  /* Create a query */
  CREATE QUERY hQuery NO-ERROR.

  buffer-loop:
  DO iLoop = 1 TO NUM-ENTRIES(ttComboData.cBufferList):
    CREATE BUFFER hBufferList[iLoop] FOR TABLE ENTRY(iLoop,ttComboData.cBufferList) NO-ERROR.
    IF ERROR-STATUS:ERROR THEN NEXT buffer-loop.
    hQuery:ADD-BUFFER(hBufferList[iLoop]) NO-ERROR.
  END. /* buffer-loop */

  /* Prepare the query */
  lOk = hQuery:QUERY-PREPARE(ttComboData.cForEach).

  /* Open the query */
  hQuery:QUERY-OPEN() NO-ERROR.

  /* get handle of key field */
  iBuffer = LOOKUP(ENTRY(1,ttComboData.cKeyFieldName,".":U),ttComboData.cBufferList).
  IF iBuffer > 0 THEN
    hBuffer = hBufferList[iBuffer].
  ELSE
    hBuffer = hBufferList[1].
  hKeyField = hBuffer:BUFFER-FIELD(ENTRY(2,ttComboData.cKeyFieldName,".":U)) NO-ERROR.

  /* get handles of all description fields */
  DO iLoop = 1 TO NUM-ENTRIES(ttComboData.cDescFieldNames):
    ASSIGN cField = ENTRY(iLoop,ttComboData.cDescFieldNames).       
    iBuffer = LOOKUP(ENTRY(1,cField,".":U),ttComboData.cBufferList).
    IF iBuffer > 0 THEN
      hBuffer = hBufferList[iBuffer].
    ELSE
      hBuffer = hBufferList[1].
    /* -- added by SiL to handle extents */
    cField = ENTRY (2, cField, '.':U).
    IF INDEX (cField, '[':U) > 0 THEN
      ASSIGN
          iDescExtent[iLoop] = INT(ENTRY (1, ENTRY (2, cField, '[':U), ']':U))
          cField  = ENTRY (1, cField, '[':U).
    hDescFields[iLoop] = hBuffer:BUFFER-FIELD(cField) NO-ERROR.
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
    DO iLoop = 1 TO NUM-ENTRIES(ttComboData.cDescFieldNames):
      ASSIGN
        cDescValues[iLoop] = "":U
        .
    END.

    /* get values of all fields */
    cKeyValue = STRING(hKeyField:BUFFER-VALUE) NO-ERROR. 
    IF cKeyValue = "":U OR cKeyValue = ? THEN
      ASSIGN cKeyValue = "?":U.
    cKeyValue = REPLACE(cKeyValue, ttComboData.cListItemDelimiter, "":U).
    DO iLoop = 1 TO NUM-ENTRIES(ttComboData.cDescFieldNames):
      IF INDEX(ENTRY(iLoop,ttComboData.cDescFieldNames),"[":U) = 0 THEN DO:
        cDescValues[iLoop] = STRING(hDescFields[iLoop]:BUFFER-VALUE) NO-ERROR.
        IF cDescValues[iLoop] = "":U OR cDescValues[iLoop] = ? THEN
          ASSIGN cDescValues[iLoop] = "?":U.
        cDescValues[iLoop] = REPLACE(cDescValues[iLoop], ttComboData.cListItemDelimiter, " ":U).
      END.
      ELSE DO:
        cDescValues[iLoop] = STRING(hDescFields[iLoop]:BUFFER-VALUE[INTEGER(RIGHT-TRIM(ENTRY(2,ENTRY(iLoop,ttComboData.cDescFieldNames),"[":U),"]":U))]) NO-ERROR.
        IF cDescValues[iLoop] = "":U OR cDescValues[iLoop] = ? THEN
          ASSIGN cDescValues[iLoop] = "?":U.
        cDescValues[iLoop] = REPLACE(cDescValues[iLoop], ttComboData.cListItemDelimiter, " ":U).

      END.
    END.

    ASSIGN
      cDescription = "":U.

    /* Build description from list of description values */
    IF ttComboData.cDescSubstitute = "":U THEN
    DO iLoop = 1 TO NUM-ENTRIES(ttComboData.cDescFieldNames):
      ASSIGN
        ttComboData.cDescSubstitute = ttComboData.cDescSubstitute + (IF ttComboData.cDescSubstitute = "":U THEN "":U ELSE " / ":U) +
                                 "&":U + STRING(iLoop)
        .
    END.

    ASSIGN cDescription = SUBSTITUTE(ttComboData.cDescSubstitute,
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

    IF ttComboData.cListItemPairs <> "":U THEN ttComboData.cListItemPairs = ttComboData.cListItemPairs + ttComboData.cListItemDelimiter.
    ttComboData.cListItemPairs = ttComboData.cListItemPairs + cDescription + ttComboData.cListItemDelimiter + cKeyValue.

  END.  /* query-loop */

  /* Now run through the flags and put put in the extra values */
  CASE ttComboData.cFlag:
    WHEN "N" THEN /* blank is a none option */
    DO:
      ASSIGN
        ttComboData.cListItemPairs = "<None>":U 
                   + ttComboData.cListItemDelimiter
                   + cEmptyValue
                   + (IF ttComboData.cListItemPairs = "":U THEN "":U ELSE ttComboData.cListItemDelimiter)
                   + ttComboData.cListItemPairs
      .
    END.
    WHEN "A" THEN /* blank is an all option */
    DO:
      ASSIGN
        ttComboData.cListItemPairs = "<All>":U 
                   + ttComboData.cListItemDelimiter
                   + cEmptyValue
                   + (IF ttComboData.cListItemPairs = "":U THEN "":U ELSE ttComboData.cListItemDelimiter)
                   + ttComboData.cListItemPairs
      .
    END.
/*     OTHERWISE /* blank is not allowed */                                                                  */
/*     DO:                                                                                                   */
/*       ASSIGN                                                                                              */
/*         ttComboData.cListItemPairs = "":U                                                                 */
/*                    + ttComboData.cListItemDelimiter                                                       */
/*                    + cEmptyValue                                                                          */
/*                    + (IF ttComboData.cListItemPairs = "":U THEN "":U ELSE ttComboData.cListItemDelimiter) */
/*                    + ttComboData.cListItemPairs                                                           */
/*       .                                                                                                   */
/*     END.                                                                                                  */
  END CASE.

  /* Make sure that the string contains PAIRS */ 
  IF ttComboData.cListItemPairs = "":U OR NUM-ENTRIES(ttComboData.cListItemPairs, ttComboData.cListItemDelimiter) MOD 2 <> 0 THEN
    ASSIGN
      ttComboData.cListItemPairs = ttComboData.cListItemDelimiter
    .

  /* now see if we can find the default value specified and prime the current description */
  ASSIGN
    iLoop = LOOKUP(ttComboData.cCurrentKeyValue, ttComboData.cListItemPairs, ttComboData.cListItemDelimiter).
  IF iLoop > 1 THEN
    ASSIGN
      ttComboData.cCurrentDescValue = ENTRY(iLoop - 1,ttComboData.cListItemPairs, ttComboData.cListItemDelimiter)
      .
  ELSE
    ASSIGN
      ttComboData.cCurrentDescValue = "":U.

  /* tidy up */
  hQuery:QUERY-CLOSE() NO-ERROR.
  DELETE OBJECT hQuery NO-ERROR.
  ASSIGN hQuery = ?.

  buffer-loop2:
  DO iLoop = 1 TO NUM-ENTRIES(ttComboData.cBufferList):
    DELETE OBJECT hBufferList[iLoop] NO-ERROR.
    ASSIGN hBufferList[iLoop] = ?.
  END. /* buffer-loop2 */

END.  /* FOR EACH ttComboData: */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


