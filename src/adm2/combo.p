&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/***********************************************************************
* Copyright (C) 2005-2007 by Progress Software Corporation. All rights *
* reserved.  Prior versions of this work may contain portions          *
* contributed by participants of Possenet.                             *
*                                                                      *
***********************************************************************/
/*--------------------------------------------------------------------------
    File        : combo.p
    Purpose     : Super procedure for combo class.

    Syntax      : RUN start-super-proc("adm2/combo.p":U).

  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */


&SCOP ADMSuper combo.p

{src/adm2/ttlookup.i}
{src/adm2/ttdcombo.i}
{src/adm2/tttranslate.i}
  
  /* Custom exclude file */

  {src/adm2/custom/comboexclcustom.i}

/* glUsenewAPI is conditionally defined in smrtprop.i based on &admSUPER names
   and can be used in and below the main-block in this super */

DEFINE TEMP-TABLE ttDComboCopy  NO-UNDO LIKE ttDcombo.             
DEFINE TEMP-TABLE ttLookupEmpty NO-UNDO LIKE ttLookup.

&SCOPED-DEFINE setprop ~
    DEFINE VARIABLE hComboBuffer AS HANDLE NO-UNDO. ~
    DEFINE VARIABLE hComboCont   AS HANDLE NO-UNDO. ~
    ~{get ContainerSource hComboCont~}. ~
    hComboBuffer = DYNAMIC-FUNCT('returnComboBuffer' IN TARGET-PROCEDURE). ~
    IF NOT hComboBuffer:AVAILABLE THEN ~
    DO: ~
      hComboBuffer:BUFFER-CREATE(). ~
      hComboBuffer:BUFFER-FIELD('hWidget':U):BUFFER-VALUE  = TARGET-PROCEDURE. ~
      hComboBuffer:BUFFER-FIELD('hViewer':U):BUFFER-VALUE  = hComboCont. ~
    END. ~
    hComboBuffer:BUFFER-FIELD('lRefreshQuery':U):BUFFER-VALUE  = TRUE. ~
    hComboBuffer:BUFFER-FIELD('~{&ttfield~}':U):BUFFER-VALUE = ~{&propvalue~}. ~
    &UNDEFINE ttfield ~
    &UNDEFINE propvalue

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-buildCombo) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD buildCombo Procedure 
FUNCTION buildCombo RETURNS LOGICAL
  (pcMode AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-buildList) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD buildList Procedure 
FUNCTION buildList RETURNS CHARACTER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-createDataSource) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD createDataSource Procedure 
FUNCTION createDataSource RETURNS HANDLE
  ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-createLabel) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD createLabel Procedure 
FUNCTION createLabel RETURNS HANDLE
  (pcLabel AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-destroyCombo) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD destroyCombo Procedure 
FUNCTION destroyCombo RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fixKeyDataType) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fixKeyDataType Procedure 
FUNCTION fixKeyDataType RETURNS CHARACTER
  ( pcKeyFormat AS CHARACTER,
    pcKeyDataType AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getAltValueOnAdd) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getAltValueOnAdd Procedure 
FUNCTION getAltValueOnAdd RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getAltValueOnRebuild) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getAltValueOnRebuild Procedure 
FUNCTION getAltValueOnRebuild RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getBuildSequence) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getBuildSequence Procedure 
FUNCTION getBuildSequence RETURNS INTEGER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getComboDelimiter) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getComboDelimiter Procedure 
FUNCTION getComboDelimiter RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getComboFlag) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getComboFlag Procedure 
FUNCTION getComboFlag RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getComboHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getComboHandle Procedure 
FUNCTION getComboHandle RETURNS HANDLE
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getCurrentDescValue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getCurrentDescValue Procedure 
FUNCTION getCurrentDescValue RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getCurrentKeyValue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getCurrentKeyValue Procedure 
FUNCTION getCurrentKeyValue RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDataValue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getDataValue Procedure 
FUNCTION getDataValue RETURNS CHARACTER
  ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDescSubstitute) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getDescSubstitute Procedure 
FUNCTION getDescSubstitute RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getFieldHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getFieldHandle Procedure 
FUNCTION getFieldHandle RETURNS HANDLE
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getFlagValue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getFlagValue Procedure 
FUNCTION getFlagValue RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getInnerLines) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getInnerLines Procedure 
FUNCTION getInnerLines RETURNS INTEGER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getListItemPairs) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getListItemPairs Procedure 
FUNCTION getListItemPairs RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getNumItems) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getNumItems Procedure 
FUNCTION getNumItems RETURNS INTEGER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getRefreshList) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getRefreshList Procedure 
FUNCTION getRefreshList RETURNS CHARACTER
  ( INPUT pcParentCombo AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getSecured) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getSecured Procedure 
FUNCTION getSecured RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getSort) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getSort Procedure 
FUNCTION getSort RETURNS LOGICAL
  ( )  FORWARD.

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

&IF DEFINED(EXCLUDE-returnComboBuffer) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD returnComboBuffer Procedure 
FUNCTION returnComboBuffer RETURNS HANDLE
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setAltValueOnAdd) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setAltValueOnAdd Procedure 
FUNCTION setAltValueOnAdd RETURNS LOGICAL
  ( pcAltValue AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setAltValueOnRebuild) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setAltValueOnRebuild Procedure 
FUNCTION setAltValueOnRebuild RETURNS LOGICAL
  ( pcAltValue AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setBuildSequence) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setBuildSequence Procedure 
FUNCTION setBuildSequence RETURNS LOGICAL
  ( piSequence AS INTEGER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setComboDelimiter) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setComboDelimiter Procedure 
FUNCTION setComboDelimiter RETURNS LOGICAL
  ( pcValue AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setComboFlag) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setComboFlag Procedure 
FUNCTION setComboFlag RETURNS LOGICAL
  ( pcValue AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setComboHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setComboHandle Procedure 
FUNCTION setComboHandle RETURNS LOGICAL
  ( phValue AS HANDLE )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setCurrentDescValue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setCurrentDescValue Procedure 
FUNCTION setCurrentDescValue RETURNS LOGICAL
  ( pcValue AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setCurrentKeyValue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setCurrentKeyValue Procedure 
FUNCTION setCurrentKeyValue RETURNS LOGICAL
  ( pcValue AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setDataValue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setDataValue Procedure 
FUNCTION setDataValue RETURNS LOGICAL
  (pcValue AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setDescSubstitute) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setDescSubstitute Procedure 
FUNCTION setDescSubstitute RETURNS LOGICAL
  ( pcValue AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setFlagValue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setFlagValue Procedure 
FUNCTION setFlagValue RETURNS LOGICAL
  ( pcValue AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setInnerLines) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setInnerLines Procedure 
FUNCTION setInnerLines RETURNS LOGICAL
  ( piInnerLines AS INTEGER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setListItemPairs) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setListItemPairs Procedure 
FUNCTION setListItemPairs RETURNS LOGICAL
  ( pcValue AS CHARACTER )  FORWARD.

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

&IF DEFINED(EXCLUDE-setQueryTables) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setQueryTables Procedure 
FUNCTION setQueryTables RETURNS LOGICAL
  ( pcValue AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setSecured) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setSecured Procedure 
FUNCTION setSecured RETURNS LOGICAL
  ( INPUT plFieldIsSecured AS LOGICAL )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setSort) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setSort Procedure 
FUNCTION setSort RETURNS LOGICAL
  ( pilSort AS LOGICAL )  FORWARD.

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
         HEIGHT             = 23.38
         WIDTH              = 55.8.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB Procedure 
/* ************************* Included-Libraries *********************** */

{src/adm2/combprop.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


 
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

  
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-anyKey) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE anyKey Procedure 
PROCEDURE anyKey :
/*------------------------------------------------------------------------------
  Purpose:     We could trap a keypress in here and scroll to the first occurance
               of an entry that begins with the key entered.
  Parameters:  <none>
  Notes:       Use LAST-EVENT:FUNCTION for testing keypress.
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-destroyObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE destroyObject Procedure 
PROCEDURE destroyObject :
/*------------------------------------------------------------------------------
  Purpose:   local overide of destroyObject; delete created widgets
  Parameters: <NONE>
  Notes:     
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cFieldName              AS CHARACTER  NO-UNDO.

  {get FieldName cFieldName}.
  
  FIND FIRST ttDCombo
       WHERE ttDCombo.hWidget = TARGET-PROCEDURE
         AND ttDCombo.cWidgetName = cFieldName
       NO-ERROR.
  IF AVAILABLE ttDCombo THEN 
    DELETE ttDCombo.
  ELSE
    ASSIGN ERROR-STATUS:ERROR = NO.
  
  {fn destroyCombo}.
  
  RUN SUPER.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-disableField) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disableField Procedure 
PROCEDURE disableField :
/*------------------------------------------------------------------------------
  Purpose:   disable Combo Field
  Parameters: <NONE>
  Notes:  The SmartDataViewer container will call this procedure if a widget of 
          type PROCEDURE is encountered in disableFields    
------------------------------------------------------------------------------*/
 DEFINE VARIABLE hCombo           AS HANDLE    NO-UNDO.
 DEFINE VARIABLE hBrowseContainer AS HANDLE    NO-UNDO.

 {get ComboHandle hCombo}.
 IF VALID-HANDLE(hCombo) THEN
 DO:
   ASSIGN
     hCombo:SENSITIVE = FALSE
     hCombo:TAB-STOP   = TRUE.   
 END.

 {set FieldEnabled FALSE}.

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

&IF DEFINED(EXCLUDE-displayCombo) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE displayCombo Procedure 
PROCEDURE displayCombo :
/*------------------------------------------------------------------------------
  Purpose:     This is published from the smartviewer containing the smartdatafield 
               to populate the combo with the evaluated query data - if the
               query was succesful.
               It is published from displayfields in the viewer.
               The queries were initially built in getComboQuery. 
  Parameters:  input combo temp-table
  Notes:       DEPRECATED - Use displayField instead.
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER TABLE FOR ttDCombo.

  /* this section is included to support calls from old custom code that uses the New API */
  IF glUseNewAPI THEN
  DO:
    RUN copyToComboTable IN TARGET-PROCEDURE (INPUT TABLE ttDCombo).
    EMPTY TEMP-TABLE ttDCombo.
    RUN displayField IN TARGET-PROCEDURE.
  END.
  ELSE 
    RUN oldDisplayCombo IN TARGET-PROCEDURE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-displayField) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE displayField Procedure 
PROCEDURE displayField :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE hCombo            AS HANDLE     NO-UNDO.
DEFINE VARIABLE cFieldName        AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cValue            AS CHARACTER  NO-UNDO.
DEFINE VARIABLE hViewer           AS HANDLE     NO-UNDO.
DEFINE VARIABLE lFieldIsSecured   AS LOGICAL    NO-UNDO.
DEFINE VARIABLE lDisplayField     AS LOGICAL    NO-UNDO.
DEFINE VARIABLE hViewerDataSource AS HANDLE     NO-UNDO.
DEFINE VARIABLE hComboBuffer      AS HANDLE     NO-UNDO.
DEFINE VARIABLE hDataSource       AS HANDLE     NO-UNDO.
DEFINE VARIABLE lValid            AS LOGICAL    NO-UNDO.
DEFINE VARIABLE cNewRecord        AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cAltValue         AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cObjectType       AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cDataSourceName   AS CHARACTER  NO-UNDO.

&SCOPED-DEFINE xp-assign
{get ComboHandle hCombo}
{get DisplayField lDisplayField}
{get Secured lFieldIsSecured}
{get ContainerSource hViewer}
{get FieldName cFieldName}
{get DataSource hDataSource}
.
&UNDEFINE xp-assign

IF NOT lFieldIsSecured AND lDisplayField AND VALID-HANDLE(hViewer) THEN 
DO:
  /* If the combo has its own datasource the list is built initialize 
     and/or queryOpened */  
  IF NOT VALID-HANDLE(hDataSource) THEN
    {fnarg buildCombo ''}.

  {get NewRecord cNewRecord hViewer}.
  {get DataSource hViewerDataSource hViewer}.
  IF VALID-HANDLE(hViewerDataSource) THEN
  DO:
    {get ObjectType cObjectType hViewerDataSource}.      
    IF cObjectType = 'SmartBusinessObject':U THEN
    DO: 
      /* if this viewer is constructed from an SBO the fields are already 
         qualified */
      IF NOT INDEX(cFieldName, ".":U) > 0 THEN
      DO:
        /* There is only ONE datasourcename in a viewer that has been built 
           against an SDO */
        {get DataSourceNames cDataSourceName hViewer}.
        IF cDataSourceName > "":U THEN
          cFieldName = cDataSourceName + ".":U + cFieldName.
      END.
    END.
    cValue = {fnarg columnValue cFieldName hViewerDataSource}.
  END. /* valid viewer data source */
  ELSE DO:
    hComboBuffer = {fn returnComboBuffer}. 
    cValue = DYNAMIC-FUNCTION("formattedValue":U IN TARGET-PROCEDURE, hComboBuffer:BUFFER-FIELD('cCurrentKeyValue':U):BUFFER-VALUE).
  END.

  lValid = {set DataValue cValue}.
    
  /* If set failed in AddMode, check if an alternative value is specified */
  IF NOT lValid AND hCombo:NUM-ITEMS > 0 AND cNewRecord <> 'NO':U THEN
  DO:
    {get AltValueOnAdd cAltValue}.
    /* if altvalue is '<Clear>' then setDataValue has already taken care of this*/  
    IF cAltValue <> '<Clear>':U THEN
    DO:
      CASE cAltValue:
        WHEN '<First>':U THEN
          cValue = hCombo:ENTRY(1).
        WHEN '<Last>':U THEN
          cValue = hCombo:ENTRY(hCombo:NUM-ITEMS).
      END CASE.
      {set DataValue cValue}.
    END.
  END. /* New and NOT valid */
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-enableField) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enableField Procedure 
PROCEDURE enableField :
/*------------------------------------------------------------------------------
  Purpose:   enable Combo Field
  Parameters: <NONE>
  Notes:  The SmartDataViewer Container will call this procedure if a widget of 
          type PROCEDURE is encountered in enableFields    
------------------------------------------------------------------------------*/
 DEFINE VARIABLE hCombo          AS HANDLE     NO-UNDO.
 DEFINE VARIABLE hButton          AS HANDLE     NO-UNDO.

 {get ComboHandle hCombo}.
 IF VALID-HANDLE(hCombo) THEN
 DO:
   hCombo:SENSITIVE = TRUE.

   ASSIGN
     hCombo:TAB-STOP = TRUE.   
 END.

 {set FieldEnabled TRUE}.

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

&IF DEFINED(EXCLUDE-enterCombo) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enterCombo Procedure 
PROCEDURE enterCombo :
/*------------------------------------------------------------------------------
  Purpose:     Trigger fired on entry of combo field
  Parameters:  <none>
  Notes:       The purpose of this trigger is to store the current screen value
               of the displayed field in the combo so that where the 
               displayedfield is not equal to the keyfield (usually the case) then
               we can fire logic when the displayed field is changed in the leave
               trigger to see if the new value keyed in actually exists as a unique
               record, and if so, avoid having to use the combo.
------------------------------------------------------------------------------*/

  DEFINE VARIABLE hCombo              AS HANDLE       NO-UNDO.
  DEFINE VARIABLE hContainer          AS HANDLE       NO-UNDO.
  DEFINE VARIABLE cScreenValue        AS CHARACTER    NO-UNDO.

  &SCOPED-DEFINE xp-assign
  {get ComboHandle hCombo}
  {get containerSource hContainer}.
  &UNDEFINE xp-assign
  
  cScreenValue = ENTRY((hCombo:LOOKUP(hCombo:SCREEN-VALUE) * 2) - 1,hCombo:LIST-ITEM-PAIRS,hCombo:DELIMITER).
  {set DisplayValue cScreenValue}.

  PUBLISH "comboEntry":U FROM hContainer (INPUT hCombo:SCREEN-VALUE,   /* current combo key field value */
                                           INPUT TARGET-PROCEDURE      /* handle of combo */
                                          ).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getComboQuery) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getComboQuery Procedure 
PROCEDURE getComboQuery :
/*------------------------------------------------------------------------------
  Purpose:     This routine is published from the viewer and is used to pass the query
               required by this combo back to the viewer for building. Once built,
               the query will be returned into the procedure displayCombo.
  Parameters:  input-output combo temp table
  Notes:       This is designed to facilitate all combo queries being built with
               a single appserver hit.
               It is published from displayfields in the viewer.
               NOTE that this is not run at all in add mode.
------------------------------------------------------------------------------*/
DEFINE INPUT-OUTPUT PARAMETER TABLE FOR ttDCombo.

  DEFINE VARIABLE cFieldName              AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cKeyField               AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cKeyFormat              AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDisplayedField         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cKeyDataType            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDisplayDataType        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cQueryTables            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cQueryString            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDescSubstitute         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cKeyFieldValue          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cNewQuery               AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cParentField            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cParentFilterQuery      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cComboFlag              AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFlagValue              AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cComboDelimiter         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iBuildSequence          AS INTEGER    NO-UNDO.

  DEFINE VARIABLE hContainer              AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hDataSource             AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cPhysicalTableNames     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cTempTableNames         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lUseCache               AS LOGICAL    NO-UNDO.

  &SCOPED-DEFINE xp-assign
  {get FieldName cFieldName}
  {get KeyField cKeyField}
  {get KeyFormat cKeyFormat}
  {get DisplayedField cDisplayedField}
  {get KeyDataType cKeyDataType}
  {get DisplayDataType cDisplayDataType}
  {get BaseQueryString cQueryString}
  {get QueryTables cQueryTables}
  {get DataValue cKeyFieldValue}
  {get ParentField cParentField}
  {get ParentFilterQuery cParentFilterQuery}
  {get DescSubstitute cDescSubstitute}
  {get ComboFlag cComboFlag}
  {get ComboDelimiter cComboDelimiter}
  {get FlagValue cFlagValue}
  {get BuildSequence iBuildSequence}
  {get PhysicalTableNames cPhysicalTableNames}
  {get TempTables cTempTableNames}
  {get containerSource hContainer}.   /* viewer */
  {get UseCache lUseCache}.
  &UNDEFINE xp-assign
  
  IF VALID-HANDLE(hContainer) THEN
    hDataSource = DYNAMIC-FUNCTION('getDataSource':U IN hContainer) NO-ERROR.

  cKeyDataType = fixKeyDataType(cKeyFormat,cKeyDataType).
  {set KeyDataType cKeyDataType}.

  /* we must get the value of the external field from the SDO that is the 
     data source of the viewer - and then change the query for the combo
     to find the record where the keyfield is equal to this external field
     value
  */

  IF VALID-HANDLE(hDataSource) THEN
    cKeyFieldValue = IF NUM-ENTRIES(cFieldName,".":U) > 1 THEN
                        DYNAMIC-FUNCTION("ColumnValue":U IN hDataSource,ENTRY(2, cFieldName, ".":U))
                     ELSE
                        DYNAMIC-FUNCTION("ColumnValue":U IN hDataSource,cFieldName).
  IF (cKeyFieldValue = "":u OR cKeyFieldValue = ? OR cKeyFieldValue = "0":u) AND
     DYNAMIC-FUNCTION("getNewRecord":U IN hContainer) = "Add":U THEN
      {set DataValue ''}.
  ELSE
    /* reset saved keyfieldvalue */
    {set DataValue cKeyFieldValue}.

      /* Update query into temp-table */
    FIND FIRST ttDCombo
         WHERE ttDCombo.hWidget = TARGET-PROCEDURE
           AND ttDCombo.hViewer = hContainer
           AND ttDCombo.cWidgetName = cFieldName
         NO-ERROR.
    IF NOT AVAILABLE ttDCombo THEN CREATE ttDCombo.
    ASSIGN
      ttDCombo.hWidget             = TARGET-PROCEDURE
      ttDCombo.hViewer             = hContainer
      ttDCombo.cWidgetName         = cFieldName
      ttDCombo.cWidgetType         = cKeyDataType
      ttDCombo.cForEach            = cQueryString
      ttDCombo.cBufferList         = cQueryTables
      ttDCombo.cKeyFieldName       = cKeyField
      ttDCombo.cKeyFormat          = cKeyFormat
      ttDCombo.cDescFieldNames     = cDisplayedField
      ttDCombo.cDescSubstitute     = cDescSubstitute
      ttDCombo.cFlag               = cComboFlag
      ttDCombo.cListItemDelimiter  = cComboDelimiter
      ttDCombo.cCurrentKeyValue    = cKeyFieldValue
      ttDCombo.cFlagValue          = cFlagValue
      ttDCombo.cParentField        = cParentField
      ttDCombo.cParentFilterQuery  = cParentFilterQuery
      ttDCombo.iBuildSequence      = iBuildSequence
      ttDCombo.cPhysicalTableNames = cPhysicalTableNames
      ttDCombo.cTempTableNames     = cTempTableNames
      ttDCombo.lUseCache           = lUseCache.
  RETURN.

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

&IF DEFINED(EXCLUDE-initializeCombo) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeCombo Procedure 
PROCEDURE initializeCombo :
/*------------------------------------------------------------------------------
  Purpose:     Run as part of initializeObject to set up the combo
  Parameters:  <none>
  Notes:       Defaults keyfield to actual field if not defined.
               Defaults displayed field to keyfield if not defined.
               Assumes a data type of decimal for keyfield and character for
               displayed field if different.
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cDisplayedField       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cKeyField             AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cLABEL                AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cKeyFormat            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDisplayFormat        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cToolTip              AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cKeyDataType          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDisplayDataType      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hFrame                AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hContainer            AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hParentFrame          AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hCombo                AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cLookupImg            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hBtn                  AS HANDLE     NO-UNDO.
  DEFINE VARIABLE iRowsToBatch          AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cUIBMode              AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cComboDelimiter       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iInnerLines           AS INTEGER    NO-UNDO.
  DEFINE VARIABLE dComboWidth           AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE lLocalField           AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cTableIOType          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFieldName            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hComboBuffer          AS HANDLE     NO-UNDO.
  DEFINE VARIABLE lSort                 AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE hDataSource           AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cDataSourceName       AS CHARACTER  NO-UNDO.

  {get ContainerHandle hFrame}.

  hParentFrame = hFrame:FRAME.
  IF NOT VALID-HANDLE(hParentFrame) THEN 
    RETURN.

  {fn destroyCombo}. /* Get rid of existing widgets so we can recreate them */
  
  &SCOPED-DEFINE xp-assign
  {get DisplayedField cDisplayedField}
  {get KeyField cKeyField}
  {get FieldLabel cLabel}
  {get FieldToolTip cToolTip}
  {get KeyFormat cKeyFormat}
  {get KeyDataType cKeyDataType}
  {get DisplayFormat cDisplayFormat}
  {get DisplayDataType cDisplayDataType}
  {get UIBMode cUIBmode}
  {get ComboDelimiter cComboDelimiter}
  {get InnerLines iInnerLines}
  {get ContainerSource hContainer}
  {get Width dComboWidth}
  {get FieldName cFieldName} 
  {get Sort lSort}
  /* Check if SDF was dropped onto a Local Field #9417*/
  {get LocalField lLocalField}
  {get DataSource hDataSource}
  {get DataSourceName cDataSourceName}
   .
  &UNDEFINE xp-assign

  IF cComboDelimiter = '':U THEN
  DO:
    cComboDelimiter = CHR(1).
    {set ComboDelimiter cComboDelimiter}.
  END.

  IF VALID-HANDLE(hContainer) AND (cUIBMode BEGINS "DESIGN":U) = FALSE THEN
    DYNAMIC-FUNCTION("setEditable":U IN hContainer,TRUE) NO-ERROR.
  
  IF iInnerLines = ? OR iInnerLines = 0 THEN
    iInnerLines = 5.

  /* default to the fieldname if no keyfield 
     (This will give errors further down if the field does not exist) */
  IF cKeyField = "":U THEN
  DO:
    cKeyField = cFieldName.
    {set KeyField cKeyField}.
  END.

  /* default to the keyfield if no displayedfield */
  IF cDisplayedField = "":U OR cDisplayedField = ? THEN
  DO:
    cDisplayedField = cKeyField.
    {set DisplayedField cDisplayedField}.
  END.
  
  IF cDataSourceName > '':U AND NOT(VALID-HANDLE(hDataSource)) THEN
    hDataSource = {fn createDataSource}.

  /* if valid datasource then get field attributes from it */
  IF VALID-HANDLE(hDataSource) THEN
  DO:
    ASSIGN
      cKeyDataType     = {fnarg columnDataType cKeyField hDataSource}
      cKeyFormat       = {fnarg columnFormat cKeyField hDataSource}.
    IF cDisplayedField = cKeyField THEN
      ASSIGN
        cDisplayDataType = cKeyDataType
        cDisplayFormat   = cKeyFormat.
    ELSE
      ASSIGN
        cDisplayDataType = {fnarg columnDataType cDisplayedField hDataSource}
        cDisplayFormat   = {fnarg columnFormat cDisplayedField hDataSource}.

    &SCOPED-DEFINE xp-assign
    {set KeyDataType cKeyDataType}
    {set KeyFormat cKeyFormat}
    {set DisplayDataType cDisplayDataType}
    {set DisplayFormat cDisplayFormat}
    .
    &UNDEFINE xp-assign
  END.
  ELSE DO:
    cKeyDataType = fixKeyDataType(cKeyFormat,cKeyDataType).
     /* Assume a decimal data type if not defined for key field */
    IF cKeyDataType = "":U THEN 
    DO:
      IF cKeyFormat = "":U OR INDEX(cKeyFormat,".":U) > 0 THEN
         cKeyDataType = "DECIMAL":U.
      ELSE IF INDEX(cKeyFormat,"X(":U) > 0 THEN
        cKeyDataType = "CHARACTER":U.
    END.

    {set KeyDataType  cKeyDataType}.

    /* Default the format of the key field if not defined */
    IF cKeyFormat = "":U THEN
    CASE cKeyDataType:
      WHEN "decimal":U THEN ASSIGN cKeyFormat = "->>>>>>>>>>>>>>>>>9.999999999":U.
      WHEN "date":U THEN ASSIGN cKeyFormat = "99/99/9999":U.
      WHEN "datetime":U THEN ASSIGN cKeyFormat = "99/99/9999 HH:MM:SS.SSS":U.
      WHEN "datetime-tz":U THEN ASSIGN cKeyFormat = "99/99/9999 HH:MM:SS.SSS+HH:MM":U.
      WHEN "integer":U THEN ASSIGN cKeyFormat = ">>>>>>>9":U.
      OTHERWISE ASSIGN cKeyFormat = "x(256)":U.
    END CASE.
    {set KeyFormat  cKeyFormat}.

    /* default data type of display field to key field data type or character */
    IF cDisplayDataType = "":U THEN
      IF cKeyField = cDisplayedField THEN
        cDisplayDataType = cKeyDataType.
      ELSE
        cDisplayDataType = "character":U.

    {set DisplayDataType  cDisplayDataType}.

    /* Default the format of the display field if not defined */
    IF cDisplayFormat = "":U THEN
    CASE cDisplayDataType:
      WHEN "decimal":U THEN ASSIGN cDisplayFormat = "->>>>>>>>>>>>>>>>>9.999999999":U.
      WHEN "date":U THEN ASSIGN cDisplayFormat = "99/99/9999":U.
      WHEN "datetime":U THEN ASSIGN cDisplayFormat = "99/99/9999 HH:MM:SS.SSS":U.
      WHEN "datetime-tz":U THEN ASSIGN cDisplayFormat = "99/99/9999 HH:MM:SS.SSS+HH:MM":U.
      WHEN "integer":U OR WHEN "INT64":U THEN ASSIGN cDisplayFormat = ">>>>>>>9":U.
      OTHERWISE ASSIGN cDisplayFormat = "x(256)":U.
    END CASE.
    {set DisplayFormat  cDisplayFormat}.
  END.

  CREATE COMBO-BOX hCombo
    ASSIGN FRAME            = hFrame
           NAME             = "fiCombo" 
           SUBTYPE          = "DROP-DOWN-LIST":U 
           X                = 0
           Y                = 0
           INNER-LINES      = iInnerLines
           AUTO-COMPLETION  = TRUE       
           DELIMITER        = cComboDelimiter
           WIDTH-PIXELS     = hFrame:WIDTH-PIXELS
           SORT             = lSort            
           SENSITIVE        = (cUIBMode BEGINS "DESIGN":U) = FALSE
           TAB-STOP         = TRUE.

  IF DYNAMIC-FUNCTION('getUseWidgetID':U IN TARGET-PROCEDURE) THEN
      RUN assignWidgetID IN TARGET-PROCEDURE (INPUT hCombo, INPUT 2,
                                              INPUT ?,      INPUT ?).
  ASSIGN 
    hCombo:DATA-TYPE       = cKeyDataType 
    hCombo:FORMAT          = cKeyFormat
    hCombo:LIST-ITEM-PAIRS = cComboDelimiter
    hCombo:HIDDEN          = FALSE NO-ERROR.

  {set ComboHandle hCombo}.  
  ASSIGN hFrame:HEIGHT = hCombo:HEIGHT NO-ERROR.
  /* create a label if not blank */  
  IF cLabel NE "":U THEN
      {fnarg createLabel cLabel}.

  IF DYNAMIC-FUNCTION("getSessionParam":U IN THIS-PROCEDURE, INPUT "_debug_tools_on":U) = "YES":U THEN
     ON CTRL-ALT-SHIFT-Q OF hCombo
       PERSISTENT RUN showQuery IN TARGET-PROCEDURE.

  IF cUIBMode BEGINS "DESIGN":U THEN
  DO:
    ON END-MOVE OF hFrame 
      PERSISTENT RUN endMove      IN TARGET-PROCEDURE. 
  END.
  ELSE DO:    
    /* create an entry/leave trigger always, code is defined */
    ON ENTRY OF hCombo 
      PERSISTENT RUN enterCombo IN TARGET-PROCEDURE.
    ON LEAVE OF hCombo 
      PERSISTENT RUN leaveCombo IN TARGET-PROCEDURE.
    ON VALUE-CHANGED OF hCombo 
      PERSISTENT RUN valueChanged IN TARGET-PROCEDURE.
    /*ON ANY-KEY OF hCombo PERSISTENT RUN anyKey IN TARGET-PROCEDURE.*/

    hCombo:MOVE-TO-BOTTOM().
    hCombo:TOOLTIP = cToolTIP.

    IF VALID-HANDLE(hDataSource) THEN 
      hCombo:LIST-ITEM-PAIRS = {fn buildList}. 
    ELSE DO:
      hComboBuffer = {fn returnComboBuffer}.
      IF NOT hComboBuffer:AVAILABLE THEN 
      DO:
        hComboBuffer:BUFFER-CREATE().
        hComboBuffer:BUFFER-FIELD('hWidget':U):BUFFER-VALUE  = TARGET-PROCEDURE.
      END.   

      ASSIGN 
        hComboBuffer:BUFFER-FIELD('hViewer':U):BUFFER-VALUE             = hContainer
        hComboBuffer:BUFFER-FIELD('cWidgetName':U):BUFFER-VALUE         = cFieldName
        hComboBuffer:BUFFER-FIELD('cWidgetType':U):BUFFER-VALUE         = cKeyDataType
        hComboBuffer:BUFFER-FIELD('cKeyFieldName':U):BUFFER-VALUE       = cKeyField
        hComboBuffer:BUFFER-FIELD('cKeyFormat':U):BUFFER-VALUE          = cKeyFormat
        hComboBuffer:BUFFER-FIELD('cDescFieldNames':U):BUFFER-VALUE     = cDisplayedField
        hComboBuffer:BUFFER-FIELD('cListItemDelimiter':U):BUFFER-VALUE  = cComboDelimiter.  
    END.
  END.

  RUN disableField IN TARGET-PROCEDURE.
  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-leaveCombo) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE leaveCombo Procedure 
PROCEDURE leaveCombo :
/*------------------------------------------------------------------------------
  Purpose:     Trigger fired on leave of combo field
  Parameters:  <none>
  Notes:       The purpose of this trigger is to store the current screen value
               of the displayed field in the combo so that where the 
               displayedfield is not equal to the keyfield (usually the case) then
               we can fire logic when the displayed field is changed in the leave
               trigger to see if the new value keyed in actually exists as a unique
               record, and if so, avoid having to use the combo.
------------------------------------------------------------------------------*/

  DEFINE VARIABLE hCombo               AS HANDLE       NO-UNDO.
  DEFINE VARIABLE hContainer           AS HANDLE       NO-UNDO.

  &SCOPED-DEFINE xp-assign
  {get ComboHandle hCombo}
  {get containerSource hContainer}.
  &UNDEFINE xp-assign

  PUBLISH "comboLeave":U FROM hContainer (INPUT hCombo:SCREEN-VALUE,   /* current combo key field value */
                                          INPUT TARGET-PROCEDURE       /* handle of combo */
                                          ).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-oldDisplayCombo) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE oldDisplayCombo Procedure 
PROCEDURE oldDisplayCombo :
/*------------------------------------------------------------------------------
  Purpose:     This is published from the smartviewer containing the smartdatafield 
               to populate the combo with the evaluated query data - if the
               query was succesful.
               It is published from displayfields in the viewer.
               The queries were initially built in getComboQuery. 
  Parameters:  input combo temp-table
  Notes:       This is designed to facilitate all combo queries being built with
               a single appserver hit.
------------------------------------------------------------------------------*/

DEFINE VARIABLE cFieldName              AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cKeyFieldValue          AS CHARACTER  NO-UNDO.
DEFINE VARIABLE hCombo                  AS HANDLE     NO-UNDO.
DEFINE VARIABLE iEntry                  AS INTEGER    NO-UNDO.
DEFINE VARIABLE hContainer              AS HANDLE     NO-UNDO.
DEFINE VARIABLE cCurrentListItemPairs   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE lFieldIsSecured         AS LOGICAL    NO-UNDO.
DEFINE VARIABLE cNewRecord              AS CHARACTER  NO-UNDO.
DEFINE VARIABLE lDisplayField           AS LOGICAL    NO-UNDO.

{get FieldName cFieldName}.

FIND FIRST ttDCombo
     WHERE ttDCombo.hWidget = TARGET-PROCEDURE
       AND ttDCombo.cWidgetName = cFieldName
     NO-ERROR.
IF NOT AVAILABLE ttDCombo THEN RETURN.

&SCOPED-DEFINE xp-assign
{get ComboHandle hCombo}
{get containerSource hContainer}   /* viewer */
{get DisplayField lDisplayField}
{get Secured lFieldIsSecured}.
&UNDEFINE xp-assign

cNewRecord = "":U.
IF VALID-HANDLE(hContainer) THEN
  {get NewRecord cNewRecord hContainer}. 

cKeyFieldValue = DYNAMIC-FUNCTION("formattedValue":U IN TARGET-PROCEDURE, ttDCombo.cCurrentKeyValue).

cCurrentListItemPairs = "":U.
IF CAN-QUERY(hCombo,"LIST-ITEM-PAIRS":U) THEN
  cCurrentListItemPairs = hCombo:LIST-ITEM-PAIRS.

ASSIGN hCombo:DELIMITER = ttDCombo.cListItemDelimiter.

IF cCurrentListItemPairs <> ttDCombo.cListItemPairs THEN
  hCombo:LIST-ITEM-PAIRS = ttDCombo.cListItemPairs
                           NO-ERROR.
{set ListItemPairs ttDCombo.cListItemPairs}.

/*cKeyFieldValue = TRIM(cKeyFieldValue).*/

iEntry = LOOKUP(cKeyFieldValue,ttDCombo.cKeyValues,ttDCombo.cListItemDelimiter)
         NO-ERROR.

IF iEntry = ? THEN
  iEntry = 0.
/* Only set the SCREEN-VALUE if the field is not secured */
IF NOT lFieldIsSecured AND lDisplayField THEN DO:
  IF iEntry > 0 THEN
    hCombo:SCREEN-VALUE = hCombo:ENTRY(iEntry) NO-ERROR.
  IF iEntry > 0 AND
     (hCombo:ENTRY(iEntry) = "":U OR  
      hCombo:ENTRY(iEntry) = ?) THEN
    {fnarg clearCombo hCombo}.
  
  /* If all else fails - make sure the combo doesn't assume the first available entry */
  IF (iEntry <= 0 OR
      ERROR-STATUS:ERROR OR 
      hCombo:SCREEN-VALUE = ?) AND 
     hCombo:LIST-ITEM-PAIRS <> ? THEN
    {fnarg clearCombo hCombo}.
  
  /* Check for a BLANK combo entry if pcValue is BLANK */

  IF iEntry <> 0 AND cKeyFieldValue = "":U AND cNewRecord <> "Add":U THEN DO:
    hCombo:LIST-ITEM-PAIRS = REPLACE(hCombo:LIST-ITEM-PAIRS,(hCombo:DELIMITER + hCombo:DELIMITER),(hCombo:DELIMITER + "!":U + hCombo:DELIMITER)).
    /* No assign the combo to the  */
    hCombo:SCREEN-VALUE = "!" NO-ERROR.
    IF ERROR-STATUS:ERROR THEN
      {fnarg clearCombo hCombo}.
  END.

  IF cNewRecord <> "Add":U THEN
    cKeyFieldValue = hCombo:SCREEN-VALUE.
                           
END.
ELSE DO:
  {fnarg clearCombo hCombo}.
  ERROR-STATUS:ERROR = FALSE.
END.

IF cKeyFieldValue <> ? THEN
  {set DataValue cKeyFieldValue}.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-prepareField) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE prepareField Procedure 
PROCEDURE prepareField :
/*------------------------------------------------------------------------------
  Purpose:    prepare the field for retrieval by building the query with 
              current parentvalues added to the baseQueryString    
  Parameters:  <none>
  Notes:      The combo query is realized as list-item-pairs in the widget, so 
              we only setQueryString if there is parent fields or if the 
              current query is blank. (This is mainly to avoid an unecessary 
              function call and string comparison. Calling setQueryString 
              unconditionally would not cause unecessary data retrieval as 
              setQueryString only sets the reset flag when the query has 
              changed.)  
------------------------------------------------------------------------------*/
 DEFINE VARIABLE cParentField            AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cQueryString            AS CHARACTER  NO-UNDO.
  
  {get ParentField cParentField}.
  {get QueryString cQueryString}.

  IF cParentField > '' OR cQueryString = '' THEN
    {set QueryString "~{fn buildQuery~}"}.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-queryOpened) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE queryOpened Procedure 
PROCEDURE queryOpened :
/*------------------------------------------------------------------------------
  Purpose:  Rebuild list when datasource (re)opens query    
Parameters:  <none>
  Notes:    Published from SDF datasource   
------------------------------------------------------------------------------*/
  DEFINE VARIABLE lInitialized  AS LOGICAL    NO-UNDO.
  
  {get ObjectInitialized lInitialized}.
  IF lInitialized THEN
    {fnarg buildCombo 'Reset':U}.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-refreshChildDependancies) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE refreshChildDependancies Procedure 
PROCEDURE refreshChildDependancies :
/*------------------------------------------------------------------------------
  Purpose:     This procedure steps through any other Dynamic Combo's and checks
               if it is a parent of that combo, If it is, it will run refreshCombo
               in this procedure that will refresh the data items accordingly.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcFieldName AS CHARACTER  NO-UNDO.
  
  DEFINE VARIABLE cFieldName          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cKeyField           AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDisplayedField     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cKeyDataType        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDisplayDataType    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cQueryTables        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cQueryString        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDescSubstitute     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cKeyFieldValue      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cNewQuery           AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cParentField        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cComboFlag          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFlagValue          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cComboDelimiter     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cParentFilterQuery  AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE hContainer          AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hDataSource         AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hCombo              AS HANDLE     NO-UNDO.
  
  DEFINE VARIABLE cList               AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cLoopList           AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cRefreshList        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iLoop               AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iLoop2              AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cCombo              AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cOriginalKeyValue   AS CHARACTER  NO-UNDO.
  
  &SCOPED-DEFINE xp-assign
  {get containerSource hContainer}   /* viewer */
  {get ComboHandle hCombo}.
  &UNDEFINE xp-assign
  
  IF glUseNewAPI THEN
  DO:
    RUN fetchChildFieldData IN hContainer (pcFieldName).  
    RETURN.
  END.

  /* Create a list of Dynamic Combos to be refreshed
     due to the parent changing */
  cLoopList = pcFieldName.
  cList = cLoopList.
  DO_WHILE:
  DO WHILE cList <> "":U:
    cList = "":U.
    DO iLoop = 1 TO NUM-ENTRIES(cLoopList):
      cCombo = ENTRY(iLoop,cLoopList).
      IF getRefreshList(cCombo) = "":U THEN
        LEAVE DO_WHILE.
      cList = IF cList = "":U THEN getRefreshList(cCombo) ELSE cList + "," + getRefreshList(cCombo).
    END.
    cLoopList = cList.
    cRefreshList = IF cRefreshList = "":U THEN cList ELSE cRefreshList + ",":U + cList.
  END.
  
  ASSIGN cLoopList    = cRefreshList
         cRefreshList = "":U.

  DO iLoop = 1 TO NUM-ENTRIES(cLoopList):
    cCombo = ENTRY(iLoop,cLoopList).
    IF LOOKUP(cCombo,cRefreshList) > 0 THEN
      NEXT.
    cRefreshList = IF cRefreshList = "":U THEN cCombo ELSE cRefreshList + ",":U + cCombo.
  END.
  
  IF cRefreshList = "":U OR
     cRefreshList = ? THEN
    RETURN.
 
  DO iLoop = 1 TO NUM-ENTRIES(cRefreshList):
    cCombo = ENTRY(iLoop,cRefreshList).
    
    FIND FIRST ttDCombo
         WHERE ttDCombo.hViewer     = hContainer
         AND   ttDCombo.cWidgetName = cCombo
         EXCLUSIVE-LOCK NO-ERROR.
    
    IF NOT AVAILABLE ttDCombo THEN
      NEXT.

    IF NOT VALID-HANDLE(ttDCombo.hWidget) THEN
        NEXT.

    &SCOPED-DEFINE xp-assign
    {get FieldName cFieldName ttDCombo.hWidget}
    {get KeyField cKeyField ttDCombo.hWidget}
    {get DisplayedField cDisplayedField ttDCombo.hWidget}
    {get KeyDataType cKeyDataType ttDCombo.hWidget}
    {get DisplayDataType cDisplayDataType ttDCombo.hWidget}
    {get BaseQueryString cQueryString ttDCombo.hWidget}
    {get QueryTables cQueryTables ttDCombo.hWidget}
    {get DataValue cKeyFieldValue ttDCombo.hWidget}
    {get ParentField cParentField ttDCombo.hWidget}
    {get DescSubstitute cDescSubstitute ttDCombo.hWidget}
    {get ComboFlag cComboFlag ttDCombo.hWidget}
    {get ComboDelimiter cComboDelimiter ttDCombo.hWidget}
    {get FlagValue cFlagValue ttDCombo.hWidget}.
    &UNDEFINE xp-assign
  
    cNewQuery = cQueryString .
  
    /* We need to set the values to nothing in order to refresh
       the queries to the new values of each individual combo */
    {set DataValue '' ttDCombo.hWidget}.
    /* Get Parent-Child filter Query */
    RUN returnParentFieldValues IN ttDCombo.hWidget (OUTPUT cParentFilterQuery).
    IF cParentFilterQuery <> "":U THEN DO:
      IF  NUM-ENTRIES(cParentFilterQuery,"|":U) > 1 
      AND NUM-ENTRIES(cQueryTables) > 1 THEN 
      DO:
        DO iLoop2 = 1 TO NUM-ENTRIES(cParentFilterQuery,"|":U):
          IF TRIM(ENTRY(iLoop2,cParentFilterQuery,"|":U)) <> "":U THEN
            cNewQuery = DYNAMIC-FUNCTION("newWhereClause" IN ttDCombo.hWidget,
                                         ENTRY(iLoop2,cQueryTables),
                                         ENTRY(iLoop2,cParentFilterQuery,"|":U),
                                         cNewQuery,
                                         "AND":U).
        END.
      END.
      ELSE 
        cNewQuery = DYNAMIC-FUNCTION("newWhereClause" IN ttDCombo.hWidget,
                                     ENTRY(1,cQueryTables),
                                     cParentFilterQuery,
                                     cNewQuery,
                                     "AND":U).
    END.
    /* Just making double sure that we do not refresh the combo
       if no parent filter query was specified */
    ELSE
      NEXT.
     
    /* If the query is still the same - there is no need to refresh
       the query. Get out of here */
    IF ttDCombo.cForEach = cNewQuery THEN
      NEXT.
     
    /* Since we do not want to lose the other Combo information
       we'll copy the changed record to another buffer and
       get the query back for these combos only */
    CREATE ttDComboCopy.
    BUFFER-COPY ttDCombo TO ttDComboCopy.
    ASSIGN ttDComboCopy.cForEach = cNewQuery.
  END.

  /* To be on the save side of Lookups, I created another temp-table
     for it so that we don't break anything - this would always
     be empty in anycase */
  EMPTY TEMP-TABLE ttLookupEmpty.

  /* Resolve query */
  IF VALID-HANDLE(gshAstraAppserver) THEN
    RUN adm2/lookupqp.p ON gshAstraAppserver (INPUT-OUTPUT TABLE ttLookupEmpty,
                                              INPUT-OUTPUT TABLE ttDComboCopy,
                                              INPUT "ComboAutoRefresh":U,
                                              INPUT "":U,
                                              INPUT hContainer).
  
  /* After the query has been repopulated - assign all the values back
     to the original temp-table - since all the other procedures
     refer to that table */
  FOR EACH ttDComboCopy:
    FIND FIRST ttDCombo
         WHERE ttDCombo.hWidget     = ttDComboCopy.hWidget
         AND   ttDCombo.cWidgetName = ttDComboCopy.cWidgetName
         EXCLUSIVE-LOCK NO-ERROR.
    IF AVAILABLE ttDCombo THEN 
    DO:
      BUFFER-COPY ttDComboCopy TO ttDCombo.
      RUN refreshCombo IN ttDCombo.hWidget.
    END.
  END.

  /* The table is duplicated in the viewer class, so assign the values back 
     to that also */
  RUN updateDynComboTable IN hContainer(TEMP-TABLE ttDComboCopy:DEFAULT-BUFFER-HANDLE).

  EMPTY TEMP-TABLE ttDComboCopy.
  
  /* Now we need to see if we can set the combo back to the original set value 
     We only want to do this if called from somewhere other than VALUE-CHANGED */
  IF  INDEX(PROGRAM-NAME(2),"valueChanged":U) = 0 
  AND INDEX(PROGRAM-NAME(2),"combo.p":U) = 0 THEN 
  DO:
    FIND FIRST ttDCombo
         WHERE ttDCombo.hWidget = TARGET-PROCEDURE
         NO-LOCK NO-ERROR.
    IF AVAILABLE ttDCombo THEN 
    DO:
      IF VALID-HANDLE(hContainer) THEN
        hDataSource = DYNAMIC-FUNCTION('getDataSource':U IN hContainer) NO-ERROR.
      {get FieldName cFieldName}.
      IF VALID-HANDLE(hDataSource) THEN
        cOriginalKeyValue = IF NUM-ENTRIES(cFieldName,".":U) > 1 THEN
                              DYNAMIC-FUNCTION("ColumnStringValue":U IN hDataSource,ENTRY(2, cFieldName, ".":U))
                            ELSE
                              DYNAMIC-FUNCTION("ColumnStringValue":U IN hDataSource,cFieldName).
      IF LOOKUP(cKeyFieldValue,ttDCombo.cKeyValues,ttDCombo.cListItemDelimiter) > 0 AND 
         cOriginalKeyValue <> "":U AND cOriginalKeyValue <> ? AND cOriginalKeyValue <> "?":U THEN
        {set DataValue cOriginalKeyValue}.
        
    END.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-refreshCombo) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE refreshCombo Procedure 
PROCEDURE refreshCombo :
/*------------------------------------------------------------------------------
  Purpose:     This procedure is usually triggered from a value-changed event
               of a parent combo.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/ 
  RUN displayField IN TARGET-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-repositionObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE repositionObject Procedure 
PROCEDURE repositionObject :
/*------------------------------------------------------------------------------
  Purpose:     This procedure will reposition the combo and it's label
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

&IF DEFINED(EXCLUDE-resizeObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE resizeObject Procedure 
PROCEDURE resizeObject :
/*------------------------------------------------------------------------------
  Purpose: Resize the Combo      
  Parameters:  INPUT pidHeight decimal New height of component 
               INPUT pidWidth decimal New widtht of component.
  Notes:  The procedure deletes the current widget,
          Resizes the frame and recreates the widget.  
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pidHeight AS DECIMAL NO-UNDO.
  DEFINE INPUT PARAMETER pidWidth  AS DECIMAL NO-UNDO.

  DEFINE VARIABLE hCombo    AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hFrame    AS HANDLE     NO-UNDO.
                     
  &SCOPED-DEFINE xp-assign
  {get ContainerHandle hFrame}
  {get ComboHandle hCombo}.
  &UNDEFINE xp-assign
                     
  ASSIGN hFrame:SCROLLABLE            = TRUE
         hFrame:WIDTH-CHARS           = pidWidth
         hFrame:HEIGHT-CHARS          = pidHeight
         hFrame:VIRTUAL-WIDTH-CHARS   = hFrame:WIDTH-CHARS
         hFrame:VIRTUAL-HEIGHT-CHARS  = hFrame:HEIGHT-CHARS
         hFrame:SCROLLABLE            = FALSE.
  
  IF VALID-HANDLE(hCombo) THEN
    hCombo:WIDTH-CHARS = pidWidth.

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-showQuery) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE showQuery Procedure 
PROCEDURE showQuery :
/*------------------------------------------------------------------------------
  Purpose:     This procedure will display the current query of the combo.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cFieldName  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cQuery      AS CHARACTER  NO-UNDO.
  
  IF glUseNewAPI THEN
    cQuery = {fn getQueryString}.
  ELSE DO:
    FIND FIRST ttDCombo
         WHERE ttDCombo.hWidget = TARGET-PROCEDURE
         AND ttDCombo.cWidgetName = cFieldName
         NO-ERROR.
    IF NOT AVAILABLE ttDCombo THEN 
      RETURN.
    cQuery = ttDCombo.cForEach.
  END.

  MESSAGE cQuery
          VIEW-AS ALERT-BOX TITLE "Combo Query".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-valueChanged) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE valueChanged Procedure 
PROCEDURE valueChanged :
/*------------------------------------------------------------------------------
  Purpose: Make sure the SmartDataViewer  container knows that this value has
           changed.      
  Parameters:  <none>
  Notes:    Defined as a PERSISTENT value-changed trigger in the dynamic-widget
            The code currently duplicates the logic that is defined
            in the U10 trigger in the SmartDataViewer because this code's check
            of FOCUS is wrong when the actual change is caused by a user event
            in the browser.         
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cEvent         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hCombo         AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hContainer     AS HANDLE     NO-UNDO.
  DEFINE VARIABLE lRepos         AS LOGICAL    NO-UNDO.
  
  DEFINE VARIABLE cKeyFieldValue AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFieldName     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cScreenValue   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cKeyValues     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDescValues    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hDynComboBuf   AS HANDLE     NO-UNDO.
  
  &SCOPED-DEFINE xp-assign
  {get ComboHandle hCombo}
  {get ContainerSource hContainer}
  {get FieldName cFieldName}
  {set DataModified YES}.
  &UNDEFINE xp-assign
 
  /* First we'll set the new KeyFieldValue */
  cKeyFieldValue = RIGHT-TRIM(hCombo:INPUT-VALUE) NO-ERROR.
  IF NOT ERROR-STATUS:ERROR THEN
    {set DataValue cKeyFieldValue}.
  
  &SCOPED-DEFINE xp-assign
  /* Get the value formatted correctly */
  {get DataValue cKeyFieldValue}
  &UNDEFINE xp-assign
  
  hDynComboBuf = {fn returnComboBuffer}.
  IF hDynComboBuf:AVAILABLE THEN 
  DO:
    hDynComboBuf:BUFFER-FIELD('cCurrentKeyValue':U):BUFFER-VALUE = cKeyFieldValue.
    cScreenValue = ENTRY((hCombo:LOOKUP(hCombo:SCREEN-VALUE) * 2) - 1,hCombo:LIST-ITEM-PAIRS,hCombo:DELIMITER).
    {set CurrentDescValue cScreenValue}.
  END.

  /* Refreshes any other child dependant Dynamic combo's */
  RUN refreshChildDependancies IN TARGET-PROCEDURE (INPUT cFieldName).

  /* This will ensure that the Static Combo's know that the parent has changed */
  PUBLISH "populateChildCombo":U FROM hContainer (INPUT cKeyFieldValue, INPUT TRUE).
  
  PUBLISH "comboValueChanged":U FROM  hContainer (INPUT cKeyFieldValue,     /* Key Field Value */
                                                  INPUT cScreenValue,       /* Current Screen Value */
                                                  INPUT TARGET-PROCEDURE    /* Handle to combo - use to determine which combo's value was changed */
                                                  ). 

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

&IF DEFINED(EXCLUDE-buildCombo) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION buildCombo Procedure 
FUNCTION buildCombo RETURNS LOGICAL
  (pcMode AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose: Build the combo list-item-pairs  
Parameter: pcMode - 
               Blank - just build list (F. ex. called from displayfield)
               Reset - Reset screen-value after rebuild. 
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cBuildCombo   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hDataSource   AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hCombo        AS HANDLE     NO-UNDO.
  DEFINE VARIABLE lNewList      AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cCurrentValue AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hCombobuffer  AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cLIP          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cValue        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cAltValue     AS CHARACTER  NO-UNDO.

  &SCOPED-DEFINE xp-assign
  {get ComboHandle hCombo}
  {get DataSource hDataSource}.
  &UNDEFINE xp-assign

  IF VALID-HANDLE(hCombo) THEN
  DO:
    cCurrentValue = hCombo:SCREEN-VALUE.   
    IF NOT VALID-HANDLE(hDataSource) THEN
    DO:
      hComboBuffer = {fn returnComboBuffer}.
      IF NOT hComboBuffer:AVAILABLE THEN 
        RETURN ?.

      IF CAN-QUERY(hCombo,"LIST-ITEM-PAIRS":U) THEN
      DO:
        cLIP = hComboBuffer:BUFFER-FIELD('cListItemPairs'):BUFFER-VALUE.
        IF hCombo:LIST-ITEM-PAIRS <> cLIP THEN
        DO:
          hCombo:LIST-ITEM-PAIRS = cLIP NO-ERROR.
          {set ListItemPairs cLIP}.   
        END.  
      END.  
    END.
    ELSE
      hCombo:LIST-ITEM-PAIRS = {fn buildList} NO-ERROR.
      
    IF pcMode = 'RESET':U THEN
    DO:
      hCombo:SCREEN-VALUE = cCurrentValue NO-ERROR.
      /* screen-value = ? means the setting failed */
      IF hCombo:SCREEN-VALUE = ? THEN
      DO:
        {get AltValueOnRebuild cAltValue}.
        cValue = ?. 
        /* if altvalue is '<Clear>' then setting the list-item-pairs has already
           taken care of this. */
        IF cAltValue <> '<Clear>':U THEN
        DO:
          CASE cAltValue:
            WHEN '<First>':U THEN
              cValue = hCombo:ENTRY(1).
            WHEN '<Last>':U THEN
              cValue = hCombo:ENTRY(hCombo:NUM-ITEMS).
          END CASE.
        END.
        {set DataValue cValue}.
        {set DataModified TRUE}.
      END.  /* current value not in list */
    END. /* mode = 'reset' */ 
  END. /* valid combo */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-buildList) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION buildList Procedure 
FUNCTION buildList RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  Build combo list from DataSource
    Notes:  
------------------------------------------------------------------------------*/  
  DEFINE VARIABLE hDataSource     AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cList           AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDescSubstitute AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cComboDelimiter AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDisplayedField AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cKeyField       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iKeyNum         AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cFormatMask     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cComboFlag      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cOption         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFlagValue      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cEmptyValue     AS CHARACTER  NO-UNDO.

  &SCOPED-DEFINE xp-assign
  {get DataSource hDataSource}
  {get DescSubstitute cDescSubstitute}
  {get ComboDelimiter cComboDelimiter}
  {get DisplayedField cDisplayedField}
  {get KeyField cKeyField}
  {get ComboFlag cComboFlag}
  {get FlagValue cFlagValue}
    .
  &UNDEFINE xp-assign
    
  /* This should only be called when valid data source, but check just in case */
  IF VALID-HANDLE(hDataSource) THEN
  DO:
    ASSIGN
      iKeyNum = NUM-ENTRIES(cDescSubstitute) + 1 
      cFormatMask = cDescSubstitute 
                  /* add delimiter and keyfield to return a paired list with key
                     as second item */
                  + cComboDelimiter 
                  /* add substitute token for keyfield */  
                  + '&' + STRING(NUM-ENTRIES(cDisplayedField) + 1)
      cList = DYNAMIC-FUNCTION('rowValues':U IN hDataSource,
                                cDisplayedField + ',' + cKeyField,
                                cFormatMask,
                                cComboDelimiter).
    IF cComboFlag > '' AND cList <> ? THEN
    DO:
      CASE cComboFlag:
        WHEN 'N' THEN 
          cOption = "<None>":U.
        WHEN 'A' THEN
          cOption = "<All>":U.
      END.
      IF cOption <> '' AND VALID-HANDLE(gshTranslationManager) THEN
        cOption = DYNAMIC-FUNCTION("translatePhrase":U IN gshTranslationManager,
                                   cOption,
                                   0).
      /* could blow 32K limit */
      DO ON STOP UNDO,LEAVE:
        ASSIGN
          cEmptyValue = {fnarg formattedValue cFlagValue}
          cList       = cOption + cComboDelimiter + cEmptyValue 
                      + (IF cList > '' 
                         THEN cComboDelimiter + cList 
                         ELSE '') NO-ERROR.   
      END.
      IF ERROR-STATUS:ERROR THEN
        MESSAGE ERROR-STATUS:GET-MESSAGE(1)
        VIEW-AS ALERT-BOX WARNING. 
    END.
  END.
  
  RETURN IF cList = '' THEN ? ELSE cList.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-createDataSource) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION createDataSource Procedure 
FUNCTION createDataSource RETURNS HANDLE
  ( ) :
/*------------------------------------------------------------------------------
  Purpose: Create and initialize a DataSource from the DataSourceName property  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hDataSource       AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cDataSourceName   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hViewerDataSource AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hRequestSDO       AS HANDLE     NO-UNDO.
  DEFINE VARIABLE lUseCache         AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE hContainer        AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cRenderingProc    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lUseProxy         AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lDynamic          AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lDataView         AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cProps            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cBusinessEntity   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDatasetName      AS CHARACTER  NO-UNDO.
  
  &SCOPED-DEFINE xp-assign
  {get ContainerSource hContainer}  
  {get DataSource hDataSource}  
  {get DataSourceName cDataSourceName}
  .
  &UNDEFINE xp-assign

  IF NOT VALID-HANDLE(hDataSource) 
  AND cDataSourceName > '' 
  AND VALID-HANDLE(hcontainer) THEN 
  DO:
    {get DataSource hViewerDataSource hContainer}.
    IF VALID-HANDLE(hViewerDataSource) THEN
      lDataView = {fnarg InstanceOf 'DataView':U hViewerDataSource}.

   /* A viewer with no data source may exist... (not recommended, but..)
      Currently assume that it always exists for DataView cases.. since the 
      combo is assigned to one of the viewer's tables at design time*/ 
    ELSE  
      lDataView = NO. 

    IF NOT lDataView THEN
    DO:
      IF VALID-HANDLE(gshAstraAppServer) THEN 
      DO:
        lUseProxy  = SESSION <> gshAstraAppServer.
        IF lUseProxy THEN
          ASSIGN
            cRenderingProc = 'adm2/thindata.w':U
            cProps         = 'AsDivision':U  + CHR(4) + 'CLIENT'.
        ELSE DO:
          ASSIGN
            cRenderingProc = 'adm2/thinsdo.w':U
            cProps         = 'LaunchLogicalName':U + CHR(4) + cDataSourceName.
       /* CurrentLogicalname is set for dynamic containers that has set/get
          while the static container still need to use the LaunchLogicalName 
          trick above as containr.p does not yet have a set and get */.   
         {set CurrentLogicalName cDataSourceName hContainer}.  
        END.
      END.
      ELSE  /* non-dynamcis not really supported... */
        cRenderingProc = cDataSourceName.
  
    END.
    ELSE DO:
      &SCOPED-DEFINE xp-assign
      {get BusinessEntity cBusinessEntity hViewerDataSource}
      {get DatasetName cDatasetName hViewerDataSource}
       .
      &UNDEFINE xp-assign
      ASSIGN
        cRenderingProc = 'adm2/thindataview.w'
        cProps =  'BusinessEntity':U + CHR(4) + cBusinessEntity
               +  CHR(3)
               +  'DatasetName':U + CHR(4) + cDatasetName
               +  CHR(3)
               +  'DataTable':U + CHR(4) + cDataSourceName.

    END.
       
     /* No batching */
    cProps = cProps 
           + (IF cProps = '' THEN '' ELSE CHR(3))
           +  'RowsToBatch':U + CHR(4) + '0'.

    RUN constructObject IN hContainer 
          (cRenderingProc,
           '',
           cProps, 
           OUTPUT hRequestSDO).

    IF NOT lDataView THEN
    DO:
      /* The proxy is created from the class and need a logical name */  
      IF lUseProxy THEN
        {set LogicalObjectName cDataSourceName hRequestSDO}.         
       
      /* else clear the prepareinstance callback prop after use */
      ELSE 
        {set currentLogicalName ? hContainer}.

      /* Only share if dynamic (always true in dynamic as renderer is set above) */
      {get DynamicData lDynamic hRequestSDO}.
      IF lDynamic THEN
        {set ShareData TRUE hRequestSDO}. 
  
      /* inherit cache from combo props */
      {get UseCache lUseCache}.
      IF lUseCache THEN
        {set CacheDuration ? hRequestSDO}.
    END.
        
    RUN addlink IN TARGET-PROCEDURE (hRequestSDO,'Data':U,TARGET-PROCEDURE).
 
  END.

  RETURN hRequestSDO. 

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-createLabel) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION createLabel Procedure 
FUNCTION createLabel RETURNS HANDLE
  (pcLabel AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose   : Create the label of the Combo 
 Description:         The label are added to the parent frame  
    Notes   : This function is separated in order to be able to create 
               the label in design-mode.
------------------------------------------------------------------------------*/
   DEFINE VARIABLE hLabel        AS HANDLE    NO-UNDO.
   DEFINE VARIABLE iLabelLength  AS INTEGER   NO-UNDO.
   DEFINE VARIABLE hParentFrame  AS HANDLE    NO-UNDO.
   DEFINE VARIABLE hFrame        AS HANDLE    NO-UNDO.
   DEFINE VARIABLE lLabels       AS LOGICAL    NO-UNDO.
   DEFINE VARIABLE lVisible      AS LOGICAL    NO-UNDO.
   DEFINE VARIABLE hCombo        AS HANDLE     NO-UNDO.

   &SCOPED-DEFINE xp-assign
   {get LabelHandle hLabel}
   {get Labels lLabels}
   /* Check if the SDF is being hidden on initialization - issue 11059 */
   {get HideOnInit lVisible}
   {get ComboHandle hCombo}
   {get ContainerHandle hFrame}.
   &UNDEFINE xp-assign
   
   IF NOT lLabels THEN
     pcLabel = "":U.

   IF VALID-HANDLE(hLabel) THEN
   DO:
     /* endmove passes blank value, if so just copy the old value */ 
     IF pcLabel = "":U THEN 
       pcLabel = RIGHT-TRIM(hLabel:SCREEN-VALUE,":":U).
     DELETE WIDGET hLABEL.
   END.   
   ELSE IF pcLabel = "":U THEN
     RETURN ?.

   hParentFrame = hFrame:FRAME.

   iLabelLength = FONT-TABLE:GET-TEXT-WIDTH-PIXELS(pcLabel + ": ":U, hFrame:FONT).

   CREATE TEXT hLabel
     ASSIGN FRAME                 = hParentFrame
            X                     = hFrame:X - iLabelLength
            Y                     = hFrame:Y
            HIDDEN                = TRUE
            WIDTH-PIXELS          = iLabelLength
            FORMAT                = "x(256)":U
            SCREEN-VALUE          = pcLabel + ":":U
            HEIGHT-PIXELS         = SESSION:PIXELS-PER-ROW 
            .  
   IF hLabel:COL <= 0 THEN
     hLabel:COL = 1.

  {set LabelHandle hLabel}.

  IF DYNAMIC-FUNCTION('getUseWidgetID':U IN TARGET-PROCEDURE) THEN
     RUN assignLabelWidgetID IN TARGET-PROCEDURE.  

  ASSIGN hLabel:HIDDEN = lVisible.

  hCombo:SIDE-LABEL-HANDLE = hLabel.

  RETURN hLabel. 
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-destroyCombo) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION destroyCombo Procedure 
FUNCTION destroyCombo RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose: Cleanup all dynamicly created objects. 
    Notes:  
------------------------------------------------------------------------------*/

  DEFINE VARIABLE hCombo       AS HANDLE   NO-UNDO.
  DEFINE VARIABLE hLabel        AS HANDLE   NO-UNDO.

  &SCOPED-DEFINE xp-assign
  {get ComboHandle hCombo}
  {get LabelHandle hLabel}.
  &UNDEFINE xp-assign

  IF VALID-HANDLE(hCombo) THEN DELETE WIDGET hCombo.
  IF VALID-HANDLE(hLabel)  THEN DELETE WIDGET hLabel.

  ASSIGN
    hCombo = ?
    hLabel = ?
    .

  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fixKeyDataType) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fixKeyDataType Procedure 
FUNCTION fixKeyDataType RETURNS CHARACTER
  ( pcKeyFormat AS CHARACTER,
    pcKeyDataType AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  In an earlier version of Dynamics we saved the DisplayDataType
            in the KeyDataType attribute and visa-versa...
            We need to cater for this situation since older version's data
            will still be incorrect and it is not possible to fix the data
            in the repository due to the complexity.
    
    Notes: This function is only used for backward compatibility, when a dyncombo
           could be created without a data type. This cannot be done in 10.1B,
           therefore we don't need to add support for INT64 here.
------------------------------------------------------------------------------*/
  
  IF pcKeyDataType = "CHARACTER":U THEN DO:
    IF INDEX(pcKeyFormat,">":U) > 0 AND
       INDEX(pcKeyFormat,"9":U) > 0 AND
       INDEX(pcKeyFormat,".":U) > 0 THEN /* We have a decimal */
      pcKeyDataType = "DECIMAL":U.
    IF INDEX(pcKeyFormat,">":U) > 0 AND
       INDEX(pcKeyFormat,"9":U) > 0 AND
       INDEX(pcKeyFormat,".":U) = 0 THEN /* We have an Integer */
      pcKeyDataType = "INTEGER":U.
    IF INDEX(pcKeyFormat,"/":U) > 0 AND
       INDEX(pcKeyFormat,"99":U) > 0 THEN /* We have a Date */
      pcKeyDataType = "DATE":U.
    IF INDEX(pcKeyFormat,"TRUE":U) > 0 OR
       INDEX(pcKeyFormat,"YES":U) > 0 THEN /* We have a Logical */
      pcKeyDataType = "LOGICAL":U.
  END.

  RETURN pcKeyDataType.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getAltValueOnAdd) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getAltValueOnAdd Procedure 
FUNCTION getAltValueOnAdd RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  Specifies the alternate value to display in the case the viewer data 
            source initial value does not exist in the list of values. 
            
           - <Clear> = Clear the combo box  
           - <First>   = Select first item in list of values  
           - <Last>   = Select last item in list of values  
           - An actual key value
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cAltValue AS CHARACTER  NO-UNDO.
  {get AltValueOnAdd cAltValue}.

  RETURN cAltValue. 

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getAltValueOnRebuild) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getAltValueOnRebuild Procedure 
FUNCTION getAltValueOnRebuild RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  Specifies the alternate value to display if the current value does 
            not exist in the list after it is rebuilt, for example as a result 
            of a value change in a parent combo.  
           - <Clear> = Clear the combo box  
           - <First>   = Select first item in list of values  
           - <Last>   = Select last item in list of values  
           - An actual key value    
    Notes: This applies to rebuild when in edit mode, not to the normal display 
           event, which also may rebuild the list.               
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cAltValue AS CHARACTER  NO-UNDO.
  {get AltValueOnRebuild cAltValue}.

  RETURN cAltValue. 

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getBuildSequence) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getBuildSequence Procedure 
FUNCTION getBuildSequence RETURNS INTEGER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose: 
    Notes:   
------------------------------------------------------------------------------*/
  DEFINE VARIABLE iSequence AS INTEGER NO-UNDO.
  
  
  &SCOPED-DEFINE xpBuildSequence
  {get BuildSequence iSequence}.
  &UNDEFINE xpBuildSequence
  
  RETURN iSequence.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getComboDelimiter) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getComboDelimiter Procedure 
FUNCTION getComboDelimiter RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose: 
    Notes:   
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cValue AS CHARACTER NO-UNDO.
  &SCOPED-DEFINE xpComboDelimiter
  {get ComboDelimiter cValue}.
  &UNDEFINE xpComboDelimiter
  
  RETURN cValue.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getComboFlag) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getComboFlag Procedure 
FUNCTION getComboFlag RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose: 
    Notes:   
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cValue AS CHARACTER NO-UNDO.
  
  &SCOPED-DEFINE xpComboFlag
  {get ComboFlag cValue}.
  &UNDEFINE xpComboFlag
  
  RETURN cValue.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getComboHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getComboHandle Procedure 
FUNCTION getComboHandle RETURNS HANDLE
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose: 
    Notes:   
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hValue AS HANDLE NO-UNDO.
  {get ComboHandle hValue}.
  RETURN hValue.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getCurrentDescValue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getCurrentDescValue Procedure 
FUNCTION getCurrentDescValue RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose: 
    Notes:   
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cValue AS CHARACTER NO-UNDO.
  {get DisplayValue cValue}.
  RETURN cValue.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getCurrentKeyValue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getCurrentKeyValue Procedure 
FUNCTION getCurrentKeyValue RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose: 
    Notes:   
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cValue AS CHARACTER NO-UNDO.
  {get DataValue cValue}.
  RETURN cValue.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDataValue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getDataValue Procedure 
FUNCTION getDataValue RETURNS CHARACTER
  ( ) :
/*------------------------------------------------------------------------------
  Purpose: Returns the datavalue   
    Notes: This is read by the SmartDataViewer when it collectChanges 
           if it encounters this PROCEDURE in the list of EnabledHandles and 
           the  DataModified property of this object equals TRUE. 
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hCombo          AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cDisplayedField AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cKeyField       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDataValue      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDefaultValue   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cKeyDataType    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cKeyFormat      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cOldDataValue   AS CHARACTER  NO-UNDO.
  
  /*
  /* ensure manual field changes are saved correctly */
  RUN leaveCombo IN TARGET-PROCEDURE.
  */
  {get ComboHandle hCombo}.

  IF NOT VALID-HANDLE(hCombo) THEN
    RETURN ?. 

  &SCOPED-DEFINE xp-assign
  {get KeyField cKeyField}
  {get DisplayedField cDisplayedField}
  {get FlagValue cDefaultValue}
  {get KeyDataType cKeyDataType}
  {get keyFormat cKeyFormat}.
  &UNDEFINE xp-assign

  &SCOPED-DEFINE xpDataValue
  {get DataValue cDataValue}.
  &UNDEFINE xpDataValue
  cDataValue = TRIM(cDataValue).
  
  /* Check if a BLANK VALUE is valid for our COMBO */
  IF CAN-QUERY(hCombo,"LIST-ITEM-PAIRS":U) AND
     cDataValue = "":U AND 
     (LOOKUP(cDataValue,hCombo:LIST-ITEM-PAIRS,hCombo:DELIMITER) > 0 OR
      LOOKUP("!":U,hCombo:LIST-ITEM-PAIRS,hCombo:DELIMITER) > 0) THEN
    cDataValue = "!":U.

  IF cDataValue = "":U AND 
     cDataValue <> cDefaultValue THEN
    ASSIGN cDataValue    = cDefaultValue
           cOldDataValue = cDataValue.
  

  CASE cKeyDataType:
    WHEN "DECIMAL":U THEN
      cDataValue = TRIM(STRING(DECIMAL(cDataValue),cKeyFormat)) NO-ERROR.
    WHEN "INTEGER":U THEN
      cDataValue = TRIM(STRING(INTEGER(cDataValue),cKeyFormat)) NO-ERROR.
    WHEN "INT64":U THEN
      cDataValue = TRIM(STRING(INT64(CDATAVALUE),cKeyFormat)) NO-ERROR.
  END CASE.
  /* Check for invalid values in an Integer or Decimal field */
  IF ERROR-STATUS:ERROR AND
     ERROR-STATUS:GET-NUMBER(1) = 76 AND 
     cDataValue = cDefaultValue THEN DO:
    ASSIGN cDataValue = "0":U.
    /* Set the DefaultValue 'FlagValue' to 0 (zero) */
    {set FlagValue '0'}.
  END.
  
  /* Check if the value was a BLANK value */
  IF cDataValue = "!":U THEN
    cDataValue = "":U.
  
  RETURN cDataValue.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDescSubstitute) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getDescSubstitute Procedure 
FUNCTION getDescSubstitute RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose: 
    Notes:   
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cValue AS CHARACTER NO-UNDO.

  &SCOPED-DEFINE xpDescSubstitute
  {get DescSubstitute cValue}.
  &UNDEFINE xpDescSubstitute
  RETURN cValue.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getFieldHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getFieldHandle Procedure 
FUNCTION getFieldHandle RETURNS HANDLE
  (  ) :
/*------------------------------------------------------------------------------
  Purpose: Override to return the ComboHandle  
    Notes: The different sibling classes, like lookup and select have all been 
           implemented with different names. This function is expected to 
           replace those in order to achieve polymorphism. 
         - Currently used by clearField.
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hField AS HANDLE     NO-UNDO.
  {get ComboHandle hField}.

  RETURN hField.   

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getFlagValue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getFlagValue Procedure 
FUNCTION getFlagValue RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose: Get's the Option Flag Key Values for <All> and <None>
    Notes:   
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cValue AS CHARACTER NO-UNDO.
  &SCOPED-DEFINE xpFlagValue
  {get FlagValue cValue}.
  &UNDEFINE xpFlagValue
  
  RETURN cValue.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getInnerLines) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getInnerLines Procedure 
FUNCTION getInnerLines RETURNS INTEGER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose: Get's the Option Flag Key Values for <All> and <None>
    Notes:   
------------------------------------------------------------------------------*/
  DEFINE VARIABLE iInnerLines AS INTEGER NO-UNDO.
  {get InnerLines iInnerLines}.
  RETURN iInnerLines.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getListItemPairs) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getListItemPairs Procedure 
FUNCTION getListItemPairs RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose: 
    Notes:   
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cValue AS CHARACTER NO-UNDO.
  {get ListItemPairs cValue}.
  RETURN cValue.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getNumItems) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getNumItems Procedure 
FUNCTION getNumItems RETURNS INTEGER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose: Return the number of items in the combo box 
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hCombo AS HANDLE     NO-UNDO.
  {get ComboHandle hCombo}. 
  IF VALID-HANDLE(hCombo) THEN
    RETURN hCombo:NUM-ITEMS.

  RETURN ?.
  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getRefreshList) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getRefreshList Procedure 
FUNCTION getRefreshList RETURNS CHARACTER
  ( INPUT pcParentCombo AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  This function will return the names of the Dynamic Combos to be 
            refreshed for a parent combo as the input parameter.
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cReturnList AS CHARACTER  NO-UNDO.

  DEFINE BUFFER bDCombo FOR ttDCombo.

  FOR EACH  bDCombo
      WHERE bDCombo.cWidgetName <> pcParentCombo
      AND   LOOKUP(pcParentCombo,bDCombo.cParentField) > 0
      NO-LOCK:
    cReturnList = cReturnList + (IF cReturnList = "" THEN "" ELSE ",") +
                  bDCombo.cWidgetName.
  END.

  RETURN cReturnList.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getSecured) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getSecured Procedure 
FUNCTION getSecured RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns TRUE if the combo's security is set to HIDDEN
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE plFieldIsSecured  AS LOGICAL    NO-UNDO.
  
  {get Secured plFieldIsSecured}.
  
  RETURN plFieldIsSecured.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getSort) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getSort Procedure 
FUNCTION getSort RETURNS LOGICAL
  ( ) :
/*------------------------------------------------------------------------------
  Purpose: Returns TRUE if the combo is to be sorted.   
    Notes:   
------------------------------------------------------------------------------*/
  DEFINE VARIABLE lSort AS LOGICAL NO-UNDO.
  {get Sort lSort}.
  RETURN lSort.

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
         - Overrides lookupfield to default to first table   
------------------------------------------------------------------------------*/
 DEFINE VARIABLE cQueryTables AS CHARACTER  NO-UNDO.
 
 {get QueryTables cQueryTables}.
 IF INDEX(pcParentFilterQuery,"|":U) = 0 THEN 
   RETURN ENTRY(1,cQueryTables).  
 ELSE 
   RETURN cQueryTables.    

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-returnComboBuffer) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION returnComboBuffer Procedure 
FUNCTION returnComboBuffer RETURNS HANDLE
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  IF glUseNewAPI THEN
    RETURN {fnarg ReturnBuffer 'Combo':U}.  /* let lookup.p return the handle */
  ELSE DO:
    FIND FIRST ttDCombo WHERE ttDCombo.hWidget = TARGET-PROCEDURE NO-ERROR.
    RETURN BUFFER ttDCombo:HANDLE.
  END.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setAltValueOnAdd) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setAltValueOnAdd Procedure 
FUNCTION setAltValueOnAdd RETURNS LOGICAL
  ( pcAltValue AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Specifies the alternate value to display in the case the viewer data 
            source initial value does not exist in the list of values. 
Parameter: pcAltValue            
           - <Clear> = Clear the combo box  
           - <First>   = Select first item in list of values  
           - <Last>   = Select last item in list of values  
           - An actual key value
    Notes:  
------------------------------------------------------------------------------*/
  
  {set AltValueOnAdd pcAltValue}.
  RETURN TRUE. 

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setAltValueOnRebuild) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setAltValueOnRebuild Procedure 
FUNCTION setAltValueOnRebuild RETURNS LOGICAL
  ( pcAltValue AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Specifies the alternate value to display if the current value does 
            not exist in the list after it is rebuilt, for example as a result 
            of a value change in a parent combo.  
Parameter: pcAltValue            
           - <Clear> = Clear the combo box  
           - <First>   = Select first item in list of values  
           - <Last>   = Select last item in list of values  
           - An actual key value
    Notes: This applies to rebuild when in edit mode, not to the normal display 
           event, which also may rebuild the list.               
------------------------------------------------------------------------------*/
  
  {set AltValueOnAdd pcAltValue}.
  RETURN TRUE. 

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setBuildSequence) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setBuildSequence Procedure 
FUNCTION setBuildSequence RETURNS LOGICAL
  ( piSequence AS INTEGER ) :
/*------------------------------------------------------------------------------
  Purpose: 
Parameters:     
    Notes:   
------------------------------------------------------------------------------*/
  IF piSequence = ? THEN ASSIGN piSequence = 0. /* avoid nulls */
  
  &SCOPED-DEFINE ttfield iBuildSequence
  &SCOPED-DEFINE propvalue piSequence
  {&setprop}


  &SCOPED-DEFINE xpBuildSequence
  {set BuildSequence piSequence}.
  &UNDEFINE xpBuildSequence
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setComboDelimiter) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setComboDelimiter Procedure 
FUNCTION setComboDelimiter RETURNS LOGICAL
  ( pcValue AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose: 
Parameters:     
    Notes:   
------------------------------------------------------------------------------*/
  &SCOPED-DEFINE ttfield cListItemDelimiter
  &SCOPED-DEFINE propvalue pcValue
  {&setprop}

  &SCOPED-DEFINE xpComboDelimiter
  {set ComboDelimiter pcValue}.
  &UNDEFINE xpComboDelimiter
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setComboFlag) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setComboFlag Procedure 
FUNCTION setComboFlag RETURNS LOGICAL
  ( pcValue AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose: 
Parameters:     
    Notes:   
------------------------------------------------------------------------------*/
  &SCOPED-DEFINE ttfield cFlag
  &SCOPED-DEFINE propvalue pcValue
  {&setprop}

  &SCOPED-DEFINE xpComboFlag
  {set ComboFlag pcValue}.
  &UNDEFINE xpComboFlag
  
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setComboHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setComboHandle Procedure 
FUNCTION setComboHandle RETURNS LOGICAL
  ( phValue AS HANDLE ) :
/*------------------------------------------------------------------------------
  Purpose: 
Parameters:     
    Notes:   
------------------------------------------------------------------------------*/
  {set ComboHandle phValue}.
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setCurrentDescValue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setCurrentDescValue Procedure 
FUNCTION setCurrentDescValue RETURNS LOGICAL
  ( pcValue AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose: 
Parameters:     
    Notes:   
------------------------------------------------------------------------------*/
  {set DisplayValue pcValue}.
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setCurrentKeyValue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setCurrentKeyValue Procedure 
FUNCTION setCurrentKeyValue RETURNS LOGICAL
  ( pcValue AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose: 
Parameters:     
    Notes:   
------------------------------------------------------------------------------*/
  {set DataValue pcValue}.
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setDataValue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setDataValue Procedure 
FUNCTION setDataValue RETURNS LOGICAL
  (pcValue AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose: Sets the datavalue   
Parameters: INPUT pcValue - Value that corresponds to the KeyField property      
    Notes: This is either called by the SmartDataViewer Displayfields or by
           the combo's own displayField.
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hCombo           AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cKeyField        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDisplayedField  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hContainer       AS HANDLE     NO-UNDO.
  DEFINE VARIABLE lFieldIsSecured  AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE iEntry           AS INTEGER    NO-UNDO.
  DEFINE VARIABLE lDisplayField    AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cDisplayValue    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lReturn          AS LOGICAL    NO-UNDO INIT TRUE.
  DEFINE VARIABLE hComboBuffer     AS HANDLE     NO-UNDO.

  {get ComboHandle hCombo}.         

  IF VALID-HANDLE(hCombo) AND hCombo:DATA-TYPE = "DECIMAL":U AND pcValue = "":U THEN 
    pcValue = ?.

  &SCOPED-DEFINE xpDataValue
  {set DataValue pcValue}.
  &UNDEFINE xpDataValue
  
  /* Check if the Combo has been populated. If not, we only update the 
     ADMProps field */
  hComboBuffer = {fn returnComboBuffer}.
  IF NOT VALID-HANDLE(hCombo) OR NOT hComboBuffer:AVAILABLE THEN
    RETURN TRUE.
  
  /* Test for BLANK VALUE '!' */
  IF pcValue = '!' THEN
    pcValue = "".

  &SCOPED-DEFINE xp-assign
  {get ContainerSource hContainer}
  {get Secured lFieldIsSecured}
  {get DisplayField lDisplayField}
  {get ComboHandle hCombo}
  {get KeyField cKeyField}
  {get DisplayedField cDisplayedField}
  . 

  &UNDEFINE xp-assign
  
  IF NOT lFieldIsSecured AND lDisplayField THEN
  DO:
    IF VALID-HANDLE(hCombo) and
       hCombo:LIST-ITEM-PAIRS <> ? THEN
      hCombo:SCREEN-VALUE = (IF pcValue = '' THEN ' ' ELSE pcValue) NO-ERROR.
    IF ERROR-STATUS:GET-NUMBER(1) = 4058 OR pcValue = ? THEN   
    DO:
      RUN clearField IN TARGET-PROCEDURE.
      lReturn = FALSE.
      cDisplayValue = ?.
    END.
    ELSE IF VALID-HANDLE(hCombo) 
    AND cKeyField <> cDisplayedField THEN
    DO:
      iEntry = hCombo:LOOKUP(hCombo:SCREEN-VALUE).
      /*
      IF iEntry MODULO 2 = 0 THEN
      */

      cDisplayValue = ENTRY((iEntry * 2) - 1,hCombo:LIST-ITEM-PAIRS,hCombo:DELIMITER).
    END.
    ELSE     
      cDisplayValue = pcValue.

    {set DisplayValue cDisplayValue}. 
    
  END.
  
  IF {fn getDataModified} THEN
     RUN notifyChildFields IN TARGET-PROCEDURE ('fetch').
  
  {set Modify TRUE}.      
  
  RETURN lReturn.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setDescSubstitute) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setDescSubstitute Procedure 
FUNCTION setDescSubstitute RETURNS LOGICAL
  ( pcValue AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose: 
Parameters:     
    Notes:   
------------------------------------------------------------------------------*/
  &SCOPED-DEFINE ttfield cDescSubstitute 
  &SCOPED-DEFINE propvalue pcValue 
  {&setprop} 

  &SCOPED-DEFINE xpDescSubstitute
  {set DescSubstitute pcValue}.
  &UNDEFINE xpDescSubstitute
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setFlagValue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setFlagValue Procedure 
FUNCTION setFlagValue RETURNS LOGICAL
  ( pcValue AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose: Set's the Option Flag Key Values for <All> and <None>
Parameters:     
    Notes: The need to make the value of <All> and <None> something different 
           than the normal ? . or BLANK. This value will be assigned to the 
           key field when one of these options are chosen.
------------------------------------------------------------------------------*/
  &SCOPED-DEFINE ttfield cFlagValue
  &SCOPED-DEFINE propvalue pcValue
  {&setprop}

  &SCOPED-DEFINE xpFlagValue
  {set FlagValue pcValue}.
  &UNDEFINE xpFlagValue
  
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setInnerLines) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setInnerLines Procedure 
FUNCTION setInnerLines RETURNS LOGICAL
  ( piInnerLines AS INTEGER ) :
/*------------------------------------------------------------------------------
  Purpose:  Set's the Sort propery for the Combo
    Notes:  
------------------------------------------------------------------------------*/
  {set InnerLines piInnerLines}.
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setListItemPairs) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setListItemPairs Procedure 
FUNCTION setListItemPairs RETURNS LOGICAL
  ( pcValue AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose: 
Parameters:     
    Notes:   
------------------------------------------------------------------------------*/
  {set ListItemPairs pcValue}.
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
  Purpose: Sets the Parent field name of this combo's parent dependant object
Parameters:     
    Notes:   
------------------------------------------------------------------------------*/
  &SCOPED-DEFINE ttfield cParentField
  &SCOPED-DEFINE propvalue pcValue
  {&setprop}

  RETURN SUPER(pcValue).

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
  &SCOPED-DEFINE ttfield cParentFilterQuery
  &SCOPED-DEFINE propvalue pcValue
  {&setprop}

  RETURN SUPER(pcValue).

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
 &SCOPED-DEFINE ttfield cPhysicalTableNames 
 &SCOPED-DEFINE propvalue pcvalue
 {&setprop} 

 RETURN SUPER(pcValue).

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
 &SCOPED-DEFINE ttfield cBufferList 
 &SCOPED-DEFINE propvalue pcvalue
 {&setprop}

 RETURN SUPER(pcValue).

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setSecured) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setSecured Procedure 
FUNCTION setSecured RETURNS LOGICAL
  ( INPUT plFieldIsSecured AS LOGICAL ) :
/*------------------------------------------------------------------------------
  Purpose:  Indicates whether a field has the HIDDEN security option set
    Notes:  
------------------------------------------------------------------------------*/
  {set Secured plFieldIsSecured}.
  
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setSort) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setSort Procedure 
FUNCTION setSort RETURNS LOGICAL
  ( pilSort AS LOGICAL ) :
/*------------------------------------------------------------------------------
  Purpose: set to TRUE if the combo widget is to be sorted.   
Parameters: INPUT pilsort - logical   
  Notes:   
------------------------------------------------------------------------------*/
  {set Sort pilSort}.
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
  &SCOPED-DEFINE ttfield cTempTableNames
  &SCOPED-DEFINE propvalue pcValue
  {&setprop}

  RETURN SUPER(pcValue).

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
  &SCOPED-DEFINE ttfield lUseCache
  &SCOPED-DEFINE propvalue plValue
  {&setprop}

  RETURN SUPER(plValue).

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

