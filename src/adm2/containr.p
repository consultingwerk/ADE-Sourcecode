&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/***********************************************************************
* Copyright (C) 2005-2008 by Progress Software Corporation. All rights *
* reserved.  Prior versions of this work may contain portions          *
* contributed by participants of Possenet.                             *
*                                                                      *
************************************************************************/
/*--------------------------------------------------------------------------
    File        : containr.p
    Purpose     : Code common to all containers, including WIndows and Frames

    Syntax      : adm2/containr.p
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/*Defines the temp-tables and prodataset for the widget-id assignments.*/
DEFINE TEMP-TABLE ttXMLFileNames NO-UNDO
FIELD cFileName AS CHARACTER
INDEX cfilename cfilename.
{adecomm/dswid.i}

/* Tell cntnattr.i that this is the Super Procedure */
&SCOP ADMSuper containr.p

  {src/adm2/custom/containrexclcustom.i}
  
/* This variable is needed at least temporarily in 9.1B so that a called
   fn can tell who the actual source was.  */
DEFINE VARIABLE ghTargetProcedure    AS HANDLE    NO-UNDO.

DEFINE VARIABLE gcCurrentObjectName  AS CHARACTER NO-UNDO.
DEFINE VARIABLE giPrevPage           AS INTEGER   NO-UNDO.
DEFINE VARIABLE ghDataContainer      AS HANDLE    NO-UNDO.
  {src/adm2/tttranslate.i}

/* This is currently only used for the dynmaic server container, but 
   it is expected that this will be merged together with TTs to manage 
   objects constructed from Repository. As of current the TTs are just 
   populated from the private DefineInstance API and used to pass data
   to constructObjects and addLink  */

/* Allow ADM2 / Dynamics windows to be embedded in OpenEdge Architect */
{adecomm/oeideservice.i &OEIDE-EXCLUDE-PROTOTYPES="yes"}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-addPageNRequiredPages) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD addPageNRequiredPages Procedure 
FUNCTION addPageNRequiredPages RETURNS LOGICAL
    ( INPUT piPageNumber        AS INTEGER,
      INPUT pcPageLinkedList    AS CHARACTER  ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-applyContext) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD applyContext Procedure 
FUNCTION applyContext RETURNS LOGICAL
  ( pcMode    AS CHAR,
    pcContext AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-applyContextFromClient) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD applyContextFromClient Procedure 
FUNCTION applyContextFromClient RETURNS LOGICAL
  ( pcContext AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-applyContextFromServer) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD applyContextFromServer Procedure 
FUNCTION applyContextFromServer RETURNS LOGICAL
  ( pcContext AS CHAR )  FORWARD.

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

&IF DEFINED(EXCLUDE-assignContainedProperties) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD assignContainedProperties Procedure 
FUNCTION assignContainedProperties RETURNS LOGICAL
  (pcPropValues   AS CHAR,
   pcReplace      AS CHAR) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-assignQueries) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD assignQueries Procedure 
FUNCTION assignQueries RETURNS HANDLE
  ( pcQueries AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-containedProperties) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD containedProperties Procedure 
FUNCTION containedProperties RETURNS CHARACTER
  (pcQueryProps   AS CHAR,
   plDeep         AS LOG)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-disablePagesInFolder) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD disablePagesInFolder Procedure 
FUNCTION disablePagesInFolder RETURNS LOGICAL
  (pcPageInformation AS CHARACTER) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-enablePagesInFolder) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD enablePagesInFolder Procedure 
FUNCTION enablePagesInFolder RETURNS LOGICAL
  (pcPageInformation AS CHARACTER) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getCallerObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getCallerObject Procedure 
FUNCTION getCallerObject RETURNS HANDLE
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getCallerProcedure) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getCallerProcedure Procedure 
FUNCTION getCallerProcedure RETURNS HANDLE
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getCallerWindow) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getCallerWindow Procedure 
FUNCTION getCallerWindow RETURNS HANDLE
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getCascadeChildCol) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getCascadeChildCol Procedure 
FUNCTION getCascadeChildCol RETURNS DECIMAL
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getCascadeChildren) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getCascadeChildren Procedure 
FUNCTION getCascadeChildren RETURNS CHARACTER
  ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getCascadeChildRow) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getCascadeChildRow Procedure 
FUNCTION getCascadeChildRow RETURNS DECIMAL
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getClientNames) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getClientNames Procedure 
FUNCTION getClientNames RETURNS CHARACTER
  (   )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getCommitSource) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getCommitSource Procedure 
FUNCTION getCommitSource RETURNS HANDLE
  (   )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getCommitSourceEvents) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getCommitSourceEvents Procedure 
FUNCTION getCommitSourceEvents RETURNS CHARACTER
  (   )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getCommitTarget) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getCommitTarget Procedure 
FUNCTION getCommitTarget RETURNS CHARACTER
  (   )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getCommitTargetEvents) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getCommitTargetEvents Procedure 
FUNCTION getCommitTargetEvents RETURNS CHARACTER
  (   )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getContainedAppServices) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getContainedAppServices Procedure 
FUNCTION getContainedAppServices RETURNS CHARACTER
    ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getContainedDataObjects) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getContainedDataObjects Procedure 
FUNCTION getContainedDataObjects RETURNS CHARACTER
  (   )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getContainerMode) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getContainerMode Procedure 
FUNCTION getContainerMode RETURNS CHARACTER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getContainerTarget) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getContainerTarget Procedure 
FUNCTION getContainerTarget RETURNS CHARACTER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getContainerTargetEvents) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getContainerTargetEvents Procedure 
FUNCTION getContainerTargetEvents RETURNS CHARACTER
  (   )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getContainerToolbarSource) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getContainerToolbarSource Procedure 
FUNCTION getContainerToolbarSource RETURNS CHARACTER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getContainerToolbarSourceEvents) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getContainerToolbarSourceEvents Procedure 
FUNCTION getContainerToolbarSourceEvents RETURNS CHARACTER
  (   )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getContextForClient) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getContextForClient Procedure 
FUNCTION getContextForClient RETURNS CHARACTER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getContextForServer) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getContextForServer Procedure 
FUNCTION getContextForServer RETURNS CHARACTER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getCurrentLogicalName) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getCurrentLogicalName Procedure 
FUNCTION getCurrentLogicalName RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getCurrentPage) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getCurrentPage Procedure 
FUNCTION getCurrentPage RETURNS INTEGER
  ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDataContainer) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getDataContainer Procedure 
FUNCTION getDataContainer RETURNS LOGICAL
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDataContainerHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getDataContainerHandle Procedure 
FUNCTION getDataContainerHandle RETURNS HANDLE
  ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDataContainerName) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getDataContainerName Procedure 
FUNCTION getDataContainerName RETURNS CHARACTER
  (   )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDisabledAddModeTabs) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getDisabledAddModeTabs Procedure 
FUNCTION getDisabledAddModeTabs RETURNS CHARACTER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDynamicSDOProcedure) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getDynamicSDOProcedure Procedure 
FUNCTION getDynamicSDOProcedure RETURNS CHARACTER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getFilterSource) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getFilterSource Procedure 
FUNCTION getFilterSource RETURNS HANDLE
  ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getHasDbAwareObjects) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getHasDbAwareObjects Procedure 
FUNCTION getHasDbAwareObjects RETURNS LOGICAL
  (   )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getHasDynamicProxy) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getHasDynamicProxy Procedure 
FUNCTION getHasDynamicProxy RETURNS LOGICAL
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getHasObjectMenu) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getHasObjectMenu Procedure 
FUNCTION getHasObjectMenu RETURNS LOGICAL
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getHideChildContainersOnClose) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getHideChildContainersOnClose Procedure 
FUNCTION getHideChildContainersOnClose RETURNS LOGICAL
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getHideOnClose) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getHideOnClose Procedure 
FUNCTION getHideOnClose RETURNS LOGICAL
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getInitialPageList) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getInitialPageList Procedure 
FUNCTION getInitialPageList RETURNS CHARACTER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getInstanceNames) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getInstanceNames Procedure 
FUNCTION getInstanceNames RETURNS CHARACTER
  (   )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getMultiInstanceActivated) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getMultiInstanceActivated Procedure 
FUNCTION getMultiInstanceActivated RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getMultiInstanceSupported) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getMultiInstanceSupported Procedure 
FUNCTION getMultiInstanceSupported RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getNavigationSource) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getNavigationSource Procedure 
FUNCTION getNavigationSource RETURNS CHARACTER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getNavigationSourceEvents) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getNavigationSourceEvents Procedure 
FUNCTION getNavigationSourceEvents RETURNS CHARACTER
  (   )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getNavigationTarget) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getNavigationTarget Procedure 
FUNCTION getNavigationTarget RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getOutMessageTarget) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getOutMessageTarget Procedure 
FUNCTION getOutMessageTarget RETURNS HANDLE
  ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getPage0LayoutManager) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getPage0LayoutManager Procedure 
FUNCTION getPage0LayoutManager RETURNS CHARACTER
        (  ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getPageLayoutInfo) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getPageLayoutInfo Procedure 
FUNCTION getPageLayoutInfo RETURNS CHARACTER
        (  ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getPageNTarget) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getPageNTarget Procedure 
FUNCTION getPageNTarget RETURNS CHARACTER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getPageSource) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getPageSource Procedure 
FUNCTION getPageSource RETURNS HANDLE
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getPageTokens) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getPageTokens Procedure 
FUNCTION getPageTokens RETURNS CHARACTER
    (  ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getPendingPage) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getPendingPage Procedure 
FUNCTION getPendingPage RETURNS INTEGER
  ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getPrimarySdoTarget) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getPrimarySdoTarget Procedure 
FUNCTION getPrimarySdoTarget RETURNS HANDLE
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getReEnableDataLinks) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getReEnableDataLinks Procedure 
FUNCTION getReEnableDataLinks RETURNS CHARACTER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getRemoveMenuOnHide) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getRemoveMenuOnHide Procedure 
FUNCTION getRemoveMenuOnHide RETURNS LOGICAL
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getRequestHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getRequestHandle Procedure 
FUNCTION getRequestHandle RETURNS HANDLE
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getRequiredPages) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getRequiredPages Procedure 
FUNCTION getRequiredPages RETURNS CHARACTER
    (  ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getRunDOOptions) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getRunDOOptions Procedure 
FUNCTION getRunDOOptions RETURNS CHARACTER
  ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getRunMultiple) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getRunMultiple Procedure 
FUNCTION getRunMultiple RETURNS LOGICAL
  ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getSavedContainerMode) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getSavedContainerMode Procedure 
FUNCTION getSavedContainerMode RETURNS CHARACTER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getSdoForeignFields) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getSdoForeignFields Procedure 
FUNCTION getSdoForeignFields RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getStatusArea) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getStatusArea Procedure 
FUNCTION getStatusArea RETURNS LOGICAL

  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getTargetProcedure) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getTargetProcedure Procedure 
FUNCTION getTargetProcedure RETURNS HANDLE
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getTopOnly) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getTopOnly Procedure 
FUNCTION getTopOnly RETURNS LOGICAL
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getUpdateActive) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getUpdateActive Procedure 
FUNCTION getUpdateActive RETURNS LOGICAL
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getUpdateSource) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getUpdateSource Procedure 
FUNCTION getUpdateSource RETURNS CHARACTER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getUpdateTarget) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getUpdateTarget Procedure 
FUNCTION getUpdateTarget RETURNS CHARACTER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getWaitForObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getWaitForObject Procedure 
FUNCTION getWaitForObject RETURNS HANDLE
  ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getWidgetIDFileName) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getWidgetIDFileName Procedure 
FUNCTION getWidgetIDFileName RETURNS CHARACTER
        (  ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getWindowFrameHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getWindowFrameHandle Procedure 
FUNCTION getWindowFrameHandle RETURNS HANDLE
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getWindowName) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getWindowName Procedure 
FUNCTION getWindowName RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getWindowTitleViewer) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getWindowTitleViewer Procedure 
FUNCTION getWindowTitleViewer RETURNS HANDLE
  ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-initPagesForTranslation) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD initPagesForTranslation Procedure 
FUNCTION initPagesForTranslation RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-isFetchPending) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD isFetchPending Procedure 
FUNCTION isFetchPending RETURNS LOGICAL
  ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-isRequestTreeRoot) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD isRequestTreeRoot Procedure 
FUNCTION isRequestTreeRoot RETURNS LOGICAL
  ( INPUT phTopContainer AS HANDLE,
    INPUT phTargetObject AS HANDLE )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-lockContainingWindow) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD lockContainingWindow Procedure 
FUNCTION lockContainingWindow RETURNS LOGICAL
    ( INPUT plLockWindow            AS LOGICAL)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-newHeight) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD newHeight Procedure 
FUNCTION newHeight RETURNS LOGICAL
        ( pdHeight as decimal ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-newWidth) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD newWidth Procedure 
FUNCTION newWidth RETURNS LOGICAL
        ( pdWidth as decimal ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-obtainContextForClient) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD obtainContextForClient Procedure 
FUNCTION obtainContextForClient RETURNS CHARACTER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-obtainContextForServer) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD obtainContextForServer Procedure 
FUNCTION obtainContextForServer RETURNS CHARACTER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-obtainPropertyFromContext) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD obtainPropertyFromContext Procedure 
FUNCTION obtainPropertyFromContext RETURNS CHARACTER
  ( INPUT pcObjectType AS CHAR,
    INPUT pcInstance   AS CHAR,
    INPUT pcProperty   AS CHAR,
    INPUT pcContext    AS CHAR) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-pageNRequiredPages) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD pageNRequiredPages Procedure 
FUNCTION pageNRequiredPages RETURNS CHARACTER
    ( INPUT piPageNum    AS INTEGER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-pageNTargets) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD pageNTargets Procedure 
FUNCTION pageNTargets RETURNS CHARACTER
  ( phTarget AS HANDLE, piPageNum AS INTEGER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-registerAppService) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD registerAppService Procedure 
FUNCTION registerAppService RETURNS LOGICAL
  ( pcAppService AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setCallerObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setCallerObject Procedure 
FUNCTION setCallerObject RETURNS LOGICAL
  ( h AS HANDLE )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setCallerProcedure) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setCallerProcedure Procedure 
FUNCTION setCallerProcedure RETURNS LOGICAL
  ( h AS HANDLE )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setCallerWindow) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setCallerWindow Procedure 
FUNCTION setCallerWindow RETURNS LOGICAL
  ( h AS HANDLE )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setClientNames) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setClientNames Procedure 
FUNCTION setClientNames RETURNS LOGICAL
  ( pcClientNames AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setCommitSource) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setCommitSource Procedure 
FUNCTION setCommitSource RETURNS LOGICAL
  ( phSource AS HANDLE )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setCommitSourceEvents) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setCommitSourceEvents Procedure 
FUNCTION setCommitSourceEvents RETURNS LOGICAL
  ( pcSourceEvents AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setCommitTarget) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setCommitTarget Procedure 
FUNCTION setCommitTarget RETURNS LOGICAL
  ( phTarget AS HANDLE )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setCommitTargetEvents) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setCommitTargetEvents Procedure 
FUNCTION setCommitTargetEvents RETURNS LOGICAL
  ( pcTargetEvents AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setContainedAppServices) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setContainedAppServices Procedure 
FUNCTION setContainedAppServices RETURNS LOGICAL
  ( pcAppServices AS CHARACTER  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setContainedDataObjects) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setContainedDataObjects Procedure 
FUNCTION setContainedDataObjects RETURNS LOGICAL
  ( pcObjects AS CHARACTER  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setContainerMode) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setContainerMode Procedure 
FUNCTION setContainerMode RETURNS LOGICAL
  ( cContainerMode AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setContainerTarget) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setContainerTarget Procedure 
FUNCTION setContainerTarget RETURNS LOGICAL
  ( pcObject AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setContainerToolbarSource) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setContainerToolbarSource Procedure 
FUNCTION setContainerToolbarSource RETURNS LOGICAL
  ( pcTarget AS CHARACTER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setContainerToolbarSourceEvents) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setContainerToolbarSourceEvents Procedure 
FUNCTION setContainerToolbarSourceEvents RETURNS LOGICAL
  ( pcEvents AS CHARACTER  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setCurrentLogicalName) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setCurrentLogicalName Procedure 
FUNCTION setCurrentLogicalName RETURNS LOGICAL
        ( input pcObjectName as character ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setCurrentPage) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setCurrentPage Procedure 
FUNCTION setCurrentPage RETURNS LOGICAL
  ( iPage AS INTEGER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setDataContainer) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setDataContainer Procedure 
FUNCTION setDataContainer RETURNS LOGICAL
  ( plDataContainer AS LOG )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setDataContainerName) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setDataContainerName Procedure 
FUNCTION setDataContainerName RETURNS LOGICAL
  ( pcName AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setDisabledAddModeTabs) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setDisabledAddModeTabs Procedure 
FUNCTION setDisabledAddModeTabs RETURNS LOGICAL
  ( cDisabledAddModeTabs AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setDynamicSDOProcedure) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setDynamicSDOProcedure Procedure 
FUNCTION setDynamicSDOProcedure RETURNS LOGICAL
  ( pcProc AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setFilterSource) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setFilterSource Procedure 
FUNCTION setFilterSource RETURNS LOGICAL
  ( phObject AS HANDLE )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setHasDbAwareObjects) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setHasDbAwareObjects Procedure 
FUNCTION setHasDbAwareObjects RETURNS LOGICAL
  ( plDbObjects AS LOGICAL )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setHasDynamicProxy) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setHasDynamicProxy Procedure 
FUNCTION setHasDynamicProxy RETURNS LOGICAL
  ( plProxy AS LOGICAL )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setHasObjectMenu) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setHasObjectMenu Procedure 
FUNCTION setHasObjectMenu RETURNS LOGICAL
  ( plObjectHasMenus AS LOGICAL )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setHideChildContainersOnClose) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setHideChildContainersOnClose Procedure 
FUNCTION setHideChildContainersOnClose RETURNS LOGICAL
  ( plHideChildContainersOnClose AS LOGICAL )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setHideOnClose) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setHideOnClose Procedure 
FUNCTION setHideOnClose RETURNS LOGICAL
  ( plHideOnClose AS LOGICAL )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setInitialPageList) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setInitialPageList Procedure 
FUNCTION setInitialPageList RETURNS LOGICAL
  ( pcPageList AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setInMessageTarget) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setInMessageTarget Procedure 
FUNCTION setInMessageTarget RETURNS LOGICAL
  ( phObject AS HANDLE )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setInstanceNames) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setInstanceNames Procedure 
FUNCTION setInstanceNames RETURNS LOGICAL
  ( pcNames AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setMultiInstanceActivated) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setMultiInstanceActivated Procedure 
FUNCTION setMultiInstanceActivated RETURNS LOGICAL
  ( lMultiInstanceActivated AS LOGICAL)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setMultiInstanceSupported) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setMultiInstanceSupported Procedure 
FUNCTION setMultiInstanceSupported RETURNS LOGICAL
  ( lMultiInstanceSupported AS LOGICAL)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setNavigationSource) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setNavigationSource Procedure 
FUNCTION setNavigationSource RETURNS LOGICAL
  ( pcSource AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setNavigationSourceEvents) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setNavigationSourceEvents Procedure 
FUNCTION setNavigationSourceEvents RETURNS LOGICAL
  ( pcEvents AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setNavigationTarget) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setNavigationTarget Procedure 
FUNCTION setNavigationTarget RETURNS LOGICAL
  ( cTarget AS CHARACTER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setOutMessageTarget) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setOutMessageTarget Procedure 
FUNCTION setOutMessageTarget RETURNS LOGICAL
  ( phObject AS HANDLE )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setPage0LayoutManager) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setPage0LayoutManager Procedure 
FUNCTION setPage0LayoutManager RETURNS LOGICAL
        ( INPUT pcPage0LayoutManager    AS CHARACTER ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setPageLayoutInfo) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setPageLayoutInfo Procedure 
FUNCTION setPageLayoutInfo RETURNS LOGICAL
        ( INPUT pcPageLayoutInfo                AS CHARACTER ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setPageNTarget) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setPageNTarget Procedure 
FUNCTION setPageNTarget RETURNS LOGICAL
  ( pcObject AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setPageSource) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setPageSource Procedure 
FUNCTION setPageSource RETURNS LOGICAL
  ( phObject AS HANDLE )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setPageTokens) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setPageTokens Procedure 
FUNCTION setPageTokens RETURNS LOGICAL
    ( input pcPageTokens    as character  ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setPendingPage) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setPendingPage Procedure 
FUNCTION setPendingPage RETURNS LOGICAL
  ( piPendingPage AS INTEGER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setPrimarySdoTarget) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setPrimarySdoTarget Procedure 
FUNCTION setPrimarySdoTarget RETURNS LOGICAL
  ( hPrimarySdoTarget AS HANDLE )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setReEnableDataLinks) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setReEnableDataLinks Procedure 
FUNCTION setReEnableDataLinks RETURNS LOGICAL
  ( cReEnableDataLinks AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setRemoveMenuOnHide) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setRemoveMenuOnHide Procedure 
FUNCTION setRemoveMenuOnHide RETURNS LOGICAL
  ( plRemoveMenu AS LOG )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setRequiredPages) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setRequiredPages Procedure 
FUNCTION setRequiredPages RETURNS LOGICAL
    ( INPUT pcRequiredPages     AS CHARACTER) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setRouterTarget) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setRouterTarget Procedure 
FUNCTION setRouterTarget RETURNS LOGICAL
  ( phObject AS HANDLE )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setRunDOOptions) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setRunDOOptions Procedure 
FUNCTION setRunDOOptions RETURNS LOGICAL
  ( pcOptions AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setRunMultiple) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setRunMultiple Procedure 
FUNCTION setRunMultiple RETURNS LOGICAL
  ( plMultiple AS LOGICAL )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setSavedContainerMode) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setSavedContainerMode Procedure 
FUNCTION setSavedContainerMode RETURNS LOGICAL
  ( cSavedContainerMode AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setSdoForeignFields) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setSdoForeignFields Procedure 
FUNCTION setSdoForeignFields RETURNS LOGICAL
  ( cSdoForeignFields AS CHARACTER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setStatusArea) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setStatusArea Procedure 
FUNCTION setStatusArea RETURNS LOGICAL
  (plStatusArea AS LOGICAL)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setStatusDefault) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setStatusDefault Procedure 
FUNCTION setStatusDefault RETURNS LOGICAL
  (pcStatusDefault AS CHARACTER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setStatusInput) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setStatusInput Procedure 
FUNCTION setStatusInput RETURNS LOGICAL
  (pcStatusInput AS CHARACTER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setStatusInputOff) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setStatusInputOff Procedure 
FUNCTION setStatusInputOff RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setTopOnly) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setTopOnly Procedure 
FUNCTION setTopOnly RETURNS LOGICAL
    (plTopOnly AS LOGICAL) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setUpdateActive) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setUpdateActive Procedure 
FUNCTION setUpdateActive RETURNS LOGICAL
  ( plActive AS LOGICAL )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setUpdateSource) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setUpdateSource Procedure 
FUNCTION setUpdateSource RETURNS LOGICAL
  ( pcSource AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setUpdateTarget) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setUpdateTarget Procedure 
FUNCTION setUpdateTarget RETURNS LOGICAL
  ( pcTarget AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setWaitForObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setWaitForObject Procedure 
FUNCTION setWaitForObject RETURNS LOGICAL
  ( phObject AS HANDLE )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setWidgetIDFileName) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setWidgetIDFileName Procedure 
FUNCTION setWidgetIDFileName RETURNS LOGICAL
        (INPUT pcWidgetIDFileName AS CHARACTER) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setWindowFrameHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setWindowFrameHandle Procedure 
FUNCTION setWindowFrameHandle RETURNS LOGICAL
  ( phFrame AS HANDLE)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setWindowName) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setWindowName Procedure 
FUNCTION setWindowName RETURNS LOGICAL
  ( INPUT pcWindowName  AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setWindowTitleViewer) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setWindowTitleViewer Procedure 
FUNCTION setWindowTitleViewer RETURNS LOGICAL
  ( phViewer AS HANDLE )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-targetPage) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD targetPage Procedure 
FUNCTION targetPage RETURNS INTEGER
  ( phObject AS HANDLE )  FORWARD.

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
         HEIGHT             = 20.43
         WIDTH              = 55.8.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB Procedure 
/* ************************* Included-Libraries *********************** */

{src/adm2/cntnprop.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-assignPageProperty) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE assignPageProperty Procedure 
PROCEDURE assignPageProperty :
/*------------------------------------------------------------------------------
  Purpose:  Sets the specified property in all objects on the CurrentPage of
            calling SmartContainer.
   Params:  INPUT pcProp AS CHARACTER -- property to set.
            INPUT pcValue AS CHARACTER -- value to assign to that property. 
                This is specified in CHARACTER form but can be used to
                assign values to non-character properties.
    Notes:  This variation on assignLinkProperty is necessary because 
            the notion of paging does not fit well with PUBLISH/SUBSCRIBE. 
            All objects in a Container will subscribe to initializeObject, etc., 
            but the paging performs the operation on subsets of those objects 
            at a time. That is, the container will not publish 'iniializeObject'
            to objects on a page other than zero until that page is first 
            viewed.  So properties such as HideOnInit which are set as part 
            of initialization must be set page-by-page.
            
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER pcProp  AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER pcValue AS CHARACTER NO-UNDO.
  
  DEFINE VARIABLE iVar     AS INTEGER   NO-UNDO.
  DEFINE VARIABLE cObjects AS CHARACTER NO-UNDO.
  
  {get CurrentPage iVar}.
  cObjects = pageNTargets(TARGET-PROCEDURE, iVar).
  
  DO iVar = 1 TO NUM-ENTRIES(cObjects):
    dynamic-function("set":U + pcProp IN WIDGET-HANDLE(ENTRY(iVar, cObjects)),
      pcValue) NO-ERROR.
  END.

  RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-assignWidgetIDs) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE assignWidgetIDs Procedure 
PROCEDURE assignWidgetIDs :
/*------------------------------------------------------------------------------
    Purpose:
    Parameters: <none>
    Notes:
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER pcObjectHandles AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER piPageNumber    AS INTEGER    NO-UNDO.

DEFINE VARIABLE cXMLFileName    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE iObject         AS INTEGER    NO-UNDO.
DEFINE VARIABLE cObject         AS CHARACTER  NO-UNDO.
DEFINE VARIABLE hObject         AS HANDLE     NO-UNDO.
DEFINE VARIABLE cInstances      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cContainerFile  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cContainerPath  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cContainerName  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE hSource         AS HANDLE     NO-UNDO.
DEFINE VARIABLE hContainer      AS HANDLE     NO-UNDO.
DEFINE VARIABLE iParentWidgetID AS INTEGER    NO-UNDO.
DEFINE VARIABLE lOk             AS LOGICAL    NO-UNDO.
DEFINE VARIABLE cActions        AS CHARACTER  NO-UNDO.
DEFINE VARIABLE isDynamicObject AS LOGICAL    NO-UNDO.
DEFINE VARIABLE cInitialPages   AS CHARACTER  NO-UNDO.

&SCOPED-DEFINE xp-assign
{get logicalObjectName cContainerFile}
{get ContainerSource hSource}
{get InitialPageList cInitialPages}.
&UNDEFINE xp-assign

IF cContainerFile NE "" THEN ASSIGN isDynamicObject = TRUE.

IF NOT isDynamicObject THEN
    ASSIGN cContainerFile = REPLACE(TARGET-PROCEDURE:FILE-NAME, "~\", "/")
           cContainerPath = IF INDEX(cContainerFile, "/") > 0 THEN SUBSTRING(cContainerFile, 1, R-INDEX(cContainerFile, "/") - 1) ELSE ""
           cContainerName = SUBSTRING(cContainerFile, R-INDEX(cContainerFile, "/") + 1).
ELSE
    ASSIGN cContainerName = cContainerFile
           cContainerPath = "":U.

IF VALID-HANDLE(hSource) THEN
DO:
    {get ContainerHandle hContainer}.
    IF hContainer:TYPE NE 'WINDOW':U THEN
    ASSIGN iParentWidgetID = hContainer:WIDGET-ID.
END.
ELSE
    ASSIGN iParentWidgetID = 0.

/*We need to get and process the XML file name only for page zero*/
IF piPageNumber = 0 OR CAN-DO(cInitialPages, STRING(piPageNumber)) THEN
DO:
    {get WidgetIDFileName cXmlFileName} NO-ERROR.
    IF ERROR-STATUS:ERROR THEN RETURN.

    /*IF the xml file name is blank or null, is because we have to use the default value,
      which is the file name with the '.xml' extension*/
    IF cXMLFileName = "":U OR cXMLFileName = ? THEN
       IF isDynamicObject THEN
           ASSIGN cXMLFileName = cContainerFile + ".xml":U.
       ELSE
           ASSIGN cXMLFileName = cContainerFile
                  cXMLFileName = REPLACE(cXMLFileName, SUBSTRING(cXMLFileName, R-INDEX(cXMLFileName, "."), -1), ".xml").

    ASSIGN cXMLFileName = SEARCH(REPLACE(cXMLFileName, "~\", "/")).

    {set WidgetIDFileName cXMLFileName}.

    /*If the xml file cannot be found, just returns*/
    IF cXMLFileName = ? OR cXMLFileName = "" THEN
        RETURN.

    /*Checks that the XML file was not previously loaded*/
    IF NOT CAN-FIND(FIRST ttXMLFileNames WHERE ttXMLFileNames.cFileName = cXMLFileName) THEN
    DO:
        ASSIGN lOk = DATASET dsWidgetID:READ-XML("FILE":U, cXMLFileName, "MERGE":U, ?, FALSE) NO-ERROR.
        /*If the xml file does not have a valid format for the widget-id functionality, shows the error and returns*/
        IF NOT lOk THEN
        DO:
            MESSAGE "The WIDGET-ID XML file '" cXMLFileName "' cannot be loaded."
             VIEW-AS ALERT-BOX ERROR.
            RETURN.
        END. /* IF NOT lOk THEN */

        CREATE ttXMLFileNames.
        ASSIGN ttXMLFileNames.cFileName = cXMLFileName.
    END. /*IF NOT CAN-FIND(FIRST ttXMLFileNames*/

END. /*IF piPageNumber = 0 THEN*/

FIND FIRST Container NO-LOCK WHERE Container.contPath = cContainerPath AND
                                   Container.contName = cContainerName NO-ERROR.
                                   
IF NOT AVAILABLE(container) THEN RETURN.

/*Every toolbar use the same widget-ids for their toolbar buttons, so get the widget-ids once, and later
  set them to every toolbar involved in the window.*/
FOR EACH Action NO-LOCK WHERE Action.contPath = Container.contPath AND
                              Action.contName = Container.contName:
    ASSIGN cActions = cActions + Action.ActionID + "," + STRING(Action.WidgetID) + ",".
END.
ASSIGN cActions = TRIM(cActions, ",").

REPEAT iObject = 1 TO NUM-ENTRIES(pcObjectHandles):
    ASSIGN hObject = WIDGET-HANDLE(ENTRY(iObject, pcObjectHandles))
           cInstances = "".

    /*Widget-ids can only be set for visual objects*/
    IF NOT DYNAMIC-FUNCTION("instanceOf":U IN hObject, INPUT "visual":U) THEN
       NEXT.

    ASSIGN cObject = DYNAMIC-FUNCTION('getObjectName':U IN hObject).

    FIND FIRST Instance NO-LOCK WHERE Instance.contPath = Container.contPath AND
                                      Instance.contName = Container.contName AND
                                      Instance.ID       = cObject NO-ERROR.
    IF NOT AVAILABLE(Instance) THEN NEXT.

    {set WidgetID "iParentWidgetID + Instance.widgetID" hObject}.

    /*If the object is a folder we have to set the widget-ids for its page before we set the main frame widget-id*/
    IF DYNAMIC-FUNCTION("instanceOf":U IN hObject, "SmartFolder":U) THEN
    DO:
        FOR EACH Pages NO-LOCK WHERE Pages.contPath = Container.contPath AND
                                     Pages.contName = Container.contName
                                     BY Pages.PageNumber:
            ASSIGN cInstances = cInstances + STRING(Pages.widgetID) + ",".
        END.

        ASSIGN cInstances = TRIM(cInstances, ",":U).
        {set FolderWidgetIDs cInstances hObject}.
    END. /* IF Instance.ObjectType = "SmartFolder":U THEN */

    /*If the object is a Toolbar we have to set the widget-ids for its actions before we set the main frame widget-id*/
    IF DYNAMIC-FUNCTION("instanceOf":U IN hObject, "Toolbar":U) THEN
        {set ActionWidgetIDs cActions hObject}.

    /*If the object is a SDF inside of a viewer, we have to set the SDF frame widget-id. This is required because
      the SDF label is placed in the viewer frame, so this value is used later to avoid duplicates.*/
    IF DYNAMIC-FUNCTION("instanceOf":U IN hObject, "Field":U) THEN
        {set FrameWidgetID Instance.widgetID hObject}.

    /*If the object is a SmartFilter, we have to set the widget-ids for each filter field.*/
    IF DYNAMIC-FUNCTION("instanceOf":U IN hObject, "Filter":U) THEN
    DO:
        FOR EACH InstanceChildren WHERE InstanceChildren.parentInstanceID = Instance.ID       AND
                                        InstanceChildren.contPath         = Instance.contPath AND
                                        InstanceChildren.contName         = Instance.contName
                                        NO-LOCK:

            ASSIGN cInstances = cInstances + InstanceChildren.ID + "," + STRING(InstanceChildren.WidgetID) + ",".
        END. /* FOR EACH InstanceChildren */

        ASSIGN cInstances = TRIM(cInstances, ",").
        {set FieldWidgetIDs cInstances hObject}.
    END. /* WHEN "dynfilter":U THEN */

END. /*REPEAT iObject = 1 TO NUM-ENTRIES(pcObjectHandles):*/

/*For dynamic viewers, we have to get the field names and their widget-ids*/
IF DYNAMIC-FUNCTION("instanceOf":U IN TARGET-PROCEDURE, "DynView":U) THEN
DO:
    FOR EACH Instance WHERE Instance.contPath         = Container.contPath AND
                            Instance.contName         = Container.contName AND
                            Instance.ObjectType      NE "SmartDataField":U
                            NO-LOCK:
        ASSIGN cInstances = cInstances + Instance.ID + "," + STRING(Instance.WidgetID) + ",".
    END. /* FOR EACH InstanceChildren */

    ASSIGN cInstances = TRIM(cInstances, ",":U).
    {set FieldWidgetIDs cInstances}.

    ASSIGN cInstances = "":U.
END. /*IF DYNAMIC-FUNCTION("instanceOf":U IN hObject, "DynView":U) THEN*/

/*If we can find a TreeNode instance, is because we are in a DynTree, so we have to get all nodes in the treeview*/
IF CAN-FIND(FIRST TreeNode WHERE TreeNode.contPath         = Container.contPath AND
                                 TreeNode.contName         = Container.contName) THEN
DO:
    FOR EACH TreeNode NO-LOCK WHERE TreeNode.contPath   = Container.contPath AND
                                    TreeNode.contName   = Container.contName:
        ASSIGN cInstances = cInstances + ",":U + ENTRY(1, TreeNode.ID, "_":U) + ",":U + ENTRY(2, TreeNode.ID, "_":U) + ",":U + STRING(TreeNode.widgetID).
    END. /*FOR EACH Instance*/

    DYNAMIC-FUNCTION('setContainerWidgetIDs':U IN TARGET-PROCEDURE, INPUT TRIM(cInstances, ",")) NO-ERROR.
END. /*TreeNodes*/ 

RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-bufferFetchContainedData) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE bufferFetchContainedData Procedure 
PROCEDURE bufferFetchContainedData :
/*------------------------------------------------------------------------------
  Purpose:     server-side procedure to prepare and open a query on all
               SDOs (rowObject buffers).
  Parameters:  pcQueries AS CHARACTER 
               - CHR(1)-delimited-list of QueryString properties.
                 The list is in ContainedDataObject order, which also includes 
                 one entry for each SDO inside an SBO.... 
                 Blank entries means that the BaseQuery should be used.  
               pcPositions AS CHARACTER 
               - reserved for future use 
    Notes:  This is the internal buffer logic used on the server side of 
            the container class fetchContainedData and is called thru one of 
            several *fetchData APIs that has output parameters for the table 
            handles.
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcQueries   AS CHARACTER NO-UNDO.
  DEFINE INPUT  PARAMETER pcPositions AS CHARACTER NO-UNDO.
  
  DEFINE VARIABLE cObjects         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iObject          AS INTEGER    NO-UNDO.
  DEFINE VARIABLE hObject          AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cQueryString     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cTargets         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iTarget          AS INTEGER    NO-UNDO.
  DEFINE VARIABLE hTarget          AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hContainerSource AS HANDLE     NO-UNDO.
  DEFINE VARIABLE lQuery           AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE hSource          AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cSkipList        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hMaster          AS HANDLE     NO-UNDO.
    
  &SCOPED-DEFINE xp-assign
  /* all SDOs in container including those inside an SBO */
  {get ContainedDataObjects cObjects}                      
  /* ContainerTarget has SBOs  */ 
  {get ContainerTarget cTargets}
  .
  &UNDEFINE xp-assign

  DO iObject = 1 TO NUM-ENTRIES(cObjects):
    ASSIGN
      hObject = WIDGET-HANDLE(ENTRY(iObject,cObjects))
      cQueryString = ENTRY(iObject,pcQueries,CHR(1)).

    /* SKIP is used:
       1. Dynamic SDO with OpenOnInit false need the RowObject definition
       2. A master SDO in an SBO got data from the client cache and is not 
          part of the request */ 

    IF cQueryString <> 'SKIP':U THEN
    DO:
      /* Blank means use base query */ 
      IF cQueryString = '':U THEN
        {get BaseQuery cQueryString hObject}.

      {set QueryString cQueryString hObject}.
    END.
    ELSE 
      cSkipList = cSkipList 
                + (IF cSkipList = '':U THEN '':U ELSE ',':U)
                + STRING(hObject).    
  END. /* do iObject = 1 to num-entries(cObjects) */

  DO iTarget = 1 TO NUM-ENTRIES(cTargets):
    hTarget = WIDGET-HANDLE(ENTRY(iTarget,cTargets)).
    {get QueryObject lQuery hTarget}.
    /* As of now all contained should be query objects, but.. */    
    IF lQuery THEN
    DO:
      hMaster = ?.
      /* If this is an SBO the 'skip' was registered against the master SDO above */      
      {get MasterDataObject hMaster hTarget} NO-ERROR.  
      
      /* if SKIP of master then open the child of the SKIPed SDO inside the SBO instead */
      IF VALID-HANDLE(hMaster) AND CAN-DO(cSkipList,STRING(hMaster)) THEN
      DO:          
        {get ContainedDataObjects cObjects hTarget}.         
        DO iObject = 1 TO NUM-ENTRIES(cObjects):        
          hObject = WIDGET-HANDLE(ENTRY(iObject,cObjects)).
          {get DataSource hSource hObject}.
          IF CAN-DO(cSkipList,STRING(hSource)) THEN
             {fn openQuery hObject}.   
        END.
      END.
      ELSE IF NOT CAN-DO(cSkipList,STRING(hTarget)) THEN
      DO:
        {get DataSource hSource hTarget}.
        IF NOT VALID-HANDLE(hSource) THEN
          {fn openQuery hTarget}.   
      END.
    END. /* if queryobject */
  END. /* do iTarget = 1 to NUM-ENTRIES(cTargets) */
       
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-bufferFetchContainedRows) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE bufferFetchContainedRows Procedure 
PROCEDURE bufferFetchContainedRows :
/*------------------------------------------------------------------------------
  Purpose:    Procedure that makes a new batch of data available in the dataQuery
              in one of the contained SDOs and all its data-link children.
  Parameters:  
    INPUT  pcQueries     -  CHR(1)-delimited-list of QueryString properties of 
                            the SDOs. ( SKIP indicate which SDOs to skip) 
    INPUT  piStartRow    -  The RowNum value of the record to start the batch
                            to return.  Typically piStartRow is ? as a flag to 
                            use pcRowIdent instead of piStartRow.
    INPUT  pcRowIdent     - The RowIdent of the first record of the batch to
                            to return.  Can also be "FIRST" or "LAST" to force
                            the retrieval of the first (or last) batch of 
                            RowObject records.
    INPUT  plNext         - True if serverSendRows is to start on the "next"
                            record from what is indicated by piStartRow or
                            piRowIdent.
    INPUT  piRowsToReturn - The number of rows in a batch.
    OUTPUT piRowsReturned - The actual number of rows returned. This number
                            will either be the same as piRowsToReturn or
                            less when there are not enough records to fill
                            up the batch.
    Notes:  This is the internal buffer logic used on the server side of 
            fetchContainedRows and is called thru one of several 
            *fetchContainedRows APIs that has output parameters for the table 
            handles.    
        -  (it could be changed to be called on the client, by changing the 
            call to sendRows to call fetchContainedRows and fix 
            fetchContainedRows to have logic that calls sendRows on 'server', 
            but it does not make any sense to change the query during batching)   
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcQueries      AS CHARACTER NO-UNDO.
  DEFINE INPUT  PARAMETER piStartRow     AS CHARACTER NO-UNDO.
  DEFINE INPUT  PARAMETER pcRowIdent     AS CHARACTER NO-UNDO.
  DEFINE INPUT  PARAMETER plNext         AS CHARACTER NO-UNDO.
  DEFINE INPUT  PARAMETER piRowsToReturn AS INTEGER   NO-UNDO.
  DEFINE OUTPUT PARAMETER piRowsReturned AS INTEGER   NO-UNDO.
  
  DEFINE VARIABLE cTargets   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hFirstSDO  AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hTarget    AS HANDLE     NO-UNDO.
  DEFINE VARIABLE iTarget    AS INTEGER    NO-UNDO.
  DEFINE VARIABLE lQuery     AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE hSource    AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cSDOs      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hMaster    AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cPosition  AS CHARACTER  NO-UNDO.

  hFirstSDO = {fnarg assignQueries pcQueries}.
  
  RUN sendRows IN hFirstSDO
              (piStartRow, 
               pcRowIdent, 
               plNext, 
               piRowsToReturn, 
               OUTPUT piRowsReturned).
  
  /* We need to position similar to the how the client will position to
     ensure that child data objects also return the right data.
     The logic here is very similar to what happens on the client in 
     clientSendRows.
     (It may be moved into a common method in the future, possibly 
      opendataQuery extended to handle positionForClient) */
  IF pcRowident = 'LAST':U THEN
    {fnarg openDataQuery 'LAST':U hFirstSDO}.
  ELSE IF pcRowident = 'FIRST':U THEN
    {fnarg openDataQuery 'FIRST':U hFirstSDO}.
  ELSE DO:
    {get PositionForClient cPosition hFirstSDO}.
    IF cPosition > "":U THEN
    DO:
      {fnarg openDataQuery '':U hFirstSDO}.
      {fnarg findRowObjectUseRowident cPosition hFirstSDO}.
    END. 
    ELSE  /* What ??? hmm... better find something */
      {fnarg openDataQuery 'FIRST':U hFirstSDO}.
  END.
  
  PUBLISH 'DataAvailable':U FROM hFirstSDO ('DIFFERENT':U).

  /* loop through 'free' containertargets (no source) that may have be part of 
     this request. The purpose is to find data for objects that are    
     'position targets'  */
  {get ContainerTarget cTargets}.
  DO iTarget = 1 TO NUM-ENTRIES(cTargets):
    hTarget = WIDGET-HANDLE(ENTRY(iTarget,cTargets)).
    
    IF hTarget = hFirstSDo THEN
       NEXT.
    
    /* A master has no source so ensure that it is not opened here. 
       It can only be batched above */
    {get MasterDataObject hMaster} NO-ERROR.
    IF hTarget = hMaster THEN
       NEXT.

    /* if the sendrows above was for a batch inside an SBO then ensure that 
       we don't open the query in the SBO */  
    {get ContainedDataObjects cSDOS hTarget} NO-ERROR.
    IF LOOKUP(STRING(hFirstSDO),cSDOS) > 0 THEN
       NEXT.
    
    /* As of now all contained should be query objects, but.. */
    {get QueryObject lQuery hTarget}.
    IF lQuery THEN
    DO:
      {get DataSource hSource hTarget}.     
      IF NOT VALID-HANDLE(hSource) THEN
        {fn openQuery hTarget}.
    END.
  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-buildDataRequest) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE buildDataRequest Procedure 
PROCEDURE buildDataRequest :
/*------------------------------------------------------------------------------
  Purpose:  Receives a request for data request info from a container source 
            and republishes it to contained top-only dataviews and containers.           - This completely overrides the container's implementation in order to 
  Parameters: see data.p version for detailed explanation of parameters
       phOwner        -  
       pcDataSource   - Data source entity name in the case this request is from
                        a data source. 
                        This means that foreignfields need to be collected.
       pcViewerSource - Viewer's data source entity name in the case 
                        this request is passed through a viewer. 
                        This means that this object probably has a link to an 
                        SDF and position info need to be collected. The object
                        may still be a child of another object on the viewer so 
                        foreignfields are also collected. 
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER phOwner         AS HANDLE     NO-UNDO.
  DEFINE INPUT  PARAMETER pcDataSource    AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pcViewerSource  AS CHARACTER  NO-UNDO.
  
  DEFINE INPUT-OUTPUT PARAMETER pcRequests       AS CHARACTER  NO-UNDO.
  DEFINE INPUT-OUTPUT PARAMETER pcDataTables     AS CHARACTER  NO-UNDO.
  DEFINE INPUT-OUTPUT PARAMETER pcQueries        AS CHARACTER  NO-UNDO.
  DEFINE INPUT-OUTPUT PARAMETER pcBatchSizes     AS CHARACTER  NO-UNDO.
  DEFINE INPUT-OUTPUT PARAMETER pcForeignFields  AS CHARACTER  NO-UNDO.
  DEFINE INPUT-OUTPUT PARAMETER pcPositionFields AS CHARACTER  NO-UNDO.
  DEFINE INPUT-OUTPUT PARAMETER pcContext        AS CHARACTER  NO-UNDO.
  DEFINE INPUT-OUTPUT PARAMETER pcDatasetSources AS CHARACTER  NO-UNDO.
  DEFINE INPUT-OUTPUT PARAMETER pcEntities       AS CHARACTER  NO-UNDO.
  DEFINE INPUT-OUTPUT PARAMETER pcEntityNames    AS CHARACTER  NO-UNDO.

  PUBLISH "buildDataRequest":U FROM TARGET-PROCEDURE
                               (INPUT phOwner,
                                INPUT '':U,
                                INPUT '':U,  
                                INPUT-OUTPUT pcRequests, 
                                INPUT-OUTPUT pcDataTables,
                                INPUT-OUTPUT pcQueries,
                                INPUT-OUTPUT pcBatchSizes,
                                INPUT-OUTPUT pcForeignFields,
                                INPUT-OUTPUT pcPositionFields,
                                INPUT-OUTPUT pcContext,
                                INPUT-OUTPUT pcDatasetSources,
                                INPUT-OUTPUT pcEntities,
                                INPUT-OUTPUT pcEntityNames).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-cancelObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE cancelObject Procedure 
PROCEDURE cancelObject :
/* -----------------------------------------------------------------------------
      Purpose: Cancel an object.                  
      Parameters:  <none>
      Notes:  If this is the window container or a virtual container then 
              cancel and undo all containertargets and then destroy.             
            - Published from containerTargets or called directly    
            - There is a slight overhead in this construct as destroyObject
              (called from exitObject -> apply 'close') does a publish 
              'confirmExit', which really is unnecessary after this has 
              published 'confirmCancel'.
              The reason is that destroyObject may be called directly.
            - We currently have to call exitObject as the appbuilder 
              wait-for protests if we destroy directly. 
              Even apply 'close' to target-procedure does not trigger 
              the wait-for. It seems as this has to be fired from the actual 
              instance. (exitObject shoueld be local in all container instances)
              This may very well be a problem for application wait-for as well.     
----------------------------------------------------------------------------*/
  DEFINE VARIABLE hContainer AS HANDLE     NO-UNDO.
  DEFINE VARIABLE lError     AS LOGICAL    NO-UNDO.

  {get ContainerHandle hContainer}.
  
  /* republish until we reached top window */
  IF VALID-HANDLE(hContainer) AND hContainer:TYPE <> 'WINDOW':U THEN
    PUBLISH 'cancelObject':U FROM TARGET-PROCEDURE.  
  ELSE DO:  
    /* Cancel and undo all Container targets  */
    PUBLISH 'confirmCancel':U FROM TARGET-PROCEDURE (INPUT-OUTPUT lError).
    IF NOT lError THEN
    DO:
      RUN exitObject /* destroyObject */ IN TARGET-PROCEDURE NO-ERROR.
      IF ERROR-STATUS:ERROR THEN
      DO:
        RUN destroyObject IN TARGET-PROCEDURE.
      END.  
    END.
  END.
  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-cascadeChildPosition) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE cascadeChildPosition Procedure 
PROCEDURE cascadeChildPosition :
/*------------------------------------------------------------------------------
  Purpose: Check, and if necessery calculate new position info for a new window. 
  Parameters:  
           pcLogicalObjectname = new object's logical name   (LogialcObjectname)
           pcInstanceName      = new object's instance name  (ObjectName)
           pdHeight            = new object's height
           pdWidth             = new object's width
           input-output pdRow  = new object's current/suggested row 
           input-output pdCol  = new object's current/suggested col 
                                  
  Notes:   The passed col and row is checked against existing child window 
           positions and various cascade properties.   
        -  getCascadeChildren defines which window are applicable
           for cascading.   
        -  getCascadeChildRow and getCascadeChildCol defines the
           cascade increments.    
        -  The current cascade relates to the last started applicable window.
        -  If Row and Col is different than unknown then the values will be 
           checked against all applicable windows and cascaded only if a 
           conflict is found. 
        -  Unknown Row and Col values will remain unknown if no applcable window
           is found.   
        -  currently only used by dynamics specific objects since they 
           typically have COL and ROW set from profile. The underlying windows 
           system cascades windows with unknown col and row 
------------------------------------------------------------------------------*/
   DEFINE INPUT        PARAMETER pcLogicalObjectName AS CHARACTER  NO-UNDO.
   DEFINE INPUT        PARAMETER pcInstanceName      AS CHARACTER  NO-UNDO.
   DEFINE INPUT        PARAMETER pdHeight            AS DECIMAL    NO-UNDO.
   DEFINE INPUT        PARAMETER pdWidth             AS DECIMAL    NO-UNDO.
   DEFINE INPUT-OUTPUT PARAMETER pdRow               AS DECIMAL    NO-UNDO.
   DEFINE INPUT-OUTPUT PARAMETER pdCol               AS DECIMAL    NO-UNDO.

   DEFINE VARIABLE cCascade     AS CHARACTER  NO-UNDO.
   DEFINE VARIABLE cProps       AS CHARACTER  NO-UNDO.
   DEFINE VARIABLE cValues      AS CHARACTER  NO-UNDO.
   DEFINE VARIABLE iObject      AS INTEGER    NO-UNDO.
   DEFINE VARIABLE lLast        AS LOGICAL    NO-UNDO.
   DEFINE VARIABLE dCascadeRow  AS DECIMAL    NO-UNDO.
   DEFINE VARIABLE dCascadeCol  AS DECIMAL    NO-UNDO.
   DEFINE VARIABLE iNumEntries  AS INTEGER    NO-UNDO.
   DEFINE VARIABLE lCascade     AS LOGICAL    NO-UNDO.
   DEFINE VARIABLE dRow         AS DECIMAL    NO-UNDO.
   DEFINE VARIABLE dCol         AS DECIMAL    NO-UNDO.
   DEFINE VARIABLE dLastRow     AS DECIMAL    NO-UNDO.
   DEFINE VARIABLE dLastCol     AS DECIMAL    NO-UNDO.

   &SCOPED-DEFINE xp-assign
   {get CascadeChildren cCascade}
   {get CascadeChildRow dCascadeRow}
   {get CascadeChildCol dCascadeCol}
   .
   &UNDEFINE xp-assign
   
   IF cCascade <> 'None':U AND pdHeight <> ? AND pdWidth <> ? THEN 
   DO:
     ASSIGN
       cProps = DYNAMIC-FUNCTION('containedProperties':U IN TARGET-PROCEDURE,
                                'SmartWindow;LogicalObjectName,Row,Col':U,NO)
       iNumEntries = NUM-ENTRIES(cProps,CHR(3)).
     
     /* start with the last instance (we loop through all of them ) */
     DO iObject = iNumEntries TO 3 BY -2:
       /* Skip if values is for requesting instance */
       IF pcInstanceName <> ENTRY(iObject - 1,cProps,CHR(3)) THEN
       DO:
         ASSIGN
           cValues = ENTRY(iObject,cProps,CHR(3))
           dRow    = DEC(ENTRY(2,cValues,CHR(4)))
           dCol    = DEC(ENTRY(3,cValues,CHR(4))).
         
         /* The intention is to only log the last entry, but the LE operator 
            ensures that we also ignore windows outside the view port (upperleft)
         */ 
         IF dLastRow LE 0 AND dLastCol LE 0 THEN
           ASSIGN 
             dLastRow = dRow
             dLastCol = dCol.

         IF cCascade = 'All':U 
         OR (cCascade = 'Same':U AND ENTRY(1,cValues,CHR(4)) = pcLogicalObjectName) THEN
         DO:
           IF pdRow = ? OR pdRow = dRow OR pdCol = ? OR pdCol = dCol THEN
           DO:
             lCascade = TRUE.
             IF pdRow = ? OR pdCol = ? THEN
               LEAVE.
           END.
         END.
       END.  /* if not requesting instance */
     END. /* do iobject  */
     
     IF lCascade THEN
     DO:
       ASSIGN 
         pdRow = dLastRow + dCascadeRow
         pdCol = dLastCol + dCascadeCol.
      
       IF pdRow < 1 OR pdCol < 1 THEN 
         ASSIGN
           pdRow = MAX(1,SESSION:HEIGHT - (pdHeight + 1))
           pdCol = MAX(1,SESSION:WIDTH  - (pdWidth + 1)).

       ELSE IF pdRow >= SESSION:HEIGHT - (pdHeight + 1) 
            OR pdCol >= SESSION:WIDTH - (pdWidth + 1) THEN 
       DO:
         ASSIGN
           pdRow = 1
           pdCol = 1.
       END.
     END. /* if lCascade */
   END.  /* if cascade <> 'none' */

   RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-changePage) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE changePage Procedure 
PROCEDURE changePage :
/*------------------------------------------------------------------------------
  Purpose:     Hides and views (and creates if necessary) objects in
               a Container when CurrentPage is reset
  Parameters:  <none>
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cObjects    AS CHARACTER NO-UNDO. 
  DEFINE VARIABLE iPageNum    AS INTEGER   NO-UNDO.
  DEFINE VARIABLE lInitted    AS LOGICAL   NO-UNDO.
  
  DEFINE VARIABLE cRequiredPages AS CHARACTER                NO-UNDO.  
  DEFINE VARIABLE iPageLoop      AS INTEGER                  NO-UNDO.
  
  /* Let folder know, if any*/
  PUBLISH 'changeFolderPage':U FROM TARGET-PROCEDURE.  /* IN page-source */
  {get CurrentPage iPageNum}.

  /* If changing to page 0, don't look for PAGE0 links (there won't be any)
     or try to re-run create-objects for it. */
  IF iPageNum NE 0 THEN
  DO:
    {get ObjectInitialized lInitted}.
    cObjects = pageNTargets(TARGET-PROCEDURE, iPageNum).
    
    IF cObjects = "":U THEN 
    DO:                            /* Page hasn't been created yet: */
      RUN changeCursor IN TARGET-PROCEDURE('WAIT':U) NO-ERROR.
      
      /* Get objects on the new page created. */
      RUN createObjects IN TARGET-PROCEDURE.
      
      /*Sets widget-ids if the -usewidgetid session parameter is being used*/
      IF DYNAMIC-FUNCTION("getUseWidgetID":U IN TARGET-PROCEDURE) THEN
      DO:
          ASSIGN cObjects = pageNTargets(TARGET-PROCEDURE, iPageNum).
          RUN assignWidgetIDs IN TARGET-PROCEDURE (cObjects, iPageNum).
      END.

      /* If the current container object has been initialized already,
         then initialize the new objects. Otherwise wait to let it happen
         when the container is init'ed. */                          
      IF lInitted THEN      
      DO:
         /* If this is newly created object, then the initialisation of the object 
            will take care of packing and resizing. However, if this is the
            first time that a page is selected, the resize the window to make things pretty.
          */
          RUN packWindow IN TARGET-PROCEDURE ( INPUT iPageNum, INPUT YES) NO-ERROR.
          RUN resizewindow IN TARGET-PROCEDURE NO-ERROR.
          
          /* Initialise all linked pages before init'ing the current
             page.
           */
          ASSIGN cRequiredPages = {fnarg pageNRequiredPages iPageNum}.   
          
          IF cRequiredPages NE "":U AND cRequiredPages NE "?":U THEN
          DO:
              DO iPageLoop = 1 TO NUM-ENTRIES(cRequiredPages):
                  /* Set the CurrentPage to the relevant page
                     so that it is init'ed
                   */
                  {set CurrentPage "INTEGER(ENTRY(iPageLoop, cRequiredPages))"}.
                  
                  /* Ensure that everything is nicely init'ed ... */
                  RUN notifyPage IN TARGET-PROCEDURE ("initializeObject":U).
                  
                  /* ... and make sure that we never see it. */
                  RUN notifyPage IN TARGET-PROCEDURE ("hideObject":U).
              END.    /* loop through other pages */
           
              /* Reset the CurrentPage to the actual current page.
               */
              {set CurrentPage iPageNum}.
          END.    /* There are other pages that need init */
                    
          RUN notifyPage IN TARGET-PROCEDURE ("initializeObject":U).
      END.    /* container has been initted. */
      
      RUN changeCursor IN TARGET-PROCEDURE("":U) NO-ERROR.
    END.    /* END DO if page not created yet */
    ELSE 
    DO:
        IF DYNAMIC-FUNCTION("getUseWidgetID":U IN TARGET-PROCEDURE) THEN
        RUN assignWidgetIDs IN TARGET-PROCEDURE (cObjects, iPageNum).
      /* If the container has been init'ed, then view its contents.
         If not, 'view' will have no effect yet  */
      IF lInitted THEN
        RUN notifyPage IN TARGET-PROCEDURE ("viewObject":U).
   
    END.     /* END DO if page had been created */
  END.       /* END DO if PageNum NE 0 */

  /* Hide and view Page 0 (the default frame) of the window for character
     mode if switching to/from a page which is another window in GUI. */
  &IF "{&WINDOW-SYSTEM}":U = "TTY":U /*AND "{&FRAME-NAME}":U NE "":U */ &THEN
    DEFINE VARIABLE prevPageHdl     AS HANDLE  NO-UNDO.
    DEFINE VARIABLE newPageHdl      AS HANDLE  NO-UNDO.
    DEFINE VARIABLE prevPageIsWin   AS LOGICAL NO-UNDO.
    DEFINE VARIABLE newPageIsWin    AS LOGICAL NO-UNDO.
    DEFINE VARIABLE parentWinHdl    AS HANDLE  NO-UNDO.
    DEFINE VARIABLE defaultFrameHdl AS HANDLE  NO-UNDO.
    DEFINE VARIABLE procHdl         AS HANDLE  NO-UNDO.

    cObjects = pageNTargets(TARGET-PROCEDURE, iPageNum).
    IF cObjects NE "":U THEN DO:
      procHdl    = WIDGET-HANDLE(ENTRY(1,cObjects)).
      
      /* Is the new page a window? */
      {get ContainerHandle newPageHdl procHdl}.
    END.
  
    cObjects = pageNTargets(TARGET-PROCEDURE, giPrevPage).
    IF cObjects NE "":U THEN DO:
      procHdl     = WIDGET-HANDLE(ENTRY(1,cObjects)).

      /* Is the new page a window? */
      {get ContainerHandle prevPageHdl procHdl}.
    END.
    
    /* If both the prev and new pages are other windows, then do nothing. 
       Else if going to another window then HIDE page 0 of current window,
       or if coming *from* another window then VIEW page 0. */
    {get ContainerHandle parentWinHdl}.
    
    IF VALID-HANDLE(parentWinHdl) THEN
        defaultFrameHdl = parentWinHdl:FIRST-CHILD.
    IF VALID-HANDLE(defaultFrameHdl) THEN /* Sanity check that there is */
    DO:                                   /* a default frame in the caller. */
        IF VALID-HANDLE(newPageHdl) AND newPageHdl:TYPE = "WINDOW":U THEN
          newPageIsWin = yes.
        IF VALID-HANDLE(prevPageHdl) AND prevPageHdl:TYPE = "WINDOW":U THEN
          prevPageIsWin = yes.
          
        IF newPageIsWin AND NOT prevPageIsWin THEN
          HIDE defaultFrameHdl.         
        ELSE IF prevPageIsWin AND NOT newPageIsWin THEN
          VIEW defaultFrameHdl.
    END.
  &ENDIF
  RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-clearWidgetIDCache) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE clearWidgetIDCache Procedure 
PROCEDURE clearWidgetIDCache :
/*------------------------------------------------------------------------------
    Purpose: Empties the dataset temp-tables for the widget-id.
    Parameters: <none>
    Notes: This is published from clearClientCache in the repository manager
           (ryrepmngrp.i), when the Compile->Clear Repository Cache menu is
           selected.
------------------------------------------------------------------------------*/
DATASET dsWidgetID:EMPTY-DATASET().
EMPTY TEMP-TABLE ttObjectNames.
EMPTY TEMP-TABLE ttXMLFileNames.
RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-confirmCancel) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE confirmCancel Procedure 
PROCEDURE confirmCancel :
/*------------------------------------------------------------------------------
  Purpose:     Make sure unsaved changes are cancelled and uncommitted data are 
               undone before allowing its container to initiate a "destroy" 
               operation.
  Parameters:  INPUT-OUTPUT plError - 
               If this is returned TRUE the destroyObject will be cancelled.
       Notes:  The name confirm is used as it is in family with the other 
               confirm methods, but this does not ask any questions   
               Invoked at the top by cancelObject.
             - Only republished if we are a non-virtual and non-window container   
------------------------------------------------------------------------------*/ 
  DEFINE INPUT-OUTPUT PARAMETER plError AS LOGICAL NO-UNDO.
  
  DEFINE VARIABLE hContainer AS HANDLE     NO-UNDO. 
  {get ContainerHandle hContainer}.
  /* Ok and Cancel should only work within a window, so if we are a window 
     container then don't republish (we currently also ignore virtual containers) */   
  IF VALID-HANDLE(hContainer) AND hContainer:TYPE <> 'window':U AND NOT plError THEN
    PUBLISH 'confirmCancel':U FROM TARGET-PROCEDURE (INPUT-OUTPUT plError).
  
  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-confirmExit) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE confirmExit Procedure 
PROCEDURE confirmExit :
/*------------------------------------------------------------------------------
  Purpose:     Passes this event on to its descendents, to check whether
               it is OK to exit (no unsaved changes, e.g.).
  Parameters:  INPUT-OUTPUT plCancel AS LOGICAL -- error flag which if set by
               any object will abort the destroy.
       Notes:  Invoked at the top by destroyObject.
------------------------------------------------------------------------------*/
  DEFINE INPUT-OUTPUT PARAMETER plCancel AS LOGICAL NO-UNDO.
  
  IF NOT plCancel THEN
     PUBLISH 'confirmExit':U FROM TARGET-PROCEDURE (INPUT-OUTPUT plCancel).
  
  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-confirmOk) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE confirmOk Procedure 
PROCEDURE confirmOk :
/*------------------------------------------------------------------------------
  Purpose:     Make sure unsaved changes are saved and uncommitted data is committed
               before allowing its container to initiate a "destroy" operation.
  Parameters:  INPUT-OUTPUT plError - 
               If this is returned TRUE the destroyObject will be cancelled.
       Notes:  The name confirm is used as it is in family with the other 
               confirm methods, but this does not ask any questions   
               Invoked at the top by okObject.
             - Only republished if we are a non-virtual and non-window container   
------------------------------------------------------------------------------*/ 
  DEFINE INPUT-OUTPUT PARAMETER plError AS LOGICAL NO-UNDO.
  
  DEFINE VARIABLE hContainer AS HANDLE     NO-UNDO. 
  {get ContainerHandle hContainer}.

  /* Ok and Cancel should only work within a window, so if we are a window 
     container then don't republish (we currently also ignore virtual containers)*/   
  IF VALID-HANDLE(hContainer) AND hContainer:TYPE <> 'window':U AND NOT plError THEN
    PUBLISH 'confirmOk':U FROM TARGET-PROCEDURE (INPUT-OUTPUT plError).
  
  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-constructObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE constructObject Procedure 
PROCEDURE constructObject :
/*------------------------------------------------------------------------------
  Purpose:     RUN from adm-create-objects to RUN a SmartObject,
               and to establish its parent and initial property settings.
  Parameters:  pcProcName AS CHARACTER -- the procedure name to run, 
               phParent   AS HANDLE    -- handle to parent its visualization to,
               pcPropList AS CHARACTER -- property list to set, 
               phObject   AS OUTPUT HANDLE -- the new procedure handle.
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER  pcProcName   AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER  phParent     AS HANDLE    NO-UNDO.
  DEFINE INPUT PARAMETER  pcPropList   AS CHARACTER NO-UNDO.
  DEFINE OUTPUT PARAMETER phObject     AS HANDLE    NO-UNDO.

  DEFINE VARIABLE hTemp               AS HANDLE    NO-UNDO.
  DEFINE VARIABLE iCurrentPage        AS INTEGER   NO-UNDO.
  DEFINE VARIABLE cVersion            AS CHARACTER NO-UNDO.
  DEFINE VARIABLE iEntry              AS INTEGER   NO-UNDO.
  DEFINE VARIABLE cEntry              AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cProperty           AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cValue              AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cSignature          AS CHARACTER NO-UNDO.
  DEFINE VARIABLE iDB                 AS INTEGER   NO-UNDO.
  DEFINE VARIABLE cDBList             AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cDotRFile           AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cMemberFile         AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cBaseFileName       AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cDynamicSDO         AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cObjectType         AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cRunDOOptions       AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cFirstEntry         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cObjectName         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iDotPos             AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cDivision           AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lSBO                AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cLogicalName        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cProperties         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cPropValues         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cRenderingProcedure AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cServerFileName     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lUseRepository      AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cContainerName      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lStopped            AS LOGICAL    NO-UNDO.
  
  ASSIGN ghTargetProcedure = TARGET-PROCEDURE NO-ERROR.
  /*set unknown here just in case of recursive call */  
  gcCurrentObjectName = ?.

  /* this is (a hack...) for lookup.p so that the launched lookup container can 
     fetch data from repository 
     Warning: LogicalObjectName is used by webspeed for lookup SDO that 
              ALREADY has all info   */               
  cFirstEntry = ENTRY(1,pcPropList,CHR(3)).  
  IF cFirstEntry <> '':U AND ENTRY(1,cFirstEntry,CHR(4)) = 'LaunchLogicalName':U THEN
  DO:
     gcCurrentObjectName = ENTRY(2,cFirstEntry,CHR(4)) NO-ERROR.
     ENTRY(1,pcPropList,CHR(4))  = 'LogicalObjectName':U.
  END.

  /* Establish what the actual LogicalObjectName is, so that we can attempt */
  /* to find a running instance when on server */
  IF gcCurrentObjectName <> ? THEN
    cLogicalName = gcCurrentObjectName.
  ELSE
  IF INDEX(CHR(3) + pcPropList,'LogicalObjectName':U + CHR(4)) > 0 THEN
  DO iEntry = 1 TO NUM-ENTRIES(pcPropList, CHR(3)):
    cEntry = ENTRY(iEntry, pcPropList, CHR(3)).  
    IF ENTRY(1, cEntry, CHR(4)) = 'LogicalObjectName':U THEN
    DO:
      cLogicalName = ENTRY(2, cEntry, CHR(4)) NO-ERROR.
      LEAVE.
    END.
  END.
  IF cLogicalName > '':U AND cLogicalName <> '?':U THEN
  DO:
    /* Look for generated filename. Generated files are run
       subject to the following criteria:
       - a Dynamics session is running 
       - the launched object has a valid logical object name
       - the calling container (the one that's doing the launching)
         is a generated container itself, except if it
         is a treeview container.
       - if the calling container is a treeview container,
         only the detail frame/node-related objects may
         be generated objects. Other objects contained by
         a treeview (such as a filter viewer) may not
         be generated objects.       
     */    
    if valid-handle(gshRepositoryManager) then
    do:
        if can-do(target-procedure:internal-entries, 'adm-assignObjectProperties') or
           ( pcProcName eq 'ry/uib/rydynframw.w' and
             {fnarg instanceOf 'DynTree'}               ) then
        do:
            cRenderingProcedure = {fnarg getMappedFilename cLogicalName gshRepositoryManager}.
            if cRenderingProcedure ne ? then
            do:
               /* Make sure that Dbaware procedure remain so. */
               if num-entries(pcProcName, chr(3)) eq 1 then
                   pcProcName = cRenderingProcedure.
               else
                   pcProcName = cRenderingProcedure + chr(3) + 'DbAware'.
            end.        /* found a mapped file */
            
            cRenderingProcedure = ''.
        end.    /* allowed to find the generated object */
    end.    /* logical name exists */    
    
    {get ASDivision cDivision} NO-ERROR.
    IF (cDivision = "SERVER":U OR SESSION:CLIENT-TYPE = "WEBSPEED":U) THEN  
    DO:
      PUBLISH "searchCache" + cLogicalName (OUTPUT phObject).
      /* if found, use it */
      IF VALID-HANDLE(phObject) THEN
      DO:
        RUN removeFromCache IN phObject.
        IF VALID-HANDLE(gshRepositoryManager) THEN
        DO:
          /* DynSBO objects are created from the repository. If a DynSBO re-uses */
          /* a 'kept-alove' SDO, the SDO instance properties must be set to the */
          /* values defined in the DynSBO */
          {get QueryObject lSBO}.
          IF lSBO THEN DO:
            cObjectName = {fn getCurrentLogicalName}.
            /* the first entry can be a container LogicalObjectName OR an IbstanceID*/
            cContainerName = ENTRY(1, cObjectName, CHR(1)).
            IF NUM-ENTRIES(cObjectName, CHR(1)) > 1 THEN
              cObjectName = ENTRY(2, cObjectName, CHR(1)).
            ELSE
              cObjectName = "":U.
  
            {set AutoCommit FALSE phObject}.
            cProperties = 'ForeignFields,RowsToBatch':U.
            RUN getInstanceProperties IN gshRepositoryManager
                                         (cContainerName,  /* container name */
                                          cObjectName,     /* instance name */
                                          INPUT-OUTPUT cProperties,
                                          OUTPUT cPropValues).
            DO iEntry = 1 TO NUM-ENTRIES(cProperties):
              ASSIGN
                cProperty = ENTRY(iEntry, cProperties)
                cValue    = ENTRY(iEntry, cPropValues, CHR(1)). 
        
              DYNAMIC-FUNCT("set":U + cProperty IN phObject, cValue) NO-ERROR .
            END.
          END. /* lSBO */
        END. /* valid ghRepositoryManager */
      END. /* valid phObject (after searchCache) */
    END. /* AsDivision = 'server' or client-type = 'webspeed' */
  END. /* IF cLogicalName > '':U AND cLogicalName <> '?':U */
  IF NOT VALID-HANDLE(phObject) THEN
  DO:                               /* start new object instance */
      /* This is a DB-AWARE object: */ 
    IF NUM-ENTRIES(pcProcName, CHR(3)) > 1 THEN 
    DO:
        /* If the base file is available, use it to determine if the 
           appropriate DB's are connected.  It is the file to run 
           if all required DBs are connected. */
      {get RunDOOptions cRunDOOptions}.
  
      ASSIGN 
        pcProcName    = ENTRY(1, pcProcName, CHR(3))
        cBaseFileName = pcProcName  /* Save off for later */
        iDotPos = R-INDEX(pcProcName, '.':U).  /* issue 9878 - dots in dir name */
      
       /* If DynamicOnly is not a Run Data Object option then we want to look for 
         rcode to run */
      IF LOOKUP('DynamicOnly':U, cRunDOOptions) = 0 THEN
      DO:
      /* We do not look for .r's if ClientOnly is a Run DO option */
        IF LOOKUP('ClientOnly':U, cRunDOOptions) = 0 AND LOOKUP('StaticClientOnly':U, cRunDOOptions) = 0 THEN
        DO:
          ASSIGN /* Find the .r file */
            FILE-INFO:FILE-NAME = SUBSTRING(pcProcName, 1, iDotPos) + "r":U
            cDotRFile           = FILE-INFO:FULL-PATHNAME
            /* If .r in proc lib, get the member name (ie, filename). */
            cMemberFile = MEMBER(cDotRFile).
          IF cMemberFile <> ? THEN
            cDotRFile = cMemberFile.
      
          IF cDotRFile NE ? THEN DO:  /* We have found the base .r */
            ASSIGN 
              RCODE-INFO:FILE-NAME = cDotRFile
              cDBList              = RCODE-INFO:DB-REFERENCES.
              
            DB-CHECK:
            DO iDB = 1 TO NUM-ENTRIES(TRIM(cDBList)):   /* Remove blank when no db */
              IF NOT CONNECTED(ENTRY(iDB,cDBList)) THEN DO:
                cDotRFile = ?.        /* Flag that we can't use the base file. */
                LEAVE DB-CHECK.
              END.  /* Found a DB that needs to be connected that isn't */
            END.  /* Do for each required DB */
          END.  /* If we have the base .r */
        END.  /* Not ClientOnly */
        /* If the .r was not found or it was found and the databases it needs
           are not connected OR ClientOnly is a Run DO option then we look 
           for the proxy */
        IF cDotRFile = ? OR 
           LOOKUP('ClientOnly':U, cRunDOOptions) > 0 OR 
           LOOKUP('StaticClientOnly':U, cRunDOOptions) > 0 THEN 
        DO:
            /* Unable to locate the base .r file OR the required DBs are
               not connected - so try the _cl proxy instead. */
            ASSIGN 
              pcProcName          = SUBSTRING(pcProcName, 1, iDotPos - 1) + "_cl.r":U
              FILE-INFO:FILE-NAME = pcProcName
              cDotRFile           = FILE-INFO:FULL-PATHNAME
              cMemberFile         = MEMBER(cDotRFile).
            IF cMemberFile <> ? THEN
                 cDotRFile = cMemberFile.
        END.        /* END ELSE DO IF base .r not found. */
        
        /* If SourceSearch is a Run DO option then we try to run source code */
        IF cDotRFile = ? AND LOOKUP('SourceSearch':U, cRunDOOptions) > 0 THEN
        DO:        
          /* If ClientOnly is not option then we run the .w directly in an 
             on stop undo, leave loop so that it will try to run the _cl.w 
             proxy if the run of the .w fails due to databases not being
             connected */
          IF LOOKUP('ClientOnly':U, cRunDOOptions) = 0 THEN
          DO ON STOP UNDO, LEAVE:
            RUN VALUE(cBaseFileName) PERSISTENT SET phObject NO-ERROR.
          END.
  
          /* If the .w did not run due to an error (such as database not 
             being connected the proxy _cl.w is run */
          IF VALID-HANDLE(phObject) THEN 
            cDotRFile = cBaseFileName.
          ELSE IF LOOKUP('ClientOnly':U, cRunDOOptions) > 0 THEN
          DO ON STOP UNDO, LEAVE:
            RUN VALUE(ENTRY(1, cBaseFileName, ".":U) + "_cl.w":U) PERSISTENT SET phObject.
          END.
          IF VALID-HANDLE(phObject) THEN 
            cDotRFile = cBaseFileName.
        END.  /* if SourceSearch */
      END.  /* Not DynamicOnly */ 
  
     /* If DynamicOnly is a Run DO option then this supercedes all other Run DO
         options (except 'StaticClientOnly') and the dynamic object is run */
      IF cDotRFile = ? OR LOOKUP('DynamicOnly':U, cRunDOOptions) > 0 THEN
      DO:        
        /* If 'StaticClientOnly' is set then the only possibility here is that 
           we may be running an WebClient session. The dynamnic SDO client proxy
           (dyndata.w) will *not* be run */
        IF LOOKUP('StaticClientOnly':U, cRunDOOptions) > 0 THEN 
        DO:
          IF SESSION:CLIENT-TYPE = 'WEBCLIENT':U THEN
          DO ON STOP UNDO, LEAVE:
            RUN VALUE(pcProcName) PERSISTENT SET phObject.
          END.
        END.
        ELSE DO:
          {get DynamicSDOProcedure cDynamicSDO}. /* normally 'adm2/dyndata.w' */
          DO ON STOP UNDO, LEAVE:
            RUN VALUE(cDynamicSDO) PERSISTENT SET phObject.
          END.
          IF NOT VALID-HANDLE (phObject) THEN 
          DO:
            ghTargetProcedure = ?.
            RETURN ERROR. 
          END.
          {set HasDynamicProxy TRUE}. /* passed to server to get extra props back */
        END.
      END.       /* END DO IF DotRFile still unfound */
      /* If cDotRFile is not ? then we run the object here unless SourceSearch
         was a Run DO option and we've already directly run the source code */
      ELSE IF NOT VALID-HANDLE(phObject) THEN 
          RUN VALUE(pcProcName) PERSISTENT SET phObject.
      /* Verify that the object was created successfully. */
      IF NOT VALID-HANDLE (phObject) THEN 
      DO:
        ghTargetProcedure = ?.
        RETURN ERROR. 
      END.
  
      /* New code for 9.1B. If the logic is that we run the _cl proxy, but
         that file is not found, then we run the dynamic SDO instead. In any case, we
         set the ServerFileName to the base filename of the SDO, to be run
         on the AppServer. This may not be the same as the ObjectName, which
         can be modified. */
      cServerFileName = cBaseFileName.
      {get UseRepository lUseRepository}.
      IF lUseRepository THEN
      DO:
        /* When using a repository, RenderingProcedure is used to set the
           ServerFileName if it is set.  This is to prevent the 
           thinRenderingProcedure (if used on client side) from being used 
           on the server side. */
        {get RenderingProcedure cRenderingProcedure phObject}.
        IF cRenderingProcedure > '':U THEN 
          cServerFileName = cRenderingProcedure.
      END.
      DYNAMIC-FUNCTION('setServerFileName':U IN phObject, cServerFileName).
     
      /* if we ran the proxy, adjust the ObjectName property */
      {get ObjectName cObjectName phObject}.
      IF INDEX(cObjectName, '_cl':U) <> 0 THEN
      DO:
         DYNAMIC-FUNCTION('setObjectName':U IN phObject,
              SUBSTR(cObjectName,1,INDEX(cObjectName,"_cl":U) - 1)).
      END.        /* END DO IF _cl */
    END.          /* This object is DB-AWARE */
    ELSE do:
      do on stop undo, leave:
        lStopped = true.  
        /* no-error does not suppress error, but makes it available in 
           error-status if it fails */
        RUN VALUE(pcProcName) PERSISTENT SET phObject no-error.       
        lStopped = false.
      end.
      if lStopped then 
      do:
        ghTargetProcedure = ?.
        if session:remote then 
          return error error-status:get-message(1).
        else
          stop. /* keep old behavior on client */
      end.   
    end. 
      
    /* Verify that the object was created successfully. */
    IF NOT VALID-HANDLE (phObject) THEN
    DO:
      ghTargetProcedure = ?.
      RETURN ERROR. 
    END.
  
    /* Check to make sure that the object version is ADM2.0 or higher.
       If this isn't an "ADM2" object, then getObjectVersion won't be
       there and won't return anything. */
    {get ObjectVersion cVersion phObject} NO-ERROR.
     
    IF cVersion = ? OR cVersion LT "{&ADM-VERSION}":U THEN 
    DO:
        dynamic-function("showMessage":U IN TARGET-PROCEDURE,
         SUBSTITUTE({fnarg messageNumber 88},phObject:FILE-NAME, cVersion)).
        IF cVersion >= "ADM2.0":U THEN
          RUN destroyObject IN phObject NO-ERROR.
        ELSE RUN dispatch IN phObject ('destroy':U) NO-ERROR.
        STOP.
    END.
  
    /* For character mode, don't attempt to parent a new window procedure. 
       We also need to check if phParent is valid before checking TYPE 
       because phParent is not valid when the container is non-visual */
    &IF "{&WINDOW-SYSTEM}":U = "TTY":U &THEN
     IF VALID-HANDLE(phParent) THEN IF phParent:TYPE NE "WINDOW":U THEN 
    &ENDIF
      {set ObjectParent phParent phObject}.
  
    /* Set any Instance Properties specified. The list is in the same format
       as returned to the function instancePropertyList, with CHR(3) between
       entries and CHR(4) between the property name and its value in each entry. 
       NOTE: we must get the datatype for each property in order to set it. */
    DO iEntry = 1 TO NUM-ENTRIES(pcPropList, CHR(3)):
      ASSIGN
        cEntry    = ENTRY(iEntry, pcPropList, CHR(3))
        cProperty = REPLACE(ENTRY(1, cEntry, CHR(4)), 
                            "DataObjectNames":U, "UpdateOrder":U)
        cValue    = ENTRY(2, cEntry, CHR(4)). 
      DYNAMIC-FUNCTION("set":U + cProperty IN phObject, cValue) NO-ERROR .
      /** This message code removed to avoid issues with attributes being set
          which are not available as properties in the object.          
            DYNAMIC-FUNCTION("showMessage":U IN TARGET-PROCEDURE,
                             "Property ":U  + cProperty + " not defined.":U). 
                           
      ***/ 
    END.
  END. /* if not valid-handle(phObject) */
  /* Now create the default link to the containing object. */
  RUN addLink IN TARGET-PROCEDURE(INPUT TARGET-PROCEDURE, INPUT "CONTAINER":U, INPUT phObject).    
  {get CurrentPage iCurrentPage}.
  IF iCurrentPage <> 0 THEN
  DO:
    RUN addLink IN TARGET-PROCEDURE(INPUT TARGET-PROCEDURE, INPUT "PAGE":U + STRING(iCurrentPage), 
          INPUT phObject). 
    {set ObjectPage iCurrentPage phObject}.
  END.
  ASSIGN
   gcCurrentObjectName = ?
   ghTargetProcedure = ?.
  RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-createObjects) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE createObjects Procedure 
PROCEDURE createObjects :
/*------------------------------------------------------------------------------
   Purpose: Standard code for running the objects in a Container. It runs
            the AppBuilder-generated procedure named adm-create-objects. 
Parameters: <none>
     Notes: The ObjectsCreated flag protects agains multiple starts of page 0.
            Other pages are protected in changePage.
------------------------------------------------------------------------------*/
  DEFINE VARIABLE iPage           AS INTEGER    NO-UNDO.
  DEFINE VARIABLE lObjectsCreated AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE iStartPage      AS INTEGER    NO-UNDO.
 
  {get CurrentPage iPage}.
  IF iPage = 0 THEN
    {get ObjectsCreated lObjectsCreated}.
  
  IF iPage <> 0 OR NOT lObjectsCreated THEN
  DO:
    RUN adm-create-objects IN TARGET-PROCEDURE NO-ERROR.
    
    /* Deep create.
       Create the contained objects for certain classes of objects: dynamic containers,
       both object and widget containers. This excludes data objects. */
    PUBLISH "createObjects":U FROM TARGET-PROCEDURE.        
  
    /* new for 9.1B: run an additional optional procedure in the container,
       which can do any work that must be done after all the contained objects
       have been created and the links established, but before initializeObject.*/
    RUN postCreateObjects IN TARGET-PROCEDURE NO-ERROR.
    
    /* if page 0 then this is the start up so ensure that we run the startpage */
    IF iPage = 0 THEN
    DO:
      /*  Use NO-ERROR as a non visual (server side) container does not inherit
          Visual */
      RUN SUPER NO-ERROR.
      {get StartPage iStartPage}.
      IF iStartPage NE ? AND iStartPage NE 0 THEN
        RUN selectPage IN TARGET-PROCEDURE (iStartPage).
      {set ObjectsCreated TRUE}.
    END.
  END.

  RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-deletePage) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE deletePage Procedure 
PROCEDURE deletePage :
/*------------------------------------------------------------------------------
  Purpose:  Deletes all the objects on the specified page.
   Params:  piPageNum AS INTEGER
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER piPageNum AS INTEGER NO-UNDO.
  
  DEFINE VARIABLE iCurrentPage   AS INTEGER   NO-UNDO.
  
    &SCOPED-DEFINE xp-assign
    {get CurrentPage iCurrentPage}
    /* Temporarily reset the current page, to tell the folder */  
    {set CurrentPage piPageNum}.
    &UNDEFINE xp-assign
    
    /* Also tell the folder or other paging visualization, if any. */
    PUBLISH 'deleteFolderPage':U FROM TARGET-PROCEDURE.  
    RUN notifyPage IN TARGET-PROCEDURE ("destroyObject":U).
        
    {set CurrentPage iCurrentPage}.

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
 run saveWindowDimensions in target-procedure.

 RUN SUPER NO-ERROR.
 IF ERROR-STATUS:ERROR OR RETURN-VALUE = "ADM-ERROR":U THEN
     RETURN ERROR "ADM-ERROR":U.

/* We don't want an ASSIGN ERROR-STATUS:ERROR = NO. It may clear an error status raised above us in the stack. */

END PROCEDURE.  /* destroyObject */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fetchContainedData) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE fetchContainedData Procedure 
PROCEDURE fetchContainedData :
/*------------------------------------------------------------------------------
   Purpose: Client side procedure to get a set of data back from the server.
Parameters: pcObject AS CHARACTER 
                   - if unknown, then fetch data sets for all QueryObjects
                     in this container as well as all QueryObjects in all 
                     contained containers (in unlimited levels).                         
                   - if specified, then fetch data sets from that Object 
                     down only following the data link.
     Notes: The Data links is followed also when preparing and retrieving data 
            for all objects in containers. 
         -  The datalinks can go across containers, but it will not go into
            a container that not is a descendant of this container.                 
-----------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pcObject AS CHARACTER  NO-UNDO.

DEFINE VARIABLE cContext        AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cError          AS CHARACTER  NO-UNDO.
DEFINE VARIABLE hObject         AS HANDLE     NO-UNDO.
DEFINE VARIABLE hRowObjectTT    AS HANDLE     NO-UNDO.

DEFINE VARIABLE hTT      AS HANDLE     NO-UNDO EXTENT 64.

DEFINE VARIABLE iObject AS INTEGER    NO-UNDO.

DEFINE VARIABLE pcPhysicalNames         AS CHARACTER  NO-UNDO.
DEFINE VARIABLE pcQualnames             AS CHARACTER  NO-UNDO.
DEFINE VARIABLE pcQueryFields           AS CHARACTER  NO-UNDO.
DEFINE VARIABLE pcQueries               AS CHARACTER  NO-UNDO.

DEFINE VARIABLE cTTList                 AS CHARACTER  NO-UNDO.
DEFINE VARIABLE pcHandles               AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cServerFileName         AS CHARACTER  NO-UNDO.
DEFINE VARIABLE hAppServer              AS HANDLE     NO-UNDO.
DEFINE VARIABLE cContainedAppServices   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE iService                AS INTEGER    NO-UNDO.
DEFINE VARIABLE cAppService             AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cQueryString            AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cServerOperatingMode    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE hContainerSource        AS HANDLE     NO-UNDO.
DEFINE VARIABLE lSBO                    AS LOGICAL    NO-UNDO.
DEFINE VARIABLE lAsBound                AS LOGICAL    NO-UNDO.
DEFINE VARIABLE hAsHandle               AS HANDLE     NO-UNDO.
DEFINE VARIABLE lInitialized            AS LOGICAL    NO-UNDO.
DEFINE VARIABLE cInstanceNames          AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cTargets                AS CHARACTER  NO-UNDO.
DEFINE VARIABLE hMasterObject           AS HANDLE     NO-UNDO.
DEFINE VARIABLE lAsHasStarted           AS LOGICAL    NO-UNDO.
DEFINE VARIABLE lHasDbAwareObjects      AS LOGICAL    NO-UNDO.
DEFINE VARIABLE cDummy                  AS CHARACTER  NO-UNDO.

/* set table before retrieval unless 'cache' , if 'cache' we do not set 
   the handle in case the object is static. instead we retrieve the 
   table and then pushes it to the static object. (could have done the 
   opposite; set the table and pushed it to the cache, but this way the 
   operations for shared and non-shared are more similar)  */
&SCOP assigntable ~{&ttvar~}[~{&num~}] = WIDGET-H(ENTRY(~{&num~},~{&Tables~})) ~
                  WHEN NUM-ENTRIES(~{&Tables~}) >= ~{&num~}  

RUN changeCursor IN TARGET-PROCEDURE('WAIT':U).

&SCOPED-DEFINE xp-assign
{get HasDbAwareObjects lHasDbAwareObjects}
{get ObjectInitialized lInitialized}
 .
&UNDEFINE xp-assign

IF NOT lHasDbAwareObjects THEN
DO:
  /* NOTE: initializeDataObjects calls fetchData directly, this is here 
           to make fetchContainedData calls work also with no dbaware   */
  RUN fetchData IN TARGET-PROCEDURE.
END.
/* else if TRUE since unknown value means no dataobjects 
   If initialized then we know the request is from an SDO  */
ELSE IF lHasDbAwareObjects OR lInitialized THEN
DO:
  IF pcObject = ? THEN
    {get ContainedAppServices cContainedAppServices}.
  
  {set HasDbAwareObjects TRUE}.

  DO iService = 1 TO IF pcObject = ?  
                     THEN NUM-ENTRIES(cContainedAppServices)
                     ELSE 1:
   /* If we loop through all services, check connection and that it is remote */
   IF (pcObject = ? OR pcObject = '':U) THEN
   DO:
     cAppService = ENTRY(iService,cContainedAppServices).
     {get AsBound lAsbound}.    
     IF NOT lAsBound THEN
     DO:
       {set Appservice cAppService}.
       RUN connectServer IN TARGET-PROCEDURE (OUTPUT hAppServer).   
       /* if session the object have opened them selves  */
       IF happserver = SESSION THEN
          NEXT.
  
       IF hAppServer  = ? THEN
       DO:
         RUN changeCursor IN TARGET-PROCEDURE('':U).
         RETURN 'ADM-ERROR':U.
       END.
     END.
   END.
   ELSE /* We connect for object requests further down  */
     cAppservice = ?.
    
   RUN prepareDataForFetch IN TARGET-PROCEDURE
      (INPUT TARGET-PROCEDURE,
       INPUT cAppService,
       INPUT pcObject,
       INPUT IF NOT lInitialized AND pcObject = ? THEN 'INIT':U ELSE '':U, 
       INPUT-OUTPUT pcHandles, 
       INPUT-OUTPUT pcPhysicalNames,
       INPUT-OUTPUT pcQualNames,
       INPUT-OUTPUT pcQueryFields,
       INPUT-OUTPUT pcQueries,
       INPUT-OUTPUT cTTlist).
    
   IF pcPhysicalNames > '':U THEN
   DO:
     &SCOPED-DEFINE Tables cTTList
     &SCOPED-DEFINE ttVar hTT
     ASSIGN 
      &SCOPED-DEFINE num 1 
      {&assigntable} 
      &SCOPED-DEFINE num 2
      {&assigntable} 
      &SCOPED-DEFINE num 3 
      {&assigntable} 
      &SCOPED-DEFINE num 4
      {&assigntable} 
      &SCOPED-DEFINE num 5 
      {&assigntable} 
      &SCOPED-DEFINE num 6
      {&assigntable} 
      &SCOPED-DEFINE num 7 
      {&assigntable} 
      &SCOPED-DEFINE num 8
      {&assigntable} 
      &SCOPED-DEFINE num 9 
      {&assigntable} 
      &SCOPED-DEFINE num 10
      {&assigntable} 
      &SCOPED-DEFINE num 11
      {&assigntable} 
      &SCOPED-DEFINE num 12
      {&assigntable} 
      &SCOPED-DEFINE num 13 
      {&assigntable} 
      &SCOPED-DEFINE num 14
      {&assigntable} 
      &SCOPED-DEFINE num 15 
      {&assigntable} 
      &SCOPED-DEFINE num 16
      {&assigntable} 
      &SCOPED-DEFINE num 17 
      {&assigntable} 
      &SCOPED-DEFINE num 18
      {&assigntable} 
      &SCOPED-DEFINE num 19 
      {&assigntable} 
      &SCOPED-DEFINE num 20
      {&assigntable} 
      &SCOPED-DEFINE num 21
      {&assigntable} 
      &SCOPED-DEFINE num 22
      {&assigntable} 
      &SCOPED-DEFINE num 23 
      {&assigntable} 
      &SCOPED-DEFINE num 24
      {&assigntable} 
      &SCOPED-DEFINE num 25 
      {&assigntable} 
      &SCOPED-DEFINE num 26
      {&assigntable} 
      &SCOPED-DEFINE num 27 
      {&assigntable} 
      &SCOPED-DEFINE num 28
      {&assigntable} 
      &SCOPED-DEFINE num 29 
      {&assigntable} 
      &SCOPED-DEFINE num 30
      {&assigntable} 
      &SCOPED-DEFINE num 31
      {&assigntable} 
      &SCOPED-DEFINE num 32
      .
     IF NUM-ENTRIES(pcHandles) > 32 THEN
      ASSIGN
      {&assigntable} 
      &SCOPED-DEFINE num 33 
      {&assigntable} 
      &SCOPED-DEFINE num 34
      {&assigntable} 
      &SCOPED-DEFINE num 35 
      {&assigntable} 
      &SCOPED-DEFINE num 36
      {&assigntable} 
      &SCOPED-DEFINE num 37 
      {&assigntable} 
      &SCOPED-DEFINE num 38
      {&assigntable} 
      &SCOPED-DEFINE num 39 
      {&assigntable} 
      &SCOPED-DEFINE num 40
      {&assigntable} 
      &SCOPED-DEFINE num 41
      {&assigntable} 
      &SCOPED-DEFINE num 42
      {&assigntable} 
      &SCOPED-DEFINE num 43 
      {&assigntable} 
      &SCOPED-DEFINE num 44
      {&assigntable} 
      &SCOPED-DEFINE num 45 
      {&assigntable} 
      &SCOPED-DEFINE num 46
      {&assigntable} 
      &SCOPED-DEFINE num 47 
      {&assigntable} 
      &SCOPED-DEFINE num 48
      {&assigntable} 
      &SCOPED-DEFINE num 49 
      {&assigntable} 
      &SCOPED-DEFINE num 50
      {&assigntable} 
      &SCOPED-DEFINE num 51
      {&assigntable} 
      &SCOPED-DEFINE num 52
      {&assigntable} 
      &SCOPED-DEFINE num 53 
      {&assigntable} 
      &SCOPED-DEFINE num 54
      {&assigntable} 
      &SCOPED-DEFINE num 55 
      {&assigntable} 
      &SCOPED-DEFINE num 56
      {&assigntable} 
      &SCOPED-DEFINE num 57 
      {&assigntable} 
      &SCOPED-DEFINE num 58
      {&assigntable} 
      &SCOPED-DEFINE num 59 
      {&assigntable} 
      &SCOPED-DEFINE num 60
      {&assigntable} 
      &SCOPED-DEFINE num 61
      {&assigntable} 
      &SCOPED-DEFINE num 62
      {&assigntable} 
      &SCOPED-DEFINE num 63 
      {&assigntable} 
      &SCOPED-DEFINE num 64
      .
      &UNDEFINE num
      &UNDEFINE ttVar
      &UNDEFINE Tables
    IF pcObject <> ? AND pcObject <> '':U THEN
    DO:
      /* we cannot lookup the returned pcHandles in case pcobject is an SBO */ 
      &SCOPED-DEFINE xp-assign
      {get InstanceNames cInstanceNames}
      {get ContainerTarget cTargets}.
      &UNDEFINE xp-assign
      hObject = WIDGET-HANDLE(ENTRY(LOOKUP(pcObject,cInstanceNames),cTargets)).
  
      IF NOT VALID-HANDLE(hObject) THEN
        RETURN 'ADM-ERROR':U. 
      
      &SCOPED-DEFINE xp-assign
      {get AppService cAppService hObject}
      {get AsHasStarted lAsHasStarted hObject}
      .
      &UNDEFINE xp-assign    
      
      {set AppService cAppService}.
      RUN connectServer IN TARGET-PROCEDURE (OUTPUT hAppServer). 
  
      IF hAppServer  = ? THEN
        RETURN 'ADM-ERROR':U.
      
      /* if not asHasstarted we must ensure that obtainContextForServer sets
         the 'first-time' context   */
      IF NOT lAsHasStarted THEN
        {set AsHasStarted NO}.
    END.
    
    {set ProcessList pcHandles}.
    cContext = {fn obtainContextForServer}.
    {set ProcessList ''}.
    IF VALID-HANDLE(hAppserver) THEN
    DO:
      {get ServerfileName cServerFileName}.
      RUN adm2/fetchdata64.p ON hAppserver 
       (INPUT cServerFileName,
        INPUT-OUTPUT cContext,
        INPUT pcPhysicalNames,
        INPUT pcQualNames,
        INPUT pcQueryFields,
        INPUT pcQueries,
        INPUT '':U, /* future */
        OUTPUT TABLE-HANDLE hTT[1],OUTPUT TABLE-HANDLE hTT[2],
        OUTPUT TABLE-HANDLE hTT[3],OUTPUT TABLE-HANDLE hTT[4],
        OUTPUT TABLE-HANDLE hTT[5],OUTPUT TABLE-HANDLE hTT[6],
        OUTPUT TABLE-HANDLE hTT[7],OUTPUT TABLE-HANDLE hTT[8],
        OUTPUT TABLE-HANDLE hTT[9],OUTPUT TABLE-HANDLE hTT[10],
        OUTPUT TABLE-HANDLE hTT[11],OUTPUT TABLE-HANDLE hTT[12],
        OUTPUT TABLE-HANDLE hTT[13],OUTPUT TABLE-HANDLE hTT[14],
        OUTPUT TABLE-HANDLE hTT[15],OUTPUT TABLE-HANDLE hTT[16],
        OUTPUT TABLE-HANDLE hTT[17],OUTPUT TABLE-HANDLE hTT[18],
        OUTPUT TABLE-HANDLE hTT[19],OUTPUT TABLE-HANDLE hTT[20],
        OUTPUT TABLE-HANDLE hTT[21],OUTPUT TABLE-HANDLE hTT[22],
        OUTPUT TABLE-HANDLE hTT[23],OUTPUT TABLE-HANDLE hTT[24],
        OUTPUT TABLE-HANDLE hTT[25],OUTPUT TABLE-HANDLE hTT[26],
        OUTPUT TABLE-HANDLE hTT[27],OUTPUT TABLE-HANDLE hTT[28],
        OUTPUT TABLE-HANDLE hTT[29],OUTPUT TABLE-HANDLE hTT[30],
        OUTPUT TABLE-HANDLE hTT[31],OUTPUT TABLE-HANDLE hTT[32],
        OUTPUT TABLE-HANDLE hTT[33],OUTPUT TABLE-HANDLE hTT[34],
        OUTPUT TABLE-HANDLE hTT[35],OUTPUT TABLE-HANDLE hTT[36],
        OUTPUT TABLE-HANDLE hTT[37],OUTPUT TABLE-HANDLE hTT[38],
        OUTPUT TABLE-HANDLE hTT[39],OUTPUT TABLE-HANDLE hTT[40],
        OUTPUT TABLE-HANDLE hTT[41],OUTPUT TABLE-HANDLE hTT[42],
        OUTPUT TABLE-HANDLE hTT[43],OUTPUT TABLE-HANDLE hTT[44],
        OUTPUT TABLE-HANDLE hTT[45],OUTPUT TABLE-HANDLE hTT[46],
        OUTPUT TABLE-HANDLE hTT[47],OUTPUT TABLE-HANDLE hTT[48],
        OUTPUT TABLE-HANDLE hTT[49],OUTPUT TABLE-HANDLE hTT[50],
        OUTPUT TABLE-HANDLE hTT[51],OUTPUT TABLE-HANDLE hTT[52],
        OUTPUT TABLE-HANDLE hTT[53],OUTPUT TABLE-HANDLE hTT[54],
        OUTPUT TABLE-HANDLE hTT[55],OUTPUT TABLE-HANDLE hTT[56],
        OUTPUT TABLE-HANDLE hTT[57],OUTPUT TABLE-HANDLE hTT[58],
        OUTPUT TABLE-HANDLE hTT[59],OUTPUT TABLE-HANDLE hTT[60],
        OUTPUT TABLE-HANDLE hTT[61],OUTPUT TABLE-HANDLE hTT[62],
        OUTPUT TABLE-HANDLE hTT[63],OUTPUT TABLE-HANDLE hTT[64],
        OUTPUT cError). 
       
    END.
    ELSE DO:  /* we cannot get here */ 
      {get AsHandle hAsHandle}.
      IF VALID-HANDLE(hAsHandle)  THEN
        RUN remoteFetchData IN hAsHandle
        (INPUT-OUTPUT ccontext,
         INPUT pcPhysicalNames,
         INPUT pcQualNames,
         INPUT pcQueryFields,
         INPUT pcQueries,
         INPUT '':U, /* future */
         OUTPUT TABLE-HANDLE hTT[1],OUTPUT TABLE-HANDLE hTT[2],
         OUTPUT TABLE-HANDLE hTT[3],OUTPUT TABLE-HANDLE hTT[4],
         OUTPUT TABLE-HANDLE hTT[5],OUTPUT TABLE-HANDLE hTT[6],
         OUTPUT TABLE-HANDLE hTT[7],OUTPUT TABLE-HANDLE hTT[8],
         OUTPUT TABLE-HANDLE hTT[9],OUTPUT TABLE-HANDLE hTT[10],
         OUTPUT TABLE-HANDLE hTT[11],OUTPUT TABLE-HANDLE hTT[12],
         OUTPUT TABLE-HANDLE hTT[13],OUTPUT TABLE-HANDLE hTT[14],
         OUTPUT TABLE-HANDLE hTT[15],OUTPUT TABLE-HANDLE hTT[16],
         OUTPUT TABLE-HANDLE hTT[17],OUTPUT TABLE-HANDLE hTT[18],
         OUTPUT TABLE-HANDLE hTT[19],OUTPUT TABLE-HANDLE hTT[20],
         OUTPUT TABLE-HANDLE hTT[21],OUTPUT TABLE-HANDLE hTT[22],
         OUTPUT TABLE-HANDLE hTT[23],OUTPUT TABLE-HANDLE hTT[24],
         OUTPUT TABLE-HANDLE hTT[25],OUTPUT TABLE-HANDLE hTT[26],
         OUTPUT TABLE-HANDLE hTT[27],OUTPUT TABLE-HANDLE hTT[28],
         OUTPUT TABLE-HANDLE hTT[29],OUTPUT TABLE-HANDLE hTT[30],
         OUTPUT TABLE-HANDLE hTT[31],OUTPUT TABLE-HANDLE hTT[32],
         OUTPUT cError).
         
      RUN endClientDataRequest  IN TARGET-PROCEDURE.
    END.
 
    if cError <> "" then 
    do:
       RUN addServerReadError IN TARGET-PROCEDURE(cError).
       RUN showDataMessagesProcedure IN TARGET-PROCEDURE(output cDummy).
       RETURN.   
    end.
    
    /* foreign fields in query from server may not be registered on client
       so set QueryString from QueryWhere  */ 
    DO iObject = 1 TO NUM-ENTRIES(pcHandles):
      IF ENTRY(1,ENTRY(iObject,pcQueryFields,CHR(1)),CHR(2)) <> '':U 
       /* no physicalname means child sdo inside sbo */
      OR ENTRY(iObject,pcPhysicalNames) = '':U THEN
      DO:
        hObject = WIDGET-HANDLE(ENTRY(iObject,pcHandles)).
        {get QueryString cQueryString hObject}.
        IF cQueryString = '':U THEN
        DO:
          /* QueryWhere should normally be ? at this stage, but it might
             have been set from an external call */
          {get QueryWhere cQueryString hObject}.
          IF cQueryString <> ? AND cQueryString <> '':U THEN
          DO:
           {set QueryString cQueryString hObject}.
          END.
        END. /* QueryString = '' */
      END.
    END. /* Do iObject = 1 to num-entries(cContainedObjects) */      
   
    {fnarg applyContextFromServer cContext}.
    {get ServerOperatingMode cServerOperatingMode}.
   
    DO iObject = 1 TO NUM-ENTRIES(pcHandles):
      hObject = WIDGET-HANDLE(ENTRY(iObject,pcHandles)).
  
      &SCOPED-DEFINE xp-assign
      {set AsHasStarted YES hObject}
      {set ServerOperatingMode cServerOperatingMode hObject}
      .
      &UNDEFINE xp-assign
      IF ENTRY(iObject,pcQueries,CHR(1)) <> 'SKIP':U THEN
      DO:
        /* A dynamic dataobject may have gotten its table def here
          and/or an object has been set to cache data */    
        IF ENTRY(iObject,cTTList) = '?':U THEN
          {fnarg receiveData hTT[iObject] hObject}.      
        ELSE
          {fnarg openDataQuery 'FIRST':U hObject}.
      END.
      ELSE IF ENTRY(iObject,cTTList) = '?':U THEN
        {set RowObjectTable hTT[iObject] hObject}.
  
      /* NOTE: When 'SKIP' is used to ignore an SBO's master SDO that got data 
               from cache, the entry in the TTList is set to blank. 
               This ensures that the fetch output parameter above is unknown 
               and NOT mapped to the SDO AND avoids that the empty TT returned 
               is passed to the SDO as when the entry is '?', but instead is 
               deleted immediately.  (ideally we should not have gotten a TT 
               back from the server in this case, but the SBO data retrieval
               always retrieves all tables ) */
      ELSE IF ENTRY(iObject,cTTList) = '':U THEN
        DELETE OBJECT htt[iObject].
  
      /* set ASHasStarted for SBO */
      IF ENTRY(iObject,pcPhysicalNames) <> '':U THEN 
      DO:
          {get ContainerSource hContainerSource hObject}.
          {get QueryObject lSBO hContainerSource}.
          IF lSBO THEN
          DO:
            {set ServerOperatingMode cServerOperatingMode hContainerSource}.
            {set ASHasStarted YES hContainerSource}.
          END.
      END.
  
      /* foreign fields in query from server may not be registered on client
         so set QueryString from BaseQuery if it was not set above  */ 
      IF ENTRY(1,ENTRY(iObject,pcQueryFields,CHR(1)),CHR(2)) <> '':U 
       /* no physicalname means child sdo inside sbo */
      OR ENTRY(iObject,pcPhysicalNames) = '':U THEN
      DO:      
        {get ContainerSource hContainerSource hObject}.
        {get QueryObject lSBO hContainerSource}.
        /* if this is the top SDO in an SBO and we have ForeignFields then 
           the SBO will receive a dataAvailable so we need to set the 
           DataIsFetched to avoid a reopen (SBOs does not currently get 
           Foreign values from the server, so we can't rely on 
           dataAvailable('reset') */
        IF lSBO AND ENTRY(iObject,pcPhysicalNames) <> '':U THEN
           {set DataIsFetched TRUE hContainerSource}.
  
        {get QueryString cQueryString hObject}.
        IF cQueryString = '':U THEN
        DO:
          {get BaseQuery cQueryString hObject}.
          {set QueryString cQueryString hObject}.
        END. /* QueryString = '' */
      END.
    END. /* Do iObject = 1 to num-entries(cContainedObjects) */      

    DO iObject = 1 TO NUM-ENTRIES(pcHandles):
      hObject = WIDGET-HANDLE(ENTRY(iObject,pcHandles)).
      IF ENTRY(1,ENTRY(iObject,pcQueryFields,CHR(1)),CHR(2)) = '':U THEN
      DO:
        /* no physicalname means child sdo inside sbo */
        IF  ENTRY(iObject,pcPhysicalNames) <> '':U
        AND ENTRY(iObject,pcQueries,CHR(1)) <> 'SKIP':U  THEN
        DO:
          {get ContainerSource hContainerSource hObject}.
          {get QueryObject lSBO hContainerSource}.
          IF lSBO THEN
          DO:
            {get MasterDataObject hMasterObject hContainerSource}.
            IF hObject = hMasterObject THEN
              PUBLISH 'DataAvailable':U FROM hMasterObject ('RESET':U).
            ELSE
              PUBLISH 'DataAvailable':U FROM hContainerSource ('RESET':U).
          END.
          ELSE  
            PUBLISH 'DataAvailable':U FROM hObject ('RESET':U).
        END.
      END.
    END.
   END. /* if pcPhysicalnames <> '' */
  END.
  {set appservice '':U}.
END. /* lhasdbaware*/

RUN changeCursor IN TARGET-PROCEDURE('':U).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fetchContainedRows) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE fetchContainedRows Procedure 
PROCEDURE fetchContainedRows :
/*------------------------------------------------------------------------------
   Purpose: Client side procedure to get a set of data back from the server.
Parameters: pcObject AS CHARACTER 
                   - if unknown, then fetch data sets for all QueryObjects
                     in this container as well as all QueryObjects in all 
                     contained containers (in unlimited levels).                         
                   - if specified, then fetch data sets from that Object 
                     down only following the data link.
     Notes: The Data links is followed also when preparing and retrieving data 
            for all objects in containers. 
         -  The datalinks can go across containers, but it will not go into
            a container that not is a descendant of this container.                 
-----------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER pcObject       AS CHARACTER NO-UNDO.
DEFINE INPUT  PARAMETER piStartRow     AS INTEGER   NO-UNDO.
DEFINE INPUT  PARAMETER pcRowIdent     AS CHARACTER NO-UNDO.
DEFINE INPUT  PARAMETER plNext         AS LOGICAL   NO-UNDO.
DEFINE INPUT  PARAMETER piRowsToReturn AS INTEGER   NO-UNDO.
DEFINE OUTPUT PARAMETER piRowsReturned AS INTEGER   NO-UNDO.

DEFINE VARIABLE hRowObject1     AS HANDLE     NO-UNDO.
DEFINE VARIABLE hRowObject2     AS HANDLE     NO-UNDO.
DEFINE VARIABLE hRowObject3     AS HANDLE     NO-UNDO.
DEFINE VARIABLE hRowObject4     AS HANDLE     NO-UNDO.
DEFINE VARIABLE hRowObject5     AS HANDLE     NO-UNDO.
DEFINE VARIABLE hRowObject6     AS HANDLE     NO-UNDO.
DEFINE VARIABLE hRowObject7     AS HANDLE     NO-UNDO.
DEFINE VARIABLE hRowObject8     AS HANDLE     NO-UNDO.
DEFINE VARIABLE hRowObject9     AS HANDLE     NO-UNDO.
DEFINE VARIABLE hRowObject10    AS HANDLE     NO-UNDO.
DEFINE VARIABLE hRowObject11    AS HANDLE     NO-UNDO.
DEFINE VARIABLE hRowObject12    AS HANDLE     NO-UNDO.
DEFINE VARIABLE hRowObject13    AS HANDLE     NO-UNDO.
DEFINE VARIABLE hRowObject14    AS HANDLE     NO-UNDO.
DEFINE VARIABLE hRowObject15    AS HANDLE     NO-UNDO.
DEFINE VARIABLE hRowObject16    AS HANDLE     NO-UNDO.
DEFINE VARIABLE hRowObject17    AS HANDLE     NO-UNDO.
DEFINE VARIABLE hRowObject18    AS HANDLE     NO-UNDO.
DEFINE VARIABLE hRowObject19    AS HANDLE     NO-UNDO.
DEFINE VARIABLE hRowObject20    AS HANDLE     NO-UNDO.
DEFINE VARIABLE hRowObject21    AS HANDLE     NO-UNDO.
DEFINE VARIABLE hRowObject22    AS HANDLE     NO-UNDO.
DEFINE VARIABLE hRowObject23    AS HANDLE     NO-UNDO.
DEFINE VARIABLE hRowObject24    AS HANDLE     NO-UNDO.
DEFINE VARIABLE hRowObject25    AS HANDLE     NO-UNDO.
DEFINE VARIABLE hRowObject26    AS HANDLE     NO-UNDO.
DEFINE VARIABLE hRowObject27    AS HANDLE     NO-UNDO.
DEFINE VARIABLE hRowObject28    AS HANDLE     NO-UNDO.
DEFINE VARIABLE hRowObject29    AS HANDLE     NO-UNDO.
DEFINE VARIABLE hRowObject30    AS HANDLE     NO-UNDO.
DEFINE VARIABLE hRowObject31    AS HANDLE     NO-UNDO.
DEFINE VARIABLE hRowObject32   AS HANDLE     NO-UNDO.

DEFINE VARIABLE iObject AS INTEGER    NO-UNDO.

DEFINE VARIABLE hAsHandle       AS HANDLE     NO-UNDO.
DEFINE VARIABLE cContext        AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cError          AS CHARACTER  NO-UNDO.
DEFINE VARIABLE hObject         AS HANDLE     NO-UNDO.

DEFINE VARIABLE pcPhysicalNames         AS CHARACTER  NO-UNDO.
DEFINE VARIABLE pcQualnames             AS CHARACTER  NO-UNDO.
DEFINE VARIABLE pcQueryFields           AS CHARACTER  NO-UNDO.
DEFINE VARIABLE pcQueries               AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cTTList                 AS CHARACTER  NO-UNDO.
DEFINE VARIABLE pcHandles               AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cServerFileName         AS CHARACTER  NO-UNDO.
DEFINE VARIABLE hAppServer              AS HANDLE     NO-UNDO.
DEFINE VARIABLE cContainedAppServices   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE iService                AS INTEGER    NO-UNDO.
DEFINE VARIABLE cAppService             AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cQueryString            AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cServerOperatingMode    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE hContainerSource        AS HANDLE     NO-UNDO.
DEFINE VARIABLE lSBO                    AS LOGICAL    NO-UNDO.
DEFINE VARIABLE lAsBound                AS LOGICAL    NO-UNDO.
DEFINE VARIABLE cTargets                AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cInstanceNames          AS CHARACTER  NO-UNDO.

RUN changeCursor IN TARGET-PROCEDURE('WAIT':U).

IF pcObject = ? THEN
  {get ContainedAppServices cContainedAppServices}.
                     
DO iService = 1 TO IF pcObject = ? 
                   THEN NUM-ENTRIES(cContainedAppServices)
                   ELSE 1:
  
  IF pcObject = ? THEN
    cAppService = ENTRY(iService,cContainedAppServices).
  ELSE 
    cAppservice = ?.

  RUN prepareDataForFetch IN TARGET-PROCEDURE
    (INPUT TARGET-PROCEDURE,
     INPUT cAppService,
     INPUT pcObject,
     INPUT 'Batch':U, 
     INPUT-OUTPUT pcHandles, 
     INPUT-OUTPUT pcPhysicalNames /* CHARACTER */,
     INPUT-OUTPUT pcQualNames /* CHARACTER */,
     INPUT-OUTPUT pcQueryFields /* CHARACTER */,
     INPUT-OUTPUT pcQueries /* CHARACTER */,
     INPUT-OUTPUT cTTlist  ).

  ASSIGN 
    hRowObject1  = WIDGET-H(ENTRY(1,cTTList)) WHEN NUM-ENTRIES(cTTList) >= 1
    hRowObject2  = WIDGET-H(ENTRY(2,cTTList)) WHEN NUM-ENTRIES(cTTList) >= 2
    hRowObject3  = WIDGET-H(ENTRY(3,cTTList)) WHEN NUM-ENTRIES(cTTList) >= 3
    hRowObject4  = WIDGET-H(ENTRY(4,cTTList)) WHEN NUM-ENTRIES(cTTList) >= 4
    hRowObject5  = WIDGET-H(ENTRY(5,cTTList)) WHEN NUM-ENTRIES(cTTList) >= 5
    hRowObject6  = WIDGET-H(ENTRY(6,cTTList)) WHEN NUM-ENTRIES(cTTList) >= 6
    hRowObject7  = WIDGET-H(ENTRY(7,cTTList)) WHEN NUM-ENTRIES(cTTList) >= 7
    hRowObject8  = WIDGET-H(ENTRY(8,cTTList)) WHEN NUM-ENTRIES(cTTList) >= 8
    hRowObject9  = WIDGET-H(ENTRY(9,cTTList)) WHEN NUM-ENTRIES(cTTList) >= 9
    hRowObject10 = WIDGET-H(ENTRY(10,cTTList)) WHEN NUM-ENTRIES(cTTList) >= 10
    hRowObject11 = WIDGET-H(ENTRY(11,cTTList)) WHEN NUM-ENTRIES(cTTList) >= 11
    hRowObject12 = WIDGET-H(ENTRY(12,cTTList)) WHEN NUM-ENTRIES(cTTList) >= 12
    hRowObject13 = WIDGET-H(ENTRY(13,cTTList)) WHEN NUM-ENTRIES(cTTList) >= 13
    hRowObject14 = WIDGET-H(ENTRY(14,cTTList)) WHEN NUM-ENTRIES(cTTList) >= 14
    hRowObject15 = WIDGET-H(ENTRY(15,cTTList)) WHEN NUM-ENTRIES(cTTList) >= 15
    hRowObject16 = WIDGET-H(ENTRY(16,cTTList)) WHEN NUM-ENTRIES(cTTList) >= 16
    hRowObject17 = WIDGET-H(ENTRY(17,cTTList)) WHEN NUM-ENTRIES(cTTList) >= 17
    hRowObject18 = WIDGET-H(ENTRY(18,cTTList)) WHEN NUM-ENTRIES(cTTList) >= 18
    hRowObject19 = WIDGET-H(ENTRY(19,cTTList)) WHEN NUM-ENTRIES(cTTList) >= 19
    hRowObject20 = WIDGET-H(ENTRY(20,cTTList)) WHEN NUM-ENTRIES(cTTList) >= 20
    hRowObject21 = WIDGET-H(ENTRY(21,cTTList)) WHEN NUM-ENTRIES(cTTList) >= 21
    hRowObject22 = WIDGET-H(ENTRY(22,cTTList)) WHEN NUM-ENTRIES(cTTList) >= 22
    hRowObject23 = WIDGET-H(ENTRY(23,cTTList)) WHEN NUM-ENTRIES(cTTList) >= 23
    hRowObject24 = WIDGET-H(ENTRY(24,cTTList)) WHEN NUM-ENTRIES(cTTList) >= 24
    hRowObject25 = WIDGET-H(ENTRY(25,cTTList)) WHEN NUM-ENTRIES(cTTList) >= 25
    hRowObject26 = WIDGET-H(ENTRY(26,cTTList)) WHEN NUM-ENTRIES(cTTList) >= 26
    hRowObject27 = WIDGET-H(ENTRY(27,cTTList)) WHEN NUM-ENTRIES(cTTList) >= 27
    hRowObject28 = WIDGET-H(ENTRY(28,cTTList)) WHEN NUM-ENTRIES(cTTList) >= 28
    hRowObject29 = WIDGET-H(ENTRY(29,cTTList)) WHEN NUM-ENTRIES(cTTList) >= 29
    hRowObject30 = WIDGET-H(ENTRY(30,cTTList)) WHEN NUM-ENTRIES(cTTList) >= 30
    hRowObject31 = WIDGET-H(ENTRY(31,cTTList)) WHEN NUM-ENTRIES(cTTList) >= 31
    hRowObject32 = WIDGET-H(ENTRY(32,cTTList)) WHEN NUM-ENTRIES(cTTList) >= 32.
    
  {set ProcessList pcHandles}.
  cContext = {fn obtainContextForServer}.
  {set ProcessList '':U}.

  IF pcObject <> ? AND pcObject <> '':U THEN
  DO:
  /* we cannot lookup the returned pcHandles in case pcobject is an SBO */ 
    &SCOPED-DEFINE xp-assign
    {get InstanceNames cInstanceNames}
    {get ContainerTarget cTargets}.
    &UNDEFINE xp-assign
    hObject = WIDGET-HANDLE(ENTRY(LOOKUP(pcObject,cInstanceNames),cTargets)).
    IF NOT VALID-HANDLE(hObject) THEN 
      RETURN ERROR 'ADM-ERROR':U.
    {get AppService cAppService hObject}.
  END.
  
  &SCOPED-DEFINE xp-assign
  {set Appservice cAppService}
  {get AsBound lAsbound}
  {get ServerfileName cServerFileName}.
  &UNDEFINE xp-assign
  IF NOT lAsBound THEN
  DO:
    RUN connectServer IN TARGET-PROCEDURE (OUTPUT hAppServer). 
    
    IF hAppServer  = ? THEN
      RETURN ERROR 'ADM-ERROR':U.

    RUN adm2/fetchrows.p ON hAppserver
     (INPUT cServerFileName,
      INPUT-OUTPUT cContext,
      pcPhysicalNames,
      pcQualNames,
      pcQueryFields,
      pcQueries,
      piStartRow, 
      pcRowIdent, 
      plNext, 
      piRowsToReturn, 
      OUTPUT piRowsReturned,
      OUTPUT TABLE-HANDLE hRowObject1 APPEND, 
      OUTPUT TABLE-HANDLE hRowObject2 APPEND,
      OUTPUT TABLE-HANDLE hRowObject3 APPEND,
      OUTPUT TABLE-HANDLE hRowObject4 APPEND,
      OUTPUT TABLE-HANDLE hRowObject5 APPEND,
      OUTPUT TABLE-HANDLE hRowObject6 APPEND,
      OUTPUT TABLE-HANDLE hRowObject7 APPEND,
      OUTPUT TABLE-HANDLE hRowObject8 APPEND,
      OUTPUT TABLE-HANDLE hRowObject9 APPEND,
      OUTPUT TABLE-HANDLE hRowObject10 APPEND,
      OUTPUT TABLE-HANDLE hRowObject11 APPEND,
      OUTPUT TABLE-HANDLE hRowObject12 APPEND,
      OUTPUT TABLE-HANDLE hRowObject13 APPEND,
      OUTPUT TABLE-HANDLE hRowObject14 APPEND,
      OUTPUT TABLE-HANDLE hRowObject15 APPEND,
      OUTPUT TABLE-HANDLE hRowObject16 APPEND,
      OUTPUT TABLE-HANDLE hRowObject17 APPEND,
      OUTPUT TABLE-HANDLE hRowObject18 APPEND,
      OUTPUT TABLE-HANDLE hRowObject19 APPEND,
      OUTPUT TABLE-HANDLE hRowObject20 APPEND,
      OUTPUT TABLE-HANDLE hRowObject21 APPEND,
      OUTPUT TABLE-HANDLE hRowObject22 APPEND,
      OUTPUT TABLE-HANDLE hRowObject23 APPEND,
      OUTPUT TABLE-HANDLE hRowObject24 APPEND,
      OUTPUT TABLE-HANDLE hRowObject25 APPEND,
      OUTPUT TABLE-HANDLE hRowObject26 APPEND,
      OUTPUT TABLE-HANDLE hRowObject27 APPEND,
      OUTPUT TABLE-HANDLE hRowObject28 APPEND,
      OUTPUT TABLE-HANDLE hRowObject29 APPEND,
      OUTPUT TABLE-HANDLE hRowObject30 APPEND,
      OUTPUT TABLE-HANDLE hRowObject31 APPEND,
      OUTPUT TABLE-HANDLE hRowObject32 APPEND,
      OUTPUT cError). /* not used yet */
  END.
  ELSE DO:
    {get AsHandle hAsHandle}.
    RUN remoteFetchRows IN hAsHandle
      (INPUT-OUTPUT cContext,
       pcPhysicalNames,
       pcQualNames,
       pcQueryFields,
       pcQueries,
       piStartRow, 
       pcRowIdent, 
       plNext, 
       piRowsToReturn, 
       OUTPUT piRowsReturned,
       OUTPUT TABLE-HANDLE hRowObject1 APPEND, 
       OUTPUT TABLE-HANDLE hRowObject2 APPEND,
       OUTPUT TABLE-HANDLE hRowObject3 APPEND,
       OUTPUT TABLE-HANDLE hRowObject4 APPEND,
       OUTPUT TABLE-HANDLE hRowObject5 APPEND,
       OUTPUT TABLE-HANDLE hRowObject6 APPEND,
       OUTPUT TABLE-HANDLE hRowObject7 APPEND,
       OUTPUT TABLE-HANDLE hRowObject8 APPEND,
       OUTPUT TABLE-HANDLE hRowObject9 APPEND,
       OUTPUT TABLE-HANDLE hRowObject10 APPEND,
       OUTPUT TABLE-HANDLE hRowObject11 APPEND,
       OUTPUT TABLE-HANDLE hRowObject12 APPEND,
       OUTPUT TABLE-HANDLE hRowObject13 APPEND,
       OUTPUT TABLE-HANDLE hRowObject14 APPEND,
       OUTPUT TABLE-HANDLE hRowObject15 APPEND,
       OUTPUT TABLE-HANDLE hRowObject16 APPEND,
       OUTPUT TABLE-HANDLE hRowObject17 APPEND,
       OUTPUT TABLE-HANDLE hRowObject18 APPEND,
       OUTPUT TABLE-HANDLE hRowObject19 APPEND,
       OUTPUT TABLE-HANDLE hRowObject20 APPEND,
       OUTPUT TABLE-HANDLE hRowObject21 APPEND,
       OUTPUT TABLE-HANDLE hRowObject22 APPEND,
       OUTPUT TABLE-HANDLE hRowObject23 APPEND,
       OUTPUT TABLE-HANDLE hRowObject24 APPEND,
       OUTPUT TABLE-HANDLE hRowObject25 APPEND,
       OUTPUT TABLE-HANDLE hRowObject26 APPEND,
       OUTPUT TABLE-HANDLE hRowObject27 APPEND,
       OUTPUT TABLE-HANDLE hRowObject28 APPEND,
       OUTPUT TABLE-HANDLE hRowObject29 APPEND,
       OUTPUT TABLE-HANDLE hRowObject30 APPEND,
       OUTPUT TABLE-HANDLE hRowObject31 APPEND,
       OUTPUT TABLE-HANDLE hRowObject32 APPEND,
       OUTPUT cError). /* not used yet */       
    RUN endClientDataRequest  IN TARGET-PROCEDURE.
  END.


  /* Foreign fields in query from server may not be registered on client
     so set QueryString from QueryWhere  */ 
  DO iObject = 1 TO NUM-ENTRIES(pcHandles):
    IF ENTRY(1,ENTRY(iObject,pcQueryFields,CHR(1)),CHR(2)) <> '':U     
     /* no physicalname means child sdo inside sbo */
    OR ENTRY(iObject,pcPhysicalNames) = '':U THEN
    DO:
      hObject = WIDGET-HANDLE(ENTRY(iObject,pcHandles)).
      {get QueryString cQueryString hObject}.
      IF cQueryString = '':U THEN
      DO:
        /* QueryWhere should normally be ? at this stage, but it might
           have been set from an external call */
        {get QueryWhere cQueryString hObject}.
        IF cQueryString <> ? AND cQueryString <> '':U THEN
        DO:
         {set QueryString cQueryString hObject}.
        END.
      END. /* QueryString = '' */
    END.
  END. /* Do iObject = 1 to num-entries(cContainedObjects) */      
  
  {fnarg applyContextFromServer cContext}.
  {get ServerOperatingMode cServerOperatingMode}.
  
  /* foreign fields in query from server may not be registered on client
     so set QueryString from BaseQuery if it was not set above  */ 
  DO iObject = 1 TO NUM-ENTRIES(pcHandles):
    
    hObject = WIDGET-HANDLE(ENTRY(iObject,pcHandles)).
    {set AsHasStarted YES hObject}.
    {set ServerOperatingMode cServerOperatingMode hObject}.
    
    /* The caller opens the batched dataset */
    IF iObject > 1 THEN
    DO:
      {fnarg openDataQuery 'FIRST':U hObject}.
      {set DataIsFetched TRUE hObject}.
    END.

    /* set ASHasStarted for SBO */
    IF ENTRY(iObject,pcPhysicalNames) <> '':U THEN 
    DO:
        {get ContainerSource hContainerSource hObject}.
        {get QueryObject lSBO hContainerSource}.
        IF lSBO THEN
            {set ASHasStarted YES hContainerSource}.
    END.

    IF ENTRY(1,ENTRY(iObject,pcQueryFields,CHR(1)),CHR(2)) <> '':U 
     /* no physicalname means child sdo inside sbo */
    OR ENTRY(iObject,pcPhysicalNames) = '':U THEN
    DO:
      {get ContainerSource hContainerSource hObject}.
      {get QueryObject lSBO hContainerSource}.
      /* if this is the top SDO in an SBO and we have ForeignFields then 
         the SBO will receive a dataAvailable so we need to set the 
         DataIsFetched to avoid a reopen (SBOs does not currently get 
         Foreign values from the server, so we can't rely on 
         dastaAvailble('reset') */
      IF lSBO AND ENTRY(iObject,pcPhysicalNames) <> '':U THEN
         {set DataIsFetched TRUE hContainerSource}.

      {get QueryString cQueryString hObject}.
      IF cQueryString = '':U THEN
      DO:
        {get BaseQuery cQueryString hObject}.
        {set QueryString cQueryString hObject}.
      END. /* QueryString = '' */
    END.
  END. /* Do iObject = 1 to num-entries(cContainedObjects) */      
END.

RUN changeCursor IN TARGET-PROCEDURE('':U).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fetchData) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE fetchData Procedure 
PROCEDURE fetchData :
/*------------------------------------------------------------------------------
  Purpose:   Fetches all data for contained dataviews from the datacontainer  
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   DEFINE VARIABLE cEntities       AS CHARACTER  NO-UNDO.
   DEFINE VARIABLE cEntityNames    AS CHARACTER  NO-UNDO.
   DEFINE VARIABLE cDatasetSources AS CHARACTER  NO-UNDO.
   DEFINE VARIABLE cDataTables     AS CHARACTER  NO-UNDO.
   DEFINE VARIABLE cQueries        AS CHARACTER  NO-UNDO.
   DEFINE VARIABLE cRequests       AS CHARACTER  NO-UNDO.
   DEFINE VARIABLE cForeignFields  AS CHARACTER  NO-UNDO.
   DEFINE VARIABLE cPositionFields AS CHARACTER  NO-UNDO.
   DEFINE VARIABLE cBatchSizes     AS CHARACTER  NO-UNDO.
   DEFINE VARIABLE cContext        AS CHARACTER  NO-UNDO.

   DEFINE VARIABLE iNumTables   AS INTEGER    NO-UNDO.
   DEFINE VARIABLE cTable       AS CHARACTER  NO-UNDO.
   DEFINE VARIABLE iTable       AS INTEGER    NO-UNDO.
   DEFINE VARIABLE hObject      AS HANDLE     NO-UNDO.
   DEFINE VARIABLE lDefs        AS LOGICAL    NO-UNDO.
   DEFINE VARIABLE hDataSource  AS HANDLE     NO-UNDO.
   DEFINE VARIABLE cTargets     AS CHARACTER  NO-UNDO.
   DEFINE VARIABLE hRequestor   AS HANDLE     NO-UNDO.
   DEFINE VARIABLE cMessage     AS CHARACTER  NO-UNDO.
   DEFINE VARIABLE cDummy       AS CHARACTER  NO-UNDO.
    
   /* Run, don't publish, in order to call viewer override */
   RUN buildDataRequest IN TARGET-PROCEDURE
                               (INPUT TARGET-PROCEDURE, 
                                INPUT '', /* datasource*/
                                INPUT '',  /* viewersource */
                                INPUT-OUTPUT cRequests,
                                INPUT-OUTPUT cDataTables,
                                INPUT-OUTPUT cQueries,
                                INPUT-OUTPUT cBatchSizes,
                                INPUT-OUTPUT cForeignFields,
                                INPUT-OUTPUT cPositionFields,
                                INPUT-OUTPUT cContext,
                                INPUT-OUTPUT cDatasetSources,
                                INPUT-OUTPUT cEntities,
                                INPUT-OUTPUT cEntityNames).
 
  {get RequestHandle hRequestor}.
  RUN retrieveData IN {fn getDataContainerHandle}
                         (hRequestor,
                          YES, /* refresh (log context both ends)*/
                          NO,
                          NO, 
                          cRequests,
                          cDataTables,
                          cQueries,
                          cBatchSizes,
                          cForeignFields,
                          cPositionFields,
                          cContext,
                          cDatasetSources,
                          cEntities,
                          cEntityNames) NO-ERROR.

  IF ERROR-STATUS:ERROR THEN
  DO:
    RUN addServerError IN TARGET-PROCEDURE('retrieve':u,RETURN-VALUE,cEntities).
    RUN showDataMessagesProcedure IN TARGET-PROCEDURE (output cDummy).
    RETURN 'ADM-ERROR':U.
  END.

  PUBLISH "dataRequestComplete":U FROM TARGET-PROCEDURE.  

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getContextAndDestroy) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getContextAndDestroy Procedure 
PROCEDURE getContextAndDestroy :
/*------------------------------------------------------------------------------
  Purpose:     Server-side procedure run after new data has been requested by 
               the client.
  Parameters:  OUTPUT pcContaineProps - Properties of the Contained SDOs
  Notes:        
------------------------------------------------------------------------------*/
  DEFINE OUTPUT PARAMETER pcContainedProps AS CHAR NO-UNDO.
                                                                                      
  pcContainedProps = {fn obtainContextForClient}.
  RUN destroyObject IN TARGET-PROCEDURE.              
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-hideObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE hideObject Procedure 
PROCEDURE hideObject :
/*------------------------------------------------------------------------------
  Purpose: Override to support removal of menus on hide    
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE lRemoveMenu AS LOGICAL    NO-UNDO.

  {get RemoveMenuOnhide lRemoveMenu}.
 
  IF lRemoveMenu THEN
     PUBLISH 'removeMenu':U FROM TARGET-PROCEDURE.
  
  RUN SUPER. 
         
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-hidePage) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE hidePage Procedure 
PROCEDURE hidePage :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER piPageNum AS INTEGER NO-UNDO.

DEFINE VARIABLE cPageLinkHandles AS CHARACTER NO-UNDO.
DEFINE VARIABLE hObject AS HANDLE NO-UNDO.  
DEFINE VARIABLE iEntry AS INTEGER NO-UNDO.
DEFINE VARIABLE cLink AS CHARACTER NO-UNDO.

    cLink = "Page" + STRING(piPageNum) + "-target".

    
    cPageLinkHandles = DYNAMIC-FUNCTION('pageNTargets' IN TARGET-PROCEDURE, TARGET-PROCEDURE, piPageNum).
    DO iEntry = 1 TO NUM-ENTRIES(cPageLinkHandles):
        hObject = WIDGET-HANDLE(ENTRY(iEntry,cPageLinkHandles)).
        RUN hideObject IN hObject NO-ERROR.
    END.
    RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-initializeDataObjects) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeDataObjects Procedure 
PROCEDURE initializeDataObjects :
/*------------------------------------------------------------------------------
  Purpose: initialize data objects separate (before) other objects.
       
  Parameters: plDeep 
              Yes - Publish to child containers to open their dataobjects
              
  Notes:  - This will call createObjects and create all objects in the 
            container including visual objects.  
            The createObjects is called from the main block for some 
            containers different places in 
            containers, so  will only run once for page 0.
          - This is used by an AppServer Aware container or a Dataview 
            container (HasDbAwareObjects=NO) (or published from one.
 Note date: 2005/09/13          
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER plDeep AS LOGICAL    NO-UNDO.

  DEFINE VARIABLE cTargets           AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lQuery             AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE hObject            AS HANDLE     NO-UNDO.
  DEFINE VARIABLE iTarget            AS INTEGER    NO-UNDO.
  DEFINE VARIABLE lQueryObject       AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lDataContainer     AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE hContainerSource   AS HANDLE     NO-UNDO.
  DEFINE VARIABLE lFetchPending      AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lObjectsCreated    AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cObjectType        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lHasDBAware        AS LOGICAL    NO-UNDO INIT ?.
  DEFINE VARIABLE lDBAware           AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cUIBMode           AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lParentInitted     AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE hDataSource        AS HANDLE     NO-UNDO.
  DEFINE VARIABLE lQuerySource       AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lDataSourceInitted AS LOGICAL    NO-UNDO.

  &SCOPED-DEFINE xp-assign
  {get ObjectsCreated lObjectsCreated}
  {get UIBMode cUIBMode}
  {get QueryObject lQuery}
  .
  &UNDEFINE xp-assign

  /* in design mode objects are created only, so don't initialize */
  IF cUIBMode BEGINS 'DESIGN':U THEN
    RETURN.

  /* This is only called in itself by non query containers, but SBOs will 
     receive this from its container, but the publishing container will manage
     the SBO as a data object and RUN initializeObject directly, so we ignore 
     this. */       
  IF lQuery THEN 
    RETURN.

  /* createObjects is protected against double run, but we still want to avoid 
     calling it unnecessarily */
  IF NOT lObjectsCreated THEN
    RUN createObjects IN TARGET-PROCEDURE.
    
  IF plDeep THEN
    PUBLISH 'initializeDataObjects':U FROM TARGET-PROCEDURE (plDeep).  
         
  {get ContainerTarget cTargets}.
  DO iTarget = 1 TO NUM-ENTRIES(cTargets): 
    ASSIGN 
      hObject  = WIDGET-HANDLE(ENTRY(iTarget,cTargets))
      lDBAware = ?.
    {get QueryObject lQuery hObject}.
    
    /* Note that there is a DBAware property in the instances, but 
       it may have been set to false in TT SDOs to avoid having to 
       deploy the _cl or use the dynSDO, and cannot be used here.  
      (As one may guess this was not considered when the HasDBawareObjects
       was implemented) */

    IF lQuery THEN
      lDBAware = NOT {fnarg instanceOf 'DataView':U hObject}.
    ELSE 
      {get HasDBAwareObjects lDBAware hObject} NO-ERROR.

    IF lDbAware <> ? THEN
    DO:
      IF lHasDBAware = ? AND lDbAware <> ? THEN
      DO:
        lHasDBAware = lDBAware.
        {set HasDBAwareObjects lHasDBAware}.
        IF NOT lHasDBAware THEN
          /* override default from appserver aware BEFORE calling 
             initializeObject in any dataview 
             (getRequesthandle will set it to true if applicable)  */
          {set DataContainer FALSE}.
      END.
      ELSE IF lHasDBAware <> lDBAware THEN
      DO:
          MESSAGE  "The container cannot retrieve data for a mixed type of data objects."
                   "Ensure that the contained data objects are either all DbAware (SDOs or SBOs) or not (DataViews)."
                    VIEW-AS ALERT-BOX WARNING.
          RETURN ERROR.
      END.

      IF lQuery THEN
      DO:
        RUN initializeObject IN hObject.    
          /* unsubscribe to avoid the publish below
           (initializeObject is protected against double initialize, but this 
            also protects overrides). */ 
        UNSUBSCRIBE PROCEDURE hObject TO 'initializeObject':U IN TARGET-PROCEDURE.
      END.
      IF NOT lDbAware THEN
      DO:
       /* Subscribe to buildDataRequest from the container if this is a top 
          buffer of the request. This also applies to containers (viewers). 
         (datatargets subscribes to buildDataRequest from their data source)  */

        {get DataSource hDataSource hObject}.
        IF VALID-HANDLE(hDataSource) THEN
        DO:
          &SCOPED-DEFINE xp-assign
          {get ObjectInitialized lDataSourceInitted hDataSource}
          {get QueryObject lQuerySource hDataSource}
          .
          &UNDEFINE xp-assign
        END.

        IF NOT VALID-HANDLE(hDataSource) 
        OR NOT lQuerySource 
        OR lDataSourceInitted THEN
          SUBSCRIBE PROCEDURE hObject TO 'buildDataRequest':U IN TARGET-PROCEDURE.
      END.
    END. /* if lDbaware <> ? */
  END. /* iTarget = 1 to num-entries(cTargets) */

  /* The sbo initializeObject has its own fetch logic, so don't fetch if 
     this is a query object */
  IF NOT lQueryobject THEN
  DO:
    {get ContainerSource hContainerSource}.
    /* If dataviews fetchdata will call the service. */
    IF lHasDbAware = NO THEN  
    DO:
      /* Run from top (not inside an unitialized container) */
      IF VALID-HANDLE(hContainersource) THEN
        {get ObjectInitialized lParentInitted hContainersource }.
      ELSE 
        lParentInitted = TRUE.
       
      IF lParentInitted THEN
        RUN fetchData IN TARGET-PROCEDURE.
    END. /* not hasDbAware */
    /* If sdos and/or sbos fetchcontaineddata will call the appservice. 
      ( If we're the top data container of the request )*/
    ELSE DO:
      {get DataContainer lDataContainer}.
      IF lDataContainer THEN
      DO:
        IF VALID-HANDLE(hContainerSource) THEN
          lFetchPending = {fn isFetchPending hContainerSource}.
  
        IF NOT lFetchPending THEN
          RUN fetchContainedData IN TARGET-PROCEDURE (?).         
      END.
    END.  /* else (hasDbAware) */
  END. /* not queryobject (sbo)*/
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-initializeObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeObject Procedure 
PROCEDURE initializeObject :
/*------------------------------------------------------------------------------
  Purpose:     Does container-specific initialization.
  Parameters:  <none>
------------------------------------------------------------------------------*/
  DEFINE VARIABLE lHideOnInit      AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE lDisableOnInit   AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE lInitialized     AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE cType            AS CHARACTER NO-UNDO.
  DEFINE VARIABLE iStartPage       AS INTEGER   NO-UNDO.
  DEFINE VARIABLE iResizeOnPage    AS INTEGER   NO-UNDO.
  DEFINE VARIABLE hWaitForObject   AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hContainerSource AS HANDLE    NO-UNDO.
  DEFINE VARIABLE lFetchPending    AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE lDataContainer   AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE lQueryObject     AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE lUseRepository   AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE hWidget          AS HANDLE    NO-UNDO.
  DEFINE VARIABLE lObjectsCreated  AS LOGICAL   NO-UNDO.

  DEFINE VARIABLE hContainingWindow             AS HANDLE    NO-UNDO.
  DEFINE VARIABLE lParentInitted                AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE cObjectType                   AS CHARACTER NO-UNDO.
  DEFINE VARIABLE hContainerHandle              AS HANDLE    NO-UNDO.
  DEFINE VARIABLE cObjects                      AS CHARACTER NO-UNDO.

  &SCOPED-DEFINE xp-assign
  {get ContainerType cType}
  {get ObjectInitialized lInitialized}
  {get StartPage iStartPage}.
  &UNDEFINE xp-assign

  IF lInitialized THEN
    RETURN.

  IF cType = "FRAME":U OR cType = "VIRTUAL":U THEN
  DO:
    /* A non-visual container (Simple SmartContainer) needs to run 
       destroyObject on close of the procedure, for example, when it has 
       been run from the AppBuilder for testing purposes */
    IF cType = "VIRTUAL":U THEN
      ON CLOSE OF TARGET-PROCEDURE
       PERSISTENT RUN destroyObject IN TARGET-PROCEDURE.
    /* A SmartFrame or non-visual container does not RUN createObjects from the 
       main block, so it may be postponed until the SmartFrame is actually 
       initialized by its container (or by the UIB in design mode).
       It may have been called from initializeDataObject of a parent or grand parent 
       so we avoid calling createObjects if ObjectsCreated is true */
    {get ObjectsCreated lObjectsCreated}.
    IF NOT lObjectsCreated THEN
    DO:
      RUN createObjects IN TARGET-PROCEDURE NO-ERROR.
      IF ERROR-STATUS:ERROR OR RETURN-VALUE <> '':U THEN
        RETURN 'ADM-ERROR':U.

    END.   /* This will run adm-create-objects*/
  END.   /* END DO IF cType */

  IF cType NE "VIRTUAL":U THEN    /* Skip for non-visual contaioners. */
  DO:
     /*Sets widget-ids if the -usewidgetid session parameter is being used*/
     IF DYNAMIC-FUNCTION("getUseWidgetID":U IN TARGET-PROCEDURE) THEN
     DO:
         ASSIGN cObjects = DYNAMIC-FUNCTION('pageNTargets':U IN TARGET-PROCEDURE, INPUT TARGET-PROCEDURE, INPUT 0).
         
         IF iStartPage NE 0 THEN
         ASSIGN cObjects = cObjects + "," + DYNAMIC-FUNCTION('pageNTargets':U IN TARGET-PROCEDURE, INPUT TARGET-PROCEDURE, INPUT iStartPage)
                cObjects = TRIM(cObjects, ",":U).

         RUN assignWidgetIDs IN TARGET-PROCEDURE (INPUT cObjects, 0).
     END. /*IF DYNAMIC-FUNCTION("getUseWidgetID":U IN TARGET-PROCEDURE) THEN*/

    RUN initializeVisualContainer IN TARGET-PROCEDURE.
    
    &SCOPED-DEFINE xp-assign
    {get HideOnInit lHideOnInit}
    {get DisableOnInit lDisableOnInit}
    {get ContainerHandle hContainerHandle}
    .
    &UNDEFINE xp-assign
    /* ensure child frame realization in this window or this container's window */
    CURRENT-WINDOW = hContainerHandle:WINDOW NO-ERROR. 
     
    /* For containers, we propogate the DisableOnInit attributes to children
       before initializing them. (this is very old behavior that possibly is 
       unnecessary) */      
    IF lDisableOnInit THEN
      dynamic-function ("assignLinkProperty":U IN TARGET-PROCEDURE,
                         'CONTAINER-TARGET':U, 'DisableOnInit':U, 'yes':U).
    
    else if lHideOnInit then 
      /* For containers, whether DISABLE is explicitly set or not, we
         need to set it for the container itself if HideOnInit is true,
         otherwise the 'enable' below will force the container
         to be viewed if it contains any simple objects. */
      lDisableOnInit = yes.     
  END. /* cType <> 'VIRTUAL' */

  IF cType = "WINDOW":U THEN
  DO:
       /* set current MultiInstanceActivate property  */
    DEFINE VARIABLE rRowid                AS ROWID      NO-UNDO.
    DEFINE VARIABLE cProfileData          AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE lOneWindow            AS LOGICAL    NO-UNDO.

    IF VALID-HANDLE(gshProfileManager) THEN
      RUN getProfileData IN gshProfileManager (INPUT "Window":U,
                                               INPUT "OneWindow":U,
                                               INPUT "OneWindow":U,
                                               INPUT NO,
                                               INPUT-OUTPUT rRowid,
                                               OUTPUT cProfileData).

    IF cProfileData = "YES":U
    THEN lOneWindow = NO.
    ELSE lOneWindow = YES.
    DYNAMIC-FUNC("setMultiInstanceActivated":U IN TARGET-PROCEDURE,lOneWindow).
  END.

  DEFINE VARIABLE cObjectMapping AS CHARACTER  NO-UNDO.
  
  /* For some reason the SBO propery gets unknown here   */ 
  {get ObjectMapping cObjectMapping} NO-ERROR.     
  {get QueryObject lQueryObject}.
  IF NOT lQueryObject THEN
  DO: 
    /* initializeDataobjects is published to all child containers, so only
       run from top (not inside an unitialized container) */
    {get ContainerSource hContainerSource}.
    IF VALID-HANDLE(hContainersource) THEN
      {get ObjectInitialized lParentInitted hContainersource }.
    ELSE 
      lParentInitted = TRUE.

    IF lParentInitted THEN
      RUN initializeDataObjects IN TARGET-PROCEDURE (TRUE).
  END.

  /* Do our own visualization last, after all contents are initialized. */
  IF LOOKUP("manualInitializeObjects":U, TARGET-PROCEDURE:INTERNAL-ENTRIES) <> 0 THEN
    RUN manualInitializeObjects IN TARGET-PROCEDURE.
  ELSE
    PUBLISH 'initializeObject':U FROM TARGET-PROCEDURE.
 
  {set ObjectMapping cObjectMapping} NO-ERROR.
  {set PendingPage ?}.   
    /* Set StartPage to 0 so selectPage() will do the right thing. */
  IF iStartPage = ? THEN
    {set StartPage 0}.
 
  IF cType = 'VIRTUAL':U AND SESSION:BATCH-MODE THEN 
  DO:
    {get WaitForObject hWaitForObject}.
    IF VALID-HANDLE(hWaitForObject) THEN
      RUN startWaitFor IN hWaitForObject NO-ERROR.
  END.  /* if non-visual container and running in batch */
 
  RUN SUPER.
  
  
  
  /* The visual class skips this to avoid becoming visible too early if 
     container is window. 
     
     We check the ObjectType of the object, since checking the container
     handle's type is not guaranteed: we only need to do this for window-like
     containers, like windows, dialogs and contained smartframes. We don't 
     want to do it for dynamic viewers etc, which have FRAMEs as their
     container handles (just like Dialogues or SmartFrames).
   */
  &scoped-define xp-Assign     
  {get ObjectType cObjectType}
  {get ContainerHandle hWidget}.
  &undefine xp-Assign
  
    
  /* Pack and layout this container. */
  if valid-handle(hWidget) and can-do('SmartWindow,SmartFrame,SmartDialog', cObjectType) then
  DO:
    &SCOPED-DEFINE xp-assign
    {get DisableOnInit lDisableOnInit}
    {get HideOnInit lHideOnInit}
    {get UseRepository lUseRepository}
    .
    &UNDEFINE xp-assign
  
    /* If this is a Repository object, then make sure everything fits nicely.
     */
    IF lUseRepository THEN
    DO:
        /* Check whether this is a 'proper' container object, a window
           container object, like a DynFrame or a DynTree or a DynMenc.
           If it is, then we need to pack and layout the window. Other
           containers, like SBO or DynViews have this behaviour controlled
           by their window containers.
           
           The getContainingWindow() function will return the TARGET-PROCEDURE
           if this container is a window itself, or it will return the
           proper window container object handle if this container is a DynFrame.
         */
        ASSIGN hContainingWindow = {fn getContainingWindow} NO-ERROR.
        
        /* Don't pack a child DynFrame if the parent window has not yet
           completed its initialisation, since the parent window's initialisaion
           will perform the pack and resize. There should only be one pack/resize 
           when a window is launched.
         */
        IF VALID-HANDLE(hContainingWindow) AND hContainingWindow NE TARGET-PROCEDURE THEN
            {get ObjectInitialized lParentInitted hContainingWindow}.
        ELSE
            ASSIGN lParentInitted = YES.            
        
        IF VALID-HANDLE(hContainingWindow) THEN
        DO:
            /* Make sure that we have enough space for the menu items.
               This should only be run in the containing window.
             */
            {fn updateMenuWidth hContainingWindow} NO-ERROR.
            
            /* Even though Dynamics is running, run these no error
               since there may be static windows that don't have the resizing
               or packing managed by the Layout Manager.
               
               Determine the smallest size. Passing in ? will result in
               the current page being packed.
             */
            IF NOT lParentInitted THEN
                RUN packWindow IN TARGET-PROCEDURE (INPUT ?, INPUT NO) NO-ERROR.
            ELSE
            DO:
                RUN packWindow IN hContainingWindow (INPUT ?, INPUT YES) NO-ERROR.
                /* 
                Lay it out unless window-maximized in which case we postpone until 
                viewObject to make resizeWindow work on maximized size.
                - if hideoninit viewObject is not called. It would eventually need to 
                  call viewObject, but this is not tested, so rezise here for now 
                - The viewObject only calls resizeWindow if width and height is different 
                  from max width and heigth to avoid the resize on hide and view, so we 
                  do the resize here if the sizes match. In this case we do no need to 
                  wait for the view to get it right */
         
                if hContainerHandle:type <> "WINDOW"  
                or lHideOnInit
                or hContainerHandle:WINDOW-STATE <> WINDOW-MAXIMIZED 
                or (    hContainerHandle:width = hContainerHandle:max-width 
                    and hContainerHandle:height = hContainerHandle:max-height) 
                then
                   RUN resizeWindow IN hContainingWindow NO-ERROR. 
            END.    /* parent init'ed */
        END.    /* valid containing window. */
    END.    /* Repository is around. */
      
    IF NOT lDisableOnInit THEN
      RUN enableObject IN TARGET-PROCEDURE.
      
    IF NOT lHideOnInit THEN 
      RUN viewObject IN TARGET-PROCEDURE.
    ELSE 
      run hideObject in target-procedure.
  END. /* 'SmartWindow,SmartFrame,SmartDialog' */
 
/*  if  hContainerHandle:type = "window" then DO:                            */
/*                   ASSIGN hContainERhANDLE:WINDOW-STATE = WINDOW-MAXIMIZED.*/
/*             RUN resizeWindow IN TARGET-PROCEDURE NO-ERROR.                */
/*  END.*/
  SUBSCRIBE TO "RepositoryCacheCleared":U ANYWHERE RUN-PROCEDURE 'clearWidgetIDCache':U.

  IF RETURN-VALUE = "ADM-ERROR":U THEN 
    RETURN "ADM-ERROR":U.
  
  RETURN.
END PROCEDURE.    /* initializeObject */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-initializeVisualContainer) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeVisualContainer Procedure 
PROCEDURE initializeVisualContainer :
/*------------------------------------------------------------------------------
  Purpose: Translate window title and tab folder page labels plus check security
           for page labels 
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hContainer                AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cContainerName            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSecuredTokens            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDisabledPages            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iLoop                     AS INTEGER    NO-UNDO.
  DEFINE VARIABLE hFolder                   AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cFolderLabels             AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cLabel                    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lObjectSecured            AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lObjectTranslated         AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lTranslate                AS LOGICAL    NO-UNDO.
  define variable cPageTokens               as character no-undo.
  define variable cToken                    as character no-undo.
  
  /* oeide vars */
  DEFINE VARIABLE cViewId                   AS CHARACTER   NO-UNDO.
  DEFINE VARIABLE cSecondId                 AS CHARACTER   NO-UNDO.
  
  {get ContainerHandle hContainer}.   
  /* Code to enable Dynamics / ADM2 windows to run docked in the IDE.
     Any window continer (no class type check) */
  if hContainer:type = "window":U  /* only for windows (not frames) */
  and OEIDEIsRunning 
  and valid-handle(hOEIDEService) then 
  do:
    assign  
      /* use existing Appbuilder view */
      cViewId = "com.openedge.pdt.oestudio.views.OEAppBuilderView":U 
      /* linked to specific project   */
      cSecondId = "DesignView_":U
                + DYNAMIC-FUNCTION('getProjectName':U IN hOEIDEService)
      .
    RUN displayWindow IN hOEIDEService(cViewId, cSecondId, hContainer).      
  END.  /* End of IDE docking code */
                  
  /* This method is not called for ContainerType virtual while 
     DataVisual (datavis.p) doesn't support windowname and page source (folder)
     TVController gets windowname from child containers and has no folder */
  if  not {fnarg instanceOf 'DataVisual':U} 
  and not {fnarg instanceOf 'TVController':U} then  
  do:
    &SCOPED-DEFINE xp-assign
    {get ObjectSecured lObjectSecured}
    {get ObjectTranslated lObjectTranslated}
    {get LogicalObjectName cContainerName}.
    &UNDEFINE xp-assign
    
    /* Set default values. */
    IF lObjectSecured EQ ? THEN ASSIGN lObjectSecured = NO.
    IF lObjectTranslated EQ ? THEN ASSIGN lObjectTranslated = NO.

    /* If both object security and translation have been performed, then there is nothing
     * to do here. Both of these values are usually set at the same time, but there may be
     * cases where only one of these values is set. We need to cater for this.  
     PGEN has the ability to generate security and translations independently. */
    IF lObjectSecured AND lObjectTranslated THEN
      RETURN.
    
    /* Avoid creating translation TT if no translation needed or supported */
    lTranslate = not lObjectTranslated and valid-handle(gshTranslationManager). 
    /* prepare for translation */
    if lTranslate then
    do:        
      /* If no logicalObjectname i.e inside static container then derive the 
               master name from the file-name. (remove path and extension)  */
      IF cContainername = '' THEN
        ASSIGN
          cContainerName = TARGET-PROCEDURE:FILE-NAME
          cContainerName = TRIM(REPLACE(cContainerName,"~\":U,"/":U))
          cContainerName = SUBSTRING(cContainerName,R-INDEX(cContainerName,"/":U) + 1)
          cContainerName = IF R-INDEX(cContainerName,'.':U) > 0 
                           THEN SUBSTR(cContainerName,1,R-INDEX(cContainerName,'.':U) - 1)
                           ELSE cContainerName.
        /* 1st empty current temp-table contents */
      EMPTY TEMP-TABLE ttTranslate.
     
        /* Add entry for window title */
      CREATE ttTranslate.
      ASSIGN
        ttTranslate.dLanguageObj = 0
        ttTranslate.cObjectName = cContainerName
        ttTranslate.lGlobal = NO
        ttTranslate.lDelete = NO
        ttTranslate.cWidgetType = "TITLE":U
        ttTranslate.cWidgetName = "TITLE":U
        ttTranslate.hWidgetHandle = hContainer
        ttTranslate.iWidgetEntry = 0
        ttTranslate.cOriginalLabel = hContainer:TITLE    
        ttTranslate.cTranslatedLabel = "":U  
        ttTranslate.cOriginalTooltip = "":U  
        ttTranslate.cTranslatedTooltip = "":U.
      RELEASE ttTranslate.
    end.    /* translate */
    
    /* We use the folder labels in both cases: security and translation */
    /* look for tab folder and translate folder tabs */
    {get PageSource hFolder}.
    if valid-handle(hFolder) then 
    do:    
      {get FolderLabels cFolderLabels hFolder}.
      /* check security for folder labels */
      if not lObjectSecured then
      do:
          &scoped-define xp-assign
          {get SecuredTokens cSecuredTokens}
          {get PageTokens cPageTokens}.
          &undefine xp-assign
          cSecuredTokens = REPLACE(cSecuredTokens, "&":U, "":U).
      end.    /* object not secured */

      label-loop:
      DO iLoop = 1 TO NUM-ENTRIES(cFolderLabels, "|":U):    
        ASSIGN cLabel = ENTRY(iLoop, cFolderLabels, "|":U)
               cToken = entry(iLoop, cPageTokens, '|':u)
               no-error.
        
        if not lObjectSecured and cSecuredTokens gt '':u 
        and can-do(cSecuredTokens, cToken) THEN
          ASSIGN cDisabledPages = cDisabledPages
                                + (IF cDisabledPages <> "":U THEN ",":U ELSE "":U)
                                +  STRING(iLoop).
        if lTranslate then
        do:
          CREATE ttTranslate.
          ASSIGN
            ttTranslate.dLanguageObj = 0
            ttTranslate.cObjectName = cContainerName
            ttTranslate.lGlobal = NO
            ttTranslate.lDelete = NO
            ttTranslate.cWidgetType = "TAB":U
            ttTranslate.cWidgetName = "TAB":U
            ttTranslate.hWidgetHandle = hFolder
            ttTranslate.iWidgetEntry = iLoop
            ttTranslate.cOriginalLabel = cLabel
            ttTranslate.cTranslatedLabel = "":U
            ttTranslate.cOriginalTooltip = "":U
            ttTranslate.cTranslatedTooltip = "":U
            .
          RELEASE ttTranslate.
        end.  /* translate */
      END.  /* label-loop */
    end. /* valid hFolder - pageSource */
    
    /* Got all translation widgets - get translations 
       folder labels and WindowName (from translate of type "title") */
    IF lTranslate /* implies valid-handle */ THEN
    DO:
      RUN multiTranslation IN gshTranslationManager 
                                              (INPUT NO,
                                               INPUT-OUTPUT TABLE ttTranslate).

      /* do the translations */  
      translate-loop:
      FOR EACH ttTranslate:         
        if ttTranslate.cTranslatedLabel > "":U then
        do: 
          if ttTranslate.cWidgetType = "title":U then
            {set WindowName ttTranslate.cTranslatedLabel}.
          else
          if ttTranslate.cWidgetType = "tab":U then
            entry(ttTranslate.iWidgetEntry, cFolderLabels, "|":U) = ttTranslate.cTranslatedLabel. 
        end.
      end. 

      /* translate pages */
      IF valid-handle(hFolder) and cFolderLabels <> "":U THEN
        {set FolderLabels cFolderLabels hFolder}.
    END. /* translate */
    
    /* secure pages */
    IF lObjectSecured NE YES AND cDisabledPages <> "":U THEN
      DYNAMIC-FUNCTION("disablePagesInFolder":U IN TARGET-PROCEDURE, 
                       "security,":U + cDisabledPages).
     
  END. /* not datavisal and not tvcontroller */

  ASSIGN ERROR-STATUS:ERROR = NO.
  RETURN.
END PROCEDURE.  /* initializeVisualContainer */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-initPages) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initPages Procedure 
PROCEDURE initPages :
/*------------------------------------------------------------------------------
  Purpose:  Initializes one or more pages which are not yet being viewed, in
            order to establish links or to prepare for the pages being viewed.
   Params:  pcPageList AS CHARACTER -- comma-separated list of page numbers
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER pcPageList AS CHARACTER NO-UNDO.
  
  DEFINE VARIABLE iPage        AS INTEGER   NO-UNDO.
  DEFINE VARIABLE iCurrentPage AS INTEGER   NO-UNDO.
  DEFINE VARIABLE cPageObjects AS CHARACTER NO-UNDO.
  DEFINE VARIABLE iCnt         AS INTEGER   NO-UNDO.
  define variable lInitialized as logical   no-undo. 
  {get CurrentPage iCurrentPage}.
 
  DO iCnt = 1 TO NUM-ENTRIES(pcPageList): 
    iPage = INT(ENTRY(iCnt,pcPageList)).     
    IF iPage NE 0 THEN 
    DO:                     /* Shouldn't be called for page 0 */
      cPageObjects = pageNTargets(TARGET-PROCEDURE, iPage).
      IF cPageObjects = "":U THEN
      DO:
        /* Page hasn't been created yet:
         Set currentpage to create all objects on the initted page */
        {set CurrentPage iPage}.
        RUN createObjects IN TARGET-PROCEDURE.
        /* PendingPage is the Page that will is visible and is set to 
           ensure that getHideOnInit returns true, without depending on a 
           setHideOnInit, which would interfere with users setting of 
           HideOnInit.
          (This use of PendingPage is not too much of a stretch 
           - its original use was while notifying hide in selectPage.
           It is now the page that will become or remain visible.    
           Incidentally GroupAssignHidden, which was the only logic that 
           depended on this previously now also is correct if called from here) 
             */       
        &SCOPED-DEFINE xp-assign
        {get ObjectInitialized lInitialized}
        {set PendingPage iCurrentPage}.
        &UNDEFINE xp-assign
 
        /*Sets widget-ids if the -usewidgetid session parameter is being used*/
        cPageObjects = pageNTargets(TARGET-PROCEDURE, iPage).
        IF DYNAMIC-FUNCTION("getUseWidgetID":U IN TARGET-PROCEDURE) THEN
        RUN assignWidgetIDs IN TARGET-PROCEDURE (cPageObjects, iPage).
 
        /* if not initialized then this is to soon - wait for publish ()
           We keep pendingPage so objects on not pending page remains hidden
           (getHideOnInit) */
        if lInitialized then
        do: 
          RUN notifyPage IN TARGET-PROCEDURE ("initializeObject":U).
          {set PendingPage ?}.
        end.  
        {set CurrentPage iCurrentPage}.            
      END.
    END.
  END.
  RETURN.
END PROCEDURE. /* initPages */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-isUpdateActive) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE isUpdateActive Procedure 
PROCEDURE isUpdateActive :
/*------------------------------------------------------------------------------
  Purpose: Received from container source to check if contained objects have 
           unsaved or uncommitted changes (including addMode).           
    Notes: This is published thru the container link and are used mainly to 
           validate that a false value received in updateActive cna be used to 
           set UpdateActive.
           This is NOT intended to be called directly, but part of the logic
           that updates UpdateActive.  
           These are the steps:
         - 1. Updating objects publishes updateActive (true or false) to their 
              container targets. 
           2. If the value is FALSE the container turns around and publishes 
              this to ALL ContainerTargets before it is stored in UpdateActive.
              This way the value is only stored as false if ALL contained objects are 
              inactive. 
--------------------------------------------------------------------------------*/
  DEFINE INPUT-OUTPUT PARAMETER plActive AS LOGICAL NO-UNDO.

  DEFINE VARIABLE hContainer AS HANDLE     NO-UNDO. 
  {get ContainerHandle hContainer}.

  /* Ok and Cancel should only hide/view within a window, so if we are a window 
     container then don't republish (we currently also ignore virtual containers)*/   
  IF VALID-HANDLE(hContainer) 
  AND hContainer:TYPE <> 'window':U AND NOT plActive THEN 
    {get UpdateActive plActive}.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-linkStateHandler) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE linkStateHandler Procedure 
PROCEDURE linkStateHandler :
/*------------------------------------------------------------------------------
  Purpose:   Override in order to maintain a unique list of InstanceNames on 
             add and remove of ContainerTarget link    
  Parameters: pcState 
                - 'add','remove','inactive' or 'active' 
              phObject 
                - Handle of object to be linked to                                
              pcLink
                - Link name of link to the other object                                                                 
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pcState     AS CHARACTER  NO-UNDO.
  DEFINE INPUT PARAMETER phObject    AS HANDLE     NO-UNDO.
  DEFINE INPUT PARAMETER pcLink      AS CHARACTER  NO-UNDO.
  
  DEFINE VARIABLE cInstanceNames AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cObjectName    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cNewName       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iSeq           AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cTargets       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iTarget        AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iObject        AS INTEGER    NO-UNDO.
  
  RUN SUPER(pcState,phObject,pcLink). 
  
  IF pcState = 'remove':U AND pcLink = 'ContainerTarget':U THEN
  DO:    
    &SCOPED-DEFINE xp-assign
    {get ContainerTarget cTargets}
    {get InstanceNames cInstanceNames}.
    &UNDEFINE xp-assign
    
    iTarget = LOOKUP(STRING(phObject),cTargets). 
    
    ENTRY(iTarget,cInstanceNames) = '':U NO-ERROR.
    cInstanceNames =  TRIM(REPLACE(',':U + cInstanceNames + ',':U,',,':U,',':U),',':U).
    {set InstanceNames cInstanceNames}.
  END.

  IF pcState = 'add':U AND pcLink = 'ContainerTarget' THEN  
  DO:
    {get InstanceNames cInstanceNames}.
    {get ObjectName cObjectName phObject}.
    IF cObjectName = '':U OR cObjectName = ? THEN
      {get LogicalObjectName cObjectName phObject}.
    ASSIGN
      iSeq     = 1 /* Start newname on 2 */
      cNewName = cObjectName.
       /* Ensure unique instance name */
    DO WHILE CAN-DO(cInstanceNames,cNewName):
      ASSIGN  
        iSeq        = iSeq + 1
        cNewName    = cObjectName + '(':U  + STRING(iSeq) + ')':U.
    END.
    ASSIGN 
      cInstanceNames = cInstanceNames 
                     + (IF cInstanceNames = '':U THEN '':U ELSE ',':U) 
                     + cNewName.
    {set ObjectName cNewName phObject}.
    {set InstanceNames cInstanceNames}.
  END.
   
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-locateWidget) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE locateWidget Procedure 
PROCEDURE locateWidget :
/*------------------------------------------------------------------------------
  Purpose:     Locates a widget and retuns its handle and the handle of its
               TARGET-PROCEDURE
  Parameters:  pcWidget AS CHARACTER
               phWidget AS HANDLE
               phTarget AS HANDLE
  Notes:       Container logic does not support unqualified references and 
               does not support 'Self' and 'Browser' qualifiers
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER pcWidget AS CHARACTER  NO-UNDO.
DEFINE OUTPUT PARAMETER phWidget AS HANDLE     NO-UNDO.
DEFINE OUTPUT PARAMETER phTarget AS HANDLE     NO-UNDO.

  IF NUM-ENTRIES(pcWidget, '.':U) = 1 OR  /* no qualifier */
     ENTRY(1, pcWidget, '.':U) = 'Self':U OR 
     ENTRY(1, pcWidget, '.':U) = 'Browse':U THEN
    RETURN.
  
  RUN SUPER (INPUT pcWidget, OUTPUT phWidget, OUTPUT phTarget).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-notifyPage) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE notifyPage Procedure 
PROCEDURE notifyPage :
/*------------------------------------------------------------------------------
  Purpose:  Invokes the specified procedure in all objects on the CurrentPage of
            Container TARGET-PROCEDURE.
   Params:  pcProc AS CHARACTER -- internal procedure to run
    Notes:  This vestige of "notify" is necessary because the notion of paging
            does not fit well with PUBLISH/SUBSCRIBE. All objects in a Container
            will subscribe to initialize, etc., but the paging performs the
            operation on subsets of those objects at a time.
          - This method has special logic for "initializeObject" to ensure 
            that data objects are initialized first  
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pcProc  AS CHARACTER NO-UNDO.

  DEFINE VARIABLE iPage        AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iVar         AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cObjects     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hObject      AS HANDLE     NO-UNDO.
  DEFINE VARIABLE lQuery       AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lInitted     AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lHide        AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lOk          AS LOGICAL    NO-UNDO.
  
  {get CurrentPage iPage}. 
  cObjects = pageNTargets(TARGET-PROCEDURE,iPage).
 
  /* If intitializing ensure that SDOs are initialized first. This is important 
     since dynamic SDOs create the TT during initialization and visual objects 
     traditionally assume that their datasource's rowobject is valid */ 
  IF pcProc = "initializeObject":U THEN
  DO iVar = 1 TO NUM-ENTRIES(cObjects):
    hObject = WIDGET-HANDLE(ENTRY(iVar, cObjects)).
    IF VALID-HANDLE(hObject) THEN
    DO:
      &SCOPED-DEFINE xp-assign
      {get ObjectInitialized lInitted hObject}
      {get QueryObject lQuery hObject}.
      &UNDEFINE xp-assign
      
      IF lQuery AND NOT lInitted THEN
        RUN initializeObject IN hObject NO-ERROR.    
    END.
  END.   

  DO iVar = 1 TO NUM-ENTRIES(cObjects):
    ASSIGN
      hObject  = WIDGET-HANDLE(ENTRY(iVar, cObjects))
      lQuery   = FALSE
      lInitted = FALSE. 
    IF VALID-HANDLE(hObject) THEN
    DO:
      lOK = TRUE.
      /* if initialize then query objects were initialized in the loop above */
      IF pcProc = "initializeObject":U THEN
      DO:
          &SCOPED-DEFINE xp-assign
          {get ObjectInitialized lInitted hObject}
          {get QueryObject lQuery hObject}
          . 
          &UNDEFINE xp-assign
        IF lQuery OR lInitted THEN
          lOk = FALSE.
      END.
      /* if viewobject keep hideoninit hidden */
      ELSE IF pcProc = 'viewObject':U THEN 
      DO:                                 
        {get HideOnInit lHide hObject}.    
        IF lHide THEN                      
          lOk = FALSE.                     
      END.   
      IF lOk then
        RUN VALUE(pcProc) IN hObject NO-ERROR.
    END.
  END.

  RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-obtainContext) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE obtainContext Procedure 
PROCEDURE obtainContext :
/*------------------------------------------------------------------------------
  Purpose:    Obtains context for the container and its contained objects
  Parameters: pcMode - 'ForClient' or 'ForServer' 
                        Decides which function to call in SDOs
              pcParent - Parent container used to qualify names          
         I-O  pcPropList  - Ordinal list of properties  (new props will be added)
         I-O  pcValueList - Property numbers and values                              
  Notes:      This is the guts of obtainContextForServer and 
              obtainContextForClient.  
------------------------------------------------------------------------------*/
    DEFINE INPUT        PARAMETER pcMode       AS CHARACTER  NO-UNDO.
    DEFINE INPUT        PARAMETER pcParent     AS CHARACTER  NO-UNDO.
    DEFINE INPUT-OUTPUT PARAMETER pcPropList   AS CHARACTER  NO-UNDO.
    DEFINE INPUT-OUTPUT PARAMETER pcValueList  AS CHARACTER  NO-UNDO.
    
  DEFINE VARIABLE iProp            AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cProp            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iObject          AS INTEGER    NO-UNDO.
  DEFINE VARIABLE hObject          AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cObjectType      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cObjectName      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cPropList        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cValue           AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cGrandChildren   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cTargets         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cTargetNames     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cProcessList     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cASDivision      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cContext         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iLoop            AS INTEGER    NO-UNDO.
  DEFINE VARIABLE lAddContext      AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lObtainContext   AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE hMaster          AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cDataObjects     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cClientNames     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iClient          AS INTEGER    NO-UNDO.
  
  &SCOPED-DEFINE xp-assign
  {get ObjectType cObjectType}    
  {get InstanceNames cTargetNames}
  {get ContainerTarget cTargets}
  /* If set skip SDO handles not in list */
  {get ProcessList cProcessList}
  /* Clientnames to use as context name passed from client.
     Corresponds to ContainedDataObjects */
  {get ClientNames cClientNames}
  {get ContainedDataObjects cDataObjects}    
  .
  &UNDEFINE xp-assign
  
  /* get context for this if sbo or upper container  */
  IF pcParent = '' OR cObjectType = 'SmartBusinessObject':U THEN
  DO:
    IF pcMode = 'ForServer':U THEN
      cContext = {fn getContextForServer}.
    ELSE 
      cContext = {fn getContextForClient}.

    IF cContext > '' THEN
      ASSIGN
        cObjectName = pcParent
        hObject     = TARGET-PROCEDURE
        lAddContext = TRUE.

  END. /* pcParent = '' or sbo */
  DO iObject = 0 TO NUM-ENTRIES(cTargets):
    IF iObject > 0 THEN
    DO:
      ASSIGN 
        hObject        = WIDGET-HANDLE(ENTRY(iObject,cTargets))
        cObjectName    = ENTRY(iObject,cTargetNames)
        lAddContext    = FALSE
        lObtainContext = FALSE.

      {get ObjectType cObjectType hObject}.  

      IF cObjectType = 'SmartDataObject':U THEN 
      DO:
        IF (cProcessList = '' OR LOOKUP(STRING(hObject),cProcessList) > 0) THEN
        DO:
          IF pcMode = 'ForServer':U THEN
            cContext = REPLACE({fn obtainContextForServer hObject},CHR(3),CHR(4)).
          ELSE 
            cContext = REPLACE({fn obtainContextForClient hObject},CHR(3),CHR(4)).
          IF cContext > '' THEN
          DO:
            lAddContext = TRUE.
            IF cClientNames > '' THEN
              ASSIGN
                iClient     = LOOKUP(STRING(hObject),cDataObjects)
                cObjectName = ENTRY(iClient,cClientNames).
          END.
        END.
      END.
      ELSE IF cObjectType = 'SmartBusinessObject':U THEN 
      DO:
        /* If client names then use master to find sbo's client name 
           The instances in the SBO will have the same name as on the 
           client. The sbo part of the name is passed to obtainContext
           below to be added to the context together with the instance names 
           to match the pathed client names */
        IF cClientNames > '' THEN
        DO:
          {get MasterDataObject hMaster hObject}.
          ASSIGN
            iClient     = LOOKUP(STRING(hMaster),cDataObjects)
            cObjectName = ENTRY(iClient,cClientNames)
            ENTRY(NUM-ENTRIES(cObjectName,':'),cObjectName,':') = ''
            cObjectName    = RIGHT-TRIM(cObjectName,':')
            .
        END.
        /* Skip if this SBO's master is not in the processlist */
        IF cProcessList > '' THEN
        DO:
          {get MasterDataObject hMaster hObject}.
          lObtainContext = LOOKUP(STRING(hMaster),cProcessList) > 0.
        END.
        ELSE 
          lObtainContext = TRUE.
      END.
      ELSE DO:
        cGrandChildren = ''.
        {get ContainerTarget cGrandChildren hObject} NO-ERROR.
        lObtainContext = (cGrandChildren > '').
      END.
      cObjectName = (IF pcParent <> '' THEN pcParent + ':' ELSE '')
                  + cObjectName.

    END. /* iObject > 0 */
    
    /* lAddContext is set to True above when context need to be added to the 
       list when managing this object's context or an SDO's context  */ 
    IF lAddContext THEN
    DO:
      /* Replace the propertyname with the property's entry number in proplist
           (and add new props to proplist) */ 
      DO iLoop = 1 TO NUM-ENTRIES(cContext,CHR(4)) BY 2:
        ASSIGN
          cProp = ENTRY(iLoop,cContext,CHR(4)) 
          iProp = LOOKUP(cProp,pcPropList).
        IF iProp = 0 THEN
           ASSIGN
             pcPropList = pcPropList
                        + (IF pcPropList = '' THEN '' ELSE ',') 
                        + cProp 
             iProp      = NUM-ENTRIES(pcPropList).  
        ENTRY(iLoop,cContext,CHR(4)) = STRING(iProp). 
      END.
      
      pcValueList = pcValueList 
                  + (IF pcValueList = '' THEN '' ELSE CHR(3))
                  + cObjectName + CHR(3) + cContext.
    END. /* if laddcontext */
    
    IF lObtainContext THEN 
    DO:
        IF cProcessList > '' THEN
          {set ProcessList cProcessList hObject}.
        RUN obtainContext IN hObject (pcMode,
                                      cObjectName,
                                      INPUT-OUTPUT pcPropList,
                                      INPUT-OUTPUT pcValueList).
        IF cProcessList > '' THEN
          {set ProcessList '' hObject}.
    END. /* else  (addcontext or  container ) */
  END. /* do iObject = 1 to num-entries(cTargets) */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-okObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE okObject Procedure 
PROCEDURE okObject :
/* -----------------------------------------------------------------------------
      Purpose: Save and close an object (Ok action)    
      Parameters:  <none>
      Notes:  If this is the window container or a virtual container then confirm 
              (save and commit all containertargets) and destroy if no errors.
            - Published from containerTargets or called directly.
            - There is a slight overhead in this construct as destroyObject
              (called from exitObject -> apply 'close') does a publish 
              'confirmExit', which really is unnecessary after this has 
              published 'confirmOk'.
              The reason is that destroyObject may be called directly.
            - We currently have to call exitObject as the appbuilder 
              wait-for protests if we destroy directly. 
              Even apply 'close' to target-procedure does not trigger 
              the wait-for. It seems as this has to be fired from the actual 
              instance. (exitObject shoueld be local in all container instances)
              This may very well be a problem for application wait-for as well.     
----------------------------------------------------------------------------*/
  DEFINE VARIABLE hContainer AS HANDLE     NO-UNDO.
  DEFINE VARIABLE lError     AS LOGICAL    NO-UNDO.

  {get ContainerHandle hContainer}.
  
  /* republish until we reached top window */
  IF VALID-HANDLE(hContainer) AND hContainer:TYPE <> 'WINDOW':U THEN
    PUBLISH 'okObject':U FROM TARGET-PROCEDURE.  
  ELSE DO:  
    /* Save and commit all Container targets  */
    PUBLISH 'confirmOk':U FROM TARGET-PROCEDURE (INPUT-OUTPUT lError).
    IF NOT lError THEN
    DO:
      RUN exitObject /* destroyObject */ IN TARGET-PROCEDURE NO-ERROR.
      IF ERROR-STATUS:ERROR THEN
      DO:
        RUN destroyObject IN TARGET-PROCEDURE.
      END.
    END.
  END.

  RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-passThrough) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE passThrough Procedure 
PROCEDURE passThrough :
/*------------------------------------------------------------------------------
  Purpose:     Acts as an intermediary for dynamic links which need the
               pass-through mechanism, to get an event from an object outside
               a container to one inside it, or vice-versa.
  Parameters:  pcLinkName AS CHARACTER -- the link (event) name to be passed on;
               pcArgument AS CHARACTER -- a single character string argument.
  Notes:       To use this for single pass-through events, define a PassThrough
               link from the Source to the intermediate container, and define
               the actual dynamic link from the container to the Target. 
               Then PUBLISH 'PassThrough' (LinkName, Argument) to send the event.
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER pcLinkName AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER pcArgument AS CHARACTER NO-UNDO.
  
  PUBLISH pcLinkName FROM TARGET-PROCEDURE (pcArgument).
  RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-prepareDataForFetch) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE prepareDataForFetch Procedure 
PROCEDURE prepareDataForFetch :
/*------------------------------------------------------------------------------
  Purpose:   prepare Data objects for fetch    
  Parameters: phTopContainer - Container that originated the request from
                               fetchContainedData or fetchContainedRows
              pcAppservice   - passed on to data objects (see data.p)  
              pcObject       - if PcOptions is 'POSITION' then this 
                               is the data source.
              pcOptions 
                POSITION - Special request to find all SmartDataFields in this
                           cointainer and retrieve position information about 
                           their sources.  
                           
  Notes:        
------------------------------------------------------------------------------*/
DEFINE INPUT        PARAMETER phTopContainer  AS HANDLE     NO-UNDO.
DEFINE INPUT        PARAMETER pcAppService    AS CHARACTER  NO-UNDO.
DEFINE INPUT        PARAMETER pcObject        AS CHARACTER  NO-UNDO.
DEFINE INPUT        PARAMETER pcOptions       AS CHARACTER  NO-UNDO.

DEFINE INPUT-OUTPUT PARAMETER pcHandles       AS CHARACTER  NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER pcPhysicalNames AS CHARACTER  NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER pcQualNames     AS CHARACTER  NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER pcForeignFields AS CHARACTER  NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER pcQueries       AS CHARACTER  NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER pcTables        AS CHARACTER  NO-UNDO.

DEFINE VARIABLE cTargets                AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cInstanceNames          AS CHARACTER  NO-UNDO.
DEFINE VARIABLE iTarget                 AS INTEGER    NO-UNDO.
DEFINE VARIABLE hTarget                 AS HANDLE     NO-UNDO.
DEFINE VARIABLE lQuery                  AS LOGICAL    NO-UNDO.   
DEFINE VARIABLE cContainerType          AS CHARACTER  NO-UNDO.
DEFINE VARIABLE hDataSource             AS HANDLE     NO-UNDO.
DEFINE VARIABLE lPosition               AS LOGICAL    NO-UNDO.
DEFINE VARIABLE cFieldName              AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cKeyField               AS CHARACTER  NO-UNDO.
DEFINE VARIABLE iPrepare                AS INTEGER    NO-UNDO.
DEFINE VARIABLE cInactiveLinks          AS CHARACTER  NO-UNDO.
DEFINE VARIABLE lInit                   AS LOGICAL    NO-UNDO.
DEFINE VARIABLE cObjectType             AS CHARACTER  NO-UNDO.
DEFINE VARIABLE lInitialized            AS LOGICAL    NO-UNDO.
DEFINE VARIABLE hViewerDataSource       AS HANDLE     NO-UNDO.
DEFINE VARIABLE cSDOName                AS CHARACTER  NO-UNDO.

{get ContainerTarget cTargets}.

ASSIGN
  lPosition = LOOKUP('POSITION':U,pcOptions) > 0
  lInit     = LOOKUP('INIT':U,pcOptions) > 0.

/* Skip this container if the DataSource link is inactive 
   and this is a position request, unless init where data link are disabled 
   at start .. */ 
IF lPosition AND NOT lInit THEN
DO:
  /* Only check inactivelinks if this container is initialized, it may not be 
     even if this is not an init request */  
  {get ObjectInitialized lInitialized}.
  IF lInitialized THEN
  DO:
    {get Inactivelinks cInactiveLinks}.
    IF LOOKUP('DataSource':U,cInactiveLinks) > 0 THEN
      RETURN.
  END.
END.

IF pcObject > '':U AND NOT lPosition THEN
DO:
  {get InstanceNames cInstanceNames}.
  hTarget = WIDGET-HANDLE(ENTRY(LOOKUP(pcObject,cInstanceNames),cTargets)).
END.

/* Request for a specific SDO on this container */
IF VALID-HANDLE(hTarget) THEN
DO: 
    RUN prepareDataForFetch IN hTarget
         (phTopContainer,
          pcAppService,  
          ?,
          pcOptions,
          INPUT-OUTPUT pcHandles,
          INPUT-OUTPUT pcPhysicalNames,
          INPUT-OUTPUT pcQualNames,
          INPUT-OUTPUT pcForeignFields,
          INPUT-OUTPUT pcQueries,
          INPUT-OUTPUT pcTables).  
    /* Second pass, visualtargets - pass position option to visual targets
       and prepare position information */ 
    RUN prepareDataForFetch IN hTarget
         (phTopContainer,
          pcAppService,
          ?,
          'VISUALTARGETS':u + IF lInit THEN ',INIT':U ELSE '':U,
          INPUT-OUTPUT pcHandles,
          INPUT-OUTPUT pcPhysicalNames,
          INPUT-OUTPUT pcQualNames,
          INPUT-OUTPUT pcForeignFields,
          INPUT-OUTPUT pcQueries,
          INPUT-OUTPUT pcTables).     
END.
ELSE DO:
  DO iTarget = 1 TO NUM-ENTRIES(cTargets):
    hTarget = WIDGET-HANDLE(ENTRY(iTarget,cTargets)).

    IF NOT lPosition THEN
    DO:
      ASSIGN
        lQuery         = FALSE
        cContainerType = '':U.

      &SCOPED-DEFINE xp-assign
      {get QueryObject lQuery hTarget}
      {get ContainerType cContainerType hTarget}  
      {get ObjectType cObjectType hTarget}
      {get DataSource hDataSource hTarget}
       .
      &UNDEFINE xp-assign

      IF IsRequestTreeRoot(phTopContainer, hTarget)
      OR (NOT lQuery AND cContainerType > '':U 
          /* Skip Viewers with datasources in this container as they will 
             be reached from their datasource. 
             (We want the SDFs AFTER the viewer's datasource since the 
              order is important to find the handle when setting fetchOnOpen
              on server)  */
          AND (cObjectType <> 'SmartDataViewer':U 
               OR hDataSource = ? 
               OR LOOKUP(STRING(hDataSource),cTargets) = 0 ) 
          )   THEN     
        RUN prepareDataForFetch IN hTarget
            (phTopContainer,
             pcAppService,
             ?,
             IF lInit THEN 'INIT':U ELSE '':U,
             INPUT-OUTPUT pcHandles,
             INPUT-OUTPUT pcPhysicalNames,
             INPUT-OUTPUT pcQualNames,
             INPUT-OUTPUT pcForeignFields,
             INPUT-OUTPUT pcQueries,
             INPUT-OUTPUT pcTables).        
    END. /* not position or object > '' () */
    
    IF lPosition THEN
    DO:
      cFieldName  = '':U.
      {get FieldName cFieldName hTarget} NO-ERROR. 

      /* If a SmartDataField then prepare position info for its DataSource */ 
      IF cFieldName > '':U THEN
      DO:
        {get DataSource hDataSource hTarget}.        
        IF VALID-HANDLE(hDataSource) THEN
        DO:
          /* Need field mapping to figure out if local field is in viewer datasource 
          */
          IF NOT {fn getLocalField hTarget} THEN
          DO:
            {get KeyField cKeyField hTarget}.            
            /* */              
            {get DataSource hViewerDataSource}.

            {get ObjectType cObjectType hViewerDataSource}.

            IF cObjectType = 'SmartBusinessObject':U THEN
            DO:
              /* if viewer displays more than one SDO the field is qualified*/ 
              IF NUM-ENTRIES(cFieldName,'.') > 1 THEN
                 cSDOName = ENTRY(1,cFieldName,'.').
              ELSE /* else only one entry here */  
                {get DataSourceNames cSDOName}.
              cSDOName = pcObject + ":":U + cSDOName. 
            END. /* SBO */
            ELSE 
              cSDOName = pcObject.
            
            RUN prepareDataForFetch IN hDataSource
              (phTopContainer,
               pcAppService,
               cSDOName + ",":U + cKeyField + ",":U + cFieldName,
               pcOptions,
               INPUT-OUTPUT pcHandles,
               INPUT-OUTPUT pcPhysicalNames,
               INPUT-OUTPUT pcQualNames,
               INPUT-OUTPUT pcForeignFields,
               INPUT-OUTPUT pcQueries,
               INPUT-OUTPUT pcTables).
          END.
        END.
      END. /* fieldname <> '' (SDF) */
    END.
  END.
  
  /* Second pass  - pass position option to visual targets */  
  IF NOT lPosition THEN 
  DO iTarget = 1 TO NUM-ENTRIES(cTargets):
    hTarget = WIDGET-HANDLE(ENTRY(iTarget,cTargets)).
    IF IsRequestTreeRoot(phTopContainer, hTarget) THEN
      RUN prepareDataForFetch IN hTarget
          (phTopContainer,
           pcAppService,
           ?,
           'VISUALTARGETS':u + IF lInit THEN ',INIT':U ELSE '':U,
           INPUT-OUTPUT pcHandles,
           INPUT-OUTPUT pcPhysicalNames,
           INPUT-OUTPUT pcQualNames,
           INPUT-OUTPUT pcForeignFields,
           INPUT-OUTPUT pcQueries,
           INPUT-OUTPUT pcTables).   
  END.  /* Do iTarget */
END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-processAction) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE processAction Procedure 
PROCEDURE processAction :
/*------------------------------------------------------------------------------
  Purpose:     Override visual to capture paging events.
  Parameters:  input name of action
  Notes:       Passes event on to super if not ctrl-page-* or this container
               is not a page target or window.
             - This is not a container standalone event, but more of a shortkey
               to the actual page source as it relies on a pagesource to figure 
               out number of pages.
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pcAction       AS CHARACTER   NO-UNDO.

DEFINE VARIABLE hPageSource           AS HANDLE      NO-UNDO.
DEFINE VARIABLE iPage                 AS INTEGER     NO-UNDO.
DEFINE VARIABLE hContainer            AS HANDLE      NO-UNDO.
DEFINE VARIABLE iNumTabs              AS INTEGER     NO-UNDO.
DEFINE VARIABLE cTabs                 AS CHARACTER   NO-UNDO. 
 
    if pcAction =  "ctrl-page-down":U 
    or pcAction =  "ctrl-page-up":U then
    do:
      &SCOPED-DEFINE xp-assign
      {get ContainerHandle hContainer}   
      {get PageSource hPageSource}
      {get CurrentPage iPage}.
      &UNDEFINE xp-assign
    
      if valid-handle(hPageSource) then
      do:
        {get FolderLabels cTabs hPageSource}.
        iNumTabs = num-entries(cTabs,"|").
        case pcAction:
          when "ctrl-page-up":U then
          do:
            if iPage > 1 then
              run selectPage in target-procedure(iPage - 1).
           /* dynamics only: PUBLISH "selectPrevTab":U FROM target-procedure.*/
          end.
          when "ctrl-page-down":U then
          do:
            if iPage  < iNumTabs then
              run selectPage in target-procedure(iPage + 1).
           /* dynamics only: PUBLISH "selectNextTab":U FROM target-procedure.*/
          end.
        end case.
      end.
    
      /* super simply calls containersource - no point if this is a window */
      if not valid-handle(hPageSource) and hContainer:type <> "Window":U then
        run super(pcAction).
    end.
    else
      run super(pcAction).
    
    return. 
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-removePageNTarget) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE removePageNTarget Procedure 
PROCEDURE removePageNTarget :
/*------------------------------------------------------------------------------
  Purpose:     Removes an object from the list of Targets on a page.
  Parameters:  phTarget AS HANDLE -- handle of the object being removed;
               piPage   AS INTEGER -- page number the object is on.
  Notes:       Run from removeAllLinks for objects not on Page 0.
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER phTarget AS HANDLE  NO-UNDO.
  DEFINE INPUT PARAMETER piPage   AS INTEGER NO-UNDO.
  
  /* The format of the PageNTargets list is <handle>|<page>[,...] */
  RUN modifyListProperty IN TARGET-PROCEDURE (TARGET-PROCEDURE, 'REMOVE':U, "PageNTarget":U,
    STRING(phTarget) + "|":U + STRING(piPage)).
  RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-resizeWindow) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE resizeWindow Procedure 
PROCEDURE resizeWindow :
/*------------------------------------------------------------------------------
  Purpose:    Respond to a resize event from user event or container targets.
  Parameters:  <none>
  Notes:      The current functionality just resizes the frame according to the
              window size. This was added to make the call from the toolbar's 
              resizeObject after it expands a window have some default 
              functionality also outside ICF, but this is mostly a placeholder 
              for logic to resize all contained objects, currently implemented 
              in ICF ry/uib/rydyncontw.w.
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hContainerHandle AS HANDLE NO-UNDO.
  DEFINE VARIABLE hContainerSource AS HANDLE NO-UNDO.
  DEFINE VARIABLE hFrame           AS HANDLE NO-UNDO.  
  /*DEFINE VARIABLE lScrollable      AS LOGICAL    NO-UNDO.*/
  
  {get ContainerHandle hContainerHandle}.
  IF VALID-HANDLE(hContainerHandle) AND hContainerHandle:TYPE = 'Window':U THEN
  DO:
    {get WindowFrameHandle hFrame}.
    /* don't resize frame if it is not a child of the window 
      (protects customers that used the &frame-name for separate frames)  */  
    IF VALID-HANDLE(hFrame) and hFrame:parent = hContainerhandle THEN
    DO:
      /* We set scrollable false since we do not want scrollbars if all 
         contents of the frame fits in the window.  
         We log the actual value for reassign after resize */ 
      /*assign 
        lScrollable = hFrame:scrollable
        hFrame:scrollable = false.*/
      /* Intentionally separate statements with no-error to always shrink if 
         possible. We could have used max(frame,window) to ensure that the 
         frames only were increased, but we want to shrink unless some widget 
         inside the frame prevents it.  */
      hFrame:WIDTH  = hContainerHandle:WIDTH NO-ERROR.
      hFrame:HEIGHT = hContainerHandle:HEIGHT NO-ERROR.
      /* if the frame was scrollable set it back */
      /*if lScrollable then
      do:
        hFrame:scrollable = true.    
        /* if the size did not fit force scrollbars 
           We turned scrollable off to remove the undesired side effect of 
           scrollbars for a frame that fits in the window, but we want this  
           default behavior if the frame is not fitting  */
        if hFrame:virtual-width > hFrame:width then 
          assign 
            hFrame:width-p = hFrame:width-p + 1 
            hFrame:width-p = hFrame:width-p - 1. 
        else
        if hFrame:virtual-height > hFrame:height then
          assign
           hFrame:height-p = hFrame:height-p + 1 
           hFrame:height-p = hFrame:height-p - 1.           
      end.*/
    END.
  END.
  ELSE DO: /* No window here so pass up to the next contanier*/
    {get ContainerSource hContainerSource}.
    RUN resizeWindow IN hContainerSource NO-ERROR.  
  END.
  RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-saveWindowDimensions) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE saveWindowDimensions Procedure 
PROCEDURE saveWindowDimensions :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE hContainerSource    AS HANDLE       NO-UNDO.
DEFINE VARIABLE cObjectname         AS CHARACTER    NO-UNDO.
DEFINE VARIABLE lSaveWindowPos      AS LOGICAL      NO-UNDO.
DEFINE VARIABLE cProfileData        AS CHARACTER    NO-UNDO.
DEFINE VARIABLE rProfileRid         AS ROWID        NO-UNDO.
DEFINE VARIABLE hContainer          AS HANDLE       NO-UNDO.
DEFINE VARIABLE hParent             AS HANDLE       NO-UNDO.
 
 
 ASSIGN lSaveWindowPos = NO.

 {get ContainerHandle hContainer}.

 
 IF VALID-HANDLE(hContainer) AND CAN-QUERY(hContainer, "window-state":U) AND 
    (hContainer:WINDOW-STATE EQ WINDOW-NORMAL OR hContainer:WINDOW-STATE EQ WINDOW-MAXIMIZED) THEN
     /* THis property is set by the container window super procedure rydyncontp.p in updateWindowSizes */
     ASSIGN lSaveWindowPos = LOGICAL(DYNAMIC-FUNCTION("getUserProperty":U IN TARGET-PROCEDURE, INPUT "SaveWindowPos":U))
            NO-ERROR.

 /* Only position and size if asked to */
 IF lSaveWindowPos and VALID-HANDLE(gshProfileManager) THEN
 DO:
   {get LogicalObjectName cObjectName}. 
   IF hContainer:WINDOW-STATE EQ WINDOW-MAXIMIZED THEN
   do:
        
      RUN getProfileData IN gshProfileManager ( INPUT        "Window":U,              /* Profile type code                            */
                                                INPUT        "SizePos":U,             /* Profile code                                 */
                                                INPUT        cObjectName,             /* Profile data key                             */
                                                INPUT        "NO":U,                  /* Get next record flag                         */
                                                INPUT-OUTPUT rProfileRid,             /* Rowid of profile data                        */
                                                      OUTPUT cProfileData       ).    /* Found profile data. Positions as follows:    */
      if num-entries(cProfileData,CHR(3)) = 4 then
         ASSIGN cProfileData = cProfileData + CHR(3) + "WINDOW-MAXIMIZED":U.
      ELSE if num-entries(cProfileData,CHR(3)) = 5 then
         ENTRY(5,cProfileData,CHR(3)) = "WINDOW-MAXIMIZED":U.
      ELSE
         cProfileData = "WINDOW-MAXIMIZED":U.
   end.
   else  
      /* Always store decimal values as if they were in American numeric format.
       * When retrieving decimal values, we need to convert to the current
       * SESSION:NUMERIC-DECIMAL-POINT.                                         */
     ASSIGN cProfileData = REPLACE(STRING(hContainer:COLUMN),       SESSION:NUMERIC-DECIMAL-POINT, ".":U) + CHR(3)
                         + REPLACE(STRING(hContainer:ROW),          SESSION:NUMERIC-DECIMAL-POINT, ".":U) + CHR(3)
                         + REPLACE(STRING(hContainer:WIDTH-CHARS),  SESSION:NUMERIC-DECIMAL-POINT, ".":U) + CHR(3)
                         + REPLACE(STRING(hContainer:HEIGHT-CHARS), SESSION:NUMERIC-DECIMAL-POINT, ".":U).
        
   IF LENGTH(cObjectName) > 0 THEN
   DO:
     /* We have to check if this handle is valid since it might 
        have been killed if a developer was running something
        and closed the AppBuilder and it then attempts to close
        down any running containers. */
       RUN setProfileData IN gshProfileManager (INPUT "Window":U,          /* Profile type code */
                                                INPUT "SizePos":U,         /* Profile code */
                                                INPUT cObjectName,         /* Profile data key */
                                                INPUT ?,                   /* Rowid of profile data */
                                                INPUT cProfileData,        /* Profile data value */
                                                INPUT NO,                  /* Delete flag */
                                                INPUT "PER":u).            /* Save flag (permanent) */
   END.     /* have an object name */
 END.   /* save window positions/size */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-selectPage) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE selectPage Procedure 
PROCEDURE selectPage :
/*------------------------------------------------------------------------------
  Purpose:  Changes the currently selected page. If the previous current page
            is not page 0 (the background page which is always visible), then 
            hideObject is run in all the objects on the CurrentPage. Then
            the CurrentPage is changed to the new page number of piPageNum, and
            the changePage procedure is run to view, and if necessary, create
            the objects on the new page.
   Params:  INPUT piPageNum AS INTEGER
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER piPageNum AS INTEGER NO-UNDO.
  
  DEFINE VARIABLE iCurrentPage    AS INTEGER   NO-UNDO.
  DEFINE VARIABLE cPageList       AS CHARACTER NO-UNDO.
  DEFINE VARIABLE iStartPage      AS INTEGER   NO-UNDO.
  define variable iPendingPage    as integer   no-undo.
  
  &SCOPED-DEFINE xp-assign
  {get PendingPage iPendingPage}
  {get StartPage iStartPage}
  {get CurrentPage iCurrentPage}.
  &UNDEFINE xp-assign
  
  /* If this property has its initial value of unknown, then we are
     in the middle of createObjects and want to postpone this selectPage
     until that is done. */
  IF iStartPage = ? THEN
  DO:
    {set StartPage piPageNum}.
    RETURN.
  END.   /* END DO IF iStartPage = ? */
  
  IF iCurrentPage EQ piPageNum THEN 
  /* Don't reselect the same page unless the object(s) on that page
     have since been destroyed (a SmartWindow that was closed, e.g.). */
  DO:                   
      cPageList = pageNTargets(TARGET-PROCEDURE, iCurrentPage).
      IF cPageList NE "":U THEN 
        RETURN.
  END.
  
  IF iCurrentPage = 0 then
  do:
     /* PendingPage may have been set by initPages when currentpage is 0,
        but 0 is no longer pending if selectPage is called  */
     if iPendingPage <> ? then
        {set PendingPage piPageNum}.
  end.
  else 
  do:
    /* Objects use this to avoid disabling links during hideObject - linkState 
       if they are about to become active/visible */
    {set PendingPage piPageNum}.
    RUN notifyPage IN TARGET-PROCEDURE ("hideObject":U).
    if iPendingPage = ? then
      {set PendingPage ?}.
  end.
  
  /* Save old page for TTY change-page */
  giPrevPage = iCurrentPage. 
  {set CurrentPage piPageNum}.
  RUN changePage IN TARGET-PROCEDURE.

  RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setContextAndInitialize) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setContextAndInitialize Procedure 
PROCEDURE setContextAndInitialize :
/*------------------------------------------------------------------------------
  Purpose:  Reset context and initialize this server side object   
  Parameters:  pcContext 
               Properties in the format returned from 
               containedProperties to be passed to assignContainedProperties 
  Notes:    Called from a stateless client before a request.
            The format used in this subject to change.  
            The container does not currently have an OpenOnInit property 
            so the caller would need to set openOnInit in all dataobjects
         -  The sbo overrides in order to do this.          
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pcContext AS CHARACTER  NO-UNDO.
 
  RUN createObjects IN TARGET-PROCEDURE.
 
  DYNAMIC-FUNCTION('assignContainedProperties':U IN TARGET-PROCEDURE,
                    pcContext,
                    '':U). 

  RUN initializeObject IN TARGET-PROCEDURE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-toolbar) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE toolbar Procedure 
PROCEDURE toolbar :
/*------------------------------------------------------------------------------
  Purpose:     Generic event handler for toolbar events
  Parameters:  pcValue (Character) - the name of the toolbar action
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pcValue AS CHARACTER.

DEFINE VARIABLE cResult            AS CHARACTER   NO-UNDO.
DEFINE VARIABLE chApplication      AS COM-HANDLE  NO-UNDO.
DEFINE VARIABLE chDocument         AS COM-HANDLE  NO-UNDO.
DEFINE VARIABLE chWorkSheet        AS COM-HANDLE  NO-UNDO.

DEFINE VARIABLE hRunContainer       AS HANDLE     NO-UNDO.
DEFINE VARIABLE cRunContainerType   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE hContainingWindow   AS HANDLE     NO-UNDO.     

CASE pcValue:
    WHEN "EnableData" THEN 
    DO:
        /* cause data links to be activated */ 
        PUBLISH "ToggleData" FROM TARGET-PROCEDURE (INPUT TRUE).
    END.
    WHEN "DisableData" THEN 
    DO:
        /* cause data links to be de-activated */
        PUBLISH "ToggleData" FROM TARGET-PROCEDURE (INPUT FALSE).        
    END.
    WHEN "notepad" THEN
    DO:
      IF VALID-HANDLE(gshSessionManager) THEN
        RUN launchExternalProcess IN gshSessionManager
            ( INPUT  "notepad":U,
              INPUT  "":U,
              INPUT  1,
              OUTPUT cResult ).
    END.
    WHEN "wordpad" THEN
    DO:
      IF VALID-HANDLE(gshSessionManager) THEN
        RUN launchExternalProcess IN gshSessionManager
            ( INPUT  "write",
              INPUT  "":U,
              INPUT  1,
              OUTPUT cResult ).
    END.
    WHEN "calculator" THEN
    DO:
      IF VALID-HANDLE(gshSessionManager) THEN
        RUN launchExternalProcess IN gshSessionManager
            ( INPUT  "calc":U,
              INPUT  "":U,
              INPUT  1,
              OUTPUT cResult ).
    END.
    WHEN "internet" THEN
    DO:
      IF VALID-HANDLE(gshSessionManager) THEN
        RUN launchExternalProcess IN gshSessionManager
            ( INPUT  "C:\Program Files\Internet Explorer\iexplore.exe":U,
              INPUT  "":U,
              INPUT  1,
              OUTPUT cResult).
    END.
    WHEN "email" THEN
    DO:
      IF VALID-HANDLE(gshSessionManager) THEN
        RUN sendEmail IN gshSessionManager
                          ( INPUT "":U,                 /* Email profile to use  */
                            INPUT "":U,                 /* Comma list of Email addresses for to: box */
                            INPUT "":U,                 /* Comma list of Email addresses to cc */
                            INPUT "":U,                 /* Subject of message */
                            INPUT "":U,                 /* Message text */
                            INPUT "":U,                 /* Comma list of attachment filenames */
                            INPUT "":U,                 /* Comma list of attachment filenames with full path */
/* MJS 4/11/2002            INPUT (IF NOT (SESSION:REMOTE OR SESSION:PARAM = "REMOTE":U ) THEN YES ELSE NO), */
                            INPUT NOT (SESSION:REMOTE OR SESSION:CLIENT-TYPE = "WEBSPEED":U),   
                                                        /* YES = display dialog for modification before send */
                            INPUT 0,                    /* Importance 0 = low, 1 = medium, 2 = high */
                            INPUT NO,                   /* YES = return a read receipt */
                            INPUT NO,                   /* YES = return a delivery receipt */
                            INPUT "":U,                 /* Not used yet but could be used for additional settings */
                            OUTPUT cResult              /* If failed - the reason why, blank = it worked */
                          ).
    END.
    WHEN "word" THEN
    DO:
      SESSION:SET-WAIT-STATE("GENERAL").
      CREATE "Word.Application" chApplication.            /* create new Word Application object   */
      chDocument = chApplication:Documents:Add().         /* create a new Document                */
      SESSION:SET-WAIT-STATE("").
      chApplication:Visible = True.                       /* Make the application visible         */
      RELEASE OBJECT chDocument.
      RELEASE OBJECT chApplication.
    END.
    WHEN "excel" THEN
    DO:
      SESSION:SET-WAIT-STATE("GENERAL").
      CREATE "Excel.Application" chApplication. 
      chDocument = chApplication:Workbooks:Add().
      chWorkSheet = chApplication:Sheets:Item(1).
      chWorkSheet:Name = "Astra".
      SESSION:SET-WAIT-STATE("").
      chApplication:Visible = True.
      RELEASE OBJECT chDocument.
      RELEASE OBJECT chWorkSheet.
      RELEASE OBJECT chApplication.
    END.
    WHEN "PrintSetup" THEN
    DO:
      SYSTEM-DIALOG PRINTER-SETUP.
    END.
    WHEN "Suspend" THEN
    DO:
      RUN af/cod2/aftemsuspd.w.
    END.
    WHEN "re-logon" THEN
    DO:
      IF VALID-HANDLE(gshSessionManager) THEN
        RUN relogon IN gshSessionManager.
    END.
    WHEN "preferences" THEN
    DO:
      IF VALID-HANDLE(gshSessionManager) THEN
        RUN launchContainer IN gshSessionManager (INPUT "rydynprefw":U,
                                                  INPUT "":U,
                                                  INPUT "":U,
                                                  INPUT YES,
                                                  INPUT "":U,
                                                  INPUT "":U,
                                                  INPUT "":U,
                                                  INPUT "":U,
                                                  INPUT ?,
                                                  INPUT TARGET-PROCEDURE,
                                                  INPUT ?,
                                                  OUTPUT hRunContainer,
                                                  OUTPUT cRunContainerType).
    END.
    WHEN "translate" THEN
    DO:
      /* We only allow translations of the entire container window, which will
           automatically include any viewers, browses, toolbars and other objects
           contained by it. 
           If we allow translations for other container types, such as FRAME (which
           if what a viewer is), translation does not work properly, particulary 
           since the translation relies on translating an entire container.
        */
      
        /* Check if all pages should be initialized for translation and if so,
           ensure they all are initialized */        
        {fn initPagesForTranslation}. 

        hContainingWindow = {fn getContainingWindow} NO-ERROR.
        IF hContainingWindow = ? THEN
          hContainingWindow = TARGET-PROCEDURE.  
        IF hContainingWindow <> TARGET-PROCEDURE THEN
          {fn initPagesForTranslation hContainingWindow}. 

        RUN launchContainer IN gshSessionManager ( INPUT "rydyntranw":U,
                                                   INPUT "":U,
                                                   INPUT "":U,
                                                   INPUT YES,       /* Run Once Only */
                                                   INPUT "":U,
                                                   INPUT "":U,
                                                   INPUT "":U,
                                                   INPUT "":U,
                                                   INPUT ?,
                                                   INPUT hContainingWindow,
                                                   INPUT ?,
                                                   OUTPUT hRunContainer,
                                                   OUTPUT cRunContainerType).
    END.
    WHEN "help" THEN
    DO:
      /* Check whether the focus widget is on the current page. If
         yes, then one can apply the help of the frame. If no, we
         must apply the help of the window object */
      IF VALID-HANDLE(FOCUS) AND CAN-QUERY(FOCUS,"frame":U) THEN
      DO:
        DEFINE VARIABLE hFrame       AS HANDLE NO-UNDO.
        DEFINE VARIABLE cObjects     AS CHARACTER  NO-UNDO.
        DEFINE VARIABLE i            AS INTEGER    NO-UNDO.
        DEFINE VARIABLE hObject      AS HANDLE     NO-UNDO.
        DEFINE VARIABLE hObjectFrame AS HANDLE     NO-UNDO.
        DEFINE VARIABLE lSame        AS LOGICAL    NO-UNDO.
        DEFINE VARIABLE iCurrentPage AS INTEGER    NO-UNDO.

        {get CurrentPage iCurrentPage}.
        ASSIGN hFrame = FOCUS:FRAME.
        IF hFrame:TYPE = "FRAME":U THEN
        DO:
           cObjects = PageNTargets(TARGET-PROCEDURE,iCurrentPage).
           DO i = 1 TO NUM-ENTRIES(cObjects):
               hObject = WIDGET-HANDLE(ENTRY(i,cObjects)) NO-ERROR.
               {get ContainerHandle hObjectFrame hObject} NO-ERROR.
               IF hFrame = hObjectFrame THEN
               DO:
                  lSame = YES.
                  LEAVE.
               END.
           END.
        END.
        IF lSame THEN
           APPLY "HELP" TO hFrame.
        ELSE
          RUN contextHelp IN gshSessionManager (INPUT TARGET-PROCEDURE, INPUT ?).      
      END.  /* End Valid Focus */
      ELSE DO:
        IF VALID-HANDLE(gshSessionManager) THEN
          RUN contextHelp IN gshSessionManager (INPUT TARGET-PROCEDURE, INPUT ?).      
      END.
    END.

    WHEN "helpabout" THEN
    DO:
      IF VALID-HANDLE(gshSessionManager) THEN
        RUN helpabout IN gshSessionManager (INPUT TARGET-PROCEDURE).
    END.
    WHEN "helptopics" THEN
    DO:
      IF VALID-HANDLE(gshSessionManager) THEN
        RUN helptopics IN gshSessionManager (INPUT TARGET-PROCEDURE).
    END.
    WHEN "helpcontents" THEN
    DO:
      IF VALID-HANDLE(gshSessionManager) THEN
        RUN helpcontents IN gshSessionManager (INPUT TARGET-PROCEDURE).
    END.
    WHEN "helphelp" THEN
    DO:
      IF VALID-HANDLE(gshSessionManager) THEN
        RUN helphelp IN gshSessionManager (INPUT TARGET-PROCEDURE).
    END.
    WHEN "spell" THEN
    DO:
    END.
    WHEN "audit" THEN
    DO:
    END.
    WHEN "comments" THEN
    DO:
    END.
    WHEN "history" THEN
    DO:
    END.
    WHEN "status" THEN
    DO:
    END.
END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-updateActive) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE updateActive Procedure 
PROCEDURE updateActive :
/*------------------------------------------------------------------------------
  Purpose:     Published from containertargets when they change state.
               (setDataModified, setNewRecord and setRowObjectState) 
  Parameters:  plActive 
                  TRUE or FALSE 
      Notes:  This is part of the logic to make the UpdateActive property reflect 
              the containers state.     
              These are the steps:
              - 1. Updating objects publishes updateActive (true or false) to 
                   their container targets. 
              - 2. If the value is FALSE the container turns around and publishes
                   this to ALL ContainerTargets before it is stored in 
                   UpdateActive.
              This way the value is only stored as false if ALL contained 
              objects are inactive. 
            - All participating events including okObject and okCancel is bound
              within a window container.  
------------------------------------------------------------------------------*/
 DEFINE INPUT PARAMETER plActive AS LOGICAL    NO-UNDO.
 DEFINE VARIABLE hContainer AS HANDLE     NO-UNDO. 

 IF NOT plActive THEN 
   PUBLISH 'isUpdateActive':U FROM TARGET-PROCEDURE (INPUT-OUTPUT plActive).

 &SCOPED-DEFINE xp-assign
 {set UpdateActive plActive}
 {get ContainerHandle hContainer}.
 &UNDEFINE xp-assign
 /* Tell containerSource unless we already are at the window level */ 
 IF VALID-HANDLE(hContainer) AND hContainer:TYPE <> 'window':U THEN
     PUBLISH 'UpdateActive':U FROM TARGET-PROCEDURE (plActive).
 
 /* Tell the toolbar source, which has the ok, cancel and exit actions */
 PUBLISH 'resetContainerToolbar':U FROM TARGET-PROCEDURE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-viewObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE viewObject Procedure 
PROCEDURE viewObject :
/*------------------------------------------------------------------------------
  Purpose:     (Visual) Container-specific code for viewObject. If the
                HideOnInit property has been set during initialization,
                to allow this object and its contents to be initialized
                without being viewed, turn that off here and explicitly
                view all contents.
  Parameters:  <none>
------------------------------------------------------------------------------*/  
  DEFINE VARIABLE lHide         AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE hContainer    AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cUIBMode      AS CHAR       NO-UNDO.
  DEFINE VARIABLE cType         AS CHAR       NO-UNDO.
  DEFINE VARIABLE hFrame        AS HANDLE     NO-UNDO.
  DEFINE VARIABLE lRemoveMenu   AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE iStack        AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cPageTargets  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cPage0Targets AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iTarget       AS INTEGER    NO-UNDO.
  DEFINE VARIABLE hTarget       AS HANDLE     NO-UNDO.

  &SCOPED-DEFINE xp-assign
  {get ContainerHandle hContainer}
  {get ContainerType cType}
  {get RemoveMenuOnhide lRemoveMenu}.
  {get WindowFrameHandle hFrame}.   
  &UNDEFINE xp-assign
  
  IF cType NE "VIRTUAL":U THEN   /* Non-visual container; nothing to view. */
  DO:
    &SCOPED-DEFINE xp-assign
    {get UIBMode cUIBMode}
    {get HideOnInit lHide}.
    &UNDEFINE xp-assign
    IF lHide THEN 
    DO:           
      IF cUIBMode = "":U THEN 
      DO:
        {set HideOnInit no}.
        DYNAMIC-FUNCTION('assignLinkProperty':U IN TARGET-PROCEDURE,
         INPUT 'Container-Target':U,
         INPUT 'HideOnInit':U,
         INPUT 'no':U ).
      END.   /* END DO IF UIBMODE = "" */
      
      /* Ensure that child object is parented to this window */
      IF valid-handle(hContainer) then 
      do:
        if hContainer:TYPE = "WINDOW":U THEN
          current-window = hContainer.
        else if valid-handle(hContainer:window) then 
          current-window = hContainer:window.              
      end.  
        
      /* if the object has paged targets avoid viewing hidden pages */ 
      {get PageNTarget cPageTargets}.
      IF cPageTargets > '' THEN
      DO:
        cPage0Targets = DYNAMIC-FUNCTION('pageNTargets':U IN TARGET-PROCEDURE,
                                         TARGET-PROCEDURE,
                                         0).
        DO iTarget = 1 TO NUM-ENTRIES(cPage0Targets):
          hTarget = WIDGET-HANDLE(ENTRY(iTarget,cPage0Targets)).
          RUN viewObject IN hTarget.
        END.
        /* notify object's on current page */
        RUN notifyPage IN TARGET-PROCEDURE('viewObject':U).
      END.
      ELSE
        PUBLISH 'viewObject':U FROM TARGET-PROCEDURE.
    END.     /* END IF lHide */ 
  END.       /* END OF NOT virtual container */
  
  IF lRemoveMenu THEN
    PUBLISH 'rebuildMenu':U FROM  TARGET-PROCEDURE.
  
  RUN SUPER.
  
  /* dynamics container is started from stored maximized mode postpones resizeWindow until 
     the window is visible (the check of width <> max-width ensures we do not do this if 
     someone just hides and views a maximized window) 
     We do it before we view the frame to avod the children to flash by in small size  */
  
  IF VALID-HANDLE(hContainer) 
  AND hContainer:TYPE = "WINDOW":U  
  AND hContainer:WINDOW-STATE = WINDOW-MAXIMIZE  
  and (hContainer:width <> hContainer:max-width 
       or 
       hContainer:height <> hContainer:max-height)
  and {fn getUseRepository} then
     run resizeWindow in target-procedure no-error.     
  
  /* If this need to be before super, then just move it. The current order
    is arbitrary  */
  IF VALID-HANDLE(hFrame) THEN
  DO:
    hFrame:HIDDEN = NO.
  END.
  
  
  
  IF VALID-HANDLE(hContainer) AND hContainer:TYPE = "WINDOW":U THEN
  DO:
     
     
    APPLY "ENTRY" TO hContainer.
    &IF "{&WINDOW-SYSTEM}":U <> "TTY":U &THEN
    hContainer:MOVE-TO-TOP().
    &ENDIF
    
    IF hContainer:WINDOW-STATE = WINDOW-MINIMIZED THEN 
    DO: 
      /* if the window is minimized at initialization we assume that 
         it should stay minimized (bug fix). We cannot check  
         ObjectInitialized=false as it is set to true (too?) early, so 
         we use last resort and check for the caller */
      iStack = 2.
      /* loop through overrides  */
      DO WHILE ENTRY(1,PROGRAM-NAME(iStack),' ':U) = 'viewObject':U:
        iStack = iStack + 1.
      END.
      /* Exact signature match (other objects could call viewObject from
         initializeObject in which case we want normal state) */ 
      IF PROGRAM-NAME(iStack) <> 'initializeObject adm2/containr.p':U THEN
        hContainer:WINDOW-STATE = WINDOW-NORMAL.
    END.
  END.
  
  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-viewPage) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE viewPage Procedure 
PROCEDURE viewPage :
/*------------------------------------------------------------------------------
  Purpose:  Views a new page without hiding the current page. This is
            intended to be run from application code which wants to view
            a new page which is a separate SmartWindow. viewPage will run
            changePage to view (and if necessary create) the new SmartWindow,
            but will not hide the objects on the current page, since they
            are in a separate window which can be viewed at the same time.
           
   Params:  INPUT piPageNum AS INTEGER
    Notes:  because the previous page is not hidden, the CurrentPage property
            is reset only temporarily so that changePage knows the new
            page number; then it is reset to its previous value.
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER piPageNum AS INTEGER NO-UNDO.
  
  DEFINE VARIABLE iCurrentPage    AS INTEGER   NO-UNDO.
  DEFINE VARIABLE cPageList       AS CHARACTER NO-UNDO.
  DEFINE VARIABLE iPrevPage       AS INTEGER   NO-UNDO.
   
  {get CurrentPage iCurrentPage}. 
  IF iCurrentPage EQ piPageNum THEN 
  /* Don't reselect the same page unless the object(s) on that page
     have since been destroyed (a SmartWindow that was closed, e.g.). */
  DO:                   
      cPageList = pageNTargets (TARGET-PROCEDURE, iCurrentPage).
      IF cPageList NE "":U THEN 
        RETURN.
  END.

  iPrevPage = iCurrentPage.
  /* Reset the current page temporarily for changePage */
  {set CurrentPage piPageNum}.
  RUN changePage IN TARGET-PROCEDURE.
  /* Now restore the currently selected page */
  {set CurrentPage iPrevPage}.

  RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-addPageNRequiredPages) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION addPageNRequiredPages Procedure 
FUNCTION addPageNRequiredPages RETURNS LOGICAL
    ( INPUT piPageNumber        AS INTEGER,
      INPUT pcPageLinkedList    AS CHARACTER  ):
/*------------------------------------------------------------------------------
  Purpose:  Adds an entry to the value of the RequiredPages property.
    Notes:  * There is an offset of one because of the fact that we also store the 
               linked pages for page zero. This is in the first position.
------------------------------------------------------------------------------*/
    DEFINE VARIABLE cAllRequiredPages         AS CHARACTER                NO-UNDO.
    
    {get RequiredPages cAllRequiredPages}.
    
    ASSIGN ENTRY(piPageNumber + 1, cAllRequiredPages, "|":U) = pcPageLinkedList NO-ERROR.
    {set RequiredPages cAllRequiredPages}.
    
    RETURN TRUE.
END FUNCTION.    /* addPageNRequiredPages */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-applyContext) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION applyContext Procedure 
FUNCTION applyContext RETURNS LOGICAL
  ( pcMode    AS CHAR,
    pcContext AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose: Apply context returned from server after a server call
Parameters: pcMode 
            - 'FromClient' 
            - 'FromServer' 
            pccontext - Propertylist<chr(3)>object<chr(3)>propnum<chr(4)>propvalue
    Notes: 
       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE iProp             AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cProp             AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cValue            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cTargets          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cTargetNames      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cProperties       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cObjectName       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cObjectType       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iObject           AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cValueList        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cGrandChild       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hObject           AS HANDLE     NO-UNDO.
  DEFINE VARIABLE iTarget           AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iNumEntries       AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iPropNum          AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iLoop             AS INTEGER    NO-UNDO.
  DEFINE VARIABLE lUseClientNames   AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cInstanceNames    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cContainerTargets AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iSDO              AS INTEGER    NO-UNDO.
  DEFINE VARIABLE hSDO              AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cSDO              AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lSBOProps         AS LOGICAL    NO-UNDO.
  &SCOPED-DEFINE addpropertyname ~
   iProp = INT(ENTRY((2 * ~{&Num~}) - 1,cValueList,CHR(4))) WHEN iNumEntries >= ~{&Num~} ~
   cProp = ENTRY(iProp,cProperties) WHEN iNumEntries >= ~{&Num~} ~
   ENTRY((2 * ~{&Num~}) - 1,cValueList,CHR(4)) = cProp WHEN iNumEntries >= ~{&Num~}

  /* InstanceNames and ContainerTarget are synchronized while 
     ClientNames is passed from client and matches containedDataObjects */ 
  {get ClientNames cTargetNames}.
 
  IF cTargetNames = '' THEN
  DO:
    &SCOPED-DEFINE xp-assign
    {get InstanceNames cTargetNames}
    {get ContainerTarget cTargets}
    .
    &UNDEFINE xp-assign
  END.
  ELSE DO:
    lUseClientNames = TRUE.
    {get ContainedDataObjects cTargets}.
  END.
  /* The property list is the first entry while the objects info starts on 
     the 2 entry */  
  cProperties = ENTRY(1,pcContext,CHR(3)).
  IF cProperties <> "" THEN
  DO iObject = 2 TO NUM-ENTRIES(pcContext,CHR(3)) BY 2:        
    ASSIGN
      cObjectName = ENTRY(iObject,pcContext,CHR(3))
      cValueList  = ENTRY(iObject + 1,pcContext,CHR(3))
      cGrandChild = ''
      hObject     = ?
      iTarget     = 0
      lSBOProps   = FALSE.      
    
    /* Blank object is for this procedure */
    IF cObjectName = '':U THEN
    DO iProp = 1 TO NUM-ENTRIES(cValueList,CHR(4)) BY 2:
      ASSIGN
        iPropNum = INT(ENTRY(iProp,cValueList,CHR(4)))
        cProp    = ENTRY(iPropNum,cProperties)
        cValue = ENTRY(iProp + 1,cValueList,CHR(4)).
      CASE cProp:
        WHEN 'AsHasStarted':U THEN
          {set AsHasStarted cValue} NO-ERROR.
        WHEN 'ServerOperatingMode':U THEN
          {set ServerOperatingMode cValue} NO-ERROR.
        WHEN 'HasDynamicProxy':U THEN
          {set HasDynamicProxy cValue}.
        OTHERWISE 
          DYNAMIC-FUNCTION('set':U + cProp IN TARGET-PROCEDURE,cValue) NO-ERROR. 
      END CASE.
    END.
    ELSE DO:
      iTarget = LOOKUP(cObjectName,cTargetNames).      
      IF iTarget = 0 THEN 
      DO:
        /* if using clientNames then this must be an sbo in which case 
           we do not have a direct reference from client name  */  
        IF lUseClientNames THEN
        DO iSDO = 1 TO NUM-ENTRIES(cTargetNames):
          /* find the first sdo that matches this sbo using the clientnames
             and get the sbo handle from it */ 
          IF ENTRY(iSDO,cTargetNames) BEGINS cObjectName + ":" THEN
          DO:
            hSDO = WIDGET-HANDLE(ENTRY(iSDO,cTargets)).
            {get ContainerSource hObject hSDO}.
            lSBOProps = TRUE.
            LEAVE.
          END.
        END.
        /* Else check if this is for an object inside a childcontainer? */
        ELSE DO:
          IF NUM-ENTRIES(cObjectName,':':U) > 1  THEN
            ASSIGN
              cGrandChild = cObjectName 
              cObjectName = ENTRY(1,cObjectName,':':U)
              ENTRY(1,cGrandChild,':':U) = ''
              cGrandChild = SUBSTR(cGrandChild,2)
              iTarget = LOOKUP(cObjectName,cTargetNames).
        END.
      END. /* iTarget = 0 */
               
      IF iTarget > 0 THEN 
         hObject = WIDGET-HANDLE(ENTRY(iTarget,cTargets)). 
 
      IF VALID-HANDLE(hObject) THEN
      DO:
        /* If these are grand [grand ] child properties then pass them to 
           their parent (this object's child) */  
        IF cGrandChild > '' OR lSBOProps THEN
          DYNAMIC-FUNCTION('applyContext':U IN hObject,
                            pcMode,
                            cProperties
                            + CHR(3)
                            + cGrandChild
                            + CHR(3)
                            + cValueList) NO-ERROR.
  
        ELSE DO:
          {get ObjectType cObjectType hObject}.
          IF cObjectType = 'SmartDataObject':U THEN
          DO:
            iNumEntries = NUM-ENTRIES(cValueList,CHR(4)) / 2.
            ASSIGN
              &SCOPED-DEFINE num 1
              {&addpropertyname}
              &SCOPED-DEFINE num 2
              {&addpropertyname} 
              &SCOPED-DEFINE num 3
              {&addpropertyname} 
              &SCOPED-DEFINE num 4
              {&addpropertyname} 
              &SCOPED-DEFINE num 5
              {&addpropertyname} 
              &SCOPED-DEFINE num 6
              {&addpropertyname}
              &SCOPED-DEFINE num 7
              {&addpropertyname}
              &SCOPED-DEFINE num 8
              {&addpropertyname}
              &SCOPED-DEFINE num 9
              {&addpropertyname}
              &SCOPED-DEFINE num 10
              {&addpropertyname}
              &SCOPED-DEFINE num 11
              {&addpropertyname}
              &SCOPED-DEFINE num 12
              {&addpropertyname}
              &SCOPED-DEFINE num 13
              {&addpropertyname}
              &SCOPED-DEFINE num 14
              {&addpropertyname}
              &SCOPED-DEFINE num 15
              {&addpropertyname}
              .
              Assign 
              &SCOPED-DEFINE num 16
              {&addpropertyname}
              &SCOPED-DEFINE num 17
              {&addpropertyname}
              &SCOPED-DEFINE num 18
              {&addpropertyname}
              &SCOPED-DEFINE num 19
              {&addpropertyname}
              &SCOPED-DEFINE num 20
              {&addpropertyname}.
            
            DO iLoop = 21 TO iNumEntries:
              &SCOPED-DEFINE num iLoop
              ASSIGN {&addpropertyname}.
            END.
  
            DYNAMIC-FUNCTION('applyContext':U + pcMode IN hObject,
                              cValueList).
  
          END.
        END. /* else (an object in this container)  */
      END. /* if valid-handle(hObject) */
    END. /* else (cObjectname <> '')*/
  END. /* do iObject = 2 to num-entries(pcPropValues) */

  /* A sub container may receive context even if not appserver aware */
  {set AsHasStarted TRUE} NO-ERROR.

  RETURN TRUE. 

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-applyContextFromClient) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION applyContextFromClient Procedure 
FUNCTION applyContextFromClient RETURNS LOGICAL
  ( pcContext AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose: Apply context from client
    Notes: 
------------------------------------------------------------------------------*/
 
  DYNAMIC-FUNCTION('applyContext':U IN TARGET-PROCEDURE,
                   'FromClient',
                    pcContext).
  RETURN TRUE. 

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-applyContextFromServer) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION applyContextFromServer Procedure 
FUNCTION applyContextFromServer RETURNS LOGICAL
  ( pcContext AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose: Apply context returned from server after a server call
    Notes: 
       Typical usage:    
           cContext = obtainContextForServer()
           run <statelesscall>.p (object,
                                  input-output cContext). 
           applyContextFromServer(cContext)               
------------------------------------------------------------------------------*/
 
  DYNAMIC-FUNCTION('applyContext':U IN TARGET-PROCEDURE,
                   'FromServer',
                    pcContext).

  {set AsHasStarted TRUE}.

  RETURN TRUE. 

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-applyFocus) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION applyFocus Procedure 
FUNCTION applyFocus RETURNS LOGICAL
  ( pcField AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose: Apply entry to first or specified widget.
           Overrides smart.p in order to pass COntainerTargets and their 
           ContainerHandle frame handles to applyFocusToFrame in order to 
           call applyFocus in objects when their frame is encountered in 
           the tab order.
  pcfield - a field name
          - ? first in tab order  
    Notes:  Similar to applyentry but returns result allowing callers to 
            manage this across multiple contained objects.  
            
------------------------------------------------------------------------------*/
    
  DEFINE VARIABLE hContainer       AS HANDLE NO-UNDO. 
  DEFINE VARIABLE hWindow          AS HANDLE NO-UNDO. 
  DEFINE VARIABLE cTargets         AS CHARACTER NO-UNDO. 
  DEFINE VARIABLE iTarget          AS INTEGER NO-UNDO.
  DEFINE VARIABLE hTarget          AS HANDLE NO-UNDO.
  DEFINE VARIABLE cTargetFrames    AS CHARACTER NO-UNDO.
  DEFINE VARIABLE hChildFrame      AS HANDLE NO-UNDO.
  DEFINE VARIABLE hWidget          AS HANDLE NO-UNDO.
  DEFINE VARIABLE lWin             AS LOGICAL NO-UNDO.
  
  {get ContainerHandle hContainer}.
  {get ContainerTarget cTargets}.
   
  if not valid-handle(hContainer) then 
    return false. 
    
   /* Build list of frames for identification in widgetloop */
  DO iTarget = 1 TO NUM-ENTRIES(cTargets):  
    hTarget    = WIDGET-HANDLE(ENTRY(iTarget,cTargets)).      
    {get ContainerHandle hChildFrame hTarget}.
    cTargetFrames = cTargetFrames 
                  + (if iTarget = 1 then "" else ',':U) 
                  + if valid-handle(hChildFrame) 
                    then STRING(hChildFrame)
                    else "". 
  END. /* containerTarget loop */ 
  /* find primary adm frame if window */
  IF hContainer:TYPE = "WINDOW":U THEN
  do: 
    hWindow = hContainer.
    {get WindowFrameHandle hContainer}.  
  end.  
  
  /* could be invalid if this container has no frame */
  if valid-handle(hContainer) then
  do:
    IF DYNAMIC-FUNC("applyFocusToFrame":U IN TARGET-PROCEDURE, 
                     hContainer,pcField,cTargetFrames,cTargets) THEN
      RETURN TRUE.
  end.
  ELSE DO: /* the window with no containerhandle can still have frames from 
              smart objects. In this case we have no tab order between the 
              frames and use the widget order (possibly the same?) */
    hWidget = hWindow:FIRST-CHILD.
    do while valid-handle(hWidget).
      IF DYNAMIC-FUNC("applyFocusToFrame":U IN TARGET-PROCEDURE, 
                       hWidget,pcField,cTargetFrames,cTargets) THEN
         RETURN TRUE.
      hWidget = hWidget:NEXT-SIBLING.
    end.          
  end.
  
  RETURN FALSE.   

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-assignContainedProperties) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION assignContainedProperties Procedure 
FUNCTION assignContainedProperties RETURNS LOGICAL
  (pcPropValues   AS CHAR,
   pcReplace      AS CHAR):
/*------------------------------------------------------------------------------
   Purpose: Set properties in contained objects using the returned value of
            containedProperties().  
Parameters: 
   pcPropValues - char
        - Matches the value that is returned from containedProperties.   
        - A CHR(3)-delimited list where;
          - The first entry is a 'header' that defines which properties the rest 
            of the entries in the list applies to. 
            The header have two possible formats:
            - Comma separated list of properties (when all objects are SDOs).
            - A paired semicolon lists with object type and a comma delimited
              list of properties. 'THIS' is used instead of ObjectType for 
              this container instance.  
              Example: 
              - SmartBusinessObject;Prop1;SmartDataObject;propA,propB,propC                 
            
          - The rest of the CHR(3) entries is a paired list of objectNames and 
            a CHR(4)-delimited list of property values, where each chr(4).
            entry corresponds to the comma separated property list for the 
            object's Object type  
            - A blank objectname indicates this container instance.
            - ObjectNames is qualified with ':' to specify container relationship. 
   pcReplace - char
        - Comma separated pair of properties to replace  
           Example:  
              'QueryWhere,QueryContext' 
               - Specifies that 'QueryWhere' values in the list should 
                 be used to setQueryContext                                
     Notes: Passes properties recursively to an 'unlimited' level of child 
            containers in order to be support the 'deep' option of the 
            containedProperties function.         
         -  If the ClientNames property is defined, the ObjectName entry in the 
            passed list will be identified with this instead of InstanceNames.
            This is used to enable communication with clients with a different 
            container structure.
 Note date: 2002/02/07     
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cPropHeader    AS CHARACTER NO-UNDO.
  DEFINE VARIABLE iProp          AS INTEGER   NO-UNDO.
  DEFINE VARIABLE cProp          AS CHARACTER NO-UNDO.
  DEFINE VARIABLE iReplace       AS INTEGER   NO-UNDO.
  DEFINE VARIABLE iObject        AS INTEGER   NO-UNDO.
  DEFINE VARIABLE hObject        AS HANDLE    NO-UNDO.
  DEFINE VARIABLE cObjectType    AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cObjectName    AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cPropList      AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cValueList     AS CHARACTER NO-UNDO.
  DEFINE VARIABLE lMultiTypes    AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE cValue         AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cPassedProp    AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cUseProp       AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cTargetNames   AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cTargets       AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cGrandChild    AS CHARACTER NO-UNDO.
  DEFINE VARIABLE iTarget        AS INTEGER   NO-UNDO.

  ASSIGN  /* The first entry is the property 'header' that defines which
             properties we get for each objectype */ 
    cPropHeader = ENTRY(1,pcPropValues,CHR(3))
    lMultiTypes = NUM-ENTRIES(cPropHeader,';':U) > 1.
  
  /* Replace propertyname(s) if replace specified */
  IF pcReplace <> '':U and pcReplace <> ? THEN
  DO iProp = 1 TO NUM-ENTRIES(cPropHeader,';':U) BY 2:
    ASSIGN  
     /* Currently no objecttype qualifier support */ 
     /* cObjectType  = ENTRY(iProp,cPropHeader,';':U)  */
      cPropList    = IF NOT lMultiTypes 
                     THEN cPropHeader
                     ELSE ENTRY(iProp + 1,cPropHeader,';':U).
    DO iReplace = 1 TO NUM-ENTRIES(pcReplace) BY 2:
      ASSIGN
        cPassedProp = ENTRY(iReplace,pcReplace)
        cUseProp    = ENTRY(iReplace + 1,pcReplace)      
        cPropList   = REPLACE(cPropList,cPassedProp,cUseProp).
    END.
    IF NOT lMultiTypes THEN
      cPropHeader = cPropList.
    ELSE
      ENTRY(iProp + 1,cPropHeader,';':U) = cPropList.
  END. /* IF pcReplace <> '':U */
  
  /* If one type set proplist once and for all here */
  cPropList = IF NOT lMultiTypes THEN cPropHeader ELSE '':U.
  
  /* ContainerTarget, InstanceNames and the optional ClientNames are 
     synhronized lists  */ 
  &SCOPED-DEFINE xp-assign
  {get ContainerTarget cTargets}
  {get ClientNames cTargetNames}.
  &UNDEFINE xp-assign
  IF cTargetNames = '':U THEN
    {get InstanceNames cTargetNames}.

  /* The objects property pairs starts on the 2 entry */  
  DO iObject = 2 TO NUM-ENTRIES(pcPropValues,CHR(3)) BY 2:        
    ASSIGN
      cObjectName = ENTRY(iObject,pcPropValues,CHR(3))
      cValueList  = ENTRY(iObject + 1,pcPropValues,CHR(3))
      cGrandChild = ''
      hObject     = ?
      iTarget     = 0.
      
    IF cObjectName = '':U THEN
      hObject = TARGET-PROCEDURE.
    ELSE DO:
      /* Are these properties for an object inside a child? */
      iTarget = LOOKUP(cObjectName,cTargetNames).
      
      IF iTarget = 0 and NUM-ENTRIES(cObjectName,':':U) > 1  THEN
        ASSIGN
          cGrandChild = cObjectName 
          cObjectName = ENTRY(1,cObjectName,':':U)
          ENTRY(1,cGrandChild,':':U) = ''
          cGrandChild = SUBSTR(cGrandChild,2)
          iTarget = LOOKUP(cObjectName,cTargetNames).
          
      IF iTarget > 0 THEN 
            hObject = WIDGET-HANDLE(ENTRY(iTarget,cTargets)). 
    END.
    
    IF VALID-HANDLE(hObject) THEN
    DO:
      /* If these are grand [grand ] child properties then pass them to 
         their parent */  
      IF cGrandchild > ''  THEN
        DYNAMIC-FUNCTION('assignContainedProperties':U IN hObject,
                          cPropHeader
                          + CHR(3)
                          + cGrandChild
                          + CHR(3)
                          + cValueList,
                          pcReplace) NO-ERROR.

      ELSE DO:
        /* If propheader has multiple types then find the props that 
           corresponds to this object's objecttype */
        IF lMultiTypes THEN       
          ASSIGN 
            cObjectType = IF cObjectName <> '':U 
                          THEN {fn getObjectType hObject}
                          ELSE "THIS":U
            cPropList   = DYNAMIC-FUNCTION('MappedEntry':U IN TARGET-PROCEDURE,
                                            cObjectType, 
                                            cPropHeader, 
                                            TRUE,  /* return entry *after* */ 
                                            ";":U).  
        /* allow for fewer values.. */ 
        DO iProp = 1 TO NUM-ENTRIES(cValueList,CHR(4)):
          ASSIGN
            cProp      = ENTRY(iProp,cPropList)
            cValue     = ENTRY(iProp,cValueList,CHR(4)).
          DYNAMIC-FUNCTION('set':U + cProp IN hObject,cValue) NO-ERROR.
        END. /* do iProp = 1 to num-entries(cPropHeader) */
      END. /* else (an object in this container)  */
    END. /* if valid-handle(hObject) */
  END. /* do iObject = 2 to num-entries(pcPropValues) */

  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-assignQueries) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION assignQueries Procedure 
FUNCTION assignQueries RETURNS HANDLE
  ( pcQueries AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose: Assign queries to all or some of the contained SDOs and returns the 
           handle of the first SDO that got a new query. 
Parameter: pcQueries 
              - CHR(1)-separated string where SKIP is used to indicate which 
                SDOs to skip.   
              - Blank indicates that the default query should be used.                                      
    Notes: Used to reset the queries from the client     
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cSDOs        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hSDO         AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hFirstSDO    AS HANDLE     NO-UNDO.
  DEFINE VARIABLE iSDO         AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cQueryString AS CHARACTER  NO-UNDO.

  {get ContainedDataObjects cSDOs}.
  DO iSDO = 1 TO NUM-ENTRIES(cSDOs):
    cQueryString = ENTRY(iSDO, pcQueries, CHR(1)).
    IF cQueryString NE "SKIP":U THEN
    DO:
      hSDO = WIDGET-HANDLE(ENTRY(iSDO, cSDOs)).
      IF hFirstSDO = ? THEN
         hFirstSDO = hSDO.
      /* If no data is passed from the client we must use the default query            
         otherwise Foreign Fields will be appended to the current query,
         which may have conflicting Foreign Fields from initialization */  
      IF cQueryString = '':U THEN 
        {get OpenQuery cQueryString hSdo}.
        
      {set QueryWhere cQueryString hSDO}.
    END.    /* END DO IF QueryString ne "SKIP" */
  END. /* END DO iSDO */

  RETURN hFirstSDO. 

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-containedProperties) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION containedProperties Procedure 
FUNCTION containedProperties RETURNS CHARACTER
  (pcQueryProps   AS CHAR,
   plDeep         AS LOG) :
/*------------------------------------------------------------------------------
   Purpose: Returns a CHR(3)-delimited list where the first entry is the 
            passed query parameter. The rest of the entries consists of paired 
            objectNames and CHR(4)-delimited properties.
             
            For 'plDeep' queries the ObjectName will be colon separated to 
            uniquely identify levels in the tree. 
            
            The second in each pair is a chr(4) separated list of values
            where each entry corresponds to the Propertlist for that object.   
            
            <pcQueryProps>
            CHR(3)
            <ObjectName1>CHR(3)<PropAvalue>CHR(4)<PropBvalue>
            CHR(3)      
            <ObjectName2>CHR(3)<PropAvalue>CHR(4)<PropBvalue>
            
Parameters: pcProperties 
              - Comma separated list(s) of properties to retrieve from SDOs.
              - Optionally use paired semicolom lists to query different 
                Object types.   
                Example: 
                 - SmartBusinessObject;Prop1;SmartDataObject where AppService=aaaa;propA,propB,propC
                 
              'THIS' indicates properties for this object instance.   
                
            plDeep   
              - True  - Retrieve properties also from children of children.    
              - False - Only in Container targets.        
                                            
     Notes: The FORMAT of the returned string is INTERNAL and intended to 
            be transported as is (across servers) to be passed into  
            assignContainedProperties.   
         -  The format and delimiters may change completely in the 
            future.     
         -  If the ClientNames property is defined, the ObjectName entry in the 
            retunred list will be replaced with the corresponding entry in 
            the ClientNames list. This is used to enable communcation with 
            clients with a different container structure.
         -  This function collects the properties of ALL contained objects 
            defined in the input parameter 'pcProperties' EXCEPT when the 
            property 'ProcessList' is set in which case ONLY contained
            objects listed in this property are processed.
            
Note date: 2002/02/16            
------------------------------------------------------------------------------*/
  DEFINE VARIABLE iProp            AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cProp            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iObject          AS INTEGER    NO-UNDO.
  DEFINE VARIABLE hObject          AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cObjectType      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cObjectName      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cPropList        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lMultiTypes      AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cValue           AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cValueList       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cGrandChildren   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cGrandChildProps AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iGrandChild      AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cDeepProps       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iThis            AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cTargets         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cTargetNames     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cProcessList     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cChildList       AS CHARACTER   NO-UNDO.
  DEFINE VARIABLE cASDivision      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iCount           AS INTEGER     NO-UNDO.
  DEFINE VARIABLE lDataContainer   AS LOGICAL    NO-UNDO.

  ASSIGN
    lMultiTypes = NUM-ENTRIES(pcQueryProps,';':U) > 1
    cPropList   = IF NOT lMultiTypes THEN pcQueryProps ELSE '':U.
   
  /* If deep then set properties to pass to children */
  IF plDeep THEN 
  DO:
    cDeepProps = pcQueryProps.
    /* If multiTypes check for THIS and remove it as it cannot be passed to 
       children (properties from child containers will need to be retrieved
       with the child containers type) */ 
    IF lMultiTypes THEN
    DO:
      iThis = LOOKUP('THIS':U,cDeepProps,';':U).
      IF iThis > 0 THEN
        ASSIGN
          ENTRY(iThis,cDeepProps,';') = '':U
          ENTRY(iThis + 1,cDeepProps,';') = '':U.
    END.
  END.
  
  /* ContainerTarget, InstanceNames and the optional ClientNames are 
     synhronized lists */ 
  &SCOPED-DEFINE xp-assign
  {get DataContainer lDataContainer}
  {get ContainerTarget cTargets}
  {get ClientNames cTargetNames}.
  &UNDEFINE xp-assign
  IF cTargetNames = '':U THEN
    {get InstanceNames cTargetNames}.
    
  IF lDataContainer THEN
  DO:
    {get ASDivision cASDivision}.
    IF cASDivision <> 'SERVER':U THEN
      {get ProcessList cProcessList}.
  END.  

  /* Start on 0 if multiTypes and use the 0 to handle 'this' instance */  
  OBJECT-LOOP:
  DO iObject = (IF lMultiTypes THEN 0 ELSE 1) TO NUM-ENTRIES(cTargets):
    cChildList = "":U.
    IF iObject > 0 THEN 
    DO:
      cObjectName = ENTRY(iObject,cTargetNames).

      /* construct a new list of desired objects for possible child container */ 
      IF cProcessList > "" THEN
      DO:
          DO iCount = 1 TO NUM-ENTRIES(cProcessList):
            cValue = ENTRY(iCount, cProcessList).
            IF cValue BEGINS cObjectName + ":":U THEN
              cChildList = cChildList + (IF cChildList = "" THEN "" ELSE ",") +
                          REPLACE(cValue, cObjectName + ":":U, "").
          END.
    
          /* If we have a definite list of objects then use only these objects */
          IF NOT LOOKUP(cObjectName, cProcessList) > 0 AND cChildList = "" THEN
              NEXT OBJECT-LOOP.
      END.
      
      hObject = WIDGET-HANDLE(ENTRY(iObject,cTargets)).
      {get ObjectType cObjectType hObject}.
    END.
    ELSE 
      ASSIGN 
        cObjectName = '':U
        hObject     = TARGET-PROCEDURE
        cObjectType = "THIS":U.
    
    IF lMultiTypes THEN       
      cPropList   = DYNAMIC-FUNCTION('MappedEntry':U IN TARGET-PROCEDURE,
                                      cObjectType, 
                                      pcQueryProps, 
                                      TRUE,  /* return entry *after* */ 
                                      ";":U).
    
    IF (lMultiTypes AND cPropList <> ?) 
    OR (NOT lMultiTypes AND cObjectType = 'SmartDataObject':U) THEN
    DO:
      cValueList = cValueList + CHR(3) + cObjectName + CHR(3).
      DO iProp = 1 TO NUM-ENTRIES(cPropList):
        ASSIGN
          cProp      = ENTRY(iProp,cPropList)
          cValue     = DYNAMIC-FUNCTION('get':U + cProp IN hObject) 
         NO-ERROR.
        cValueList = cValueList 
                     + (IF iProp = 1 THEN '':U ELSE CHR(4))
                     +  IF cValue = ? THEN '?':U ELSE cValue.
      END. /* do iProp = 1 to num-entries(cPropList) */
    END. /* If cProplist <> ? */

    /* If Deep then retrieve properties from containers containertargets */
    IF plDeep AND iObject <> 0 THEN
    DO:
      cGrandChildren = '':U.
      {get ContainerTarget cGrandChildren hObject} NO-ERROR.
      IF cGrandChildren <> '':U AND cGrandChildren <> ? THEN 
      DO:
        {set ProcessList cChildList hObject}.
        ASSIGN
          cGrandChildProps = 
            DYNAMIC-FUNCTION('containedProperties':U IN hObject,
                              cDeepProps,
                              plDeep)
          /* remove the Propertylist that is returned at the start */
          ENTRY(1,cGrandChildProps,CHR(3)) = '':U
          cGrandChildProps = SUBSTR(cGrandChildProps,2).
        /* Add returned properties from containers with the container name 
           as qualifier */
        DO iGrandChild = 1 TO NUM-ENTRIES(cGrandChildProps,CHR(3)) BY 2:
          ENTRY(iGrandChild,cGrandChildProps,CHR(3)) = 
                 cObjectName + ':':U 
                 + ENTRY(iGrandChild,cGrandChildProps,CHR(3)).  
        END.
        IF cGrandChildProps <> '':U THEN
          cValueList = cValueList + chr(3) + cGrandChildProps. 
      END.
    END. /* plDeep */
  END. /* do iObject = 1 to num-entries(cTargets) */
  
  /* Return the input Query list as the first entry 
    (the list already starts with chr(3)) */
  RETURN pcQueryProps + cValueList.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-disablePagesInFolder) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION disablePagesInFolder Procedure 
FUNCTION disablePagesInFolder RETURNS LOGICAL
  (pcPageInformation AS CHARACTER):
/*------------------------------------------------------------------------------
  Purpose:  Disables the specified folder pages
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hFolderHandle     AS WIDGET-HANDLE  NO-UNDO.
  DEFINE VARIABLE lHasPendingValues AS LOGICAL        NO-UNDO.
  
  {get PageSource hFolderHandle TARGET-PROCEDURE}.
  
  IF VALID-HANDLE(hFolderHandle) AND
     LOOKUP("disablePages":U, hFolderHandle:INTERNAL-ENTRIES) <> 0 THEN
  DO:
    RUN disablePages IN hFolderHandle(INPUT  pcPageInformation,
                                      OUTPUT lHasPendingValues).
    
    RETURN TRUE.  /* Function return value. */
  END.
  ELSE
    RETURN FALSE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-enablePagesInFolder) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION enablePagesInFolder Procedure 
FUNCTION enablePagesInFolder RETURNS LOGICAL
  (pcPageInformation AS CHARACTER):
/*------------------------------------------------------------------------------
  Purpose:  Enables the specified folder pages
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hFolderHandle     AS WIDGET-HANDLE  NO-UNDO.
  DEFINE VARIABLE lHasPendingValues AS LOGICAL        NO-UNDO.
  
  {get PageSource hFolderHandle TARGET-PROCEDURE}.
  
  IF VALID-HANDLE(hFolderHandle) AND
     LOOKUP("enablePages":U, hFolderHandle:INTERNAL-ENTRIES) <> 0 THEN
  DO:
    RUN enablePages IN hFolderHandle(INPUT  pcPageInformation,
                                     OUTPUT lHasPendingValues).
    
    RETURN TRUE.  /* Function return value. */
  END.
  ELSE
    RETURN FALSE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getCallerObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getCallerObject Procedure 
FUNCTION getCallerObject RETURNS HANDLE
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
DEFINE VARIABLE hCaller AS HANDLE NO-UNDO.
{get CallerObject hCaller}.
RETURN hCaller.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getCallerProcedure) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getCallerProcedure Procedure 
FUNCTION getCallerProcedure RETURNS HANDLE
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
DEFINE VARIABLE hCaller AS HANDLE NO-UNDO.
{get CallerProcedure hCaller}.
RETURN hCaller.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getCallerWindow) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getCallerWindow Procedure 
FUNCTION getCallerWindow RETURNS HANDLE
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
DEFINE VARIABLE hCaller AS HANDLE NO-UNDO.
{get CallerWindow hCaller}.
RETURN hCaller.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getCascadeChildCol) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getCascadeChildCol Procedure 
FUNCTION getCascadeChildCol RETURNS DECIMAL
  (  ) :
/*------------------------------------------------------------------------------
 Purpose: Returns the col increment for cascade 
   Notes: Currently NOT implemented as a default adm/repos property.
         - The actual cascade logic is implemented in cascadeChildPosition.  
 -------------------------------------------------------------------------------*/
  DEFINE VARIABLE dCol AS DECIMAL    NO-UNDO INIT ?.
  
  /*
  &IF DEFINED(xpCascadeChildCol) = 0 &THEN
     &SCOPED-DEFINE xpCascadeChildCol
     {get CascadeChildCol dCol} NO-ERROR.
     &UNDEFINE xpCascadeChildCol
  &ELSE
     {get CascadeChildCol dCol}.
  &ENDIF
  IF dCol = ? THEN
  */

  dCol = 4.0.
  
  RETURN dCol.   

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getCascadeChildren) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getCascadeChildren Procedure 
FUNCTION getCascadeChildren RETURNS CHARACTER
  ( ) :
/*------------------------------------------------------------------------------
  Purpose: Decides whether new child windows should cascade.
           - 'Same' - Cascade if object with conflicting pos is the same as the 
                      new object. (lookup) 
           - 'Any'  - Cascade if any object has conflicting pos  
           - 'None' - no cascade
    Notes: Currently NOT implemented as a default adm/repos property.    
         - The cascade behavior is implemented in cascadeChildPosition.  
         - Defaults to 'Same' in order to ensure that lookup browse window is 
           cascading. (All lookups use the same window)
 -----------------------------------------------------------------------------*/
  DEFINE VARIABLE cCascade AS CHARACTER  NO-UNDO.
   
  /*
  /* Allow attribute to be defined (not implemented in Repository or ADM) */
  &SCOPED-DEFINE xpCascadeChildren
  {get CascadeChildren cCascade} NO-ERROR. 
  &UNDEFINE xpCascadeChildren
  IF cCascade = '' OR cCascade = ? THEN 
  */
  cCascade = 'Same':U.

  RETURN cCascade.   

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getCascadeChildRow) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getCascadeChildRow Procedure 
FUNCTION getCascadeChildRow RETURNS DECIMAL
  (  ) :
/*------------------------------------------------------------------------------
 Purpose: Returns the row increment for cascade 
   Notes: Currently NOT implemented as a default adm/repos property.   
         - The actual cascade logic is implemented in newChildPosition.   
 -------------------------------------------------------------------------------*/
  DEFINE VARIABLE dRow AS DECIMAL    NO-UNDO INIT ?.
  /*
  &IF DEFINED(xpCascadeChildRow) = 0 &THEN
     &SCOPED-DEFINE xpCascadeChildRow
     {get CascadeChildRow dRow} NO-ERROR.
     &UNDEFINE xpCascadeChildRow
  &ELSE
     {get CascadeChildRow dRow}.
  &ENDIF
  IF dRow = ? THEN
  */
    dRow = 1.0.
  
  RETURN dRow.   

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getClientNames) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getClientNames Procedure 
FUNCTION getClientNames RETURNS CHARACTER
  (   ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the list of ClientNames, which is a list that corresponds 
            to InstanceNames, with the proxy's ObjectName on the client.
    Notes:  This is set in a server side container, so that containedProperties 
            and assignContainedProperties can receive and return properties to 
            and from a client with a different container structure.
          - This is required in the dynamic server container, which constructs 
            server side objects for all data objects in the caller container 
            tree, without recreating the child-containers that are not 
            QueryObjects. (SBOs are the only containers constructed on the 
            server)                             
Note date: 2002/02/16                        
-----------------------------------------------------------------------------*/
  DEFINE VARIABLE cNames AS CHARACTER  NO-UNDO.
  {get ClientNames cNames}.
  
  RETURN cNames.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getCommitSource) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getCommitSource Procedure 
FUNCTION getCommitSource RETURNS HANDLE
  (   ) :
/*------------------------------------------------------------------------------
   Purpose: Return the CommitSource. Used for pass-thru for regular 
            containers, but also inherited by the SBO that uses it for 'real'. 
   Params:  <none>
   Note:    xp not defined because the sbo needs logic in set override. 
            (set AutoCommit) 
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hCommitSource AS HANDLE NO-UNDO.
  &SCOPED-DEFINE xpCommitSource  
  {get CommitSource hCommitSource}.
  &UNDEFINE xpCommitSource  
  
  RETURN hCommitSource.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getCommitSourceEvents) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getCommitSourceEvents Procedure 
FUNCTION getCommitSourceEvents RETURNS CHARACTER
  (   ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the list of events to be subscribed to in the
            Commit Panel or other Commit-Source.  
   Params:  <none>
    Notes:  Commit is a pass-thru link, but the sbo uses it for real, this 
            property is here because we currently keep the link and event 
            properties together..          
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cEvents AS CHARACTER NO-UNDO.
  {get CommitSourceEvents cEvents}.
  RETURN cEvents.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getCommitTarget) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getCommitTarget Procedure 
FUNCTION getCommitTarget RETURNS CHARACTER
  (   ) :
/*------------------------------------------------------------------------------
   Purpose: Return the CommitTarget(s). Defined for pass-thru purposes. 
   Params:  <none>
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cCommitTarget AS CHARACTER NO-UNDO.
  {get CommitTarget cCommitTarget}.
  RETURN cCommitTarget.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getCommitTargetEvents) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getCommitTargetEvents Procedure 
FUNCTION getCommitTargetEvents RETURNS CHARACTER
  (   ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the list of events to be subscribed to in the
            Commit Panel or other Commit-Target.  
   Params:  <none>
    Notes:  Commit is a pass-thru link, this property is here because we 
            currently keep the link and event properties together..          
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cEvents AS CHARACTER NO-UNDO.
  {get CommitTargetEvents cEvents}.
  RETURN cEvents.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getContainedAppServices) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getContainedAppServices Procedure 
FUNCTION getContainedAppServices RETURNS CHARACTER
    ( ) :
/*------------------------------------------------------------------------------
  Purpose:  Retunrs the list of the Appservices of the Data Objects contained
            in this container.
    Notes:  The container class uses this to manage dataobjects in 
            the stateless server side APIs. 
------------------------------------------------------------------------------*/
 DEFINE VARIABLE cAppServices AS CHARACTER  NO-UNDO.
 {get ContainedAppServices cAppServices}.
 RETURN cAppServices.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getContainedDataObjects) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getContainedDataObjects Procedure 
FUNCTION getContainedDataObjects RETURNS CHARACTER
  (   ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns a list of the handles of the Data Objects contained
            in this object.
    Params: <none>
    Notes:  The container class uses this to keep track of the dataobjects in 
            the stateless server side APIs. 
            The sbo class uses it on both client and server in almost all logic
            also at design time to get names and column lists from the 
            individual Data Objects.
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cObjects AS CHARACTER NO-UNDO.
  {get ContainedDataObjects cObjects}.
  RETURN cObjects.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getContainerMode) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getContainerMode Procedure 
FUNCTION getContainerMode RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose: Returns the containermode of the window container  
    Notes: The 'primary' viewer is identifed 
           1 - WindowTitleViewer  - set here in a previous call or 
                                    in a viewer with windowTitlefield
           2 - Viewer linked to this container's containertoolbarsource as tableioSource  
               Page 0 will be preferred for page 1. 
           3 - Upper SDO on page 0 or page 1 
               First Viewer that are not a groupAssignTarget linked to this 
               SDO as an UpdateSource. Page 0 will be preferred for page 1. 
        -  Certainly room for improvement, but this is really intended for 
           backwards compatibility with Dynamics v1, which has one object 
           of one type per page and uses container toolbar and primarySDO links
        -  An SDO on page 0 with an UpdateSource on page 2 may cause no object
           to be found.
------------------------------------------------------------------------------*/
    DEFINE VARIABLE cContainerMode     AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE hVisual            AS HANDLE     NO-UNDO.
    DEFINE VARIABLE hTarget            AS HANDLE     NO-UNDO.
    DEFINE VARIABLE iLoop              AS INTEGER    NO-UNDO.
    DEFINE VARIABLE lQuery             AS LOGICAL    NO-UNDO.
    DEFINE VARIABLE cTargets           AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE hDataSource        AS HANDLE     NO-UNDO.
    DEFINE VARIABLE cDataTargets       AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE hContainer         AS HANDLE     NO-UNDO.
    DEFINE VARIABLE hContainerSource   AS HANDLE     NO-UNDO.
    DEFINE VARIABLE hSDO               AS HANDLE     NO-UNDO.
    DEFINE VARIABLE iPage              AS INTEGER    NO-UNDO.
    DEFINE VARIABLE cContainerToolbars AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE hTableioSource     AS HANDLE     NO-UNDO.
    DEFINE VARIABLE hSDOCandidate      AS HANDLE     NO-UNDO.
    DEFINE VARIABLE hVisualCandidate   AS HANDLE     NO-UNDO.
    DEFINE VARIABLE hGroupAssignSource AS HANDLE     NO-UNDO.
    DEFINE VARIABLE cObjectMode        AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cNewRecord         AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE lInitialized        AS LOGICAL    NO-UNDO.
    
    &SCOPED-DEFINE xp-assign
    {get ObjectInitialized lInitialized}
    {get ContainerHandle hContainer}.
    &UNDEFINE xp-assign

    IF NOT lInitialized THEN
    DO:
      &SCOPED-DEFINE xpContainerMode
      {get ContainerMode cContainerMode}.
      &UNDEFINE xpContainerMode
      RETURN cContainerMode.
    END.

    /* Ask containerSource unless we already are a window container */ 
    IF VALID-HANDLE(hContainer) AND hContainer:TYPE <> 'window':U THEN
    DO:
      {get ContainerSource hContainerSource}.
      IF VALID-HANDLE(hContainerSource) THEN
        RETURN {fn getContainerMode hContainerSource}.
      ELSE 
        RETURN ?.
    END.
    {get WindowTitleViewer hVisual}.    
    IF NOT VALID-HANDLE(hVisual) THEN
    DO:
      hSDO = WIDGET-HANDLE(ENTRY(1,DYNAMIC-FUNCTION('linkHandles' IN TARGET-PROCEDURE,'PrimarySdo-Target'))).
      IF NOT VALID-HANDLE(hSDO) THEN
      DO:        
        &SCOPED-DEFINE xp-assign
        {get ContainerToolbarSource cContainerToolbars}
        {get ContainerTarget cTargets}.          
        &UNDEFINE xp-assign
        /* Loop through targets on page 0 and 1 to find the 'topmost' data 
           source. We may encounter viewers, but only attempt to identify them
           as the 'containerviewer' if  linked to the containertoolbar 
           (too difficult otherwise as you can have several viewers on one page) */
        TargetLoop: 
        DO iLoop = 1 TO NUM-ENTRIES(cTargets):
          hTarget = WIDGET-HANDLE(ENTRY(iLoop,cTargets)).
          {get ObjectPage iPage hTarget}.
          IF iPage > 2 THEN
            NEXT.
          
          {get DataSource hDataSource hTarget} NO-ERROR.
           /* If Datasource is one of the container targets we have not 
              found the top (it could actually be the viewer, but we'll 
              save that search for later) */
          {get QueryObject lQuery hTarget}.
          IF lQuery THEN
          DO:
            IF VALID-HANDLE(hDataSource) AND CAN-DO(cTargets,STRING(hDataSource)) THEN
              NEXT.
            IF iPage = 0 THEN
            DO:
              hSDO = hTarget.
              LEAVE.
            END.
            ELSE   
              hSDOCandidate = hTarget.
          END.
          ELSE IF VALID-HANDLE(hDataSOurce) THEN 
          DO:
            {get TableioSource hTableioSource hTarget} NO-ERROR.
            IF LOOKUP(STRING(hTableioSource),cContainerToolbars) > 0 THEN
            DO:
              {get GroupAssignSource hGroupAssignSource hTarget} NO-ERROR.
              IF VALID-HANDLE(hGroupAssignSource) THEN
                NEXT.
              IF iPage = 0 THEN
              DO:
                hVisual = hTarget.
                LEAVE.
              END.
              ELSE   
                hVisualCandidate = hTarget.
            END.
          END.
        END. /* Targetloop*/
      END.

      IF NOT VALID-HANDLE(hVisual) AND NOT VALID-HANDLE(hVisualCandidate)  THEN
      DO:
        IF VALID-HANDLE(hSDOCandidate) AND NOT VALID-HANDLE(hSDO) THEN 
          hSDO = hSDOCandidate.
        IF VALID-HANDLE(hSDO) THEN
        DO:
          /* In defense of using cTargets - an UpdateSOurce is a DataTarget */ 
          {get UpdateSource cTargets hSDO}.
          UpdateSourceLoop: 
          DO iLoop = 1 TO NUM-ENTRIES(cTargets):
            hTarget = WIDGET-HANDLE(ENTRY(iLoop,cTargets)).
            {get ObjectPage iPage hTarget}.
            IF iPage > 2 THEN
              NEXT.
            IF iPage = 0 THEN
            DO:
              hVisual = hTarget.
              LEAVE UpdateSourceloop.
            END.
            ELSE   
              hVisualCandidate = hTarget.
          END.
          /* Ok, let's also search non-updatable */
          IF NOT VALID-HANDLE(hVisualCandidate) AND NOT VALID-HANDLE(hVisual) THEN 
          DO:
            {get DataTarget cTargets hSDO}.
            DataTargetLoop: 
            DO iLoop = 1 TO NUM-ENTRIES(cTargets):
              hTarget = WIDGET-HANDLE(ENTRY(iLoop,cTargets)).
              {get ObjectPage iPage hTarget}.
              IF iPage > 2 THEN
                NEXT.
              {get GroupAssignSource hGroupAssignSource hTarget} NO-ERROR.
              IF VALID-HANDLE(hGroupAssignSource) THEN
                NEXT.
              IF iPage = 0 THEN
              DO:
                hVisual = hTarget.
                LEAVE DataTargetloop.
              END.
              ELSE   
                hVisualCandidate = hTarget.
            END.
          END.
        END. /* valid hSDO */
       
      END. /* not valid hVisual (after search) */
    END. /* not valid hVisual (windowTitleViewer) */
    
    IF VALID-HANDLE(hVisualCandidate) AND NOT VALID-HANDLE(hVisual) THEN 
       hVisual = hVisualCandidate.
    
    IF VALID-HANDLE(hVisual) THEN
    DO:
      {get NewRecord cNewRecord hVisual} NO-ERROR.
      IF cNewRecord = 'NO':U THEN
      DO:
        {get ObjectMode cObjectMode hVisual}.
        cContainerMode = IF CAN-DO('update,modify':U,cObjectMode) THEN 'Modify':U
                         ELSE 'View':U.
      END.
      ELSE IF cNewRecord > '':U THEN
        cContainerMode = cNewRecord.
      {set WindowTitleViewer hVisual}.
    END.
    RETURN cContainerMode.
  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getContainerTarget) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getContainerTarget Procedure 
FUNCTION getContainerTarget RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns a list of the handles of the object's contained objects.
   Params:  <none>
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cTarget AS CHARACTER NO-UNDO.
  {get ContainerTarget cTarget}.
  RETURN cTarget.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getContainerTargetEvents) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getContainerTargetEvents Procedure 
FUNCTION getContainerTargetEvents RETURNS CHARACTER
  (   ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns a comma-separated list of the events this object 
            wants to subscribe to in its ContainerTarget.
   Params:  <none>
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cEvents AS CHARACTER NO-UNDO.
  {get ContainerTargetEvents cEvents}.
  RETURN cEvents.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getContainerToolbarSource) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getContainerToolbarSource Procedure 
FUNCTION getContainerToolbarSource RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the handle(s) of the object's containertoolbar-source.
   Params:  <none>
    Notes:   
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cTarget   AS CHARACTER NO-UNDO.
  
  {get ContainerToolbarSource cTarget}.
  RETURN cTarget.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getContainerToolbarSourceEvents) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getContainerToolbarSourceEvents Procedure 
FUNCTION getContainerToolbarSourceEvents RETURNS CHARACTER
  (   ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the list of events to be subscribed to in the
            ContainerToolbar-Source.  
   Params:  <none>
    Notes:             
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cEvents AS CHARACTER NO-UNDO.
  {get ContainerToolbarSourceEvents cEvents}.
  RETURN cEvents.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getContextForClient) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getContextForClient Procedure 
FUNCTION getContextForClient RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose: Returns a paired chr(4) delimited list of context properties and 
           values for this object.   
    Notes: Called from obtainContext to add the container's own context to the 
           context. 
------------------------------------------------------------------------------*/
  DEFINE VARIABLE lFirst          AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cOperatingMode  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cContext        AS CHARACTER  NO-UNDO.

  /* This is passed from the client to identify the first call */
  {get ServerFirstCall lFirst}. 

  IF lFirst THEN
  DO:    
    /* serverFirstCall need to be false if state-aware 
       (We return it to the client as a handshake that the first call has 
        completed ..  ) */
    &SCOPED-DEFINE xp-assign
    {set ServerFirstCall FALSE}
    {get ServerOperatingMode cOperatingMode}
    .
    &UNDEFINE xp-assign
    
    ASSIGN cContext = 'ServerFirstCall':U + CHR(4) + 'NO':U
                    + CHR(4) 
                    + 'ServerOperatingMode':U + CHR(4) 
                    + IF cOperatingMode = ? THEN '?':U ELSE cOperatingMode.

  END. /* First */

  RETURN cContext.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getContextForServer) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getContextForServer Procedure 
FUNCTION getContextForServer RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose: Returns a paired chr(4) delimited list of context properties and 
           values for this object.   
    Notes: Called from obtainContext to add the container's own context to the 
           context. 
------------------------------------------------------------------------------*/
  DEFINE VARIABLE lStarted  AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lHasProxy AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cContext  AS CHARACTER  NO-UNDO.

  {get AsHasStarted lStarted}.
  
  /* Send some extra info the first time */
  IF NOT lStarted THEN
  DO:
    ASSIGN
      cContext    = 'ServerFirstCall':U + CHR(4) + 'YES':U.

    {get HasDynamicProxy lHasProxy}.
    IF lHasProxy THEN
      cContext    = cContext + CHR(4) + 'HasDynamicProxy':U + CHR(4) + 'YES':U.
  END.
  RETURN cContext.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getCurrentLogicalName) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getCurrentLogicalName Procedure 
FUNCTION getCurrentLogicalName RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  This is set in constructObject if LogicalObjectname
            is passed in as (currently the first) property to be used by 
            callee to fetch its data in repository
    Notes:  
------------------------------------------------------------------------------*/  
  RETURN gcCurrentObjectName.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getCurrentPage) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getCurrentPage Procedure 
FUNCTION getCurrentPage RETURNS INTEGER
  ( ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the current page number of the Container
   Params:  <none>
------------------------------------------------------------------------------*/

  DEFINE VARIABLE iPage AS INTEGER NO-UNDO.
  {get CurrentPage iPage}.
  RETURN iPage.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDataContainer) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getDataContainer Procedure 
FUNCTION getDataContainer RETURNS LOGICAL
  (  ) :
/*------------------------------------------------------------------------------
  Purpose: Returns true if this object can handle data requests for dbaware 
           objects or if this object defines the scope of requests for  
           non-dbaware objects . 
    Notes: The usage is slightly different depending on the type of dataobjects.
           Set from the appserver aware for the HasDbAware case. 
       HasDBaware 
           Indicates that the object CAN manage a data request to the appserver. isFetchPending is used to identify
           If an uninitialized parent datacontainer hamdloes the request during 
           initialization. After the object is initialized a datacontainer will
           manage all request for contained objects.
       NOT HasDBaware (DataViews)  
         - Defines the scope of requests to the service allowing child 
           containers to have object in the same business entities as the parent. 
         - Set only at the top most uninitialized datacontainer. 
           getRequestHandle is used to return the datacontainer both before and 
           after initialization. getRequestHandle also sets this property to 
           true in the top most uninitialized datacontainer (unless a parent 
           container already is datacontainer).  
         - The property can be set to true in a child container fetchData 
           override if it is necessary to limit the scope of contained 
           business entities. (The reason it cannot be done in initializeObject
           is that initializeDataObject currently sets this to false, since it 
           may be true because the container is appserver aware for the dbaware
           case). 
           
------------------------------------------------------------------------------*/
  DEFINE VARIABLE lDataContainer AS LOGICAL    NO-UNDO.
  {get DataContainer lDataContainer}.
  RETURN lDataContainer.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDataContainerHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getDataContainerHandle Procedure 
FUNCTION getDataContainerHandle RETURNS HANDLE
  ( ) :
/*------------------------------------------------------------------------------
  Purpose: Returns the datacontainer that handles all data requests.  
    Notes: If the RequestHandle (the object that manages the request for this
           object) is another object then we just return the DataContainerHandle
           from it. If the container does its own request we resolve the handle 
           here.      
         - The DataContainerName allows override (for namespacing).  
         - The ghDatacontainer variable is for the class and only used for 
           the default DataContainer
         - Duplicated in dataview.p 
------------------------------------------------------------------------------*/
  define variable cName          as character no-undo.
  define variable hRequestHandle as handle    no-undo.
  
  {get RequestHandle hRequesthandle}.
  if hRequestHandle <> target-procedure and hRequestHandle <> ? then
    return {fn getDataContainerHandle hRequestHandle}.
  else    
  do: 
    {get DataContainerName cName}.
    if cName = '':U or cName = 'DataContainer':U then
    do:
      if not valid-handle(ghDataContainer) then 
        ghDataContainer = {fnarg getManagerHandle 'DataContainer':U}.
  
      return ghDataContainer.
    end.
    else 
      return {fnarg getManagerHandle cName}.
  end.
       
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDataContainerName) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getDataContainerName Procedure 
FUNCTION getDataContainerName RETURNS CHARACTER
  (   ) :
/*------------------------------------------------------------------------------
  Purpose:  The DataContainerName is passed to getManagerHandle to start the 
            DataContainer for an instance. 
    Notes:  The DataContainer and the Service Adapter has a one-to-one 
            relationship. This property allows applications to run in the same 
            session with separate Service Adapters. 
            This might be necessary if Business Entity references need 
            different namepaces because the applications have been developed 
            separately.
          - Duplicated in dataview.p 
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cName AS CHARACTER   NO-UNDO.
  {get DataContainerName cName}.
  RETURN cName.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDisabledAddModeTabs) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getDisabledAddModeTabs Procedure 
FUNCTION getDisabledAddModeTabs RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    DEFINE VARIABLE cDisabledAddModeTabs AS CHARACTER NO-UNDO.
    {get DisabledAddModeTabs cDisabledAddModeTabs}.
    RETURN cDisabledAddModeTabs.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDynamicSDOProcedure) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getDynamicSDOProcedure Procedure 
FUNCTION getDynamicSDOProcedure RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the name of the dynamic SDO procedure, 'adm2/dyndata.w'
            by default (can be modified if the dynamic SDO is customized).
   Params:  <none>
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cProc AS CHARACTER NO-UNDO.
  {get DynamicSDOProcedure cProc}.
  RETURN cProc.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getFilterSource) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getFilterSource Procedure 
FUNCTION getFilterSource RETURNS HANDLE
  ( ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the Filter Source for Pass-through support.
   Params:  <none>
------------------------------------------------------------------------------*/

  DEFINE VARIABLE hSource AS HANDLE NO-UNDO.
  {get FilterSource hSource}.
  RETURN hSource.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getHasDbAwareObjects) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getHasDbAwareObjects Procedure 
FUNCTION getHasDbAwareObjects RETURNS LOGICAL
  (   ) :
/*------------------------------------------------------------------------------
  Purpose: Tells whether the container has DbAware data objects.
    Notes: The container's data objects are either all DbAware or all not 
           DbAware. 
           SDOs and SBOs are DbAware and are managed differently than 
           DataViews who are not DbAware.      
        -  The property name is somewhat misleading/inconsistent, since it is not 
           reflecting the DBAware property of the contained instances. 
           TT based SDOs may have their instance DBAware set to false, but is 
           still considered as DBAware in this context.                        
------------------------------------------------------------------------------*/
  DEFINE VARIABLE lDbObjects AS LOGICAL    NO-UNDO.
  {get HasDbAwareObjects lDbObjects}.
  RETURN lDbObjects.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getHasDynamicProxy) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getHasDynamicProxy Procedure 
FUNCTION getHasDynamicProxy RETURNS LOGICAL
  (  ) :
/*------------------------------------------------------------------------------
  Purpose: Returns if the Container has a dynamic client proxy. 
    Notes:  
------------------------------------------------------------------------------*/
 DEFINE VARIABLE lProxy AS LOGICAL    NO-UNDO.
 {get HasDynamicProxy lProxy}.
 RETURN lProxy.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getHasObjectMenu) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getHasObjectMenu Procedure 
FUNCTION getHasObjectMenu RETURNS LOGICAL
  (  ) :
/*------------------------------------------------------------------------------
  Purpose: Returns whether menus have been linked to a container. 
    Notes:  
------------------------------------------------------------------------------*/
 DEFINE VARIABLE lHasMenus AS LOGICAL    NO-UNDO.
 {get HasObjectMenu lHasMenus}.
 RETURN lHasMenus.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getHideChildContainersOnClose) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getHideChildContainersOnClose Procedure 
FUNCTION getHideChildContainersOnClose RETURNS LOGICAL
  (  ) :
/*------------------------------------------------------------------------------
  Purpose: Returns if the Container's child containers should be hidden 
           when closed. Used mostly for containers launched in a Dynamic TreeView
           Object.
    Notes:  
------------------------------------------------------------------------------*/
 DEFINE VARIABLE lHideChildContainersOnClose AS LOGICAL    NO-UNDO.
 {get HideChildContainersOnClose lHideChildContainersOnClose}.
 RETURN lHideChildContainersOnClose.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getHideOnClose) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getHideOnClose Procedure 
FUNCTION getHideOnClose RETURNS LOGICAL
  (  ) :
/*------------------------------------------------------------------------------
  Purpose: Returns if the Container should be hidden when closed 
    Notes:  
------------------------------------------------------------------------------*/
 DEFINE VARIABLE lHideOnClose AS LOGICAL    NO-UNDO.
 {get HideOnClose lHideOnClose}.
 RETURN lHideOnClose.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getInitialPageList) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getInitialPageList Procedure 
FUNCTION getInitialPageList RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose: Returns the comma delimited list of pages to construct at startup. A 
           special value of * will indicate all pages must be initialised at
           startup.
    Notes: None
------------------------------------------------------------------------------*/
    DEFINE VARIABLE cPageList AS CHARACTER NO-UNDO.
    {get InitialPageList cPageList}.
    RETURN cPageList.
  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getInstanceNames) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getInstanceNames Procedure 
FUNCTION getInstanceNames RETURNS CHARACTER
  (   ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the ordered list of ObjectNames of ContainerTargets.
    Notes:  This is used to enforce unique instance names in the container and
            is updated in constructObject and destroyObject together with 
            the container link.
          - This is needed in order for containedProperties and 
            assignContainedProperties to work together. 
          - The list is in ContainerTarget order and each name is currently 
            also stored in each object's ObjectName property. The name 
            InstanceNames were still chosen instead of basing the name of any 
            of these properties as this is more true to the nature of this 
            property. 
Note date: 2002/02/08                        
-----------------------------------------------------------------------------*/
  DEFINE VARIABLE cNames AS CHARACTER  NO-UNDO.
  {get InstanceNames cNames}.
  
  RETURN cNames.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getMultiInstanceActivated) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getMultiInstanceActivated Procedure 
FUNCTION getMultiInstanceActivated RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE lMultiInstanceActivated AS LOGICAL NO-UNDO.
  {get MultiInstanceActivated lMultiInstanceActivated}.
  RETURN lMultiInstanceActivated.
  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getMultiInstanceSupported) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getMultiInstanceSupported Procedure 
FUNCTION getMultiInstanceSupported RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE lMultiInstanceSupported AS LOGICAL NO-UNDO.
  {get MultiInstanceSupported lMultiInstanceSupported}.
  RETURN lMultiInstanceSupported.
  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getNavigationSource) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getNavigationSource Procedure 
FUNCTION getNavigationSource RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  Return the NavigationSource. Used for pass-thru for regular 
            containers, but also inherited by the SBO that uses it for 'real'.  
    Notes:  Because multiple Navigation-Sources are supported, this is a 
            comma-separated list of strings.
------------------------------------------------------------------------------*/
DEFINE VARIABLE cNavigationSource AS CHARACTER  NO-UNDO.
  
  {get NavigationSource cNavigationSource}.
  RETURN cNavigationSource. 

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getNavigationSourceEvents) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getNavigationSourceEvents Procedure 
FUNCTION getNavigationSourceEvents RETURNS CHARACTER
  (   ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the list of events to be subscribed to in the
            Navigation Panel or other Navigation-Source.
   Params:  <none>
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cEvents AS CHARACTER NO-UNDO.
  {get NavigationSourceEvents cEvents}.
  RETURN cEvents.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getNavigationTarget) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getNavigationTarget Procedure 
FUNCTION getNavigationTarget RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose: Supported for pass-thru 
    Notes:  
------------------------------------------------------------------------------*/
 DEFINE VARIABLE cNavigationTarget AS CHARACTER NO-UNDO.          

  {get NavigationTarget cNavigationTarget}.
  RETURN cNavigationTarget. 
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getOutMessageTarget) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getOutMessageTarget Procedure 
FUNCTION getOutMessageTarget RETURNS HANDLE
  ( ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the OutMessage Target for Pass-through support.
   Params:  <none>
------------------------------------------------------------------------------*/

  DEFINE VARIABLE hTarget AS HANDLE NO-UNDO.
  {get OutMessageTarget hTarget}.
  RETURN hTarget.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getPage0LayoutManager) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getPage0LayoutManager Procedure 
FUNCTION getPage0LayoutManager RETURNS CHARACTER
        (  ):
/*------------------------------------------------------------------------------
  Purpose:  
        Notes:
------------------------------------------------------------------------------*/
    DEFINE VARIABLE cPage0LayoutManager       AS CHARACTER        NO-UNDO.
        
    {get Page0LayoutManager cPage0LayoutManager}.
   
    RETURN cPage0LayoutManager.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getPageLayoutInfo) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getPageLayoutInfo Procedure 
FUNCTION getPageLayoutInfo RETURNS CHARACTER
        (  ):
/*------------------------------------------------------------------------------
  Purpose:  
        Notes:
------------------------------------------------------------------------------*/
    DEFINE VARIABLE cPageLayoutInfo         AS CHARACTER            NO-UNDO.
    
    {get PageLayoutInfo cPageLayoutInfo}.
        
    RETURN cPageLayoutInfo.
END FUNCTION.   /* getPageLayoutInfo */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getPageNTarget) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getPageNTarget Procedure 
FUNCTION getPageNTarget RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the list of objects which are on some page other than 0.
   Params:  <none>
    Notes:  This property has a special format of "handle|page#' for each entry,
            and should not be manipulated directly. Use addLink.
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cTarget AS CHARACTER NO-UNDO.
  {get PageNTarget cTarget}.
  RETURN cTarget.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getPageSource) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getPageSource Procedure 
FUNCTION getPageSource RETURNS HANDLE
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the handle of the object's Page Source (folder), if any.
   Params:  <none>
------------------------------------------------------------------------------*/

  DEFINE VARIABLE hSource AS HANDLE NO-UNDO.
  {get PageSource hSource}.
  RETURN hSource.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getPageTokens) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getPageTokens Procedure 
FUNCTION getPageTokens RETURNS CHARACTER
    (  ):
/*------------------------------------------------------------------------------
  Purpose: 
    Notes:
------------------------------------------------------------------------------*/
    define variable cPageTokens        as character no-undo.
    {get PageTokens cPageTokens}.
    
    error-status:error = no.
    return cPageTokens.
END FUNCTION.    /* getPageTokens */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getPendingPage) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getPendingPage Procedure 
FUNCTION getPendingPage RETURNS INTEGER
  ( ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the Pending page number of the Container. This is set 
            immediately in SelectPage so that objects on hide can check 
            what will become the new page before CurrentPage is set. 
            This was specifically implemented so that hideObject -> linkState 
            could avoid disabling links for objects that are going to become 
            viewed.
    Notes:  Returns ? when no page selection is pending.                   
------------------------------------------------------------------------------*/
  DEFINE VARIABLE iPage AS INTEGER NO-UNDO.
  {get PendingPage iPage}.
  RETURN iPage.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getPrimarySdoTarget) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getPrimarySdoTarget Procedure 
FUNCTION getPrimarySdoTarget RETURNS HANDLE
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hPrimarySdoTarget AS HANDLE NO-UNDO.
  {get PrimarySdoTarget hPrimarySdoTarget}.
  RETURN hPrimarySdoTarget.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getReEnableDataLinks) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getReEnableDataLinks Procedure 
FUNCTION getReEnableDataLinks RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    DEFINE VARIABLE cReEnableDataLinks AS CHARACTER NO-UNDO.
    {get ReEnableDataLinks cReEnableDataLinks}.
    RETURN cReEnableDataLinks.
  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getRemoveMenuOnHide) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getRemoveMenuOnHide Procedure 
FUNCTION getRemoveMenuOnHide RETURNS LOGICAL
  (  ) :
/*------------------------------------------------------------------------------
 Purpose: Decides whether the the menus should be removed from the menubar 
          on hide of the container.  
 Parameters: INPUT plRemove 
     Notes:
------------------------------------------------------------------------------*/
  DEFINE VARIABLE lRemoveMenu AS LOGICAL    NO-UNDO.
  {get RemoveMenuOnhide lRemoveMenu}.
  RETURN lRemoveMenu.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getRequestHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getRequestHandle Procedure 
FUNCTION getRequestHandle RETURNS HANDLE
  (  ) :
/*------------------------------------------------------------------------------
  Purpose: Return the handle that defines the scope of service requests for 
           contained dataview objects. 
    Notes: Returns its own handle if datacontainer, otherwise if not initialize,
           it will return the container source RequestHandle.
        -  If this object is uninitialized and no parent requestor was 
           found then this object's handle is returned and DataContainer 
           is set to true. 
        -  Returns ? if initialized and datacontainer is false and no 
           parent datacontainer. 
        -  DataContainer is set to false in initializeDataObject if the 
           container has db aware object (currently deaults to yes if appserver
           aware to handle non-dbware objects).  
        -  In short, the top-most uninitialized object becomes the datacontainer
           unless a parent already is datacontainer
        -  The DataContainer flag is also used for appserver aware standard
           containers, so we ignore it if the object HasDbAwareObjects.                                     
------------------------------------------------------------------------------*/
  DEFINE VARIABLE lDataContainer   AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lInitialized     AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE hContainerSource AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hRequestor       AS HANDLE     NO-UNDO.
  DEFINE VARIABLE lDbAware         AS LOGICAL    NO-UNDO.

  {get Datacontainer lDataContainer}.
  IF lDataContainer THEN
  DO:
    /* Standard appserver aware container will have YES or ? */
    {get HasDbAwareObjects lDbAware}.
    IF lDbAware = TRUE OR lDbAware = ? THEN
      RETURN ?.
  END. /* DataContainer true */

  IF NOT lDataContainer THEN
  DO:
    {get ContainerSource hContainerSource}.
    IF VALID-HANDLE(hContainerSource) THEN
    DO:
      {get RequestHandle hRequestor hContainerSource}.
      IF VALID-HANDLE(hRequestor) THEN
        RETURN hRequestor.
    END.
    {get ObjectInitialized lInitialized}.
    IF lInitialized THEN
      RETURN ?.

    {set Datacontainer TRUE}.
  END.  /* not datacontainer */

  /* datacontainer or not initialized with no parent that is  
     datacontainer or not initialized */
  RETURN TARGET-PROCEDURE.  

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getRequiredPages) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getRequiredPages Procedure 
FUNCTION getRequiredPages RETURNS CHARACTER
    (  ):
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:
------------------------------------------------------------------------------*/
    DEFINE VARIABLE cRequiredPages             AS CHARACTER          NO-UNDO.
    
    {get RequiredPages cRequiredPages}.    
    
    RETURN cRequiredPages.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getRunDOOptions) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getRunDOOptions Procedure 
FUNCTION getRunDOOptions RETURNS CHARACTER
  ( ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns a comma-separated list with options that determine how 
            Data Objects are run from constructObject
            The options available are:
              dynamicOnly - this runs dynamic data objects only and supercedes
                            all other options
              sourceSearch - this searches for source code if rcode is not found
              clientOnly - this runs proxy (_cl) code only (for both rcode and 
                           source code)
            
            If dynamicOnly and/or clientOnly options are used the container
            assumes that the Data Object has an AppServer partition defined.
            If an AppServer partition is not defined and dynamicOnly and/or
            clientOnly options are used, errors will occur as if the Data 
            Object was being run on an AppServer that hadn't been started.
            
   Params:  <none>
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cOptions AS CHARACTER NO-UNDO.
  {get RunDOOptions cOptions}.
  RETURN cOptions.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getRunMultiple) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getRunMultiple Procedure 
FUNCTION getRunMultiple RETURNS LOGICAL
  ( ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  def vAR plMultiple AS LOGICAL no-undo.  
  {get RunMultiple plMultiple}.
  RETURN plMultiple.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getSavedContainerMode) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getSavedContainerMode Procedure 
FUNCTION getSavedContainerMode RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    DEFINE VARIABLE cSavedContainerMode AS CHARACTER NO-UNDO.
    {get SavedContainerMode cSavedContainerMode}.
    RETURN cSavedContainerMode.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getSdoForeignFields) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getSdoForeignFields Procedure 
FUNCTION getSdoForeignFields RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cSdoForeignFields AS CHARACTER.
  {get SdoForeignFields cSdoForeignFields}.
  RETURN cSdoForeignFields.
  

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getStatusArea) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getStatusArea Procedure 
FUNCTION getStatusArea RETURNS LOGICAL

  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns whether the container has a status area or not
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hContainer AS HANDLE NO-UNDO.
  
  {get ContainerHandle hContainer}.
  IF VALID-HANDLE(hContainer) AND CAN-QUERY(hContainer,"status-area":U) THEN
    RETURN hContainer:STATUS-AREA.
  ELSE 
    RETURN FALSE.  

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getTargetProcedure) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getTargetProcedure Procedure 
FUNCTION getTargetProcedure RETURNS HANDLE
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  
  RETURN ghTargetProcedure.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getTopOnly) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getTopOnly Procedure 
FUNCTION getTopOnly RETURNS LOGICAL
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:     Get window top only (toggle)
  Parameters:  input logical of yes / no for what to set it to.
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE hContainer AS HANDLE NO-UNDO.

{get ContainerHandle hContainer}.
IF VALID-HANDLE(hContainer) AND CAN-QUERY(hContainer,"top-only":U) THEN
  RETURN hContainer:TOP-ONLY.
ELSE 
  RETURN FALSE.  

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getUpdateActive) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getUpdateActive Procedure 
FUNCTION getUpdateActive RETURNS LOGICAL
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns true if ANY of the contained object's have active updates  
    Notes:  See setUpdateactive                
          - All participating events including okObject and okCancel is bound
            within a window container.  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE lActive AS LOGICAL    NO-UNDO.
  {get UpdateActive lActive}.

  RETURN lActive.  

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getUpdateSource) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getUpdateSource Procedure 
FUNCTION getUpdateSource RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the handle of the object's Update-Source.
   Params:  <none>
    Notes:  This is used for pass-through links, to connect an object
            inside the container with an object outside the container.
            It is CHARACTER because at least one type of container (SBO)
            supports multiple update sources.
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cSource   AS CHARACTER NO-UNDO.
  
  {get UpdateSource cSource}.
  RETURN cSource.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getUpdateTarget) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getUpdateTarget Procedure 
FUNCTION getUpdateTarget RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the handle of the object's Update-Target.
   Params:  <none>
    Notes:  This is used for pass-through links, to connect an object
            inside the container with an object outside the container.
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cTarget   AS CHARACTER NO-UNDO.
  
  {get UpdateTarget cTarget}.
  RETURN cTarget.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getWaitForObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getWaitForObject Procedure 
FUNCTION getWaitForObject RETURNS HANDLE
  ( ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the handle of the object (most likely a SmartConsumer) 
            in the container that contains a wait-for that needs to be started 
            with startWaitFor 
   Params:  <none>
------------------------------------------------------------------------------*/

  DEFINE VARIABLE hObject AS HANDLE NO-UNDO.
  {get WaitForObject hObject}.
  RETURN hObject.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getWidgetIDFileName) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getWidgetIDFileName Procedure 
FUNCTION getWidgetIDFileName RETURNS CHARACTER
        (  ):
/*------------------------------------------------------------------------------
    Purpose: Returns the xml file name that stores the widget-id values for
             the container.
    Notes:
------------------------------------------------------------------------------*/
DEFINE VARIABLE cWidgetIDFileName AS CHARACTER  NO-UNDO.
{get WidgetIDFileName cWidgetIDFileName}.
RETURN cWidgetIDFileName.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getWindowFrameHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getWindowFrameHandle Procedure 
FUNCTION getWindowFrameHandle RETURNS HANDLE
  (  ) :
/*------------------------------------------------------------------------------
  Purpose: Stores the optional frame of a Window container 
    Notes: The somewhat strange name is used because this property ONLY  
           identifies the frame of a window container and must not be 
           confused with the important ContainerHandle, which is the
           widget handle of the container in all object and in most cases 
           stores the frame handle also for a SmartContainer.  
         - Even if Window containers does not need a frame they often has one
           and in that case we must include it in for example resizing or 
           widget-tree logic etc...                                   
------------------------------------------------------------------------------*/
DEFINE VARIABLE hFrame AS HANDLE NO-UNDO.
{get WindowFrameHandle hFrame}.
RETURN hFrame.   

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getWindowName) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getWindowName Procedure 
FUNCTION getWindowName RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose: Returns the title of the container window, if it has one. 
    Notes:  * See notes in setWindowName() for more details of usage.
------------------------------------------------------------------------------*/
  define variable hWindow          as handle                         no-undo.
  define variable cWindowName      as character                      no-undo.
    
  {get ContainerHandle hWindow}.
  if valid-handle(hWindow) 
  and (hWindow:type = 'WINDOW':U or hWindow:type = 'DIALOG-BOX':U ) then
    cWindowName = hWindow:title.
  else
    cWindowName = ?.
    
  return cWindowName.
END FUNCTION.    /* getWindowName */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getWindowTitleViewer) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getWindowTitleViewer Procedure 
FUNCTION getWindowTitleViewer RETURNS HANDLE
  ( ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
DEFINE VARIABLE hHandle AS HANDLE NO-UNDO.
{get WindowTitleViewer hHandle}.
RETURN hHandle.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-initPagesForTranslation) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION initPagesForTranslation Procedure 
FUNCTION initPagesForTranslation RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  To check if profile data exists indicating whether all pages on a
            container needs to be initialized before the translation window
            opens up. That way, all widgets on the container will be listed in
            the translation Browse.
    
    Notes:  a) If no profile data exists, a default value of true will be assumed,
               forcing all pages to initialize for translation
            b) The code was placed here instead of the Translation viewer. The
               reason was that if all pages were initialized from the Translation
               viewer and the Translation window was closed, all toolbars
               initialized by the call from the Translation viewer were destroyed
               with the Translation window. It seems that the toolbars were
               parented to the wrong container. This way, the initialization forces
               all objects to be parented to the correct container.
            c) Seeing that Translation will not be called that often - and that
               the value of the preference could be set at any time, the value
               of the profile code will be read whenever the translation window
               is to be launched.
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cFolderLabels AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cProfileData  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cPageString   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iCurrentPage  AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iPage         AS INTEGER    NO-UNDO.
  DEFINE VARIABLE lSuccess      AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lExists       AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE hPageSource   AS HANDLE     NO-UNDO.
  DEFINE VARIABLE rRowid        AS ROWID      NO-UNDO.
  DEFINE VARIABLE hContainingWindow         AS HANDLE                 NO-UNDO.
  DEFINE VARIABLE cTabEnabled               AS CHARACTER              NO-UNDO.
  
  IF VALID-HANDLE(gshProfileManager) THEN
  DO:
    {get PageSource hPageSource}.

    /* If we don't have a valid page source, it means we won't have multiple pages */
    IF VALID-HANDLE(hPageSource) THEN
    DO:
      /* Check if profile data exists for the preference */
      RUN checkProfileDataExists IN gshProfileManager (INPUT  "Window":U,
                                                       INPUT  "InitForTrn":U,
                                                       INPUT  "InitForTrn":U,
                                                       INPUT  YES,
                                                       INPUT  NO,
                                                       OUTPUT lExists).

      /* If the preference does exist, find the value for it */
      IF lExists THEN
        RUN getProfileData IN gshProfileManager (INPUT "Window":U,
                                                 INPUT "InitForTrn":U,
                                                 INPUT "InitForTrn":U,
                                                 INPUT NO,
                                                 INPUT-OUTPUT rRowid,
                                                 OUTPUT cProfileData).

      /* If profile data does not exist OR if the profile data says that all pages should be initialized, continue */
      IF (NOT lExists) OR cProfileData = "yes":U THEN
      DO:
        {get CurrentPage  iCurrentPage}.              /* Get the current page as this will be needed after the initialization */
        
        &SCOPED-DEFINE xp-assign
        {get FolderLabels cFolderLabels hPageSource} /* Get the page labels to determine the number of pages (needed to build the string of page numbers) */
        {get TabEnabled cTabEnabled hPageSource}.
        &UNDEFINE xp-assign
        
        DO iPage = 1 TO NUM-ENTRIES(cFolderLabels, "|":U):
          
          /* Build a string that will build a comma seperated list of 
             page numbers, i.e. 1,2,3,4,5,6 - if the container had 6 pages 
             
             However, if the tab is disabled, then don't init it - it may
             be that a particular page is initially disabled, or that the page
             is secured. If so, let the UI/developer enable it when required.
           */
           IF cTabEnabled                               NE ?     AND
              NUM-ENTRIES(cTabEnabled, "|":U)           GE iPage AND
              LOGICAL(ENTRY(iPage, cTabEnabled, "|":U)) EQ NO    THEN
              NEXT.
          
          cPageString = cPageString + (IF cPageString = "":U THEN "":U ELSE ",":U) + STRING(iPage).
        END.    /* loop through pages */
        
        /* Run initPages passing in the string of page numbers - this will initialize all non-initialized pages */
        RUN initPages IN TARGET-PROCEDURE (INPUT cPageString).
        
        /* Once all the pages have been init'ed then pack and lay them out.
           Packing and layout happens at a container level, and is managed by
           the container's initializeObject() and changePage() functions.
           The call to initPages() above bypasses this, and so while the pages
           have been init'ed, they haven't yet been packed.
         */
        ASSIGN hContainingWindow = {fn getContainingWindow} NO-ERROR.
        IF NOT VALID-HANDLE(hContainingWindow) THEN
            ASSIGN hContainingWindow = TARGET-PROCEDURE.
            
        /* All of these pages now become the initial page list
           of this container. This list is required for the packing
           to ensure that all of the recently init'ed pages are
           packed correctly.
           
           Don't forget page 0.
         */
        ASSIGN cPageString = "0,":U + cPageString.
        {set InitialPageList cPageString}.
                
        RUN packWindow IN hContainingWindow (INPUT 0, INPUT YES) NO-ERROR.
        RUN resizeWindow IN hContainingWindow NO-ERROR.
        
        /* initPages makes the tab of the page being initialized selected, but at the end, does not re-select the tab that was selected when the user
           initiated the Translation window. If we do not do this, an incorrect tab will be seen as selected, BUT the objects you see will be the objects
           on the originally selected page - i.e if you had Page 1 selected, but the container had 5 pages, at the end of the initPages call, the objects
           on Page 1 will be visible, but the tab of Page 5 will be shown as the selected tab */
        {set CurrentPage 0}.

        RUN selectPage IN TARGET-PROCEDURE (INPUT iCurrentPage).
      END.
    END.

    lSuccess = TRUE.
  END.
  ELSE
    lSuccess = FALSE.

  RETURN lSuccess.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-isFetchPending) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION isFetchPending Procedure 
FUNCTION isFetchPending RETURNS LOGICAL
  ( ) :
/*------------------------------------------------------------------------------
  Purpose: Check if this or any container outside of this is going to fetch data
    Notes: Dataobjects check this during initialization in order to decide
           whether they need to open the query themselves or not   
------------------------------------------------------------------------------*/
  DEFINE VARIABLE lDataContainer        AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE hSource               AS HANDLE     NO-UNDO.
  DEFINE VARIABLE lOk                   AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lInitialized          AS LOGICAL    NO-UNDO.

  {get DataContainer lDataContainer}.
  IF lDataContainer THEN
  DO:
    {get ObjectInitialized lInitialized}.
    IF NOT lInitialized THEN
       RETURN TRUE.
  END.

  {get ContainerSource hSource}.
  IF VALID-HANDLE(hSource) THEN
    RETURN {fn IsFetchPending hSource}.
  
  RETURN FALSE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-isRequestTreeRoot) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION isRequestTreeRoot Procedure 
FUNCTION isRequestTreeRoot RETURNS LOGICAL
  ( INPUT phTopContainer AS HANDLE,
    INPUT phTargetObject AS HANDLE ) :
/*------------------------------------------------------------------------------
  Purpose:  To determine if we should prepareDataForFetch for the TargetObject.
    Notes:  If the target to fetch for is a QueryObject and it has a valid Data Source, 
            we need to determine if the DataSource's container is in the same container 
            hierarchy as that of the target. If so, and the DataSource is already 
            initialized, we need to proceed with the 'prepareData' call for the target
------------------------------------------------------------------------------*/
DEFINE VARIABLE hTargetContainer        AS HANDLE     NO-UNDO.
DEFINE VARIABLE hDSContainer            AS HANDLE     NO-UNDO.
DEFINE VARIABLE lOkToFetchForTarget     AS LOGICAL    NO-UNDO.
DEFINE VARIABLE hDataSource             AS HANDLE     NO-UNDO.
DEFINE VARIABLE lDataSourceInitialized  AS LOGICAL    NO-UNDO.
DEFINE VARIABLE lQuery                  AS LOGICAL    NO-UNDO.

  {get QueryObject lQuery phTargetObject}.
  
  /* if this is not a QueryObject return FALSE */
  IF lQuery THEN
  DO:
    {get DataSource hDataSource phTargetObject}.
    lOkToFetchForTarget = hDataSource EQ ?.
   
    IF NOT lOkToFetchForTarget AND VALID-HANDLE(hDataSource) THEN
    DO:
      lOkToFetchForTarget = TRUE.
      /* unless the DataSource is in the same container hierarchy... */
      &SCOPED-DEFINE xp-assign
      {get ObjectInitialized lDataSourceInitialized hDataSource}
      {get ContainerSource hDSContainer hDataSource}
        .
      &UNDEFINE xp-assign
      {get ContainerSource hTargetContainer phTargetObject}.

      IF hTargetContainer = hDSContainer OR NOT lDataSourceInitialized THEN
        lOkToFetchForTarget = FALSE.
      ELSE DO WHILE hTargetContainer <> phTopContainer:
        {get ContainerSource hTargetContainer hTargetContainer}.
        IF hTargetContainer = hDSContainer THEN
        DO:
          lOkToFetchForTarget = FALSE.
          LEAVE.
        END.
      END.  /* DO WHILE */
    END.  /* if NOT lOkToFetchForTarget */
  END.  /* if lQuery */

  RETURN lOkToFetchForTarget.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-lockContainingWindow) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION lockContainingWindow Procedure 
FUNCTION lockContainingWindow RETURNS LOGICAL
    ( INPUT plLockWindow            AS LOGICAL) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    DEFINE VARIABLE iReturnCode         AS INTEGER                      NO-UNDO.
    DEFINE VARIABLE iLockWindow         AS INTEGER                      NO-UNDO.
    DEFINE VARIABLE hWindow             AS HANDLE                       NO-UNDO.

    ASSIGN iLockWindow = INTEGER(DYNAMIC-FUNCTION("getUserProperty":U IN TARGET-PROCEDURE, INPUT "LockWindow":U)) NO-ERROR.

    ASSIGN iLockWindow = iLockWindow + (IF plLockWindow THEN 1 ELSE -1)
           /* make sure that we are dealing with a non-zero value here. */
           iLockWindow = MAX(iLockWindow, 0)
           .
    DYNAMIC-FUNCTION("setUserProperty":U IN TARGET-PROCEDURE, INPUT "LockWindow":U, INPUT STRING(iLockWindow)).

    IF plLockWindow AND iLockWindow > 1 THEN
        RETURN FALSE.

    IF NOT plLockWindow AND iLockWindow > 0 THEN
        RETURN FALSE.

    {get ContainerHandle hWindow}.
    
    IF plLockWindow AND hWindow:HWND EQ ? THEN
       RETURN FALSE.

    IF plLockWindow THEN
        RUN lockWindowUpdate IN gshSessionManager (INPUT hWindow:HWND, OUTPUT iReturnCode).
    ELSE
        RUN lockWindowUpdate IN gshSessionManager (INPUT 0, OUTPUT iReturnCode).

    RETURN TRUE.
END FUNCTION.   /* lockContainingWindow */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-newHeight) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION newHeight Procedure 
FUNCTION newHeight RETURNS LOGICAL
        ( pdHeight as decimal ):
/*------------------------------------------------------------------------------
    Purpose: Tell the container that new height is needed for an object
  Parameter: pdHeight - total height needed for the object based on current 
                        position. Typically (o:row - 1) + o:height     
    Notes:   This is primarily for simple window size increase when/before 
             objects are resized or dynamically created.
           - Containers might override just to ignore this if they don't support 
             size increase or if  sizing/resizing is handled by other mechanisms, 
             like the Dynamics Layout Manager.     
------------------------------------------------------------------------------*/
   if pdHeight > {fn getHeight} then
   do:
     /* no-error - not part of the container interface */ 
     run resizeObject in target-procedure(pdHeight,{fn getWidth}) no-error.
     if error-status:error then
        return false.
   end.
   return true. 
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-newWidth) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION newWidth Procedure 
FUNCTION newWidth RETURNS LOGICAL
        ( pdWidth as decimal ):
/*------------------------------------------------------------------------------
    Purpose: Tell the container of a new width needed for an object. 
  Parameter: pdWidth - Total width needed for the object based on current 
                       position. Typically (o:col - 1) + o:width    
   Notes:   This is primarily for simple window size increase when/before 
            objects are resized or dynamically created.
          - Containers might override just to ignore this if they don't support 
            size increase or if sizing/resizing is handled by other mechanisms, 
            like the Dynamics Layout Manager.     
------------------------------------------------------------------------------*/
   if pdWidth > {fn getWidth} then 
   do:
     /* no-error - not part of the container interface  */ 
     run resizeObject in target-procedure({fn getHeight},pdWidth) no-error.
     if error-status:error then
        return false.
   end.
   return true. 
   
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-obtainContextForClient) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION obtainContextForClient Procedure 
FUNCTION obtainContextForClient RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose: Obtain context properties to return to the client after or as part 
           of a server request.   
    Notes: The returned data depends on if this is the first call from the 
           client or not. If this is the first call we still return the regular
           context if this is also is a data request, which is the only request 
           that really may change context. A data request is identified with 
           an open query.
         - The serverside object's serverFirstCall defaults to false so that a 
           normal request does not need to have any special information. 
           It is the client's responsibility to signal a first call by passing 
           serverFirstCall=yes as part of the context.  
        -  See also notes in obtainContextForServer about AsHasStarted and 
           ServerFirstCall
        -  Overridden in sbo.p mostly because a Data request also could
           be a save/commit. 
Note date: 2002/02/12                   
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cProperties     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cContext        AS CHARACTER  NO-UNDO.
  
  RUN obtainContext IN TARGET-PROCEDURE ('ForClient':U,
                                         '',
                                         INPUT-OUTPUT cProperties,
                                         INPUT-OUTPUT cContext). 

  RETURN cProperties + CHR(3) + cContext.
  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-obtainContextForServer) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION obtainContextForServer Procedure 
FUNCTION obtainContextForServer RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose: Obtain the context properties to pass to the server.  
    Notes: The server need to know if this is the first call:   
            Client: AsHasStarted = no until a response from server 
            Server: serverFirstCall = no unless client passes YES 
           One reason why there are two 'similar' properties; AsHasStarted and 
           ServerFirstCall, is that we want different defaults on client and 
           server. 
           (We could have set AsHasStarted=yes on server, but this is considered
           somewhat unreliable (and unelegant) as we may want the context 
           functionality anywhere, maybe also when AsDivision is blank) 
           So AsHasStarted is managed on the client while serverFirstCall is 
           passed from the client as YES and passed from server as NO. 
         - This is always called before an Appserver call. It is used to send 
           context in initializeServerObject as well as in all data 
           requests. 
Note date: 2002/02/12           
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cContext       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cProperties    AS CHARACTER  NO-UNDO.

  RUN obtainContext IN TARGET-PROCEDURE ('ForServer':U,
                                         '',
                                         INPUT-OUTPUT cProperties,
                                         INPUT-OUTPUT cContext). 

  RETURN cProperties + CHR(3) + cContext.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-obtainPropertyFromContext) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION obtainPropertyFromContext Procedure 
FUNCTION obtainPropertyFromContext RETURNS CHARACTER
  ( INPUT pcObjectType AS CHAR,
    INPUT pcInstance   AS CHAR,
    INPUT pcProperty   AS CHAR,
    INPUT pcContext    AS CHAR):
/*------------------------------------------------------------------------------
  Purpose:  Returns the value of a specific property from a context string
    Notes:  This function works for container lists *only*
------------------------------------------------------------------------------*/
DEFINE VARIABLE cPropList    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cValueList   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE iPropPos     AS INTEGER    NO-UNDO.
DEFINE VARIABLE cValue       AS CHARACTER  NO-UNDO.
 
 ASSIGN
   cPropList = ENTRY(1, pcContext, CHR(3))
   iPropPos  = LOOKUP(pcProperty,cPropList)
   cValue    = ?.
 
 IF iPropPos > 0 THEN 
 DO:
   ENTRY(1,pcContext,CHR(3)) = ''.
   pcContext = SUBSTR(pccontext,2).
   cValueList = DYNAMIC-FUNCTION('mappedEntry':U IN TARGET-PROCEDURE,
                                  pcInstance,
                                  pcContext,
                                  TRUE, /* find second in pair */
                                  CHR(3)).
   IF cValueList > '' THEN
     cValue = DYNAMIC-FUNCTION('mappedEntry':U IN TARGET-PROCEDURE,
                                STRING(iPropPos), /* The prop name is a number at this stage */ 
                                cValueList,
                                TRUE, /* find second in pair */
                                CHR(4)).
 END.

 /* cValue is ? if we could not locate the instance and/or property 
    (mappedentry returns ? if not found)*/

 RETURN cValue.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-pageNRequiredPages) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION pageNRequiredPages Procedure 
FUNCTION pageNRequiredPages RETURNS CHARACTER
    ( INPUT piPageNum    AS INTEGER ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns a comma-separated list of the pages linked to the             
            specified page for this container.
   Params:  <none>
    Notes:  * The RequiredPages attribute is stored as a series of pipe-delimiter
              lists of page numbers, including one for page zero. 
            * There will always be one more entry in the property than there are 
              pages on the container.
------------------------------------------------------------------------------*/
    DEFINE VARIABLE cAllRequiredPages    AS CHARACTER                     NO-UNDO.
    DEFINE VARIABLE cRequiredPages       AS CHARACTER                     NO-UNDO.    
    
    /* Get all the linked pages. */
    {get RequiredPages cAllRequiredPages}.
        
    ASSIGN cRequiredPages = ENTRY(piPageNum + 1, cAllRequiredPages, "|":U) NO-ERROR.
    
    RETURN cRequiredPages.
END FUNCTION.    /* pageNRequiredPages */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-pageNTargets) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION pageNTargets Procedure 
FUNCTION pageNTargets RETURNS CHARACTER
  ( phTarget AS HANDLE, piPageNum AS INTEGER ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns a comma-separated list of the objects on the 
            specified page for this container.
   Params:  <none>
    Notes:  This attribute is stored as a comma-separated list of entries, where
            each entry consists of an object handle (in string form) and its
            page number, separated by a vertical bar.
            The Target-Procedure is passed as a parameter because this function
            is only invoked locally, not IN the Target-procedure.
            This function is intended to be used only internally by the ADM
            paging code. 
         -  This function is not always called in TARGET-PROCEDURE, so all 
            get and set must use the phTarget  
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cPageN      AS CHARACTER NO-UNDO.
  DEFINE VARIABLE iObj        AS INTEGER   NO-UNDO.
  DEFINE VARIABLE cTargets    AS CHARACTER NO-UNDO INIT "":U.
  DEFINE VARIABLE cEntry      AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cAllTargets AS CHARACTER NO-UNDO.
  
  /* For page 0 we remove paged objects from the containertarget property*/
  IF piPageNum = 0 THEN
    {get ContainerTarget cTargets phTarget}.

  {get PageNTarget cPageN phTarget}.
  DO iObj = 1 TO NUM-ENTRIES(cPageN):
    cEntry = ENTRY(iObj, cPageN).
    IF piPageNum = 0 THEN 
       cTargets = DYNAMIC-FUNCTION('deleteEntry':U IN phTarget,
                                    LOOKUP(ENTRY(1,cEntry,"|":U),cTargets),
                                    cTargets,
                                    ',').
    ELSE                    
    IF INT(ENTRY(2, cEntry, "|":U)) = piPageNum THEN
      cTargets = cTargets + (IF cTargets = "":U THEN "":U ELSE ",":U)
        + ENTRY(1, cEntry, "|":U).

  END.
  
  RETURN cTargets.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-registerAppService) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION registerAppService Procedure 
FUNCTION registerAppService RETURNS LOGICAL
  ( pcAppService AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE lDataContainer        AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cContainedAppservices AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hSource               AS HANDLE     NO-UNDO.
  DEFINE VARIABLE lOk                   AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lSourceOk             AS LOGICAL    NO-UNDO.

  {get DataContainer lDataContainer}.
  IF lDataContainer THEN
  DO:
    {get ContainedAppservices cContainedAppservices}.
    IF NOT CAN-DO(cContainedAppservices,pcAppservice) THEN
    DO:
      cContainedAppservices = cContainedAppservices
                            + (IF cContainedAppservices = '':U THEN '':U ELSE ',':U)
                            + pcAppService.
      {set ContainedAppservices cContainedAppservices}.
    END.
    lOk = TRUE.
  END.
  
  {get ContainerSource hsource}.
  IF VALID-HANDLE(hSource) THEN
    lSourceOK = {fnarg registerAppService pcAppService hSource}.
  
  RETURN lOk OR lSourceOk.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setCallerObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setCallerObject Procedure 
FUNCTION setCallerObject RETURNS LOGICAL
  ( h AS HANDLE ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

{set CallerObject h}.
RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setCallerProcedure) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setCallerProcedure Procedure 
FUNCTION setCallerProcedure RETURNS LOGICAL
  ( h AS HANDLE ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

{set CallerProcedure h}.
RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setCallerWindow) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setCallerWindow Procedure 
FUNCTION setCallerWindow RETURNS LOGICAL
  ( h AS HANDLE ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

{set CallerWindow h}.
RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setClientNames) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setClientNames Procedure 
FUNCTION setClientNames RETURNS LOGICAL
  ( pcClientNames AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Sets the list of ClientNames, which is a list that corresponds 
            to InstanceNames, with the proxy's ObjectName on the client.
    Notes:  See getClientNames.                   
Note date: 2002/02/16                        
-----------------------------------------------------------------------------*/
  {set ClientNames pcClientNames}.
  
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setCommitSource) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setCommitSource Procedure 
FUNCTION setCommitSource RETURNS LOGICAL
  ( phSource AS HANDLE ) :
/*------------------------------------------------------------------------------
   Purpose: Set the CommitSource. Used for pass-thru for regular 
            containers, but also inherited by the SBO that uses it for 'real'. 
   Params:  <none>
   Note:    xp not defined because the sbo needs logic in override. 
                 (set AutoCommit) 
------------------------------------------------------------------------------*/
  &SCOPED-DEFINE xpCommitSource  
  {set CommitSource phSource}.
  &UNDEFINE xpCommitSource 
  
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setCommitSourceEvents) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setCommitSourceEvents Procedure 
FUNCTION setCommitSourceEvents RETURNS LOGICAL
  ( pcSourceEvents AS CHAR) :
/*------------------------------------------------------------------------------
   Purpose: Set the CommitSourceEvents. Used for pass-thru for regular 
            containers, but also inherited by the SBO that uses it for 'real'. 
   Params:  <none>
   Notes:   We define this function and property in the container because we 
            currently keep the link and event properties together..          
------------------------------------------------------------------------------*/
  {set CommitSourceEvents pcSourceEvents}.
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setCommitTarget) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setCommitTarget Procedure 
FUNCTION setCommitTarget RETURNS LOGICAL
  ( phTarget AS HANDLE ) :
/*------------------------------------------------------------------------------
   Purpose: Set the CommitTarget. Used for pass-thru purposes. 
   Params:  <none>
------------------------------------------------------------------------------*/
  {set CommitTarget phTarget}.
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setCommitTargetEvents) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setCommitTargetEvents Procedure 
FUNCTION setCommitTargetEvents RETURNS LOGICAL
  ( pcTargetEvents AS CHAR ) :
/*------------------------------------------------------------------------------
   Purpose: Set the CommitTargetEvents. 
   Params:  <none>
   Notes:  Commit is a pass-thru link, this property is here because we 
           currently keep the link and event properties together..   
------------------------------------------------------------------------------*/
  {set CommitTargetEvents pcTargetEvents}.
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setContainedAppServices) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setContainedAppServices Procedure 
FUNCTION setContainedAppServices RETURNS LOGICAL
  ( pcAppServices AS CHARACTER  ) :
/*------------------------------------------------------------------------------
  Purpose:  Set the list of the Appservices of the Data Objects contained
            in this container.
    Params: <none>
    Notes:  The container class uses this to manage dataobjects in 
            the stateless server side APIs. 
------------------------------------------------------------------------------*/
  {set ContainedAppServices pcAppServices}.
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setContainedDataObjects) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setContainedDataObjects Procedure 
FUNCTION setContainedDataObjects RETURNS LOGICAL
  ( pcObjects AS CHARACTER  ) :
/*------------------------------------------------------------------------------
  Purpose:  Set the list of the handles of the Data Objects contained
            in this container.
    Params: <none>
    Notes:  The container class uses this to keep track of the dataobjects in 
            the stateless server side APIs. 
            The sbo class uses it on both client and server in almost all logic
            also at design time to get names and column lists from the 
            individual Data Objects.            
------------------------------------------------------------------------------*/
  {set ContainedDataObjects pcObjects}.
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setContainerMode) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setContainerMode Procedure 
FUNCTION setContainerMode RETURNS LOGICAL
  ( cContainerMode AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose: The ContainerMode property is used during initialization after that 
           it is read from the 'primary' viewer.  
    Notes: 
------------------------------------------------------------------------------*/    
   &SCOPED-DEFINE xpContainerMode
   {set ContainerMode cContainerMode}.
   &UNDEFINE xpContainerMode
   
   RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setContainerTarget) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setContainerTarget Procedure 
FUNCTION setContainerTarget RETURNS LOGICAL
  ( pcObject AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Sets the ContainerTarget link value.
   Params:  pcObject AS CHARACTER -- handle or handles of the objects which
              should be made Container-Targets of this object.
    Notes:  Because the value can be a list, it should be modified using
             modifyListProperty, and is normally maintained by addLink.
------------------------------------------------------------------------------*/

  {set ContainerTarget pcObject}.
  RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setContainerToolbarSource) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setContainerToolbarSource Procedure 
FUNCTION setContainerToolbarSource RETURNS LOGICAL
  ( pcTarget AS CHARACTER) :
/*------------------------------------------------------------------------------
  Purpose:  sets the handle(s) of the object's containertoolbar-source.
   Params:   
    Notes:   
------------------------------------------------------------------------------*/
  {set ContainerToolbarSource pcTarget}.
  RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setContainerToolbarSourceEvents) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setContainerToolbarSourceEvents Procedure 
FUNCTION setContainerToolbarSourceEvents RETURNS LOGICAL
  ( pcEvents AS CHARACTER  ) :
/*------------------------------------------------------------------------------
  Purpose:  Sets the list of events to be subscribed to in the
            ContainerToolbar-Source.  
   Params:  <none>
    Notes:             
------------------------------------------------------------------------------*/
  {set ContainerToolbarSourceEvents pcEvents}.
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setCurrentLogicalName) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setCurrentLogicalName Procedure 
FUNCTION setCurrentLogicalName RETURNS LOGICAL
        ( input pcObjectName as character ):
/*------------------------------------------------------------------------------
  Purpose:  Used by the repository bootstrapping mechanism.
        Notes:
------------------------------------------------------------------------------*/
    gcCurrentObjectName = pcObjectName.
    return true.
END FUNCTION.    /* setCurrentLogicalName */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setCurrentPage) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setCurrentPage Procedure 
FUNCTION setCurrentPage RETURNS LOGICAL
  ( iPage AS INTEGER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    {set CurrentPage iPage}.
    RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setDataContainer) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setDataContainer Procedure 
FUNCTION setDataContainer RETURNS LOGICAL
  ( plDataContainer AS LOG ) :
/*------------------------------------------------------------------------------
 Purpose: Set to true if this object can handle data requests for dbaware 
          objects or if this object defines the scope of requests for  
          non-dbaware objects. 
   Notes: See getDatacontainer 
------------------------------------------------------------------------------*/
  {set DataContainer plDataContainer}.
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setDataContainerName) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setDataContainerName Procedure 
FUNCTION setDataContainerName RETURNS LOGICAL
  ( pcName AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  The DataContainerName is passed to getManagerHandle to start the 
            DataContainer for an instance. 
    Notes:  The DataContainer and the Service Adapter has a one-to-one 
            relationship. This property allows applications to run in the same 
            session with separate Service Adapters. 
            This might be necessary if Business Entity references need 
            different namepaces because the applications have been developed 
            separately.
          - Duplicated in dataview.p 
------------------------------------------------------------------------------*/
  {set DataContainerName pcName}.
  RETURN true.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setDisabledAddModeTabs) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setDisabledAddModeTabs Procedure 
FUNCTION setDisabledAddModeTabs RETURNS LOGICAL
  ( cDisabledAddModeTabs AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    {set DisabledAddModeTabs cDisabledAddModeTabs}.
    RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setDynamicSDOProcedure) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setDynamicSDOProcedure Procedure 
FUNCTION setDynamicSDOProcedure RETURNS LOGICAL
  ( pcProc AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Sets the name of the dynamic SDO procedure, 'adm2/dyndata.w'
            by default (can be modified if the dynamic SDO is customized).
   Params:  pcProc AS CHARACTER -- name of the .w to run in place of
            'adm2/dyndata.w'
------------------------------------------------------------------------------*/

  {set DynamicSDOProcedure pcProc}.
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setFilterSource) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setFilterSource Procedure 
FUNCTION setFilterSource RETURNS LOGICAL
  ( phObject AS HANDLE ) :
/*------------------------------------------------------------------------------
  Purpose:  Sets the FilterSource link value.
   Params:  phObject AS HANDLE
------------------------------------------------------------------------------*/

  {set FilterSource phObject}.
  RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setHasDbAwareObjects) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setHasDbAwareObjects Procedure 
FUNCTION setHasDbAwareObjects RETURNS LOGICAL
  ( plDbObjects AS LOGICAL ) :
/*------------------------------------------------------------------------------
  Purpose: Tells whether the container has DbAware data objects.
    Notes: The container's data objects are either all DbAware or all not 
           DbAware. 
           SDOs and SBOs are DbAware and are managed differently than 
           DataViews who are not DbAware.     
        -  The property name is somewhat misleading/inconsistent, since it is not 
           reflecting the DBAware property of the contained instances. 
           TT based SDOs may have their instance DBAware set to false, but is 
           still considered as DBAware in this context.                        
------------------------------------------------------------------------------*/
 {set HasDbAwareObjects plDbObjects}.
 RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setHasDynamicProxy) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setHasDynamicProxy Procedure 
FUNCTION setHasDynamicProxy RETURNS LOGICAL
  ( plProxy AS LOGICAL ) :
/*------------------------------------------------------------------------------
  Purpose: Set to true when the container has a dynamic client proxy. 
    Notes: Maintained from constructObject. 
------------------------------------------------------------------------------*/
 DEFINE VARIABLE lProxy AS LOGICAL    NO-UNDO.
 {set HasDynamicProxy plProxy}.
 RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setHasObjectMenu) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setHasObjectMenu Procedure 
FUNCTION setHasObjectMenu RETURNS LOGICAL
  ( plObjectHasMenus AS LOGICAL ) :
/*------------------------------------------------------------------------------
  Purpose: Set to true when an object has menus linked to it. 
    Notes:  
------------------------------------------------------------------------------*/
 {set HasObjectMenu plObjectHasMenus}.
 RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setHideChildContainersOnClose) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setHideChildContainersOnClose Procedure 
FUNCTION setHideChildContainersOnClose RETURNS LOGICAL
  ( plHideChildContainersOnClose AS LOGICAL ) :
/*------------------------------------------------------------------------------
  Purpose: Set to TRUE when the container's child containers should only be 
           hidden when closed. Mostly used for containers launched in the 
           Dynamic TreeView object.
    Notes:  
------------------------------------------------------------------------------*/
 {set HideChildContainersOnClose plHideChildContainersOnClose}.
 RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setHideOnClose) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setHideOnClose Procedure 
FUNCTION setHideOnClose RETURNS LOGICAL
  ( plHideOnClose AS LOGICAL ) :
/*------------------------------------------------------------------------------
  Purpose: Set to TRUE when the container should only be hidden when closed. 
    Notes:  
------------------------------------------------------------------------------*/
 {set HideOnClose plHideOnClose}.
 RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setInitialPageList) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setInitialPageList Procedure 
FUNCTION setInitialPageList RETURNS LOGICAL
  ( pcPageList AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Sets the comma delimited list of pages to construct at startup. A 
            special value of * will indicate all pages must be initialised at
            startup.
   Params:  pcPageList AS CHARACTER -- comma delimited list of pages or * for all
------------------------------------------------------------------------------*/

  {set InitialPageList pcPageList}.
  RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setInMessageTarget) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setInMessageTarget Procedure 
FUNCTION setInMessageTarget RETURNS LOGICAL
  ( phObject AS HANDLE ) :
/*------------------------------------------------------------------------------
  Purpose:  Sets the InMessageTarget link value.
   Params:  phObject AS HANDLE
------------------------------------------------------------------------------*/

  {set InMessageTarget phObject}.
  RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setInstanceNames) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setInstanceNames Procedure 
FUNCTION setInstanceNames RETURNS LOGICAL
  ( pcNames AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Sets the ordered list of ObjectNames of ContainerTargets.
    Notes:  This is used to enforce unique instance names in the container and
            is updated in constructObject and destroyObject together with 
            the container link.
          - This is needed in order for containedProperties and 
            assignContainedProperties to work together. 
          - The list is in ContainerTarget order and each name is currently 
            also stored in each object's ObjectName property. The name 
            InstanceNames were still chosen instead of basing the name of any 
            of these properties as this is more true to the nature of this 
            property. 
Note date: 2002/02/08      
------------------------------------------------------------------------------*/
  {set InstanceNames pcNames}.
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setMultiInstanceActivated) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setMultiInstanceActivated Procedure 
FUNCTION setMultiInstanceActivated RETURNS LOGICAL
  ( lMultiInstanceActivated AS LOGICAL) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    {set MultiInstanceActivated lMultiInstanceActivated}.
    RETURN TRUE.
                                                             
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setMultiInstanceSupported) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setMultiInstanceSupported Procedure 
FUNCTION setMultiInstanceSupported RETURNS LOGICAL
  ( lMultiInstanceSupported AS LOGICAL) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    {set MultiInstanceSupported lMultiInstanceSupported}.
    RETURN TRUE.
                                                             
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setNavigationSource) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setNavigationSource Procedure 
FUNCTION setNavigationSource RETURNS LOGICAL
  ( pcSource AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose: Set the NavigationSource. Used for pass-thru for regular 
           containers, but also inherited by the SBO that uses it for 'real'.  
Parameters: PcSource -  Because multiple Navigation-Sources are supported, 
                        this is a comma-separated list of strings.
    Notes:                    
------------------------------------------------------------------------------*/
  {set NavigationSource pcSource}.
  RETURN TRUE. 
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setNavigationSourceEvents) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setNavigationSourceEvents Procedure 
FUNCTION setNavigationSourceEvents RETURNS LOGICAL
  ( pcEvents AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Sets the list of events to be subscribed to in the
            Navigation Panel or other Navigation-Source.
   Params:  pcEvents - List of events that addLink will subscribe to
------------------------------------------------------------------------------*/
  {set NavigationSourceEvents pcEvents}.
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setNavigationTarget) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setNavigationTarget Procedure 
FUNCTION setNavigationTarget RETURNS LOGICAL
  ( cTarget AS CHARACTER) :
/*------------------------------------------------------------------------------
  Purpose: supported for pass-thru  
    Notes:  
------------------------------------------------------------------------------*/
 {set NavigationTarget cTarget}.
  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setOutMessageTarget) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setOutMessageTarget Procedure 
FUNCTION setOutMessageTarget RETURNS LOGICAL
  ( phObject AS HANDLE ) :
/*------------------------------------------------------------------------------
  Purpose:  Sets the OutMessageTarget link value.
   Params:  phObject AS HANDLE
------------------------------------------------------------------------------*/

  {set OutMessageTarget phObject}.
  RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setPage0LayoutManager) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setPage0LayoutManager Procedure 
FUNCTION setPage0LayoutManager RETURNS LOGICAL
        ( INPUT pcPage0LayoutManager    AS CHARACTER ):
/*------------------------------------------------------------------------------
  Purpose:  
        Notes:
------------------------------------------------------------------------------*/    
    {set Page0LayoutManager pcPage0LayoutManager}.
    
    RETURN TRUE.
END FUNCTION.   /* setPage0LayoutManager */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setPageLayoutInfo) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setPageLayoutInfo Procedure 
FUNCTION setPageLayoutInfo RETURNS LOGICAL
        ( INPUT pcPageLayoutInfo                AS CHARACTER ):
/*------------------------------------------------------------------------------
  Purpose:  
        Notes:
------------------------------------------------------------------------------*/
        &SCOPED-DEFINE xpPageLayoutInfo
        {set PageLayoutInfo pcPageLayoutInfo}.
        &UNDEFINE xpPageLayoutInfo

        RETURN TRUE.
END FUNCTION.   /* setPageLayoutInfo */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setPageNTarget) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setPageNTarget Procedure 
FUNCTION setPageNTarget RETURNS LOGICAL
  ( pcObject AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Sets the PageNTarget link value.
   Params:  pcObject AS CHARACTER -- specially formatted list of objects and
              the pages they are on.
------------------------------------------------------------------------------*/

  {set PageNTarget pcObject}.
  RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setPageSource) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setPageSource Procedure 
FUNCTION setPageSource RETURNS LOGICAL
  ( phObject AS HANDLE ) :
/*------------------------------------------------------------------------------
  Purpose:  Sets the PageSource link value.
   Params:  phObject AS HANDLE
------------------------------------------------------------------------------*/

  {set PageSource phObject}.
  RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setPageTokens) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setPageTokens Procedure 
FUNCTION setPageTokens RETURNS LOGICAL
    ( input pcPageTokens    as character  ):
/*------------------------------------------------------------------------------
  Purpose:  
        Notes:
------------------------------------------------------------------------------*/
    {set PageTokens pcPageTokens}.
    
    error-status:error = no.
    return true.
END FUNCTION.    /* setPageTokens */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setPendingPage) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setPendingPage Procedure 
FUNCTION setPendingPage RETURNS LOGICAL
  ( piPendingPage AS INTEGER ) :
/*------------------------------------------------------------------------------
  Purpose:  Sets the Pending page number of the Container. This is set 
            immediately in SelectPage so that objects on hide can check 
            what will become the new page before CurrentPage is set. 
            This was specifically implemented so that hideObject -> linkState 
            could avoid disabling links for objects that are going to become 
            viewed. 
    Notes:  Should only be set by containr. 
------------------------------------------------------------------------------*/
  {set PendingPage piPendingPage}.
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setPrimarySdoTarget) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setPrimarySdoTarget Procedure 
FUNCTION setPrimarySdoTarget RETURNS LOGICAL
  ( hPrimarySdoTarget AS HANDLE ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    {set PrimarySdoTarget hPrimarySdoTarget}.
    RETURN TRUE.                               
  

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setReEnableDataLinks) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setReEnableDataLinks Procedure 
FUNCTION setReEnableDataLinks RETURNS LOGICAL
  ( cReEnableDataLinks AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    {set ReEnableDataLinks cReEnableDataLinks}.
    RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setRemoveMenuOnHide) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setRemoveMenuOnHide Procedure 
FUNCTION setRemoveMenuOnHide RETURNS LOGICAL
  ( plRemoveMenu AS LOG ) :
/*------------------------------------------------------------------------------
 Purpose: Decides whether the the menus should be removed from the menubar 
          on hide of the toolbar. 
 Parameters: INPUT plRemove 
     Notes:
------------------------------------------------------------------------------*/
  {set RemoveMenuOnhide plRemoveMenu}.
  RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setRequiredPages) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setRequiredPages Procedure 
FUNCTION setRequiredPages RETURNS LOGICAL
    ( INPUT pcRequiredPages     AS CHARACTER):
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:
------------------------------------------------------------------------------*/
    {set RequiredPages pcRequiredPages}.
    
    RETURN TRUE.
END FUNCTION.    /* setRequiredPages */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setRouterTarget) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setRouterTarget Procedure 
FUNCTION setRouterTarget RETURNS LOGICAL
  ( phObject AS HANDLE ) :
/*------------------------------------------------------------------------------
  Purpose:  Sets the RouterTarget link value.
   Params:  phObject AS HANDLE
------------------------------------------------------------------------------*/

  {set RouterTarget phObject}.
  RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setRunDOOptions) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setRunDOOptions Procedure 
FUNCTION setRunDOOptions RETURNS LOGICAL
  ( pcOptions AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Sets the RunDOOptions property value.
   Params:  pcOptions AS CHARACTER
------------------------------------------------------------------------------*/

  {set RunDOOptions pcOptions}.
  RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setRunMultiple) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setRunMultiple Procedure 
FUNCTION setRunMultiple RETURNS LOGICAL
  ( plMultiple AS LOGICAL ) :
/*------------------------------------------------------------------------------
  Purpose:  Sets the DataTarget property that decides 
   Params:  plMultiple AS LOGICAL
------------------------------------------------------------------------------*/

  {set RunMultiple plMultiple}.
  RETURN TRUE.


END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setSavedContainerMode) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setSavedContainerMode Procedure 
FUNCTION setSavedContainerMode RETURNS LOGICAL
  ( cSavedContainerMode AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    {set SavedContainerMode cSavedContainerMode}.
    RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setSdoForeignFields) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setSdoForeignFields Procedure 
FUNCTION setSdoForeignFields RETURNS LOGICAL
  ( cSdoForeignFields AS CHARACTER) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    {set SdoForeignFields cSdoForeignFields}.
    RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setStatusArea) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setStatusArea Procedure 
FUNCTION setStatusArea RETURNS LOGICAL
  (plStatusArea AS LOGICAL) :
/*------------------------------------------------------------------------------
  Purpose:  Allows for the setting of the status area for a container
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hContainer AS HANDLE NO-UNDO.
  
  {get ContainerHandle hContainer}.
  IF VALID-HANDLE(hContainer)              AND
     CAN-QUERY(hContainer,"status-area":U) AND
     plStatusArea = TRUE                   THEN
    hContainer:STATUS-AREA = plStatusArea.
  
  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setStatusDefault) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setStatusDefault Procedure 
FUNCTION setStatusDefault RETURNS LOGICAL
  (pcStatusDefault AS CHARACTER) :
/*------------------------------------------------------------------------------
  Purpose:  Allows the user to sets the STATUS DEFAULT for the window's
            STATUS-AREA
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hContainer  AS HANDLE     NO-UNDO.

  {get ContainerHandle hContainer}.

  IF VALID-HANDLE(hContainer) 
    AND hContainer:TYPE = "Window":U
    THEN
    STATUS DEFAULT pcStatusDefault IN WINDOW hContainer.
  ELSE
    RETURN FALSE.   /* Function return value. */
    
  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setStatusInput) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setStatusInput Procedure 
FUNCTION setStatusInput RETURNS LOGICAL
  (pcStatusInput AS CHARACTER) :
/*------------------------------------------------------------------------------
  Purpose:  Allows the user to sets the STATUS INPUT for the window's
            STATUS-AREA
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hContainer  AS HANDLE     NO-UNDO.

  {get ContainerHandle hContainer}.

  IF VALID-HANDLE(hContainer) THEN
    STATUS DEFAULT pcStatusInput IN WINDOW hContainer.
  ELSE
    RETURN FALSE.   /* Function return value. */

  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setStatusInputOff) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setStatusInputOff Procedure 
FUNCTION setStatusInputOff RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  Allows the user to sets the STATUS INPUT off for the window's
            STATUS-AREA
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hContainer  AS HANDLE     NO-UNDO.

  {get ContainerHandle hContainer}.

  IF VALID-HANDLE(hContainer) THEN
    STATUS INPUT OFF IN WINDOW hContainer.
  ELSE
    RETURN FALSE.   /* Function return value. */

  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setTopOnly) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setTopOnly Procedure 
FUNCTION setTopOnly RETURNS LOGICAL
    (plTopOnly AS LOGICAL):
/*------------------------------------------------------------------------------
  Purpose:     Set window to top only (toggle)
  Parameters:  input logical of yes / no for what to set it to.
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE hContainer AS HANDLE NO-UNDO.

{get ContainerHandle hContainer}.
IF VALID-HANDLE(hContainer) AND CAN-QUERY(hContainer,"top-only":U) THEN
  hContainer:TOP-ONLY = plTopOnly.

RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setUpdateActive) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setUpdateActive Procedure 
FUNCTION setUpdateActive RETURNS LOGICAL
  ( plActive AS LOGICAL ) :
/*------------------------------------------------------------------------------
  Purpose: Set to true if ANY of the contained object's have active updates  
    Notes: Not intended for manual update !! 
           These are the steps involved to set this property :
         - 1. Updating objects publishes 'updateActive' (true or false) to their 
              container targets. (from setDataModified, setNewRecord or 
              setRowObjectState).
           2. If the value is FALSE updateActive turns around and publishes 
              'isUpdateActive', which checks properties involved, to ALL 
              ContainerTargets before it is stored in the UpdateActive property.
              This way the value is only FALSE if ALL contained objects are 
              inactive. (Well, at least that's what we think...  ) 
          - All participating events including okObject and okCancel is bound
            within a window container.       
------------------------------------------------------------------------------*/
  {set UpdateActive plActive}.

  RETURN TRUE.  

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setUpdateSource) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setUpdateSource Procedure 
FUNCTION setUpdateSource RETURNS LOGICAL
  ( pcSource AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Sets the handle of the object's Update-Source
   Params:  pcSource AS CHARACTER -- may be multiple for SBOs, e.g.
    Notes:  This is used for pass-through links, to connect an object
            inside the container with an object outside the container.
------------------------------------------------------------------------------*/

  {set UpdateSource pcSource}.
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setUpdateTarget) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setUpdateTarget Procedure 
FUNCTION setUpdateTarget RETURNS LOGICAL
  ( pcTarget AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Sets the handle of the object's Update-Target.
   Params:  pcTarget AS CHARACTER -- handle in character form
    Notes:  This is used for pass-through links, to connect an object
            inside the container with an object outside the container.
------------------------------------------------------------------------------*/

  {set UpdateTarget pcTarget}.
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setWaitForObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setWaitForObject Procedure 
FUNCTION setWaitForObject RETURNS LOGICAL
  ( phObject AS HANDLE ) :
/*------------------------------------------------------------------------------
  Purpose:  Sets the WaitForObject value
   Params:  phObject AS HANDLE
------------------------------------------------------------------------------*/

  {set WaitForObject phObject}.
  RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setWidgetIDFileName) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setWidgetIDFileName Procedure 
FUNCTION setWidgetIDFileName RETURNS LOGICAL
        (INPUT pcWidgetIDFileName AS CHARACTER):
/*------------------------------------------------------------------------------
    Purpose:
    Notes:
------------------------------------------------------------------------------*/
{set WidgetIDFileName pcWidgetIDFileName}.
RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setWindowFrameHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setWindowFrameHandle Procedure 
FUNCTION setWindowFrameHandle RETURNS LOGICAL
  ( phFrame AS HANDLE) :
/*------------------------------------------------------------------------------
  Purpose: Store the optional frame of a Window container 
    Notes: The somewhat strange name is used because this property ONLY  
           identifies the frame of a window container and must not be 
           confused with the important ContainerHandle, which is the
           widget handle of the container in all objects and in most cases 
           stores the frame handle.(Also for a windowless SmartContainer)  
         - Even if Window containers does not need a frame they often has one
           and in that case we must include it in for example resizing or 
           widget-tree logic etc...  
      ------ Why not resolve this at run time in the windows widget-tree ---- 
         1.All SmartObject's frames are also in the widget tree of the container, 
           and although these frames could be checked through the 
           containerTargets it's also possible that secondary frames exists 
           both in this container or in child SmartObjects.  
         2. Frame Z-order changes when a frame is viewed !!!            
------------------------------------------------------------------------------*/
 {set WindowFrameHandle phFrame}.
 RETURN TRUE.   

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setWindowName) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setWindowName Procedure 
FUNCTION setWindowName RETURNS LOGICAL
  ( INPUT pcWindowName  AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Sets the window title of a window.
    Notes:  * WindowName is not a property for all containers. It is not even 
              a property for all windows. The setting of this value as a property
              is dealt with by the dynamic container rendering, in Dynamics.
------------------------------------------------------------------------------*/
  define variable hWindow                    as handle                no-undo.
  define variable lSetTitle                  as logical               no-undo.
  
  {get ContainerHandle hWindow}.      
  if valid-handle(hWindow) 
  and (hWindow:type = 'WINDOW':U or hWindow:type = 'DIALOG-BOX':U ) then
    assign lSetTitle = yes
           hWindow:title = pcWindowName.
  
  return lSetTitle.

END FUNCTION.   /* setWindowName */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setWindowTitleViewer) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setWindowTitleViewer Procedure 
FUNCTION setWindowTitleViewer RETURNS LOGICAL
  ( phViewer AS HANDLE ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

{set WindowTitleViewer phViewer}.
RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-targetPage) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION targetPage Procedure 
FUNCTION targetPage RETURNS INTEGER
  ( phObject AS HANDLE ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the page number of an object
    Notes:    
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cTargets  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iObj      AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cEntry    AS CHARACTER  NO-UNDO.

  {get PageNTarget cTargets}.
  DO iObj = 1 TO NUM-ENTRIES(cTargets):
    cEntry = ENTRY(iObj, cTargets).
    /* return the page immediately when found */ 
    IF ENTRY(1, cEntry, "|":U) = STRING(phObject) THEN
       RETURN INTEGER(ENTRY(2, cEntry, "|":U)).
    
  END.
  
  /* If not on a page check if its a containertarget at all and return ? 
     it if isn't */

  {get ContainerTarget cTargets}.
  
  RETURN IF CAN-DO(cTargets,STRING(phObject)) 
         THEN 0 
         ELSE ?.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

