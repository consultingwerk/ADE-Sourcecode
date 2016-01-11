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
/*----------------------------------------------------------------------
    File        : select.p
    Purpose     : Super procedure for select class.
    Description : SmartSelection Component
    Syntax      : RUN start-super-proc("adm2/select.p":U).
    
    Author      : Roel Lakenvelt (VCD Software BV)                 Progress 9.0A
    ADM         : 06/23/1999 Progress Software Corp.               Progress 9.1A       
                   Changed to super-procedure that inherits field class.  
                   Added 9.1 widgets and browser support.
    Modified    : July 18, 2000          
------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

&SCOP ADMSuper select.p
&SCOP selectionSeparator CHR(1)
&SCOP refreshKey F5

  /* Custom exclude file */
  {src/adm2/custom/selectexclcustom.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-buildList) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD buildList Procedure 
FUNCTION buildList RETURNS CHARACTER PRIVATE
  (  )  FORWARD.

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

&IF DEFINED(EXCLUDE-destroySelection) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD destroySelection Procedure 
FUNCTION destroySelection RETURNS LOGICAL
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-formattedValue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD formattedValue Procedure 
FUNCTION formattedValue RETURNS CHARACTER
  (pcValue AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getAutoRefresh) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getAutoRefresh Procedure 
FUNCTION getAutoRefresh RETURNS LOGICAL
  ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getBrowseFields) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getBrowseFields Procedure 
FUNCTION getBrowseFields RETURNS CHARACTER
  ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getBrowseTitle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getBrowseTitle Procedure 
FUNCTION getBrowseTitle RETURNS CHARACTER
  ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getCancelBrowseOnExit) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getCancelBrowseOnExit Procedure 
FUNCTION getCancelBrowseOnExit RETURNS LOGICAL
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getChangedEvent) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getChangedEvent Procedure 
FUNCTION getChangedEvent RETURNS CHARACTER
  ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDataSourceFilter) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getDataSourceFilter Procedure 
FUNCTION getDataSourceFilter RETURNS CHARACTER
  ( )  FORWARD.

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

&IF DEFINED(EXCLUDE-getDefineAnyKeyTrigger) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getDefineAnyKeyTrigger Procedure 
FUNCTION getDefineAnyKeyTrigger RETURNS LOGICAL
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDisplayedField) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getDisplayedField Procedure 
FUNCTION getDisplayedField RETURNS CHARACTER
  ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDisplayedFields) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getDisplayedFields Procedure 
FUNCTION getDisplayedFields RETURNS CHARACTER
  ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDisplayValue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getDisplayValue Procedure 
FUNCTION getDisplayValue RETURNS CHARACTER
  ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getEnableOnAdd) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getEnableOnAdd Procedure 
FUNCTION getEnableOnAdd RETURNS LOGICAL
  ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getExitBrowseOnAction) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getExitBrowseOnAction Procedure 
FUNCTION getExitBrowseOnAction RETURNS LOGICAL
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getFormat) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getFormat Procedure 
FUNCTION getFormat RETURNS CHARACTER
  ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getHelpId) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getHelpId Procedure 
FUNCTION getHelpId RETURNS INTEGER
  ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getKeyField) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getKeyField Procedure 
FUNCTION getKeyField RETURNS CHARACTER
  ( )  FORWARD.

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

&IF DEFINED(EXCLUDE-getNumRows) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getNumRows Procedure 
FUNCTION getNumRows RETURNS INTEGER
  ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getOptional) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getOptional Procedure 
FUNCTION getOptional RETURNS LOGICAL
  ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getOptionalBlank) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getOptionalBlank Procedure 
FUNCTION getOptionalBlank RETURNS LOGICAL
  ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getOptionalString) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getOptionalString Procedure 
FUNCTION getOptionalString RETURNS CHARACTER
  ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getRepositionDataSource) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getRepositionDataSource Procedure 
FUNCTION getRepositionDataSource RETURNS LOGICAL
  ( )  FORWARD.

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

&IF DEFINED(EXCLUDE-getStartBrowseKeys) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getStartBrowseKeys Procedure 
FUNCTION getStartBrowseKeys RETURNS CHARACTER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getToolTip) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getToolTip Procedure 
FUNCTION getToolTip RETURNS CHARACTER
  ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getUsePairedList) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getUsePairedList Procedure 
FUNCTION getUsePairedList RETURNS LOGICAL
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getViewAs) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getViewAs Procedure 
FUNCTION getViewAs RETURNS CHARACTER
  ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-repositionDataSource) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD repositionDataSource Procedure 
FUNCTION repositionDataSource RETURNS LOGICAL
  (pcValue AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setAutoRefresh) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setAutoRefresh Procedure 
FUNCTION setAutoRefresh RETURNS LOGICAL
  ( pilAutorefresh AS LOGICAL )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setBrowseFields) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setBrowseFields Procedure 
FUNCTION setBrowseFields RETURNS LOGICAL
  ( picBrowseFields AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setBrowseTitle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setBrowseTitle Procedure 
FUNCTION setBrowseTitle RETURNS LOGICAL
  ( picBrowseTitle AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setCancelBrowseOnExit) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setCancelBrowseOnExit Procedure 
FUNCTION setCancelBrowseOnExit RETURNS LOGICAL
  ( plCancelBrowse AS LOG )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setChangedEvent) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setChangedEvent Procedure 
FUNCTION setChangedEvent RETURNS LOGICAL
  ( picChangedEvent AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setDataSourceFilter) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setDataSourceFilter Procedure 
FUNCTION setDataSourceFilter RETURNS LOGICAL
  ( picDataSourceFilter AS CHARACTER )  FORWARD.

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

&IF DEFINED(EXCLUDE-setDefineAnyKeyTrigger) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setDefineAnyKeyTrigger Procedure 
FUNCTION setDefineAnyKeyTrigger RETURNS LOGICAL
  ( plTrigger AS LOG )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setDisplayedField) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setDisplayedField Procedure 
FUNCTION setDisplayedField RETURNS LOGICAL
  ( picDisplayedField AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setDisplayValue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setDisplayValue Procedure 
FUNCTION setDisplayValue RETURNS LOGICAL
  (pcValue AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setEnableOnAdd) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setEnableOnAdd Procedure 
FUNCTION setEnableOnAdd RETURNS LOGICAL
  ( pilEnableOnAdd AS LOGICAL )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setExitBrowseOnAction) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setExitBrowseOnAction Procedure 
FUNCTION setExitBrowseOnAction RETURNS LOGICAL
  ( plExitBrowse AS LOG )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setFormat) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setFormat Procedure 
FUNCTION setFormat RETURNS LOGICAL
  ( pcFormat AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setHelpId) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setHelpId Procedure 
FUNCTION setHelpId RETURNS LOGICAL
  ( piHelpId AS INTEGER )  FORWARD.

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

&IF DEFINED(EXCLUDE-setLabel) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setLabel Procedure 
FUNCTION setLabel RETURNS LOGICAL
  (pcLabel AS CHARACTER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setNumRows) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setNumRows Procedure 
FUNCTION setNumRows RETURNS LOGICAL
  ( piNumRows AS INTEGER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setOptional) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setOptional Procedure 
FUNCTION setOptional RETURNS LOGICAL
  ( pilOptional AS LOGICAL )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setOptionalBlank) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setOptionalBlank Procedure 
FUNCTION setOptionalBlank RETURNS LOGICAL
  ( plOptionalBlank AS LOGICAL )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setOptionalString) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setOptionalString Procedure 
FUNCTION setOptionalString RETURNS LOGICAL
  ( picOptionalString AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setRepositionDataSource) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setRepositionDataSource Procedure 
FUNCTION setRepositionDataSource RETURNS LOGICAL
  ( plReposSource AS LOG )  FORWARD.

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

&IF DEFINED(EXCLUDE-setStartBrowseKeys) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setStartBrowseKeys Procedure 
FUNCTION setStartBrowseKeys RETURNS LOGICAL
  ( picBrowseKeys AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setToolTip) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setToolTip Procedure 
FUNCTION setToolTip RETURNS LOGICAL
  ( pcToolTip AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setViewAs) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setViewAs Procedure 
FUNCTION setViewAs RETURNS LOGICAL
  ( picViewAs AS CHARACTER )  FORWARD.

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
         HEIGHT             = 13.48
         WIDTH              = 59.2.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB Procedure 
/* ************************* Included-Libraries *********************** */

{src/adm2/seleprop.i}

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
  Purpose: run persistently on any key of the selection FILL-IN      
  Parameters:  <none>
  Notes:   Used only with the view-as browse option.
           The persistent trigger that calls this is defined if 
           DefineAnyKeyTrigger is true. 
           The user could define a override of this in selectcustom.p if more 
           sophisticated interactions with the data-source is required without 
           starting the browse. 
           For example something like:   
            if last-event:key-function = 'cursor-down' then 
               run fetchNext in getDataSource().
 ----------------------------------------------------------------------------- */
    DEFINE VARIABLE cBrowseKeys AS CHAR  NO-UNDO.

    {get StartBrowseKeys cBrowseKeys}.
    
    /* Currently we check for both labels and functions. 
       There is a theoretic potential for a collison here? */
    IF CAN-DO(cBrowseKeys,LAST-EVENT:FUNCTION) 
    OR CAN-DO(cBrowseKeys,LAST-EVENT:LABEL) THEN
    DO:
      RUN initializeBrowse IN TARGET-PROCEDURE.
      RETURN NO-APPLY.
    END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-browseHandler) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE browseHandler Procedure 
PROCEDURE browseHandler :
/*------------------------------------------------------------------------------
  Purpose:    Sets the properties in the newly started borwose.    
  Parameters: phHandle as handle. 
  Notes:      This is called from initializeBrowse after the browse has been 
              started, but BEFORE any links are added or the browse has been 
              initialized.    
              The developer can override this to set or override properties 
              for the browse.   
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER phBrowseObject AS HANDLE NO-UNDO.

  DEFINE VARIABLE cBrowseFields    AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cDisplayedField  AS CHARACTER NO-UNDO.
  DEFINE VARIABLE lExitOnAction    AS LOG       NO-UNDO.
  DEFINE VARIABLE lCancelOnExit    AS LOG       NO-UNDO.
  DEFINE VARIABLE cSearchField     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDbField         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iNumRows         AS INTEGER    NO-UNDO.
  DEFINE VARIABLE hDataSource      AS HANDLE     NO-UNDO.
  
  /** Get the SmartSelect properties that need to be used by the browse */  
  {get BrowseFields cBrowseFields}.
  {get ExitBrowseOnAction lExitOnAction}.
  {get CancelBrowseOnExit lCancelOnExit}.
  {get NumRows iNumRows}.
  {get DisplayedField cDisplayedField}.

  {get DataSource hDataSource}.  
  
  IF VALID-HANDLE(hDataSource) THEN
  DO:
    /* Search/sort on calculated fields is currently not supported 
       So if this is not a dbfield we must use the keyfield.  */
    ASSIGN
      cSearchField = cDisplayedField  
      cDbField = {fnarg columnDbColumn cDisplayedField hDataSource}.
    
    IF cDbField = '':U THEN
    DO:
      {get KeyField cSearchField}.
    END.
  END. /* valid-handle(hDataSource) */

  /** Set the properties in the browse */
  {set DisplayedFields cBrowseFields phBrowseObject}. 
  {set SearchField cSearchField phBrowseObject}.   
  {set ApplyExitOnAction lExitOnAction phBrowseObject}.
                           /* NO SPACES HERE!!*/
  {set ApplyActionOnExit  lCancelOnExit=FALSE   phBrowseObject}. 
  
  /* Set the width of the browse to show all fields*/
  {set CalcWidth TRUE phBrowseObject}.
  {set MaxWidth SESSION:WIDTH phBrowseObject}.
  {set NumDown iNumRows phBrowseObject}.
  
  /* Set the event to publish on default-action and subscribe to it */
  {set ActionEvent 'rowSelected':U  phBrowseObject}.
  SUBSCRIBE PROCEDURE TARGET-PROCEDURE TO 'rowSelected' IN phBrowseObject.

  RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-dataAvailable) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE dataAvailable Procedure 
PROCEDURE dataAvailable :
/*------------------------------------------------------------------------------
  Purpose:   Logic to receive data from the data-source when the view-as
             is a fill-in.     
  Parameters: INPUT PcMode - Not used  
  Notes:     We use a Modify property to avoid marking the value as changed 
             when setdataValue calles fetchRowident in the data-source in order 
             to display the record. 
             If Modify is true we check the source-procedure because this 
             identifies whether this is called directly from 'value-changed' or 
             indirectly from 'default-action'. 
 ------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pcMode AS CHAR No-UNDO.
 
  DEFINE VARIABLE hDataSource     AS HANDLE NO-UNDO.
  DEFINE VARIABLE hViewer         AS HANDLE NO-UNDO.
  DEFINE VARIABLE hViewerSource   AS HANDLE NO-UNDO.
  DEFINE VARIABLE cDisplayedField AS CHAR   NO-UNDO.
  DEFINE VARIABLE cKeyField       AS CHAR   NO-UNDO.
  DEFINE VARIABLE hSelection      AS HANDLE NO-UNDO.
  DEFINE VARIABLE lModify         AS LOGICAL NO-UNDO.
  DEFINE VARIABLE lStarting       AS LOGICAL NO-UNDO.
  DEFINE VARIABLE cFunc           AS CHAR NO-UNDO.
  DEFINE VARIABLE cOldValue       AS CHAR NO-UNDO.
  DEFINE VARIABLE cNewValue       AS CHAR NO-UNDO.
  
  {get starting lStarting}.
   
  /* Set to TRUE in initializeBrowse. It avoids that data that does not exist 
     in the SDO is overwritten with data from the SDO. */
  IF lStarting THEN
    {set starting FALSE}.
  ELSE DO:
    
    {get SelectionHandle hSelection}.
    IF VALID-HANDLE(hSelection) AND hSelection:TYPE = "FILL-IN":U THEN
    DO:
      {get DisplayedField cDisplayedField}.
      {get KeyField cKeyField}.
      {get DataSource hDataSource}.
      {get Modify lModify}. 
        
       /* 
       Modify is false if this is fired from setDataValue -> repositionDataSource     
       Modify is true if this is called directly or indirectly from the browse.
       
       We do NOT want to change values when the user navigates. We know 
       this is the case when Modify and data-source = source because the 
       browser publishes dataAvailable on 'value-changed')
         
       But we want to change the value when the user double-clicks or RETURNS  
       In this case Modify is also true, but data-source is not source  
       because of the indirection; the BrowseObject publishes getActionEvent() 
       which is subscribed -> browseRowSelected -> run dataAvailable('') */

      IF lModify AND SOURCE-PROCEDURE = hDataSource THEN
        RETURN.
      
      hSelection:SCREEN-VALUE = {fnarg columnValue cDisplayedField hDataSource}. 
      /* We store the DisplayValue so we are sure to return the right one 
         in the case where the SDO may have repositioned when getDisplayValue
         is requested  */ 
      {set DisplayValue hSelection:SCREEN-VALUE}.

      /* We only want to run ValueChanged from default-action in browser 
         We may also get here when ValueChanged calls repositionDataSource, 
         so repositionDataSource sets Modify to false to avoid looping. */
      IF lModify THEN
      DO:
        cNewValue = {fnarg columnValue cKeyField hDataSource}.
        {get DataValue cOldValue}.
        
        IF cNewValue <> cOldValue THEN
        DO:
          /* setDataValue only stores the new value when called internally 
             (Doesn't call repositionDataSource, so looping is avoided). */         
          {set DataValue cNewValue}.
          RUN valueChanged IN TARGET-PROCEDURE.
        END. /* cNewValue <> cOldValue */
      END. /* lmodify */
    END. /* valid hSelection and fill-in */
  END. /* not lStarting */
  
  RETURN. 

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-destroyObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE destroyObject Procedure 
PROCEDURE destroyObject :
/** 
*   @desc  local overide of destroyObject; delete created widgets
*/
/*------------------------------------------------------------------------------
  Purpose:   local overide of destroyObject; delete created widgets
  Parameters: <NONE>
  Notes:     
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hDataSource AS HANDLE.

  {fn destroySelection}.
  
  RUN SUPER.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-disableField) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disableField Procedure 
PROCEDURE disableField :
/**
*   @desc  disable SmartSelection component
*/
/*------------------------------------------------------------------------------
  Purpose:   disable SmartSelection component
  Parameters: <NONE>
  Notes:  The SmartDataViewer container will call this procedure if a widget of 
          type PROCEDURE is encountered in disableFields    
------------------------------------------------------------------------------*/
 DEFINE VARIABLE hSelection    AS HANDLE    NO-UNDO.
 DEFINE VARIABLE hButton         AS HANDLE    NO-UNDO.
 DEFINE VARIABLE hBrowseContainer AS HANDLE    NO-UNDO.

 {get SelectionHandle hSelection}.
 
 IF VALID-HANDLE(hSelection) THEN
 DO:
   IF hSelection:TYPE <> "FILL-IN":U THEN 
     hSelection:SENSITIVE = FALSE.
   ELSE
   DO:  
     {get BrowseContainer hBrowseContainer}.
     {get ButtonHandle hButton}.
     
     IF VALID-HANDLE(hBrowsecontainer) THEN 
       RUN disableObject IN hBrowseContainer.
   
     ASSIGN
       hButton:SENSITIVE    = FALSE
       hSelection:READ-ONLY = TRUE
       hSelection:TAB-STOP  = TRUE.   
   END. 
 END.
 
 {set FieldEnabled FALSE}.
 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-disable_UI) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI Procedure  _DEFAULT-DISABLE
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

&IF DEFINED(EXCLUDE-enableField) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enableField Procedure 
PROCEDURE enableField :
/**
*   @desc  enable SmartSelection component
*/
/*------------------------------------------------------------------------------
  Purpose:   enable SmartSelection component
  Parameters: <NONE>
  Notes:  The SmartDataViewer Container will call this procedure if a widget of 
          type PROCEDURE is encountered in enableFields    
------------------------------------------------------------------------------*/
 DEFINE VARIABLE hSelection      AS HANDLE NO-UNDO.
 DEFINE VARIABLE cDisplayedField AS CHAR   NO-UNDO.
 DEFINE VARIABLE cKeyField       AS CHAR   NO-UNDO.
 DEFINE VARIABLE hButton         AS HANDLE NO-UNDO.

 {get SelectionHandle hSelection}.
 
 IF VALID-HANDLE(hSelection) THEN
 DO:
   IF hSelection:TYPE <> "FILL-IN":U THEN
     hSelection:SENSITIVE = TRUE.
   ELSE DO:
     {get KeyField cKeyField}.
     {get DisplayedField cDisplayedField}.
     {get ButtonHandle hButton}.
    
     /* Currently we don't enable the displayfield */
     IF cKeyField = cDisplayedField THEN 
       hSelection:READ-ONLY = FALSE.
   
     ASSIGN
       hButton:SENSITIVE   = TRUE 
       hSelection:TAB-STOP = TRUE.   
   END.
 
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
   DEFINE VARIABLE cBlank AS CHAR NO-UNDO.
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

&IF DEFINED(EXCLUDE-initializeBrowse) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeBrowse Procedure 
PROCEDURE initializeBrowse :
/*------------------------------------------------------------------------------
  Purpose: Code to initialize the browse     
  Parameters:  <none>
  Notes:   Starts a browse to show the Data-source data. The browse procedure
           is specicifed in the BrowseProcedure property and defaults to the 
           dynamic smartDataBrowser.   
           A dynamic SmartWindow (BrowseContainer) is started first and the 
           browse procedure is started with the containers constructObject.
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hContainer       AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hBrowseContainer AS HANDLE    NO-UNDO.
  DEFINE VARIABLE cBrowseWinProc   AS CHARACTER NO-UNDO.
  DEFINE VARIABLE hBrowseWindow    AS HANDLE    NO-UNDO.
  DEFINE VARIABLE cBrowseProc      AS CHARACTER NO-UNDO.
  DEFINE VARIABLE hBrowseObject    AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hToolbar         AS HANDLE    NO-UNDO.
  DEFINE VARIABLE cBrowseTitle     AS CHARACTER NO-UNDO.
  DEFINE VARIABLE hDataSource      AS HANDLE    NO-UNDO.
  DEFINE VARIABLE lEnabled         AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE cUIBmode         AS CHAR      NO-UNDO.
  DEFINE VARIABLE cRowident        AS CHAR      NO-UNDO.
  DEFINE VARIABLE dBrowseHeight    AS DECIMAL   NO-UNDO.
  DEFINE VARIABLE dBrowseWidth     AS DECIMAL   NO-UNDO.

  {get uibMODE cUIBmode}.
  
  IF cuibMode BEGINS "DESIGN":U THEN 
    RETURN. 
  
  {get BrowseObject hBrowseObject}.
  
  {get BrowseContainer hBrowseContainer}.
  IF NOT VALID-HANDLE(hBrowseContainer) THEN 
  DO: 
    {get ContainerSource hContainer}.
    {get DataSource hDataSource}.
    {get BrowseWindowProcedure cBrowseWinProc}.
    
    RUN constructObject IN hContainer 
           (cBrowseWinProc,
            ?,
            "":U,
            OUTPUT hBrowseContainer).    
    {set BrowseContainer hBrowseContainer}.

    {get ContainerHandle hBrowseWindow hBrowseContainer}.
    {get BrowseTitle cBrowseTitle}.
    hBrowseWindow:TITLE = cBrowseTitle.
    
    RUN constructObject IN hBrowseContainer 
           ('adm2/dyntoolbar.w',
             hBrowseWindow,
            'Menu' + CHR(4) + 'yes' + CHR(3) + 
            'Toolbar' + CHR(4) + 'no' + CHR(3) + 
            'ActionGroups' + CHR(4) + 'Navigation',
            OUTPUT hToolbar).
    
    {get BrowseProcedure cBrowseProc}.
   
    RUN constructObject IN hBrowseContainer 
           (cBrowseProc,
            hBrowseWindow,
            '':U,
            OUTPUT hBrowseObject).

    {set BrowseObject hBrowseObject}.   
    /* Set properties in the browser from the select's instance properties */
    RUN browseHandler IN TARGET-PROCEDURE(hBrowseObject).
    
    RUN addLink IN hBrowseContainer ( hDataSource, 'Data':U , hBrowseObject).    
    RUN addLink IN hBrowseContainer ( hToolbar, 'navigation':U , hDataSource).
  
    {get Rowident cRowident hdatasource}.

    RUN removeLink IN hContainer (hDataSource, 'Data':U , TARGET-PROCEDURE).
    
    /* We set HideOnInit to TRUE in the browse container and view it explicitly 
      after resizing. Otherwise the browse gets visualized before the window
      is resized and we get flashing. */

    {set HideOnInit TRUE hBrowseContainer}.
    RUN initializeObject in hBrowseContainer.

    /* We need to now resize the Browse container after the browse has
       resized itself during initialization based on calcWidth being
       set to TRUE and NumDown being set.  We need to view the Browse
       container after resizing it because it was set to be hidden
       on initialization. */
    /* viewObject will resize the browse */
    RUN viewObject IN hBrowseObject.

    {get HEIGHT dBrowseHeight hBrowseObject}.
    {get WIDTH  dBrowseWidth hBrowseObject}.
    RUN resizeObject IN hBrowseContainer (dBrowseHeight, dBrowseWidth).
    
    {set Starting TRUE}. /* tell dataAvail not to do anything 
                            except setting it back to false */
    IF cRowident <> ? THEN
      DYNAMIC-FUNC("fetchrowident":U IN hDataSource,cRowident,"").
    
    RUN addLink IN hContainer (hDataSource, 'Data':U , TARGET-PROCEDURE).
    
    {get FieldEnabled lEnabled}.
    
    IF NOT lEnabled THEN 
      RUN disableObject IN hBrowseObject.      
  END. /* if not valid-handle(hBrowseContainer)*/
  RUN viewObject IN hBrowseContainer. 
  
  /* Focus on the browse immediately */
  RUN applyEntry IN hBrowseObject (INPUT ?).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-initializeObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeObject Procedure 
PROCEDURE initializeObject :
/**
*   @desc  super override of initializeObject
*/
/*------------------------------------------------------------------------------
  Purpose: Override of initializeObject in order to subscribe to 
           the ChangedEvent if defined and initializeSelection      
  Parameters:  <none>
  Notes:    
---------------------------------------------------------------------------*/
  
  DEFINE VARIABLE cEvent     AS CHAR   NO-UNDO.
  DEFINE VARIABLE hContainer AS HANDLE NO-UNDO.
  DEFINE VARIABLE cUIBMode    AS CHAR   NO-UNDO.
  
  RUN SUPER.
  
  {get ChangedEvent cEvent}.
  {get ContainerSource hContainer}.    
  
  IF VALID-HANDLE(hContainer) AND cEvent NE "":U THEN
  DO:
    {get UIBMode cUIBMode}.    
    IF NOT (cUIBMode BEGINS "DESIGN":U)  THEN
       SUBSCRIBE PROCEDURE hContainer TO cEvent IN THIS-PROCEDURE.
  END.

  RUN initializeSelection IN TARGET-PROCEDURE.
  
  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-initializeSelection) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeSelection Procedure 
PROCEDURE initializeSelection :
/*------------------------------------------------------------------------------
    Purpose: Create the selection-widget and populate with data unless the 
             view-as is specified as a browse. 
Parameters:  <none>
     Notes:  This is part of the object's initialization 
             (called from initializeObject) 
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cViewAs       AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cViewAsType   AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cViewAsOption AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cDisplayedField AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cKeyField     AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cLABEL        AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cKeyFormat    AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cDispFormat   AS CHARACTER NO-UNDO.
  DEFINE VARIABLE iHelpId       AS INTEGER   NO-UNDO.
  DEFINE VARIABLE cToolTip      AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cDataType     AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cKeyDataType  AS CHARACTER NO-UNDO.
  DEFINE VARIABLE hDataSource   AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hFrame        AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hContainer    AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hParentFrame  AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hSelection    AS HANDLE    NO-UNDO.
  DEFINE VARIABLE cSelectionImg AS CHAR      NO-UNDO.
  DEFINE VARIABLE hBtn          AS HANDLE    NO-UNDO.
  DEFINE VARIABLE lSort         AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE lSDOinit      AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE iNumRows      AS INTEGER   NO-UNDO.
  DEFINE VARIABLE cList         AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cUIBMode      AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cFilter       AS CHARACTER NO-UNDO.
  DEFINE VARIABLE lAnyKey       AS LOG       NO-UNDO.

  {get ContainerHandle hFrame}.
    
  hParentFrame = hFrame:FRAME.
    
  IF NOT VALID-HANDLE(hParentFrame) THEN 
    RETURN.
  
  {fn destroySelection}.

  {get DisplayedField cDisplayedField}.
  {get KeyField cKeyField}.
  {get Label cLabel}.
  {get ToolTip cToolTip}.
  {get HelpId iHelpId}.
  {get Format cKeyFormat}.
  {get ViewAs cViewAs}.
  {get Sort lSort}.
  {get NumRows iNumRows}.
  {get DataSource hDataSource}.  
  {get UIBMode cUIBmode}. 
  
  /* default to the fieldname if no keyfield 
     (This will give errors further down if the field does not exist) */
  IF cKeyField = "":U THEN
  DO:
     {get FieldName cKeyfield}.
     {set KeyField  cKeyfield}.
  END.
  
  /* default to the keyfield if no displayedfield */
  IF cDisplayedField = "":U THEN
  DO:
    cDisplayedField = cKeyField.
    {set DisplayedField cDisplayedField}.
  END.

  cDataType = ?.

  IF VALID-HANDLE(hDataSource) AND cDisplayedField <> "":U THEN    
  DO:
    cDataType = {fnarg columnDataType cDisplayedField hDataSource}.    
    
    IF NOT (cUIBMode BEGINS "Design":U)  THEN
    DO:
      /* Unknown means that the field probably was not defined in the source */
      IF cDataType = ? THEN
      DO:
        /* 7351 =  Buffer-field not found */
        IF ERROR-STATUS:GET-NUMBER(1) = 7351 THEN
          DYNAMIC-FUNC('showMessage' IN TARGET-PROCEDURE, 
                        STRING(19) + ",":U 
                                  + cDisplayedField 
                                  + ",":U 
                                  + TARGET-PROCEDURE:FILE-NAME).

        RETURN "ADM-ERROR":U.      
        
      END. /* cDataType = ? */
      
      {get ObjectInitialized lSDOinit hDataSource}.
      {get DataSourceFilter cFilter}.
      
      /* Make sure last record is not displayed twice */
      {set CheckLastOnOpen TRUE hDataSource}.
      IF lSdoInit THEN
      DO:
         IF cFilter NE "":U THEN
           DYNAMIC-FUNCTION("addQueryWhere" IN hDataSource,cFilter,?,'':U). 
        
         /* Currently we need to reopen the query for sdos that already 
            are intialized to ensure that the last record is not displayed
            twice and also for the filter above. */
        {fn openQuery hDataSource}.
      END. /* SDO init */
    END. /* not uibmode begins design */     
    
    cKeyFormat = IF cKeyFormat = '?':U OR cKeyFormat = ? OR cKeyFormat = '':U
                 THEN {fnarg columnFormat cKeyField hDataSource}
                 ELSE cKeyFormat.
      
  END. /* if valid sdo and cDisplayedField <> '' */
  
  /* create a label if not blank */  
  IF cLabel NE "":U THEN
  DO: 
    /* If the label is unknown or "?" we should use the datasource.  
       cDataType <> ? indicates that the field is found in the data-source. */    
    IF cLabel = '?':U OR cLabel = ? AND cDataType <> ? THEN 
    DO:
      cLabel = ?.
      IF VALID-HANDLE(hDataSource) THEN  
        cLabel = {fnarg columnLabel cKeyField hDataSource}.
    END. /* cLabel = '?' or ? */     
    
    IF cLabel <> ? THEN
      {fnarg createLabel cLabel}. 
  END. /* cLabel <> "":U */

  ASSIGN
    cDataType  = IF cDataType <> ? 
                 THEN cDataType 
                 ELSE "CHARACTER":U  /* design - or buffer-field not found etc */
      
   cKeyFormat  = IF cKeyFormat = '?':U OR cKeyFormat = ? OR cKeyFormat = '':U
                 THEN "x(256)":U
                 ELSE cKeyFormat 

   cViewAsType   = ENTRY(1,cViewas,":":U).
   cViewAsOption = IF NUM-ENTRIES(cViewAs,":") > 1
                   THEN ENTRY(2,cViewas,":":U)
                   ELSE cViewAsOption.  
  
  /* If this is not a browser we must get the keyfield datatype and 
     build the list for the widget */ 
  IF cViewAsType <> "Browser":U THEN     
  DO:
    
    /* We don't allow different key and display in editable combo 
       because there's no key to save and no way to get the value with 
       list-item-pairs */    
    IF cViewAsType    = "combo-box":U AND 
       cViewAsOption <> "drop-down-list":U THEN
      cDisplayedField = cKeyField.

    IF cKeyField <> cDisplayedField AND VALID-HANDLE(hDataSource) THEN
    DO:
      cKeyDataType = {fnarg columnDataType cKeyField hDataSource}.    

      IF NOT (cUIBMode BEGINS "Design":U) 
      /* Unknown means that the field probably was not defined in the source */
      AND cKeyDataType = ? THEN
      DO:
        /* 7351 =  Buffer-field not found */
        IF ERROR-STATUS:GET-NUMBER(1) = 7351 THEN
          DYNAMIC-FUNC('showMessage' IN TARGET-PROCEDURE, 
                       STRING(19) + ",":U 
                                  + cKeyField 
                                  + ",":U 
                                  + TARGET-PROCEDURE:FILE-NAME).
        RETURN "ADM-ERROR":U.      
      END. /* cDataType = ? */    
    END. /* keyfield <> displayedfield and valid data-source */ 
    ELSE cKeyDataType = cDataType.
    
    /* If the SDO was initialized we build the list now, otherwise the 
       refreshObject will take care of this when the SDO openQuery
       publishes "queryOpened" 
      (unknown datatype indicates invalid keyfield) */

    IF lSDOInit AND cKeyDataType <> ? THEN 
      ASSIGN     
         cList = {fn buildList}. 
  END. /* not browser */

  CASE cViewAsType:
    WHEN "Selection-List":U THEN
    DO:
        CREATE SELECTION-LIST hSelection
          ASSIGN SCROLLBAR-VERTICAL = TRUE
                 SORT             = lSort
                 FRAME            = hFrame
                 X                = 0
                 Y                = 0
                 WIDTH-PIXELS     = hFrame:WIDTH-PIXELS
                 HEIGHT-PIXELS    = hFrame:HEIGHT-PIXELS
                 HIDDEN           = FALSE
                 DELIMITER        = {&selectionSeparator}
                 SENSITIVE        = FALSE.
          
          IF cList NE "":U THEN
            hSelection:LIST-ITEM-PAIRS = cList.
    END. /* when "selection-list" */
    WHEN "Radio-Set":U THEN
    DO:
      CREATE RADIO-SET hSelection
          ASSIGN DELIMITER        = {&selectionSeparator}
                 HORIZONTAL       = cViewAsOption BEGINS "H"
                 RADIO-BUTTONS    = (IF cList <> "":U 
                                 THEN cList
                                 ELSE "":U + {&selectionSeparator} + "":U)
                 FRAME            = hFrame
                 Y                = 0
                 WIDTH-PIXELS     = hFrame:WIDTH-PIXELS 
                 HEIGHT-PIXELS    = hFrame:HEIGHT-PIXELS
                 HIDDEN           = FALSE
                 SENSITIVE        = FALSE.
    END. /* when "radio-set" */
    WHEN "Combo-Box":U THEN
    DO:
      IF cViewAsOption = "SIMPLE":U AND hFrame:HEIGHT = 1 THEN
         hFrame:HEIGHT-P = hFrame:HEIGHT-P + 2.

      CREATE COMBO-BOX hSelection
          ASSIGN DELIMITER        = {&selectionSeparator}
                 SUBTYPE          = cViewAsOption
                 DATA-TYPE        = IF hSelection:SUBTYPE = "drop-down-list":U 
                                    THEN cKeyDataType
                                    ELSE hSelection:DATA-TYPE
                 SORT             = lSort
                 FORMAT           = cKeyFormat
                 WIDTH-PIXELS     = hFrame:WIDTH-PIXELS 
                                    - (IF hSelection:SUBTYPE = "SIMPLE":U 
                                       THEN 2 
                                       ELSE 0)
                 FRAME            = hFrame
                 HIDDEN           = TRUE
                 SENSITIVE        = FALSE.

       IF cList NE "":U THEN
       DO:
         IF {fn getUsePairedList} THEN
           hSelection:LIST-ITEM-PAIRS = cList.
         ELSE 
           hSelection:LIST-ITEMS = cList.
       END.
       /* The frame (sometimes decimals??) protests about the height if 
          exactly 1 so we use no-error. */ 
       ASSIGN 
           hSelection:HIDDEN       = FALSE NO-ERROR.
       
       IF iNumRows > 0 THEN
          hSelection:INNER-LINES = MIN(hSelection:NUM-ITEMS,iNumRows).
       
       IF hSelection:SUBTYPE <> "Simple":U THEN
         hFrame:HEIGHT = hSelection:HEIGHT.
    END. /* when "combo-box" */
    WHEN "Browser":U THEN
    DO:
       IF VALID-HANDLE(hDataSource) THEN
         cDispFormat = {fnarg columnFormat cDisplayedField hDataSource}.
       ELSE 
         cDispFormat = "x(255)":U.

       CREATE FILL-IN hSelection
          ASSIGN FRAME            = hFrame
                 SUBTYPE          = IF cUIBMode BEGINS "DESIGN":U
                                    THEN "NATIVE":U
                                    ELSE "PROGRESS":U 
                 X                = 0
                 Y                = 0
                 DATA-TYPE        = cDataType 
                 FORMAT           = cDispFormat                 
                 WIDTH-PIXELS     = hFrame:WIDTH-PIXELS - 24
                 HIDDEN           = FALSE
                 SENSITIVE        = (cUIBMode BEGINS "DESIGN":U) = FALSE
                 READ-ONLY        = TRUE
                 TAB-STOP         = FALSE.
                               
        CREATE BUTTON hBtn
          ASSIGN NO-FOCUS         = TRUE
                 FRAME            = hFrame
                 X                = hSelection:WIDTH-P + 4
                 Y                = 1 
                 WIDTH-PIXELS     = 19
                 HEIGHT-P         = hSelection:HEIGHT-P - 1 
                 HIDDEN           = FALSE
                 SENSITIVE        = FALSE
              TRIGGERS:
                ON CHOOSE PERSISTENT 
                  RUN initializeBrowse IN TARGET-PROCEDURE.
              END.
       {get SelectionImage cSelectionImg}.
        hBtn:LOAD-IMAGE(cSelectionImg).      
        hFrame:HEIGHT = hSelection:HEIGHT.
       
       {get DefineAnyKeyTrigger lAnyKey}.
       
       IF lAnyKey THEN 
         ON ANY-KEY OF hSelection 
           PERSISTENT RUN anyKey IN TARGET-PROCEDURE.
    
       {set ButtonHandle hBtn}.       
    END. /* when "browser" */
  END CASE. /* cViewAsType */
  
  IF VALID-HANDLE(hSelection) THEN
  DO:
    hSelection:MOVE-TO-BOTTOM().
    hSelection:TOOLTIP = cToolTIP.
    IF iHelpId <> ? THEN 
     hSelection:CONTEXT-HELP-ID = iHelpId.
  
    ON VALUE-CHANGED OF hSelection PERSISTENT RUN valueChanged  IN TARGET-PROCEDURE.
    ON {&refreshKey} OF hSelection PERSISTENT RUN refreshObject IN TARGET-PROCEDURE.
    ON END-MOVE      OF hFrame     PERSISTENT RUN endMove       IN TARGET-PROCEDURE. 
  END.
  {set SelectionHandle hSelection}.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-queryOpened) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE queryOpened Procedure 
PROCEDURE queryOpened :
/*------------------------------------------------------------------------------
  Purpose: subscribe to dataSource     
  Parameters:  
  Notes:    The SmartSelect need to know that the query changed as this cannot 
            be detected through the ordinary publish "dataAvailable". 
------------------------------------------------------------------------------*/  
  DEFINE VARIABLE lInitialized AS LOGICAL NO-UNDO.

  /* we're not ready for this event until we have initialized. */
  {get ObjectInitialized lInitialized}.
  IF lInitialized THEN
     RUN refreshobject IN TARGET-PROCEDURE. 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-refreshObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE refreshObject Procedure 
PROCEDURE refreshObject :
/*------------------------------------------------------------------------------
  Purpose: Refresh the data in SmartSelection
  Parameters:  <none>
  Notes:   openQuery in the datasource publishes "queryOpened" which run this 
          (Also defined as PERSISTENT trigger on f5 of the selection widget)  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cList      AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cOldValue  AS CHARACTER NO-UNDO.
  DEFINE VARIABLE hSelection AS HANDLE    NO-UNDO.
  DEFINE VARIABLE iNumRows   AS INT       NO-UNDO.
  DEFINE VARIABLE lUsePair   AS LOGICAL    NO-UNDO.

  {get SelectionHandle hSelection}.
  
  IF NOT VALID-HANDLE(hSelection)
  OR hSelection:TYPE = "fill-in":U THEN
    RETURN.

  ASSIGN 
    cOldValue = hSelection:SCREEN-VALUE
    cList     = {fn buildList}.
  
  IF hSelection:TYPE = "RADIO-SET":U THEN
     hSelection:RADIO-BUTTONS = (IF cList <> "":U 
                                 THEN cList
                                 ELSE "":U + {&selectionSeparator} + "":U).
    
  ELSE
  DO:
    {get UsePairedList lUsePair}.

    IF NOT lUsePair THEN
    DO:
      IF cList <> "":U THEN
        hSelection:LIST-ITEMS = cList.
      ELSE
        hSelection:LIST-ITEMS = ?.
    END.
    ELSE DO: 
      IF cList <> "":U THEN
        hSelection:LIST-ITEM-PAIRS = cList. 
      ELSE
        hSelection:LIST-ITEM-PAIRS = ?.
    END.
  END.
  
  /* Is old value still in the list? t*/
  hSelection:SCREEN-VALUE = cOldValue NO-ERROR.

  IF hSelection:TYPE = "COMBO-BOX":U 
  AND hSelection:SUBTYPE <> "simple":U THEN
  DO:
    {get NumRows iNumRows}.  
     IF iNumRows > 0 THEN
        hSelection:INNER-LINES = IF hSelection:NUM-ITEMS = ? THEN 1
                                 ELSE MIN(hSelection:NUM-ITEMS,iNumRows).
  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-resizeObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE resizeObject Procedure 
PROCEDURE resizeObject :
/**
*   @desc  resize contents of Smartselection component after the developer
*   @desc  resizes the component
*   @param <code>input pidheight decimal</code> new height of component
*   @param <code>input pidwidth  decimal</code> new width  of component
*/
/*------------------------------------------------------------------------------
  Purpose: Resize the SmartSelection      
  Parameters:  INPUT pidHeight decimal New height of component 
               INPUT pidWidth decimal New widtht of component.
  Notes:  The procedure deletes the current widget,
          Resizes the frame and recreates the widget.  
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pidHeight AS DECIMAL NO-UNDO.
  DEFINE INPUT PARAMETER pidWidth  AS DECIMAL NO-UNDO.
  
  DEFINE VARIABLE hFrame   AS HANDLE NO-UNDO.
  DEFINE VARIABLE cUIBMode AS CHAR   NO-UNDO.

  {get ContainerHandle hFrame}.
 
  {fn destroySelection}.

  ASSIGN hFrame:SCROLLABLE            = TRUE
         hFrame:WIDTH-CHARS           = pidWidth
         hFrame:HEIGHT-CHARS          = pidHeight
         hFrame:VIRTUAL-WIDTH-CHARS   = hFrame:WIDTH-CHARS
         hFrame:VIRTUAL-HEIGHT-CHARS  = hFrame:HEIGHT-CHARS
         hFrame:SCROLLABLE            = FALSE.
 
  {get UIBMode cUIBMode}.
 
  IF cUIBMode = "design":U  THEN
    RUN initializeSelection IN TARGET-PROCEDURE.

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-rowSelected) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE rowSelected Procedure 
PROCEDURE rowSelected :
/*------------------------------------------------------------------------------
  Purpose:  Published from the browser when a row is selected.
  Parameters:  
  Notes:    The browser is selected on default action 
            and exit (if CancelrowObExit = false)
            The subscribtion is done in browseHandler 
------------------------------------------------------------------------------*/
  RUN dataAvailable IN TARGET-PROCEDURE('':U).
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
            in the U10 trigger in the SmartDataViewer when the view-as is 
            browse, because this code's check of FOCUS is wrong when the 
            actual change is caused by a user event in the browser         
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cEvent      AS CHAR    NO-UNDO.
  DEFINE VARIABLE cKeyField   AS CHAR    NO-UNDO.
  DEFINE VARIABLE cViewAs     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cNewValue   AS CHAR    NO-UNDO.
  DEFINE VARIABLE hContainer  AS HANDLE  NO-UNDO.
  DEFINE VARIABLE hSelection  AS HANDLE     NO-UNDO.
  DEFINE VARIABLE lResult     AS LOGICAL NO-UNDO.
  DEFINE VARIABLE lRepos      AS LOG     NO-UNDO.

  {get ContainerSource hContainer}.
  
  /* We should actually apply U10 to the container (SmartDataViewer) because 
    the viewer.i has this logic on U10, but it does not handle browsers */  
  IF VALID-HANDLE(hContainer) THEN
  DO:
    {get FieldsEnabled lResult hContainer}.
     /* Only if the object's enable for input.*/
    IF lResult THEN 
    DO:
        {get DataModified lResult hContainer}.
        IF NOT lResult THEN   /* Don't send the event more than once. */
          {set DataModified YES hContainer}.
     END.
  END. /* valid container */
  
  /* We must logg this as modifed to make the viewer save the value */
  {set DataModified YES}.

  {get ViewAs cViewAs}.

  /* Should we Publish event with new value to container? */
  {get ChangedEvent cEvent}. 

  {get SelectionHandle hSelection}.

  IF cEvent NE "":U THEN
  DO:
    /* if browser then dataAvailable did set DataValue before this was called */
    IF cViewAs = "browser":U THEN
      {get DataValue cNewValue}.
    ELSE 
      cNewValue = hSelection:INPUT-VALUE.
    
    PUBLISH cEvent (cNewValue).
  END. /* cevent <> '' */
  
  /* Note: to solve Issue 446 just remove this do block */  
  IF hSelection:TYPE <> "Fill-In":U THEN
  DO:
    {get RepositionDataSource lRepos}.   
    IF lRepos THEN 
      {fnarg repositionDataSource hSelection:SCREEN-VALUE}.
  END. /* hSelection:type  <> fill-in */

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

&IF DEFINED(EXCLUDE-buildList) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION buildList Procedure 
FUNCTION buildList RETURNS CHARACTER PRIVATE
  (  ) :
/*------------------------------------------------------------------------------
  Purpose   : Build the list of fields to display and the corresponding
              SCREEN-VALUE for the widget. 
    Notes   : Loops through all the rows in the data-source.                            
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cList         AS CHARACTER NO-UNDO.

  DEFINE VARIABLE hBuffer          AS HANDLE    NO-UNDO.
  DEFINE VARIABLE cViewAs          AS CHAR      NO-UNDO.
  DEFINE VARIABLE hKeyField        AS HANDLE    NO-UNDO.
  DEFINE VARIABLE cKeyField        AS CHAR      NO-UNDO.
  DEFINE VARIABLE cField           AS CHAR      NO-UNDO.
  DEFINE VARIABLE cKeyDataType     AS CHAR      NO-UNDO.
  DEFINE VARIABLE hDataSource      AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hContainerSource AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hContDataSource  AS HANDLE    NO-UNDO.
  DEFINE VARIABLE iItemCount       AS INTEGER   NO-UNDO.
  DEFINE VARIABLE cDisplayField    AS CHARACTER NO-UNDO.
  DEFINE VARIABLE lListInitialized AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE lOptional        AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE cOptionalString  AS CHAR      NO-UNDO.
  DEFINE VARIABLE cQueryPosition   AS CHAR      NO-UNDO.
  DEFINE VARIABLE cUIBMode         AS CHAR      NO-UNDO.
  DEFINE VARIABLE lUsePair         AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cColumns         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cValueList       AS CHARACTER  NO-UNDO.
  /*  
  {get ListInitialized lListInitialized}.
  
  IF lListInitialized THEN 
    RETURN gcList.
  */
    
  cList = "":U.
  {set ListInitialized TRUE}.   
  {get UIBMode cUIBMode}. 
  {get UsePairedList lUsePair}.
  
  /* We don't want real data in design or design-child mode */ 
  IF cUIBMode BEGINS "Design":U THEN
  DO:
    DO iItemCount = 1 TO 3:
       cList = cList + {&selectionSeparator}  
                     + "Item " + STRING(iItemCount) 
                     + IF lUsePair 
                       THEN ( {&selectionSeparator} + STRING(iItemCount))
                       ELSE '':U .
    END.
    cList = SUBSTRING(cList,2).   
    RETURN cList.
  END. /* cUibMode begins 'design' */  

  {get DataSource hDataSource}.
  
  IF NOT VALID-HANDLE(hDataSource) THEN
    RETURN cList.
  
  {get DisplayedField cDisplayField}.
  {get KeyField cKeyField}.
  
  IF cKeyField EQ "":U THEN  
    {get KeyFields cKeyField hDataSource}.

  /* No use without a keyfield 
    (If DisplayedField was blank it has been set to KeyField in 
     initializeSelection ) */ 
  IF cKeyField = "":U THEN 
    RETURN cList.
  
  cKeyDataType  = {fnarg columnDataType cKeyField hDataSource}.
  
  /* Just in case the field is not there */
  IF cKeyDataType = ? THEN 
     RETURN "":U.
  
  {get Optional lOptional}.
  {get OptionalString cOptionalString}.
  {get ViewAs cViewAs}.

  IF lOptional AND lUsePair THEN
  DO:
    /*************
     We are currently allowing the optional value also for mandatory fields, 
     The user may override it to store a valid value instead (ie blank)   

    {get FieldName cField}.
    {get ContainerSource hContainerSource}.
    {get DataSource hContDataSource hContainerSource}.
    
    IF VALID-HANDLE(hContDataSource) THEN
       lOptional = NOT {fnarg columnMandatory cField hContDataSource}.
    IF lOptional THEN
    ************/
     cList = cOptionalString 
             + {&selectionSeparator}              
             /* Cannot add '?' to list-item-pairs (bug 19991509-025) */
             + IF cViewAs BEGINS "radio":U THEN "?":U ELSE "":U. 
  END. /* IF lOptional */

  ASSIGN
    cColumns   = cDisplayField 
                 + (IF lUsePair THEN ("," + cKeyField)
                    ELSE "":U)
    cValueList = DYNAMIC-FUNCTION('rowValues':U IN hDataSource,
                                   cColumns,
                                   /* Not much sense in using formats for 
                                      pairedlists as radio-sets and 
                                      selection-lists does not support format
                                      and the format applies to the invisible 
                                      data for combo-boxes */
                                   IF lUsePair 
                                   THEN '':U
                                   ELSE 'Formatted':U,
                                   {&selectionSeparator}) NO-ERROR.
  IF cValueList = ? THEN 
      MESSAGE cDisplayField ": List of items is too large.":U VIEW-AS ALERT-BOX WARNING.

  
  RETURN cList /* optional value */
        + (IF cList <> "":U AND cValueList <> "":U 
           THEN {&selectionSeparator}
           ELSE "":U)
        + cValueList.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-createLabel) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION createLabel Procedure 
FUNCTION createLabel RETURNS HANDLE
  (pcLabel AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose   : Create the label of the Selection 
 Description:         The label are added to the parent frame  
    Notes   : This function is separated in order to be able to create 
               the label in design-mode.
             Instance properties
             - Show label when label is set from the data-source
                (The Dialog knows the datasource, but this super procedure cannot
                 find it because the link is not implemented)     
             EndMove
             - Move label accordingly
------------------------------------------------------------------------------*/
   DEFINE VARIABLE hLabel        AS HANDLE    NO-UNDO.
   DEFINE VARIABLE iLabelLength  AS INTEGER   NO-UNDO.
   DEFINE VARIABLE hParentFrame  AS HANDLE    NO-UNDO.
   DEFINE VARIABLE hFrame        AS HANDLE    NO-UNDO.
  
   {get LabelHandle hLabel}.
   IF VALID-HANDLE(hLabel) THEN
   DO:
     /* endmove passes blank value, if so just copy the old value */ 
     IF pcLabel = "":U THEN 
       pcLabel = RIGHT-TRIM(hLabel:SCREEN-VALUE,":":U).
     DELETE WIDGET hLABEL.
   END.   
   ELSE IF pcLabel = "":U THEN
     RETURN ?.
   
   {get ContainerHandle hFrame}.
    
   hParentFrame = hFrame:FRAME.
 
   iLabelLength = FONT-TABLE:GET-TEXT-WIDTH-PIXELS(pcLabel + ": ":U, hFrame:FONT).
       
   CREATE TEXT hLabel
     ASSIGN FRAME                 = hParentFrame
            X                     = hFrame:X - iLabelLength
            Y                     = hFrame:Y
            HIDDEN                = FALSE
            WIDTH-PIXELS          = iLabelLength
            FORMAT                = "x(256)"
            SCREEN-VALUE          = pcLabel + ":":U
            HEIGHT-PIXELS         = SESSION:PIXELS-PER-ROW 
             /*FONT-TABLE:GET-TEXT-HEIGHT-PIXELS(FRAME {&frame-name}:FONT)*/.
  
  {set LabelHandle hLabel}.
  
  RETURN hLabel. 
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-destroySelection) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION destroySelection Procedure 
FUNCTION destroySelection RETURNS LOGICAL
  (  ) :
/**
*   @desc  cleanup all created objects
*/
/*------------------------------------------------------------------------------
  Purpose   : Cleanup all dynamicly created objects.  
    Notes   :  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hSelection   AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hLabel       AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hButton      AS HANDLE    NO-UNDO.

  {get SelectionHandle hSelection}.
  {get LabelHandle hLabel}.
  {get ButtonHandle hButton}.
    
  IF VALID-HANDLE(hSelection) THEN DELETE WIDGET hSelection.
  IF VALID-HANDLE(hLabel)     THEN DELETE WIDGET hLabel.
  IF VALID-HANDLE(hButton)    THEN DELETE WIDGET hButton.
    
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-formattedValue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION formattedValue Procedure 
FUNCTION formattedValue RETURNS CHARACTER
  (pcValue AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose: Return the formatted value of a passed value according to the 
           SmartSelects format. 
Parameter: pcValue - The value that need to be formatted.      
    Notes: Used internally in order to ensure that unformatted data can be 
           applied to screen-value (setDataValue) or used as lookup in
           list-item-pairs in (getDisplayValue)  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hSelection AS HANDLE     NO-UNDO.
  
  {get SelectionHandle hSelection}.
  
  IF VALID-HANDLE(hSelection) AND CAN-QUERY(hSelection,'format':U) THEN
  DO:
    CASE hSelection:DATA-TYPE:
      WHEN 'character':U THEN
        pcValue = STRING(pcValue,hSelection:FORMAT).
      WHEN 'date':U THEN
        pcValue = STRING(DATE(pcValue),hSelection:FORMAT).
      WHEN 'decimal':U THEN
        pcValue = STRING(DECIMAL(pcValue),hSelection:FORMAT).
      WHEN 'integer':U THEN
        pcValue = STRING(INT(pcValue),hSelection:FORMAT).
      WHEN 'logical':U THEN
        pcValue = ENTRY(IF CAN-DO('yes,true':U,pcValue) THEN 1 ELSE 2,
                         hSelection:FORMAT,'/':U).
    END CASE. /* hSelection:data-type */
  END.
  
  RETURN pcValue.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getAutoRefresh) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getAutoRefresh Procedure 
FUNCTION getAutoRefresh RETURNS LOGICAL
  ( ) :
/*------------------------------------------------------------------------
Purpose - NOT in use. 
--------------------------------------------------------------------------*/

  DEFINE VARIABLE lAutoRefresh AS LOGICAL NO-UNDO.
/* Not used anywhere at this time -- saved for future use */
  {get autoRefresh lAutoRefresh}.
  RETURN lAutoRefresh.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getBrowseFields) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getBrowseFields Procedure 
FUNCTION getBrowseFields RETURNS CHARACTER
  ( ) :
/*------------------------------------------------------------------------------
  Purpose: Returns the list of fields to display in the browse when the viewAs 
           property is set to "browse" 
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cBrowseFields AS CHARACTER NO-UNDO.
  {get BrowseFields cBrowseFields}.
  RETURN cBrowseFields.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getBrowseTitle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getBrowseTitle Procedure 
FUNCTION getBrowseTitle RETURNS CHARACTER
  ( ) :
/*------------------------------------------------------------------------------
  Purpose: Returns the title to display in the browse SmartWindowContainer 
          when the ViewAs property is set to "browse" 
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cBrowseTitle AS CHARACTER NO-UNDO.
  {get BrowseTitle cBrowseTitle}.
  RETURN cBrowseTitle.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getCancelBrowseOnExit) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getCancelBrowseOnExit Procedure 
FUNCTION getCancelBrowseOnExit RETURNS LOGICAL
  (  ) :
/*------------------------------------------------------------------------------
   Purpose: Returns true if the value in the browse is NOT to be selected 
            on Exit. 
Parameters: 
     Notes: This setting should probably be set to true when ExitBrowseOnAction 
            alos is true. Because when the user Exits the browse when a value 
            is selected the close button can function as a Cancel.               
------------------------------------------------------------------------------*/
  DEFINE VARIABLE lCancelBrowse AS LOG  NO-UNDO.
  {get CancelBrowseOnExit lCancelBrowse}.
  RETURN lCancelBrowse.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getChangedEvent) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getChangedEvent Procedure 
FUNCTION getChangedEvent RETURNS CHARACTER
  ( ) :
/*------------------------------------------------------------------------------
  Purpose: Returns an optional event to publish on value-changed.  
    Notes: The developer must make sure define the corresponding SUBSCRIBE 
           in the container        
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cChangedEvent AS CHARACTER NO-UNDO.
  {get ChangedEvent cChangedEvent}.
  RETURN cChangedEvent.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDataSourceFilter) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getDataSourceFilter Procedure 
FUNCTION getDataSourceFilter RETURNS CHARACTER
  ( ) :
/*--------------------------------------------------------------------------- 
Purpose: Returns an optional filter expression for the data-source.
Notes:  
-----------------------------------------------------------------------------*/

  DEFINE VARIABLE cDataSourceFilter AS CHARACTER NO-UNDO.
  {get DataSourceFilter cDataSourceFilter}.
  RETURN cDataSourceFilter.

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
           the DataModified property of this object equals TRUE.
         - For viewas 'browser' we have stored the value (from the SDO), 
           We cannot retrieve this from the SDO when requested, because 
           the user may have repositioned the browser to another row without 
           actually selecting it. 
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hSelection      AS HANDLE    NO-UNDO.
  DEFINE VARIABLE cViewAs         AS CHARACTER NO-UNDO.
  DEFINE VARIABLE lOptional       AS LOG       NO-UNDO.
  DEFINE VARIABLE cOptionalString AS CHAR      NO-UNDO.
  DEFINE VARIABLE cValue          AS CHARACTER NO-UNDO.

  {get SelectionHandle hSelection}.  
  IF NOT VALID-HANDLE(hSelection) THEN
     RETURN ?.

  {get ViewAs cViewAs}.
  IF cViewAS = 'Browser':U THEN
  DO:
    ASSIGN 
      ghProp = WIDGET-HANDLE(ENTRY(1, TARGET-PROCEDURE:ADM-DATA, CHR(1)))
      ghProp = ghProp:BUFFER-FIELD('DataValue':U).
    RETURN IF ghProp:BUFFER-VALUE = ? THEN '?':U ELSE ghProp:BUFFER-VALUE.
  END. /* if viewas 'browser' */
  ELSE  
    RETURN  IF LENGTH(hSelection:SCREEN-VALUE) > 0 /* saves optional combo 
                                                 workaround bug 19990915-025 */
            THEN hSelection:INPUT-VALUE
            ELSE "?":U.
    

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDefineAnyKeyTrigger) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getDefineAnyKeyTrigger Procedure 
FUNCTION getDefineAnyKeyTrigger RETURNS LOGICAL
  (  ) :
/*------------------------------------------------------------------------------
   Purpose: Returns true if a persistent trigger is (to be) defined on ANY-KEY. 
Parameters:     
     Notes: Only used for the fill-in that are generated for the view-as browse 
            option.  
------------------------------------------------------------------------------*/
  ASSIGN ghProp = WIDGET-HANDLE(ENTRY(1, TARGET-PROCEDURE:ADM-DATA, CHR(1)))
         ghProp = ghProp:BUFFER-FIELD('DefineAnyKeyTrigger':U).
  RETURN ghProp:BUFFER-VALUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDisplayedField) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getDisplayedField Procedure 
FUNCTION getDisplayedField RETURNS CHARACTER
  ( ) :
/*------------------------------------------------------------------------------
  Purpose: Returns the name of the field to display in the selection
    Notes:   
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cDisplayedField AS CHARACTER NO-UNDO.
  {get DisplayedField cDisplayedField}.
  RETURN cDisplayedField.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDisplayedFields) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getDisplayedFields Procedure 
FUNCTION getDisplayedFields RETURNS CHARACTER
  ( ) :
/*------------------------------------------------------------------------------
  Purpose: Used in signature match etc.  
    Notes: We return all data-source fields:
            DisplayedField + KeyField + BrowseFields - Duplicates
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cDisplayedFields AS CHAR NO-UNDO.   
  DEFINE VARIABLE cKeyField        AS CHAR NO-UNDO.
  DEFINE VARIABLE cBrowseFields    AS CHAR NO-UNDO.
 
  {get DisplayedField cDisplayedFields}.
  {get KeyField cKeyField}.
  {get BrowseFields cBrowseFields}.
  
  ASSIGN  
      
    /* we add comma before and after so that 
       replace  "," + field + "," with one single comma works no matter where 
       the field is, using comma also ensures that we don't replace partially
       matching names */
    cBrowseFields  = ",":U + cBrowseFields + ",":U   
    cBrowseFields  = REPLACE(cBrowseFields,",":U + cKeyField + ",":U,",":U)
    cBrowseFields  = REPLACE(cBrowseFields,",":U + cDisplayedFields + ",":U,",":U)
    /* Keep the first comma in order to add unconditionally below */
    cBrowseFields  = RIGHT-TRIM(cBrowseFields,",":U). 
  
  RETURN TRIM(cDisplayedFields + (IF cKeyField <> cDisplayedFields 
                                  AND cKeyField <> "":U
                                  THEN ",":U + cKeyField 
                                  ELSE "":U)
                               +  cBrowseFields,",":U).
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDisplayValue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getDisplayValue Procedure 
FUNCTION getDisplayValue RETURNS CHARACTER
  ( ) :
/*------------------------------------------------------------------------------
  Purpose: Returns the displayvalue given the datavalue  
    Notes: If the keyfield and displayfield are the same, then keyfield value 
           (datavalue) is returned.
           If they are not the same, then if a reposition source is set, then
           returns the displayedfieldvalue that is gotten from the sdo.
           In all other cases it will search the list-item-pairs (or radio-buttons 
           for radio-sets) given the datavalue and will return the display value.
           Note: in this case, unique data values must be used otherwise the first
           displayed value found in the list will be returned.
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hSelection      AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hDataSource     AS HANDLE    NO-UNDO.
  DEFINE VARIABLE cDisplayedField AS CHAR      NO-UNDO.
  DEFINE VARIABLE cKeyField       AS CHAR      NO-UNDO.
  DEFINE VARIABLE cDataValue      AS CHAR      NO-UNDO.
  DEFINE VARIABLE lUsedPair       AS LOG       NO-UNDO.
  DEFINE VARIABLE cViewAs         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lOptional       AS LOG       NO-UNDO.

  {get SelectionHandle hSelection}.
   
  IF NOT VALID-HANDLE(hSelection) THEN
    RETURN ERROR. 

  {get UsePairedList lUsedPair}.
  {get KeyField cKeyField}.
  {get DisplayedField cDisplayedField}.
  {get Optional lOptional}.
  {get DataSource hDataSource}.
  {get ViewAs cViewAs}.
  
  /* From 9.1C we store the DisplayValue (and DataValue) for browser in 
     dataAvailable or setDataValue to avoid returning the current SDO value 
     as this may not be correct if the user has not chosen the record with 
    'default-action' */
  IF cViewAs = "browser":U THEN
  DO:
    ASSIGN 
      ghProp = WIDGET-HANDLE(ENTRY(1, TARGET-PROCEDURE:ADM-DATA, CHR(1)))
      ghProp = ghProp:BUFFER-FIELD('DisplayValue':U).

    RETURN ghProp:BUFFER-VALUE.
  END. /* if ViewAs = 'browser' */

  {get DataValue cDatavalue}.

  /* If we are not using a paired list (editable combo-boxes) OR
     the keyfield and displayfield are the same,
     the dataValue IS the display value. Even if optional
     we want to return the cDataValue. */  
  IF NOT lUsedPair OR cKeyField = cDisplayedField THEN 
    RETURN cDataValue.
     
  /* This is the case where the display value may be different than the 
     datavalue */
  IF lOptional AND (cDataValue = "?":U OR cDataValue = ?) THEN
    RETURN "?":U.
  
  /* get display value from list-item-pairs given the data value */
  IF CAN-QUERY(hSelection,'LIST-ITEM-PAIRS':U) THEN 
     cDataValue = DYNAMIC-FUNCTION('mappedEntry':U IN TARGET-PROCEDURE,
                                    {fnarg formattedValue cDataValue}, 
                                     hSelection:LIST-ITEM-PAIRS,
                                     FALSE, /* lookup 2nd return 1st */
                                     {&selectionSeparator}) /* Delimiter */ .
  ELSE /* radio set */
     cDataValue = DYNAMIC-FUNCTION('mappedEntry':U IN TARGET-PROCEDURE,
                                     cDataValue, 
                                     hSelection:RADIO-BUTTONS,
                                     FALSE, /* lookup 2nd return 1st */
                                     {&selectionSeparator}) /* Delimiter */ .
        
  /* if more than one returned in the list, then use the first */      
  IF INDEX(cDataValue,{&selectionSeparator} ) > 0 THEN
    cDataValue = ENTRY(1,cDataValue,{&selectionSeparator} ).
    
  RETURN cDataValue.
 
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getEnableOnAdd) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getEnableOnAdd Procedure 
FUNCTION getEnableOnAdd RETURNS LOGICAL
  ( ) :
/*
 NOT IN USE
*/

  DEFINE VARIABLE lEnableOnAdd AS LOGICAL NO-UNDO.
  {get EnableOnAdd lEnableOnAdd}.
  RETURN lEnableOnAdd.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getExitBrowseOnAction) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getExitBrowseOnAction Procedure 
FUNCTION getExitBrowseOnAction RETURNS LOGICAL
  (  ) :
/*------------------------------------------------------------------------------
   Purpose: Returns true if the selection of a value in the browse also should 
            Exit the browse. 
Parameters:  
     Notes: The selection of a value is triggered by DEFAULT-ACTION 
             (RETURN or double-click )
------------------------------------------------------------------------------*/
  DEFINE VARIABLE lExitBrowse AS LOG  NO-UNDO.
  {get ExitBrowseOnAction lExitBrowse}.
  RETURN lExitBrowse.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getFormat) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getFormat Procedure 
FUNCTION getFormat RETURNS CHARACTER
  ( ) :
/*------------------------------------------------------------------------------
  Purpose: Returns an overridden format  
    Notes: Only used when VeewAs is BROWSE and the dta is displayed in a fill-in.
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cFormat AS CHARACTER NO-UNDO.
  {get Format cFormat}.
  RETURN cFormat.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getHelpId) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getHelpId Procedure 
FUNCTION getHelpId RETURNS INTEGER
  ( ) :
/*------------------------------------------------------------------------------
  Purpose: Returns the optionally defined HelpId of the selection   
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE iHelpId AS INTEGER NO-UNDO.
  {get HelpId iHelpId}.
  RETURN iHelpId.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getKeyField) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getKeyField Procedure 
FUNCTION getKeyField RETURNS CHARACTER
  ( ) :
/*------------------------------------------------------------------------------
  Purpose: Returns the name of the field name which value is: 
           - received from the SmartDataViewer in setDataValue  
           - retrieved by the SmartDataViewer in getDataValue   
    Notes:   
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cKeyField AS CHARACTER NO-UNDO.
  {get KeyField cKeyField}.
  RETURN cKeyField.

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
    Notes: - "?" specifies that the data-source label is to be used
           - Blank specifies NO-LABEL   
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cLabel AS CHARACTER NO-UNDO.
  {get Label cLabel}.
  
  /* Unknown means use data-source, 
     but because it will be changed to blank in smart.p function 
     we must make it to a string */
    
  IF cLabel = ? THEN 
    cLabel = "?":U.
  RETURN cLabel.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getNumRows) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getNumRows Procedure 
FUNCTION getNumRows RETURNS INTEGER
  ( ) :
/*------------------------------------------------------------------------------
  Purpose: Returns the number of rows to display in the selection widget   
    Notes:  
------------------------------------------------------------------------------*/

  DEFINE VARIABLE iNumRows AS INTEGER NO-UNDO.
  {get NumRows iNumRows}.
  RETURN iNumRows.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getOptional) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getOptional Procedure 
FUNCTION getOptional RETURNS LOGICAL
  ( ) :
/*------------------------------------------------------------------------------
  Purpose: Returns TRUE if the selection is optional   
    Notes: If optional is TRUE the OptionalString defines the value to display.  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE lOptional AS LOGICAL NO-UNDO.
  {get Optional lOptional}.
  RETURN lOptional.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getOptionalBlank) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getOptionalBlank Procedure 
FUNCTION getOptionalBlank RETURNS LOGICAL
  ( ) :
/*------------------------------------------------------------------------------
  Purpose: Returns true if the optional value is a Blank value 
    Notes: Character fields only
------------------------------------------------------------------------------*/
  DEFINE VARIABLE lOptionalBlank AS LOGICAL NO-UNDO.
  {get OptionalBlank lOptionalBlank}.
  RETURN lOptionalBlank.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getOptionalString) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getOptionalString Procedure 
FUNCTION getOptionalString RETURNS CHARACTER
  ( ) :
/*------------------------------------------------------------------------------
  Purpose: Returns the value to display as an optional value  when the Optional 
           property is set to true.
    Notes: 
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cOptionalString AS CHARACTER NO-UNDO.
  {get OptionalString cOptionalString}.
  RETURN cOptionalString.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getRepositionDataSource) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getRepositionDataSource Procedure 
FUNCTION getRepositionDataSource RETURNS LOGICAL
  ( ) :
/*------------------------------------------------------------------------------
   Purpose: Returns true if the data-source is to be repositioned on 
            VALUE-CHANGED of the select.  
Parameters: . 
     Notes: This is not needed for the view-as browse option.
            This must be set to true if for example the data-source also 
            is a data-source for other objects and those objects need to be 
            refreshed when a value is changed in the combo-box.               
------------------------------------------------------------------------------*/
  DEFINE VARIABLE lRepositionDataSource AS LOG    NO-UNDO.
  {get RepositionDataSource lRepositionDataSource}.
  RETURN lRepositionDataSource.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getSort) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getSort Procedure 
FUNCTION getSort RETURNS LOGICAL
  ( ) :
/*------------------------------------------------------------------------------
  Purpose: Returns TRUE if the selection is to be sorted.   
    Notes:   
------------------------------------------------------------------------------*/
  DEFINE VARIABLE lSort AS LOGICAL NO-UNDO.
  {get Sort lSort}.
  RETURN lSort.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getStartBrowseKeys) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getStartBrowseKeys Procedure 
FUNCTION getStartBrowseKeys RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
   Purpose: Return the list of Keylabels or KeyFunctions that starts the browse.  
Parameters: 
     Notes: The keys will only be used if DefineAnyKeyTrigger is true
            There's currently no distinction between keyfunctions or labels.
            The anyKey procedure checks the list and starts the browse if 
            any entry in the list matches the LAST-EVENT:FUNCTION or :LABEL.                       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cBrowseKeys AS CHAR   NO-UNDO.
  {get StartBrowseKeys cBrowseKeys}.
  RETURN cBrowseKeys.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getToolTip) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getToolTip Procedure 
FUNCTION getToolTip RETURNS CHARACTER
  ( ) :
/*------------------------------------------------------------------------------
  Purpose: Returns the optionally defined Tooltip for the selection   
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cToolTip AS CHARACTER NO-UNDO.
  {get ToolTip cToolTip}.
  RETURN cToolTip.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getUsePairedList) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getUsePairedList Procedure 
FUNCTION getUsePairedList RETURNS LOGICAL
  (  ) :
/*------------------------------------------------------------------------------
  Purpose: Editable combo-boxes does not use paired list.  
           We need to know this when we build the list before the widget 
           has been created. 
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cViewAs AS CHARACTER  NO-UNDO.  
  
  {get ViewAs cViewAs}.

  IF cViewAs BEGINS 'combo-box:':U THEN
    RETURN NOT ENTRY(2,cViewas,':':U) <> 'drop-down-list':U.
  ELSE
    RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getViewAs) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getViewAs Procedure 
FUNCTION getViewAs RETURNS CHARACTER
  ( ) :
/*------------------------------------------------------------------------------
  Purpose: Returns the ViewAs definition  of the selection   
           - combo-box,radio-set,selection-list and browse 
           - Uses colon as separator to define SUB-TYPE for combo-box or 
             horizontal/vertical radio-set   
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cViewAs AS CHARACTER NO-UNDO.
  {get ViewAs cViewAs}.
  RETURN cViewAs.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-repositionDataSource) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION repositionDataSource Procedure 
FUNCTION repositionDataSource RETURNS LOGICAL
  (pcValue AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose: Reposition the current dataSource according to the keyfield 
    Notes: Conditionally called from setDataValue and valueChanged.     
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cKeyField         AS CHAR    NO-UNDO.
  DEFINE VARIABLE hDataSource       AS HANDLE  NO-UNDO.
  DEFINE VARIABLE lFound            AS LOGICAL NO-UNDO.

  {get KeyField cKeyField}.
  {get DataSource hDataSource}.
     
  IF NOT VALID-HANDLE(hDataSource) THEN
    RETURN FALSE.
  
  /* findRowWhere will make the SDO publish dataAvailable. We set Modify false
     to tell dataAvailable not to call valueChanged. 
      Case 1: When this is called from valueChanged to avoid loop     
      Case 2: When this is called from setDataValue to avoid setModified=true */
  
  {set Modify FALSE}.   
  
  lFound = DYNAMIC-FUNC("findRowWhere":U IN hDataSource, 
                         cKeyField,
                         pcValue,
                        '':U).

  {set Modify TRUE}. 

  RETURN lFound.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setAutoRefresh) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setAutoRefresh Procedure 
FUNCTION setAutoRefresh RETURNS LOGICAL
  ( pilAutorefresh AS LOGICAL ) :
/* NOT USED -- saved for future use */
  {set AutoRefresh pilAutoRefresh}.
  RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setBrowseFields) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setBrowseFields Procedure 
FUNCTION setBrowseFields RETURNS LOGICAL
  ( picBrowseFields AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose: Stores the list of fields to display in the browse when the viewAs 
           property is set to "browse" 
Parameters: INPUT picBrowseFields - comma separated list of fieldnames.     
    Notes:  
------------------------------------------------------------------------------*/

  {set BrowseFields picBrowseFields}.
  RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setBrowseTitle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setBrowseTitle Procedure 
FUNCTION setBrowseTitle RETURNS LOGICAL
  ( picBrowseTitle AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose: Stores the text to display as title in the SmartContainer Window when
           the viewAs property is set to "browse" 
Parameters: INPUT picBrowseTitle  - character.    
    Notes:  
------------------------------------------------------------------------------*/
  {set BrowseTitle picBrowseTitle}.
  RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setCancelBrowseOnExit) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setCancelBrowseOnExit Procedure 
FUNCTION setCancelBrowseOnExit RETURNS LOGICAL
  ( plCancelBrowse AS LOG ) :
/*------------------------------------------------------------------------------
   Purpose: Set to true if the value in the browse is NOT to be selected 
            on Exit. 
Parameters: 
     Notes: This setting should probably be set to true when ExitBrowseOnAction 
            also is true. Because when the user Exits the browse when a value 
            is selected the close button can function as a Cancel.               
------------------------------------------------------------------------------*/
  {set CancelBrowseOnExit plCancelBrowse}.
  RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setChangedEvent) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setChangedEvent Procedure 
FUNCTION setChangedEvent RETURNS LOGICAL
  ( picChangedEvent AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose: Stores an optional event to publish on value-changed.  
Parameters: INPUT picChangedEvent  - character.    
    Notes: The developer must make sure define the corresponding SUBSCRIBE 
           usually in the SmartDataViewer container        
------------------------------------------------------------------------------*/
  {set ChangedEvent picChangedEvent}.
  RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setDataSourceFilter) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setDataSourceFilter Procedure 
FUNCTION setDataSourceFilter RETURNS LOGICAL
  ( picDataSourceFilter AS CHARACTER ) :
/*--------------------------------------------------------------------------- 
Purpose: Stores an optional filter expression for the data-source.
Parameters: INPUT picdataSourcefilter - character - query expression 
Notes:  
-----------------------------------------------------------------------------*/
  picDataSourceFilter = REPLACE(picDataSourceFilter,"'":U,"~"":U).
  {set DataSourceFilter picDataSourceFilter}.
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
                          - ?   Passed from viewer when no data
                          - '?' Future support of unknown in data when 
                                list-item-pairs is fixed to handle this  
    Notes: This is called by the SmartDataViewer if it encounters this PROCEDURE
           in the list of DisplayedHandles. 
           Note that the actual display of the fill-in (browser) is done in
           displayedFields.
           The RepositionDataSource option is currently only used to optionally
           enforce the browse to reposition when the 'view-as' <> 'browse'. 
         - The propery value is stored in the abprops temp-table when viewAs 
           'browser' because getDataValue cannot retrieve the value from the 
           SDO as the SDO may have moved to another row without being explicitly
           selected with default-action.  
         - We call this internally for 'browser' just to store the value and 
           avoid a potential loop by making the reposition logic only happen 
           when source <> target.  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hSelection        AS HANDLE NO-UNDO.
  DEFINE VARIABLE cViewAs           AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cKeyField         AS CHAR   NO-UNDO.
  DEFINE VARIABLE cDisplayedField   AS CHAR   NO-UNDO.
  DEFINE VARIABLE lOptional         AS LOG    NO-UNDO.
  DEFINE VARIABLE lAvailable        AS LOG    NO-UNDO.
  DEFINE VARIABLE cOptionalString   AS CHAR   NO-UNDO.
  DEFINE VARIABLE lRepositionSource AS LOG    NO-UNDO.
  DEFINE VARIABLE deInVal           AS DECIMAL DECIMALS 9 NO-UNDO.

  {get SelectionHandle hSelection}.
  
  IF NOT VALID-HANDLE(hSelection) THEN
    RETURN FALSE.

  {get ViewAs cViewAs}.

  /* We must NOT repositionDataSource if called internally.  */  
  IF SOURCE-PROCEDURE <> TARGET-PROCEDURE THEN
  DO:
   {get RepositionDataSource lRepositionSource}.
    IF cViewAs ='Browser':U OR lRepositionSource THEN
      lAvailable = {fnarg repositionDataSource pcValue}.
  END.

  IF cViewAs ='Browser':U THEN
  DO:
    /* When the SmartSelect is browsed we store the DataValue, because we may 
       not be able to get the the value from the SDO, since the user may 
       have moved to another row in the browser without actually selecting
       the row with 'default-action' */           
    ASSIGN 
      ghProp = WIDGET-HANDLE(ENTRY(1, TARGET-PROCEDURE:ADM-DATA, CHR(1)))
      ghProp = ghProp:BUFFER-FIELD('DataValue':U)
      ghProp:BUFFER-VALUE = pcValue.

    IF NOT lAvailable AND SOURCE-PROCEDURE <> TARGET-PROCEDURE THEN
    DO:
      IF pcValue = '?':U OR pcValue = ? THEN
      DO:
        {get Optional lOptional}.
        
        IF lOptional THEN 
        DO:
          {get OptionalString cOptionalString}.
          pcValue = cOptionalString.
        END.
       /* DisplayValue return '?' for unknown, which means allowed unknown 
         (? means really unknown probably error) */
        {set DisplayValue '?':U}.       
      END. /* pcValue '?' or ? */
    
      {get KeyField cKeyField}.
      {get DisplayedField cDisplayedField}.
      
      hSelection:SCREEN-VALUE = IF cKeyField = cDisplayedField OR lOptional
                                THEN pcValue
                                ELSE "":U. 
      {set Modify TRUE}.
    END. /* not lAvailable  */
  END. /* cviewAs = 'Browser' */
  ELSE DO:
   
    IF hSelection:TYPE = "COMBO-BOX":U THEN 
    DO:
      /* We allow 'bogus' data in editable combo-box, but this only works when 
         screen-value is unknown, so set list-items = list-items just in case */
      IF hSelection:SUBTYPE <> "drop-down-list":U THEN
         hSelection:LIST-ITEMS = hSelection:LIST-ITEMS.

      /* A COMBO-BOX of subtype drop-down-list is formatted, so we must apply 
         the format to be able to assign the screen-value.*/
      IF hSelection:SUBTYPE = "drop-down-list":U THEN
        pcValue = {fnarg formattedValue pcValue}.

    END. /* if combo-box */

    hSelection:SCREEN-VALUE = pcValue NO-ERROR.
    
    /* In case the assign of screen-value failed we blank the widget so it 
       doesn't show the previous value. Error-staus:error is no, so we check 
       for the specific error message. Note that there are cases where the 9.1B
       check that compared screen-value and pcValue failed also when data was 
       ok. 
       
       A pcValue of unknown gives no error, but does not change screen-value 
       either, so we need to blank the field also in that case as unknown is 
       an indicator that no data exists in the viewer container 
       (support for unknown in data will be handled with '?' when the 
        list-item-pairs supports it) */
 
    IF ERROR-STATUS:GET-NUMBER(1) = 4058 OR pcValue = ? THEN
    DO:
      IF hSelection:TYPE = "COMBO-BOX":U 
      OR hSelection:TYPE = "SELECTION-LIST":U THEN 
      DO:
        IF hSelection:NUM-ITEMS > 0 THEN 
        DO:
         /* Logic above allows bogus data if editable combo with list-items
           (however 9.1B did arrive here because it used to compare 
            screen-value with pcValue to detect errors). We check for list-items
            or list-item-pairs here even if get-number now should avoid that.*/               
          IF hSelection:SUBTYPE = "drop-down-list":U THEN
            ASSIGN hSelection:LIST-ITEM-PAIRS = hSelection:LIST-ITEM-PAIRS 
                                                                  NO-ERROR. 
          ELSE IF hSelection:LIST-ITEMS <> ? /* do we need this?*/ THEN
            ASSIGN hSelection:LIST-ITEMS = hSelection:LIST-ITEMS NO-ERROR.
        END. /* num-items > 0 */
      END. /* hSelection:TYPE = "COMBO-BOX":U */
    END. /* error-status:get-number */  
    
  END. /* else (not fill-in or editable combo) */

  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setDefineAnyKeyTrigger) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setDefineAnyKeyTrigger Procedure 
FUNCTION setDefineAnyKeyTrigger RETURNS LOGICAL
  ( plTrigger AS LOG ) :
/*------------------------------------------------------------------------------
   Purpose: Set to true if a persistent trigger is to be defined on ANY-KEY. 
            The persistent trigger is also defined if true.   
Parameters: plTrigger - Logical    
     Notes: Only used for the fill-in that are generated for the view-as browse 
            option.  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hSelection AS HANDLE NO-UNDO.
  
  IF plTrigger THEN
  DO:
    {get SelectionHandle hSelection}.

    IF VALID-HANDLE(hSelection) THEN
      ON ANY-KEY OF hSelection PERSISTENT 
         RUN anyKey IN TARGET-PROCEDURE. 
  END.

  ASSIGN ghProp = WIDGET-HANDLE(ENTRY(1, TARGET-PROCEDURE:ADM-DATA, CHR(1)))
         ghProp = ghProp:BUFFER-FIELD('DefineAnyKeyTrigger':U)
         ghProp:BUFFER-VALUE = plTrigger.
  
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setDisplayedField) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setDisplayedField Procedure 
FUNCTION setDisplayedField RETURNS LOGICAL
  ( picDisplayedField AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose: Stores the name of the field to display in the selection
Parameters: INPUT picDisplayedField - fieldname    
    Notes:   
------------------------------------------------------------------------------*/
  {set DisplayedField picDisplayedField}.
  RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setDisplayValue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setDisplayValue Procedure 
FUNCTION setDisplayValue RETURNS LOGICAL
  (pcValue AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose: Store the DisplayValue 
Parameter: Value to store      
    Notes: Exists as function because getDataValue has additional logic.
           Used internally for viewas 'browser' to store the value when   
           retrieved from the SDO. getDataValue cannot retrieve this  from the 
           SDO because the user may have have repositioned the browser to 
           another row without actually selecting it.
------------------------------------------------------------------------------*/
   ASSIGN 
      ghProp = WIDGET-HANDLE(ENTRY(1, TARGET-PROCEDURE:ADM-DATA, CHR(1)))
      ghProp = ghProp:BUFFER-FIELD('DisplayValue':U).
      ghProp:BUFFER-VALUE = pcValue.
  
  RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setEnableOnAdd) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setEnableOnAdd Procedure 
FUNCTION setEnableOnAdd RETURNS LOGICAL
  ( pilEnableOnAdd AS LOGICAL ) :
/* not in use */
  {set EnableOnAdd pilEnableOnAdd}.
  RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setExitBrowseOnAction) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setExitBrowseOnAction Procedure 
FUNCTION setExitBrowseOnAction RETURNS LOGICAL
  ( plExitBrowse AS LOG ) :
/*------------------------------------------------------------------------------
   Purpose: Set to true if the selection of a value in the browse also should 
            Exit the browse. 
Parameters: plExitBrowse as logical 
     Notes: The selection of a value is triggered by DEFAULT-ACTION 
             (RETURN or double-click )
------------------------------------------------------------------------------*/
  {set ExitBrowseOnAction plExitBrowse}.
  RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setFormat) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setFormat Procedure 
FUNCTION setFormat RETURNS LOGICAL
  ( pcFormat AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose: Sets the format of the Displayedfield  
Parameters: INPUT pcFormat - Valid format   
    Notes: Only used when ViewAs is BROWSE and the displayed field is a fill-in.
------------------------------------------------------------------------------*/
  {set Format pcFormat}.
  RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setHelpId) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setHelpId Procedure 
FUNCTION setHelpId RETURNS LOGICAL
  ( piHelpId AS INTEGER ) :
/*------------------------------------------------------------------------------
  Purpose: Stores the optionally defined HelpId of the selection   
Parameters: INPUT pcHelpId - Integer   
    Notes:  
------------------------------------------------------------------------------*/
  {set HelpId piHelpId}.
  RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setKeyField) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setKeyField Procedure 
FUNCTION setKeyField RETURNS LOGICAL
  ( pcKeyField AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose: Stores the name of the field to use as the keyfield in the selection
Parameters: INPUT picKeyField - fieldname    
    Notes: - received from the SmartDataViewer in setDataValue  
           - retrieved by the SmartDataViewer in getDataValue   
------------------------------------------------------------------------------*/

  {set KeyField pcKeyField}.
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
    Notes: - "?" specifies that the data-source label is to be used
           - Blank specifies NO-LABEL   
------------------------------------------------------------------------------*/
  
  {set Label pcLabel}.
  RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setNumRows) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setNumRows Procedure 
FUNCTION setNumRows RETURNS LOGICAL
  ( piNumRows AS INTEGER ) :
/*------------------------------------------------------------------------------
  Purpose: Stores the number of rows to use in the selection. 
Parameters: INPUT piNumRows - integer         
    Notes:  
------------------------------------------------------------------------------*/

  {set NumRows piNumRows}.
  RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setOptional) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setOptional Procedure 
FUNCTION setOptional RETURNS LOGICAL
  ( pilOptional AS LOGICAL ) :
/*------------------------------------------------------------------------------
  Purpose: set to TRUE if the selection is supposed to be optional   
Parameters: INPUT pilOptional - logical    
    Notes: If optional is TRUE the OptionalString defines the value to display.  
------------------------------------------------------------------------------*/
  {set Optional pilOptional}.
  RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setOptionalBlank) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setOptionalBlank Procedure 
FUNCTION setOptionalBlank RETURNS LOGICAL
  ( plOptionalBlank AS LOGICAL ) :
/*------------------------------------------------------------------------------
  Purpose: set to yes if the optional value is a Blank value.  
Parameters: INPUT plOptionalBlank - Logical   
    Notes: NOT IN USE
----------------------------------------------------------------------*/    
  {set OptionalBlank plOptionalBlank}.
  RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setOptionalString) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setOptionalString Procedure 
FUNCTION setOptionalString RETURNS LOGICAL
  ( picOptionalString AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose: set to string to display for non-values if Optional is true  
Parameters: INPUT picOptionalString - Character   
    Notes:
----------------------------------------------------------------------*/    
  {set OptionalString picOptionalString}.
  RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setRepositionDataSource) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setRepositionDataSource Procedure 
FUNCTION setRepositionDataSource RETURNS LOGICAL
  ( plReposSource AS LOG ) :
/*------------------------------------------------------------------------------
   Purpose: Set to true if the data-source is to be repositioned on 
            VALUE-CHANGED.  
Parameters: plReposSource as logical. 
     Notes: This is not needed for the view-as browse option.
            This must be set to true if for example the data-source also 
            is a data-source for other objects and those objects need to be 
            refreshed when a value is changed in the combo-box.               
------------------------------------------------------------------------------*/
  {set RepositionDataSource plReposSource}.
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
  Purpose: set to TRUE if the selection is to be sorted.   
Parameters: INPUT pilsort - logical   
  Notes:   
------------------------------------------------------------------------------*/
  {set Sort pilSort}.
  RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setStartBrowseKeys) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setStartBrowseKeys Procedure 
FUNCTION setStartBrowseKeys RETURNS LOGICAL
  ( picBrowseKeys AS CHARACTER ) :
/*------------------------------------------------------------------------------
   Purpose: Stores a list of Keylabels or KeyFunctions that starts the browse.  
Parameters: INPUT picBrowseKeys - Comma separated list of labels or functions
     Notes: The keys will only be used if DefineAnyKeyTrigger is true
            There's currently no distinction between keyfunctions or labels.
            The anyKey procedure checks the list and starts the browse if 
            any entry in the list matches the LAST-EVENT:FUNCTION or :LABEL.                       
------------------------------------------------------------------------------*/
  {set StartBrowseKeys picBrowseKeys}.
  RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setToolTip) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setToolTip Procedure 
FUNCTION setToolTip RETURNS LOGICAL
  ( pcToolTip AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose: Store the optionally defined Tooltip for the selection   
Parameters: INPUT pcTooltip - character   
  Notes:  
------------------------------------------------------------------------------*/
  {set ToolTip pcToolTip}.
  RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setViewAs) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setViewAs Procedure 
FUNCTION setViewAs RETURNS LOGICAL
  ( picViewAs AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose: Returns the ViewAs definition  of the selection   
Parameters: INPUT picViewas - character   
           - combo-box,radio-set,selection-list OR browse 
           - Uses colon as separator to define SUB-TYPE for combo-box or 
             horizontal/vertical radio-set,   
    Notes:  
------------------------------------------------------------------------------*/
  {set ViewAs picViewAs}.
  RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

