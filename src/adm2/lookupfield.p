&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/**********************************************************************
* Copyright (C) 2005,2006 by Progress Software Corporation. All rights*
* reserved.  Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                            *
*                                                                     *
**********************************************************************/
/*--------------------------------------------------------------------------
    File        : lookupfield.p
    Purpose     : Super procedure for abstract lookup class. 

    Syntax      : RUN start-super-proc("adm2/lookupfield.p":U).

  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
&SCOP ADMSuper lookupfield.p

{src/adm2/ttlookup.i}
{src/adm2/ttdcombo.i}
  
/* Custom exclude file */
{src/adm2/custom/lookupfieldexclcustom.i}

/* glUsenewAPI is conditionally defined in smrtprop.i based on &admSUPER names
   and can be used in and below the main-block in this super */
   
DEFINE VARIABLE gcCacheOptions AS CHARACTER  NO-UNDO INIT 'ALL':U.

/* Create copies of the lookup and combo temp tables */
DEFINE TEMP-TABLE ttLookupCopy LIKE ttLookup.
DEFINE TEMP-TABLE ttDComboCopy LIKE ttDCombo.

/* keeps the already retrieved values */
DEFINE TEMP-TABLE masterTTdCombo   LIKE ttDCombo.
DEFINE TEMP-TABLE masterTTLookup   LIKE ttLookup.

/* keeps the temporary result which will be obtained from the master */
DEFINE TEMP-TABLE resultTTdCombo   LIKE ttdCombo.
DEFINE TEMP-TABLE resultTTLookup   LIKE ttLookup.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-buildQuery) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD buildQuery Procedure 
FUNCTION buildQuery RETURNS CHARACTER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-dataSourceColumnValue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD dataSourceColumnValue Procedure 
FUNCTION dataSourceColumnValue RETURNS CHARACTER
  ( pcColumn AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getBaseQueryString) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getBaseQueryString Procedure 
FUNCTION getBaseQueryString RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDataSourceName) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getDataSourceName Procedure 
FUNCTION getDataSourceName RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDisplayDataType) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getDisplayDataType Procedure 
FUNCTION getDisplayDataType RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDisplayedField) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getDisplayedField Procedure 
FUNCTION getDisplayedField RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDisplayFormat) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getDisplayFormat Procedure 
FUNCTION getDisplayFormat RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getFieldLabel) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getFieldLabel Procedure 
FUNCTION getFieldLabel RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getFieldToolTip) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getFieldToolTip Procedure 
FUNCTION getFieldToolTip RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getKeyDataType) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getKeyDataType Procedure 
FUNCTION getKeyDataType RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getKeyField) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getKeyField Procedure 
FUNCTION getKeyField RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getKeyFormat) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getKeyFormat Procedure 
FUNCTION getKeyFormat RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getLabel) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getLabel Procedure 
FUNCTION getLabel RETURNS CHARACTER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getLabelHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getLabelHandle Procedure 
FUNCTION getLabelHandle RETURNS HANDLE
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getManagerHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getManagerHandle Procedure 
FUNCTION getManagerHandle RETURNS HANDLE
  ( INPUT pcManagerName AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getParentField) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getParentField Procedure 
FUNCTION getParentField RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getParentFilterQuery) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getParentFilterQuery Procedure 
FUNCTION getParentFilterQuery RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getPhysicalTableNames) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getPhysicalTableNames Procedure 
FUNCTION getPhysicalTableNames RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getQueryBuilderJoinCode) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getQueryBuilderJoinCode Procedure 
FUNCTION getQueryBuilderJoinCode RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getQueryBuilderOptionList) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getQueryBuilderOptionList Procedure 
FUNCTION getQueryBuilderOptionList RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getQueryBuilderOrderList) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getQueryBuilderOrderList Procedure 
FUNCTION getQueryBuilderOrderList RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getQueryBuilderTableOptionList) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getQueryBuilderTableOptionList Procedure 
FUNCTION getQueryBuilderTableOptionList RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getQueryBuilderTuneOptions) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getQueryBuilderTuneOptions Procedure 
FUNCTION getQueryBuilderTuneOptions RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getQueryBuilderWhereClauses) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getQueryBuilderWhereClauses Procedure 
FUNCTION getQueryBuilderWhereClauses RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getQueryString) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getQueryString Procedure 
FUNCTION getQueryString RETURNS CHAR
  (   )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getQueryTables) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getQueryTables Procedure 
FUNCTION getQueryTables RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getSDFFileName) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getSDFFileName Procedure 
FUNCTION getSDFFileName RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getSDFTemplate) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getSDFTemplate Procedure 
FUNCTION getSDFTemplate RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getTempTables) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getTempTables Procedure 
FUNCTION getTempTables RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getUseCache) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getUseCache Procedure 
FUNCTION getUseCache RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-insertExpression) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD insertExpression Procedure 
FUNCTION insertExpression RETURNS CHARACTER PRIVATE
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
   pcDataTypes   AS CHARACTER,    
   pcOperators   AS CHARACTER,
   pcQueryString AS CHARACTER,
   pcAndOr       AS CHARACTER) FORWARD.

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

&IF DEFINED(EXCLUDE-parentJoinTables) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD parentJoinTables Procedure 
FUNCTION parentJoinTables RETURNS CHARACTER
  ( pcParentFilterQuery AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-returnBuffer) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD returnBuffer Procedure 
FUNCTION returnBuffer RETURNS HANDLE
  (INPUT pcObjectType AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-returnTableIOType) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD returnTableIOType Procedure 
FUNCTION returnTableIOType RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setBaseQueryString) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setBaseQueryString Procedure 
FUNCTION setBaseQueryString RETURNS LOGICAL
  ( pcValue AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setDataSourceName) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setDataSourceName Procedure 
FUNCTION setDataSourceName RETURNS LOGICAL
  ( pcValue AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setDisplayDataType) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setDisplayDataType Procedure 
FUNCTION setDisplayDataType RETURNS LOGICAL
  ( pcValue AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setDisplayedField) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setDisplayedField Procedure 
FUNCTION setDisplayedField RETURNS LOGICAL
  ( pcDisplayedField AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setDisplayFormat) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setDisplayFormat Procedure 
FUNCTION setDisplayFormat RETURNS LOGICAL
  ( pcValue AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setFieldHidden) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setFieldHidden Procedure 
FUNCTION setFieldHidden RETURNS LOGICAL
  ( INPUT plHide AS LOGICAL )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setFieldLabel) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setFieldLabel Procedure 
FUNCTION setFieldLabel RETURNS LOGICAL
  ( pcValue AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setFieldToolTip) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setFieldToolTip Procedure 
FUNCTION setFieldToolTip RETURNS LOGICAL
  ( pcValue AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setKeyDataType) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setKeyDataType Procedure 
FUNCTION setKeyDataType RETURNS LOGICAL
  ( pcValue AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setKeyField) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setKeyField Procedure 
FUNCTION setKeyField RETURNS LOGICAL
  ( pcKeyField AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setKeyFormat) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setKeyFormat Procedure 
FUNCTION setKeyFormat RETURNS LOGICAL
  ( pcValue AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setLabel) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setLabel Procedure 
FUNCTION setLabel RETURNS LOGICAL
  ( pcLabel AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setLabelHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setLabelHandle Procedure 
FUNCTION setLabelHandle RETURNS LOGICAL
  ( phValue AS HANDLE )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setParentField) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setParentField Procedure 
FUNCTION setParentField RETURNS LOGICAL
  ( pcValue AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setParentFilterQuery) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setParentFilterQuery Procedure 
FUNCTION setParentFilterQuery RETURNS LOGICAL
  ( pcValue AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setPhysicalTableNames) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setPhysicalTableNames Procedure 
FUNCTION setPhysicalTableNames RETURNS LOGICAL
  ( pcValue AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setQueryBuilderJoinCode) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setQueryBuilderJoinCode Procedure 
FUNCTION setQueryBuilderJoinCode RETURNS LOGICAL
  ( pcValue AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setQueryBuilderOptionList) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setQueryBuilderOptionList Procedure 
FUNCTION setQueryBuilderOptionList RETURNS LOGICAL
  ( pcValue AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setQueryBuilderOrderList) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setQueryBuilderOrderList Procedure 
FUNCTION setQueryBuilderOrderList RETURNS LOGICAL
  ( pcValue AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setQueryBuilderTableOptionList) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setQueryBuilderTableOptionList Procedure 
FUNCTION setQueryBuilderTableOptionList RETURNS LOGICAL
  ( pcValue AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setQueryBuilderTuneOptions) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setQueryBuilderTuneOptions Procedure 
FUNCTION setQueryBuilderTuneOptions RETURNS LOGICAL
  ( pcValue AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setQueryBuilderWhereClauses) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setQueryBuilderWhereClauses Procedure 
FUNCTION setQueryBuilderWhereClauses RETURNS LOGICAL
  ( pcValue AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setQueryString) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setQueryString Procedure 
FUNCTION setQueryString RETURNS LOGICAL
  ( pcQuery AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setQueryTables) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setQueryTables Procedure 
FUNCTION setQueryTables RETURNS LOGICAL
  ( pcValue AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setSDFFileName) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setSDFFileName Procedure 
FUNCTION setSDFFileName RETURNS LOGICAL
  ( pcValue AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setSDFTemplate) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setSDFTemplate Procedure 
FUNCTION setSDFTemplate RETURNS LOGICAL
  ( pcValue AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setTempTables) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setTempTables Procedure 
FUNCTION setTempTables RETURNS LOGICAL
  ( pcValue AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setUseCache) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setUseCache Procedure 
FUNCTION setUseCache RETURNS LOGICAL
  ( plValue AS LOGICAL )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-whereClauseBuffer) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-EXTERNAL whereClauseBuffer Procedure 
FUNCTION whereClauseBuffer RETURNS CHARACTER PRIVATE
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
  DEFINE VARIABLE cBuffer AS CHARACTER  NO-UNDO.

  pcWhere = LEFT-TRIM(pcWhere).

  /* Remove double blanks */
  DO WHILE INDEX(pcWhere,"  ":U) > 0:
    pcWhere = REPLACE(pcWhere,"  ":U," ":U).
  END.

  cBuffer = (IF NUM-ENTRIES(pcWhere," ":U) > 1 
            THEN ENTRY(IF pcWhere BEGINS "FOR ":U THEN 3 ELSE 2,pcWhere," ":U)
            ELSE "":U).
  
  /* Strip DB prefix */
  IF NUM-ENTRIES(cBuffer,".":U) > 1 THEN
    cBuffer = ENTRY(2,cBuffer,".":U).
  
  RETURN cBuffer.

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
         HEIGHT             = 22.57
         WIDTH              = 64.6.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB Procedure 
/* ************************* Included-Libraries *********************** */

{src/adm2/lookupfieldprop.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

/* published from the Repository Manager when the client cache is cleared */
SUBSCRIBE TO "RepositoryCacheCleared":U ANYWHERE.

/* published from non-Lookup objects (i.e. Viewer) that need a cache manager */
SUBSCRIBE TO "returnCacheManager":U ANYWHERE.

IF VALID-HANDLE(gshSessionManager) THEN
  gcCacheOptions = DYNAMIC-FUNCTION('getSessionParam':U IN TARGET-PROCEDURE,
                                    'field_cache_options':U).

IF gcCacheOptions = ? OR gcCacheOptions = '':U THEN
  gcCacheOptions = 'ALL':U.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-checkComboCache) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE checkComboCache Procedure 
PROCEDURE checkComboCache PRIVATE :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER phViewer        AS HANDLE     NO-UNDO.

DEFINE VARIABLE cKeyField               AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cKeyFieldValue          AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cNewQuery               AS CHARACTER  NO-UNDO.
DEFINE VARIABLE iLoop                   AS INTEGER    NO-UNDO.
DEFINE VARIABLE hQuery                  AS HANDLE      NO-UNDO.
DEFINE VARIABLE hDataSource             AS HANDLE     NO-UNDO.

  {get DataSource hDataSource phViewer}.

  COMBO_LOOP:
  FOR EACH  ttDCombo WHERE ttDCombo.hViewer = phViewer
                       AND ttDCombo.lRefreshQuery = TRUE
                       AND ttDcombo.cForEach > ''
                     BY    ttDCombo.iBuildSequence
                     BY    ttDCombo.hWidget:
     
    /* default to decimal if not set-up */
    IF ttDCombo.cWidgetType = "":U THEN
      ttDCombo.cWidgetType = "Decimal":U. 
  
    /* Default to comma delimiter */
    IF ttDCombo.cListItemDelimiter = "":U THEN
      ttDCombo.cListItemDelimiter = ",":U.  
    
    /* Check & reassign comma delimiter, check with euro format */
    IF SESSION:NUMERIC-DECIMAL-POINT = ",":U AND
       ttDCombo.cWidgetType = "Decimal":U AND
       ttDCombo.cListItemDelimiter = ",":U THEN
     ttDCombo.cListItemDelimiter = CHR(3).  
  
    /* set the current combo value from the viewer's data source */
    IF VALID-HANDLE(hDataSource) THEN
      ttDCombo.cCurrentKeyValue = {fnarg ColumnValue ttDCombo.cKeyFieldName hDataSource}.
     
    /* Check if we should be looking for cached data */
    IF (LOOKUP("DynCombo":U, gcCacheOptions) > 0 OR
        LOOKUP("ALL":U, gcCacheOptions) > 0) AND
       ttDCombo.lUseCache = TRUE THEN
    DO:
        /* Find if current combo-request is already cached in memory-tables */
        FIND FIRST masterTTDCombo 
             WHERE masterTTDCombo.cForEach                 EQ ttDCombo.cForEach
             AND   masterTTDCombo.cWidgetType              EQ ttDCombo.cWidgetType
             AND   masterTTDCombo.cBufferList              EQ ttDCombo.cBufferList
             AND   masterTTDCombo.cPhysicalTableNames      EQ ttDCombo.cPhysicalTableNames
             AND   masterTTDCombo.cTempTableNames          EQ ttDCombo.cTempTableNames
             AND   masterTTDCombo.cKeyFieldName            EQ ttDCombo.cKeyFieldName
             AND   masterTTDCombo.cKeyFormat               EQ ttDCombo.cKeyFormat
             AND   masterTTDCombo.cDescFieldNames          EQ ttDCombo.cDescFieldNames
             AND   masterTTDCombo.cDescSubstitute          EQ ttDCombo.cDescSubstitute
             AND   masterTTDCombo.cFlag                    EQ ttDCombo.cFlag
             AND   masterTTDCombo.cFlagValue               EQ ttDCombo.cFlagValue
             AND   masterTTDCombo.cListItemDelimiter       EQ ttDCombo.cListItemDelimiter
             NO-LOCK NO-ERROR.

        /* append/override TT values from cache */
        IF AVAILABLE masterTTDCombo THEN
        DO:
          ASSIGN 
            ttDCombo.cListItemPairs     = masterTTDCombo.cListItemPairs
            ttDCombo.cKeyValues         = masterTTDCombo.cKeyValues
            ttDCombo.cDescriptionValues = masterTTDCombo.cDescriptionValues
            /* resolve the Current Description Value corresponding to the current Key Value */
            ttDCombo.cCurrentDescValue = ENTRY(LOOKUP(ttDCombo.cCurrentKeyValue,
                                                      ttDCombo.cKeyValues,
                                                      ttDCombo.cListItemDelimiter),
                                               ttDCombo.cDescriptionValues,
                                               ttDCombo.cListItemDelimiter) NO-ERROR.
          NEXT COMBO_LOOP.
        END.
    END.

    ttDCombo.lRefreshQuery = FALSE.
    /* create an entry in ttDComboCopy to be retrieved by the server */
    CREATE ttDComboCopy.
    BUFFER-COPY ttDCombo 
         EXCEPT cListItemPairs cDescriptionValues cCurrentDescValue cKeyValues
             TO ttDComboCopy.
  END. /* EACH  ttDCombo */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-checkLookupCache) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE checkLookupCache Procedure 
PROCEDURE checkLookupCache PRIVATE :
/*------------------------------------------------------------------------------
  Purpose:     This procedure will attempt to find any cached information for
               all lookups for a particular viewer
  Parameters:  phViewer - The handle of the current viewer
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER phViewer       AS HANDLE     NO-UNDO.

DEFINE VARIABLE hQuery                  AS HANDLE      NO-UNDO.
DEFINE VARIABLE cQueryTables            AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cKeyField               AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cKeyFieldValue          AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cDisplayedField         AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cDisplayValue           AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cNewQuery               AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cParentField            AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cParentFilterQuery      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE iLoop                   AS INTEGER    NO-UNDO.
DEFINE VARIABLE hContainer              AS HANDLE     NO-UNDO.
DEFINE VARIABLE hDataSource             AS HANDLE     NO-UNDO.
DEFINE VARIABLE lModified               AS LOGICAL    NO-UNDO.
DEFINE VARIABLE hField                  AS HANDLE     NO-UNDO.

  {get DataSource hDataSource phViewer}.

  /* Find if current Lookup-request is already cached in memory-tables */
  LOOKUP_LOOP:
  FOR EACH ttLookup WHERE ttLookup.hViewer = phViewer 
                      AND ttLookup.lRefreshQuery = TRUE:
    /* default to decimal if not set-up */
    IF ttLookup.cWidgetType = "":U THEN
      ASSIGN ttLookup.cWidgetType = "DECIMAL":U.    

    
    /* Check if we should be looking for cached data */
    IF (LOOKUP("DynLookup":U, gcCacheOptions) > 0 OR
        LOOKUP("ALL":U, gcCacheOptions) > 0) AND
       ttLookup.lUseCache = TRUE THEN
    DO:
        /* Find if current combo-request is already cached in memory-tables */
        FIND FIRST masterTTLookup 
             WHERE masterTTLookup.cWidgetType         = ttLookup.cWidgetType
             AND   masterTTLookup.cForEach            = ttLookup.cForEach
             AND   masterTTLookup.cBufferList         = ttLookup.cBufferList
             AND   masterTTLookup.cPhysicalTableNames = ttLookup.cPhysicalTableNames
             AND   masterTTLookup.cTempTableNames     = ttLookup.cTempTableNames
             AND   masterTTLookup.cFieldList          = ttLookup.cFieldList  
             AND   masterTTLookup.cDataTypeList       = ttLookup.cDataTypeList
             NO-LOCK NO-ERROR.

        IF AVAILABLE masterTTLookup THEN
        DO:
          /* cache found - copy values */
          ASSIGN ttLookup.cFoundDataValues = masterTTLookup.cFoundDataValues
                 ttLookup.cRowIdent        = masterTTLookup.cRowIdent       
                 ttLookup.lMoreFound       = masterTTLookup.lMoreFound     
                 ttLookup.lRefreshQuery    = masterTTLookup.lRefreshQuery.
          NEXT LOOKUP_LOOP.
        END. /* AVAILABLE masterTTLookup */
    END.
    ttLookup.lRefreshQuery = FALSE.
    /* create transfer record to retrieve data from server */
    CREATE ttLookupCopy.
    BUFFER-COPY ttLookup 
         EXCEPT ttLookup.cFoundDataValues
                ttLookup.cRowIdent
             TO ttLookupCopy.
  END. /* EACH ttLookup */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-clearCache) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE clearCache Procedure 
PROCEDURE clearCache :
/*------------------------------------------------------------------------------
  Purpose:     This procedure will clear the temp-tables that contains the 
               cached data for lookups and combos
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

EMPTY TEMP-TABLE masterTTDCombo.
EMPTY TEMP-TABLE masterTTLookup.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-copyToComboTable) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE copyToComboTable Procedure 
PROCEDURE copyToComboTable :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER TABLE FOR ttDComboCopy.

  RUN copyToComboTableLocal.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-copyToComboTableLocal) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE copyToComboTableLocal Procedure 
PROCEDURE copyToComboTableLocal PRIVATE :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    FOR EACH ttDComboCopy:
        FIND ttDCombo WHERE
            ttDCombo.hwidget = ttDComboCopy.hwidget
            NO-LOCK NO-ERROR.
        IF NOT AVAIL ttDCombo THEN
          CREATE ttDCombo.
        BUFFER-COPY ttDComboCopy TO ttDCombo.
    END.

    EMPTY TEMP-TABLE ttDComboCopy.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-copyToLookupTable) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE copyToLookupTable Procedure 
PROCEDURE copyToLookupTable :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER TABLE FOR ttLookupCopy.

  RUN copyToLookupTableLocal.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-copyToLookupTableLocal) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE copyToLookupTableLocal Procedure 
PROCEDURE copyToLookupTableLocal PRIVATE :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    FOR EACH ttLookupCopy:
        FIND ttLookup WHERE
            ttLookup.hwidget = ttLookupCopy.hwidget
            NO-LOCK NO-ERROR.
        IF NOT AVAIL ttLookup THEN
          CREATE ttLookup.
        BUFFER-COPY ttLookupCopy TO ttLookup.
    END.

    EMPTY TEMP-TABLE ttLookupCopy.

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
  Notes:       Remove the TT records for Combo/Lookup objects being destroyed
------------------------------------------------------------------------------*/

  FIND FIRST ttDCombo
       WHERE ttDCombo.hWidget = TARGET-PROCEDURE
       NO-ERROR.
  IF AVAILABLE ttDCombo THEN 
    DELETE ttDCombo.
  ELSE DO:
    FIND FIRST ttLookup
         WHERE ttLookup.hWidget = TARGET-PROCEDURE
         NO-ERROR.
    IF AVAILABLE ttLookup THEN 
      DELETE ttLookup.
    ELSE
      ASSIGN ERROR-STATUS:ERROR = NO.
  END.
  
  RUN SUPER.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-disable_UI) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI Procedure 
PROCEDURE disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
  /* Hide all frames. */
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-endMove) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE endMove Procedure 
PROCEDURE endMove :
/*------------------------------------------------------------------------------
  Purpose:  Move the label when the field is moved in design-mode    
  Parameters:  
  Notes:    Defined as PERSISTENT on END-MOVE of the frame of the widget.    
------------------------------------------------------------------------------*/

   DEFINE VARIABLE cBlank AS CHARACTER NO-UNDO.
   /* Because we override endmove we must apply it in order to make the
      AppBuilder notify the change */
   APPLY "END-RESIZE":U TO SELF. /* runs setPosition */
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-hideObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE hideObject Procedure 
PROCEDURE hideObject :
/*------------------------------------------------------------------------------
  Purpose: Override in order to make sure the label is hidden     
  Parameters:  <none>
  Notes:   For sizing reasons, the label is not really a part of the object,
           but added as a text widget to the parent frame.    
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hLabel AS HANDLE NO-UNDO.

  {get LabelHandle hLabel}.

  IF VALID-HANDLE(hLabel) THEN 
    hLabel:HIDDEN = TRUE.

  RUN SUPER.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-notifyChildFields) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE notifyChildFields Procedure 
PROCEDURE notifyChildFields :
/*------------------------------------------------------------------------------
  Purpose:  Refresh child combos   
  Parameters:  pcEvent - 
               Prepare    = prepareField
               Retrieve   = prepareField,retrieveData
               Fetch      = preparefield,retrieveData and displayField 
               Reset      = reset/reopen/rebuild children only
  Notes:   Limitations: 
           - Lookup Children are not currently refreshed
           (This may be right or wrong (most likely wrong..), but this is the 
            old behavior so options/properties are needed if change and more
            control is required.  
           - The Lookups linked fields children are not refreshed..           
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER pcEvent AS CHARACTER  NO-UNDO.

DEFINE VARIABLE hContainer  AS HANDLE     NO-UNDO.
DEFINE VARIABLE cField      AS CHARACTER  NO-UNDO.
  
  &SCOPED-DEFINE xp-assign
  {get FieldName cField}
  {get ContainerSource hContainer}  
  .
  &UNDEFINE xp-assign
  /* manager api, don't use target-procedure...*/ 
  RUN notifyFields (pcEvent, hContainer, cField).  

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-notifyFields) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE notifyFields Procedure 
PROCEDURE notifyFields :
/*------------------------------------------------------------------------------
  Purpose:  Notify data events to a set of fields.    
  Parameters: pcEvent      
               Prepare    = prepareField
               Retrieve   = prepareField,retrieveData
               Fetch      = preparefield,retrieveData and displayField 
               Reset      = reset/reopen/rebuild children onlyphViewer    - viewer handle
              pcParent    - Parent name 
                            - blank = fields with no parent
                            - ?     = all
             
  Notes: -    
         - Works only for combos 
-------------------------------------------------------------------------------*/  
  DEFINE INPUT  PARAMETER pcEvent     AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER phViewer    AS HANDLE     NO-UNDO.
  DEFINE INPUT  PARAMETER pcParent    AS CHARACTER  NO-UNDO.
  
  DEFINE BUFFER bttDComboChild FOR ttDCombo.

  IF LOOKUP(pcEvent,'Fetch,Prepare,Retrieve':U) > 0 THEN
  FOR EACH bttDComboChild WHERE bttDComboChild.hViewer = phViewer
                          AND (pcParent = ? 
                               OR (pcParent = '' AND bttDComboChild.cParentField = '')
                               OR LOOKUP(pcParent,bttDComboChild.cParentField) > 0):
    RUN prepareField IN bttDComboChild.hWidget.
  END.

  IF LOOKUP(pcEvent, 'Fetch,Retrieve':U) > 0 THEN
    RUN retrieveData (phViewer).
  
  IF LOOKUP(pcEvent,'Fetch,Reset':U) > 0 THEN
  FOR EACH bttDComboChild WHERE bttDComboChild.hViewer = phViewer
                          AND (pcParent = ? 
                               OR (pcParent = '' AND bttDComboChild.cParentField = '')
                               OR LOOKUP(pcParent,bttDComboChild.cParentField) > 0):
    {fnarg buildCombo 'RESET' bttDComboChild.hWidget}.
  END.

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-oldReturnParentFieldValues) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE oldReturnParentFieldValues Procedure 
PROCEDURE oldReturnParentFieldValues :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE OUTPUT PARAMETER pcNewQuery  AS CHARACTER  NO-UNDO.
  
  DEFINE VARIABLE cParentField      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFilterQuery      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hContainer        AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hWidget           AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cAllFieldHandles  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iLoop             AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iField            AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cField            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cValue            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSubs             AS CHARACTER  NO-UNDO EXTENT 9.
  DEFINE VARIABLE cSDFFieldName     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hSDFHandle        AS HANDLE     NO-UNDO.

  &SCOPED-DEFINE xp-assign
  {get ParentField cParentField}
  {get ParentFilterQuery cFilterQuery}
  {get containerSource hContainer}.   /* viewer */
  &UNDEFINE xp-assign

  IF cFilterQuery = ? OR cFilterQuery = "?":U THEN
    cFilterQuery = "":U.
  IF cParentField = ? OR cParentField = "?":U THEN
    cParentField = "":U.

  IF cParentField <> "":U AND VALID-HANDLE(hContainer) THEN
    cAllFieldHandles = DYNAMIC-FUNCTION("getAllFieldHandles":U IN hContainer).
  
  IF cAllFieldHandles <> "":U AND cParentField <> "":U THEN
  field-loop:
  DO iLoop = 1 TO NUM-ENTRIES(cAllFieldHandles):
    hWidget = WIDGET-HANDLE(ENTRY(iLoop,cAllFieldHandles)).
    /* Normal Widgets - Non SmartDataFields */
    IF VALID-HANDLE(hWidget) AND
       hWidget:TYPE <> "PROCEDURE":U AND
       CAN-QUERY(hWidget, "NAME":U) AND 
       LOOKUP(hWidget:NAME, cParentField) <> 0 AND 
       hWidget:NAME <> ? THEN
    DO:
      ASSIGN
        iField = LOOKUP(hWidget:NAME, cParentField)
        cField = ENTRY(iField,cParentField)
        NO-ERROR.
      IF iField > 0 AND iField <= 9 AND iField <> ? THEN
        ASSIGN cValue        = IF CAN-QUERY(hWidget,"INPUT-VALUE":U) THEN hWidget:INPUT-VALUE ELSE hWidget:INPUT-VALUE
               cValue        = IF cValue = ? OR cValue = "?":U THEN "":U ELSE cValue
               cSubs[iField] = TRIM(cValue).
    END.
    
    /* SmartDataFields Static Combo, Dynamic Combos and Lookups */
    IF VALID-HANDLE(hWidget) AND hWidget:TYPE = "PROCEDURE":U THEN 
    DO:
      ASSIGN 
        hSDFHandle    = hWidget
        cSDFFieldName = '':U.
  
      {get FieldName cSDFFieldName hSDFHandle} NO-ERROR.
      IF cSDFFieldName NE '':U THEN
      DO:
        ASSIGN
          iField = LOOKUP(cSDFFieldName, cParentField)
          cField = ENTRY(iField,cParentField) NO-ERROR.
  
        {get DataValue cValue hSDFHandle}.
         
        IF iField > 0 AND iField <= 9 THEN
          ASSIGN cSubs[iField] = TRIM(cValue).
      END.  /* if SDF */
    END.  /* if procedure */
    
  END.
  
  pcNewQuery = SUBSTITUTE(cFilterQuery,cSubs[1],cSubs[2],cSubs[3],cSubs[4],cSubs[5],cSubs[6],cSubs[7],cSubs[8],cSubs[9]).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-repositionObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE repositionObject Procedure 
PROCEDURE repositionObject :
/*------------------------------------------------------------------------------
  Purpose:     This procedure will reposition the lookup fill-in and it's label
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pdRow    AS DECIMAL    NO-UNDO.
  DEFINE INPUT PARAMETER pdColumn AS DECIMAL    NO-UNDO.

  DEFINE VARIABLE hLabelHandle    AS HANDLE     NO-UNDO.
  DEFINE VARIABLE iLabelLength    AS INTEGER    NO-UNDO.
  DEFINE VARIABLE hFrame          AS HANDLE     NO-UNDO.

  RUN SUPER (INPUT pdRow, INPUT pdColumn).

  {get LabelHandle hLabelHandle}.

  IF NOT VALID-HANDLE(hLabelHandle) THEN
    RETURN.

  IF TRIM(hLabelHandle:SCREEN-VALUE) = "":U THEN
    RETURN.

  {get ContainerHandle hFrame}.

  iLabelLength = FONT-TABLE:GET-TEXT-WIDTH-PIXELS(hLabelHandle:SCREEN-VALUE + " ":U, hFrame:FONT).

  ASSIGN
      hLabelHandle:X            = hFrame:X - iLabelLength
      hLabelHandle:Y            = hFrame:Y
      hLabelHandle:WIDTH-PIXELS = iLabelLength
      .

  RETURN. 
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-repositoryCacheCleared) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE repositoryCacheCleared Procedure 
PROCEDURE repositoryCacheCleared :
/*------------------------------------------------------------------------------
  Purpose:     This event is published from the repository manager when the
               client cache was cleared and should in turn cleat the SDF's
               client cache.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  RUN clearCache IN TARGET-PROCEDURE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-retrieveAppserverData) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE retrieveAppserverData Procedure 
PROCEDURE retrieveAppserverData PRIVATE :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER phViewer       AS HANDLE NO-UNDO.

  IF VALID-HANDLE(gshAstraAppserver) AND
    (CAN-FIND(FIRST ttLookupCopy) OR
     CAN-FIND(FIRST ttDComboCopy)) THEN
  DO:
      RUN adm2/fetchfield.p ON gshAstraAppserver 
                       (INPUT-OUTPUT TABLE ttLookupCopy,
                        INPUT-OUTPUT TABLE ttDComboCopy).
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-retrieveData) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE retrieveData Procedure 
PROCEDURE retrieveData :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER phViewer           AS HANDLE     NO-UNDO.

  /* cleanup the transfer TTs */
  EMPTY TEMP-TABLE ttDComboCopy.
  EMPTY TEMP-TABLE ttLookupCopy.

  /* check which record is in master */
  RUN checkComboCache (phViewer).   
  RUN checkLookupCache (phViewer).   

  /* Retrieve info from AppServer */
  RUN retrieveAppServerData (phViewer).

  /* Append retrieved data to Master tables */
  RUN updateMasterTTDCombo.
  RUN updateMasterTTLookup.

  /* merge with existing TTs */
  RUN copyToComboTableLocal.
  RUN copyToLookupTableLocal.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-returnCacheManager) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE returnCacheManager Procedure 
PROCEDURE returnCacheManager :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE OUTPUT PARAMETER phCacheManager AS HANDLE NO-UNDO.  
   
   phCacheManager = THIS-PROCEDURE.

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
DEFINE OUTPUT PARAMETER pcNewQuery          AS CHARACTER  NO-UNDO.

DEFINE VARIABLE iWidget           AS INTEGER    NO-UNDO.
DEFINE VARIABLE hWidget           AS HANDLE     NO-UNDO.
DEFINE VARIABLE ifield            AS INTEGER    NO-UNDO.
DEFINE VARIABLE cField            AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cValue            AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cSubs             AS CHARACTER  NO-UNDO EXTENT 9.
DEFINE VARIABLE cAllFieldHandles  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cAllFieldNames    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cDisplayedFields  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE hDataSource       AS HANDLE     NO-UNDO.
DEFINE VARIABLE cParentFieldList      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cParentFilterQuery AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cFieldHandles      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE iDWidget           AS INTEGER    NO-UNDO.
DEFINE VARIABLE hContainer         AS HANDLE     NO-UNDO.
DEFINE VARIABLE lUseDataSource     AS LOGICAL    NO-UNDO.
DEFINE VARIABLE hVar               AS HANDLE     NO-UNDO.
DEFINE VARIABLE cDSN               AS CHARACTER    NO-UNDO.
  
  /* if the caller is using the old API redirect the call */
  IF NOT glUseNewAPI THEN
  DO:
    RUN oldReturnParentFieldValues IN TARGET-PROCEDURE ( OUTPUT pcNewQuery ).
    RETURN.
  END.
  
  &SCOPED-DEFINE xp-assign
  {get ParentField cParentFieldList}
  {get ParentFilterQuery cParentFilterQuery}
  {get ContainerSource hContainer}   /* viewer */
  .
  &UNDEFINE xp-assign
  
  &SCOPED-DEFINE xp-assign
  {get AllFieldHandles cAllFieldHandles hContainer}
  {get AllFieldNames cAllFieldNames hContainer}
  {get DisplayedFields cDisplayedFields hContainer}
  {get FieldHandles cFieldHandles hContainer}
  {get DataSource hDataSource hContainer}
  .
  &UNDEFINE xp-assign
  
  
  DO iField = 1 TO NUM-ENTRIES(cParentFieldList):
    ASSIGN
      cValue  = ""
      cField  = ENTRY(ifield, cParentFieldList)
      lUseDataSource = FALSE
      iDWidget = LOOKUP(cField, cDisplayedFields).

    
    IF iDWidget > 0 THEN
      hWidget = WIDGET-HANDLE(ENTRY(iDWidget, cFieldHandles)).
    ELSE DO:
      iWidget = LOOKUP(cField, cAllFieldNames).
      IF iWidget > 0 THEN
        hWidget = WIDGET-HANDLE(ENTRY(iWidget, cAllFieldHandles)).
    END.
     
    IF VALID-HANDLE(hWidget) THEN
    DO:
      /* Use viewer data-source unless modified if possible to enable this 
         to be called on record change before display */       
      IF iDWidget > 0 AND VALID-HANDLE(hDataSource) THEN
      DO: 
        IF hWidget:TYPE = 'PROCEDURE':U THEN
        DO:
          IF NOT {fn getDataModified hWidget} THEN
            lUseDataSource = TRUE.
        END.
        ELSE IF NOT hWidget:MODIFIED THEN
          lUseDataSource = TRUE.
      END.
      
      IF lUseDataSource THEN 
      DO:
        /* check if the DataSource is an SBO */
        {get MasterDataObject hVar hDataSource} NO-ERROR.      
        IF VALID-HANDLE(hVar) THEN
        DO: 
          /* if this viewer is constructed from an SBO the fields are already qualified */
          IF NOT INDEX(cField, ".":U) > 0 THEN
          DO:
            {get DataSourceNames cDSN hContainer}.
            IF cDSN > "":U THEN
              cField = cDSN + ".":U + cField.
          END.
        END.
        cValue = {fnarg columnValue cField hDataSource}. 
      END.
      ELSE IF hWidget:TYPE = 'PROCEDURE':U THEN
        cValue = {fn getDataValue hWidget}. 
      ELSE 
        cValue = hWidget:INPUT-VALUE.     
      IF cValue = ? OR cValue = "?":U THEN
        cValue = "".
    END.

    cSubs[ifield] = TRIM(cValue).
  END.
  pcNewQuery = SUBSTITUTE(cParentFilterQuery,cSubs[1],cSubs[2],cSubs[3],cSubs[4],
                           cSubs[5],cSubs[6],cSubs[7],cSubs[8],cSubs[9]).
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-shortCutKey) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE shortCutKey Procedure 
PROCEDURE shortCutKey :
/*------------------------------------------------------------------------------
  Purpose:     We could trap a keypress in here and auto-display single value
               found if only 1 is found, by going direct to query.
  Parameters:  <none>
  Notes:       Use LAST-EVENT:FUNCTION for testing keypress.
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cBrowseKeys AS CHAR  NO-UNDO.

  /* Check to see if the Lookup button is enabled. If it is not,
     it probably means that the programmer did not want to perform a lookup
     and therefore ran the disableButton procedure. In this case, do not open
     the browser.

     *** NOTE: Because the standard behaviour would enable the browser again
        -----  no RUN SUPER will be done!!! */
  DEFINE VARIABLE hButton AS HANDLE NO-UNDO.

  {get ButtonHandle hButton}.

  IF hButton:SENSITIVE = TRUE THEN
  DO:
    RUN initializeBrowse IN TARGET-PROCEDURE.
    RETURN NO-APPLY.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-updateMasterTTDCombo) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE updateMasterTTDCombo Procedure 
PROCEDURE updateMasterTTDCombo PRIVATE :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:      
------------------------------------------------------------------------------*/
DEFINE VARIABLE lCache AS LOGICAL    NO-UNDO.
DEFINE VARIABLE iPos AS INTEGER    NO-UNDO.
DEFINE VARIABLE cDummyButton AS CHARACTER  NO-UNDO.

  lCache = (LOOKUP("DynCombo":U, gcCacheOptions) > 0 OR
            LOOKUP("ALL":U, gcCacheOptions) > 0).

  FOR EACH ttDComboCopy:
    /* check if data retrieval errors occured */
    IF ENTRY(2, ttDComboCopy.cListItemPairs,ttDComboCopy.cListItemDelimiter) = "<ERROR>":U THEN
    DO:
      RUN showMessages IN gshSessionManager 
        (INPUT "Combo '" + ttDComboCopy.cWidgetName + "' Failed to retrieve data: " +
               ENTRY(1, ttDComboCopy.cListItemPairs,ttDComboCopy.cListItemDelimiter),
         INPUT "ERR",
         INPUT "&OK",
         INPUT "&OK",
         INPUT "&OK",
         INPUT "Error",
         INPUT NO,
         INPUT ?,
         OUTPUT cDummyButton).
      ttDComboCopy.cListItemPairs = ttDComboCopy.cListItemDelimiter.
    END.
    FIND ttDCombo WHERE ttDCombo.hwidget = ttDComboCopy.hwidget.

    /* find the default value specified and set the current description */
    iPos = LOOKUP(ttDCombo.cCurrentKeyValue, 
                  ttDComboCopy.cListItemPairs, 
                  ttDComboCopy.cListItemDelimiter).
    IF iPos > 2 THEN
      ttDComboCopy.cCurrentDescValue = ENTRY(iPos - 1, 
                                             ttDComboCopy.cListItemPairs, 
                                             ttDComboCopy.cListItemDelimiter).
    ELSE
      ttDComboCopy.cCurrentDescValue = "":U.

    BUFFER-COPY ttDComboCopy TO ttDCombo.

    IF lCache THEN
    DO:
      /* Check if new is already in Master */
      FIND FIRST masterTTDCombo 
           WHERE masterTTDCombo.cWidgetType         = ttDCombo.cWidgetType
           AND   masterTTDCombo.cForEach            = ttDCombo.cForEach
           AND   masterTTDCombo.cBufferList         = ttDCombo.cBufferList
           AND   masterTTDCombo.cPhysicalTableNames = ttDCombo.cPhysicalTableNames 
           AND   masterTTDCombo.cTempTableNames     = ttDCombo.cTempTableNames 
           AND   masterTTDCombo.cKeyFieldName       = ttDCombo.cKeyFieldName
           AND   masterTTDCombo.cKeyFormat          = ttDCombo.cKeyFormat
           AND   masterTTDCombo.cDescFieldNames     = ttDCombo.cDescFieldNames
           AND   masterTTDCombo.cDescSubstitute     = ttDCombo.cDescSubstitute
           AND   masterTTDCombo.cCurrentKeyValue    = ttDCombo.cCurrentKeyValue
           AND   masterTTDCombo.cFlag               = ttDCombo.cFlag
           AND   masterTTDCombo.cFlagValue          = ttDCombo.cFlagValue
           AND   masterTTDCombo.cListItemDelimiter  = ttDCombo.cListItemDelimiter
           AND   masterTTDCombo.cParentField        = ttDCombo.cParentField
           AND   masterTTDCombo.cParentFilterQuery  = ttDCombo.cParentFilterQuery
           NO-LOCK NO-ERROR.
      IF NOT AVAILABLE masterTTDCombo THEN
      DO:
        CREATE masterTTDCombo.
        RAW-TRANSFER ttDCombo TO masterTTDCombo.
      END.
    END.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-updateMasterTTLookup) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE updateMasterTTLookup Procedure 
PROCEDURE updateMasterTTLookup PRIVATE :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE lCache AS LOGICAL    NO-UNDO.

  lCache = (LOOKUP("DynLookup":U, gcCacheOptions) > 0 OR
            LOOKUP("ALL":U, gcCacheOptions) > 0).
  FOR EACH ttLookupCopy:
    FIND ttLookup WHERE ttLookup.hwidget = ttLookupCopy.hwidget.
    BUFFER-COPY ttLookupCopy TO ttLookup.
    IF lCache THEN
    DO:
      /* Check if new is already in Master */
      FIND FIRST masterTTLookup 
           WHERE masterTTLookup.cWidgetType         = ttLookup.cWidgetType
           AND   masterTTLookup.cForEach            = ttLookup.cForEach
           AND   masterTTLookup.cBufferList         = ttLookup.cBufferList
           AND   masterTTLookup.cPhysicalTableNames = ttLookup.cPhysicalTableNames 
           AND   masterTTLookup.cTempTableNames     = ttLookup.cTempTableNames
           AND   masterTTLookup.cFieldList          = ttLookup.cFieldList   
           AND   masterTTLookup.cDataTypeList       = ttLookup.cDataTypeList
           AND   masterTTLookup.cFoundDataValues    = ttLookup.cFoundDataValues
           AND   masterTTLookup.cRowIdent           = ttLookup.cRowIdent       
           AND   masterTTLookup.lMoreFound          = ttLookup.lMoreFound
           AND   masterTTLookup.lRefreshQuery       = ttLookup.lRefreshQuery
           NO-LOCK NO-ERROR.
      IF NOT AVAILABLE masterTTLookup THEN
      DO:
        CREATE masterTTLookup.
        RAW-TRANSFER ttLookup TO masterTTLookup.
      END.
    END.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-viewObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE viewObject Procedure 
PROCEDURE viewObject :
/*------------------------------------------------------------------------------
  Purpose: Make sure the label is viewed     
  Parameters:  <none>
  Notes:   For sizing reasons, the label is not really a part of the object,
           but added as a text widget to the parent frame.    
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hLabel AS HANDLE NO-UNDO.

  {get LabelHandle hLabel}.

  IF VALID-HANDLE(hLabel) THEN 
    hLabel:HIDDEN = FALSE.

  RUN SUPER.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-buildQuery) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION buildQuery Procedure 
FUNCTION buildQuery RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:    Build and returns the query of the field instance as defined by 
              the BaseQueryString, current parent filter values and potential
              fixed filter definitions without the position criteria added by 
              the field's own values.
  Parameters:
  Notes:      The lookup uses this as basis for search expression defined by the 
              displayedfield or position expression defined by the Field value
------------------------------------------------------------------------------*/
    DEFINE VARIABLE cFieldQuery       AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cParentFilterList AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cQueryTables      AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE iLoop             AS INTEGER    NO-UNDO.

    {get BaseQueryString cFieldQuery}.  
    /* Set Parent-Child filter */
    RUN returnParentFieldValues IN TARGET-PROCEDURE (OUTPUT cParentFilterList).
    IF cParentFilterList > "":U THEN 
    DO:
      cQueryTables = {fnarg parentJoinTables cParentFilterList}.
      DO iLoop = 1 TO NUM-ENTRIES(cParentFilterList,"|":U):
        IF TRIM(ENTRY(iLoop,cParentFilterList,"|":U)) > "":U THEN
           cFieldQuery = DYNAMIC-FUNCTION("newWhereClause" IN TARGET-PROCEDURE,
                                           ENTRY(iLoop,cQueryTables),
                                           ENTRY(iLoop,cParentFilterList,"|":U),
                                           cFieldQuery,
                                           "AND":U).
      END.
    END. /* parentFilter > '' */

    /* Process any filter set phrases in the query string */
    IF VALID-HANDLE(gshGenManager) THEN
      RUN processQueryStringFilterSets IN gshGenManager (INPUT  cFieldQuery,
                                                         OUTPUT cFieldQuery).

    RETURN cFieldQuery.    

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-dataSourceColumnValue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION dataSourceColumnValue Procedure 
FUNCTION dataSourceColumnValue RETURNS CHARACTER
  ( pcColumn AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE iColumn AS INTEGER    NO-UNDO.

  FIND ttLookup WHERE ttLookup.hWidget = TARGET-PROCEDURE NO-ERROR.
  IF AVAIL ttLookup AND ttLookup.cFoundDataValues > '':U THEN
  DO:
    iColumn = LOOKUP(pcColumn,ttLookup.cFieldList).
    IF iColumn <= NUM-ENTRIES(ttLookup.cFoundDataValues, CHR(1)) THEN
      RETURN ENTRY(iColumn,ttLookup.cFoundDataValues, CHR(1)).
  END.
  
  RETURN ?.   

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getBaseQueryString) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getBaseQueryString Procedure 
FUNCTION getBaseQueryString RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose: 
    Notes:   
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cValue AS CHARACTER NO-UNDO.
  {get BaseQueryString cValue}.
  RETURN cValue.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDataSourceName) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getDataSourceName Procedure 
FUNCTION getDataSourceName RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose: 
    Notes:   
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cValue AS CHARACTER NO-UNDO.
  {get DataSourceName cValue}.
  RETURN cValue.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDisplayDataType) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getDisplayDataType Procedure 
FUNCTION getDisplayDataType RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose: 
    Notes:   
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cValue AS CHARACTER NO-UNDO.
  {get DisplayDataType cValue}.
  RETURN cValue.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDisplayedField) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getDisplayedField Procedure 
FUNCTION getDisplayedField RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose: Returns the name of the field to display in the selection
    Notes:   
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cDisplayedField AS CHARACTER NO-UNDO.
  
  &scoped-define xpDisplayedField
  {get DisplayedField cDisplayedField}.
  &undefine xpDisplayedField
  
  RETURN cDisplayedField.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDisplayFormat) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getDisplayFormat Procedure 
FUNCTION getDisplayFormat RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose: 
    Notes:   
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cValue AS CHARACTER NO-UNDO.
  {get DisplayFormat cValue}.
  RETURN cValue.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getFieldLabel) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getFieldLabel Procedure 
FUNCTION getFieldLabel RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose: 
    Notes:   
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cValue AS CHARACTER NO-UNDO.
  {get FieldLabel cValue}.
  RETURN cValue.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getFieldToolTip) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getFieldToolTip Procedure 
FUNCTION getFieldToolTip RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose: 
    Notes:   
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cValue AS CHARACTER NO-UNDO.
  {get FieldToolTip cValue}.
  RETURN cValue.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getKeyDataType) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getKeyDataType Procedure 
FUNCTION getKeyDataType RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose: 
    Notes:   
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cValue AS CHARACTER NO-UNDO.
  {get KeyDataType cValue}.
  RETURN cValue.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getKeyFormat) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getKeyFormat Procedure 
FUNCTION getKeyFormat RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose: 
    Notes:   
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cValue AS CHARACTER NO-UNDO.
  {get KeyFormat cValue}.
  RETURN cValue.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getLabel) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getLabel Procedure 
FUNCTION getLabel RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose: Get the Label to use when creating the widget.     
    Notes: The underlying Label property implemented in the Smart class is 
           currently not used, but is expected to replace the redundant 
           FieldLabel in a future releasa. 
 -----------------------------------------------------------------------------*/
  DEFINE VARIABLE cLabel AS CHARACTER  NO-UNDO.
  {get FieldLabel cLabel}.

  RETURN cLabel.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getLabelHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getLabelHandle Procedure 
FUNCTION getLabelHandle RETURNS HANDLE
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose: 
    Notes:   
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hValue AS HANDLE NO-UNDO.
  {get LabelHandle hValue}.
  RETURN hValue.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getManagerHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getManagerHandle Procedure 
FUNCTION getManagerHandle RETURNS HANDLE
  ( INPUT pcManagerName AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
DEFINE VARIABLE lICFRunning AS LOGICAL    NO-UNDO.

  IF pcManagerName = "SDFCacheManager":U THEN
    IF glUseNewAPI THEN
      RETURN THIS-PROCEDURE.

  /* otherwise.. */
  lICFRunning = DYNAMIC-FUNCTION("isICFRunning":U IN TARGET-PROCEDURE) = YES NO-ERROR.
  IF lICFRunning THEN
    RETURN SUPER(pcManagerName).
  ELSE
    RETURN ?.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getParentField) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getParentField Procedure 
FUNCTION getParentField RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose: 
    Notes:   
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cValue AS CHARACTER NO-UNDO.
  
  &scoped-define xpParentField
  {get ParentField cValue}.
  &undefine xpParentField
  
  RETURN cValue.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getParentFilterQuery) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getParentFilterQuery Procedure 
FUNCTION getParentFilterQuery RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose: 
    Notes:   
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cValue AS CHARACTER NO-UNDO.
  
  &scoped-define xpParentFilterQuery  
  {get ParentFilterQuery cValue}.
  &undefine xpParentFilterQuery
  
  RETURN cValue.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getPhysicalTableNames) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getPhysicalTableNames Procedure 
FUNCTION getPhysicalTableNames RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose: 
    Notes:   
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cValue AS CHARACTER NO-UNDO.

 &SCOPED-DEFINE xpPhysicalTableNames
  {get PhysicalTableNames cValue}.
 &UNDEFINE xpPhysicalTableNames
 
  RETURN cValue.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getQueryBuilderJoinCode) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getQueryBuilderJoinCode Procedure 
FUNCTION getQueryBuilderJoinCode RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  
  DEFINE VARIABLE cValue AS CHARACTER NO-UNDO.
  {get QueryBuilderJoinCode cValue}.
  RETURN cValue.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getQueryBuilderOptionList) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getQueryBuilderOptionList Procedure 
FUNCTION getQueryBuilderOptionList RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  
  DEFINE VARIABLE cValue AS CHARACTER NO-UNDO.
  {get QueryBuilderOptionList cValue}.
  RETURN cValue.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getQueryBuilderOrderList) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getQueryBuilderOrderList Procedure 
FUNCTION getQueryBuilderOrderList RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  
  DEFINE VARIABLE cValue AS CHARACTER NO-UNDO.
  {get QueryBuilderOrderList cValue}.
  RETURN cValue.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getQueryBuilderTableOptionList) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getQueryBuilderTableOptionList Procedure 
FUNCTION getQueryBuilderTableOptionList RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  
  DEFINE VARIABLE cValue AS CHARACTER NO-UNDO.
  {get QueryBuilderTableOptionList cValue}.
  RETURN cValue.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getQueryBuilderTuneOptions) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getQueryBuilderTuneOptions Procedure 
FUNCTION getQueryBuilderTuneOptions RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  
  DEFINE VARIABLE cValue AS CHARACTER NO-UNDO.
  {get QueryBuilderTuneOptions cValue}.
  RETURN cValue.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getQueryBuilderWhereClauses) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getQueryBuilderWhereClauses Procedure 
FUNCTION getQueryBuilderWhereClauses RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  
  DEFINE VARIABLE cValue AS CHARACTER NO-UNDO.
  {get QueryBuilderWhereClauses cValue}.
  RETURN cValue.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getQueryString) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getQueryString Procedure 
FUNCTION getQueryString RETURNS CHAR
  (   ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  FIND ttlookup WHERE hWidget = TARGET-PROCEDURE NO-ERROR.
  IF AVAIL ttlookup THEN
    RETURN ttLookup.cForEach.
  ELSE DO:
    FIND ttDcombo WHERE ttDcombo.hWidget = TARGET-PROCEDURE NO-ERROR.
    IF AVAIL ttDcombo THEN
      RETURN ttDcombo.cForEach.
  END.

  RETURN ?.    

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getQueryTables) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getQueryTables Procedure 
FUNCTION getQueryTables RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose: 
    Notes:   
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cValue AS CHARACTER NO-UNDO.
  
  &scoped-define xpQueryTables
  {get QueryTables cValue}.
  &Undefine xpQueryTables
  
  RETURN cValue.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getSDFFileName) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getSDFFileName Procedure 
FUNCTION getSDFFileName RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose: 
    Notes:   
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cValue AS CHARACTER NO-UNDO.
  {get SDFFileName cValue}.
  RETURN cValue.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getSDFTemplate) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getSDFTemplate Procedure 
FUNCTION getSDFTemplate RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose: 
    Notes:   
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cValue AS CHARACTER NO-UNDO.
  {get SDFTemplate cValue}.
  RETURN cValue.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getTempTables) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getTempTables Procedure 
FUNCTION getTempTables RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose: 
    Notes:   
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cValue AS CHARACTER NO-UNDO.
  
  &scoped-define xpTempTables
  {get TempTables cValue}.
  &undefine xpTempTables
  
  RETURN cValue.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getUseCache) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getUseCache Procedure 
FUNCTION getUseCache RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose: 
    Notes:   
------------------------------------------------------------------------------*/
  DEFINE VARIABLE lValue AS LOGICAL NO-UNDO.
  
  &scoped-define xpUseCache
  {get UseCache lValue}.
  &undefine xpUseCache
  
  RETURN lValue.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-insertExpression) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION insertExpression Procedure 
FUNCTION insertExpression RETURNS CHARACTER PRIVATE
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

&IF DEFINED(EXCLUDE-newQueryString) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION newQueryString Procedure 
FUNCTION newQueryString RETURNS CHARACTER
  (pcColumns     AS CHARACTER,   
   pcValues      AS CHARACTER,    
   pcDataTypes   AS CHARACTER,    
   pcOperators   AS CHARACTER,
   pcQueryString AS CHARACTER,
   pcAndOr       AS CHARACTER):
/*------------------------------------------------------------------------------   
   Purpose: Returns a new query string to the passed query. 
            The tables in the passed query must match getQueryTables().  
            Adds column/value pairs to the corresponding buffer's where-clause. 
            Each buffer's expression will always be embedded in parenthesis.
   Parameters: 
     pcColumns   - Column names (Comma separated) as table.fieldname                  

     pcValues    - corresponding Values (CHR(1) separated)
     pcDataTypes - corresponding data types (comma seperated)
     pcOperators - Operator - one for all columns
                              - blank - defaults to (EQ)  
                              - Use slash to define alternative string operator
                                EQ/BEGINS etc..
                            - comma separated for each column/value
     pcQueryString - A complete querystring matching the queries tables.
                     MUST be qualifed correctly.
                     ? - existing query BaseQueryString plus parent filter values
                         and filter sets
                     ?  Old API - base query 
                      
     pcAndOr       - AND or OR decides how the new expression is appended to 
                     the passed query (for each buffer!).                                               
   Notes:  This was taken from query.p but changed for lookups to work without an
           SDO.
           
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

  {get QueryTables cBufferList}.    

  /* If unkown value is passed used the existing query string */
  IF pcQueryString = ? THEN
  DO:
    /* The new API's existing query is the BaseQueryString plus parent filter 
       values and filter sets, which buildQuery will return. 
       (The old api added filtersets in the cache manager or in lookupqp.p. 
        The old cache manager also added parent values for the combo, while 
        the old lookup added this in getLookupQuery, assignNewValue or the
        popup browse etc..)*/  
    IF glUseNewAPI THEN
      pcQueryString = {fn buildQuery}.
    ELSE
      {get BaseQueryString pcQueryString}.      
  END. /* pcQueryString = ? */

  ASSIGN pcQueryString = REPLACE(pcQueryString,CHR(10)," ":U)
         pcQueryString = REPLACE(pcQueryString,CHR(12)," ":U)
         pcQueryString = REPLACE(pcQueryString,CHR(13)," ":U).

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

      /* Unqualified fields will use the first buffer in the query */
      IF INDEX(cColumn,".":U) = 0 THEN       
        cColumn = cBuffer + ".":U + cColumn.

      /* Wrong buffer? */
      IF NOT (cColumn BEGINS cBuffer + ".":U) THEN NEXT ColumnLoop.

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
        cDataType   = ENTRY(iColumn,pcDataTypes).

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
        pcQueryString = DYNAMIC-FUNCTION("newWhereClause":U IN TARGET-PROCEDURE, INPUT cBuffer, INPUT cBufWhere, INPUT pcQueryString, INPUT pcAndOr).
  END. /* do iBuffer = 1 to hQuery:num-buffers */
  RETURN pcQueryString.
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

&IF DEFINED(EXCLUDE-parentJoinTables) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION parentJoinTables Procedure 
FUNCTION parentJoinTables RETURNS CHARACTER
  ( pcParentFilterQuery AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose: Returns a comma separated list of the tables that corresponds to the 
           passed ParentFilterQuery. 
    Notes: This is implemented to separate out old subclass difference from 
           buildQuery. The dyncombo class joins to the first table while the 
           dynlookup joins to the last in the case where the query only has one 
           entry and there's more than one table in the query.
------------------------------------------------------------------------------*/
 DEFINE VARIABLE cQueryTables AS CHARACTER  NO-UNDO.
 
 {get QueryTables cQueryTables}.
 IF INDEX(pcParentFilterQuery,"|":U) = 0 THEN 
   RETURN ENTRY(NUM-ENTRIES(cQueryTables),cQueryTables).  
 ELSE 
   RETURN cQueryTables.    

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-returnBuffer) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION returnBuffer Procedure 
FUNCTION returnBuffer RETURNS HANDLE
  (INPUT pcObjectType AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  IF pcObjectType = "Combo":U THEN
  DO:
    FIND FIRST ttDCombo WHERE ttDcombo.hWidget = TARGET-PROCEDURE NO-ERROR.
    RETURN BUFFER ttDCombo:HANDLE.
  END.
  ELSE IF pcObjectType = "Lookup":U THEN
  DO:
    FIND FIRST ttLookup WHERE ttLookup.hWidget = TARGET-PROCEDURE NO-ERROR.
    RETURN BUFFER ttLookup:HANDLE.
  END.
  ELSE RETURN ?.   /* unknown object type */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-returnTableIOType) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION returnTableIOType Procedure 
FUNCTION returnTableIOType RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hViewerHandle   AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hTableIOSource  AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cTableIOSource  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cTableIOType    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cuibMode        AS CHARACTER  NO-UNDO.

  {get uibMODE cUIBmode}.

  IF cuibMode BEGINS "DESIGN":U THEN 
    RETURN "":U. 

  {get ContainerSource hViewerHandle}.
  
  IF VALID-HANDLE(hViewerHandle) THEN
    {get TableIOSource cTableIOSource hViewerHandle}.
  
  hTableIOSource = WIDGET-HANDLE(ENTRY(1,cTableIOSource)).

  IF VALID-HANDLE(hTableIOSource) THEN
    cTableIOType = DYNAMIC-FUNCTION("getTableIOType":U IN hTableIOSource).

  RETURN cTableIOType.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setBaseQueryString) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setBaseQueryString Procedure 
FUNCTION setBaseQueryString RETURNS LOGICAL
  ( pcValue AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose: 
Parameters:     
    Notes:   
------------------------------------------------------------------------------*/
  &SCOPED-DEFINE xpBaseQueryString
  {set BaseQueryString pcValue}.
  &UNDEFINE xpBaseQueryString
  
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setDataSourceName) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setDataSourceName Procedure 
FUNCTION setDataSourceName RETURNS LOGICAL
  ( pcValue AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose: Sets the DataSourceName 
Parameters:     
    Notes:   
------------------------------------------------------------------------------*/
  {set DataSourceName pcValue}.
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setDisplayDataType) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setDisplayDataType Procedure 
FUNCTION setDisplayDataType RETURNS LOGICAL
  ( pcValue AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose: 
Parameters:     
    Notes:   
------------------------------------------------------------------------------*/
  {set DisplayDataType pcValue}.
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setDisplayedField) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setDisplayedField Procedure 
FUNCTION setDisplayedField RETURNS LOGICAL
  ( pcDisplayedField AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose: Stores the name of the field to display in the selection
Parameters: INPUT pcDisplayedField - fieldname    
    Notes:   
------------------------------------------------------------------------------*/
  &SCOPED-DEFINE xpDisplayedField
  {set DisplayedField pcDisplayedField}.
  &UNDEFINE xpDisplayedField
  
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setDisplayFormat) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setDisplayFormat Procedure 
FUNCTION setDisplayFormat RETURNS LOGICAL
  ( pcValue AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose: 
Parameters:     
    Notes:   
------------------------------------------------------------------------------*/
  {set DisplayFormat pcValue}.
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setFieldHidden) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setFieldHidden Procedure 
FUNCTION setFieldHidden RETURNS LOGICAL
  ( INPUT plHide AS LOGICAL ) :
/*------------------------------------------------------------------------------
  Purpose:  Hide or view a lookup field
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hLookup   AS HANDLE NO-UNDO.
  DEFINE VARIABLE hButton   AS HANDLE NO-UNDO.
  DEFINE VARIABLE hLabel    AS HANDLE NO-UNDO.
  DEFINE VARIABLE hFrame    AS HANDLE NO-UNDO.
  
  &SCOPED-DEFINE xp-assign
  {get LookupHandle hLookup}
  {get ContainerHandle hFrame}.
  &UNDEFINE xp-assign
  
  IF VALID-HANDLE(hLookup) THEN
  DO:
   &SCOPED-DEFINE xp-assign
   {get ButtonHandle hButton}
   {get LabelHandle hLabel}.
   &UNDEFINE xp-assign
  
   ASSIGN
     hButton:HIDDEN   = plHide
     hLookup:HIDDEN   = plHide
     hLabel:HIDDEN    = plHide
     hLookup:TAB-STOP = plHide = FALSE
     hFrame:HIDDEN    = plHide. 
  END.

  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setFieldLabel) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setFieldLabel Procedure 
FUNCTION setFieldLabel RETURNS LOGICAL
  ( pcValue AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose: 
Parameters:     
    Notes:   
------------------------------------------------------------------------------*/

  {set FieldLabel pcValue}.
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setFieldToolTip) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setFieldToolTip Procedure 
FUNCTION setFieldToolTip RETURNS LOGICAL
  ( pcValue AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose: 
Parameters:     
    Notes:   
------------------------------------------------------------------------------*/
  {set FieldToolTip pcValue}.
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setKeyDataType) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setKeyDataType Procedure 
FUNCTION setKeyDataType RETURNS LOGICAL
  ( pcValue AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose: 
Parameters:     
    Notes:   
------------------------------------------------------------------------------*/
  &SCOPED-DEFINE xpKeyDataType
  {set KeyDataType pcValue}.
  &UNDEFINE xpKeyDataType
  
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF


&IF DEFINED(EXCLUDE-setKeyFormat) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setKeyFormat Procedure 
FUNCTION setKeyFormat RETURNS LOGICAL
  ( pcValue AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose: 
Parameters:     
    Notes:   
------------------------------------------------------------------------------*/
  {set KeyFormat pcValue}.
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setLabel) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setLabel Procedure 
FUNCTION setLabel RETURNS LOGICAL
  ( pcLabel AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose: Set the Label  
Parameter: pcLabel - The label to use when creating the widget.     
    Notes: The underlying Label property implemented in the Smart class is 
           currently not used, but is expected to replace the redundant 
           FieldLabel in a future releasa. 
 -----------------------------------------------------------------------------*/
  {set FieldLabel pcLabel}.

  RETURN TRUE. 

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setLabelHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setLabelHandle Procedure 
FUNCTION setLabelHandle RETURNS LOGICAL
  ( phValue AS HANDLE ) :
/*------------------------------------------------------------------------------
  Purpose: 
Parameters:     
    Notes:   
------------------------------------------------------------------------------*/
  {set LabelHandle phValue}.
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setParentField) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setParentField Procedure 
FUNCTION setParentField RETURNS LOGICAL
  ( pcValue AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose: Sets the Parent field name of this lookup's parent dependant object
Parameters:     
    Notes:   
------------------------------------------------------------------------------*/
  &SCOPED-DEFINE xpParentField
  {set ParentField pcValue}.
  &UNDEFINE xpParentField
  
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setParentFilterQuery) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setParentFilterQuery Procedure 
FUNCTION setParentFilterQuery RETURNS LOGICAL
  ( pcValue AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose: Sets the Parent object's foreign fields
Parameters:     
    Notes:   
------------------------------------------------------------------------------*/
  &SCOPED-DEFINE xpParentFilterQuery
  {set ParentFilterQuery pcValue}.
  &UNDEFINE xpParentFilterQuery
  
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setPhysicalTableNames) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setPhysicalTableNames Procedure 
FUNCTION setPhysicalTableNames RETURNS LOGICAL
  ( pcValue AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose: Sets the actual DB Tables names of buffers defined for the query
Parameters:     
    Notes:   
------------------------------------------------------------------------------*/
 &SCOPED-DEFINE xpPhysicalTableNames
  {set PhysicalTableNames pcValue}.
 &UNDEFINE xpPhysicalTableNames
 
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setQueryBuilderJoinCode) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setQueryBuilderJoinCode Procedure 
FUNCTION setQueryBuilderJoinCode RETURNS LOGICAL
  ( pcValue AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  
  {set QueryBuilderJoinCode pcValue}.
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setQueryBuilderOptionList) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setQueryBuilderOptionList Procedure 
FUNCTION setQueryBuilderOptionList RETURNS LOGICAL
  ( pcValue AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  {set QueryBuilderOptionList pcValue}.
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setQueryBuilderOrderList) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setQueryBuilderOrderList Procedure 
FUNCTION setQueryBuilderOrderList RETURNS LOGICAL
  ( pcValue AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  {set QueryBuilderOrderList pcValue}.
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setQueryBuilderTableOptionList) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setQueryBuilderTableOptionList Procedure 
FUNCTION setQueryBuilderTableOptionList RETURNS LOGICAL
  ( pcValue AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  {set QueryBuilderTableOptionList pcValue}.
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setQueryBuilderTuneOptions) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setQueryBuilderTuneOptions Procedure 
FUNCTION setQueryBuilderTuneOptions RETURNS LOGICAL
  ( pcValue AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  {set QueryBuilderTuneOptions pcValue}.
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setQueryBuilderWhereClauses) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setQueryBuilderWhereClauses Procedure 
FUNCTION setQueryBuilderWhereClauses RETURNS LOGICAL
  ( pcValue AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  {set QueryBuilderWhereClauses pcValue}.
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setQueryString) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setQueryString Procedure 
FUNCTION setQueryString RETURNS LOGICAL
  ( pcQuery AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  
  FIND ttlookup WHERE hWidget = TARGET-PROCEDURE NO-ERROR.
  IF AVAIL ttlookup THEN
  DO:
    IF ttLookup.lRefreshQuery = FALSE AND ttLookup.cForEach <> pcQuery THEN
       ttLookup.lRefreshQuery = TRUE.
    ttLookup.cForEach = pcQuery.
    RETURN TRUE.
  END.
  ELSE DO:
    FIND ttDcombo WHERE ttDcombo.hWidget = TARGET-PROCEDURE NO-ERROR.
    IF AVAIL ttDcombo THEN
    DO:
      IF ttDcombo.lRefreshQuery = FALSE AND ttDcombo.cForEach <> pcQuery THEN
        ttDcombo.lRefreshQuery = TRUE.
      ttDcombo.cForEach = pcQuery.
      RETURN TRUE.
    END.
  END.

  RETURN FALSE.    

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setQueryTables) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setQueryTables Procedure 
FUNCTION setQueryTables RETURNS LOGICAL
  ( pcValue AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose: 
Parameters:     
    Notes:   
------------------------------------------------------------------------------*/
 &SCOPED-DEFINE xpQueryTables
 {set QueryTables pcValue}.
 &UNDEFINE xpQueryTables
 
 RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setSDFFileName) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setSDFFileName Procedure 
FUNCTION setSDFFileName RETURNS LOGICAL
  ( pcValue AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose: Sets the SmartDataField file name 
Parameters:     
    Notes:   
------------------------------------------------------------------------------*/
  {set SDFFileName pcValue}.
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setSDFTemplate) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setSDFTemplate Procedure 
FUNCTION setSDFTemplate RETURNS LOGICAL
  ( pcValue AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose: Sets the SmartDataField template file name 
Parameters:     
    Notes:   
------------------------------------------------------------------------------*/
  {set SDFTemplate pcValue}.
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setTempTables) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setTempTables Procedure 
FUNCTION setTempTables RETURNS LOGICAL
  ( pcValue AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose: Sets the PLIP names of Temp Tables defined for the query
Parameters:     
    Notes:   
------------------------------------------------------------------------------*/
  &SCOPED-DEFINE xpTempTables
  {set TempTables pcValue}.
  &UNDEFINE xpTempTables
    
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setUseCache) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setUseCache Procedure 
FUNCTION setUseCache RETURNS LOGICAL
  ( plValue AS LOGICAL ) :
/*------------------------------------------------------------------------------
  Purpose: 
Parameters:     
    Notes:   
------------------------------------------------------------------------------*/
  &SCOPED-DEFINE xpUseCache
  {set UseCache plValue}.
  &UNDEFINE xpUseCache
  
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

