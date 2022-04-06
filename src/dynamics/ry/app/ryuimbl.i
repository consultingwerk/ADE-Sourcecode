&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
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
* Copyright (C) 2005 by Progress Software Corporation. All rights    *
* reserved.  Prior versions of this work may contain portions        *
* contributed by participants of Possenet.                           *
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD appendComments Include 
FUNCTION appendComments RETURNS CHARACTER PRIVATE
  ( pcContext AS CHARACTER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD appendLookupData Include 
FUNCTION appendLookupData RETURNS CHARACTER
  ( pcLogicalObjectName AS CHARACTER,
    pcSDOName AS CHARACTER,
    pcSDOCols AS CHARACTER,
    pcSDOValues AS CHARACTER,
    plAppendData AS LOGICAL)  FORWARD.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD cleanupDataObjects Include 
FUNCTION cleanupDataObjects RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getCLOBValue Include 
FUNCTION getCLOBValue RETURNS {&clobtype}
  (pcColumnName AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getDataSourceHandle Include 
FUNCTION getDataSourceHandle RETURNS HANDLE
  ( INPUT pcLogicalObjectName AS CHARACTER,
    INPUT pcDSName AS CHARACTER,
    INPUT pcDSPath AS CHARACTER)  FORWARD.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getNewCLOBValue Include 
FUNCTION getNewCLOBValue RETURNS {&clobtype}
  ( pcColumnName AS CHARACTER)  FORWARD.

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
  ( pcLogicalObjectName as CHARACTER, 
    pcDSName AS CHARACTER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getSDODataColumns Include 
FUNCTION getSDODataColumns RETURNS CHARACTER
  ( pcLogicalObjectName AS CHARACTER,
    phSDOHandle AS HANDLE,
    plUpdatable AS LOGICAL,
    plIncludeCLOBS AS LOGICAL)  FORWARD.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD loadCLOBData Include 
FUNCTION loadCLOBData RETURNS LOGICAL
  ( pcLogicalObjectName AS CHARACTER,
    pcSDOName AS CHARACTER,
    piCounter AS INTEGER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD ouputConflictData Include 
FUNCTION ouputConflictData RETURNS LOGICAL
  ()  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD outputCLOBData Include 
FUNCTION outputCLOBData RETURNS LOGICAL
  ( pcSDOName AS CHARACTER,
    piCoutner AS INTEGER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD outputComboData Include 
FUNCTION outputComboData RETURNS LOGICAL
  ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD outputCommittedData Include 
FUNCTION outputCommittedData RETURNS LOGICAL
  ()  FORWARD.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD processFilterInfo Include 
FUNCTION processFilterInfo RETURNS LOGICAL PRIVATE
  ( pcOverrideLogicalObjectName AS CHARACTER,
      pcDSName AS CHARACTER,
      pcSDOName AS CHARACTER,
      pcSDOEvent AS CHARACTER,
      plSaveFilter AS LOGICAL,
      phDS AS HANDLE) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD removeCLOBColumns Include 
FUNCTION removeCLOBColumns RETURNS CHARACTER PRIVATE
  (pcLogicalObjectname AS CHARACTER,
   pcObjectName AS CHARACTER,
   pcDataColumns AS CHARACTER,
   pcData AS CHARACTER)  FORWARD.

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
  ( pcLogicalObjectName as CHARACTER,
    pcDSName AS CHARACTER,
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setDataSourceHandle Include 
FUNCTION setDataSourceHandle RETURNS LOGICAL
  ( INPUT pcLogicalObjectName AS CHARACTER, 
    INPUT pcDSName AS CHARACTER,
    INPUT pcDSPath AS CHARACTER,
    INPUT phDS AS HANDLE)  FORWARD.

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
  DEFINE VARIABLE i2                         AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cLinkedSBOs                AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cChildSBOName              AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cOnlyChildSDOName          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDSName                    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cOverrideLogicalObjectName AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cChildDSName               AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hSDO                       AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cSDOName                   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSDOs                      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cParentSDOName             AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cForeignFields             AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDestroyStateless          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cLogicalDSName             AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDSIsSBO                   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lDSIsSBO                   AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cFinalLogicalName          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cEntityFields              AS CHARACTER  NO-UNDO.
  
  hParent = ?.
  cFinalLogicalName = "":U.
         
  /* Start the container */
  IF NOT VALID-HANDLE(ghSDOContainer) THEN
    RUN adm2/dyncontainer.w PERSISTENT SET ghSDOContainer NO-ERROR.

  REPEAT i1 = 1 TO NUM-ENTRIES(pcSDOList,",":U):
  
    ASSIGN cChildDSName  = ENTRY(i1, pcSDOList, ",":U).

    /* First check if the DS to be started is SBO */
    ASSIGN cDSIsSBO = getSavedDSProperty(pcLogicalObjectName, cChildDSName, 'isSBO':U)
           lDSIsSBO = (IF cDSIsSBO > "":U THEN LOGICAL(cDSIsSBO) ELSE NO).

    /* This is a SDO in a SBO start SBO which will start the SDO's */
    IF (lDSIsSBO OR NUM-ENTRIES(cChildDSName, ".":U) > 1 ) THEN
    DO:
      ASSIGN cChildSBOName = ENTRY(1, cChildDSName, ".":U)
             cChildSDOName = ENTRY(2, cChildDSName, ".":U)
             cDSName = cChildSBOName
             cLogicalDSName = cChildSBOName
             lDSIsSBO = YES.

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
             cLogicalDSName = ?
             lDSIsSBO = NO
             cDSName = cChildSDOName.
    END.
    
    FIND FIRST ttSDOLink NO-LOCK
       WHERE ttSDOLink.SDOName = cChildDSName NO-ERROR.
    IF NOT AVAILABLE ttSDOLink THEN NEXT.

    IF (ttSDOLink.ParentSDOName = "":U) THEN
      hParent = ?.

    /* If the data needs to be fetched for some other container do the override stuff */
    ASSIGN 
      cOverrideLogicalObjectName = get-value('_':U + cChildSDOName + '._object':U)
      cOverrideLogicalObjectName = TRIM(cOverrideLogicalObjectName, "|":U)
      cOverrideLogicalObjectName = TRIM(cOverrideLogicalObjectName).
    
    /* If this is a pass thru object then get the context from the pass thru' container */
    IF (cOverrideLogicalObjectName = ? OR cOverrideLogicalObjectName = "":U) THEN
    DO:
      IF (cDSName = getPassThruSDOInfo(2)) THEN
        ASSIGN cOverrideLogicalObjectName = getPassThruSDOInfo(1).
      ELSE
        ASSIGN cOverrideLogicalObjectName = pcLogicalObjectName.
    END.
    
    IF (cOverrideLogicalObjectName = ? OR cOverrideLogicalObjectName = "":U) THEN
      cOverrideLogicalObjectName = pcLogicalObjectName.

    cContext = getSavedDSContext(cOverrideLogicalObjectName, cDSName, '':U).

    IF (cContext = ? OR cContext = "":U ) THEN
      cContext = getSavedDynamicDSInfo(cOverrideLogicalObjectName, cDSName).

    ASSIGN cParentSDOName = "":U
           cForeignFields = "":U.

    RUN getParentDS( INPUT cOverrideLogicalObjectName, 
                      INPUT cChildDSName, 
                     OUTPUT cParentSDOName, 
                     OUTPUT cForeignFields) NO-ERROR.

    IF ( cParentSDOName > "":U AND cParentSDOName <> "master") THEN
      hParent = getDataSourceHandle(cOverrideLogicalObjectName, cParentSDOName, "":U).
    ELSE
      hParent = ?.

    {log "'adding: ' + cDSName + ' with parent: ' + cParentSDOName + ' and foreign fields: ' + cForeignFields"}
    IF cLogicalDSName > "":U THEN
    DO:
      ASSIGN cFinalLogicalName = getSavedDSProperty(cOverrideLogicalObjectName, cDSName, 'ObjectName':U).
      IF cFinalLogicalName = "":U OR cFinalLogicalName = ? THEN
        ASSIGN cFinalLogicalName = cLogicalDSName.
    END.
    
    /*  Append HasComments and HasAutoComments to the context */
    IF NOT lDSIsSBO THEN
      cContext = appendComments(cContext).
    
    hChild = DYNAMIC-FUNCTION('insertDataObject':U IN ghSDOContainer,
                               cFinalLogicalName,
                               getSavedDSPath(cDSName),
                               cDSName,
                               hParent, 
                               cForeignFields, 
                               cContext).
    
    {log "'SDO name: ' + cDSName + ' Handle: ' + STRING(hChild)"}.
     
    ASSIGN cDestroyStateless = getSavedDSProperty(cOverrideLogicalObjectName, cChildSDOName, 'DestroyStateless':U).
    IF cDestroyStateless = ? OR cDestroyStateless = "":U THEN
      ASSIGN cDestroyStateless = "no".
    DYNAMIC-FUNCTION('setDestroyStateless' IN hChild, cDestroyStateless) NO-ERROR.
    
    IF ( cChildSBOName > '':U) THEN
    DO:
      cSDOs = TRIM(DYNAMIC-FUNCTION("getContainedDataObjects":U IN hChild)) NO-ERROR.
      DO i2 = 1 TO NUM-ENTRIES(cSDOs):
        ASSIGN hSDO     = WIDGET-HANDLE(ENTRY(i2, cSDOs, ",":U))
               cSDOName = DYNAMIC-FUNCTION("getObjectName":U IN hSDO ).
               
        {get EntityFields cEntityFields hSDO}.
        IF cContext = '':U THEN
        DO:
          {set FetchHasComment TRUE hSDO}.
          RUN initializeEntityDetails IN hSDO.
        END.
        
        DYNAMIC-FUNCTION('setDataReadHandler' IN hSDO, THIS-PROCEDURE).
        DYNAMIC-FUNCTION('setOpenOnInit' IN hSDO, FALSE).
        DYNAMIC-FUNCTION('setDataReadColumns' IN hSDO, getSDODataColumns(cOverrideLogicalObjectName, hSDO, NO, NO)).
        DYNAMIC-FUNCTION('setDataDelimiter':U IN hSDO, getSavedDSDataDelimiter(cOverrideLogicalObjectName, cChildSDOName)).
        DYNAMIC-FUNCTION('setDataReadFormat':U IN hSDO, 'Formatted':U).
      END.
    END.
    ELSE
    DO:
      /* Rebuild on reposition */
      DYNAMIC-FUNCTION('setRebuildOnRepos':U IN hChild, TRUE).

      /* Set the Rows to batch */
      DYNAMIC-FUNCTION('setRowsToBatch':U IN hChild, INTEGER(getSavedDSProperty(cOverrideLogicalObjectName, cChildSDOName, 'RowsToBatch':U))).
    
      DYNAMIC-FUNCTION('setDataReadHandler' IN hChild, THIS-PROCEDURE).
      DYNAMIC-FUNCTION('setDataReadColumns' IN hChild, getSDODataColumns(cOverrideLogicalObjectName, hChild, NO, NO)).
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE exportLOB Include 
PROCEDURE exportLOB :
/*------------------------------------------------------------------------------
  Purpose:     This procedure will export the LOB column.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hSDO   AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cRowId AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE mVal   AS MEMPTR     NO-UNDO.
  
  ASSIGN hSDO   = getDataSourceHandle(get-value("logicalobjectname"), get-value("sdoname"), ?)
         cRowId = get-value('rowident':U).
         
  DYNAMIC-FUNCTION('setRebuildOnRepos':U IN hSDO, TRUE).
  DYNAMIC-FUNCTION('setRowsToBatch':U IN hSDO, 1).

  IF (cRowId > "":U) THEN
    DYNAMIC-FUNCTION('fetchRowIdent':U IN hSDO, cRowId, "").
  
  DYNAMIC-FUNCTION("copyLargeColumnToMemptr" IN hSDO, get-value("columnname"), mval).
  {&out-long} mval.
  
  SET-SIZE(mval) = 0.

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
    IF (pcParentSDOName = 'master':U AND getPassThruSDOInfo(2) > "":U) THEN
    DO:
      pcParentSDOName = getPassThruSDOInfo(2).
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
  DEFINE VARIABLE cAllEntries    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cAllValues     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cProperties    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cValue         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iCount         AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cExportData    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cExportLOBData AS CHARACTER  NO-UNDO.
  
  /* Initialize Global values */

  ASSIGN
    cExportData          = get-value('export':U)
    cExportLOBData       = get-value('exportLOB':U)
    glExportData         = (cExportData > '':U OR cExportLOBData > '':U)
    glExportLOBData      = (cExportLOBData > '':U)
    gcRequestEvents      = get-value('do':U)   
    glNeedToDoUI         = (gcRequestEvents = '' OR gcRequestEvents = ?)
    glDoMainMenu         = FALSE
    cProperties          = DYNAMIC-FUNCTION("getPropertyList":U IN gshSessionManager,
                             "currentUserObj,currentLanguageObj,BaseHref,CssTheme":U, YES)
    gdCurrentUserObj     = DECIMAL(ENTRY(1, cProperties, CHR(3)))
    gdCurrentLanguageObj = DECIMAL(ENTRY(2, cProperties, CHR(3))) 
    gcBaseHref           = ENTRY(3, cProperties, CHR(3)) 
    gcCssTheme           = ENTRY(4, cProperties, CHR(3)) 
    NO-ERROR.

  /* Move get-value() into temp-tables.              *
   * Copy request data into session/context data...  *
   
  ASSIGN
    cAllEntries = get-value(?).

  DO iCount = 1 TO NUM-ENTRIES(cAllEntries):
     * DHTML client returns values in pipe ('|') delimited lists, always *
     *  with the first entry blank (for client-side performance) so here *
     *  we remove the first entry                                        *
    ASSIGN
      cValue     = TRIM(get-value(ENTRY(iCount, cAllEntries)))
      cAllValues = cAllValues + (IF iCount = 1 THEN "" ELSE CHR(3)) + 
        IF SUBSTRING(cValue, 1, 1) = "|" THEN SUBSTRING(cValue, 2) ELSE cValue.
      
  END.
  */
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
  DEFINE VARIABLE cSBOName        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDSName         AS CHARACTER  NO-UNDO.
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
  DEFINE VARIABLE cCleanup        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lIsSBO          AS LOGICAL    NO-UNDO.

  /* get the links for the SDO list 
     - NOTE THIS WILL POPULATE the ttSDOLink table used later */
  {log "'request events are: ' + pcRequestEvents"}

  populateDSLinks(pcLogicalObjectName, pcRequestEvents).

  /* Build the SDO list by traversing the parent child relations */
  cSDOList = traverseAndBuildDSList("":U, "":U).

  {log "'SDO list for events is: ' + cSDOList"}

  /* Start a container and Link all the SDO's */
  RUN createLinksInContainer(pcLogicalObjectName, 
                                pcRequestEvents, 
                                cSDOList) NO-ERROR.

  /* Get the data for only the top level SDO's */
  FOR EACH ttSDOLink 
     WHERE ttSDOLInk.parentSDOName = "":
    
    ASSIGN 
      cSDOName    = ttSDOLink.SDOName
      cDSName     = cSDOName
      cSDOEvent   = ttSDOLink.SDOEvent
      cRowId      = '':U
      cSBOName    = ''.
      
    IF NUM-ENTRIES(cSDOName,'.':U) > 1 THEN 
      ASSIGN
        cSBOName = ENTRY(1,cSDOName,'.')
        cSDOName = ENTRY(2,cSDOName,'.')
        lIsSBO   = YES.

    /* If the pass-thru link over rides the container name then use the 
       over riddent container name */
    ASSIGN 
      cOverrideLogicalObjectName = get-value('_':U + cSDOName + '._object':U)
      cOverrideLogicalObjectName = TRIM(cOverrideLogicalObjectName, "|":U)
      cOverrideLogicalObjectName = TRIM(cOverrideLogicalObjectName).
    
    IF (cOverrideLogicalObjectName = ? OR cOverrideLogicalObjectName = "":U) THEN
      cOverrideLogicalObjectName = pcLogicalObjectName.
    
    {log "'Firing event: ' + cSDOEvent + ' on SDO: ' + cSDOName + ',SBO=' + cSBOName + ' DS name:' + cDSName"}

    /* Get the SDO Handle */
    hDS = getDataSourceHandle(cOverrideLogicalObjectName, cDSName, "").
    IF NOT VALID-HANDLE(hDS) THEN
    DO:
      {log "'ERROR - Could not get valid handle for SDO: ' + cDSName"}
      NEXT.
    END.

    IF NOT lIsSBO THEN
    DO:
      /* set the FillBatchOnRepos */
      cFillBatchOnRepos = getSavedDSProperty(cOverrideLogicalObjectName, cDSName, 'FillBatchOnRepos':U).
      IF (cFillBatchOnRepos = ? OR cFillBatchOnRepos = "":U) THEN
        cFillBatchOnRepos = "yes".
      DYNAMIC-FUNCTION('setFillBatchOnRepos':U IN hDS, LOGICAL(cFillBatchOnRepos)).

    END.
    
    /* This is a temperory fix for the lookups to set the DestroyStateless to yes 
       Since lookup sdo is a locally manufactured SDO, for now, we will hardcode it 
       based on the name - THIS value has to be Yes as we use the same name for 
       multiple lookup SDO's */
    IF cSDOName = 'lookup':U THEN
      DYNAMIC-FUNCTION("setDestroyStateless":U IN hDS, YES).
    
    /* If the first/last record in the batch was deleted then this logic will 
       fix the navigation from breaking 
    */
    ASSIGN 
      cFirstResultRow = get-value('_':U + cSDOName + '._first':U)
      cLastResultRow = get-value('_':U + cSDOName + '._last':U)
      cPos = "1":U.

    IF (cFirstResultRow > "" ) THEN
      DYNAMIC-FUNCTION('setFirstResultRow':U IN hDS, cPos + ";":U + cFirstResultRow).

    IF (cLastResultRow > "" ) THEN
    DO:
      ASSIGN cPos = ENTRY(1, DYNAMIC-FUNCTION('getLastResultRow':U IN hDS), ";":U) NO-ERROR.
      DYNAMIC-FUNCTION('setLastResultRow':U IN hDS, cPos + ";":U + cLastResultRow).
    END.
    
    /* Set the queryFilter */
    IF (cSDOEvent <> "FILTER":U AND cSDOEvent <> "MORE") THEN
      RUN queryFilter (cOverrideLogicalObjectName, cDSName, cSDOEvent, hDS, NO) NO-ERROR.

    lognote('','EVENT:' + cDSName + '=>' + cSDOEvent).

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
        IF (cSDOEvent =  'PASSTHRU') THEN
          cRowId = getPassThruSDOInfo(3) NO-ERROR.
        ELSE 
          ASSIGN
            cRowId = get-value('_':U + cSDOName + '._position':U)
            cRowId = TRIM(cRowId, '|':U).
        {log "'Position row id is: ' +  cSDOName + '/' + cRowid"}

        /* Reposition the record */
        IF (cRowId > "":U) THEN
          DYNAMIC-FUNCTION('findRowInCurrentBatch':U IN hDS, "RowObject.RowIdent", cRowId, "":U).
      END.
      WHEN "FILTER":U THEN
      DO:
        /* Process and set the filter information */
        processFilterInfo(cOverrideLogicalObjectName, cDSName, cSDOName, cSDOEvent, ttSDOLink.SaveFilter, hDS).
        
        /* Fetch the first batch */
        RUN fetchFirstBatch IN hDS.
      END.
      WHEN "MORE":U THEN
      DO:
        /* Process and set the filter information */
        processFilterInfo(cOverrideLogicalObjectName, cDSName, cSDOName, cSDOEvent, no, hDS).
  
        /* Get and set the last batch row num - This is must or it will not find the NEXT batch */
        ASSIGN cPos = ENTRY(1, DYNAMIC-FUNCTION('getLastResultRow':U IN hDS), ";":U) NO-ERROR.
        DYNAMIC-FUNCTION('setLastResultRow':U IN hDS, cPos + ";":U + cLastResultRow).
        DYNAMIC-FUNCTION('setFillBatchOnRepos':U IN hDS, false).  /* Make sure navigates right */
     
        /* Fetch the Next batch */
        RUN fetchNextBatch IN hDS.
      END.
      WHEN "FIND":U THEN
      DO:
        ASSIGN 
          cFind       = get-value('_':U + cSDOName + '._find':U)
          cFindKey    = cOverrideLogicalObjectName + ".":U + cDSName + ".find":U.
          
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
    cDSName = ENTRY(i1, cSDOList).

    /*
    * if this not an SBO then proceed *
    IF ( DYNAMIC-FUNCTION("IsA":U IN gshRepositoryManager,cDSName,"SBO":U)) THEN
      NEXT.
    */

    /* If the pass-thru link over rides the container name then use the 
       over riddent container name */

    ASSIGN 
      cOverrideLogicalObjectName = get-value('_':U + ENTRY(NUM-ENTRIES(cDSName,'.'),cDSName,'.') + '._object':U)
      cOverrideLogicalObjectName = TRIM(cOverrideLogicalObjectName, "|":U)
      cOverrideLogicalObjectName = TRIM(cOverrideLogicalObjectName).
    
    IF (cOverrideLogicalObjectName = ? OR cOverrideLogicalObjectName = "":U) THEN
      cOverrideLogicalObjectName = pcLogicalObjectName.
    
    /* Find the Event */
    FIND FIRST ttSDOLink WHERE ttSDOLink.SDOName = cDSName NO-ERROR.
    IF NOT AVAILABLE ttSDOLink THEN NEXT.

    /* Make sure that SDO data exists. There are valid events 
       (POSITION,PASSTHRU) when the SDO may not have data. */
    IF CAN-DO("POSITION,PASSTHRU":U, ttSDOLink.SDOEvent)  THEN
       NEXT.

    FIND FIRST ttSDOData WHERE ttSDOData.SDOName = cDSName NO-ERROR.

    /* Output any Header Information */
    outputSDOHeader(cOverrideLogicalObjectName, cDSName, plExportData).

    /* Output the SDO Data */
    iCounter = outputSDOData(cOverrideLogicalObjectName, cDSName, plExportData). 

    /* Find the SDO Position to Enable disable the navigation buttons */
    /* -1 = Last, 1 = First or Filter, 0 = Complete Batch, 9 otherwise */
    IF (NOT plExportData) THEN
      iBatchNum = findSDOPosition(cDSName, ?).

    /* Output any SDO footer information  */
    IF (NOT plExportData) THEN
      outputSDOFooter(cOverrideLogicalObjectName, cDSName, STRING(iBatchNum)).

  END. /* for each SDO object (ghObjectBuffer) */

  /* Do the cleanup */
  cCleanup = get-value("_cleanupdataobjects").
  IF (cCleanup <> "NO") THEN 
  DO:
    {log "'Destroying Data Objects and the Dyn container'"}
    cleanupDataObjects().
  END.

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
  DEFINE OUTPUT PARAMETER phSDOHandle AS HANDLE NO-UNDO.
  

  DEFINE VARIABLE iCounter       AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iBatchNum      AS INTEGER    NO-UNDO.
  DEFINE VARIABLE c1             AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDisplayField  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cQueryFields   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cQueryString   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cWhere         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cQueryTables   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cQueryValue    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cContextName   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSDOContext    AS CHARACTER  NO-UNDO.


  /* The context for the SDO exists, then do nothing */
  /*  Can have different WHERE clause for input values  
    IF ( getSavedDSContext(pcLogicalObjectName, pcSDOName) > '':U ) THEN
      RETURN.
  */

  c1 = DYNAMIC-FUNCTION("getPropertyList":U IN gshSessionManager,
                         pcLogicalObjectName + ".":U + gcLookupObjectName + ".lookup":U, NO).
  {log "'Lookupcxt:' + pcLogicalObjectName + '.':U + gcLookupObjectName + '.lookup' + '=' + c1"}  

  ASSIGN
    cQueryString  = ENTRY(5,c1,CHR(4))
    cQueryTables  = ENTRY(6,c1,CHR(4))
    cQueryFields  = ENTRY(1,c1,CHR(4)) + ",":U + ENTRY(10,c1,CHR(4))
    cDisplayField = ENTRY(2,c1,CHR(4))
    cQueryValue   = GET-VALUE('lookup')
  NO-ERROR.

  /* Start the Dynamic SDO */
  RUN adm2/dynsdo.w PERSISTENT SET phSDOHandle.
  
  {log "'defineDataObject:' + cQueryString"}  
  
  DYNAMIC-FUNCTION("defineDataObject":U IN phSDOHandle,
                   cQueryTables,
                   cQueryString,
                   cQueryFields,
                   "NO" ).
  
  DYNAMIC-FUNCTION("setDestroyStateless":U IN  phSDOHandle, TRUE).
  {log "'initializeObject:' + cQueryString"}  
  
  /* Initialize the object */
  RUN initializeObject IN phSDOHandle.
  /* Fetch the first record */
  RUN fetchFirst IN phSDOHandle.
  
  /* Save the SDO Context in Lookup SDO */  
  
  cContextName =  gcLookupObjectName + '.':U + pcSDOName + '.context':U.

  /* Get the context from SDO */
  cSDOContext = DYNAMIC-FUNCTION("obtainContextForClient":U IN phSDOHandle).
  ASSIGN
    cSDOContext = REPLACE(cSDOContext, CHR(3), '#':U)
    cSDOContext = REPLACE(cSDOContext, CHR(4), '$':U).


  {log "'setPropertyList:' + cContextName + '=' + cSDOContext"}  
  
  DYNAMIC-FUNCTION("setPropertyList":U IN gshSessionManager,
                   INPUT cContextName,
                   INPUT cSDOContext,
                   INPUT NO).
                   
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
  DEFINE INPUT PARAMETER AppProgram  AS CHARACTER  NO-UNDO.
  
  DEFINE VARIABLE lResult            AS LOGICAL    NO-UNDO INITIAL TRUE.
  DEFINE VARIABLE iLookup            AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iCombo             AS INTEGER    NO-UNDO.
  DEFINE VARIABLE i1                 AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cRequestEvent      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cComboName         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cComboValues       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cComboJS           AS CHARACTER  NO-UNDO.
 
  CREATE WIDGET-POOL "B2BUIM":U.
  ASSIGN gcLogicalObjectName = AppProgram
         gcLookupContainerName = gcLogicalObjectName
         glOutputSDODefinition = FALSE.

  /* Move SDO events processing (for db updating, Add/Update/Delete) 
     to Request (or Event) Manager */
  gcJsRun = "":U.

  /* The error handling in processResponse takes care of any errors so we 
     don't care about the Errror status */
  IF (NOT glExportData) THEN
    RUN processResponse(gcLogicalObjectName, gcRequestEvents, OUTPUT lResult) NO-ERROR.
  {log "'Request' + gcRequestEvents"}
  
  /* Reset the error status */
  ERROR-STATUS:ERROR = FALSE.
  
  /* Save user settings - Still to be implemented */
  IF (NOT glExportData) THEN
    RUN saveUserSettings.
  
  IF (NOT glExportData) THEN
  DO:
    /* Start output of page */
    IF (glNeedToDoUI) THEN  
      RUN screenUI NO-ERROR.
    ELSE 
      RUN screenData NO-ERROR.
    
    /* Special treat dynLookups when launched via button from hidden screen */
    IF ( NOT ERROR-STATUS:ERROR ) THEN
    DO:
      iLookup = INDEX(gcRequestEvents,"|lookup.launch.").
      IF iLookup > 0 THEN 
      DO:
        ASSIGN gcRequestEvents = TRIM(gcRequestEvents, "|":U)
               gcLookupObjectName = ENTRY(3,gcRequestEvents,'.')
               gcLogicalObjectName = gcLookupObjectName. 
               
        RUN runLookup(INPUT ENTRY(4,gcRequestEvents,'.')).
      END.

      iCombo = INDEX(gcRequestEvents,".combodata").
      IF iCombo > 0 THEN
      DO:
        REPEAT i1 = 1 TO NUM-ENTRIES(gcRequestEvents,"|":U):
          /* Find the request */
          ASSIGN cRequestEvent = ENTRY(i1, gcRequestEvents, "|":U).
          IF ( INDEX(cRequestEvent,'.combodata') > 0 ) THEN
          DO:
            
            ASSIGN cComboName = SUBSTRING(cRequestEvent, 1, INDEX(cRequestEvent,'.combodata') - 1).
            {log "'comboname=' + cComboName"}
            RUN runCombo( INPUT gcLogicalObjectName, 
                          INPUT cComboName, 
                          INPUT NO, 
                          INPUT '|':U).
          END.
        END.
      END.
    END.
  END.
  
  IF (lResult AND (NOT ERROR-STATUS:ERROR ) AND (NOT glExportLOBData)) THEN
    RUN processEvents(gcLogicalObjectName, gcRequestEvents, glExportData) NO-ERROR.

  IF ((NOT glExportData) AND (NOT ERROR-STATUS:ERROR)) THEN
    RUN screenEnd.

  IF (glExportLOBData) THEN
    RUN exportLOB.
    
  RUN requestCleanup.

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
  DEFINE VARIABLE cSDOCols        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cLookupCols     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSDOEvent       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSDOEvents      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cdSDOName       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cTarget         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hSDO            AS HANDLE     NO-UNDO.
  DEFINE VARIABLE i1              AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iCols           AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iRun            AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iSDOEvents      AS INTEGER    NO-UNDO.
  DEFINE VARIABLE lLogic          AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cOut            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cData           AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDataColumns    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cNewColValues   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cOldColValues   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cError          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cASDOCols       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cOldVal         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cNewVal         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cConflictError  AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE cDSName         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDSSaveEvent    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lDSisSBO        AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE hSBO            AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cAutoCommit     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lAutoCommit     AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cSBOName        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hDS             AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cRowsToBatch    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cCurrentDS      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iSaveSuccess    AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cDeleteColumn   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cOverrideObjectName AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cLookupParamName    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDSLookupList       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cLookupParams       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cLookupParam        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cLookup             AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cKeyField           AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDataName           AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cLookupData         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE temp                AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDataColumn         AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cParamName          AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cCLOBColumns        AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cName               AS CHARACTER NO-UNDO.

  /* See if there is any processing to do (from client request), e.g. 'do' =
     'orderfullo.save'.  If no Add, Update, Delete or business logic events 
     then exit (nothing to process - probably navigation OR menuselection) */

  pcRequestEvents = TRIM(pcRequestEvents, "|":U).

  IF INDEX(pcRequestEvents, ".add":U)        = 0 AND
     INDEX(pcRequestEvents, ".update":U)     = 0 AND 
     INDEX(pcRequestEvents, ".delete":U)     = 0 AND 
     INDEX(pcRequestEvents, ".run":U)        = 0 AND /* business logic (dma) */
     INDEX(pcRequestEvents, ".dyntree":U)    = 0 AND /* treedata fetch (psd) */
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
    IF INDEX(cEntry, ".run":U) > 0 THEN 
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
        lLogic   = TRUE                                  /* PSD - ??? unused */
        plSuccess = (IF i1 = 1 THEN FALSE ELSE plSuccess).
        
        /* If this is the only event, then we don't want regular SDO
           processing.  Otherwise, let regular SDO processing determine
           the plSuccess state. */
      RUN adm2/callstring.p (cCall, cTarget, cFlags, cParams).
      NEXT.
    END.
    ELSE IF INDEX(cEntry, ".dyntree":U) > 0 THEN DO:
      {log "'Dyntree' + cEntry"}
      RUN getTreeData(cEntry). 
      NEXT.
    END.
    ELSE IF NOT INDEX(cEntry, ".save":U) > 0 THEN DO:
      NEXT.
    END.
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

  /* Start the loop for each object */
  FOR EACH ttDSSaveEvents:

    cDSName = ttDSSaveEvents.DSName.
    lDSisSBO = ttDSSaveEvents.IsSBO.

    {log "'Save Events for object: ':U + cDSName + ' are: ':U + ttDSSaveEvents.DSSaveEvent"}
    DO i1 = 1 TO NUM-ENTRIES(ttDSSaveEvents.DSSaveEvent, ",":U):

      cEntry = ENTRY(i1, ttDSSaveEvents.DSSaveEvent, ",":U).

      /* If there is no event - then ignore */
      IF cEntry = "" THEN NEXT.
      IF NUM-ENTRIES(cEntry, ".":U) <= 1  THEN
        NEXT.
  
      /* Process SDO events */
      ASSIGN
        gcSaveSDOName  = ENTRY(1, cEntry, ".":U)
        cdSDOName = '_':U + gcSaveSDOName.

      IF (gcSaveSDOName = ? OR gcSaveSDOName = "") THEN NEXT.

      ASSIGN
        cSDOEvents = get-value(cdSDOName + "._do":U)
        cOverrideObjectName = get-value(cdSDOName + "._object":U).

      IF (cSDOEvents = ? OR cSDOEvents = "") THEN NEXT.

      IF (cOverrideObjectName = ? OR cOverrideObjectName = "":U ) THEN
        cOverrideObjectName = pcLogicalObjectName.

      /* Get the data delimiter */
      gcDataDelimiter = getSavedDSDataDelimiter(cOverrideObjectName, cDSName).
      IF ( gcDataDelimiter = ? OR gcDataDelimiter = "":U ) THEN
        gcDataDelimiter = "|".

      /* Find the auto commit - This needs to happen as some times, the auto commit info is missing*/
      cAutoCommit = getSavedDSProperty(cOverrideObjectName, cDSName, "AutoCommit").
      ASSIGN lAutoCommit = LOGICAL(cAutoCommit) NO-ERROR.
      IF lAutoCommit = ? THEN lAutoCommit = TRUE.

      /* Get individual SDO events from client request, e.g. 
         'dorderfullo.do' = 'update|add'.  
      */

      /* Instantiate SDO or SBO */
      IF lDSisSBO THEN
      DO:
        ASSIGN 
          cSBOName = cDSName
          hSBO = getDataSourceHandle(cOverrideObjectName, cDSName, ?)
          hSDO = findSDOHandleInSBO(cOverrideObjectName, cDSName, hSBO, gcSaveSDOName)
          hDS = hSBO
          cDataName = cSBOName + "." + gcSaveSDOName.
      END.
      ELSE
      DO:
        ASSIGN 
          hSDO = getDataSourceHandle(cOverrideObjectName, gcSaveSDOName, ?)
          cSBOName = "":U
          hDS = hSDO
          cDataName = gcSaveSDOName.
      END.

      /* Clear any previous filters and sorts - Remove the values from the DS 
         This is required for the case when you apply filter -add a record 
         outside the filter and then change the record that was just added. */
      RUN queryFilter (INPUT cOverrideObjectName, INPUT cDataName, INPUT "":U, INPUT hSDO, INPUT YES).
      
      cRowsToBatch = getSavedDSProperty(cOverrideObjectName, gcSaveSDOName, 'RowsToBatch':U).
      IF ( cRowsToBatch = ? OR cRowsToBatch = "" ) THEN
        cRowsToBatch = "50".
      
      /* Set defaults */
      IF NOT lDSisSBO THEN
      DO:
        DYNAMIC-FUNCTION('setRebuilDOnRepos':U IN hSDO, TRUE). 
        DYNAMIC-FUNCTION('setRowsToBatch':U IN hSDO, INTEGER(cRowsToBatch)).
        DYNAMIC-FUNCTION('setDataDelimiter':U IN hSDO, gcDataDelimiter).
      END.
      
      DYNAMIC-FUNCTION('setAutoCommit':U IN hDS, lAutoCommit).
      DYNAMIC-FUNCTION('setDataReadFormat':U IN hSDO, 'Formatted':U).

      ASSIGN
        c1 = getSDODataColumns(cOverrideObjectName, hSDO, NO, YES)
        cParamNames  = "":U
        cDataColumns = '':U
        cLookupCols  = '':U.
      
      /* Get data columns and build column list */
      DO iCols = 1 to NUM-ENTRIES(c1):
        /* Strip any tablename prefix eg 'order.' from SDO cols */
        cCol = ENTRY(iCols, c1).
        IF INDEX(cCol, '.':U) > 0 THEN
          cCol = ENTRY(NUM-ENTRIES(cCol, ".":U), cCol, '.':u).
        ASSIGN
          cParamNames  = cParamNames + ',':U + cdSDOName + '.':U + cCol.

        IF lDSIsSBO THEN
          cDataColumns = cDataColumns + gcSaveSDOName + "." + cCol + ',':u.
        ELSE
          cDataColumns = cDataColumns + cCol + ',':u.
      END.
      
      ASSIGN 
        cDataColumns = TRIM(cDataColumns, ',':U)
        cParamNames  = TRIM(cParamNames, ',':U)
&IF DEFINED(newdatatypes) &THEN
        cCLOBColumns = DYNAMIC-FUNCTION("getCLOBColumns" IN hSDO)
&ENDIF
        .

      /* Find the lookup columns - This could later be optimized by doing this in the saveDynLookup Info */
      ASSIGN cDSLookupList = DYNAMIC-FUNCTION("getPropertyList":U IN gshSessionManager,
                                                 cOverrideObjectName + ".":U + gcSaveSDOName + ".lookup":U, NO).
                                                 
      cLookupParams = '':U.
      DO iCols = 1 TO NUM-ENTRIES(cDSLookupList, "|":U):
        cLookupParamName = ENTRY(iCols, cDSLookupList, "|":U).
        ASSIGN cLookup = DYNAMIC-FUNCTION("getPropertyList":U IN gshSessionManager,
                                           cLookupParamName, NO).
        IF ( NUM-ENTRIES(cLookup, CHR(4) ) > 13 ) THEN
        DO:
          ASSIGN cLookupParams = cLookupParams + cdSDOName + "." + ENTRY(8, cLookup, CHR(4)) + ',':u
                 cKeyField = ENTRY(4, cLookup, CHR(4))
                 cKeyField = ENTRY(NUM-ENTRIES(cKeyField, ".":U), cKeyField, ".":U).
                 
          IF lDSIsSBO THEN
            ASSIGN cLookupCols = cLookupCols + gcSaveSDOName + "." + cKeyField + ',':u.
          ELSE
            ASSIGN cLookupCols = cLookupCols + cKeyField + ',':u.
        END.
      END.
      cLookupCols    = TRIM(cLookupCols, ',':U). 
      cLookupParams  = TRIM(cLookupParams, ',':U). 
      
      /* Set the Data read columns in the SDO */  
      DYNAMIC-FUNCTION('setDataReadColumns' IN hSDO, cDataColumns).

      ASSIGN giRowNumber = 1.

      /* Walk thru the SDO/WDO events */
      cOut = "".

      DO iSDOEvents = 1 to NUM-ENTRIES(cSDOEvents, "|":U):

        ASSIGN
          cSDOEvent = ENTRY(iSDOEvents, cSDOEvents, "|":U)
          cData     = '':U
          plSuccess    = TRUE
        .

        CASE cSDOEvent:
          WHEN "add":U THEN
          DO:
            ASSIGN giRowNumber = giRowNumber + 1
                   cNewColValues = "":U.

            /* Build list of cols names and values chr(1) delimited for submitRow() 
              Get SDO data from client request 
              e.g. 'dorderfullo.orderStatus' = 'Shipped|Shipped|Ordered' */
              
            
            DO iCols = 1 to NUM-ENTRIES(cDataColumns):
              
              ASSIGN 
                cDataColumn = ENTRY(iCols, cDataColumns, ",":U)
                cParamName  = ENTRY(iCols, cParamNames, ",":U).
              
&IF DEFINED(newdatatypes) &THEN
              /* Check if this column is a CLOB */
              IF ( LOOKUP(ENTRY(NUM-ENTRIES(cDataColumn, ".":U), cDataColumn, ".":U), cCLOBColumns, ",":U) > 0 ) THEN
              DO:
                ASSIGN cNewColValues = cNewColValues + (IF iCols = 1 THEN "":U ELSE gcDataDelimiter) +
                                       "DATA,getCLOBValue," + STRING(THIS-PROCEDURE).
                NEXT.
              END.
&ENDIF              
              temp = ENTRY(giRowNumber, get-value(cParamName), gcDataDelimiter) NO-ERROR.
              IF (ERROR-STATUS:ERROR OR temp = ? ) THEN
              DO:
                ASSIGN cNewColValues = cNewColValues + (IF iCols = 1 THEN "":U ELSE gcDataDelimiter).
                ERROR-STATUS:ERROR = FALSE.
                NEXT.
              END.
              IF CAN-DO(cLookupCols,cDataColumn) THEN 
              DO:
                /* Find the initial value of the field */
                cOldVal = DYNAMIC-FUNCTION('columnProps':U IN hDS, cDataColumn, 'Initial':U) NO-ERROR.
                cLookupParam = ENTRY(LOOKUP(cDataColumn, cLookupCols, ",":U), cLookupParams, ",":U).
                
                RUN saveLookup(cOverrideObjectName, cLookupParam,giRowNumber,cOldVal,cOldVal,gcDataDelimiter) NO-ERROR.
                
                /* Have to provide the new-value as the old-value such that it always will be executed */  
                IF NOT ERROR-STATUS:ERROR THEN 
                  temp = RETURN-VALUE.
                ELSE
                DO:
                  {log "'Lookup Save errors: ':U + RETURN-VALUE"}
                  ERROR-STATUS:ERROR = FALSE.
                  plSuccess = handleErrors(cOverrideObjectName, cSBOName, gcSaveSDOName, cSDOEvent, RETURN-VALUE, "", "._":U + ENTRY(iCols, cDataColumns, ",":U)).
                  RETURN.
                END.
              END.
              cNewColValues = cNewColValues + (IF iCols = 1 THEN "":U ELSE gcDataDelimiter) + temp.
            END.
            
            RUN createData IN hDS ( INPUT cDataColumns, 
                                    INPUT-OUTPUT cNewColValues,
                                    OUTPUT cError).
                                    
            /* Just a temperory work around to get around the open API returning ";" if no errors exist */
            cError = TRIM(cError).
            cError = TRIM(cError, ";").

            IF cError > "":U THEN
            DO:
              {log "'Create Data errors: ':U + cError"}
              plSuccess = handleErrors(cOverrideObjectName, cSBOName, gcSaveSDOName, cSDOEvent, cError, "", "").
              RETURN.
            END.
            ELSE
            DO:
              /* Get the data from the latest create row */
              ASSIGN cName = (IF cSBOName > "":U THEN cSBOName + ".":U + gcSaveSDOName ELSE gcSaveSDOName).
              cData = removeCLOBColumns(cOverrideObjectName, cName , cDataColumns, cNewColValues).
            END.
          END.
          WHEN "update":U THEN
          DO:
            ASSIGN 
              giRowNumber = giRowNumber + 1
              cOldColValues = ""
              cNewColValues = "".

            /* Build list of cols names and values chr(1) delimited for submitRow() 
               Get SDO data from client request 
              e.g. 'dorderfullo.orderStatus' = 'Shipped|Shipped|Ordered'
              Note that for updates there will be 2 values 'oldvalue|newvalue' */

            DO iCols = 1 to NUM-ENTRIES(cDataColumns):
              ASSIGN 
                cDataColumn = ENTRY(iCols, cDataColumns, ",":U)
                cParamName  = ENTRY(iCols, cParamNames, ",":U).
                
&IF DEFINED(newdatatypes) &THEN
              /* Check if this column is a CLOB */
              IF ( LOOKUP(ENTRY(NUM-ENTRIES(cDataColumn, ".":U), cDataColumn, ".":U), cCLOBColumns, ",":U) > 0 ) THEN
              DO:
                ASSIGN cOldVal = "DATA,getCLOBValue," + STRING(THIS-PROCEDURE)
                       cNewVal = "DATA,getNewCLOBValue," + STRING(THIS-PROCEDURE).
              END.
              ELSE
&ENDIF
              DO:
                cOldVal = ENTRY(giRowNumber, get-value(cParamName), gcDataDelimiter) NO-ERROR.
                IF ERROR-STATUS:ERROR THEN
                DO:
                  cOldVal = "".
                  ERROR-STATUS:ERROR = FALSE.
                END.
                cNewVal = ENTRY(giRowNumber + 1, get-value(cParamName), gcDataDelimiter) NO-ERROR.
                IF ERROR-STATUS:ERROR THEN
                DO:
                  cNewVal = cOldVal.
                  ERROR-STATUS:ERROR = FALSE.
                END.
                IF CAN-DO(cLookupCols,cDataColumn) THEN 
                DO:
                  cLookupParam = ENTRY(LOOKUP(cDataColumn, cLookupCols, ",":U), cLookupParams, ",":U).
                  RUN saveLookup(cOverrideObjectName, cLookupParam, giRowNumber + 1, cOldVal, cNewVal, gcDataDelimiter) NO-ERROR.
                  IF NOT ERROR-STATUS:ERROR THEN
                    cNewVal = RETURN-VALUE.
                  ELSE
                  DO:
                    {log "'Lookup Save errors: ':U + RETURN-VALUE"}
                    plSuccess = handleErrors(cOverrideObjectName, cSBOName, gcSaveSDOName, cSDOEvent, RETURN-VALUE, "", "._":U + ENTRY(iCols, cDataColumns, ",":U)).
                    RETURN.
                  END.
                END.
              END.
              cOldColValues = cOldColValues + 
                            (IF iCols = 1 THEN "":U ELSE gcDataDelimiter) + 
                            cOldVal.
              cNewColValues = cNewColValues + 
                            (IF iCols = 1 THEN "":U ELSE gcDataDelimiter) + 
                            cNewVal.
                 
            END.
            
            RUN updateData IN hDS(INPUT cDataColumns, 
                                   INPUT cOldColValues,
                                   INPUT-OUTPUT cNewColValues,
                                   OUTPUT cError).
                                   
            ASSIGN giRowNumber = giRowNumber + 1.
            /* Just a temporary work around to get around the open API returning ";" if no errors exist */
            cError = TRIM(cError).
            cError = TRIM(cError, ";").
          
            IF cError > "" THEN
            DO:
              {log "'Update Data errors: ':U + cError"}
              cConflictError = DYNAMIC-FUNCTION('getLastCommitErrorType':U IN hDS) NO-ERROR. 
              IF (cConflictError = 'CONFLICT') THEN
                plSuccess = returnConflict(cOverrideObjectName, gcSaveSDOName, cDataColumns, escapeData(cNewColValues), hDS) NO-ERROR.
              ELSE
                plSuccess = handleErrors(cOverrideObjectName, cSBOName, gcSaveSDOName, cSDOEvent, cError, "", "").
              RETURN.
            END.
            ELSE
            DO:
              /* Get the data from the latest update row */
              /*loose the CLOB/BLOB columns */
              ASSIGN cName = (IF cSBOName > "":U THEN cSBOName + ".":U + gcSaveSDOName ELSE gcSaveSDOName).
              cData = removeCLOBColumns(cOverrideObjectName, cName, cDataColumns, cNewColValues).
            END.
          END. /* update */

          WHEN "delete" THEN
          DO:
            ASSIGN giRowNumber = giRowNumber + 1
                   cRowId = ENTRY(giRowNumber, get-value(cdSDOName + ".rowident":U), gcDataDelimiter) NO-ERROR.
                   
            IF lDSIsSBO THEN
              cDeleteColumn = gcSaveSDOName + ".RowIdent":U.
            ELSE
              cDeleteColumn =  "RowIdent":U.
            
            RUN deleteData IN hDS( INPUT cDeleteColumn, INPUT cRowId, OUTPUT cError).

            /* Just a temperory work around to get around the open API returning ";" if no errors exist */
            cError = TRIM(cError).
            cError = TRIM(cError, ";").
          
            IF cError > "":U THEN
            DO:
              {log "'Delete Data errors: ':U + cError"}
              plSuccess = handleErrors(cOverrideObjectName, cSBOName, gcSaveSDOName, cSDOEvent, cError, "", "").
              RETURN.
            END.
            ELSE
            DO:
              cData = "":U.
            END.
          END.
          OTHERWISE 
          DO:
            ASSIGN plSuccess = FALSE.
          END.
        END CASE.

        
        /* Write to a temp record */
        IF (plSuccess AND lAutoCommit) THEN
        DO:
          ASSIGN cLookupData = appendLookupData(cOverrideObjectName, gcSaveSDOName, cDataColumns, cData, NO) NO-ERROR.
          CREATE ttCommittedData.
          ASSIGN giDataCounter = giDataCounter + 1
                 ttCommittedData.DSName  = gcSaveSDOName
                 ttCommittedData.Counter = giDataCounter
                 ttCommittedData.Data = cData
                 ttCommittedData.LookupData = cLookupData.
                 
          IF (cSDOEvent <> "delete") THEN
          DO:
            IF VALID-HANDLE(hDS) THEN
              ASSIGN ttCommittedData.hasComments = {fn hasActiveComments hDS}.
          
&IF DEFINED(newdatatypes) &THEN
            /* Now get the clob data and add it to the ttCLOBData TT */
            DYNAMIC-FUNCTION("loadCLOBData" IN TARGET-PROCEDURE, 
                             cOverrideObjectName, 
                             gcSaveSDOName, 
                             giDataCounter).
&ENDIF
          END.
          
        END.
      END. /* DO iSDOEvents = 1 to iNumSDOEvents: */
    END. /* NUM-ENTRIES(ttDSSaveEvents.DSSaveEvent, ",":U) */
    
    /* If there is no auto commit then commit the data */
    IF ( NOT lAutoCommit) THEN
    DO:
      {log "'committing TRANSACTION for object: ':U + cDSName"}
      
      DYNAMIC-FUNCTION('setDataReadHandler' IN hDS, THIS-PROCEDURE).
      RUN commitData IN hDS(OUTPUT cError).

      /* Just a temperory work around to get around the open API returning ";" if no errors exist */
      cError = TRIM(cError).
      cError = TRIM(cError, ";").

      IF cError > "":U THEN
      DO:
        {log "'Commit Transaction errors: ':U + cError"}
        plSuccess = handleErrors(cOverrideObjectName, cDSName, cDSName, "save", cError, "", "").
        RETURN.
      END.
    END.
  END. /* ttDSSaveEvents */
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

  lognote('','Get filter: ' + cFilters).


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
    lognote('','Prepare filter: ' + cFilters).
    RUN prepareQueryForFilterAndFind ( INPUT cFilters, INPUT phSDO,
                                       OUTPUT cFilterFields,
                                       OUTPUT cFilterOperators,
                                       OUTPUT cFilterValues).

    {log "'filter fields: ' + cFilterFields + 'filter operators' + cFilterOperators + 'val; ' + cFilterValues"}
    
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
  {log "'Query=' + DYNAMIC-FUNCTION('getQueryString':U IN phSDO)"}
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE receiveCommittedData Include 
PROCEDURE receiveCommittedData :
/*------------------------------------------------------------------------------
  Purpose:     Load the data in the temp table 
  Parameters:  <none>
  Notes:       This is called from the SDO.
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcObjectName   AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pcColumnNames  AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pcValues       AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pcCommitAction AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE cData              AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cLookupData        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cClobColumns       AS CHARACTER  NO-UNDO.
  
  DEFINE VARIABLE hSDO              AS HANDLE     NO-UNDO.
  hSDO = getDataSourceHandle(gcLogicalObjectName, pcObjectName, "").

  /*
  {log "'Committed Data for sdo: ' + STRING(pcObjectName) + ' with action: ' + pcCommitAction + ' and col names: ' + STRING(pcColumnNames) + ' is: ' + STRING(pcValues)"}
  */
  
  /* If it is a delete request then we don't care about the data */
  IF (pcCommitAction = "DELETE":U) THEN
    ASSIGN cData = "":U
           cLookupData = "":U.
  ELSE
  DO:
    ASSIGN 
      cData = removeCLOBColumns(gcLogicalObjectName, pcObjectName, pcColumnNames, pcValues)
      cLookupData = appendLookupData(gcLogicalObjectName, pcObjectName, pcColumnNames, pcValues, NO) NO-ERROR.
  END.
  
  CREATE ttCommittedData.
  ASSIGN giDataCounter = giDataCounter + 1
         ttCommittedData.DSName = pcObjectName
         ttCommittedData.Counter = giDataCounter
         ttCommittedData.Action = pcCommitAction
         ttCommittedData.Data = cData
         ttCommittedData.LookupData = cLookupData.
         
  /* Get the CLOB columns and load the ttCLOBData for each CLOB column */
  IF (pcCommitAction <> "DELETE":U) THEN
  DO:
  
    IF VALID-HANDLE(hSDO) THEN
      ASSIGN ttCommittedData.hasComments = {fn hasActiveComments hSDO}.
         
&IF DEFINED(newdatatypes) &THEN
    DYNAMIC-FUNCTION("loadCLOBData" IN TARGET-PROCEDURE, 
                   gcLogicalObjectName,
                   pcObjectName, 
                   giDataCounter).
&ENDIF
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

  DEFINE VARIABLE hSDO AS HANDLE     NO-UNDO.
  hSDO = getDataSourceHandle(gcLogicalObjectName, pcObjectName, "").
  
  /*
  {log "'Data for sdo: ' + STRING(pcObjectName) + ' with col names: ' + STRING(pcColumnNames) + ' is: ' + STRING(pcValues)"}
  */
  CREATE ttSDOData.
  ASSIGN 
    giDataCounter = giDataCounter + 1
    ttSDOData.SDOName   = pcObjectName
    ttSDOData.Counter   = giDataCounter 
    ttSDOData.SDOValues = pcValues
    ttSDOData.SDOCols   = pcColumnNames.
  
  IF VALID-HANDLE(hSDO) THEN
    ASSIGN ttSDOData.hasComments = {fn hasActiveComments hSDO}.
  /* Get the CLOB columns and load the ttCLOBData for each CLOB column */
&IF DEFINED(newdatatypes) &THEN
  DYNAMIC-FUNCTION("loadCLOBData" IN TARGET-PROCEDURE, 
                   gcLogicalObjectName,
                   pcObjectName, 
                   giDataCounter).

&ENDIF
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE requestCleanup Include 
PROCEDURE requestCleanup :
/*------------------------------------------------------------------------------
  Purpose:    Clean up temp-tables and other variables after a request is done 
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  
  EMPTY TEMP-TABLE ttLinkedField.
  EMPTY TEMP-TABLE ttLink.

  IF VALID-HANDLE(ghttLinkedObj) THEN
  DO:
    ghttLinkedObj:BUFFER-RELEASE NO-ERROR.
    DELETE OBJECT ghttLinkedObj NO-ERROR.
    ghttLinkedObj = ?.
  END.

  EMPTY TEMP-TABLE ttDSSaveEvents.
  EMPTY TEMP-TABLE ttCommittedData.
  EMPTY TEMP-TABLE ttConflictData.
  EMPTY TEMP-TABLE ttClientAction.
  EMPTY TEMP-TABLE ttSDOFieldsUsed.
  EMPTY TEMP-TABLE ttObjAttr.
  EMPTY TEMP-TABLE ttSDOData.  /* Empty the SDO Data temp-table */
  EMPTY TEMP-TABLE ttCLOBData. /* Empty the CLOB Data temp-table */
  EMPTY TEMP-TABLE ttSDOLink.  /* Empty the dataset */
  EMPTY TEMP-TABLE ttComboData.

  DELETE WIDGET-POOL "B2BUIM":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE runCombo Include 
PROCEDURE runCombo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/  
  DEFINE INPUT PARAMETER pcLogicalObjectName AS CHARACTER  NO-UNDO.
  DEFINE INPUT PARAMETER pcComboName         AS CHARACTER  NO-UNDO.
  DEFINE INPUT PARAMETER plHTML              AS LOGICAL    NO-UNDO.
  DEFINE INPUT PARAMETER pcDelimiter         AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE cComboValues               AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDescSubstitute            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDispFields                AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cQueryTables               AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cComboFlag                 AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFlagValue                 AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFormat                    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDataType                  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFieldName                 AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cBaseQueryString           AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cKeyField                  AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE cFlagOption                AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cField                     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE ix                         AS INTEGER    NO-UNDO.

  DEFINE VARIABLE cHtml                      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cJS                        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE oBFhD                      AS HANDLE     NO-UNDO.
  DEFINE VARIABLE oBFhI                      AS HANDLE     NO-UNDO.
  DEFINE VARIABLE oBh                        AS HANDLE     NO-UNDO EXTENT 20.
  DEFINE VARIABLE oDbValue                   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE oDisplayFieldName          AS CHARACTER  NO-UNDO EXTENT 9.
  DEFINE VARIABLE oDisplayTemp               AS CHARACTER  NO-UNDO EXTENT 9.
  DEFINE VARIABLE oDisplayValue              AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE oFieldName                 AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE oIdx                       AS INTEGER    NO-UNDO.
  DEFINE VARIABLE oNotEmpty                  AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE oQh                        AS HANDLE     NO-UNDO.
  DEFINE VARIABLE oSuccess                   AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cParentField               AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cParentFieldValue          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cParentFilterQuery         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cQueryAddtion              AS CHARACTER  NO-UNDO.

  cComboValues = DYNAMIC-FUNCTION("getPropertyList":U IN gshSessionManager,
                         pcLogicalObjectName + ".":U + pcComboName + ".combo":U, NO).
  {log "'Lookup:' + pcLogicalObjectName + '.':U + pcComboName + '.combo  =' + cComboValues"}
  
  IF (NUM-ENTRIES(cComboValues, CHR(4)) < 11) THEN                        
  DO:
    {log "'Lookup failed! due to insufficient data: ' + cComboValues"}
    RETURN.
  END.

  ASSIGN
    cKeyField          = ENTRY( 1, cComboValues, CHR(4))
    cQueryTables       = ENTRY( 2, cComboValues, CHR(4))
    cBaseQueryString   = ENTRY( 3, cComboValues, CHR(4))
    cDispFields        = ENTRY( 4, cComboValues, CHR(4))
    cFieldName         = ENTRY( 5, cComboValues, CHR(4))
    cFormat            = ENTRY( 6, cComboValues, CHR(4))
    cDataType          = ENTRY( 7, cComboValues, CHR(4))
    cDescSubstitute    = ENTRY( 8, cComboValues, CHR(4))
    cComboFlag         = ENTRY( 9, cComboValues, CHR(4))
    cFlagValue         = ENTRY(10, cComboValues, CHR(4))
    cParentField       = ENTRY(11, cComboValues, CHR(4))
    cParentFilterQuery = ENTRY(12, cComboValues, CHR(4))
  .

  ASSIGN cQueryAddtion = "":U
         cParentFieldValue = "":U.

  IF (cParentField > "":U) THEN
     ASSIGN cParentFieldValue = GET-VALUE('lookupParent').

  /* This is if the Parent field has been specified and a value exists*/
  IF (cParentField > "":U AND cParentFilterQuery > "":U) THEN 
  DO:
     IF cParentFieldValue > "":U  THEN
     DO:
       ASSIGN cQueryAddtion = SUBSTITUTE(cParentFilterQuery, cParentFieldValue).
       IF cQueryAddtion > "":U THEN
       DO:
         IF (INDEX(cBaseQueryString, "WHERE":U) > 0) THEN
           ASSIGN cBaseQueryString = cBaseQueryString + " AND " + cQueryAddtion.
         ELSE
           ASSIGN cBaseQueryString = cBaseQueryString + " WHERE " + cQueryAddtion.
       END.
     END.
     ELSE
       RETURN ''.
  END.

  DO oIdx = 1 TO NUM-ENTRIES(cDispFields):
    ASSIGN
      oDisplayFieldName[oIdx] = ENTRY(oIdx,cDispFields)
      oDisplayFieldName[oIdx] = (IF INDEX(oDisplayFieldName[oIdx], ".":U) > 0 THEN 
                                    ENTRY(2, oDisplayFieldName[oIdx], ".":U) 
                                 ELSE oDisplayFieldName[oIdx]).
  END.

  oFieldName = (IF INDEX(cKeyField, ".":U) > 0 THEN ENTRY(2, cKeyField, ".":U) ELSE cKeyField).
  CREATE QUERY oQh IN WIDGET-POOL "B2BUIM":U.
  REPEAT oIdx = 1 TO NUM-ENTRIES(cQueryTables):
    CREATE BUFFER oBh[oIdx] FOR TABLE ENTRY(oIdx,cQueryTables) 
      IN WIDGET-POOL "B2BUIM":U NO-ERROR.

    IF ERROR-STATUS:ERROR THEN NEXT.
    oQh:ADD-BUFFER(oBh[oIdx]) NO-ERROR.
  END.
  oSuccess = oQh:QUERY-PREPARE(cBaseQueryString) NO-ERROR.
  IF oSuccess THEN 
  DO:
    /* Run the query */
    oQh:QUERY-OPEN().
    oNotEmpty = oQh:GET-FIRST(NO-LOCK).
    IF NOT(oQh:QUERY-OFF-END) AND oNotEmpty THEN 
    DO:
      ASSIGN oIdx = MAXIMUM(1, LOOKUP(ENTRY(1, oFieldName, ".":U), cQueryTables)).
      IF VALID-HANDLE(oBh[oIdx]) AND oBh[oIdx]:AVAILABLE THEN 
      DO:
        IF (cFormat > "":U) THEN
          ASSIGN oBh[oIdx]:BUFFER-FIELD(oFieldName):FORMAT = cFormat.
        ASSIGN oBFhI = oBh[oIdx]:BUFFER-FIELD(oFieldName) NO-ERROR.
        /* Just in case */
        IF (cFormat = ? OR cFormat = "":U) THEN
          cFormat = oBFhI:FORMAT.
        IF (cDataType = ? OR cDataType = "":U) THEN
          cDataType = oBFhI:DATA-TYPE.
      END.
    END.
    
    /* <all> or <none> option is being used. */
    IF cComboFlag > "" THEN 
    DO:
      ASSIGN cFlagOption = DYNAMIC-FUNCTION("formatValue", cFlagValue,cFormat,cDataType) NO-ERROR.
      IF cFlagOption <> ? THEN
      DO:
        IF plHTML THEN
        DO:
          cHtml = '~n<option value="':U + LC(cFlagOption) + '">':U + 
                   html-encode(IF cComboFlag = "A":U THEN '<all>' ELSE '<none>') + 
                   '</option>~n':U.
    
          /* If the combo has more than 32K data, we can't store in a variable so output now */
          {&OUT} cHtml.
        END.
        ELSE
           cJs = cJs + pcDelimiter + LC(cFlagOption) + pcDelimiter +
               html-encode(IF cComboFlag = "A":U THEN '<all>' ELSE '<none>').
      END.
    END.

    REPEAT WHILE NOT(oQh:QUERY-OFF-END) AND oNotEmpty:
      /* Get display value */
      ASSIGN
        oDbValue      = RIGHT-TRIM(oBFhI:STRING-VALUE)
        oDisplayValue = "":U
        oDisplayTemp  = "":U.

      DO oIdx = 1 TO NUM-ENTRIES(cDispFields):
        ASSIGN 
                cField = ENTRY(oIdx, cDispFields)
                ix     = MAXIMUM(1, LOOKUP(ENTRY(1, cField, ".":U), cQueryTables))
          oBFhD  = oBh[ix]:BUFFER-FIELD(ENTRY(2,cField,".":U)).
        IF VALID-HANDLE(oBFhD) THEN
          oDisplayTemp[oIdx] = RIGHT-TRIM(STRING(oBFhD:BUFFER-VALUE())).
      END.
      oDisplayValue = SUBSTITUTE(cDescSubstitute,oDisplayTemp[1],oDisplayTemp[2],oDisplayTemp[3],oDisplayTemp[4],oDisplayTemp[5],oDisplayTemp[6],oDisplayTemp[7],oDisplayTemp[8],oDisplayTemp[9]).
      oDisplayValue = TRIM(html-encode(RIGHT-TRIM(oDisplayValue))).

      IF (plHTML) THEN
      DO:
        /* Write out the OPTION tag */
        cHtml = '<option value="' + LC(oDbValue) + '">' + oDisplayValue + '</option>~n'.
        /* If the combo has more than 32K data, we can't store in a variable so output */
        {&OUT} cHtml.
      END.
      ELSE 
        cJs = cJs + pcDelimiter + escapeData(LC(oDbValue)) + pcDelimiter + escapeData(oDisplayValue).

      oQh:GET-NEXT(NO-LOCK).
    END. /* REPEAT */
  END.
  ASSIGN cJs = TRIM(cJS, pcDelimiter).

  IF NOT plHTML THEN
  DO:
    IF NUM-ENTRIES(pcComboName, ".":U) = 1 THEN
       pcComboName = "tool." + pcComboName.

    CREATE ttComboData.
    ASSIGN ttComboData.ttComboName = pcComboName.
           ttComboData.ttData = cJs.
  END.
  /* Clean up */
  oQh:QUERY-CLOSE().
  DO oIdx = 1 TO NUM-ENTRIES(cQueryTables):
    DELETE OBJECT oBh[oIdx] NO-ERROR.
    ASSIGN oBh[oIdx] = ?.
  END.
  DELETE OBJECT oQh NO-ERROR.
  ASSIGN oQh = ?.
  RETURN ''.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE runLookup Include 
PROCEDURE runLookup :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  Logical name of object that contains the lookup
  Notes:
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pcLogicalObjectName AS CHARACTER NO-UNDO.
  
  DEFINE VARIABLE c1                AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cBrowseField      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cBrowseFields     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cBrowseLabels     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDispField        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cKeyField         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cQueryFields      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cQueryTables      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cLookupValue      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cWindowTitle      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cRowsToBatch      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE i1                AS INTEGER    NO-UNDO.
  DEFINE VARIABLE i2                AS INTEGER    NO-UNDO.
  DEFINE VARIABLE hSDOHandle        AS HANDLE     NO-UNDO.
  
  DEFINE VARIABLE cParentField       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cParentFilterQuery AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cParentFieldValue  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cTemp              AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cLookupValues      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDisplayDataType   AS CHARACTER  NO-UNDO.
  
  cLookupValues = DYNAMIC-FUNCTION("getPropertyList":U IN gshSessionManager,
                         pcLogicalObjectName + ".":U + gcLookupObjectName + ".lookup":U, NO).
  {log "'Lookup:' + pcLogicalObjectName + '.':U + gcLookupObjectName + '.lookup  =' + cLookupValues"}
  
  IF (NUM-ENTRIES(cLookupValues, CHR(4)) < 14) THEN                        
  DO:
    {log "'Lookup failed! due to insufficient data: ' + cLookupValues"}
    RETURN.
  END.
  
  ASSIGN
    cKeyField          = ENTRY(1, cLookupValues, CHR(4))
    cDispField         = ENTRY(2, cLookupValues, CHR(4))
    cQueryTables       = ENTRY(6, cLookupValues, CHR(4))
    cRowsToBatch       = ENTRY(9, cLookupValues, CHR(4))
    cQueryFields       = ENTRY(10, cLookupValues, CHR(4))
    cParentField       = ENTRY(11, cLookupValues, CHR(4))
    cParentFilterQuery = ENTRY(12, cLookupValues, CHR(4))
    cWindowTitle       = ENTRY(13, cLookupValues, CHR(4))
    cDisplayDataType   = ENTRY(14, cLookupValues, CHR(4))
    cLookupValue       = GET-VALUE('lookup')
    i1                 = NUM-ENTRIES(cQueryFields)
    cBrowseFields      = cQueryFields.
    
  /* Note that the start command will clean-up any previous context */
  ASSIGN gcRequestEvents  = '|lookup.first|lookup.filter'.
  
  IF (cParentField > "":U) THEN
    cParentFieldValue = GET-VALUE('lookupParent').

  IF (cRowsToBatch = ? OR cRowsToBatch = '':U) THEN
    cRowsToBatch = "50":U.

  /* IMPORTANT NOTE:
    Over ride the logical object name to be the lookup instance name 
    (currently logical name due to bugs inthe instance name)
    so that all the context can be stored against the lookup object as
    opposed to the original container 
  */

  saveDSProperty(gcLookupObjectName, "lookup":U, "RowsToBatch":U, cRowsToBatch).
  saveDSPath("lookup":U, "adm2/dynsdo.w":U).
  
  cTemp = "":U.
  
  /* This is if the value is partially typed */
  {log "'Parent field is: ' + cParentField + ' parent filter: ' + cPArentFilterQuery + ' parent field value: ' + cParentFieldValue"}
  {log "'Lookup-value=' + cLookupValue"} 

  IF (cLookupValue > '':U) THEN 
  DO:
    IF (cDisplayDataType = "character") THEN
      cTemp = '|' + cDispField + ' > ' + cLookupValue + '|' + cDispField + ' < ' + cLookupValue + CHR(255).
    ELSE
      cTemp = '|' + cDispField + ' > ' + cLookupValue.
  END.
  
  /* This is if the Parent field has been specified */
  IF (cParentFieldValue > "":U AND cParentFilterQuery > "":U) THEN 
  DO:
    cParentFilterQuery = REPLACE(cParentFilterQuery, "'", "":U).
    cParentFilterQuery = REPLACE(cParentFilterQuery, '"', '':U).
    cTemp = cTemp + '|' + SUBSTITUTE(cParentFilterQuery, cParentFieldValue).
  END.

  {log "'ProcessLookup:' + pcLogicalObjectName"}
  /* populate the context for the lookup */
  RUN processLookup(INPUT pcLogicalObjectName, 
                    INPUT "lookup":U, 
                    OUTPUT hSDOHandle).

  DO i1 = 1 TO NUM-ENTRIES(cBrowseFields, ",":U):
    cBrowseField = ENTRY(i1, cBrowseFields, ",":U).
    IF ( i1 = 1) THEN
      cBrowseLabels = DYNAMIC-FUNCTION("columnLabel" IN hSDOHandle, cBrowseField).
    ELSE
      cBrowseLabels = cBrowseLabels + "|":U + DYNAMIC-FUNCTION("columnLabel" IN hSDOHandle, cBrowseField).
  END.
  {log "'LookupLabels:' + cBrowseLabels"}
  {log " 'lookup filter is: ' + cTemp"}
  
  /* This is concat of the two cases above */
  IF (cTemp > "":U) THEN
    set-user-field('_lookup._filter':U, cTemp).


  {&OUT}
    '~napp.wbo.lookup("' cWindowTitle '","' REPLACE(LC(cBrowseFields),',','|') '","' cBrowseLabels '");~n'.
  RUN setClientAction('wbo.lookup').
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE saveLookup Include 
PROCEDURE saveLookup :
/*------------------------------------------------------------------------------
  Purpose:  Perform dynamic lookup on save
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pcLogicalObjectName AS CHARACTER  NO-UNDO.  
  DEFINE INPUT PARAMETER cField              AS CHARACTER  NO-UNDO.  
  DEFINE INPUT PARAMETER iEntry              AS INTEGER    NO-UNDO.  
  DEFINE INPUT PARAMETER cOldData            AS CHARACTER  NO-UNDO.  
  DEFINE INPUT PARAMETER cNewData            AS CHARACTER  NO-UNDO.  
  DEFINE INPUT PARAMETER pcDataDelimiter     AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE cValue   AS CHAR NO-UNDO.
  DEFINE VARIABLE lSuccess AS LOGICAL INITIAL TRUE NO-UNDO.

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
  DEFINE VARIABLE cLookupObj      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSDOName        AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE cReturn      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cWhere       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hBuffer      AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hBufferList  AS HANDLE     NO-UNDO EXTENT 20.
  DEFINE VARIABLE hField       AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hQuery       AS HANDLE     NO-UNDO.
  
  DEFINE VARIABLE cLookupObjParamName AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDSLookupObjList    AS CHARACTER  NO-UNDO.
  
  /* If the old data and new data is the same then look for the lookup value */
  IF (cOldData <> cNewData) THEN 
    RETURN cNewData.
    
  /* A check needs to be done to check that the field is available in the input */  
  ASSIGN cValue = get-value(REPLACE(cField,'.','._'))
         cValue = ENTRY(iEntry,cValue,pcDataDelimiter)
         cField    = SUBSTRING(cField,2).
  
  IF ( NUM-ENTRIES(cField, ".":U) > 1) THEN
    ASSIGN cSDOName  = ENTRY(1,cField,'.':U)
           cLookupObj = ENTRY(2,cField,'.':U).
  ELSE
    RETURN ERROR "LookupObject not found!".

  /* Find the lookup data object */
  cLookupObjParamName = pcLogicalObjectName + ".":U + cLookupObj + ".lookupObj":U.
  ASSIGN cDSLookupObjList = DYNAMIC-FUNCTION("getPropertyList":U IN gshSessionManager,
                                           cLookupObjParamName, NO)
         cDSLookupObjList = ENTRY(1, cDSLookupObjList, "|":U).
  /* Find the lookup data */
  ASSIGN c1 = DYNAMIC-FUNCTION("getPropertyList":U IN gshSessionManager, cDSLookupObjList, NO).
  
  ASSIGN
    cKeyField      = ENTRY(1, c1, CHR(4))
    cDisplayField  = ENTRY(2, c1, CHR(4))
    cKeyDataType   = ENTRY(3, c1, CHR(4))
    cFieldName     = ENTRY(4, c1, CHR(4))
    cQueryString   = ENTRY(5, c1, CHR(4))
    cQueryTables   = ENTRY(6, c1, CHR(4))
    cFieldName     = TRIM(cFieldName, ">":U)
    cFieldName     = TRIM(cFieldName, "<":U).
  
  /* If the Displayed field is same as the ke field then like GUI save the data */
  IF ( cDisplayField = cKeyField ) THEN
    RETURN cValue.
  
  ASSIGN
    i1 = INDEX(cQueryString, ' BY ':U)
    i2 = INDEX(cQueryString, ' WHERE ':U)
    cWhere    = cDisplayField + ' = "':U + cValue + '"':U.

  IF cValue = "" THEN RETURN "".

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
    hQuery:GET-FIRST().

    IF hQuery:QUERY-OFF-END THEN 
      cReturn = "":U.
    ELSE
    DO:
      ASSIGN i3 = MAXIMUM(1, LOOKUP(ENTRY(1, cKeyField, ".":U), cQueryTables)).
      IF hBufferList[i3]:AVAILABLE THEN 
        cReturn = hBufferList[i3]:BUFFER-FIELD(ENTRY(2, cKeyField, ".":U)):BUFFER-VALUE NO-ERROR.
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
  RUN afmessagep IN gshSessionManager 
                        (INPUT pcMessageList, /*** needed to add 'af/app/' ***/
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION appendComments Include 
FUNCTION appendComments RETURNS CHARACTER PRIVATE
  ( pcContext AS CHARACTER) :
/*------------------------------------------------------------------------------
  Purpose:  This function appends the HasComment and HasAutoComments to the context list.
    Notes:  
------------------------------------------------------------------------------*/
  IF INDEX("EntityFields", pcContext) > 0 THEN
    RETURN pcContext.

  IF INDEX("FetchHasComment", pcContext) = 0 THEN
    ASSIGN pcContext = pcContext 
                     + (IF pcContext = '' THEN '' ELSE CHR(3))
                     + "FetchHasComment" + CHR(4) + "YES".
  IF INDEX("FetchAutoComment", pcContext) = 0 THEN
    ASSIGN pcContext = pcContext  
                     + (IF pcContext = '' THEN '' ELSE CHR(3))
                     + "FetchAutoComment" + CHR(4) + "YES".
  ASSIGN pcContext = TRIM(pcContext, CHR(3)).

  RETURN pcContext.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION appendLookupData Include 
FUNCTION appendLookupData RETURNS CHARACTER
  ( pcLogicalObjectName AS CHARACTER,
    pcSDOName AS CHARACTER,
    pcSDOCols AS CHARACTER,
    pcSDOValues AS CHARACTER,
    plAppendData AS LOGICAL) :
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
  DEFINE VARIABLE cDSLookupList   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDataDelimiter  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cLookupParam    AS CHARACTER  NO-UNDO.

  IF (pcLogicalObjectName > "":U)  THEN
    cDataDelimiter = getSavedDSDataDelimiter(pcLogicalObjectName, pcSDOName).
  ELSE
    pcLogicalObjectName = gcLogicalObjectName.

  IF (plAppendData) THEN
    ASSIGN cRetSDOValues  = pcSDOValues.

  IF pcSDOValues = ? OR TRIM(pcSDOValues) = "":U THEN
    RETURN cRetSDOValues.

  IF ( cDataDelimiter = ? OR cDataDelimiter = "":U ) THEN
    cDataDelimiter = "|".
  
    /* This will provide the list of lookups to look for this SDO */
  ASSIGN cDSLookupList = DYNAMIC-FUNCTION("getPropertyList":U IN gshSessionManager,
                                           pcLogicalObjectName + ".":U + ENTRY(NUM-ENTRIES(pcSDOName,'.'),pcSDOName,'.') + ".lookup":U, NO).
  DO i1 = 1 TO NUM-ENTRIES(cDSLookupList, "|":U):
  
    cLookupParam = ENTRY(i1,cDSLookupList,'|':U).
    c1 = DYNAMIC-FUNCTION("getPropertyList":U IN gshSessionManager,
                           cLookupParam, NO).
    
    IF (NUM-ENTRIES(c1, CHR(4)) < 14) THEN 
      NEXT.
      
  /* Append lookup data to SDO data string */
    ASSIGN
      cKeyField      = ENTRY(1, c1, CHR(4))
      cDisplayField  = ENTRY(2, c1, CHR(4))
      cKeyDataType   = ENTRY(3, c1, CHR(4))
      cFieldName     = ENTRY(4, c1, CHR(4))
      cQueryString   = ENTRY(5, c1, CHR(4))
      cQueryTables   = ENTRY(6, c1, CHR(4))
      cLinkedFields  = ENTRY(7, c1, CHR(4))
      cFieldName     = TRIM(cFieldName, ">":U)
      cFieldName     = TRIM(cFieldName, "<":U).

    IF NUM-ENTRIES(pcSDOName,'.') > 1 THEN
      pcSDOCols = REPLACE(pcSDOCols, ENTRY(2,pcSDOname,'.') + '.','').

    
    /* Get the object value that will be used to modify the query WHERE phrase. */
    i2 = LOOKUP(cFieldName, pcSDOCols).
    IF (i2 > 0)  THEN
    DO:
      cFieldValue = ENTRY(i2, pcSDOValues, cDataDelimiter).

      /* Get lookup value */
      cLookupValue = getLookupValue(cQueryTables, cQueryString, cFieldValue, 
                                    cKeyField, cKeyDataType, cDisplayField,
                                    cLinkedFields, cDataDelimiter).
      /* Append lookup value to SDO data */
      cRetSDOValues = cRetSDOValues + cLookupValue.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION cleanupDataObjects Include 
FUNCTION cleanupDataObjects RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  Cleanup the SDO's ad SBO's used by the request.
    Notes:  
------------------------------------------------------------------------------*/
  FOR EACH ttSDO:
    ASSIGN ttSDO.ttHandle = ?.
  END.
  IF VALID-HANDLE(ghSDOContainer) THEN
    RUN destroyObject IN ghSDOContainer.

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
  {log "'clearCtx=' + cContextName"}
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
    IF (NUM-ENTRIES(cSDOName, ".":U) > 1)  THEN
      cSDOName = ENTRY(2,cSDOName,".":U).

    IF  ( cSDOName = pcSDOName ) THEN
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getCLOBValue Include 
FUNCTION getCLOBValue RETURNS {&clobtype}
  (pcColumnName AS CHARACTER ) :
&IF DEFINED(newdatatypes) &THEN
/*------------------------------------------------------------------------------
  Purpose: This function is called by the SDO to fetch the CLOB data. 
    Notes: THIS IS A INTERNAL API 
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cSDOName    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cColumnName AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cParamName  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE clValue     AS LONGCHAR   NO-UNDO.

  IF (NUM-ENTRIES(pcColumnName, ".":U) > 1) THEN
    cSDOName = ENTRY(1, pcColumnName, ".":U).
  ELSE
    cSDOName = gcSaveSDOName.

  ASSIGN cColumnName = ENTRY(NUM-ENTRIES(pcColumnName, ".":U), pcColumnName, ".":U)
         cParamName  = "_":U + cSDOName + "." + cColumnName
         clValue     = DYNAMIC-FUNCTION("get-long-value" IN web-utilities-hdl, cParamName)
         clValue     = ENTRY(giRowNumber, clValue, gcDataDelimiter).
         
  RETURN clValue.
  
&ENDIF
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getDataSourceHandle Include 
FUNCTION getDataSourceHandle RETURNS HANDLE
  ( INPUT pcLogicalObjectName AS CHARACTER,
    INPUT pcDSName AS CHARACTER,
    INPUT pcDSPath AS CHARACTER) :
/*------------------------------------------------------------------------------
  Purpose:  Gets the SDO Handle
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hDSHandle    AS HANDLE NO-UNDO.
  DEFINE VARIABLE hSDO         AS HANDLE NO-UNDO.
  DEFINE VARIABLE cSBOName     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFinalDSName AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSDOName     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cContext     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDSIsSBO     AS CHARACTER NO-UNDO.
  DEFINE VARIABLE lDSIsSBO     AS LOGICAL NO-UNDO.
  DEFINE VARIABLE cLogicalObjectName AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cFinalLogicalName  AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cEntityFields      AS CHARACTER NO-UNDO.

  /* First check if the DS to be started is SBO */
  ASSIGN cDSIsSBO = getSavedDSProperty(pcLogicalObjectName, pcDSName, 'isSBO':U)
         lDSIsSBO = (IF cDSIsSBO > "":U THEN LOGICAL(cDSIsSBO) ELSE NO).
  
  /* If the object is SBO then find the SBO name, SDO name */
  IF (lDSIsSBO OR NUM-ENTRIES(pcDSName, ".":U) > 1) THEN
  DO:
    ASSIGN lDSIsSBO = yes
           cSBOName = ENTRY(1, pcDSName, ".":U)
           cFinalDSName = cSBOName
           cLogicalObjectName = cFinalDSName.
           
    IF NUM-ENTRIES(pcDSName, ".":U) > 1 THEN       
      ASSIGN cSDOName = ENTRY(2, pcDSName, ".":U) NO-ERROR.
      
  END.
  ELSE
    ASSIGN lDSIsSBO = no
           cSBOName = '':U
           cFinalDSName = pcDSName
           cSDOName = pcDSName
           cLogicalObjectName = ?.

  FIND FIRST ttSDO WHERE ttSDO.ttContainer = pcLogicalObjectName 
                     AND ttSDO.ttName = cFinalDSName NO-ERROR.
                     
  IF AVAILABLE ttSDO THEN 
  DO:
    /* Save the path in the context - The path need not be container qualified */
    saveDSPath(cFinalDSName, ttSDO.ttPath).
    
    IF VALID-HANDLE(ttSDO.ttHandle) THEN
    DO:
      IF ( lDSIsSBO AND cSDOName > '':U ) THEN
        RETURN findSDOHandleInSBO(pcLogicalObjectName, cSBOName, ttSDO.ttHandle, cSDOName).
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

  cContext = getSavedDSContext(pcLogicalObjectName, cFinalDSName, '':U).
  IF (cContext = ? OR cContext = "":U ) THEN
    cContext = getSavedDynamicDSInfo(pcLogicalObjectName, cFinalDSName).
    
  {log "'Start SDO:' + pcLogicalObjectName + '/' + cFinalDSName + ':' + cContext"} 
  IF cLogicalObjectName > "":U THEN
  DO:
    ASSIGN cFinalLogicalName = getSavedDSProperty(pcLogicalObjectName, cFinalDSName, 'ObjectName':U).
    IF cFinalLogicalName = "":U OR cFinalLogicalName = ? THEN
      ASSIGN cFinalLogicalName = cLogicalObjectName.
  END.
  
  IF NOT lDSIsSBO THEN 
    cContext = appendComments(cContext).
    
  hDSHandle = DYNAMIC-FUNCTION('insertDataObject':U IN ghSDOContainer,
                                cFinalLogicalName, 
                                pcDSPath, 
                                cFinalDSName, 
                                ?, 
                                ?, 
                                cContext).  
  
  IF ( NOT VALID-HANDLE(hDSHandle)) THEN
  DO:
    {log "'Error running SDO: ' + pcDSName + ' (' + pcDSPath + ') - ':U + ERROR-STATUS:GET-MESSAGE(1) + ', Program:' + PROGRAM-NAME(1)"}
    RUN setMessage (INPUT '** ERROR: Could not get valid handle for SDO: ' + pcDSName + ' (':U + pcDSPath + ').  ErrMsg:':U + ERROR-STATUS:GET-MESSAGE(1) + ', Program:' + PROGRAM-NAME(1), INPUT 'ERR':u).
    RETURN ?.
  END.
  
  /* Save the SDO handle in the Temp table */
  setDataSourceHandle(pcLogicalObjectName, cFinalDSName, pcDSPath, hDSHandle).

  /* Save the path in the context */
  saveDSPath(cFinalDSName, pcDSPath).

  IF ( lDSIsSBO AND cSDOName > '':U ) THEN
  DO:
    hSDO = findSDOHandleInSBO(pcLogicalObjectName, cSBOName, hDSHandle, cSDOName).
    {get EntityFields cEntityFields hSDO}.
    IF cContext = '':U THEN
    DO:
      {set FetchHasComment TRUE hSDO}.
      RUN initializeEntityDetails IN hSDO.
    END.
    RETURN hSDO.
  END.
  ELSE
    RETURN hDSHandle.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getDSHandle Include 
FUNCTION getDSHandle RETURNS HANDLE
  ( INPUT pcDSName AS CHARACTER,
    INPUT pcDSPath AS CHARACTER) :
/*------------------------------------------------------------------------------
  Purpose:  GEts the SDO Handle
    Notes:  THIS API IS DEPRICATED AND WILL BE REMOVED IN THE NEXT RELEASE
            PLEASE USE getDataSourceHandle 
------------------------------------------------------------------------------*/

  RETURN getDataSourceHandle(gcLogicalObjectName, pcDSName, pcDSPath).

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
    iWherePos = INDEX(pcQueryString, ' WHERE ':U).

    IF pcKeyDataType = "DECIMAL" THEN
      cWhere    = '(':U + pcKeyField + ' = DECIMAL("':U + pcFieldValue + '"))':U.
    ELSE
      cWhere    = '(':U + pcKeyField + ' = ':U + QUOTER(pcFieldValue) + ')':U.

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
    /* If there is INDEXED-REPOSITION in the query loose that else 4GL query fails */
    ASSIGN pcQueryString = REPLACE(pcQueryString, "INDEXED-REPOSITION":U, "":U).
    
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

    ASSIGN ix = MAXIMUM(1, LOOKUP(ENTRY(1, pcDisplayField, ".":U), pcQueryTables))
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getNewCLOBValue Include 
FUNCTION getNewCLOBValue RETURNS {&clobtype}
  ( pcColumnName AS CHARACTER) :
&IF DEFINED(newdatatypes) &THEN
/*------------------------------------------------------------------------------
  Purpose:  This function is called by SDO to fetcht he new column Value.
    Notes:  THIS IS A INTERNAL FUNCTION.
------------------------------------------------------------------------------*/
  DEFINE VARIABLE clValue AS LONGCHAR  NO-UNDO.
  giRowNumber = giRowNumber + 1.
  clValue = getCLOBValue(pcColumnName).
  giRowNumber = giRowNumber - 1.
  
  RETURN clValue.   /* Function return value. */

&ENDIF
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
    
    /* Find the first entry in this - This is # seaparated*/
    cPassThruField = ENTRY(1, cPassThruField, "#":U).
    
    /* If the lookup begins as DYN then it is not pass thru' information */
    IF (cPassThruField BEGINS "DYN=":U) THEN
      RETURN '':U.
      
    IF ( NUM-ENTRIES(cPassThruField, ".":U) < piEntryNumber) THEN
      RETURN '':U.
    
    IF (piEntryNumber = 1) THEN
      cEntry = ENTRY(1, cPassThruField, ".":U).
    ELSE IF (piEntryNumber = 2) THEN
    DO:
      cEntry = ENTRY(2, cPassThruField, ".":U).
      /* If the input is SBO.SDO the this would be required */
      IF ( NUM-ENTRIES(cPassThruField, ".":U) > 3 ) THEN
        cEntry = cEntry + '.':U + ENTRY(3, cPassThruField, ".":U).
    END.
    ELSE IF (piEntryNumber = 3) THEN
    DO:
      /* If the second entry is SBO.SDO the this would be required */
      IF ( NUM-ENTRIES(cPassThruField, ".":U) > 3 ) THEN
        cEntry = ENTRY(4, cPassThruField, ".":U).
      ELSE
        cEntry = ENTRY(3, cPassThruField, ".":U).
      /* If there is a #, loose that */
      cEntry = ENTRY(1, cEntry, "#":U).
    END.
    RETURN cEntry.
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
  {log "'GetCxt:' + cDSContextName + '=' + cDSContext"}
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
  ( pcLogicalObjectName as CHARACTER, 
    pcDSName AS CHARACTER) :
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
                                     INPUT pcLogicalObjectName + "." + cFinalDSName + ".dynamicInfo":U,
                                     INPUT NO).
 /* {log "'GetDyn:' + pcLogicalObjectName + '.' + cFinalDSName + '.dynamicInfo=' + cDynamicDSInfo"} */
  
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
    plUpdatable AS LOGICAL,
    plIncludeCLOBS AS LOGICAL) :
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
  DEFINE VARIABLE cColumnDataTypes AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cColumnDataType  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cColumnName      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cCLOBColumns     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cBLOBColumns     AS CHARACTER  NO-UNDO.

  /* GEt the SDO name */
  cSDOName = DYNAMIC-FUNCTION('getLogicalObjectName':U IN phSDOHandle).

 /* {log "'get=' + DYNAMIC-FUNCTION('getDataColumns':U IN phSDOHandle)"} */

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

  /* From the SDO list, take away the hidden fields */
  DO iNum = 1 TO NUM-ENTRIES(cHiddenColumns, ",":U):
    iLoc = 0.
    cHiddenColumn = ENTRY(iNum, cHiddenColumns).
    iLoc = LOOKUP(cHiddenColumn, cSDOColumns) NO-ERROR.
    IF iLoc > 0 THEN
      ENTRY(iLoc, cSDOColumns, ",":U) = "":U.
  END.

  /* From the SDO columns, if not updatabase then loose the BLOB columns 
     Also rearrange the columns so that CLOB/BLOB fields are at the end */
  ASSIGN cColumnDataTypes = DYNAMIC-FUNCTION('columnProps':U IN phSDOHandle, cSDOColumns, 'DataType':U).
  DO iNum = 1 TO NUM-ENTRIES(cSDOColumns, ",":U):
    ASSIGN cColumnDataType = ENTRY(2, ENTRY(iNum, cColumnDataTypes, CHR(3)), CHR(4))
           cColumnName = ENTRY(iNum, cSDOColumns, ",":U).
    IF cColumnDataType = "CLOB" THEN
      ASSIGN cCLOBColumns = cCLOBColumns + "," + cColumnName.
    ELSE IF cColumnDataType = "BLOB" THEN
      ASSIGN cBLOBColumns = cBLOBColumns + "," + cColumnName.
    ELSE
      ASSIGN cNewSDOColumns = cNewSDOColumns + ",":U + cColumnName.
  END.
  IF (plIncludeCLOBS) THEN
    ASSIGN cNewSDOColumns = cNewSDOColumns + "," + cCLOBColumns.

  ASSIGN cSDOColumns = cNewSDOColumns
         cNewSDOColumns = "":U.

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
        RUN setClientAction(pcSDOName + LC(pcMarkColumn) + '.mark').
      WHEN 'ambigous' THEN 
        RUN setClientAction(pcSDOName + LC(pcMarkColumn) + '.mark').
    END CASE.

    /* We want to ignore any saved records */
    EMPTY TEMP-TABLE ttCommittedData.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION loadCLOBData Include 
FUNCTION loadCLOBData RETURNS LOGICAL
  ( pcLogicalObjectName AS CHARACTER,
    pcSDOName AS CHARACTER,
    piCounter AS INTEGER) :
/*------------------------------------------------------------------------------
  Purpose:  This function will fetch the CLOB columns from the SDO and load them
            in the ttCLOBdata temp-table
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cClobColumns      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hSDOHandle        AS HANDLE     NO-UNDO.
  DEFINE VARIABLE i                 AS INTEGER    NO-UNDO.

  ASSIGN hSDOHandle = getDataSourceHandle(pcLogicalObjectName, pcSDOName, "").
  ASSIGN cClobColumns  = DYNAMIC-FUNCTION("getCLOBColumns" IN hSDOHandle).

  DO i = 1 TO NUM-ENTRIES(cClobColumns, ",":U):
    CREATE ttCLOBData.
    ASSIGN 
      ttCLOBData.SDOName      = pcSDOName
      ttCLOBData.ttCounter    = piCounter 
      ttCLOBData.ttSubCounter = i
      ttCLOBData.ttColumnName = ENTRY(i, cClobColumns, ",":U).
      
    ttCLOBData.ttDelimiter  = DYNAMIC-FUNCTION("getDataDelimiter" IN hSDOHandle).
    ttCLOBData.ttValue = DYNAMIC-FUNCTION("columnLongCharValue" IN hSDOHandle, ttCLOBData.ttColumnName).
  END.
  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION ouputConflictData Include 
FUNCTION ouputConflictData RETURNS LOGICAL
  () :
/*------------------------------------------------------------------------------
  Purpose:  This function will output the conflict data.
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cCurrentDS   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iSaveSuccess AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cDSName      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDataDelimiter AS CHARACTER NO-UNDO.

  cCurrentDS = '':U.
  iSaveSuccess = 0.
  FOR EACH ttConflictData
      BY DSName BY Counter:
      
    IF (cCurrentDS <> ttConflictData.DSName) THEN
    DO:
      IF (cCurrentDS > '':U) THEN
      DO:
        {&OUT} ']);':U + '~n':U.
        ASSIGN iSaveSuccess = 0.
      END.
      
      /* If this is a SDO in a SBO then the name is SBO.SDO and we need SDO */
      cDSName = ttConflictData.DSName.
      IF (NUM-ENTRIES(cDSName, ".":U) > 1) THEN
        cDSName = ENTRY(2, cDSName, ".":U).
        
      {&OUT} 'app._':U + cDSName + '.saveconflict([':U + '~n':U.
      
      ASSIGN cCurrentDS = ttConflictData.DSName.
      cDataDelimiter = getSavedDSDataDelimiter(gcLogicalObjectName, ttConflictData.DSName).
    END.

    ASSIGN iSaveSuccess = iSaveSuccess + 1.
    {&OUT} (IF iSaveSuccess = 1 THEN " '":U ELSE ",'":U) + escapeData(ttConflictData.Data).
    
    /* Now send the CLOB fields */
    DYNAMIC-FUNCTION("outputCLOBData" in TARGET-PROCEDURE, ttConflictData.DSName, ttConflictData.Counter).
    /* output comments data */
    {&OUT} cDataDelimiter.
    {&OUT} STRING(ttConflictData.hasComments, "yes/no").

    /* Now the lookup data */
    {&OUT} escapeData(ttConflictData.LookupData).
    
    /* Now the neding quotes */
    {&OUT} "'":U + '~n':U.

  END.
  
  IF (iSaveSuccess > 0) THEN
    {&OUT} ']);':U + '~n':U.

  EMPTY TEMP-TABLE ttConflictData.

  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION outputCLOBData Include 
FUNCTION outputCLOBData RETURNS LOGICAL
  ( pcSDOName AS CHARACTER,
    piCoutner AS INTEGER) :
&IF DEFINED(newdatatypes) &THEN
/*------------------------------------------------------------------------------
  Purpose:  This function will output the CLOB data to the stream.
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cNewLine       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cReturn        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE pcData         AS LONGCHAR   NO-UNDO.
  
  ASSIGN
    cNewLine = (IF OPSYS = "UNIX":U THEN "~\~\n":U ELSE "~\n":U)
    cReturn  = (IF OPSYS = "UNIX":U THEN "~\~\r":U ELSE "~\r":U).

  /* Send the CLOB fields */
  FOR EACH ttCLOBData
     WHERE ttCLOBData.SDOName = pcSDOName
       AND ttCLOBData.ttCounter = piCoutner
        BY ttCLOBData.ttSubCounter:
    
    {&out} ttCLOBData.ttDelimiter.
     
    /* The variable has to be longchar for some of the operations hence the 
         assignemnt form CLOB to LONGCHAR 
       Also working around a core issue of sending a blank longchar adds 
         a Carriage-Return hence the check 
    */
    
    ASSIGN pcData = ttCLOBData.ttValue.
    IF (pcData > "":U) THEN
    DO:
      /* Escape some of the characters */
      pcData = REPLACE(pcData, "~\":U, "~\~\":U).
      pcData = REPLACE(pcData, "'":U, "~\'":U).
    
      /* There may be a need to do newline or carriage return characters also */
      ASSIGN
        pcData = REPLACE(pcData, CHR(10), cNewLine)
        pcData = REPLACE(pcData, CHR(13), cReturn).
        
      {&OUT-LONG} pcData.
    END.
  END.
  RETURN TRUE.   /* Function return value. */
&ENDIF
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION outputComboData Include 
FUNCTION outputComboData RETURNS LOGICAL
  ( ) :
/*------------------------------------------------------------------------------
  Purpose:  Output any combo data
    Notes:  
------------------------------------------------------------------------------*/

  FOR EACH ttComboData:
    {&OUT} "app.apph.action('" + ttComboData.ttComboName + ".options|" + 
            ttComboData.ttData  + "');~n" SKIP.
  END.
  EMPTY TEMP-TABLE ttComboData.
  RETURN TRUE.   

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION outputCommittedData Include 
FUNCTION outputCommittedData RETURNS LOGICAL
  () :
/*------------------------------------------------------------------------------
  Purpose:  This function will output the committed data.
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cCurrentDS   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iSaveSuccess AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cDSName      AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE cDataDelimiter    AS CHARACTER  NO-UNDO.
  cCurrentDS = '':U.
  iSaveSuccess = 0.
  FOR EACH ttCommittedData
      BY DSName BY Counter:
      
    IF (cCurrentDS <> ttCommittedData.DSName) THEN
    DO:
      IF (cCurrentDS > '':U) THEN
      DO:
        {&OUT} ']);':U + '~n':U.
        ASSIGN iSaveSuccess = 0.
      END.
      
      /* If this is a SDO in a SBO then the name is SBO.SDO and we need SDO */
      cDSName = ttCommittedData.DSName.
      IF (NUM-ENTRIES(cDSName, ".":U) > 1) THEN
        cDSName = ENTRY(2, cDSName, ".":U).
        
      {&OUT} 'app._':U + cDSName + '.saveok([':U + '~n':U.
      
      ASSIGN cCurrentDS = ttCommittedData.DSName.
      cDataDelimiter = getSavedDSDataDelimiter(gcLogicalObjectName, ttCommittedData.DSName).
    END.

    ASSIGN iSaveSuccess = iSaveSuccess + 1.
    {&OUT} (IF iSaveSuccess = 1 THEN " '":U ELSE ",'":U) + escapeData(ttCommittedData.Data).
    
    /* output comments data */
    IF (ttCommittedData.Action <> "DELETE") THEN
    DO:
      /* Now send the CLOB fields */
      DYNAMIC-FUNCTION("outputCLOBData" in TARGET-PROCEDURE, ttCommittedData.DSName, ttCommittedData.Counter).

      {&OUT} cDataDelimiter.
      {&OUT} STRING(ttCommittedData.hasComments, "yes/no").
    
      /* Now the lookup data */
      {&OUT} escapeData(ttCommittedData.LookupData).
    
    END.
    
    /* Now the neding quotes */
    {&OUT} "'":U + '~n':U.

  END.
  
  IF (iSaveSuccess > 0) THEN
    {&OUT} ']);':U + '~n':U.

  EMPTY TEMP-TABLE ttCommittedData.

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
  DEFINE VARIABLE cLookupData    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iCounter       AS INTEGER    INITIAL 0 NO-UNDO.
  DEFINE VARIABLE cDataDelimiter AS CHARACTER  NO-UNDO.
  
  cDataDelimiter = getSavedDSDataDelimiter(pcLogicalObjectName, pcSDOName).

  FOR EACH ttSDOData
     WHERE ttSDOData.SDOName = pcSDOName
        BY ttSDOData.Counter:
    
    ASSIGN
      cSDODataValues = escapeData(ttSDOData.SDOValues)
      iCounter       = iCounter + 1.


    /* First send the data */
    IF (NOT plExportData) THEN
      {&out} (IF iCounter = 1 THEN " '":U ELSE ",'":U) cSDODataValues.
    ELSE 
      {&out} '<tr><td>' cSDODataValues.

    /* Now send the CLOB fields */
    DYNAMIC-FUNCTION("outputCLOBData" in TARGET-PROCEDURE, ttSDOData.SDOName, ttSDOData.Counter).

    /* output comments data */
    {&OUT} cDataDelimiter.
    {&OUT} STRING(ttSDOData.hasComments, "yes/no").
    /* Now send the lookup data */
    IF (NOT plExportData) THEN
    DO:
      ASSIGN cLookupData = appendLookupData(pcLogicalObjectName, pcSDOName, ttSDOData.SDOCols, ttSDOData.SDOValues, NO) NO-ERROR.
      {&out} escapeData(cLookupData).
    END.

    /* Now the closing tags */
    IF (NOT plExportData) THEN
      {&out} "'":U SKIP.
    ELSE 
      {&out} '</td></tr>' SKIP.
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
    hSDOHandle = getDataSourceHandle(pcLogicalObjectName, pcSDOName, "").
    IF NOT VALID-HANDLE(hSDOHandle) THEN
      RETURN FALSE.

    /* get the Data columns */
    cDataColumns = getSDODataColumns(pcSDOName, hSDOHandle, NO, YES).
    {log "'Export:' + cDataColumns"}
    /* get the Data Delimiter */
    cDataDelimiter = getSavedDSDataDelimiter(pcLogicalObjectName, pcSDOName).

    /* output the header in HTML format */
    {&OUT} '<tr><th>' REPLACE(cDataColumns, ',', '</th><th>') '</th></tr>' SKIP.
  END.
  ELSE
  DO:
    /* output the header */
    {&OUT} 'app._':U + LC(cFinalSDOName) + '.load([':U SKIP.
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

  /* First find the list of SDO's in the request */
  /* This will be used to determine the parent child relations later */
  cSDORequestList = "":U.
  REPEAT i1 = 1 TO NUM-ENTRIES(pcRequestEvents,"|":U):
    /* Find the request */
    ASSIGN cRequestEvent = ENTRY(i1, pcRequestEvents, "|":U).
    IF ( cRequestEvent = ? OR 
         cRequestEvent = "":U OR 
         INDEX(cRequestEvent,'.run') > 0 OR 
         INDEX(cRequestEvent,'.dyntree') > 0 OR 
         INDEX(cRequestEvent,'.combodata') > 0) THEN
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
    IF ( cRequestEvent = ? OR cRequestEvent = "":U
       OR INDEX(cRequestEvent,'.run') > 0 
       OR INDEX(cRequestEvent,'.dyntree') > 0 
       OR INDEX(cRequestEvent,'.combodata') > 0) THEN
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
      {log "'Pass through link is: ':U + getPassThruSDOInfo(2)"}

      IF (cParentSDOName = getPassThruSDOInfo(2) ) THEN
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION processFilterInfo Include 
FUNCTION processFilterInfo RETURNS LOGICAL PRIVATE
  ( pcOverrideLogicalObjectName AS CHARACTER,
      pcDSName AS CHARACTER,
      pcSDOName AS CHARACTER,
      pcSDOEvent AS CHARACTER,
      plSaveFilter AS LOGICAL,
      phDS AS HANDLE):
/*------------------------------------------------------------------------------
  Purpose:  This function get the filter information from the CGI stream and 
            sets the filter information to the SDO.
  Notes:
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cFilter AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSortFields AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFilterKey AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSortingKey AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lDeleteFilter AS LOGICAL    NO-UNDO.
  
  ASSIGN 
    cFilter       = get-value('_':U + pcSDOName + '._filter':U)
    cSortFields   = get-value('_':U + pcSDOName + '._sorting':U)
    cFilterKey    = pcOverrideLogicalObjectName + ".":U + pcDSName + ".filter":U
    cSortingKey   = pcOverrideLogicalObjectName + ".":U + pcDSName + ".sorting":U
    lDeleteFilter = (cFilter = "").
    
  {log "'Filter information:' + cFilter + ' and Sort field information:' + cSortFields"}
  
  /* Clear any previous filters and sorts - Remove the values from the SDO */
  RUN queryFilter (INPUT pcOverrideLogicalObjectName, INPUT pcDSName, INPUT pcSDOEvent, INPUT phDS, INPUT YES).
  
  /* Persist the new values for filters and sorts */
  DYNAMIC-FUNCTION("setPropertyList":U IN gshSessionManager,
    INPUT cFilterKey + ",":U + cSortingKey,
    INPUT cFilter + CHR(3) + cSortFields,
    INPUT NO).
  
  lognote('','Set filter: ' + cFilter).
  
  /* Persist the new values to the Profile Manager if requested (dma) */
  IF plSaveFilter THEN
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
  RUN queryFilter (INPUT pcOverrideLogicalObjectName, INPUT pcDSName, INPUT pcSDOEvent, INPUT phDS, INPUT NO).
 
  RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION removeCLOBColumns Include 
FUNCTION removeCLOBColumns RETURNS CHARACTER PRIVATE
  (pcLogicalObjectname AS CHARACTER,
   pcObjectName AS CHARACTER,
   pcDataColumns AS CHARACTER,
   pcData AS CHARACTER) :
/*------------------------------------------------------------------------------
  Purpose:  Remove the BLOC/CLOB columns from the Data
    Notes:  THIS IS A PRIVATE INTERNAL FUNCTION
------------------------------------------------------------------------------*/
  DEFINE VARIABLE i                AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cDataColumn      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFinalData       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hSDOHandle       AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cCLOBColumns     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDataDelimiter   AS CHARACTER  NO-UNDO.
 
  ASSIGN 
    hSDOHandle      = getDataSourceHandle(pcLogicalObjectName, pcObjectName, "")
&IF DEFINED(newdatatypes) &THEN
    cCLOBColumns    = DYNAMIC-FUNCTION("getCLOBColumns" IN hSDOHandle)
&ENDIF
    cDataDelimiter  = DYNAMIC-FUNCTION("getDataDelimiter" IN hSDOHandle).
      
  DO i = 1 TO NUM-ENTRIES(pcDataColumns, ",":U):
    ASSIGN 
      cDataColumn = ENTRY(i, pcDataColumns, ",":U)
      cDataColumn = ENTRY(NUM-ENTRIES(cDataColumn, ".":U), cDataColumn, ".":U).
    IF (LOOKUP(cDataColumn, cCLOBColumns) > 0) THEN
      NEXT.
    cFinalData = cFinalData + (IF cFinalData > "":U THEN cDataDelimiter ELSE "":U) +
                 ENTRY(i, pcData, cDataDelimiter).
  END.
  RETURN cFinalData.   /* Function return value. */

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
  DEFINE VARIABLE cOut        AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cLookupData AS CHARACTER NO-UNDO.
  DEFINE VARIABLE hSDO        AS HANDLE     NO-UNDO.
  
  /* We want to ignore any saved records */
  EMPTY TEMP-TABLE ttCommittedData.
  hSDO = getDataSourceHandle(pcLogicalObjectName, pcSDOName, "").
  
  ASSIGN pcData      = removeCLOBColumns(pcLogicalObjectName, pcSDOName, pcDataColumns, pcData).
  ASSIGN cLookupData = appendLookupData(pcLogicalObjectName, pcSDOName, pcDataColumns, pcData, NO) NO-ERROR.
  CREATE ttConflictData.
  ASSIGN giDataCounter = giDataCounter + 1
         ttConflictData.DSName  = pcSDOName
         ttConflictData.Counter = giDataCounter
         ttConflictData.Data = pcData
         ttConflictData.LookupData = cLookupData.

  IF VALID-HANDLE(hSDO) THEN
    ASSIGN ttConflictData.hasComments = {fn hasActiveComments hSDO}.

  /* Now get the clob data and add it to the ttCLOBData TT */
  DYNAMIC-FUNCTION("loadCLOBData" IN TARGET-PROCEDURE, 
                   pcLogicalObjectName, 
                   pcSDOName, 
                   giDataCounter).
  
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
      cOverrideLogicalObjectName = get-value('_':U + cShortSDOName + '._object':U)
      cOverrideLogicalObjectName = TRIM(cOverrideLogicalObjectName, "|":U)
      cOverrideLogicalObjectName = TRIM(cOverrideLogicalObjectName).

    IF (cOverrideLogicalObjectName = ? OR cOverrideLogicalObjectName = "":U) THEN
      cOverrideLogicalObjectName = pcLogicalObjectName.

    {log "'SaveCxt:' + cFinalDSName"} 
    FIND FIRST ttSDOLink WHERE ttSDOLInk.SDOName = cDSName NO-ERROR.
    IF NOT AVAILABLE ttSDOLink THEN NEXT.

    ASSIGN 
      cSDOEvent    = ttSDOLink.SDOEvent
      cContextName =  cOverrideLogicalObjectName + '.':U + cFinalDSName + '.context':U.

    IF CAN-DO("ALL,MORE", cSDOEvent) THEN
      NEXT.

    /* Get the SDO Handle */
    hSDOHandle = getDataSourceHandle(pcLogicalObjectName, cFinalDSName, "").

    /* Get the context from SDO */
    cSDOContext = DYNAMIC-FUNCTION("obtainContextForClient":U IN hSDOHandle).

    ASSIGN
      cSDOContext = REPLACE(cSDOContext, CHR(3), '#':U)
      cSDOContext = REPLACE(cSDOContext, CHR(4), '$':U).

    {log "'SetCxt:' + cContextName + '=' + cSDOContext"} 
    
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
                   cFinalDSName + ".path":U, 
                   pcDSPath, 
                   NO).
  
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
  ( pcLogicalObjectName as CHARACTER,
    pcDSName AS CHARACTER,
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
 /* {log "'SetDyn:' + pcLogicalObjectName + '.':U + cFinalDSName + '.dynamicInfo=' + pcDynamicSDOInfo"} */
  DYNAMIC-FUNCTION("setPropertyList":U IN gshSessionManager,
                   pcLogicalObjectName + ".":U + cFinalDSName + ".dynamicInfo":U, pcDynamicSDOInfo, 
                   NO).
  
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setDataSourceHandle Include 
FUNCTION setDataSourceHandle RETURNS LOGICAL
  ( INPUT pcLogicalObjectName AS CHARACTER, 
    INPUT pcDSName AS CHARACTER,
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
  
  FIND FIRST ttSDO WHERE ttSDO.ttContainer = pcLogicalObjectName 
                     AND ttSDO.ttName = cFinalDSName EXCLUSIVE-LOCK NO-ERROR.
                     
  IF NOT AVAILABLE ttSDO THEN 
  DO:
    IF (pcDSPath = ? OR pcDSPath = "":U) THEN
      pcDSPath = getSavedDSPath(cFinalDSName).

    CREATE ttSDO.
    ASSIGN ttSDO.ttContainer = pcLogicalObjectName
           ttSDO.ttName = cFinalDSName
           ttSDO.ttPath = pcDSPath.
  END.
  ASSIGN ttSDO.ttHandle = phDS.
  {log "'set SDO path=' + ttSDO.ttPath"}

  RETURN TRUE.
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
    Notes:  THIS API IS DEPRICATED AND WILL BE REMOVED IN THE NEXT RELEASE
            PLEASE USE setDataSourceHandle instead
------------------------------------------------------------------------------*/

  RETURN setDataSourceHandle(gcLogicalObjectName, pcDSName, pcDSPath, phDS).

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

    IF bttSDOLink.SDOName = 'master' THEN NEXT.
    pcSDOList = pcSDOList + ",":U + bttSDOLink.SDOName.
    pcSDOList = TRIM(pcSDOList, ",":U).
    pcSDOList = traverseAndBuildDSList(pcSDOList, bttSDOLink.SDOName).
  END.
  RETURN pcSDOList.   /* Function return value. */
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

