&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Definition Comments Wizard" Include _INLINE
/* Actions: ? af/cod/aftemwizcw.w ? ? ? */
/* Program Definition Comment Block Wizard
Welcome to the Program Definition Comment Block Wizard. Press Next to proceed.
af/cod/aftemwizpw.w
*/
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Include 
/*********************************************************************
* Copyright (C) 2002 by Progress Software Corporation ("PSC"),       *
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
  File: ryuimbl.i

  Description:  UIM Business Logic Processor

  Purpose:

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:           0   UserRef:    
                Date:   06/13/2002  Author:     

  Update Notes: Created from Template ryteminclu.i

---------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* object identifying preprocessor */
/* &glob   AstraInclude    yes  */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD appendLookupData Include 
FUNCTION appendLookupData RETURNS CHARACTER
  ( pcLogicalObjectName AS CHARACTER,
    pcSDOName AS CHARACTER,
    pcSDOCols AS CHARACTER,
    pcSDOValues AS CHARACTER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD changeParentInParentChildInfo Include 
FUNCTION changeParentInParentChildInfo RETURNS LOGICAL
  ( pcLogicalObjectName AS CHARACTER,
    pcSDOName AS CHARACTER,
    pcOldParentSDOName AS CHARACTER,
    pcNewParentSDOName AS CHARACTER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD clearDSContext Include 
FUNCTION clearDSContext RETURNS LOGICAL
  ( pcLogicalObjectName AS CHARACTER,
    pcDSName AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD createSDOLinks Include 
FUNCTION createSDOLinks RETURNS LOGICAL
  ( pcLogicalObjectName AS CHARACTER,
    pcDSName AS CHARACTER,
    pcParentSDOName AS CHARACTER,
    pcForeignFields AS CHARACTER,
    pcSDOEvent AS CHARACTER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD escapeData Include 
FUNCTION escapeData RETURNS CHARACTER
  (pcData AS CHARACTER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD findMasterSDOInSBO Include 
FUNCTION findMasterSDOInSBO RETURNS CHARACTER
  ( pcDSName AS CHARACTER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD findSDOHandleInSBO Include 
FUNCTION findSDOHandleInSBO RETURNS HANDLE
  ( pcLogicalObjectName AS CHARACTER,
    pcSBOName AS CHARACTER,
    phSBOHandle AS HANDLE,
    pcSDOName AS CHARACTER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD findSDOPosition Include 
FUNCTION findSDOPosition RETURNS INTEGER
  ( pcSDOName AS CHARACTER,
    phSDOHandle AS HANDLE)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getDSHandle Include 
FUNCTION getDSHandle RETURNS HANDLE
  ( INPUT pcDSName AS CHARACTER,
    INPUT pcDSPath AS CHARACTER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getLookupValue Include 
FUNCTION getLookupValue RETURNS CHARACTER
  ( pcQueryTables AS CHARACTER,
    pcQueryString AS CHARACTER,
    pcFieldValue AS CHARACTER,
    pcKeyField AS CHARACTER, 
    pcKeyDataType AS CHARACTER,
    pcDisplayField AS CHARACTER,
    pcLinkedFields AS CHARACTER,
    pcDataDelimiter AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getPassThruSDOInfo Include 
FUNCTION getPassThruSDOInfo RETURNS CHARACTER
  (piEntryNumber AS INTEGER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getSavedContainerProperty Include 
FUNCTION getSavedContainerProperty RETURNS CHARACTER
  (pcLogicalObjectName AS CHARACTER,
   pcPropertyName AS CHARACTER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getSavedDSContext Include 
FUNCTION getSavedDSContext RETURNS CHARACTER
  ( pcLogicalObjectName AS CHARACTER,
    pcDSName AS CHARACTER,
    pcDSType AS CHARACTER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getSavedDSDataDelimiter Include 
FUNCTION getSavedDSDataDelimiter RETURNS CHARACTER
  (pcLogicalObjectName AS CHARACTER,
   pcDSName AS CHARACTER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getSavedDSPath Include 
FUNCTION getSavedDSPath RETURNS CHARACTER
  ( pcDSName AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getSavedDSProperty Include 
FUNCTION getSavedDSProperty RETURNS CHARACTER
  (pcLogicalObjectName AS CHARACTER,
   pcDSName AS CHARACTER,
   pcPropertyName AS CHARACTER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getSavedDynamicDSInfo Include 
FUNCTION getSavedDynamicDSInfo RETURNS CHARACTER
  ( pcDSName AS CHARACTER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getSDODataColumns Include 
FUNCTION getSDODataColumns RETURNS CHARACTER
  ( pcLogicalObjectName AS CHARACTER,
    phSDOHandle AS HANDLE,
    plUpdatable AS LOGICAL)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD handleErrors Include 
FUNCTION handleErrors RETURNS LOGICAL
  (pcLogicalObjectName AS CHARACTER,
   pcSBOName AS CHARACTER,
   pcSDOName AS CHARACTER,
   pcSDOEvent AS CHARACTER,
   pcError AS CHARACTER,
   pcErrorRowId AS CHARACTER,
   pcMarkColumn AS CHARACTER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD includeSDOChildren Include 
FUNCTION includeSDOChildren RETURNS LOGICAL
  ( pcLogicalObjectName AS CHARACTER,
    pcParentSDOName AS CHARACTER,
    pcSDOEvent AS CHARACTER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD outputSDOData Include 
FUNCTION outputSDOData RETURNS INTEGER
  ( pcLogicalObjectName AS CHARACTER,
    pcSDOName AS CHARACTER,
    plExportData AS LOGICAL)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD outputSDOFooter Include 
FUNCTION outputSDOFooter RETURNS LOGICAL
  ( pcLogicalObjectName AS CHARACTER,
    pcSDOName AS CHARACTER,
    pcBatchNum AS CHARACTER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD outputSDOHeader Include 
FUNCTION outputSDOHeader RETURNS LOGICAL
  ( pcLogicalObjectName AS CHARACTER,
    pcSDOName AS CHARACTER,
    plExportData AS LOGICAL)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD populateDSLinks Include 
FUNCTION populateDSLinks RETURNS LOGICAL
  ( pcLogicalObjectName AS CHARACTER, 
    pcRequestEvents  AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD returnConflict Include 
FUNCTION returnConflict RETURNS LOGICAL
  ( pcLogicalObjectName AS character,
    pcSDOName AS CHARACTER,
    pcDataColumns AS CHARACTER,
    pcData AS CHARACTER,
    phSDO AS HANDLE)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD saveContainerProperty Include 
FUNCTION saveContainerProperty RETURNS LOGICAL
  (pcLogicalObjectName AS CHARACTER,
   pcPropertyName AS CHARACTER,
   pcPropertyValue AS CHARACTER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD saveDSContext Include 
FUNCTION saveDSContext RETURNS LOGICAL
  ( pcLogicalObjectName AS CHARACTER,
    pcSDOList AS CHARACTER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD saveDSPath Include 
FUNCTION saveDSPath RETURNS LOGICAL
  ( pcDSName AS CHARACTER,
    pcDSPath AS CHARACTER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD saveDSProperty Include 
FUNCTION saveDSProperty RETURNS LOGICAL
  (pcLogicalObjectName AS CHARACTER,
   pcDSName AS CHARACTER,
   pcPropertyName AS CHARACTER,
   pcPropertyValue AS CHARACTER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD saveDSSecurity Include 
FUNCTION saveDSSecurity RETURNS LOGICAL
  (pcLogicalObjectName AS CHARACTER,
   pcDSName AS CHARACTER,
   pcPropertyValue AS CHARACTER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD saveDynamicDSInfo Include 
FUNCTION saveDynamicDSInfo RETURNS LOGICAL
  ( pcDSName AS CHARACTER,
    pcDynamicSDOInfo AS CHARACTER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setChildSDOInfo Include 
FUNCTION setChildSDOInfo RETURNS LOGICAL
  (pcLogicalObjectName AS CHARACTER,
   pcSDOName AS CHARACTER,
   pcParentSDOName AS CHARACTER,
   pcForeignFields AS CHARACTER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setDSHandle Include 
FUNCTION setDSHandle RETURNS LOGICAL
  ( INPUT pcDSName AS CHARACTER,
    INPUT pcDSPath AS CHARACTER,
    INPUT phDS AS HANDLE)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD traverseAndBuildDSList Include 
FUNCTION traverseAndBuildDSList RETURNS CHARACTER
  (pcSDOList AS CHARACTER,
   pcParentSDOName AS CHARACTER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Include
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: INCLUDE-ONLY
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Include ASSIGN
         HEIGHT             = 21.76
         WIDTH              = 58.2.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE createLinksInContainer Include 
PROCEDURE createLinksInContainer :
/*------------------------------------------------------------------------------
  Purpose:     process the links and establish the links for SDO data fetch.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcLogicalObjectName AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pcRequestEvents     AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pcSDOList           AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE cChildSDOName              AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cContext                   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hChild                     AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hParent                    AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hProcedure                 AS HANDLE     NO-UNDO.
  DEFINE VARIABLE i1                         AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cLinkedSBOs                AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cChildSBOName              AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cOnlyChildSDOName          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDSName                    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cOverrideLogicalObjectName AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cChildDSName               AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDSType                    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hSDO                       AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cSDOName                   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSDOs                      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cParentSDOName             AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cForeignFields             AS CHARACTER  NO-UNDO.

  hParent = ?.

  /* Start the container */
  IF NOT VALID-HANDLE(ghSDOContainer) THEN
    RUN adm2/dyncontainer.w PERSISTENT SET ghSDOContainer NO-ERROR.

  REPEAT i1 = 1 TO NUM-ENTRIES(pcSDOList,",":U):
    ASSIGN cChildDSName  = ENTRY(i1, pcSDOList, ",":U).

    /* This is a SDO in a SBO start SBO which will start the SDO's */
    IF (NUM-ENTRIES(cChildDSName, ".":U) > 1 ) THEN
    DO:
      ASSIGN cChildSBOName = ENTRY(1, cChildDSName, ".":U)
             cChildSDOName = ENTRY(2, cChildDSName, ".":U)
             cDSName = cChildSBOName
             cDSType = 'SBO':U.

      IF ( LOOKUP(cChildSBOName, cLinkedSBOs, ",":U) > 0 )  THEN
        NEXT.
      ELSE
        ASSIGN cLinkedSBOs = cLinkedSBOs + "," + cChildSBOName
               cLinkedSBOs = TRIM(cLinkedSBOs, ",":U).
    END.
    ELSE
    DO:
      ASSIGN cChildSBOName = '':U
             cChildSDOName = cChildDSName
             cDSType = 'SDO':U
             cDSName = cChildSDOName.
    END.
    
    FIND FIRST ttSDOLink NO-LOCK
       WHERE ttSDOLink.SDOName = cChildDSName NO-ERROR.
    IF NOT AVAILABLE ttSDOLink THEN NEXT.

    IF (ttSDOLink.ParentSDOName = "":U) THEN
      hParent = ?.

    /* If the data needs to be fetched for some other container do the override stuff */
    ASSIGN 
      cOverrideLogicalObjectName = get-value('d':U + cChildSDOName + '._object':U)
      cOverrideLogicalObjectName = TRIM(cOverrideLogicalObjectName, "|":U)
      cOverrideLogicalObjectName = TRIM(cOverrideLogicalObjectName).
    
    IF (cOverrideLogicalObjectName = ? OR cOverrideLogicalObjectName = "":U) THEN
      cOverrideLogicalObjectName = pcLogicalObjectName.

    cContext = getSavedDSContext(cOverrideLogicalObjectName, cDSName, cDSType).

    IF (cContext = ? OR cContext = "":U ) THEN
      cContext = getSavedDynamicDSInfo(cDSName).

    ASSIGN cParentSDOName = "":U
           cForeignFields = "":U.

    RUN getParentDS( INPUT cOverrideLogicalObjectName, 
                      INPUT cChildDSName, 
                     OUTPUT cParentSDOName, 
                     OUTPUT cForeignFields) NO-ERROR.

    IF ( cParentSDOName > "":U AND cParentSDOName <> "master") THEN
      hParent = getDSHandle(cParentSDOName, "":U).
    ELSE
      hParent = ?.

    logNote("note", "adding: " + cDSName + " with parent: " + cParentSDOName + " and foreign fields: " + cForeignFields).
    hChild = DYNAMIC-FUNCTION('addDataObject':U IN ghSDOContainer,
                               getSavedDSPath(cDSName),
                               cDSName,
                               hParent, cForeignFields, 
                               cContext).
    
    IF ( cChildSBOName > '':U) THEN
    DO:
      cSDOs = TRIM(DYNAMIC-FUNCTION("getContainedDataObjects":U IN hChild)) NO-ERROR.
      DO i1 = 1 TO NUM-ENTRIES(cSDOs):
        ASSIGN hSDO     = WIDGET-HANDLE(ENTRY(i1, cSDOs, ",":U))
               cSDOName = DYNAMIC-FUNCTION("getObjectName":U IN hSDO ).
        DYNAMIC-FUNCTION('setDataReadHandler' IN hSDO, THIS-PROCEDURE).
        DYNAMIC-FUNCTION('setOpenOnInit' IN hSDO, FALSE).
        DYNAMIC-FUNCTION('setDataReadColumns' IN hSDO, getSDODataColumns(cOverrideLogicalObjectName, hSDO, NO)).
        DYNAMIC-FUNCTION('setDataDelimiter':U IN hSDO, getSavedDSDataDelimiter(cOverrideLogicalObjectName, cChildSDOName)).
        DYNAMIC-FUNCTION('setDataReadFormat':U IN hSDO, 'Formatted':U).
        DYNAMIC-FUNCTION('setObjectName':U IN hSDO, cChildSBOName + ".":U + cSDOName).
      END.
    END.
    ELSE
    DO:
      DYNAMIC-FUNCTION('setDataReadHandler' IN hChild, THIS-PROCEDURE).
      DYNAMIC-FUNCTION('setDataReadColumns' IN hChild, getSDODataColumns(cOverrideLogicalObjectName, hChild, NO)).
      DYNAMIC-FUNCTION('setDataDelimiter':U IN hChild, getSavedDSDataDelimiter(cOverrideLogicalObjectName, cChildSDOName)).
      DYNAMIC-FUNCTION('setDataReadFormat':U IN hChild, 'Formatted':U).
    END.

    /* Store the SDO handle */
    setDSHandle(cDSName, ?, hChild).
    hParent = hChild.

  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getParentDS Include 
PROCEDURE getParentDS :
/*------------------------------------------------------------------------------
  Purpose: Find the Parent SDO info from either the Context or the input data. 
    Notes: 
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcLogicalObjectName AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pcChildSDOName      AS CHARACTER  NO-UNDO.
  DEFINE OUTPUT PARAMETER pcParentSDOName     AS CHARACTER  NO-UNDO.
  DEFINE OUTPUT PARAMETER pcForeignFields     AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE cChildParamName  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cParentParamName AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cParentString    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE i1               AS INTEGER    NO-UNDO.

  cParentParamName = pcLogicalObjectName + ".parent_":U + pcChildSDOName.
  cParentString = get-value(cParentParamName).

  IF ( cParentString = ? OR cParentString = "":U) THEN
    cParentString =  DYNAMIC-FUNCTION("getPropertyList":U IN gshSessionManager,
                       INPUT cParentParamName, INPUT NO).

  IF ( cParentString > "":U) THEN
  DO:
    pcParentSDOName = ENTRY( NUM-ENTRIES(cParentString, ",":U), cParentString, ",":U) NO-ERROR.

    /* If this is a pass thru' link then the SDO name will be master */
    IF (pcParentSDOName = 'master':U AND getPassThruSDOInfo(1) > "":U) THEN
    DO:
      pcParentSDOName = getPassThruSDOInfo(1).
      changeParentInParentChildInfo(pcLogicalObjectName, pcChildSDOName, 'master':U, pcParentSDOName).
    END.

    REPEAT i1 = 1 TO (NUM-ENTRIES(cParentString, ",":U) - 1):
      pcForeignFields = pcForeignFields + "," + ENTRY(i1, cParentString, ",":U).
    END.
    pcForeignFields = TRIM(pcForeignFields, ",":U).
  END.
  IF (pcForeignFields = ? OR pcForeignFields = "") THEN
    ASSIGN pcForeignFields = "".

  IF (pcParentSDOName = ? OR pcParentSDOName = "") THEN
    ASSIGN pcParentSDOName = "".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeRequest Include 
PROCEDURE initializeRequest :
/*------------------------------------------------------------------------------
  Purpose:     To load values from client request into session/context data
  Parameters:  <none>
  Notes:       - This is specifically code for the Complex HTML client type
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cAllEntries AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cAllValues  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cProperties AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cValue      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iCount      AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cExportData AS CHARACTER  NO-UNDO.
  
  /* Initialize Global values and clear temp-tables */
  EMPTY TEMP-TABLE ttSDOFieldsUsed.
  EMPTY TEMP-TABLE ttObjAttr.

  ASSIGN
    cExportData          = get-value('export':U)
    glExportData         = (cExportData > '':U)
    gcRequestEvents      = get-value('do':U)   
    glNeedToDoUI         = (gcRequestEvents = '' OR gcRequestEvents = ?)
    glDoMainMenu         = FALSE
    cProperties          = DYNAMIC-FUNCTION("getPropertyList":U IN gshSessionManager,
                             "currentUserObj,currentLanguageObj,BaseHref":U, YES)
    gdCurrentUserObj     = DECIMAL(ENTRY(1, cProperties, CHR(3)))
    gdCurrentLanguageObj = DECIMAL(ENTRY(2, cProperties, CHR(3))) 
    gcBaseHref           = ENTRY(3, cProperties, CHR(3)) 
    NO-ERROR.

  /* Move get-value() into temp-tables. */
  /* Copy request data into session/context data... */
  ASSIGN
    cAllEntries = get-value(?).

  DO iCount = 1 TO NUM-ENTRIES(cAllEntries):
    /* DHTML client returns values in pipe ('|') delimited lists, always 
       with the first entry blank (for client-side performance) so here
       we remove the first entry */
    ASSIGN
      cValue     = TRIM(get-value(ENTRY(iCount, cAllEntries)))
      cAllValues = cAllValues + (IF iCount = 1 THEN "" ELSE CHR(3)) + 
        IF SUBSTRING(cValue, 1, 1) = "|" THEN SUBSTRING(cValue, 2) ELSE cValue.
      
  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE prepareQueryForFilterAndFind Include 
PROCEDURE prepareQueryForFilterAndFind :
/*------------------------------------------------------------------------------
  Purpose:     This procedure will prepare the query for filter and Find finctions
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcParseString         AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER phSDO             AS HANDLE     NO-UNDO.
  DEFINE OUTPUT PARAMETER pcEntryFields    AS CHARACTER  NO-UNDO.
  DEFINE OUTPUT PARAMETER pcEntryOperators AS CHARACTER  NO-UNDO.
  DEFINE OUTPUT PARAMETER pcEntryValues    AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE cEntry          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cOperator        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFinalOperator   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cName            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cValue           AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE i1               AS INTEGER    NO-UNDO.

  pcParseString = TRIM(pcParseString, "|":U).
  DO i1 = 1 TO NUM-ENTRIES(pcParseString,"|":U):

    cEntry = ENTRY(i1,pcParseString,"|":u).
    IF INDEX (cEntry,">":U) > 0 THEN
      ASSIGN cOperator = ">":U
             cFinalOperator = ">=":U.
    ELSE IF INDEX (cEntry,"<":U) > 0 THEN
      ASSIGN cOperator = "<":U
             cFinalOperator = "<=":U.
    ELSE IF INDEX (cEntry,"=":U) > 0 THEN
      ASSIGN cOperator = "=":U
             cFinalOperator = "=":U.
    ASSIGN
      cName = TRIM(ENTRY(1,cEntry,cOperator))
      cValue = TRIM(ENTRY(2,cEntry,cOperator))
      cValue = (IF cValue = "undefined":U THEN "":U ELSE cValue).
    
    /* getting all that mathes up to the first letters of TO by adding chr(255) to the value */
    IF cOperator = "<" AND DYNAMIC-FUNCTION("columnDataType":U IN phSDO,cName) = "character" THEN
      cValue = cValue + CHR(255).

    IF ( cName = "":U AND cValue = "":U ) THEN
      NEXT.

    ASSIGN
      pcEntryFields = pcEntryFields + ",":U + cName
      pcEntryOperators = pcEntryOperators +  ",":U + cFinalOperator
      pcEntryValues = pcEntryValues + CHR(1) + cValue.

  END.

  /* Trim and loose the initial , */
  ASSIGN pcEntryFields = TRIM(pcEntryFields, ",":U).
         pcEntryOperators = TRIM(pcEntryOperators, ",":U).
         pcEntryValues = TRIM(pcEntryValues, CHR(1)).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE processEvents Include 
PROCEDURE processEvents :
/*------------------------------------------------------------------------------
  Purpose:     Output application data (eg, orders, customers, etc)
                This performs navigations (First, Prev, Next, Last, Filter, Sort)
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pcLogicalObjectName AS CHARACTER  NO-UNDO.
  DEFINE INPUT PARAMETER pcRequestEvents     AS CHARACTER  NO-UNDO.
  DEFINE INPUT PARAMETER plExportData        AS LOGICAL    NO-UNDO.
  
  DEFINE VARIABLE c1              AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cContextName    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDisplayField   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFillBatchOnRepos AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFilter         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFilterKey      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cRequestEvent   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cRowId          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSDOEvent       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSDOList        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSDOName        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSortFields     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hDS             AS HANDLE     NO-UNDO.  
  DEFINE VARIABLE i1              AS INTEGER    NO-UNDO.
  DEFINE VARIABLE i2              AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iBatchNum       AS INTEGER    NO-UNDO INITIAL 9.
  DEFINE VARIABLE iCounter        AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iRowsToBatch    AS INTEGER    NO-UNDO INITIAL 10.
  DEFINE VARIABLE lDeleteFilter   AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cSortingKey     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cOverrideLogicalObjectName AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE cFind           AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFindKey        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFindFields     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFindOperators  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFindValues     AS CHARACTER  NO-UNDO.
  
  DEFINE VARIABLE cFirstResultRow AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cLastResultRow  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cPos            AS CHARACTER  NO-UNDO.

  /* get the links for the SDO list 
     - NOTE THIS WILL POPULATE the ttSDOLink table used later */
  logNote("note", "request events are: " + pcRequestEvents).

  populateDSLinks(pcLogicalObjectName, pcRequestEvents).

  /* Build the SDO list by traversing the parent child relations */
  cSDOList = traverseAndBuildDSList("":U, "":U).

  logNote("note", "SDO LIST: " + cSDOList).

  /* Start a container and Link all the SDO's */
  RUN createLinksInContainer(pcLogicalObjectName, 
                                pcRequestEvents, 
                                cSDOList) NO-ERROR.

  /* Empty the SDO Data temp-table */
  EMPTY TEMP-TABLE ttSDOData.

  /* Get the data for only the top level SDO's */
  FOR EACH ttSDOLink 
     WHERE ttSDOLInk.parentSDOName = "":
    
    ASSIGN 
      cSDOName    = ttSDOLink.SDOName
      cSDOEvent   = ttSDOLink.SDOEvent
      cRowId      = '':U.

    logNote("note", "firing event: " + cSDOEvent + " on SDO: " + cSDOName).

    /* Get the SDO Handle */
    hDS = getDSHandle(cSDOName, "").
    IF NOT VALID-HANDLE(hDS) THEN
    DO:
      logNote("NOTE":U, "ERROR - Could not get valid handle for SDO: " + cSDOName).
      NEXT.
    END.

    /* Rebuild on reposition */
    DYNAMIC-FUNCTION('setRebuildOnRepos':U IN hDS, TRUE).
    
    /* If the pass-thru link over rides the container name then use the 
       over riddent container name */
    ASSIGN 
      cOverrideLogicalObjectName = get-value('d':U + cSDOName + '._object':U)
      cOverrideLogicalObjectName = TRIM(cOverrideLogicalObjectName, "|":U)
      cOverrideLogicalObjectName = TRIM(cOverrideLogicalObjectName).
    
    IF (cOverrideLogicalObjectName = ? OR cOverrideLogicalObjectName = "":U) THEN
      cOverrideLogicalObjectName = pcLogicalObjectName.
    
    /* Set the Rows to batch */
    DYNAMIC-FUNCTION('setRowsToBatch':U IN hDS, INTEGER(getSavedDSProperty(cOverrideLogicalObjectName, cSDOName, 'RowsToBatch':U))).

    /* set the FillBatchOnRepos */
    cFillBatchOnRepos = getSavedDSProperty(cOverrideLogicalObjectName, cSDOName, 'FillBatchOnRepos':U).
    IF (cFillBatchOnRepos = ? OR cFillBatchOnRepos = "":U) THEN
      cFillBatchOnRepos = "yes".
    DYNAMIC-FUNCTION('setFillBatchOnRepos':U IN hDS, LOGICAL(cFillBatchOnRepos)).

    /* If the first/last record in the batch was deleted then this logic will 
       fix the navigation from breaking 
    */
    ASSIGN 
      cFirstResultRow = get-value('d':U + cSDOName + '._first':U)
      cLastResultRow = get-value('d':U + cSDOName + '._last':U)
      cPos = "1":U.

    IF (cFirstResultRow > "" ) THEN
      DYNAMIC-FUNCTION('setFirstResultRow':U IN hDS, cPos + ";":U + cFirstResultRow).

    IF (cLastResultRow > "" ) THEN
    DO:
      ASSIGN cPos = ENTRY(1, DYNAMIC-FUNCTION('getLastResultRow':U IN hDS), ";":U) NO-ERROR.
      DYNAMIC-FUNCTION('setLastResultRow':U IN hDS, cPos + ";":U + cLastResultRow).
    END.
    
    /* Set the queryFilter */
    IF (cSDOEvent <> "FILTER":U) THEN
      RUN queryFilter (cOverrideLogicalObjectName, cSDOName, cSDOEvent, hDS, NO) NO-ERROR.

    /* If we have a specific event for the sdo do it, otherwise do CURRENT */
    CASE cSDOEvent:
      WHEN 'ALL':U THEN
      DO:
        DYNAMIC-FUNCTION('setRowsToBatch':U IN hDS, INT(get-value('Export'))).
        RUN fetchFirstBatch IN hDS.
      END.
      WHEN 'FIRST':U OR
      WHEN 'START':U THEN
        RUN fetchFirstBatch IN hDS.
      WHEN 'NEXT':U THEN
        RUN fetchNextBatch IN hDS.
      WHEN 'PREV':U THEN
        RUN fetchPrevBatch IN hDS.
      WHEN 'LAST':U THEN
        RUN fetchLastBatch IN hDS.
      WHEN "INCLUDED":U THEN
        .
      WHEN 'PASSTHRU':U OR
      WHEN 'POSITION' THEN
      DO:
        /* Set the Rows to batch */
        DYNAMIC-FUNCTION('setRowsToBatch':U IN hDS, 1).
        IF (cSDOEvent =  'PASSTHRU') THEN
          cRowId = getPassThruSDOInfo(2) NO-ERROR.
        ELSE 
        DO:
          IF ( NUM-ENTRIES(cSDOName, ".":U) > 1 ) THEN
            cRowId = get-value('d':U + ENTRY(2, cSDOName, ".":U) + '._position':U).
          ELSE
            cRowId = get-value('d':U + cSDOName + '._position':U).
          cRowId = TRIM(cRowId, '|':U).
        END.
        lognote('note','POSITION=' +  cSDOName + '/' + cRowid).

        /* Reposition the record */
        IF (cRowId > "":U) THEN
          DYNAMIC-FUNCTION('fetchRowIdent':U IN hDS, cRowId, "":U).
      END.
      WHEN "FILTER":U THEN
      DO:
        ASSIGN 
          cFilter       = get-value('d':U + cSDOName + '._filter':U)
          cSortFields   = get-value('d':U + cSDOName + '._sorting':U)
          cFilterKey    = cOverrideLogicalObjectName + ".":U + cSDOName + ".filter":U
          cSortingKey   = cOverrideLogicalObjectName + ".":U + cSDOName + ".sorting":U
          lDeleteFilter = (cFilter = "").
          
        lognote('Note','Filter=' + cFilter + '/' + cSortFields).

        /* Clear any previous filters and sorts - Remove the values from the SDO */
        RUN queryFilter (INPUT cOverrideLogicalObjectName, INPUT cSDOName, INPUT cSDOEvent, INPUT hDS, INPUT YES).
        
        /* Persist the new values for filters and sorts */
        DYNAMIC-FUNCTION("setPropertyList":U IN gshSessionManager,
          INPUT cFilterKey + ",":U + cSortingKey,
          INPUT cFilter + CHR(3) + cSortFields,
          INPUT NO).

        /* Persist the new values to the Profile Manager if requested (dma) */
        IF ttSDOLink.SaveFilter THEN
          RUN setProfileData IN gshProfileManager 
            ("SDO":U,        /* Profile type code */
             "Attributes":U, /* Profile code */
             cFilterKey,     /* Profile data key */
             ?,              /* Rowid of profile data */
             cFilter,        /* Profile data value */
             lDeleteFilter,  /* Delete flag */
             "PER":U).       /* Save flag (permanent).  If blank, sessionid will be 
                                used for contextid */

        /* Load the values in SDO */
        RUN queryFilter (INPUT cOverrideLogicalObjectName, INPUT cSDOName, INPUT cSDOEvent, INPUT hDS, INPUT NO).

        /* Fetch the first batch */
        RUN fetchFirstBatch IN hDS.
      END.
      WHEN "FIND":U THEN
      DO:
        ASSIGN 
          cFind       = get-value('d':U + cSDOName + '._find':U)
          cFindKey    = cOverrideLogicalObjectName + ".":U + cSDOName + ".find":U.
          
        lognote('Note','Find=' + cFind).

        IF (cFind > "":U)  THEN
        DO:
          RUN prepareQueryForFilterAndFind ( INPUT cFind, INPUT hDS,
                                             OUTPUT cFindFields,
                                             OUTPUT cFindOperators,
                                             OUTPUT cFindValues).

          IF cFindFields > "" THEN
          DO:
            DYNAMIC-FUNCTION("findRowWhere":U IN hDS, 
                         cFindFields,
                         cFindValues,
                         cFindOperators).
          END.     
        END.
      END.
      OTHERWISE
        RUN fetchCurrentBatch IN hDS.
    END CASE.
  END.

  /* Save the SDO Context */  
  saveDSContext(pcLogicalObjectName, cSDOList).
  
  /* Iterate thru' the Application Data and output it */

  REPEAT i1 = 1 TO NUM-ENTRIES(cSDOList):
    /* Find the SDO Name */
    cSDOName = ENTRY(i1, cSDOList).

    /* if this not an SBO then proceed */
    IF ( DYNAMIC-FUNCTION("IsA":U IN gshRepositoryManager,cSDOName,"SBO":U)) THEN
      NEXT.

    /* If the pass-thru link over rides the container name then use the 
       over riddent container name */

    ASSIGN 
      cOverrideLogicalObjectName = get-value('d':U + cSDOName + '._object':U)
      cOverrideLogicalObjectName = TRIM(cOverrideLogicalObjectName, "|":U)
      cOverrideLogicalObjectName = TRIM(cOverrideLogicalObjectName).
    
    IF (cOverrideLogicalObjectName = ? OR cOverrideLogicalObjectName = "":U) THEN
      cOverrideLogicalObjectName = pcLogicalObjectName.
    
    /* Find the Event */
    FIND FIRST ttSDOLink WHERE ttSDOLink.SDOName = cSDOName NO-ERROR.
    IF NOT AVAILABLE ttSDOLink THEN NEXT.

    /* Make sure that SDO data exists. There are valid events 
       (POSITION,PASSTHRU) when the SDO may not have data. */
    IF CAN-DO("POSITION,PASSTHRU":U, ttSDOLink.SDOEvent)  THEN
       NEXT.

    FIND FIRST ttSDOData WHERE ttSDOData.SDOName = cSDOName NO-ERROR.

    /* Output any Header Information */
    outputSDOHeader(cOverrideLogicalObjectName, cSDOName, plExportData).

    /* Output the SDO Data */
    iCounter = outputSDOData(cOverrideLogicalObjectName, cSDOName, plExportData). 

    /* Find the SDO Position to Enable disable the navigation buttons */
    /* -1 = Last, 1 = First or Filter, 0 = Complete Batch, 9 otherwise */
    IF (NOT plExportData) THEN
      iBatchNum = findSDOPosition(cSDOName, ?).

    /* Output any SDO footer information  */
    IF (NOT plExportData) THEN
      outputSDOFooter(cOverrideLogicalObjectName, cSDOName, STRING(iBatchNum)).

  END. /* for each SDO object (ghObjectBuffer) */

  /* Do the cleanup */
  IF VALID-HANDLE(ghSDOContainer) THEN
    RUN destroyObject IN ghSDOContainer.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE processLookup Include 
PROCEDURE processLookup :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pcLogicalObjectName AS CHARACTER  NO-UNDO.
  DEFINE INPUT PARAMETER pcSDOName AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE iCounter       AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iBatchNum      AS INTEGER    NO-UNDO.
  DEFINE VARIABLE c1             AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDisplayField  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cQueryFields   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cQueryString   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cWhere         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cQueryTables   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cQueryValue    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hSDOHandle     AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cContextName   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSDOContext    AS CHARACTER  NO-UNDO.


  /* The context for the SDO exists, then do nothing */
  /*  Can have different WHERE clause for input values  
    IF ( getSavedDSContext(pcLogicalObjectName, pcSDOName) > '':U ) THEN
      RETURN.
  */

  ASSIGN
    c1            = DYNAMIC-FUNCTION("getPropertyList":U IN gshSessionManager,
                    'LookupQuery,LookupTables,LookupFields,LookupDisplay,LookupValue', YES)
    cQueryString  = ENTRY(1,c1,CHR(3))
    cQueryTables  = ENTRY(2,c1,CHR(3))
    cQueryFields  = ENTRY(3,c1,CHR(3))
    cDisplayField = ENTRY(4,c1,CHR(3))
    cQueryValue   = ENTRY(5,c1,CHR(3))
  NO-ERROR.

  /* Start the Dynamic SDO */
  RUN adm2/dynsdo.w PERSISTENT SET hSDOHandle.
  
  DYNAMIC-FUNCTION("defineDataObject":U IN hSDOHandle,
                   cQueryTables,
                   cQueryString,
                   cQueryFields,
                   "NO" ).
  /* Initialize the object */
  RUN initializeObject IN hSDOHandle.
  /* Fetch the first record */
  RUN fetchFirst IN hSDOHandle.
  /* Save the SDO Context */  
  cContextName =  pcLogicalObjectName + '.':U + pcSDOName + '.context':U.
  
  /* Get the context from SDO */
  cSDOContext = DYNAMIC-FUNCTION("obtainContextForClient":U IN hSDOHandle).
  ASSIGN
    cSDOContext = REPLACE(cSDOContext, CHR(3), '#':U)
    cSDOContext = REPLACE(cSDOContext, CHR(4), '$':U).


  DYNAMIC-FUNCTION("setPropertyList":U IN gshSessionManager,
                   INPUT cContextName,
                   INPUT cSDOContext,
                   INPUT NO).
  /* Destroy the SDO */
  RUN destroyObject IN hSDOHandle.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE processRequest Include 
PROCEDURE processRequest :
/*------------------------------------------------------------------------------
  Purpose:     This is the other external entry point (other than initialzeValues),
               this will be called when a process needs to output the UI.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER AppProgram AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE lResult       AS LOGICAL    NO-UNDO INITIAL TRUE.
  DEFINE VARIABLE iLookup       AS INTEGER    NO-UNDO.

  CREATE WIDGET-POOL "B2BUIM":U.
  ASSIGN gcLogicalObjectName = AppProgram.

  /* Move SDO events processing (for db updating, Add/Update/Delete) 
     to Request (or Event) Manager */
  logNote('note':U,"Running ProcessResponse.":U) NO-ERROR. 
  gcJsRun = "":U.

  RUN processResponse(gcLogicalObjectName, gcRequestEvents, OUTPUT lResult).
  
  /* Save user settings - Still to be implemented */
  RUN saveUserSettings.
  
  IF (NOT glExportData) THEN
  DO:
    /* Start output of page */
    IF (glNeedToDoUI) THEN  
      RUN screenUI.
    ELSE 
      RUN screenData.
    
    /* Special treat dynLookups when launched via button from hidden screen */
    iLookup = INDEX(gcRequestEvents,"|lookup.launch.").
    IF iLookup > 0 THEN DO:
      ASSIGN
        gcLogicalObjectName = ENTRY(1,SUBSTRING(gcRequestEvents,iLookup + 15),'|')
        gcRequestEvents     = gcRequestEvents + '|lookup.first'.
      RUN doLookup.
    END.
  END.
  
  logNote('note':U,"Running ProcessEvents.":U) NO-ERROR.    
  IF (lResult) THEN
    RUN processEvents(gcLogicalObjectName, gcRequestEvents, glExportData) NO-ERROR.

  IF (NOT glExportData) THEN
    RUN screenEnd.

  EMPTY TEMP-TABLE ttClientAction.

  /* TBD: Put this into another IP/function called finalise*/
  IF VALID-HANDLE(ghttLinkedObj) THEN
  DO:
    ghttLinkedObj:BUFFER-RELEASE NO-ERROR.
    DELETE OBJECT ghttLinkedObj NO-ERROR.
    ghttLinkedObj = ?.
  END.
  RUN clearObjectCache(ghBufferCacheBuffer).
  DELETE WIDGET-POOL "B2BUIM":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE processResponse Include 
PROCEDURE processResponse :
/*------------------------------------------------------------------------------
  Purpose:     This procedure will process the response.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcLogicalObjectName AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pcRequestEvents     AS CHARACTER  NO-UNDO.
  DEFINE OUTPUT PARAMETER plSuccess            AS LOGICAL    NO-UNDO INITIAL TRUE.

  DEFINE VARIABLE c1              AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cCall           AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cCol            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cColValues      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cEntry          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFlags          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cMsgText        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cParamNames     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cParams         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cRowId          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cRowIdEnt       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSDOCols        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cLookupCols     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSDOEvent       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSDOEvents      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSDOName        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cdSDOName       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cTarget         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hSDO            AS HANDLE     NO-UNDO.
  DEFINE VARIABLE i1              AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iColENTRY       AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iCols           AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iRun            AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iSDOEvents      AS INTEGER    NO-UNDO.
  DEFINE VARIABLE lLogic          AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cOut            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iSaveSuccess    AS INTEGER NO-UNDO.
  DEFINE VARIABLE iSaveFail       AS INTEGER NO-UNDO.
  DEFINE VARIABLE cData           AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDataColumns    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cNewColValues   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cOldColValues   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cError          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cASDOCols       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cOldVal         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cNewVal         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cConflictError  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDataDelimiter  AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE cDSName         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDSSaveEvent    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lDSisSBO        AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE hSBO            AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cAutoCommit     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lAutoCommit     AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cSBOName        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hDS             AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cRowsToBatch    AS CHARACTER  NO-UNDO.

  /* See if there is any processing to do (from client request), e.g. 'do' =
     'orderfullo.save'.  If no Add, Update, Delete or business logic events 
     then exit (nothing to process - probably navigation OR menuselection) */
  EMPTY TEMP-TABLE ttDSSaveEvents.

  pcRequestEvents = TRIM(pcRequestEvents, "|":U).

  IF INDEX(pcRequestEvents, ".add":U)        = 0 AND
     INDEX(pcRequestEvents, ".update":U)     = 0 AND 
     INDEX(pcRequestEvents, ".delete":U)     = 0 AND 
     INDEX(pcRequestEvents, ".run":U)        = 0 AND /* business logic (dma) */
     INDEX(pcRequestEvents, ".treeview":U)   = 0 AND /* treedata fetch (psd) */
     INDEX(pcRequestEvents, ".save":U)       = 0 THEN RETURN.
  IF pcRequestEvents = ? OR pcRequestEvents = "":U THEN RETURN.

  /* Walk thru the event groups (one group per SDO/WDO) */
  DO i1 = 1 TO NUM-ENTRIES(pcRequestEvents, "|":U):

    cEntry = ENTRY(i1, pcRequestEvents, "|":U).
    /* If there is no request - then ignore */
    IF cEntry = "" THEN NEXT.
    IF NUM-ENTRIES(cEntry, ".":U) <= 1  THEN
      NEXT.

    /* Process business logic event */
    IF INDEX(cEntry, ".run.":U) > 0 THEN 
    DO:
      ASSIGN
        /* Decode double period, encoded in ry/dhtml/ryapph.htc (runOnServer) */
        cEntry   = REPLACE(cEntry, "..":U, CHR(3))
        cCall    = REPLACE(ENTRY(1, cEntry, ".":U), CHR(3), ".":U)
        cTarget  = REPLACE(ENTRY(2, cEntry, ".":U), CHR(3), ".":U)
        iRun     = LOOKUP("run":U, cEntry, ".")
        cFlags   = ENTRY(iRun + 1, cEntry, ".":U)
              
        /* TBD: The parameter delimiter, CHR(9), needs to be changed to an
           unprintable character in ry/dhtml/ryapph.htc. */
        /* Strip off any non-parameter stuff */
        ENTRY(1, cEntry, CHR(9)) = ""
        cParams  = TRIM(cEntry)
        cParams  = REPLACE(cParams, CHR(9), ",":U)
        lLogic   = TRUE
        plSuccess = (IF i1 = 1 THEN FALSE ELSE plSuccess).
        
        /* If this is the only event, then we don't want regular SDO
           processing.  Otherwise, let regular SDO processing determine
           the plSuccess state. */

      logNote('Save':U, 'DynCall:':u + cCall + '|':U + cTarget + '|':U + cFlags + '=':U + cparams).
      RUN adm2/callstring.p (cCall, cTarget, cFlags, cParams).
      logNote('Save':U , 'DynCall ':U + (IF RETURN-VALUE='' THEN 'OK':U ELSE 'Error ':U + RETURN-VALUE)).
      NEXT.
    END.
    ELSE IF NOT INDEX(cEntry, ".save":U) > 0 THEN 
      NEXT.
    ELSE
    DO:
      /* Check if this is a SBO - If so, execute as a block */
      cDSName = ENTRY(1, cEntry, ".":U).
      IF ( NUM-ENTRIES(cEntry, ".":U) > 2) THEN
        ASSIGN cDSSaveEvent = ENTRY(2, cEntry, ".":U) + ".":U + ENTRY(3, cEntry, ".":U)
               lDSisSBO = TRUE.
      ELSE
        ASSIGN cDSSaveEvent = cEntry
               lDSisSBO = FALSE.

      FIND FIRST ttDSSaveEvents WHERE ttDSSaveEvents.DSName = cDSName NO-ERROR.
      IF AVAILABLE ttDSSaveEvents THEN
        ttDSSaveEvents.DSSaveEvent =  ttDSSaveEvents.DSSaveEvent + "," + cDSSaveEvent.
      ELSE
      DO:
        CREATE ttDSSaveEvents.
        ASSIGN ttDSSaveEvents.DSName = cDSName
               ttDSSaveEvents.DSSaveEvent =  cDSSaveEvent
               ttDSSaveEvents.IsSBO = lDSisSBO.
      END.
    END.
  END.

  tranBlock:
  DO TRANSACTION:
  
    /* Start the loop for each object */
    FOR EACH ttDSSaveEvents:

      cDSName = ttDSSaveEvents.DSName.
      lDSisSBO = ttDSSaveEvents.IsSBO.

      /* Get the data delimiter */
      cDataDelimiter = getSavedDSDataDelimiter(pcLogicalObjectName, cDSName).
      IF ( cDataDelimiter = ? OR cDataDelimiter = "":U ) THEN
        cDataDelimiter = "|".

      lAutoCommit = TRUE.
      logNote("Save", "Save Events for object: ":U + cDSName + " are: ":U + ttDSSaveEvents.DSSaveEvent).

      DO i1 = 1 TO NUM-ENTRIES(ttDSSaveEvents.DSSaveEvent, ",":U):

        cEntry = ENTRY(i1, ttDSSaveEvents.DSSaveEvent, ",":U).

        /* If there is no event - then ignore */
        IF cEntry = "" THEN NEXT.
        IF NUM-ENTRIES(cEntry, ".":U) <= 1  THEN
          NEXT.
    
        /* Process SDO events */
        ASSIGN
          cSDOName  = ENTRY(1, cEntry, ".":U)
          cdSDOName = 'd':U + cSDOName.

        IF (cSDOName = ? OR cSDOName = "") THEN NEXT.

        ASSIGN
          cSDOEvents = get-value(cdSDOName + "._do":U)
          cSDOEvents = TRIM(cSDOEvents, "|":U).

        IF (cSDOEvents = ? OR cSDOEvents = "") THEN NEXT.

        /* Get individual SDO events from client request, e.g. 
           'dorderfullo.do' = 'update|add'.  
        */
  
        /* Instantiate SDO or SBO */
        IF lDSisSBO THEN
        DO:
          cSBOName = cDSName.
          hSBO = getDSHandle(cDSName, ?).

          hSDO = findSDOHandleInSBO(pcLogicalObjectName, cDSName, hSBO, cSDOName).
          hDS = hSBO.
        END.
        ELSE
        DO:
          hSDO = getDSHandle(cSDOName, ?).
          cSBOName = "":U.
          hDS = hSDO.
        END.

        cRowsToBatch = getSavedDSProperty(pcLogicalObjectName, cSDOName, 'RowsToBatch':U).
        IF cRowsToBatch = ? OR cRowsToBatch = "" THEN
          cRowsToBatch = "50".
        logNote("save":U, "Rows to batch for DS: " + cSDOName + " is: " + cRowsToBatch).
        
        /* Set defaults */
        DYNAMIC-FUNCTION('setRebuilDOnRepos':U IN hSDO, TRUE). 
        DYNAMIC-FUNCTION('setRowsToBatch':U IN hSDO, INTEGER(cRowsToBatch)).
        DYNAMIC-FUNCTION('setAutoCommit':U IN hSDO, lAutoCommit).
        DYNAMIC-FUNCTION('setDataDelimiter':U IN hSDO, cDataDelimiter).
        DYNAMIC-FUNCTION('setDataReadFormat':U IN hSDO, 'Formatted':U).

        /* Get data columns and build column list */
        ASSIGN
          c1 = getSDODataColumns(pcLogicalObjectName, hSDO, NO)
          cParamNames  = "":U
          cDataColumns = '':U
          cLookupCols  = '':U.
   
        DO iCols = 1 to NUM-ENTRIES(c1):
          /* Strip any tablename prefix eg 'order.' from SDO cols */
          cCol = ENTRY(iCols, c1).
          IF INDEX(cCol, '.':U) > 0 THEN
            cCol = ENTRY(NUM-ENTRIES(cCol, ".":U), cCol, '.':u).
          IF get-value(cdSDOName + '._' + cCol) > '' THEN
            cLookupCols = cLookupCols + cCol + ',':u.
          ASSIGN
            cParamNames  = cParamNames + ',':U + cdSDOName + '.':U + cCol.

          IF lDSIsSBO THEN
            cDataColumns = cDataColumns + cSDOName + "." + cCol + ',':u.
          ELSE
            cDataColumns = cDataColumns + cCol + ',':u.
        END.

        cDataColumns = TRIM(cDataColumns, ',':U). 
        cLookupCols  = TRIM(cLookupCols, ',':U). 
        cParamNames  = TRIM(cParamNames, ',':U). 

        logNote('Save':U,'Data Columns: ':U + cDataColumns).
        logNote('Save':U,'Lookup Columns: ':U + cLookupCols).
        logNote('Save':U,'Parameter names: ':U + cParamNames).

        ASSIGN iColENTRY = 1.

        /* Walk thru the SDO/WDO events */
        iSaveSuccess = 0.
        iSaveFail = 0.
        cOut = "".

        DO iSDOEvents = 1 to NUM-ENTRIES(cSDOEvents, "|":U):
          ASSIGN
            cSDOEvent = ENTRY(iSDOEvents, cSDOEvents, "|":U)
            cRowId    = ENTRY(iSDOEvents, TRIM(get-value(ENTRY(1, cParamNames, ",":U)), cDataDelimiter), cDataDelimiter)
            cData     = '':U
            plSuccess    = TRUE
          .
  
          CASE cSDOEvent:
            WHEN "add":U THEN
            DO:
              ASSIGN iColENTRY = iColENTRY + 1
                     cNewColValues = "":U.
  
              /* Build list of cols names and values chr(1) delimited for submitRow() 
                Get SDO data from client request 
                e.g. 'dorderfullo.orderStatus' = 'Shipped|Shipped|Ordered' */

              DEFINE VARIABLE temp AS CHARACTER  NO-UNDO.
              DO iCols = 1 to NUM-ENTRIES(cDataColumns):
                temp = ENTRY(iColENTRY, get-value(ENTRY(iCols, cParamNames, ",":U)), cDataDelimiter) NO-ERROR.
                IF (ERROR-STATUS:ERROR OR temp = ? ) THEN
                DO:
                  ASSIGN cNewColValues = cNewColValues + (IF iCols = 1 THEN "":U ELSE cDataDelimiter).
                  ERROR-STATUS:ERROR = FALSE.
                  NEXT.
                END.
                IF CAN-DO(cLookupCols,ENTRY(iCols,cDataColumns, ",":U)) THEN 
                DO:
                  RUN saveLookup(ENTRY(iCols, cParamNames, ",":U),iColENTRY,temp,cDataDelimiter ) NO-ERROR.
                  IF NOT ERROR-STATUS:ERROR THEN 
                    temp = RETURN-VALUE.
                  ELSE
                  DO:
                    logNote("Save":U, "Lookup Save errors: ":U + RETURN-VALUE ).
                    ERROR-STATUS:ERROR = FALSE.
                    iSaveFail = iSaveFail + 1.
                    plSuccess = handleErrors(pcLogicalObjectName, cSBOName, cSDOName, cSDOEvent, RETURN-VALUE, "", "._":U + ENTRY(iCols, cDataColumns, ",":U)).
                    UNDO tranBlock, LEAVE tranBlock.
                  END.
                END.
                cNewColValues = cNewColValues + (IF iCols = 1 THEN "":U ELSE cDataDelimiter) + temp.
              END.

              RUN createData IN hDS ( INPUT cDataColumns, 
                                      INPUT-OUTPUT cNewColValues,
                                      OUTPUT cError).
              /* Just a temperory work around to get around the open API returning ";" if no errors exist */
              cError = TRIM(cError).
              cError = TRIM(cError, ";").

              IF cError > "":U THEN
              DO:
                iSaveFail = iSaveFail + 1.
                logNote("Save":U, "Create Data errors: ":U + cError ).
                plSuccess = handleErrors(pcLogicalObjectName, cSBOName, cSDOName, cSDOEvent, cError, "", "").
                UNDO tranBlock, LEAVE tranBlock.
              END.
              ELSE
              DO:
                iSaveSuccess = iSaveSuccess + 1.
                /* Get the data from the latest create row */
                cData = cNewColValues.
              END.
            END.
            WHEN "update":U THEN
            DO:
              ASSIGN 
                cOldColValues = ""
                cNewColValues = "".

              /* Build list of cols names and values chr(1) delimited for submitRow() 
                 Get SDO data from client request 
                e.g. 'dorderfullo.orderStatus' = 'Shipped|Shipped|Ordered'
                Note that for updates there will be 2 values 'oldvalue|newvalue' */

              DO iCols = 1 to NUM-ENTRIES(cDataColumns):
                cOldVal = ENTRY(iColENTRY + 1, get-value(ENTRY(iCols, cParamNames, ",":U)), cDataDelimiter) NO-ERROR.
                IF ERROR-STATUS:ERROR THEN
                DO:
                  cOldVal = "".
                  ERROR-STATUS:ERROR = FALSE.
                END.
                cNewVal = ENTRY(iColENTRY + 2, get-value(ENTRY(iCols, cParamNames, ",":U)), cDataDelimiter) NO-ERROR.
                IF ERROR-STATUS:ERROR THEN
                DO:
                  cNewVal = cOldVal.
                  ERROR-STATUS:ERROR = FALSE.
                END.
                IF CAN-DO(cLookupCols,ENTRY(iCols,cDataColumns, ",":U)) THEN 
                DO:
                  RUN saveLookup(ENTRY(iCols, cParamNames, ",":U),iColENTRY + 2,cNewVal, cDataDelimiter) NO-ERROR.
                  IF NOT ERROR-STATUS:ERROR THEN
                    cNewVal = RETURN-VALUE.
                  ELSE
                  DO:
                    iSaveFail = iSaveFail + 1.
                    logNote("Save":U, "Lookup Save errors: ":U + RETURN-VALUE ).
                    plSuccess = handleErrors(pcLogicalObjectName, cSBOName, cSDOName, cSDOEvent, RETURN-VALUE, "", "._":U + ENTRY(iCols, cDataColumns, ",":U)).
                    UNDO tranBlock, LEAVE tranBlock.
                  END.
                END.
                cOldColValues = cOldColValues + 
                              (IF iCols = 1 THEN "":U ELSE cDataDelimiter) + 
                              cOldVal.
                cNewColValues = cNewColValues + 
                              (IF iCols = 1 THEN "":U ELSE cDataDelimiter) + 
                              cNewVal.
                   
              END.
              iColENTRY = iColENTRY + 2.
              RUN updateData IN hDS(INPUT cDataColumns, 
                                     INPUT cOldColValues,
                                     INPUT-OUTPUT cNewColValues,
                                     OUTPUT cError).

              /* Just a temperory work around to get around the open API returning ";" if no errors exist */
              cError = TRIM(cError).
              cError = TRIM(cError, ";").
            
              IF cError > "" THEN
              DO:
                logNote("Save":U, "Update Data errors: ":U + cError ).
                cConflictError = DYNAMIC-FUNCTION('getLastCommitErrorType':U IN hDS) NO-ERROR. 
                iSaveFail = iSaveFail + 1.
                IF (cConflictError = 'CONFLICT') THEN
                  plSuccess = returnConflict(pcLogicalObjectName, cSDOName, cDataColumns, escapeData(cNewColValues), hDS) NO-ERROR.
                ELSE
                DO:
                  plSuccess = handleErrors(pcLogicalObjectName, cSBOName, cSDOName, cSDOEvent, cError, "", "").
                END.
                UNDO tranBlock, LEAVE tranBlock.
              END.
              ELSE
              DO:
                iSaveSuccess = iSaveSuccess + 1.
                /* Get the data from the latest update row */
                cData = cNewColValues.
              END.

            END. /* update */

            WHEN "delete" THEN
            DO:
              ASSIGN 
                iColENTRY = iColENTRY + 1.
              logNote("note", "Row id is: " + cRowid).

              RUN deleteData IN hDS( INPUT "RowIdent":U, INPUT cRowid, OUTPUT cError).

              /* Just a temperory work around to get around the open API returning ";" if no errors exist */
              cError = TRIM(cError).
              cError = TRIM(cError, ";").
            
              IF cError > "":U THEN
              DO:
                iSaveFail = iSaveFail + 1.
                logNote("Save":U, "Delete Data errors: ":U + cError ).
                plSuccess = handleErrors(pcLogicalObjectName, cSBOName, cSDOName, cSDOEvent, cError, "", "").
                UNDO tranBlock, LEAVE tranBlock.
              END.
              ELSE
              DO:
                iSaveSuccess = iSaveSuccess + 1.
                cData = "":U.
              END.
            END.
          END CASE.

          IF ((plSuccess) AND iSaveSuccess = 1) THEN
            cOut = cOut + 'app.':U + 'd':U + cSDOName + '.saveok([':U + '~n':U.

          /* Write to a Variable */
          IF (plSuccess) THEN
          DO:
            cData = appendLookupData(pcLogicalObjectName, cSDOName, cDataColumns, cData) NO-ERROR.
            cOut = cOut + (IF iSaveSuccess = 1 THEN " '":U ELSE ",'":U) + escapeData(cData) + "'":U + '~n':U.
          END.
          
        END. /* DO iSDOEvents = 1 to iNumSDOEvents: */
             
      END. /* NUM-ENTRIES(ttDSSaveEvents.DSSaveEvent, ",":U) */
      
      IF (iSaveSuccess > 0) THEN
        cOut = cOut + ']);':U + '~n':U.
    
    END. 
    
    /* Confirm to client that events were successfully completed. */
    gcJsRun = gcJsRun + cOut.
    
  END. /* Do Transaction */
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE queryFilter Include 
PROCEDURE queryFilter :
/*------------------------------------------------------------------------------
  Purpose:     Deals with query and sorting.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pcLogicalObjectName AS CHARACTER  NO-UNDO.
  DEFINE INPUT PARAMETER pcSDOName           AS CHARACTER  NO-UNDO.
  DEFINE INPUT PARAMETER pcSDOEvent          AS CHARACTER  NO-UNDO.
  DEFINE INPUT PARAMETER phSDO               AS HANDLE     NO-UNDO.
  DEFINE INPUT PARAMETER plRemoveSelection   AS LOGICAL    NO-UNDO.

  DEFINE VARIABLE cFilterFields    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFilterKey       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFilterOperators AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFilterValues    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFilters         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSortFields      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE ix               AS INTEGER    NO-UNDO.
  DEFINE VARIABLE rRowid           AS ROWID      NO-UNDO.

  /* Built up Temp table */
  ASSIGN
    cFilterFields    = "":U
    cFilterOperators = "":U
    cFilterValues    = "":U
    cFilterKey       = pcLogicalObjectName + ".":U + pcSDOName + ".filter":U
    cFilters         = DYNAMIC-FUNCTION("getPropertyList":U IN gshSessionManager,
                         cFilterKey, NO)
    cSortFields      = DYNAMIC-FUNCTION("getPropertyList":U IN gshSessionManager,
                         pcLogicalObjectName + ".":U + pcSDOName + ".sorting":U, NO).

  /* If no filters found locally, check Profile Manager for saved filter settings */
  IF cFilters = "" THEN
    RUN getProfileData IN gshProfileManager 
      ("SDO":U,             /* Profile type code */
       "Attributes":U,      /* Profile code */
       cFilterKey,          /* Profile data key */
       "NO":U,              /* Get next record flag */
       INPUT-OUTPUT rRowid, /* Rowid of profile data */
       OUTPUT cFilters) NO-ERROR.
  
  IF (cFilters > "") THEN
  DO:
    RUN prepareQueryForFilterAndFind ( INPUT cFilters, INPUT phSDO,
                                       OUTPUT cFilterFields,
                                       OUTPUT cFilterOperators,
                                       OUTPUT cFilterValues).


    IF cFilterFields > "" THEN
    DO:
      IF plRemoveSelection THEN
      DO:
        /* Set the query string to be same as the query where */
        DYNAMIC-FUNCTION("setQueryString":U IN phSDO, 
                         DYNAMIC-FUNCTION("getQueryWhere":U IN phSDO)).
        /* Remove all the set filter info */
        DYNAMIC-FUNCTION("removeQuerySelection":U IN phSDO, 
                         cFilterFields,
                         cFilterOperators).
      END.
      ELSE
        DYNAMIC-FUNCTION("assignQuerySelection":U IN phSDO, 
                   cFilterFields,
                   cFilterValues,
                   cFilterOperators).
    END.
  END.
  lognote('note','Query=' + DYNAMIC-FUNCTION("getQueryString":U IN phSDO)).
  IF cSortFields > "" THEN 
  DO:
    DO ix = 2 TO NUM-ENTRIES(cSortFields,'|'): /* 9633 */
      ENTRY(ix,cSortFields,'|') = 'RowObject.' + ENTRY(ix,cSortFields,'|').
    END.
    
    IF plRemoveSelection THEN 
      DYNAMIC-FUNCTION("setQuerySort":U IN phSDO, "":U).
    ELSE
    DO:
      cSortFields = REPLACE(TRIM(cSortFields, "|"),"|"," by ").
      DYNAMIC-FUNCTION("setQuerySort":U IN phSDO, cSortFields).
    END.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE receiveData Include 
PROCEDURE receiveData :
/*------------------------------------------------------------------------------
  Purpose:     Load the data in the temp table 
  Parameters:  <none>
  Notes:       This is called from the SDO.
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcObjectName  AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pcColumnNames AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pcValues      AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE liCount AS INTEGER    NO-UNDO.
  DEFINE VARIABLE i1      AS INTEGER    NO-UNDO.
  FIND FIRST ttSDOCount WHERE ttSDOCount.SDOName = pcObjectName NO-ERROR.
  /* 
  logNote('note':U, 'Data for sdo: ' + STRING(pcObjectName) + ' with col names: ' + STRING(pcColumnNames) + ' is: ' + STRING(pcValues)).
  */
  IF AVAILABLE ttSDOCount THEN
  DO:
    IF (( ttSDOCount.rowsToBatch > 0 ) AND (ttSDOCount.iCount >=  ttSDOCount.rowsToBatch)) THEN
      RETURN 'adm-error'. 

    ASSIGN liCount = ttSDOCount.iCount + 1
           ttSDOCount.iCount = liCount.
  END.

  CREATE ttSDOData.
  ASSIGN 
    ttSDOData.SDOName   = pcObjectName
    ttSDOData.Counter   = liCount
    ttSDOData.SDOValues = pcValues
    ttSDOData.SDOCols   = pcColumnNames.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE saveLookup Include 
PROCEDURE saveLookup :
/*------------------------------------------------------------------------------
  Purpose:  Perform dynamic lookup on save
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER cField AS CHAR NO-UNDO.  
  DEFINE INPUT PARAMETER iEntry AS INT  NO-UNDO.  
  DEFINE INPUT PARAMETER cData  AS CHAR NO-UNDO.  
  DEFINE INPUT PARAMETER pcDataDelimiter AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE cValue   AS CHAR NO-UNDO.
  DEFINE VARIABLE lSuccess AS LOGICAL    NO-UNDO.
  cValue = ENTRY(iEntry,get-value(REPLACE(cField,'.','._')),pcDataDelimiter).

  DEFINE VARIABLE i1              AS INTEGER    NO-UNDO.
  DEFINE VARIABLE i2              AS INTEGER    NO-UNDO.
  DEFINE VARIABLE i3              AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cKeyField       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDisplayField   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cKeyDataType    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFieldName      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cQueryString    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cQueryTables    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE c1              AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFieldValue     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cLookupValue    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cRetSDOValues   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cScreen         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSDOName        AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE cReturn      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cWhere       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hBuffer      AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hBufferList  AS HANDLE     NO-UNDO EXTENT 20.
  DEFINE VARIABLE hField       AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hQuery       AS HANDLE     NO-UNDO.
  
  ASSIGN 
    cField    = SUBSTRING(cField,2)
    cSDOName  = ENTRY(1,cField,'.') NO-ERROR.

  cScreen = DYNAMIC-FUNCTION("getPropertyList":U IN gshSessionManager,
                              'screen_':U + gcLogicalObjectName, NO).
  
  /* Append lookup data to SDO data string */
  c1 = ENTRY(LOOKUP(cSDOName,cScreen,'|') + 1, cScreen, '|':U).
  i1 = LOOKUP(ENTRY(2,cField,'.'),c1,CHR(4)) - 3.
  lSuccess = TRUE.

  ASSIGN
    cKeyField      = ENTRY(i1    , c1, CHR(4))
    cDisplayField  = ENTRY(i1 + 1, c1, CHR(4))
    cKeyDataType   = ENTRY(i1 + 2, c1, CHR(4))
    cFieldName     = ENTRY(i1 + 3, c1, CHR(4))
    cFieldName     = TRIM(cFieldName, ">":U)
    cFieldName     = TRIM(cFieldName, "<":U)
    cQueryString   = ENTRY(i1 + 4, c1, CHR(4))
    cQueryTables   = ENTRY(i1 + 5, c1, CHR(4))
  NO-ERROR.
  
  /* If the Displayed field is same as the ke field then like GUI save the data */
  IF ( cDisplayField = cKeyField ) THEN
    RETURN cValue.
  
  ASSIGN
    i1 = INDEX(cQueryString, ' BY ':U)
    i2 = INDEX(cQueryString, ' WHERE ':U)
    cWhere    = cDisplayField + ' = "':U + cValue + '"':U.


  /* Perform the more efficient dynamic find if only one table is needed. */
  IF NUM-ENTRIES(cQueryTables) = 1 THEN 
  DO:
    CREATE BUFFER hBuffer FOR TABLE cQueryTables IN WIDGET-POOL "B2BUIM":U NO-ERROR.
    hBuffer:FIND-FIRST("WHERE " + cWhere) NO-ERROR.
    IF NOT hBuffer:AVAILABLE THEN 
    DO:
      hBuffer:FIND-UNIQUE("WHERE " + REPLACE(cWhere,' = ',' BEGINS ')) NO-ERROR.
      IF ( hBuffer:AMBIGUOUS ) THEN
        ASSIGN lSuccess = FALSE
               cReturn = "ambigous".
      ELSE
      DO:
        IF hBuffer:AVAILABLE THEN 
          cReturn = hBuffer:BUFFER-FIELD(ENTRY(2, ckeyField, ".":U)):BUFFER-VALUE NO-ERROR.
        ELSE 
          cReturn = "".
      END.
    END.
    ELSE
      cReturn = hBuffer:BUFFER-FIELD(ENTRY(2, ckeyField, ".":U)):BUFFER-VALUE NO-ERROR.

    hBuffer:BUFFER-RELEASE() NO-ERROR.
    DELETE OBJECT hBuffer.
    hBuffer = ?.
  END.
  ELSE 
  DO:
    IF i2 > 0 THEN
      SUBSTRING(cQueryString, i2 + 7, 0) = cWhere + ' AND ':U.
    ELSE
    IF i1 > 0 THEN
      SUBSTRING(cQueryString, i1, 0) = 'WHERE ' + cWhere.
    ELSE
      cQueryString = cQueryString + ' WHERE ':U + cWhere. 

    CREATE QUERY hQuery IN WIDGET-POOL "B2BUIM":U NO-ERROR.
    DO i3 = 1 TO NUM-ENTRIES(cQueryTables):
      CREATE BUFFER hBufferList[i3] FOR TABLE ENTRY(i3,cQueryTables) 
        IN WIDGET-POOL "B2BUIM":U NO-ERROR.
      IF ERROR-STATUS:ERROR THEN NEXT.
      hQuery:ADD-BUFFER(hBufferList[i3]) NO-ERROR.
    END.
    hQuery:QUERY-PREPARE(cQueryString) NO-ERROR.

    hQuery:QUERY-OPEN().
    IF hQuery:QUERY-OFF-END THEN 
      cReturn = "":U.
    ELSE
    DO:
      ASSIGN i3 = MAXIMUM(1, LOOKUP(ENTRY(1, cKeyField, ".":U), cQueryTables)).
      IF hBufferList[i3]:AVAILABLE THEN 
        cReturn = hBufferList[i3]:BUFFER-FIELD(ENTRY(2, cField, ".":U)):BUFFER-VALUE NO-ERROR.
      ELSE
        cReturn = "":U.
    END.

    /* Clean up */
    hQuery:QUERY-CLOSE().
    DO i3 = 1 TO NUM-ENTRIES(cQueryTables):
      DELETE OBJECT hBufferList[i3] NO-ERROR.
      ASSIGN hBufferList[i3] = ?.
    END.
    DELETE OBJECT hQuery NO-ERROR.
    ASSIGN hQuery  = ?.
  END.

  IF lSuccess THEN
    RETURN cReturn.
  ELSE
    RETURN ERROR cReturn.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE saveUserSettings Include 
PROCEDURE saveUserSettings :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setClientAction Include 
PROCEDURE setClientAction :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER cAction   AS CHARACTER NO-UNDO.
  
  CREATE ttClientAction.
  ASSIGN
    ttClientAction.ttAction = REPLACE(cAction,'"',"'").

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setMessage Include 
PROCEDURE setMessage :
/*------------------------------------------------------------------------------
  Purpose:     Set the output message 
  Parameters:  <none>
  Notes:       Based on showMessages in Session Manager
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pcMessageList   AS CHARACTER.
  DEFINE INPUT PARAMETER pcMessageType   AS CHARACTER.

  DEFINE VARIABLE cAnswer          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cButtonList      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFailed          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFullMessages    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cMessageTitle    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSummaryMessages AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSuppressDisplay AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iButtonPressed   AS INTEGER    NO-UNDO.
  DEFINE VARIABLE lSuppressDisplay AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lUpdateErrorLog  AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE pcButtonList     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE pcButtonPressed  AS CHARACTER  NO-UNDO.    
  DEFINE VARIABLE pcCancelButton   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE pcDefaultButton  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE pcMessageTitle   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE phContainer      AS HANDLE     NO-UNDO.
  DEFINE VARIABLE plDisplayEmpty   AS LOGICAL    NO-UNDO INITIAL ?.

  /* Set up defaults for values not passed in */
  IF NOT CAN-DO("MES,INF,WAR,ERR,HAL,ABO,QUE":U,pcMessageType) THEN
    ASSIGN pcMessageType = "ERR":U.
  IF pcButtonList = "":U THEN 
        ASSIGN pcButtonList = "OK":U.
  IF pcDefaultButton = "":U OR LOOKUP(pcDefaultButton,pcButtonList) = 0 THEN
        ASSIGN pcDefaultButton = IF LOOKUP("OK":U,pcButtonList) > 0 THEN "OK":U
                                 ELSE ENTRY(1,pcButtonList).
  IF pcCancelButton = "":U OR LOOKUP(pcCancelButton,pcButtonList) = 0 THEN
        ASSIGN pcCancelButton = IF LOOKUP("OK":U,pcButtonList) > 0 THEN "OK":U
                                ELSE ENTRY(1,pcButtonList).
  IF pcMessageTitle = "":U THEN
  DO:
    CASE pcMessageType:
      WHEN "MES":U THEN
        ASSIGN pcMessageTitle = "Message":U. 
      WHEN "INF":U THEN
        ASSIGN pcMessageTitle = "Information":U.
      WHEN "WAR":U THEN
        ASSIGN pcMessageTitle = "Warning":U. 
      WHEN "ERR":U THEN
        ASSIGN pcMessageTitle = "Error":U.
      WHEN "HAL":U THEN
        ASSIGN pcMessageTitle = "Halt Condition":U.
      WHEN "ABO":U THEN
        ASSIGN pcMessageTitle = "About Application":U.
      WHEN "QUE":U THEN
        ASSIGN pcMessageTitle = "Question":U.
    END CASE.
  END.

  IF plDisplayEmpty = ? THEN 
        ASSIGN plDisplayEmpty = YES.
  RUN af/app/afmessagep (INPUT pcMessageList, /*** needed to add 'af/app/' ***/
                         INPUT pcButtonList,
                         INPUT pcMessageTitle,
                         OUTPUT cSummaryMessages,
                         OUTPUT cFullMessages,
                         OUTPUT cButtonList,
                         OUTPUT cMessageTitle,
                         OUTPUT lUpdateErrorLog,
                         OUTPUT lSuppressDisplay).  

  /* Display message if not remote and not suppressed */
  IF NOT lSuppressDisplay THEN
    cSuppressDisplay = DYNAMIC-FUNCTION("getPropertyList":U IN gshSessionManager,
                                        "suppressDisplay":U, YES).
  ELSE 
        cSuppressDisplay = "YES":U.

  IF cSuppressDisplay = "YES":U THEN 
    ASSIGN lSuppressDisplay = YES.

  IF NOT lSuppressDisplay THEN
  DO:
    /* Currently prepend the message with the title (& :\n\n) - as info.alert 
       does not support a title - yet.  Replace any newline and carrige-return 
       characters with JavaScript newline */ 
    ASSIGN
        cFullMessages = REPLACE(cFullMessages, '~\', '~\~\')
      cFullMessages = REPLACE(cFullMessages, CHR(10), '~\n':u)
      cFullMessages = REPLACE(cFullMessages, CHR(13), '~\n':u)
      cFullMessages = REPLACE(cFullMessages, CHR(3), '~\n':u).
    
    /* If the message ends with '\n\n*** Error: ' then strip it off
       (this is a bug, I think, with af/app/afmessagep). */
    IF LENGTH(cFullMessages) >= 15 AND
      SUBSTRING(cFullMessages, LENGTH(cFullMessages) - 14) = '~\n~\n*** Error: ':u THEN
      cFullMessages = SUBSTRING(cFullMessages, 1, LENGTH(cFullMessages) - 15).
    RUN setClientAction('info.':U + 
      (IF pcMessageType = 'QUE':U THEN 'prompt':U ELSE 'alert':U) + '|':U + 
       cMessageTitle + '|':U /*':~\n~\n':U */ + cFullMessages).
  END.
  ELSE
    ASSIGN pcButtonPressed = pcDefaultButton.  /* If remote, assume default button */

  /* If remote, or update error log set to YES, then update error log and send 
     an email if possible */
  IF (SESSION:REMOTE OR SESSION:PARAM = "REMOTE":U) 
    OR lUpdateErrorLog OR lSuppressDisplay THEN
    RUN updateErrorLog IN gshSessionManager (cSummaryMessages, cFullMessages).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION appendLookupData Include 
FUNCTION appendLookupData RETURNS CHARACTER
  ( pcLogicalObjectName AS CHARACTER,
    pcSDOName AS CHARACTER,
    pcSDOCols AS CHARACTER,
    pcSDOValues AS CHARACTER) :
/*------------------------------------------------------------------------------
  Purpose:  This function appends the lookup data to the SDO data.
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE i1              AS INTEGER    NO-UNDO.
  DEFINE VARIABLE i2              AS INTEGER    NO-UNDO.
  DEFINE VARIABLE i3              AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cKeyField       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDisplayField   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cKeyDataType    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFieldName      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cQueryString    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cQueryTables    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE c1              AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFieldValue     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cLinkedFields   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cLookupValue    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cRetSDOValues   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cScreen         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDataDelimiter  AS CHARACTER  NO-UNDO.

  IF (pcLogicalObjectName > "":U)  THEN
    cDataDelimiter = getSavedDSDataDelimiter(pcLogicalObjectName, pcSDOName).
  ELSE
    pcLogicalObjectName = gcLogicalObjectName.

  ASSIGN 
    cRetSDOValues  = pcSDOValues.

  IF cRetSDOValues = ? OR TRIM(cRetSDOValues) = "":U THEN
    RETURN cRetSDOValues.

  /* Get the Lookup fields */
  cScreen = DYNAMIC-FUNCTION("getPropertyList":U IN gshSessionManager,
                              'screen_':U + pcLogicalObjectName, NO).
  
  IF ( cDataDelimiter = ? OR cDataDelimiter = "":U ) THEN
    cDataDelimiter = "|".
  
  /* Append lookup data to SDO data string */
  i2 = LOOKUP(pcSDOName,cScreen,'|') + 1.
  IF i2 > 1 THEN DO:
    c1 = ENTRY(i2, cScreen, '|':U).
    DO i2 = 1 TO (NUM-ENTRIES(c1, CHR(4)) - 1) BY 8:
      ASSIGN
        cKeyField      = ENTRY(i2    , c1, CHR(4))
        cDisplayField  = ENTRY(i2 + 1, c1, CHR(4))
        cKeyDataType   = ENTRY(i2 + 2, c1, CHR(4))
        cFieldName     = ENTRY(i2 + 3, c1, CHR(4))
        cFieldName     = TRIM(cFieldName, ">":U)
        cFieldName     = TRIM(cFieldName, "<":U)
        cQueryString   = ENTRY(i2 + 4, c1, CHR(4))
        cQueryTables   = ENTRY(i2 + 5, c1, CHR(4))
        cLinkedFields  = ENTRY(i2 + 6, c1, CHR(4))
        NO-ERROR.

      /* Get the object value that will be used to modify the query WHERE phrase. */
      i1 = LOOKUP(cFieldName, pcSDOCols) NO-ERROR.
      IF i1 > 0  THEN
      DO:
        cFieldValue = ENTRY(i1, cRetSDOValues, cDataDelimiter).

        /* Get lookup value */
        cLookupValue = getLookupValue(cQueryTables, cQueryString, cFieldValue, 
                                      cKeyField, cKeyDataType, cDisplayField,
                                      cLinkedFields, cDataDelimiter).
        /* Append lookup value to SDO data */
        cRetSDOValues = cRetSDOValues + cLookupValue.
      END.
    END.
  END. 

  RETURN cRetSDOValues.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION changeParentInParentChildInfo Include 
FUNCTION changeParentInParentChildInfo RETURNS LOGICAL
  ( pcLogicalObjectName AS CHARACTER,
    pcSDOName AS CHARACTER,
    pcOldParentSDOName AS CHARACTER,
    pcNewParentSDOName AS CHARACTER) :
/*------------------------------------------------------------------------------
  Purpose:  This function will change the parent SDO Name
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cParentParamName AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cParentString AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cForeignFields AS CHARACTER  NO-UNDO.

  cParentParamName = pcLogicalObjectName + ".parent_":U + pcSDOName.
  cParentString =  DYNAMIC-FUNCTION("getPropertyList":U IN gshSessionManager,
                       INPUT cParentParamName, INPUT NO).
  IF cParentString = ? OR cParentString = "":U THEN
    RETURN TRUE.

  /* Replace the name */
  ENTRY( NUM-ENTRIES(cParentString, ",":U), cParentString, ",":U) = pcNewParentSDOName.

  /* Save the value */
  DYNAMIC-FUNCTION("setPropertyList":U IN gshSessionManager,
                   INPUT cParentParamName, 
                   INPUT cParentString,
                   INPUT NO).

  /* Now worry about all the children to this parent */
  ASSIGN cForeignFields = cParentString.
  ENTRY( NUM-ENTRIES(cForeignFields, ",":U), cForeignFields, ",":U) = "":U.
  cForeignFields = TRIM(cForeignFields, ",":U).
  
  /* Set the children for this parent */
  setChildSDOInfo(pcLogicalObjectName, pcSDOName, pcNewParentSDOName, cForeignFields).

RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION clearDSContext Include 
FUNCTION clearDSContext RETURNS LOGICAL
  ( pcLogicalObjectName AS CHARACTER,
    pcDSName AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose: This function will clear the SDO context. 
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cFinalDSName AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cContextName AS CHARACTER  NO-UNDO.

  IF (NUM-ENTRIES(pcDSName, ".":U) > 1 ) THEN
    ASSIGN cFinalDSName = ENTRY(1, pcDSName, ".":U).
  ELSE
    ASSIGN cFinalDSName = pcDSName.

  ASSIGN cContextName =  pcLogicalObjectName + '.':U + cFinalDSName + '.context':U.
  DYNAMIC-FUNCTION("setPropertyList":U IN gshSessionManager,
                   INPUT cContextName,
                   INPUT "":U,
                   INPUT NO).

  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION createSDOLinks Include 
FUNCTION createSDOLinks RETURNS LOGICAL
  ( pcLogicalObjectName AS CHARACTER,
    pcDSName AS CHARACTER,
    pcParentSDOName AS CHARACTER,
    pcForeignFields AS CHARACTER,
    pcSDOEvent AS CHARACTER) :
/*------------------------------------------------------------------------------
  Purpose:  Create the Temp tables. This is a separate function as this gets 
            called recursively.
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cSBOName AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFinalDSName AS CHARACTER  NO-UNDO.

  IF ( NUM-ENTRIES(pcDSName, ".":U) > 1 )THEN
    ASSIGN cSBOName = ENTRY(1, pcDSName, ".":U)
           cFinalDSName = cSBOName.
  ELSE
    ASSIGN cSBOName = "":U
           cFinalDSName = pcDSName.

  FIND FIRST ttSDOLink EXCLUSIVE-LOCK 
       WHERE ttSDOLink.SDOName = pcDSName NO-ERROR.
  IF AVAILABLE ttSDOLink THEN
  DO:
    IF ( ttSDOLink.SDOEvent <> "INCLUDED":U) THEN
      ASSIGN 
        ttSDOLink.SDOEvent   = pcSDOEvent.
        ttSDOLink.SaveFilter = (IF pcSDOEvent = "savefilter":U 
                                THEN TRUE ELSE ttSDOLink.SaveFilter).
    RETURN TRUE.
  END.

  CREATE ttSDOLink.
  ASSIGN 
    ttSDOLink.SDOName       = pcDSName
    ttSDOLink.ParentSDOName = pcParentSDOName
    ttSDOLink.ForeignFields = pcForeignFields
    ttSDOLink.SDOEvent      = pcSDOEvent.
    ttSDOLink.SaveFilter    = (pcSDOEvent = "savefilter":U).

  CREATE ttSDOCount.
  ASSIGN 
    ttSDOCount.SDOName     = pcDSName
    ttSDOCount.iCount      = 0.
  ASSIGN
    ttSDOCount.rowsToBatch = IF (ttSDOLink.SDOEvent = 'ALL':U) THEN 0 ELSE
      INTEGER(getSavedDSProperty(pcLogicalObjectName, cFinalDSName, 'RowsToBatch':U)).

  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION escapeData Include 
FUNCTION escapeData RETURNS CHARACTER
  (pcData AS CHARACTER) :
/*------------------------------------------------------------------------------
  Purpose:  This function will escape data line single quotes etc..
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cNewLine AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cReturn  AS CHARACTER  NO-UNDO.
  
  /* Escape some of the characters */
  pcData = REPLACE(pcData, "~\":U, "~\~\":U).
  pcData = REPLACE(pcData, "'":U, "~\'":U).

  ASSIGN
    cNewLine = (IF OPSYS = "UNIX":U THEN "~\~\n":U ELSE "~\n":U)
    cReturn  = (IF OPSYS = "UNIX":U THEN "~\~\r":U ELSE "~\r":U).

  ASSIGN
    /* There may be a need to do newline or carriage return characters also */
    pcData = REPLACE(pcData, CHR(10), cNewLine)
    pcData = REPLACE(pcData, CHR(13), cReturn).
  
  RETURN pcData.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION findMasterSDOInSBO Include 
FUNCTION findMasterSDOInSBO RETURNS CHARACTER
  ( pcDSName AS CHARACTER) :
/*------------------------------------------------------------------------------
  Purpose: Returns the Master SDO name from a SBO 
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hSBO           AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cSDOs          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cMasterSDOName AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hMasterSDO     AS HANDLE     NO-UNDO.

  ASSIGN
    cMasterSDOName = pcDSName
    hSBO  = getDSHandle(pcDSName, "":U)
    cSDOs = TRIM(DYNAMIC-FUNCTION("getContainedDataObjects":U IN hSBO)) NO-ERROR.

  /* If this is a SBO, then we need to do the loop for all the SDO's in the SBO */
  IF (ERROR-STATUS:ERROR = NO AND cSDOs > "":U) THEN
  DO:
    ASSIGN 
      hMasterSDO = DYNAMIC-FUNCTION("getMasterDataObject":U IN hSBO)
      cMasterSDOName = DYNAMIC-FUNCTION("getObjectName":U IN hMasterSDO).
  END.
  
  RETURN cMasterSDOName.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION findSDOHandleInSBO Include 
FUNCTION findSDOHandleInSBO RETURNS HANDLE
  ( pcLogicalObjectName AS CHARACTER,
    pcSBOName AS CHARACTER,
    phSBOHandle AS HANDLE,
    pcSDOName AS CHARACTER) :
/*------------------------------------------------------------------------------
  Purpose:  Finds the SDO handle in SBO.
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cSDOs    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSDO     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hSDO     AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cSDOName AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE i1       AS INTEGER    NO-UNDO.

  IF (NOT VALID-HANDLE(phSBOHandle) ) THEN
    RETURN ?.

  cSDOs = TRIM(DYNAMIC-FUNCTION("getContainedDataObjects":U IN phSBOHandle)) NO-ERROR.
  IF (ERROR-STATUS:ERROR) THEN
    RETURN ?.

  DO i1 = 1 TO NUM-ENTRIES(cSDOs):
    ASSIGN cSDO = ENTRY(i1, cSDOs, ",":U)
           hSDO = WIDGET-HANDLE(cSDO)
           cSDOName = DYNAMIC-FUNCTION("getObjectName":U IN hSDO ).

    IF  ( cSDOName = pcSDOName ) THEN
    DO:
      RETURN hSDO.
    END.
      RETURN hSDO.
  END.
  
  RETURN ?.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION findSDOPosition Include 
FUNCTION findSDOPosition RETURNS INTEGER
  ( pcSDOName AS CHARACTER,
    phSDOHandle AS HANDLE) :
/*------------------------------------------------------------------------------
  Purpose:  Find if the First, Next, Prev, Last buttons need to be enabled.
    Notes:  -1 = Last, 1 = First or Filter, 0 = Complete Batch, 9 otherwise 
------------------------------------------------------------------------------*/
  DEFINE VARIABLE iBatchNum    AS INTEGER    NO-UNDO INITIAL 9.
  DEFINE VARIABLE iRowsToBatch AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cSDOEvent    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hSDOHandle   AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cLastRowNum  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFirstRowNum AS CHARACTER  NO-UNDO.

  /* Get the SDO Handle */
  IF NOT VALID-HANDLE(phSDOHandle) THEN
  DO:
    hSDOHandle = getDSHandle(pcSDOName, "").
    IF NOT VALID-HANDLE(hSDOHandle) THEN
      RETURN iBatchNum.
  END.
  ELSE
    hSDOHandle = phSDOHandle.

  cLastRowNum = DYNAMIC-FUNCTION("getLastRowNum":U IN hSDOHandle).
  cFirstRowNum = DYNAMIC-FUNCTION("getFirstRowNum":U IN hSDOHandle).

  IF (cFirstRowNum > '':U ) THEN
    iBatchNum = 1.
  IF (cLastRowNum > '':U ) THEN
    iBatchNum = -1.
  IF (cFirstRowNum > '':U  AND cLastRowNum > '':U) THEN
    iBatchNum = 0.

  RETURN iBatchNum.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getDSHandle Include 
FUNCTION getDSHandle RETURNS HANDLE
  ( INPUT pcDSName AS CHARACTER,
    INPUT pcDSPath AS CHARACTER) :
/*------------------------------------------------------------------------------
  Purpose:  GEts the SDO Handle
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hDSHandle    AS HANDLE NO-UNDO.
  DEFINE VARIABLE cDSType      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSBOName     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFinalDSName AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSDOName     AS CHARACTER  NO-UNDO.

  IF (NUM-ENTRIES(pcDSName, ".":U) > 1) THEN
    ASSIGN cDSType = 'SBO':U
           cSBOName = ENTRY(1, pcDSName, ".":U)
           cFinalDSName = cSBOName
           cSDOName = ENTRY(2, pcDSName, ".":U).
  ELSE
    ASSIGN cDSType = 'SDO':U
           cSBOName = '':U
           cFinalDSName = pcDSName
           cSDOName = pcDSName.

  FIND FIRST ttSDO WHERE ttSDO.ttName = cFinalDSName NO-ERROR.
  IF AVAILABLE ttSDO THEN 
  DO:
    /* Save the path in the context */
    saveDSPath(cFinalDSName, ttSDO.ttPath).
    
    IF VALID-HANDLE(ttSDO.ttHandle) THEN
    DO:

      /* If we Reuse the SDO's then this is required.....
      {fn closeQuery ttSDO.ttHandle}.
      DYNAMIC-FUNCTION("setQueryWhere":U IN ttSDO.ttHandle, "").
      */
      IF ( cDSType = 'SBO') THEN
        RETURN findSDOHandleInSBO(gcLogicalObjectName, cSBOName, ttSDO.ttHandle, cSDOName).
      ELSE
        RETURN ttSDO.ttHandle.
    END.
    ELSE
    DO:
      IF (pcDSPath = ? OR pcDSPath = "":U) THEN
        pcDSPath = ttSDO.ttPath.
    END.
  END.
  
  IF (pcDSPath = ? OR pcDSPath = "":U) THEN
    ASSIGN pcDSPath = getSavedDSPath(cFinalDSName).

  /* If we've got this far then the SDO has not already been instantiated
     so we will do it manually.  Start the container. */
  IF NOT VALID-HANDLE(ghSDOContainer) THEN
    RUN adm2/dyncontainer.w PERSISTENT SET ghSDOContainer.

  hDSHandle = DYNAMIC-FUNCTION('addDataObject':U IN ghSDOContainer,
                                pcDSPath, cFinalDSName, ?, ?, 
                                getSavedDynamicDSInfo(cFinalDSName) ).  
  
  IF ( NOT VALID-HANDLE(hDSHandle)) THEN
  DO:
    logNote('NOTE':U,'Error running SDO: ' + pcDSName + ' (' + pcDSPath + ') - ':U + ERROR-STATUS:GET-MESSAGE(1) + ', Program:' + PROGRAM-NAME(1)).
    RUN setMessage (INPUT '** ERROR: Could not get valid handle for SDO: ' + pcDSName + ' (':U + pcDSPath + ').  ErrMsg:':U + ERROR-STATUS:GET-MESSAGE(1) + ', Program:' + PROGRAM-NAME(1), INPUT 'ERR':u).
    RETURN ?.
  END.
  
  /* Save the SDO handle in the Temp table */
  setDSHandle(cFinalDSName, pcDSPath, hDSHandle).

  /* Save the path in the context */
  saveDSPath(cFinalDSName, pcDSPath).

  IF ( cDSType = 'SBO') THEN
    RETURN findSDOHandleInSBO(gcLogicalObjectName, cSBOName, hDSHandle, cSDOName).
  ELSE
    RETURN hDSHandle.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getLookupValue Include 
FUNCTION getLookupValue RETURNS CHARACTER
  ( pcQueryTables AS CHARACTER,
    pcQueryString AS CHARACTER,
    pcFieldValue AS CHARACTER,
    pcKeyField AS CHARACTER, 
    pcKeyDataType AS CHARACTER,
    pcDisplayField AS CHARACTER,
    pcLinkedFields AS CHARACTER,
    pcDataDelimiter AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  TBD: Support for linked fields
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cLinkField   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cReturn      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cWhere       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hBuffer      AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hBufferList  AS HANDLE     NO-UNDO EXTENT 20.
  DEFINE VARIABLE hField       AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hQuery       AS HANDLE     NO-UNDO.
  DEFINE VARIABLE iByPos       AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iWherePos    AS INTEGER    NO-UNDO.
  DEFINE VARIABLE ix           AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iy           AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cTemp        AS CHARACTER  NO-UNDO.

  /* Massage query string, adding WHERE criteria, taking into account existing
     WHERE and BY phrases, e.g.
     
     FOR EACH gsm_currency NO-LOCK BY gsm_currency.currency_code
     
     becomes

     FOR EACH gsm_currency NO-LOCK 
       WHERE gsm_currency.currency_obj = DECIMAL(pcFieldValue)
       BY gsm_currency.currency_code
  */
  ASSIGN
    cReturn = pcDataDelimiter
    iByPos    = INDEX(pcQueryString, ' BY ':U)
    iWherePos = INDEX(pcQueryString, ' WHERE ':U)
    cWhere    = '(':U + pcKeyField + ' = "':U + pcFieldValue + '")':U.
  /* Perform the more efficient dynamic find if only one table is needed. */
  IF NUM-ENTRIES(pcQueryTables) = 1 THEN 
  DO:
    CREATE BUFFER hBuffer FOR TABLE pcQueryTables IN WIDGET-POOL "B2BUIM":U NO-ERROR.
    hBuffer:FIND-FIRST("WHERE " + cWhere) NO-ERROR.
    ASSIGN cTemp = "":U.
    IF ( VALID-HANDLE(hBuffer) AND hBuffer:AVAILABLE ) THEN 
    DO:
      ASSIGN cTemp = hBuffer:BUFFER-FIELD(ENTRY(2, pcDisplayField, ".":U)):BUFFER-VALUE NO-ERROR.
      IF (cTemp = ? OR ERROR-STATUS:ERROR) THEN
      DO:
        ASSIGN 
          ERROR-STATUS:ERROR = NO
          cTemp = "":U.
      END.
    END.
    IF ( (cTemp = "":U) AND (pcDisplayField = pcKeyField) ) THEN
      cTemp = pcFieldValue.

    cReturn = cReturn + cTemp.
                
      /* Append linked field data to the return value */
    DO iy = 1 TO NUM-ENTRIES(pcLinkedFields):
      ASSIGN cLinkField     = ENTRY(2, ENTRY(iy, pcLinkedFields), ".":U)
             cTemp = "":U.
      IF ( VALID-HANDLE(hBuffer) AND hBuffer:AVAILABLE ) THEN 
      DO:  
        ASSIGN cTemp = hBuffer:BUFFER-FIELD(cLinkField):BUFFER-VALUE NO-ERROR.
        IF (cTemp = ? OR ERROR-STATUS:ERROR) THEN
          ASSIGN 
            ERROR-STATUS:ERROR = NO
            cTemp = "":U.
      END.
      cReturn = cReturn + pcDataDelimiter + cTemp.
    END.
    
    hBuffer:BUFFER-RELEASE() NO-ERROR.
    DELETE OBJECT hBuffer.
    hBuffer = ?.
  END.
  ELSE 
  DO:
    IF iWherePos > 0 THEN
      SUBSTRING(pcQueryString, iWherePos + 7, 0) = cWhere + ' AND ':U.
    ELSE
    IF iByPos > 0 THEN
      SUBSTRING(pcQueryString, iByPos, 0) = 'WHERE ' + cWhere.
    ELSE
      pcQueryString = pcQueryString + ' WHERE ':U + cWhere. 

    CREATE QUERY hQuery IN WIDGET-POOL "B2BUIM":U NO-ERROR.
    DO ix = 1 TO NUM-ENTRIES(pcQueryTables):
      CREATE BUFFER hBufferList[ix] FOR TABLE ENTRY(ix,pcQueryTables) 
        IN WIDGET-POOL "B2BUIM":U NO-ERROR.
      IF ERROR-STATUS:ERROR THEN NEXT.
      hQuery:ADD-BUFFER(hBufferList[ix]) NO-ERROR.
    END.
    hQuery:QUERY-PREPARE(pcQueryString) NO-ERROR.

    hQuery:QUERY-OPEN().
    /* There should only be one record found. */
    hQuery:GET-FIRST().

    ASSIGN ix = MAXIMUM(1, LOOKUP(ENTRY(1, pcKeyField, ".":U), pcQueryTables))
           cTemp = "":U.
    IF ( VALID-HANDLE(hBufferList[ix]) AND hBufferList[ix]:AVAILABLE ) THEN 
    DO:
      ASSIGN cTemp = hBufferList[ix]:BUFFER-FIELD(ENTRY(2, pcDisplayField, ".":U)):BUFFER-VALUE NO-ERROR.
      IF (cTemp = ? OR ERROR-STATUS:ERROR) THEN
        ASSIGN 
          ERROR-STATUS:ERROR = NO
          cTemp = "":U.
    END.
    IF ( (cTemp = "":U) AND (pcDisplayField = pcKeyField) ) THEN
      cTemp = pcFieldValue.
    cReturn = cReturn + cTemp.
    
    /* Append linked field data to the return value */
    DO iy = 1 TO NUM-ENTRIES(pcLinkedFields):
      ASSIGN
        cLinkField = ENTRY(2, ENTRY(iy, pcLinkedFields), ".":U)
        cTemp = "":U
        ix = MAXIMUM(1, LOOKUP(ENTRY(1, cLinkField, ".":U), pcQueryTables)).

      IF ( VALID-HANDLE(hBufferList[ix]) AND hBufferList[ix]:AVAILABLE ) THEN 
      DO:  
        ASSIGN cTemp = hBufferList[ix]:BUFFER-FIELD(cLinkField):BUFFER-VALUE NO-ERROR.
        IF (cTemp = ? OR ERROR-STATUS:ERROR) THEN
          ASSIGN 
            ERROR-STATUS:ERROR = NO
            cTemp = "":U.
      END.
      cReturn = cReturn + pcDataDelimiter + cTemp.
    END.
    
    /* Clean up */
    hQuery:QUERY-CLOSE().
    DO ix = 1 TO NUM-ENTRIES(pcQueryTables):
      DELETE OBJECT hBufferList[ix] NO-ERROR.
      ASSIGN hBufferList[ix] = ?.
    END.
    DELETE OBJECT hQuery NO-ERROR.
    ASSIGN hQuery  = ?.
  END.
  
  RETURN cReturn.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getPassThruSDOInfo Include 
FUNCTION getPassThruSDOInfo RETURNS CHARACTER
  (piEntryNumber AS INTEGER) :
/*------------------------------------------------------------------------------
  Purpose:  This function will return the pass thru foreign fields in proper format.
    Notes:  The field and value is chr(1) separated pairs.
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cPassThruField AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cEntry         AS CHARACTER  NO-UNDO.

  IF (piEntryNumber > 0) THEN
  DO:
    cPassThruField = get-value("lookup").
    cPassThruField = TRIM(cPassThruField, "|":U).
    IF ( NUM-ENTRIES(cPassThruField, ".":U) >= piEntryNumber) THEN
    DO:
      cEntry = ENTRY(piEntryNumber, cPassThruField, ".":U).
      IF (cEntry BEGINS "DYN=":U) THEN
        RETURN '':U.
      ELSE
        RETURN cEntry.
    END.
    ELSE
      RETURN '':U.
  END.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getSavedContainerProperty Include 
FUNCTION getSavedContainerProperty RETURNS CHARACTER
  (pcLogicalObjectName AS CHARACTER,
   pcPropertyName AS CHARACTER) :
/*------------------------------------------------------------------------------
  Purpose:  return the rows to batch for the SDO.
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cContainerProperty AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cParamName   AS CHARACTER  NO-UNDO.
  
  cParamName = pcLogicalObjectName + "." + pcPropertyName.

  ASSIGN cContainerProperty = DYNAMIC-FUNCTION("getPropertyList":U IN gshSessionManager,
                                         cParamName, NO).

  IF (cContainerProperty = ? ) THEN
    RETURN '':U.
  ELSE
    RETURN cContainerProperty.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getSavedDSContext Include 
FUNCTION getSavedDSContext RETURNS CHARACTER
  ( pcLogicalObjectName AS CHARACTER,
    pcDSName AS CHARACTER,
    pcDSType AS CHARACTER) :
/*------------------------------------------------------------------------------
  Purpose:  Gets the SDO Context.
    Notes:  Replace # with chr(3) and $ with chr(4)
  ------------------------------------------------------------------------------*/
  DEFINE VARIABLE cDSContext     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDSContextName AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFinalDSName    AS CHARACTER  NO-UNDO.

  IF ( NUM-ENTRIES(pcDSName, ".":U ) > 1)  THEN
    cFinalDSName = ENTRY(1, pcDSName, ".":U).
  ELSE
    cFinalDSName = pcDSName.

  ASSIGN cDSContextName = pcLogicalObjectName + ".":U + cFinalDSName + ".context":U.

  ASSIGN
    cDSContext = DYNAMIC-FUNCTION("getPropertyList":U IN gshSessionManager,
                    INPUT cDSContextName,
                    INPUT NO).

  IF (cDSContext > "":U) THEN
    ASSIGN
      cDSContext = REPLACE(cDSContext, '#':U, CHR(3))
      cDSContext = REPLACE(cDSContext, '$':U, CHR(4)).
  ELSE
    cDSContext = "":U.

  RETURN cDSContext.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getSavedDSDataDelimiter Include 
FUNCTION getSavedDSDataDelimiter RETURNS CHARACTER
  (pcLogicalObjectName AS CHARACTER,
   pcDSName AS CHARACTER) :
/*------------------------------------------------------------------------------
  Purpose:  return the Data Delimiter for the SDO.
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cParamName      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDataDelimiter  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFinalDSName    AS CHARACTER  NO-UNDO.

  IF ( NUM-ENTRIES(pcDSName, ".":U ) > 1)  THEN
    cFinalDSName = ENTRY(1, pcDSName, ".":U).
  ELSE
    cFinalDSName = pcDSName.

  /* First check if there is a client override for the data delimiter property */
  cDataDelimiter = get-value("DataDelimiter":U).
  IF (cDataDelimiter > "":U)  THEN
    RETURN cDataDelimiter.

  /* If there is no client override, then check the repository value for 
     this SDO */

  cParamName = pcLogicalObjectName + ".":U + cFinalDSName + ".DataDelimiter":U.
  ASSIGN cDataDelimiter = DYNAMIC-FUNCTION("getPropertyList":U IN gshSessionManager,
                                         cParamName, NO).

  IF (cDataDelimiter > "":U ) THEN
    RETURN cDataDelimiter.
  ELSE
    RETURN '|':U.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getSavedDSPath Include 
FUNCTION getSavedDSPath RETURNS CHARACTER
  ( pcDSName AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  GEt the SDO PAth
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cDSPath AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFinalDSName    AS CHARACTER  NO-UNDO.

  IF ( NUM-ENTRIES(pcDSName, ".":U ) > 1)  THEN
    cFinalDSName = ENTRY(1, pcDSName, ".":U).
  ELSE
    cFinalDSName = pcDSName.

  ASSIGN cDSPath = DYNAMIC-FUNCTION("getPropertyList":U IN gshSessionManager,
                                     INPUT cFinalDSName + ".path":U,
                                     INPUT NO).

  IF (cDSPath = ? OR cDSPath = "":U) THEN
    RETURN pcDSName.

  RETURN cDSPath.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getSavedDSProperty Include 
FUNCTION getSavedDSProperty RETURNS CHARACTER
  (pcLogicalObjectName AS CHARACTER,
   pcDSName AS CHARACTER,
   pcPropertyName AS CHARACTER) :
/*------------------------------------------------------------------------------
  Purpose:  return the rows to batch for the SDO.
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cDSProperty AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cParamName   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFinalDSName    AS CHARACTER  NO-UNDO.

  IF ( NUM-ENTRIES(pcDSName, ".":U ) > 1)  THEN
    cFinalDSName = ENTRY(1, pcDSName, ".":U).
  ELSE
    cFinalDSName = pcDSName.

  cParamName = pcLogicalObjectName + "." + cFinalDSName + "." + pcPropertyName.

  ASSIGN cDSProperty = DYNAMIC-FUNCTION("getPropertyList":U IN gshSessionManager,
                                         cParamName, NO).

  IF (cDSProperty = ? ) THEN
    RETURN '':U.
  ELSE
    RETURN cDSProperty.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getSavedDynamicDSInfo Include 
FUNCTION getSavedDynamicDSInfo RETURNS CHARACTER
  ( pcDSName AS CHARACTER) :
/*------------------------------------------------------------------------------
  Purpose:  GEt the Dynamic SDO Info
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cDynamicDSInfo AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFinalDSName    AS CHARACTER  NO-UNDO.

  IF ( NUM-ENTRIES(pcDSName, ".":U ) > 1)  THEN
    cFinalDSName = ENTRY(1, pcDSName, ".":U).
  ELSE
    cFinalDSName = pcDSName.

  ASSIGN cDynamicDSInfo = DYNAMIC-FUNCTION("getPropertyList":U IN gshSessionManager,
                                     INPUT cFinalDSName + ".dynamicInfo":U,
                                     INPUT NO).

  IF (cDynamicDSInfo > '':U ) THEN
    ASSIGN
      cDynamicDSInfo = REPLACE(cDynamicDSInfo, '#':U, CHR(3))
      cDynamicDSInfo = REPLACE(cDynamicDSInfo, '$':U, CHR(4)).
  ELSE
    cDynamicDSInfo = "":U.

  RETURN cDynamicDSInfo.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getSDODataColumns Include 
FUNCTION getSDODataColumns RETURNS CHARACTER
  ( pcLogicalObjectName AS CHARACTER,
    phSDOHandle AS HANDLE,
    plUpdatable AS LOGICAL) :
/*------------------------------------------------------------------------------
  Purpose: Returns a list of SDO Data columns. This function will also check and 
           eliminate any 'secured hidden' fields from the list. This will ensure 
           that secured data does not go to the client as one could 'view souce' 
           to look at the secured data.
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cSDOColumns      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSDOColumn       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cHiddenColumns   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cHiddenColumn    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cNewSDOColumns   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iNum             AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iLoc             AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cSDOName         AS CHARACTER  NO-UNDO.

  /* GEt the SDO name */
  cSDOName = DYNAMIC-FUNCTION('getLogicalObjectName':U IN phSDOHandle).

  /* Get the columns */
  IF (plUpdatable) THEN
    cSDOColumns = DYNAMIC-FUNCTION('getUpdatableColumns':U IN phSDOHandle).
  ELSE
  DO:
    IF (glExportData) THEN
      cSDOColumns = DYNAMIC-FUNCTION('getDataColumns':U IN phSDOHandle).
    ELSE
      cSDOColumns = "RowIdent," + DYNAMIC-FUNCTION('getDataColumns':U IN phSDOHandle).
  END.

  /* Get the list of Hidden Secured Fields for this SDO */
  cHiddenColumns = getSavedDSProperty(pcLogicalObjectName, cSDOName, 'SecuredHiddenFields':U).
  cHiddenColumns = TRIM(cHiddenColumns, ",":U).
  IF (cHiddenColumns = "" ) THEN
    RETURN cSDOColumns.


  /* From the SDO list, take away the hidden fields */
  DO iNum = 1 TO NUM-ENTRIES(cHiddenColumns, ",":U):
    iLoc = 0.
    cHiddenColumn = ENTRY(iNum, cHiddenColumns).
    iLoc = LOOKUP(cHiddenColumn, cSDOColumns) NO-ERROR.
    IF iLoc > 0 THEN
      ENTRY(iLoc, cSDOColumns, ",":U) = "":U.
  END.

  /* Eliminate ",1,,2,3," condition to "1,2,3" */
  cSDOColumns = TRIM(cSDOColumns,",":U).
  DO iNum = 1 TO NUM-ENTRIES(cSDOColumns, ",":U):
    cSDOColumn = ENTRY(iNum, cSDOColumns).
    IF cSDOColumn = "" THEN NEXT.
    cNewSDOColumns = cNewSDOColumns + ",":U + cSDOColumn.
  END.
  cNewSDOColumns = TRIM(cNewSDOColumns, ",":U).

  /* Return the new column list */
  RETURN cNewSDOColumns.   /* Function return value. */
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION handleErrors Include 
FUNCTION handleErrors RETURNS LOGICAL
  (pcLogicalObjectName AS CHARACTER,
   pcSBOName AS CHARACTER,
   pcSDOName AS CHARACTER,
   pcSDOEvent AS CHARACTER,
   pcError AS CHARACTER,
   pcErrorRowId AS CHARACTER,
   pcMarkColumn AS CHARACTER) :
/*------------------------------------------------------------------------------
  Purpose:  This function will handle the SDO errors.
    Notes:  
------------------------------------------------------------------------------*/
  IF pcError > '':U THEN
  DO:
    CASE pcError:
      WHEN 'nomatch' THEN 
        RUN setClientAction('info.msg|nomatch|No match found for lookup').
      WHEN 'ambigous' THEN 
        RUN setClientAction('info.msg|ambigous|Exact match is required for lookup on save').
      OTHERWISE
        RUN setMessage (INPUT pcError, INPUT 'ERR':u).
    END CASE.
    
    RUN setClientAction( IF (pcSDOEvent = 'update' OR pcSDOEvent = 'add') THEN 
                              pcSDOname + '.undoupdate':U
                         ELSE 'wbo.undo':U).

    CASE pcError:
      WHEN 'nomatch' THEN 
        RUN setClientAction(pcSDOName + pcMarkColumn + '.mark').
      WHEN 'ambigous' THEN 
        RUN setClientAction(pcSDOName + pcMarkColumn + '.mark').
    END CASE.

  END. 

  RETURN FALSE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION includeSDOChildren Include 
FUNCTION includeSDOChildren RETURNS LOGICAL
  ( pcLogicalObjectName AS CHARACTER,
    pcParentSDOName AS CHARACTER,
    pcSDOEvent AS CHARACTER) :
/*------------------------------------------------------------------------------
  Purpose:  Include all the children SDO's for the parent
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cChild         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cChildSDOName  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cChildren      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cForeignFields AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cParamName     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE i1             AS INTEGER    NO-UNDO.
  DEFINE VARIABLE i2             AS INTEGER    NO-UNDO.

  IF (pcParentSDOName = ? OR pcParentSDOName = "" ) THEN
    RETURN TRUE.

  cParamName = pcLogicalObjectName + ".child_":U + pcParentSDOName.
  /* First find if this already exists */
  cChildren = DYNAMIC-FUNCTION("getPropertyList":U IN gshSessionManager,
                               cParamName, NO).

  cChildren = TRIM(cChildren, "|":u). 
  IF (cChildren = ? OR cChildren = "") THEN
    RETURN TRUE.
  REPEAT i1 = 1 TO NUM-ENTRIES(cChildren,"|":U):
    ASSIGN cChild = ENTRY(i1, cChildren, "|":U).
    IF ( cChild = ? OR cChild = "":U) THEN
      NEXT.
    ASSIGN cChildSDOName  = ENTRY(NUM-ENTRIES(cChild, ",":U), cChild, ",":U).
    REPEAT i2 = 1 TO (NUM-ENTRIES(cChild, ",":U) - 1):
      cForeignFields = cForeignFields + "," + ENTRY(i2, cChild, ",":U).
    END.
    cForeignFields = TRIM(cForeignFields, ",":U).
    
    /* Create the TT's - This is separated as it gets called recursively */
    createSDOLinks(pcLogicalObjectName, cChildSDOName, pcParentSDOName, cForeignFields, pcSDOEvent).
    
    /* Check if the child has any children */
    includeSDOChildren(pcLogicalObjectName, cChildSDOName, pcSDOEvent).
  END.

  RETURN TRUE.   /* Function return value. */
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION outputSDOData Include 
FUNCTION outputSDOData RETURNS INTEGER
  ( pcLogicalObjectName AS CHARACTER,
    pcSDOName AS CHARACTER,
    plExportData AS LOGICAL) :
/*------------------------------------------------------------------------------
  Purpose:  Get the SDO Data
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cSDODataValues AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iCounter       AS INTEGER    INITIAL 0 NO-UNDO.

  FOR EACH ttSDOData
     WHERE ttSDOData.SDOName = pcSDOName
        BY ttSDOData.Counter:
    
    IF (NOT plExportData) THEN
      ttSDOData.SDOValues = appendLookupData(pcLogicalObjectName, pcSDOName, ttSDOData.SDOCols, ttSDOData.SDOValues) NO-ERROR.

    ASSIGN
      cSDODataValues = escapeData(ttSDOData.SDOValues)
      iCounter       = iCounter + 1.

    IF (NOT plExportData) THEN
      {&out} (IF iCounter = 1 THEN " '":U ELSE ",'":U) cSDODataValues "'":U SKIP.
    ELSE 
      {&out} '<tr><td>' cSDODataValues '</td></tr>' SKIP.
  END.
  RETURN iCounter.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION outputSDOFooter Include 
FUNCTION outputSDOFooter RETURNS LOGICAL
  ( pcLogicalObjectName AS CHARACTER,
    pcSDOName AS CHARACTER,
    pcBatchNum AS CHARACTER) :
/*------------------------------------------------------------------------------
  Purpose:  output the SDO Footer
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cDataDelimiter AS CHARACTER  NO-UNDO.

  /* Find the Data Delimiter used for this load */
  cDataDelimiter = getSavedDSDataDelimiter(pcLogicalObjectName, pcSDOName).

  {&out} '],"' + cDataDelimiter + '",':U + pcBatchNum + ');':U SKIP. 

  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION outputSDOHeader Include 
FUNCTION outputSDOHeader RETURNS LOGICAL
  ( pcLogicalObjectName AS CHARACTER,
    pcSDOName AS CHARACTER,
    plExportData AS LOGICAL) :
/*------------------------------------------------------------------------------
  Purpose:  This function will output the SDO header
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hSDOHandle      AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cDataColumns    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDataDelimiter  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFinalSDOName   AS CHARACTER  NO-UNDO.

  IF ( NUM-ENTRIES(pcSDOName, ".":U) > 1 ) THEN
    cFinalSDOName = ENTRY(2, pcSDOName, ".":U).
  ELSE
    cFinalSDOName = pcSDOName.

  IF plExportData THEN
  DO:
    /* Get the SDO Handle */
    hSDOHandle = getDSHandle(pcSDOName, "").
    IF NOT VALID-HANDLE(hSDOHandle) THEN
      RETURN FALSE.

    /* get the Data columns */
    cDataColumns = getSDODataColumns(pcSDOName, hSDOHandle, NO).
    logNote('Note','Export:' + cDataColumns).
    /* get the Data Delimiter */
    cDataDelimiter = getSavedDSDataDelimiter(pcLogicalObjectName, pcSDOName).

    /* output the header in HTML format */
    {&OUT} '<tr><th>' REPLACE(cDataColumns, ',', '</th><th>') '</th></tr>' SKIP.
  END.
  ELSE
  DO:
    /* output the header */
    {&OUT} 'app.':U + 'd':U + LC(cFinalSDOName) + '.load([':U SKIP.
  END.

  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION populateDSLinks Include 
FUNCTION populateDSLinks RETURNS LOGICAL
  ( pcLogicalObjectName AS CHARACTER, 
    pcRequestEvents  AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  This function will populate the Links in the ttSDOlinks table then
            traverse the links and return a list of SDO's
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cChildSDOName   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cForeignFields  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cParentSDOName  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cRequestEvent   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSDOEvent       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSDORequestList AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE i1              AS INTEGER    NO-UNDO.

  pcRequestEvents = TRIM(pcRequestEvents,"|":U).

  /* Empty the dataset */
  EMPTY TEMP-TABLE ttSDOLink.
  EMPTY TEMP-TABLE ttSDOCount.

  /* First find the list of SDO's in the request */
  /* This will be used to determine the parent child relations later */
  cSDORequestList = "":U.
  REPEAT i1 = 1 TO NUM-ENTRIES(pcRequestEvents,"|":U):
    /* Find the request */
    ASSIGN cRequestEvent = ENTRY(i1, pcRequestEvents, "|":U).
    IF ( cRequestEvent = ? OR cRequestEvent = "":U) THEN
      NEXT.

    /* Find the SDO Name */
    IF ( NUM-ENTRIES(cRequestEvent, ".":U) > 2 ) THEN
      ASSIGN cChildSDOName  = ENTRY(1, cRequestEvent, ".":U) + ".":U + ENTRY(2, cRequestEvent, ".":U).
    ELSE
      ASSIGN cChildSDOName  = ENTRY(1, cRequestEvent, ".":U).

    IF (cChildSDOName = ?  OR cChildSDOName = "":U) THEN
      NEXT.

    cSDORequestList = cSDORequestList + "," + cChildSDOName.
  END.
  cSDORequestList = TRIM(cSDORequestList, ",":U).

  /* Populate the ttSDOLink temp table - This will also populate the 
     appropriate Parent/Child relation.
  */
  REPEAT i1 = 1 TO NUM-ENTRIES(pcRequestEvents,"|":U):

    /* Find the request */
    ASSIGN cRequestEvent = ENTRY(i1, pcRequestEvents, "|":U).
    IF ( cRequestEvent = ? OR cRequestEvent = "":U) THEN
      NEXT.

    /* Find the SDO Name */
    IF ( NUM-ENTRIES(cRequestEvent, ".":U) > 2 ) THEN
      ASSIGN cChildSDOName  = ENTRY(1, cRequestEvent, ".":U) + ".":U + ENTRY(2, cRequestEvent, ".":U).
    ELSE
      ASSIGN cChildSDOName  = ENTRY(1, cRequestEvent, ".":U).
    IF (cChildSDOName = ?  OR cChildSDOName = "":U) THEN
      NEXT.

    /* Find the SDO Event */
    ASSIGN cSDOEvent = ENTRY(NUM-ENTRIES(cRequestEvent,".":U), cRequestEvent, ".":U).
    IF ( cSDOEvent = ? OR cSDOEvent = "":U) THEN
      cSDOEvent = 'START':U.
        
    /* Do not send data if it is a save action */
    IF ( cSDOEvent = 'SAVE':U) THEN
      NEXT.
    
    /* Special Case for lookup - A HACK needs to be fixed */
    IF (cChildSDOName = 'lookup' AND cSDOEvent = 'START':U) THEN 
    DO:
      RUN processLookup(pcLogicalObjectName, cChildSDOName).
      ASSIGN cSDOEvent = 'FIRST':U.
    END.
    
    /* If the Event is START clean the prior context */
    IF ( cSDOEvent = 'START':U) THEN
    DO:
      /* Do the SDO context cleanup here */      
      clearDSContext(pcLogicalObjectName, cChildSDOName).
      ASSIGN cSDOEvent = 'FIRST':U.
    END.

    /* If this SDO was considered previously, then ignore it */
    FIND FIRST ttSDOLink EXCLUSIVE-LOCK 
      WHERE ttSDOLink.SDOName = cChildSDOName NO-ERROR.
    
    /* If available then only update with the latest event */
    IF AVAILABLE ttSDOLink THEN
    DO:
      ASSIGN 
        ttSDOLink.SDOEvent   = cSDOEvent.
      NEXT.
    END.

    /* Get the parent of this SDO */
    ASSIGN 
      cForeignFields = '':U
      cParentSDOName = '':U.

    RUN getParentDS( INPUT pcLogicalObjectName, 
                      INPUT cChildSDOName, 
                     OUTPUT cParentSDOName, 
                     OUTPUT cForeignFields).

    /* The parent is not in the request then do not worry about parent info */
    IF ( cParentSDOName > "" AND NOT CAN-DO(cSDORequestList, cParentSDOName)) THEN
    DO:
      logNote("NOTE":U, '*******Pass through link is: ':U + getPassThruSDOInfo(1) ).

      IF (cParentSDOName = getPassThruSDOInfo(1) ) THEN
        createSDOLinks(pcLogicalObjectName, cParentSDOName, "":U, "":U, "PASSTHRU":U).
      ELSE
        ASSIGN 
          cParentSDOName = "":U
          cForeignFields = "":U.
    END.


    /* Create the TT's - This is separated as it gets called recursively */
    createSDOLinks(pcLogicalObjectName, cChildSDOName, cParentSDOName, cForeignFields, cSDOEvent).
    
    /* If the parent SDO is Null, then include all the children */
    IF (cParentSDOName = ? OR cParentSDOName = "":U) THEN
      includeSDOChildren(pcLogicalObjectName, cChildSDOName, "INCLUDED":U).

  END.

  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION returnConflict Include 
FUNCTION returnConflict RETURNS LOGICAL
  ( pcLogicalObjectName AS character,
    pcSDOName AS CHARACTER,
    pcDataColumns AS CHARACTER,
    pcData AS CHARACTER,
    phSDO AS HANDLE) :
/*------------------------------------------------------------------------------
  Purpose:  This function is called if SDO returns is a error and the error is 
            called due to a conflict. i.e if User1 reads a record and user2 reads 
            the same record and modifies it and saves the changes. Now if the 
            User1 modifies the changes and tries to save the changes, then
            it is a conflict as the user1 needs to read the latest changes 
            from the database before his changes will be accepted.
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cOut AS CHARACTER NO-UNDO.

  cOut = 'app.':U + 'd':U + pcSDOName + '.saveconflict([':U + '~n':U.
        
  /* Write to a Variable */
  pcData = appendLookupData(pcLogicalObjectName, pcSDOName, pcDataColumns, pcData) NO-ERROR.

  cOut = cOut + " '":U + pcData + "'":U + '~n':U.

  cOut = cOut + ']);':U + '~n':U.

  /* Confirm to client that events were completed. */
  gcJsRun = gcJsRun + cOut.

  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION saveContainerProperty Include 
FUNCTION saveContainerProperty RETURNS LOGICAL
  (pcLogicalObjectName AS CHARACTER,
   pcPropertyName AS CHARACTER,
   pcPropertyValue AS CHARACTER) :
/*------------------------------------------------------------------------------
  Purpose:  Saves the Container property i.e Hidden Fields etc...
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cSDOProperty AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cParamName   AS CHARACTER  NO-UNDO.
  

  cParamName = pcLogicalObjectName + "." + pcPropertyName.
  ASSIGN cSDOProperty = DYNAMIC-FUNCTION("setPropertyList":U IN gshSessionManager,
                        cParamName, pcPropertyValue, NO).
  
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION saveDSContext Include 
FUNCTION saveDSContext RETURNS LOGICAL
  ( pcLogicalObjectName AS CHARACTER,
    pcSDOList AS CHARACTER) :
/*------------------------------------------------------------------------------
  Purpose:  Sets the SDO Context
    Notes:  Replace # with CHR(3) and $ with CHR(4)
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cContextName   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSDOContext    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSDOEvent      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSDOName       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cShortSDOName  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hSDOHandle     AS HANDLE     NO-UNDO.
  DEFINE VARIABLE i1             AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cLinkedSBOs    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSBOName       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFinalDSName   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDSName        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cOverrideLogicalObjectName AS CHARACTER  NO-UNDO.

  DO i1 = 1 TO NUM-ENTRIES(pcSDOList, ",":U):
    /* The override logical object name is mainly for pass thru' link */
    ASSIGN cDSName = ENTRY(i1, pcSDOList, ",":U).

    /* This is a SDO in a SBO then save SBO context */
    IF (NUM-ENTRIES(cDSName, ".":U) > 1 ) THEN
    DO:
      ASSIGN cSBOName = ENTRY(1, cDSName, ".":U)
             cShortSDOName = ENTRY(2, cDSName, ".":U)
             cFinalDSName = cSBOName.

      IF ( LOOKUP(cSBOName, cLinkedSBOs, ",":U) > 0 )  THEN
        NEXT.
      ELSE
        ASSIGN cLinkedSBOs = cLinkedSBOs + "," + cSBOName
               cLinkedSBOs = TRIM(cLinkedSBOs, ",":U).
    END.
    ELSE
      ASSIGN cShortSDOName = cDSName
             cFinalDSName = cDSName.

    /* If the pass-thru link over rides the container name then use the 
       over riddent container name */
    ASSIGN
      cOverrideLogicalObjectName = get-value('d':U + cShortSDOName + '._object':U)
      cOverrideLogicalObjectName = TRIM(cOverrideLogicalObjectName, "|":U)
      cOverrideLogicalObjectName = TRIM(cOverrideLogicalObjectName).

    IF (cOverrideLogicalObjectName = ? OR cOverrideLogicalObjectName = "":U) THEN
      cOverrideLogicalObjectName = pcLogicalObjectName.

    FIND FIRST ttSDOLink WHERE ttSDOLInk.SDOName = cDSName NO-ERROR.
    IF NOT AVAILABLE ttSDOLink THEN NEXT.

    ASSIGN 
      cSDOEvent    = ttSDOLink.SDOEvent
      cContextName =  cOverrideLogicalObjectName + '.':U + cFinalDSName + '.context':U.

    IF CAN-DO("POSITION,PASSTHRU,ALL", cSDOEvent) THEN
      NEXT.

    /* Get the SDO Handle */
    hSDOHandle = getDSHandle(cFinalDSName, "").

    /* Get the context from SDO */
    cSDOContext = DYNAMIC-FUNCTION("obtainContextForClient":U IN hSDOHandle).

    ASSIGN
      cSDOContext = REPLACE(cSDOContext, CHR(3), '#':U)
      cSDOContext = REPLACE(cSDOContext, CHR(4), '$':U).

    /*
    logNote("note":U, "Saving context for SDO: ":U + cContextName + " is: ":U + cSDOContext).
    */
    DYNAMIC-FUNCTION("setPropertyList":U IN gshSessionManager,
                     INPUT cContextName,
                     INPUT cSDOContext,
                     INPUT NO).
  END.

  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION saveDSPath Include 
FUNCTION saveDSPath RETURNS LOGICAL
  ( pcDSName AS CHARACTER,
    pcDSPath AS CHARACTER) :
/*------------------------------------------------------------------------------
  Purpose:  set the SDO Path
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cFinalDSName    AS CHARACTER  NO-UNDO.

  IF ( NUM-ENTRIES(pcDSName, ".":U ) > 1)  THEN
    cFinalDSName = ENTRY(1, pcDSName, ".":U).
  ELSE
    cFinalDSName = pcDSName.

  DYNAMIC-FUNCTION("setPropertyList":U IN gshSessionManager,
                   cFinalDSName + ".path":U, pcDSPath, NO).
  
  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION saveDSProperty Include 
FUNCTION saveDSProperty RETURNS LOGICAL
  (pcLogicalObjectName AS CHARACTER,
   pcDSName AS CHARACTER,
   pcPropertyName AS CHARACTER,
   pcPropertyValue AS CHARACTER) :
/*------------------------------------------------------------------------------
  Purpose:  return the rows to batch for the SDO.
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cDSProperty AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cParamName   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFinalDSName    AS CHARACTER  NO-UNDO.

  IF ( NUM-ENTRIES(pcDSName, ".":U ) > 1)  THEN
    cFinalDSName = ENTRY(1, pcDSName, ".":U).
  ELSE
    cFinalDSName = pcDSName.

  cParamName = pcLogicalObjectName + "." + cFinalDSName + "." + pcPropertyName.
  ASSIGN cDSProperty = DYNAMIC-FUNCTION("setPropertyList":U IN gshSessionManager,
                        cParamName, pcPropertyValue, NO).
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION saveDSSecurity Include 
FUNCTION saveDSSecurity RETURNS LOGICAL
  (pcLogicalObjectName AS CHARACTER,
   pcDSName AS CHARACTER,
   pcPropertyValue AS CHARACTER) :
/*------------------------------------------------------------------------------
  Purpose:  return the rows to batch for the SDO.
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cSDOSecurity AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cParamName   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iFld         AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cSecurity    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFinalDSName    AS CHARACTER  NO-UNDO.

  IF ( NUM-ENTRIES(pcDSName, ".":U ) > 1)  THEN
    cFinalDSName = ENTRY(1, pcDSName, ".":U).
  ELSE
    cFinalDSName = pcDSName.

  cParamName = pcLogicalObjectName + "." + cFinalDSName + ".SecuredHiddenFields":U.
  
  ASSIGN cSDOSecurity = DYNAMIC-FUNCTION("getPropertyList":U IN gshSessionManager,
                        cParamName, NO).

  IF (cSDOSecurity > "":U) THEN
  DO:
    DO iFld = 1 TO NUM-ENTRIES(pcPropertyValue, ",":U):
      cSecurity = ENTRY(iFld, pcPropertyValue) NO-ERROR.
      IF (ERROR-STATUS:ERROR) THEN
      DO:
        ERROR-STATUS:ERROR = NO.
        NEXT.
      END.
      IF (LOOKUP(cSecurity, cSDOSecurity) > 0 ) THEN
        NEXT.
      ELSE
        cSDOSecurity = cSDOSecurity + "," + cSecurity.
    END.
  END.
  ELSE
    cSDOSecurity = pcPropertyValue.

  ASSIGN cSDOSecurity = DYNAMIC-FUNCTION("setPropertyList":U IN gshSessionManager,
                        cParamName, cSDOSecurity, NO).
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION saveDynamicDSInfo Include 
FUNCTION saveDynamicDSInfo RETURNS LOGICAL
  ( pcDSName AS CHARACTER,
    pcDynamicSDOInfo AS CHARACTER) :
/*------------------------------------------------------------------------------
  Purpose:  set the SDO Path
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cFinalDSName    AS CHARACTER  NO-UNDO.

  IF ( NUM-ENTRIES(pcDSName, ".":U ) > 1)  THEN
    cFinalDSName = ENTRY(1, pcDSName, ".":U).
  ELSE
    cFinalDSName = pcDSName.

  DYNAMIC-FUNCTION("setPropertyList":U IN gshSessionManager,
                   cFinalDSName + ".dynamicInfo":U, pcDynamicSDOInfo, NO).
  
  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setChildSDOInfo Include 
FUNCTION setChildSDOInfo RETURNS LOGICAL
  (pcLogicalObjectName AS CHARACTER,
   pcSDOName AS CHARACTER,
   pcParentSDOName AS CHARACTER,
   pcForeignFields AS CHARACTER) :
/*------------------------------------------------------------------------------
  Purpose:  Set the Child SDO list in the Context.
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cChild     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cChildren  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cName      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cParamName AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE i1         AS INTEGER    NO-UNDO.
  DEFINE VARIABLE lFound     AS LOGICAL    NO-UNDO.

  IF (pcParentSDOName > "" ) THEN
  DO:
    cParamName = pcLogicalObjectName + ".child_":U + pcParentSDOName.
    /* First find if this already exists */
    cChildren = DYNAMIC-FUNCTION("getPropertyList":U IN gshSessionManager,
                                 cParamName, NO).

    IF cChildren = ? THEN
      cChildren = "":U.

    IF (cChildren > "") THEN
    DO:
      REPEAT i1 = 1 TO NUM-ENTRIES(cChildren,"|":U):
        ASSIGN cChild = ENTRY(i1, cChildren, "|":U).
        IF ( cChild > "":U) THEN
        DO:
          ASSIGN cName  = ENTRY(NUM-ENTRIES(cChild, ",":U), cChild, ",":U).
          IF ( pcSDOName = cName )  THEN
          DO:
            lFound = TRUE.
            LEAVE.
          END.
        END.
      END.
    END.

    IF (NOT lFound) THEN
    DO:
      cChildren = cChildren + "|":U + pcForeignFields + ",":U + pcSDOName.
      DYNAMIC-FUNCTION("setPropertyList":U IN gshSessionManager, cParamName, cChildren, NO).
    END.
  END.
  RETURN FALSE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setDSHandle Include 
FUNCTION setDSHandle RETURNS LOGICAL
  ( INPUT pcDSName AS CHARACTER,
    INPUT pcDSPath AS CHARACTER,
    INPUT phDS AS HANDLE) :
/*------------------------------------------------------------------------------
  Purpose:  sets the SDO Handle
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cFinalDSName AS CHARACTER  NO-UNDO.

  IF (NUM-ENTRIES(pcDSName, ".":U) > 1) THEN
    ASSIGN cFinalDSName = ENTRY(1, pcDSName, ".":U).
  ELSE
    ASSIGN cFinalDSName = pcDSName.
  
  FIND FIRST ttSDO WHERE ttSDO.ttName = cFinalDSName EXCLUSIVE-LOCK NO-ERROR.
  IF NOT AVAILABLE ttSDO THEN 
  DO:
    IF (pcDSPath = ? OR pcDSPath = "":U) THEN
      pcDSPath = getSavedDSPath(cFinalDSName).

    CREATE ttSDO.
    ASSIGN ttSDO.ttName = cFinalDSName
           ttSDO.ttPath = pcDSPath.
  END.
  ASSIGN ttSDO.ttHandle = phDS.

  RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION traverseAndBuildDSList Include 
FUNCTION traverseAndBuildDSList RETURNS CHARACTER
  (pcSDOList AS CHARACTER,
   pcParentSDOName AS CHARACTER) :
/*------------------------------------------------------------------------------
  Purpose: Based on parent child relations, traverse and build a SDO list.
           This is required as the parent SDO needs to be provided to the
           container before the child SDO is provided. 
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE BUFFER bttSDOLink FOR ttSDOLink.

  FOR EACH bttSDOLink NO-LOCK
     WHERE bttSDOLink.ParentSDOName = pcParentSDOName 
       AND NOT CAN-DO(bttSDOLink.SDOName, pcSDOList):

    IF ( DYNAMIC-FUNCTION("IsA":U IN gshRepositoryManager,bttSDOLink.SDOName,"SBO":U)) THEN
      NEXT.

    pcSDOList = pcSDOList + ",":U + bttSDOLink.SDOName.
    pcSDOList = TRIM(pcSDOList, ",":U).
    pcSDOList = traverseAndBuildDSList(pcSDOList, bttSDOLink.SDOName).
  END.
  RETURN pcSDOList.   /* Function return value. */
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

