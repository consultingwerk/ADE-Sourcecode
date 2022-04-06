&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*********************************************************************
* Copyright (C) 2005-2008 by Progress Software Corporation. All      *
* rights reserved.  Prior versions of this work may contain portions *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*--------------------------------------------------------------------------
    File        : smart.p
    Purpose     : General Super Procedure for New ADM applications
    Syntax      : adm2/smart.p

    Modified    : July 31, 2000 Version 9.1B
------------------------------------------------------------------------*/
/*          This .p file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/
 
/* ***************************  Definitions  ************************** */

/* Tell smrtattr.i that this is the Super Procedure */
&SCOP ADMSuper smart.p

  {src/adm2/custom/smartexclcustom.i}
  
  /* Define and initialize variables for properties shared by all objects. */
 DEFINE VARIABLE scPassThroughLinks AS CHARACTER NO-UNDO 
   INIT "Data;multiple,Update;single,Filter;single,OutMessage;single,Navigation;single,Commit;single":U.
 DEFINE VARIABLE scCircularLinks    AS CHARACTER NO-UNDO
   INIT "Data":U.
   
  DEFINE VARIABLE gcDataMessages  AS CHARACTER NO-UNDO INIT "":U.
  DEFINE VARIABLE glManageReadErrors  AS LOGICAL NO-UNDO.


DEFINE TEMP-TABLE ADMLink NO-UNDO
  FIELD LinkSource AS HANDLE
  FIELD LinkTarget AS HANDLE
  FIELD LinkType   AS CHARACTER.

/* Class property */
DEFINE VARIABLE glIsCrystalInstalled AS LOGICAL INIT ? NO-UNDO.

DEFINE VARIABLE glIcfIsRunning       AS LOGICAL INITIAL ? NO-UNDO.
def var gcMessageBoxType as character initial ? no-undo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-anyMessage) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD anyMessage Procedure 
FUNCTION anyMessage RETURNS LOGICAL
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-applyFocus) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD applyFocus Procedure 
FUNCTION applyFocus RETURNS LOGICAL
  ( pcField AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-applyFocusToFrame) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD applyFocusToFrame Procedure 
FUNCTION applyFocusToFrame RETURNS LOGICAL
  ( phFrame AS HANDLE,
    pcField AS CHAR,
    pcFrameList AS CHAR,
    pcObjectList AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-assignBufferValueFromReference) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD assignBufferValueFromReference Procedure 
FUNCTION assignBufferValueFromReference RETURNS CHARACTER
  (phBufferField AS HANDLE, 
   pcReference   AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-assignLinkProperty) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD assignLinkProperty Procedure 
FUNCTION assignLinkProperty RETURNS LOGICAL
  ( pcLink AS CHARACTER, pcPropName AS CHARACTER, pcPropValue AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-assignMappedEntry) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD assignMappedEntry Procedure 
FUNCTION assignMappedEntry RETURNS CHARACTER
   (pcEntryNames  AS CHAR,
    pcList        AS CHAR,
    pcEntryValues AS CHAR,
    pcDelimiter   AS CHAR,
    plFirst       AS LOG)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-assignTargetLinkState) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD assignTargetLinkState Procedure 
FUNCTION assignTargetLinkState RETURNS LOGICAL
        ( pcLinkType    as char,
          plActive      as logical,
          plQueryObject as logical ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-changeLinkState) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD changeLinkState Procedure 
FUNCTION changeLinkState RETURNS LOGICAL
  ( pcState  AS CHAR,
    pcLink   AS CHAR, 
    phObject AS HANDLE) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-clearCombo) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD clearCombo Procedure 
FUNCTION clearCombo RETURNS LOGICAL
  ( phField AS HANDLE ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-deleteEntry) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD deleteEntry Procedure 
FUNCTION deleteEntry RETURNS CHARACTER
  ( piEntry  AS INTEGER,
    pcString AS CHARACTER,
    pcDelim  AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-deleteProperties) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD deleteProperties Procedure 
FUNCTION deleteProperties RETURNS LOGICAL ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fetchMessages) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fetchMessages Procedure 
FUNCTION fetchMessages RETURNS CHARACTER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getChildDataKey) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getChildDataKey Procedure 
FUNCTION getChildDataKey RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getClassName) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getClassName Procedure 
FUNCTION getClassName RETURNS CHARACTER
        (  ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getContainerHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getContainerHandle Procedure 
FUNCTION getContainerHandle RETURNS HANDLE
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getContainerHidden) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getContainerHidden Procedure 
FUNCTION getContainerHidden RETURNS LOGICAL
  ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getContainerSource) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getContainerSource Procedure 
FUNCTION getContainerSource RETURNS HANDLE
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getContainerSourceEvents) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getContainerSourceEvents Procedure 
FUNCTION getContainerSourceEvents RETURNS CHARACTER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getContainerType) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getContainerType Procedure 
FUNCTION getContainerType RETURNS CHARACTER
  ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDataLinksEnabled) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getDataLinksEnabled Procedure 
FUNCTION getDataLinksEnabled RETURNS LOGICAL
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDataSource) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getDataSource Procedure 
FUNCTION getDataSource RETURNS HANDLE
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDataSourceEvents) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getDataSourceEvents Procedure 
FUNCTION getDataSourceEvents RETURNS CHARACTER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDataSourceNames) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getDataSourceNames Procedure 
FUNCTION getDataSourceNames RETURNS CHARACTER
  (   )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDataTarget) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getDataTarget Procedure 
FUNCTION getDataTarget RETURNS CHARACTER
  ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDataTargetEvents) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getDataTargetEvents Procedure 
FUNCTION getDataTargetEvents RETURNS CHARACTER
  (   )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDBAware) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getDBAware Procedure 
FUNCTION getDBAware RETURNS LOGICAL
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDesignDataObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getDesignDataObject Procedure 
FUNCTION getDesignDataObject RETURNS CHARACTER
  ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDynamicObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getDynamicObject Procedure 
FUNCTION getDynamicObject RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getHideOnInit) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getHideOnInit Procedure 
FUNCTION getHideOnInit RETURNS LOGICAL
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getInactiveLinks) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getInactiveLinks Procedure 
FUNCTION getInactiveLinks RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getInstanceId) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getInstanceId Procedure 
FUNCTION getInstanceId RETURNS DECIMAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getInstanceProperties) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getInstanceProperties Procedure 
FUNCTION getInstanceProperties RETURNS CHARACTER
  ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getIsCrystalInstalled) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getIsCrystalInstalled Procedure 
FUNCTION getIsCrystalInstalled RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getLabel) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getLabel Procedure 
FUNCTION getLabel RETURNS CHARACTER
   ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getLayoutPosition) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getLayoutPosition Procedure 
FUNCTION getLayoutPosition RETURNS CHARACTER
        (  ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getLogicalObjectName) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getLogicalObjectName Procedure 
FUNCTION getLogicalObjectName RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getLogicalVersion) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getLogicalVersion Procedure 
FUNCTION getLogicalVersion RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getManageReadErrors) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getManageReadErrors Procedure 
FUNCTION getManageReadErrors RETURNS LOGICAL
  (   )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getManagerHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getManagerHandle Procedure 
FUNCTION getManagerHandle RETURNS HANDLE
  ( pcManager AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getMessageBoxType) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getMessageBoxType Procedure 
FUNCTION getMessageBoxType RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getObjectHidden) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getObjectHidden Procedure 
FUNCTION getObjectHidden RETURNS LOGICAL
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getObjectInitialized) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getObjectInitialized Procedure 
FUNCTION getObjectInitialized RETURNS LOGICAL
  ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getObjectName) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getObjectName Procedure 
FUNCTION getObjectName RETURNS CHARACTER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getObjectPage) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getObjectPage Procedure 
FUNCTION getObjectPage RETURNS INTEGER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getObjectParent) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getObjectParent Procedure 
FUNCTION getObjectParent RETURNS HANDLE
  ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getObjectsCreated) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getObjectsCreated Procedure 
FUNCTION getObjectsCreated RETURNS LOGICAL
        (  ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getObjectVersion) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getObjectVersion Procedure 
FUNCTION getObjectVersion RETURNS CHARACTER
  ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getParentDataKey) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getParentDataKey Procedure 
FUNCTION getParentDataKey RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getPassThroughLinks) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getPassThroughLinks Procedure 
FUNCTION getPassThroughLinks RETURNS CHARACTER
  ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getPhysicalObjectName) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getPhysicalObjectName Procedure 
FUNCTION getPhysicalObjectName RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getPhysicalVersion) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getPhysicalVersion Procedure 
FUNCTION getPhysicalVersion RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getPropertyDialog) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getPropertyDialog Procedure 
FUNCTION getPropertyDialog RETURNS CHARACTER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getQueryObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getQueryObject Procedure 
FUNCTION getQueryObject RETURNS LOGICAL
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getRenderingProcedure) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getRenderingProcedure Procedure 
FUNCTION getRenderingProcedure RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getRunAttribute) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getRunAttribute Procedure 
FUNCTION getRunAttribute RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getServiceAdapterName) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getServiceAdapterName Procedure 
FUNCTION getServiceAdapterName RETURNS CHARACTER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getSuperProcedure) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getSuperProcedure Procedure 
FUNCTION getSuperProcedure RETURNS CHARACTER
        (  ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getSuperProcedureHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getSuperProcedureHandle Procedure 
FUNCTION getSuperProcedureHandle RETURNS CHARACTER
        (  ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getSuperProcedureMode) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getSuperProcedureMode Procedure 
FUNCTION getSuperProcedureMode RETURNS CHARACTER
        (  ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getSupportedLinks) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getSupportedLinks Procedure 
FUNCTION getSupportedLinks RETURNS CHARACTER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getThinRenderingProcedure) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getThinRenderingProcedure Procedure 
FUNCTION getThinRenderingProcedure RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getTranslatableProperties) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getTranslatableProperties Procedure 
FUNCTION getTranslatableProperties RETURNS CHARACTER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getUIBMode) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getUIBMode Procedure 
FUNCTION getUIBMode RETURNS CHARACTER
  ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getUseRepository) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getUseRepository Procedure 
FUNCTION getUseRepository RETURNS LOGICAL
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getUserProperty) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getUserProperty Procedure 
FUNCTION getUserProperty RETURNS CHARACTER
  ( pcPropName AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-instanceOf) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD instanceOf Procedure 
FUNCTION instanceOf RETURNS LOGICAL
    ( INPUT pcClass        AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-instancePropertyList) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD instancePropertyList Procedure 
FUNCTION instancePropertyList RETURNS CHARACTER
  ( pcPropList AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-isDialogBoxParent) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD isDialogBoxParent Procedure 
FUNCTION isDialogBoxParent RETURNS LOGICAL
  ( INPUT hWidget AS HANDLE )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-isFunctionInCallStack) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD isFunctionInCallStack Procedure 
FUNCTION isFunctionInCallStack RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-isLinkInactive) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD isLinkInactive Procedure 
FUNCTION isLinkInactive RETURNS LOGICAL
  (pcLinkType AS CHAR,
   phObject   AS HANDLE) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-linkHandles) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD linkHandles Procedure 
FUNCTION linkHandles RETURNS CHARACTER
  ( pcLink AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-linkProperty) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD linkProperty Procedure 
FUNCTION linkProperty RETURNS CHARACTER
  ( pcLink AS CHARACTER, pcPropName AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-mappedEntry) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD mappedEntry Procedure 
FUNCTION mappedEntry RETURNS CHARACTER
  (pcEntry     AS CHAR,
   pcList      AS CHAR,
   plFirst     AS LOG,
   pcDelimiter AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-mergeLists) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD mergeLists Procedure 
FUNCTION mergeLists RETURNS CHARACTER
  ( pcList1     AS CHAR,
    pcList2     AS CHAR,
    pcDlm1      AS CHAR,
    pcDlm2      AS CHAR,
    pcNewDlm    AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-messageNumber) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD messageNumber Procedure 
FUNCTION messageNumber RETURNS CHARACTER
  ( piMessage AS INTEGER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-modifyInactiveLinks) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD modifyInactiveLinks Procedure 
FUNCTION modifyInactiveLinks RETURNS LOGICAL
  ( pcMode     AS CHAR,
    pcLinkType AS CHAR,
    phObject   AS HANDLE)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-propertyType) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD propertyType Procedure 
FUNCTION propertyType RETURNS CHARACTER
  ( pcPropName AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-reviewMessages) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD reviewMessages Procedure 
FUNCTION reviewMessages RETURNS CHARACTER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setChildDataKey) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setChildDataKey Procedure 
FUNCTION setChildDataKey RETURNS LOGICAL
  ( cChildDataKey AS CHARACTER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setClassName) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setClassName Procedure 
FUNCTION setClassName RETURNS LOGICAL
        ( INPUT pcClassName        AS CHARACTER ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setContainerHidden) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setContainerHidden Procedure 
FUNCTION setContainerHidden RETURNS LOGICAL
  ( plHidden AS LOGICAL )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setContainerSource) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setContainerSource Procedure 
FUNCTION setContainerSource RETURNS LOGICAL
  ( phObject AS HANDLE )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setContainerSourceEvents) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setContainerSourceEvents Procedure 
FUNCTION setContainerSourceEvents RETURNS LOGICAL
  ( pcEvents AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setDataLinksEnabled) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setDataLinksEnabled Procedure 
FUNCTION setDataLinksEnabled RETURNS LOGICAL
  ( lDataLinksEnabled AS LOGICAL )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setDataSource) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setDataSource Procedure 
FUNCTION setDataSource RETURNS LOGICAL
  ( phObject AS HANDLE )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setDataSourceEvents) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setDataSourceEvents Procedure 
FUNCTION setDataSourceEvents RETURNS LOGICAL
  ( pcEventsList AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setDataSourceNames) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setDataSourceNames Procedure 
FUNCTION setDataSourceNames RETURNS LOGICAL
  ( pcSourceNames AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setDataTarget) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setDataTarget Procedure 
FUNCTION setDataTarget RETURNS LOGICAL
  ( pcTarget AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setDataTargetEvents) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setDataTargetEvents Procedure 
FUNCTION setDataTargetEvents RETURNS LOGICAL
  ( pcEvents AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setDBAware) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setDBAware Procedure 
FUNCTION setDBAware RETURNS LOGICAL
  ( lAware AS LOGICAL )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setDesignDataObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setDesignDataObject Procedure 
FUNCTION setDesignDataObject RETURNS LOGICAL
  ( pcDataObject AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setDynamicObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setDynamicObject Procedure 
FUNCTION setDynamicObject RETURNS LOGICAL
  ( lTemp AS LOGICAL )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setHideOnInit) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setHideOnInit Procedure 
FUNCTION setHideOnInit RETURNS LOGICAL
  ( plHideOnInit AS LOGICAL )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setInactiveLinks) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setInactiveLinks Procedure 
FUNCTION setInactiveLinks RETURNS LOGICAL
  ( pcInactiveLinks AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setInstanceId) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setInstanceId Procedure 
FUNCTION setInstanceId RETURNS LOGICAL
  ( pdInstanceId AS DECIMAL )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setInstanceProperties) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setInstanceProperties Procedure 
FUNCTION setInstanceProperties RETURNS LOGICAL
  ( pcPropList AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setLabel) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setLabel Procedure 
FUNCTION setLabel RETURNS LOGICAL
  (pcLabel AS CHARACTER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setLayoutPosition) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setLayoutPosition Procedure 
FUNCTION setLayoutPosition RETURNS LOGICAL
        ( INPUT pcLayoutPosition                AS CHARACTER ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setLogicalObjectName) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setLogicalObjectName Procedure 
FUNCTION setLogicalObjectName RETURNS LOGICAL
  ( cName AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setLogicalVersion) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setLogicalVersion Procedure 
FUNCTION setLogicalVersion RETURNS LOGICAL
  ( cVersion AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setManageReadErrors) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setManageReadErrors Procedure 
FUNCTION setManageReadErrors RETURNS LOGICAL
  (plManageReadErrors AS LOGICAL )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setMessageBoxType) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setMessageBoxType Procedure 
FUNCTION setMessageBoxType RETURNS LOGICAL
        ( input pcMessageBoxType as character ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setObjectHidden) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setObjectHidden Procedure 
FUNCTION setObjectHidden RETURNS LOGICAL
  ( plHidden AS LOGICAL )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setObjectName) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setObjectName Procedure 
FUNCTION setObjectName RETURNS LOGICAL
  ( pcName AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setObjectParent) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setObjectParent Procedure 
FUNCTION setObjectParent RETURNS LOGICAL
  ( phParent AS HANDLE )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setObjectsCreated) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setObjectsCreated Procedure 
FUNCTION setObjectsCreated RETURNS LOGICAL
  ( plCreated AS LOGICAL )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setObjectVersion) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setObjectVersion Procedure 
FUNCTION setObjectVersion RETURNS LOGICAL
  ( cObjectVersion AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setParentDataKey) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setParentDataKey Procedure 
FUNCTION setParentDataKey RETURNS LOGICAL
  ( cParentDataKey AS CHARACTER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setPassThroughLinks) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setPassThroughLinks Procedure 
FUNCTION setPassThroughLinks RETURNS LOGICAL
  ( pcLinks AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setPhysicalObjectName) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setPhysicalObjectName Procedure 
FUNCTION setPhysicalObjectName RETURNS LOGICAL
  ( cTemp AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setPhysicalVersion) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setPhysicalVersion Procedure 
FUNCTION setPhysicalVersion RETURNS LOGICAL
  ( cVersion AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setRenderingProcedure) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setRenderingProcedure Procedure 
FUNCTION setRenderingProcedure RETURNS LOGICAL
  ( cProcedure AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setRunAttribute) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setRunAttribute Procedure 
FUNCTION setRunAttribute RETURNS LOGICAL
  ( cRunAttribute AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setSuperProcedure) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setSuperProcedure Procedure 
FUNCTION setSuperProcedure RETURNS LOGICAL
        ( INPUT pcSuperProcedure                AS CHARACTER ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setSuperProcedureHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setSuperProcedureHandle Procedure 
FUNCTION setSuperProcedureHandle RETURNS LOGICAL
        ( INPUT pcProcedureHandle       AS CHARACTER  ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setSuperProcedureMode) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setSuperProcedureMode Procedure 
FUNCTION setSuperProcedureMode RETURNS LOGICAL
        ( INPUT pcProcedureMode         AS CHARACTER ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setSupportedLinks) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setSupportedLinks Procedure 
FUNCTION setSupportedLinks RETURNS LOGICAL
  ( pcLinkList AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setThinRenderingProcedure) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setThinRenderingProcedure Procedure 
FUNCTION setThinRenderingProcedure RETURNS LOGICAL
  ( cProcedure AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setTranslatableProperties) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setTranslatableProperties Procedure 
FUNCTION setTranslatableProperties RETURNS LOGICAL
  ( pcPropList AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setUIBMode) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setUIBMode Procedure 
FUNCTION setUIBMode RETURNS LOGICAL
  ( pcMode AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setUserProperty) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setUserProperty Procedure 
FUNCTION setUserProperty RETURNS LOGICAL
  ( pcPropName AS CHARACTER, pcPropValue AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-showDataMessages) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD showDataMessages Procedure 
FUNCTION showDataMessages RETURNS CHARACTER
  ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-showmessage) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD showmessage Procedure 
FUNCTION showmessage RETURNS LOGICAL
  ( pcMessage AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-signature) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD signature Procedure 
FUNCTION signature RETURNS CHARACTER
  ( pcName AS CHARACTER )  FORWARD.

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
         HEIGHT             = 12.05
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB Procedure 
/* ************************* Included-Libraries *********************** */

{src/adm2/smrtprop.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-addLink) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE addLink Procedure 
PROCEDURE addLink :
/*------------------------------------------------------------------------------
  Purpose:     Adds a link between two objects by setting property values 
               in each.
  Parameters:  INPUT phSource AS HANDLE -- source procedure handle, 
               INPUT pcLink   AS CHARACTER  -- link name, 
               INPUT phTarget AS HANDLE -- target procedure handle
  Notes:       If the link is not in the SupportedLinks list for either object,
               then the link name will be treated as a single 
               subscription in the "Target" for an event in the "Source".
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER phSource     AS HANDLE    NO-UNDO.
  DEFINE INPUT PARAMETER pcLink       AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER phTarget     AS HANDLE    NO-UNDO.
  
  DEFINE VARIABLE cEvents       AS CHARACTER NO-UNDO.
  DEFINE VARIABLE iEntry        AS INTEGER   NO-UNDO.
  DEFINE VARIABLE iEvent        AS INTEGER   NO-UNDO.
  DEFINE VARIABLE cObject       AS CHARACTER NO-UNDO.
  DEFINE VARIABLE hObject       AS HANDLE    NO-UNDO.
  DEFINE VARIABLE cTargets      AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cSources      AS CHARACTER NO-UNDO.
  DEFINE VARIABLE hTarget       AS HANDLE    NO-UNDO.
  DEFINE VARIABLE cType         AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cNumTargs     AS CHARACTER NO-UNDO.
  DEFINE VARIABLE iLink         AS INTEGER   NO-UNDO.
  DEFINE VARIABLE hSrcContainer AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hTrgContainer AS HANDLE    NO-UNDO.
  
  /* A container link is not a true link, so simplify logic and skip pass-thru 
     logic to improve performance (only measurable with very many objects..) */  
  IF pcLink = 'Container':U THEN
  DO:
    {set ContainerSource phSource phTarget}.
    {get ContainerTarget cTargets phSource}.
    /* This works also if cTargets = ? */   
    cTargets = (IF cTargets > '':U THEN cTargets + ',':U ELSE '':U)
             + STRING(phTarget).                 
    {set ContainerTarget cTargets phSource}.
  END.
  ELSE DO:
  
    /* For a "PageN" link, where the name of the link as passed to addLink is
       "PAGE" plus a page number, add that as a '|'-delimited string to the
       PageNTarget property in the Source (the Container). Don't do anything
       in the Target because PageNSource would always be the ContainerSource. */
    IF pcLink BEGINS "PAGE":U AND pcLink NE "PAGE":U  THEN  /* It's "PageN" */                                
      RUN modifyListProperty (phSource, 'ADD':U, "PageNTarget":U, 
        STRING(phTarget) + "|":U + SUBSTR(pcLink,5)).
    ELSE DO:
      DO iLink = 1 TO NUM-ENTRIES(scPassThroughLinks):
        /* passthrough links are stored as link;single/multiple */
        IF ENTRY(1, ENTRY(iLink, scPassThroughLinks), ";":U) = pcLink THEN
          cNumTargs = ENTRY(2, ENTRY(iLink, scPassThroughLinks), ";":U).
      END.   /* END DO iLink */
      IF cNumTargs NE "":U THEN      /* we found a pass-through link */    
      DO:
        /* If this is a pass-through link type then look for a matching link. 
           Do this only if the object in the "middle" of the potential 
           pass-through is a container such as a Window or Frame. */
        {get ContainerType cType phSource}.
        IF cType NE "":U THEN
        DO:
          /* First, if my Source has a Source of its own for the same link type,
             then change my Source to that one. Leave the existing link in place,
             IF the link type supports multiple targets. */ 
          hObject = dynamic-function("get":U + pcLink + "Source":U IN phSource)
             NO-ERROR.
          IF VALID-HANDLE(hObject) THEN
          DO: 
            /* Make sure the new Source is inside phSource 
               OR that phTarget is inside phSource  
               to ensure that we don't do a 'pass-by' which may happen 
               with an SBO or if the source is not a real container  */                   
            {get ContainerSource hSrcContainer hObject}. 
            {get ContainerSource hTrgContainer phTarget}. 
  
            IF hSrcContainer = phSource OR hTrgContainer = phSource THEN
            DO: 
              IF cNumTargs = "single":U THEN
               /* Link supports only one target; so don't keep the "intermediate"
                  link that goes to the container. */
                 RUN removeLink(hObject, pcLink, phSource).
               /* set up to modify the new link in any case. */
              phSource = hObject.
            END. /* hContainer = phsource */
          END. /* END DO IF VALID-HANDLE(hObject) */         
        END.   /* END if phSource is a Container */      
        /* Allow for the possibility that both the source and target of a 
           pass-through link may be containers; check both and replace both
           if appropriate. 9.1A -- 99-04-01-016 */
        {get ContainerType cType phTarget}.
        IF cType NE "":U THEN
        DO:
          /* If my target has target(s) of the same link type, then I want to
             remove it/them and add a new link to my Source. */
          cTargets = dynamic-function("get":U + pcLink + "Target":U IN phTarget)
            NO-ERROR.
          IF cTargets NE ? AND cTargets NE "":U THEN    
          DO:  /* If the target has this link type at all */
              
            DO iEntry = 1 TO NUM-ENTRIES(cTargets):  /* if there are any */
              hTarget = WIDGET-HANDLE(ENTRY(iEntry, cTargets)).
             /* Make sure the new Target is inside the phtarget
                OR phSource is inside phTarget and not on the 
                to ensure that we don't do a 'pass-by' which may happen 
                with an SBO or if the source is not a real container  */                   
              {get ContainerSource hTrgContainer hTarget}. 
              {get ContainerSource hSrcContainer phSource}. 
              IF hTrgContainer = phTarget OR hSrcContainer = phTarget THEN
              DO:
                RUN removeLink (phTarget, pcLink, hTarget).
                RUN addLink (phSource, pcLink, hTarget).
              END.
            END.  /* END DO iEntry */
            /* if this link type supports multiple Targets, then go ahead
               and add the link to the container in case it;s wanted;
               otherwise just return, */
            IF cNumTargs = "single":U THEN
              RETURN.   /* Since we did the altered addLink(s), we're done. */
          END.  /* END DO IF cTargets */
        END.    /* END IF cTYPE (phTarget is a Container) */
      END.        /* END pass-through code */
      
      /* If this isn't a recognized link, just do a single subscription 
         of the name. Do this only if neither side supports the link. */
      {get SupportedLinks cSources phSource}.
      {get SupportedLinks cTargets phTarget}.
  
      IF (pcLink NE "Container":U AND NOT pcLink BEGINS "Page":U) AND
         (LOOKUP(pcLink + "-Source":U, cSources) = 0 AND
          LOOKUP(pcLink + "-Target":U, cTargets) = 0) THEN
      DO:
           SUBSCRIBE PROCEDURE phTarget TO pcLink IN phSource.
           /* Because there are no "Source" and "Target" properties for
              these "dynamic" links, we need to store the handles where
              the linkHandles function will be able to get at them later,
              if needed. */
           RUN modifyUserLinks IN phSource ('ADD':U, pcLink + "-Target":U,
             phTarget).
           RUN modifyUserLinks IN phTarget ('ADD':U, pcLink + "-Source":U,
             phSource).  
           RETURN.
      END.   /* END DO for non-Supported Link */
      
      /* All the remaining code is for Supported Links. */
      
      /* Whether we found a pass-through or not, continue with the current link */
      /* NOTE: This will fail w/o error if the property isn't defined.*/
      /* Although standard SmartLinks permit a single Source and multiple
         Targets, check to see whether this link does. A single Source or
         Target is stored as a handle, multiple Sources or Targets as a
         list in Character form. */
      IF dynamic-function('propertyType':U IN phTarget, pcLink + "Source":U) 
       = "CHARACTER":U THEN 
         RUN modifyListProperty 
          (phTarget, 'ADD':U, pcLink + "Source":U, STRING(phSource)).
      
      ELSE DO:
        IF dynamic-function("get":U + pcLink + "Source":U IN phTarget) = ? THEN
          dynamic-function("set":U + pcLink + "Source":U IN phTarget,phSource) 
             NO-ERROR.    
        ELSE DO:
          showMessage(SUBSTITUTE({fnarg messageNumber 79}, phTarget:FILE-NAME, pcLink)).
          RETURN.
        END.   /* END DO IF Not Unknown */
      END.     /* END ELSE DO (if Not CHARACTER) */
      
      IF dynamic-function('propertyType':U IN phSource, pcLink + "Target":U) 
       = "CHARACTER":U THEN
        RUN modifyListProperty 
          (phSource, 'ADD':U, pcLink + "Target":U, STRING(phTarget)).
      ELSE DO:
        IF dynamic-function("get":U + pcLink + "Target":U IN phSource) = ? THEN
          dynamic-function("set":U + pcLink + "Target":U IN phSource, 
            phTarget) NO-ERROR.    
        ELSE DO:
          showMessage(SUBSTITUTE({fnarg messageNumber 80}, phSource:FILE-NAME, pcLink)).
          RETURN.
        END.   /* END DO IF Not Unknown */
      END.     /* END ELSE DO (if Not CHARACTER) */
          
    END.       /* END ELSE DO for normal (non-pageN) link processing */
  END. /* pcLink <> 'Container' */
  
  /* SUBSCRIBE to all the appropriate events on each side of the link. 
     First SUBSCRIBE the target to all the events it says it wants
     from its source. */
  RUN linkStateHandler IN phTarget ('Add':U,
                                    phSource,
                                    pcLink + "Source":U).
                   
  /* Then SUBSCRIBE the source to all the events (if any) that it wants
     from its target. */
  RUN linkStateHandler IN phSource ('Add':U,
                                    phTarget,
                                    pcLink + "Target":U).         
  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-addMessage) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE addMessage Procedure 
PROCEDURE addMessage :
/*------------------------------------------------------------------------------
  Purpose:  Inserts the message text into a data message log along with its
            Field, and Table if known.
   Params:  INPUT pcText AS CHARACTER -- Text of the message; 
            INPUT pcField AS CHARACTER --  the field name for which the message
               occurred, if it was related to a specific field;
            INPUT pcTable AS CHARACTER --  the database table for which the 
               message occurred, if it was related to an update to a database 
               table.
    Notes:  If pcText is unknown (?), that signals 
              that this function should retrieve messages from the 
              error-status handle. 
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pcText  AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER pcField AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER pcTable AS CHARACTER NO-UNDO.
  
  DEFINE VARIABLE iMsg     AS INTEGER   NO-UNDO.
  DEFINE VARIABLE iMsgCnt  AS INTEGER   NO-UNDO.
  DEFINE VARIABLE cMessage AS CHARACTER NO-UNDO.
  
  /* If one or more "raw" messages were passed (i.e., they are already in
     the delimited formatted created below), then these were returned from
     an AppServer object or other remote object. Just append them to any local
     messages. */
 
  IF pcText NE ? AND INDEX(pcText, CHR(4)) NE 0 THEN
    ASSIGN gcDataMessages = gcDataMessages +
      (IF gcDataMessages NE "":U THEN CHR(3) ELSE "":U) +
      pcText.
      
  ELSE DO:
    
    /* If there's no message passed, this means that a Progress ERROR-STATUS
       was detected, so we add a row for each of those messages. */
   
    iMsgCnt = IF pcText = ? THEN ERROR-STATUS:NUM-MESSAGES ELSE 1.
  
       
    DO iMsg = 1 TO iMsgCnt:
      IF pcText = ? THEN
      DO:
      /* When logging ERROR-STATUS messages, remove any which directly 
         reference the BUFFER-FIELD attribute; these errors are side-effects
         of other assignment errors which should be reported to the user
         instead. */
        cMessage = ERROR-STATUS:GET-MESSAGE(iMsg).
        IF INDEX(cMessage, 'BUFFER-FIELD':U) NE 0 THEN NEXT.
      END. /* END DO IF pcText = ? */
      ASSIGN gcDataMessages = gcDataMessages +
             (IF gcDataMessages NE "":U THEN CHR(3) ELSE "":U) +
             (IF pcText = ? THEN cMessage ELSE pcText)
             + CHR(4) + (IF pcField = ? THEN "":U ELSE pcField)
             + CHR(4) + (IF pcTable = ? THEN "":U ELSE pcTable).
    END.   /* END DO iMsg */
  END.     /* END ELSE DO */
  
  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-addServerError) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE addServerError Procedure 
PROCEDURE addServerError :
/*------------------------------------------------------------------------------
    Purpose: Adds server ERROR to the message stack. 
             This is only used for unexpected ERRORs returned from the 
             Service Adapter, not normal save or query exceptions/errors.              
    Parameters: pcEvent - 'DEFINE'
                        - 'RETRIEVE' 
                        - 'SUBMIT' 
                pcMessage - error message (service adapterreturn-value)  
                          - ? or blank use error-status
                pcEntities - requested entities/objects/tables                  
    Notes: This is only used for applications that uses datasviews and 
           service adpaters to manage all data requests
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcEvent   AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pcMessage AS CHARACTER  NO-UNDO.  
  DEFINE INPUT  PARAMETER pcEntities AS CHARACTER  NO-UNDO. 
  
  DEFINE VARIABLE cHeader  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iMessage AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iError   AS INTEGER    NO-UNDO.
  
  IF pcMessage = ? OR pcMessage = "" THEN 
  DO iError = 1 TO ERROR-STATUS:NUM-MESSAGES: 
    pcMessage = pcMessage 
              + (IF iError = 1 THEN "" ELSE "~n")
              + ERROR-STATUS:GET-MESSAGE(iError).   
  END.
  
  CASE pcEvent:
    WHEN 'define' THEN iMessage = 98.
    WHEN 'retrieve' THEN iMessage = 99.
    WHEN 'submit' THEN iMessage = 100.    
  END.  
  
  IF iMessage > 0 THEN 
  DO:
    cHeader = SUBSTITUTE({fnarg messageNumber iMessage},pcEntities).
    RUN addMessage IN TARGET-PROCEDURE(cHeader,?,?).
  END.    
  RUN addMessage IN TARGET-PROCEDURE(pcMessage,?,?).  
  RETURN.   
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-addServerReadError) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE addServerReadError Procedure 
PROCEDURE addServerReadError :
/*------------------------------------------------------------------------------
    Purpose: Adds server ERROR to the message stack on the client. 
             This is used by the container for unexpected ERRORs returned from
             the Appserver. (record not found )              
    Parameters:  pcMessage - error message (service adapterreturn-value)  
                           - 'ERROR', ? or blank use default message
                           
    Notes: This is used for applications that uses SDOs.           
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcMessage AS CHARACTER  NO-UNDO.  
  
  RUN addMessage IN TARGET-PROCEDURE({fnarg messageNumber 102},?,?).

  IF pcMessage = ? OR pcMessage = "" THEN 
    RUN addMessage IN TARGET-PROCEDURE({fnarg messageNumber 103},?,?).
  ELSE 
    RUN addMessage IN TARGET-PROCEDURE(pcMessage,?,?).  
  RETURN.   
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-adjustTabOrder) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adjustTabOrder Procedure 
PROCEDURE adjustTabOrder :
/*------------------------------------------------------------------------------
  Purpose:     Changes the tab order of SmartObjects
  Parameters:  INPUT phObject AS HANDLE -- handle of the smart object
               INPUT phAnchor AS HANDLE -- handle of either another smartobject 
                 procedure or a widget-handle of the object that will 
                 anchor the smartobject
               INPUT pcPosition AS CHARACTER -- 
                 "After" if smartobject is moved-after the anchor
                 "Before" if smartobject is moved-before anchor
  
  Notes:       adjustTabOrder calls are generated by the AppBuilder in 
               adm-create-objects 
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER phObject   AS HANDLE    NO-UNDO.
  DEFINE INPUT PARAMETER phAnchor   AS HANDLE    NO-UNDO.
  DEFINE INPUT PARAMETER pcPosition AS CHARACTER NO-UNDO.
  
  DEFINE VARIABLE hContainer AS HANDLE NO-UNDO.
  
  /* Get widget handle of phObject */
  {get ContainerHandle hContainer phObject}.
  IF NOT VALID-HANDLE(hContainer) THEN 
    RETURN "ADM-ERROR":U. 
  
  /* If phAnchor is smart-object procedure handle, get its object-handle */
  IF phAnchor:TYPE = "PROCEDURE":U THEN DO:
    {get ContainerHandle phAnchor phAnchor}.
    IF NOT VALID-HANDLE(phAnchor) THEN 
      RETURN "ADM-ERROR":U. 
  END.
  
  /* Check that the two handle have the same parent */
  IF hContainer:PARENT NE phAnchor:PARENT THEN 
    RETURN "ADM-ERROR":U. 
  
  IF pcPosition = "BEFORE":U THEN hContainer:MOVE-BEFORE(phAnchor).
                             ELSE hContainer:MOVE-AFTER(phAnchor).
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-applyEntry) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE applyEntry Procedure 
PROCEDURE applyEntry :
/*------------------------------------------------------------------------------
  Purpose:     Applies "ENTRY" to the first enabled and visible object 
               in the default frame (unless pcField is specified), 
               or in the first child which is a Frame.
  Parameters:  INPUT pcField AS CHARACTER -- optional fieldname; if specified,
               (if this parameter is not blank or unknown), then
               the frame field of that name will be positioned to. 
       Notes:             
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcField AS CHARACTER NO-UNDO.
  
  {fnarg applyFocus pcField}.
  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-changeCursor) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE changeCursor Procedure 
PROCEDURE changeCursor :
/*------------------------------------------------------------------------------
  Purpose:  Sets the cursor on all windows and on any dialog box frames 
            that are currently on the screen.   
  Parameters: INPUT pcCursor AS CHARACTER -- name of cursor to use.  
                This should be either "WAIT" or "".
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER pcCursor AS CHARACTER NO-UNDO.
  
&IF "{&WINDOW-SYSTEM}":U ne "TTY":U &THEN
   /* Set the Wait state, which changes the cursor automatically */
   SESSION:SET-WAIT-STATE(IF pcCursor = "WAIT":U THEN "GENERAL":U ELSE "":U).
&ENDIF
 
  RETURN.   
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-createControls) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE createControls Procedure 
PROCEDURE createControls :
/*------------------------------------------------------------------------------
  Purpose:     Default action for SmartObject-specific initialization of
               ActiveX Controls. Runs adm-create-controls, an AppBuilder-
               generated procedure.
  Parameters:  <none>
  Notes:       A localization of this behavior should be placed in a procedure
               called createControls in the SmartObject. The V8-style name
               adm-create-controls for the standard behavior is maintained
               in order to allow a localization in the same procedure file.
------------------------------------------------------------------------------*/

  RUN adm-create-controls IN TARGET-PROCEDURE NO-ERROR.
  RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-destroyObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE destroyObject Procedure 
PROCEDURE destroyObject :
/*------------------------------------------------------------------------------
  Purpose:     Cleans up and deletes the current object procedure
               and its descendents, if any.
  Parameters:  <none>
       Notes:  Checks first to see if any object is not prepared to be
               destroyed (e.g., if DataModified is set).
------------------------------------------------------------------------------*/    
  DEFINE VARIABLE hSource       AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hParent       AS HANDLE     NO-UNDO.
  DEFINE VARIABLE lCancel       AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lUseRepos     AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cSourceEvents AS CHARACTER  NO-UNDO.
  
  &SCOPED-DEFINE xp-assign
  {get ContainerSource hSource}
  {get ContainerSourceEvents cSourceEvents}
  . 
  &UNDEFINE xp-assign
  
  /* It is too late to stop destroy when published from the container source. 
     confirmExit is published down the container link chain. In order to only 
     publish from the top and not again further down the chain, only publish 
     if this event is NOT published from the ContainerSource or if not 
     subscribed to the event (the last is rather unlikely, but is for backwards
     compatibilty with the old unconditional publish ensuring that the event 
     reaches subscribers that do not use the containersource subscription) */
  IF hSource <> SOURCE-PROCEDURE 
  OR LOOKUP('confirmExit':U,cSourceEvents) = 0 THEN 
  DO:
    PUBLISH 'confirmExit':U FROM TARGET-PROCEDURE (INPUT-OUTPUT lCancel).
    /* Any message will already have been displayed if Cancel is true.
       Main window close trigger will return no-apply based on check 
       of error or return-value */
    IF lCancel THEN    
      RETURN ERROR "ADM-ERROR":U.
  END.

  /* Hide objects where applicable before destroying contents.  */
  RUN hideObject IN TARGET-PROCEDURE.
  
  PUBLISH 'destroyObject':U FROM TARGET-PROCEDURE. /* Destroy descendents */
  
  /* If we close a subwindow in character mode, we need to explicitly
     re-view its parent. */
  &IF "{&WINDOW-SYSTEM}":U = "TTY":U &THEN
      IF CAN-DO('*Window*':U,TARGET-PROCEDURE:TYPE) THEN
      DO:
          hParent = WIDGET-HANDLE(DYNAMIC-FUNCTION
            ("linkProperty":U IN TARGET-PROCEDURE,
                "CONTAINER-SOURCE":U, "ContainerHandle":U)).
          IF VALID-HANDLE(hParent) AND VALID-HANDLE(hSource) THEN
            RUN viewObject IN hSource.
      END.  
  &ENDIF
  RUN removeAllLinks IN TARGET-PROCEDURE.
  {get UseRepository lUseRepos}.
  /* clone the repos admprops into a static one in the static object's 
     widget-pool so it lives to be referenced after super in destroyObject
     overrides */ 
  IF lUseRepos THEN
  DO:
    RUN adm-clone-props IN TARGET-PROCEDURE NO-ERROR.
    ASSIGN ERROR-STATUS:ERROR = NO.
  END.
  
  RUN disable_UI IN TARGET-PROCEDURE.

  RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-displayLinks) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE displayLinks Procedure 
PROCEDURE displayLinks :
/*------------------------------------------------------------------------------
  Purpose:     Utility procedure to put up a dialog showing all the ADM
               links for a given container object.
  Parameters:  <none>
  Notes:       Can be executed by selecting displayLinks from the ProTools
               procedure object viewer for the desired SmartContainer.
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hContainer AS HANDLE NO-UNDO.
  DEFINE VARIABLE Radio-Sort AS CHARACTER  LABEL "Sort By" INIT "Type":U   
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Type", "Type":U,
          "Source", "Source":U,
          "Target", "Target":U
     SIZE 32 BY 1 NO-UNDO.

  DEFINE BUTTON Btn_OK AUTO-GO 
     LABEL "OK" 
     SIZE 12 BY 1.08
     BGCOLOR 8 .

  /* Query definitions                                */
  DEFINE QUERY BROWSE-1 FOR 
      ADMLink SCROLLING.

&SCOP OPEN-QUERY-BROWSE-1 OPEN QUERY BROWSE-1 FOR EACH ADMLink ~
  BY IF Radio-Sort = "Type":U THEN linkType ~
  ELSE IF Radio-Sort = "Source":U THEN linkSource:file-name ~
  ELSE linkTarget:file-name.


/* Browse definitions                                */
  DEFINE BROWSE BROWSE-1
  QUERY BROWSE-1 NO-LOCK DISPLAY
    linkType label "Type" Format "X(12)":U
    LC(linkSource:FILE-NAME) label "Source" Format "X(35)":U
    LC(linkTarget:FILE-NAME) label "Target" Format "X(35)":U
    WITH NO-ROW-MARKERS SEPARATORS SIZE 87 BY 9.2.

  DEFINE FRAME Dialog-Frame
     Radio-Sort AT ROW 1.5 COL 30
     Btn_OK AT ROW 13 COL 32
     BROWSE-1 AT ROW 3 COL 3 SPACE(2)
     SPACE(3) SKIP(1)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         TITLE "ADM Links".
         
  ON VALUE-CHANGED OF Radio-Sort 
  DO:
    ASSIGN Radio-Sort.
    {&OPEN-QUERY-BROWSE-1}
  END.
      
  ENABLE Radio-Sort BROWSE-1   Btn_OK   
      WITH FRAME Dialog-Frame.

  EMPTY TEMP-TABLE ADMLink.

  RUN oneObjectLinks (TARGET-PROCEDURE).
  
  {&OPEN-QUERY-BROWSE-1} 

  WAIT-FOR GO OF FRAME Dialog-Frame.
 
                                          
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-editInstanceProperties) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE editInstanceProperties Procedure 
PROCEDURE editInstanceProperties :
/* -----------------------------------------------------------------------------
      Purpose:    Runs the dialog to get runtime property settings
      Parameters:  <none>
      Notes:       Generally run by the AppBuilder in design mode.
 -----------------------------------------------------------------------------*/

  DEFINE VARIABLE cDialog AS CHARACTER NO-UNDO.

  {get PropertyDialog cDialog}.
  RUN VALUE(cDialog) (INPUT TARGET-PROCEDURE) NO-ERROR.
  IF ERROR-STATUS:ERROR THEN
    showMessage 
      ({fnarg messageNumber 81}).
      
  RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-exitObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE exitObject Procedure 
PROCEDURE exitObject :
/* -----------------------------------------------------------------------------
      Purpose: Passes an exit request to its container    
      Parameters:  <none>
      Notes:  The convention is that the standard routine always
          passes an exit request to its CONTAINER-SOURCE. The container 
          that is actually able to initiate the exit should define
          a local version and *not* call the standard one.    
          That local "exitObject" is built into the SmartWindow template.
    --------------------------------------------------------------------------*/

  PUBLISH 'exitObject':U FROM TARGET-PROCEDURE. /* NOTE: MUST go to Container-Source */
     
  RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-hideObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE hideObject Procedure 
PROCEDURE hideObject :
/*------------------------------------------------------------------------------
  Purpose:     Hides the current object.
  Parameters:  none
  Notes:       "Hide" is a logical concept here; non-visual objects may also be
               "hidden", meaning that they are not currently active; this may
               affect whether code in some subscribe procedures is executed.
------------------------------------------------------------------------------*/

  DEFINE VARIABLE hContainer      AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hFrame          AS HANDLE    NO-UNDO.
  DEFINE VARIABLE cType           AS CHARACTER NO-UNDO.
  
  &SCOPED-DEFINE xp-assign
  {get ContainerHandle hContainer}
  {set ObjectHidden yes}
  {get containerType cType}.
  &UNDEFINE xp-assign
  
  IF VALID-HANDLE(hContainer) THEN
  &IF "{&WINDOW-SYSTEM}":U = "TTY":U &THEN
       IF hContainer:TYPE EQ "WINDOW" THEN DO: /* Can't hide TTY window, */
         hFrame = hContainer:FIRST-CHILD.
         IF VALID-HANDLE(hFrame) THEN
           HIDE hFrame NO-PAUSE.               /* so hide the contents.  */
       END.
       ELSE
  &ENDIF
         ASSIGN hContainer:HIDDEN = YES.
  
  RUN returnFocus IN TARGET-PROCEDURE (TARGET-PROCEDURE:HANDLE).     

  IF cType NE "":U THEN
    /* We don't need to physically hide the SmartObjects in this Container -
       they will disappear when it is hidden - but we need to tell them that
       they are part of a hidden Container so that they can set links
       and other states dependent on HIDDEN accordingly. */
    dynamic-function("assignLinkProperty":U In TARGET-PROCEDURE,
      "Container-Target":U, "ContainerHidden":U, "yes":U).
      
  /* For those objects which want to "deactivate" a link when an object is
     hidden, we tell them that this object is 'inactive'. We also set the
     ObjectActive property to hold onto the state for future inquiries. */
  PUBLISH 'LinkState':U FROM TARGET-PROCEDURE ('inactive':U).
  
  RETURN.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-initializeObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeObject Procedure 
PROCEDURE initializeObject :
/*------------------------------------------------------------------------------
  Purpose:  Performs general initialization common to all objects.
   Params:  <none>
    Notes:  There is a version of initializeObject in virtually every Super
            procedure; each performs the initialization appropriate to that
            class of objects. 
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cSource          AS CHARACTER NO-UNDO.
  DEFINE VARIABLE hContainer       AS HANDLE    NO-UNDO.
  DEFINE VARIABLE lInitialized     AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE cNewRecord       AS CHARACTER NO-UNDO.
  DEFINE VARIABLE lHideOnInit      AS LOGICAL   NO-UNDO.

  {get ObjectInitialized lInitialized}.
  IF lInitialized THEN 
    RETURN "ADM-ERROR":U.  /* Just get out if already initialized. */

  /* Initialize any OCX's in the SmartObjects. */
  RUN createControls IN TARGET-PROCEDURE NO-ERROR.
  RUN control_load IN TARGET-PROCEDURE NO-ERROR.

  /* If this object has no visualization, we still need to run viewObject unless
     the hideOninit is true. view and hide is a logical state that also is used
     to indicate whether an object is active.
     Visual objects does this in its initilizeObject override AFTER enable  */
  &SCOPED-DEFINE xp-assign
  {get ContainerHandle hContainer}
  {set ObjectInitialized yes}.
  &UNDEFINE xp-assign
  
  IF NOT VALID-HANDLE (hContainer) THEN 
  DO:
    {get HideOnInit lHideOnInit}.
    IF NOT lHideOnInit THEN 
      RUN viewObject IN TARGET-PROCEDURE.
    ELSE 
      PUBLISH "LinkState":U FROM TARGET-PROCEDURE ('inactive':U).  
  END.

  RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-linkStateHandler) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE linkStateHandler Procedure 
PROCEDURE linkStateHandler :
/*------------------------------------------------------------------------------
  Purpose: Handler for the LinkState event, also used by addlink and removeLink,           
           Subscribes/unsubscribes to the <link>events in the object   
Parameter: pcState  - 'Add'      - activate newly added links by subscribing to 
                                   the <Link>Events of the passed object.
                    - 'Active'   - activate links by subscribing to the
                                   <Link>Events of the passed object.
                    - 'Remove'   - deactivate newly removed links by 
                                   unsubscribing to the <Link>Events of the 
                                   passed object.                   
                    - 'Inactive' - deactivate links by unsubscribing to the
                                   <Link>Events of the passed object.                   
           phObject - Object to subscribe/unsubscribe to.                         
           pcLink   - Full link name pointing to the passed object.  
                      DataSource or Data-source (both forms supported) 
   Notes: The name -handler attempts to indicate that this is an event-handler 
          that not should be called directly outside of the intended events, but
          rather be actively used as an event to ensure that properties that
          are link dependant are set/removed.  
        - It's crucial that the subscribtion only happens once so we check 
          ObjectActive to ensure that the inactive/active unsubscribe/subscribe
          only is performed when the state is changed:
           updateLinkState(State)  
             publish linkState (state) --> receiver 
             Here.. <---------------------- run linkStateHandler in source(target). 
             {set ObjectActive ..}
        - Since this may be called for several objects/links the ObjectActive 
          property has to be managed outside of this.      
------------------------------------------------------------------------------*/
 DEFINE INPUT PARAMETER pcState       AS CHARACTER  NO-UNDO.
 DEFINE INPUT PARAMETER phObject      AS HANDLE     NO-UNDO.
 DEFINE INPUT PARAMETER pcLink        AS CHARACTER  NO-UNDO.
 
 DEFINE VARIABLE cEvents        AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE iEvent         AS INTEGER    NO-UNDO.
 DEFINE VARIABLE cLinkedObject  AS CHARACTER  NO-UNDO.

 ASSIGN
    pcLink  = REPLACE(pcLink,'-':U,'':U)
    cEvents = DYNAMIC-FUNCTION("get":U + pcLink + "Events":U IN TARGET-PROCEDURE)    
    cLinkedObject = DYNAMIC-FUNCTION("get":U + pcLink IN TARGET-PROCEDURE) 
 NO-ERROR.

 IF ERROR-STATUS:ERROR THEN
   RETURN 'adm-error':U. /* ?? */

 CASE pcState:
   WHEN 'remove':U THEN
   DO:
     /* 'Remove' is only allowed if the get<link> is  pointing to the object */
     IF NOT CAN-DO(cLinkedObject,STRING(phObject)) THEN
       RETURN.
   END.
   /* 'Add' is only allowed if get<link> matches the passed object */
   WHEN 'add':U THEN
   DO:
     IF NOT CAN-DO(cLinkedObject,STRING(phObject)) THEN
       RETURN.
   END.
   /* 'Active' is only allowed if get<Link> matches the passed object
      and the link is previously inactivated  */
   WHEN 'active':U THEN
   DO:
     IF NOT CAN-DO(cLinkedObject,STRING(phObject)) THEN
       RETURN. 
     IF NOT DYNAMIC-FUNCTION('isLinkInactive':U IN TARGET-PROCEDURE,pcLink,phObject) THEN 
       RETURN. 
     DYNAMIC-FUNCTION('modifyInactiveLinks':U IN TARGET-PROCEDURE,
                      'REMOVE':U,pcLink,phObject). 
   END.
   /* 'inactive' is only allowed if get<Link> matches the passed object 
       is not previously inactivated:  ObjectActive=yes */
   WHEN 'inactive':U THEN
   DO:
     IF NOT CAN-DO(cLinkedObject,STRING(phObject)) THEN
       RETURN.     
     
     IF DYNAMIC-FUNCTION('isLinkInactive':U IN TARGET-PROCEDURE,pcLink,phObject) THEN 
       RETURN. 

     DYNAMIC-FUNCTION('modifyInactiveLinks':U IN TARGET-PROCEDURE,
                      'ADD':U,pcLink,phObject). 
   END.
 END CASE.
 
 IF VALID-HANDLE(phObject) THEN
 DO:
   DO iEvent = 1 TO NUM-ENTRIES(cEvents):
     /* Never activate/deactivate linkstate */
     IF ENTRY(iEvent, cEvents) <> 'LinkState':U OR CAN-DO('REMOVE,ADD':U, pcState) THEN
     DO:
       IF CAN-DO('ACTIVE,ADD':U, pcState) THEN
         SUBSCRIBE PROCEDURE TARGET-PROCEDURE TO ENTRY(iEvent, cEvents) IN phObject.
       IF CAN-DO('INACTIVE,REMOVE':U, pcState)  THEN
         UNSUBSCRIBE PROCEDURE TARGET-PROCEDURE TO ENTRY(iEvent, cEvents) IN phObject.
     END.
   END.
 END.
 
 RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-modifyListProperty) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE modifyListProperty Procedure 
PROCEDURE modifyListProperty :
/*------------------------------------------------------------------------------
  Purpose:     Allows values to be added or deleted from any object property
               which is a comma-separated list (SupportedLinks, etc.)
  Parameters:  INPUT phCaller AS HANDLE -- handle of the object whose 
                 property is being changed
               INPUT pcMode AS CHARACTER -- 'ADD' or 'REMOVE'
               INPUT pcListName AS CHARACTER -- name of the property
               INPUT pcListvalue AS CHARACTER -- the value to add or remove
  Notes:       This is the ADM2 equivalent of what was modify-list-attribute
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER phCaller      AS HANDLE    NO-UNDO.
  DEFINE INPUT PARAMETER pcMode        AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER pcListName    AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER pcListValue   AS CHARACTER NO-UNDO.
  
  DEFINE VARIABLE lAddingValue         AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE cValueList           AS CHARACTER NO-UNDO.
  DEFINE VARIABLE iValue               AS INTEGER   NO-UNDO.
  DEFINE VARIABLE iComma               AS INTEGER   NO-UNDO.
  DEFINE VARIABLE OK                   AS LOGICAL   NO-UNDO.
  
  IF pcMode = "ADD":U THEN lAddingValue = yes.
  ELSE IF pcMode = "REMOVE":U THEN lAddingValue = no.
  ELSE DO:
    showMessage
      ({fnarg messageNumber 82}).
    RETURN ERROR.
  END.
  
  cValueList = dynamic-function("get":U + TRIM(pcListName) IN phCaller) NO-ERROR.

  IF cValueList = ?  THEN 
  DO:
  /* If the property isn't defined we have to initialize it with the added values first.*/ 
  IF lAddingValue THEN
  OK = dynamic-function("set":U + pcListName IN phCaller, pcListValue) NO-ERROR.
  /* NO-ERROR clause is added in case the property doesn't exist */
  RETURN.        
  END.

  iValue = LOOKUP(pcListValue, cValueList).

  /* Removing a value that's not there or adding a value that *is* there: */
  IF (iValue = 0 AND not lAddingValue) 
     OR (iValue NE 0 AND lAddingValue)   
       THEN RETURN.                           /* -> Nothing to do. */
  ELSE IF lAddingValue THEN             /* New item is added to the list */
      cValueList = cValueList +         /* (or is the only thing in the list) */
          (IF cValueList NE "":U THEN ",":U ELSE "":U)
          + pcListValue.
  ELSE                            /* Removing a value */
      ASSIGN cValueList = ',':U + cValueList + ',':U
             cValueList = REPLACE(cValueList, 
                                  ',':U + ENTRY(iValue + 1, cValueList) + ',':U, 
                                  ',':U)
             cValueList = SUBSTR(cValueList, 2, LENGTH(cValueList) - 2,
                                 "CHARACTER":U).

  /* Reset the attribute value. */
  dynamic-function("set":U + pcListName IN phCaller, cValueList).

  RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-modifyUserLinks) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE modifyUserLinks Procedure 
PROCEDURE modifyUserLinks :
/*------------------------------------------------------------------------------
  Purpose:     Maintains a delimited list of user-defined links (that is, 
               links which are not in the SupportedLinks list for an object),
               and the handle(s) of the object(s) at the other end of the 
               links.
  Parameters:  INPUT pcMod AS CHARACTER -- 'ADD' or 'REMOVE';
               INPUT pcLinkName AS CHARACTER -- link name including -Source or
               -Target;
               INPUT phObject AS HANDLE -- procedure handle of the object at the
               other end of the link.
  Notes:       Run from addLink and removeLink; used primarily by 
               the linkHandles function.
               The list is the third entry in ADM-DATA, delimited by CHR(1).
               Each entry in the list consists of a link name followed by
               CHR(4) followed by a comma-separated list of one or
               more handles. The list entries are delimited by CHR(3).
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER pcMod      AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER pcLinkName AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER phObject   AS HANDLE    NO-UNDO.
  
  DEFINE VARIABLE cLinkList    AS CHARACTER NO-UNDO.
  DEFINE VARIABLE iLink        AS INTEGER   NO-UNDO.
  DEFINE VARIABLE cLinkEntry   AS CHARACTER NO-UNDO INIT "":U.
  DEFINE VARIABLE cLinkName    AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cHandles     AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cNewEntry    AS CHARACTER NO-UNDO INIT "":U.
  
  cLinkList = ENTRY(3, TARGET-PROCEDURE:ADM-DATA, CHR(1)).
  
  DO iLink = 1 TO NUM-ENTRIES(cLinkList, CHR(3)):
    ASSIGN cLinkEntry = ENTRY(iLink, cLinkList, CHR(3))
           cLinkName  = ENTRY(1, cLinkEntry, CHR(4)).
    IF cLinkName = pcLinkName THEN
    DO:
      cHandles = ENTRY(2, cLinkEntry, CHR(4)).
      IF pcMod = "ADD":U THEN
      DO:
        /* If this object is already there, just exit. */
        IF LOOKUP(STRING(phObject), cHandles) NE 0 THEN
          RETURN.
        ASSIGN cHandles = cHandles + 
                 (IF cHandles NE "":U THEN ",":U ELSE "":U) +
                   STRING(phObject)
               cNewEntry = pcLinkName + CHR(4) + cHandles.
        LEAVE.    /* Our entry was already there and we updated it. */
      END.   /* END DO FOR Add */
      ELSE IF pcMod = "REMOVE":U THEN
      DO:
        /* If this object is *not* already there, just exit. */
        IF LOOKUP(STRING(phObject), cHandles) EQ 0 THEN
          RETURN.
        ASSIGN cHandles = REPLACE(",":U + cHandles + ",":U, 
                  ",":U + STRING(phObject) + ",":U, ",":U)
               cHandles = SUBSTR(cHandles, 2, LENGTH(cHandles) - 2)
               cNewEntry = pcLinkName + CHR(4) + cHandles.
        LEAVE.    /* Our entry has been removed. */
      END.    /* END DO IF REMOVE */       
    END.      /* END DO IF cLinkName = pcLinkName */
    ELSE cLinkEntry = "":U.
  END.     /* END DO iLink */
  IF cLinkEntry = "":U THEN  /* Not there yet; create it for Add */
  DO:
    IF pcMod = "ADD":U THEN
      cNewEntry = pcLinkName + CHR(4) + STRING(phObject).
    ELSE RETURN.             /* Or exit if trying to remove and it's not there.*/
  END.   /* END DO IF cLinkEntry = "" */
    
  IF cLinkEntry = "":U THEN  /* Just add it to the end */
    TARGET-PROCEDURE:ADM-DATA = TARGET-PROCEDURE:ADM-DATA + 
      (IF cLinkList NE "":U THEN CHR(3) ELSE "":U) +
      cNewEntry. 
  ELSE TARGET-PROCEDURE:ADM-DATA = REPLACE(TARGET-PROCEDURE:ADM-DATA,
     cLinkEntry, cNewEntry).
  RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-oneObjectLinks) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE oneObjectLinks Procedure 
PROCEDURE oneObjectLinks PRIVATE :
/*------------------------------------------------------------------------------
  Purpose:     Private procedure called from displayLinks to add links for
               a single object. Recurses down the Container link chain.
  Parameters:  hObject AS HANDLE.
------------------------------------------------------------------------------*/
  
  DEFINE INPUT PARAMETER hObject  AS HANDLE.
  
  DEFINE VARIABLE cSupported      AS CHARACTER.
  DEFINE VARIABLE iLink           AS INTEGER.
  DEFINE VARIABLE cLink           AS CHARACTER.
  DEFINE VARIABLE cType           AS CHARACTER.
  DEFINE VARIABLE cTargets        AS CHARACTER.
  DEFINE VARIABLE iTarget         AS INTEGER.
  DEFINE VARIABLE cContainer      AS CHARACTER.
  
  {get SupportedLinks cSupported hObject} NO-ERROR.
  {get ContainerType cContainer hObject} NO-ERROR.
  IF cContainer NE "":U THEN
    cSupported = cSupported + ",Container-Source".
  DO iLink = 1 TO NUM-ENTRIES(cSupported):
    cLink = ENTRY(iLink, cSupported).
    IF INDEX(cLink, 'Source') NE 0 THEN
    DO:
      cType = SUBSTR(cLink, 1, INDEX(cLink, '-') - 1).
      cTargets = dynamic-function('get' + cType + 'Target' 
        IN hObject) NO-ERROR.
      DO iTarget = 1 TO NUM-ENTRIES(cTargets):
        CREATE ADMLink.
        ASSIGN LinkType = cType
               LinkSource = hObject
               LinkTarget = WIDGET-HANDLE(ENTRY(iTarget, cTargets)).
        IF cLink = 'Container-Source':U THEN  /* recurse on contained objects. */
          RUN oneObjectLinks (LinkTarget).
      END.
    END.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-removeAllLinks) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE removeAllLinks Procedure 
PROCEDURE removeAllLinks :
/* ---------------------------------------------------------------------
  Purpose:     Removes all links as part of destroying a procedure.
  Parameters:  <none>
  Notes:       Run automatically as part of destroyObject
-----------------------------------------------------------------------*/
  
  DEFINE VARIABLE cSupportedLinks AS CHARACTER NO-UNDO.
  DEFINE VARIABLE iLink           AS INTEGER   NO-UNDO.
  DEFINE VARIABLE iPage           AS INTEGER   NO-UNDO.
  DEFINE VARIABLE cLink           AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cLinkType       AS CHARACTER NO-UNDO.
  DEFINE VARIABLE iHyphen         AS INTEGER   NO-UNDO.
  DEFINE VARIABLE iObject         AS INTEGER   NO-UNDO.
  DEFINE VARIABLE cDirection      AS CHARACTER NO-UNDO.
  DEFINE VARIABLE hObject         AS HANDLE    NO-UNDO.
  DEFINE VARIABLE cObjects        AS CHARACTER NO-UNDO.
  
  /* If this object is not on page 0, remove the PageN link in its 
     container. There is no PageN-Source per se -- it is always the 
     Container-Source. */
  {get ObjectPage iPage}.
  IF iPage NE 0 THEN
  DO:
    {get ContainerSource hObject}.
    IF VALID-HANDLE(hObject) THEN
      RUN removePageNTarget IN hObject (TARGET-PROCEDURE, iPage).
  END.  /* END DO IF not Page 0 */

  /* remove user-defined links too */
  RUN removeUserLinks IN TARGET-PROCEDURE.

  {get SupportedLinks cSupportedLinks}.
  /* Add standard links which aren't on SupportedLinks to the list. */
  cSupportedLinks = cSupportedLinks + 
    (IF cSupportedLinks NE "":U THEN ",":U ELSE "":U) +
     "Container-Source,Container-Target,Page-Source,Page-Target":U.
      
  DO iLink = 1 TO NUM-ENTRIES(cSupportedLinks):
    assign 
      cLink = TRIM(ENTRY(iLink, cSupportedLinks))
      iHyphen = R-INDEX(ENTRY(iLink, cSupportedLinks), "-":U)
      cLinkType = SUBSTR(cLink, 1, iHyphen - 1)  /* Base link type */
      cDirection = SUBSTR(cLink, iHyphen + 1)     /* Source or Target */
      cObjects = ?. 
    IF cDirection = "TARGET":U THEN             /* This object is the Target */
    DO:
      /* Note: Can't use {get} for variable properties.*/
      cObjects = dynamic-function("get":U + cLinkType + "Source":U
        IN TARGET-PROCEDURE) NO-ERROR.   
      IF cObjects NE ? THEN
        DO iObject = 1 TO NUM-ENTRIES(cObjects):  /* May be multiple sources. */
          hObject = WIDGET-HANDLE(ENTRY(iObject, cObjects)).
          IF VALID-HANDLE(hObject) THEN
            RUN removeLink IN TARGET-PROCEDURE
              (hObject, cLinkType, TARGET-PROCEDURE).
        END.              /* DO iObject */
    END.                  /* END This object is the Target */
    ELSE DO:                                     /* This object is the Source */
      cObjects = dynamic-function("get":U + cLinkType + "Target":U
        IN TARGET-PROCEDURE) NO-ERROR.      
      IF cObjects NE ? THEN          /* Might be unknown if no prop function. */   
        DO iObject = 1 TO NUM-ENTRIES(cObjects): /* May be multiple targets. */
          hObject = WIDGET-HANDLE(ENTRY(iObject, cObjects)).
          IF VALID-HANDLE(hObject) THEN
            RUN removeLink IN TARGET-PROCEDURE 
            (TARGET-PROCEDURE, cLinkType, hObject).
        END.              /* END DO iObject */
    END.                  /* END This object is the Source */
  END.                    /* END Processing for SupportedLinks */
    
  RETURN.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-removeLink) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE removeLink Procedure 
PROCEDURE removeLink :
/* ---------------------------------------------------------------------
  Purpose:     Removes a specific link between two objects.
  Parameters:  INPUT phSource AS HANDLE -- source procedure handle,
               INPUT pcLink   AS CHARACTER -- link type name, 
               INPUT phTarget AS HANDLE -- link target object handle
-----------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER phSource      AS HANDLE    NO-UNDO.   
  DEFINE INPUT PARAMETER pcLink        AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER phTarget      AS HANDLE    NO-UNDO.   
 
  DEFINE VARIABLE cEvents      AS CHARACTER NO-UNDO.
  DEFINE VARIABLE iEvent       AS INTEGER   NO-UNDO.
  DEFINE VARIABLE cSources     AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cTargets     AS CHARACTER NO-UNDO.
    
  /* If this isn't a recognized link, just delete the single subscription 
     of the name. Do this only if neither side supports the link. */
  {get SupportedLinks cSources phSource}.
  {get SupportedLinks cTargets phTarget}.
  IF (pcLink NE "Container":U AND NOT pcLink BEGINS "Page":U) AND
     (LOOKUP(pcLink + "-Source":U, cSources) = 0 AND
      LOOKUP(pcLink + "-Target":U, cTargets) = 0) THEN
  DO:
      UNSUBSCRIBE PROCEDURE phTarget TO pcLink IN phSource.
         /* Because there are no "Source" and "Target" properties for
            these "dynamic" links, we need to store the handles where
            the linkHandles function will be able to get at them later,
            if needed. */
      RUN modifyUserLinks IN phSource ('REMOVE':U, pcLink + "-Target":U,
          phTarget).
     RUN modifyUserLinks IN phTarget ('REMOVE':U, pcLink + "-Source":U,
         phSource).  
     RETURN.
  END.   /* END DO for non-Supported Link */
    
  /* The remaining code is for standard SupportedLinks. */
  
  /* UNSUBSCRIBE to all the appropriate events on each side of the old link. 
     First UNSUBSCRIBE the target. */
   RUN linkStateHandler IN phTarget ('Remove':U,
                                    phSource,
                                    pcLink + "Source":U).
   /*  UNSUBSCRIBE the source. */
   RUN linkStateHandler IN phSource ('Remove':U,
                                    phTarget,
                                    pcLink + "Target":U).

   /* We must be prepared for the Source or Target link to be a list 
     of more than one object. */
   IF dynamic-function('propertyType':U IN phTarget, pcLink + "Source":U) 
     = "CHARACTER":U THEN
       RUN modifyListProperty (phTarget, 'REMOVE':U, pcLink + "Source":U, 
         STRING(phSource)).
   ELSE dynamic-function("set":U + pcLink + "Source":U IN phTarget, ?)
      NO-ERROR. /* Remove the Source  -- don't complain if it's not there. */
  
   IF dynamic-function('propertyType':U IN phSource, pcLink + "Target":U) 
     = "CHARACTER":U THEN
       RUN modifyListProperty (phSource, 'REMOVE':U, pcLink + "Target":U, 
         STRING(phTarget)).
   ELSE dynamic-function("set":U + pcLink + "Target":U IN phSource, ?)
      NO-ERROR. /* Remove the Target  -- don't complain if it's not there. */
  
  
  RETURN.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-removeUserLinks) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE removeUserLinks Procedure 
PROCEDURE removeUserLinks :
/*------------------------------------------------------------------------------
  Purpose:  Remove all user-defined links. This routine will normally be called 
            when an object is deleted. Not only do we want to delete it's links
            but we need to delete the links to it that other objects have.
            So, for instance, if user links for the deleted object has a link 
            such as 
            "Mylink-target,<handlex>"
            then we need to delete a corresponding link "mylink-source,handley" 
            in the object identified by 'handlex'. Note: in this example, 
            'handley' is the object that is being deleted.
            
               
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE clinklist   AS CHARACTER NO-UNDO.
DEFINE VARIABLE ilink       AS INTEGER   NO-UNDO.
DEFINE VARIABLE iHandle     AS INTEGER   NO-UNDO.
DEFINE VARIABLE clinkentry  AS CHARACTER NO-UNDO.
DEFINE VARIABLE clinkname   AS CHARACTER NO-UNDO.
DEFINE VARIABLE chandles    AS CHARACTER NO-UNDO.
DEFINE VARIABLE hObj        AS HANDLE    NO-UNDO.

 /* get the User-defined links list from adm-data */
 cLinkList = ENTRY(3, TARGET-PROCEDURE:ADM-DATA, CHR(1)).

 /* loop through all of the user-defined links for this object
  * and find out what other objects have links to the current object.
  * Then call a routine to remove those links in those objects.
  */
 DO iLink = 1 TO NUM-ENTRIES(cLinkList, CHR(3)):
    ASSIGN cLinkEntry = ENTRY(iLink, cLinkList, CHR(3))
           cLinkName  = ENTRY(1, cLinkEntry, CHR(4))
           cHandles = ENTRY(2, cLinkEntry, CHR(4)).

    /* if the link is "mylink-target" for the current object, then
     * we need to delete "mylink-source" in the other object (and 
     * vice-versa). So we make the substitution here.
     */
     IF R-INDEX(cLinkName,"-Target":U) NE 0 
        THEN clinkname = REPLACE(cLinkName,"-Target":U, "-Source":U).
     ELSE IF R-INDEX(clinkName,"-Source":U) NE 0
          THEN clinkname = REPLACE(cLinkName,"-Source":U,"-Target":U).

    /* remove the link on behalf of the other object */
     DO iHandle = 1 TO NUM-ENTRIES(cHandles,",":U):
        hObj = WIDGET-HANDLE(ENTRY(iHandle,cHandles,",":U)).
        IF VALID-HANDLE(hobj) THEN
          RUN modifyUserLinks IN hObj ('Remove':U, cLinkName, TARGET-PROCEDURE).
     END.
  END.

/* When all done, set the target-procedure's user-defined link list to null. 
 * Note: we could have deleted each handle one by one using modifyUserLinks
 * for the target-procedure's list but setting the whole entry to NULL is easier 
 * and cleaner. To do it the other way, we need to make sure
 * we detect the case where there are no handles (just a link name) in the list.
 */
  ASSIGN
    cLinkList = TARGET-PROCEDURE:ADM-DATA
    ENTRY(3,cLinkList,CHR(1)) = "":U
    TARGET-PROCEDURE:ADM-DATA = cLinkList.
  
 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-repositionObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE repositionObject Procedure 
PROCEDURE repositionObject :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/  
    DEFINE INPUT PARAMETER pdRow    AS DECIMAL NO-UNDO.
    DEFINE INPUT PARAMETER pdCol    AS DECIMAL NO-UNDO.
    DEFINE VARIABLE hParent AS HANDLE NO-UNDO.

    DEFINE VARIABLE hContainer AS HANDLE NO-UNDO.
    
    {get ContainerHandle hContainer}.

    IF VALID-HANDLE(hContainer) THEN
    DO:  
      
      IF hContainer:TYPE = "WINDOW":U THEN
      DO:
        IF pdRow = 0 THEN 
          pdRow = (SESSION:HEIGHT-CHARS - hContainer:HEIGHT-CHARS) / 2.
        IF pdCol = 0 THEN 
          pdCol = (SESSION:WIDTH-CHARS - hContainer:WIDTH-CHARS) / 2.
      END.
      
      /* A Dialog naturally centers on its parent and positions relative
         to its parent, so we must adjust for that. */
      ELSE IF hContainer:TYPE = "DIALOG-BOX":U THEN
      DO:
        hParent = hContainer:PARENT.
        IF pdRow = 0 THEN 
            pdRow = ((SESSION:HEIGHT-CHARS - hContainer:HEIGHT-CHARS) / 2) - hParent:ROW.
        IF pdCol = 0 THEN 
            pdCol = ((SESSION:WIDTH-CHARS - hContainer:WIDTH-CHARS) / 2) - hParent:COL.
      END.

      /* If the row or column wound up being between 0 and 1 after the 
         calculation, change it, because otherwise Progress will complain. */
      IF pdRow GE 0 AND pdRow < 1 THEN pdRow = 1.
      IF pdCol GE 0 AND pdCol < 1 THEN pdCol = 1.

      ASSIGN hContainer:ROW    =   pdRow 
             hContainer:COLUMN =   pdCol
             NO-ERROR.
    END.  
    RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-returnFocus) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE returnFocus Procedure 
PROCEDURE returnFocus :
/*------------------------------------------------------------------------------
  Purpose:     returns focus to the containing window
  Parameters:  hTarget - a handle to the target procedure object
  Notes:       
------------------------------------------------------------------------------*/
  DEF INPUT PARAM hTarget AS HANDLE NO-UNDO.
  
  DEFINE VARIABLE cUIBMode     AS CHAR      NO-UNDO.
  DEFINE VARIABLE hCntSrc      AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hCntWidget   AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hParent      AS HANDLE    NO-UNDO.

  &SCOPED-DEFINE xp-assign
  {get UIBMode cUIBMode hTarget}
  {get ContainerHandle hCntWidget hTarget}.  /* This object's widget container */
  &UNDEFINE xp-assign
  IF cUIBMode NE "DESIGN":U AND VALID-HANDLE(hCntWidget) 
    AND hCntWidget:TYPE EQ "WINDOW":U THEN
  DO:
    {get ContainerSource hCntSrc hTarget}.  /* Container Source's procedure handle */
    IF VALID-HANDLE(hCntSrc) THEN
    DO:
      {get ContainerHandle hCntWidget hCntSrc}.  /* Container Source's widget container */
    END.
    IF VALID-HANDLE(hCntWidget) THEN
      APPLY "ENTRY":U TO hCntWidget.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-returnNothing) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE returnNothing Procedure 
PROCEDURE returnNothing :
/*------------------------------------------------------------------------------
  Purpose:  Clean return value...        
  Parameters:  <none>
  Notes:   The use of return-value for error is a problem as there now is no 
           safe place to reset it. 
         - commitTransaction is calling this if necessary to ensure that 
           old return-values does not cause issues for customer code.       
------------------------------------------------------------------------------*/
  RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-showDataMessagesProcedure) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE showDataMessagesProcedure Procedure 
PROCEDURE showDataMessagesProcedure :
/*------------------------------------------------------------------------------
  Purpose:     Returns the name of the field (if any) from the first
               error message, to allow the caller to use it to position the 
               cursor.
  Parameters:  <none>
  Notes:       Invokes fetchMessages() to retrieve all messages stored in the
               class property gcMessages.
               (normally database update-related error messages), and
               displays them in an alert-box of type error.
               This function expects to receive back a single string 
               from fetchMessages with one or more messages delimited by CHR(3),
               and within each message the message text, Fieldname (or blank) +
               a Tablename (or blank), delimited by CHR(4) if present.
------------------------------------------------------------------------------*/
  DEFINE OUTPUT PARAMETER pcReturn AS CHARACTER.

  DEFINE VARIABLE cMessages   AS CHARACTER NO-UNDO.
  DEFINE VARIABLE iMsg        AS INTEGER   NO-UNDO.
  DEFINE VARIABLE iMsgCnt     AS INTEGER   NO-UNDO.
  DEFINE VARIABLE cMessage    AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cFirstField AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cField      AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cTable      AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cText       AS CHARACTER NO-UNDO INIT "":U.
  DEFINE VARIABLE hContainerSource AS HANDLE NO-UNDO.
  DEFINE VARIABLE hContainer  AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cIgnore     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lIgnore     AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cSummary    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cParentType AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFocusType  AS CHARACTER  NO-UNDO.

  ASSIGN cMessages = DYNAMIC-FUNCTION('fetchMessages':U IN TARGET-PROCEDURE).

  /* Issue 6945 - we need to detect if a browse cell is involved */
  IF VALID-HANDLE(FOCUS) THEN
      ASSIGN cParentType = FOCUS:PARENT:TYPE
             cFocusType  = FOCUS:TYPE.
  {get ContainerHandle hContainer}.

  /* If we're running Dynamics, and a dialog is not involved, and there is
     no function in the call stack, and we're not in an updatable field in a 
     browser we can just send the message to the session manager to display.
     We want to avoid calling afmessagep in the session manager in this scenario,
     as each call to it will result in an Appserver hit, and showMessages is
     going to run afmessagep anyway. */
  IF  cMessages <> "":U
  AND NOT {fnarg IsDialogBoxParent hContainer}
  AND NOT {fn IsFunctionInCallStack}
  AND NOT (cFocusType = 'FILL-IN' AND cParentType BEGINS 'BROWSE':U) /* 6945 */
  AND VALID-HANDLE(gshSessionManager) THEN
  DO:
      DEFINE VARIABLE cButtonPressed AS CHARACTER NO-UNDO.
      {get ContainerSource hContainerSource}.

      /* Dynamics showMessages handles message list in raw form */
      RUN showMessages IN gshSessionManager (
          INPUT cMessages,        /* pcMessageList   */
          INPUT "ERR",            /* pcMessageType   */
          INPUT "OK",             /* pcButtonList    */
          INPUT "OK",             /* pcDefaultButton */
          INPUT "",               /* pcCancelButton  */
          INPUT "ADM2Message",    /* pcMessageTitle  */
          INPUT TRUE,             /* plDisplayEmpty  */
          INPUT hContainerSource, /* phContainer     */
          OUTPUT cButtonPressed   /* pcButtonPressed */
          ).
      /* Return the field name from the first error message so the caller can
         use it to position the cursor. */
      ASSIGN cMessage    = ENTRY(1, cMessages, CHR(3))
             cFirstField = IF NUM-ENTRIES(cMessage, CHR(4)) > 1 
                           THEN ENTRY(2, cMessage, CHR(4)) 
                           ELSE "":U.
  END.
  ELSE
  DO:
      iMsgCnt = NUM-ENTRIES(cMessages, CHR(3)).
      msgCnt_blk:
      DO iMsg = 1 TO iMsgCnt:
        /* Format a string of messages; each has a first line of
           "Field:  <field>    "Table:  <table>"
           (if either of these is defined) plus the error message on a
            separate line. */
        ASSIGN cMessage = ENTRY(iMsg, cMessages, CHR(3))
               cField = IF NUM-ENTRIES(cMessage, CHR(4)) > 1 
                        THEN ENTRY(2, cMessage, CHR(4)) 
                        ELSE "":U
               cTable = IF NUM-ENTRIES(cMessage, CHR(4)) > 2 
                        THEN ENTRY(3, cMessage, CHR(4)) 
                        ELSE "":U
               .
        /* Is Dynamics running? If so then run the messages through the standard message routine.
           This will ensure that the messages are translated and correctly formatted.           */
        IF VALID-HANDLE(gshSessionManager) THEN
           /* We are only interested in getting the summary message here. 
              Ignore all other parameters.  */
           RUN afmessagep IN gshSessionManager ( INPUT  cMessage,
                                                 INPUT  "":U,
                                                    INPUT  "":U,
                                                   OUTPUT cSummary,
                                                   OUTPUT cIgnore,
                                                   OUTPUT cIgnore,
                                                   OUTPUT cIgnore,
                                                   OUTPUT lIgnore,
                                                   OUTPUT lIgnore  ).
        else 
          cSummary = entry(1,cMessage,chr(4)).
            
        ASSIGN cText = cText 
                       + (IF cField NE "":U 
                          THEN DYNAMIC-FUNCTION('messageNumber':U IN TARGET-PROCEDURE, 10) + cField + "   ":U 
                          ELSE "":U)                                    
                       + (IF cTable NE "":U 
                          THEN DYNAMIC-FUNCTION('messageNumber':U IN TARGET-PROCEDURE, 11) + cTable 
                          ELSE "":U) 
                       + (IF cField NE "":U OR cTable NE "":U THEN "~n":U + "  ":U ELSE "":U)
                       + cSummary + "~n":U. 
        /* since we are displaying in a resizable dialog we can afford a blank line between fields */
        IF TRIM(cText) <> "" THEN ASSIGN cText = cText + "~n".
    
        /* Return the field name from the first error message so the caller can
           use it to position the cursor. */
        IF iMsg = 1 THEN cFirstField = cField.
      END.   /* END DO iMsg */
      
      /* Either Dynamics is not connected, or we couldn't use the standard Dynamics message window.
         Either way, display the message using the standard 4GL MESSAGE statement. */
      IF cText NE "":U AND cMessages <> "":U THEN
          MESSAGE cText VIEW-AS ALERT-BOX ERROR TITLE "Data Error".
  END.

  pcReturn = cFirstField.
  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-showMessageProcedure) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE showMessageProcedure Procedure 
PROCEDURE showMessageProcedure :
/*------------------------------------------------------------------------------
  Purpose:     Astra 2 override for showMessage function to use Astra 2 message
               handling routines.
               Displays (using a simple MESSAGE statement by default)
               either a literal message string, or a message number which
               is returned by the messageNumber function.
  Parameters: INPUT pcMessage AS CHARACTER -- 
              - Either a literal message string 
              - Or a message number in character form. 
               
               A message number can be followed by a comma delimited list
               with maximum 10 entries:
               
               The LAST entry (2 - 10) is:               
               1) The word "Question" or "YesNo", in which case the message is 
                  displayed with YES-NO buttons and the answer is returned.
               
               2) The word "YesNoCancel", in which case the message is displayed
                  with YES-NO-CANCEL buttons and the answer is returned.
               
               3) The word "OkCancel", in which case the message is displayed
                  with OK-CANCEL buttons and the answer is returned.
                  
               Optional entries from 2 to 10: 
                  Each entry will be placed into the numeric message
                  in place of the the string of form &n, where n is an integer 
                  between 1 and 9, inclusive (Entry 2 will replace &1 etc)         
                  
    Returns:   LOGICAL: true/false if the Question option is used,
                        true/false/unknown if the YesNoCancel option is used 
                        else true.
  Notes:       This function can be overridden to use a mechanism other than
               the MESSAGE statement to display messages, and still use the
               messageNumber function to map message numbers to translatable text.
               Note that this is different from addMessage, fetchMessages, etc.,
               which log messages in a temp-table for later retrieval.
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pcMessage AS CHARACTER NO-UNDO.
  DEFINE OUTPUT PARAMETER plAnswer AS LOGICAL NO-UNDO.
  
  DEFINE VARIABLE iMessage      AS INTEGER   NO-UNDO.
  DEFINE VARIABLE cMessage      AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cMessageType  AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cMsg          AS CHARACTER EXTENT 9 NO-UNDO.
  DEFINE VARIABLE iNumParam     AS INT       NO-UNDO.
  DEFINE VARIABLE lAnswer       AS LOGICAL   NO-UNDO.

  DEFINE VARIABLE cAnswer AS CHARACTER.
  DEFINE VARIABLE cButtonPressed AS CHARACTER.            
  DEFINE VARIABLE hContainerSource AS HANDLE NO-UNDO.
  DEFINE VARIABLE hContainer       AS HANDLE NO-UNDO.
  
  &SCOPED-DEFINE xp-assign
  {get ContainerSource hContainerSource}
  {get ContainerHandle hContainer}.
  &UNDEFINE xp-assign
 
  iMessage = INTEGER(ENTRY(1,pcMessage)) NO-ERROR.  /* was a number passed? */
  IF ERROR-STATUS:ERROR THEN 
    MESSAGE pcMessage VIEW-AS ALERT-BOX INFORMATION. /* No -- use the literal text */
  ELSE DO:   /* A numeric message */
    ASSIGN
      cMessage     = DYNAMIC-FUNCTION("messageNumber" IN TARGET-PROCEDURE, INPUT iMessage)
      iNumParam    = NUM-ENTRIES(pcMessage)
      cMessageType = ENTRY(iNumParam,pcMessage)
      cMsg[1]      = IF iNumParam > 1 THEN ENTRY(2,pcMessage) ELSE "":U
      cMsg[2]      = IF iNumParam > 2 THEN ENTRY(3,pcMessage) ELSE "":U
      cMsg[3]      = IF iNumParam > 3 THEN ENTRY(4,pcMessage) ELSE "":U
      cMsg[4]      = IF iNumParam > 4 THEN ENTRY(5,pcMessage) ELSE "":U
      cMsg[5]      = IF iNumParam > 5 THEN ENTRY(6,pcMessage) ELSE "":U
      cMsg[6]      = IF iNumParam > 6 THEN ENTRY(7,pcMessage) ELSE "":U
      cMsg[7]      = IF iNumParam > 7 THEN ENTRY(8,pcMessage) ELSE "":U
      cMsg[8]      = IF iNumParam > 8 THEN ENTRY(9,pcMessage) ELSE "":U
      cMsg[9]      = IF iNumParam > 9 THEN ENTRY(10,pcMessage) ELSE "":U      
      cMessage     = SUBSTITUTE(cMessage,
                                cMsg[1],cMsg[2],cMsg[3],cMsg[4],cMsg[5],
                                cMsg[6],cMsg[7],cMsg[8],cMsg[9]).
      
    /* Yes -- get the msg */
    CASE cMessageType:
      WHEN 'Question':U OR WHEN 'YesNo':U THEN
      DO:
        IF NOT {fnarg IsDialogBoxParent hContainer}
           AND NOT {fn IsFunctionInCallStack}
           AND VALID-HANDLE(gshSessionManager) THEN
        DO:
            RUN askQuestion IN gshSessionManager (    
                INPUT cMessage,         /* pcMessageList     */
                INPUT "Yes,No",         /* pcButtonList      */
                INPUT "YES",            /* pcDefaultButton   */
                INPUT "NO",             /* pcCancelButton    */
                INPUT "Question",       /* pcMessageTitle    */
                INPUT "",               /* pcDataType        */
                INPUT "",               /* pcFormat          */
                INPUT-OUTPUT cAnswer,   /* pcAnswer          */
                OUTPUT cButtonPressed   /* pcButtonPressed   */   
                ) NO-ERROR.
        
            CASE cButtonPressed:
                WHEN "YES" THEN lAnswer = TRUE.
                WHEN "NO"  THEN lAnswer = FALSE.                
            END CASE.             
        END.
        ELSE DO:
            MESSAGE cMessage VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO 
            UPDATE lAnswer.
        END.
        
        plAnswer = lAnswer.              
        RETURN.
      END.
      WHEN 'OkCancel':U THEN
      DO:
        IF NOT {fnarg IsDialogBoxParent hContainer}
           AND NOT {fn IsFunctionInCallStack}
           AND VALID-HANDLE(gshSessionManager) THEN
        DO:
              RUN askQuestion IN gshSessionManager (    
                  INPUT cMessage,         /* pcMessageList     */
                  INPUT "Ok,Cancel",      /* pcButtonList      */
                  INPUT "YES",            /* pcDefaultButton   */
                  INPUT "NO",             /* pcCancelButton    */
                  INPUT "Question",       /* pcMessageTitle    */
                  INPUT "",               /* pcDataType        */
                  INPUT "",               /* pcFormat          */
                  INPUT-OUTPUT cAnswer,   /* pcAnswer          */
                  OUTPUT cButtonPressed   /* pcButtonPressed   */   
                  ) NO-ERROR.

              CASE cButtonPressed:
                  WHEN "OK"     THEN lAnswer = TRUE.
                  WHEN "CANCEL" THEN lAnswer = FALSE.                
              END CASE.             
        END.
        ELSE DO:
            MESSAGE cMessage VIEW-AS ALERT-BOX QUESTION BUTTONS OK-CANCEL 
            UPDATE lAnswer.
        END.
        planswer = lAnswer.
        RETURN.
      END.
      WHEN 'YesNoCancel':U THEN
      DO:
          IF NOT {fnarg IsDialogBoxParent hContainer}
             AND NOT {fn IsFunctionInCallStack}
             AND VALID-HANDLE(gshSessionManager) THEN
          DO:   
            
            RUN askQuestion IN gshSessionManager (    
                INPUT cMessage,                             /* pcMessageList     */
                INPUT "Yes,No,Cancel",                      /* pcButtonList      */
                INPUT "CANCEL",                             /* pcDefaultButton   */
                INPUT "Cancel",                             /* pcCancelButton    */
                INPUT "Question",                           /* pcMessageTitle    */
                INPUT "",                                   /* pcDataType        */
                INPUT "",                                   /* pcFormat          */
                INPUT-OUTPUT cAnswer,                       /* pcAnswer          */
                OUTPUT cBUttonPressed                       /* pcButtonPressed   */   
                ).
                           
            
            CASE cButtonPressed:
                WHEN "YES"    THEN lAnswer = TRUE.
                WHEN "NO"     THEN lAnswer = FALSE.                
                WHEN "CANCEL" THEN lAnswer = ?.
            END CASE.             
                                  
          END.         
          ELSE DO:
            MESSAGE cMessage VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO-CANCEL 
            UPDATE lAnswer.
          END.
        
          plAnswer = lAnswer.
          RETURN.
      END.
      OTHERWISE 
      DO:
          IF NOT {fnarg IsDialogBoxParent hContainer}
             AND NOT {fn IsFunctionInCallStack}
             AND VALID-HANDLE(gshSessionManager) THEN
        DO:       
            RUN showMessages IN gshSessionManager (
                INPUT cMessage,         /* pcMessageList */
                INPUT "INF",            /* pcMessageType   */
                INPUT "OK",             /* pcButtonList    */
                INPUT "OK",             /* pcDefaultButton */
                INPUT "",               /* pcCancelButton  */
                INPUT "Information",    /* pcMessageTitle  */
                INPUT TRUE,             /* plDisplayEmpty  */
                INPUT hContainerSource, /* phContainer     */
                OUTPUT cButtonPressed   /* pcButtonPressed */               
                ).
                
        END.
        ELSE DO:
            MESSAGE cMessage VIEW-AS ALERT-BOX INFORMATION.      
        END.
      END.
    END CASE.
  END.  /* END ELSE IF numeric message */
  
  plAnswer = TRUE.        
  RETURN.       /* Return value not meaningful in this case. */
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-toggleData) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE toggleData Procedure 
PROCEDURE toggleData :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER plEnabled AS LOGICAL NO-UNDO.

/*     MESSAGE "dataviscustom.p toggleData setting DLE to " plEnabled "for " TARGET-PROCEDURE:FILE-NAME. */
    
    {set DataLinksEnabled plEnabled}.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-viewObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE viewObject Procedure 
PROCEDURE viewObject :
/*------------------------------------------------------------------------------
  Purpose:     Views the current object.
   Params:     <none>
    Notes:     "Viewing" in the ADM is a logical concept which can be applied
               to all objects regardless of whether they have a visualization;
               that is why this procedure is found in smart.p. When an
               object is "viewed" its links are typically activated; when
               "hidden" they are sometimes deactivated, depending on the link
               type. If an object has an actual visualization, the version of
               viewObject in visual.p will view it.
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cContainer       AS CHARACTER NO-UNDO.
  DEFINE VARIABLE hContainer       AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hFrame           AS HANDLE    NO-UNDO.
    
  &SCOPED-DEFINE xp-assign
  {get containerType cContainer}
  {set ObjectHidden NO}
  {set hideOnInit NO}. /* turn off flag as it is checked by container's notifypage */
  &UNDEFINE xp-assign
  IF cContainer NE "":U THEN
    /* We don't need to physically view the SmartObjects in this Container -
       they will reappear when it is viewed - but we need to tell them that
       they are part of a viewed Container so that they can set links
       and other states dependent on HIDDEN accordingly. */
    DYNAMIC-FUNCTION("assignLinkProperty":U In TARGET-PROCEDURE,
      "Container-Target":U, "ContainerHidden":U, "no":U).
    
  /* For those objects which want to "activate" a link when an object is
     viewed, we tell them that this object is 'active'. We also set the
     ObjectActive property to hold onto the state for future inquiries. */
  PUBLISH 'LinkState':U FROM TARGET-PROCEDURE ('active':U).
  
  {get ContainerHandle hContainer}.
  
  IF VALID-HANDLE(hContainer) THEN
    &IF "{&WINDOW-SYSTEM}":U = "TTY":U &THEN
       IF hContainer:TYPE EQ "WINDOW" THEN DO: /* Can't view TTY window, */
           hFrame = hContainer:FIRST-CHILD.
           IF VALID-HANDLE(hFrame) THEN
             VIEW hFrame.                      /* so view the contents.  */
       END. 
       ELSE
    &ENDIF
    ASSIGN hContainer:HIDDEN = NO.

    
  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-anyMessage) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION anyMessage Procedure 
FUNCTION anyMessage RETURNS LOGICAL
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns a flag indicating whether there is any message in the log.
   Params:  <none>
  Returns:  LOGICAL: true if there are messages in the log, else false.
------------------------------------------------------------------------------*/

  RETURN gcDataMessages NE "":U.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-applyFocus) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION applyFocus Procedure 
FUNCTION applyFocus RETURNS LOGICAL
  ( pcField AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose: Apply entry to a widget
  pcfield - a field name
          - ? first in tab order  
    Notes:  Similar to applyEntry (which just calls this), but returns result 
            allowing callers to manage focus across multiple contained objects.  
          - container.p overrides this and passes ContainerHandle frames and 
            ContainerTargets as the last parameters to applyFocusToframe in 
            order to call applyFocus in child objects when their frame is
            encountered .
------------------------------------------------------------------------------*/ 
  DEFINE VARIABLE hFrame AS HANDLE      NO-UNDO.
  
  {get ContainerHandle hFrame}.
  RETURN DYNAMIC-FUNC("applyFocusToFrame":U IN TARGET-PROCEDURE, 
                       hFrame,pcField,"","").

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-applyFocusToFrame) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION applyFocusToFrame Procedure 
FUNCTION applyFocusToFrame RETURNS LOGICAL
  ( phFrame AS HANDLE,
    pcField AS CHAR,
    pcFrameList AS CHAR,
    pcObjectList AS CHAR ) :
/*------------------------------------------------------------------------------
    Purpose: Utility that applies focus ("entry") to the specified or first tab 
             item in the passed frame, including possible child frames and 
             optionally through the child objects that owns the frame.   
 Parameters:
  phFrame      - frame handle to check
  pcField      - field name of widget to apply entry to 
               - blank or ? means find first tab item. 
  pcFrameList  - List of frame handles that belongs to SmartObjects.   
  pcObjectList - List of objects that corresponds to the frame list.   
    Notes:   This is a frame level utility used by the object level applyFocus
             not really intended for direct calls. 
             Use applyFocus or run applyEntry     
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hWidget AS HANDLE      NO-UNDO.
  DEFINE VARIABLE iObject AS INTEGER     NO-UNDO.
  DEFINE VARIABLE hObject AS HANDLE      NO-UNDO.

  IF NOT VALID-HANDLE(phFrame) 
  OR lookup(phFrame:TYPE,'FRAME,DIALOG-BOX':U) = 0 THEN
    RETURN FALSE.

  if pcField = ? then 
    pcField = "":U.
  
  ASSIGN 
    hWidget = phFrame:CURRENT-ITERATION
    hWidget = hWidget:FIRST-TAB-ITEM. 
 
  DO WHILE VALID-HANDLE(hWidget):

    IF hWidget:VISIBLE THEN
    DO:
      IF hWidget:TYPE = "frame":U THEN
      DO:
        iObject = lookup(string(hWidget),pcFrameList). 
        if iObject > 0 then
        do:
          hObject = WIDGET-HANDLE(ENTRY(iObject,pcObjectList)).
          if {fnarg applyFocus pcField hObject} then
            return TRUE.
        end.
        ELSE
        IF DYNAMIC-FUNC("applyFocusToFrame":U IN TARGET-PROCEDURE, 
                         hWidget,pcfield,pcFrameList,pcObjectList) THEN
          RETURN TRUE.
      END.
      ELSE IF hWidget:SENSITIVE AND (pcField = "":U OR pcField = hWidget:NAME) THEN
      DO:
         APPLY "entry"  TO hWidget.
         RETURN TRUE.
      END.
    END.

    hWidget = hWidget:NEXT-TAB-ITEM. 
  END. /* do while valid hWidget */

  RETURN FALSE.  

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-assignBufferValueFromReference) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION assignBufferValueFromReference Procedure 
FUNCTION assignBufferValueFromReference RETURNS CHARACTER
  (phBufferField AS HANDLE, 
   pcReference   AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose: Assigns a large buffer-column from the passed reference.
           Returns the error message if it fails.  
Paramters: phbufferField - buffer-field handle of large data-type
           pcReference   - Reference to where the value can be retrieved
                         - File,<filename>
                         - File,<function-name>,<procedure-handle> 
                         - Data,<function-name>,<procedure-handle> 
                         - Data,<function-name>,<procedure-handle> 
                         - Data,<function-name>,<procedure-handle> 
                                    
    Notes: Could not find or open file problems are considered potential 
           runtime errors and are using the adm messageNumber.  
           Errors that are considered design time errors are either returned 
           from progress error-status or hardcoded.    
         - This is implemented in smart since it is needed by both the data 
           class and dataset class (and has no property dependencies)  
------------------------------------------------------------------------------*/  
  DEFINE VARIABLE cRefType          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDataType         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE mLargeValue       AS MEMPTR     NO-UNDO. 
  DEFINE VARIABLE clLargeValue      AS LONGCHAR   NO-UNDO. 
  DEFINE VARIABLE hLargeSource      AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cLargeFile        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cLargeFunction    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cLargeFilePathed  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSignature        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cErrorReason      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lQueryContainer   AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cObjectName       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cColumnName       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lUseParam         AS LOGICAL    NO-UNDO.

  IF pcReference = '' 
  OR pcReference = '?' 
  OR pcReference = ?   
  OR pcReference = 'File,':U
  OR pcReference = 'File,?':U THEN
    phBufferField:BUFFER-VALUE = ?.

  ELSE DO:   
    ASSIGN
      cRefType       = ENTRY(1,pcReference)
      cLargeFunction = ENTRY(2,pcReference)
      cColumnName    = {fnarg columnName phBufferField}.
     
    IF NUM-ENTRIES(pcReference) > 2 THEN
    DO:    
      hLargeSource  = WIDGET-HANDLE(ENTRY(3,pcReference)).
      IF NOT VALID-HANDLE(hLargeSource) THEN
        RETURN "The procedure handle in the large object update reference is not valid.".

    END.
   
    IF VALID-HANDLE(hLargeSource) THEN
    DO:
      IF CAN-DO(hLargeSource:INTERNAL-ENTRIES,cLargefunction) THEN
        cSignature = hLargeSource:GET-SIGNATURE(cLargefunction). 
      ELSE /* adm2 super stack */
        cSignature = {fnarg signature cLargefunction hLargeSource}.  
      
      IF cSignature <> '' THEN
      DO:
        lUseParam = ENTRY(3,cSignature) <> '':U.
        IF cRefType = 'Data' THEN 
          cDataType = ENTRY(2,cSignature).
        ELSE 
          cDataType = 'CHARACTER':U. 
      END.
    END.

    CASE cRefType:
      WHEN 'Data':U THEN
      DO:
        CASE cDataType:
          WHEN 'Memptr':U THEN
          DO:
            IF lUseParam THEN 
              mLargeValue = DYNAMIC-FUNCTION(cLargeFunction IN hLargeSource,
                                             cColumnName) NO-ERROR.
            ELSE 
              mLargeValue = DYNAMIC-FUNCTION(cLargeFunction IN hLargeSource)
                                                                   NO-ERROR.
    
            COPY-LOB FROM mLargeValue TO phBufferField:BUFFER-VALUE NO-ERROR. 
            
            IF ERROR-STATUS:ERROR THEN
              RETURN ERROR-STATUS:GET-MESSAGE(1).
          END.
          WHEN 'Longchar':U THEN
          DO:
            IF lUseParam THEN 
              clLargeValue = DYNAMIC-FUNCTION(cLargeFunction IN hLargeSource,
                                              cColumnName) NO-ERROR.
            ELSE
              clLargeValue = DYNAMIC-FUNCTION(cLargeFunction IN hLargeSource)
                                                                     NO-ERROR.                

            IF LENGTH(clLargeValue) > 0 THEN
              COPY-LOB FROM clLargeValue TO phBufferField:BUFFER-VALUE NO-ERROR. 
            ELSE 
              phBufferField:BUFFER-VALUE = ?.
    
            IF ERROR-STATUS:ERROR THEN
               RETURN ERROR-STATUS:GET-MESSAGE(1).
          END.
          OTHERWISE 
          DO:
            IF lUseParam THEN 
              phBufferField:BUFFER-VALUE = DYNAMIC-FUNCTION(cLargeFunction IN hLargeSource,
                                                            cColumnName) NO-ERROR.
            ELSE
              phBufferField:BUFFER-VALUE = DYNAMIC-FUNCTION(cLargeFunction IN hLargeSource)
                                           NO-ERROR. 

            IF ERROR-STATUS:ERROR THEN
               RETURN ERROR-STATUS:GET-MESSAGE(1).
          END.
        END CASE. /* cDataType */
      END. /* when 'data' */
      WHEN 'File':U THEN
      DO:
        /* if file and function get the filename from the call back */
        IF VALID-HANDLE(hLargeSource) THEN
        DO:
          IF lUseParam THEN
            cLargeFile = DYNAMIC-FUNCTION(cLargeFunction IN hLargeSource,
                                          cColumnName) NO-ERROR.
           ELSE
             cLargeFile = DYNAMIC-FUNCTION(cLargeFunction IN hLargeSource)
                          NO-ERROR.
           IF ERROR-STATUS:ERROR THEN
             RETURN ERROR-STATUS:GET-MESSAGE(1).
        END.

        /* if no procedure to call in the filename is passed as reference */
        ELSE 
          cLargeFile = cLargeFunction.

        IF cLargeFile <> '':U THEN
        DO:
          ASSIGN
            FILE-INFO:FILE-NAME = cLargefile
            cLargeFilePathed = FILE-INFO:FULL-PATHNAME.
        
          IF cLargeFilePathed <> ? THEN 
            COPY-LOB FROM FILE cLargeFilePathed TO phBufferField:BUFFER-VALUE NO-ERROR.              
             
          /* If pathed name is unknown or progress 43 (could not find or open) 
             then use ADM error 92 (could not find or open.. ) as the reason 
             to pass to the caller  */
          IF (ERROR-STATUS:ERROR AND ERROR-STATUS:GET-NUMBER(1) = 43) 
          OR cLargeFilePathed = ? THEN
            cErrorReason = SUBSTITUTE({fnarg messageNumber 92}, 
                                         (IF cLargeFilePathed = ? 
                                          THEN cLargeFile
                                          ELSE cLargeFilePathed)).
        END.
        ELSE
          phBufferField:BUFFER-VALUE = ?.
      END.

      OTHERWISE 
        cErrorReason = "The reference type " + cRefType + " is not valid in update reference.". 
  
    END CASE.          
    
  END.

  RETURN cErrorReason.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-assignLinkProperty) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION assignLinkProperty Procedure 
FUNCTION assignLinkProperty RETURNS LOGICAL
  ( pcLink AS CHARACTER, pcPropName AS CHARACTER, pcPropValue AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:     Sets a property value in an object at the other end of 
               a specified link, relative to TARGET-PROCEDURE.
  Parameters:  INPUT pcLink AS CHARACTER -- Link Type, 
               INPUT pcPropName AS CHARACTER -- Property Name, 
               INPUT pcPropValue AS CHARACTER -- Property Value.
     Returns:  LOGICAL: true if "set" operation succeeds, else false.
  Notes:       ADM2 Version of set-link-attribute. Note that only one property
               name and value is allowed, as opposed to the "attribute list"
               format of V8. If the property function is not there or invalid
               somehow, or if any of the "set"s fails, return false.
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cObjects   AS CHARACTER NO-UNDO.
  DEFINE VARIABLE lReturn    AS LOGICAL   NO-UNDO INIT yes.
  DEFINE VARIABLE lSuccess   AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE iObject    AS INTEGER   NO-UNDO.
  DEFINE VARIABLE hObject    AS HANDLE    NO-UNDO.
  
  cObjects = DYNAMIC-FUNCTION('linkHandles':U IN TARGET-PROCEDURE, pcLink).
  IF cObjects NE ? THEN
    DO iObject = 1 TO NUM-ENTRIES(cObjects):
      /* Get the property's native datatype so that we can set it properly. */
      ASSIGN hObject = WIDGET-HANDLE(ENTRY(iObject, cObjects))
      
      lSuccess = dynamic-function("set":U + pcPropName IN hObject, pcPropValue) NO-ERROR.   
      IF NOT lSuccess THEN lReturn = FALSE.
    END.
    
  RETURN lReturn.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-assignMappedEntry) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION assignMappedEntry Procedure 
FUNCTION assignMappedEntry RETURNS CHARACTER
   (pcEntryNames  AS CHAR,
    pcList        AS CHAR,
    pcEntryValues AS CHAR,
    pcDelimiter   AS CHAR,
    plFirst       AS LOG) :
/*------------------------------------------------------------------------------
  Purpose: Assign a value to a mapped entry list. This is the analog of the
           assignMappedEntry function copied from adeuib/_abfuncs.w
           Returns the updated list.
              
Parameters:  INPUT pcEntryNames  - entry names to set (pcDelimiter delimited).  
             INPUT pcList        - Delimited Name<deL>Value string to assign new values to.
             INPUT pcEntryValues - New values to assign (pcDelimiter delimited).
             INPUT pcDelmiter    - Delimiter of 1st 3 parameters    
             INPUT plFirst       - TRUE  - Name first, value second.
                                   FALSE - Value first, Name second.
                                          
    Notes: Assigns the value to all occurances of pcEntry in the pcList     
           If it can't find the pcEntry, it adds the pcEntry <DEL> pcValue at the end.
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cName       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cValue      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iEntry      AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iLookUp     AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iNumEntries AS INTEGER    NO-UNDO.
  DEFINE VARIABLE lAssigned   AS LOGICAL    NO-UNDO.

  /* Find out how many name/values need to be set */
  iNumEntries = NUM-ENTRIES(pcEntryNames, pcDelimiter).
  /* Make sure that we have the correct number of values */
  IF NUM-ENTRIES(pcEntryValues, pcDelimiter) NE iNumEntries THEN DO:
    RETURN ?.  /* Names and values don't match, return ? */
  END.

  DO iEntry = 1 TO iNumEntries:
    ASSIGN lAssigned = NO
           cName     = ENTRY(iEntry, pcEntryNames,  pcDelimiter)
           cValue    = ENTRY(iEntry, pcEntryValues, pcDelimiter).

    /* Find all occurances */
    DO iLookUp = IF plFirst THEN 1 ELSE 2 TO NUM-ENTRIES(pcList, pcDelimiter) BY 2:
      IF ENTRY(iLookup, pcList, pcDelimiter) = cName THEN DO:
         ENTRY(iLookup + (IF plFirst THEN 1 ELSE -1), pcList, pcDelimiter) = cValue.
         lAssigned = YES.
      END.
    END. /* Look to find all occurances */

    IF NOT lAssigned THEN DO: /* Couldn't find at least one instance,
      create the name value pair at the end */
      pcList = pcList + (IF pcList = "":U THEN "" ELSE pcDelimiter) +
                        (IF plFirst THEN cName + pcDelimiter + cValue
                                    ELSE cValue + pcDelimiter + cName).
    END. /* If we can't find the pcEntry */
  END.  /* Loop through all name/value pairs to be assigned */

  RETURN pcList.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-assignTargetLinkState) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION assignTargetLinkState Procedure 
FUNCTION assignTargetLinkState RETURNS LOGICAL
        ( pcLinkType    as char,
          plActive      as logical,
          plQueryObject as logical ):
/*------------------------------------------------------------------------------
    Purpose: Disable links to targets.
 Parameters:  pcLinkType    - Link type name (e.g. "Data" for data-target) 
              plActive      - Yes - Active
                            - No  - Inactive 
              plQueryObject - Yes - only targets where QueryObject = true 
                                 (Dataview, sdo, sbo)
                            - No  - only targets where QueryObject = false 
                                 (visual)
                            - ?   Any/all targets                             
      Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cTargets  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iTarget   AS INTEGER    NO-UNDO.
  DEFINE VARIABLE hTarget   AS HANDLE     NO-UNDO.
  DEFINE VARIABLE lOk       AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lQuery    AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cState    AS CHARACTER  NO-UNDO.
  
  cTargets = dynamic-function("get":U + pcLinkType + "Target":U in target-procedure)
             no-error.
  /* design time error (don't throw error, but give a hint if used with 
     unsupported link) */
  if error-status:error then 
    message error-status:get-message(1) view-as alert-box error.
     
  if plActive then 
    cState = 'Active':U. 
  else 
    cState = 'Inactive':U.
      
  do iTarget = 1 TO num-entries(cTargets):
    hTarget = widget-handle(entry(iTarget,cTargets)).
    if valid-handle(hTarget) then 
    do:  
      if plQueryObject <> ? then
      do: 
        {get QueryObject lQuery hTarget}.
        lOk = (lQuery = plQueryObject).
      end.
      else 
        lOk = true.
        
      if lOk then 
        run linkStateHandler in hTarget(cState,
                                        target-procedure,
                                        pcLinkType + "Source":U).
    end. /* valid target */
  end. /* Do iTarget = 1 to NUM */
  return true. 
  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-changeLinkState) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION changeLinkState Procedure 
FUNCTION changeLinkState RETURNS LOGICAL
  ( pcState  AS CHAR,
    pcLink   AS CHAR, 
    phObject AS HANDLE):

/*------------------------------------------------------------------------------
  Purpose: Subscribe to the link events in the passed object  
Parameter: pcState - 'Active'  - activate links by subscribing to the
                                <Link>Events of the passed object
                     'Inactive' - deactivate links by unsubscribing to the
                                <Link>Events of the passed object
           pcLink - full link name to a linked object.  
                    DataSource or Data-source (both forms supported) 
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cEvents AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iEvent  AS INTEGER    NO-UNDO.
  
  ASSIGN
    pcLink  = REPLACE(pcLink,'-':U,'':U)
    cEvents = DYNAMIC-FUNCTION("get":U + pcLink + "Events":U IN TARGET-PROCEDURE) 
  NO-ERROR.
  
  IF ERROR-STATUS:ERROR = FALSE AND VALID-HANDLE(phObject) THEN
  DO:
    DO iEvent = 1 TO NUM-ENTRIES(cEvents):
      IF pcState = 'ACTIVE':U THEN
        SUBSCRIBE PROCEDURE TARGET-PROCEDURE TO ENTRY(iEvent, cEvents) IN phObject.
      IF pcState = 'INACTIVE':U THEN
        UNSUBSCRIBE PROCEDURE TARGET-PROCEDURE TO ENTRY(iEvent, cEvents) IN phObject.
    END.
    RETURN TRUE.
  END.
  ELSE 
    RETURN FALSE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-clearCombo) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION clearCombo Procedure 
FUNCTION clearCombo RETURNS LOGICAL
  ( phField AS HANDLE ):
/*-----------------------------------------------------------------------------
  Purpose: General purpose utility to clear a combo-box.   
           This is primarily implemented to avoid performance overhead with 
           the old list-item[-pairs] = list-item[-pairs] trick on large lists.  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE lHasBlank    AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lBlankAdded  AS LOGICAL    NO-UNDO.

  IF phField:SUBTYPE = 'drop-down-list':U THEN
  DO:
    IF CAN-QUERY(phField,'LIST-ITEMS':U) THEN 
    DO:
      /* Other data-types than char may be blank ('zzz').
         NO-ERROR is used to prevent errors for logical combos. */
      lHasBlank = phField:LOOKUP(' ') > 0 NO-ERROR. 
      IF phField:DATA-TYPE = 'CHARACTER':U THEN 
        lBlankAdded = phField:ADD-FIRST('').
      IF lHasBlank OR lBlankAdded THEN
        phField:SCREEN-VALUE = ' '.
      ELSE
        phField:LIST-ITEMS = phField:LIST-ITEMS. 
    END.
    ELSE DO: /* list-item-pairs */
      /* Add a blank entry first, take advantage of the fact that first entry
         will be found when screen-value is set even if other entries have same 
         value */ 
      CASE phField:DATA-TYPE:
        WHEN 'CHARACTER':U THEN
          lBlankAdded = phField:ADD-FIRST('','').
        WHEN 'DECIMAL':U THEN
          lBlankAdded = phField:ADD-FIRST('',0.0).
        WHEN 'INTEGER':U THEN
          lBlankAdded = phField:ADD-FIRST('',0).
        WHEN 'DATE':U THEN 
          lBlankAdded = phField:ADD-FIRST('',TODAY).
        /*otherwise... (datetime/-tz is not supported, 
          logicals typically will have very few entries, so not worth while)*/ 
      END.   
      IF lBlankAdded THEN
        phField:SCREEN-VALUE = IF phField:ENTRY(1) = '' THEN ' ' 
                               ELSE phField:ENTRY(1).
      ELSE  
        phField:LIST-ITEM-PAIRS = phField:LIST-ITEM-PAIRS. 
    END.
    IF lBlankAdded THEN
      phField:DELETE(1).
  END.
  ELSE /* simple and drop-down combos  */
    phField:SCREEN-VALUE = ''. 

  RETURN TRUE. 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-deleteEntry) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION deleteEntry Procedure 
FUNCTION deleteEntry RETURNS CHARACTER
  ( piEntry  AS INTEGER,
    pcString AS CHARACTER,
    pcDelim  AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Delete entry piEntry from pcString.
  Returns:  Returns the new string without the specified entry.
    
------------------------------------------------------------------------------*/
DEFINE VARIABLE iNumEnt  AS INT  NO-UNDO.
DEFINE VARIABLE cUnique AS CHAR NO-UNDO INIT "@":U.
 
/* if delimiter is not specified then use comma as default */
IF pcDelim = "":U OR pcDelim = ? THEN pcDelim = ",":U.

/* determine a unique string to replace the entry we want to delete then
 * we can easily delete it and the appropriate delimiters from pcString.
 * First, if the character used to build the unique string is the delimiter 
 * then use another character altogether to build the unique string.
 */
IF pcDelim = cUnique THEN cUnique = "$":U.      /* use alternative char*/
DO WHILE INDEX(pcString,cUnique) > 0:
    cUnique = cUnique + SUBSTR(cUnique,1,1).    /* build unique string*/
end.

/* replace the entry-to-delete with unique string */
/* then delete it and appropriate delimiters      */
ENTRY(piEntry,pcString,pcDelim) = cUnique.
iNumEnt = NUM-ENTRIES(pcString,pcDelim).                 
IF iNumEnt = 1 AND piEntry = 1 THEN pcString = "":U.   /* only entry*/
ELSE 
   pcstring = REPLACE(pcString,
                       IF piEntry = iNumEnt THEN pcDelim + cUnique /* last entry*/
                       ELSE IF piEntry = 1 THEN cUnique + pcDelim  /* first entry*/
                       ELSE cUnique + pcDelim,                     /* middle entry*/
                       "":U).
RETURN pcString.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-deleteProperties) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION deleteProperties Procedure 
FUNCTION deleteProperties RETURNS LOGICAL ( ) :
/*------------------------------------------------------------------------------
  Purpose: Delete the property tt record   
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hPropTable AS HANDLE     NO-UNDO.
  hPropTable = WIDGET-HANDLE(ENTRY(1,TARGET-PROCEDURE:ADM-DATA,CHR(1))). 
  
  IF VALID-HANDLE(hPropTable) AND hPropTable:NAME <> 'ADMProps':U THEN
  DO:
    hPropTable:FIND-FIRST('WHERE Target = WIDGET-HANDLE(':U + QUOTER(TARGET-PROCEDURE) + ') ':U). 
    hPropTable:BUFFER-DELETE().
  END.
  RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fetchMessages) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fetchMessages Procedure 
FUNCTION fetchMessages RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns a delimited list of all messages in their "raw" form. 
            The message log is cleared.
   Params:  <none>
  Returns:  CHARACTER: specially-delimited message text string
    Notes:  The message list is delimited by CHR(3); within each message, the
            Message Text, the Field (if any), and the Table (if any) are delimited
            by CHR(4). Use the similar function reviewMessages to read messages
            without deleting them.
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cMessages AS CHARACTER NO-UNDO INIT "":U.
  
  cMessages = gcDataMessages.  
  gcDataMessages = "":U.
  glManageReadErrors = false. 
  
  RETURN cMessages.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getChildDataKey) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getChildDataKey Procedure 
FUNCTION getChildDataKey RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    DEFINE VARIABLE cChildDataKey AS CHARACTER NO-UNDO.
    {get ChildDataKey cChildDataKey}.
    RETURN cChildDataKey.
  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getClassName) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getClassName Procedure 
FUNCTION getClassName RETURNS CHARACTER
        (  ):
/*------------------------------------------------------------------------------
  Purpose:  Returns the Repository class name
    Notes:
------------------------------------------------------------------------------*/
    DEFINE VARIABLE cClassName                 AS CHARACTER              NO-UNDO.
    
    &SCOPED-DEFINE xpClassName
    {get ClassName cClassName}.
    &UNDEFINE xpClassName
    
    RETURN cClassName.
END FUNCTION.    /* getClassName */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getContainerHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getContainerHandle Procedure 
FUNCTION getContainerHandle RETURNS HANDLE
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the widget handle of this object's Window or 
            Frame container. 
   Returns: HANDLE
   Params:  <none>
------------------------------------------------------------------------------*/

  DEFINE VARIABLE hContainer AS HANDLE NO-UNDO.
  
  {get ContainerHandle hContainer}.
  RETURN hContainer.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getContainerHidden) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getContainerHidden Procedure 
FUNCTION getContainerHidden RETURNS LOGICAL
  ( ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns a flag indicating whether this object's *parent* container
            is hidden.
   Returns: LOGICAL
   Params:  <none>
------------------------------------------------------------------------------*/

  DEFINE VARIABLE lHidden AS LOGICAL NO-UNDO.
  {get ContainerHidden lHidden}.
  RETURN lHidden.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getContainerSource) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getContainerSource Procedure 
FUNCTION getContainerSource RETURNS HANDLE
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the handle of this object's ContainerSource, if any.
   Params:  <none>
  Returns:  HANDLE
------------------------------------------------------------------------------*/
  
  DEFINE VARIABLE hSource AS HANDLE NO-UNDO.
  {get ContainerSource hSource}.
  RETURN hSource.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getContainerSourceEvents) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getContainerSourceEvents Procedure 
FUNCTION getContainerSourceEvents RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns a comma-separated list of the events this object 
            wants to subscribe to in its ContainerSource
   Params:  <none>
  Returns:  CHARACTER
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cEvents AS CHARACTER NO-UNDO.
  {get ContainerSourceEvents cEvents}.
  RETURN cEvents.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getContainerType) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getContainerType Procedure 
FUNCTION getContainerType RETURNS CHARACTER
  ( ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the Type of Container which this SmartObject is --
            blank if the object is not a container, otherwise "WINDOW" for
            a SmartWindow , "FRAME" for a SmartFrame.
   Params:  <none>
  Returns:  CHARACTER
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cType AS CHARACTER NO-UNDO.
  {get ContainerType cType}.
  RETURN cType.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDataLinksEnabled) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getDataLinksEnabled Procedure 
FUNCTION getDataLinksEnabled RETURNS LOGICAL
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes: DEPRECATED 
------------------------------------------------------------------------------*/
  DEFINE VARIABLE lDataLinksEnabled AS LOGICAL NO-UNDO.
  {get DataLinksEnabled lDataLinksEnabled}.
  RETURN lDataLinksEnabled.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDataSource) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getDataSource Procedure 
FUNCTION getDataSource RETURNS HANDLE
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the object's data source, if any.
   Params:  <none>
  Returns:  HANDLE
    Notes: There si no xp preprosessor in order to allow design-time override  
------------------------------------------------------------------------------*/
DEFINE VARIABLE hDataSource AS HANDLE     NO-UNDO.

  &SCOPED-DEFINE xpDataSource
  {get DataSource hDataSource}.
  &UNDEFINE xpDataSource
  
  RETURN hDataSource.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDataSourceEvents) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getDataSourceEvents Procedure 
FUNCTION getDataSourceEvents RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns a comma-separated list of the events this object 
            wants to subscribe to in its DataSource.
   Params:  <none>
  Returns:  CHARACTER
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cEvents AS CHARACTER NO-UNDO.
  {get DataSourceEvents cEvents}.
  RETURN cEvents.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDataSourceNames) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getDataSourceNames Procedure 
FUNCTION getDataSourceNames RETURNS CHARACTER
  (   ) :
/*------------------------------------------------------------------------------
 Purpose:  Returns the ObjectName of the Data Object that sends data to this
           visual object. This would be set if the data-Source is an SBO
           or other Container with DataObjects.
  Params:  <none>
   Notes: Used by both visual objects and SDOs.
          See the SBOs addDataTarget for more details on how this is set.  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cSourceNames AS CHAR   NO-UNDO.

  {get DataSourceNames cSourceNames}.
  RETURN cSourceNames.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDataTarget) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getDataTarget Procedure 
FUNCTION getDataTarget RETURNS CHARACTER
  ( ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the Data Target (in CHARACTER form, because it may be
            a comma-separated list). 
   Params:  <none>
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cTarget AS CHARACTER NO-UNDO.
  {get DataTarget cTarget}.
  RETURN cTarget.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDataTargetEvents) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getDataTargetEvents Procedure 
FUNCTION getDataTargetEvents RETURNS CHARACTER
  (   ) :
/*------------------------------------------------------------------------------
  Purpose:     Returns the list of events this object subscribes to in its
               DataTarget.
  Parameters:  
  Notes:        
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cEvents AS CHARACTER  NO-UNDO.
  {get DataTargetEvents cEvents}.
  RETURN cEvents.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDBAware) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getDBAware Procedure 
FUNCTION getDBAware RETURNS LOGICAL
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns a flag indicating whether this object is dependent
            on being connected to a database or not, to allow some code
            to execute two different ways (for DataObjects, e.g.).
    Params: <none>
   Returns: LOGICAL
------------------------------------------------------------------------------*/

  DEFINE VARIABLE lAware AS LOGICAL NO-UNDO.
  {get DBAware lAware}.
  RETURN lAware.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDesignDataObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getDesignDataObject Procedure 
FUNCTION getDesignDataObject RETURNS CHARACTER
  ( ) :
/*------------------------------------------------------------------------------
  Purpose: Returns the design time SDO for objects that needs SDO data,
           but cannot be linked.
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cDataObject AS CHAR NO-UNDO.
  {get DesignDataObject cDataObject}.
  RETURN cDataObject.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDynamicObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getDynamicObject Procedure 
FUNCTION getDynamicObject RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
DEFINE VARIABLE lTemp AS LOGICAL NO-UNDO.
    {get DynamicObject lTemp}.
  RETURN lTemp.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getHideOnInit) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getHideOnInit Procedure 
FUNCTION getHideOnInit RETURNS LOGICAL
  (  ) :
/*------------------------------------------------------------------------------
  Purpose: Return the logical flag that indicates whether to visualize 
           at initialization.
    Notes: Also used for non visual object in order to publish LinkState 
           correctly for activation and deactivation of links.   
         - PendingPage is used as "visiblePage" in this logic to ensure that 
           this returns true for object's that are on a hidden page so they 
           remain hidden during initilization without depending on a 
           setHideOnInit that messes with customers use of HideOnInit. 
         - containr.p initPages sets PendingPage to the current visible page 
           when initializing hidden objects. Old behavior dictates that 
           CurrentPage must be the initted page also when hidden.              
------------------------------------------------------------------------------*/
  DEFINE VARIABLE lHideOnInit      AS LOGICAL   NO-UNDO.
  define variable hContainerSource as handle    no-undo.
  define variable iPendingPage     as integer   no-undo.
  define variable iObjectPage      as integer   no-undo.
  define variable lQueryObject     as logical   no-undo.
  
  &scop xpHideOnInit
  &scop xp-assign
  {get HideOnInit lHideOnInit}
  {get QueryObject lQueryObject}
  {get ObjectPage iObjectPage}
  {get ContainerSource hContainerSource}
  .
  &undefine xp-assign
  &undefine xpHideOnInit
  
  /* if we're on a page that can be hidden and we're not a Query 
    (data-source) and not already defined to be hidden then check 
     PendingPage */ 
  if iObjectPage <> 0 
  and not lQueryObject 
  and not lHideOnInit 
  and valid-handle(hContainerSource) then
  do:
    {get PendingPage iPendingPage hContainerSource}.    
    /* if pendingpage is set and not current then keep the object hidden  */
    if iPendingPage <> ? and iObjectPage <> iPendingPage then
      lHideOnInit  = true.
  end.
    
  return lHideOnInit.
  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getInactiveLinks) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getInactiveLinks Procedure 
FUNCTION getInactiveLinks RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
   Purpose: Stores inactive links 
   Notes:   Stored as a comma-separated paired list where the second entry of 
            each pair is a semi-colon separated list of object handles 
        -   modifyInactiveLinks should be used to maintain thje property. 
        -   isLinklnactive should be used to check if an actual link is 
            inactive                  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cInactiveLinks AS CHARACTER  NO-UNDO.
  
  {get InactiveLinks cInactiveLinks}.
  RETURN cInactiveLinks. 

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getInstanceId) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getInstanceId Procedure 
FUNCTION getInstanceId RETURNS DECIMAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the Repository manager's unique identifier of this instance  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE dId AS DECIMAL    NO-UNDO.
  {get InstanceId dId}.
  RETURN dId.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getInstanceProperties) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getInstanceProperties Procedure 
FUNCTION getInstanceProperties RETURNS CHARACTER
  ( ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the ADM Instance Properties of the SmartObject --
            a list of those properties which can be set at design time to
            be initialized as part of SmO startup.
   Params:  <none>
  Returns:  CHARACTER
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cProps AS CHARACTER NO-UNDO.
  {get InstanceProperties cProps} NO-ERROR.
  RETURN cProps.


END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getIsCrystalInstalled) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getIsCrystalInstalled Procedure 
FUNCTION getIsCrystalInstalled RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose: Check if Crystal is installed  
    Notes: This is defined as a class property to ensure the check only 
           is done once per session. 
           datavis getPrintPreviewActive calls this.  
------------------------------------------------------------------------------*/
 DEFINE VARIABLE hApplication          AS COM-HANDLE NO-UNDO.
 DEFINE VARIABLE cRegReportDesign      AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cKeyReportDesign      AS CHARACTER  NO-UNDO.

 /* not checked yet */
 IF glIsCrystalInstalled = ? THEN
 DO:
   /* Get the values for Crystal Reports from the Registry */
   ASSIGN
     cKeyReportDesign  = "CrystalRuntime.Application"
     cRegReportDesign  = "CrystalRuntime.Application.7" /* Default Value */ 
     .

   /* cRegReportDesign */
   LOAD cKeyReportDesign BASE-KEY "HKEY_CLASSES_ROOT":U NO-ERROR.
   IF NOT ERROR-STATUS:ERROR THEN 
   DO:
     USE cKeyReportDesign.
     GET-KEY-VALUE SECTION "CurVer":U KEY DEFAULT VALUE cRegReportDesign.
   END.
   UNLOAD cKeyReportDesign NO-ERROR.

   CREATE VALUE(cRegReportDesign) hApplication NO-ERROR.
   ASSIGN glIsCrystalInstalled = NOT ERROR-STATUS:ERROR.
   RELEASE OBJECT hApplication NO-ERROR.   
   ASSIGN hApplication = ?.
   ERROR-STATUS:ERROR = NO.   

 END.
  
 RETURN glIsCrystalInstalled.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getLabel) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getLabel Procedure 
FUNCTION getLabel RETURNS CHARACTER
   ( ) :
/*------------------------------------------------------------------------------
  Purpose: Returns the LABEL defined for the selection   
    Notes: - "?" specifies that the logicalObjectName is to be used
           - Blank specifies NO-LABEL   
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cLabel AS CHARACTER NO-UNDO.
  &SCOPED-DEFINE xpLabel
  {get Label cLabel}.
  &UNDEFINE xpLabel
      
  IF cLabel = ? THEN 
  DO:
    {get ObjectName cLabel}.
    IF cLabel = '' OR cLabel = ? THEN
      {get LogicalObjectName cLabel}.
    
    /* store default for future requests */
    IF cLabel <> '' AND cLabel <> ? THEN
      {set Label cLabel}.
  END.

  RETURN cLabel.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getLayoutPosition) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getLayoutPosition Procedure 
FUNCTION getLayoutPosition RETURNS CHARACTER
        (  ):
/*------------------------------------------------------------------------------
  Purpose:  
        Notes:
------------------------------------------------------------------------------*/
    DEFINE VARiABLE cLayoutPosition    AS CHARACTER                 NO-UNDO.
    
    {get LayoutPosition cLayoutPosition}.
    
    RETURN cLayoutPosition.
END FUNCTION.   /* get LayoutPosition */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getLogicalObjectName) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getLogicalObjectName Procedure 
FUNCTION getLogicalObjectName RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose: Return the logical object (Repository object name)  
    Notes:  This is the unique name of the object master in the repository 
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cLogicalObject AS CHARACTER  NO-UNDO.  
  {get LogicalObjectName cLogicalObject}.
  RETURN cLogicalObject.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getLogicalVersion) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getLogicalVersion Procedure 
FUNCTION getLogicalVersion RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
DEFINE VARIABLE cVersion AS CHARACTER NO-UNDO. 
  
  &SCOPED-DEFINE xpLogicalVersion
  {get LogicalVersion cVersion}.
  &UNDEFINE xpLogicalVersion
  RETURN cVersion.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getManageReadErrors) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getManageReadErrors Procedure 
FUNCTION getManageReadErrors RETURNS LOGICAL
  (   ) :
/*------------------------------------------------------------------------------
  Purpose: Session property that tells if adm error mechanism is used on data 
           retrieval.
    Notes: This should only be set to true if one is absolutley sure that the 
           messages are emptied from the message queue when the request is 
           completed.   
           (which is stored in a variable in smart)   
         - Used on server by some adm2 data request procedures - fetch*   
         - Set to false in fetchMessages
------------------------------------------------------------------------------*/

  RETURN glManageReadErrors.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getManagerHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getManagerHandle Procedure 
FUNCTION getManagerHandle RETURNS HANDLE
  ( pcManager AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes: Override to assign default "managers" for dynamics and adm2   
           If a manager is found in the session it overrides the default. 
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hManager AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cDefault AS CHARACTER  NO-UNDO.
 
  hManager = SUPER(pcManager) NO-ERROR.
  IF NOT VALID-HANDLE(hManager) THEN
  DO:
    CASE pcManager:
      WHEN 'DataContainer' THEN
        ASSIGN cDefault = 'adm2/datacontainer.p':U. 
      WHEN 'SDFCacheManager':U THEN
        ASSIGN cDefault = 'adm2/lookupfield.p':U. 
      WHEN 'CacheManager':U THEN
        ASSIGN cDefault = 'adm2/data.p':U. 
      WHEN 'ToolbarManager':U THEN
        ASSIGN cDefault = 'adm2/toolbar.p':U. 
      WHEN 'ServiceAdapter':U THEN
        ASSIGN cDefault = {fn getServiceAdapterName}. 
    END.

    IF cDefault > '' THEN
    DO:
      hManager = SESSION:FIRST-PROCEDURE.
      DO WHILE VALID-HANDLE(hManager):
        IF REPLACE(hManager:FILE-NAME,'~\':U,'/':U) 
           = RIGHT-TRIM(REPLACE(cDefault + ' ','.r ','.p ')) THEN
          RETURN hManager.
        hManager = hManager:NEXT-SIBLING.
      END.
      DO ON STOP UNDO,LEAVE:
        RUN VALUE(cDefault) PERSISTENT SET hManager. 
      END.
    END.
  END.

  RETURN hManager. 
 
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getMessageBoxType) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getMessageBoxType Procedure 
FUNCTION getMessageBoxType RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose: Returns the type of message  
    Notes:  
------------------------------------------------------------------------------*/
    define variable rRowid as rowid no-undo.
    define variable lProfileExists as logical no-undo.

    if gcMessageBoxType eq ? and valid-handle(gshSessionManager) then
    do:
        /* check user prefs first. */
        run checkProfileDataExists in gshProfileManager ('General',
                                                         'Preference',
                                                         'MessageBoxType',
                                                         No,    /*plCheckPermanentOnly*/
                                                         No,    /*plCheckCacheOnly*/
                                                         output lProfileExists ) no-error.
        
        if lProfileExists then
            run getProfileData in gshProfileManager ('General':u, /* Profile type code     */
                                                     'Preference':u, /* Profile code          */
                                                     'MessageBoxType':u, /* Profile data key      */
                                                     'No':u,              /* Get next record flag  */
                                                     input-output rRowid,       /* Rowid of profile data */
                                                     output gcMessageBoxType ).            /* Found profile data. */        
        
        /* if no user pref exists, use session params */
        if gcMessageBoxType eq ? or gcMessageBoxType eq '':u then
            gcMessageBoxType = dynamic-function('getSessionParam':u in target-procedure, 'MessageBoxType').
    end.    /* not set yet */

    /* if no value can be found, use Complex as default */
    if gcMessageBoxType eq ? or gcMessageBoxType eq '':u then
        gcMessageBoxType = "Complex".    
    
    return gcMessageBoxType.    
END FUNCTION.    /* getMessageBoxType */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getObjectHidden) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getObjectHidden Procedure 
FUNCTION getObjectHidden RETURNS LOGICAL
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns a flag indicating whether the current object is hidden.
            Note that "Hidden" is a logical concept in the ADM. 
            A non-visual object can be "hidden" to indicate that it is 
            not currently active in some way, because it is a 
            Container-Target of some visual object that is hidden.
   Params:  <none>
  Returns:  LOGICAL
------------------------------------------------------------------------------*/

  DEFINE VARIABLE lHidden AS LOGICAL NO-UNDO.

  DEFINE VARIABLE lContainerHidden AS LOGICAL    NO-UNDO.

  {get ContainerHidden lContainerHidden}.

  IF lContainerHidden THEN
    RETURN YES.
  ELSE
  DO:
    &SCOPED-DEFINE xpObjectHidden
    {get ObjectHidden lHidden}.
    &UNDEFINE xpObjectHidden
    RETURN lHidden.
  END.
  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getObjectInitialized) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getObjectInitialized Procedure 
FUNCTION getObjectInitialized RETURNS LOGICAL
  ( ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns a flag indicating whether this object has been initialized.
   Params:  <none>
  Returns:  LOGICAL
------------------------------------------------------------------------------*/

  DEFINE VARIABLE lInitted AS LOGICAL NO-UNDO.
  {get ObjectInitialized lInitted}.
  RETURN lInitted.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getObjectName) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getObjectName Procedure 
FUNCTION getObjectName RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the name of the object, which can be the filename
            or some other designation meaningful to the repository and
            other objects. 
   Returns: CHARACTER
   Params:  <none>
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cName AS CHARACTER NO-UNDO.
  
  {get ObjectName cName}.
  RETURN cName.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getObjectPage) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getObjectPage Procedure 
FUNCTION getObjectPage RETURNS INTEGER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the logical page on which this object has been placed.
   Params:  <none>
  Returns:  INTEGER
------------------------------------------------------------------------------*/

  DEFINE VARIABLE iPage AS INTEGER NO-UNDO.
  {get ObjectPage iPage}.
  RETURN iPage.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getObjectParent) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getObjectParent Procedure 
FUNCTION getObjectParent RETURNS HANDLE
  ( ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the widget handle of this object's Window or Frame parent,
            that is, the handle of the visual container of its CONTAINER-SOURCE.
   Params:  <none>
  Returns:  HANDLE
    Notes:  Compare to ContainerHandle, which is the handle of *this* object's 
            Frame or Window if it has one.
---------------------------------------------------------------------------*/

  DEFINE VARIABLE hObject AS HANDLE NO-UNDO.
  
  {get ContainerHandle hObject}.
  IF VALID-HANDLE(hObject) THEN
  DO:
    IF CAN-QUERY(hObject,"FRAME":U) AND VALID-HANDLE(hObject:FRAME) THEN
      RETURN hObject:FRAME.
    ELSE IF VALID-HANDLE(hObject:PARENT) THEN
      RETURN hObject:PARENT.
    ELSE RETURN ?.
  END.
  ELSE RETURN ?.
  
 END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getObjectsCreated) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getObjectsCreated Procedure 
FUNCTION getObjectsCreated RETURNS LOGICAL
        (  ):
/*------------------------------------------------------------------------------
  Purpose:  Returns whether this object has run createObjects for page 0.
   Params:  <none>
    Notes:  This is used in createObjects to avoid double create. Some 
            containers run createObjects from the main block while others
            start them from initializeObject. The create initializeObject is 
            often too late so this flag was introduced to allow us to have more
            control over when the objects are created and run createObjects 
            before initializeObject for all objects without risking a double 
            create.            
----------------------------------------------------------------------------*/
  DEFINE VARIABLE lCreated AS LOGICAL NO-UNDO.
  {get ObjectsCreated lCreated}.
  RETURN lCreated.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getObjectVersion) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getObjectVersion Procedure 
FUNCTION getObjectVersion RETURNS CHARACTER
  ( ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the ADM version of the SmartObject
   Params:  <none>
  Returns:  CHARACTER
    Notes:  For Progress Version 9 objects, this will return "ADM2.0" or higher.
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cVersion AS CHARACTER NO-UNDO.
  {get ObjectVersion cVersion} NO-ERROR.
  RETURN cVersion.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getParentDataKey) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getParentDataKey Procedure 
FUNCTION getParentDataKey RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    DEFINE VARIABLE cParentDataKey AS CHARACTER NO-UNDO.
    {get ParentDataKey cParentDataKey}.
    RETURN cParentDataKey.
  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getPassThroughLinks) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getPassThroughLinks Procedure 
FUNCTION getPassThroughLinks RETURNS CHARACTER
  ( ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the list of which link types are considered candidates
            for creating "pass-through" links.
   Params:  <none>
  Returns:  CHARACTER
    Notes:  This property value is stored once in smart.p for all SmartObjects.
------------------------------------------------------------------------------*/

  RETURN scPassThroughLinks.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getPhysicalObjectName) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getPhysicalObjectName Procedure 
FUNCTION getPhysicalObjectName RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cTemp AS CHARACTER NO-UNDO.
  {get PhysicalObjectName cTemp}.
  RETURN cTemp.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getPhysicalVersion) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getPhysicalVersion Procedure 
FUNCTION getPhysicalVersion RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
DEFINE VARIABLE cVersion AS CHARACTER NO-UNDO.          
    {get PhysicalVersion cVersion}.
  RETURN cVersion.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getPropertyDialog) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getPropertyDialog Procedure 
FUNCTION getPropertyDialog RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the name of the dialog procedure that sets 
            InstanceProperties.
   Params:  <none>
  Returns:  CHARACTER
    Notes:  This property is usually used only internally, but must be callable
            from the AppBuilder to determine whether to enable the 
            InstanceProperties menu item.
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cDialog AS CHARACTER NO-UNDO.
  {get PropertyDialog cDialog}.
  RETURN cDialog.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getQueryObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getQueryObject Procedure 
FUNCTION getQueryObject RETURNS LOGICAL
  (  ) :
/*------------------------------------------------------------------------------
  Purpose: Returns a flag indicating whether this object queries data.
    Notes: The data class and sbo class are both considered to be a QueryObject. 
Note date: 2002/02/14       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE lQuery AS LOGICAL NO-UNDO.
  {get QueryObject lQuery}.
  RETURN lQuery.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getRenderingProcedure) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getRenderingProcedure Procedure 
FUNCTION getRenderingProcedure RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose: Return the rendering procedure
    Notes: 
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cRenderingProcedure AS CHARACTER  NO-UNDO.  
  {get RenderingProcedure cRenderingProcedure}.
  RETURN cRenderingProcedure.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getRunAttribute) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getRunAttribute Procedure 
FUNCTION getRunAttribute RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
DEFINE VARIABLE cRunAttribute AS CHARACTER NO-UNDO.          
    {get RunAttribute cRunAttribute}.
  RETURN cRunAttribute.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getServiceAdapterName) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getServiceAdapterName Procedure 
FUNCTION getServiceAdapterName RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose: Returns the procedure name of the Service Adapter  
    Notes: Used by getManagerHandle('ServiceAdapter'). 
           Override to use a separate/different service adapter
------------------------------------------------------------------------------*/

  RETURN "adm2/serviceadapter.p":U.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getSuperProcedure) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getSuperProcedure Procedure 
FUNCTION getSuperProcedure RETURNS CHARACTER
        (  ):
/*------------------------------------------------------------------------------
  Purpose:  
        Notes:
------------------------------------------------------------------------------*/
    DEFINE VARIABLE cSuperProcedure                 AS CHARACTER                    NO-UNDO.
    
    {get SuperProcedure cSuperProcedure}.
        
    RETURN cSuperProcedure.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getSuperProcedureHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getSuperProcedureHandle Procedure 
FUNCTION getSuperProcedureHandle RETURNS CHARACTER
        (  ):
/*------------------------------------------------------------------------------
  Purpose:  
        Notes:
------------------------------------------------------------------------------*/
    DEFINE VARIABLE cProcedureHandle                AS CHARACTER      NO-UNDO.
    
    {get SuperProcedureHandle cProcedureHandle}.
                
    RETURN cProcedureHandle.
END FUNCTION.   /* getSuperProcedureHandle */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getSuperProcedureMode) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getSuperProcedureMode Procedure 
FUNCTION getSuperProcedureMode RETURNS CHARACTER
        (  ):
/*------------------------------------------------------------------------------
  Purpose:  
        Notes:
------------------------------------------------------------------------------*/
    DEFINE VARIABLE cProcedureMode                  AS CHARACTER      NO-UNDO.
        
    {get SuperProcedureMode cProcedureMode}.
        
    RETURN cProcedureMode.
END FUNCTION.   /* getSuperProcedureMode */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getSupportedLinks) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getSupportedLinks Procedure 
FUNCTION getSupportedLinks RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns a list of the SmartObject links supported by this object.
   Params:  <none>
  Returns: CHARACTER
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cLinks AS CHARACTER NO-UNDO.
  {get SupportedLinks cLinks}.
  RETURN cLinks.
  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getThinRenderingProcedure) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getThinRenderingProcedure Procedure 
FUNCTION getThinRenderingProcedure RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose: Return the thin rendering procedure
    Notes: 
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cThinRenderingProcedure AS CHARACTER  NO-UNDO.  
  {get ThinRenderingProcedure cThinRenderingProcedure}.
  RETURN cThinRenderingProcedure.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getTranslatableProperties) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getTranslatableProperties Procedure 
FUNCTION getTranslatableProperties RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns a list of translatable properties for the object.
   Params:  <none>
  Returns:  CHARACTER
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cProps AS CHARACTER NO-UNDO.
  {get TranslatableProperties cProps} NO-ERROR.
  RETURN cProps.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getUIBMode) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getUIBMode Procedure 
FUNCTION getUIBMode RETURNS CHARACTER
  ( ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the UIB Mode property to indicate whether this object is
            in Design mode in the AppBuilder.
   Params:  <none>
  Returns:  CHARACTER
    Notes:  This will return blank if the object is not in design mode,
            that is, not running in an AppBuilder design window. It will
            return "Design" if in design mode, or "Design-Child" if it is
            contained in another SmartObject which is in design mode
            (such as a SmartFrame). It will return ? if the object is not
            a SmartObject (does not have a valid handle in ADM-DATA).
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cMode AS CHARACTER NO-UNDO INIT ?.
  {get UIBMode cMode}.
  RETURN cMode.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getUseRepository) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getUseRepository Procedure 
FUNCTION getUseRepository RETURNS LOGICAL
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/    
  /* The Icf session manager will have this in a super procedure of the session */
  IF glIcfIsRunning EQ ? THEN
        glIcfIsRunning = DYNAMIC-FUNCTION('isICFRunning':U IN THIS-PROCEDURE) NO-ERROR.
  
  /* Return no if unknown !*/ 
  RETURN glIcfIsRunning = TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getUserProperty) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getUserProperty Procedure 
FUNCTION getUserProperty RETURNS CHARACTER
  ( pcPropName AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Retrieves the value of a dynamically-defined property.
   Params:  pcPropName AS CHARACTER
  Returns:  CHARACTER: property value in character form
    Notes:  Dynamically-defined properties are currently stored in a list 
            in the ADM-DATA procedure attribute, delimited by CHR(3), 
            with CHR(4) between property name and value. However, 
            it should not be necessary for developers to be aware of the s
            pecific storage mechanism for dynamically-defined properties, 
            which could be subject to change in the future. 
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cProps   AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cPropVal AS CHARACTER NO-UNDO.
  DEFINE VARIABLE iEntry   AS INTEGER   NO-UNDO.
  
  cProps = ENTRY(2, TARGET-PROCEDURE:ADM-DATA, CHR(1)).
  DO iEntry = 1 TO NUM-ENTRIES(cProps, CHR(3)):
    cPropVal = ENTRY(iEntry, cProps, CHR(3)).
    IF ENTRY(1, cPropVal, CHR(4)) = pcPropName THEN
      RETURN ENTRY(2, cPropVal, CHR(4)).
  END.   /* END DO iEntry */
  RETURN ?.          /* Property was not found. */
  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-instanceOf) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION instanceOf Procedure 
FUNCTION instanceOf RETURNS LOGICAL
    ( INPUT pcClass        AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose: Resolve if this is an instance Of a particular class/object type 
    Notes: For Dynamics this does include the inheritance hierarchy 
 ------------------------------------------------------------------------------*/      
    DEFINE VARIABLE cClassName         AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cObjectType        AS CHARACTER NO-UNDO.
    
    IF VALID-HANDLE(gshRepositoryManager) THEN
    DO:
        {get ClassName cClassName}.
        /* Using ClassIsA is more robust because IsA() depends on this
           object being in the object cache. In addition, ClassIsA() will
           attempt to cache the class if it is not already cached, something
           that IsA() cannot do.
         */
        IF cClassName EQ pcClass THEN
            RETURN TRUE.
        ELSE if cClassName > "" 
        AND DYNAMIC-FUNCTION('ClassIsA':U IN gshRepositoryManager, cClassName, pcClass) then
            RETURN TRUE.
    END.    /* Using the Repository */
    
    /* allow transparent references for Dynamics classes in adm2 */  
    case pcClass:
        when "Base":U then pcClass = "Smart":U.
        when "DynCombo":U then pcClass = "Combo":U.
        when "DynLookup":U then pcClass = "Lookup":U.
        when "DataVisual":U then pcClass = "Datavis":U.
        when "Container":U then pcClass = "Containr":U.         
    end. 
    
    /* check super stack */
    if {fnarg instanceOfSuper pcClass} then 
        return true. 
      
    /* somewhat questionable perhaps, but needed for backwards compatibilty 
       with early versions */
    {get ObjectType cObjectType}.    
    return pcClass = cObjectType.    
      
END FUNCTION.   /* instanceOf */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-instancePropertyList) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION instancePropertyList Procedure 
FUNCTION instancePropertyList RETURNS CHARACTER
  ( pcPropList AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns a list of the values of the names of the object's 
            InstanceProperties, that is those properties which can be set 
            to initial values in design mode.
            These can be set in the AppBuilder to determine the object 
            instance's behavior at runtime.
    Params: INPUT pcPropList AS CHARACTER -- optional list of properties wanted. 
            The default (when this parameter is blank) is all the InstanceProps;
            other valid options are "*", for all properties, or a list of 
            specific properties wanted. 
   Returns: CHARACTER: delimited list of property name/value pairs with CHR(3)
            between pairs and CHR(4) between name and value.
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cInstanceProperties   AS CHARACTER NO-UNDO.
  DEFINE VARIABLE iNumProps           AS INTEGER   NO-UNDO. 
  DEFINE VARIABLE iEntry              AS INTEGER   NO-UNDO.
  DEFINE VARIABLE iProc               AS INTEGER   NO-UNDO.
  DEFINE VARIABLE cProcs              AS CHARACTER NO-UNDO.
  DEFINE VARIABLE hProc               AS HANDLE    NO-UNDO.
  DEFINE VARIABLE cPropValues         AS CHARACTER NO-UNDO INIT '':U.
  DEFINE VARIABLE cProperty           AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cSignature          AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cEntries            AS CHARACTER NO-UNDO.
  DEFINE VARIABLE lTranslate          AS LOGICAL   NO-UNDO INIT no.
  DEFINE VARIABLE cTranslatable       AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cValue              AS CHARACTER NO-UNDO.
  
  IF pcPropList = 'ADM-TRANSLATABLE-FORMAT':U THEN
  DO:
    lTranslate = yes.
    {get TranslatableProperties cTranslatable}.
    pcPropList = "":U.
  END.
  
  IF pcPropList = "":U OR pcPropList = ? THEN
    {get InstanceProperties cInstanceProperties}. /* Default */
  
  ELSE IF pcPropList = '*':U THEN
  DO:
    /* For now at least we define properties as being identified by a
       function that begins "get" without a following hyphen and which takes
       no arguments. We build a list of all of those properties, looking
       in the object itself and in all its super procedures. */
    cProcs = STRING(TARGET-PROCEDURE) + ",":U + 
      TARGET-PROCEDURE:SUPER-PROCEDURES.
    DO iProc = 1 TO NUM-ENTRIES(cProcs):  
      hProc = WIDGET-HANDLE(ENTRY(iProc, cProcs)).
      IF VALID-HANDLE(hproc) THEN
      DO:
        cEntries = hProc:INTERNAL-ENTRIES.
        iNumProps = NUM-ENTRIES(cEntries).
        DO iEntry = 1 TO iNumProps:
          cProperty = ENTRY(iEntry, cEntries).
          /* If there's a get property and it's not already in our list... */
          IF cProperty BEGINS "get":U and SUBSTR(cProperty,4,1) NE "-":U 
            AND LOOKUP(SUBSTR(cProperty, 4), cInstanceProperties) = 0 THEN
          DO:
            cSignature = hProc:GET-SIGNATURE(cProperty).
            IF ENTRY(1, cSignature) = "FUNCTION":U AND  /* It's a function... */
             NUM-ENTRIES(cSignature) = 3 AND     /* Null 3rd entry means no args */
             ENTRY(3, cSignature) = "":U THEN
               cInstanceProperties = cInstanceProperties +
                 (IF cInstanceProperties NE '':U THEN ',':U ELSE '':U ) + 
                    SUBSTR(cProperty, 4). /* Skip the "get" prefix */
          END.   /* END DO IF get */
        END.     /* END DO IEntry */
      END.       /* END DO IF VALID-HANDLE(hProc) */
    END.         /* END DO iProc */
    
    /* Now add any ad hoc properties which have been defined. */
    cEntries = ENTRY(2, TARGET-PROCEDURE:ADM-DATA, CHR(1)).
    DO iEntry = 1 TO NUM-ENTRIES(cEntries, CHR(3)):
      cInstanceProperties = cInstanceProperties +
        (IF cInstanceProperties NE '':U THEN ',':U ELSE '':U ) + 
          ENTRY(1,ENTRY(iEntry, cEntries, CHR(3)),CHR(4)).
    END.    /* END DO iEntry */
  END.      /* END DO IF "*" */
  
  ELSE cInstanceProperties = pcPropList.  /* Give them the ones they asked for. */
  
  IF lTranslate THEN cPropValues = "'":U.  /* In quotes if xlatable */
  
  iNumProps = NUM-ENTRIES(cInstanceProperties).
  IF lTranslate AND (iNumProps = 0) THEN     /* If no properties at all, */
    cPropValues = "''":U.                   /*   just close the quote.*/
  DO iEntry = 1 TO iNumProps:
    cProperty = ENTRY(iEntry, cInstanceProperties).
    /* We better avoid calling asHandle if unbound as this actually will
       do a bind ..*/
    IF cProperty = 'AsHandle':U AND NOT {fn getAsBound} THEN
       cValue = '':U.  
    ELSE DO:
      cValue = STRING(dynamic-function('get':U + cProperty IN TARGET-PROCEDURE))
               NO-ERROR.
      IF cValue = ? THEN 
      DO:
        /* This is an ad hoc user property. */
        IF ERROR-STATUS:GET-MESSAGE(1) > '':U THEN
        DO:
          /* pre v10.1B used to set all unknown to blank, 
             kept this after cleanup, could possibly do next
             as unknown means non-existing user prop  */               
          cValue = {fnarg getUserProperty cProperty}.
          IF cValue = ? THEN
            cValue = '':U.
        END.
        ELSE
          cValue = "?":U.
      END.
    END.

    IF lTranslate THEN       /* Return the special form with :Us */
    DO:
      cValue = REPLACE (cValue,"'":U, "~~'":U).
      cPropValues = cPropValues
                  + (IF cPropValues NE "'":U THEN CHR(3) ELSE '':U)
                  + cProperty + CHR(4).
      IF LOOKUP(cProperty, cTranslatable) NE 0 THEN
      DO:
        cPropValues = cPropValues + "':U + '":U + cValue + "'":U.
        IF iEntry NE iNumProps THEN 
           cPropValues = cPropValues + " + '":U.
      END.
      ELSE 
        cPropValues = cPropValues + cValue.  /* This one's not xlatable */
    END.   /* END if lTranslate */
    ELSE cPropValues = cPropValues
                     + (IF cPropValues NE '':U THEN CHR(3) ELSE '':U)
                     + cProperty 
                     + CHR(4) 
                     + cValue.
  END.
  
  /* If this is the last property and the user wants the translatable format
     and this last property was not translatable, then put ':U at the end. */
  IF lTranslate AND LOOKUP(cProperty, cTranslatable) = 0 THEN
    cPropValues = cPropValues + "':U":U.
    
  RETURN cPropValues.
  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-isDialogBoxParent) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION isDialogBoxParent Procedure 
FUNCTION isDialogBoxParent RETURNS LOGICAL
  ( INPUT hWidget AS HANDLE ) :
/*------------------------------------------------------------------------------
  Purpose: TRUE if any parent widget of 'hWidget' is a DIALOG-BOX
    Notes:  
------------------------------------------------------------------------------*/
  IF VALID-HANDLE(hWidget) THEN
      IF hWidget:TYPE = "DIALOG-BOX":U THEN
         RETURN TRUE.
      ELSE 
         IF CAN-QUERY(hWidget, "PARENT":U) THEN
             RETURN isDialogBoxParent(hWidget:PARENT).
         ELSE
             RETURN FALSE.
  ELSE
      RETURN FALSE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-isFunctionInCallStack) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION isFunctionInCallStack Procedure 
FUNCTION isFunctionInCallStack RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns TRUE if there is a Function in the call stack. 
    Notes:  
------------------------------------------------------------------------------*/
DEFINE VARIABLE cSuperList     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cSuperNameList AS CHARACTER  NO-UNDO.
DEFINE VARIABLE iVar           AS INTEGER    NO-UNDO INIT 1. 
DEFINE VARIABLE cName          AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cIpName        AS CHARACTER  NO-UNDO.
DEFINE VARIABLE hProcedure     AS HANDLE     NO-UNDO.
DEFINE VARIABLE cSignature     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE iIdx           AS INTEGER    NO-UNDO.

/* create a list of session procedures and their names */
hProcedure = SESSION:FIRST-PROCEDURE.
REPEAT WHILE valid-handle(hProcedure):
  IF hProcedure:TYPE = "PROCEDURE":U THEN
    ASSIGN
      cSuperList = cSuperList + (IF cSuperList > "" THEN "," ELSE "") +
                   STRING(hProcedure)
      cSuperNameList = cSuperNameList + 
                        (IF cSuperNameList > "" THEN "," ELSE "") +
                        hProcedure:FILE-NAME.
  hProcedure = hProcedure:NEXT-SIBLING.
END.
                                             
/* scan the call stack until a fuction is found (return true) or we reach */
/* the end of the stack (return false) */
REPEAT:
  ASSIGN 
    iVar = iVar + 1     /* do not include THIS function */
    cName = PROGRAM-NAME(iVar)
    hProcedure = ?.

  IF cName = ? OR cName = '' /* 20030306-008, iz9204 */ THEN  /* end of stack */
    LEAVE.
  IF NUM-ENTRIES(cName, " ") = 1 THEN  
    NEXT.               /* not interested in external procedures */

  ASSIGN
      cIpName = ENTRY(1, cname, " ")
      cName = ENTRY(2, cname, " ")
      iIdx = LOOKUP(cName, cSuperNameList).
  
  IF iIdx > 0 THEN
      hProcedure = WIDGET-HANDLE(ENTRY(iIdx, cSuperList)).

  IF VALID-HANDLE(hProcedure) THEN
      IF entry(1, hProcedure:GET-SIGNATURE(cIpName)) = "FUNCTION":U THEN
         RETURN TRUE.
END.

RETURN FALSE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-isLinkInactive) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION isLinkInactive Procedure 
FUNCTION isLinkInactive RETURNS LOGICAL
  (pcLinkType AS CHAR,
   phObject   AS HANDLE):
/*------------------------------------------------------------------------------
   Purpose: Check if a particular link is inactivate  
Parameters:
    pcLinkType - LinkType  f.ex 'DataSource'.        
    phObject   - Object in other end of link     
               - ? - if object does not matter  
                     may be used with links that only supports one object 
                     or cases where one only need to know if any link is 
                     inactive (or all links are active).    
     Notes: Whenever possible pass in the object as single links may change 
            to multiple links.    
         -  The inactivelinks property is maintained by the modifyInactiveLinks
            function. 
------------------------------------------------------------------------------*/
  DEFINE VARIABLE iPos         AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cLinks       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cHandles     AS CHARACTER  NO-UNDO.
  
  /* Ignore ANY dashes in linkname  */ 
  pcLinkType = REPLACE(pcLinkType,'-':U,'':U).

  {get InactiveLinks cLinks}.
  iPos = LOOKUP(pcLinkType,cLinks).   
  IF iPos > 0 AND phObject <> ? THEN 
  DO:
    cHandles = ENTRY(iPos + 1,cLinks).
    RETURN LOOKUP(STRING(phObject),cHandles,';':U) > 0.
  END.
  ELSE 
    RETURN iPos > 0.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-linkHandles) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION linkHandles Procedure 
FUNCTION linkHandles RETURNS CHARACTER
  ( pcLink AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Takes a link name and returns a list of handles of objects at
            the other end of that link, relative to the TARGET-PROCEDURE.
   Params:  pcLink AS CHARACTER -- Link name (including "-SOURCE" or "-TARGET")
  Returns:  CHARACTER: comma-separated list of handles 
    Notes:  ADM2 version of get-link-handle IN V8. NOTE: If the link type
            does not exist in the object "" will be returned, not ?.
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cObjects     AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cLinkList    AS CHARACTER NO-UNDO.
  DEFINE VARIABLE iEntry       AS INTEGER   NO-UNDO.
  DEFINE VARIABLE cLinkEntry   AS CHARACTER NO-UNDO.
  cObjects = dynamic-function
   ("get":U + TRIM(SUBSTR(pcLink, 1, R-INDEX(pcLink,"-":U) - 1) +
     SUBSTR(pcLink, R-INDEX(pcLink, "-":U) + 1)) IN TARGET-PROCEDURE) NO-ERROR.
  IF cObjects = ? THEN 
  DO:
    /* Unknown means this is not a standard SupportedLink; so get the
       handle from ADM-DATA (see modifyUserLinks for format). */
    cObjects = "":U.     /* Init to blank in case it's not found here. */
    cLinkList = ENTRY(3, TARGET-PROCEDURE:ADM-DATA, CHR(1)).
    DO iEntry = 1 TO NUM-ENTRIES(cLinkList, CHR(3)):
      cLinkEntry = ENTRY(iEntry, cLinkList, CHR(3)).
      IF ENTRY(1, cLinkEntry, CHR(4)) = pcLink THEN
      DO:
        cObjects = ENTRY(2, cLinkEntry, CHR(4)).
        LEAVE.
      END. /* END DO IF ENTRY(1, */
    END.   /* END DO iEntry */
  END.     /* END DO IF ? */
  
  RETURN cObjects.
  
 END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-linkProperty) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION linkProperty Procedure 
FUNCTION linkProperty RETURNS CHARACTER
  ( pcLink AS CHARACTER, pcPropName AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the value of the requested property in the object at the
            other end of the specified link, relative to TARGET-PROCEDURE.
   Params:  INPUT pcLink     AS CHARACTER -- Link name,
            INPUT pcPropName AS CHARACTER -- Property name.
  Returns:  CHARACTER: property value in character form
    Notes:  ADM2 Version of request-attribute in V8. The value is returned in
            character format. If there is not exactly one object at the other
            end of the link, or that object is no longer there,
            the unknown value is returned.
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cObject AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cValue  AS CHARACTER NO-UNDO.
    
  cObject = dynamic-function ("get":U + 
     TRIM(SUBSTR(pcLink, 1, R-INDEX(pcLink,"-":U) - 1) +
     SUBSTR(pcLink, R-INDEX(pcLink, "-":U) + 1)) IN TARGET-PROCEDURE). 
     
  IF cObject NE ? AND NUM-ENTRIES(cObject) = 1 THEN
  DO:
    cValue = STRING(dynamic-function
      ("get":U + pcPropName IN WIDGET-HANDLE(cObject))) NO-ERROR.
    RETURN cValue.
  END.
  ELSE RETURN ?. 

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-mappedEntry) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION mappedEntry Procedure 
FUNCTION mappedEntry RETURNS CHARACTER
  (pcEntry     AS CHAR,
   pcList      AS CHAR,
   plFirst     AS LOG,
   pcDelimiter AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose: Return the 'other' entry in a separated list of paired entries.
           This is required to ensure that the lookup does not find a matching
           entry in the wrong part of the pair.  
              
Parameters:  INPUT pcEntry    - entry to lookup.  
             INPUT pcList     - comma separated list with paired entries. 
             INPUT plFirst    - TRUE  - lookup first and RETURN second.
                                FALSE - lookup second and RETURN first.
             INPUT pcDelmiter - Delimiter of pcList               
    Notes: Used to find mapped RowObject or database column in assignList.  
           In other cases, such as the ObjectMapping property of SBOs, an
           entry may occur more than once in the list, in which case a list
           of matching values is returned, using the same delimiter as the list.
        -  Returns ? if no entry is found          
------------------------------------------------------------------------------*/
  DEFINE VARIABLE iLookUp AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cList   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cValues AS CHARACTER  NO-UNDO.

  /* We use a work list so we are free to remove entries from it without
     risking to remove the value that we eventually want to return */
  ASSIGN
    cValues = ? /* Set to ? to identify not found (Blank may be found) */
    cList   = pcList.
  DO WHILE TRUE:
    iLookup = LOOKUP(pcEntry,cList,pcDelimiter).
    
    /* The entry is no longer in the list or not at all, so return any values 
       we have found in earlier passes; if none found unknown will be returned.*/
    IF iLookup = 0 OR iLookup = ? THEN 
      RETURN cValues.

    /* If this is the correct half of the pair add the other part from the
       original list to the list of values to return. */
    IF iLookup MODULO 2 = (IF plFirst THEN 1 ELSE 0) THEN
      cValues = (IF cValues <> ? THEN cValues + pcDelimiter ELSE '':U)
              + ENTRY(IF plFirst THEN (iLookup + 1) ELSE (iLookup - 1),
                      pcList,
                      pcDelimiter).
    
    /* We remove this entry (right or wrong) from the work list to be able 
       to lookup the next. (Setting it to blank if we are looking for blank
       will cause an endless loop so we set it to '?' in that case )*/ 
    ENTRY(iLookup,cList,pcDelimiter) = IF pcEntry <> '':U THEN '':U ELSE '?':U.
  END. /* do while true */
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-mergeLists) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION mergeLists Procedure 
FUNCTION mergeLists RETURNS CHARACTER
  ( pcList1     AS CHAR,
    pcList2     AS CHAR,
    pcDlm1      AS CHAR,
    pcDlm2      AS CHAR,
    pcNewDlm    AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose: Return a paired list of two lists 
    Notes: The main reason that this exists is performance, it is approx 
           50% faster to merge without a loop.  
------------------------------------------------------------------------------*/
 DEFINE VARIABLE iNumEntries AS INTEGER    NO-UNDO.
 DEFINE VARIABLE cMergeList  AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE iNum        AS INTEGER    NO-UNDO.
 
 ASSIGN
   pcDlm1    = IF pcDlm1  = '':U THEN ' ':U ELSE IF pcDlm1 <> ? THEN pcDlm1 ELSE ',':U 
   pcDlm2    = IF pcDlm2 = '':U THEN ' ':U ELSE IF pcDlm2 <> ? THEN pcDlm2 ELSE ',':U 
   pcNewDlm  = IF pcNewDlm = '':U THEN ' ':U ELSE IF pcNewDlm <> ? THEN pcNewDlm ELSE ',':U 
   iNumEntries = NUM-ENTRIES(pcList1,pcDlm1).
 /* New assign for WHEN evaluation of iNumentries */ 
 ASSIGN  
   cMergeList  = REPLACE(pcList1,pcDlm1,pcNewDlm)
   ENTRY(( 1 * 2) - 1,cMergelist,pcNewDlm) = ENTRY( 1,pcList1,pcDlm1) + pcNewDlm + ENTRY( 1,pcList2,pcDlm2) WHEN iNumEntries >= 1
   ENTRY(( 2 * 2) - 1,cMergelist,pcNewDlm) = ENTRY( 2,pcList1,pcDlm1) + pcNewDlm + ENTRY( 2,pcList2,pcDlm2) WHEN iNumEntries >= 2
   ENTRY(( 3 * 2) - 1,cMergelist,pcNewDlm) = ENTRY( 3,pcList1,pcDlm1) + pcNewDlm + ENTRY( 3,pcList2,pcDlm2) WHEN iNumEntries >= 3
   ENTRY(( 4 * 2) - 1,cMergelist,pcNewDlm) = ENTRY( 4,pcList1,pcDlm1) + pcNewDlm + ENTRY( 4,pcList2,pcDlm2) WHEN iNumEntries >= 4
   ENTRY(( 5 * 2) - 1,cMergelist,pcNewDlm) = ENTRY( 5,pcList1,pcDlm1) + pcNewDlm + ENTRY( 5,pcList2,pcDlm2) WHEN iNumEntries >= 5
   ENTRY(( 6 * 2) - 1,cMergelist,pcNewDlm) = ENTRY( 6,pcList1,pcDlm1) + pcNewDlm + ENTRY( 6,pcList2,pcDlm2) WHEN iNumEntries >= 6
   ENTRY(( 7 * 2) - 1,cMergelist,pcNewDlm) = ENTRY( 7,pcList1,pcDlm1) + pcNewDlm + ENTRY( 7,pcList2,pcDlm2) WHEN iNumEntries >= 7
   ENTRY(( 8 * 2) - 1,cMergelist,pcNewDlm) = ENTRY( 8,pcList1,pcDlm1) + pcNewDlm + ENTRY( 8,pcList2,pcDlm2) WHEN iNumEntries >= 8
   ENTRY(( 9 * 2) - 1,cMergelist,pcNewDlm) = ENTRY( 9,pcList1,pcDlm1) + pcNewDlm + ENTRY( 9,pcList2,pcDlm2) WHEN iNumEntries >= 9
   ENTRY((10 * 2) - 1,cMergelist,pcNewDlm) = ENTRY(10,pcList1,pcDlm1) + pcNewDlm + ENTRY(10,pcList2,pcDlm2) WHEN iNumEntries >= 10
   ENTRY((11 * 2) - 1,cMergelist,pcNewDlm) = ENTRY(11,pcList1,pcDlm1) + pcNewDlm + ENTRY(11,pcList2,pcDlm2) WHEN iNumEntries >= 11
   ENTRY((12 * 2) - 1,cMergelist,pcNewDlm) = ENTRY(12,pcList1,pcDlm1) + pcNewDlm + ENTRY(12,pcList2,pcDlm2) WHEN iNumEntries >= 12
   ENTRY((13 * 2) - 1,cMergelist,pcNewDlm) = ENTRY(13,pcList1,pcDlm1) + pcNewDlm + ENTRY(13,pcList2,pcDlm2) WHEN iNumEntries >= 13
   ENTRY((14 * 2) - 1,cMergelist,pcNewDlm) = ENTRY(14,pcList1,pcDlm1) + pcNewDlm + ENTRY(14,pcList2,pcDlm2) WHEN iNumEntries >= 14
   ENTRY((15 * 2) - 1,cMergelist,pcNewDlm) = ENTRY(15,pcList1,pcDlm1) + pcNewDlm + ENTRY(15,pcList2,pcDlm2) WHEN iNumEntries >= 15
   ENTRY((16 * 2) - 1,cMergelist,pcNewDlm) = ENTRY(16,pcList1,pcDlm1) + pcNewDlm + ENTRY(16,pcList2,pcDlm2) WHEN iNumEntries >= 16
   ENTRY((17 * 2) - 1,cMergelist,pcNewDlm) = ENTRY(17,pcList1,pcDlm1) + pcNewDlm + ENTRY(17,pcList2,pcDlm2) WHEN iNumEntries >= 17
   ENTRY((18 * 2) - 1,cMergelist,pcNewDlm) = ENTRY(18,pcList1,pcDlm1) + pcNewDlm + ENTRY(18,pcList2,pcDlm2) WHEN iNumEntries >= 18
   ENTRY((19 * 2) - 1,cMergelist,pcNewDlm) = ENTRY(19,pcList1,pcDlm1) + pcNewDlm + ENTRY(19,pcList2,pcDlm2) WHEN iNumEntries >= 19
   ENTRY((20 * 2) - 1,cMergelist,pcNewDlm) = ENTRY(20,pcList1,pcDlm1) + pcNewDlm + ENTRY(20,pcList2,pcDlm2) WHEN iNumEntries >= 20
   ENTRY((21 * 2) - 1,cMergelist,pcNewDlm) = ENTRY(21,pcList1,pcDlm1) + pcNewDlm + ENTRY(21,pcList2,pcDlm2) WHEN iNumEntries >= 21
   ENTRY((22 * 2) - 1,cMergelist,pcNewDlm) = ENTRY(22,pcList1,pcDlm1) + pcNewDlm + ENTRY(22,pcList2,pcDlm2) WHEN iNumEntries >= 22
   ENTRY((23 * 2) - 1,cMergelist,pcNewDlm) = ENTRY(23,pcList1,pcDlm1) + pcNewDlm + ENTRY(23,pcList2,pcDlm2) WHEN iNumEntries >= 23
   ENTRY((24 * 2) - 1,cMergelist,pcNewDlm) = ENTRY(24,pcList1,pcDlm1) + pcNewDlm + ENTRY(24,pcList2,pcDlm2) WHEN iNumEntries >= 24
   .
 DO iNum = 25 TO iNumEntries:
   ENTRY((iNum * 2) - 1,cMergelist,pcNewDlm) = ENTRY(iNum,pcList1,pcDlm1) + pcNewDlm + ENTRY(iNum,pcList2,pcDlm2).
 END.

 RETURN cMergeList.
 
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-messageNumber) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION messageNumber Procedure 
FUNCTION messageNumber RETURNS CHARACTER
  ( piMessage AS INTEGER ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns a message text given a message number. Allows these
            these messages to be translated and kept track of in one place
            (src/adm2/admmsgs.i)
   Params:  INPUT piMessage AS INTEGER
  Returns:  CHARACTER: message text
------------------------------------------------------------------------------*/

  {src/adm2/admmsgs.i}    /* Defines the array cADMMessages */
  
  RETURN cADMMessages[piMessage].

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-modifyInactiveLinks) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION modifyInactiveLinks Procedure 
FUNCTION modifyInactiveLinks RETURNS LOGICAL
  ( pcMode     AS CHAR,
    pcLinkType AS CHAR,
    phObject   AS HANDLE) :
/*------------------------------------------------------------------------------
  Purpose: Modify the internal InactiveLinks property that is used to keep track
           of inactivelinks for the object.    
 Parameters:
     pcMode  - 'ADD'    - add to list  
             - 'REMOVE' - Remove from list        
     pcLinkType - LinkType  f.ex 'DataSource'.        
     phObject   - Object in other end of link     
    Notes: The property is stored as a comma-separated paired list where the
           second entry of each pair is a semi-colon separated list of object
           handles 
        -  The isLinklnactive should be used to check if an actual link is 
           inactive                 
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cLinks       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iPos         AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cHandles     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iHandle      AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cD1          AS CHARACTER  NO-UNDO INIT ',':U.
  DEFINE VARIABLE cD2         AS CHARACTER  NO-UNDO INIT ';':U.

  /* Ignore ANY dashes in linkname  */ 
  pcLinkType = REPLACE(pcLinkType,'-':U,'':U).

  {get InactiveLinks cLinks}.
  iPos = LOOKUP(pcLinkType,cLinks).
  
  IF pcMode = 'ADD':U THEN
  DO:
    IF iPos = 0 THEN
      ASSIGN
        cLinks = cLinks 
               + (IF cLinks = '':U THEN '':U ELSE cD1)
               + pcLinkType
               + cD1
               + STRING(phObject).
    ELSE DO:
      ASSIGN
        cHandles = ENTRY(iPos + 1,cLinks)
        cHandles = cHandles 
                 + (IF cHandles = '':U THEN '':U ELSE cD2)
                 + STRING(phObject)
        ENTRY(iPos + 1,cLinks) = cHandles.
    END.
  END.
  ELSE IF pcMode = 'REMOVE':U AND iPos > 0 THEN
  DO:
    cHandles = ENTRY(iPos + 1,cLinks).
    IF NUM-ENTRIES(cHandles,cD2) = 1 OR phObject = ? THEN
    DO:
      ENTRY(iPos,cLinks) = '':U.
      ENTRY(iPos + 1,cLinks) = '':U.
      cLinks = TRIM(REPLACE(cD1 + cLinks + cD1,cD1 + cD1,cD1),cD1). 
    END.
    ELSE DO:
      iHandle = LOOKUP(STRING(phObject),cHandles,cD2).
      IF iHandle > 0 THEN
        ASSIGN 
          ENTRY(iHandle,cHandles,cD2) = '':U
          cHandles = TRIM(REPLACE(cD2 + cHandles + cD2,cD2 + cD2,cD2),cD2).
          ENTRY(iPos + 1,cLinks) = cHandles.
    END.
  END.
  {set InactiveLinks cLinks}.
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-propertyType) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION propertyType Procedure 
FUNCTION propertyType RETURNS CHARACTER
  ( pcPropName AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Locates the "set" property function for the specified property name
            either locally or in a SUPER procedure, and returns its datatype.
   Params:  INPUT pcPropName AS CHARACTER -- Property name
  Returns:  CHARACTER: datatype of the property
------------------------------------------------------------------------------*/

  DEFINE VARIABLE hProc      AS HANDLE    NO-UNDO.
  DEFINE VARIABLE i          AS INTEGER   NO-UNDO.
  DEFINE VARIABLE cSetProp   AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cSupers    AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cSignature AS CHARACTER NO-UNDO.
  DEFINE VARIABLE hSuper     AS HANDLE    NO-UNDO.
  
  cSetProp = "set":U + pcPropName.
  IF LOOKUP(cSetProp, TARGET-PROCEDURE:INTERNAL-ENTRIES) NE 0 THEN
      hProc = TARGET-PROCEDURE.
  ELSE DO:
    cSupers = TARGET-PROCEDURE:SUPER-PROCEDURES.
    /* Go in reverse so customizations is found first. The customization may have changed 
       the data type. For example link functions like getUpdateSource mneed to be changed to 
       support multiple objects. */
    DO i = NUM-ENTRIES(cSupers) TO 1 BY -1: 
      hSuper = WIDGET-HANDLE(ENTRY(i, cSupers)).
      IF LOOKUP(cSetProp, hSuper:INTERNAL-ENTRIES) NE 0 THEN
      DO:
        hProc = hSuper.
        LEAVE.
      END.     /* END DO IF found the function. */
    END.       /* END DO i -- for each super procedure. */
  END.         /* END ELSE DO IF not found in the object's entries list. */
  IF VALID-HANDLE(hProc) THEN
  DO:
    /* Signature should be "FUNCTION,LOGICAL, INPUT <param> <type>" */
    cSignature = hProc:GET-SIGNATURE(cSetProp).  
    IF NUM-ENTRIES(cSignature) NE 3 OR
       ENTRY(1, cSignature) NE "FUNCTION":U OR
       ENTRY(2, cSignature) NE "LOGICAL":U THEN
       RETURN ?.
    ELSE DO:
       cSignature = ENTRY(3, cSignature).
       IF NUM-ENTRIES(cSignature, " ":U) NE 3 OR
          ENTRY(1, cSignature, " ":U) NE "INPUT":U THEN
          RETURN ?.
       ELSE RETURN ENTRY(3, cSignature, " ":U).
    END.
  END.
  ELSE RETURN ?.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-reviewMessages) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION reviewMessages Procedure 
FUNCTION reviewMessages RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns a delimited list of all messages, without removing
            them from the log. 
   Params:  <none>
  Returns:  CHARACTER: The message list is delimited by CHR(3); within each 
            message, the message text, the Field (if any), and the Table 
            (if any) are delimited by CHR(4). 
    Notes:  Use the similar function fetchMessages to read messages
            and delete them from the log, which is the norm.
------------------------------------------------------------------------------*/

  RETURN gcDataMessages.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setChildDataKey) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setChildDataKey Procedure 
FUNCTION setChildDataKey RETURNS LOGICAL
  ( cChildDataKey AS CHARACTER) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    {set ChildDataKey cChildDataKey}.
    RETURN TRUE.                      
  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setClassName) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setClassName Procedure 
FUNCTION setClassName RETURNS LOGICAL
        ( INPUT pcClassName        AS CHARACTER ):
/*------------------------------------------------------------------------------
  Purpose:  Sets the value of the Repository class name
  Notes:    * This should only be done by the Repository retrieval.
------------------------------------------------------------------------------*/
    &SCOPED-DEFINE xpClassName
    {set ClassName pcClassName}.
    &UNDEFINE xpClassName
    
    RETURN TRUE.
END FUNCTION.    /* setClassName */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setContainerHidden) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setContainerHidden Procedure 
FUNCTION setContainerHidden RETURNS LOGICAL
  ( plHidden AS LOGICAL ) :
/*------------------------------------------------------------------------------
  Purpose:  Sets the ContainerHidden property, indicating that this object's
            SmartContainer (SmartWindow, SmartFrame...) has been hidden.
    Params: plHidden AS LOGICAL.
   Returns: LOGICAL (true)
    Notes:  This is called from the containers hide- and viewObject. 
            A publish of linkState will be done if the object has a datasource 
            outside the container in order to deactivate datalinks from outside 
            objects on hide of the container and activate datalinks again on 
            view of the container.            
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hContainerSource AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hDataSource      AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hDataContSource  AS HANDLE     NO-UNDO.

  &SCOPED-DEFINE xp-assign
  {get ContainerSource hContainerSource}
  {get DataSource hDataSource}
  {set ContainerHidden plHidden}
  .
  &UNDEFINE xp-assign
  
  IF VALID-HANDLE(hDataSource) AND VALID-HANDLE(hContainerSource) THEN
  DO:
    /* If our datasource is in another container we publish the fact that 
       the object is active/inactive so that links can be disabled/enabled
       accordingly. (This is also done as part of hide/view, but when the 
       container is hidden hideObject and viewObject is not done */
    {get ContainerSource hDataContSource hDataSource}.
    IF VALID-HANDLE(hDataContSource) 
    AND hDataContSource <> hContainerSource THEN
      PUBLISH 'LinkState':U FROM TARGET-PROCEDURE (IF plHidden THEN 'inactive':U
                                                   ELSE 'active').

  END.
  
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setContainerSource) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setContainerSource Procedure 
FUNCTION setContainerSource RETURNS LOGICAL
  ( phObject AS HANDLE ) :
/*------------------------------------------------------------------------------
  Purpose:  Sets the ContainerSource link value.
   Params:  INPUT phObject AS HANDLE -- procedure handle of the object 
            which should become the Container-Source
  Returns:  LOGICAL (true)
------------------------------------------------------------------------------*/
    /* This should be run only from add/removeLink and modifyListProperty.
       It's needed because the callers get a variable link name for which
       {set} can't be used. */

  {set ContainerSource phObject}.
  RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setContainerSourceEvents) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setContainerSourceEvents Procedure 
FUNCTION setContainerSourceEvents RETURNS LOGICAL
  ( pcEvents AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  Stores a comma-separated list of the events this object 
            wants to subscribe to in its ContainerSource
   Params:  pcEvents - List of events
  Returns:  CHARACTER
------------------------------------------------------------------------------*/
  
  {set ContainerSourceEvents pcEvents}.
  
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setDataLinksEnabled) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setDataLinksEnabled Procedure 
FUNCTION setDataLinksEnabled RETURNS LOGICAL
  ( lDataLinksEnabled AS LOGICAL ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  DEPRECATED 
------------------------------------------------------------------------------*/
 {set DataLinksEnabled lDataLinksEnabled}.
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setDataSource) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setDataSource Procedure 
FUNCTION setDataSource RETURNS LOGICAL
  ( phObject AS HANDLE ) :
/*------------------------------------------------------------------------------
  Purpose:  Sets the DataSource link value.
   Params:  phObject AS HANDLE -- Procedure handle of
            the object which should be made this object's Data-Source
  Returns:  LOGICAL (true)
    Notes: There iS no xp preprosessor in order to allow design-time override  
            of getDataSource
------------------------------------------------------------------------------*/
  &SCOPED-DEFINE xpDataSource
  {set DataSource phObject}.
  &UNDEFINE xpDataSource
  
  RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setDataSourceEvents) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setDataSourceEvents Procedure 
FUNCTION setDataSourceEvents RETURNS LOGICAL
  ( pcEventsList AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Modifies the list of DataSourceEvents. 
   Params:  pcEventsList AS CHARACTER -- comma-separated list of events.
  Returns:  LOGICAL (true)
    Notes:  Because this is a comma-separated list, it should normally be
            invoked indirectly, through modifyListProperty.
------------------------------------------------------------------------------*/

   {set DataSourceEvents pcEventsList}.
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setDataSourceNames) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setDataSourceNames Procedure 
FUNCTION setDataSourceNames RETURNS LOGICAL
  ( pcSourceNames AS CHAR ) :
/*------------------------------------------------------------------------------
 Purpose: Stores the ObjectName of the Data Object that sends data to this
          visual object. This would be set if the data-Source is an SBO
          or other Container with DataObjects.
  Params: pcSourceNames 
   Notes: Used both by visual objects and SDOs. 
          See the SBOs addDataTarget for more details on how this is set.  
------------------------------------------------------------------------------*/
  {set DataSourceNames pcSourceNames}.
  
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setDataTarget) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setDataTarget Procedure 
FUNCTION setDataTarget RETURNS LOGICAL
  ( pcTarget AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Sets the DataTarget object handle, normally for pass-through 
            support.
   Params:  pcTarget AS CHARACTER -- DataTarget procedure handle.
    Notes:  Because this can be a list, it should normally be changed using
            modifyListProperty.
------------------------------------------------------------------------------*/
  {set DataTarget pcTarget}.
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setDataTargetEvents) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setDataTargetEvents Procedure 
FUNCTION setDataTargetEvents RETURNS LOGICAL
  ( pcEvents AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:     Resets the list of events this object subscribes to in its
               DataTarget.
  Parameters:  
    pcEvents - A comma-separated list of events to subscribe to.  
  Notes:       Normally modifyListProperty should be used to ADD or REMOVE 
               events from this list.
------------------------------------------------------------------------------*/
  {set DataTargetEvents pcEvents}.
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setDBAware) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setDBAware Procedure 
FUNCTION setDBAware RETURNS LOGICAL
  ( lAware AS LOGICAL ) :
/*------------------------------------------------------------------------------
  Purpose:  Sets a flag indicating whether this object is sensitive to being
            connected to a database or not.
   Params:  lAware AS LOGICAL
  Returns:  LOGICAL (true)
------------------------------------------------------------------------------*/

  {set DBAware lAware}.
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setDesignDataObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setDesignDataObject Procedure 
FUNCTION setDesignDataObject RETURNS LOGICAL
  ( pcDataObject AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Stores the name of the design-time dataobject. 
   Params:  pcDataObject AS CHARACTER -- name of the dataobject
    Notes:  
------------------------------------------------------------------------------*/
  {set DesignDataObject pcDataObject}.
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setDynamicObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setDynamicObject Procedure 
FUNCTION setDynamicObject RETURNS LOGICAL
  ( lTemp AS LOGICAL ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    {set DynamicObject lTemp}.
  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setHideOnInit) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setHideOnInit Procedure 
FUNCTION setHideOnInit RETURNS LOGICAL
  ( plHideOnInit AS LOGICAL ) :
/*------------------------------------------------------------------------------
  Purpose: Set the flag that indicates whether to visualize 
           at initialization.
Parameters: plHideOnInit - logical           
    Notes: Also used for non visual object in order to publish LinkState 
           correctly for activation and deactivation of links.   
------------------------------------------------------------------------------*/
  &scop xpHideOnInit
  {set HideOnInit plHideOnInit}.
  &undefine xpHideOnInit
  RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setInactiveLinks) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setInactiveLinks Procedure 
FUNCTION setInactiveLinks RETURNS LOGICAL
  ( pcInactiveLinks AS CHARACTER ) :
/*------------------------------------------------------------------------------
 Purpose: Retunrs the inactive links 
   Notes:   Stored as a comma-separated paired list where the second entry of 
            each pair is a semi-colon separated list of object handles 
        -   modifyInactiveLinks should be used to maintain thje property. 
        -   isLinklnactive should be used to check if an actual link is 
            inactive  
------------------------------------------------------------------------------*/
  {set InactiveLinks pcInactiveLinks}.
  RETURN TRUE. 

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setInstanceId) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setInstanceId Procedure 
FUNCTION setInstanceId RETURNS LOGICAL
  ( pdInstanceId AS DECIMAL ) :
/*------------------------------------------------------------------------------
  Purpose: This is the Repository manager's unique identifier of this instance  
    Notes: This should never need to be set.. except by the Repository Manager,
           which doesn't use this function...   
------------------------------------------------------------------------------*/
  {set InstanceId pdInstanceId}.
  RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setInstanceProperties) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setInstanceProperties Procedure 
FUNCTION setInstanceProperties RETURNS LOGICAL
  ( pcPropList AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Sets the list of instance properties. 
   Params:  pcPropList AS CHARACTER -- modified list of InstanceProperties
  Returns:  LOGICAL (true)
    Notes:  Because this is a comma-separated list, it should normally be
            invoked indirectly, through modifyListAttribute.
------------------------------------------------------------------------------*/

  {set InstanceProperties pcPropList}.
  RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setLabel) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setLabel Procedure 
FUNCTION setLabel RETURNS LOGICAL
  (pcLabel AS CHARACTER) :
/*------------------------------------------------------------------------------
  Purpose: Stores the LABEL defined for the selection   
Parameters: INPUT pcLabel - char     
------------------------------------------------------------------------------*/
  &SCOPED-DEFINE xpLabel
  {set Label pcLabel}.
  &UNDEFINE xpLabel
  RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setLayoutPosition) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setLayoutPosition Procedure 
FUNCTION setLayoutPosition RETURNS LOGICAL
        ( INPUT pcLayoutPosition                AS CHARACTER ):
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:
------------------------------------------------------------------------------*/
    {set LayoutPosition pcLayoutPosition}.
    
    RETURN TRUE.
END FUNCTION.   /* setLayoutPosition */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setLogicalObjectName) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setLogicalObjectName Procedure 
FUNCTION setLogicalObjectName RETURNS LOGICAL
  ( cName AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Set the LogicalObjectName 
    Notes:  This is the unique name of the object master in the repository 
------------------------------------------------------------------------------*/
  {set LogicalObjectName cName}.
  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setLogicalVersion) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setLogicalVersion Procedure 
FUNCTION setLogicalVersion RETURNS LOGICAL
  ( cVersion AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    &SCOPED-DEFINE xpLogicalVersion
    {set LogicalVersion cVersion}.
    &UNDEFINE xpLogicalVersion
  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setManageReadErrors) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setManageReadErrors Procedure 
FUNCTION setManageReadErrors RETURNS LOGICAL
  (plManageReadErrors AS LOGICAL ) :
/*------------------------------------------------------------------------------
  Purpose: Session property that tells if adm error mechanism is used on data 
           retrieval.
    Notes: This should only be set to true if one is absolutely sure that the 
           messages are emptied from the message queue when the request is 
           completed. ( stored in a variable in smart - see fetchMessages,
           addMessage and anyMessage)   
         - Used on server by some adm2 data request procedures - fetch*  
         - Set to false in fetchMessages 
------------------------------------------------------------------------------*/

  glManageReadErrors = plManageReadErrors.
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setMessageBoxType) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setMessageBoxType Procedure 
FUNCTION setMessageBoxType RETURNS LOGICAL
        ( input pcMessageBoxType as character ):
/*------------------------------------------------------------------------------
    Purpose:
    Notes:
------------------------------------------------------------------------------*/
    gcMessageBoxType = pcMessageBoxType.
    
    error-status:error = no.
    return true.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setObjectHidden) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setObjectHidden Procedure 
FUNCTION setObjectHidden RETURNS LOGICAL
  ( plHidden AS LOGICAL ) :
/*------------------------------------------------------------------------------
  Purpose:  sets the Object Hidden property 
   Params:  lHidden AS LOGICAL
------------------------------------------------------------------------------*/
  &SCOPED-DEFINE xpObjectHidden
  {set ObjectHidden plHidden}.
  &UNDEFINE xpObjectHidden
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setObjectName) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setObjectName Procedure 
FUNCTION setObjectName RETURNS LOGICAL
  ( pcName AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  sets the ObjectName property of the dynamic SDO.
   Params:  cName AS CHAR
    Notes:  The default name of a SmartObject is its simple file name
            (not including the _cl proxy suffix in the case of AppServer
            objects). This function can be used to reset it when needed.
------------------------------------------------------------------------------*/

  {set ObjectName pcName}.
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setObjectParent) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setObjectParent Procedure 
FUNCTION setObjectParent RETURNS LOGICAL
  ( phParent AS HANDLE ) :
/*------------------------------------------------------------------------------
  Purpose:  Sets the property ObjectParent, the widget handle of this
            SmartObject's Container-Source's Frame or Window.
   Params:  INPUT phParent AS HANDLE -- Frame or Window handle.
  Returns:  LOGICAL: true if assign succeeds; false if parent handle param or
            ContainerHandle property is not a valid handle.
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hObject AS HANDLE NO-UNDO.
  
  {get ContainerHandle hObject}.
  IF VALID-HANDLE(hObject) AND VALID-HANDLE(phParent) THEN
  DO:
    IF CAN-DO( "DIALOG-BOX,FRAME":U, phParent:TYPE) THEN
    DO:
        IF CAN-SET(hObject, "FRAME":U) THEN
            ASSIGN hObject:FRAME = phParent.
    END.    /* Dialogue box or frame */
    ELSE ASSIGN hObject:PARENT = phParent.
    RETURN TRUE.
  END.
  ELSE RETURN FALSE.
  
 END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setObjectsCreated) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setObjectsCreated Procedure 
FUNCTION setObjectsCreated RETURNS LOGICAL
  ( plCreated AS LOGICAL ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns a flag indicating whether this object has run createObjects
            for page 0.
   Params:  <none>
    Notes:  Some containers run createObjects from the main block while others
            start them from initializeObject. The create initializeObject is 
            often too late so this flag was introduced to allow us to have more
            control over when the objects are created and run createObjects 
            before initializeObject for all objects 
----------------------------------------------------------------------------*/
  {set ObjectsCreated plCreated}.
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setObjectVersion) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setObjectVersion Procedure 
FUNCTION setObjectVersion RETURNS LOGICAL
  ( cObjectVersion AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    {set ObjectVersion cObjectVersion}.                               
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setParentDataKey) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setParentDataKey Procedure 
FUNCTION setParentDataKey RETURNS LOGICAL
  ( cParentDataKey AS CHARACTER) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    {set ParentDataKey cParentDataKey}.
    RETURN TRUE.                      
  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setPassThroughLinks) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setPassThroughLinks Procedure 
FUNCTION setPassThroughLinks RETURNS LOGICAL
  ( pcLinks AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose: Sets the variable which stores links which can be passed through 
   Params: pcLinks AS CHARACTER -- comma-separated list of links.
           Each link actually consists of <linkname>;single/multiple,
           where single means only one target is supported, so the original
           link to the container should be deleted when the links are combined.
  Returns: LOGICAL (true)
    Notes: This property is shared by all objects. Because it is a list,
           it should normally be modified using modifyListProperty.
------------------------------------------------------------------------------*/

  scPassThroughLinks = pcLinks.
  
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setPhysicalObjectName) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setPhysicalObjectName Procedure 
FUNCTION setPhysicalObjectName RETURNS LOGICAL
  ( cTemp AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    {set PhysicalObjectName cTemp}.
  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setPhysicalVersion) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setPhysicalVersion Procedure 
FUNCTION setPhysicalVersion RETURNS LOGICAL
  ( cVersion AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    {set PhysicalVersion cVersion}.
  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setRenderingProcedure) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setRenderingProcedure Procedure 
FUNCTION setRenderingProcedure RETURNS LOGICAL
  ( cProcedure AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Set the RenderingProcedure 
    Notes:  
------------------------------------------------------------------------------*/
  {set RenderingProcedure cProcedure}.
  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setRunAttribute) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setRunAttribute Procedure 
FUNCTION setRunAttribute RETURNS LOGICAL
  ( cRunAttribute AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    {set RunAttribute cRunAttribute}.
  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setSuperProcedure) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setSuperProcedure Procedure 
FUNCTION setSuperProcedure RETURNS LOGICAL
        ( INPUT pcSuperProcedure                AS CHARACTER ):
/*------------------------------------------------------------------------------
  Purpose:  
        Notes: * The super procedure handle can be a comma-separate value list.
------------------------------------------------------------------------------*/
        &SCOPED-DEFINE xpSuperProcedure
        {set SuperProcedure pcSuperProcedure}.
        &UNDEFINE xpSuperProcedure
        
        RETURN TRUE.
END FUNCTION.   /* setSuperProcedure */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setSuperProcedureHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setSuperProcedureHandle Procedure 
FUNCTION setSuperProcedureHandle RETURNS LOGICAL
        ( INPUT pcProcedureHandle       AS CHARACTER  ):
/*------------------------------------------------------------------------------
  Purpose:  
        Notes: * The super procedure handle can be a comma-separate value list.
------------------------------------------------------------------------------*/
        &SCOPED-DEFINE xpSuperProcedureHandle
        {set SuperProcedureHandle pcProcedureHandle}.
        &UNDEFINE xpSuperProcedureHandle
                
        RETURN TRUE.
END FUNCTION.   /* setSuperProcedureHandle */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setSuperProcedureMode) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setSuperProcedureMode Procedure 
FUNCTION setSuperProcedureMode RETURNS LOGICAL
        ( INPUT pcProcedureMode         AS CHARACTER ):
/*------------------------------------------------------------------------------
  Purpose:  
        Notes:
------------------------------------------------------------------------------*/
        &SCOPED-DEFINE xpSuperProcedureMode
        {set SuperProcedureMode pcProcedureMode}.
        &UNDEFINE xpSuperProcedureMode
        
        RETURN TRUE.
END FUNCTION.   /* setSuperProcedureMode */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setSupportedLinks) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setSupportedLinks Procedure 
FUNCTION setSupportedLinks RETURNS LOGICAL
  ( pcLinkList AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Modifies the list of SupportedLinks. 
   Params:  pcLinkList AS CHARACTER -- comma-separated list of links.
  Returns:  LOGICAL (true)
    Notes:  Because this is a comma-separated list, it should normally be
            invoked indirectly, through modifyListProperty.
------------------------------------------------------------------------------*/
  IF pcLinkList = '':U THEN
     RETURN FALSE.
             
   {set SupportedLinks pcLinkList}.
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setThinRenderingProcedure) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setThinRenderingProcedure Procedure 
FUNCTION setThinRenderingProcedure RETURNS LOGICAL
  ( cProcedure AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Set the ThinRenderingProcedure 
    Notes:  
------------------------------------------------------------------------------*/
  {set ThinRenderingProcedure cProcedure}.
  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setTranslatableProperties) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setTranslatableProperties Procedure 
FUNCTION setTranslatableProperties RETURNS LOGICAL
  ( pcPropList AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Sets the list of translatable properties, those which should
            not have a ":U" following their literal values when code is
            generated in adm-create-objects. 
   Params:  pcPropList AS CHARACTER -- comma-separated list of properties.
  Returns:  LOGICAL (true)
    Notes:  Because this is a comma-separated list, it should normally be
            invoked indirectly, through modifyListAttribute.
------------------------------------------------------------------------------*/

   {set TranslatableProperties pcPropList}.
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setUIBMode) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setUIBMode Procedure 
FUNCTION setUIBMode RETURNS LOGICAL
  ( pcMode AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Sets the UIBMode property of the object.
   Params:  INPUT pcMode AS CHARACTER -- blank or "Design" are normal values.
  Returns:  LOGICAL (true)
    Notes:  In addition to setting the property, this property function
            runs an AppBuilder procedure which sets up the object for use
            in a design window, making it Movable, etc.
            For performance reasons, UIBMode has been made an xp property.  
            If you need to set it, make sure this function is invoked explicitly.
            Don't {set UIBMode...}
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cTarget AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iTarget AS INTEGER    NO-UNDO.
  DEFINE VARIABLE hTarget AS HANDLE     NO-UNDO.

  IF pcMode = "Design":U THEN
  DO:
      /* Make the object editable in the UIB */
      RUN adeuib/_uibmode.p (INPUT TARGET-PROCEDURE).
      /* Set UIBMode in all children of this object.  Note that they *
       * in turn will set UIBMode in their children and so on...     */
      {get ContainerTarget cTarget} NO-ERROR.
      DO iTarget = 1 TO NUM-ENTRIES(cTarget):
        hTarget = WIDGET-HANDLE(ENTRY(iTarget,cTarget)).
        IF VALID-HANDLE(hTarget) THEN
          {set UIBMode 'Design-Child':U hTarget}.
      END. 
  END.
 
  /* Set UIBMode for this object */
  {set UIBMode pcMode}.

  RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setUserProperty) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setUserProperty Procedure 
FUNCTION setUserProperty RETURNS LOGICAL
  ( pcPropName AS CHARACTER, pcPropValue AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Assigns a value to a dynamically-defined property,
            allocating a slot for the property if it doesn't exist yet.
   Params:  INPUT pcPropName AS CHARACTER, 
            INPUT pcPropValue AS CHARACTER
  Returns:  LOGICAL (true)
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cOldProps AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cNewProps AS CHARACTER NO-UNDO.
  DEFINE VARIABLE iIndex    AS INTEGER   NO-UNDO.
  DEFINE VARIABLE iNext     AS INTEGER   NO-UNDO.
  
  /* These ad hoc properties are stored in the second entry in the
     object's ADM-DATA attribute, as a string delimited by CHR(3)
     between property/value pairs and CHR(4) between the property name
     and its value. */
  /* Changed to delimit name/value with CHR(4). */
  IF pcPropValue = ? THEN           /* Don't allow unknown value. */
    pcPropValue = "":U.
  cOldProps = ENTRY(2, TARGET-PROCEDURE:ADM-DATA, CHR(1)).
  iIndex = INDEX(CHR(3) + cOldProps, CHR(3) + pcPropName + CHR(4)).
  IF iIndex = 0 THEN    /* Property wasn't defined yet. */
    cNewProps = cOldProps + (IF cOldProps NE "":U THEN CHR(3) ELSE "":U) +
      pcPropName + CHR(4) + pcPropValue.
  ELSE DO:
    ASSIGN iIndex = iIndex + LENGTH(pcPropName)  /* End of current prop name */
           /* iNext is the position of delimiter before the next property. */
           iNext = INDEX(SUBSTR(cOldProps, iIndex + 1), CHR(3))
           /* Substitute the new value for the old one, and then add back
              any other property values if there were any. */
           cNewProps = SUBSTR(cOldProps, 1, iIndex) + pcPropValue +
            (IF iNext NE 0 THEN SUBSTR(cOldProps, iIndex + iNext) ELSE "":U).
  END.   /* END DO IF iIndex NE 0 */
     
  
  TARGET-PROCEDURE:ADM-DATA = ENTRY(1,TARGET-PROCEDURE:ADM-DATA, CHR(1)) +
    CHR(1) + CNewProps + CHR(1) + 
    ENTRY(3, TARGET-PROCEDURE:ADM-DATA, CHR(1)). /* entry 3 is user links */
  
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-showDataMessages) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION showDataMessages Procedure 
FUNCTION showDataMessages RETURNS CHARACTER
  ( ) : 
/*------------------------------------------------------------------------------
  Purpose:   Returns the name of the field (if any) from the first
             error message, to allow the caller to use it to position the 
             cursor.
   Params:   <none>.   
   Notes:     Invokes fetchMessages() to retrieve all messages stored in the
              class property gcMessages.
             (normally database update-related error messages), and
             displays them in a alert-box of type error.
             This function expects to receive back a single string 
             from fetchMessages with one or more messages delimited by CHR(3),
             and within each message the message text, Fieldname (or blank) +
             a Tablename (or blank), delimited by CHR(4) if present.
           NOT IN USE BY standard ADM2, still used by WEB2 
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cMessages   AS CHARACTER NO-UNDO.
  DEFINE VARIABLE iMsg        AS INTEGER   NO-UNDO.
  DEFINE VARIABLE iMsgCnt     AS INTEGER   NO-UNDO.
  DEFINE VARIABLE cMessage    AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cFirstField AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cField      AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cTable      AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cText       AS CHARACTER NO-UNDO INIT "":U.

  cMessages = DYNAMIC-FUNCTION('fetchMessages':U IN TARGET-PROCEDURE).
  iMsgCnt = NUM-ENTRIES(cMessages, CHR(3)).
  DO iMsg = 1 TO iMsgCnt:
    /* Format a string of messages; each has a first line of
       "Field:  <field>    "Table:  <table>"
       (if either of these is defined) plus the error message on a
        separate line. */
    ASSIGN cMessage = ENTRY(iMsg, cMessages, CHR(3))
           cField = IF NUM-ENTRIES(cMessage, CHR(4)) > 1 THEN
             ENTRY(2, cMessage, CHR(4)) ELSE "":U
           cTable = IF NUM-ENTRIES(cMessage, CHR(4)) > 2 THEN
             ENTRY(3, cMessage, CHR(4)) ELSE "":U
           cText = cText + (IF cField NE "":U THEN
             dynamic-function('messageNumber':U IN TARGET-PROCEDURE, 10) ELSE "":U)              
             + cField + "   ":U +       
             (IF cTable NE "":U THEN 
             dynamic-function('messageNumber':U IN TARGET-PROCEDURE, 11) ELSE "":U) + cTable + 
             (IF cField NE "":U OR cTable NE "":U THEN "~n":U ELSE "":U)
                 + "  ":U + ENTRY(1, cMessage, CHR(4)) + "~n":U.
    /* Return the field name from the first error message so the caller can
       use it to position the cursor. */
    IF iMsg = 1 THEN cFirstField = cField.
  END.   /* END DO iMsg */
  IF cText NE "":U THEN
    MESSAGE cText VIEW-AS ALERT-BOX ERROR.

  RETURN cFirstField.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-showmessage) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION showmessage Procedure 
FUNCTION showmessage RETURNS LOGICAL
  ( pcMessage AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:     Displays (using a simple MESSAGE statement by default)
               either a literal message string, or a message number which
               is returned by the messageNumber function.
  Parameters: INPUT pcMessage AS CHARACTER -- 
              - Either a literal message string 
              - Or a message number in character form. 
               
               A message number can be followed by a comma delimited list
               with maximum 10 entries:
               
               The LAST entry (2 - 10) is:               
               1) The word "Question" or "YesNo", in which case the message is 
                  displayed with YES-NO buttons and the answer is returned.
               
               2) The word "YesNoCancel", in which case the message is displayed
                  with YES-NO-CANCEL buttons and the answer is returned.
              
               3) The word "OkCancel", in which case the message is displayed
                  with OK-CANCEL buttons and the answer is returned.   
                  
               Optional entries from 2 to 10: 
                  Each entry will be placed into the numeric message
                  in place of the the string of form &n, where n is an integer 
                  between 1 and 9, inclusive (Entry 2 will replace &1 etc)         
                  
    Returns:   LOGICAL: true/false if the Question option is used,
                        true/false/unknown if the YesNoCancel option is used 
                        else true.
  Notes:       This function can be overridden to use a mechanism other than
               the MESSAGE statement to display messages, and still use the
               messageNumber function to map message numbers to translatable text.
               Note that this is different from addMessage, fetchMessages, etc.,
               which log messages in a temp-table for later retrieval.
------------------------------------------------------------------------------*/
  DEFINE VARIABLE iMessage      AS INTEGER   NO-UNDO.
  DEFINE VARIABLE cMessage      AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cMessageType  AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cMsg          AS CHARACTER EXTENT 9 NO-UNDO.
  DEFINE VARIABLE iNumParam     AS INT       NO-UNDO.
  DEFINE VARIABLE lAnswer       AS LOGICAL   NO-UNDO.

  iMessage = INTEGER(ENTRY(1,pcMessage)) NO-ERROR.  /* was a number passed? */
  IF ERROR-STATUS:ERROR THEN 
    MESSAGE pcMessage VIEW-AS ALERT-BOX INFORMATION. /* No -- use the literal text */
  ELSE DO:   /* A numeric message */
    ASSIGN
      cMessage     = messageNumber(iMessage)
      iNumParam    = NUM-ENTRIES(pcMessage)
      cMessageType = ENTRY(iNumParam,pcMessage)
      cMsg[1]      = IF iNumParam > 1 THEN ENTRY(2,pcMessage) ELSE "":U
      cMsg[2]      = IF iNumParam > 2 THEN ENTRY(3,pcMessage) ELSE "":U
      cMsg[3]      = IF iNumParam > 3 THEN ENTRY(4,pcMessage) ELSE "":U
      cMsg[4]      = IF iNumParam > 4 THEN ENTRY(5,pcMessage) ELSE "":U
      cMsg[5]      = IF iNumParam > 5 THEN ENTRY(6,pcMessage) ELSE "":U
      cMsg[6]      = IF iNumParam > 6 THEN ENTRY(7,pcMessage) ELSE "":U
      cMsg[7]      = IF iNumParam > 7 THEN ENTRY(8,pcMessage) ELSE "":U
      cMsg[8]      = IF iNumParam > 8 THEN ENTRY(9,pcMessage) ELSE "":U
      cMsg[9]      = IF iNumParam > 9 THEN ENTRY(10,pcMessage) ELSE "":U      
      cMessage     = SUBSTITUTE(cMessage,
                                cMsg[1],cMsg[2],cMsg[3],cMsg[4],cMsg[5],
                                cMsg[6],cMsg[7],cMsg[8],cMsg[9]).
      
    /* Yes -- get the msg */
    CASE cMessageType:
      WHEN 'Question':U OR WHEN 'YesNo':U THEN
      DO:
        MESSAGE cMessage VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO 
        UPDATE lAnswer.
        RETURN lAnswer.
      END.
      WHEN 'OkCancel':U THEN
      DO:
        MESSAGE cMessage VIEW-AS ALERT-BOX QUESTION BUTTONS OK-CANCEL 
        UPDATE lAnswer.
        RETURN lAnswer.
      END.
      WHEN 'YesNoCancel':U THEN
      DO:
        MESSAGE cMessage VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO-CANCEL 
        UPDATE lAnswer.
        RETURN lAnswer.
      END.
      OTHERWISE 
        MESSAGE cMessage VIEW-AS ALERT-BOX INFORMATION.      
    END CASE.
  END.  /* END ELSE IF numeric message */
  
  RETURN TRUE.       /* Return value not meaningful in this case. */
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-signature) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION signature Procedure 
FUNCTION signature RETURNS CHARACTER
  ( pcName AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose: Returns the signature of the named function or internal procedure,
           in the format returned by the Progress GET-SIGNATURE method.  
   Params: INPUT pcName AS CHARACTER -- function or procedure name.
  Returns: CHARACTER: signature in Progress GET-SIGNATURE format.
    Notes: This function is needed because the routine may be located in
           a SUPER procedure, so we need to search SUPER-PROCEDURES if needed.
------------------------------------------------------------------------------*/

  DEFINE VARIABLE iEntry      AS INTEGER   NO-UNDO.
  DEFINE VARIABLE cSuperProcs AS CHARACTER NO-UNDO.
  DEFINE VARIABLE hSuper      AS HANDLE    NO-UNDO.
  
  IF LOOKUP(pcName, TARGET-PROCEDURE:INTERNAL-ENTRIES) NE 0 THEN
    RETURN TARGET-PROCEDURE:GET-SIGNATURE(pcName).   /* It's defined "locally" */
  ELSE DO:
    cSuperProcs = TARGET-PROCEDURE:SUPER-PROCEDURES. /* List of SUper Proc handles */
    DO iEntry = 1 to NUM-ENTRIES(cSuperProcs):

      hSuper = WIDGET-HANDLE(ENTRY(iEntry, cSuperProcs)).
      IF VALID-HANDLE(hSuper) AND LOOKUP(pcName, hSuper:INTERNAL-ENTRIES) NE 0 THEN
        RETURN hSuper:GET-SIGNATURE(pcName).   /* It's defined in this super proc */
    END.
  END.
  RETURN "".   /* Not found anywhere */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

