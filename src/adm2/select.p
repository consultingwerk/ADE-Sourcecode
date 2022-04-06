&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/***********************************************************************
* Copyright (C) 2000,2007 by Progress Software Corporation. All rights *
* reserved. Prior versions of this work may contain portions           *
* contributed by participants of Possenet.                             *
*                                                                      *
***********************************************************************/
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

&IF DEFINED(EXCLUDE-getFieldHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getFieldHandle Procedure 
FUNCTION getFieldHandle RETURNS HANDLE
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

&IF DEFINED(EXCLUDE-getLabel) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getLabel Procedure 
FUNCTION getLabel RETURNS CHARACTER
  ( )  FORWARD.

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

&IF DEFINED(EXCLUDE-getParentFieldHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getParentFieldHandle Procedure 
FUNCTION getParentFieldHandle RETURNS HANDLE
  (   )  FORWARD.

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

&IF DEFINED(EXCLUDE-getSelectionHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getSelectionHandle Procedure 
FUNCTION getSelectionHandle RETURNS HANDLE
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

&IF DEFINED(EXCLUDE-setLabel) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setLabel Procedure 
FUNCTION setLabel RETURNS LOGICAL
  (pcLabel AS CHARACTER)  FORWARD.

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

&IF DEFINED(EXCLUDE-setSelectionHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setSelectionHandle Procedure 
FUNCTION setSelectionHandle RETURNS LOGICAL
  ( phValue AS HANDLE )  FORWARD.

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

&IF DEFINED(EXCLUDE-validateField) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD validateField Procedure 
FUNCTION validateField RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-validateMessage) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD validateMessage Procedure 
FUNCTION validateMessage RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

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
         WIDTH              = 63.2.
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
    DEFINE VARIABLE cBrowseKeys AS CHAR   NO-UNDO.
    DEFINE VARIABLE hButton     AS HANDLE NO-UNDO.

    {get StartBrowseKeys cBrowseKeys}.
    
    /* Currently we check for both labels and functions. 
       There is a theoretic potential for a collison here? */
    IF CAN-DO(cBrowseKeys,LAST-EVENT:FUNCTION) 
    OR CAN-DO(cBrowseKeys,LAST-EVENT:LABEL) THEN
    DO:
    /* If the SmartSelect Lookup button is disabled, we assume that we should
       not perform a lookup as this probably hads been set by disableButton */
      {get ButtonHandle hButton}.
      IF hButton:SENSITIVE = TRUE THEN
      DO:
        RUN initializeBrowse IN TARGET-PROCEDURE.
        RETURN NO-APPLY.
      END.
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
  DEFINE VARIABLE lExitOnAction    AS LOG       NO-UNDO.
  DEFINE VARIABLE lCancelOnExit    AS LOG       NO-UNDO.
  DEFINE VARIABLE cSearchField     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDbField         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iNumRows         AS INTEGER    NO-UNDO.
  DEFINE VARIABLE hDataSource      AS HANDLE     NO-UNDO.

  /** Get the SmartSelect properties that need to be used by the browse */  
  &SCOPED-DEFINE xp-assign
  {get BrowseFields cBrowseFields}
  {get ExitBrowseOnAction lExitOnAction}
  {get CancelBrowseOnExit lCancelOnExit}
  {get NumRows iNumRows}
  {get DisplayedField cSearchField}
  {get DataSource hDataSource}
  .  
  &UNDEFINE xp-assign
  
  IF VALID-HANDLE(hDataSource) THEN
  DO:
    /* Search/sort on calculated fields is currently not supported 
       So if this is an data class but not a dbfield use the keyfield.  */
    IF NOT {fnarg instanceOf 'DataView':U hDataSource} THEN 
    DO:
      cDbField = {fnarg columnDbColumn cSearchField hDataSource}.      
      IF cDbField = '':U THEN
      DO:
        {get KeyField cSearchField}.
      END.
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
  SUBSCRIBE PROCEDURE TARGET-PROCEDURE TO 'rowSelected':U IN phBrowseObject.

  RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-chooseButton) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE chooseButton Procedure 
PROCEDURE chooseButton :
/*------------------------------------------------------------------------------
   Purpose:  Choose button event handler that sets focus if required before 
             calling initalizeBrowse. 
  Parameters:  <none>
  Notes:     The lookup button is defined as no-focus. 'Entry' is applied
             to the fill-in in order to make the lookup fill-in and button 
             behave as a single widget and fire leave of other widgets also 
             when the user clicks directly on the button. 
------------------------------------------------------------------------------*/  
  DEFINE VARIABLE hField AS HANDLE     NO-UNDO.
  
  {get FieldHandle hField}.

  IF FOCUS <> hField THEN
    APPLY 'ENTRY':U TO hField.

  RUN initializeBrowse IN TARGET-PROCEDURE.

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
  Parameters: INPUT PcMode 
                - Blank - called from rowSelected, which is the DefaultAction 
                          event of the browser. 
                - all other values are unimportant              
  Notes:     The datasource can be navigated without actually selecting anything,
             so a blank pcMode or the internal Modify property is used to signal
             that the SDO's values are to be used to set and display this objects
             values.              
           - All positioning done from this object will set Modify to true 
             before calling a poistional method in the SDO to ensure that values
             are received and stored here.             
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pcMode AS CHAR No-UNDO.
 
  DEFINE VARIABLE hDataSource      AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cDisplayedField  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDisplayValue    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cKeyField        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hSelection       AS HANDLE     NO-UNDO.
  DEFINE VARIABLE lModify          AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cNewValue        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cOldValue        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cOldDisplayValue AS CHARACTER  NO-UNDO.

  /* no datasource here is unlikely, but it would be meaningless so just return*/ 
  {get DataSource hDataSource}.
  IF NOT VALID-HANDLE(hDataSource) THEN
    RETURN.
  /* The datasource can be navigated without actually selecting anything,
     so unless we are in modify mode (valuechanged, leave) or called from 
     rowSelected (pcMode = '') then just ignore this*/
  {get Modify lModify}. 
  IF pcMode > '':U AND NOT lModify THEN
    RETURN.
 
  &SCOPED-DEFINE xp-assign
  {set Modify FALSE} /* Turn off modify mode */
  {get SelectionHandle hSelection}.
  &UNDEFINE xp-assign
  IF VALID-HANDLE(hSelection) AND hSelection:TYPE = "FILL-IN":U THEN
  DO:
    &SCOPED-DEFINE xp-assign
    {get DisplayedField cDisplayedField}
    {get KeyField cKeyField}
    {get DisplayValue cOldDisplayValue}        
    {get DataValue cOldValue}
    .             
    &UNDEFINE xp-assign
    ASSIGN
      cNewValue     = {fnarg columnValue cKeyField hDataSource}
      cDisplayValue = {fnarg columnValue cDisplayedField hDataSource}.

    IF cNewValue <> cOldValue THEN
       /* setDataValue does not call repositionDataSource when called internally
          (currently not at all for fill-in... ) */
      {set DataValue cNewValue}.

    IF cOldDisplayValue <> hSelection:INPUT-VALUE
    OR cOldDisplayValue <> cDisplayValue   THEN
    DO:
      ASSIGN 
        cDisplayValue           = {fnarg columnValue cDisplayedField hDataSource}
        cNewValue               = {fnarg columnValue cKeyField hDataSource}
        hSelection:SCREEN-VALUE = cDisplayValue    
        .
      {set DisplayValue cDisplayValue}.  

      /* if not called from setDataValue then valuechanged  */
      IF cNewValue <> cOldValue THEN
        /* valuechanged does not call repositionDataSource when DataValue
           matches datasource */
        RUN valueChanged IN TARGET-PROCEDURE.
    END.
  END. /* valid hSelection and fill-in */
  
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

&IF DEFINED(EXCLUDE-disableButton) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disableButton Procedure 
PROCEDURE disableButton :
/*------------------------------------------------------------------------------
  Purpose:     In certain instances, i.e. when we modify a specific record,
               we don't want a user to use a specific SmartSelect to find
               another record and potentially modify another record. For this
               reason we would just disable the specific SmartSelect's button
               and Browser to prevent the use of the lookup.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hSelection       AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hButton          AS HANDLE    NO-UNDO.
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
     
      ASSIGN hButton:SENSITIVE = FALSE.
    END. 
  END.

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

&IF DEFINED(EXCLUDE-enableButton) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enableButton Procedure 
PROCEDURE enableButton :
/*------------------------------------------------------------------------------
  Purpose:    If the SmartSelect button was disabled because the programmer did
              not want the user to do a lookup, this procedure will enable the
              button again
  Parameters: <NONE>
  Notes:      
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
     {get ButtonHandle hButton}.
    
     ASSIGN hButton:SENSITIVE = TRUE.
   END.
 END.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-enableField) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enableField Procedure 
PROCEDURE enableField :
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
     /* IF cKeyField = cDisplayedField THEN */
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

&IF DEFINED(EXCLUDE-enterSelect) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enterSelect Procedure 
PROCEDURE enterSelect :
/*------------------------------------------------------------------------------
  Purpose:     Trigger fired on entry of smartselect field
  Parameters:  <none>
  Notes:        
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hSelection            AS HANDLE       NO-UNDO.
  DEFINE VARIABLE hContainer            AS HANDLE       NO-UNDO.
  
  {get SelectionHandle hSelection}.
  {get containerSource hContainer}.
  PUBLISH "lookupEntry":U FROM hContainer
             (INPUT hSelection:INPUT-VALUE,  /* current selection value */
              INPUT TARGET-PROCEDURE         /* handle of lookup */
             ).
  
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
  DEFINE VARIABLE lOpen            AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE cValue           AS CHARACTER NO-UNDO.

  {get uibMODE cUIBmode}.
  
  IF cuibMode BEGINS "DESIGN":U THEN 
    RETURN. 
  
  {get BrowseObject hBrowseObject}.
  
  {get BrowseContainer hBrowseContainer}.
  IF NOT VALID-HANDLE(hBrowseContainer) THEN 
  DO: 
    &SCOPED-DEFINE xp-assign
    {get ContainerSource hContainer}
    {get DataSource hDataSource}
    {get BrowseWindowProcedure cBrowseWinProc}
    .
    &UNDEFINE xp-assign
    
    RUN constructObject IN hContainer 
           (cBrowseWinProc,
            ?,
            "":U,
            OUTPUT hBrowseContainer).    
    
    &SCOPED-DEFINE xp-assign
    {set BrowseContainer hBrowseContainer}
    {get BrowseTitle cBrowseTitle}
    .
    &UNDEFINE xp-assign    
    {get ContainerHandle hBrowseWindow hBrowseContainer}.
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
    
    &SCOPED-DEFINE xp-assign
    {get DataValue cValue}
    {get FieldEnabled lEnabled}
    .
    &UNDEFINE xp-assign
    
    {fnarg repositionDataSource cValue}.
     /* deal with openoninit false + invalid DataValue */
    {get QueryOpen lOpen hDataSource}.
    IF NOT lOpen THEN 
      {fn openQuery hDataSource}.

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
           the ChangedEvent and refreshObject if necessary and to create the 
           widgets in initializeSelection.      
  Parameters:  <none>
  Notes:    
---------------------------------------------------------------------------*/
  DEFINE VARIABLE cEvent       AS CHAR   NO-UNDO.
  DEFINE VARIABLE hContainer   AS HANDLE NO-UNDO.
  DEFINE VARIABLE cUIBMode     AS CHAR   NO-UNDO.
  DEFINE VARIABLE hParentField AS HANDLE NO-UNDO.
   
  RUN SUPER.
  
  {get ChangedEvent cEvent}.
  {get ContainerSource hContainer}.    
  
  IF VALID-HANDLE(hContainer) AND cEvent NE "":U THEN
  DO:
    {get UIBMode cUIBMode}.    
    IF NOT (cUIBMode BEGINS "DESIGN":U)  THEN
       SUBSCRIBE PROCEDURE hContainer TO cEvent IN TARGET-PROCEDURE.
  END.
  
  /* Check if we have a parent field and subscribe to 'refreshObject' if we do.  
     We ignore the QueryOpened event if the parentfield is not in synch 
     with its datasource and thus need to be told when to refresh again. 
     The parent will publish 'refreshObject' from rowSelected to signal 
     that it is in synch with its source. */ 
  {get ParentFieldHandle hParentField}.
  if valid-handle(hParentField) then
     subscribe procedure target-procedure to "refreshObject":U in hParentField. 
  
  RUN initializeSelection IN TARGET-PROCEDURE.

RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-initializeSelection) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeSelection Procedure 
PROCEDURE initializeSelection :
/*-----------------------------------------------------------------------------
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
  DEFINE VARIABLE iNumRows      AS INTEGER   NO-UNDO.
  DEFINE VARIABLE cList         AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cUIBMode      AS CHARACTER NO-UNDO.
  DEFINE VARIABLE lAnyKey       AS LOG       NO-UNDO.
  DEFINE VARIABLE cFieldName    AS CHARACTER NO-UNDO.
  DEFINE VARIABLE lSDOInit      AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE lLocal        AS LOGICAL    NO-UNDO.

  {get ContainerHandle hFrame}.
    
  hParentFrame = hFrame:FRAME.
    
  IF NOT VALID-HANDLE(hParentFrame) THEN 
    RETURN.
  
  {fn destroySelection}.
  &SCOPED-DEFINE xp-assign
  {get DisplayedField cDisplayedField}
  {get KeyField cKeyField}
  {get Label cLabel}
  {get ToolTip cToolTip}
  {get HelpId iHelpId}
  {get Format cKeyFormat}
  {get ViewAs cViewAs}
  {get Sort lSort}
  {get NumRows iNumRows}
  {get DataSource hDataSource}  
  {get UIBMode cUIBmode}
   . 
  &UNDEFINE xp-assign
  
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
    {get ObjectInitialized  lSDOInit hDataSource}.
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
    END. /* not uibmode begins design */     
    
    cKeyFormat = IF cKeyFormat = '?':U OR cKeyFormat = ? OR cKeyFormat = '':U
                 THEN {fnarg columnFormat cKeyField hDataSource}
                 ELSE cKeyFormat.
      
  END. /* if valid sdo and cDisplayedField <> '' */
    
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

      IF cKeyDataType = ? THEN
      DO:
        /* Unknown means that the field probably was not defined in the source */
        IF  NOT (cUIBMode BEGINS "Design":U) THEN
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
        ELSE
          cKeyDataType = cDataType.
      END.
    END. /* keyfield <> displayedfield and valid data-source */ 
    ELSE
      cKeyDataType = cDataType.
    
    /* If the SDO is initialized we build the list now, otherwise  
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
                 HIDDEN           = TRUE
                 DELIMITER        = {&selectionSeparator}
                 SENSITIVE        = FALSE.

        IF DYNAMIC-FUNCTION('getUseWidgetID':U IN TARGET-PROCEDURE) THEN
          RUN assignWidgetID IN TARGET-PROCEDURE (INPUT hSelection, INPUT 2,
                                                  INPUT ?,          INPUT 0).
        ASSIGN hSelection:HIDDEN = FALSE NO-ERROR.

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
                 HIDDEN           = TRUE
                 SENSITIVE        = FALSE.

        IF DYNAMIC-FUNCTION('getUseWidgetID':U IN TARGET-PROCEDURE) THEN
          RUN assignWidgetID IN TARGET-PROCEDURE (INPUT hSelection, INPUT 2,
                                              INPUT ?,          INPUT 0).
        ASSIGN hSelection:HIDDEN = FALSE NO-ERROR.
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
                 FORMAT           = IF cUIBMode BEGINS 'design'
                                    THEN hSelection:FORMAT
                                    ELSE cKeyFormat 
                 WIDTH-PIXELS     = hFrame:WIDTH-PIXELS 
                                    - (IF hSelection:SUBTYPE = "SIMPLE":U 
                                       THEN 2 
                                       ELSE 0)
                 FRAME            = hFrame
                 HIDDEN           = TRUE
                 SENSITIVE        = FALSE.

        IF DYNAMIC-FUNCTION('getUseWidgetID':U IN TARGET-PROCEDURE) THEN
          RUN assignWidgetID IN TARGET-PROCEDURE (INPUT hSelection, INPUT 2,
                                              INPUT ?,          INPUT 0).
        ASSIGN hSelection:HIDDEN = FALSE NO-ERROR.

       IF cList NE "":U THEN
       DO:
         IF {fn getUsePairedList} THEN
           hSelection:LIST-ITEM-PAIRS = cList.
         ELSE 
           hSelection:LIST-ITEMS = cList.
       END.
       
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
                 NAME             = "fiLookup":U /* name so can refocus field */
                 SUBTYPE          = IF cUIBMode BEGINS "DESIGN":U
                                    THEN "NATIVE":U
                                    ELSE "PROGRESS":U 
                 X                = 0
                 Y                = 0
                 DATA-TYPE        = cDataType 
                 FORMAT           = IF cUIBMode BEGINS 'design'
                                    THEN hSelection:FORMAT
                                    ELSE cDispFormat 
                 WIDTH-PIXELS     = hFrame:WIDTH-PIXELS - 24
                 HIDDEN           = TRUE
                 SENSITIVE        = (cUIBMode BEGINS "DESIGN":U) = FALSE
                 READ-ONLY        = TRUE
                 TAB-STOP         = FALSE.
                               
       CREATE BUTTON hBtn
         ASSIGN NO-FOCUS         = TRUE
                FRAME            = hFrame
                X                = hSelection:WIDTH-P + (if SESSION:WINDOW-SYSTEM eq 'MS-WINXP' then 0 else 4)
                Y                = (if SESSION:WINDOW-SYSTEM eq 'MS-WINXP' then 0 else 1)
                WIDTH-PIXELS     = (if SESSION:WINDOW-SYSTEM eq 'MS-WINXP' then 22 else 19)
                HEIGHT-P         = hSelection:HEIGHT-P - (if SESSION:WINDOW-SYSTEM eq 'MS-WINXP' then 0 else 1)
                HIDDEN           = TRUE
                SENSITIVE        = FALSE
              TRIGGERS:
                ON CHOOSE PERSISTENT 
                  RUN chooseButton IN TARGET-PROCEDURE.
              END.

       IF DYNAMIC-FUNCTION('getUseWidgetID':U IN TARGET-PROCEDURE) THEN
         RUN assignWidgetID IN TARGET-PROCEDURE (INPUT hSelection, INPUT 2,
                                                  INPUT hBtn,       INPUT 6).
       ASSIGN hSelection:HIDDEN = FALSE
              hBtn:HIDDEN       = FALSE NO-ERROR.

       {get SelectionImage cSelectionImg}.
       hBtn:LOAD-IMAGE(cSelectionImg).      
       hFrame:HEIGHT = hSelection:HEIGHT.

       {get DefineAnyKeyTrigger lAnyKey}.

       IF lAnyKey THEN 
         ON ANY-KEY OF hSelection 
           PERSISTENT RUN anyKey IN TARGET-PROCEDURE.

       {set ButtonHandle hBtn}.
       /* create entry/leave trigger */
       
       ON ENTRY OF hSelection 
         PERSISTENT RUN enterSelect IN TARGET-PROCEDURE.

       ON LEAVE OF hSelection 
         PERSISTENT RUN leaveSelect IN TARGET-PROCEDURE.
    END. /* when "browser" */
  END CASE. /* cViewAsType */

  {set SelectionHandle hSelection}.
  IF VALID-HANDLE(hSelection) THEN
  DO:
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

    hSelection:MOVE-TO-BOTTOM().
    hSelection:TOOLTIP = cToolTIP.
    IF iHelpId <> ? THEN 
     hSelection:CONTEXT-HELP-ID = iHelpId.

    {get LocalField lLocal}.
    IF NOT lLocal THEN
      ON VALUE-CHANGED OF hSelection PERSISTENT RUN valueChanged  IN TARGET-PROCEDURE.
    ON {&refreshKey} OF hSelection PERSISTENT RUN refreshObject IN TARGET-PROCEDURE.
    ON END-MOVE      OF hFrame     PERSISTENT RUN endMove       IN TARGET-PROCEDURE. 
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-leaveSelect) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE leaveSelect Procedure 
PROCEDURE leaveSelect :
/*------------------------------------------------------------------------------
  Purpose:     This procedure is fired on leave of a smartselect field.
  Parameters:  <none>
  Notes:       The purpose of this procedure is to cope with the situation where
               a value is manually entered rather than using the lookup key.
               In this case, we need to see if the screen value has been changed,
               and if so, see if the changed screen value is a valid record.
               If it is, reset the keyvalue thereby avoiding having to use the
               lookup.
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hDataSource           AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hSelection            AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cKeyField             AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cKeyFieldValue        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDisplayedField       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cScreenValue          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDataValue            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDisplayValue         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hContainer            AS HANDLE     NO-UNDO.
  DEFINE VARIABLE lFound                AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE iLookup               AS INTEGER    NO-UNDO.
  DEFINE VARIABLE lModified             AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cOldValue             AS CHARACTER  NO-UNDO.
  
  &SCOPED-DEFINE xp-assign
  {get DataModified lModified}
  {get SelectionHandle hSelection}
  .
  &UNDEFINE xp-assign
  
  IF lModified AND hSelection:TYPE = "Fill-In":U THEN
  DO:
    &SCOPED-DEFINE xp-assign
    {get KeyField cKeyField}
    {get DisplayedField cDisplayedField}
    {get DataSource hDataSource}
    {get DataValue cDataValue}
    {get DisplayedField cDisplayedField}
    {get DisplayValue cOldValue}
    .
    &UNDEFINE xp-assign

    cScreenValue = hSelection:INPUT-VALUE. 
    
    ASSIGN      
      cDisplayValue  = {fnarg columnValue cDisplayedField hDataSource}
      cKeyFieldValue = {fnarg columnValue cKeyField hDataSource}.

    IF cDataValue   <> cKeyFieldValue 
    OR cScreenValue <> cDisplayValue THEN
    DO:
      RUN valueChanged IN TARGET-PROCEDURE.
    END.
  END. /* Modified */

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-linkStateHandler) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE linkStateHandler Procedure 
PROCEDURE linkStateHandler :
/*------------------------------------------------------------------------------
   Purpose: Override in order to set the Select filter and datasource 
            batching props if not browsed 
Parameters: See smart.p   
     Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pcState   AS CHARACTER  NO-UNDO.
  DEFINE INPUT PARAMETER phObject  AS HANDLE     NO-UNDO.
  DEFINE INPUT PARAMETER pcLink    AS CHARACTER  NO-UNDO.
  
  DEFINE VARIABLE cViewAs          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFilter          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iNumRows         AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iRowsToBatch     AS INTEGER    NO-UNDO.
  DEFINE VARIABLE lInitialized     AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lDataInactive    AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cKeyField        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cValue           AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDisplayedField  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSortField       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lQueryopen       AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cRowIdent        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lEnableField     AS LOGICAL    NO-UNDO.

  IF pcstate = 'add':U AND pcLink = 'DataSource':U  THEN
  DO:
    {get DataSourceFilter cFilter}.     
    IF cFilter NE "":U THEN
    DO:
      /* not supported for Dataview */
      IF NOT {fnarg instanceOf 'DataView':U phObject} THEN
        DYNAMIC-FUNCTION("addQueryWhere":U IN phObject,cFilter,?,'':U). 
    END.

    {get ViewAs cViewAs}.

    /* If this is a Microsoft widget we need all data and rowValues will do 
       an extra call to get remaining data, so set properties here to avoid 
       this extra Appserver hit in the case where the query is opened before 
       buildList -> rowValues  (openoninit = true etc..) */
    IF cViewAs <> 'Browser':U THEN
    DO:
      &SCOPED-DEFINE xp-assign
      {set RebuildOnRepos FALSE phObject}
      {set RowsToBatch 0 phObject}
      .
      &UNDEFINE xp-assign
    END.
    ELSE DO: 
      /* Ensure that browse will be scrollable; set RowsTobatch at least 
         one higher than the NumRows, which will be set to NumDown in the 
         browse in browseHandler  */
      {get NumRows iNumRows}.
      {get RowsToBatch iRowsToBatch phObject}. 
      IF iNumRows GE iRowsToBatch AND iRowsToBatch <> 0 THEN
      DO:
        iRowsToBatch = iNumRows + 1.
        {set RowsToBatch iRowsToBatch phObject}.
      END.
      {get EnableField lEnableField}.
      /* if the field is enabled ensure the SDO is sorted on the displayedField
         so that first record will be found on leave of the field. 
         (if the field is disabled the browser will set correct sort when 
          it is initialized)  */
      IF lEnableField THEN
      DO:   
        {get DisplayedField cDisplayedField}.
        IF NUM-ENTRIES(cDisplayedField,'.':U) = 1 THEN
          cDisplayedField = 'RowObject.':U + cDisplayedField.
        {fnarg resortQuery cDisplayedField phObject}.
      END. /* Enablefield*/
    END.
  END.

  {get ObjectInitialized lInitialized}.
  IF lInitialized AND pcstate = 'active':U AND pcLink = 'DataSource':U THEN
  DO:
   /* if the source is inactive then just wait for the dataavailable
      that it will publish when it becomes active */ 
    IF NOT DYNAMIC-FUNCTION('isLinkInactive':U IN phObject,'DataSource':U,?) THEN 
      lDataInactive = DYNAMIC-FUNCTION('isLinkInactive':U IN TARGET-PROCEDURE,
                                       'DataSource':U,phObject).
  END. 

  RUN SUPER(pcState,phObject,pcLink).
   
  /* lDataInactive is set above when 'active' 'DataSource' and the DataSource 
     link was inactive. */
  IF lDataInactive THEN
  DO:
    &SCOPED-DEFINE xp-assign
    {get KeyField cKeyField}
    {get DataValue cValue}
    .
    &UNDEFINE xp-assign

    /* Only retrieve values from DataSource if it is in synch with the 
       current DataValue  */  
    IF {fnarg columnValue cKeyField phObject} = cValue THEN    
    DO:
      /* The passed value is not used, but 'RESET' is most future-proof as 
         it is a signal to do stuff if necessary, but not always */ 
      {set Modify TRUE}.
      RUN dataAvailable IN TARGET-PROCEDURE('reset':U).
    END.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-publishLookupComplete) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE publishLookupComplete Procedure 
PROCEDURE publishLookupComplete PRIVATE :
/*------------------------------------------------------------------------------
  Purpose:  Publish the lookup complete event    
  Parameters:  <none>
  Notes:    This is 1 of 3 alternative ways to notify the container and is 
            the default if UseRepository and source is not dataview and 
            eventonchange is blank. 
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER plAvail        AS LOGICAL    NO-UNDO.
  DEFINE INPUT  PARAMETER pcOldDispValue AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE cColumnValues AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hDataSource   AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cDataColumns  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cLargeColumns AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cNewValue     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDisplayValue AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hSelection    AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hViewer       AS HANDLE     NO-UNDO.
  DEFINE VARIABLE iLarge        AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iEntry        AS INTEGER    NO-UNDO.

  &SCOPED-DEFINE xp-assign
  {get DataSource hDataSource}
  {get DataValue cNewValue}
  {get DisplayValue cDisplayValue}
  {get FieldHandle hSelection}
  {get ContainerSource hViewer}
  .
  &UNDEFINE xp-assign
  
  IF plAvail THEN
  DO:
    ASSIGN 
      cColumnValues = {fnarg colValues cDataColumns hDataSource}    
      cDataColumns  = {fn getDataColumns hDataSource}
      cLargeColumns = {fn getLargeColumns hDataSource}.
    
    DO iLarge = 1 TO NUM-ENTRIES(cLargeColumns):      
        ASSIGN
          iEntry = LOOKUP(ENTRY(iLarge,cLargeColumns),cDataColumns)
          cDataColumns = DYNAMIC-FUNCTION('deleteEntry':U IN TARGET-PROCEDURE,
                                           iEntry,
                                           cDataColumns,
                                           ','). 
    END.
    cColumnValues = {fnarg colValues cDataColumns hDataSource}.  
    PUBLISH "lookupComplete":U FROM hViewer 
           (cDataColumns,     /* CSV of all the columns in the SDO */
            cColumnValues,    /* CHR(1) delim list of all the values of the above columns */
            cNewValue,        /* the key field value of the selected record */
            cDisplayValue,    /* the value displayed on screen (may be the same as the key field value ) */
            pcOldDispValue, /* the old value displayed on screen (may be the same as the key field value ) */
            FOCUS <> hSelection,  /* YES = lookup browser used, NO = manual value entered */
            TARGET-PROCEDURE     /* Handle to lookup - use to determine which lookup has been left */
           ).          
  END.
  ELSE 
    PUBLISH "lookupComplete":U FROM hViewer 
                ('',  /* CSV of all the columns in the SDO */
                 '',   /* CHR(1) delim list of all the values of the above columns */
                 cNewValue,    /* the key field value of the selected record */
                 cDisplayValue,  /* the value displayed on screen (may be the same as the key field value ) */
                 pcOldDispValue, /* the old value  */
                 NO,                /* YES = lookup browser used, NO = manual value entered */
                 TARGET-PROCEDURE   /* Handle to lookup - use to determine which lookup has been left */
                ). 

  RETURN.

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
          - This event is ignored if the parent SDO of our SDO has an SDF that 
            is not in synch. if we are a child then the queryopened event is 
            typically a result of setDataValue in a parent SDF repositioning 
            its datasource, which then opens child SDOs.     
------------------------------------------------------------------------------*/  
  DEFINE VARIABLE lInitialized AS LOGICAL NO-UNDO.
  
  DEFINE VARIABLE hGrandDad          AS HANDLE  NO-UNDO.
  DEFINE VARIABLE hParentField       AS HANDLE  NO-UNDO. 
  DEFINE VARIABLE cParentField       AS CHAR    NO-UNDO. 
  DEFINE VARIABLE cParentValue       AS CHAR    NO-UNDO. 
  DEFINE VARIABLE cParentVisualValue AS CHAR    NO-UNDO. 
  
  /* we're not ready for this event until we have initialized. */
  {get ObjectInitialized lInitialized}.
  if not lInitialized then 
    return. 
  
  /* Check if we have a parent field and ignore this event if the 
     parentfield is not in synch with its datasource. */ 
  {get ParentFieldHandle hParentField}.
  if valid-handle(hParentField) then
  do:    
    {get DataSource hGrandDad hParentField}.
    {get FieldName cParentField hParentField}.      
    {get DataValue cParentVisualValue hParentField}.     
    cParentValue = {fnarg columnValue cParentField hGrandDad}.
    if cParentValue <> cParentVisualValue then
      return.
  end.
  
  /* if we get here then do the refresh */
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
  Notes:    The browser is selected on default action and exit 
            (if CancelRowOnExit = false)            
            The subscribtion of this event is done in browseHandler 
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hSelection          AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hContainer          AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hRealContainer      AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hWindow             AS HANDLE     NO-UNDO.

  RUN dataAvailable IN TARGET-PROCEDURE('':U).
  
  /* We're now in synch with the SDO so publish refreshObject to child SDFs
     which subscribes to this in initializeObject, because they ignore 
     QueryOpened events while we're not in synch with the SDO */ 
  publish "refreshObject":U from target-procedure.
  
  {get containerSource hContainer}.
  {get containerSource hRealContainer hContainer}.
  {get SelectionHandle hSelection}.

  IF VALID-HANDLE(hSelection) AND hSelection:TYPE = "FILL-IN":U THEN
  DO:
    /* Focus back in fill-in */
    RUN applyEntry IN TARGET-PROCEDURE (hSelection:NAME).
    
    /* get focus back in correct window */   
    {get ContainerHandle hWindow hRealContainer}.
    DO WHILE (VALID-HANDLE(hWindow) AND 
      hWindow:TYPE NE "WINDOW":U):
        hWindow = hWindow:PARENT.
    END.
    
    IF hWindow:TYPE = "WINDOW":U THEN
      CURRENT-WINDOW = hWindow.    
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-valueChanged) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE valueChanged Procedure 
PROCEDURE valueChanged :
/*------------------------------------------------------------------------------
  Purpose: Make sure the SmartDataViewer container knows that this value has
           changed.      
  Parameters:  <none>
  Notes:   Defined as a PERSISTENT value-changed trigger in the dynamic-widget
           and also called from dataAvailable when modify is true, AFTER 
           setDataValue to be able to identify whether the datasource
           need to be positioned. 
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cEvent          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cKeyField       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cViewAs         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cOldValue       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cScreenValue    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hSelection      AS HANDLE     NO-UNDO.
  DEFINE VARIABLE lReposition     AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE hDataSource     AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cDisplayedField AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDataValue      AS CHARACTER  NO-UNDO. 
  DEFINE VARIABLE hContainer      AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cFieldName      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lFound          AS LOGICAL    NO-UNDO.

  /* Set modified true to make the viewer save the value */
  &SCOPED-DEFINE xp-assign
  {set DataModified YES}
  {get ViewAs cViewAs}
  {get KeyField cKeyField}
  {get DisplayedField cDisplayedField}
  {get DataValue cDataValue}
  {get SelectionHandle hSelection}
  {get DisplayValue cOldValue} /* not old when called from dataavail.. */   
  {get DataSource hDataSource}
   .
  &UNDEFINE xp-assign
  IF cViewAs <> 'Browser':U THEN
    {get RepositionDataSource lReposition}.   
  ELSE
    lReposition = TRUE.

  /* fired from trigger valuechanged / leaveSelect */
  IF lReposition AND cOldValue <> hSelection:INPUT-VALUE  THEN
  DO:
    cScreenValue = hSelection:INPUT-VALUE.
    {set DisplayValue cScreenValue}. 

    IF cKeyField = cDisplayedField OR cViewAs <> 'Browser':U THEN
      lFound = {fnarg repositionDataSource cScreenValue}.
    ELSE DO:
      {set Modify TRUE}.
  
       /* qualify with RowObject. as signal that this is the SDO ColumnName, 
          which may be different than the table's fieldname */     
      IF NUM-ENTRIES(cDisplayedField,".":U) = 1 THEN
        cDisplayedField = "RowObject.":U + cDisplayedField.
      lFound = DYNAMIC-FUNC("findRowWhere":U IN hDataSource, 
                             cDisplayedField,
                             cScreenValue,
                             '=/BEGINS':U).
      /* the ui just remains as is, so give some feedback...*/
      IF NOT lFound THEN 
        BELL. 
      {set Modify FALSE}.
    END.
    IF NOT lFound AND cViewAs = 'Browser':U THEN
    DO:
      IF cKeyField = cDisplayedField THEN
        {set DataValue cScreenValue}.
      ELSE 
        {set DataValue ?}.
    END.
  END.

   /* Publish or run event to/in container  */
  &SCOPED-DEFINE xp-assign
  {get ChangedEvent cEvent} 
  {get FieldName cFieldName} 
  {get ContainerSource hContainer}
  .
  &UNDEFINE xp-assign
  
  IF cEvent NE "":U THEN
  DO:
    {get DataValue cDataValue}.
    PUBLISH cEvent FROM TARGET-PROCEDURE (cDataValue).
  END. /* cevent <> '' */
  ELSE IF lReposition THEN 
  DO:
    IF {fnarg instanceOf 'DataView':U hDataSource} THEN
      RUN displayRelationFields IN hContainer (cFieldName).
    ELSE 
      RUN publishLookupComplete IN TARGET-PROCEDURE(lFound,cOldValue).
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
      MESSAGE SUBSTITUTE({fnarg messageNumber 78}, cDisplayField) VIEW-AS ALERT-BOX WARNING.

  
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
   DEFINE VARIABLE hSelection    AS HANDLE     NO-UNDO.
   
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
            HIDDEN                = TRUE
            WIDTH-PIXELS          = iLabelLength
            FORMAT                = "x(256)":U
            SCREEN-VALUE          = pcLabel + ":":U
            HEIGHT-PIXELS         = SESSION:PIXELS-PER-ROW 
             /*FONT-TABLE:GET-TEXT-HEIGHT-PIXELS(FRAME {&frame-name}:FONT)*/.
  
  &SCOPED-DEFINE xp-assign
  {set LabelHandle hLabel}
  {get SelectionHandle hSelection}.
  &UNDEFINE xp-assign

  IF DYNAMIC-FUNCTION('getUseWidgetID':U IN TARGET-PROCEDURE) THEN
     RUN assignLabelWidgetID IN TARGET-PROCEDURE.  

  hSelection:SIDE-LABEL-HANDLE = hLabel.

  hLabel:HIDDEN = FALSE.
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
Notes:   Not supported against the Dataview where base filtering is expected
         to be implemented in the data access layer.   
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
    &SCOPED-DEFINE xpDataValue
    {get DataValue cValue}.
    &UNDEFINE xpDataValue

    RETURN IF cValue = ? THEN '?':U ELSE cValue.
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
DEFINE VARIABLE lTrigger AS LOGICAL    NO-UNDO.

  &SCOPED-DEFINE xpDefineAnyKeyTrigger
  {get DefineAnyKeyTrigger lTrigger}.
  &UNDEFINE xpDefineAnyKeyTrigger
  
  RETURN lTrigger.
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
  DEFINE VARIABLE hSelection      AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hDataSource     AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cDisplayedField AS CHAR       NO-UNDO.
  DEFINE VARIABLE cKeyField       AS CHAR       NO-UNDO.
  DEFINE VARIABLE cDataValue      AS CHAR       NO-UNDO.
  DEFINE VARIABLE lUsedPair       AS LOG        NO-UNDO.
  DEFINE VARIABLE cViewAs         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lRepos          AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lOptional       AS LOG        NO-UNDO.

  {get SelectionHandle hSelection}.
   
  IF NOT VALID-HANDLE(hSelection) THEN
    RETURN ?. 

  &SCOPED-DEFINE xp-assign
  {get UsePairedList lUsedPair}
  {get KeyField cKeyField}
  {get DisplayedField cDisplayedField}
  {get Optional lOptional}
  {get DataSource hDataSource}
  {get ViewAs cViewAs}
   .
  &UNDEFINE xp-assign
  
  IF cViewAs <> "browser":U  THEN
  DO:
    {get RepositionDataSource lRepos}.   

    /* This is the case where the display value may be different than the 
       datavalue */
    IF lOptional THEN 
    DO:
      {get DataValue cDataValue}.
      IF (cDataValue = "?":U OR cDataValue = ?) THEN
        RETURN "?":U.
    END.
  END.

  /* From 9.1C we store the DisplayValue (and DataValue) for browser in 
     dataAvailable or setDataValue to avoid returning the current SDO value 
     as this may not be correct if the user has not chosen the record with 
    'default-action' 
     From 10.1a01 we also do this for any repositionsource case to be able 
     to detect change in trigger procedures also for non browser */
  IF cViewAs = "browser":U OR lRepos THEN
    RETURN SUPER().
  
  {get DataValue cDatavalue}.

  /* If we are not using a paired list (editable combo-boxes) OR
     the keyfield and displayfield are the same,
     the dataValue IS the display value. Even if optional
     we want to return the cDataValue. */  
  IF NOT lUsedPair OR cKeyField = cDisplayedField THEN 
    RETURN cDataValue.

    /* get display value from list-item-pairs given the data value */
  IF CAN-QUERY(hSelection,'LIST-ITEM-PAIRS':U) THEN 
     cDataValue = DYNAMIC-FUNCTION('mappedEntry':U IN TARGET-PROCEDURE,
                                    {fnarg formattedValue cDataValue TARGET-PROCEDURE}, 
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

&IF DEFINED(EXCLUDE-getFieldHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getFieldHandle Procedure 
FUNCTION getFieldHandle RETURNS HANDLE
  (  ) :
/*------------------------------------------------------------------------------
  Purpose: Override to return the Selectionhandle  
    Notes: The different sibling classes, like lookup and combo have all been 
           implemented with different names. This function is expected to 
           replace those in order to achieve polymorphism. 
         - Currently used by clearField.
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hField AS HANDLE     NO-UNDO.
  {get SelectionHandle hField}.

  RETURN hField.   

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
  &SCOPED-DEFINE xpLabel
  {get Label cLabel}.
  &UNDEFINE xpLabel
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

&IF DEFINED(EXCLUDE-getParentFieldHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getParentFieldHandle Procedure 
FUNCTION getParentFieldHandle RETURNS HANDLE
  (   ) :
/*------------------------------------------------------------------------------
  Purpose: Returns the handle of the parent SDF if any   
    Notes: Used in initializeObject and queryopened.
         - Checks if the SDO has a parent SDO and returns the SDF target of
           this if it exists.
         - Could possibly be a property (or derived from ParentField moved
           here) and/or link, but the usage is rare and the main logic is only 
           executed for those who have a parent. The parent sdo would also 
           typically only have one target.   
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hDataSource        AS HANDLE  NO-UNDO.
  DEFINE VARIABLE hGrandDad          AS HANDLE  NO-UNDO.
  DEFINE VARIABLE cParentSiblings    AS CHAR    NO-UNDO.
  DEFINE VARIABLE hTarget            AS handle  NO-UNDO.
  DEFINE VARIABLE iTarget            AS INTEGER NO-UNDO.
  
  {get DataSource hDataSource}.
  if valid-handle(hDataSource) then
  do:
    {get DataSource hGrandDad hDataSource}.
    if valid-handle(hGrandDad) then
    do:
      {get DataTarget cParentSiblings hGrandDad}.
      do iTarget = 1 to num-entries(cParentSiblings):
        hTarget = widget-handle(entry(iTarget,cParentSiblings)).
        if {fnarg instanceOf 'Field':U hTarget} then
          return hTarget.
      end.                   
    end.    
  end.
  
  RETURN ?.    

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

&IF DEFINED(EXCLUDE-getSelectionHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getSelectionHandle Procedure 
FUNCTION getSelectionHandle RETURNS HANDLE
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose: 
    Notes:   
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hValue AS HANDLE NO-UNDO.
  {get SelectionHandle hValue}.
  RETURN hValue.

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
  DEFINE VARIABLE cKeyField         AS CHAR       NO-UNDO.
  DEFINE VARIABLE hDataSource       AS HANDLE     NO-UNDO.
  DEFINE VARIABLE lFound            AS LOGICAL    NO-UNDO.
  
  &SCOPED-DEFINE xp-assign
  {get KeyField cKeyField}
  {get DataSource hDataSource}
  .
  &UNDEFINE xp-assign
  
  IF NOT VALID-HANDLE(hDataSource) THEN
    RETURN FALSE.

  {set Modify TRUE}.     
  /* qualify with RowObject. as signal that this is the SDO ColumnName, 
     which may be different than the table's fieldname */   
  IF NUM-ENTRIES(cKeyField,".":U) = 1 THEN
    cKeyField = "RowObject.":U + cKeyField.
 
  lFound = DYNAMIC-FUNC("findRowWhere":U IN hDataSource, 
                         cKeyField,
                         pcValue,
                        '':U).

  {set Modify FALSE}. 

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
     Notes: Not supported against the Dataview ( base filtering is expected
            to be implemented in the data access layer ).   
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
  DEFINE VARIABLE hSelection        AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cViewAs           AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cKeyField         AS CHAR       NO-UNDO.
  DEFINE VARIABLE cDisplayedField   AS CHAR       NO-UNDO.
  DEFINE VARIABLE lOptional         AS LOG        NO-UNDO.
  DEFINE VARIABLE lAvailable        AS LOG        NO-UNDO.
  DEFINE VARIABLE cOptionalString   AS CHAR       NO-UNDO.
  DEFINE VARIABLE lRepositionSource AS LOG        NO-UNDO.
  DEFINE VARIABLE cKeyValue         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lInternal         AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE iSuper            AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cSupers           AS CHARACTER  NO-UNDO.

  {get SelectionHandle hSelection}.  
  IF NOT VALID-HANDLE(hSelection) THEN
    RETURN FALSE.

  {get ViewAs cViewAs}.

  /* The behavior is different when used as an External API 
     The call is internal if called from target or this (select.p) or
     a super-procedure that extends select.p (earlier in list of supers)  */   
  ASSIGN
    cSupers   = TARGET-PROCEDURE:SUPER-PROCEDURES
    iSuper    = LOOKUP(STRING(THIS-PROCEDURE),cSupers)
    lInternal = (LOOKUP(STRING(SOURCE-PROCEDURE),cSupers) <= iSuper
                 AND 
                 LOOKUP(STRING(SOURCE-PROCEDURE),cSupers) > 0
                 )
                OR SOURCE-PROCEDURE = TARGET-PROCEDURE 
    .
                    
  IF cViewAs = 'Browser':U THEN
  DO:
    /* When the SmartSelect is browsed we must store the DataValue, because the 
       user may move to another row in the browser without selecting the row  */               
    &SCOPED-DEFINE xpdataValue 
    {set DataValue pcValue}.
    &UNDEFINE xpdataValue 
  END.

  /* repositionDataSource if called externally.  */  
  IF NOT lInternal THEN
  DO:
    IF cViewAs ='Browser':U THEN
    DO:
      lAvailable = {fnarg repositionDataSource pcValue}.
      IF NOT lAvailable THEN
      DO:
        IF pcValue = '?':U OR pcValue = ? THEN
        DO:
          {get Optional lOptional}.
          
          IF lOptional THEN 
          DO:
            {get OptionalString cOptionalString}.
            pcValue = cOptionalString.
          END.
        END. /* pcValue '?' or ? */        
        /* DisplayValue return '?' for unknown, which means allowed unknown 
          (? means really unknown probably error) */         
        {set DisplayValue '?':U}.               
        {get KeyField cKeyField}.
        {get DisplayedField cDisplayedField}.        
        hSelection:SCREEN-VALUE = IF cKeyField = cDisplayedField OR lOptional
                                  THEN pcValue
                                  ELSE "":U. 
      END. /* not lAvailable and External  */
    END. /* cViewAs = 'Browser' */
    ELSE DO:
      IF hSelection:TYPE = "COMBO-BOX":U THEN 
      DO:
        /* iz3633: if pcValue is "" (no spaces-- as in the case when Add is pressed) 
         * then we should process it the same as ? for combo-boxes.
         * It is not the same case as when a string of spaces is passed in since
         * those could be valid data values.
         */
         IF pcvalue = "":U AND LENGTH(pcvalue) = 0 THEN
             pcValue = ?.
  
        /* We allow 'bogus' data in editable combo-box, but this only works when 
           screen-value is unknown, so set list-items = list-items just in case */
        IF hSelection:SUBTYPE <> "drop-down-list":U THEN
           hSelection:LIST-ITEMS = hSelection:LIST-ITEMS.
  
        /* A COMBO-BOX of subtype drop-down-list is formatted, so we must apply 
           the format to be able to assign the screen-value.*/
        IF hSelection:SUBTYPE = "drop-down-list":U THEN
          pcValue = {fnarg formattedValue pcValue}.
  
      END. /* if combo-box */
      
      hSelection:SCREEN-VALUE = pcvalue NO-ERROR.
  
      /* In case the assign of screen-value failed we clear the widget so it 
         doesn't show the previous value. Error-staus:error is no, so we check 
         for the specific error message.          
         A pcValue of unknown gives no error, but does not change screen-value 
         either, so we need to blank the field also in that case as unknown is 
         an indicator that no data exists in the viewer container 
        (support for unknown in data will be handled with '?' when the 
         list-item-pairs supports it) */
   
      IF ERROR-STATUS:GET-NUMBER(1) = 4058 OR pcValue = ? THEN   
        RUN clearField IN TARGET-PROCEDURE.
      /* synch sdo after datavalue is set 
        (child select queryopened checks if in synch) */       
      {get RepositionDataSource lRepositionSource}.
      if lRepositionSource then 
         {fnarg repositionDataSource pcValue}.    
    END. /* else (not fill-in or editable combo) */
  END.

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

  &SCOPED-DEFINE xpDefineAnyKeyTrigger
  {set DefineAnyKeyTrigger plTrigger}.
  &UNDEFINE xpDefineAnyKeyTrigger
  
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
  &SCOPED-DEFINE xpLabel
  {set Label pcLabel}.
  &UNDEFINE xpLabel
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

&IF DEFINED(EXCLUDE-setSelectionHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setSelectionHandle Procedure 
FUNCTION setSelectionHandle RETURNS LOGICAL
  ( phValue AS HANDLE ) :
/*------------------------------------------------------------------------------
  Purpose: 
Parameters:     
    Notes:   
------------------------------------------------------------------------------*/
  {set SelectionHandle phValue}.
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

&IF DEFINED(EXCLUDE-validateField) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION validateField Procedure 
FUNCTION validateField RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose: Returns true if the current DataValue is valid. 
    Notes: Called from the viewers validateFields   
           The currently only invalid case is an unknown DataValue when
           DisplayField <> KeyField and fillin as it means that the typed value 
           did not find a match in the SDO. 
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cDataValue      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hSelection      AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cKeyField       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDisplayedField AS CHARACTER  NO-UNDO.

   {get SelectionHandle hSelection}.
  IF hSelection = FOCUS AND hSelection:TYPE = 'Fill-in':U THEN
    RUN leaveSelect IN TARGET-PROCEDURE. 
  
  {get KeyField cKeyField}.
  {get DisplayedField cDisplayedField}.
  IF hSelection:TYPE = 'Fill-in':U AND cKeyField <> cDisplayedField THEN
  DO:
    {get DataValue cDataValue}.  
    IF cDataValue = ? OR cDataValue = '?':U THEN
      RETURN FALSE.
  END.

  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-validateMessage) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION validateMessage Procedure 
FUNCTION validateMessage RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose: The error message to display if validateField Failed 
    Notes:  
------------------------------------------------------------------------------*/    
  DEFINE VARIABLE hDataSource  AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cTables      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cField       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cScreenValue AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cKeyError    AS CHARACTER  NO-UNDO.

  {get DataSource hDataSource}.
  {get DisplayedField cField}.  
  {get Tables cTables hDataSource}.
  
  {get DisplayValue cScreenValue}. 
  cKeyError = {fnarg columnLabel cField hDataSource} 
            + ": ":U + cScreenValue.

  RETURN SUBSTITUTE({fnarg messageNumber 29},cTables,cKeyError).

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

