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
  File: fetchfield.p

  Description:  Generic Combo/Lookup Data Build

  Purpose:      Generic Combo/Lookup Data Build.
                This routine should be run server side.
                Copes with multiple combos/lookups at once.

  Parameters:   input-output temp-table of lookup quries to build
                Table is updated with query results
           
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
DEFINE INPUT-OUTPUT  PARAMETER TABLE FOR ttDCombo.

/* To keep track of PLIPs started */
DEFINE TEMP-TABLE ttPLIP NO-UNDO
  FIELDS cPLIP    AS CHARACTER
  FIELDS hHandle  AS HANDLE
  INDEX  idx1     AS PRIMARY UNIQUE cPLIP.


{src/adm2/inrepprmod.i}
{src/adm2/sdfcmnapis.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-formattedValue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD formattedValue Procedure 
FUNCTION formattedValue RETURNS CHARACTER
  (pcValue    AS CHARACTER,
   pcDataType AS CHARACTER,
   pcFormat   AS CHARACTER)  FORWARD.

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
         WIDTH              = 56.8.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */
RUN populateLookups.
RUN populateCombos.

FOR EACH ttPLIP:
  IF VALID-HANDLE(ttPLIP.hHandle) THEN
    RUN killPlip IN ttPLIP.hHandle NO-ERROR.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-getDBList) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getDBList Procedure 
PROCEDURE getDBList :
/*------------------------------------------------------------------------------
  Purpose:     Get DB list from query string
  Parameters:  input query string
               output buffer list
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER  pcQueryString             AS CHARACTER  NO-UNDO.
DEFINE OUTPUT PARAMETER pcDBList                  AS CHARACTER  NO-UNDO.

DEFINE VARIABLE iStart                            AS INTEGER    NO-UNDO.
DEFINE VARIABLE iPosn                             AS INTEGER    NO-UNDO.
DEFINE VARIABLE iPos1                             AS INTEGER    NO-UNDO.
DEFINE VARIABLE iPos2                             AS INTEGER    NO-UNDO.
DEFINE VARIABLE iPos3                             AS INTEGER    NO-UNDO.
DEFINE VARIABLE iPos4                             AS INTEGER    NO-UNDO.
DEFINE VARIABLE iPos5                             AS INTEGER    NO-UNDO.
DEFINE VARIABLE iPos6                             AS INTEGER    NO-UNDO.
DEFINE VARIABLE iPos7                             AS INTEGER    NO-UNDO.
DEFINE VARIABLE iPos8                             AS INTEGER    NO-UNDO.
DEFINE VARIABLE iPos9                             AS INTEGER    NO-UNDO.
DEFINE VARIABLE iLen                              AS INTEGER    NO-UNDO.
DEFINE VARIABLE cBuffer                           AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cDB                               AS CHARACTER  NO-UNDO.

ASSIGN iStart = 1.


buffer-loop:
REPEAT WHILE TRUE:

  ASSIGN
    cBuffer = "":U
    iPos1 = INDEX(pcQueryString, " EACH ":U, iStart)
    iPos2 = INDEX(pcQueryString, " FIRST ":U, iStart)
    iPos3 = INDEX(pcQueryString, " LAST ":U, iStart)
    iPos4 = INDEX(pcQueryString, ",EACH ":U, iStart)
    iPos5 = INDEX(pcQueryString, ",FIRST ":U, iStart)
    iPos6 = INDEX(pcQueryString, ",LAST ":U, iStart)
    iPos7 = INDEX(pcQueryString, CHR(10) + "EACH ":U, iStart)
    iPos8 = INDEX(pcQueryString, CHR(10) + "FIRST ":U, iStart)
    iPos9 = INDEX(pcQueryString, CHR(10) + "LAST ":U, iStart)
    iPosn = IF (iPos1 > 0) THEN iPos1 ELSE 999999
    iPosn = IF (iPos2 > 0 AND iPos2 < iPosn) THEN iPos2 ELSE iPosn
    iPosn = IF (iPos3 > 0 AND iPos3 < iPosn) THEN iPos3 ELSE iPosn
    iPosn = IF (iPos4 > 0 AND iPos4 < iPosn) THEN iPos4 ELSE iPosn
    iPosn = IF (iPos5 > 0 AND iPos5 < iPosn) THEN iPos5 ELSE iPosn
    iPosn = IF (iPos6 > 0 AND iPos6 < iPosn) THEN iPos6 ELSE iPosn
    iPosn = IF (iPos7 > 0 AND iPos7 < iPosn) THEN iPos7 ELSE iPosn
    iPosn = IF (iPos8 > 0 AND iPos8 < iPosn) THEN iPos8 ELSE iPosn
    iPosn = IF (iPos9 > 0 AND iPos9 < iPosn) THEN iPos9 ELSE iPosn
    .
  IF iPosn = 0 OR iPosn = 999999 THEN LEAVE buffer-loop.

  IF SUBSTRING(pcQueryString,iPosn + 1,1) = "F":U THEN
    ASSIGN iLen = 6.
  ELSE
    ASSIGN iLen = 5.

  ASSIGN iStart = iPosn + iLen.

  /* Found a buffer - get its name, minus the DB reference */
  ASSIGN
    cBuffer = TRIM(SUBSTRING(pcQueryString,iPosn + iLen))
    iPos1 = INDEX(cBuffer, " ":U)
    iPos2 = INDEX(cBuffer, ",":U)
    iLen = IF (iPos1 > 0) THEN iPos1 ELSE 999999
    iLen = IF (iPos2 > 0 AND iPos2 < iLen) THEN iPos2 ELSE iLen    
    .
    IF iLen = 0 OR iLen = 999999 THEN ASSIGN iLen = LENGTH(cBuffer) + 1.
  ASSIGN
    cBuffer = SUBSTRING(cBuffer,1,iLen - 1).
  
  IF NUM-ENTRIES(cBuffer,".":U) = 2 THEN
    ASSIGN cDB = ENTRY(1,cBuffer,".":U).  /* strip off DB */

  IF LENGTH(cDB) > 0 THEN
    ASSIGN
      pcDBList = pcDBList + (IF pcDBList <> "":U THEN ",":U ELSE "":U) +
                  cDB.

END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-populateCombos) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE populateCombos Procedure 
PROCEDURE populateCombos :
DEFINE VARIABLE hQuery AS HANDLE NO-UNDO.
DEFINE VARIABLE hBufferList AS HANDLE EXTENT 20 NO-UNDO.
DEFINE VARIABLE hBuffer AS HANDLE NO-UNDO.
DEFINE VARIABLE hKeyField AS HANDLE NO-UNDO.
DEFINE VARIABLE hDescFields AS HANDLE EXTENT 9 NO-UNDO.
DEFINE VARIABLE iLoop AS INTEGER NO-UNDO.
DEFINE VARIABLE iBuffer AS INTEGER NO-UNDO.
DEFINE VARIABLE cField AS CHARACTER NO-UNDO.
DEFINE VARIABLE cKeyValue AS CHARACTER NO-UNDO.
DEFINE VARIABLE cDescription AS CHARACTER NO-UNDO.
DEFINE VARIABLE cDescValues AS CHARACTER  EXTENT 9 NO-UNDO.
DEFINE VARIABLE cEmptyValue AS CHARACTER NO-UNDO.
DEFINE VARIABLE lOk AS LOGICAL NO-UNDO.
DEFINE VARIABLE cOldQuery AS CHARACTER NO-UNDO.
DEFINE VARIABLE cPlipName AS CHARACTER NO-UNDO.
DEFINE VARIABLE hPlipHandle AS HANDLE NO-UNDO.
DEFINE VARIABLE hTempTable AS HANDLE NO-UNDO.
DEFINE VARIABLE iExtent AS INTEGER NO-UNDO.
DEFINE VARIABLE cKeyDataType AS CHARACTER NO-UNDO.
DEFINE VARIABLE cTranslatedOption AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cDBList AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cFlagValueVar AS CHARACTER  NO-UNDO.

main-loop:
FOR EACH  ttDCombo WHERE ttDCombo.iBuildSequence < 99999
                     AND ttDCombo.cForEach > ""
                   BY ttDCombo.hViewer 
                   BY ttDCombo.iBuildSequence:
  ASSIGN 
    ttDCombo.cForEach = REPLACE(ttDCombo.cForEach,CHR(10)," ":U)
    ttDCombo.cForEach = REPLACE(ttDCombo.cForEach,CHR(12)," ":U)
    ttDCombo.cForEach = REPLACE(ttDCombo.cForEach,CHR(13)," ":U)
    hBuffer = ?
    hKeyField = ?
    cKeyValue = "":U
    ttDCombo.cKeyValues = "":U      
    ttDCombo.cDescriptionValues = "":U.

  DO iLoop = 1 TO NUM-ENTRIES(ttDCombo.cDescFieldNames):
    ASSIGN
      hDescFields[iLoop] = ?
      cDescValues[iLoop] = "":U.
  END.

  /* Create a query */
  CREATE QUERY hQuery NO-ERROR.

  buffer-loop:
  DO iLoop = 1 TO NUM-ENTRIES(ttDCombo.cBufferList):
    /* Check for TEMP-TABLES */
    IF ttDCombo.cTempTableNames <> "":U AND
       ENTRY(iLoop,ttDCombo.cTempTableNames) <> "":U THEN 
    DO:
      /* Since we are on the AppServer we do not care to run any special code
         to ensure that we run the PLIPs anywhere esle */
      cPlipName = ENTRY(iLoop,ttDCombo.cTempTableNames).
      IF cPlipName <> "":U THEN DO:
        FIND FIRST ttPLIP 
             WHERE ttPLIP.cPLIP = cPlipName
             NO-LOCK NO-ERROR.
        IF AVAILABLE ttPLIP THEN
          hPLIPHandle = ttPLIP.hHandle.
        ELSE DO:
          RUN VALUE(cPlipName) PERSISTENT SET hPLIPHandle NO-ERROR.
          CREATE ttPLIP.
          ASSIGN ttPLIP.cPLIP = cPlipName
                 ttPLIP.hHandle = hPLIPHandle.
        END.
        /* If for some reason we could not run the PLIP - just continue with the other SDFs */
        IF NOT VALID-HANDLE(hPLIPHandle) THEN
          NEXT.
        /* Check if the procedure to populate the data for the Temp Table is available in the PLIP */
        IF LOOKUP(ENTRY(iLoop,ttDCombo.cBufferList) + "Data":U,hPLIPHandle:INTERNAL-ENTRIES) = 0 THEN
          NEXT.
        RUN VALUE(ENTRY(iLoop,ttDCombo.cBufferList) + "Data":U) IN hPLIPHandle (OUTPUT hTempTable) NO-ERROR.
        /* Make sure we have a valid Temp Table */
        IF NOT VALID-HANDLE(hTempTable) OR 
           ERROR-STATUS:ERROR THEN
          NEXT.

        CREATE BUFFER hBufferList[iLoop] FOR TABLE hTempTable NO-ERROR.
      END.
    END.

    IF ttDCombo.cPhysicalTableNames <> "":U AND 
       ENTRY(iLoop,ttDCombo.cPhysicalTableNames) <> "":U THEN
      CREATE BUFFER hBufferList[iLoop] FOR TABLE TRIM(ENTRY(iLoop,ttDCombo.cPhysicalTableNames)) BUFFER-NAME ENTRY(iLoop,ttDCombo.cBufferList) NO-ERROR. 

    /* Actual DataBase Tables */
    IF NOT VALID-HANDLE(hBufferList[iLoop]) THEN
      CREATE BUFFER hBufferList[iLoop] FOR TABLE ENTRY(iLoop,ttDCombo.cBufferList) NO-ERROR.
    IF ERROR-STATUS:ERROR THEN NEXT buffer-loop.
    hQuery:ADD-BUFFER(hBufferList[iLoop]) NO-ERROR.
  END. /* buffer-loop */
  
  /* Exclude Products and Product Modules belonging to Repository
     NOTE: This should no longer be used, but is kept for backwards compatibility */
  cOldQuery = ttDCombo.cForEach.      /* This is just a backup method (??) */
  RUN processQueryClause (cBufferList, INPUT-OUTPUT ttDCombo.cForEach).

  lOk = hQuery:QUERY-PREPARE(ttDCombo.cForEach) NO-ERROR.

  IF NOT lOk THEN 
  DO:
    ttDCombo.cForEach = cOldQuery.
    RUN getDBList (INPUT ttDCombo.cForEach, OUTPUT cDBList).
    RUN removeDBPrefix (INPUT-OUTPUT ttDCombo.cForEach, cDBList).
    lOk = hQuery:QUERY-PREPARE(ttDCombo.cForEach) NO-ERROR.
  END.

  /* get handle of key field */
  ASSIGN 
    iBuffer = LOOKUP(ENTRY(1,ttDCombo.cKeyFieldName,".":U),ttDCombo.cBufferList)
    iBuffer = IF iBuffer > 0 THEN iBuffer ELSE 1  
    hBuffer = hBufferList[iBuffer].

  /* Test for arrays in key field */
  IF INDEX(ttDCombo.cKeyFieldName,"[":U) = 0 THEN
    cField = SUBSTRING(ttDCombo.cKeyFieldName,1,INDEX(ttDCombo.cKeyFieldName,"[":U) - 1).
  ELSE
    cField = ttDCombo.cKeyFieldName.
  ASSIGN
    hKeyField = hBuffer:BUFFER-FIELD(ENTRY(2, cField, ".":U))
    cKeyDataType = hKeyField:DATA-TYPE NO-ERROR.

  /* get handles of all description fields */
  DO iLoop = 1 TO NUM-ENTRIES(ttDCombo.cDescFieldNames):
    ASSIGN 
      cField = ENTRY(iLoop,ttDCombo.cDescFieldNames)    
      iBuffer = LOOKUP(ENTRY(1,cField,".":U),ttDCombo.cBufferList)
      iBuffer = IF iBuffer > 0 THEN iBuffer ELSE 1  
      hBuffer = hBufferList[iBuffer].
    IF INDEX(cField,"[":U) = 0 THEN
      cField = SUBSTRING(cField,1,INDEX(cField,"[":U) - 1).
    hDescFields[iLoop] = hBuffer:BUFFER-FIELD(ENTRY(2,cField,".":U)) NO-ERROR.
  END.

  /* Open the query */
  hQuery:QUERY-OPEN().
  hQuery:GET-FIRST() NO-ERROR.
  REPEAT WHILE hBufferList[1]:AVAILABLE:
    cKeyValue = "":U.    
    DO iLoop = 1 TO 9:
      cDescValues[iLoop] = "":U.
    END.

    IF INDEX(ttDCombo.cKeyFieldName,"[":U) = 0 THEN
      cKeyValue = RIGHT-TRIM(STRING(hKeyField:BUFFER-VALUE,ttDCombo.cKeyFormat)) NO-ERROR. 
    ELSE DO:
      iExtent = INTEGER(RIGHT-TRIM(TRIM(SUBSTRING(ttDCombo.cKeyFieldName,INDEX(ttDCombo.cKeyFieldName,"[":U),LENGTH(ttDCombo.cKeyFieldName)),"["),"]")) NO-ERROR.
      IF iExtent = ? OR iExtent = 0 THEN
        iExtent = 1.
      cKeyValue = TRIM(STRING(hKeyField:BUFFER-VALUE[iExtent],ttDCombo.cKeyFormat)) NO-ERROR. 
    END.
    IF cKeyValue = ? THEN
      cKeyValue = "?":U.

    cKeyValue = REPLACE(cKeyValue, ttDCombo.cListItemDelimiter, "":U).     
    cKeyValue = formattedValue(cKeyValue,cKeyDataType,ttDCombo.cKeyFormat).
    /* get values of all fields */
    DO iLoop = 1 TO NUM-ENTRIES(ttDCombo.cDescFieldNames):
      IF INDEX(ENTRY(iLoop,ttDCombo.cDescFieldNames),"[":U) = 0 THEN
        cDescValues[iLoop] = STRING(hDescFields[iLoop]:BUFFER-VALUE) NO-ERROR.
      ELSE DO:
        iExtent = INTEGER(RIGHT-TRIM(TRIM(SUBSTRING(ENTRY(iLoop,ttDCombo.cDescFieldNames),INDEX(ENTRY(iLoop,ttDCombo.cDescFieldNames),"[":U),LENGTH(ENTRY(iLoop,ttDCombo.cDescFieldNames))),"["),"]")) NO-ERROR.
        IF iExtent = ? OR iExtent = 0 THEN
          iExtent = 1.
        cDescValues[iLoop] = STRING(hDescFields[iLoop]:BUFFER-VALUE[iExtent]) NO-ERROR. 
      END.
      IF cDescValues[iLoop] = ? THEN
        cDescValues[iLoop] = "?":U.
      cDescValues[iLoop] = REPLACE(cDescValues[iLoop], ttDCombo.cListItemDelimiter, " ":U).
    END.

    /* Build description from list of description values */
    IF ttDCombo.cDescSubstitute = "":U THEN
    DO iLoop = 1 TO NUM-ENTRIES(ttDCombo.cDescFieldNames):
      ttDCombo.cDescSubstitute = ttDCombo.cDescSubstitute + 
               (IF ttDCombo.cDescSubstitute = "":U THEN "":U ELSE " / ":U) + "&":U + STRING(iLoop).
    END.
    DO ON STOP UNDO, LEAVE:
      ASSIGN 
        cDescription = SUBSTITUTE(ttDCombo.cDescSubstitute,cDescValues[1],cDescValues[2],cDescValues[3],cDescValues[4],cDescValues[5],cDescValues[6],cDescValues[7],cDescValues[8],cDescValues[9])
        ttDCombo.cListItemPairs = ttDCombo.cListItemPairs +
                   (IF ttDCombo.cListItemPairs > "" THEN ttDCombo.cListItemDelimiter ELSE "") +
                   cDescription + ttDCombo.cListItemDelimiter + cKeyValue
        NO-ERROR.
    END.
    IF ERROR-STATUS:ERROR THEN
    DO:
      ttDCombo.cListItemPairs = ERROR-STATUS:GET-MESSAGE(1) + 
                                ttDcombo.cListItemDelimiter + "<ERROR>":U .
      NEXT main-loop.
    END.

    hQuery:GET-NEXT().
  END.  /* query loop */
  
  /* Now run through the flags and put put in the extra values */
  CASE ttDCombo.cFlag:
    WHEN "N" THEN /* blank is a none option */
      cTranslatedOption = "<None>":U.
    WHEN "A" THEN /* blank is an all option */
      cTranslatedOption = "<All>":U.
    OTHERWISE
      cTranslatedOption = ?.
  END CASE.

  IF cTranslatedOption <> ? THEN
  DO:
    CASE ttDCombo.cWidgetType:
      WHEN "Character":U THEN cEmptyValue = ".":U.
      WHEN "Decimal":U   THEN cEmptyValue = "0":U.
      WHEN "Integer":U   THEN cEmptyValue = "0":U.
      WHEN "Date":U      THEN cEmptyValue = "?":U.
      OTHERWISE               cEmptyValue = "0":U.
    END CASE.
    IF VALID-HANDLE(gshTranslationManager) THEN
      cTranslatedOption = DYNAMIC-FUNCTION("translatePhrase":U IN gshTranslationManager,
                                           INPUT cTranslatedOption,
                                           INPUT 0).
    cFlagValueVar = IF ttDCombo.cWidgetType = "Decimal" THEN
                      REPLACE(ttDCombo.cFlagValue,".":U,SESSION:NUMERIC-DECIMAL-POINT)
                    ELSE ttDCombo.cFlagValue.
    cEmptyValue = formattedValue(cFlagValueVar,cKeyDataType,ttDCombo.cKeyFormat).
    ASSIGN
      ttDCombo.cListItemPairs = cTranslatedOption 
                              + ttDCombo.cListItemDelimiter
                              + cEmptyValue 
                              + (IF ttDCombo.cListItemPairs > "" 
                                 THEN ttDCombo.cListItemDelimiter 
                                 ELSE "")
                              + ttDCombo.cListItemPairs.
  END.

  /* Make sure that the string contains PAIRS */ 
  IF ttDCombo.cListItemPairs = "":U OR 
     NUM-ENTRIES(ttDCombo.cListItemPairs, ttDCombo.cListItemDelimiter) MOD 2 <> 0 
  THEN
    ttDCombo.cListItemPairs = ttDCombo.cListItemDelimiter.

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
  DEFINE VARIABLE hQuery             AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hBufferList        AS HANDLE EXTENT 20 NO-UNDO.
  DEFINE VARIABLE hBuffer            AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hReturnFields      AS HANDLE EXTENT 50 NO-UNDO.
  DEFINE VARIABLE iLoop              AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iBuffer            AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cField             AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cRowid             AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cValue             AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cPlipName          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hPlipHandle        AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hTempTable         AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cFoundValue2       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cReturnField2      AS CHARACTER  NO-UNDO.
  
  FOR EACH  ttLookup WHERE ttLookup.cForEach > "" BY ttLookup.hViewer:
    ASSIGN ttLookup.cForEach = REPLACE(ttLookup.cForEach,CHR(10)," ":U)
           ttLookup.cForEach = REPLACE(ttLookup.cForEach,CHR(12)," ":U)
           ttLookup.cForEach = REPLACE(ttLookup.cForEach,CHR(13)," ":U).
   

    /* Reset list item pairs and current value in case being re-run for some reason, plus field handles */
    ASSIGN
      ttLookup.cFoundDataValues = "":U
      ttLookup.lMoreFound = FALSE
      ttLookup.cRowIdent = "":U
      hBuffer = ?.

    DO iLoop = 1 TO NUM-ENTRIES(ttLookup.cFieldList):
      hReturnFields[iLoop] = ?.
    END.

    /* Create a query */
    CREATE QUERY hQuery NO-ERROR.
  
    DO iLoop = 1 TO NUM-ENTRIES(ttLookup.cBufferList):
      /* Check for TEMP-TABLES */
      IF ttLookup.cTempTableNames <> "":U THEN 
      DO:
        cPlipName = ENTRY(iLoop,ttLookup.cTempTableNames).
        IF cPlipName <> "":U THEN 
        DO:
          FIND FIRST ttPLIP WHERE ttPLIP.cPLIP = cPlipName
                            NO-LOCK NO-ERROR.
          IF AVAILABLE ttPLIP THEN
            hPLIPHandle = ttPLIP.hHandle.
          ELSE DO:
            RUN VALUE(cPlipName) PERSISTENT SET hPLIPHandle NO-ERROR.
            CREATE ttPLIP.
            ASSIGN ttPLIP.cPLIP   = cPlipName
                   ttPLIP.hHandle = hPLIPHandle.
          END.
          RUN VALUE(ENTRY(iLoop,ttLookup.cBufferList) + "Data":U) IN hPLIPHandle (OUTPUT hTempTable) NO-ERROR.

          /* Make sure we have a valid Temp Table */
          IF NOT VALID-HANDLE(hTempTable) OR ERROR-STATUS:ERROR THEN
            NEXT.

          /* Now create the buffer handle */
          CREATE BUFFER hBufferList[iLoop] FOR TABLE hTempTable NO-ERROR.
        END.
      END.
      /* Check for BUFFERS */
      IF ttLookup.cPhysicalTableNames <> "":U AND 
         ENTRY(iLoop,ttLookup.cPhysicalTableNames) <> "":U THEN
        CREATE BUFFER hBufferList[iLoop] FOR TABLE TRIM(ENTRY(iLoop,ttLookup.cPhysicalTableNames)) 
                      BUFFER-NAME ENTRY(iLoop,ttLookup.cBufferList) NO-ERROR. 

      /* Actual DataBase Tables */
      IF NOT VALID-HANDLE(hBufferList[iLoop]) THEN
        CREATE BUFFER hBufferList[iLoop] FOR TABLE ENTRY(iLoop,ttLookup.cBufferList) NO-ERROR.

      IF ERROR-STATUS:ERROR THEN NEXT.
      hQuery:ADD-BUFFER(hBufferList[iLoop]).
    END. /* buffer-loop */

    /* Exclude Products and Product Modules belonging to Repository
       NOTE: This should no longer be used, but is kept for backwards compatibility */
    RUN processQueryClause (cBufferList, INPUT-OUTPUT ttLookup.cForEach).
  
    DO iLoop = 1 TO NUM-ENTRIES(ttLookup.cFieldList):
      ASSIGN 
        cField = ENTRY(iLoop,ttLookup.cFieldList)   
        iBuffer = LOOKUP(ENTRY(1,cField,".":U),ttLookup.cBufferList).
      IF iBuffer > 0 THEN
        hBuffer = hBufferList[iBuffer].
      ELSE
        hBuffer = hBufferList[1].
      hReturnFields[iLoop] = hBuffer:BUFFER-FIELD(ENTRY(2,cField,".":U)) NO-ERROR.
    END.
    hQuery:QUERY-PREPARE(ttLookup.cForEach).
    hQuery:QUERY-OPEN().
    hQuery:GET-FIRST() NO-ERROR.
    IF hBufferList[1]:AVAILABLE THEN 
    DO:
      DO iLoop = 1 TO NUM-ENTRIES(ttLookup.cFieldList):
        cValue = RIGHT-TRIM(STRING(hReturnFields[iLoop]:BUFFER-VALUE)) NO-ERROR.
        IF cValue = ? THEN
          ASSIGN cValue = "?":U.
        ASSIGN 
          ttLookup.cFoundDataValues = ttLookup.cFoundDataValues +
                                      (IF iLoop = 1 THEN "":U ELSE CHR(1)) +
                                      cValue.
      END.
      /* Store rowids of buffers */
      DO iLoop = 1 TO NUM-ENTRIES(ttLookup.cBufferList):
        ttLookup.cRowIdent = ttLookup.cRowIdent +
                             (IF iLoop = 1 THEN "":U ELSE ",":U) +
                             STRING(hBufferList[iLoop]:ROWID).
      END.
    END.
    
    /* Check if more records could be found */
    hQuery:GET-NEXT() NO-ERROR.
    IF hBufferList[1]:AVAILABLE THEN
    DO:
      ASSIGN
        cFoundValue2        = ENTRY(2,ttLookup.cFoundDataValues,CHR(1))
        cReturnField2       = STRING(hReturnFields[2]:BUFFER-VALUE).

      /* Check for ambiguous on find */
      IF ttLookup.lPopupOnAmbiguous AND
         ttLookup.cScreenValue <> "":U AND
         (cReturnField2 = ttLookup.cScreenValue OR
          cFoundValue2 <> ttLookup.cScreenValue)
      THEN
        ttLookup.lMoreFound = TRUE.

      IF ttLookup.lPopupOnUniqueAmbiguous AND
         cFoundValue2 = SUBSTRING(cReturnField2, 1 ,LENGTH(cFoundValue2))
      THEN
        ttLookup.lMoreFound = TRUE.

      /* If we are not supposed to auto popup on ambiguous, but the user entered
         's' and we have more than one record starting with 's' we should not 
         assign a value - we should leave it as an invalid value and allow the 
         bussiness logic to take care of it */
      IF NOT ttLookup.lMoreFound AND
         ttLookup.cScreenValue <> "":U AND
         ttLookup.lPopupOnAmbiguous = FALSE AND
         SUBSTRING(cReturnField2, 1, LENGTH(ttLookup.cScreenValue)) = ttLookup.cScreenValue AND
         LENGTH(cFoundValue2) <> LENGTH(ttLookup.cScreenValue)
      THEN DO:
        ASSIGN ttLookup.lMoreFound = FALSE
               ttLookup.cFoundDataValues = ?.
      END.
    END.

    /* clean up dynamic objects */
    hQuery:QUERY-CLOSE() NO-ERROR.
    DELETE OBJECT hQuery NO-ERROR.
    hQuery = ?.
    DO iLoop = 1 TO NUM-ENTRIES(ttLookup.cBufferList):
      DELETE OBJECT hBufferList[iLoop] NO-ERROR.
      hBufferList[iLoop] = ?.
    END. 
  END.  /* FOR EACH ttLookup: */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-processQueryClause) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE processQueryClause Procedure 
PROCEDURE processQueryClause :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT         PARAMETER pcBufferList AS CHARACTER  NO-UNDO.
DEFINE INPUT-OUTPUT  PARAMETER pcQuery      AS CHARACTER  NO-UNDO.

DEFINE VARIABLE rRowid         AS ROWID NO-UNDO.
DEFINE VARIABLE cProfileData   AS CHARACTER NO-UNDO.
DEFINE VARIABLE lDisplayRepository AS LOGICAL NO-UNDO.
DEFINE VARIABLE cProduct       AS CHARACTER NO-UNDO.
DEFINE VARIABLE cProductModule AS CHARACTER NO-UNDO.
DEFINE VARIABLE iPrLoop        AS INTEGER NO-UNDO.
DEFINE VARIABLE cDBList        AS CHARACTER  NO-UNDO.

  /* Exclude Products and Product Modules belonging to Repository
     NOTE: This should no longer be used, but is kept (for now) for backwards compatibility */
  IF INDEX(pcQuery,"[EXCLUDE_REPOSITORY_PRODUCTS]":U) > 0 OR 
     INDEX(pcQuery,"[EXCLUDE_REPOSITORY_PRODUCT_MODULES]":U) > 0 THEN 
  DO:
    /* Display Repository?  */
    ASSIGN rRowid = ?.
    RUN getProfileData IN gshProfileManager ( INPUT "General":U,
                                              INPUT "DispRepos":U,
                                              INPUT "DispRepos":U,
                                              INPUT NO,
                                              INPUT-OUTPUT rRowid,
                                              OUTPUT cProfileData).
    ASSIGN 
      lDisplayRepository = (cProfileData EQ "YES":U)
      rRowID = ?.

    /* Add Product Exclusion */
    IF NOT lDisplayRepository AND 
       INDEX(pcQuery,"[EXCLUDE_REPOSITORY_PRODUCTS]":U) > 0 AND
       LOOKUP("gsc_product":U,pcBufferList) > 0 THEN 
    DO:
      pcQuery = REPLACE(pcQuery,"[EXCLUDE_REPOSITORY_PRODUCTS]":U,"TRUE":U).
      DO iPrLoop = 1 TO NUM-ENTRIES("{&REPOSITORY-PRODUCTS}":U):
        cProduct = TRIM(ENTRY(iPrLoop,"{&REPOSITORY-PRODUCTS}":U)).
        IF cProduct = "":U THEN
          NEXT.
        pcQuery = DYNAMIC-FUNCTION("newWhereClause",
                                     "gsc_product":U,
                                     "gsc_product.product_code <> '" + cProduct + "'",
                                     pcQuery,
                                     "AND":U).
      END.
    END.

    /* Add Product Module Exclusion */
    IF NOT lDisplayRepository AND 
       INDEX(pcQuery,"[EXCLUDE_REPOSITORY_PRODUCT_MODULES]":U) > 0 AND
       LOOKUP("gsc_product_module":U,pcBufferList) > 0 THEN 
    DO:
      pcQuery = REPLACE(pcQuery,"[EXCLUDE_REPOSITORY_PRODUCT_MODULES]":U,"TRUE":U).
      DO iPrLoop = 1 TO NUM-ENTRIES("{&REPOSITORY-MODULES}":U):
        cProduct = TRIM(ENTRY(iPrLoop,"{&REPOSITORY-MODULES}":U)).
        IF cProduct = "":U THEN
          NEXT.
        pcQuery = DYNAMIC-FUNCTION("newWhereClause",
                                     "gsc_product_module":U,
                                     "NOT gsc_product_module.product_module_code BEGINS '" + cProduct + "'",
                                     pcQuery,
                                     "AND":U).
      END.
      pcQuery = pcQuery.
    END.
    IF lDisplayRepository THEN
      ASSIGN pcQuery = REPLACE(pcQuery,"[EXCLUDE_REPOSITORY_PRODUCTS]":U,"TRUE":U)
             pcQuery = REPLACE(pcQuery,"[EXCLUDE_REPOSITORY_PRODUCT_MODULES]":U,"TRUE":U).
  END.

  /* Prepare the query */
  RUN getDBList (INPUT pcQuery, OUTPUT cDBList).
  RUN removeDBPrefix (INPUT-OUTPUT pcQuery, cDBList).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-removeDBPrefix) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE removeDBPrefix Procedure 
PROCEDURE removeDBPrefix :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT-OUTPUT PARAMETER pcQuery   AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER       pcDBList  AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE iLoop   AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cDBName AS CHARACTER  NO-UNDO.

  DO iLoop = 1 TO NUM-ENTRIES(pcDBList):
    cDBName = ENTRY(iLoop,pcDBList).
    pcQuery = REPLACE(pcQuery,(cDBName + ".":U),"":U).
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-formattedValue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION formattedValue Procedure 
FUNCTION formattedValue RETURNS CHARACTER
  (pcValue    AS CHARACTER,
   pcDataType AS CHARACTER,
   pcFormat   AS CHARACTER) :
/*------------------------------------------------------------------------------
  Purpose: Return the formatted value of a passed value according to the 
           SmartSelect/Dynamic Combo/Dynamic Lookup/SDF format. 
Parameter: pcValue - The value that need to be formatted.      
    Notes: Used internally in order to ensure that unformatted data can be 
           applied to screen-value (setDataValue) or used as lookup in
           list-item-pairs in (getDisplayValue)  
           This code was moved from select.p into field.p to accomodate
           dynamic lookups and combos, but since we cannot use this function
           in field.p when running AppServer (since the handle to the SDF is 
           invalid during AppSever mode we had to create this function here too)
------------------------------------------------------------------------------*/
  /* Invalid Format */
  IF pcFormat = "":U OR pcFormat = ? OR pcFormat = "?":U THEN
    RETURN pcValue.
  IF pcDataType = "":U OR pcDataType = ? OR pcDataType = "?":U THEN
    RETURN pcValue.

  CASE pcDataType:
    WHEN 'CHARACTER':U THEN
      pcValue = RIGHT-TRIM(STRING(pcValue,pcFormat)).
    WHEN 'DATE':U THEN
      pcValue = STRING(DATE(pcValue),pcFormat).
    WHEN 'DECIMAL':U THEN
      pcValue = STRING(DECIMAL(pcValue),pcFormat).
    WHEN 'INTEGER':U THEN
      pcValue = STRING(INT(pcValue),pcFormat).
    WHEN 'LOGICAL':U THEN
      pcValue = ENTRY(IF CAN-DO('yes,true':U,pcValue) THEN 1 ELSE 2,
                       pcFormat,'/':U).
  END CASE.
  
  RETURN pcValue.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

