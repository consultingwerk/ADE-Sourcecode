&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12
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
/*--------------------------------------------------------------------------
    File        : browser.p
    Purpose     : Super procedure for PDO SmartBrowser objects

    Syntax      : adm2/browser.p

    Modified    : August 8, 2000 -- Version 9.1B
    Modified    : 09/29/2001        Mark Davies (MIP)
                  Added security to Excel and Crysal Exports.
    Modified    : 10/19/2001        Mark Davies (MIP)
                  Security for hiding secured fields works for a browse on an
                  object controller with a standard layout, but does not
                  work when you design it with a browser, viewer and toolbars
                  on one container. To rectify this I took out the container
                  name being passed to the field security check API.
    Modified    : 11/13/2001        Mark Davies (MIP)
                  Check for valid-handle for all gsh... variables
    Modified    : 02/27/2002        Mark Davies (MIP)
                  Fix for issue #4086 - Changes made to cater for SBO caused
                  an error.
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

  /* This is needed by some procedures so that another procedure we call
     can identify what the original TARGET-PROCEDURE is. The value is 
     returned by getTargetProcedure. */
  DEFINE VARIABLE ghTargetProcedure AS HANDLE NO-UNDO.

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

&IF DEFINED(EXCLUDE-colValues) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD colValues Procedure 
FUNCTION colValues RETURNS CHARACTER
  ( pcViewColList AS CHARACTER )  FORWARD.

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

&IF DEFINED(EXCLUDE-getFolderWindowToLaunch) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getFolderWindowToLaunch Procedure 
FUNCTION getFolderWindowToLaunch RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

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

&IF DEFINED(EXCLUDE-getPrintPreviewActive) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getPrintPreviewActive Procedure 
FUNCTION getPrintPreviewActive RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

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

&IF DEFINED(EXCLUDE-getToolbarSource) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getToolbarSource Procedure 
FUNCTION getToolbarSource RETURNS CHARACTER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getToolbarSourceEvents) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getToolbarSourceEvents Procedure 
FUNCTION getToolbarSourceEvents RETURNS CHARACTER
  (   )  FORWARD.

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

&IF DEFINED(EXCLUDE-hasActiveAudit) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD hasActiveAudit Procedure 
FUNCTION hasActiveAudit RETURNS LOGICAL
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-hasActiveComments) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD hasActiveComments Procedure 
FUNCTION hasActiveComments RETURNS LOGICAL
  (  )  FORWARD.

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

&IF DEFINED(EXCLUDE-setFolderWindowToLaunch) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setFolderWindowToLaunch Procedure 
FUNCTION setFolderWindowToLaunch RETURNS LOGICAL
  ( pcTemp AS CHARACTER )  FORWARD.

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

&IF DEFINED(EXCLUDE-setPrintPreviewActive) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setPrintPreviewActive Procedure 
FUNCTION setPrintPreviewActive RETURNS LOGICAL
  ( lPreviewActive AS LOGICAL )  FORWARD.

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

&IF DEFINED(EXCLUDE-setToolbarSource) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setToolbarSource Procedure 
FUNCTION setToolbarSource RETURNS LOGICAL
  ( pcTarget AS CHARACTER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setToolbarSourceEvents) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setToolbarSourceEvents Procedure 
FUNCTION setToolbarSourceEvents RETURNS LOGICAL
  ( pcEvents AS CHARACTER  )  FORWARD.

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
   Compile into: adm2
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
         HEIGHT             = 24.86
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
      {get BrowseHandle hBrowse}.
      {get TableIOSource hSource}.
      {get SearchHandle hSearchField}.
      /* If the Browse was not enabled (perhaps because it was empty),
         enable it. */
     
      IF hBrowse:READ-ONLY THEN
      DO:
        {get ContainerHandle hFrame}.
        APPLY "ENTRY":U TO hFrame.
        hBrowse:READ-ONLY = no.
      END.
      ASSIGN
        hSearchField:SENSITIVE = NO WHEN VALID-HANDLE(hSearchField).
      hQuery = hBrowse:QUERY.
      IF NOT hQuery:IS-OPEN THEN
        hQuery:QUERY-OPEN.
      
      hBrowse:INSERT-ROW("AFTER":U).
      {set BrowseInitted no}.    /* Signal for ROW-ENTRY trigger code */

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
  Notes:     Called from initializeObject and fetchDataSet('BatchEnd') to ensure
             that there are no blank rows in the browser.   
------------------------------------------------------------------------------*/
DEFINE VARIABLE iRepoRow         AS INTEGER    NO-UNDO.
DEFINE VARIABLE iRowNum          AS INTEGER    NO-UNDO.
DEFINE VARIABLE hDataSource      AS HANDLE     NO-UNDO.
DEFINE VARIABLE hDataQuery       AS HANDLE     NO-UNDO.
DEFINE VARIABLE hBrowse          AS HANDLE     NO-UNDO.
DEFINE VARIABLE hRowObject       AS HANDLE     NO-UNDO.
DEFINE VARIABLE rRowid           AS ROWID      NO-UNDO.
DEFINE VARIABLE iLastRowNum      AS INTEGER    NO-UNDO.
DEFINE VARIABLE iNumEntries      AS INTEGER    NO-UNDO.
DEFINE VARIABLE lFetchOnRepos    AS LOGICAL    NO-UNDO.
DEFINE VARIABLE lRebuild         AS LOGICAL    NO-UNDO.
DEFINE VARIABLE cObjectType      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cDataSource      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE iLoop            AS INTEGER    NO-UNDO.
  {get BrowseHandle hBrowse}.     /* Handle of the browse widget. */
  {get DataSource hDataSource}.   /* Proc. handle of our SDO/SBO. */
  
  IF VALID-HANDLE(hDataSource) THEN
  DO:
    {get ObjectType cObjectType hDataSource}.
  END.

  IF cObjectType = 'SmartBusinessObject':U THEN /* we really want the SDO */
  DO:
    {get DataSourceNames cDataSource}.
    hDataSource = {fnarg dataObjectHandle cDataSource hDataSource}.
  END.

  IF VALID-HANDLE(hBrowse) AND VALID-HANDLE(hDataSource) THEN
  DO:
    ghTargetProcedure = TARGET-PROCEDURE.
    {get DataHandle hDataQuery hDataSource}.
    ghTargetProcedure = ?. 
    iNumEntries = hBrowse:NUM-ENTRIES.
    IF iNumEntries > 0 AND iNumEntries LT hBrowse:DOWN  
    AND VALID-HANDLE(hDataQuery) AND {fn getNewRecord} = 'NO':U THEN
    DO:
      {get LastRowNum iLastRowNum hDataSource}. 
      {get RowObject hRowObject hDataSource}.
      rRowid = hRowObject:ROWID.
      IF rRowid <> ? THEN
      DO:
        IF iLastRowNum <> ? THEN
        DO:
          DO iLoop = 1 TO iNumEntries:
            IF hBrowse:IS-ROW-SELECTED(iLoop) THEN
               LEAVE.
          END.
          hBrowse:SET-REPOSITIONED-ROW(hBrowse:DOWN - (max(0,INumEntries - iLoop)),"ALWAYS":U).
          hDataQuery:REPOSITION-TO-ROWID(rRowid).
        END.
        ELSE DO:
          /* Check if we are supposed to fetch data to fill the browse */
          {get FetchOnReposToEnd lFetchOnRepos}.
          IF lFetchOnRepos THEN
          DO:
            PUBLISH 'fetchBatch':U FROM TARGET-PROCEDURE(YES).
            hBrowse:SET-REPOSITIONED-ROW(iNumEntries,"always":U).
            hDataQuery:REPOSITION-TO-ROWID(rRowid).        
            RUN "DataAvailable":U IN hDataSource('value-changed':U).
          END.
        END.
      END.
    END.                     
    
    {get RebuildOnRepos lRebuild hDataSource}.

    /* This is not very well though out and the down logic doesn't really work 
      for long, but we need to get rid of the 'always' setting used above, and 
      it is here in an attempt to keep the same setting after 
      fetchRowident -> fetchDataSet ('Batchend') and also at initialization.  
      The down / 2 is here just to try to keep old behavior, but we set it to 
      1 for SDOs with rebuild as the half way down setting makes no sense and 
      causes the above logic to have problems getting the last recod at bottom
       
      The point is: don't hesitate to get rid of this, for example when improving
      browse repositioning...  */ 

    hBrowse:SET-REPOSITIONED-ROW(
       IF lRebuild THEN 1 ELSE INT(hBrowse:DOWN / 2),"CONDITIONAL":U).  
  
  END.

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
 
  {get FieldsEnabled lFieldsEnabled}.
  {get EnabledFields cEnabledFields}.
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

&IF DEFINED(EXCLUDE-calcWidth) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE calcWidth Procedure 
PROCEDURE calcWidth :
/*------------------------------------------------------------------------------
  Purpose:     Calculates the exact width of the browse based on the columns in 
               the browse.
  Parameters:  <none>
  Notes:       Called from initializeObject for dynamic SmartDataBrowsers
------------------------------------------------------------------------------*/
DEFINE VARIABLE cColLabel     AS CHARACTER NO-UNDO.
DEFINE VARIABLE dMaxWidth     AS DECIMAL   NO-UNDO.
DEFINE VARIABLE dWidth        AS DECIMAL   NO-UNDO.
DEFINE VARIABLE hColumn       AS HANDLE    NO-UNDO.
DEFINE VARIABLE hDataSource   AS HANDLE    NO-UNDO.
DEFINE VARIABLE hBrowse       AS HANDLE    NO-UNDO.
DEFINE VARIABLE iNumDown      AS INTEGER   NO-UNDO.
DEFINE VARIABLE lCalcWidth    AS LOGICAL   NO-UNDO.
DEFINE VARIABLE dHeight       AS DECIMAL    NO-UNDO.

  {get BrowseHandle hBrowse}.
  
  /* We need to make the browse visible in order to get the width for its columns */
  hBrowse:HIDDEN = FALSE.
  hColumn = hBrowse:FIRST-COLUMN.
  IF hBrowse:ROW-MARKERS THEN dWidth = 2.
  DO WHILE VALID-HANDLE(hColumn):
    dWidth     = dWidth + hColumn:WIDTH + 1.
    hColumn = hColumn:NEXT-COLUMN.
  END.  /* Do While */

  /* We must use the minimum of the calculated width or the Max Width property
     value */
  {get MaxWidth dMaxWidth}.
  dWidth = MIN(dWidth, dMaxWidth).
  {get Height dHeight}.
  RUN resizeObject IN TARGET-PROCEDURE (dHeight, dWidth + 3.5).
  ASSIGN hBrowse:WIDTH = dWidth NO-ERROR.
  RUN resizeObject IN TARGET-PROCEDURE (dHeight, dWidth + 3.5).
                                                                                
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
  DEFINE VARIABLE hDataSource       AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cForeignFields    AS CHARACTER  NO-UNDO.    
  DEFINE VARIABLE lSelfQuery        AS LOGICAL    NO-UNDO.  
  
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
  DEFINE VARIABLE lSelfQuery    AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE cResult       AS CHARACTER NO-UNDO.
  DEFINE VARIABLE hUpdateTarget AS HANDLE    NO-UNDO.
  
  {get NewRecord cNew}.

  RUN SUPER.
  IF RETURN-VALUE = "ADM-ERROR":U THEN RETURN "ADM-ERROR":U.    
  {get QueryObject lSelfQuery}.
  
  IF lSelfQuery THEN
  DO:
    /* if new get rid of the inserted row 
       Not needed if we have a datasource as the SDO publishes cancelNew */
    IF cNew NE 'No':U THEN  /* Could be Add or Copy or No */
      RUN cancelNew IN TARGET-PROCEDURE.
    ELSE 
      RUN displayFields IN TARGET-PROCEDURE (?).                
  END.

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
   DEFINE VARIABLE lQueryObject AS LOGICAL NO-UNDO.

     /* Set the RowIdent before copyRow gets invoked because it needs to 
        copy the initial values out of the current record.  */ 
     {get QueryObject lQueryObject}.
     IF NOT lQueryObject THEN
     DO:
       {get BrowseHandle hBrowse}.
       hDataQuery = hBrowse:QUERY.
       hRowObject = hDataQuery:GET-BUFFER-HANDLE(1).
       {set RowIdent STRING(hRowObject:ROWID)}.
     END.
 
     RUN SUPER.
     IF RETURN-VALUE = "ADM-ERROR":U THEN RETURN "ADM-ERROR":U.
     
     /* Open up a slot for the new row. */
     {get BrowseHandle hBrowse}.
     {get SearchHandle hSearchField}.
      ASSIGN
        hSearchField:SENSITIVE = NO WHEN VALID-HANDLE(hSearchField).
     hBrowse:INSERT-ROW("AFTER":U).
     {set BrowseInitted no}.    /* Signal for ROW-ENTRY trigger code */
      
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
        PARENT = phPopupMenu
        LABEL  = pcLabel
        NAME   = pcName.
  ELSE DO:
    IF plToggle THEN
      CREATE MENU-ITEM phMenuItem
        ASSIGN
          PARENT     = phPopupMenu
          LABEL      = pcLabel
          NAME       = pcName
          TOGGLE-BOX = plToggle
          CHECKED    = plChecked.
    ELSE
      CREATE MENU-ITEM phMenuItem
        ASSIGN
          PARENT = phPopupMenu
          LABEL  = pcLabel
          NAME   = pcName.
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

  {get BrowseHandle hBrowse}.
  {get ColumnsMovable lMovable}.
  {get ColumnsSortable lSortable}.
  {get UseRepository lUseRepos}.
  
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
  {set MovableHandle hColsMovable}.

  RUN createPopupItem IN TARGET-PROCEDURE
      (INPUT hPopupMenu,
       INPUT FALSE,
       INPUT '&Sort Columns',
       INPUT 'miColsSortable':U,
       INPUT lSortable,
       INPUT TRUE,
       OUTPUT hColsSortable).
  {set SortableHandle hColsSortable}.

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
      PARENT  = hResetSubMenu
      SUBTYPE = 'RULE':U.

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
        PARENT  = hPopupMenu
        SUBTYPE = 'RULE':U.

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
      PARENT  = hPopupMenu
      SUBTYPE = 'RULE':U.

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
------------------------------------------------------------------------------*/
DEFINE VARIABLE cSearchField AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cSearchLabel AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cSortField   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE hBrowse      AS HANDLE     NO-UNDO.
DEFINE VARIABLE hDataSource  AS HANDLE     NO-UNDO.
DEFINE VARIABLE hFrame       AS HANDLE     NO-UNDO.
DEFINE VARIABLE hSearchField AS HANDLE     NO-UNDO.
DEFINE VARIABLE hSearchLabel AS HANDLE     NO-UNDO.
DEFINE VARIABLE lHideOnInit  AS LOGICAL    NO-UNDO.
DEFINE VARIABLE lOpenOnInit  AS LOGICAL    NO-UNDO.

  {get DataSource hDataSource}.   /* Proc. handle of our SDO. */
  {get BrowseHandle hBrowse}.     /* Handle of the browse widget. */

  /* If there is a SearchField, then allocate the first line of the frame
     to it and define the label and fill-in for it. */   
  {get SearchField cSearchField}.
  IF cSearchField NE "":U AND cSearchField NE ? THEN
  DO:
    {get ContainerHandle hFrame}.    /* Frame handle to put the widgets in. */
    /* NOTE: This resorts the query by the SearchField. */
    cSortField = {fnarg columnDbColumn cSearchField hDataSource}.
    /* Currently we only support dbfields as search/sort field */  
    IF cSortField <> "":U THEN
    DO:
      ASSIGN hBrowse:HEIGHT = hBrowse:HEIGHT - 1  /* Shorten the browse */
             hBrowse:ROW = 2                     /* and place at row 2 */ 
             cSearchLabel = {fnarg columnLabel cSearchfield hDataSource}
                             + ": ":U.          
      CREATE TEXT hSearchLabel IN WIDGET-POOL STRING(TARGET-PROCEDURE)           /* Label for the field */ 
        ASSIGN 
          SCREEN-VALUE = cSearchLabel
          FORMAT = "X(":U + STRING(LENGTH(cSearchLabel)) + ")":U
          ROW     = 1
          WIDTH   = FONT-TABLE:GET-TEXT-WIDTH(cSearchLabel)
          HEIGHT  = 1
          COL     = 2
          FRAME   = hFrame
          SCREEN-VALUE = cSearchLabel
          HIDDEN       = FALSE.
      CREATE FILL-IN hSearchField IN WIDGET-POOL STRING(TARGET-PROCEDURE)
        ASSIGN 
          DATA-TYPE = dynamic-function('columnDataType':U IN hDataSource, 
                                       cSearchField)
          FORMAT    = dynamic-function('columnFormat':U IN hDataSource, 
                                        cSearchField)
          ROW       = 1 
          COL       = hSearchLabel:COL + hSearchLabel:WIDTH 
          FRAME     = hFrame
          VISIBLE   = yes 
          SENSITIVE = yes
          SIDE-LABEL-HANDLE = hSearchLabel
        TRIGGERS: 
          ON ANY-PRINTABLE
            PERSISTENT RUN searchTrigger IN TARGET-PROCEDURE. 
        END TRIGGERS.

      {set SearchHandle hSearchField}.
      IF {fn getQuerySort hDataSource} <> cSortField THEN
      DO:
        {set QuerySort cSortField hDataSource}. 
        {get OpenOnInit lOpenOnInit hDataSource}.
        IF lOpenOnInit THEN 
          {fn openQuery hDataSource}.
      END.
      {get HideOnInit lHideOnInit}.
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
                                          
  Notes:       This procedure is here rather than in browser.p because it
               must sometimes use query.p, and sometimes datavis.p, as its
               super procedure, depending on whether the SmartDataBrowser has 
               its own database query.
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pcRelative AS CHARACTER NO-UNDO.
  
  DEFINE VARIABLE hBrowse           AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hDataSource       AS HANDLE    NO-UNDO.
  DEFINE VARIABLE lSelfQuery        AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE lSourceQuery      AS LOGICAL   NO-UNDO INIT ?.
  DEFINE VARIABLE cRowIdent         AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cFields           AS CHARACTER NO-UNDO.
  DEFINE VARIABLE hSource           AS HANDLE    NO-UNDO.
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
   
  /* Do nothing if source sdo is not initialized */
  {get DataSource hSource}.
  IF VALID-HANDLE(hSource) THEN
  DO:
    {get objectinitialized lInitialized hSource}.
    IF NOT lInitialized THEN 
      RETURN.
  END.
   
  {get ToolbarSource hToolbarSource}.
  IF VALID-HANDLE(hToolbarSOurce) THEN
    RUN resetToolbar IN hToolbarSource.
  /* if we got this message from "ourselves", because someone selected
     a row in the browser, which ran dataAvailable in the DataSource,
     then ignore it when it comes back. */
  /* If a Relative flag of FIRST/NEXT/LAST/PREV comes from a master query,
     and we are a dependent detail query OF that master, then treat these
     as just being DIFFERENT rows, and signal our super proc (query.p)
     to re-open the query, rather than doing a reposition. */
  {get QueryObject lSelfQuery}.
  {get QueryObject lSourceQuery SOURCE-PROCEDURE} NO-ERROR.  
   
  /* If this is a browse with its own query, we have to differentiate 
     between events coming from this browser through the VALUE-CHANGED trigger, 
     which we want to respond to, and the event published by our super procedure,
     query.p, which we need to ignore to avoid an infinite loop. So brschnge.i
     sends a special parameter of VALUE-CHANGED for that trigger,which we 
     convert to DIFFERENT. Otherwise we ignore DIFFERENT if it comes from 
     "ourself" or when we browse an SDO. We also ignore 'RESET' from an SDO. */
  
  IF NOT lSelfQuery OR (lSelfQuery AND THIS-PROCEDURE = SOURCE-PROCEDURE) THEN
  DO:
    IF pcRelative = 'DIFFERENT':U THEN
    DO:
     /* The SBO publishes dataAvailable 'DIFFERENT' at start up.*/ 
      {get DataSource hDataSource}.
      IF VALID-HANDLE(hDataSource) THEN
      DO:
        cRowIdent = ENTRY(1,{fnarg colValues '':U hDataSource},CHR(1)).
        {set RowIdent cRowIdent}.   
      END.

      /* This block is also entered when a browser is initialized / started up,
         in which case it will exit this procedure without updating the window
         title at startup. This is to fix issue 4703 */
      RUN updateTitle IN TARGET-PROCEDURE.

      RETURN.
    END. /* pcRelative = different */
    ELSE IF LOOKUP(pcRelative,"SAME,RESET":U) > 0 THEN
    DO:  
      /* A record in new mode will not be present in the browser yet, unless 
         the browse is the update source, so in that case we avoid this as 
         refresh/display would reposition the query and make the DataSource
         loose track of its new unsaved record. (The problem was encountered
         when an SBO publishes dataAvailable after a failed add)*/ 
      IF VALID-HANDLE(hSource) THEN
      DO:
        {get UpdateTarget hUpdateTarget}.
        IF NOT VALID-HANDLE(hUpdateTarget) OR hUpdateTarget <> hSource THEN
          {get NewMode lNewMode hSource}.
      END.

      IF NOT lNewMode THEN
      DO:
        /* This is necessary because BROWSER:REFRESH does not refresh */
        /* the current row */
        RUN displayRecord IN TARGET-PROCEDURE. 
        RUN refreshBrowse IN TARGET-PROCEDURE.
      END.
    END.
  END.
  
  /* If the browser has its own db query and no Foreign Fields, and this
     request didn't come from itself, then this is a request from an SDO
     being used for update to refresh the browse row with new values. */
  IF lSelfQuery AND SOURCE-PROCEDURE NE THIS-PROCEDURE THEN 
  DO:
    {get ForeignFields cFields}.
    IF cFields = "":U AND VALID-HANDLE(hSource) THEN
    DO:
      {get DisplayedFields cDisplayed}.
      cColumns    =
       dynamic-function ("colValues":U IN hSource, cDisplayed) NO-ERROR.
      RUN displayFields IN TARGET-PROCEDURE (cColumns). 
      RETURN.
    END.  /* END DO IF VALID-HANDLE */
  END.    /* END DO IF SelfQuery and no FF */

  /* IF this browser has a db query and the source of the event also does
     (i.e., is not a Nav Panel) and we didn't get the event from ourself...*/
  IF lSelfQuery AND lSourceQuery AND SOURCE-PROCEDURE NE THIS-PROCEDURE 
  AND LOOKUP(pcRelative, "FIRST,NEXT,PREV,LAST":U) NE 0 THEN 
      pcRelative = "DIFFERENT":U.
  
  {get BrowseHandle hBrowse}.
  
  CASE pcRelative:
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
  
  RUN displayObjects IN TARGET-PROCEDURE NO-ERROR.
  RUN updateTitle IN TARGET-PROCEDURE.
  RUN rowDisplay IN TARGET-PROCEDURE NO-ERROR.  /* Custom display checks. */
  
  {get DataSource hDataSource}.
  IF VALID-HANDLE(hDataSource) THEN
  DO:
    /* colValues will return ALL rowids for an SBO when no fields is passed, 
       but getRowident has logic to filter away the abundant ones.. */
    cRowIdent = ENTRY(1,{fnarg colValues '':U hDataSource},CHR(1)).
    {set RowIdent cRowIdent}.  
  END.

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
     {get ActionEvent cActionEvent}. 
     
     IF cActionEvent <> "":U THEN
       PUBLISH cActionEvent FROM TARGET-PROCEDURE.
  
     /* Is the default action supposed to close the browse ? */
     {get ApplyExitOnAction lExit}.
   
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
  DEFINE VARIABLE hDataSource       AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cForeignFields    AS CHARACTER  NO-UNDO.    
  DEFINE VARIABLE lSelfQuery        AS LOGICAL    NO-UNDO.  
  
  {get BrowseHandle hBrowse}.
  {get QueryObject lSelfQuery}.
  IF lSelfQuery THEN 
  DO:
    {get DataSource hDataSource}.
    {get ForeignFields cForeignFields TARGET-PROCEDURE}.    
  END.
  
  IF lSelfQuery THEN
    IF cForeignFields NE "":U AND hDataSource = SOURCE-PROCEDURE THEN 
      RETURN.   
  
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
    hBrowse:SELECT-FOCUSED-ROW().
  
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
  Notes:      The record deletion is actually done up the chain. 
              Invokes deleteComplete when the SDBrowser has its own query.
------------------------------------------------------------------------------*/
  
  DEFINE VARIABLE cErrors     AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cQueryPos   AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cRowIdent   AS CHARACTER NO-UNDO INIT "":U.
  DEFINE VARIABLE hBrowse     AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hBuffer     AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hDataSource AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hQuery      AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hRowIdent   AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hRowNum     AS HANDLE    NO-UNDO.
  DEFINE VARIABLE iCnt        AS INTEGER   NO-UNDO.
  DEFINE VARIABLE lQueryObj   AS LOGICAL   NO-UNDO.
  
  {get BrowseHandle hBrowse}.
  IF hBrowse:NUM-SELECTED-ROWS NE 1 THEN
  DO:
     DYNAMIC-FUNCTION("showMessage":U IN TARGET-PROCEDURE, "1":U).  
     /* Must select a single row for deletion. */
     RETURN "ADM-ERROR":U.
  END.
  
  hBrowse:SELECT-FOCUSED-ROW() NO-ERROR.  /* In case it's not yet explicitly selected.*/
  hQuery = hBrowse:QUERY.  /* Whether DB or RowObject query */
  {get QueryObject lQueryObj}.
  IF lQueryObj THEN
  DO:
    /* For a database query, leave the first entry in RowIdent blank and
       set the rest of it to the database record ROWID(s). */
    DO iCnt = 1 TO hQuery:NUM-BUFFERS:
      ASSIGN hBuffer = hQuery:GET-BUFFER-HANDLE(iCnt)
             cRowIdent = cRowIdent + ",":U +  STRING(hBuffer:ROWID).
    END.    /* END DO iCnt */
  END.      /* END DO QueryObject = Yes */
  ELSE DO:     /* QueryObject = No */
    ASSIGN hBuffer = hQuery:GET-BUFFER-HANDLE(1)
           cRowIdent = STRING(hBuffer:ROWID).
    {get DataSource hDataSource}.
    {get QueryPosition cQueryPos hDataSource}.
  END.  /* Else Do - QueryObject = No */
  {set RowIdent cRowIdent}.
  
  RUN SUPER.
  
  IF RETURN-VALUE = "ADM-ERROR":U THEN RETURN "ADM-ERROR":U. 
  
  IF lQueryObj THEN
    RUN deleteComplete IN TARGET-PROCEDURE.

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

  DEFINE VARIABLE lQueryObject AS LOGICAL  NO-UNDO.
  DEFINE VARIABLE hDataSource  AS HANDLE   NO-UNDO.
  DEFINE VARIABLE lAction      AS LOG    NO-UNDO.
 
  ghTargetProcedure = TARGET-PROCEDURE. /* 9.1B: Stash this so DQB can get it.*/

  {get QueryObject lQueryObject}.
  /* Do this only if the object does not have its own database query. */
  IF NOT lQueryObject THEN
  DO:
    {get DataSource hDataSource}.
    {set DataQueryBrowsed no hDataSource} NO-ERROR.
  END.

  /* Is the exit supposed to behave as a double-click or return?
    (publish the ActionEvent) */
  {get ApplyActionOnExit lAction}.
  IF lAction THEN 
  DO:
    /* There's an opposite property that dictates that defaultAction calls
       exit, which is not needed in this case and also would create loop  */ 
    {set ApplyExitOnAction FALSE}.
    RUN defaultAction IN TARGET-PROCEDURE.
  END. /* if lAction */

  DELETE WIDGET-POOL STRING(TARGET-PROCEDURE) NO-ERROR.

  RUN SUPER.

  ghTargetProcedure = ?.         /* 9.1B: reset local TargetProcedure var. */

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

  DEFINE INPUT PARAMETER pcFields   AS CHARACTER NO-UNDO. 
  
  DEFINE VARIABLE hBrowse   AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hFrame    AS HANDLE    NO-UNDO.
  DEFINE VARIABLE lEnabled  AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE cFields   AS CHARACTER NO-UNDO.
  DEFINE VARIABLE lSelected AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE hColumn   AS HANDLE    NO-UNDO.

  {get BrowseHandle hBrowse}.
  /* NOTE: No specific support yet for just disabling 'Create' fields. */
  IF VALID-HANDLE(hBrowse) AND pcFields = 'All':U THEN
  DO:
    {get EnabledFields cFields}.
    {get FieldsEnabled lEnabled}.
    IF cFields NE "":U AND lEnabled   /* There are enabled fields to disable */
    THEN DO:
      {get ContainerHandle hFrame}.
      
      /* Was a row selected? */
      lSelected = hBrowse:NUM-SELECTED-ROWS > 0. 
      APPLY "ENTRY":U TO hFrame.
      /* Setting each column to read-only avoids problems with the column 
         remaining visually enabled when this procedure is called without  
         row-leave/leave been fired (for example the toolbar which has no focus). */
      hBrowse:READ-ONLY = TRUE NO-ERROR.
      hColumn = hBrowse:FIRST-COLUMN.
      DO WHILE VALID-HANDLE(hColumn):
        IF CAN-DO(cFields,hColumn:NAME) THEN 
          hColumn:READ-ONLY = TRUE NO-ERROR.
        hColumn = hColumn:NEXT-COLUMN.
      END.      
      IF lSelected THEN 
         hBrowse:SELECT-FOCUSED-ROW() NO-ERROR.
      {set FieldsEnabled no}.
    END.
  END.
  
  RUN SUPER(pcFields).
  
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
 DEFINE VARIABLE lSelfQuery        AS LOGICAL    NO-UNDO.
 DEFINE VARIABLE hQuery            AS HANDLE     NO-UNDO.
 DEFINE VARIABLE hBuffer           AS HANDLE     NO-UNDO.
 DEFINE VARIABLE hField            AS HANDLE     NO-UNDO.  
 DEFINE VARIABLE cField            AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cBufferHandles    AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cBufferList       AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cNewRecord        AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE lStaticDisp       AS LOGICAL    NO-UNDO.

 {get QueryObject lSelfQuery}.
 {get NewRecord cNewRecord}.
 {get DisplayedFields cFields}.

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
   IF NOT lSelfQuery OR (lSelfQuery AND cNewRecord NE 'no':U) THEN 
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
                                           TRIM(ENTRY(iValue, pcColValues, CHR(1)))
                                           ELSE IF hFrameField:DATA-TYPE NE "LOGICAL":U THEN "":U
                                           ELSE ?
                hFrameField:MODIFIED = no  /* Checked by update code. */
               NO-ERROR.
     END.
   END. /* IF NOT lSelfQuery ... */
  
   ELSE DO:
      {get QueryHandle hQuery}.
      IF NOT hQuery:IS-OPEN THEN RETURN.

      DO iValue = 1 TO hQuery:NUM-BUFFERS:
        ASSIGN 
            hBuffer        = hQuery:GET-BUFFER-HANDLE(iValue)
            cBufferHandles = cBufferHandles + ",":U + STRING(hBuffer)
            cBufferList    = cBufferList + ",":U + hBuffer:NAME
            .
      END.   
      ASSIGN 
          cBufferHandles = LEFT-TRIM(cBufferHandles,",":U)      
          cBufferList    = LEFT-TRIM(cBufferList,",":U)
          .
      
      hQuery:GET-CURRENT().
      hBuffer =  hQuery:GET-BUFFER-HANDLE(1).
      IF hBuffer:AVAILABLE THEN DO:
          {get FieldHandles cFieldHandles}.
          IF cFieldHandles NE "":U THEN
          DO iValue = 1 TO NUM-ENTRIES(cFieldHandles):
            ASSIGN hFrameField = WIDGET-HANDLE(ENTRY(iValue,cFieldHandles)).
            IF hFrameField:TABLE NE ? THEN
                ASSIGN
                   hBuffer = WIDGET-HANDLE(ENTRY(LOOKUP(hFrameField:TABLE,cBufferList),cBufferHandles))
                   hField  = hBuffer:BUFFER-FIELD(hFrameField:NAME)
                   hFrameField:SCREEN-VALUE = IF hField:BUFFER-VALUE NE ? THEN hField:BUFFER-VALUE
                                        ELSE IF hField:DATA-TYPE NE "LOGICAL":U THEN "":U
                                        ELSE ?
                   hFrameField:MODIFIED = no.
          END. /* DO iValue = 1 TO ... */  
      END. /* IF hBuffer:AVAILABLE ... */    
   END.
 END.

 RUN displayObjects IN TARGET-PROCEDURE NO-ERROR.
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

  DEFINE VARIABLE lSelected        AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE hBrowse          AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hFrame           AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hColumn          AS HANDLE     NO-UNDO.
  DEFINE VARIABLE lEnabled         AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cDisplayedFields AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFields          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFieldSecurity   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cState           AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cTarget          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iFieldPos        AS INTEGER    NO-UNDO.

  {get BrowseHandle hBrowse}.
  IF VALID-HANDLE(hBrowse) THEN
  DO:
    {get EnabledFields cFields}.
    {get FieldsEnabled lEnabled}.
    {get RecordState cState}.
    {get UpdateTarget cTarget}.
    {get DisplayedFields cDisplayedFields}.
    {get FieldSecurity cFieldSecurity}.
    
    IF cFields NE "":U AND (NOT lEnabled) /* There are fields to enable */
         AND cTarget NE "":U              /* and an Update-Target */
    THEN DO:
      lSelected = hBrowse:NUM-SELECTED-ROWS = 1.  /* Was a row selected? */
      {get ContainerHandle hFrame}.
      
      APPLY "ENTRY":U TO hFrame.
      
      /* Turn off read-only for each column 
         See comments in disable fields why read-only is true */
      hColumn = hBrowse:FIRST-COLUMN.
      DO WHILE VALID-HANDLE(hColumn):
        iFieldPos = LOOKUP(hColumn:NAME,cDisplayedFields).
        IF CAN-DO(cFields,hColumn:NAME) AND
          ((iFieldPos <> 0 AND
          NUM-ENTRIES(cFieldSecurity) >= iFieldPos AND 
          ENTRY(iFieldPos,cFieldSecurity) = "":U) OR 
          iFieldPos = 0 OR 
          cFieldSecurity = "":U) THEN
          hColumn:READ-ONLY = FALSE.
        hColumn = hColumn:NEXT-COLUMN.
      END.
      hBrowse:READ-ONLY = no.
      IF lSelected THEN hBrowse:SELECT-FOCUSED-ROW() NO-ERROR.
      APPLY "ENTRY":U TO hBrowse.
      {set FieldsEnabled yes}.
    END.
    
    IF cState = 'NoRecordAvailable':U THEN DO:
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
  Purpose:   Override as visual assumes EnabledObjFlds is fields.  
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hBrowse AS HANDLE     NO-UNDO.

  {get BrowseHandle hBrowse}.
  hBrowse:SENSITIVE = TRUE.
  
  {set ObjectEnabled yes}.  

  /* We also run enable_UI from here. */ 
  RUN enable_UI IN TARGET-PROCEDURE NO-ERROR.

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
      hBrowse:REFRESHABLE = YES. 

      /* This is/was a workaround to "wake-up" an updatable browse when running 
         on an Appserver. If the cell had focus before fetchLast it did not 
         detect that anything had changed and all rows became invisible. 
         This particular condition can be detected as hBrowse:num-entries 
         returned 0, (the browse must have a split personality), but by doing 
         this in all cases we get an additional benefit as an updatable browse 
         will keep focus in the current cell */ 
      IF FOCUS = hBrowse THEN
        APPLY "ENTRY":U TO hBrowse. 
    END.
    WHEN 'BatchEnd':U THEN 
    DO:
      hBrowse:REFRESHABLE = YES. 
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
DEFINE VARIABLE cColDataEntry        AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cColumnBGColors      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cColumnFGColors      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cColumnLabelBGColors AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cColumnLabelFGColors AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cColumnLabelFonts    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cColumnLabels        AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cColumnWidths        AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cColumnFonts         AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cDefaultColumnData   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cEnabledFields       AS CHARACTER  NO-UNDO INIT "":U.
DEFINE VARIABLE cEnabledHandles      AS CHARACTER  NO-UNDO INIT "":U.
DEFINE VARIABLE cFieldHandles        AS CHARACTER  NO-UNDO INIT "":U.
DEFINE VARIABLE cFieldSecurity       AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cSavedColumnData     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE dAllWidth            AS DECIMAL    NO-UNDO.
DEFINE VARIABLE dTotalWidth          AS DECIMAL    NO-UNDO.
DEFINE VARIABLE hBrowse              AS HANDLE     NO-UNDO.
DEFINE VARIABLE hColumn              AS HANDLE     NO-UNDO.
DEFINE VARIABLE hDataSource          AS HANDLE     NO-UNDO.
DEFINE VARIABLE hLastColumn          AS HANDLE     NO-UNDO.
DEFINE VARIABLE iColDataEntry        AS INTEGER    NO-UNDO.
DEFINE VARIABLE iFieldPos            AS INTEGER    NO-UNDO.
DEFINE VARIABLE lUseRepository       AS LOGICAL    NO-UNDO.

  {get BrowseHandle hBrowse}.    
  {get DataSource hDataSource}.
  {get EnabledFields cEnabledFields}.
  {get FieldSecurity cFieldSecurity}.
  {get SavedColumnData cSavedColumnData}.

  {get UseRepository lUseRepository}.
  IF lUseRepository THEN
  DO:
    &SCOPED-DEFINE xpBrowseColumnBGColors
    {get BrowseColumnBGColors cColumnBGColors}.
    &UNDEFINE xpBrowseColumnBGColors
    
    &SCOPED-DEFINE xpBrowseColumnFGColors
    {get BrowseColumnFGColors cColumnFGColors}.
    &UNDEFINE xpBrowseColumnFGColors
    
    &SCOPED-DEFINE xpBrowseColumnLabelBGColors
    {get BrowseColumnLabelBGColors cColumnLabelBGColors}.
    &UNDEFINE xpBrowseColumnLabelBGColors
    
    &SCOPED-DEFINE xpBrowseColumnLabelFGColors
    {get BrowseColumnLabelFGColors cColumnLabelFGColors}.
    &UNDEFINE xpBrowseColumnLabelFGColors
    
    &SCOPED-DEFINE xpBrowseColumnLabelFonts
    {get BrowseColumnLabelFonts cColumnLabelFonts}.
    &UNDEFINE xpBrowseColumnLabelFonts
    
    &SCOPED-DEFINE xpBrowseColumnLabels
    {get BrowseColumnLabels cColumnLabels}.
    &UNDEFINE xpBrowseColumnLabels
    
    &SCOPED-DEFINE xpBrowseColumnWidths
    {get BrowseColumnWidths cColumnWidths}.  
    &UNDEFINE xpBrowseColumnWidths    
       
    &SCOPED-DEFINE xpBrowseColumnFonts
    {get BrowseColumnFonts cColumnFonts}.
    &UNDEFINE xpBrowseColumnFonts       
  END.  /* if using repository and dynamic */
  IF VALID-HANDLE(hBrowse) THEN
    ASSIGN hColumn= hBrowse:FIRST-COLUMN.
  ASSIGN dTotalWidth = 0
         dAllWidth   = 0.
  
  DO WHILE VALID-HANDLE(hColumn):
    ASSIGN
      iFieldPos     = iFieldPos + 1 
      cFieldHandles = cFieldHandles 
                    + (IF cFieldHandles NE "":U THEN "," ELSE "":U) 
                    + STRING(hColumn).
    IF LOOKUP(hColumn:NAME, cEnabledFields) NE 0 THEN
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
        hColumn:FONT          = IF NUM-ENTRIES(cColumnFonts, CHR(5)) >= iFieldPos THEN
                                    INTEGER(ENTRY(iFieldPos, cColumnFonts, CHR(5)))
                                ELSE
                                    hColumn:FONT

        hColumn:AUTO-RESIZE    = TRUE
        hColumn:RESIZABLE      = TRUE
       NO-ERROR.
      
    cDefaultColumnData = cDefaultColumnData
                       + (IF NUM-ENTRIES(cDefaultColumnData, CHR(3)) > 0 
                          THEN CHR(3) ELSE '':U)
                       + hColumn:NAME + CHR(4) + STRING(hColumn:WIDTH-PIXELS).
    DO iColDataEntry = 1 TO NUM-ENTRIES(cSavedColumnData, CHR(3)):
      cColDataEntry = ENTRY(iColDataEntry, cSavedColumnData, CHR(3)).
      IF ENTRY(1, cColDataEntry, CHR(4)) = hColumn:NAME THEN
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
        ASSIGN hColumn:READ-ONLY = TRUE.
    END.
    ELSE
      ASSIGN dTotalWidth = dTotalWidth + hColumn:WIDTH-PIXELS
             hLastColumn = hColumn.
    hColumn = hColumn:NEXT-COLUMN.
  END.              

    /* If a column is now hidden due to security, add the width
       of that column to the width of the last visible column to
       use up all the original available space */
  IF dTotalWidth < dAllWidth THEN
    hLastColumn:WIDTH-PIXELS = hLastColumn:WIDTH-PIXELS + (dAllWidth - dTotalWidth).

  {set FieldHandles cFieldHandles}.
  {set EnabledHandles cEnabledHandles}.

  /* Stores default column positions and sizes to support reset to default */
  {set DefaultColumnData cDefaultColumnData}.

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
  DEFINE VARIABLE cEnabledFields    AS CHARACTER NO-UNDO INIT "":U.
  DEFINE VARIABLE cCreateHandles    AS CHARACTER NO-UNDO INIT "":U.
  DEFINE VARIABLE cRowIdent         AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cUIBMode          AS CHARACTER NO-UNDO.
  DEFINE VARIABLE lSaveSource       AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE lQueryObject      AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE cTarget           AS CHARACTER NO-UNDO.
  DEFINE VARIABLE lQueryBrowsed     AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE cFields           AS CHARACTER NO-UNDO.
  DEFINE VARIABLE hDataQuery        AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hDataBuffer       AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hTableio          AS HANDLE    NO-UNDO.
  DEFINE VARIABLE iField            AS INTEGER   NO-UNDO.
  DEFINE VARIABLE cField            AS CHARACTER NO-UNDO.
  DEFINE VARIABLE lResult           AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE hField            AS HANDLE    NO-UNDO.
  DEFINE VARIABLE cAssigns          AS CHARACTER NO-UNDO.
  DEFINE VARIABLE iEntry            AS INTEGER   NO-UNDO.
  DEFINE VARIABLE lDynamic          AS LOGICAL   NO-UNDO INIT no.
  DEFINE VARIABLE cValidation       AS CHARACTER NO-UNDO INIT "":U.
  DEFINE VARIABLE lCalcWidth        AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE iNumDown          AS INTEGER   NO-UNDO.
  DEFINE VARIABLE cContained        AS CHARACTER NO-UNDO.
  DEFINE VARIABLE hQueryRowObject   AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hQueryHandle      AS HANDLE    NO-UNDO.
  DEFINE VARIABLE lScrollRemote     AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE hTarget           AS HANDLE     NO-UNDO.
  DEFINE VARIABLE lRowDisplay       AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE rRowid            AS ROWID      NO-UNDO.
  DEFINE VARIABLE lPopupActive      AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lMovable          AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lSortable         AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lFitLastColumn    AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lUseRepository    AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cDataSourceNames  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hSDO              AS HANDLE     NO-UNDO.

  /* Create the widgets in this widget-pool.  It will be destroyed in destroyObject */ 

  CREATE WIDGET-POOL STRING(TARGET-PROCEDURE) PERSISTENT NO-ERROR.

  /* NEW FOR 9.1B: stash the TARGET-PROCEDURE handle away so the
     Data-Source can identify it if it's an SBO */
  ghTargetProcedure = TARGET-PROCEDURE.
  {get UIBMode cUIBMode}.

  /* First determine whether this is a "dynamic" browser (actually an
     empty static browser to be filled in at runtime). */
  {get DataSource hDataSource}.   /* Proc. handle of our SDO. */
  {get BrowseHandle hBrowse}.     /* Handle of the browse widget. */
  
  /* Retrieves column positions and sizes, if they exist, from the profile 
     manager for this browser instance */
  IF VALID-HANDLE(gshProfileManager) THEN 
    RUN readSavedSettings IN TARGET-PROCEDURE.

  /* The sort column used to be set here.  It is now set from the SDO initialization */

  hBrowse:ALLOW-COLUMN-SEARCHING = TRUE.
  IF hBrowse:NUM-COLUMNS = 0 THEN
  DO:
    lDynamic = yes.            /* Signal to code below. */
    /* Get Displayed and Enabled fields at runtime. */
    IF NOT VALID-HANDLE(hDataSource) THEN
      RETURN ERROR.  /* Can't do anything without it. */
    {get DataHandle hDataQuery hDataSource} NO-ERROR. /*Handle of the SDO's query. */
    IF VALID-HANDLE(hDataQuery) THEN         
    DO:
      ASSIGN
        hQueryRowObject = hDataQuery:GET-BUFFER-HANDLE(1)
        rRowid = hQueryRowObject:ROWID.
      ASSIGN hBrowse:QUERY = hDataQuery NO-ERROR.     /* Attach this to the Browse.*/
      
      ERROR-STATUS:ERROR = NO.
      hDataBuffer = hDataQuery:GET-BUFFER-HANDLE(1).  /* SDO Buffer handle.  */
      
      /* synch the browse with the data source */
      IF rRowid <> ? THEN 
        hDataQuery:REPOSITION-TO-ROWID(rRowid).
      
      /* If the browse became visible when the QUERY was attached above then 
         turn off fit-last-column since the first column will expand to the
         full length when using add-like below
         (the reason that this is down here was that there was a run 
         dataAvailable after the repos, which theoretically may change
         visibility.. it can probably be move up closer if needed..  )   */
      IF hBrowse:VISIBLE THEN
        ASSIGN
          lFitLastColumn = hBrowse:FIT-LAST-COLUMN
          hBrowse:FIT-LAST-COLUMN = FALSE.
    END.
      
    {get EnabledFields cEnabledFields}.
    {get DisplayedFields cFields}.
    /* If DisplayedFields is blank, this means take all fields from the SDO.
       If EnabledFields is blank, this means take all updatable fields
       from the SDO, IF there is a Tableio-Source. */
    IF cFields = "":U AND VALID-HANDLE (hDataSource) THEN
    DO:
        /* If the DataSource is in fact an SBO, this function is not
           available, which means effectively that a dynamic SDB built
           against an SBO *must* have a column list (otherwise the SBO
           has no idea which SDO to attach the SDB to). */
      {get DataColumns cFields hDataSource} NO-ERROR.
      {set DisplayedFields cFields}.         /* Set the property. */
    END.    /* END DO IF cFields "" */
    DO iField = 1 TO NUM-ENTRIES(cFields):
      /* Add the requested columns to the browse. */
        hField = hDataBuffer:BUFFER-FIELD(ENTRY(iField, cFields)) NO-ERROR.
        IF VALID-HANDLE(hField) THEN
        DO:
           IF hField:VALIDATE-EXPRESSION NE ? THEN 
           DO: 
             cValidation = hField:VALIDATE-EXPRESSION.
             hField:VALIDATE-EXPRESSION = "":U.
             hBrowse:ADD-LIKE-COLUMN(hField).
             hField:VALIDATE-EXPRESSION = cValidation.
           END.  /* if vaildate-expression ne ? */
           ELSE hBrowse:ADD-LIKE-COLUMN(hField).
        END. /* END DO IF valid-handle */
    END.  /* END DO iField */
    /* set fit-last-column (expandable) back if turned off temporarily above*/
    IF lFitLastColumn THEN
      hBrowse:FIT-LAST-COLUMN = TRUE.

    {get UseRepository lUseRepository}.
    IF cEnabledFields = "":U AND NOT lUseRepository THEN
    DO:
      {get TableIOSource hTableIO}.
      IF VALID-HANDLE(hTableIO) AND VALID-HANDLE (hDataSource) THEN
      DO:
        {get UpdatableColumns cEnabledFields hDataSource}.
        
        /* If the Display list was specified, but the Enabled list wasn't,
           make sure we remove any fields from the Enable list which
           weren't in the Display list. */
        DO iField = 1 TO NUM-ENTRIES(cEnabledFields):
          cField = ENTRY(iField, cEnabledFields).
          IF LOOKUP(cField, cFields) = 0 THEN
            ASSIGN cEnabledFields = REPLACE(',':U + cEnabledFields + ',':U, 
                     ',':U + cField + ',':U, ',':U)
                   cEnabledFields = 
                     SUBSTR(cEnabledFields, 2, LENGTH(cEnabledFields) - 2,
                     "CHARACTER":U).
        END. /* END DO iField */
        {set EnabledFields cEnabledFields}.
      END.   /* END DO IF TableIOSource */
    END.     /* END DO IF cEnabledFields "" */
     
    /* If there are any enabled fields, set the enabled prop to yes,
       because they will be explitly disabled by initializeObject if needed. */
    IF cEnabledFields NE "":U THEN
    DO:
      /* Now enable the appropriate columns. 
         The Browse must be made updatable first. */
      hBrowse:READ-ONLY = no.    
      hField = hBrowse:FIRST-COLUMN.
      DO WHILE VALID-HANDLE(hField):
        IF LOOKUP(hField:NAME,cEnabledFields) NE 0 THEN
          hField:READ-ONLY = no.
        hField = hField:NEXT-COLUMN.
      END. /* END DO WHILE hField */
      {set FieldsEnabled yes}.
    END. /* END DO IF cEnabledFields */   
  END.   /* END DO IF NUM-COLUMNS = 0 -- "dynamic" browser */

  /* We need to set expandable to TRUE here when CalcWidth is TRUE before
     the browse is viewed so that calcWidth can calculate column widths
     correctly. */
  {get CalcWidth lCalcWidth}.
  IF NOT (cUIBMode BEGINS "Design":U) AND lCalcWidth THEN hBrowse:EXPANDABLE = FALSE.

  {get QueryObject lQueryObject}.
  /* We need to set CheckLastOnOpen to TRUE so that LastDBRowIdent is set
     when the query is opened, we can then check the value of LastDBRowIdent
     in fetchNext to determine if we have just moved to the last row in 
     the query, if we have then QueryPosition can be set properly */
  IF lQueryObject THEN
    {set CheckLastOnOpen TRUE}. 
  ELSE IF VALID-HANDLE(hDataSource) THEN
  DO:
    {get DataQueryBrowsed lQueryBrowsed hDataSource}.
    IF lQueryBrowsed THEN
    DO:
      DYNAMIC-FUNCTION("showMessage":u IN TARGET-PROCEDURE,
        "SDO query cannot be browsed by more than one SmartDataBrowser.":U).
      RETURN "ADM-ERROR":U.
    END.
    {set DataQueryBrowsed yes hDataSource}. 
  END.

  RUN SUPER.
  IF RETURN-VALUE = "ADM-ERROR":U THEN
    RETURN "ADM-ERROR":U.
  
  /* If this object or its parent is in design mode, then don't
     open the query or do any of the rest of this initialization code. */
  
  IF cUIBMode BEGINS "Design":U
    THEN RETURN.
    
  /* If we have no TableIO-Source, or if it's an Update panel in "Update" mode,
     or if there's no Update-Target, then the Browse should be disabled. */
  {get SaveSource lSaveSource}.
  {get UpdateTarget cTarget}.
  IF (NOT lSaveSource) OR (cTarget = "":U) THEN 
  DO:
    RUN disableFields IN TARGET-PROCEDURE('All':U).
    /* This may need to be reflected in the tableiosource */  
    PUBLISH 'resetTableio':U FROM TARGET-PROCEDURE.
  END.  
  ELSE {set ObjectMode 'Modify':U}.

  {get DataSource hDataSource}.
  {get BrowseHandle hBrowse}.
  {get QueryObject lQueryObject}.
  hBrowse:CREATE-ON-ADD = TRUE.
  
  IF lQueryObject THEN
  DO:
    {get ForeignFields cFields}.
    /* This browser is browsing its own db query. If there's no other DataSource
       dependency and we're not in design mode, open that query. */
    IF (NOT VALID-HANDLE(hDataSource) AND (NOT cUIBMode BEGINS "Design":U))
        OR cFields = "":U
      THEN {fn openQuery}.
    /* Otherwise if there's a DataSource, find out if there's a row waiting
       for us; if there is, dataAvailable will open our dependent query. */
    ELSE IF VALID-HANDLE(hDataSource) THEN
      RUN dataAvailable In TARGET-PROCEDURE ("DIFFERENT":U).
    hDataQuery = hBrowse:QUERY.
    IF hDataQuery:NUM-RESULTS > 0 THEN
      {set RecordState 'RecordAvailable':U}.
  END.   /* END Do for QueryObject */ 
  ELSE IF VALID-HANDLE(hDataSource) THEN
  DO:
    /* Reassign the Browse to use the Data Object's query. */
    {get DataHandle hDataQuery hDataSource} NO-ERROR.  /* NO-ERROR for design*/
    IF VALID-HANDLE(hDataQuery) THEN
    DO:
      /* Else go ahead and attach the query and set the source's property.*/
      IF NOT lDynamic THEN       /* If dynamic, this has been done above. */
      DO:
         ASSIGN hBrowse:QUERY = hDataQuery NO-ERROR. 
         ERROR-STATUS:ERROR = NO.
      END.
    END.     /* END DO IF VALID-HANDLE */
  END.       /* END DO for non-QueryObject */
  
  /* Initialize the list of handles of the browse fields, 
     for displayFields and updateRecord to use. 
     Also set a similar list of the field names for updateRecord to use. 
     Also a list of Enabled Field handles for enable/disableFields,
       and a list of any fields to be enabled for Create. */
    
  IF VALID-HANDLE(hBrowse) THEN
  DO:           /* SKip all this at design time or when there's no query yet. */
    
    /* Get the handle to the RowObject temp-table in the query and
       set QueryRowObject from it */
    hQueryHandle = hBrowse:QUERY.
    IF VALID-HANDLE(hQueryHandle) THEN
        hQueryRowObject = hQueryHandle:GET-BUFFER-HANDLE(1).

    {set QueryRowObject hQueryRowObject}.

    /* set column data (such as label, width, etc.) */
    RUN initializeColumnSettings IN TARGET-PROCEDURE no-error.

    {set CreateHandles cCreateHandles}.
    
    RUN createSearchField IN TARGET-PROCEDURE.

    IF lCalcWidth THEN RUN calcWidth IN TARGET-PROCEDURE.
    
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
        /*  RowsTOBatch above is in the SBO, but LastRowNum is not */
        {get DataSourceNames cDataSourceNames}.
        hSDO = ?. 
        IF cDataSourceNames > '':U THEN
        DO:
          hSDO = {fnarg dataObjectHandle cDataSourceNames hDataSource} NO-ERROR.
          IF VALID-HANDLE(hSDO) THEN
            {get LastRowNum iMaxGuess hSDO}.
        END.        
        /* No-error as it still may get here with an SBO if something
           is wrong with datasourcenames (mismatch or blank) 
           Even if that is very wrong, this error wont give any clue ..  */
        IF iMaxGuess = 0 AND NOT VALID-HANDLE(hSDO) THEN
          {get LastRowNum iMaxGuess hDataSource} NO-ERROR.
      END.
      IF iMaxGuess > 0 THEN
        hBrowse:MAX-DATA-GUESS = iMaxGuess.
    END.  /* if not design mode */

    /* Sets column positions and sizes based on savedColumnData */
    RUN resetColumnSettings IN TARGET-PROCEDURE.

    /* Column movable and allow-column-searching are mutually exclusive, 
       column sorting (implemented with column-searching) takes precedence */
    {get ColumnsMovable lMovable}.
    {get ColumnsSortable lSortable}.
    hBrowse:COLUMN-MOVABLE = IF lSortable THEN FALSE ELSE lMovable.
    hBrowse:ALLOW-COLUMN-SEARCHING = lSortable.
    IF lMovable AND lSortable THEN
      {set ColumnsMovable FALSE}.
    {get PopupActive lPopupActive}.
    IF lPopupActive THEN 
      RUN createPopupMenu IN TARGET-PROCEDURE.

  END.        /* END IF VALID-HANDLE(hBrowse) */
  
  /* The following links the ROW-DISPLAY trigger in with the rowDisplay procedure. This
     is only used to support scrolling of the remote query.*/
  {get ScrollRemote lScrollRemote}.
  /* Check also for rowDisplay in custom super. */
  hTarget = WIDGET-HANDLE(ENTRY(1, TARGET-PROCEDURE:SUPER-PROCEDURES)).
  IF hTarget NE THIS-PROCEDURE AND  /* Make sure it's not just browser.p */
      LOOKUP('rowDisplay', hTarget:INTERNAL-ENTRIES) NE 0
       THEN lRowDisplay = YES.
  IF lScrollRemote OR lRowDisplay THEN
    ON ROW-DISPLAY OF hBrowse PERSISTENT RUN rowDisplay IN TARGET-PROCEDURE. 

  ghTargetProcedure = ?.         /* 9.1B: reset local storage of this. */

  RUN adjustReposition IN TARGET-PROCEDURE.

  /* we need to tell ourselves that we have data...  */  
  RUN dataAvailable IN TARGET-PROCEDURE ('DIFFERENT':U).
  
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
DEFINE VARIABLE hDataSource       AS HANDLE NO-UNDO.
DEFINE VARIABLE hDataTarget       AS HANDLE NO-UNDO.
DEFINE VARIABLE hNavigationSource AS HANDLE NO-UNDO.
DEFINE VARIABLE cProcedureType    AS CHARACTER NO-UNDO.
DEFINE VARIABLE lMultiInstanceActivated AS LOGICAL    NO-UNDO.

     /* This is the window that can view/modify/add the current record */
    {get FolderWindowToLaunch cFolderWindow}.

    IF cFolderWindow > "":U THEN
    DO:
      {get ContainerSource hContainerSource}.
      {get ContainerHandle hWindowHandle hContainerSource}.
      IF VALID-HANDLE(gshSessionManager) THEN
      DO:
        {get DataSource hDataSource}.
         IF VALID-HANDLE(hContainerSource) 
            AND LOOKUP ("getMultiInstanceActivated":U, hContainerSource:INTERNAL-ENTRIES) <> 0 THEN
           lMultiInstanceActivated = DYNAMIC-FUNCTION("getMultiInstanceActivated":U IN hContainerSource).
         ELSE
           lMultiInstanceActivated = NO.
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
  Purpose:    Override to set FetchHasAudit and FetchHasComment
  Parameters: pcstate -
                add,remove,inactive,active
              phObject - object to link to 
              pcLink   - Linkname (data-source)      
  Notes:      
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pcState   AS CHARACTER  NO-UNDO.
  DEFINE INPUT PARAMETER phObject  AS HANDLE     NO-UNDO.
  DEFINE INPUT PARAMETER pcLink    AS CHARACTER  NO-UNDO.
 
  DEFINE VARIABLE hDataSource     AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hToolbarSource  AS HANDLE     NO-UNDO.

  IF pcLink = 'ToolbarSource':U AND pcState = 'Add':U THEN
  DO:
    {get DataSource hDataSource}.
    IF VALID-HANDLE(hDataSource) THEN
    DO:
      {set FetchHasAudit   TRUE hDataSource}.
      {set FetchHasComment TRUE hDataSource}.
      {set FetchAutoComment TRUE hDataSource}.
    END.
  END.
  ELSE IF pcLink = 'DataSource':U  AND pcState = 'Add':U THEN
  DO:
    {get ToolbarSource hToolbarSource}.
    IF VALID-HANDLE(hToolbarSource) THEN
    DO:
      {set FetchHasAudit   TRUE phObject}.
      {set FetchHasComment TRUE phObject}.
      {set FetchAutoComment TRUE phObject}.
    END.
  END.

  RUN SUPER(pcState,phObject,pcLink).
  
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

  {get MovableHandle hMovableItem}.
  {get SortableHandle hSortableItem}.

  {set ColumnsMovable hMovableItem:CHECKED}.
  IF hSortableItem:CHECKED AND hMovableItem:CHECKED THEN
  DO:
    hSortableItem:CHECKED = FALSE.
    {set ColumnsSortable FALSE}.
  END.  /* both checked */

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
  
  {get BrowseHandle hBrowse}.
  hBrowse:REFRESHABLE = NO.

  DO iNumCols = 1 TO NUM-ENTRIES(pcColumnData, CHR(3)):
    ASSIGN
      cColumnEntry = ENTRY(iNumCols, pcColumnData, CHR(3))
      hColumn      = hBrowse:FIRST-COLUMN
      iColumnPos   = 1.

    DO WHILE VALID-HANDLE(hColumn):
      IF hColumn:NAME = ENTRY(1, cColumnEntry, CHR(4)) THEN
      DO:
        hBrowse:MOVE-COLUMN(iColumnPos, iNumCols) NO-ERROR.
        hColumn:WIDTH-PIXELS = INTEGER(ENTRY(2, cColumnEntry, CHR(4))).
        LEAVE.
      END.  /* if column name = entry */
      ASSIGN
        hColumn    = hColumn:NEXT-COLUMN
        iColumnPos = iColumnPos + 1.
    END.  /* do while column valid */
  END.  /* do iNumCols to column data entries */
  hBrowse:REFRESHABLE = YES.

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
  DEFINE VARIABLE lQuery      AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE lModified   AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE cNewRecord  AS CHARACTER NO-UNDO.  
  DEFINE VARIABLE iLastRowNum AS INTEGER   NO-UNDO.
  DEFINE VARIABLE cMsg        AS CHARACTER NO-UNDO.
  
  /* If this object is browsing a DataObject query, then when we scroll 
     to the end, see if there are more rows in the database query 
     to be transferred to the RowObject query. */
  {get QueryObject lQuery}.
  IF NOT lQuery THEN
  DO:
    iLastRowNum = DYNAMIC-FUNCTION('linkProperty':U IN TARGET-PROCEDURE,
                                   INPUT 'DATA-SOURCE':U,
                                   INPUT 'LastRowNum':U).
    IF iLastRowNum NE ? THEN RETURN. /* If we have already fetched the last row then return */
    
    {get DataModified lModified}.
    IF lModified THEN 
    DO:                   
      {get NewRecord cNewRecord}.    
      cMsg = (IF cNewRecord = 'no':U 
              THEN '12':U 
              ELSE IF cNewRecord = 'add':U 
              THEN '13':U 
              ELSE '14':U).
      
      {fnarg showMessage cMsg}.

      RUN applyEntry IN TARGET-PROCEDURE (?).
      RETURN NO-APPLY.
    END.

    {get BrowseHandle hBrowse}.
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
    
    {get DataSource hDataSource}.
    
    IF VALID-HANDLE(hdataSource) THEN
    DO:
     /* Traditionally the browser just used run dataAvailable from the events,
        but this is now in a super-procedure and the sbo need to know the
        target, so we subscribe the source temporarily. */ 
      SUBSCRIBE PROCEDURE hDataSource TO 'DataAvailable':U IN TARGET-PROCEDURE.    
      PUBLISH 'dataAvailable':U FROM TARGET-PROCEDURE("DIFFERENT":U). 
      UNSUBSCRIBE PROCEDURE hDataSource TO 'DataAvailable':U IN TARGET-PROCEDURE.    
    END.

    IF VALID-HANDLE(hFocus) THEN        
      IF hFocus:PARENT = hBrowse:HANDLE THEN      
        RUN applyCellEntry IN TARGET-PROCEDURE
                           (IF KEYFUNCTION(KEYCODE(LAST-EVENT:LABEL)) = "TAB":U 
                            THEN ? 
                            ELSE hFocus:Name).    
  END.
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
  DEFINE VARIABLE lQuery       AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE lModified    AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE cNewRecord   AS CHARACTER NO-UNDO. 
  DEFINE VARIABLE hCell        AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hCellEntry   AS HANDLE    NO-UNDO.  
  DEFINE VARIABLE iCount       AS INTEGER   NO-UNDO.
  DEFINE VARIABLE iFirstRowNum AS INTEGER   NO-UNDO.
  DEFINE VARIABLE hBrowse      AS HANDLE    NO-UNDO.
  DEFINE VARIABLE cMsg         AS CHARACTER NO-UNDO.
  
  /* If this object is browsing a DataObject query, then when we scroll 
     to the end, see if there are more rows in the database query 
     to be transferred to the RowObject query. */
  {get QueryObject lQuery}.
  IF NOT lQuery THEN
  DO:
    iFirstRowNum = DYNAMIC-FUNCTION('linkProperty':U IN TARGET-PROCEDURE,
                                   INPUT 'DATA-SOURCE':U,
                                   INPUT 'FirstRowNum':U).
    IF iFirstRowNum NE ? THEN RETURN. /* If we have already fetched the first row then return */
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

    PUBLISH 'fetchBatch':U FROM TARGET-PROCEDURE (no). /* no -- move backwards */
      
    RUN fetchDataSet IN TARGET-PROCEDURE ('BatchEnd':U).      
    
    hBrowse:SET-REPOSITIONED-ROW (hBrowse:DOWN,"CONDITIONAL":U). 
    
    /* Empty list of rowids in rowDisplay if scrollRemote is yes 
      (avoid bfget field to large error) */
    {set VisibleRowReset TRUE}.
    
    {get DataSource hDataSource}.
    
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
    
 END. /* not lQuery*/

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
            case when it is a true user event, but APPLY 'END' is also the only 
            way to make the browse respond to a fetchLast in the DataSource. 
            In the latter case QueryPosition is already set in the datasource 
            and can thus be used to avoid an extra (or endless..) loop.
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hBrowse   AS HANDLE     NO-UNDO.
  DEFINE VARIABLE lQuery    AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cQueryPos AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hSource   AS HANDLE     NO-UNDO.

  {get Browsehandle hBrowse}.

  hBrowse:REFRESHABLE = NO.
  {get QueryObject lQuery}.
  IF lQuery THEN
  DO:
    {get QueryPosition cQueryPos}.
    IF LOOKUP(cQueryPos,'LastRecord,OnlyRecord':U) = 0 THEN
      RUN fetchLast IN TARGET-PROCEDURE.   
  END.
  ELSE DO:
    {get DataSource hSource}.
    IF VALID-HANDLE(hSource) THEN
    DO:
      {get QueryPosition cQueryPos hSource}.
      IF LOOKUP(cQueryPos,'LastRecord,OnlyRecord':U) = 0 THEN
      DO:
        /* The SBO fetchLast need to know who this is */
        ghTargetProcedure = TARGET-PROCEDURE.
        RUN fetchLast IN hSource.
        ghTargetProcedure = ?.
      END.
    END.
  END.   
  hBrowse:REFRESHABLE = YES.  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-onHome) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE onHome Procedure 
PROCEDURE onHome :
/*------------------------------------------------------------------------------
   Purpose:  Event handler for the 'HOME' event    
Parameters:  <none>
     Notes: This event need to call fetchFirst in the DataSource for the normal 
            case when it is a true user event, but APPLY 'HOME' is also the only 
            way to make the browse respond to a fetchFirst in the DataSource. 
            In the latter case QueryPosition is already set in the datasource 
            and can thus be used to avoid an extra (or endless..) loop.
------------------------------------------------------------------------------*/

  DEFINE VARIABLE hBrowse   AS HANDLE     NO-UNDO.
  DEFINE VARIABLE lQuery    AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cQueryPos AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hSource   AS HANDLE     NO-UNDO.

  {get Browsehandle hBrowse}.
  hBrowse:REFRESHABLE = NO.
  {get QueryObject lQuery}.
  IF lQuery THEN
  DO:
    {get QueryPosition cQueryPos}.
    IF LOOKUP(cQueryPos,'FirstRecord,OnlyRecord':U) = 0 THEN
      RUN fetchFirst IN TARGET-PROCEDURE.   
  END.
  ELSE DO:
    {get DataSource hSource}.
    IF VALID-HANDLE(hSource) THEN
    DO:
      {get QueryPosition cQueryPos hSource}.
      IF LOOKUP(cQueryPos,'FirstRecord,OnlyRecord':U) = 0 THEN
      DO:
        /* The SBO fetchFirst need to know who this is */
        ghTargetProcedure = TARGET-PROCEDURE.
        RUN fetchFirst IN hSource.
        ghTargetProcedure = ?.
      END.
    END.
  END.   
  hBrowse:REFRESHABLE = YES.  
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
  DEFINE VARIABLE cRowident   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hRowObject  AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hQuery      AS HANDLE     NO-UNDO.
  DEFINE VARIABLE lQuery      AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cNewRecord  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hDataSource AS HANDLE     NO-UNDO.

  {get BrowseHandle hBrowse}.
  IF NOT VALID-HANDLE(hBrowse) THEN
    RETURN NO-APPLY.

  {get NewRecord cNewRecord}.
  IF cNewRecord = 'NO':U THEN
  DO:
    ASSIGN
      hQuery     = hBrowse:QUERY
      hRowObject = hQuery:GET-BUFFER-HANDLE(1).

    {get RowIdent cRowident}.
    IF ENTRY(1,cRowident) <> STRING(hRowObject:ROWID) THEN
    DO:
      {get QueryObject lQuery}.
      IF lQuery THEN  /* Browser has its own dbquery */
        RUN dataAvailable ("VALUE-CHANGED":U). 
      ELSE DO:
        {get DataSource hDataSource}.
        /* Traditionally the browser just used run dataAvailable from the events,
           but this is now in a super-procedure and the sbo need to know the
           target, so we subscribe the source temporarily.  */ 
        SUBSCRIBE PROCEDURE hDataSource TO 'DataAvailable':U IN TARGET-PROCEDURE.    
        PUBLISH 'dataAvailable':U FROM TARGET-PROCEDURE("DIFFERENT":U). 
        UNSUBSCRIBE PROCEDURE hDataSource TO 'DataAvailable':U IN TARGET-PROCEDURE.    
      END.
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

  {get ObjectName cBrowseName}.
  {get ContainerSource hContainerSource}.

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
       INPUT NO,
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

&IF DEFINED(EXCLUDE-resetRecord) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE resetRecord Procedure 
PROCEDURE resetRecord :
/*------------------------------------------------------------------------------
  Purpose:     SmartDataBrowser version of resetRecord.
               Redisplays the original field values retrieved from the 
               Data Object or directly from the query associated with
               the SmartDataBrowser.
  Parameters:  <none>
  Notes:       Invoked when the Reset button is pressed on an Update SmartPanel.
------------------------------------------------------------------------------*/

  DEFINE VARIABLE lSelfQuery AS LOGICAL NO-UNDO.

  {get QueryObject lSelfQuery}.
  IF NOT lSelfQuery THEN
    RUN SUPER.
  ELSE DO:  
      RUN displayFields IN TARGET-PROCEDURE (?).
      {set DataModified ?}.
      PUBLISH 'resetRecord':U FROM TARGET-PROCEDURE.  /* In case GroupAssign */
      RUN applyEntry IN TARGET-PROCEDURE (?).
  END.
  
  RETURN.
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

DEFINE VARIABLE cBaseQuery             AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cBrowseName            AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cContainerName         AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cCurrentSort           AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cDataSourceName        AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cProfileKey            AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cRowIdent              AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cSortColumn            AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cSourceNames           AS CHARACTER  NO-UNDO.
DEFINE VARIABLE hBrowse                AS HANDLE     NO-UNDO.
DEFINE VARIABLE hContainerSource       AS HANDLE     NO-UNDO.
DEFINE VARIABLE hDataSource            AS HANDLE     NO-UNDO.
DEFINE VARIABLE iByPos                 AS INTEGER    NO-UNDO.
DEFINE VARIABLE lDataSourceInitialized AS LOGICAL    NO-UNDO.
DEFINE VARIABLE lInitialized           AS LOGICAL    NO-UNDO.
DEFINE VARIABLE lProfileExists         AS LOGICAL    NO-UNDO.
DEFINE VARIABLE rID                    AS ROWID      NO-UNDO.

  {get ObjectName cBrowseName}.
  {get ContainerSource hContainerSource}.
  {get ObjectInitialized lInitialized}.

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
           INPUT NO,
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

  {get DataSource hDataSource}.
  {get ObjectName cDataSourceName hDataSource}.
  {get DataSourceNames cSourceNames}.
  
  /* The SBO does not have a sort API, so if SourceNames is defined we need to 
     get the handle of the actual Source */
  IF (cSourceNames <> ? AND cSourceNames <> '':U) AND
      (cSourceNames NE cDataSourceName) THEN
     hDataSource = {fnarg DataObjectHandle cSourceNames hDataSource}. 

  /* If a profile does not exist and this is not being called from 
     initializeObject then the sort column needs to be reset from the 
     default sort criteria of the SDO's base query */
  IF NOT lProfileExists AND lInitialized THEN
  DO:
    {get BaseQuery cBaseQuery hDataSource}.

    ASSIGN cBaseQuery  = REPLACE(cBaseQuery, CHR(10), " ":U)
           cBaseQuery  = REPLACE(cBaseQuery, CHR(13), " ":U)
           iByPos      = INDEX(cBaseQuery," BY ":U) + 3
           cSortColumn = IF iByPos > 3
                         /* trim away blanks and period and remove indexed-reposition */
                         THEN REPLACE(TRIM(SUBSTR(cBaseQuery,iByPos)," .":U),' INDEXED-REPOSITION':U, '':U)
                         ELSE "":U.
  END.  /* if profile doesn't exist and browse initialized */

  IF VALID-HANDLE(hDataSource) THEN
  DO:
    {get QuerySort cCurrentSort hDataSource}.
    /* The sort column could be a column that has been renamed in the SDO so
       we need to get the actual field name by invoking columnDbColumn.  
       This qualifies the sort column with the table name.  Since the 
       sort column can get qualified in this way, it could be stored that 
       way in a profile and reset here.  So if the sort column is
       already qualified, we do not invoke columnDbColumn for it unless
       it is qualified with RowObject.  */
    IF cSortColumn NE "":U AND 
       (NUM-ENTRIES(cSortColumn,".":U) = 1 OR 
       (NUM-ENTRIES(cSortColumn,".":U) = 2 AND ENTRY(1, cSortColumn,".":U) = "RowObject":U)) THEN
        cSortColumn = {fnarg columnDbColumn cSortColumn hDataSource}.
    DYNAMIC-FUNCTION("setQuerySort" IN hDataSource, cSortColumn). 
    {get ObjectInitialized lDataSourceInitialized hDataSource}.
        
    IF lDataSourceInitialized THEN 
    DO:  
        IF cCurrentSort <> cSortColumn THEN /* Only reopen the query if the sort column has changed */
        DO:
            /* Get the record we need to reposition to */
            cRowident = DYNAMIC-FUNCTION('getRowIdent':U IN hDataSource) NO-ERROR.
        
            {get BrowseHandle hBrowse}.
            hBrowse:REFRESHABLE = NO.
                
            /* Reopen query and reposition to current rowid */
            DYNAMIC-FUNCTION('openQuery' IN hDataSource).
            IF cRowIdent <> ? AND cRowIdent <> "":U THEN
                DYNAMIC-FUNCTION('fetchRowIdent' IN hDataSource, cRowIdent, '':U) NO-ERROR.
    
            hBrowse:REFRESHABLE = YES.
        END.  /* if sort column changed */
    END.  /* data source initialized */    
  END. /* valid-handle(hSource)*/

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
  
  
  /* If the width is getting smaller, do the browse first else the frame */
  IF pd_width < hBrowse:WIDTH THEN
    ASSIGN hBrowse:WIDTH = pd_width - (hBrowse:COLUMN - 1) WHEN NOT otherWidget
           hFrame:WIDTH  = MAX(pd_width,dSearchSize)       NO-ERROR.
  ELSE
    ASSIGN hFrame:WIDTH  = MAX(pd_width,dSearchSize)
           hBrowse:WIDTH = pd_width - (hBrowse:COLUMN - 1) WHEN NOT otherWidget
       NO-ERROR.           
  
  ASSIGN hBrowse:HEIGHT = pd_height - (hBrowse:ROW - 1) WHEN NOT otherWidget NO-ERROR.
  /* Error 6422 is given because the browse requires minimum 2 rows in viewport.*/
  IF ERROR-STATUS:ERROR AND ERROR-STATUS:GET-NUMBER(1) = 6422 THEN
  DO:
    /* Make the browse as low as allowed */
    hBrowse:DOWN = 2.
    pd_Height = hBrowse:HEIGHT + (hBrowse:ROW - 1).
  END.
  hFrame:HEIGHT  = pd_height  NO-ERROR.
  
  hBrowse:SET-REPOSITIONED-ROW (hBrowse:DOWN,"CONDITIONAL":U).
  
  /* Fix for issue 5633 (second part) */
  IF VALID-HANDLE(hRO) THEN 
    IF rCurRowid <> ? THEN 
      IF rCurRowid <> hRO:ROWID THEN     /* IF a valid buffer existed in the beginning... */
        hRO:FIND-BY-ROWID (rCurRowid, NO-LOCK). /* ...attempt to find saved */

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
    {get QueryRowObject hBuffer}.
    {get VisibleRowids cRowids}.
    {get VisibleRowReset lReset}.
    
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
    
    {set VisibleRowReset lReset}.
    {set VisibleRowids cRowids}.
  END.

END PROCEDURE.

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
  
  /* First we must capture the keystroke which fired the trigger. */
  APPLY LAST-KEY.
  
  {get DataSource hSource}.
  {get SearchField cSearchField}.
  
  DYNAMIC-FUNCTION('findRowWhere':U IN hSource,
                    cSearchField, 
                    SELF:SCREEN-VALUE,
                    '>=':U).
  
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

DEFINE VARIABLE hBrowse AS HANDLE NO-UNDO.

  {get BrowseHandle hBrowse}.
  hBrowse:VISIBLE = TRUE.

  /* Added 3 as 2 has been reported to cause problems ???? */ 
  RUN resizeObject IN TARGET-PROCEDURE ((piNumDown * (hBrowse:ROW-HEIGHT + 0.2)) + 3,
                                        hBrowse:WIDTH).
  /* There is a core bug where if down is already set to the number we are trying to 
     set it to then setting down doesn't have any affect on height - which is what
     we need to have adjusted to get rid of any extra space at the bottom.  So when 
     down is equal to what we are about to set it to then we need to set it twice for
     it to have the correct affect. */
  IF hBrowse:DOWN = piNumDown THEN hBrowse:DOWN = piNumDown - 1 NO-ERROR.
  hBrowse:DOWN = piNumDown NO-ERROR.
  RUN resizeObject IN TARGET-PROCEDURE (hBrowse:ROW - 1 + hBrowse:HEIGHT, hBrowse:WIDTH).

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

  {get MovableHandle hMovableItem}.
  {get SortableHandle hSortableItem}.

  {set ColumnsSortable hSortableItem:CHECKED}.
  IF hSortableItem:CHECKED AND hMovableItem:CHECKED THEN
  DO:
    hMovableItem:CHECKED = FALSE.   
    {set ColumnsMovable FALSE}.
  END.  /* if both now checked */

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
  
  hColumn = phBrowse:CURRENT-COLUMN.

  {set SORT hColumn:NAME}.  
  
  APPLY 'END-SEARCH':U TO phBrowse.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-toolbar) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE toolbar Procedure 
PROCEDURE toolbar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
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
  WHEN "Comments" THEN DO:
      {get ContainerSource hContainerSource}.
      {get ContainerHandle hWindowHandle hContainerSource}.        
      {get DataSource hDataSource}.

      /* If we are linked to an SBO then retrieve the SDO handle */
      IF VALID-HANDLE(hDataSource)
      AND {fnarg instanceOf 'SBO':U hDataSource} THEN
      DO:                                   /* we have the SBO, get the SDO */
        {get DataSourceNames cDataSource}.
        hDataSource = {fnarg dataObjectHandle cDataSource hDataSource}.
      END.

      IF VALID-HANDLE(gshSessionManager) THEN
        RUN launchContainer IN gshSessionManager (                                                    
            INPUT "gsmcmobjcw",     /* pcObjectFileName       */
            INPUT "",               /* pcPhysicalName         */
            INPUT "",               /* pcLogicalName          */
            INPUT TRUE,             /* plOnceOnly             */
            INPUT "",               /* pcInstanceAttributes   */
            INPUT "",               /* pcChildDataKey         */
            INPUT STRING(hDataSource), /* pcRunAttribute         */
            INPUT "",               /* container mode         */
            INPUT hWindowHandle,    /* phParentWindow         */
            INPUT hContainerSource, /* phParentProcedure      */
            INPUT hContainerSource,                /* phObjectProcedure      */
            OUTPUT hNewObject,      /* phProcedureHandle      */
            OUTPUT cProcedureType   /* pcProcedureType        */       
        ).       

  END.

  WHEN "Export":U  THEN DO:
      {get DataSource hDataSource}.
      {get DisplayedFields cFields}.            

      ASSIGN 
        cMaxRecords = "500":U
        cMessage = "About to transfer selected data into Excel." + CHR(10) + CHR(10) +
                   "This may take a long time if the data set is large and has not been filtered." + CHR(10) +
                   "You may specify the maximum records to return for large data sets." + CHR(10)
                   .
      IF VALID-HANDLE(gshSessionManager) THEN
        RUN askquestion IN gshSessionManager (INPUT cMessage,
                       INPUT "&Browser Fields,&All Fields,&Cancel":U,
                       INPUT "&Browser Fields":U,
                       INPUT "&Cancel":U,
                       INPUT "Transfer to Excel",
                       INPUT "Integer":U,
                       INPUT ">>>>>>>9":U,
                       INPUT-OUTPUT cMaxRecords,
                       OUTPUT cButton).
      IF cButton = "&All Fields":U THEN
        ASSIGN cFields = "":U.
      ELSE DO:
          /* We already have all the browser field names, but we may have them in the wrong order. *
           * The user may have moved columns, so make sure they're ordered correctly.              */
          {get browseHandle hBrowse}.
          IF VALID-HANDLE(hBrowse) THEN
              do-blk:
              DO iBrowsePosition = 1 TO hBrowse:NUM-COLUMNS:
                  ASSIGN hColumn         = hBrowse:GET-BROWSE-COLUMN(iBrowsePosition)
                         iFieldsPosition = LOOKUP(hColumn:BUFFER-FIELD:NAME, cFields)
                         NO-ERROR.

                  IF ERROR-STATUS:ERROR
                  OR iFieldsPosition = 0
                  OR iFieldsPosition = ? THEN
                      NEXT do-blk.

                  /* If the field is out of place, swap it with the field currently in its place */
                  IF iBrowsePosition <> iFieldsPosition THEN
                      ASSIGN cStoreFieldName                 = ENTRY(iBrowsePosition, cFields)
                             ENTRY(iBrowsePosition, cFields) = hColumn:BUFFER-FIELD:NAME
                             ENTRY(iFieldsPosition, cFields) = cStoreFieldName.
              END.
      END.

      IF cButton <> "&Cancel":U THEN
        RUN transferToExcel IN hDataSource (INPUT cFields, INPUT NO, INPUT YES, INPUT INTEGER(cMaxRecords)).
  END.

  WHEN "Preview":u  THEN DO:
      {get DataSource hDataSource}.
      {get DisplayedFields cFields}.            

      ASSIGN 
        cMaxRecords = "500":U
        cMessage = "About to transfer selected data into a Report Preview Window"
                 + CHR(10)
                 + CHR(10)
                 + "This may take a long time if the data set is large and has not been filtered."
                 + CHR(10)
                 + "You may specify the maximum records to return for large data sets."
                 + CHR(10)
                 + CHR(10)
                 + 'NOTE : The report will only display the fields that do not exceed the maximum width of the report layout.'
                 + CHR(10)
                 .
      IF VALID-HANDLE(gshSessionManager) THEN
        RUN askquestion IN gshSessionManager (INPUT cMessage,
                       INPUT "&Browser Fields,&All Fields,&Cancel":U,
                       INPUT "&Browser Fields":U,
                       INPUT "&Cancel":U,
                       INPUT "Report Preview",
                       INPUT "Integer":U,
                       INPUT ">>>>>>>9":U,
                       INPUT-OUTPUT cMaxRecords,
                       OUTPUT cButton).
      IF cButton = "&All Fields":U THEN
        ASSIGN cFields = "":U.
      IF cButton <> "&Cancel":U THEN
        RUN printToCrystal IN hDataSource (INPUT cFields, INPUT NO, INPUT INTEGER(cMaxRecords)).
  END.

  WHEN "Filter" OR WHEN "Find" THEN DO:
      
      {get ContainerSource hContainerSource}.
      {get ContainerHandle hWindowHandle hContainerSource}.              
      {get DataSource hDataSource}.
     
      IF VALID-HANDLE(hDataSource) THEN DO:
          IF VALID-HANDLE(gshSessionManager) THEN
            RUN launchContainer IN gshSessionManager (                                                    
                INPUT "",                       /* pcObjectFileName     */
                INPUT "af/sup2/afsdofiltw.w",   /* pcPhysicalName       */
                INPUT "",                       /* pcLogicalName        */
                INPUT TRUE,                     /* plOnceOnly           */
                INPUT "",                       /* pcInstanceAttributes */
                INPUT "",                       /* pcChildDataKey       */
                INPUT "",                       /* pcRunAttribute       */
                INPUT "",                       /* container mode    */
                INPUT hWindowHandle,            /* phParentWindow       */
                INPUT hContainerSource,         /* phParentProcedure    */
                INPUT ?,                        /* phObjectProcedure    */
                OUTPUT hFilterWindow,           /* phProcedureHandle    */
                OUTPUT cProcedureType           /* pcProcedureType      */       
            ).         
              
          IF VALID-HANDLE(hFilterWindow) THEN DO:        
              RUN initializeObject IN hFilterWindow.
              RUN setDataSourceHandle IN hFilterWindow (pcValue, hDataSource, TARGET-PROCEDURE).
          END.
      END.
  END.

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
  END.

 WHEN "audit" THEN DO:
      {get ContainerSource hContainerSource}.
      {get ContainerHandle hWindowHandle hContainerSource}.        
      {get DataSource hDataSource}.
      
      /* If we are linked to an SBO then retrieve the SDO handle */
      IF VALID-HANDLE(hDataSource)
      AND {fnarg instanceOf 'SBO':U hDataSource} THEN
      DO:                                   /* we have the SBO, get the SDO */
        {get DataSourceNames cDataSource}.
        hDataSource = {fnarg dataObjectHandle cDataSource hDataSource}.
      END.
      
      IF VALID-HANDLE(gshSessionManager) THEN
        RUN launchContainer IN gshSessionManager (                                                    
            INPUT "gstadobjcw",     /* pcObjectFileName       */
            INPUT "",               /* pcPhysicalName         */
            INPUT "",               /* pcLogicalName          */
            INPUT TRUE,             /* plOnceOnly             */
            INPUT "",               /* pcInstanceAttributes   */
            INPUT "",               /* pcChildDataKey         */
            INPUT STRING(hDataSource), /* pcRunAttribute         */
            INPUT "",               /* container mode         */
            INPUT hWindowHandle,    /* phParentWindow         */
            INPUT hContainerSource, /* phParentProcedure      */
            INPUT hContainerSource,                /* phObjectProcedure      */
            OUTPUT hNewObject,      /* phProcedureHandle      */
            OUTPUT cProcedureType   /* pcProcedureType        */       
        ).       
  END.
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

  {get ObjectName cBrowseName}.
  {get BrowseHandle hBrowse}.
  {get ContainerSource hContainerSource}.

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
           INPUT NO,
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
               If the SmartDataBrowser is browsing a DataObject query and not 
               its own, this sets the RowIdent property to the RowObject 
               ROWID, because the DataObject will be looking for it to 
               identify which row is being updated. 
               Otherwise the RowIndent property is set to the ROWID(s)
               of the database record(s).
  Parameters:  <none>
------------------------------------------------------------------------------*/

  DEFINE VARIABLE hBrowse    AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hQuery     AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hParent    AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hBuffer    AS HANDLE    NO-UNDO.
  DEFINE VARIABLE iBuffer    AS INTEGER   NO-UNDO.
  DEFINE VARIABLE cRowIdent  AS CHARACTER NO-UNDO INIT "":U.
  DEFINE VARIABLE cNewRecord AS CHARACTER NO-UNDO.
  DEFINE VARIABLE lQueryObj  AS LOGICAL   NO-UNDO.
  
  {get BrowseHandle hBrowse}.
  hQuery = hBrowse:QUERY.
  {get NewRecord cNewRecord}.   /* save to check at very end */
  {get QueryObject lQueryObj}.
  IF NOT lQueryObj THEN
    hBuffer = hQuery:GET-BUFFER-HANDLE(1).
  ELSE DO:
    /* If it's a new record (Add/Copy) then RowIdent will be set correctly. */
    IF cNewRecord = 'No':U THEN   /* RowIdent is the db ROWIDs. */
    DO:
      DO iBuffer = 1 TO hQuery:NUM-BUFFERS:
        hBuffer = hQuery:GET-BUFFER-HANDLE(iBuffer).
        cRowIdent = cRowIdent + ",":U +  /* Leave first element blank - no TT */
          IF hBuffer:AVAILABLE THEN STRING(hBuffer:ROWID) ELSE "":U.
      END.    /* END DO iBuffer */
      {set RowIdent cRowIdent}.
    END.      /* END DO IF not NewRecord */
  END.      /* END DO QueryObject NE No */
  
  RUN SUPER.
  IF RETURN-VALUE = "ADM-ERROR":U THEN DO:
    ASSIGN hParent = FOCUS:PARENT WHEN VALID-HANDLE(FOCUS).
    IF hParent NE hBrowse THEN RUN applyEntry IN TARGET-PROCEDURE (?).
    RETURN "ADM-ERROR":U.
  END.
  
  /* If this was an Add or Copy, then re-open the local db query if 
     there is one. */
  ELSE IF lQueryObj AND cNewRecord NE 'No':U THEN
  DO:
    {fn openQuery}.
    APPLY "END":U TO hBrowse.  /* NOTE: Presumes new record is at the end. */
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

  {get ObjectName cBrowseName}.
  {get ContainerSource hContainerSource}.
  {get DataSource hDataSource}.

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
           INPUT NO,
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
      {get BrowseHandle hBrowse}.
      {get SearchHandle hSearchField}.
      {get DataModified lModified}. 
      {get NewRecord cNewRecord}.   
      
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
        {get BrowseHandle hBrowse}.
        {get SearchHandle hSearchField}.
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
  DEFINE VARIABLE lDataLinksEnabled     AS LOGICAL      NO-UNDO.
  DEFINE VARIABLE cWindowTitleField     AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE cWindowTitleColumn    AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE cWindowTitleValue     AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE cWindowName           AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE cWindowTitle          AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE hContainerHandle      AS HANDLE       NO-UNDO.
  DEFINE VARIABLE hSourceSource         AS HANDLE       NO-UNDO.
  DEFINE VARIABLE hContainerSource      AS HANDLE       NO-UNDO.


  {get DataSource hSource}.
  IF  VALID-HANDLE(hSource) THEN
      {get DataSource hSourceSource hSource}.

  /* get window title if required */
  {get WindowTitleField cWindowTitleField}.

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

&IF DEFINED(EXCLUDE-valueChanged) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE valueChanged Procedure 
PROCEDURE valueChanged :
/*------------------------------------------------------------------------------
     Purpose: Event handler for VALUE-CHANGED of browse anywhere event.
  Parameters: <none> 
       Notes: Sets DataModified, which is the all important flag that tells 
              that data need to be saved.
          -   This is NOT the VALUE-CHANGED event handler of the browse. Its 
              event handler is onValueChanged. 
              They have nothing in common as the browse's event triggers from 
              a user change of record while this event is for changes to 
              values in columns.      
-----------------------------------------------------------------------------*/
  DEFINE VARIABLE cDisplayedFields AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lEnabled         AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lModified        AS LOGICAL    NO-UNDO.

  {get DisplayedFields cDisplayedFields}.
  /* Ignore the event if it wasn't a browse field. */
  IF LOOKUP(FOCUS:NAME, cDisplayedFields) NE 0 THEN 
  DO:
    {get FieldsEnabled lEnabled}.
    IF lEnabled THEN    /* Only if browse enabled for input. */
    DO:             
      {get DataModified lModified}.
      IF NOT lModified THEN   /* Don't send the updateState event more than once. */
        {set DataModified yes}.
    END.  /* END DO IF lResult */
  END.    /* END DO IF LOOKUP */
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
             - The browser implicit sets the buffer to its currently selected 
               row when it is visualized. This may cause problems if the 
               DataSource is being manipulated by another object; An 
               update-target may have called AddRow in the DataSource, which 
               creates a RowObject while the browse still has the old row
               selected.  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE iNumDown    AS INTEGER   NO-UNDO.
  DEFINE VARIABLE rRowid      AS ROWID     NO-UNDO.
  DEFINE VARIABLE hDataSource AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hDataHandle AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hRowObject  AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hBrowse     AS HANDLE    NO-UNDO.

  DEFINE VARIABLE lTargetNotSet AS LOGICAL NO-UNDO.

  /* NEW FOR 9.1B: stash the TARGET-PROCEDURE handle away so the
     Data-Source can identify it if it's an SBO.     
     Currently we want to avoid setting it to unknown when this is called 
     from a procedure that already has set ghTargetProcedure.   */  
  ASSIGN 
    lTargetNotSet     = ghTargetProcedure <> TARGET-PROCEDURE 
    ghTargetProcedure = TARGET-PROCEDURE. 

  {get DataSource hDataSource}.
  {get BrowseHandle hBrowse}.
  
  IF lTargetNotSet THEN
    ghTargetProcedure = ?.

  /* Log the DataSource's current rowid for comparison further down. 
     Implicit browser behavior when viewing a hidden browse may change it  */
  IF VALID-HANDLE(hDataSource) THEN
  DO:
    /* Use datahandle to ensure that SBOs returns correct info. */   
    {get DataHandle hDataHandle hDataSource} NO-ERROR.
    IF VALID-HANDLE(hDataHandle) THEN
    DO:
      ASSIGN
        hRowObject = hDataHandle:GET-BUFFER-HANDLE(1) 
        rRowid     = hRowObject:ROWID.
    END. /* valid datahandle*/
  END. /* valid datasource */
   
  RUN SUPER.
  
  /* Reset buffer in case the visualization changed it */
  IF  VALID-HANDLE(hDataSource) 
  AND VALID-HANDLE(hRowObject) 
  AND rRowid <> ? 
  AND rRowid <> hRowObject:ROWID THEN      
    hRowObject:FIND-BY-ROWID(rRowid) NO-ERROR.   
    
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
  hQuery = dynamic-function("getQueryHandle":U IN TARGET-PROCEDURE) NO-ERROR.
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
  ASSIGN ghProp = WIDGET-HANDLE(ENTRY(1, TARGET-PROCEDURE:ADM-DATA, CHR(1)))
         ghProp = ghProp:BUFFER-FIELD('ActionEvent':U).
  
  RETURN ghProp:BUFFER-VALUE.

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
  ASSIGN ghProp = WIDGET-HANDLE(ENTRY(1, TARGET-PROCEDURE:ADM-DATA, CHR(1)))
         ghProp = ghProp:BUFFER-FIELD('ColumnsMovable':U).
  
  RETURN ghProp:BUFFER-VALUE.

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
  ASSIGN ghProp = WIDGET-HANDLE(ENTRY(1, TARGET-PROCEDURE:ADM-DATA, CHR(1)))
         ghProp = ghProp:BUFFER-FIELD('ColumnsSortable':U).
  
  RETURN ghProp:BUFFER-VALUE.

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
            In the case where the SmartDataBrowser has its own db query, 
            this function will return Unknown.
            Used internally.
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cSignature AS CHARACTER NO-UNDO INIT "":U.
  DEFINE VARIABLE iCol       AS INTEGER   NO-UNDO.
  DEFINE VARIABLE hRowObject AS HANDLE    NO-UNDO.
  DEFINE VARIABLE cDataType  AS CHARACTER NO-UNDO.
  DEFINE VARIABLE hColumn    AS HANDLE    NO-UNDO.
  DEFINE VARIABLE lQueryObj  AS LOGICAL   NO-UNDO.
  
  {get QueryObject lQueryObj}. 
  IF lQueryObj THEN
    RETURN ?.

  {get RowObject hRowObject} NO-ERROR.
  IF VALID-HANDLE(hRowObject) THEN
  DO iCol = 1 TO hRowObject:NUM-FIELDS:
    hColumn = hRowObject:BUFFER-FIELD(iCol).
    cDataType = hColumn:DATA-TYPE.
    cSignature = cSignature +
      (IF     cDataType = 'CHARACTER':U THEN '1':U
      ELSE IF cDataType = 'DATE':U      THEN '2':U
      ELSE IF cDataType = 'LOGICAL':U   THEN '3':U
      ELSE IF cDataType = 'INTEGER':U   THEN '4':U
      ELSE IF cDataType = 'DECIMAL':U   THEN '5':U
      /* Note: Float/Double reserved for possible future use. */
      ELSE IF cDataType = 'FLOAT':U OR 
              cDataType = 'DOUBLE':U    THEN '6':U
      ELSE IF cDataType = 'RECID':U     THEN '7':U
      ELSE IF cDataType = 'RAW':U       THEN '8':U
      ELSE IF cDataType = 'ROWID':U     THEN '9':U  
      ELSE '0':U).
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

&IF DEFINED(EXCLUDE-getPrintPreviewActive) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getPrintPreviewActive Procedure 
FUNCTION getPrintPreviewActive RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose: Returns true if the print preview functionality is active
    Notes: Ensure check is only done once in session, then use value of
           property from then on.
------------------------------------------------------------------------------*/

  DEFINE VARIABLE lPreviewActive        AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE hApplication          AS COM-HANDLE NO-UNDO.

  DEFINE VARIABLE cRegReportDesign      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cKeyReportDesign      AS CHARACTER  NO-UNDO.

  &SCOPED-DEFINE xpPrintPreviewActive 
  {get PrintPreviewActive lPreviewActive}.
  &UNDEFINE xpPrintPreviewActive 

  /* not checked yet */
  IF lPreviewActive = ?
  THEN DO:

    /* Get the values for Crystal Reports from the Registry */
    ASSIGN
      cKeyReportDesign  = "CrystalRuntime.Application"
      cRegReportDesign  = "CrystalRuntime.Application.7" /* Default Value */ 
      .

    /* cRegReportDesign */
    LOAD cKeyReportDesign BASE-KEY "HKEY_CLASSES_ROOT":U NO-ERROR.
    IF NOT ERROR-STATUS:ERROR
    THEN DO:
      USE cKeyReportDesign.
      GET-KEY-VALUE SECTION "CurVer":U KEY DEFAULT VALUE cRegReportDesign.
    END.
    UNLOAD cKeyReportDesign NO-ERROR.

    CREATE VALUE(cRegReportDesign) hApplication NO-ERROR.
    ASSIGN lPreviewActive = NOT ERROR-STATUS:ERROR.
    RELEASE OBJECT hApplication NO-ERROR.
    ASSIGN hApplication = ?.
    ERROR-STATUS:ERROR = NO.

    &SCOPED-DEFINE xpPrintPreviewActive 
    {set PrintPreviewActive lPreviewActive}.
    &UNDEFINE xpPrintPreviewActive 

  END.

  RETURN lPreviewActive.

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

&IF DEFINED(EXCLUDE-getToolbarSource) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getToolbarSource Procedure 
FUNCTION getToolbarSource RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the handle(s) of the object's toolbar-source.
   Params:  <none>
    Notes:   
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cSource   AS CHARACTER NO-UNDO.
  
  {get ToolbarSource cSource}.
  RETURN cSource.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getToolbarSourceEvents) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getToolbarSourceEvents Procedure 
FUNCTION getToolbarSourceEvents RETURNS CHARACTER
  (   ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the list of events to be subscribed to in the
            Toolbar-Source.  
   Params:  <none>
    Notes:             
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cEvents AS CHARACTER NO-UNDO.
  {get ToolbarSourceEvents cEvents}.
  RETURN cEvents.

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

&IF DEFINED(EXCLUDE-hasActiveAudit) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION hasActiveAudit Procedure 
FUNCTION hasActiveAudit RETURNS LOGICAL
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hSource AS HANDLE     NO-UNDO.

  {get DataSource hSource}.
  IF VALID-HANDLE(hSource) THEN
  DO:
    ghTargetProcedure = TARGET-PROCEDURE.
    RETURN {fn hasActiveAudit hSource}.
    ghTargetProcedure = ?.
  END.

  RETURN FALSE. 

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-hasActiveComments) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION hasActiveComments Procedure 
FUNCTION hasActiveComments RETURNS LOGICAL
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hSource AS HANDLE     NO-UNDO.
  
  {get DataSource hSource}.
  IF VALID-HANDLE(hSource) THEN
  DO:
    ghTargetProcedure = TARGET-PROCEDURE.
    RETURN {fn hasActiveComments hSource}.
    ghTargetProcedure = ?.
  END.

  RETURN FALSE. 

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
  DEFINE VARIABLE hBrowse AS HANDLE NO-UNDO.
  {get BrowseHandle hBrowse}.
  
  ASSIGN ghProp = WIDGET-HANDLE(ENTRY(1, TARGET-PROCEDURE:ADM-DATA, CHR(1)))
         ghProp = ghProp:BUFFER-FIELD('ActionEvent':U)
         ghProp:BUFFER-VALUE = pcEvent.
  
  ON 'default-action':U OF hBrowse 
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

  ASSIGN ghProp = WIDGET-HANDLE(ENTRY(1, TARGET-PROCEDURE:ADM-DATA, CHR(1)))
         ghProp = ghProp:BUFFER-FIELD('ColumnsMovable':U)
         ghProp:BUFFER-VALUE = plMovable.

  {get BrowseHandle hBrowse}.
  {get ObjectInitialized lInitialized}.

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

  ASSIGN ghProp = WIDGET-HANDLE(ENTRY(1, TARGET-PROCEDURE:ADM-DATA, CHR(1)))
         ghProp = ghProp:BUFFER-FIELD('ColumnsSortable':U)
         ghProp:BUFFER-VALUE = plSortable.

  {get BrowseHandle hBrowse}.
  {get ObjectInitialized lInitialized}.

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

&IF DEFINED(EXCLUDE-setPrintPreviewActive) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setPrintPreviewActive Procedure 
FUNCTION setPrintPreviewActive RETURNS LOGICAL
  ( lPreviewActive AS LOGICAL ) :
/*------------------------------------------------------------------------------
  Purpose: Set whether print preview functionality is active
    Notes:  
------------------------------------------------------------------------------*/

  &SCOPED-DEFINE xpPrintPreviewActive 
  {set PrintPreviewActive lPreviewActive}.
  &UNDEFINE xpPrintPreviewActive 

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
  Purpose:  Sets the name of a field which can be searched on for repositioning
            the query the browse is attached to.
   Params:  pcField AS CHARACTER -- SmartDataObject Field Name
   Notes:   The field name passed as parameter is the actual field name in 
            the SmartDataObject not the one referenced in the Data Dictionnary.
------------------------------------------------------------------------------*/

  {set SearchField pcField}.
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
  DEFINE VARIABLE cRowIdent                     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSort                         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cTable                        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hBrowse                       AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cSourceNames                  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lSort                         AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cSourceName                   AS CHARACTER  NO-UNDO.

  {get DataSource hSource}.
  {get ObjectName cSourceName hSource}.
  {get DataSourceNames cSourceNames}.
  
  /* The SBO does not have a sort API, so if SourceNames is defined we need to 
     get the handle of the actual Source */
  IF (cSourceNames <> ? AND cSourceNames <> '':U) AND
      (cSourceNames NE cSourceName) THEN
     hSource = {fnarg DataObjectHandle cSourceNames hSource}. 
  
  cRowident = DYNAMIC-FUNCTION('getRowIdent':U IN hSource) NO-ERROR.
  
  IF VALID-HANDLE(hSource) THEN
  DO:
    {get BrowseHandle hBrowse}.
    hBrowse:REFRESHABLE = NO.

    /* see if calculated field and abort of so */
    cTable = DYNAMIC-FUNCTION('columntable':U IN hSource, pcColumnName) NO-ERROR.
    IF cTable <> "":U THEN
    DO:
      /* now we can add our sort phrase */
      cSort = DYNAMIC-FUNCTION("getQuerySort":U IN hSource). 
      /* The sort column could be a column that has been renamed in the SDO so
         we need to get the actual field name by invoking columnDbColumn.   */
      IF pcColumnName NE "":U THEN 
        pcColumnName = {fnarg columnDbColumn pcColumnName hSource}.
      
      IF INDEX(cSort,pcColumnName) > 0 AND INDEX(cSort,"descending":U) = 0 THEN
        DYNAMIC-FUNCTION("setQuerySort":U IN hSource,pcColumnName + " descending":U). 
      ELSE
        DYNAMIC-FUNCTION("setQuerySort":U IN hSource,pcColumnName). 
        
      IF cRowIdent <> ? AND cRowIdent <> "":U THEN
      DO:
        DYNAMIC-FUNCTION('closeQuery':U IN hSource).
        DYNAMIC-FUNCTION('fetchRowIdent':U IN hSource, cRowIdent, '':U) NO-ERROR.
      END.
      ELSE
        /* Reopen query and reposition to current rowid */
        DYNAMIC-FUNCTION('openQuery':U IN hSource).     

      lSort = TRUE.
    END.
    hBrowse:REFRESHABLE = YES.
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

&IF DEFINED(EXCLUDE-setToolbarSource) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setToolbarSource Procedure 
FUNCTION setToolbarSource RETURNS LOGICAL
  ( pcTarget AS CHARACTER) :
/*------------------------------------------------------------------------------
  Purpose:  sets the handle(s) of the object's toolbar-source.
   Params:   
    Notes:   
------------------------------------------------------------------------------*/
  {set ToolbarSource pcTarget}.
  RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setToolbarSourceEvents) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setToolbarSourceEvents Procedure 
FUNCTION setToolbarSourceEvents RETURNS LOGICAL
  ( pcEvents AS CHARACTER  ) :
/*------------------------------------------------------------------------------
  Purpose:  Sets the list of events to be subscribed to in the
            Toolbar-Source.  
   Params:  <none>
    Notes:             
------------------------------------------------------------------------------*/
  {set ToolbarSourceEvents pcEvents}.
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

