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
    File        : browser.p
    Purpose     : Super procedure for SmartDataBrowser objects

    Syntax      : adm2/browser.p
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

  /* This is needed by some procedures so that another procedure we call
     can identify what the original TARGET-PROCEDURE is. The value is 
     returned by getTargetProcedure. */
  DEFINE VARIABLE ghTargetProcedure AS HANDLE NO-UNDO.
                                                                 
  /* Browser fixed sizes in decimals (600X800 - 1280X1024) */
  &scop browseborderwidth   4.6
  &scop browserowmarkerwidth  2.0
  &scop browsedividerwidth  0.8
 
/* Tell brsattr.i that this is the Super procedure. */
   &SCOP ADMSuper browser.p

  {src/adm2/custom/browserexclcustom.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-adjustVisibleRowids) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD adjustVisibleRowids Procedure 
FUNCTION adjustVisibleRowids RETURNS LOGICAL
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-calculateDownHeight) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD calculateDownHeight Procedure 
FUNCTION calculateDownHeight RETURNS DECIMAL
  ( piNumDown as integer )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-calculateMaxWidth) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD calculateMaxWidth Procedure 
FUNCTION calculateMaxWidth RETURNS DECIMAL
  (  )  FORWARD.

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

&IF DEFINED(EXCLUDE-destroyBrowse) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD destroyBrowse Procedure 
FUNCTION destroyBrowse RETURNS LOGICAL
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fieldSecurityRule) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fieldSecurityRule Procedure 
FUNCTION fieldSecurityRule RETURNS CHARACTER
  ( phWidget AS HANDLE )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getActionEvent) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getActionEvent Procedure 
FUNCTION getActionEvent RETURNS CHARACTER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getApplyActionOnExit) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getApplyActionOnExit Procedure 
FUNCTION getApplyActionOnExit RETURNS LOGICAL
  ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getApplyExitOnAction) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getApplyExitOnAction Procedure 
FUNCTION getApplyExitOnAction RETURNS LOGICAL
  ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getBGColor) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getBGColor Procedure 
FUNCTION getBGColor RETURNS INTEGER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getBrowseColumnAutoCompletions) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getBrowseColumnAutoCompletions Procedure 
FUNCTION getBrowseColumnAutoCompletions RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getBrowseColumnBGColors) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getBrowseColumnBGColors Procedure 
FUNCTION getBrowseColumnBGColors RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getBrowseColumnDelimiters) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getBrowseColumnDelimiters Procedure 
FUNCTION getBrowseColumnDelimiters RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getBrowseColumnFGColors) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getBrowseColumnFGColors Procedure 
FUNCTION getBrowseColumnFGColors RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getBrowseColumnFonts) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getBrowseColumnFonts Procedure 
FUNCTION getBrowseColumnFonts RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getBrowseColumnInnerLines) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getBrowseColumnInnerLines Procedure 
FUNCTION getBrowseColumnInnerLines RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getBrowseColumnItemPairs) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getBrowseColumnItemPairs Procedure 
FUNCTION getBrowseColumnItemPairs RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getBrowseColumnItems) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getBrowseColumnItems Procedure 
FUNCTION getBrowseColumnItems RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getBrowseColumnLabelBGColors) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getBrowseColumnLabelBGColors Procedure 
FUNCTION getBrowseColumnLabelBGColors RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getBrowseColumnLabelFGColors) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getBrowseColumnLabelFGColors Procedure 
FUNCTION getBrowseColumnLabelFGColors RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getBrowseColumnLabelFonts) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getBrowseColumnLabelFonts Procedure 
FUNCTION getBrowseColumnLabelFonts RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getBrowseColumnLabels) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getBrowseColumnLabels Procedure 
FUNCTION getBrowseColumnLabels RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getBrowseColumnMaxChars) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getBrowseColumnMaxChars Procedure 
FUNCTION getBrowseColumnMaxChars RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getBrowseColumnSorts) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getBrowseColumnSorts Procedure 
FUNCTION getBrowseColumnSorts RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getBrowseColumnTypes) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getBrowseColumnTypes Procedure 
FUNCTION getBrowseColumnTypes RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getBrowseColumnUniqueMatches) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getBrowseColumnUniqueMatches Procedure 
FUNCTION getBrowseColumnUniqueMatches RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getBrowseColumnWidths) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getBrowseColumnWidths Procedure 
FUNCTION getBrowseColumnWidths RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getBrowseHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getBrowseHandle Procedure 
FUNCTION getBrowseHandle RETURNS HANDLE
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getCalcWidth) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getCalcWidth Procedure 
FUNCTION getCalcWidth RETURNS LOGICAL
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getColumnsMovable) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getColumnsMovable Procedure 
FUNCTION getColumnsMovable RETURNS LOGICAL
  ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getColumnsSortable) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getColumnsSortable Procedure 
FUNCTION getColumnsSortable RETURNS LOGICAL
  ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDataObjectHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getDataObjectHandle Procedure 
FUNCTION getDataObjectHandle RETURNS HANDLE
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDataSignature) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getDataSignature Procedure 
FUNCTION getDataSignature RETURNS CHARACTER
  ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDefaultColumnData) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getDefaultColumnData Procedure 
FUNCTION getDefaultColumnData RETURNS CHARACTER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getFetchOnReposToEnd) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getFetchOnReposToEnd Procedure 
FUNCTION getFetchOnReposToEnd RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getFGColor) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getFGColor Procedure 
FUNCTION getFGColor RETURNS INTEGER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getFolderWindowToLaunch) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getFolderWindowToLaunch Procedure 
FUNCTION getFolderWindowToLaunch RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getFont) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getFont Procedure 
FUNCTION getFont RETURNS INTEGER
(  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getMaxWidth) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getMaxWidth Procedure 
FUNCTION getMaxWidth RETURNS DECIMAL
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getMovableHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getMovableHandle Procedure 
FUNCTION getMovableHandle RETURNS HANDLE
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getNumDown) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getNumDown Procedure 
FUNCTION getNumDown RETURNS INTEGER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getPopupActive) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getPopupActive Procedure 
FUNCTION getPopupActive RETURNS LOGICAL
  ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getQueryRowObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getQueryRowObject Procedure 
FUNCTION getQueryRowObject RETURNS HANDLE
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getSavedColumnData) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getSavedColumnData Procedure 
FUNCTION getSavedColumnData RETURNS CHARACTER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getScrollRemote) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getScrollRemote Procedure 
FUNCTION getScrollRemote RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getSearchField) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getSearchField Procedure 
FUNCTION getSearchField RETURNS CHARACTER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getSearchFieldMaxWidth) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getSearchFieldMaxWidth Procedure 
FUNCTION getSearchFieldMaxWidth RETURNS DECIMAL
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getSeparatorFGColor) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getSeparatorFGColor Procedure 
FUNCTION getSeparatorFGColor RETURNS INTEGER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getSeparators) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getSeparators Procedure 
FUNCTION getSeparators RETURNS LOGICAL
  ( ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getSortableHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getSortableHandle Procedure 
FUNCTION getSortableHandle RETURNS HANDLE
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getTargetProcedure) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getTargetProcedure Procedure 
FUNCTION getTargetProcedure RETURNS HANDLE
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getTooltip) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getTooltip Procedure 
FUNCTION getTooltip RETURNS CHARACTER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getUseSortIndicator) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getUseSortIndicator Procedure 
FUNCTION getUseSortIndicator RETURNS LOGICAL
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getVisibleRowids) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getVisibleRowids Procedure 
FUNCTION getVisibleRowids RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getVisibleRowReset) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getVisibleRowReset Procedure 
FUNCTION getVisibleRowReset RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-isOkToFetch) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD isOkToFetch Procedure 
FUNCTION isOkToFetch RETURNS LOGICAL
  (INPUT pcRequestedBatch AS CHAR  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-rowVisible) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD rowVisible Procedure 
FUNCTION rowVisible RETURNS CHARACTER
  ( INPUT pcRowids AS CHARACTER,
    INPUT phQryBuffer AS HANDLE )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setActionEvent) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setActionEvent Procedure 
FUNCTION setActionEvent RETURNS LOGICAL
  ( pcEvent AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setApplyActionOnExit) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setApplyActionOnExit Procedure 
FUNCTION setApplyActionOnExit RETURNS LOGICAL
  ( plApply AS LOG)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setApplyExitOnAction) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setApplyExitOnAction Procedure 
FUNCTION setApplyExitOnAction RETURNS LOGICAL
  ( plApply AS LOG)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setBGColor) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setBGColor Procedure 
FUNCTION setBGColor RETURNS LOGICAL
 ( piBGColor AS INTEGER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setBrowseColumnAutoCompletions) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setBrowseColumnAutoCompletions Procedure 
FUNCTION setBrowseColumnAutoCompletions RETURNS LOGICAL
  (  INPUT pcBrowseColumnAutoCompletions AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setBrowseColumnBGColors) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setBrowseColumnBGColors Procedure 
FUNCTION setBrowseColumnBGColors RETURNS LOGICAL
  ( INPUT pcBrowseColumnBGColors AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setBrowseColumnDelimiters) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setBrowseColumnDelimiters Procedure 
FUNCTION setBrowseColumnDelimiters RETURNS LOGICAL
  (  INPUT pcBrowseColumnDelimiters AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setBrowseColumnFGColors) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setBrowseColumnFGColors Procedure 
FUNCTION setBrowseColumnFGColors RETURNS LOGICAL
  ( INPUT pcBrowseColumnFGColors AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setBrowseColumnFonts) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setBrowseColumnFonts Procedure 
FUNCTION setBrowseColumnFonts RETURNS LOGICAL
  ( INPUT pcBrowseColumnFonts AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setBrowseColumnInnerLines) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setBrowseColumnInnerLines Procedure 
FUNCTION setBrowseColumnInnerLines RETURNS LOGICAL
  (  INPUT pcBrowseColumnInnerLines AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setBrowseColumnItemPairs) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setBrowseColumnItemPairs Procedure 
FUNCTION setBrowseColumnItemPairs RETURNS LOGICAL
  (  INPUT pcBrowseColumnItemPairs AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setBrowseColumnItems) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setBrowseColumnItems Procedure 
FUNCTION setBrowseColumnItems RETURNS LOGICAL
  (  INPUT pcBrowseColumnItems AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setBrowseColumnLabelBGColors) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setBrowseColumnLabelBGColors Procedure 
FUNCTION setBrowseColumnLabelBGColors RETURNS LOGICAL
  ( INPUT pcBrowseColumnLabelBGColors AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setBrowseColumnLabelFGColors) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setBrowseColumnLabelFGColors Procedure 
FUNCTION setBrowseColumnLabelFGColors RETURNS LOGICAL
  ( INPUT pcBrowseColumnLabelFGColors AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setBrowseColumnLabelFonts) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setBrowseColumnLabelFonts Procedure 
FUNCTION setBrowseColumnLabelFonts RETURNS LOGICAL
  (  INPUT pcBrowseColumnLabelFonts AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setBrowseColumnLabels) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setBrowseColumnLabels Procedure 
FUNCTION setBrowseColumnLabels RETURNS LOGICAL
  ( INPUT pcBrowseColumnLabels AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setBrowseColumnMaxChars) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setBrowseColumnMaxChars Procedure 
FUNCTION setBrowseColumnMaxChars RETURNS LOGICAL
  (  INPUT pcBrowseColumnMaxChars AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setBrowseColumnSorts) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setBrowseColumnSorts Procedure 
FUNCTION setBrowseColumnSorts RETURNS LOGICAL
  (  INPUT pcBrowseColumnSorts AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setBrowseColumnTypes) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setBrowseColumnTypes Procedure 
FUNCTION setBrowseColumnTypes RETURNS LOGICAL
  (  INPUT pcBrowseColumnTypes AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setBrowseColumnUniqueMatches) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setBrowseColumnUniqueMatches Procedure 
FUNCTION setBrowseColumnUniqueMatches RETURNS LOGICAL
  (  INPUT pcBrowseColumnUniqueMatches AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setBrowseColumnWidths) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setBrowseColumnWidths Procedure 
FUNCTION setBrowseColumnWidths RETURNS LOGICAL
  ( INPUT pcBrowseColumnWidths AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setCalcWidth) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setCalcWidth Procedure 
FUNCTION setCalcWidth RETURNS LOGICAL
  ( plCalcWidth AS LOGICAL )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setColumnsMovable) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setColumnsMovable Procedure 
FUNCTION setColumnsMovable RETURNS LOGICAL
  ( INPUT plMovable AS LOGICAL )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setColumnsSortable) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setColumnsSortable Procedure 
FUNCTION setColumnsSortable RETURNS LOGICAL
  ( INPUT plSortable AS LOGICAL )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setDataModified) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setDataModified Procedure 
FUNCTION setDataModified RETURNS LOGICAL
  ( lModified AS LOGICAL )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setDefaultColumnData) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setDefaultColumnData Procedure 
FUNCTION setDefaultColumnData RETURNS LOGICAL
  ( INPUT pcData AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setFetchOnReposToEnd) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setFetchOnReposToEnd Procedure 
FUNCTION setFetchOnReposToEnd RETURNS LOGICAL
  ( plFetchOnRepos AS LOG )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setFGColor) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setFGColor Procedure 
FUNCTION setFGColor RETURNS LOGICAL
   ( piFGColor AS INTEGER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setFolderWindowToLaunch) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setFolderWindowToLaunch Procedure 
FUNCTION setFolderWindowToLaunch RETURNS LOGICAL
  ( pcTemp AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setFont) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setFont Procedure 
FUNCTION setFont RETURNS LOGICAL
( piFont AS INTEGER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setMaxWidth) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setMaxWidth Procedure 
FUNCTION setMaxWidth RETURNS LOGICAL
  ( pdMaxWidth AS DECIMAL )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setMovableHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setMovableHandle Procedure 
FUNCTION setMovableHandle RETURNS LOGICAL
  ( INPUT phMovable AS HANDLE )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setNumDown) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setNumDown Procedure 
FUNCTION setNumDown RETURNS LOGICAL
  ( piNumDown AS INTEGER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setPopupActive) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setPopupActive Procedure 
FUNCTION setPopupActive RETURNS LOGICAL
  ( INPUT plActive AS LOGICAL )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setQueryRowObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setQueryRowObject Procedure 
FUNCTION setQueryRowObject RETURNS LOGICAL
  ( INPUT phQueryRowObject AS HANDLE )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setSavedColumnData) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setSavedColumnData Procedure 
FUNCTION setSavedColumnData RETURNS LOGICAL
  ( INPUT pcData AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setScrollRemote) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setScrollRemote Procedure 
FUNCTION setScrollRemote RETURNS LOGICAL
  ( INPUT plScrollRemote AS LOGICAL )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setSearchField) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setSearchField Procedure 
FUNCTION setSearchField RETURNS LOGICAL
  ( pcField AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setSeparatorFGColor) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setSeparatorFGColor Procedure 
FUNCTION setSeparatorFGColor RETURNS LOGICAL
    ( piSeparatorFGColor AS INTEGER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setSeparators) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setSeparators Procedure 
FUNCTION setSeparators RETURNS LOGICAL
  ( plSeparators AS LOGICAL )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setSort) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setSort Procedure 
FUNCTION setSort RETURNS LOGICAL
  ( pcColumnName  AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setSortableHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setSortableHandle Procedure 
FUNCTION setSortableHandle RETURNS LOGICAL
  ( INPUT phSortable AS HANDLE )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setTooltip) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setTooltip Procedure 
FUNCTION setTooltip RETURNS LOGICAL
  ( pcTooltip AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setUseSortIndicator) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setUseSortIndicator Procedure 
FUNCTION setUseSortIndicator RETURNS LOGICAL
  ( plUseSortIndicator AS LOGICAL )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setVisibleRowids) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setVisibleRowids Procedure 
FUNCTION setVisibleRowids RETURNS LOGICAL
  ( INPUT pcRowids AS CHARACTER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setVisibleRowReset) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setVisibleRowReset Procedure 
FUNCTION setVisibleRowReset RETURNS LOGICAL
  ( INPUT plReset AS LOGICAL )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-showSort) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD showSort Procedure 
FUNCTION showSort RETURNS LOGICAL
  ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-stripCalcs) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD stripCalcs Procedure 
FUNCTION stripCalcs RETURNS CHARACTER
  ( INPUT cClause AS CHARACTER )  FORWARD.

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
         HEIGHT             = 18.19
         WIDTH              = 59.8.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB Procedure 
/* ************************* Included-Libraries *********************** */

{src/adm2/brsprop.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */
&IF DEFINED(EXCLUDE-addRecord) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE addRecord Procedure 
PROCEDURE addRecord :
/*------------------------------------------------------------------------------
  Purpose:     SmartDataBrowser version of addRecord which inserts a new blank 
               row after the currently selected one if any.
  Parameters:  <none>
  Notes:       Initial values are not displayed here but from ROW-ENTRY trigger 
               (see brsentry.i).
------------------------------------------------------------------------------*/
   
   DEFINE VARIABLE hBrowse      AS HANDLE    NO-UNDO.
   DEFINE VARIABLE hFrame       AS HANDLE    NO-UNDO.
   DEFINE VARIABLE hSource      AS HANDLE    NO-UNDO.
   DEFINE VARIABLE hSearchField AS HANDLE    NO-UNDO.    
   DEFINE VARIABLE hQuery       AS HANDLE    NO-UNDO.

      RUN SUPER.
      IF RETURN-VALUE = "ADM-ERROR":U THEN RETURN "ADM-ERROR":U.
      
      /* Open up a slot for the new row. */
      &SCOPED-DEFINE xp-assign
      {get BrowseHandle hBrowse}
      {get TableIOSource hSource}
      {get SearchHandle hSearchField}.
      &UNDEFINE xp-assign
      /* If the Browse was not enabled (perhaps because it was empty),
         enable it. */
     
      IF hBrowse:READ-ONLY THEN
      DO:
        {get ContainerHandle hFrame}.
        APPLY "ENTRY":U TO hFrame.
        hBrowse:READ-ONLY = NO.
      END.
      ASSIGN
        hSearchField:SENSITIVE = NO WHEN VALID-HANDLE(hSearchField).
      hQuery = hBrowse:QUERY.
      IF NOT hQuery:IS-OPEN THEN
        hQuery:QUERY-OPEN.
      
      hBrowse:INSERT-ROW("AFTER":U).
      {set BrowseInitted NO}.    /* Signal for ROW-ENTRY trigger code */

    PUBLISH 'updateState':U FROM TARGET-PROCEDURE ('update').  
    RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-adjustReposition) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adjustReposition Procedure 
PROCEDURE adjustReposition :
/*------------------------------------------------------------------------------
  Purpose:   Adjust the browser's repositioning    
  Parameters:  <none>
  Notes:     Called from initializeObject, fetchDataSet('BatchEnd'), 
             resizeObject, onHome and onEnd to ensure that there are no blank 
             rows in the browser.  
           - Will retrieve data if necessary when FetchOnReposToEnd is true
           - uses browse num-entries and should only be called when refreshable
             (the logic that relies on checking if num-entries has changed 
              actually turns it off temporarily )    
------------------------------------------------------------------------------*/
DEFINE VARIABLE hDataSource      AS HANDLE     NO-UNDO.
DEFINE VARIABLE hDataQuery       AS HANDLE     NO-UNDO.
DEFINE VARIABLE hBrowse          AS HANDLE     NO-UNDO.
DEFINE VARIABLE hRowObject       AS HANDLE     NO-UNDO.
DEFINE VARIABLE rRowid           AS ROWID      NO-UNDO.
DEFINE VARIABLE iLastRowNum      AS INTEGER    NO-UNDO.
DEFINE VARIABLE iFirstRowNum     AS INTEGER    NO-UNDO.
DEFINE VARIABLE iNumEntries      AS INTEGER    NO-UNDO.
DEFINE VARIABLE lFetchOnRepos    AS LOGICAL    NO-UNDO.
DEFINE VARIABLE lRebuild         AS LOGICAL    NO-UNDO.
DEFINE VARIABLE cObjectType      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cDataSource      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE iLoop            AS INTEGER    NO-UNDO.
DEFINE VARIABLE cNew             AS character  NO-UNDO.
DEFINE VARIABLE lNoRefresh       AS LOGICAL    NO-UNDO.
  
  &SCOPED-DEFINE xp-assign
  {get NewRecord cNew}  
  {get BrowseHandle hBrowse}      /* Handle of the browse widget. */
  /* Proc. handle of our SDO/Dataview. (NOT SBO) */
  {get DataObjectHandle hDataSource}.  
  &UNDEFINE xp-assign
  if cNew = "NO":U and valid-handle(hBrowse) and valid-handle(hDataSource) then 
  do:
    hDataQuery = hBrowse:query. 
    iNumEntries = hBrowse:num-entries.
    if iNumEntries > 0 and iNumEntries lt hBrowse:down 
    and valid-handle(hDataQuery) then
    do:      
      &SCOPED-DEFINE xp-assign
      {get RebuildOnRepos lRebuild hDataSource}
      {get RowObject hRowObject hDataSource}
      {get LastRowNum iLastRowNum hDataSource}.
      &UNDEFINE xp-assign
      
      rRowid = hRowObject:rowid.
      /* No use without a current record as the end of browse logic needs 
         it for reposition and the fetchRows APIs needs current record */  
      if rRowid <> ? then 
      do:
        /* Check if we are supposed to fetch data to fill the browse */
        {get FetchOnReposToEnd lFetchOnRepos}.    
        /* If we have the last record first adjust the position to fill the 
           browse if this does not help then check for and read data backward  */
        if iLastRowNum <> ? then 
        do:
          /* This method should really be called with refreshable on, but 
             we turn it on here as having it off could cost an appserver  hit */  
          if not hBrowse:refreshable then 
            assign hBrowse:refreshable = true
                   lNoRefresh = true.
          /* move the current row so that the last row is at bottom of browse */
          do iLoop = 1 to iNumEntries:
            if hBrowse:is-row-selected(iLoop) then 
               leave.
          end.          
          hBrowse:set-repositioned-row(hBrowse:down - max(0,iNumEntries - iLoop),
                                       "ALWAYS":U).
          hDataQuery:reposition-to-rowid(rRowid).
          /* if still too few entries then append data on top */
          if lFetchOnRepos and lRebuild and hBrowse:num-entries lt hBrowse:down then 
          do:
            /* no need to call if we already have all data */  
            {get FirstRowNum iFirstRowNum hDataSource}.
            if iFirstRowNum = ? then 
              run fetchRows in hDataSource(no,  /*backward*/
                                          /* increase batch temporarily if necessary. */
                                           hBrowse:down - hBrowse:num-entries,
                                           yes). /* round up to nearest amount that 
                                                 is dividible with batchsize */
                                
          end. /*fetchonrepos and rebuild and too few entries */
          if lNoRefresh then 
            assign  
              hBrowse:refreshable = false.
          
        end. /* lastrownum <> ? */
        else if lFetchOnRepos then 
        do:
          run fetchRows in hDataSource 
                         (yes, /* forward */
                           /* adjusts batchsize temporarily to retrieve 
                            the missing number of rows. */ 
                          hBrowse:down - hBrowse:Num-entries,
                          yes). /* use batchsize as basis */
          /* If fetchBatch got the last batch, call this again to tap into 
             the position-at-end logic above..  */
          {get LastRowNum iLastRowNum hDataSource}.
          if iLastRownum <> ? then 
            run adjustReposition in target-procedure .
        end.
      end. /* rowid <> ? */
    end. /* too few entries */
    /* This is not very well though out and the down logic doesn't really work 
       for long, but we need to get rid of the 'always' setting used above, and 
       it is here in an attempt to keep the same setting after 
       fetchRowident -> fetchDataSet ('Batchend') and also at initialization.  
       The down / 2 is here just to try to keep old behavior, but we set it to 
       1 for SDOs with rebuild as the half way down setting makes no sense and 
       causes the above logic to have problems getting the last recod at bottom 

    The point is: don't hesitate to replace this, for example when improving
    browse repositioning...  */ 

    hBrowse:SET-REPOSITIONED-ROW(
       IF lRebuild THEN 1 ELSE INT(hBrowse:DOWN / 2),"CONDITIONAL":U).  

  end. /* newRecord = 'no' and valid browse and datasource handles */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-applyCellEntry) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE applyCellEntry Procedure 
PROCEDURE applyCellEntry :
/*------------------------------------------------------------------------------
  Purpose:     Applies "ENTRY" to the first enabled column 
               in the browse (unless pcCellName is specified).
  Parameters:  pcCellName AS CHARACTER -- optional fieldname; if specified,
               the browse column of that name will be positioned to.
------------------------------------------------------------------------------*/

   DEFINE INPUT PARAMETER pcCellName   AS CHARACTER NO-UNDO.

   DEFINE VARIABLE hBrowse     AS HANDLE NO-UNDO. 
   DEFINE VARIABLE hCell       AS HANDLE NO-UNDO.

    {get BrowseHandle hBrowse}.
    ASSIGN hCell   = hBrowse:FIRST-COLUMN.
    
    DO WHILE VALID-HANDLE(hCell):
        IF NOT hCell:READ-ONLY AND (pcCellName = ? OR hCell:NAME = pcCellName) THEN DO:
            APPLY "ENTRY":U TO hCell.
            RETURN.
        END. 
        ASSIGN hCell = hCell:NEXT-COLUMN.
    END.

    RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-applyEntry) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE applyEntry Procedure 
PROCEDURE applyEntry :
/*------------------------------------------------------------------------------
  Purpose:     Applies "ENTRY" to the first enabled column in the browse 
               (unless pcField is specified) if columns are enabled in the 
               browse, or in the first child of the SmartDataBrowser's frame.
  Parameters:  pcField AS CHARACTER -- optional fieldname; if specified,
               the column field of that name will be positioned to.
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER pcField  AS CHARACTER NO-UNDO.
  
  DEFINE VARIABLE cEnabledFields  AS CHARACTER NO-UNDO.
  DEFINE VARIABLE lFieldsEnabled  AS LOGICAL    NO-UNDO.
 
  &SCOPED-DEFINE xp-assign
  {get FieldsEnabled lFieldsEnabled}
  {get EnabledFields cEnabledFields}.
  &UNDEFINE xp-assign
  IF LOOKUP(pcField,cEnabledFields) NE 0 AND lFieldsEnabled THEN
    RUN applyCellEntry IN TARGET-PROCEDURE (pcField).
  ELSE RUN SUPER(pcField).  

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-assignMaxGuess) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE assignMaxGuess Procedure 
PROCEDURE assignMaxGuess :
/*------------------------------------------------------------------------------
  Purpose:     This procedure adds the value input to the browse's 
               MAX-DATA-GUESS attribute
  Parameters:  INPUT piMaxGuess AS INTEGER
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER piMaxGuess AS INTEGER NO-UNDO.

DEFINE VARIABLE hBrowse AS HANDLE NO-UNDO.

  {get BrowseHandle hBrowse}.
  ASSIGN hBrowse:MAX-DATA-GUESS = hBrowse:MAX-DATA-GUESS + piMaxGuess.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-assignWidgetID) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE assignWidgetID Procedure 
PROCEDURE assignWidgetID :
/*------------------------------------------------------------------------------
    Purpose:
    Parameters: <none>
    Notes:
------------------------------------------------------------------------------*/
DEFINE VARIABLE hContainer AS HANDLE NO-UNDO.
DEFINE VARIABLE cFileName  AS CHARACTER NO-UNDO.

DEFINE VARIABLE hSearchField AS HANDLE     NO-UNDO.
DEFINE VARIABLE hSearchLable AS HANDLE     NO-UNDO.

ASSIGN hContainer = DYNAMIC-FUNCTION('getContainerSource' IN TARGET-PROCEDURE) NO-ERROR.

IF NOT VALID-HANDLE(hContainer) THEN RETURN.

ASSIGN cFileName = DYNAMIC-FUNCTION('getWidgetIDFileName' IN hContainer).

IF cFileName = ? OR cFileName = "" THEN RETURN.

{get SearchHandle hSearchField}.

IF VALID-HANDLE(hSearchField) THEN
DO:
    ASSIGN hSearchField:WIDGET-ID = 4 NO-ERROR.
    ASSIGN hSearchField:SIDE-LABEL-HANDLE:WIDGET-ID = 2 NO-ERROR.
END.

RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-calcWidth) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE calcWidth Procedure 
PROCEDURE calcWidth :
/*------------------------------------------------------------------------------
  Purpose:     Calculates the exact width of the browse based on the columns in 
               the browse.
  Parameters:  <none>
  Notes:       Called from initializeObject for dynamic SmartDataBrowsers
------------------------------------------------------------------------------*/
DEFINE VARIABLE dWidth        AS DECIMAL   NO-UNDO.
DEFINE VARIABLE hBrowse       AS HANDLE    NO-UNDO.
DEFINE VARIABLE hContainer    AS HANDLE NO-UNDO.

  &SCOPED-DEFINE xp-assign
  {get BrowseHandle hBrowse}
  {get ContainerSource hContainer}.
  &UNDEFINE xp-assign
  
  dWidth = (hBrowse:COL - 1) + {fn calculateMaxWidth}. 
  
  /* tell container about new height (no guarantee that it is handled) */
  if valid-handle(hContainer) then
     {fnarg newWidth dWidth hContainer}.
  
  RUN resizeObject IN TARGET-PROCEDURE ({fn getHeight}, dWidth).
                                                                                
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-cancelNew) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE cancelNew Procedure 
PROCEDURE cancelNew :
/*------------------------------------------------------------------------------
  Purpose:     Deletes a currently selected NEW row from the Browse's viewport.  
  Parameters:  <none>
  Notes:       Published from dataSource on cancel of a new row. 
               The 9.1B check to see if the updateSource was a browse did 
               not work for SBOs, where the SDO has no updateSource and the 
               SBO has several. It's too much of a hassle to have some 
               kind of property to keep track of this.  
               Publish seems to be a more future proof and dynamic way to do 
               this as it should work also when we decide to support multiple 
               or 'switchable' updateSoruces for SDOs. 
               As the method ensures that this really is new should make it 
               robust enough as the query only can have one browse.
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hBrowse           AS HANDLE     NO-UNDO.  
  
  {get BrowseHandle hBrowse}.
  IF hBrowse:NEW-ROW THEN 
    RUN deleteComplete IN TARGET-PROCEDURE.

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-cancelRecord) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE cancelRecord Procedure 
PROCEDURE cancelRecord :
/*------------------------------------------------------------------------------
  Purpose:     SmartDataBrowser version of cancelRecord which cancels the 
               add/copy of a new row or update of a current row.
               Depending on if the action comes after an add/copy 
               or an update, it deletes the newly added row (add/copy) 
               or redisplays the current record (update).
  Parameters:  <none>
------------------------------------------------------------------------------*/

  DEFINE VARIABLE hBrowse       AS HANDLE    NO-UNDO.
  DEFINE VARIABLE cNew          AS CHARACTER NO-UNDO.
  
  {get NewRecord cNew}.

  RUN SUPER.
  IF RETURN-VALUE = "ADM-ERROR":U THEN RETURN "ADM-ERROR":U.    
  
  RUN applyEntry IN TARGET-PROCEDURE(?).

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-copyRecord) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE copyRecord Procedure 
PROCEDURE copyRecord :
/*------------------------------------------------------------------------------
  Purpose:     SmartDataBrowser version of copyRecord which inserts a new 
               blank row after the currently selected one if any.
  Parameters:  <none>
  Notes:       Initial values are not displayed here but from ROW-ENTRY trigger 
               (see brsentry.i).
------------------------------------------------------------------------------*/
   
   DEFINE VARIABLE hBrowse      AS HANDLE  NO-UNDO.
   DEFINE VARIABLE hDataQuery   AS HANDLE  NO-UNDO.
   DEFINE VARIABLE hRowObject   AS HANDLE  NO-UNDO.
   DEFINE VARIABLE hSearchField AS HANDLE  NO-UNDO.
     
     {get BrowseHandle hBrowse}.
     
     /* Set the RowIdent before copyRow gets invoked because it needs to 
        copy the initial values out of the current record.  */ 
     
     ASSIGN
       hDataQuery = hBrowse:QUERY
       hRowObject = hDataQuery:GET-BUFFER-HANDLE(1).

     {set RowIdent STRING(hRowObject:ROWID)}.
     
     RUN SUPER.
     IF RETURN-VALUE = "ADM-ERROR":U THEN RETURN "ADM-ERROR":U.
     
     /* Open up a slot for the new row. */
     &SCOPED-DEFINE xp-assign
     {get BrowseHandle hBrowse}
     {get SearchHandle hSearchField}.
     &UNDEFINE xp-assign
     ASSIGN
        hSearchField:SENSITIVE = NO WHEN VALID-HANDLE(hSearchField).
     hBrowse:INSERT-ROW("AFTER":U).
     {set BrowseInitted NO}.    /* Signal for ROW-ENTRY trigger code */
      
     PUBLISH 'updateState':U FROM TARGET-PROCEDURE ('update').
     RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-createPopupItem) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE createPopupItem Procedure 
PROCEDURE createPopupItem :
/*------------------------------------------------------------------------------
  Purpose:     Create popup menu item
  Parameters:  <none>
  Notes:       In order to translate popup menu items, create an override of this
               procedure and use the Globalization Manager API to translate 
               these items as Text.  This should be rewritten to define the 
               popup with the Toolbar and Menu Designer rather than 
               hardcoding it here, that would allow for translations as well.
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER phPopupMenu AS HANDLE     NO-UNDO.
DEFINE INPUT  PARAMETER lSubMenu    AS LOGICAL    NO-UNDO.
DEFINE INPUT  PARAMETER pcLabel     AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER pcName      AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER plChecked   AS LOGICAL    NO-UNDO.
DEFINE INPUT  PARAMETER plToggle    AS LOGICAL    NO-UNDO.
DEFINE OUTPUT PARAMETER phMenuItem  AS HANDLE     NO-UNDO.

  IF lSubMenu THEN
    CREATE SUB-MENU phMenuItem
      ASSIGN
        LABEL  = pcLabel
        NAME   = pcName
        PARENT = phPopupMenu.
  ELSE DO:
    IF plToggle THEN
      CREATE MENU-ITEM phMenuItem
        ASSIGN
          LABEL      = pcLabel
          NAME       = pcName
          TOGGLE-BOX = plToggle
          CHECKED    = plChecked
          PARENT     = phPopupMenu.
    ELSE
      CREATE MENU-ITEM phMenuItem
        ASSIGN
          LABEL  = pcLabel
          NAME   = pcName
          PARENT = phPopupMenu.
  END.  /* else not submenu */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-createPopupMenu) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE createPopupMenu Procedure 
PROCEDURE createPopupMenu :
/*------------------------------------------------------------------------------
  Purpose:     Creates browser popup menu
  Parameters:  <none>
  Notes:       Called by initializeObject
------------------------------------------------------------------------------*/
DEFINE VARIABLE hBrowse          AS HANDLE     NO-UNDO.
DEFINE VARIABLE hColsMovable     AS HANDLE     NO-UNDO.
DEFINE VARIABLE hColsSortable    AS HANDLE     NO-UNDO.
DEFINE VARIABLE hDefaultCol      AS HANDLE     NO-UNDO.
DEFINE VARIABLE hDefaultSort     AS HANDLE     NO-UNDO.
DEFINE VARIABLE hExitItem        AS HANDLE     NO-UNDO.
DEFINE VARIABLE hPopupMenu       AS HANDLE     NO-UNDO.
DEFINE VARIABLE hRemoveCol       AS HANDLE     NO-UNDO.
DEFINE VARIABLE hRemoveSort      AS HANDLE     NO-UNDO.
DEFINE VARIABLE hResetCol        AS HANDLE     NO-UNDO.
DEFINE VARIABLE hResetDefault    AS HANDLE     NO-UNDO.
DEFINE VARIABLE hResetSort       AS HANDLE     NO-UNDO.
DEFINE VARIABLE hResetSubMenu    AS HANDLE     NO-UNDO.
DEFINE VARIABLE hRuleItem        AS HANDLE     NO-UNDO.
DEFINE VARIABLE hSaveColSettings AS HANDLE     NO-UNDO.
DEFINE VARIABLE hSaveSorting     AS HANDLE     NO-UNDO.
DEFINE VARIABLE lMovable         AS LOGICAL    NO-UNDO.
DEFINE VARIABLE lSortable        AS LOGICAL    NO-UNDO.
DEFINE VARIABLE lUseRepos        AS LOGICAL    NO-UNDO.

  &SCOPED-DEFINE xp-assign
  {get BrowseHandle hBrowse}
  {get ColumnsMovable lMovable}
  {get ColumnsSortable lSortable}
  {get UseRepository lUseRepos}.
  &UNDEFINE xp-assign
  
  IF VALID-HANDLE(hBrowse:POPUP-MENU) THEN
  DO:
    hPopupMenu = hBrowse:POPUP-MENU.
    CREATE MENU-ITEM hRuleItem
       ASSIGN
          SUBTYPE = 'RULE':U
          PARENT  = hPopupMenu.
  END.
  ELSE 
    CREATE MENU hPopupMenu
      ASSIGN 
        POPUP-ONLY = TRUE
        TITLE      = 'Browser Menu'.

  RUN createPopupItem IN TARGET-PROCEDURE
      (INPUT hPopupMenu,
       INPUT FALSE,
       INPUT '&Move Columns',
       INPUT 'miColsMovable':U,
       INPUT lMovable,
       INPUT TRUE,
       OUTPUT hColsMovable).

  RUN createPopupItem IN TARGET-PROCEDURE
      (INPUT hPopupMenu,
       INPUT FALSE,
       INPUT '&Sort Columns',
       INPUT 'miColsSortable':U,
       INPUT lSortable,
       INPUT TRUE,
       OUTPUT hColsSortable).

  &SCOPED-DEFINE xp-assign
  {set MovableHandle hColsMovable}
  {set SortableHandle hColsSortable}.
  &UNDEFINE xp-assign

  RUN createPopupItem IN TARGET-PROCEDURE
      (INPUT hPopupMenu,
       INPUT TRUE,
       INPUT '&Reset',
       INPUT 'smReset':U,
       INPUT FALSE,
       INPUT FALSE,
       OUTPUT hResetSubMenu).

  RUN createPopupItem IN TARGET-PROCEDURE
      (INPUT hResetSubMenu,
       INPUT FALSE,
       INPUT '&Column Positions and Sizes',
       INPUT 'miResetCol':U,
       INPUT FALSE,
       INPUT FALSE,
       OUTPUT hResetCol).
   
  IF lUseRepos THEN
    RUN createPopupItem IN TARGET-PROCEDURE
        (INPUT hResetSubMenu,
         INPUT FALSE,
         INPUT '&Sort Column',
         INPUT 'miResetSort':U,
         INPUT FALSE,
         INPUT FALSE,
         OUTPUT hResetSort).

  CREATE MENU-ITEM hRuleItem
    ASSIGN 
      SUBTYPE = 'RULE':U
      PARENT  = hResetSubMenu.

  RUN createPopupItem IN TARGET-PROCEDURE
      (INPUT hResetSubMenu,
       INPUT FALSE,
       INPUT '&Default Column Positions and Sizes',
       INPUT 'miDefaultCol':U,
       INPUT FALSE,
       INPUT FALSE,
       OUTPUT hDefaultCol).

  RUN createPopupItem IN TARGET-PROCEDURE
      (INPUT hResetSubMenu,
       INPUT FALSE,
       INPUT 'De&fault Sort Column',
       INPUT 'miDefaultSort':U,
       INPUT FALSE,
       INPUT FALSE,
       OUTPUT hDefaultSort).

  /* Movable and Sortable are mutually exclusive and Sortable takes precedence */
  IF lMovable AND lSortable THEN hColsMovable:CHECKED = FALSE.

  IF lUseRepos THEN
  DO:
    CREATE MENU-ITEM hRuleItem
      ASSIGN 
        SUBTYPE = 'RULE':U
        PARENT  = hPopupMenu.

    RUN createPopupItem IN TARGET-PROCEDURE
        (INPUT hPopupMenu,
         INPUT FALSE,
         INPUT 'Save &Column Positions and Sizes',
         INPUT 'miSaveColumnSettings':U,
         INPUT FALSE,
         INPUT FALSE,
         OUTPUT hSaveColSettings).

    RUN createPopupItem IN TARGET-PROCEDURE
        (INPUT hPopupMenu,
         INPUT FALSE,
         INPUT 'Save &Sort Column',
         INPUT 'miSaveSorting':U,
         INPUT FALSE,
         INPUT FALSE,
         OUTPUT hSaveSorting).

    RUN createPopupItem IN TARGET-PROCEDURE
        (INPUT hPopupMenu,
         INPUT FALSE,
         INPUT '&Remove Column Positions and Sizes',
         INPUT 'miRemoveCol':U,
         INPUT FALSE,
         INPUT FALSE,
         OUTPUT hRemoveCol).

    RUN createPopupItem IN TARGET-PROCEDURE
        (INPUT hPopupMenu,
         INPUT FALSE,
         INPUT 'Re&move Sort Column',
         INPUT 'miRemoveSort':U,
         INPUT FALSE,
         INPUT FALSE,
         OUTPUT hRemoveSort).
  END.  /* if lUseRepos */

  CREATE MENU-ITEM hRuleItem
    ASSIGN 
      SUBTYPE = 'RULE':U
      PARENT  = hPopupMenu.

  RUN createPopupItem IN TARGET-PROCEDURE
      (INPUT hPopupMenu,
       INPUT FALSE,
       INPUT 'E&xit',
       INPUT 'miExit':U,
       INPUT FALSE,
       INPUT FALSE,
       OUTPUT hExitItem).

  hBrowse:POPUP-MENU = hPopupMenu.
  
  ON VALUE-CHANGED OF hColsMovable
    PERSISTENT RUN movableValueChanged IN TARGET-PROCEDURE. 

  ON VALUE-CHANGED OF hColsSortable
    PERSISTENT RUN sortableValueChanged IN TARGET-PROCEDURE.   

  ON CHOOSE OF hResetCol
    PERSISTENT RUN resetColumnSettings IN TARGET-PROCEDURE.

  ON CHOOSE OF hDefaultCol
    PERSISTENT RUN resetDefaultSettings IN TARGET-PROCEDURE.

  /* TRUE parameter indicates that sort should be reset to default sort */
  ON CHOOSE OF hDefaultSort
    PERSISTENT RUN resetSortColumn IN TARGET-PROCEDURE (INPUT TRUE).

  IF lUseRepos THEN
  DO:
    /* FALSE parameter indicates that sort should not be resert to default sort */
    ON CHOOSE OF hResetSort
      PERSISTENT RUN resetSortColumn IN TARGET-PROCEDURE (INPUT FALSE).

    /* FALSE parameter indicates that the profile should be saved rather 
       than deleted */
    ON CHOOSE OF hSaveColSettings
      PERSISTENT RUN updateColumnSettings IN TARGET-PROCEDURE (INPUT FALSE).

    /* FALSE parameter indicates that the profile should be saved rather
       than deleted */
    ON CHOOSE OF hSaveSorting
      PERSISTENT RUN updateSortColumn IN TARGET-PROCEDURE (INPUT FALSE).

    ON CHOOSE OF hRemoveCol
      PERSISTENT RUN removeColumnSettings IN TARGET-PROCEDURE.

    ON CHOOSE OF hRemoveSort
      PERSISTENT RUN removeSortColumn IN TARGET-PROCEDURE.

  END.  /* if lUseRepos */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-createSearchField) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE createSearchField Procedure 
PROCEDURE createSearchField :
/*------------------------------------------------------------------------------
  Purpose:     Create the browser's search field
  Parameters:  <none>
  Notes:       Called from initializeObject
               This resorts the query by the SearchField. 
------------------------------------------------------------------------------*/
DEFINE VARIABLE cSearchField  AS CHARACTER NO-UNDO.
DEFINE VARIABLE cSearchLabel  AS CHARACTER NO-UNDO.
DEFINE VARIABLE hBrowse       AS HANDLE    NO-UNDO.
DEFINE VARIABLE hDataSource   AS HANDLE    NO-UNDO.
DEFINE VARIABLE hFrame        AS HANDLE    NO-UNDO.
DEFINE VARIABLE hSearchField  AS HANDLE    NO-UNDO.
DEFINE VARIABLE hSearchLabel  AS HANDLE    NO-UNDO.
DEFINE VARIABLE lHideOnInit   AS LOGICAL   NO-UNDO.
DEFINE VARIABLE lOpen         AS LOGICAL   NO-UNDO.
DEFINE VARIABLE hPosSrc       AS HANDLE    NO-UNDO.
DEFINE VARIABLE hSearchHandle AS HANDLE    NO-UNDO.

  &SCOPED-DEFINE xp-assign
  {get DataSource hDataSource}    /* Proc. handle of our SDO. */
  {get BrowseHandle hBrowse}      /* Handle of the browse widget. */
  {get SearchField cSearchField}
  {get SearchHandle hSearchHandle}.
  &UNDEFINE xp-assign

  /* If there is a SearchField, then allocate the first line of the frame
     to it and define the label and fill-in for it. */   
  IF cSearchField NE "":U AND cSearchField NE ? THEN
  DO:
    {get ContainerHandle hFrame}.    /* Frame handle to put the widgets in. */
    /*  we only support dbfields as search/sort field in sdo datasource*/  
    IF {fnarg instanceOf 'DataView':U hDataSource}
    OR {fnarg columnDbColumn cSearchField hDataSource} > "":U THEN
    DO:
      /*Do not resize and reposition the browse if the searchField was
        already created.*/
      IF hBrowse:ROW NE 2 THEN
          ASSIGN hBrowse:HEIGHT = hBrowse:HEIGHT - 1  /* Shorten the browse */
                 hBrowse:ROW    = 2.                      /* and place at row 2 */

      ASSIGN cSearchLabel =  {fnarg columnLabel cSearchfield hDataSource}
                             + ": ":U.          
      CREATE TEXT hSearchLabel     /* Label for the field */ 
        ASSIGN
          FORMAT = "X(":U + STRING(LENGTH(cSearchLabel)) + ")":U
          SCREEN-VALUE = cSearchLabel
          ROW     = 1
          WIDTH   = FONT-TABLE:GET-TEXT-WIDTH(cSearchLabel)
          HEIGHT  = 1
          COL     = 2
          FRAME   = hFrame
          HIDDEN  = TRUE.

      CREATE FILL-IN hSearchField
        ASSIGN
          DATA-TYPE = DYNAMIC-FUNCTION('columnDataType':U IN hDataSource, 
                                       cSearchField)
          FORMAT    = DYNAMIC-FUNCTION('columnFormat':U IN hDataSource, 
                                        cSearchField)
          ROW       = 1 
          COL       = hSearchLabel:COL + hSearchLabel:WIDTH 
          width     = min(hSearchField:width,{fn getSearchFieldMaxWidth})
          FRAME     = hFrame
          HIDDEN    = TRUE 
          SENSITIVE = YES
          SIDE-LABEL-HANDLE = hSearchLabel
          TRIGGERS: 
          ON ANY-PRINTABLE
            PERSISTENT RUN searchTrigger IN TARGET-PROCEDURE. 
        END TRIGGERS.

      IF NUM-ENTRIES(cSearchField,'.':U) = 1 THEN
        cSearchField = 'RowObject.':U + cSearchField.

      /* reopens only if different from before, sets QuerySort if query is not 
         opened yet */
      {fnarg resortQuery cSearchField hDataSource}.

      /* Reposition to the first row after the resort,
         unless the SDO is not open (for example openoninit false )
         or already has a positionsource (SDF -> viewer -> datasource)*/
      &SCOPED-DEFINE xp-assign
      {get QueryOpen lOpen hDataSource}
      {get PositionSource hPosSrc hDataSource}
       .
      &UNDEFINE xp-assign
      IF lOpen AND NOT VALID-HANDLE(hPosSrc) THEN
        RUN fetchFirst IN hDataSource.

      &SCOPED-DEFINE xp-assign
      {get HideOnInit lHideOnInit}
      {set SearchHandle hSearchField}
       .      
      &UNDEFINE xp-assign

      IF DYNAMIC-FUNCTION('getUseWidgetID':U IN TARGET-PROCEDURE) THEN         RUN assignWidgetID IN TARGET-PROCEDURE.

      ASSIGN hSearchField:HIDDEN = FALSE             
             hSearchLabel:HIDDEN = FALSE no-error.

      IF lHideOnInit THEN 
        RUN hideObject IN TARGET-PROCEDURE.
    END. /* if cSortfield <> '':U */
  END. /* If lSearchField */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-dataAvailable) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE dataAvailable Procedure 
PROCEDURE dataAvailable :
/*------------------------------------------------------------------------------
  Purpose:     SmartDataBrowser version of dataAvailable.
               Repositions itself in response to a query reposition in its 
               DataSource.
  Parameters:  pcRelative AS CHARACTER
               Possible values are:
               FIRST    - Repositions to the first row in the browse
               LAST     - Repositions to the last row in the browse
               PREV     - Repositions to the prev row in the browse
               NEXT     - Repositions to the next row in the browse
               REPOSITIONED - A navigation has taken place, but the query has 
                              been repositioned so the browse is already 
                              on the correct record 
               DIFFERENT- Returns or invokes next up on the chain 
                         (If database based browse query.p will publish 
                          dataavail, is not important for SDO browsing)
                                          
  Notes:        
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pcRelative AS CHARACTER NO-UNDO.
  
  DEFINE VARIABLE hBrowse           AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hDataSource       AS HANDLE    NO-UNDO.
  DEFINE VARIABLE cRowIdent         AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cFields           AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cDisplayed        AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cColumns          AS CHARACTER NO-UNDO.
  DEFINE VARIABLE lInitialized      AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE hToolbarSource    AS HANDLE    NO-UNDO.
  DEFINE VARIABLE lNewMode          AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE hUpdateTarget     AS HANDLE    NO-UNDO.
  
  /* Do nothing if not initialized */
  {get objectinitialized lInitialized}.
  IF NOT lInitialized THEN 
    RETURN.
   
  {get DataSource hDataSource}.
  IF VALID-HANDLE(hDataSource) THEN
  DO:
    /* Do nothing if source sdo is not initialized */
    {get objectinitialized lInitialized hDataSource}.
    IF NOT lInitialized THEN 
      RETURN.
    /* colValues will return ALL rowids for an SBO when no fields is passed, 
       but getRowident has logic to filter away the abundant ones.. */
    cRowIdent = ENTRY(1,{fnarg colValues '':U hDataSource},CHR(1)).
    {set RowIdent cRowIdent}.  
  END.
  
  {get BrowseHandle hBrowse}.
  CASE pcRelative:
    when "SAME":U or when "RESET":U or when "RESORT":U then 
    DO:  
      /* A record in new mode will not be present in the browser yet, unless 
         the browse is the update source, so in that case we avoid this as 
         refresh/display would reposition the query and make the DataSource
         loose track of its new unsaved record. (The problem was encountered
         when an SBO publishes dataAvailable after a failed add)*/ 
      IF VALID-HANDLE(hDataSource) THEN
      DO:
        {get UpdateTarget hUpdateTarget}.
        IF NOT VALID-HANDLE(hUpdateTarget) OR hUpdateTarget <> hDataSource THEN
          {get NewMode lNewMode hDataSource}.
      END.

      IF NOT lNewMode THEN
      DO:
        /* This is necessary because BROWSER:REFRESH does not refresh */
        /* the current row */
        RUN displayRecord IN TARGET-PROCEDURE. 
        RUN refreshBrowse IN TARGET-PROCEDURE.
        /* This adjustment is not always needed on 'reset', but datacontainers 
           just publishes dataavailable 'reset' when they get new data.
           They should really run fetchFirst then this would be taken care of 
           by the apply 'home' -> onHome. But child SDOs would need to be 
           changed to treat 'first' as 'reset' before this could be done */
        if pcRelative = 'RESET':U then
          run adjustReposition in target-procedure.
      END.
    END.
    WHEN "FIRST":U THEN 
    DO:
      /* applying 'home' in a column goes to start of column */ 
      IF VALID-HANDLE(FOCUS) AND
        FOCUS:PARENT = hBrowse THEN
          APPLY "CTRL-HOME":U TO hBrowse.            
      ELSE 
        APPLY "HOME":U TO hBrowse.
    END.    
    WHEN "NEXT":U  THEN hBrowse:SELECT-NEXT-ROW() NO-ERROR.           
    WHEN "PREV":U  THEN hBrowse:SELECT-PREV-ROW() NO-ERROR.
    WHEN "LAST":U  THEN 
    DO:
      /* Applying 'End' in a column goes to end of column */ 
      IF VALID-HANDLE(FOCUS) AND
        FOCUS:PARENT = hBrowse THEN
        APPLY "CTRL-END":U TO hBrowse.
      ELSE 
        APPLY "END":U TO hBrowse.
    END.    
  END CASE.
  
  RUN updateTitle IN TARGET-PROCEDURE.
  RUN rowDisplay IN TARGET-PROCEDURE NO-ERROR.  /* Custom display checks. */
  
  
  RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-defaultAction) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE defaultAction Procedure 
PROCEDURE defaultAction :
/*------------------------------------------------------------------------------
  Purpose:  Runs persistently from default action.   
  Parameters:  <none>
  Notes:    The trigger is defined in setActionEvent . 
------------------------------------------------------------------------------*/
   DEFINE VARIABLE cActionEvent AS CHARACTER  NO-UNDO.
   DEFINE VARIABLE lExit        AS LOGICAL    NO-UNDO.
   DEFINE VARIABLE cLaunch      AS CHARACTER  NO-UNDO.
   
   {get FolderWindowToLaunch cLaunch}.
   IF cLaunch > '':U THEN
     RUN LaunchFolderWindow IN TARGET-PROCEDURE ('View':U).
      
   ELSE DO:
     &SCOPED-DEFINE xp-assign
     {get ActionEvent cActionEvent}
     {get ApplyExitOnAction lExit}.
     &UNDEFINE xp-assign
     
     IF cActionEvent <> "":U THEN
       PUBLISH cActionEvent FROM TARGET-PROCEDURE.
  
     /* Is the default action supposed to close the browse ? */   
     IF lExit THEN 
     DO:
       /* There's an opposite property that dictates that the exit is to 
          behave as defaultAction, (mainly to do the publish above)
          which is not needed in this case and also would create loop  */ 
       {set ApplyActionOnExit FALSE}.
       RUN exitObject IN TARGET-PROCEDURE.
     END.
   END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-deleteComplete) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE deleteComplete Procedure 
PROCEDURE deleteComplete :
/*------------------------------------------------------------------------------
  Purpose:     Deletes the currently selected row from the Browse's viewport.
  Parameters:  <none>
  Notes:       If the SmartDataBrowser is updateable and has its own query it 
               will be invoked from deleteRecord which in this case does 
               nothing as the row has already been deleted.
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hBrowse           AS HANDLE     NO-UNDO.
  
  {get BrowseHandle hBrowse}.
  
  IF hBrowse:NUM-SELECTED-ROWS EQ 1 THEN 
    hBrowse:DELETE-CURRENT-ROW().
    
  /* Multiple browser is not really supported, but this was necessary to 
     ensure that a 9.1B fix that changed the place where this was published
     from data.p did not make them behave even worse...
     It fixes a core bug that makes the first row available AND 
     ensures that a row is selected after delete AND dataVailable behaves ok.    
     Note that this is depending of the fact that current code also  
     prevents the delete to take place with more than one selected row.
     If multiple browsers is to be supported to be able to DELETE 
     more than one row this may behave really badly... */      
  IF hBrowse:MULTIPLE 
  AND hBrowse:FOCUSED-ROW <> ? 
  /* aviod error 2108 with empty multi-select add/cancel */
  AND hBrowse:NUM-ITERATIONS > 0 THEN
    hBrowse:deSELECT-FOCUSED-ROW().

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-deleteRecord) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE deleteRecord Procedure 
PROCEDURE deleteRecord :
/*------------------------------------------------------------------------------
  Purpose:    SmartDataBrowser version of deleteRecord.  
  Parameters:  <none>
  Notes:      The actual record deletion is done in the super. 
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cQueryPos   AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cRowIdent   AS CHARACTER NO-UNDO INIT "":U.
  DEFINE VARIABLE hBrowse     AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hBuffer     AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hDataSource AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hQuery      AS HANDLE    NO-UNDO.
  
  {get BrowseHandle hBrowse}.
  
  IF hBrowse:NUM-SELECTED-ROWS NE 1 THEN
  DO:
     DYNAMIC-FUNCTION("showMessage":U IN TARGET-PROCEDURE, "1":U).  
     /* Must select a single row for deletion. */
     RETURN "ADM-ERROR":U.
  END.
  
  hBrowse:SELECT-FOCUSED-ROW() NO-ERROR.  /* In case it's not yet explicitly selected.*/
  ASSIGN
    hQuery = hBrowse:QUERY  /* Whether DB or RowObject query */
    hBuffer = hQuery:GET-BUFFER-HANDLE(1)
    cRowIdent = STRING(hBuffer:ROWID).

  {get DataSource hDataSource}.
  {get QueryPosition cQueryPos hDataSource}.
  {set RowIdent cRowIdent}.
  
  RUN SUPER.
  
  IF RETURN-VALUE = "ADM-ERROR":U THEN RETURN "ADM-ERROR":U. 
  
  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-destroyObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE destroyObject Procedure 
PROCEDURE destroyObject :
/*------------------------------------------------------------------------------
  Purpose:     SmartDataBrowser version of destroyObject which lets its
               Data source know that it is no longer being browsed.
  Parameters:  <none>
  Notes:       This is needed because only one browser may browse a
               SmartDataObject query at a time.
------------------------------------------------------------------------------*/

  DEFINE VARIABLE lAction      AS LOG      NO-UNDO.
  
  {get ApplyActionOnExit lAction}.
  
  /* Is the exit supposed to behave as a double-click or return?
    (publish the ActionEvent) */
  IF lAction THEN 
  DO:
    /* There's an opposite property that dictates that defaultAction calls
       exit, which is not needed in this case and also would create loop  */ 
    {set ApplyExitOnAction FALSE}.
    RUN defaultAction IN TARGET-PROCEDURE.
  END. /* if lAction */
  
  {fn destroyBrowse}.

  RUN SUPER.

  RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-disableCreateFields) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disableCreateFields Procedure 
PROCEDURE disableCreateFields :
/*------------------------------------------------------------------------------
  Purpose:  Disable fields that only are enabled on create (EnabledWhenNew)    
  Parameters:  <none>
  Notes:    EnableFields will enable fields that are specified in the 
            EnabledWhenNew list on Add or Copy. This method is called to 
            disable these on cancelRecord or updateRecord. 
------------------------------------------------------------------------------*/
  DEFINE VARIABLE iField            AS INTEGER   NO-UNDO.
  DEFINE VARIABLE hField            AS HANDLE    NO-UNDO.
  DEFINE VARIABLE cField            AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cName             AS CHARACTER NO-UNDO.
  DEFINE VARIABLE lInitialized      AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE cEnabledWhenNew   AS CHARACTER NO-UNDO.   
  DEFINE VARIABLE cEnabledFields    AS CHARACTER NO-UNDO.  
  DEFINE VARIABLE iEnable           AS INTEGER   NO-UNDO.
  DEFINE VARIABLE cDisableList      AS CHARACTER NO-UNDO.
  
  &SCOPED-DEFINE xp-assign
  {get ObjectInitialized lInitialized}
  {get EnabledFields cEnabledFields}
  {get EnabledWhenNew cEnabledWhenNew} 
  .
  &UNDEFINE xp-assign
  
  /* Bail out if not initialized yet, as the Enabled* properties may not 
     be properly set yet. */
  IF NOT lInitialized THEN 
    RETURN.
                      
  IF cEnabledWhenNew = "":U THEN
    RETURN.

  /* we could in principle just pass enabledWhenNew directly to DisableFieldList.
     But the list is typically short and the behavior should be consistent with 
     EnableFields, which enables these.  */             
  DO iField = 1 TO NUM-ENTRIES(cEnabledWhenNew):
    /* EnabledWhenNew might contain both fields and objects */ 
    assign
      cField = ENTRY(iField, cEnabledWhenNew)
      iEnable = lookup(cField,cEnabledFields).
    IF iEnable > 0 THEN
       cDisableList = cDisableList 
                    + (IF cDisableList = "":U THEN "":U ELSE ",":U)
                    + cField. 
  end.
  
  IF cDisableList > "":U THEN
    RUN disableFieldList IN TARGET-PROCEDURE (cDisableList).
  
  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-disableFieldList) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disableFieldList Procedure 
PROCEDURE disableFieldList :
/*------------------------------------------------------------------------------
   Purpose: Disable a list of fields or objects.       
Parameters:  pcFieldList  - List of fields to disable.
     Notes:  The passed fields must be in the broeser's DisplayedFields. 
          -  This is intended for use by the browser's public disable* methods 
             and should typically not be called by external objects as no 
             properties are set or events fired.              
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcFieldList  AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE hBrowse          AS HANDLE    NO-UNDO.
  DEFINE VARIABLE lEnabled         AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE lSelected        AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE hField           AS HANDLE    NO-UNDO.
  DEFINE VARIABLE iField           AS INTEGER   NO-UNDO. 
  DEFINE VARIABLE iFieldPos        AS INTEGER     NO-UNDO.
  DEFINE VARIABLE cFieldName       AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cDisplayedFields AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cFieldHandles    AS CHARACTER NO-UNDO.
  
  &SCOPED-DEFINE xp-assign
  {get BrowseHandle hBrowse}
  {get FieldsEnabled lEnabled}
  {get FieldHandles cFieldHandles}
  {get DisplayedFields cDisplayedFields}.
  &UNDEFINE xp-assign
  
   /* NOTE: No specific support yet for just disabling 'Create' fields. */
  IF VALID-HANDLE(hBrowse) and lEnabled THEN  
  DO:
    lSelected = hBrowse:NUM-SELECTED-ROWS > 0. 
    DO iField = 1 TO NUM-ENTRIES(pcFieldList):
      ASSIGN
        cFieldName = ENTRY(iField,pcFieldList)    
        iFieldPos  = LOOKUP(cFieldName,cDisplayedFields).
      IF iFieldPos > 0 THEN
      DO:
        hField  = WIDGET-HANDLE(ENTRY(iFieldPos,cFieldHandles)).
        IF VALID-HANDLE(hField) THEN
          hField:READ-ONLY = TRUE NO-ERROR.
      END.
    END.
    IF lSelected THEN 
      hBrowse:SELECT-FOCUSED-ROW() NO-ERROR.
  END.

  RETURN.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-disableFields) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disableFields Procedure 
PROCEDURE disableFields :
/*------------------------------------------------------------------------------
  Purpose:     Makes the Browse control read-only.
  Parameters:  pcFields AS CHARACTER -- 'All' or 'Create'
  Notes:       'Create' is not supported yet.
               Move away focus from the Browse before turning off the
               READ-ONLY attribute.
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pcFieldType  AS CHARACTER NO-UNDO. 

  DEFINE VARIABLE hBrowse         AS HANDLE      NO-UNDO.
  DEFINE VARIABLE lEnabled        AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE cFields         AS CHARACTER NO-UNDO.
  DEFINE VARIABLE hFrame          AS HANDLE    NO-UNDO.

  &SCOPED-DEFINE xp-assign
  {get FieldsEnabled lEnabled}
  {get BrowseHandle hBrowse}
  {get ContainerHandle hFrame}
  {get EnabledFields cFields}
  .
  &UNDEFINE xp-assign
  
  IF lEnabled AND valid-handle(hBrowse) THEN 
  DO:
    IF cFields NE "":U AND pcFieldType = 'All':U then
    DO:
      APPLY "ENTRY":U TO hFrame.
      /* Setting each column to read-only avoids problems with the column 
         remaining visually enabled when this procedure is called without  
         row-leave/leave been fired (for example the toolbar which has no focus). */
      hBrowse:READ-ONLY = TRUE NO-ERROR.
      RUN disableFieldList IN TARGET-PROCEDURE(cFields).
      /* The APPLY LEAVE is necessary to overcome a problem with the browse whereby any triggers on the 
         browse cannot be programtically fired until the user executes a keyboard or mouse event. The APPLY
         HOME,CTRL-HOME,END,CTR-END in dataAvailable were not firing because of this.     */
      APPLY "LEAVE" TO hBrowse.         
    END.
    {set FieldsEnabled NO}.
  END.

  RUN SUPER(pcFieldType).
  
  RETURN.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-displayFields) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE displayFields Procedure 
PROCEDURE displayFields :
/*------------------------------------------------------------------------------
  Purpose:     Displays the current row values by moving them to the browse's
               screen-values.
  Parameters:  pcColValues AS CHARACTER -- CHR(1) delimited list of 
               BUFFER-VALUES of the requested fields; the first value in the
               list is the RowIdent value.
------------------------------------------------------------------------------*/
 DEFINE INPUT PARAMETER pcColValues AS CHARACTER NO-UNDO.
 
 DEFINE VARIABLE hFrameField       AS HANDLE     NO-UNDO.
 DEFINE VARIABLE iValue            AS INTEGER    NO-UNDO.
 DEFINE VARIABLE cRowIdent         AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE iColCount         AS INTEGER    NO-UNDO.
 DEFINE VARIABLE cFields           AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cFieldHandles     AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE hQuery            AS HANDLE     NO-UNDO.
 DEFINE VARIABLE hBuffer           AS HANDLE     NO-UNDO.
 DEFINE VARIABLE hField            AS HANDLE     NO-UNDO.  
 DEFINE VARIABLE cField            AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cBufferHandles    AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cBufferList       AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cNewRecord        AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE lStaticDisp       AS LOGICAL    NO-UNDO.

 &SCOPED-DEFINE xp-assign
 {get NewRecord cNewRecord}
 {get DisplayedFields cFields}.
 &UNDEFINE xp-assign

 /* Use static display for locally calculated fields */ 
 IF LOOKUP('<calc>':U,cFields) > 0 THEN
 DO:
   /* Conditionally compiled from browser.i if @ found in browser fields 
     (local calc field) */
   RUN DisplayFieldsStatic IN TARGET-PROCEDURE (pccolValues) NO-ERROR.
   lStaticDisp = NOT ERROR-STATUS:ERROR.
 END.

 IF NOT lStaticDisp THEN
 DO:
   ASSIGN
    iColCount = NUM-ENTRIES(pcColValues,CHR(1))
      /* Save off the row ident string, which is always the first value returned. */
    cRowIdent = ENTRY(1, pcColValues, CHR(1)).
    {set RowIdent cRowIdent}.
    {get FieldHandles cFieldHandles}.

   IF cFieldHandles NE "":U THEN
   DO iValue = 2 TO iColCount:
     cField  = ENTRY(iValue - 1,cFields).
     /* If this is a calc field, ignore it and don't display anything */
     IF cField <> '<Calc>':U THEN
       ASSIGN hFrameField = WIDGET-HANDLE(ENTRY(iValue - 1,cFieldHandles))
              hFrameField:SCREEN-VALUE = IF pcColValues NE ? THEN
                                         RIGHT-TRIM(ENTRY(iValue, pcColValues, CHR(1)))
                                         ELSE IF hFrameField:DATA-TYPE NE "LOGICAL":U THEN "":U
                                         ELSE ?
              hFrameField:MODIFIED = NO  /* Checked by update code. */
              NO-ERROR.
   END.
 END.

 RUN updateTitle IN TARGET-PROCEDURE.
 RUN rowDisplay IN TARGET-PROCEDURE NO-ERROR.  /* Custom display checks. */

 RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-enableFields) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enableFields Procedure 
PROCEDURE enableFields :
/*------------------------------------------------------------------------------
  Purpose:     Makes the Browse control updatable.
  Parameters:  <none>
  Notes:       The Browse is made updateable only if some field are enabled
               and the SmartDataBrowser is link to an Update target.
------------------------------------------------------------------------------*/
  DEFINE VARIABLE lSelected         AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE hBrowse           AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hFrame            AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hColumn           AS HANDLE     NO-UNDO.
  DEFINE VARIABLE lEnabled          AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cDisplayedFields  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cColumnList       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cColumn           AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cEnabledFields    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFieldHandles     AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cEnabledWhenNew   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFieldSecurity    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cState            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cTarget           AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iColumn           AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iEnableCol        AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cNewRecord        AS CHARACTER NO-UNDO. 
  DEFINE VARIABLE lCreateFieldsOnly AS LOGICAL   NO-UNDO.
 
  {get BrowseHandle hBrowse}.
  IF VALID-HANDLE(hBrowse) THEN
  DO:
    &SCOPED-DEFINE xp-assign
    {get EnabledFields cEnabledFields}
    {get FieldsEnabled lEnabled}
    {get NewRecord cNewRecord}
    {get EnabledWhenNew cEnabledWhenNew}
    {get RecordState cState}
    {get UpdateTarget cTarget}
    .
    &UNDEFINE xp-assign
    
    if lEnabled and cNewRecord <> "NO":U and cEnabledWhenNew > "":U then
      lCreateFieldsOnly = true.
       
    IF cEnabledFields > "":U 
    AND (NOT lEnabled or lCreateFieldsOnly)  /* There are fields to enable */
    AND cTarget > "":U THEN  /* and an Update-Target */
    DO:
      lSelected = hBrowse:NUM-SELECTED-ROWS = 1.  /* Was a row selected? */
      
      &SCOPED-DEFINE xp-assign
      {get ContainerHandle hFrame}
      {get FieldHandles cFieldHandles}
      {get FieldSecurity cFieldSecurity}
      {get DisplayedFields cDisplayedFields}.
      &UNDEFINE xp-assign
 
      if lCreateFieldsOnly then 
        cColumnList = cEnabledWhenNew.
      else 
        cColumnList = cEnabledFields.
             
      APPLY "ENTRY":U TO hFrame.
         
      /* Turn off read-only for each column 
         See comments in disable fields why read-only is true */
      hColumn = hBrowse:FIRST-COLUMN.
      do while valid-handle(hColumn):
        assign 
          iColumn    = lookup(string(hColumn),cFieldHandles).
          cColumn    = if iColumn > 0 then entry(iColumn,cDisplayedFields) else "":U.
          iEnableCol = lookup(cColumn,cColumnList).
        if iEnableCol > 0 then
        do:  
          /* enable if enabledlist only has createfields or... */
          if lCreateFieldsOnly 
          /* .. always enable if new */
          or cNewRecord <> "no" 
          /*  or not in list of enablewhen new  */  
          or cEnabledWhenNew = "":U 
          or lookup(cColumn,cEnabledWhenNew) = 0 then 
          do:
            /* Check security  */
            if cFieldSecurity = "":U  
            or NUM-ENTRIES(cFieldSecurity) < iColumn
            or ENTRY(iColumn,cFieldSecurity) = "":U then
              hColumn:read-only = false.     
          end. 
        end. /* enabled col */  
        hColumn = hColumn:NEXT-COLUMN.
      end.  /* do while valid-handle hColumn */
      /* avoid error 4517 setting read-only when browse has focus */
      if focus = hBrowse then  
        hBrowse:sensitive = no.
      hBrowse:READ-ONLY = NO.
      if hBrowse:sensitive = false then
        hBrowse:sensitive = yes.
      
      IF lSelected THEN 
        hBrowse:SELECT-FOCUSED-ROW() NO-ERROR.
      
      if not lCreateFieldsOnly THEN
        {set FieldsEnabled YES}.
    end. /* if not lenabled or createfields */
    
    IF cState = 'NoRecordAvailable':U THEN 
    DO:
      {get ContainerHandle hFrame}.
      APPLY "ENTRY":U TO hFrame.
    END.  /* if no record available */    
  END.
  
  RUN SUPER.
 
  RETURN.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-enableObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enableObject Procedure 
PROCEDURE enableObject :
/*------------------------------------------------------------------------------
  Purpose   : Override to enable browse.   
  Parameters: 
  Notes     :       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hBrowse AS HANDLE     NO-UNDO.
  {get BrowseHandle hBrowse}.
  hBrowse:SENSITIVE = TRUE.

  RUN SUPER. 

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fetchDataSet) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE fetchDataSet Procedure 
PROCEDURE fetchDataSet :
/*------------------------------------------------------------------------------
  Purpose:     Changes/Resets Browse's states depending on action which occurs.
  Parameters:  pcState AS CHARACTER 
               Possible values are: 'BatchStart', 'BatchEnd', 'NextStart'
               'NextEnd', 'PrevStart', 'PrevEnd'.
  Notes:       Used internally.
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pcState      AS CHARACTER NO-UNDO.
    
  DEFINE VARIABLE hBrowse             AS HANDLE NO-UNDO.    

  {get BrowseHandle hBrowse}.
  CASE pcState :
    WHEN 'LastStart':U THEN 
    DO:
      hBrowse:SET-REPOSITIONED-ROW(hBrowse:DOWN,"ALWAYS":U).
      hBrowse:REFRESHABLE = NO.    
    END.
    WHEN 'BatchStart':U THEN 
      hBrowse:REFRESHABLE = NO.
    WHEN 'LastEnd':U THEN 
    DO:
      /* if a get-last was used while the browse was sleeping, the browse will 
         wake up completetely empty, so reposition it to current before the 
         wake up call. */
      hBrowse:QUERY:REPOSITION-BACKWARDS(1). 
      hBrowse:REFRESHABLE = YES no-error. /* keep silent about sizing issues*/

      /* This is/was a workaround to "wake-up" an updatable browse when running 
         on an Appserver. Probably not necessary after the reposition-backwards
         was added just before the refresh. (If the cell had focus before 
         fetchLast it did not detect that anything had changed and all rows 
         became invisible. This particular condition can be detected as 
         hBrowse:num-entries returned 0), 
         but by doing this in all cases we get an additional benefit as an 
         updatable browse will keep focus in the current cell */ 
      IF FOCUS = hBrowse THEN
        APPLY "ENTRY":U TO hBrowse. 
    END.
    WHEN 'BatchEnd':U THEN 
    DO:
      hBrowse:REFRESHABLE = YES no-error. /* keep silent about sizing issues*/
      RUN adjustReposition IN TARGET-PROCEDURE.
    END.
    WHEN 'PrevStart':U THEN
      hBrowse:SET-REPOSITIONED-ROW(1,"ALWAYS":U).
    WHEN 'NextStart':U THEN
      hBrowse:SET-REPOSITIONED-ROW(hBrowse:DOWN,"ALWAYS":U).    
    WHEN 'NextEnd':U OR WHEN 'PrevEnd':U THEN
      hBrowse:SET-REPOSITIONED-ROW(hBrowse:DOWN,"CONDITIONAL":U).
  END CASE.  
  RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-filterActive) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE filterActive Procedure 
PROCEDURE filterActive :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER plActive AS LOGICAL NO-UNDO.

DEFINE VARIABLE hToolbarSource AS HANDLE.
DEFINE VARIABLE cToolbarSources AS CHARACTER.

    cToolbarSources = DYNAMIC-FUNCTION('linkHandles' IN TARGET-PROCEDURE, 'toolbar-source').
    IF cToolbarSources <> "" THEN DO:
        hToolbarSource = WIDGET-HANDLE(ENTRY(1,cToolbarSources)).
        IF plActive 
            THEN RUN updateState IN hToolbarSource ("FilterTickOn").
            ELSE RUN updateState IN hToolbarSource ("FilterTickOff").       
    END.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-initializeColumnSettings) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeColumnSettings Procedure 
PROCEDURE initializeColumnSettings :
/*------------------------------------------------------------------------------
  Purpose:     Initialize Column Settings and properties for a browser
  Parameters:  <none>
  Notes:       Sets FieldHandles and EnabledHandles properties. This used to be 
               in initializeObject. 
               Called from inititializeObject.
------------------------------------------------------------------------------*/
DEFINE VARIABLE cColDataEntry          AS CHARACTER  NO-UNDO.
DEFINE VARIABLE iBGColor               AS INTEGER    NO-UNDO.
DEFINE VARIABLE iFGColor               AS INTEGER    NO-UNDO.
DEFINE VARIABLE iSeparatorFGColor      AS INTEGER    NO-UNDO.
DEFINE VARIABLE cColumnBGColors        AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cColumnFGColors        AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cColumnLabelBGColors   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cColumnLabelFGColors   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cColumnLabelFonts      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cColumnLabels          AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cColumnWidths          AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cColumnFonts           AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cColumnDelimiters      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cColumnItems           AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cColumnItemPairs       AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cColumnInnerLines      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cColumnSorts           AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cColumnMaxChars        AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cColumnAutoCompletions AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cColumnUniqueMatches   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cDefaultColumnData     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cEnabledFields         AS CHARACTER  NO-UNDO INIT "":U.
DEFINE VARIABLE cEnabledHandles        AS CHARACTER  NO-UNDO INIT "":U.
DEFINE VARIABLE cFieldHandles          AS CHARACTER  NO-UNDO INIT "":U.
DEFINE VARIABLE cFieldSecurity         AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cSavedColumnData       AS CHARACTER  NO-UNDO.
DEFINE VARIABLE dAllWidth              AS DECIMAL    NO-UNDO.
DEFINE VARIABLE dTotalWidth            AS DECIMAL    NO-UNDO.
DEFINE VARIABLE hBrowse                AS HANDLE     NO-UNDO.
DEFINE VARIABLE hColumn                AS HANDLE     NO-UNDO.
DEFINE VARIABLE hDataSource            AS HANDLE     NO-UNDO.
DEFINE VARIABLE hLastColumn            AS HANDLE     NO-UNDO.
DEFINE VARIABLE iColDataEntry          AS INTEGER    NO-UNDO.
DEFINE VARIABLE iFieldPos              AS INTEGER    NO-UNDO.
DEFINE VARIABLE lQualFields            AS LOGICAL    NO-UNDO.
DEFINE VARIABLE cColumnRef             AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cListItems             AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cListItemPairs         AS CHARACTER  NO-UNDO.

  &SCOPED-DEFINE xp-assign
  {get BrowseHandle hBrowse}
  {get DataSource hDataSource}
  {get EnabledFields cEnabledFields}
  {get FieldSecurity cFieldSecurity}
  {get SavedColumnData cSavedColumnData}
  {get BrowseColumnBGColors cColumnBGColors}
  {get BrowseColumnFGColors cColumnFGColors}
  {get BrowseColumnLabelBGColors cColumnLabelBGColors}
  {get BrowseColumnLabelFGColors cColumnLabelFGColors}
  {get BrowseColumnLabelFonts cColumnLabelFonts}
  {get BrowseColumnLabels cColumnLabels}
  {get BrowseColumnWidths cColumnWidths}
  {get BrowseColumnFonts cColumnFonts}
  {get BrowseColumnDelimiters cColumnDelimiters}
  {get BrowseColumnItems cColumnItems}
  {get BrowseColumnItemPairs cColumnItemPairs}
  {get BrowseColumnInnerLines cColumnInnerLines}
  {get BrowseColumnSorts cColumnSorts}
  {get BrowseColumnMaxChars cColumnMaxChars}
  {get BrowseColumnAutoCompletions cColumnAutoCompletions}
  {get BrowseColumnUniqueMatches cColumnUniqueMatches}.
  &UNDEFINE xp-assign

  IF VALID-HANDLE(hBrowse) THEN
    ASSIGN hColumn   = hBrowse:FIRST-COLUMN  NO-ERROR.
  ASSIGN dTotalWidth = 0
         dAllWidth   = 0
         lQualfields = INDEX(cEnabledFields,'.':U) > 0.

  DO WHILE VALID-HANDLE(hColumn):
    ASSIGN
      iFieldPos     = iFieldPos + 1 
      cFieldHandles = cFieldHandles 
                    + (IF cFieldHandles NE "":U THEN "," ELSE "":U) 
                    + STRING(hColumn)
      cColumnRef    = IF lQualfields 
                      THEN hColumn:TABLE + '.':U + hColumn:NAME
                      ELSE hColumn:NAME.
    IF LOOKUP(cColumnRef, cEnabledFields) NE 0 THEN
      cEnabledHandles = cEnabledHandles 
                      +  (IF cEnabledHandles NE "":U THEN ",":U ELSE "":U)
                      + STRING(hColumn).
    ASSIGN 
        hColumn:COLUMN-BGCOLOR = IF NUM-ENTRIES(cColumnBGColors, CHR(5)) >= iFieldPos AND
                                    ENTRY(iFieldPos, cColumnBGColors, CHR(5)) NE "?":U THEN
                                      INTEGER(ENTRY(iFieldPos, cColumnBGColors, CHR(5)))
                                 ELSE hColumn:COLUMN-BGCOLOR
        hColumn:COLUMN-FGCOLOR = IF NUM-ENTRIES(cColumnFGColors, CHR(5)) >= iFieldPos AND
                                    ENTRY(iFieldPos, cColumnFGColors, CHR(5)) NE "?":U THEN
                                      INTEGER(ENTRY(iFieldPos, cColumnFGColors, CHR(5)))
                                 ELSE hColumn:COLUMN-FGCOLOR
        hColumn:LABEL-BGCOLOR  = IF NUM-ENTRIES(cColumnLabelBGColors, CHR(5)) >= iFieldPos AND
                                    ENTRY(iFieldPos, cColumnLabelBGColors, CHR(5)) NE "?":U THEN
                                      INTEGER(ENTRY(iFieldPos, cColumnLabelBGColors, CHR(5)))
                                 ELSE hColumn:LABEL-BGCOLOR 
        hColumn:LABEL-FGCOLOR  = IF NUM-ENTRIES(cColumnLabelFGColors, CHR(5)) >= iFieldPos AND
                                    ENTRY(iFieldPos, cColumnLabelFGColors, CHR(5)) NE "?":U THEN
                                      INTEGER(ENTRY(iFieldPos, cColumnLabelFGColors, CHR(5)))
                                 ELSE hColumn:LABEL-FGCOLOR 
        hColumn:LABEL-FONT     = IF NUM-ENTRIES(cColumnLabelFonts, CHR(5)) >= iFieldPos AND
                                    ENTRY(iFieldPos, cColumnLabelFonts, CHR(5)) NE "?":U THEN
                                      INTEGER(ENTRY(iFieldPos, cColumnLabelFonts, CHR(5)))
                                 ELSE hColumn:LABEL-FONT 
        hColumn:LABEL          = IF NUM-ENTRIES(cColumnLabels, CHR(5)) >= iFieldPos AND
                                    ENTRY(iFieldPos, cColumnLabels, CHR(5)) NE "?":U THEN
                                      ENTRY(iFieldPos, cColumnLabels, CHR(5))
                                 ELSE hColumn:LABEL
        hColumn:WIDTH-CHARS    = IF NUM-ENTRIES(cColumnWidths, CHR(5)) >= iFieldPos AND
                                    ENTRY(iFieldPos, cColumnWidths, CHR(5)) NE "?":U THEN
                                      DECIMAL(ENTRY(iFieldPos, cColumnWidths, CHR(5)))
                                 ELSE hColumn:WIDTH-CHARS
        hColumn:COLUMN-FONT    = IF NUM-ENTRIES(cColumnFonts, CHR(5)) >= iFieldPos THEN
                                    INTEGER(ENTRY(iFieldPos, cColumnFonts, CHR(5)))
                                 ELSE hColumn:COLUMN-FONT

        hColumn:AUTO-RESIZE    = TRUE
        hColumn:RESIZABLE      = TRUE
       NO-ERROR.

       /*Sets the combo-box properties if the column is view-as combo-box, and the browser is a dynamic broser.
         For static SmartDataBrowsers the view-as attribute is set in the static definition of the browser,
         therefore there is not need to read and set the view-as atributes again.*/
       IF hColumn:TYPE = "COMBO-BOX":U THEN
       DO:
            ASSIGN hColumn:DELIMITER = IF NUM-ENTRIES(cColumnDelimiters, CHR(5)) >= iFieldPos AND
                                          ENTRY(iFieldPos, cColumnDelimiters, CHR(5)) NE "?":U THEN
                                            ENTRY(iFieldPos, cColumnDelimiters, CHR(5))
                                       ELSE IF hColumn:DELIMITER NE ? THEN hColumn:DELIMITER
                                            ELSE ","
                   hColumn:INNER-LINES = IF NUM-ENTRIES(cColumnInnerLines, CHR(5)) >= iFieldPos AND
                                          ENTRY(iFieldPos, cColumnInnerLines, CHR(5)) NE "?":U THEN
                                            INT(ENTRY(iFieldPos, cColumnInnerLines, CHR(5)))
                                        ELSE IF hColumn:INNER-LINES NE ? THEN hColumn:INNER-LINES
                                             ELSE 5
                   hColumn:SORT       = IF NUM-ENTRIES(cColumnSorts, CHR(5)) >= iFieldPos AND
                                          ENTRY(iFieldPos, cColumnSorts, CHR(5)) NE "?":U THEN
                                            (IF ENTRY(iFieldPos, cColumnSorts, CHR(5)) = "Y":U THEN YES ELSE NO)
                                        ELSE IF hColumn:SORT NE ? THEN hColumn:SORT
                                             ELSE FALSE.

                   IF NUM-ENTRIES(cColumnItems, CHR(5)) >= iFieldPos AND ENTRY(iFieldPos, cColumnItems, CHR(5)) NE "?":U THEN
                        ASSIGN cListItems = ENTRY(iFieldPos, cColumnItems, CHR(5)).
                   ELSE IF NUM-ENTRIES(cColumnItemPairs, CHR(5)) >= iFieldPos AND ENTRY(iFieldPos, cColumnItemPairs, CHR(5)) NE "?":U THEN
                        ASSIGN cListItemPairs = ENTRY(iFieldPos, cColumnItemPairs, CHR(5)).

                   IF cListItems NE "":U
                      THEN ASSIGN hColumn:LIST-ITEMS = cListItems.
                      ELSE IF cListItemPairs NE "":U
                           THEN ASSIGN hColumn:LIST-ITEM-PAIRS = cListItemPairs.

            IF hColumn:SUBTYPE = "DROP-DOWN":U THEN
            ASSIGN hColumn:MAX-CHARS = IF NUM-ENTRIES(cColumnMaxChars, CHR(5)) >= iFieldPos AND
                                          ENTRY(iFieldPos, cColumnMaxChars, CHR(5)) NE "?":U THEN
                                            INT(ENTRY(iFieldPos, cColumnMaxChars, CHR(5)))
                                        ELSE IF hColumn:MAX-CHARS NE ? THEN hColumn:MAX-CHARS
                                             ELSE 255
                   hColumn:AUTO-COMPLETION = IF NUM-ENTRIES(cColumnAutoCompletions, CHR(5)) >= iFieldPos AND
                                          ENTRY(iFieldPos, cColumnAutoCompletions, CHR(5)) NE "?":U THEN
                                            (IF ENTRY(iFieldPos, cColumnAutoCompletions, CHR(5)) = "Y":U THEN YES ELSE NO)
                                        ELSE IF hColumn:AUTO-COMPLETION NE ? THEN hColumn:AUTO-COMPLETION
                                             ELSE FALSE
                   hColumn:UNIQUE-MATCH = IF NUM-ENTRIES(cColumnUniqueMatches, CHR(5)) >= iFieldPos AND
                                          ENTRY(iFieldPos, cColumnUniqueMatches, CHR(5)) NE "?":U THEN
                                            (IF ENTRY(iFieldPos, cColumnUniqueMatches , CHR(5)) = "Y":U THEN YES ELSE NO)
                                        ELSE IF hColumn:UNIQUE-MATCH NE ? THEN hColumn:UNIQUE-MATCH
                                             ELSE FALSE.
       END. /*Field view-as*/

    cDefaultColumnData = cDefaultColumnData
                       + (IF NUM-ENTRIES(cDefaultColumnData, CHR(3)) > 0 
                          THEN CHR(3) ELSE '':U)
                       + cColumnRef + CHR(4) + STRING(hColumn:WIDTH-PIXELS).

    DO iColDataEntry = 1 TO NUM-ENTRIES(cSavedColumnData, CHR(3)):
      cColDataEntry = ENTRY(iColDataEntry, cSavedColumnData, CHR(3)).
      IF ENTRY(1, cColDataEntry, CHR(4)) = cColumnRef THEN
        hColumn:WIDTH-PIXELS = INTEGER(ENTRY(2, cColDataEntry, CHR(4))) NO-ERROR. 
    END.  /* do iNumCol to entries in saved column data */

    dAllWidth = dAllWidth + hColumn:WIDTH-PIXELS.
    /* Hide/Disable Secured columns */
    IF NUM-ENTRIES(cFieldSecurity) >= iFieldPos 
    AND ENTRY(iFieldPos,cFieldSecurity) NE "":U THEN
    DO:
      IF ENTRY(iFieldPos,cFieldSecurity) = "Hidden":U THEN
        ASSIGN hColumn:VISIBLE = FALSE.
      ELSE 
        ASSIGN hColumn:READ-ONLY = TRUE NO-ERROR. /* It could be the column is not enabled which would give an error when assigning READ-ONLY */
    END.
    ELSE
      ASSIGN dTotalWidth = dTotalWidth + hColumn:WIDTH-PIXELS.

    hLastColumn = hColumn.
    hColumn = hColumn:NEXT-COLUMN.
  END.              

  /* If a column is now hidden due to security, add the width
     of that column to the width of the last visible column to
     use up all the original available space */
  IF dTotalWidth < dAllWidth THEN
    hLastColumn:WIDTH-PIXELS = hLastColumn:WIDTH-PIXELS + (dAllWidth - dTotalWidth).

  &SCOPED-DEFINE xp-assign
  {set FieldHandles cFieldHandles}
  {set EnabledHandles cEnabledHandles}
  /* Stores default column positions and sizes to support reset to default */
  {set DefaultColumnData cDefaultColumnData}.
  &UNDEFINE xp-assign

    ASSIGN ERROR-STATUS:ERROR = NO.
    RETURN.
END PROCEDURE.  /* initializeColumnSettings */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-initializeObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeObject Procedure 
PROCEDURE initializeObject :
/*---------------------------------------------------------------------------
  Purpose:     SmartDataBrowser version of initializeObject which executes 
               code mainly to set properties values.
  Parameters:  <none>
  Notes:       May create a dynamic 'Search' FILL-IN if the SearchField
               property is set.
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hDataSource       AS HANDLE NO-UNDO.
  DEFINE VARIABLE hBrowse           AS HANDLE NO-UNDO.
  DEFINE VARIABLE iMaxGuess         AS INTEGER   NO-UNDO.
  DEFINE VARIABLE cEnabledFields    AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cUIBMode          AS CHARACTER NO-UNDO.
  DEFINE VARIABLE lSaveSource       AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE cTarget           AS CHARACTER NO-UNDO.
  DEFINE VARIABLE lQueryBrowsed     AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE cFields           AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cBrowseFields     AS CHARACTER NO-UNDO.
  DEFINE VARIABLE hDataQuery        AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hTableio          AS HANDLE    NO-UNDO.
  DEFINE VARIABLE iField            AS INTEGER   NO-UNDO.
  DEFINE VARIABLE cField            AS CHARACTER NO-UNDO.
  DEFINE VARIABLE hField            AS HANDLE    NO-UNDO.
  DEFINE VARIABLE cValidation       AS CHARACTER NO-UNDO.
  DEFINE VARIABLE lCalcWidth        AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE iNumDown          AS INTEGER   NO-UNDO.
  DEFINE VARIABLE hQueryRowObject   AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hQueryHandle      AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hTarget           AS HANDLE     NO-UNDO.
  DEFINE VARIABLE lRowDisplay       AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE iSuper            AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cSupers           AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cLaunch           AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE rRowid            AS ROWID      NO-UNDO.
  DEFINE VARIABLE lPopupActive      AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lMovable          AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lSortable         AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lFitLastColumn    AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lUseRepository    AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE hSDO              AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cTooltip          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lSourceNewMode    AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE hSearchField      AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cDefaultTable     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSourceType       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lSBO              AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cSourceFieldName  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cQueryTables      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cViewAs           AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cWidgetType       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cColumnTypes      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lDynamic          AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cWidgetIDFileName AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cEnabledWhenNew   AS CHARACTER  NO-UNDO.

  ASSIGN ghTargetProcedure = TARGET-PROCEDURE. /* store TARGET-PROCEDURE so the source can identify it if it's an SBO */

  &SCOPED-DEFINE xp-assign
  {get UIBMode cUIBMode}
  /* First determine whether this is a "dynamic" browser (actually an
     empty static browser to be filled in at runtime). */
  {get DataSource hDataSource}    /* Proc. handle of our SDO. */
  {get BrowseColumnTypes cColumnTypes} /*Column types: fill-in, toggle-box or combo-box*/
  {get BrowseHandle hBrowse}.     /* Handle of the browse widget. */
  &UNDEFINE xp-assign

  /* Retrieves column positions and sizes, if they exist, from the profile 
     manager for this browser instance */
  IF VALID-HANDLE(gshProfileManager) THEN 
    RUN readSavedSettings IN TARGET-PROCEDURE.

  IF VALID-HANDLE(hDataSource) THEN
  DO:
    &SCOPED-DEFINE xp-assign
    /* If SDO is in new mode the record is not in the query yet, 
       so avoid reposition and do a find-by-rowid at end */
    {get NewMode lSourceNewMode hDataSource}
    /* Reassign the Browse to use the Data Object's query. */
    {get DataHandle hDataQuery hDataSource}   
    {get ObjectType cSourceType hDataSource}
    .
    &UNDEFINE xp-assign
    lSBO = cSourceType = 'SmartBusinessObject':U.

    IF NOT lSBO THEN
      {get QueryTables cQueryTables hDataSource}.

    IF VALID-HANDLE(hDataQuery) THEN
    DO:
      /* keep track of the SDOs position */
      IF hDataQuery:IS-OPEN THEN
        rRowid = hDataQuery:GET-BUFFER-HANDLE(1):ROWID. 
    END.
    /* The sort column used to be set here.  It is now set from the SDO initialization */
    hBrowse:ALLOW-COLUMN-SEARCHING = TRUE.
    IF hBrowse:NUM-COLUMNS = 0 THEN
    DO:
      lDynamic = YES.            /* Signal to code below. */

      IF DYNAMIC-FUNCTION('getUseWidgetID':U IN TARGET-PROCEDURE) THEN
      DO:
          ASSIGN cWidgetIDFileName = ?
                 cWidgetIDFileName = DYNAMIC-FUNCTION('getWidgetIDFileName' IN DYNAMIC-FUNCTION('getContainerSource' IN TARGET-PROCEDURE)) NO-ERROR.

          IF cWidgetIDFileName NE ? AND cWidgetIDFileName NE "" THEN 
              ASSIGN hBrowse:WIDGET-ID = 6.
      END.

      /* Get Displayed and Enabled fields at runtime. */  
      IF VALID-HANDLE(hDataQuery) THEN         
      DO:
        ASSIGN hBrowse:QUERY = hDataQuery NO-ERROR.     /* Attach this to the Browse.*/      
        ERROR-STATUS:ERROR = NO.
        /* Synch the browse with the data source unless it has 
           a new unsaved record */
        IF NOT lSourceNewMode AND rRowid <> ? THEN 
          hDataQuery:REPOSITION-TO-ROWID(rRowid).

        /* If the browse became visible when the QUERY was attached above then 
           turn off fit-last-column since the first column will expand to the
           full length when using add-like below
           (the reason that this is down here was that there was a run 
           dataAvailable after the repos, which theoretically may change
           visibility.. can probably be moved up closer if needed..  )   */
        IF hBrowse:VISIBLE THEN
          ASSIGN
            lFitLastColumn = hBrowse:FIT-LAST-COLUMN
            hBrowse:FIT-LAST-COLUMN = FALSE.
      END.

      &SCOPED-DEFINE xp-assign
      {get EnabledFields cEnabledFields}
      {get DisplayedFields cFields}.
      &UNDEFINE xp-assign
      /* If DisplayedFields is blank,  take all fields from the SDO.
         If EnabledFields is blank, take all updatable fields from the SDO 
         if valid Tableio-Source. */
      cBrowseFields = ?.

      IF lSBO THEN 
        {get DataSourceNames cDefaultTable}.
      /* If no fields are specified figure out default */
      IF cFields = "":U THEN
      DO:

        {get DataColumns cFields hDataSource}.
        IF NOT lSBO THEN 
          {get DataTable cDefaultTable hDataSource}. 
        cBrowseFields = "":U.
      END. /* cFields "" */
      IF VALID-HANDLE(hBrowse:QUERY) THEN
      DO iField = 1 TO NUM-ENTRIES(cFields):
        cField = ENTRY(iField, cFields) .
        /* Sourcefieldname is used to lookup in the source and need to be 
           qualified if the source is an sbo. The column list is qualified 
           if it was retrieved from the sbo above if DisplayedFields 
           is blank, but should be stored unqualified in the object as this is 
           how they are stored and visualized in tools etc.
           Dataview and SDO targets uses the list as is, but the qualifier
           is used to filter dataview columns for the default case. 
           (The dataview can also be accessed with no qualifiers, which 
            implies columns from the DataTable)  */            
        IF lSBO THEN
        DO:
          IF INDEX(cField,'.':U) = 0 THEN
            cSourceFieldName = cDefaultTable + '.':U + cField.
          ELSE 
            ASSIGN
              cSourceFieldName = cField
              cField           = ENTRY(2,cField,'.':U).
        END.
        ELSE 
          cSourceFieldName = cField.

        /* Default table is set above if no columns are specified in which case
           only columns belonging to the default table (or sdo) is added */
        IF cDefaultTable = '' OR INDEX(cSourceFieldName,'.':U) = 0 
        OR ENTRY(1,cSourceFieldName,'.':U) = cDefaultTable THEN
        DO:
          /* If DataView source (fields qualified and not an SBO) ignore fields 
             if the table is not in the query. */
          IF NOT lSBO 
          AND INDEX(cField, '.':U) > 0 
          AND LOOKUP(ENTRY(1,cfield,'.'),cQueryTables) = 0 THEN
            NEXT.

          hField = {fnarg columnHandle cSourceFieldName hDataSource}.

          /* Add the requested columns to the browse. */
          IF VALID-HANDLE(hField) AND (cBrowseFields = ? OR NOT CAN-DO("BLOB,CLOB":U,hField:DATA-TYPE)) THEN
          DO:

             ASSIGN cViewAS = IF NUM-ENTRIES(cColumnTypes, CHR(5)) >= iField 
                              THEN ENTRY(iField, cColumnTypes, CHR(5)) 
                              ELSE "":U.

             CASE cViewAs:
                 WHEN "TB":U THEN ASSIGN cWidgetType  = "TOGGLE-BOX":U.
                 WHEN "DD":U  THEN ASSIGN cWidgetType = "DROP-DOWN":U.
                 WHEN "DDL":U THEN ASSIGN cWidgetType = "DROP-DOWN-LIST":U.

                 OTHERWISE ASSIGN cWidgetType = "Fill-in".
            END CASE.

             IF hField:VALIDATE-EXPRESSION NE ? THEN 
             DO: 
               cValidation = hField:VALIDATE-EXPRESSION.
               hField:VALIDATE-EXPRESSION = "":U.
               hBrowse:ADD-LIKE-COLUMN(hField, -1, cWidgetType).
               hField:VALIDATE-EXPRESSION = cValidation.
             END.  /* validate-expression ne ? */
             ELSE hBrowse:ADD-LIKE-COLUMN(hField, -1, cWidgetType).

             IF cBrowseFields NE ? THEN /* blank fields list, must set it */
                 cBrowseFields = cBrowseFields 
                               + (IF cBrowseFields = "":U THEN "":U ELSE ",":U) 
                               + cField.
          END. /* IF valid-handle */
        END. /* if default table = '' or matching  */
      END.  /* DO iField */
      /* blank fields list, must set it */
      IF cBrowseFields NE ? THEN 
      DO:           
        {set DisplayedFields cBrowseFields}.
        cFields = cBrowseFields.
      END.

      /* set fit-last-column (expandable) back if turned off above*/
      IF lFitLastColumn THEN
        hBrowse:FIT-LAST-COLUMN = TRUE.

      {get UseRepository lUseRepository}.
      IF cEnabledFields = "":U AND NOT lUseRepository THEN
      DO:
        {get TableIOSource hTableIO}.
        IF VALID-HANDLE(hTableIO) AND VALID-HANDLE (hDataSource) THEN
        DO:
          {get UpdatableColumns cEnabledFields hDataSource}.

          /* If display specified, but not Enabled, ensure removal of 
             fields from the Enable list not in the Display list. */
          DO iField = 1 TO NUM-ENTRIES(cEnabledFields):
            cField = ENTRY(iField, cEnabledFields).
            IF LOOKUP(cField, cFields) = 0 THEN
              ASSIGN cEnabledFields = REPLACE(',':U + cEnabledFields + ',':U, 
                       ',':U + cField + ',':U, ',':U)
                     cEnabledFields = 
                       SUBSTR(cEnabledFields, 2, LENGTH(cEnabledFields) - 2,
                       "CHARACTER":U).
          END. /* DO iField */
          {set EnabledFields cEnabledFields}.
        END.   /*  IF TableIOSource */
      END.   /* IF cEnabledFields "" */
 
      {get TOOLTIP cTooltip}.
      hBrowse:TOOLTIP = cTooltip.
    END.   /* END DO IF NUM-COLUMNS = 0 -- "dynamic" browser */
  END.

  /* We need to set expandable to TRUE here when CalcWidth is TRUE before
     the browse is viewed so that calcWidth can calculate column widths
     correctly. */
  {get CalcWidth lCalcWidth}.
  IF NOT (cUIBMode BEGINS "Design":U) AND lCalcWidth THEN 
    hBrowse:EXPANDABLE = FALSE.

  IF VALID-HANDLE(hDataSource) THEN
  DO:
    {get DataQueryBrowsed lQueryBrowsed hDataSource}.
    IF lQueryBrowsed THEN
    DO:
      DYNAMIC-FUNCTION("showMessage":u IN TARGET-PROCEDURE,
        "SDO query cannot be browsed by more than one SmartDataBrowser.":U).
      RETURN "ADM-ERROR":U.
    END.
    {set DataQueryBrowsed YES hDataSource}. 
  END.

  /* A non-repository browser only defines the default-action trigger if 
     FolderWindowToLaunch is set (or in setActionEvent).
    (This allows support for a user-defined static triggers for non-repos browsers)*/    
  IF NOT lUseRepository THEN 
    {get FolderWindowToLaunch cLaunch}.

  IF lUseRepository OR cLaunch > '':U THEN
    ON 'DEFAULT-ACTION':U OF hBrowse PERSISTENT RUN defaultAction IN TARGET-PROCEDURE. 

  /* The following links the ROW-DISPLAY trigger in with the rowDisplay 
     procedure or to support scrolling of the remote query.*/
  {get ScrollRemote lRowDisplay}.
  /* We also need to add rowdisplay trigger if any super BELOW browser.p 
     has a rowDisplay entry */  
  IF NOT lRowDisplay THEN
  DO:
    cSupers = TARGET-PROCEDURE:SUPER-PROCEDURES.
    DO iSuper = 1 TO NUM-ENTRIES(cSupers):
      hTarget = WIDGET-HANDLE(ENTRY(iSuper,cSupers)).

      IF hTarget = THIS-PROCEDURE THEN 
        LEAVE.

      IF LOOKUP('rowDisplay':U, hTarget:INTERNAL-ENTRIES) NE 0 THEN
      DO:
        lRowDisplay = YES.
        LEAVE.
      END.
    END.
  END.

  IF lRowDisplay THEN
    ON ROW-DISPLAY OF hBrowse PERSISTENT RUN rowDisplay IN TARGET-PROCEDURE. 
    
  /* set column data (label, width, etc.) and properties (FieldHandles ..)*/
  RUN initializeColumnSettings IN TARGET-PROCEDURE NO-ERROR.
  RUN SUPER.
  IF RETURN-VALUE = "ADM-ERROR":U THEN
    RETURN "ADM-ERROR":U.
  
  /* If this object or its parent is in design mode, then don't
     open the query or do any of the rest of this initialization code. */

  IF cUIBMode BEGINS "Design":U THEN 
    RETURN.

  /* If we have no TableIO-Source, or if it's an Update panel in "Update" mode,
     or if there's no Update-Target, then the Browse should be disabled. */
  &SCOPED-DEFINE xp-assign
  {get SaveSource lSaveSource}
  {get UpdateTarget cTarget}
  {get DataSource hDataSource}
  {get BrowseHandle hBrowse}.
  &UNDEFINE xp-assign
  IF (NOT lSaveSource) OR (cTarget = "":U) THEN 
  DO:
    RUN disableFields IN TARGET-PROCEDURE('All':U).
    /* This may need to be reflected in the tableiosource */  
    PUBLISH 'resetTableio':U FROM TARGET-PROCEDURE.
  END.  
  ELSE 
  do:
    /* A static enabled browser is enabled through the definition.  
       EnabledWhenNew columns must be disabled. 
       (we could actually avoid running enablefields, but it is must set
        FieldEnabled and most importantly might also be overidden) */   
    if not lDynamic then 
    do: 
      {get EnabledWhenNew cEnabledWhenNew}.
      if cEnabledWhenNew > "" then 
        run disableFieldList in target-procedure(cEnabledWhenNew).    
    end.
    run enableFields IN TARGET-PROCEDURE. 
  end.
  
  hBrowse:CREATE-ON-ADD = TRUE.
  
  IF VALID-HANDLE(hDataQuery) THEN
  DO:
    /* Else go ahead and attach the query and set the source's property.*/
    IF NOT lDynamic THEN       /* If dynamic, this has been done above. */
    DO:
      ASSIGN hBrowse:QUERY = hDataQuery NO-ERROR.
      ERROR-STATUS:ERROR = NO. 
    END.
  END.   /* VALID */
  
  IF VALID-HANDLE(hBrowse) THEN
  DO:  
    /* Get the RowObject temp-table in the query and set QueryRowObject from it */
    hQueryHandle = hBrowse:QUERY.
    IF VALID-HANDLE(hQueryHandle) THEN
      hQueryRowObject = hQueryHandle:GET-BUFFER-HANDLE(1).

    {set QueryRowObject hQueryRowObject}.

    RUN createSearchField IN TARGET-PROCEDURE.

    IF lCalcWidth THEN 
      RUN calcWidth IN TARGET-PROCEDURE.
    
    /* We initially set MAX-DATA-GUESS to Rows to Batch, MAX-DATA-GUESS
       later gets adjusted by calls to assignMaxGuess from data.p's 
       batch processing. In preview mode the SDO is not available.  */
    IF NOT (cUIBMode BEGINS "Preview":U) AND VALID-HANDLE(hDataSource) THEN 
    DO:
      {get RowsToBatch iMaxGuess hDataSource}.

      /* Setting max-data-guess to 0 gives a very strange effect, but in 
         if RowsToBatch is 0 we have all the records, so LastRowNum should 
         provide a guess (if the SDO is started)  */  
      IF iMaxGuess = 0 THEN
      DO:
        hDataSource = {fn getDataObjectHandle}.
        {get LastRowNum iMaxGuess hDataSource}.
      END.
      IF iMaxGuess > 0 THEN
        hBrowse:MAX-DATA-GUESS = iMaxGuess.
    END.  /* if not design mode */
 
    /* Sets column positions and sizes based on savedColumnData */
    RUN resetColumnSettings IN TARGET-PROCEDURE.
   
    /* Column movable and allow-column-searching are mutually exclusive, 
       column sorting (implemented with column-searching) takes precedence */
    &SCOPED-DEFINE xp-assign
    {get ColumnsMovable lMovable}
    {get ColumnsSortable lSortable}
    {get PopupActive lPopupActive}.
    &UNDEFINE xp-assign
    hBrowse:COLUMN-MOVABLE = IF lSortable THEN FALSE ELSE lMovable.
    hBrowse:ALLOW-COLUMN-SEARCHING = lSortable.
    IF lSortable THEN
      {fn showSort}. 
    IF lMovable AND lSortable THEN
      {set ColumnsMovable FALSE}.
    IF lPopupActive THEN 
      RUN createPopupMenu IN TARGET-PROCEDURE.
  END. /* VALID-HANDLE(hBrowse) */
  
  ghTargetProcedure = ?.  /* reset local storage of this. */

  RUN adjustReposition IN TARGET-PROCEDURE.

  /* Tell ourselves that we have data...  */  
  RUN dataAvailable IN TARGET-PROCEDURE ('DIFFERENT':U).
  
  /* If source is in ADD then simulate updateState('update') behavior 
     Also ensure the SDO is pointing to the new record again. 
     (several of the above statements will do an implicit repos)  */ 
  IF lSourceNewMode AND VALID-HANDLE(hQueryRowObject) THEN 
  DO:
    {get SearchHandle hSearchField}.
    ASSIGN  
      hSearchField:SENSITIVE = NO WHEN VALID-HANDLE(hSearchField)
      hBrowse:SENSITIVE      = NO.    
    IF rRowid <> ? AND rRowid <> hQueryRowObject:ROWID THEN  
      hQueryRowObject:FIND-BY-ROWID(rRowid).
  END.

  RETURN.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-launchFolderWindow) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE launchFolderWindow Procedure 
PROCEDURE launchFolderWindow :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pcContainerMode AS CHARACTER NO-UNDO.

DEFINE VARIABLE cFolderWindow     AS CHARACTER NO-UNDO.
DEFINE VARIABLE hContainerSource  AS HANDLE NO-UNDO.
DEFINE VARIABLE hFolderWindow     AS HANDLE NO-UNDO.    
DEFINE VARIABLE hWindowHandle     AS HANDLE NO-UNDO.
DEFINE VARIABLE cProcedureType    AS CHARACTER NO-UNDO.
DEFINE VARIABLE lMultiInstanceActivated AS LOGICAL NO-UNDO.

     /* This is the window that can view/modify/add the current record */
    {get FolderWindowToLaunch cFolderWindow}.

    IF cFolderWindow > "":U THEN
    DO:
      {get ContainerSource hContainerSource}.
      {get ContainerHandle hWindowHandle hContainerSource}.
      IF VALID-HANDLE(gshSessionManager) THEN
      DO:
        IF VALID-HANDLE(hContainerSource) THEN
          {get MultiInstanceActivated lMultiInstanceActivated hContainerSource}.

          RUN launchContainer IN gshSessionManager (                                                    
              INPUT cFolderWindow,    /* pcObjectFileName  */
              INPUT "":U,               /* pcPhysicalName    */
              INPUT "":U,               /* pcLogicalName     */
              NOT lMultiInstanceActivated,  /* plOnceOnly        */
              INPUT "":U,               /* pcInstanceAttributes */
              INPUT "":U,               /* pcChildDataKey    */
              INPUT "":U,               /* pcRunAttribute    */
              INPUT pcContainerMode,  /* pcContainerMode   */
              INPUT hWindowHandle,    /* phParentWindow    */
              INPUT hContainerSource, /* phParentProcedure */
              INPUT TARGET-PROCEDURE, /* phObjectProcedure */
              OUTPUT hFolderWindow,   /* phProcedureHandle */
              OUTPUT cProcedureType   /* pcProcedureType   */       
          ).
      END.    /* There is an available window to launch */
      ELSE DO: 
        IF VALID-HANDLE(hContainerSource) THEN
        DO:
          RUN constructObject IN hContainerSource 
            ( cFolderWindow,
              hWindowHandle,
              "ContainerMode":U + CHR(4) + pcContainerMode,
              OUTPUT hFolderWindow).    
          IF VALID-HANDLE(hFolderWindow) THEN
            RUN initializeObject IN hFolderWindow.
        END.
      END.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-linkStateHandler) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE linkStateHandler Procedure 
PROCEDURE linkStateHandler :
/*------------------------------------------------------------------------------
   Purpose: Override in order to run profile sort before the SDO is initialized  
Parameters: See smart.p   
     Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pcState   AS CHARACTER  NO-UNDO.
  DEFINE INPUT PARAMETER phObject  AS HANDLE     NO-UNDO.
  DEFINE INPUT PARAMETER pcLink    AS CHARACTER  NO-UNDO.
  
  RUN SUPER(pcState,phObject,pcLink).

  IF pcstate = 'add':U AND pcLink = 'DataSource':U  THEN
    RUN resetSortColumn IN TARGET-PROCEDURE (NO).

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
  Notes:       Contains code to locate a widget specific to browser's when 
               the qualifier is 'Browse'
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER pcWidget AS CHARACTER  NO-UNDO.
DEFINE OUTPUT PARAMETER phWidget AS HANDLE     NO-UNDO.
DEFINE OUTPUT PARAMETER phTarget AS HANDLE     NO-UNDO.

DEFINE VARIABLE cField             AS CHARACTER  NO-UNDO.
 
  IF NUM-ENTRIES(pcWidget, '.':U) > 1 AND ENTRY(1, pcWidget, '.':U) = 'Browse':U THEN
  DO:
    ASSIGN 
      cField     = DYNAMIC-FUNCTION('deleteEntry':U IN TARGET-PROCEDURE,
                                     INPUT 1,
                                     INPUT pcWidget,
                                     INPUT '.':U) 
      phWidget   =  DYNAMIC-FUNCTION('internalWidgetHandle':U IN TARGET-PROCEDURE,
                                      INPUT cField, INPUT 'DATA':U)
      phTarget   = TARGET-PROCEDURE NO-ERROR.
    IF phWidget NE ? THEN RETURN.      
  END.  /* if browser qualifier */
  ELSE RUN SUPER (INPUT pcWidget, OUTPUT phWidget, OUTPUT phTarget).
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-movableValueChanged) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE movableValueChanged Procedure 
PROCEDURE movableValueChanged :
/*------------------------------------------------------------------------------
  Purpose:     Handles value-changed event for the movable popup menu item
  Parameters:  
  Notes:       Movable and sortable are mutually exclusive
------------------------------------------------------------------------------*/
DEFINE VARIABLE hMovableItem  AS HANDLE     NO-UNDO.
DEFINE VARIABLE hSortableItem AS HANDLE     NO-UNDO.

  &SCOPED-DEFINE xp-assign
  {get MovableHandle hMovableItem}
  {get SortableHandle hSortableItem}
  {set ColumnsMovable hMovableItem:CHECKED}.
  &UNDEFINE xp-assign
  
  IF hSortableItem:CHECKED AND hMovableItem:CHECKED THEN
  DO:
    hSortableItem:CHECKED = FALSE.
    {set ColumnsSortable FALSE}.
  END.  /* both checked */

  IF hSortableItem:CHECKED THEN
    {fn showSort}.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-moveAndResizeColumns) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE moveAndResizeColumns Procedure 
PROCEDURE moveAndResizeColumns :
/*------------------------------------------------------------------------------
  Purpose:     Moves and resizes columns based on column data being passed to it
  Parameters:  pcColumnData AS CHAR
               Format of pcColumnData:
        column1name CHR(4) column1width CHR(3) column2name CHR(4) column2width etc...
  Notes:              
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER pcColumnData AS CHARACTER  NO-UNDO.

DEFINE VARIABLE cColumnEntry  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE hBrowse       AS HANDLE     NO-UNDO.
DEFINE VARIABLE hColumn       AS HANDLE     NO-UNDO.
DEFINE VARIABLE iColumnPos    AS INTEGER    NO-UNDO.
DEFINE VARIABLE iNumCols      AS INTEGER    NO-UNDO.
DEFINE VARIABLE hRO           AS HANDLE     NO-UNDO. 
DEFINE VARIABLE rCurRowid     AS ROWID      NO-UNDO.
 
  {get BrowseHandle hBrowse}.

/* Issue 12777 is caused by REFRESHABLE=YES which is commented out later on */
/* so this line must be commented also. Please do not remove commented code */
/* as it serves as a prevention mechanism for anyone adding the same code */
/* again and causing regressions */

/*   hBrowse:REFRESHABLE = NO.  */

  /* fix for issues 12635, 12777... */
  /* The following code is a workaround for a core bug in the browse */
  /* widget which causes the browse query to release the current query */
  /* buffer as a result of direct manipulation of certain attributes. */
  /* So, we need to save the current Rowid, if any, and re-find it later */
  hRO = hBrowse:QUERY:GET-BUFFER-HANDLE() NO-ERROR.
  IF VALID-HANDLE(hRO) AND hRO:AVAILABLE THEN
    rCurRowid = hRO:ROWID.
  
  DO iNumCols = 1 TO NUM-ENTRIES(pcColumnData, CHR(3)):
    ASSIGN
      cColumnEntry = ENTRY(iNumCols, pcColumnData, CHR(3))
      hColumn      = hBrowse:FIRST-COLUMN
      iColumnPos   = 1.

    DO WHILE VALID-HANDLE(hColumn):
      IF hColumn:NAME = ENTRY(1, cColumnEntry, CHR(4)) THEN
      DO:
        hBrowse:MOVE-COLUMN(iColumnPos, iNumCols) NO-ERROR.
        /* The with passed in here may be from inititalizeColumnSettings, 
           which would may have measured wrong width for the last column
           if the browse was hidden at start up. This would then cause error 
           messages here if for example the browse is too small to have 
           horizontal scrollbars: (The width specified .. is invalid. ... 
           horizontal scrollbars reduces the number of viewport rows below 
           the minimum. (6421) ) */  
        hColumn:WIDTH-PIXELS = INTEGER(ENTRY(2, cColumnEntry, CHR(4))) NO-ERROR.
        LEAVE.
      END.  /* if column name = entry */
      ASSIGN
        hColumn    = hColumn:NEXT-COLUMN
        iColumnPos = iColumnPos + 1.
    END.  /* do while column valid */
  END.  /* do iNumCols to column data entries */


  IF VALID-HANDLE(hRO) THEN 
    IF rCurRowid <> ? THEN 
      IF rCurRowid <> hRO:ROWID THEN     /* IF a valid buffer existed in the beginning... */
        hRO:FIND-BY-ROWID (rCurRowid, NO-LOCK). /* ...attempt to find saved */

  /* The real issue 12777... */
  /*   hBrowse:REFRESHABLE = YES.  */
  
  ERROR-STATUS:ERROR = NO.
  RETURN.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-offEnd) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE offEnd Procedure 
PROCEDURE offEnd :
/*------------------------------------------------------------------------------
  Purpose:     trigger code for OFF-END trigger of SmartdataBrowse
  Notes:       This procedure contains the code that was previously held in
               src/adm2/brsoffnd.i.
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hDataSource AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hBrowse     AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hFocus      AS HANDLE    NO-UNDO.
  DEFINE VARIABLE lModified   AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE cNewRecord  AS CHARACTER NO-UNDO.  
  DEFINE VARIABLE iLastRowNum AS INTEGER   NO-UNDO.
  DEFINE VARIABLE cMsg        AS CHARACTER NO-UNDO.
  DEFINE VARIABLE hSDO        AS HANDLE    NO-UNDO.
  DEFINE VARIABLE cQueryPos   AS CHARACTER NO-UNDO.

   /* If this object is browsing a DataObject query, then when we scroll 
      to the end, see if there are more rows in the database query 
      to be transferred to the RowObject query. */
    &SCOPED-DEFINE xp-assign  
    {get DataSource hDataSource}
    {get DataModified lModified}
    {get NewRecord cNewRecord}
    {get BrowseHandle hBrowse}
    .
    &UNDEFINE xp-assign 

    /* use the trick to make the SBO knwo who */
    ghTargetProcedure = TARGET-PROCEDURE.
    {get QueryPosition cQueryPos hDataSource}.
    ghTargetProcedure = ?.

    /* if the browser does not manage it's own query and it doesn't have */
    /* a DataSource or the DataSource has no records, then we don't need */
    /* to do anything here */
    IF NOT VALID-HANDLE(hDataSource) OR cQueryPos BEGINS "NoRecord":U THEN 
      RETURN.

    /* returns the SDO in any case also when the source is an SBO */
    {get DataObjectHandle hSDO}.     
    /* If we have already fetched the last row then return */
    {get LastRowNum iLastRowNum hSDO}.
    IF iLastRowNum NE ? THEN 
      RETURN. 
    
    IF lModified THEN 
    DO:                   
      cMsg = (IF cNewRecord = 'no':U 
              THEN '12':U 
              ELSE IF cNewRecord = 'add':U 
              THEN '13':U 
              ELSE '14':U).
      
      {fnarg showMessage cMsg}.

      RUN applyEntry IN TARGET-PROCEDURE (?).
      RETURN NO-APPLY.
    END.

    /* The offEnd trigger fires when adding a new row to an empty browse or
     when moving off the end of the browse when there are more records than 
     the visbile rows. In the first case, we do not want to refetch the next 
     browse if we are adding a new record so we return. */ 
     IF hBrowse:NEW-ROW AND (cNewRecord = "ADD":U OR cNewRecord = "Copy":U) THEN
        RETURN.

    ASSIGN hFocus  = FOCUS.         
    RUN fetchDataSet IN TARGET-PROCEDURE ('BatchStart':U).     
    
    IF KEYFUNCTION(KEYCODE(LAST-EVENT:LABEL)) = "PAGE-DOWN":U THEN
      hBrowse:SET-REPOSITIONED-ROW(1,"ALWAYS":U).
    ELSE 
      hBrowse:SET-REPOSITIONED-ROW(hBrowse:DOWN,"ALWAYS":U).

    PUBLISH 'fetchBatch':U FROM TARGET-PROCEDURE (YES).  /* yes -- move forwards */
    
    RUN fetchDataSet IN TARGET-PROCEDURE ('BatchEnd':U).      
    
    hBrowse:SET-REPOSITIONED-ROW (hBrowse:DOWN,"CONDITIONAL":U). 
   /* Empty list of rowids in rowDisplay if scrollRemote is yes 
       (avoid bfget field to large error) */
    {set VisibleRowReset TRUE}.
    
   /* Traditionally the browser just used run dataAvailable from the events,
      but this is now in a super-procedure and the sbo need to know the
      target, so we subscribe the source temporarily. */ 
    SUBSCRIBE PROCEDURE hDataSource TO 'DataAvailable':U IN TARGET-PROCEDURE.    
    PUBLISH 'dataAvailable':U FROM TARGET-PROCEDURE("DIFFERENT":U). 
    UNSUBSCRIBE PROCEDURE hDataSource TO 'DataAvailable':U IN TARGET-PROCEDURE.    

    IF VALID-HANDLE(hFocus) THEN        
      IF hFocus:PARENT = hBrowse:HANDLE THEN      
        RUN applyCellEntry IN TARGET-PROCEDURE
                           (IF KEYFUNCTION(KEYCODE(LAST-EVENT:LABEL)) = "TAB":U 
                            THEN ? 
                            ELSE hFocus:Name).    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-offHome) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE offHome Procedure 
PROCEDURE offHome :
/*------------------------------------------------------------------------------
  Purpose:     Trigger code for OFF-HOME trigger of SmartdataBrowse
  Notes:       This procedure contains the code that was previously held in
               src/adm2/brsoffhm.i.
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hDataSource  AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hFocus       AS HANDLE    NO-UNDO.
  DEFINE VARIABLE lModified    AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE cNewRecord   AS CHARACTER NO-UNDO. 
  DEFINE VARIABLE hCell        AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hCellEntry   AS HANDLE    NO-UNDO.  
  DEFINE VARIABLE iCount       AS INTEGER   NO-UNDO.
  DEFINE VARIABLE iFirstRowNum AS INTEGER   NO-UNDO.
  DEFINE VARIABLE hBrowse      AS HANDLE    NO-UNDO.
  DEFINE VARIABLE cMsg         AS CHARACTER NO-UNDO.
  DEFINE VARIABLE hSDO         AS HANDLE    NO-UNDO.

    /* returns the SDO in any case also when the source is an SBO */
    {get DataObjectHandle hSDO}.     
   
    /* If we have already fetched the first row then return */
    {get FirstRowNum iFirstRowNum hSDO}.
    IF iFirstRowNum NE ? THEN 
        RETURN. 
    
    {get DataModified lModified}.
    IF lModified THEN 
    DO:                     
      {get NewRecord cNewRecord}.    
      cMsg = (IF cNewRecord = 'no':U 
          THEN '12':U 
          ELSE IF cNewRecord = 'add':U 
          THEN '13':U 
          ELSE '14':U).
      RUN applyEntry IN TARGET-PROCEDURE (?).
      RETURN NO-APPLY.
    END.

    {get BrowseHandle hBrowse}.
    
    ASSIGN hFocus  = FOCUS.                
    RUN fetchDataSet IN TARGET-PROCEDURE ('BatchStart':U).     
    
    IF KEYFUNCTION(KEYCODE(LAST-EVENT:LABEL)) = "PAGE-UP":U THEN
      hBrowse:SET-REPOSITIONED-ROW(hBrowse:DOWN,"ALWAYS":U).
    ELSE
      hBrowse:SET-REPOSITIONED-ROW(1,"ALWAYS":U).

    PUBLISH 'fetchBatch':U FROM TARGET-PROCEDURE (NO). /* no -- move backwards */
      
    RUN fetchDataSet IN TARGET-PROCEDURE ('BatchEnd':U).      
    
    hBrowse:SET-REPOSITIONED-ROW (hBrowse:DOWN,"CONDITIONAL":U). 
    
    /* Empty list of rowids in rowDisplay if scrollRemote is yes 
      (avoid bfget field to large error) */
    &SCOPED-DEFINE xp-assign
    {set VisibleRowReset TRUE}
    {get DataSource hDataSource}.
    &UNDEFINE xp-assign
    
    IF VALID-HANDLE(hdataSource) THEN
    DO:
     /* Traditionally the browser just used run dataAvailable from the events,
        but this is now ina super-procedure and the sbo need to know the
        target, so we subscribe the source temporarily. */ 
      SUBSCRIBE PROCEDURE hDataSource TO 'DataAvailable':U IN TARGET-PROCEDURE.    
      PUBLISH 'dataAvailable':U FROM TARGET-PROCEDURE("DIFFERENT":U). 
      UNSUBSCRIBE PROCEDURE hDataSource TO 'DataAvailable':U IN TARGET-PROCEDURE.    
    END.
   
    IF KEYFUNCTION(KEYCODE(LAST-EVENT:LABEL)) = "BACK-TAB":U THEN DO:
      ASSIGN
        hCell = hBrowse:FIRST-COLUMN.
      DO iCount = 1 TO hBrowse:NUM-COLUMNS:
        ASSIGN 
         hCellEntry = hCell WHEN NOT hCell:READ-ONLY 
         hCell      = hCell:NEXT-COLUMN
         .
      END.
    END. /* IF "BACK-TAB" ... */
    ELSE IF VALID-HANDLE(hFocus) THEN        
      IF hFocus:PARENT = hBrowse:HANDLE THEN 
         hCellEntry = hFOCUS.      

    IF VALID-HANDLE(hCellEntry) THEN
      RUN applyCellEntry IN TARGET-PROCEDURE (hCellEntry:Name).
    

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-onEnd) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE onEnd Procedure 
PROCEDURE onEnd :
/*------------------------------------------------------------------------------
  Purpose:  Event handler for the 'END' event    
  Parameters:  <none>
   Notes:   This event need to call fetchLast in the DataSource for the normal 
            case when it is a true user event, but APPLY 'END' is also the  
            way to make the browse respond to a fetchLast in the DataSource. 
          - The isOkToFetch is used to check if the source already is at last
            and avoid calling unecessarily.
           (the abl will not apply 'end' twice and this is also part of the 
            endless loop protection)    
          - adjustReposition is (thus) called in any case 
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hBrowse       AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hSource       AS HANDLE     NO-UNDO.
  
  &scop xp-assign
  {get Browsehandle hBrowse}
  {get DataSource hSource}.
  &undefine xp-assign
  
  hBrowse:REFRESHABLE = NO.
  IF DYNAMIC-FUNCTION("isOkToFetch":U IN TARGET-PROCEDURE, "LAST":U) THEN
  DO:
    /* The SBO need to know who this is */
    ghTargetProcedure = TARGET-PROCEDURE.
    run fetchLast in hSource.
    ghTargetProcedure = ?. 
  END.  /* isOkToFetch = TRUE */
  hBrowse:REFRESHABLE = YES.  
  /* check if full browse and append data on top if necessary */
  run adjustReposition in target-procedure.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-onHome) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE onHome Procedure 
PROCEDURE onHome :
/*------------------------------------------------------------------------------
   Purpose: Event handler for the 'HOME' event    
Parameters: <none>
     Notes: This event need to call fetchFirst in the DataSource for the normal 
            case when it is a true user event, but APPLY 'END' is also the only 
            way to make the browse respond to a fetchLast in the DataSource. 
        -   We call adjustReposition to ensure the viewport is full 
            if necessary. 
           (the abl will not apply 'end' twice and this is also part of the 
            endless loop protection)    
          - adjustReposition is (thus) called in any case            
 -------------------------------------------------------------------------------*/
  DEFINE VARIABLE hBrowse   AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hSource   AS HANDLE     NO-UNDO.

    {get Browsehandle hBrowse}.
    hBrowse:REFRESHABLE = NO.
       
    IF DYNAMIC-FUNCTION("isOkToFetch":U IN TARGET-PROCEDURE, "FIRST":U) THEN
    DO:
      {get DataSource hSource}.
      /* The SBO need to know who this is */
      ghTargetProcedure = TARGET-PROCEDURE.
      run fetchFirst in hSource.       
      ghTargetProcedure = ?.
    END.  /* isOkToFetch = TRUE */
    
    hBrowse:REFRESHABLE = YES.  
    /* check and request if we need full browser  */
    run adjustReposition in target-procedure.
    
     
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-onValueChanged) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE onValueChanged Procedure 
PROCEDURE onValueChanged :
/*------------------------------------------------------------------------------
   Purpose: Event handler for the Browse VALUE-CHANGED event.
Parameters:  <none>
     Notes: Different from the valueChanged procedure which fires for 
            value changes in the fields (VALUE-CHANGED on browse ANYWHERE) 
          - This event should NOT be overriden as a place to trap change of 
            record. The fact that it is fired from the value-changed trigger 
            means that it only runs when a user changes the row in the browse 
            (it does also backfire from events like home and end). It does not 
            run in all cases where a record is changed. (reposition for example)            
          - DataAvailable is the event that traps the change of record.          
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hBrowse     AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cNewRecord  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hDataSource AS HANDLE     NO-UNDO.

  {get BrowseHandle hBrowse}.
  IF NOT VALID-HANDLE(hBrowse) THEN
    RETURN NO-APPLY.

  {get NewRecord cNewRecord}.
  IF cNewRecord = 'NO':U THEN
  DO:
    IF DYNAMIC-FUNCTION("isOkToFetch":U IN TARGET-PROCEDURE, "VALUE-CHANGED":U) THEN
    DO:
      {get DataSource hDataSource}.
      /* Traditionally the browser just used run dataAvailable from the events,
         but this is now in a super-procedure and the sbo need to know the
         target, so we subscribe the source temporarily.  */ 
      SUBSCRIBE PROCEDURE hDataSource TO 'DataAvailable':U IN TARGET-PROCEDURE.    
      PUBLISH 'dataAvailable':U FROM TARGET-PROCEDURE("DIFFERENT":U).      
      UNSUBSCRIBE PROCEDURE hDataSource TO 'DataAvailable':U IN TARGET-PROCEDURE.    
    END.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-readSavedSettings) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE readSavedSettings Procedure 
PROCEDURE readSavedSettings :
/*------------------------------------------------------------------------------
  Purpose:     Reads column positions and sizes from profile into 
               SavedColumnData property.  
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE cBrowseName      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cColumnData      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cContainerNAme   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cSortColumn      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cProfileKey      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE hContainerSource AS HANDLE     NO-UNDO.
DEFINE VARIABLE lProfileExists   AS LOGICAL    NO-UNDO.
DEFINE VARIABLE rID              AS ROWID      NO-UNDO.

  &SCOPED-DEFINE xp-assign
  {get ObjectName cBrowseName}
  {get ContainerSource hContainerSource}.
  &UNDEFINE xp-assign

  IF VALID-HANDLE(hContainerSource) THEN
    {get LogicalObjectName cContainerName hContainerSource}.
  
  IF cContainerName = '':U AND VALID-HANDLE(hContainerSource) THEN
    cContainerName = hContainerSource:FILE-NAME.

  cProfileKey = cContainerName + cBrowseName.

  RUN checkProfileDataExists IN gshProfileManager
      (INPUT 'Browser':U,
       INPUT 'Columns':U,
       INPUT cProfileKey,
       INPUT NO,
       INPUT YES, /* just need to check cache */
       OUTPUT lProfileExists).
  IF lProfileExists THEN 
  DO:
    rID = ?.
    RUN getProfileData IN gshProfileManager
        (INPUT 'Browser':U,
         INPUT 'Columns':U,
         INPUT cProfileKey,
         INPUT NO,
         INPUT-OUTPUT rID,
         OUTPUT cColumnData).

    {set savedColumnData cColumnData}.
  END.  /* if profile exists */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-rebuildSearchField) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE rebuildSearchField Procedure 
PROCEDURE rebuildSearchField :
/*------------------------------------------------------------------------------
  Purpose: Creates a new search field and its label.     
  Parameters:  <none>
  Notes: This is called from the setSearchField function only if the field was
         manually set. It means that the search field is not set during the
         initialization process with the search field set in the instance
         properties. 
------------------------------------------------------------------------------*/
DEFINE VARIABLE hSearchHandle AS HANDLE NO-UNDO.
DEFINE VARIABLE hLabelHandle  AS HANDLE NO-UNDO.

  {get SearchHandle hSearchHandle}.

  /*Get the field and label handles and delete them*/
  IF VALID-HANDLE(hSearchHandle) THEN
  DO:
      ASSIGN hLabelHandle = hSearchHandle:SIDE-LABEL-HANDLE.

      DELETE OBJECT hSearchHandle NO-ERROR.
      DELETE OBJECT hLabelHandle  NO-ERROR.
  END.

  RUN createSearchField IN TARGET-PROCEDURE.

RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-refreshBrowse) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE refreshBrowse Procedure 
PROCEDURE refreshBrowse :
/*------------------------------------------------------------------------------
  Purpose:    Published from dataSource when a display is not enough.      
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hBrowse         AS HANDLE     NO-UNDO.
  {get BrowseHandle hBrowse}.

  hBrowse:REFRESH() NO-ERROR. 
 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-refreshQuery) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE refreshQuery Procedure 
PROCEDURE refreshQuery :
/*------------------------------------------------------------------------------
  Purpose: Refresh browse query and reposition to currently selected row
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hBrowse      AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hSource      AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cRowIdent    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cRows        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iLoop        AS INTEGER    NO-UNDO.

  {get BrowseHandle hBrowse}.

  hBrowse:REFRESHABLE = NO.
  hSource = {fn getDataObjectHandle}.
  IF VALID-HANDLE(hSource) THEN
  DO:
    IF hBrowse:NUM-SELECTED-ROWS EQ 1 THEN 
    DO iLoop = 1 TO hBrowse:DOWN:
      IF hBrowse:IS-ROW-SELECTED(iLoop) THEN
      DO:
        hBrowse:SET-REPOSITIONED-ROW(iLoop,"CONDITIONAL":U).
        LEAVE.
      END.
    END.    
    {fn refreshQuery hSource}.
  END.

  hBrowse:REFRESHABLE = YES.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-removeColumnSettings) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE removeColumnSettings Procedure 
PROCEDURE removeColumnSettings :
/*------------------------------------------------------------------------------
  Purpose:     Remove column position and size settings from the browser and 
               from the repository if a profile is stored for this browser.
  Parameters:  <none>
  Notes:       Invoked by the Remove Column Positins and Sizes popup menu item
------------------------------------------------------------------------------*/
  
  RUN resetDefaultSettings IN TARGET-PROCEDURE.

  /* Send flag to indicate that the profile should be deleted if it exists */
  RUN updateColumnSettings IN TARGET-PROCEDURE (INPUT TRUE).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-removeSortColumn) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE removeSortColumn Procedure 
PROCEDURE removeSortColumn :
/*------------------------------------------------------------------------------
  Purpose:     Remove column sort from the browser's data source and 
               from the repository if a profile is stored for this browser.
  Parameters:  <none>
  Notes:       Invoked by the Remove Sort Column popup menu item
------------------------------------------------------------------------------*/
  
  /* Send flag to indicate that the default sort should be used */
  RUN resetSortColumn IN TARGET-PROCEDURE (INPUT TRUE).

  /* Send flag to indicate that the profile should be deleted if it exists */
  RUN updateSortColumn IN TARGET-PROCEDURE (INPUT TRUE).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-resetColumnSettings) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE resetColumnSettings Procedure 
PROCEDURE resetColumnSettings :
/*------------------------------------------------------------------------------
  Purpose:     Resets column settings based on SavedColumnData 
  Parameters:  <none>
  Notes:       Invoked from the Reset Column Positions and Sizes popup menu
               item and from initializeObject to set the initial 
               column positions and sizes.
------------------------------------------------------------------------------*/
DEFINE VARIABLE cColumnData   AS CHARACTER  NO-UNDO.
  
  {get SavedColumnData cColumnData}.
  IF cColumnData = '':U THEN
  DO:
    {get DefaultColumnData cColumnData}.
  END.  /* if saved column data blank */

  RUN moveAndResizeColumns IN TARGET-PROCEDURE (INPUT cColumnData).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-resetDefaultSettings) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE resetDefaultSettings Procedure 
PROCEDURE resetDefaultSettings :
/*------------------------------------------------------------------------------
  Purpose:     Resets default column settings based on DefaultColumnData 
  Parameters:  <none>
  Notes:       Invoked from the Reset Default Column Positions and Sizes 
               popup menu item.  
------------------------------------------------------------------------------*/
DEFINE VARIABLE cDefaultData       AS CHARACTER  NO-UNDO.

  {get DefaultColumnData cDefaultData}.
  RUN moveAndResizeColumns IN TARGET-PROCEDURE (INPUT cDefaultData).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-resetSortColumn) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE resetSortColumn Procedure 
PROCEDURE resetSortColumn :
/*------------------------------------------------------------------------------
  Purpose:     Resets sort column 
  Parameters:  plDefault AS LOGICAL
  Notes:       Sort Column is not stored as a property in the browser since 
               sorting is done for an SDO, not a browser.  
               
               This procedure handles the following:
               - Setting the sort column initially from profile data (when 
                 invoked from initializeObject)
               - Resetting the sort column from profile data (when invoked
                 from Reset Sort Column popup menu item)
               - Resetting the sort column to the default sort criteria 
                 defined in the SDO's base query (when invoked from
                 Reset Default Sort Column popup menu item - plDefault is TRUE)
               
               setSort is not used because setSort is designed to work with the
               START-SEARCH trigger and it will change the SDO sort from 
               ascending to descending and vice versa if the same column is 
               chosen.  This should not happen here where just the sort from 
               the profile should be used. 
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER plDefault AS LOGICAL    NO-UNDO.

DEFINE VARIABLE cBrowseName            AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cContainerName         AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cProfileKey            AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cSortColumn            AS CHARACTER  NO-UNDO.
DEFINE VARIABLE hContainerSource       AS HANDLE     NO-UNDO.
DEFINE VARIABLE hDataSource            AS HANDLE     NO-UNDO.
DEFINE VARIABLE lInitialized           AS LOGICAL    NO-UNDO.
DEFINE VARIABLE lProfileExists         AS LOGICAL    NO-UNDO.
DEFINE VARIABLE rID                    AS ROWID      NO-UNDO.

  &SCOPED-DEFINE xp-assign
  {get ObjectName cBrowseName}
  {get ContainerSource hContainerSource}
  {get ObjectInitialized lInitialized}.
  &UNDEFINE xp-assign

  /* If the sort column is not being reset to the default sort column then
     the profile data is checked */
  IF NOT plDefault THEN
  DO:
    IF VALID-HANDLE(hContainerSource) THEN
      {get LogicalObjectName cContainerName hContainerSource}.
  
    IF cContainerName = '':U AND VALID-HANDLE(hContainerSource) THEN
      cContainerName = hContainerSource:FILE-NAME.

    cProfileKey = cContainerName + cBrowseName.
  
    IF VALID-HANDLE(gshProfileManager) THEN
    DO:
      RUN checkProfileDataExists IN gshProfileManager
          (INPUT 'SDO':U,
           INPUT 'Sorting':U,
           INPUT cProfileKey,
           INPUT NO,
           INPUT YES, /* just need to check cache */
           OUTPUT lProfileExists).
      IF lProfileExists THEN 
      DO:
        rID = ?.
        RUN getProfileData IN gshProfileManager
            (INPUT 'SDO':U,
             INPUT 'Sorting':U,
             INPUT cProfileKey,
             INPUT NO,
             INPUT-OUTPUT rID,
             OUTPUT cSortColumn).

        IF cSortColumn = "":U THEN
            ASSIGN lProfileExists = NO.
      END.   /* if profile exists */
    END.  /* if profile manager handle valid */
  END.  /* if not Default */

  /* If a profile does not exist and this is called from initializeObject 
     then just return rather than attempting to set the sort column */

  IF NOT lProfileExists AND NOT lInitialized THEN RETURN.
  
  hDataSource = {fn getDataObjectHandle}.
  /* If a profile does not exist and this is not being called from 
     initializeObject then the sort column needs to be reset from the 
     default sort criteria of the SDO's base query (? = default)  */
  IF NOT lProfileExists AND lInitialized THEN
    cSortColumn = ?. 
  ELSE /* if not qualification then assume rowobject is referenced  */ 
  IF cSortColumn > '':U AND NUM-ENTRIES(cSortColumn,'.':U) LE 1 THEN 
     cSortColumn =  'RowObject.':U + cSortColumn.
  
  IF VALID-HANDLE(hDataSource) THEN
    {fnarg resortQuery cSortColumn hDataSource}.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-resizeBrowse) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE resizeBrowse Procedure 
PROCEDURE resizeBrowse :
/*------------------------------------------------------------------------------
  Purpose:     Changes the size of the browse widget in a SmartDataBrowser   
  Parameters:  pd_height AS DECIMAL -- The desired height (in rows)
               pd_width  AS DECIMAL -- The desired width (in columns)     
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pd_height AS DECIMAL NO-UNDO.
  DEFINE INPUT PARAMETER pd_width  AS DECIMAL NO-UNDO.
  
  DEFINE VARIABLE hBrowse     AS HANDLE           NO-UNDO.
  DEFINE VARIABLE hFieldGroup AS HANDLE           NO-UNDO.
  DEFINE VARIABLE hFrame      AS HANDLE           NO-UNDO.
  DEFINE VARIABLE htmpWidget  AS HANDLE           NO-UNDO.
  DEFINE VARIABLE otherWidget AS LOGICAL          NO-UNDO.

  /* Assure that it doesn't get too small */
  ASSIGN pd_height = MAX(pd_height, 2.0)
         pd_width  = MAX(pd_width, 2.0).
  /* Get the handles of the browse and its frame */
  {get BrowseHandle hBrowse}.
  ASSIGN hFieldGroup = hBrowse:PARENT           /* Field Group */
         hFrame      = hFieldGroup:PARENT.       /* The frame ! */
  
  IF pd_width + hBROWSE:COLUMN <= hFrame:WIDTH THEN
    hBrowse:WIDTH = pd_width. 
  IF pd_height + hBrowse:ROW <= hFrame:HEIGHT THEN 
    hBrowse:HEIGHT = pd_height. 
           
  hBrowse:SET-REPOSITIONED-ROW (hBrowse:DOWN,"CONDITIONAL":U).
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-resizeObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE resizeObject Procedure 
PROCEDURE resizeObject :
/*------------------------------------------------------------------------------
  Purpose:     Changes the size of a SmartDataBrowser.
  Parameters:  pd_height AS DECIMAL -- The desired height (in rows)
               pd_width  AS DECIMAL -- The desired width (in columns)
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER pd_height AS DECIMAL NO-UNDO.
  DEFINE INPUT PARAMETER pd_width  AS DECIMAL NO-UNDO.
  
  DEFINE VARIABLE dSearchSize  AS DECIMAL          NO-UNDO.
  DEFINE VARIABLE hBrowse      AS HANDLE           NO-UNDO.
  DEFINE VARIABLE hFieldGroup  AS HANDLE           NO-UNDO.
  DEFINE VARIABLE hFrame       AS HANDLE           NO-UNDO.
  DEFINE VARIABLE hSearchField AS HANDLE           NO-UNDO.
  DEFINE VARIABLE hSearchLabel AS HANDLE           NO-UNDO.
  DEFINE VARIABLE htmpWidget   AS HANDLE           NO-UNDO.
  DEFINE VARIABLE otherWidget  AS LOGICAL          NO-UNDO.
  DEFINE VARIABLE iReset       AS INTEGER          NO-UNDO.

  /* Assure that it doesn't get too small */
  ASSIGN pd_height = MAX(pd_height, 2.0)
         pd_width  = MAX(pd_width, 2.0).
  /* Get the handles of the browse and its frame */
  {get BrowseHandle hBrowse}.
  ASSIGN hFieldGroup = hBrowse:PARENT           /* Field Group */
         hFrame      = hFieldGroup:PARENT       /* The frame ! */
         htmpWidget  = hFieldGroup:FIRST-CHILD. /* 1st Child   */

  /* Fix for issue 5633 - the browse widget loses the current */
  /* query record when certain sizing attributes change (EXPANDABLE or HEIGHT). */
  /* So, we need to save the current Rowid, if any, and re-find it later */
  DEFINE VARIABLE hRO       AS HANDLE     NO-UNDO. 
  DEFINE VARIABLE rCurRowid AS ROWID      NO-UNDO.
  hRO = hBrowse:QUERY:GET-BUFFER-HANDLE() NO-ERROR.
  IF VALID-HANDLE(hRO) AND hRO:AVAILABLE THEN
    rCurRowid = hRO:ROWID.
  /******* issue 5633 (first part) ********/  

  /* If the frame is NOT size-to-fit then we don't allow anything to
     be resized.  We can tell if size-to-fit has been turned off
     because SCROLLABLE is turned on.                                    */
  IF hFrame:SCROLLABLE THEN RETURN.

  /* We need to get the handles of the SearchField and its label.  We do this 
     so that the browse is resized even though we have a SearchField.  And we
     do this so that the mininum width of the frame takes the SearchField into 
     account.  */
  {get SearchHandle hSearchField}.
  IF VALID-HANDLE(hSearchField) THEN
    ASSIGN hSearchLabel = hSearchField:SIDE-LABEL-HANDLE
           dSearchSize  = hSearchField:COLUMN + hSearchField:WIDTH.

  /* While we will resize the frame, we won't change the size of the
     browse if there are other widgets in the frame (except for the affordance
     button and a SearchField).  So we have to determine if there are any widgets 
     other than the browse in the frame.                                                */
  Search-For-Siblings:
  REPEAT WHILE VALID-HANDLE(htmpWidget):
    IF htmpWidget NE hBrowse THEN DO:
      IF htmpWidget:TYPE NE "BUTTON":U OR
         htmpWidget:X    NE 4          OR
         htmpWidget:Y    NE 4          OR
         htmpWidget:TOOLTIP NE "SmartObject Options" THEN DO: 
        IF htmpWidget NE hSearchLabel AND
           htmpWidget NE hSearchField THEN DO:
            otherWidget = TRUE.
            LEAVE Search-For-Siblings.
        END.  /* If SearchField */
      END.  /* If not affordance button */
    END.
    htmpWidget = htmpWidget:NEXT-SIBLING.
  END. /* While looking for siblings */
  
  
/*   If the width is getting smaller, do the browse first else the frame*/
  IF pd_width < hBrowse:WIDTH THEN
    ASSIGN hBrowse:WIDTH = pd_width - (hBrowse:COLUMN - 1) WHEN NOT otherWidget
           hFrame:WIDTH  = MAX(pd_width,dSearchSize)       NO-ERROR.
  ELSE       
    ASSIGN hFrame:WIDTH  = MAX(pd_width,dSearchSize)
           hBrowse:WIDTH = pd_width - (hBrowse:COLUMN - 1) WHEN NOT otherWidget
           NO-ERROR.
                        
  /*   If the height is getting smaller, do the browse first else the frame*/
  IF pd_height < hBrowse:HEIGHT THEN                                                            
    ASSIGN hBrowse:HEIGHT = pd_height - (hBrowse:ROW - 1) WHEN NOT otherWidget
           hFrame:HEIGHT  = pd_height  
           NO-ERROR.
  ELSE  
    ASSIGN hFrame:HEIGHT  =   pd_height 
           hBrowse:HEIGHT = pd_height - (hBrowse:ROW - 1) WHEN NOT otherWidget 
           NO-ERROR.
 
  /* Error 6422 is given because the browse requires minimum 2 rows in viewport.*/
  IF ERROR-STATUS:ERROR AND ERROR-STATUS:GET-NUMBER(1) = 6422 THEN
  DO:
    /* Make the browse as low as allowed */
   ASSIGN hBrowse:DOWN = 2
          pd_Height    = hBrowse:HEIGHT + (hBrowse:ROW - 1)
          NO-ERROR.
  END.
  
  
  hBrowse:SET-REPOSITIONED-ROW (hBrowse:DOWN,"CONDITIONAL":U).
  
  /* Fix for issue 5633 (second part) */
  IF VALID-HANDLE(hRO) THEN 
    IF rCurRowid <> ? THEN 
      IF rCurRowid <> hRO:ROWID THEN     /* IF a valid buffer existed in the beginning... */
        hRO:FIND-BY-ROWID (rCurRowid, NO-LOCK). /* ...attempt to find saved */

  RUN adjustReposition IN TARGET-PROCEDURE.
  {fn adjustVisibleRowids}.
      
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-rowDisplay) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE rowDisplay Procedure 
PROCEDURE rowDisplay :
/*------------------------------------------------------------------------------
  Purpose:     Event Handler for the ROW-DISPLAY event.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hBuffer       AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cRowids       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lReset        AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lScrollRemote AS LOGICAL    NO-UNDO.

  {get ScrollRemote lScrollRemote}.
  
  IF lScrollRemote THEN 
  DO:
    &SCOPED-DEFINE xp-assign
    {get QueryRowObject hBuffer}
    {get VisibleRowids cRowids}
    {get VisibleRowReset lReset}.
    &UNDEFINE xp-assign
    
    /* If the handle to the query buffer has not yet been set then reurn */
    IF NOT VALID-HANDLE(hBuffer) THEN
      RETURN.
    
    /* If the count is zero, clear the rowid list */
    IF lReset THEN 
      cRowids = FILL(',':U,NUM-ENTRIES(cRowids) - 1).
    
    /* If the ROWID is not unknown, add it to the list of ROWIDs 
       (we remove the first entry to ensure the list doesn't grow out
       of proportions, since we cannot access the DOWN attribute in this
       trigger, the number of entries in the list is adjusted in 
       adjustVisibleRowids called from resizeObject or viewObject)*/
    IF hBuffer:ROWID <> ? THEN
      ASSIGN ENTRY(1,cRowids) = '':U
             cRowids          = SUBSTRING(cRowids,2) 
             cRowids          = cRowids 
                              + (IF cRowids = "":U THEN "":U ELSE ",":U)
                              + STRING(hBuffer:ROWID).
   
    /* Increment the row counter */
    lReset = NO.
    
    &SCOPED-DEFINE xp-assign
    {set VisibleRowReset lReset}
    {set VisibleRowids cRowids}.
    &UNDEFINE xp-assign
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-rowEntry) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE rowEntry Procedure 
PROCEDURE rowEntry :
/*------------------------------------------------------------------------------
  Purpose:     Browse row-entry trigger functionality.
  Parameters:  <none>
  Notes:       * there is no RUN SUPER
               * taken from src/adm2/brsentry.i
               * Retrieves and displays initial values for Add or Copy.
------------------------------------------------------------------------------*/
/* brsentry.i - trigger code for ROW-ENTRY trigger of SmartDataBrowse - 02/17/99 */
  DEFINE VARIABLE cColValues    AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cRowIdent     AS CHARACTER NO-UNDO.
  DEFINE VARIABLE hUpdateTarget AS HANDLE    NO-UNDO.
  DEFINE VARIABLE cTarget       AS CHARACTER NO-UNDO.
  DEFINE VARIABLE lInitted      AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE cNewRecord    AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cFields       AS CHARACTER NO-UNDO.
  DEFINE VARIABLE lModified       AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE cModifiedFields AS CHARACTER NO-UNDO.  
  DEFINE VARIABLE hCell           AS HANDLE    NO-UNDO.  
  DEFINE VARIABLE hQuery          AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hBuffer         AS HANDLE    NO-UNDO.    
  DEFINE VARIABLE iCnt            AS INTEGER   NO-UNDO.  
  DEFINE VARIABLE cNew            AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cUpdateNames    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hBrowse         AS handle        NO-UNDO.
  
  &SCOPED-DEFINE xp-assign yes
  {get DataModified lModified}
  {get BrowseInitted lInitted}
  {get BrowseHandle hBrowse}
  .
  &UNDEFINE xp-assign 
        
  IF hBrowse:NEW-ROW AND (NOT lInitted) THEN
  DO:
    /* Prevents initial values from being displayed twice
       if focus leaves the row (NOTE: still needed ) */
    {get UpdateTarget cTarget}.
    hUpdateTarget  = WIDGET-HANDLE(cTarget).
    IF VALID-HANDLE(hUpdateTarget) THEN
    DO:
      {get NewRecord cNewRecord}.
      {get DisplayedFields cFields}.

      /* Although the browser does not currently support multiple update targets, */
      /* we need to prefix the browser's fields with the update target name to */
      /* provide for a common input format to the data object APIs. This only */
      /* needs to happen if the UpdateTarget is an SBO */
      IF {fn getContainerType hUpdateTarget} = "VIRTUAL":U THEN
      DO:
        /* 'getUpdateTargetNames' is overriden to include the UpdateTargetNames */
        /* of all GA-related components. Here we *only* want the value of */
        /* THIS (TARGET-PROCEDURE) object. This really should be implemented */
        /* as 2 different properties... */
        &SCOPED-DEFINE xpUpdateTargetNames
        {get UpdateTargetNames cUpdateNames}.
        &UNDEFINE xpUpdateTargetNames
        
        IF cUpdateNames > "" AND NUM-ENTRIES(cUpdateNames) = 1 
        THEN DO iCnt = 1 TO NUM-ENTRIES(cFields):
          IF INDEX(ENTRY(iCnt,cFields), '.':U) = 0 THEN
            entry(iCnt,cFields) = cUpdateNames + '.':U + ENTRY(iCnt,cFields) .
        END.
      END.
      
      ghTargetProcedure = TARGET-PROCEDURE.
      IF cNewRecord = 'Add':U THEN   /* if it's Add, not Copy */
        cColValues = DYNAMIC-FUNCTION 
          ("addRow":U IN hUpdateTarget, cFields). 
      ELSE cColValues = DYNAMIC-FUNCTION 
        ("copyRow":U IN hUpdateTarget, cFields).  
      ghTargetProcedure = ?.
        
      cRowIdent = ENTRY(1, cColValues, CHR(1)).  /* save off for Save */
      {set RowIdent cRowIdent}.  /* save off for Save */
      RUN displayFields IN TARGET-PROCEDURE(cColValues).
      {set BrowseInitted YES}.
    END.  /* END DO IF VALID-HANDLE */
    ELSE DYNAMIC-FUNCTION('showMessage':U in target-procedure,
     {fnarg messageNumber 66}).
  END.    /* END DO IF NEW-ROW */
  
  ELSE IF lModified THEN DO:    
    {get ModifiedFields cModifiedFields}.
    ASSIGN 
        hQuery    = hBrowse:QUERY
        hBuffer   = hQuery:GET-BUFFER-HANDLE(1)
        cRowIdent = IF STRING(hBuffer:ROWID) NE ? THEN STRING(hBuffer:ROWID) ELSE '':U
        .
    IF cRowIdent = ENTRY(1,cModifiedFields) THEN
        DO iCnt = 2 TO NUM-ENTRIES(cModifiedFields):
            ASSIGN
                hCell = WIDGET-HANDLE(ENTRY(iCnt,cModifiedFields))
                hCell:modified  = YES
                .
        END. /* DO iCnt = 2 TO ... */
  END. /* END IF lModified */ 
END PROCEDURE.    /* rowEntry */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-rowLeave) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE rowLeave Procedure 
PROCEDURE rowLeave :
/*------------------------------------------------------------------------------
  Purpose:     Browse row-leave trigger functionality.
  Parameters:  <none>
  Notes:       * there is no RUN SUPER
               * taken from src/adm2/brsleave.i
               * If the object selected is not a SmartPanel button 
                 (which could be e.g. Cancel or Reset), then save any changes 
                 to the row. Otherwise let the button take the appropriate action.
------------------------------------------------------------------------------*/
    DEFINE VARIABLE hEntered            AS HANDLE                        NO-UNDO.
    DEFINE VARIABLE hFrame              AS HANDLE                        NO-UNDO.
    DEFINE VARIABLE hParent             AS HANDLE                        NO-UNDO.
    DEFINE VARIABLE cNewRecord          AS CHARACTER                     NO-UNDO.
    DEFINE VARIABLE lModified           AS LOGICAL                       NO-UNDO.
    DEFINE VARIABLE hCell               AS HANDLE                        NO-UNDO.
    DEFINE VARIABLE hQuery              AS HANDLE                        NO-UNDO.
    DEFINE VARIABLE hBuffer             AS HANDLE                        NO-UNDO.    
    DEFINE VARIABLE cEnabledHandles     AS CHARACTER                     NO-UNDO.
    DEFINE VARIABLE cModifiedFields     AS CHARACTER                     NO-UNDO.
    DEFINE VARIABLE iCnt                AS INTEGER                       NO-UNDO.
    DEFINE VARIABLE hUpdateTarget       AS HANDLE                        NO-UNDO.
    DEFINE VARIABLE hBrowse             AS handle                        NO-UNDO.
    DEFINE VARIABLE lSaveSource         AS LOGICAL                       NO-UNDO.
    /* 9.0B 99-02-03-026 */
    &SCOPED-DEFINE xp-assign yes
    {get NewRecord cNewRecord}
    {get EnabledHandles cEnabledHandles}
    {get DataModified lModified}
    {get BrowseHandle hBrowse}.
    &UNDEFINE xp-assign
 
    DO iCnt = 1 TO NUM-ENTRIES(cEnabledHandles):
        hCell = WIDGET-HANDLE(ENTRY(iCnt,cEnabledHandles)).
        IF hCell:MODIFIED THEN
            cModifiedFields = cModifiedFields + ',':U + STRING(hCell).
    END.    /* loop through enabled handles */
    
    ASSIGN hQuery          = hBrowse:QUERY
           hBuffer         = hQuery:GET-BUFFER-HANDLE(1)
           cModifiedFields = (IF cNewRecord NE 'no':U THEN '':U 
                              ELSE STRING(hBuffer:ROWID)) + cModifiedFields.
        {set ModifiedFields cModifiedFields}.
 
    /* If the object has a valid frame attribute, see if it's a SmartPanel. */
    hEntered = LAST-EVENT:WIDGET-ENTER.
    IF VALID-HANDLE(hEntered) THEN
        hParent = hEntered:PARENT.
    IF VALID-HANDLE(hParent) AND hParent:TYPE NE "BROWSE":U THEN
        hFrame = hEntered:FRAME.  /* Can't check FRAME on Brs flds */
        
    IF ((NOT VALID-HANDLE(hEntered)) OR  /* Some events don't go to a widget*/
        (hParent:TYPE = "BROWSE":U) OR /* Clicked elsewhere in the Browser*/
        (NOT VALID-HANDLE(hFrame)) OR  /* Check parent Frame if present */
        (NOT CAN-DO(IF hFrame:PRIVATE-DATA EQ ? THEN "":U ELSE hFrame:PRIVATE-DATA, "ADM-PANEL":U))) /*SmartPanel?*/
    THEN
    DO:
        /* If not a SmartPanel then do upd */
        /* If they selected some other object or the LEAVE was initiated 
           from outside then check before continuing. Otherwise just save. 
           If they were adding a new record and didn't change any initial values,
           make sure that gets Saved as well.
                 */
        /* 9.0B 98-11-25-039 */
        IF lModified OR 
           (cNewRecord NE 'No':U AND 
            hBrowse:NUM-SELECTED-ROWS = 1) THEN
        DO:
            /* if the leave is because we went into a wait-for in the message 
               procedure then just return.. */          
            iCnt = 1.
            DO WHILE PROGRAM-NAME(iCnt) <> ?:
                iCnt = iCnt + 1.

                IF /* These 3 are in the Dynamics Session Manager
                      and are the standard API for displaying messages
                      in Dynamics.
                    */
                   PROGRAM-NAME(iCnt) BEGINS 'askQuestion ' OR 
                   PROGRAM-NAME(iCnt) BEGINS 'showMessages ' OR 
                   PROGRAM-NAME(iCnt) BEGINS 'showWarningMessages ' OR
                   /* in smart.p */
                   PROGRAM-NAME(iCnt) BEGINS 'showDataMessagesProcedure ':U THEN
                    RETURN. 
            END.    /* loop through program stack */
            
            IF (VALID-HANDLE (hParent) AND hParent:TYPE NE "BROWSE":U)
            or last-event:function = 'window-close':U  THEN
            DO:
                /* "Current record has been changed. save those changes?" */
                IF {fnarg showMessage '"7,Question"'} THEN
                DO:
                    RUN updateRecord IN TARGET-PROCEDURE.
                    IF RETURN-VALUE = "ADM-ERROR":U THEN
                    DO:
                        IF VALID-HANDLE(FOCUS) THEN        /* 9.0B 99-01-26-030 */
                            APPLY "ENTRY":U TO FOCUS.
                        RETURN 'adm-error'.
                    END.    /* adm-error from update */
                END.    /* question 7 */
                ELSE
                DO:
                    RUN cancelRecord IN TARGET-PROCEDURE.
                    IF VALID-HANDLE(hEntered) THEN
                        APPLY "ENTRY":U TO hEntered.            /* 9.0B 99-01-26-030 */
                END.  /* not question 7 */
            END.     /* has a non-browse parent */
            ELSE
            DO:
                RUN updateRecord IN TARGET-PROCEDURE.
                IF RETURN-VALUE = "ADM-ERROR":U THEN 
                DO:
                    IF VALID-HANDLE(FOCUS) THEN           /* 9.0B 99-01-26-030 */
                        APPLY "ENTRY":U TO FOCUS.
                    RETURN 'adm-error'.
                END.    /* error from update */
            END.    /* parent is browse */
        END.    /* do the update */
        else do:
          /* get out of updatemode if applicable */ 
          {get SaveSource lSaveSource}. 
          if lSaveSource = false then
            RUN cancelRecord IN TARGET-PROCEDURE.
        end.
    END.    /* attempt the update */        
END PROCEDURE.    /* rowLeave */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-searchTrigger) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE searchTrigger Procedure 
PROCEDURE searchTrigger :
/*------------------------------------------------------------------------------
  Purpose:     This is the procedure run from the trigger on the SearchField
               for the SmartDataBrowser, if one has been defined. It repositions 
               the query to the first row GE the value requested 
               (SearchValue property).
  Parameters:  <none>
------------------------------------------------------------------------------*/

  DEFINE VARIABLE hSource      AS HANDLE    NO-UNDO.
  DEFINE VARIABLE cSearchField AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cDataType    AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cRowIdent    AS CHARACTER NO-UNDO.
  DEFINE VARIABLE lOk          AS LOGICAL   NO-UNDO.

  /* First we must capture the keystroke which fired the trigger. */
  APPLY LAST-KEY.
  
  &SCOPED-DEFINE xp-assign
  {get DataSource hSource}
  {get SearchField cSearchField}.
  &UNDEFINE xp-assign
  
  IF NUM-ENTRIES(cSearchField,'.') = 1 THEN
    cSearchField = 'RowObject.':U + cSearchField.

  lOk = DYNAMIC-FUNCTION('findRowWhere':U IN hSource,
                          cSearchField, 
                          SELF:SCREEN-VALUE,
                         '>=':U).
  /* the ui just remains as is, so give some feedback...*/
  IF NOT lok THEN
    BELL. 

  /* Now we must throw away the krystroke event to avoid getting double
     characters in the fill-in. */
  RETURN NO-APPLY.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setDown) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setDown Procedure 
PROCEDURE setDown :
/*------------------------------------------------------------------------------
  Purpose:     Sets the down attribute for the browse and resizes the browse 
               appropriately.
  Parameters:  piNumDown AS INTEGER
  Notes:       Called from initializeObject for dynamic SmartDataBrowsers.
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER piNumDown AS INTEGER NO-UNDO.

DEFINE VARIABLE hBrowse          AS HANDLE  NO-UNDO.
DEFINE VARIABLE hContainerSource AS HANDLE  NO-UNDO. 
DEFINE VARIABLE dHeight          AS DECIMAL NO-UNDO.
  
  &scop xp-assign
  {get BrowseHandle hBrowse}
  {get ContainerSource hContainerSource}.
  &undefine xp-assign
  
  dHeight = (hBrowse:ROW - 1) + {fnarg calculateDownHeight piNumDown}.
  
  /* tell container about new height (no guarantee that it is handled) */
  if valid-handle(hContainerSource) then
     {fnarg newHeight dHeight hContainerSource}.
  
  RUN resizeObject IN TARGET-PROCEDURE (dHeight, {fn getWidth}).
 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-sortableValueChanged) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE sortableValueChanged Procedure 
PROCEDURE sortableValueChanged :
/*------------------------------------------------------------------------------
  Purpose:     Handles value-changed event for the sortable popup menu item
  Parameters:  
  Notes:       Movable and sortable are mutually exclusive
------------------------------------------------------------------------------*/
DEFINE VARIABLE hMovableItem  AS HANDLE     NO-UNDO.
DEFINE VARIABLE hSortableItem AS HANDLE     NO-UNDO.
 
  &SCOPED-DEFINE xp-assign
  {get MovableHandle hMovableItem}
  {get SortableHandle hSortableItem}
  {set ColumnsSortable hSortableItem:CHECKED}.
  &UNDEFINE xp-assign

  IF hSortableItem:CHECKED AND hMovableItem:CHECKED THEN
  DO:
    hMovableItem:CHECKED = FALSE.   
    {set ColumnsMovable FALSE}.
  END.  /* if both now checked */

  IF hSortableItem:CHECKED THEN
    {fn showSort}.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-startSearch) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE startSearch Procedure 
PROCEDURE startSearch :
/*------------------------------------------------------------------------------
  Purpose:    Start Search Trigger    
  Parameters: phBrowse - The Browse handle 
                         Persistent triggers have early binding so we cannot
                         pass current-column.  
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER phBrowse AS HANDLE  NO-UNDO.
  
  DEFINE VARIABLE hColumn AS HANDLE  NO-UNDO.
  DEFINE VARIABLE cSort   AS CHARACTER  NO-UNDO.
  
  hColumn = phBrowse:CURRENT-COLUMN.
  cSort = hColumn:TABLE + ".":U + hColumn:NAME.  
  {set SORT cSort}.  

  APPLY 'END-SEARCH':U TO phBrowse.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-toolbar) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE toolbar Procedure 
PROCEDURE toolbar :
/*------------------------------------------------------------------------------
  Purpose:     Procedure to handle browse toolbar actions.
  Parameters:  pcValue AS CHARACTER - action
  Notes:       
------------------------------------------------------------------------------*/
 DEFINE INPUT PARAM pcValue          AS CHARACTER    NO-UNDO.

 DEFINE VARIABLE hContainerSource    AS HANDLE       NO-UNDO.
 DEFINE VARIABLE hNewObject          AS HANDLE       NO-UNDO.    
 DEFINE VARIABLE hWindowHandle       AS HANDLE       NO-UNDO.
 DEFINE VARIABLE cProcedureType      AS CHARACTER    NO-UNDO.
 DEFINE VARIABLE hFilterWindow       AS HANDLE       NO-UNDO.
 DEFINE VARIABLE hDataSource         AS HANDLE       NO-UNDO.
 DEFINE VARIABLE hBrowse             AS HANDLE       NO-UNDO.
 DEFINE VARIABLE cFields             AS CHARACTER    NO-UNDO.
 DEFINE VARIABLE cMessage            AS CHARACTER    NO-UNDO.
 DEFINE VARIABLE cButton             AS CHARACTER    NO-UNDO.
 DEFINE VARIABLE cMaxRecords         AS CHARACTER    NO-UNDO.
 DEFINE VARIABLE lAutoCommit         AS LOGICAL      NO-UNDO.
 DEFINE VARIABLE cDataSource         AS CHARACTER    NO-UNDO.
 DEFINE VARIABLE iBrowsePosition     AS INTEGER      NO-UNDO.
 DEFINE VARIABLE iFieldsPosition     AS INTEGER      NO-UNDO.
 DEFINE VARIABLE hColumn             AS HANDLE       NO-UNDO.
 DEFINE VARIABLE cStoreFieldName     AS CHARACTER    NO-UNDO.

 CASE pcValue:
   
  WHEN "View" OR WHEN "Copy" OR WHEN "Modify" OR WHEN "Add" THEN 
     RUN launchFolderWindow IN TARGET-PROCEDURE (INPUT pcValue).
  
  WHEN "delete" THEN DO:
    {get DataSource hDataSource}.
    
    /* We currently use autocimmit on delete for the toolbar link as this is 
       used from an objectContainer that does not have commit/undo actions*/

    IF VALID-HANDLE(hDataSource) THEN
    DO:
      {get AutoCommit lAutoCommit hDataSource}.
      {set AutoCommit YES hDataSource}.
      RUN deleteRecord IN TARGET-PROCEDURE.
      {set AutoCommit lAutoCommit hDataSource}.
    END.
  END.  /* when delete */

  OTHERWISE RUN SUPER (INPUT pcValue).
 END CASE.

 ERROR-STATUS:ERROR = NO.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-updateColumnSettings) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE updateColumnSettings Procedure 
PROCEDURE updateColumnSettings :
/*------------------------------------------------------------------------------
  Purpose:     Saves/Deletes column positions and sizes for the profile data
  Parameters:  plDeleteProfile AS LOGICAL
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER plDeleteProfile AS LOGICAL    NO-UNDO.

DEFINE VARIABLE cBrowseName      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cColumnData      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cContainerName   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cProfileKey      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE hBrowse          AS HANDLE     NO-UNDO.
DEFINE VARIABLE hColumn          AS HANDLE     NO-UNDO.
DEFINE VARIABLE hContainerSource AS HANDLE     NO-UNDO.
DEFINE VARIABLE lProfileExists   AS LOGICAL    NO-UNDO.

  &SCOPED-DEFINE xp-assign
  {get ObjectName cBrowseName}
  {get BrowseHandle hBrowse}
  {get ContainerSource hContainerSource}.
  &UNDEFINE xp-assign

  IF VALID-HANDLE(hContainerSource) THEN
    {get LogicalObjectName cContainerName hContainerSource}.
  
  IF cContainerName = '':U AND VALID-HANDLE(hContainerSource) THEN
    cContainerName = hContainerSource:FILE-NAME.

  ASSIGN 
    cProfileKey = cContainerName + cBrowseName
    cColumnData = '':U
    hColumn     = hBrowse:FIRST-COLUMN.

  IF NOT plDeleteProfile THEN
  DO:
    DO WHILE VALID-HANDLE(hColumn):
      cColumnData = cColumnData + (IF NUM-ENTRIES(cColumnData,CHR(3)) > 0 THEN CHR(3) ELSE '':U) +
                      hColumn:NAME + CHR(4) + STRING(hColumn:WIDTH-PIXELS).
      hColumn = hColumn:NEXT-COLUMN.
    END.  /* do while valid column */
  END.  /* if not delete profile */

  {set SavedColumnData cColumnData}.

  IF VALID-HANDLE(gshProfileManager) THEN
  DO:
    IF plDeleteProfile THEN
      RUN checkProfileDataExists IN gshProfileManager
          (INPUT 'Browser':U,
           INPUT 'Columns':U,
           INPUT cProfileKey,
           INPUT NO,
           INPUT YES, /* just need to check cache */
           OUTPUT lProfileExists).
  
    /* If the profile exists and needs to be deleted then run setProfileData
       to delete the profile OR if the profile does not need to be deleted
       then run setProfileData to create/update profile */
    IF (plDeleteProfile AND lProfileExists) OR (NOT plDeleteProfile) THEN
      RUN setProfileData IN gshProfileManager 
        (INPUT 'Browser':U,
         INPUT 'Columns':U,
         INPUT cProfileKey,
         INPUT ?,
         INPUT cColumnData,
         INPUT plDeleteProfile,
         INPUT 'PER':U).
  END.  /* if profile manager running */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-updateRecord) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE updateRecord Procedure 
PROCEDURE updateRecord :
/*------------------------------------------------------------------------------
  Purpose:     SmartDataBrowser version of updateRecord.
               Sets the RowIdent property to the RowObject 
               ROWID, because the DataObject will be looking for it to 
               identify which row is being updated. 
  Parameters:  <none>
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hBrowse    AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hQuery     AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hParent    AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hBuffer    AS HANDLE    NO-UNDO.
  DEFINE VARIABLE cNewRecord AS CHARACTER NO-UNDO.
  
  &SCOPED-DEFINE xp-assign
  {get BrowseHandle hBrowse}
  {get NewRecord cNewRecord}    /* save to check at very end */
  .
  &UNDEFINE xp-assign

  ASSIGN 
    hQuery = hBrowse:QUERY
    hBuffer = hQuery:GET-BUFFER-HANDLE(1).
  
  RUN SUPER.
  IF RETURN-VALUE = "ADM-ERROR":U THEN DO:
    ASSIGN hParent = FOCUS:PARENT WHEN VALID-HANDLE(FOCUS).
    IF hParent NE hBrowse THEN RUN applyEntry IN TARGET-PROCEDURE (?).
    RETURN "ADM-ERROR":U.
  END.
  
  RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-updateSortColumn) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE updateSortColumn Procedure 
PROCEDURE updateSortColumn :
/*------------------------------------------------------------------------------
  Purpose:     Saves/Deletes column positions and sizes for the profile data
  Parameters:  plDeleteProfile AS LOGICAL
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER plDeleteProfile AS LOGICAL    NO-UNDO.

DEFINE VARIABLE cBrowseName      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cContainerName   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cProfileKey      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cQuerySort       AS CHARACTER  NO-UNDO.
DEFINE VARIABLE hContainerSource AS HANDLE     NO-UNDO.
DEFINE VARIABLE hDataSource      AS HANDLE     NO-UNDO.
DEFINE VARIABLE lProfileExists   AS LOGICAL    NO-UNDO.

  &SCOPED-DEFINE xp-assign
  {get ObjectName cBrowseName}
  {get ContainerSource hContainerSource}
   /* The SBO does not have a sort API, so if SourceNames is defined we need to 
      get the handle of the actual Source */
  {get DataObjectHandle hDataSource}.
  &UNDEFINE xp-assign
  
  IF VALID-HANDLE(hContainerSource) THEN
    {get LogicalObjectName cContainerName hContainerSource}.
  
  IF cContainerName = '':U AND VALID-HANDLE(hContainerSource) THEN
    cContainerName = hContainerSource:FILE-NAME.

  cProfileKey = cContainerName + cBrowseName.

  IF NOT plDeleteProfile THEN
  DO:
    {get QuerySort cQuerySort hDataSource}.
  END.  /* if not delete */

  IF VALID-HANDLE(gshProfileManager) THEN
  DO:
    IF plDeleteProfile THEN
      RUN checkProfileDataExists IN gshProfileManager
          (INPUT 'SDO':U,
           INPUT 'Sorting':U,
           INPUT cProfileKey,
           INPUT NO,
           INPUT YES, /* just need to check cache */
           OUTPUT lProfileExists).
  
    /* If the profile exists and needs to be deleted then run setProfileData
       to delete the profile OR if the profile does not need to be deleted
       and the sort column is not blank then run setProfileData to 
       create/update profile */
    IF (plDeleteProfile AND lProfileExists) OR 
        (NOT plDeleteProfile AND cQuerySort NE '':U) THEN
      RUN setProfileData IN gshProfileManager 
        (INPUT 'SDO':U,
         INPUT 'Sorting':U,
         INPUT cProfileKey,
         INPUT ?,
         INPUT cQuerySort,
         INPUT plDeleteProfile,
         INPUT 'PER':U).
  END.  /* if profile manager running */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-updateState) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE updateState Procedure 
PROCEDURE updateState :
/*------------------------------------------------------------------------------
  Purpose:     SmartDataBrowser version of updateState.
  Parameters:  pcState AS CHARACTER
               Possible values are:
               UpdateBegin      - Enables columns in the browse and passes
                                  updateState to other objects
               Update           - Disables the browse. It means that some other
                                  object has just started an update
               UpdateComplete   - Enables the browse
     Notes:   See datavis.p           
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pcState AS CHARACTER NO-UNDO.
  
  DEFINE VARIABLE hBrowse        AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hSearchField   AS HANDLE     NO-UNDO.
  DEFINE VARIABLE lModified      AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cNewRecord     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lCanNavigate   AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE hSource        AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hDataSource    AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hCurrSource    AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hRequester     AS HANDLE     NO-UNDO.
  
  /* If we are the publisher's (dataSource's) currentUpdateSource then we 
     actually are the original publisher of this event, so just return */
  {get DataSource hDataSource}.

  /* SBOs does run, so SOURCE is incorrect, so unless we know the 
     SOURCE is the dataSource check the special trick property   */    
  IF hDataSource <> SOURCE-PROCEDURE THEN
    hRequester = {fn getTargetProcedure SOURCE-PROCEDURE} NO-ERROR.
  ELSE 
    hRequester = SOURCE-PROCEDURE.

  {get CurrentUpdateSource hCurrSource hRequester} NO-ERROR.

  IF TARGET-PROCEDURE = hCurrSource THEN
    RETURN.   

  CASE pcState:
    WHEN 'UpdateBegin':U THEN 
    DO:
      RUN enableFields IN TARGET-PROCEDURE.
      PUBLISH 'updateState':U FROM TARGET-PROCEDURE 
        /* In case enable fails for some reason.*/
        (IF RETURN-VALUE = "ADM-ERROR":U THEN 'UpdateComplete':U
           ELSE 'Update':U).   /* Tell others (Data Object, Nav Panel) */
    END.
    WHEN 'Update':U THEN
    DO:
      /* Update means some other object just started an update. Disable the 
         browser until the update completes to prevent the user from changing
         records in the middle of the update. 
         Ignore this if modified or new to avoid disabling when this is a 
         'backfire' from this object caused by the fact that the updateState
         published on add or on a modification will be published back to us 
         since visual objects both subscribe and publish this event to
         DataSources.  */
      &SCOPED-DEFINE xp-assign
      {get BrowseHandle hBrowse}
      {get SearchHandle hSearchField}
      {get DataModified lModified}
      {get NewRecord cNewRecord}. 
      &UNDEFINE xp-assign
      
      IF NOT lModified AND cNewRecord = 'no':U THEN 
        ASSIGN
          hSearchField:SENSITIVE = NO WHEN VALID-HANDLE(hSearchField)
          hBrowse:SENSITIVE      = NO.
    END.
    WHEN 'UpdateComplete':U THEN
    DO:
      /* We might get this as a run from an SBO, in which case the 
         TargetProcedure has been set in order to identify the source */
      {get TargetProcedure hSource SOURCE-PROCEDURE} NO-ERROR.
       IF NOT VALID-HANDLE(hSource) THEN
           hSource = SOURCE-PROCEDURE.

      /* canNavigate returns false if updates prevents us from navigating.
         We must set the gh- var so the SBO can identify the real target
         from the source-procedure. */
      lCanNavigate = ?.
      ghTargetProcedure = TARGET-PROCEDURE.
      lCanNavigate = {fn canNavigate hSource} NO-ERROR.
      ghTargetProcedure = ?.
      /* Active denials only (unknown is yes) */
      IF NOT (lCanNavigate = FALSE) THEN
      DO:
        &SCOPED-DEFINE xp-assign
        {get BrowseHandle hBrowse}
        {get SearchHandle hSearchField}.
        &UNDEFINE xp-assign
        ASSIGN
          hSearchField:SENSITIVE = YES WHEN VALID-HANDLE(hSearchField)
          hBrowse:SENSITIVE      = YES.
      END. /* canNavigate */
    END.
  END CASE.

  RUN SUPER(pcState).

  RETURN.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-updateTitle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE updateTitle Procedure 
PROCEDURE updateTitle :
/*------------------------------------------------------------------------------
  Purpose:     SmartDataBrowser version of updateTitle.
  Notes:       Setting up window title for a object controller is different than
               for a viewer. This code deals with specifically getting the info 
               from the broswer's data-source's. 
               
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hSource               AS HANDLE       NO-UNDO.
  DEFINE VARIABLE cDisplayed            AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE cColumns              AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE cWindowTitleField     AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE cWindowTitleColumn    AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE cWindowTitleValue     AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE cWindowName           AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE cWindowTitle          AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE hContainerHandle      AS HANDLE       NO-UNDO.
  DEFINE VARIABLE hSourceSource         AS HANDLE       NO-UNDO.
  DEFINE VARIABLE hContainerSource      AS HANDLE       NO-UNDO.

   &SCOPED-DEFINE xp-assign
  {get DataSource hSource}
  /* get window title if required */
  {get WindowTitleField cWindowTitleField}.
  &UNDEFINE xp-assign
  
  IF  VALID-HANDLE(hSource) THEN
      {get DataSource hSourceSource hSource}.

  IF  cWindowTitleField <> "" AND VALID-HANDLE(hSourceSource) THEN DO:    
      cWindowTitleColumn = DYNAMIC-FUNCTION ("colValues":U IN hSourceSource, cWindowTitleField).

    IF  NUM-ENTRIES(cWindowTitleColumn, CHR(1)) = 2 THEN DO:
        cWindowTitleValue = ENTRY(2,cWindowTitleColumn, CHR(1)).
        IF cWindowTitleValue <> ? THEN DO:
          {get ContainerSource hContainerSource}.
          IF VALID-HANDLE(hContainerSource) THEN DO:
            {get WindowName cWindowName hContainerSource}.
            {get ContainerHandle hContainerHandle hContainerSource}.
          END.

          IF INDEX(cWindowName," - ") = 0 
              THEN cWindowTitle = cWindowName.
              ELSE cWIndowTitle = SUBSTRING(cWindowName,1,INDEX(cWIndowName," - ") - 1).
          cWindowTitle = cWindowTitle + " - " + cWindowTitleValue.
          IF VALID-HANDLE(hContainerHandle) THEN
            hContainerHandle:TITLE = cWindowTitle.           
        END.
    END.
  END.
  
  RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-viewObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE viewObject Procedure 
PROCEDURE viewObject :
/*------------------------------------------------------------------------------
  Purpose:     Override to run setDown to set the DOWN attribute for the browse 
               when it is being viewed and to fix problems caused by the browse's
               implicit visualization behavior.
  Parameters:  <none>
  Notes:     - setDown must be called from viewObject as opposed to 
               initializeObject to support the object being on a page other
               than zero, because set down requires a visible browse. 
               This sets DOWN when the object is actually being viewed rather 
               than when it is initialized which could happen before it is 
               viewed if it is on a page other than zero.  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE iNumDown       AS INTEGER    NO-UNDO.
  DEFINE VARIABLE rRowid         AS ROWID      NO-UNDO.
  DEFINE VARIABLE hDataSource    AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hUpdateTarget  AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hDataHandle    AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hRowObject     AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hBrowse        AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cInactiveLinks AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lNewMode       AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cUIBMode       AS CHARACTER  NO-UNDO.

  &SCOPED-DEFINE xp-assign
  {get DataSource hDataSource}
  {get UpdateTarget hUpdateTarget}
  {get BrowseHandle hBrowse}
  {get UIBmode cUIBMode}
   .
  &UNDEFINE xp-assign
  
  /* The browser may be out of synch, so log the DataSource's current rowid 
     for reposition further down as implicit browser behavior when viewing 
     a hidden browse otherwise will position the query to the browser's rec
     (DataSource is valid, but getNewmode will give errors in design mode ) */
  IF VALID-HANDLE(hDataSource) AND NOT (cUIBMode BEGINS "Design":U) THEN
  DO:
    /* - We assume the query rowid is current unless SDO is deactive.
        (If it is inactive it will be activated by the viewObject - linkState) 
       - The browse is definitely out of synch in addmode if another object 
         is updateTarget. */
    &SCOPED-DEFINE xp-assign
    {get NewMode lNewMode hDataSource}
    {get InactiveLinks cInactiveLinks hDataSource}
    .
    &UNDEFINE xp-assign
    IF (lNewMode AND hDataSource <> hUpdateTarget) 
    OR NOT CAN-DO(cInactiveLinks,'DataSource':U) THEN
      ASSIGN 
        /* nothing really works if there is no rowobject here, but it could 
           happen if links are missing or datasource fails etc and an
           error message just makes it worse, so suppress it */
        hRowObject = hBrowse:QUERY:GET-BUFFER-HANDLE(1)
        rRowid     = hRowObject:ROWID NO-ERROR. 
  END. /* valid datasource */
  
  RUN SUPER.
  
  /* Reset buffer in case the visualization changed it */
  IF  VALID-HANDLE(hDataSource) 
  AND VALID-HANDLE(hRowObject) 
  AND rRowid <> ? 
  AND rRowid <> hRowObject:ROWID THEN
    hRowObject:FIND-BY-ROWID(rRowid).  

  {get NumDown iNumDown}.
  
  IF iNumDown > 0 THEN 
    RUN setDown IN TARGET-PROCEDURE (INPUT iNumDown).
  
  {fn adjustVisibleRowids}.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-adjustVisibleRowids) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION adjustVisibleRowids Procedure 
FUNCTION adjustVisibleRowids RETURNS LOGICAL
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  Adjusts the number of entries in the visibleRowids to the number of 
            records in the browse. 
    Notes:  The visibleRowids is used on scroll-notify when ScrollRemote
            is true. It stores the list of the rowids in the viewport. The list
            is updated in the rowDisplay procedure fired on the ROW-DISPLAY event   
          - The logic here is to avoid having rowDisplay adding to the list 
            and exceeding Progress limitations when not cleared. Since DOWN 
            cannot be referenced in ROW-DISPLAY this logic does the counting 
            and adjusts the number of entries in the property while RowDisplay 
            always removes an entry when it adds an entry.
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hBrowse  AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cRowids  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cRowList AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iEntries AS INTEGER    NO-UNDO.
  
  DEFINE VARIABLE iEntry  AS INTEGER    NO-UNDO.

  {get BrowseHandle hBrowse}.

  iEntries = hBrowse:DOWN. 
  IF iEntries > 0 THEN
  DO:
    {get VisibleRowids cRowids}.

    /* increase */
    IF NUM-ENTRIES(cRowids) LT iEntries THEN 
      cRowList = FILL(',':U,iEntries - NUM-ENTRIES(cRowids) - 1) + cRowids.
    /* Read from end of current list and append at beginning */
    ELSE IF NUM-ENTRIES(cRowids) GT iEntries THEN 
    DO iEntry = 1 TO iEntries:
      cRowList = ENTRY(NUM-ENTRIES(cRowids) - iEntry + 1,cRowids) 
               + (IF cRowList = '':U THEN '':u ELSE ',':U) 
               + cRowList.
    END.
    {set VisibleRowids cRowList}.
  END.

  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-calculateDownHeight) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION calculateDownHeight Procedure 
FUNCTION calculateDownHeight RETURNS DECIMAL
  ( piNumDown as integer ) :
/*------------------------------------------------------------------------------
  Purpose: Calculate height in decimal for the number of down requested 
    Notes: This does not set the height permanent 
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hBrowse     AS HANDLE NO-UNDO.
  DEFINE VARIABLE dDownHeight AS DECIMAL NO-UNDO.
  DEFINE VARIABLE dHeight     AS DECIMAL NO-UNDO.
  DEFINE VARIABLE lHidden     AS LOGICAL NO-UNDO.

  {get BrowseHandle hBrowse}.
  /* this should normally be called when everything is hidden, but we hide
     to make sure sizing is not prevented by frame sizes 
     (might not be an issue for the browse widget as it seem to be able to 
      resize out of bonds) */ 
  assign
    dHeight = hBrowse:height
    lHidden = hBrowse:hidden
    hBrowse:hidden = true .
  
  /* If the height matches the down we are trying to set it to then setting 
     down doesn't have any affect on height. So we set it smaller to ensure
     exact adjusted height  */
  IF hBrowse:DOWN = piNumDown THEN 
    hBrowse:DOWN = piNumDown - 1 NO-ERROR.
  hBrowse:DOWN = piNumDown NO-ERROR.
  assign
    dDownHeight    = hBrowse:height
    hBrowse:height = dHeight 
    hBrowse:hidden = lHidden no-error.
 
  RETURN dDownHeight.    

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-calculateMaxWidth) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION calculateMaxWidth Procedure 
FUNCTION calculateMaxWidth RETURNS DECIMAL
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  calculate the max width needed for all columns
    Notes:  The width calculation is using decimals and should possibly use 
            pixels for max precision, but the return has to be decimals so 
            a rounding will still occur and this does work on variousresolution
             (600 x 800 and 1280 x 1024)
 -----------------------------------------------------------------------------*/
  define variable hColumn as handle  no-undo.
  define variable hBrowse as handle  no-undo.
  define variable dWidth  as decimal no-undo.
   
  {get BrowseHandle hBrowse}.
   
  dWidth = {&browseborderwidth}. /* fixed part - scrollbar and stuff */ 
  
  IF hBrowse:ROW-MARKERS THEN 
    dWidth = dWidth + {&browserowmarkerwidth}.
  
  hColumn = hBrowse:FIRST-COLUMN.  
  if valid-handle(hColumn) then
  do:
    DO WHILE VALID-HANDLE(hColumn):
      dWidth  = dWidth + hColumn:WIDTH + {&browsedividerwidth}. 
      hColumn = hColumn:NEXT-COLUMN.
    END.  /* Do While */
    /* The divider needs to be added one less time than number of columns */ 
    dWidth = dWidth - {&browsedividerwidth}.   
  end.
  
  RETURN dWidth. 

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-colValues) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION colValues Procedure 
FUNCTION colValues RETURNS CHARACTER
  ( pcViewColList AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Formats a row of formatted values from the current row of the
            SmartDataBrowser query for the specified column list.
   Params:  pcViewColList AS CHARACTER -- comma-separated list of 
            requested columns.
    Notes:  Only applies for a SmartDataBrowser with its own query.
            Passes back a CHR(1) delimited list with the RowIdent as the 
            first value in all cases and fields values 
            (in the order they are requested).
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cColValues AS CHARACTER NO-UNDO INIT "":U.
  DEFINE VARIABLE iCol       AS INTEGER   NO-UNDO.
  DEFINE VARIABLE hColumn    AS HANDLE    NO-UNDO.
  DEFINE VARIABLE iColCount  AS INTEGER   NO-UNDO.
  DEFINE VARIABLE hQuery     AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hBuffer    AS HANDLE    NO-UNDO.
  DEFINE VARIABLE iTable     AS INTEGER   NO-UNDO.
  DEFINE VARIABLE iArray     AS INTEGER   NO-UNDO.
  DEFINE VARIABLE cName      AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cRowIdent  AS CHARACTER NO-UNDO.
           
  iColCount = NUM-ENTRIES(pcViewColList).
  /* NOTE: This function is valid only if the Browser has its own db query,
     in which case it will include the Query super procedure and this will
     be defined. Otherwise we don't do anything with this request. */
  hQuery = DYNAMIC-FUNCTION("getQueryHandle":U IN TARGET-PROCEDURE) NO-ERROR.
  IF NOT VALID-HANDLE(hQuery) THEN
    RETURN ?.

  /* Construct the RowIdent "cookie" which is passed to the requesting object.*/
  /* Start with a blank to signal this is not a RowObject TT */
  DO iTable = 1 TO hQuery:NUM-BUFFERS:
    hBuffer = hQuery:GET-BUFFER-HANDLE(iTable).
    cRowIdent = cRowIdent + ",":U + STRING(hBuffer:ROWID).
  END.
  cColValues = cColValues + cRowIdent + CHR(1).

  iColLoop:
  DO iCol = 1 TO iColCount:
    /* Cycle through tables till column found.*/
    DO iTable = 1 TO hQuery:NUM-BUFFERS: 
      cName  = ENTRY(iCol,pcViewColList).
      iArray = IF NUM-ENTRIES(cName,"[") > 1 
               THEN INT(ENTRY(1,ENTRY(2,cName,"["),"]"))
               ELSE 0.
      cName  = ENTRY(1,cName,"[":U).
      hBuffer = hQuery:GET-BUFFER-HANDLE(iTable).
      hColumn = hBuffer:BUFFER-FIELD(cName) NO-ERROR.
      IF VALID-HANDLE(hColumn) THEN
      DO:
        cColValues = cColValues + 
          RIGHT-TRIM(STRING(hColumn:BUFFER-VALUE(iArray))) +
          (IF iCol NE iColCount THEN CHR(1) ELSE "":U).
        NEXT iColLoop.                   
      END.    /* END DO for hColumn */
    END.      /* END DO iTable      */
    DYNAMIC-FUNCTION("showMessage":U IN TARGET-PROCEDURE, 
      "Column ":U + ENTRY(iCol, pcViewColList) + "not found in Browser.":U).
    RETURN ?.
  END.        /* END DO iCol        */
  RETURN cColValues.       

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-destroyBrowse) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION destroyBrowse Procedure 
FUNCTION destroyBrowse RETURNS LOGICAL
  (  ) :
/*------------------------------------------------------------------------------
  Purpose: destroy browse (remove all columns in design mode)
    Notes: Separated out of destroyobject to be called from inst prop dialog 
           at design time 
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hDataSource  AS HANDLE   NO-UNDO.
  DEFINE VARIABLE lAction      AS LOG      NO-UNDO.
  DEFINE VARIABLE hSearchField AS HANDLE   NO-UNDO.
  DEFINE VARIABLE hSearchLabel AS HANDLE   NO-UNDO.
  DEFINE VARIABLE hPopupMenu   AS HANDLE   NO-UNDO.
  DEFINE VARIABLE hBrowse      AS HANDLE   NO-UNDO.
  DEFINE VARIABLE cUIBmode     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hNext        AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hDel         AS HANDLE     NO-UNDO.

  &SCOPED-DEFINE xp-assign
  {get SearchHandle hSearchField}
  {get BrowseHandle hBrowse}
  {get UIBMode cUIBMode}
   .
  &UNDEFINE xp-assign
  
  hPopupMenu = hBrowse:POPUP-MENU NO-ERROR.
  /* Do this only if the object does not have its own database query. */
  {get DataSource hDataSource}.
  
  ghTargetProcedure = TARGET-PROCEDURE. /* 9.1B: Stash this so DQB can get it.*/
  {set DataQueryBrowsed NO hDataSource} NO-ERROR.
  ghTargetProcedure = ?.         /* 9.1B: reset local TargetProcedure var. */
  
  IF VALID-HANDLE(hSearchField) THEN
  DO:
    hSearchLabel = hSearchField:SIDE-LABEL-HANDLE.
    DELETE OBJECT hSearchField.
    DELETE OBJECT hSearchLabel.
  END.

  /* Destroy the browser's Popup Menu when it is dynaamic, a static popup
     menu could be defined for static browsers  */
  IF VALID-HANDLE(hPopupMenu) AND hPopupMenu:DYNAMIC THEN
    DELETE OBJECT hPopupMenu.
  
  /* removes columns 
    (no-error is used as this actually may give a don't fit in frame error ) */
  hBrowse:QUERY = ? NO-ERROR.
  
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fieldSecurityRule) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fieldSecurityRule Procedure 
FUNCTION fieldSecurityRule RETURNS CHARACTER
  ( phWidget AS HANDLE ) :
/*------------------------------------------------------------------------------
  Purpose: Check a field name against the FieldSecurity of the object 
Parameter: phWidget - handle (in order to be used after locateWidget in
                              the client api)
    Notes: Considered as Private  - Mainly because the handle is input. 
           Overrides visual because AllFieldHandles is not set  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cFieldHandles    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSecuredFields   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iPos             AS INTEGER    NO-UNDO.

  &SCOPED-DEFINE xp-assign
  {get FieldSecurity cSecuredFields}
  {get FieldHandles  cFieldHandles}
  .
  &UNDEFINE xp-assign
  
  iPos = LOOKUP(STRING(phWidget),cFieldHandles).

  /* Bad reference */
  IF iPos = 0 THEN
    RETURN ?.

  IF iPos <= NUM-ENTRIES(cSecuredFields) THEN
    RETURN ENTRY(iPos,cSecuredFields).
  
  RETURN "":U.  

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getActionEvent) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getActionEvent Procedure 
FUNCTION getActionEvent RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose: return the event to publish on Default-action of the browse. 
Parameter: 
    Notes: setActionEvent(pcEvent) defines the persistent trigger that runs 
           defaultAction and also subscribes the source-procedure.  
------------------------------------------------------------------------------*/
DEFINE VARIABLE cActionEvent AS CHARACTER  NO-UNDO.

  &SCOPED-DEFINE xpActionEvent
  {get ActionEvent cActionEvent}.
  &UNDEFINE xpActionEvent
  
  RETURN cActionEvent.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getApplyActionOnExit) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getApplyActionOnExit Procedure 
FUNCTION getApplyActionOnExit RETURNS LOGICAL
  ( ) :
/*------------------------------------------------------------------------------
  Purpose: Returns TRUE if exit is suppoesed to select the row in the browse.
    Notes: Currently used by the SmartSelect.
------------------------------------------------------------------------------*/
   DEF VAR lApply AS LOG NO-UNDO.
  {get ApplyActionOnExit lApply}.
  RETURN lApply.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getApplyExitOnAction) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getApplyExitOnAction Procedure 
FUNCTION getApplyExitOnAction RETURNS LOGICAL
  ( ) :
/*------------------------------------------------------------------------------
  Purpose: Returns TRUE if DEFAULT-ACTION is to exit the browse.
    Notes: Currently used by the SmartSelect.
           The logic is not performed in the trigger, but in the defaultAction
           procedure that gets defined as a persitent DEFAULT-ACTION event
           when setActionEvent is defined. 
           Local DEFAULT-ACTION events could be set up to run defaultAction.            
------------------------------------------------------------------------------*/
   DEF VAR lApply AS LOG NO-UNDO.
   {get ApplyExitOnAction lApply}.
   RETURN lApply.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getBGColor) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getBGColor Procedure 
FUNCTION getBGColor RETURNS INTEGER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  returns the Background color of the browse
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE iBGColor AS INTEGER NO-UNDO INIT ?.
  DEFINE VARIABLE hBrowse  AS HANDLE  NO-UNDO.
  
  {get Browsehandle hBrowse}.
   IF VALID-HANDLE(hBrowse) THEN
      iBGColor =  hBrowse:BGCOLOR.  
      
  RETURN iBGColor.
 
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getBrowseColumnAutoCompletions) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getBrowseColumnAutoCompletions Procedure 
FUNCTION getBrowseColumnAutoCompletions RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
DEFINE VARIABLE cBrowseColumnAutoCompletions        AS CHARACTER NO-UNDO.
    
{get BrowseColumnAutoCompletions cBrowseColumnAutoCompletions}.
    
RETURN cBrowseColumnAutoCompletions.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getBrowseColumnBGColors) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getBrowseColumnBGColors Procedure 
FUNCTION getBrowseColumnBGColors RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    DEFINE VARIABLE cBrowseColumnBGColors    AS character                NO-UNDO.
    
    {get BrowseColumnBGColors cBrowseColumnBGColors}.
    
    RETURN cBrowseColumnBGColors.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getBrowseColumnDelimiters) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getBrowseColumnDelimiters Procedure 
FUNCTION getBrowseColumnDelimiters RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
DEFINE VARIABLE cBrowseColumnDelimiters        AS CHARACTER NO-UNDO.
    
{get BrowseColumnDelimiters cBrowseColumnDelimiters}.
    
RETURN cBrowseColumnDelimiters.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getBrowseColumnFGColors) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getBrowseColumnFGColors Procedure 
FUNCTION getBrowseColumnFGColors RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    DEFINE VARIABLE cBrowseColumnFGColors        AS character        NO-UNDO.
    
    {get BrowseColumnFGColors cBrowseColumnFGColors}.
    
    RETURN cBrowseColumnFGColors.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getBrowseColumnFonts) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getBrowseColumnFonts Procedure 
FUNCTION getBrowseColumnFonts RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    DEFINE VARIABLE cBrowseColumnFonts        AS character            NO-UNDO.
    
    {get BrowseColumnFonts cBrowseColumnFonts}.
    
    RETURN cBrowseColumnFonts.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getBrowseColumnInnerLines) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getBrowseColumnInnerLines Procedure 
FUNCTION getBrowseColumnInnerLines RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
DEFINE VARIABLE cBrowseColumnInnerLines        AS CHARACTER NO-UNDO.
    
{get BrowseColumnInnerLines cBrowseColumnInnerLines}.
    
RETURN cBrowseColumnInnerLines.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getBrowseColumnItemPairs) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getBrowseColumnItemPairs Procedure 
FUNCTION getBrowseColumnItemPairs RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
DEFINE VARIABLE cBrowseColumnItemPairs        AS CHARACTER NO-UNDO.
    
{get BrowseColumnItemPairs cBrowseColumnItemPairs}.
    
RETURN cBrowseColumnItemPairs.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getBrowseColumnItems) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getBrowseColumnItems Procedure 
FUNCTION getBrowseColumnItems RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
DEFINE VARIABLE cBrowseColumnItems        AS CHARACTER NO-UNDO.
    
{get BrowseColumnItems cBrowseColumnItems}.
    
RETURN cBrowseColumnItems.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getBrowseColumnLabelBGColors) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getBrowseColumnLabelBGColors Procedure 
FUNCTION getBrowseColumnLabelBGColors RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    DEFINE VARIABLE cBrowseColumnLabelBGColors        AS character        NO-UNDO.
    
    {get BrowseColumnLabelBGColors cBrowseColumnLabelBGColors}.
    
    RETURN cBrowseColumnLabelBGColors.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getBrowseColumnLabelFGColors) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getBrowseColumnLabelFGColors Procedure 
FUNCTION getBrowseColumnLabelFGColors RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    DEFINE VARIABLE cBrowseColumnLabelFGColors        AS character        NO-UNDO.
    
    {get BrowseColumnLabelFGColors cBrowseColumnLabelFGColors}.
    
    RETURN cBrowseColumnLabelFGColors.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getBrowseColumnLabelFonts) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getBrowseColumnLabelFonts Procedure 
FUNCTION getBrowseColumnLabelFonts RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    DEFINE VARIABLE cBrowseColumnLabelFonts        AS character        NO-UNDO.
    
    {get BrowseColumnLabelFonts cBrowseColumnLabelFonts}.
    
    RETURN cBrowseColumnLabelFonts.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getBrowseColumnLabels) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getBrowseColumnLabels Procedure 
FUNCTION getBrowseColumnLabels RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    DEFINE VARIABLE cBrowseColumnLabels        AS character            NO-UNDO.
    
    {get BrowseColumnLabels cBrowseColumnLabels}.
    
    RETURN cBrowseColumnLabels.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getBrowseColumnMaxChars) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getBrowseColumnMaxChars Procedure 
FUNCTION getBrowseColumnMaxChars RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
DEFINE VARIABLE cBrowseColumnMaxChars        AS CHARACTER NO-UNDO.
    
{get BrowseColumnMaxChars cBrowseColumnMaxChars}.
    
RETURN cBrowseColumnMaxChars.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getBrowseColumnSorts) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getBrowseColumnSorts Procedure 
FUNCTION getBrowseColumnSorts RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
DEFINE VARIABLE cBrowseColumnSorts        AS CHARACTER NO-UNDO.
    
{get BrowseColumnSorts cBrowseColumnSorts}.
    
RETURN cBrowseColumnSorts.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getBrowseColumnTypes) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getBrowseColumnTypes Procedure 
FUNCTION getBrowseColumnTypes RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose: Comma delimited list containing the column type. Possible values are:
            ?=default value set to FILL-IN
            FI=FILL-IN
            DD=DROP-DOWN combo-box
            DDL=DROP-DOWN-LIST combo-box
            TB=TOGGLE-BOX
    Notes:  
------------------------------------------------------------------------------*/
DEFINE VARIABLE cBrowseColumnTypes        AS CHARACTER NO-UNDO.
    
{get BrowseColumnTypes cBrowseColumnTypes}.
    
RETURN cBrowseColumnTypes.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getBrowseColumnUniqueMatches) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getBrowseColumnUniqueMatches Procedure 
FUNCTION getBrowseColumnUniqueMatches RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
DEFINE VARIABLE cBrowseColumnUniqueMatches  AS CHARACTER NO-UNDO.
    
{get BrowseColumnUniqueMatches cBrowseColumnUniqueMatches}.
    
RETURN cBrowseColumnUniqueMatches.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getBrowseColumnWidths) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getBrowseColumnWidths Procedure 
FUNCTION getBrowseColumnWidths RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    DEFINE VARIABLE cBrowseColumnWidths        AS character            NO-UNDO.
    
    {get BrowseColumnWidths cBrowseColumnWidths}.
    
    RETURN cBrowseColumnWidths.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getBrowseHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getBrowseHandle Procedure 
FUNCTION getBrowseHandle RETURNS HANDLE
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the handle of the browse control.
   Params:  <none>
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hBrowse AS HANDLE NO-UNDO.
  {get BrowseHandle hBrowse} NO-ERROR.
  RETURN hBrowse.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getCalcWidth) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getCalcWidth Procedure 
FUNCTION getCalcWidth RETURNS LOGICAL
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns logical value that determines whether the width of the browse
            is calculated to the exact width it should be for the fields it contains
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE lCalcWidth AS LOGICAL NO-UNDO.
  {get CalcWidth lCalcWidth} NO-ERROR.
  RETURN lCalcWidth.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getColumnsMovable) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getColumnsMovable Procedure 
FUNCTION getColumnsMovable RETURNS LOGICAL
  ( ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns logical value that determines whether the browser's columns
            are movable
    Notes:  
------------------------------------------------------------------------------*/
DEFINE VARIABLE lMovable AS LOGICAL    NO-UNDO.

  &SCOPED-DEFINE xpColumnsMovable
  {get ColumnsMovable lMovable}.
  &UNDEFINE xpColumnsMovable
  
  RETURN lMovable.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getColumnsSortable) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getColumnsSortable Procedure 
FUNCTION getColumnsSortable RETURNS LOGICAL
  ( ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns logical value that determines whether the browser's columns
            are sortable
    Notes:  
------------------------------------------------------------------------------*/
DEFINE VARIABLE lSortable AS LOGICAL    NO-UNDO.

  &SCOPED-DEFINE xpColumnsSortable
  {get ColumnsSortable lSortable}.
  &UNDEFINE xpColumnsSortable
  
  RETURN lSortable.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDataObjectHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getDataObjectHandle Procedure 
FUNCTION getDataObjectHandle RETURNS HANDLE
  (  ) :
/*------------------------------------------------------------------------------
  Purpose: Return the data object handle (not the SBO) 
    Notes: Used in methods where the browser needs to access the actual data 
           object also when the datasource is a SmartBusinessObject  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hDataSource       AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cDataSource       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cObjectType       AS CHARACTER  NO-UNDO.

  {get DataSource hDataSource}.   /* Proc. handle of  Dataview/SDO/SBO. */
  
  IF VALID-HANDLE(hDataSource) THEN
  DO:
    {get ObjectType cObjectType hDataSource}.
    IF cObjectType = 'SmartBusinessObject':U THEN      
    DO:
      /* The SDO name is stored in the DataSourceNames property */
      {get DataSourceNames cDataSource}.
      hDataSource = {fnarg dataObjectHandle cDataSource hDataSource}.
    END.
  END.

  RETURN hDataSource.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDataSignature) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getDataSignature Procedure 
FUNCTION getDataSignature RETURNS CHARACTER
  ( ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns a character string value which is a list of integers 
            corresponding to the datatypes of the fields in the object 
            Temp-Table, for use in comparing objects for equivalence.
   Params:  <none>
    Notes:  A SmartDataObject and a SmartDataBrowser which have the same 
            DataSignature will be compatible; the SDO's query can be used 
            by the SmartDataBrowser. The integer values are the same codes 
            used in the _dtype field in the schema. 
            Used at design-time.
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cSignature AS CHARACTER NO-UNDO INIT "":U.
  DEFINE VARIABLE iCol       AS INTEGER   NO-UNDO.
  DEFINE VARIABLE hRowObject AS HANDLE    NO-UNDO.
  DEFINE VARIABLE cDataType  AS CHARACTER NO-UNDO.
  DEFINE VARIABLE hColumn    AS HANDLE    NO-UNDO.

  {get RowObject hRowObject} NO-ERROR.
  IF VALID-HANDLE(hRowObject) THEN
  DO iCol = 1 TO hRowObject:NUM-FIELDS:
    hColumn = hRowObject:BUFFER-FIELD(iCol).
    cDataType = hColumn:DATA-TYPE.
    cSignature = cSignature +
     (IF      cDataType = 'CHARACTER':U   THEN '01':U
      ELSE IF cDataType = 'DATE':U        THEN '02':U
      ELSE IF cDataType = 'LOGICAL':U     THEN '03':U
      ELSE IF cDataType = 'INTEGER':U     THEN '04':U
      ELSE IF cDataType = 'DECIMAL':U     THEN '05':U
      /* Note: Float/Double reserved for possible future use. */
      ELSE IF cDataType = 'FLOAT':U OR 
              cDataType = 'DOUBLE':U      THEN '06':U
      ELSE IF cDataType = 'RECID':U       THEN '07':U
      ELSE IF cDataType = 'RAW':U         THEN '08':U
      ELSE IF cDataType = 'ROWID':U       THEN '09':U  
      ELSE IF cDataType = 'BLOB':U        THEN '18':U 
      ELSE IF cDataType = 'CLOB':U        THEN '19':U 
      ELSE IF cDataType = 'DATETIME':U    THEN '34':U 
      ELSE IF cDataType = 'DATETIME-TZ':U THEN '40':U
      ELSE IF cDataType = 'INT64':U       THEN '41':U
      ELSE '00':U).
  END.
  ELSE cSignature = ?.     /* No RowObject means dynamic browse. */
  
  RETURN cSignature.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDefaultColumnData) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getDefaultColumnData Procedure 
FUNCTION getDefaultColumnData RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the list of default column data
   Params:  <none>
    Notes:  Format is column1name CHR(4) width CHR(3) column2name CHR(4) width
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cData AS CHARACTER NO-UNDO.
  {get DefaultColumnData cData} NO-ERROR.
  RETURN cData.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getFetchOnReposToEnd) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getFetchOnReposToEnd Procedure 
FUNCTION getFetchOnReposToEnd RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose: returns true if the browse should fetch more data from the server to 
           fill the batch when repositioing to the end of a batch
    Notes: This gives the correct visual appearance, but will require an 
           additional request to the server.
------------------------------------------------------------------------------*/
  DEFINE VARIABLE lFetchOnRepos AS LOGICAL    NO-UNDO.
  {get FetchOnReposToEnd lFetchOnRepos}.
  RETURN lFetchOnRepos.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getFGColor) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getFGColor Procedure 
FUNCTION getFGColor RETURNS INTEGER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  Retrieves the Foreground Color of the browse
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE iFGColor AS INTEGER NO-UNDO INIT ?.
  DEFINE VARIABLE hBrowse  AS HANDLE  NO-UNDO.
    
  {get Browsehandle hBrowse}.
  IF VALID-HANDLE(hBrowse) THEN
      iFGColor =  hBrowse:FGCOLOR. 
  
  RETURN iFGColor.
  

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getFolderWindowToLaunch) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getFolderWindowToLaunch Procedure 
FUNCTION getFolderWindowToLaunch RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
DEF VAR cTemp AS CHARACTER.

    {get FolderWindowToLaunch cTemp}.
  RETURN cTemp.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getFont) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getFont Procedure 
FUNCTION getFont RETURNS INTEGER
(  ) :
/*------------------------------------------------------------------------------
  Purpose: get the font of the browse
    Notes:  
------------------------------------------------------------------------------*/
 DEFINE VARIABLE hBrowse AS HANDLE     NO-UNDO.

 {get BrowseHandle hBrowse}.
 IF VALID-HANDLE(hBrowse) THEN
   RETURN hBrowse:FONT.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getMaxWidth) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getMaxWidth Procedure 
FUNCTION getMaxWidth RETURNS DECIMAL
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns maximum value used for setting the width of the browse when
            CalcWidth is TRUE.  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE dMaxWidth AS DECIMAL NO-UNDO.
  {get MaxWidth dMaxWidth} NO-ERROR.
  RETURN dMaxWidth.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getMovableHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getMovableHandle Procedure 
FUNCTION getMovableHandle RETURNS HANDLE
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the handle of the movable popup menu item.
   Params:  <none>
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hMovableItem AS HANDLE NO-UNDO.
  {get MovableHandle hMovableItem} NO-ERROR.
  RETURN hMovableItem.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getNumDown) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getNumDown Procedure 
FUNCTION getNumDown RETURNS INTEGER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the number of rows that are displayed DOWN in the browse   
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE iNumDown AS INTEGER NO-UNDO.
  {get NumDown iNumDown} NO-ERROR.
  RETURN iNumDown.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getPopupActive) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getPopupActive Procedure 
FUNCTION getPopupActive RETURNS LOGICAL
  ( ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns logical value that determines whether the browser popup
            menu is active
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE lActive AS LOGICAL    NO-UNDO.
  {get PopupActive lActive}.
  RETURN lActive.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getQueryRowObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getQueryRowObject Procedure 
FUNCTION getQueryRowObject RETURNS HANDLE
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the handle of the RowObject Temp-Table associated with the
            Browse's Query.
    Notes:  Note that this function cannot calculate this at run time. This 
            function is called from within a ROW-DISPLAY event and that 
            precludes us from getting access to the BROWSE handle here.
            Thus, setQueryRowObject sets the value of this handle.
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hQueryRowObject AS HANDLE     NO-UNDO.

  {get QueryRowObject hQueryRowObject}.

  RETURN hQueryRowObject.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getSavedColumnData) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getSavedColumnData Procedure 
FUNCTION getSavedColumnData RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the list of saved column data
   Params:  <none>
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cData AS CHARACTER NO-UNDO.
  {get SavedColumnData cData} NO-ERROR.
  RETURN cData.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getScrollRemote) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getScrollRemote Procedure 
FUNCTION getScrollRemote RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  Gets the value of the ScrollRemote attribute  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE lScrollRemote AS LOGICAL    NO-UNDO.

  {get ScrollRemote lScrollRemote}.

  RETURN lScrollRemote.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getSearchField) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getSearchField Procedure 
FUNCTION getSearchField RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the name of a field on which searching is enabled; if
            set, space is allocated for a fill-in to accept a value to be
            repositioned to.
   Params:  <none>
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cField   AS CHARACTER NO-UNDO.
  
  {get SearchField cField}.
  RETURN cField.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getSearchFieldMaxWidth) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getSearchFieldMaxWidth Procedure 
FUNCTION getSearchFieldMaxWidth RETURNS DECIMAL
  (  ) :
/*------------------------------------------------------------------------------
  Purpose: Limit size of search field 
    Notes:  
------------------------------------------------------------------------------*/

  RETURN 60.00.   

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getSeparatorFGColor) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getSeparatorFGColor Procedure 
FUNCTION getSeparatorFGColor RETURNS INTEGER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE iSeparatorFGColor AS INTEGER NO-UNDO INIT ?.
  DEFINE VARIABLE hBrowse  AS HANDLE  NO-UNDO.
      
  {get Browsehandle hBrowse}.
  IF VALID-HANDLE(hBrowse) THEN
     iSeparatorFGColor = hBrowse:SEPARATOR-FGCOLOR NO-ERROR.   

  RETURN iSeparatorFGColor.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getSeparators) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getSeparators Procedure 
FUNCTION getSeparators RETURNS LOGICAL
  ( ):

/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hBrowse      AS HANDLE   NO-UNDO.
  DEFINE VARIABLE lInitialized AS LOGICAL  NO-UNDO.
  DEFINE VARIABLE lSeparators  AS LOGICAL    NO-UNDO.
  {get ObjectInitialized lInitialized}.

  IF lInitialized THEN DO:
    {get Browsehandle hBrowse}.
    lSeparators =  hBrowse:SEPARATORS.
  END.
  ELSE
    {get Separators lSeparators}.

  RETURN lSeparators.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getSortableHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getSortableHandle Procedure 
FUNCTION getSortableHandle RETURNS HANDLE
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the handle of the sortable popup menu item.
   Params:  <none>
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hSortableItem AS HANDLE NO-UNDO.
  {get SortableHandle hSortableItem} NO-ERROR.
  RETURN hSortableItem.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getTargetProcedure) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getTargetProcedure Procedure 
FUNCTION getTargetProcedure RETURNS HANDLE
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the value of the super procedure's current TARGET-PROCEDURE,
            when this is needed by a routine called from the super proc.
     
------------------------------------------------------------------------------*/

  RETURN ghTargetProcedure.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getTooltip) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getTooltip Procedure 
FUNCTION getTooltip RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the browser's tooltip
   Params:  <none>
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cTooltip   AS CHARACTER NO-UNDO.
  
  {get TOOLTIP cTooltip}.
  RETURN cTooltip.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getUseSortIndicator) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getUseSortIndicator Procedure 
FUNCTION getUseSortIndicator RETURNS LOGICAL
  (  ) :
/*------------------------------------------------------------------------------
  Purpose: Decides whether the browser should use a graphical arrow in the 
           column label to show sort column and sort direction. 
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE lUseSortIndicator AS LOGICAL    NO-UNDO.
  
  {get UseSortIndicator lUseSortIndicator}.

  RETURN lUseSortIndicator. 

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getVisibleRowids) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getVisibleRowids Procedure 
FUNCTION getVisibleRowids RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  get method for VisibleRowids property
    
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cVisible AS CHARACTER  NO-UNDO.

  {get VisibleRowids cVisible}.

  RETURN cVisible.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getVisibleRowReset) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getVisibleRowReset Procedure 
FUNCTION getVisibleRowReset RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  get method for VisibleRowReset property
    
------------------------------------------------------------------------------*/
  DEFINE VARIABLE lReset AS LOGICAL    NO-UNDO.
  {get VisibleRowReset lReset}.
  RETURN lReset.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-isOkToFetch) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION isOkToFetch Procedure 
FUNCTION isOkToFetch RETURNS LOGICAL
  (INPUT pcRequestedBatch AS CHAR  ) :
/*------------------------------------------------------------------------------
  Purpose:  Indicates whether or not the current Data Object row has changed or
            is not available. 
            Input Parameter "pcRequestedBatch".
               Values: FIRST, LAST are the only values that cause different results.
    Notes:  It is used by the Browser event procedures (on***) to determine if data
            needs to be fetched depending on current batch state.
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cRowident   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hRowObject  AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hQuery      AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hBrowse     AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hSource     AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cQueryPos   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lok         AS LOGICAL    NO-UNDO.

  {get Browsehandle hBrowse}.

  ASSIGN
    hQuery     = hBrowse:QUERY
    hRowObject = hQuery:GET-BUFFER-HANDLE(1)
    lOK        = hRowObject:ROWID <> ?. 
    
  /* if no row is available, we don't need to fetch anything */
  IF lok THEN
  DO:
    {get RowIdent cRowident}.
    /* if the batch request is for First or Last, make sure that are other records*/
    /* available for fetch and that the corresponding record (First or Last) is not */
    /* in the current batch */
    IF LOOKUP(pcRequestedBatch, "FIRST,LAST":U) > 0 THEN
    DO:
      {get DataSource hSource}.
      /* SBO API needs target */
      ghTargetProcedure = TARGET-PROCEDURE.
      {get QueryPosition cQueryPos hSource}.
      ghTargetProcedure = ?.
      lOK = LOOKUP(cQueryPos, pcRequestedBatch + 'Record,OnlyRecord':U) EQ 0 AND
            (LOOKUP(STRING(hRowObject:ROWID), ENTRY(1,cRowident), ';':U) EQ 0
             OR
             DYNAMIC-FUNCT('get' + pcRequestedBatch + 'RowNum' IN hSource) EQ ?).
    END.
    /* in other cases, just verify that we're not currently displaying the */
    /* requested record */
    ELSE 
      lOK = LOOKUP(STRING(hRowObject:ROWID), ENTRY(1,cRowident), ';':U) EQ 0.      
  END.

  RETURN lOK.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-rowVisible) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION rowVisible Procedure 
FUNCTION rowVisible RETURNS CHARACTER
  ( INPUT pcRowids AS CHARACTER,
    INPUT phQryBuffer AS HANDLE ) :
/*------------------------------------------------------------------------------
  Purpose:    Determines whether the currently visible records in the browse 
              are either the first or last records in the batch.
  Parameters: pcRowids - comma separated list of ROWIDs that are currently 
              visible.
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hBuffer  AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hQuery   AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cReturn  AS CHARACTER INITIAL "NONE":U NO-UNDO.
  DEFINE VARIABLE iFirst   AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iLast    AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cLastRow AS CHARACTER  NO-UNDO.

  /* Just in case this function gets called without knowing the correct
     buffer */
  IF NOT VALID-HANDLE(phQryBuffer) OR
     phQryBuffer:TYPE <> "BUFFER" THEN
    RETURN cReturn. 
  
  /* Define a buffer on the query buffer and a query based on the new buffer.
     We cannot reposition the existing query as it has a browse based on it. */
  CREATE BUFFER hBuffer FOR TABLE phQryBuffer.
  CREATE QUERY hQuery.

  /* Add the buffer to the query, prepare the query and open the query */
  hQuery:ADD-BUFFER(hBuffer).
  hQuery:QUERY-PREPARE("FOR EACH ":U + hBuffer:NAME).
  hQuery:QUERY-OPEN().

  /* Get the last record in the query */
  hQuery:GET-LAST.
  /* Check if the last record's ROWID is the in the list of ROWIDs */
  IF CAN-DO(pcRowids,STRING(hBuffer:ROWID)) THEN 
    ASSIGN
      cLastRow = STRING(hBuffer:ROWID)
      cReturn = "LAST":U.

  /* See if the first record is visible. 
     Note that it is possible that both may be visible and we need to 
     deal with this. */
  hQuery:GET-FIRST.
  IF CAN-DO(pcRowids,STRING(hBuffer:ROWID)) THEN
  DO:
    IF cReturn <> "LAST":U THEN
      cReturn = "FIRST":U.
    ELSE
    DO:
      /* We need to handle the situation where both are visible.
         Strictly speaking, the record that occurs later in the
         stribg of rowids is the last one that was viewed. */
      ASSIGN
        iFirst = R-INDEX(pcRowids,STRING(hBuffer:ROWID))
        iLast  = R-INDEX(pcRowids,cLastRow).
      /* cReturn is already last so all we do is check if we
         have to make it first. */
      IF iFirst > iLast THEN 
        cReturn = "FIRST":U.
    END.
  END.


  /* If we don't have a last, see if the first record is visible */
  IF cReturn <> "LAST":U THEN
  DO:
  END.

  /* Close the query and delete the objects */
  hQuery:QUERY-CLOSE().
  DELETE OBJECT hQuery.
  DELETE OBJECT hBuffer.
  
  /* Return the return value. */
  RETURN cReturn.  

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setActionEvent) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setActionEvent Procedure 
FUNCTION setActionEvent RETURNS LOGICAL
  ( pcEvent AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose: subscribe an event to Default-action in the browse. 
Parameter: pcEvent - event that will be published on default-action of the 
                     browse. The caller must also subscribe to the 
                     event.
   Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hBrowse        AS HANDLE   NO-UNDO.
  DEFINE VARIABLE lUseRepository AS LOGICAL  NO-UNDO.

  &SCOPED-DEFINE xp-assign
  {get BrowseHandle hBrowse}
  {get UseRepository lUseRepository}  
  .
  &UNDEFINE xp-assign
  
  &SCOPED-DEFINE xpActionEvent
  {set ActionEvent pcEvent}.
  &UNDEFINE xpActionEvent
  
  /* Repository objects always defines this trigger in initializeObject. 
    (This avoids core crash when this is called early from prepareInstance and 
     the browser has a static trigger on the same event) */
  IF NOT lUseRepository THEN 
    ON 'DEFAULT-ACTION':U OF hBrowse 
      PERSISTENT RUN defaultAction IN TARGET-PROCEDURE.
 
  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setApplyActionOnExit) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setApplyActionOnExit Procedure 
FUNCTION setApplyActionOnExit RETURNS LOGICAL
  ( plApply AS LOG) :
/*------------------------------------------------------------------------------
  Purpose: Set to TRUE if exit is to perform the same action as the 
           DEFAULT-ACTION.  
    Notes: Currently used by the SmartSelect.  
------------------------------------------------------------------------------*/
  {set ApplyActionOnExit plApply}.
  RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setApplyExitOnAction) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setApplyExitOnAction Procedure 
FUNCTION setApplyExitOnAction RETURNS LOGICAL
  ( plApply AS LOG) :
/*------------------------------------------------------------------------------
  Purpose: Set to TRUE if DEFAULT-ACTION is to exit the browse.
    Notes: Currently used by the SmartSelect.
------------------------------------------------------------------------------*/
  {set ApplyExitOnAction plApply}.
  RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setBGColor) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setBGColor Procedure 
FUNCTION setBGColor RETURNS LOGICAL
 ( piBGColor AS INTEGER ) :
/*------------------------------------------------------------------------------
  Purpose: Sets the background color of the browse
   Params: piBGColor AS INTEGER 
    Notes:  
------------------------------------------------------------------------------*/
 DEFINE VARIABLE hBrowse AS HANDLE NO-UNDO.
 
 {get Browsehandle hBrowse}.
 IF VALID-HANDLE(hBrowse) THEN
     hBrowse:BGCOLOR = piBGColor .  

  {set BGCOLOR piBGColor}.
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setBrowseColumnAutoCompletions) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setBrowseColumnAutoCompletions Procedure 
FUNCTION setBrowseColumnAutoCompletions RETURNS LOGICAL
  (  INPUT pcBrowseColumnAutoCompletions AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    {set BrowseColumnAutoCompletions pcBrowseColumnAutoCompletions}.
    
    RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setBrowseColumnBGColors) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setBrowseColumnBGColors Procedure 
FUNCTION setBrowseColumnBGColors RETURNS LOGICAL
  ( INPUT pcBrowseColumnBGColors AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    {set BrowseColumnBGColors pcBrowseColumnBGColors}.
    
    RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setBrowseColumnDelimiters) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setBrowseColumnDelimiters Procedure 
FUNCTION setBrowseColumnDelimiters RETURNS LOGICAL
  (  INPUT pcBrowseColumnDelimiters AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    {set BrowseColumnDelimiters pcBrowseColumnDelimiters}.
    
    RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setBrowseColumnFGColors) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setBrowseColumnFGColors Procedure 
FUNCTION setBrowseColumnFGColors RETURNS LOGICAL
  ( INPUT pcBrowseColumnFGColors AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    {set BrowseColumnFGColors pcBrowseColumnFGColors}.
    
    RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setBrowseColumnFonts) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setBrowseColumnFonts Procedure 
FUNCTION setBrowseColumnFonts RETURNS LOGICAL
  ( INPUT pcBrowseColumnFonts AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    {set BrowseColumnFonts pcBrowseColumnFonts}.
    
    RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setBrowseColumnInnerLines) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setBrowseColumnInnerLines Procedure 
FUNCTION setBrowseColumnInnerLines RETURNS LOGICAL
  (  INPUT pcBrowseColumnInnerLines AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    {set BrowseColumnInnerLines pcBrowseColumnInnerLines}.
    
    RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setBrowseColumnItemPairs) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setBrowseColumnItemPairs Procedure 
FUNCTION setBrowseColumnItemPairs RETURNS LOGICAL
  (  INPUT pcBrowseColumnItemPairs AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    {set BrowseColumnItemPairs pcBrowseColumnItemPairs}.
    
    RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setBrowseColumnItems) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setBrowseColumnItems Procedure 
FUNCTION setBrowseColumnItems RETURNS LOGICAL
  (  INPUT pcBrowseColumnItems AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    {set BrowseColumnItems pcBrowseColumnItems}.
    
    RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setBrowseColumnLabelBGColors) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setBrowseColumnLabelBGColors Procedure 
FUNCTION setBrowseColumnLabelBGColors RETURNS LOGICAL
  ( INPUT pcBrowseColumnLabelBGColors AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    {set BrowseColumnLabelBGColors pcBrowseColumnLabelBGColors}.
    
    RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setBrowseColumnLabelFGColors) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setBrowseColumnLabelFGColors Procedure 
FUNCTION setBrowseColumnLabelFGColors RETURNS LOGICAL
  ( INPUT pcBrowseColumnLabelFGColors AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    {set BrowseColumnLabelFGColors pcBrowseColumnLabelFGColors}.
    
    RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setBrowseColumnLabelFonts) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setBrowseColumnLabelFonts Procedure 
FUNCTION setBrowseColumnLabelFonts RETURNS LOGICAL
  (  INPUT pcBrowseColumnLabelFonts AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    {set BrowseColumnLabelFonts pcBrowseColumnLabelFonts}.
    
    RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setBrowseColumnLabels) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setBrowseColumnLabels Procedure 
FUNCTION setBrowseColumnLabels RETURNS LOGICAL
  ( INPUT pcBrowseColumnLabels AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    {set BrowseColumnLabels pcBrowseColumnLabels}.
    
    RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setBrowseColumnMaxChars) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setBrowseColumnMaxChars Procedure 
FUNCTION setBrowseColumnMaxChars RETURNS LOGICAL
  (  INPUT pcBrowseColumnMaxChars AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    {set BrowseColumnMaxChars pcBrowseColumnMaxChars}.
    
    RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setBrowseColumnSorts) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setBrowseColumnSorts Procedure 
FUNCTION setBrowseColumnSorts RETURNS LOGICAL
  (  INPUT pcBrowseColumnSorts AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    {set BrowseColumnSorts pcBrowseColumnSorts}.
    
    RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setBrowseColumnTypes) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setBrowseColumnTypes Procedure 
FUNCTION setBrowseColumnTypes RETURNS LOGICAL
  (  INPUT pcBrowseColumnTypes AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    {set BrowseColumnTypes pcBrowseColumnTypes}.

    RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setBrowseColumnUniqueMatches) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setBrowseColumnUniqueMatches Procedure 
FUNCTION setBrowseColumnUniqueMatches RETURNS LOGICAL
  (  INPUT pcBrowseColumnUniqueMatches AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    {set BrowseColumnUniqueMatches pcBrowseColumnUniqueMatches}.
    
    RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setBrowseColumnWidths) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setBrowseColumnWidths Procedure 
FUNCTION setBrowseColumnWidths RETURNS LOGICAL
  ( INPUT pcBrowseColumnWidths AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    {set BrowseColumnWidths pcBrowseColumnWidths}.
    
    RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setCalcWidth) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setCalcWidth Procedure 
FUNCTION setCalcWidth RETURNS LOGICAL
  ( plCalcWidth AS LOGICAL ) :
/*------------------------------------------------------------------------------
  Purpose: Sets logical value that determines whether the width of the browse
           is calculated to the exact width it should be for the fields it contains
   Params: plCalcWidth AS LOGICAL   
    Notes:  
------------------------------------------------------------------------------*/
    
  {set CalcWidth plCalcWidth}.
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setColumnsMovable) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setColumnsMovable Procedure 
FUNCTION setColumnsMovable RETURNS LOGICAL
  ( INPUT plMovable AS LOGICAL ) :
/*------------------------------------------------------------------------------
  Purpose:  Sets a logical value that determines whether the browser's 
            columns are movable and if the browse object has been initialized
            and its handle is valid, COLUMN-MOVABLE is set.
    Notes:  
------------------------------------------------------------------------------*/
DEFINE VARIABLE hBrowse      AS HANDLE     NO-UNDO.
DEFINE VARIABLE lInitialized AS LOGICAL    NO-UNDO.

  &SCOPED-DEFINE xpColumnsMovable
  {set ColumnsMovable plMovable}.
  &UNDEFINE xpColumnsMovable

  &SCOPED-DEFINE xp-assign
  {get BrowseHandle hBrowse}
  {get ObjectInitialized lInitialized}.
  &UNDEFINE xp-assign

  IF lInitialized AND VALID-HANDLE(hBrowse) THEN
  DO:
    IF plMovable THEN hBrowse:ALLOW-COLUMN-SEARCHING = FALSE.
    hBrowse:COLUMN-MOVABLE = plMovable.
  END.  /* if initialized and browse valid */

  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setColumnsSortable) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setColumnsSortable Procedure 
FUNCTION setColumnsSortable RETURNS LOGICAL
  ( INPUT plSortable AS LOGICAL ) :
/*------------------------------------------------------------------------------
  Purpose:  Sets a logical value that determines whether the browser's 
            columns are sortable and if the browse object has been initialized
            and its handle is valid, ALLOW-COLUMN-SEARCHING is set to turn 
            the START-SEARCH trigger on or off which is used to sort the columns.
    Notes:  
------------------------------------------------------------------------------*/
DEFINE VARIABLE hBrowse      AS HANDLE     NO-UNDO.
DEFINE VARIABLE lInitialized AS LOGICAL    NO-UNDO.

  &SCOPED-DEFINE xpColumnsSortable
  {set ColumnsSortable plSortable}.
  &UNDEFINE xpColumnsSortable

  &SCOPED-DEFINE xp-assign
  {get BrowseHandle hBrowse}
  {get ObjectInitialized lInitialized}.
  &UNDEFINE xp-assign

  IF lInitialized AND VALID-HANDLE(hBrowse) THEN
  DO:
    IF plSortable THEN hBrowse:COLUMN-MOVABLE = FALSE.
    hBrowse:ALLOW-COLUMN-SEARCHING = plSortable.
  END.  /* if initialized and browse valid */

  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setDataModified) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setDataModified Procedure 
FUNCTION setDataModified RETURNS LOGICAL
  ( lModified AS LOGICAL ) :
/*------------------------------------------------------------------------------
  Purpose:  SmartDataBrowser version of setDataModified.
   Params:  lModified AS LOGICAL -- TRUE or FALSE 
    Notes:  The purpose of this version is to enable/disable the search 
            field (if defined) to disable the search capability while there 
            are updates in progress in the SmartDataBrowser.
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hSearchField  AS HANDLE NO-UNDO.
  {get SearchHandle hSearchField}.

  ASSIGN hSearchField:SENSITIVE = NOT lModified 
        WHEN VALID-HANDLE(hsearchField) AND lModified NE ?
        .
  RETURN SUPER( INPUT lModified).   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setDefaultColumnData) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setDefaultColumnData Procedure 
FUNCTION setDefaultColumnData RETURNS LOGICAL
  ( INPUT pcData AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Sets a property of default column data
    Notes:  
------------------------------------------------------------------------------*/
  {set DefaultColumnData pcData}.
  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setFetchOnReposToEnd) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setFetchOnReposToEnd Procedure 
FUNCTION setFetchOnReposToEnd RETURNS LOGICAL
  ( plFetchOnRepos AS LOG ) :
/*------------------------------------------------------------------------------
  Purpose: Set to true to specify that the browse should fetch more data 
           from the server to fill the batch when repopsitioing to the end of 
           a batch
    Notes: This gives the correct visual appearance, but will require an 
           additional request to the server.
------------------------------------------------------------------------------*/
  {set FetchOnReposToend plFetchOnRepos}.

  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setFGColor) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setFGColor Procedure 
FUNCTION setFGColor RETURNS LOGICAL
   ( piFGColor AS INTEGER ) :
/*------------------------------------------------------------------------------
  Purpose: Sets the foreground color of the browse
   Params: piFGColor AS INTEGER 
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hBrowse AS HANDLE     NO-UNDO.

  {get Browsehandle hBrowse}.
  IF VALID-HANDLE(hBrowse) THEN
     hBrowse:FGCOLOR = piFGColor .   

  {set FGCOLOR piFGColor}.
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setFolderWindowToLaunch) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setFolderWindowToLaunch Procedure 
FUNCTION setFolderWindowToLaunch RETURNS LOGICAL
  ( pcTemp AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  {set FolderWindowToLaunch pcTemp}.
  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setFont) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setFont Procedure 
FUNCTION setFont RETURNS LOGICAL
( piFont AS INTEGER ) :
/*------------------------------------------------------------------------------
  Purpose: Sets the font of the browse 
   Params: piFont AS INTEGER 
    Notes:  
------------------------------------------------------------------------------*/
 DEFINE VARIABLE hBrowse AS HANDLE     NO-UNDO.

 {get BrowseHandle hBrowse}.
 IF VALID-HANDLE(hBrowse) THEN
   hBrowse:FONT = piFont.

 RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setMaxWidth) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setMaxWidth Procedure 
FUNCTION setMaxWidth RETURNS LOGICAL
  ( pdMaxWidth AS DECIMAL ) :
/*------------------------------------------------------------------------------
  Purpose: Ssets maximum value used for setting the width of the browse when
           CalcWidth is TRUE.   
   Params: pdMaxWidth AS DECIMAL
    Notes:  
------------------------------------------------------------------------------*/
    
  {set MaxWidth pdMaxWidth}.
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setMovableHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setMovableHandle Procedure 
FUNCTION setMovableHandle RETURNS LOGICAL
  ( INPUT phMovable AS HANDLE ) :
/*------------------------------------------------------------------------------
  Purpose:  Sets a the handle of the movable popup menu item's handle.
    Notes:  
------------------------------------------------------------------------------*/
  {set MovableHandle phMovable}.
  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setNumDown) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setNumDown Procedure 
FUNCTION setNumDown RETURNS LOGICAL
  ( piNumDown AS INTEGER ) :
/*------------------------------------------------------------------------------
  Purpose: Sets the number of rows that are displayed DOWN in the browse
   Params: piNumDown AS INTEGER 
    Notes:  
------------------------------------------------------------------------------*/
    
  {set NumDown piNumDown}.
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setPopupActive) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setPopupActive Procedure 
FUNCTION setPopupActive RETURNS LOGICAL
  ( INPUT plActive AS LOGICAL ) :
/*------------------------------------------------------------------------------
  Purpose:  Sets a logical value that determines whether the browse popup 
            menu is active.
    Notes:  
------------------------------------------------------------------------------*/
  {set PopupActive plActive}.
  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setQueryRowObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setQueryRowObject Procedure 
FUNCTION setQueryRowObject RETURNS LOGICAL
  ( INPUT phQueryRowObject AS HANDLE ) :
/*------------------------------------------------------------------------------
  Purpose:  Sets the current value of the handle to the buffer of the RowObject
            Temp-Table in the query.
    Notes:  
------------------------------------------------------------------------------*/
  {set QueryRowObject phQueryRowObject}.
  RETURN FALSE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setSavedColumnData) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setSavedColumnData Procedure 
FUNCTION setSavedColumnData RETURNS LOGICAL
  ( INPUT pcData AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Sets a property of saved column data
    Notes:  Contains a list of column names and their widths
------------------------------------------------------------------------------*/
  {set SavedColumnData pcData}.
  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setScrollRemote) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setScrollRemote Procedure 
FUNCTION setScrollRemote RETURNS LOGICAL
  ( INPUT plScrollRemote AS LOGICAL ) :
/*------------------------------------------------------------------------------
  Purpose:  Sets the value of the ScrollRemote attribute
    Notes:  
------------------------------------------------------------------------------*/
  {set ScrollRemote plScrollRemote}.

  RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setSearchField) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setSearchField Procedure 
FUNCTION setSearchField RETURNS LOGICAL
  ( pcField AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Sets and create the field which can be searched on for repositioning
            the query the browse is attached to.
   Params:  pcField AS CHARACTER -- SmartDataObject Field Name
   Notes:   The field name passed as parameter is the actual field name in 
            the SmartDataObject not the one referenced in the Data Dictionnary.
            
            This function was modified in 10.1C to support the change of the
            search field in runtime.
            Previous to 10.1C we only set the new field name, therefore
            the field label, format and type were not mofidifed causing runtime
            errors or unexpected behaviors. Starting in 10.1C the search field
            is rebuilt in order to get all its new attributes.
------------------------------------------------------------------------------*/
DEFINE VARIABLE hSearchHandle   AS HANDLE    NO-UNDO.
DEFINE VARIABLE cOldSearchField AS CHARACTER NO-UNDO.

  {get SearchField cOldSearchField}.

  IF cOldSearchField = pcField THEN
      RETURN TRUE.

  {set SearchField pcField}.
  {get SearchHandle hSearchHandle}.

  /*If the field was already created, is because this function is called
    from the outside of the initialize process.
    We have to destroy the old search field and label, and then create the new one.*/
  IF VALID-HANDLE(hSearchHandle) THEN
        RUN rebuildSearchField IN TARGET-PROCEDURE.

  RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setSeparatorFGColor) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setSeparatorFGColor Procedure 
FUNCTION setSeparatorFGColor RETURNS LOGICAL
    ( piSeparatorFGColor AS INTEGER ) :
 /*------------------------------------------------------------------------------
   Purpose: Sets the separator color of the browse
    Params: piSeparatorFGColor AS INTEGER 
     Notes:  
 ------------------------------------------------------------------------------*/
   DEFINE VARIABLE hBrowse AS HANDLE     NO-UNDO.

   {get Browsehandle hBrowse}.
   IF VALID-HANDLE(hBrowse) THEN
      hBrowse:SEPARATOR-FGCOLOR = piSeparatorFGColor NO-ERROR.   

   {set SeparatorFGColor piSeparatorFGColor}.
   RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setSeparators) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setSeparators Procedure 
FUNCTION setSeparators RETURNS LOGICAL
  ( plSeparators AS LOGICAL ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hBrowse AS HANDLE   NO-UNDO.

  {get Browsehandle hBrowse}.
  IF VALID-HANDLE(hBrowse) THEN
     hBrowse:SEPARATORS = plSeparators.
  
  {set SEPARATORS plSeparators}.
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setSort) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setSort Procedure 
FUNCTION setSort RETURNS LOGICAL
  ( pcColumnName  AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:    Set sortcolumn and sort the data source accordingly       
  Parameters: pcColumnName -  Name of browse column.
  Notes:      
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hSource                       AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cSort                         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSourceNames                  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lSort                         AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cSourceName                   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lUseSortIndicator             AS LOGICAL    NO-UNDO.

  &SCOPED-DEFINE xp-assign
  {get DataObjectHandle hSource}  /* get the SDO also when source is SBO */
  {get UseSortIndicator lUseSortIndicator}
  .
  &UNDEFINE xp-assign 

  IF VALID-HANDLE(hSource) THEN
  DO:
    RUN changeCursor IN TARGET-PROCEDURE ('WAIT':U).
    
    /* Qualify with RowObject name and specify to toggle current sort */
    IF NUM-ENTRIES(pcColumnName,'.') = 1 THEN
      pcColumnName = 'RowObject.':U + pcColumnName.

    /* The datasource supports 'toggle' sort option */           
    pcColumnName = pcColumnName + ' TOGGLE':U. 
 
    lSort = {fnarg resortQuery pcColumnName hSource}.
    
    IF lUseSortIndicator THEN
      {fn showSort}.

    RUN changeCursor IN TARGET-PROCEDURE ('':U).
  END. /* valid-handle(hSource)*/

  RETURN lSort. 
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setSortableHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setSortableHandle Procedure 
FUNCTION setSortableHandle RETURNS LOGICAL
  ( INPUT phSortable AS HANDLE ) :
/*------------------------------------------------------------------------------
  Purpose:  Sets a the handle of the sortable popup menu item's handle.
    Notes:  
------------------------------------------------------------------------------*/
  {set SortableHandle phSortable}.
  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setTooltip) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setTooltip Procedure 
FUNCTION setTooltip RETURNS LOGICAL
  ( pcTooltip AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Sets the tooltip for the browse
   Params:  pcTooltip AS CHARACTER 
   Notes:   
------------------------------------------------------------------------------*/

  {set TOOLTIP pcTooltip}.
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setUseSortIndicator) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setUseSortIndicator Procedure 
FUNCTION setUseSortIndicator RETURNS LOGICAL
  ( plUseSortIndicator AS LOGICAL ) :
/*------------------------------------------------------------------------------
  Purpose: Decides whether the browser should use a graphical arrow in the 
           column label to show sort column and sort direction. 
 Paramter: plUseSortIndicator - YES - show sort, NO - don't           
    Notes:  
------------------------------------------------------------------------------*/
  {set UseSortIndicator plUseSortIndicator}.

  RETURN TRUE. 

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setVisibleRowids) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setVisibleRowids Procedure 
FUNCTION setVisibleRowids RETURNS LOGICAL
  ( INPUT pcRowids AS CHARACTER) :
/*------------------------------------------------------------------------------
  Purpose:  sets the VisibleRowids property
    Notes:  This property is used for the scrolling of the browse to trap the 
            scroll notify event properly.
------------------------------------------------------------------------------*/
  {set VisibleRowids pcRowids}.
  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setVisibleRowReset) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setVisibleRowReset Procedure 
FUNCTION setVisibleRowReset RETURNS LOGICAL
  ( INPUT plReset AS LOGICAL ) :
/*------------------------------------------------------------------------------
  Purpose:  sets the value of the VisibleRowReset property
    
------------------------------------------------------------------------------*/
  {set VisibleRowReset plReset}.

  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-showSort) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION showSort Procedure 
FUNCTION showSort RETURNS LOGICAL
  ( ) :
/*------------------------------------------------------------------------------
  Purpose:  Show sort arrow reflecting current sort in datasource     
  Parameters:  <none>
  Notes:    The ABL allows showing multiple sort columns with a sort number, 
            but this function currently only shows the first column in the sort 
            expression, since there is no default support to manipulate the 
            secondary sort. 
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hDataSource    AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cSort          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cColumn        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSortColumn    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lDesc          AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE iColumn        AS INTEGER    NO-UNDO.
  DEFINE VARIABLE hColumn        AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hBrowse        AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cHandles       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cNames         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lUseSortIndicator AS LOGICAL    NO-UNDO.
  
  &SCOPED-DEFINE xp-assign
  {get BrowseHandle hBrowse}
  {get FieldHandles cHandles}
  {get DisplayedFields cNames}
  {get UseSortIndicator lUseSortIndicator}
  {get DataObjectHandle hDataSource}  /* get the SDO also when source is SBO */
  .
  &UNDEFINE xp-assign
                   
  IF NOT lUseSortIndicator THEN
    RETURN FALSE. 

  hBrowse:CLEAR-SORT-ARROWS().
  IF VALID-HANDLE(hDataSource) THEN
  DO:
    ASSIGN 
      cSort               = {fn getQuerySort hDataSource}
      cSortColumn         = ENTRY(1,cSort,'':U)
      ENTRY(1,cSort,'':U) = '':U 
      lDesc               = LEFT-TRIM(cSort + ' ':U) BEGINS 'DESCENDING ':U.

    IF NOT {fnarg instanceOf 'DataView':U hDataSource} THEN 
      cSortColumn = {fnarg dbColumnDataName cSortColumn hDataSource}.

    IF cSortColumn > '' THEN
    DO:
      DO iColumn = 1 TO hBrowse:NUM-COLUMNS:
        ASSIGN
          cColumn = ''
          hColumn = hBrowse:GET-BROWSE-COLUMN(iColumn) 
          cColumn = ENTRY(LOOKUP(STRING(hColumn),cHandles),cNames)
          NO-ERROR. /* in case we encounter a calculated field */
        IF cColumn = cSortColumn THEN
        DO:
          hColumn:SORT-ASCENDING = NOT lDesc.
          RETURN TRUE.
        END. /* column = sortcolumn */
      END. /* column loop */
    END. /* SortColumn > '' */
  END. /*valid datasource */
  
  RETURN FALSE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-stripCalcs) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION stripCalcs Procedure 
FUNCTION stripCalcs RETURNS CHARACTER
  ( INPUT cClause AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Strips the expression portion of expression @ variable 
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cPart       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cNewClause  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cNewClause2 AS CHARACTER  NO-UNDO.  
  DEFINE VARIABLE iCount      AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iPos        AS INTEGER    NO-UNDO.


  /* If there are no "@" in the clause, don't change it. */
  IF NUM-ENTRIES(cClause,"@":U) <= 1 THEN
    RETURN cClause.

  /* Iterate through the clause using "@" as a delimiter */
  DO iCount = 1 TO NUM-ENTRIES(cClause,"@":U):
    cPart = ENTRY(iCount,cClause,"@":U).
    /* Find the position of the first "(" in the clause */
    iPos = INDEX(cPart,"(":U).

    /* If there is an "(", replace the rest of the string with a <calc>" */
    IF iPos > 0 THEN
      cPart = SUBSTRING(cPart, 1, iPos - 1) + "<calc>":U.

    /* Add this part to the clause */
    cNewClause = cNewClause + cPart.
  END.

  /* The variable name is still left behinf on the right of the <calc> 
     constant. */

  /* Iterate through the entries delimited by " " */
  DO iCount = 1 TO NUM-ENTRIES(cNewClause," ":U):
    
    /* Add the entry to the clause */
    cNewClause2 = cNewClause2 + ENTRY(iCount,cNewClause," ":U) + " ":U.
    
    /* If this entry is a <calc> constant */
    IF ENTRY(iCount,cNewClause," ":U) = "<calc>":U THEN
      iCount = iCount + 1.   /* skip the next entry which is the variable */

  END.
      

  RETURN TRIM(cNewClause2).   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

