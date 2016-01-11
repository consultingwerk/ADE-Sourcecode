&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
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
    File        : datavis.p
    Purpose     : Super procedure for PDO Data Visualization objects

    Syntax      : adm2/datavis.p

    Modified    : July 21, 2000 -- Version 9.1B
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */


/* Tell dvisattr.i that this is the Super procedure. */
   &SCOP ADMSuper datavis.p
  
  {src/adm2/custom/datavisexclcustom.i}

/* This variable is needed at least temporarily in 9.1B so that a called
   fn can tell who the actual source was. */
   DEFINE VARIABLE ghTargetProcedure AS HANDLE     NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-canLaunchDetailWindow) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD canLaunchDetailWindow Procedure 
FUNCTION canLaunchDetailWindow RETURNS LOGICAL
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-canNavigate) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD canNavigate Procedure 
FUNCTION canNavigate RETURNS LOGICAL
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getAuditEnabled) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getAuditEnabled Procedure 
FUNCTION getAuditEnabled RETURNS LOGICAL
  ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getCreateHandles) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getCreateHandles Procedure 
FUNCTION getCreateHandles RETURNS CHARACTER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDataModified) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getDataModified Procedure 
FUNCTION getDataModified RETURNS LOGICAL
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDisplayedFields) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getDisplayedFields Procedure 
FUNCTION getDisplayedFields RETURNS CHARACTER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDisplayedTables) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getDisplayedTables Procedure 
FUNCTION getDisplayedTables RETURNS CHARACTER
  (   )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getEditable) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getEditable Procedure 
FUNCTION getEditable RETURNS LOGICAL
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getEnabledFields) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getEnabledFields Procedure 
FUNCTION getEnabledFields RETURNS CHARACTER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getEnabledHandles) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getEnabledHandles Procedure 
FUNCTION getEnabledHandles RETURNS CHARACTER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getEnabledObjFldsToDisable) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getEnabledObjFldsToDisable Procedure 
FUNCTION getEnabledObjFldsToDisable RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getFieldHandles) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getFieldHandles Procedure 
FUNCTION getFieldHandles RETURNS CHARACTER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getFieldsEnabled) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getFieldsEnabled Procedure 
FUNCTION getFieldsEnabled RETURNS LOGICAL
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getFilterActive) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getFilterActive Procedure 
FUNCTION getFilterActive RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getGroupAssignHidden) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getGroupAssignHidden Procedure 
FUNCTION getGroupAssignHidden RETURNS LOGICAL
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getGroupAssignSource) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getGroupAssignSource Procedure 
FUNCTION getGroupAssignSource RETURNS HANDLE
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getGroupAssignSourceEvents) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getGroupAssignSourceEvents Procedure 
FUNCTION getGroupAssignSourceEvents RETURNS CHARACTER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getGroupAssignTarget) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getGroupAssignTarget Procedure 
FUNCTION getGroupAssignTarget RETURNS CHARACTER
  (  ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getGroupAssignTargetEvents) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getGroupAssignTargetEvents Procedure 
FUNCTION getGroupAssignTargetEvents RETURNS CHARACTER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getInternalDisplayFromSource) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getInternalDisplayFromSource Procedure 
FUNCTION getInternalDisplayFromSource RETURNS CHARACTER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getLabel) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getLabel Procedure 
FUNCTION getLabel RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getModifyFields) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getModifyFields Procedure 
FUNCTION getModifyFields RETURNS CHARACTER
   (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getNewRecord) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getNewRecord Procedure 
FUNCTION getNewRecord RETURNS CHARACTER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getObjectMode) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getObjectMode Procedure 
FUNCTION getObjectMode RETURNS CHARACTER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getObjectParent) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getObjectParent Procedure 
FUNCTION getObjectParent RETURNS HANDLE
  (  )  FORWARD.

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

&IF DEFINED(EXCLUDE-getRecordState) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getRecordState Procedure 
FUNCTION getRecordState RETURNS CHARACTER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getRowIdent) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getRowIdent Procedure 
FUNCTION getRowIdent RETURNS CHARACTER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getSaveSource) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getSaveSource Procedure 
FUNCTION getSaveSource RETURNS LOGICAL
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getTableIOSource) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getTableIOSource Procedure 
FUNCTION getTableIOSource RETURNS HANDLE
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getTableIOSourceEvents) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getTableIOSourceEvents Procedure 
FUNCTION getTableIOSourceEvents RETURNS CHARACTER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getTargetProcedure) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getTargetProcedure Procedure 
FUNCTION getTargetProcedure RETURNS HANDLE
  (   )  FORWARD.

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

&IF DEFINED(EXCLUDE-getUpdateTarget) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getUpdateTarget Procedure 
FUNCTION getUpdateTarget RETURNS CHARACTER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getUpdateTargetNames) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getUpdateTargetNames Procedure 
FUNCTION getUpdateTargetNames RETURNS CHARACTER
  (   )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getWindowTitleField) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getWindowTitleField Procedure 
FUNCTION getWindowTitleField RETURNS CHARACTER
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

&IF DEFINED(EXCLUDE-internalWidgetHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD internalWidgetHandle Procedure 
FUNCTION internalWidgetHandle RETURNS HANDLE
  ( INPUT pcField AS CHARACTER,
    INPUT pcSearchMode AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-okToContinue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD okToContinue Procedure 
FUNCTION okToContinue RETURNS LOGICAL
  (pcAction AS CHAR) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setDataModified) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setDataModified Procedure 
FUNCTION setDataModified RETURNS LOGICAL
  ( plModified AS LOGICAL )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setDisplayedFields) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setDisplayedFields Procedure 
FUNCTION setDisplayedFields RETURNS LOGICAL
  ( pcFieldList AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setEditable) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setEditable Procedure 
FUNCTION setEditable RETURNS LOGICAL
  ( plEditable AS LOGICAL)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setEnabledFields) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setEnabledFields Procedure 
FUNCTION setEnabledFields RETURNS LOGICAL
  ( pcFieldList AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setEnabledHandles) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setEnabledHandles Procedure 
FUNCTION setEnabledHandles RETURNS LOGICAL
  ( pcHandles AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setEnabledObjFldsToDisable) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setEnabledObjFldsToDisable Procedure 
FUNCTION setEnabledObjFldsToDisable RETURNS LOGICAL
  ( pcEnabledObjFldsToDisable AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setFieldHandles) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setFieldHandles Procedure 
FUNCTION setFieldHandles RETURNS LOGICAL
  ( pcHandles AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setGroupAssignSource) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setGroupAssignSource Procedure 
FUNCTION setGroupAssignSource RETURNS LOGICAL
  ( phObject AS HANDLE )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setGroupAssignSourceEvents) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setGroupAssignSourceEvents Procedure 
FUNCTION setGroupAssignSourceEvents RETURNS LOGICAL
  ( pcEvents AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setGroupAssignTarget) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setGroupAssignTarget Procedure 
FUNCTION setGroupAssignTarget RETURNS LOGICAL
  ( pcObject AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setGroupAssignTargetEvents) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setGroupAssignTargetEvents Procedure 
FUNCTION setGroupAssignTargetEvents RETURNS LOGICAL
  ( pcEvents AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setInternalDisplayFromSource) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setInternalDisplayFromSource Procedure 
FUNCTION setInternalDisplayFromSource RETURNS LOGICAL
  ( pcFromSource AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setLogicalObjectName) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setLogicalObjectName Procedure 
FUNCTION setLogicalObjectName RETURNS LOGICAL
  ( pcLogicalObjectName AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setModifyFields) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setModifyFields Procedure 
FUNCTION setModifyFields RETURNS LOGICAL
  ( pcModifyFields AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setNewRecord) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setNewRecord Procedure 
FUNCTION setNewRecord RETURNS LOGICAL
  ( pcMode AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setObjectMode) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setObjectMode Procedure 
FUNCTION setObjectMode RETURNS LOGICAL
  ( pcObjectMode AS CHARACTER )  FORWARD.

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

&IF DEFINED(EXCLUDE-setPrintPreviewActive) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setPrintPreviewActive Procedure 
FUNCTION setPrintPreviewActive RETURNS LOGICAL
  ( lPreviewActive AS LOGICAL )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setRowIdent) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setRowIdent Procedure 
FUNCTION setRowIdent RETURNS LOGICAL
  ( pcRowIdent AS CHAR  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setSaveSource) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setSaveSource Procedure 
FUNCTION setSaveSource RETURNS LOGICAL
  (plSave AS LOG)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setTableIOSource) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setTableIOSource Procedure 
FUNCTION setTableIOSource RETURNS LOGICAL
  ( phObject AS HANDLE )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setTableIOSourceEvents) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setTableIOSourceEvents Procedure 
FUNCTION setTableIOSourceEvents RETURNS LOGICAL
  ( pcEvents AS CHARACTER )  FORWARD.

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

&IF DEFINED(EXCLUDE-setUpdateTarget) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setUpdateTarget Procedure 
FUNCTION setUpdateTarget RETURNS LOGICAL
  ( pcObject AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setUpdateTargetNames) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setUpdateTargetNames Procedure 
FUNCTION setUpdateTargetNames RETURNS LOGICAL
      ( pcTargetNames AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setWindowTitleField) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setWindowTitleField Procedure 
FUNCTION setWindowTitleField RETURNS LOGICAL
  ( cWindowTitleField AS CHARACTER )  FORWARD.

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
         HEIGHT             = 19.52
         WIDTH              = 56.4.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB Procedure 
/* ************************* Included-Libraries *********************** */

{src/adm2/dvisprop.i}

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
  Purpose:     General code for Add operation.
  Parameters:  <none>
  Notes:       Invoked when the Add button is pressed on an Update SmartPanel
               or a SmartToolbar.
               No Add operation can be done while there are updates in 
               progress, if so the user receives a message that current values
               must be saved or cancelled before Add.
               Sets NewRecord property to 'Add'.
               PUBLISHes updateState 'Update' to tell Tableio source and 
               Update target that update is in progress.
------------------------------------------------------------------------------*/  
  DEFINE VARIABLE cTarget            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hGroupSource       AS HANDLE     NO-UNDO.
  DEFINE VARIABLE lMod               AS LOGICAL    NO-UNDO.
    
  /* If the visualization is hidden, this effectively disables 
     "TableIO" operations, unless there is a GroupAssign-Source or Target
     and also allow add to happen, even if object is hidden, if this is linked 
     to the container toolbar, i.e. it is a main viewer on the container for the
     main table .*/
  &SCOPED-DEFINE xp-assign
  {get GroupAssignSource hGroupSource}
  {get UpdateTarget cTarget}.
  &UNDEFINE xp-assign
  IF cTarget = "":U AND hGroupSource = ? THEN
  DO:
    DYNAMIC-FUNCTION ('showMessage':U IN TARGET-PROCEDURE, INPUT {fnarg messageNumber 62}).
    RETURN "ADM-ERROR":U.
  END.
  
  /* Reject the Add attempt if the current values have been modified
     and not saved. */
  {get DataModified lMod}.
  IF lMod THEN
  DO:
     DYNAMIC-FUNCTION('showMessage':U IN TARGET-PROCEDURE, INPUT '2':U).  
     /* "Current values must be saved or cancelled before Add or Copy." */
     RETURN "ADM-ERROR":U. 
  END.
   
  {set NewRecord 'Add':U}.

  /* If for some reason this object's fields have not been enabled from
     outside, then do it here. */
  RUN enableFields IN TARGET-PROCEDURE.
    
  RETURN.  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-cancelObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE cancelObject Procedure 
PROCEDURE cancelObject :
/* -----------------------------------------------------------------------------
      Purpose: Passes an cancel request to its container    
      Parameters:  <none>
      Notes:  The convention is that the standard routine always
              passes an cancel,ok or exit request to its CONTAINER-SOURCE. 
              The container that is actually able to initiate the cancel 
              should override this and *not* call SUPER.    
----------------------------------------------------------------------------*/
  PUBLISH 'cancelObject':U FROM TARGET-PROCEDURE. /* NOTE: MUST go to Container-Source */
     
  RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-cancelRecord) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE cancelRecord Procedure 
PROCEDURE cancelRecord :
/*------------------------------------------------------------------------------
  Purpose:     General code to cancel the update or add of the current row.
  Parameters:  <none>
  Notes:       Invoked when the Cancel button is pressed on an Update SmartPanel
               or on a SmartToolbar.
               Invokes cancelRow() in the Update target.
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hGroupSource  AS HANDLE    NO-UNDO.
  DEFINE VARIABLE cErrors       AS CHARACTER NO-UNDO.
  DEFINE VARIABLE hUpdateTarget AS HANDLE    NO-UNDO.
  DEFINE VARIABLE cNew          AS CHARACTER NO-UNDO.
  DEFINE VARIABLE lHidden       AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE cState        AS CHARACTER NO-UNDO.
  DEFINE VARIABLE lModified     AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE cRowIdent     AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cTarget       AS CHARACTER NO-UNDO.
  DEFINE VARIABLE lFound        AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE lSaveSource   AS LOGICAL   NO-UNDO.

  &SCOPED-DEFINE xp-assign
  {get GroupAssignSource hGroupSource}
  {get UpdateTarget cTarget}
  {get NewRecord cNew}.
  &UNDEFINE xp-assign

  hUpdateTarget = WIDGET-HANDLE(cTarget).
  
  /* Ensure the rowobject record in the SDO is pointing at the correct one, 
     before we start cancelling */
  IF VALID-HANDLE(hUpdateTarget) THEN
  DO:
    {get RowIdent cRowIdent}. 
    lFound = {fnarg repositionRowObject cRowIdent hUpdateTarget}.
    IF NOT (lFound = TRUE) THEN
      RETURN ERROR RETURN-VALUE.
  END.
  
  /* Note that for a GroupAssign-Target the UpdateTarget will not be
     present, so we will skip this step; it's done only in the Source. */
  IF VALID-HANDLE(hUpdateTarget) THEN
  DO:
    ghTargetProcedure = TARGET-PROCEDURE.
    cErrors = dynamic-function("cancelRow":U IN hUpdateTarget).
    ghTargetProcedure = ?.
  END.      /* END DO IF UpdateTarget */
  ELSE DO:
    IF hGroupSource = ? THEN
       cErrors = "No UpdateTarget present for Cancel operation.":U.
  END.   /* END ELSE DO (No Update Target) */
  
  /* DataAvailable avoids display when newRecord <> 'no', so we set it to 'no'
     AFTER the call to the UpdateTarget that publishes DataAvailable 
     and always display here instead  */
  {set NewRecord 'No':U}.   /* Note: this is character 'no', not logical*/     

  RUN displayRecord IN TARGET-PROCEDURE.

  /* Post 9.1D the disabling of the object in Update mode is managed
      by the object and not by a publish from the toolbar's updateState */   
  {get SaveSource lSaveSource}.
  IF lSaveSource = FALSE THEN
    RUN updateMode IN TARGET-PROCEDURE ('updateEnd':U).

  /* Ensure that GroupAssign-targets Modified flag is set to FALSE 
     BEFORE setDataModified as it publishes UpdateActive up the container 
     link, and each container checks all targets before republishing  */
  dynamic-function('assignLinkProperty':U IN TARGET-PROCEDURE,
                   'GroupAssign-Target':U, 
                   'DataModified':U, 
                   'no':U). 

   /* NOTE: set DataModifed/updateState must happen AFTER cancelRow() because 
     at the end of the events (depending of the toolbar mode) updatestate may 
     fire back from the toolbar to disable and if this is a viewer the focus 
     will be set to the browse and if 'add' or 'copy' the previous record will 
     become available. When this was done BEFORE cancelRow the 'add' or 'copy'
     would not be undone and these rowObject records would cause error messages
     with the next save */                 
  {get DataModified lModified}.
  IF NOT lModified THEN
    PUBLISH 'updateState':U FROM TARGET-PROCEDURE ('updateComplete':U).
  ELSE 
    {set DataModified no}.   /* Turn off the modified flag. */

    /* Disable any fields enabled just for the Add operation. */ 
  {get RecordState cState}.

  IF cState = "NoRecordAvailable":U AND cNew NE "No":U THEN  /* Could be Add or Copy or No */
    RUN disableFields IN TARGET-PROCEDURE ("All":U).
  
  IF VALID-HANDLE(hUpdateTarget) THEN
    RUN applyEntry IN TARGET-PROCEDURE (?).  

  /* NOTE: Disabling only create fields is not yet supported
     RUN disableFields IN TARGET-PROCEDURE ("Create":U).
   */
  RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-collectChanges) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE collectChanges Procedure 
PROCEDURE collectChanges :
/*------------------------------------------------------------------------------
  Purpose:     Collects changed field values.
               Executed and PUBLISHed from updateRecord to collect up changed 
               field values from GroupAssign targets.
  Parameters:  INPUT-OUTPUT pcChanges -- delimited list of
                 fieldName CHR(1) newValue CHR(1) ...;
               INPUT-OUTPUT pcInfo -- delimited list of information
                 for the caller to use to determine where the changes came from
                 and how to direct error messages. Each object which adds
                 any changes to the Changes list adds three comma-separated
                 items to the Info list: the number of fields changed in
                 this object, its page number, and its handle.
------------------------------------------------------------------------------*/
  DEFINE INPUT-OUTPUT PARAMETER pcChanges AS CHARACTER NO-UNDO.
  DEFINE INPUT-OUTPUT PARAMETER pcInfo    AS CHARACTER NO-UNDO.
  
  DEFINE VARIABLE cChange        AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cFieldHandles  AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cFieldNames    AS CHARACTER NO-UNDO.
  DEFINE VARIABLE iCnt           AS INTEGER   NO-UNDO.
  DEFINE VARIABLE iChanges       AS INTEGER   NO-UNDO INIT 0.
  DEFINE VARIABLE hFrameField    AS HANDLE    NO-UNDO.
  DEFINE VARIABLE iPage          AS INTEGER   NO-UNDO.  
  DEFINE VARIABLE lMod           AS LOGICAL   NO-UNDO. 
  DEFINE VARIABLE cNew           AS CHARACTER NO-UNDO.  
  DEFINE VARIABLE cEnabledFields AS CHARACTER NO-UNDO.  
  DEFINE VARIABLE cField         AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cValue         AS CHARACTER NO-UNDO. 
  DEFINE VARIABLE hUpdateTarget  AS HANDLE     NO-UNDO.  
  DEFINE VARIABLE cUpdateNames   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lError         AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cMessage       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cObjectType    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cModifyFields  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cCheckFields   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cUpdatable     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cLargeColumns  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hGaSource      AS HANDLE     NO-UNDO.

  &SCOPED-DEFINE xp-assign
  /* We use the list of all field handles, not just enabled ones, to capture 
     changes made programmatically to non-enabled fields. */
  {get FieldHandles cFieldHandles}
  {get DisplayedFields cFieldNames}
  /* In an add or copy situation, we assume that all enabled fields have been 
     changed, regardless of their modified status, to ensure they have a valid 
     value, and that any errors from validation procedures can return back to 
     the field in error. */
  {get NewRecord cNew}                                                 
  {get EnabledFields cEnabledFields}
  {get ObjectType cObjectType}
  {get ModifyFields cModifyFields}  
  {get UpdateTarget hUpdateTarget}
  {get GroupAssignSource hGaSource}
  .
  &UNDEFINE xp-assign

  /* we need the stored property value. Not the one adjusted for GA links etc. */
  &SCOPED-DEFINE xpUpdateTargetNames
  {get UpdateTargetNames cUpdateNames}.
  &UNDEFINE xpUpdateTargetNames
  
  DO WHILE VALID-HANDLE(hGaSource):
    &SCOPED-DEFINE xp-assign
    {get UpdateTarget hUpdateTarget hGaSource}
    {get GroupAssignSource hGaSource hGaSource}
    .
    &UNDEFINE xp-assign
  END.

  IF VALID-HANDLE(hUpdateTarget) THEN
   {get LargeColumns cLargeColumns hUpdateTarget}.

  /* CollectChanges according to ModifyFields */
  IF cModifyFields = '(Updatable)':U THEN
  DO:
    IF VALID-HANDLE(hUpdateTarget) THEN
      {get UpdatableColumns cUpdatable hUpdateTarget}.
  END.
  ELSE IF cModifyFields <> '(All)':U AND cModifyFields <> '(EnabledFields)':U THEN
    cCheckFields = cModifyFields.

  DO iCnt = 1 TO NUM-ENTRIES(cFieldHandles):
    ASSIGN 
      hFrameField = WIDGET-HANDLE(ENTRY(iCnt, cFieldHandles))
      cField      = ENTRY(iCnt,cFieldNames).   
    
    /* set above if ModifyFields specifies a field list */
    IF cCheckFields > '':U AND LOOKUP(cField,cCheckFields) = 0 THEN
      NEXT.

    /* Qualify the fields if not qualified AND UpdateTargetNames has exacly */
    /* one entry. The reason is that if it had more entries then the viewer */
    /* has been created against a SBO, so the fields should be already qualified. */
    /* On the other hand, if UpdateTargetNames is empty then our DataTarget */
    /* is NOT an SBO, so no qualification is needed */
    IF cObjectType <> "SmartDataBrowser":U THEN /* older dyn browsers may have set this property */
      IF NUM-ENTRIES(cField, '.':U) = 1 AND NUM-ENTRIES(cUpdateNames) = 1 THEN
        cField = cUpdateNames + '.':U + cField.
    
    /* set above if ModifyFields is '(updatable)' */
    IF cUpdatable > '':U AND LOOKUP(cField,cUpdatable) = 0 THEN
      NEXT.

        /* The "Frame Field" may be a procedure handle for a SmartDataField object */
    IF hFrameField:TYPE = "PROCEDURE":U THEN
    DO:
      lMod = DYNAMIC-FUNCTION('getDataModified':U IN hFrameField) NO-ERROR.

      /* if in an add/copy then set modified flag if field is enabled */
      IF lMod = NO AND cNew <> "no":U THEN  
        lMod = DYNAMIC-FUNCTION('getFieldEnabled':U IN hFrameField) NO-ERROR.
      IF lMod THEN
      DO:
        /* largecolumns need to be passed by reference */
        IF LOOKUP(cField,cLargeColumns) > 0 THEN
          cValue = DYNAMIC-FUNCTION('getLOBReference':U IN hFrameField).
        ELSE
          cValue = DYNAMIC-FUNCTION('getDataValue':U IN hFrameField).
        IF cValue = ? THEN 
          ASSIGN cValue = "?":U.      

        ASSIGN iChanges  = iChanges + 1
               pcChanges = pcChanges + (IF pcChanges EQ "":U THEN "":U ELSE CHR(1)) 
                         + cField    + CHR(1)
                         + cValue.
      END. /* if lMod */

    END.  /* END DO IF PROCEDURE */
    ELSE 
    IF hFrameField:MODIFIED 
    OR /* Always if in add/copy */
      (cNew <> "no":U AND CAN-DO(cEnabledFields,hFrameField:NAME)) THEN
    DO:
      IF LOOKUP(cField,cLargeColumns) > 0 THEN
      DO:
        /* Add call back information for LargeColumns */ 
        IF hFrameField:DATA-TYPE = 'LONGCHAR':U THEN
          cChange = 'Data,widgetLongCharValue,':U + STRING(TARGET-PROCEDURE).
        ELSE 
          cChange = 'Data,widgetValue,':U + STRING(TARGET-PROCEDURE).
      END.

      /* Need to try to assign the INPUT-VALUE to see if there is an 
         error with the INPUT-VALUE, for example an invalid date was
         entered by the user, if there is we add a message for this
         field */
      ELSE DO:
        cChange  = hFrameField:INPUT-VALUE NO-ERROR.
        IF ERROR-STATUS:GET-MESSAGE(1) NE '':U THEN 
        DO:
          cMessage = ERROR-STATUS:GET-MESSAGE(1).
          /* Ignore the format error if this is a blank field that does
             not match the format (It is possible to set screen-value to 
             blank for a field where the format does not allow blanks, but a 
             reference to input-value will give an error) */ 
          IF {fnarg widgetIsBlank cField} THEN cChange = "":U.
          ELSE DO:
            lError = TRUE.
            RUN addMessage IN TARGET-PROCEDURE (cMessage, hFrameField:NAME, ?).
          END.  /* else do */
        END.  /* if error with INPUT-VALUE */
      END.

      IF NOT lError THEN
        ASSIGN 
          iChanges  = iChanges + 1
          pcChanges = pcChanges 
                    + (IF pcChanges EQ "":U THEN "":U ELSE CHR(1)) 
                    + cField
                    + CHR(1) 
                    + IF cChange = ? 
                      THEN "?":U
                      ELSE cChange.
    END. /* END DO IF MODIFIED */ 
  END.   /* END DO iCnt */
  IF iChanges > 0 THEN
  DO:
    {get ObjectPage iPage}.
    pcInfo = pcInfo 
             + (IF pcInfo NE "":U THEN ",":U ELSE "":U)
             + STRING(iChanges) + ",":U 
             + STRING(iPage) + ",":U 
             + STRING(TARGET-PROCEDURE).
  END.  /* END DO iChanges */
  RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-confirmCancel) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE confirmCancel Procedure 
PROCEDURE confirmCancel :
/*------------------------------------------------------------------------------
  Purpose:     Make sure there are unsaved changes is cancelled and uncommitted
               changes are undone before allowing its container to initiate a 
               "destroy" operation.
  Parameters:  INPUT-OUTPUT plError - 
               If this is returned TRUE the destroyObject will be cancelled.
       Notes:  The name confirm is used as it is in family with the other 
               confirm methods, but this does not ask any questions                  
------------------------------------------------------------------------------*/ 
  DEFINE INPUT-OUTPUT PARAMETER plError AS LOGICAL NO-UNDO.
  
  IF NOT plError THEN
  DO:
    RUN okToContinueProcedure IN TARGET-PROCEDURE (
        INPUT 'Cancel':U,
        OUTPUT plError).
    plError = NOT plError.
  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-confirmCommit) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE confirmCommit Procedure 
PROCEDURE confirmCommit :
/*------------------------------------------------------------------------------
  Purpose:     Checks to make sure there are no unsaved changes before allowing 
               its data-source to start a "commitTransaction" operation.
  Parameters:  INPUT-OUTPUT plCancel - 
                 If this is returned TRUE the transaction will be committed.
------------------------------------------------------------------------------*/
  DEFINE INPUT-OUTPUT PARAMETER plCancel AS LOGICAL NO-UNDO.
  
    
  IF NOT plCancel THEN
  DO:
    RUN okToContinueProcedure IN TARGET-PROCEDURE (
        INPUT 'Commit':U,
        OUTPUT plCancel).
    plCancel = NOT plCancel.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-confirmContinue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE confirmContinue Procedure 
PROCEDURE confirmContinue :
/*------------------------------------------------------------------------------
  Purpose:     Checks to make sure there are no unsaved changes 
               or uncommitted data before allowing its data-source 
               to start an "Apply filter" operation.
  Parameters:  INPUT-OUTPUT plCancel - 
                 If this is returned TRUE new filter data will be applied.
------------------------------------------------------------------------------*/
  DEFINE INPUT-OUTPUT PARAMETER plCancel AS LOGICAL NO-UNDO.
  
  /*IF NOT plCancel THEN
    plCancel = NOT {fnarg okToContinue 'openQuery':U}. */
  IF NOT plCancel THEN
  DO:
    RUN okToContinueProcedure IN TARGET-PROCEDURE (
        INPUT 'openQuery':U,
        OUTPUT plCancel).
    plCancel = NOT plCancel.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-confirmDelete) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE confirmDelete Procedure 
PROCEDURE confirmDelete :
/*------------------------------------------------------------------------------
  Purpose:     Deleterecord hook to ask a question before record is
               deleted, giving the option to abort the deletion.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT-OUTPUT PARAMETER plAnswer AS LOGICAL NO-UNDO.

  DEFINE VARIABLE cMessage                      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cAnswer                       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cButtonPressed                AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hUpdateTarget                 AS HANDLE    NO-UNDO.
  DEFINE VARIABLE cTarget                       AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cDisplayColumns               AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iLoop                         AS INTEGER    NO-UNDO.
  DEFINE VARIABLE hContainer                    AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cAllFieldNames                AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSecuredFields                AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cHiddenFields                 AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hField                        AS HANDLE    NO-UNDO.
  DEFINE VARIABLE cFieldName                    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cUpdateTargetNames            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hSDO                          AS HANDLE     NO-UNDO.
  DEFINE VARIABLE lAll                          AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cObjectType                   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cOneToOneList                 AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iCount                        AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iCount2                       AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cValue                        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cLabel                        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cLargeColumns                 AS CHARACTER  NO-UNDO.

  ASSIGN
    plAnswer = NO
    cMessage = {fnarg messageNumber 34}.

  &SCOPED-DEFINE xp-assign
  {get UpdateTarget cTarget}
  {get ObjectType cObjectType}
  {get FieldSecurity cSecuredFields}
  {get ContainerHandle hContainer}.
  &UNDEFINE xp-assign

  hUpdateTarget = WIDGET-HANDLE(cTarget).
  IF NOT VALID-HANDLE(hUpdateTarget) THEN
  DO:
    plAnswer = no.
    RETURN. 
  END.

  IF {fn getObjectType hUpdateTarget} = 'SmartBusinessObject':U THEN
  DO:
    {get UpdateTargetNames cUpdateTargetNames}.
    hSDO = {fnarg dataObjectHandle ENTRY(1,cUpdateTargetNames) hUpdateTarget}.
    cOneToOneList = {fnarg getUpdateSiblings hSDO hUpdateTarget}.
    DO iCount = 1 TO NUM-ENTRIES(cOneToOneList):
      hSDO = {fnarg dataObjectHandle ENTRY(iCount,cOneToOneList) hUpdateTarget}.
      {get PromptColumns cAnswer  hSDO}.
      IF cAnswer = '(NONE)':U OR cAnswer = '':U OR cAnswer = ? THEN
        cAnswer = '':U.
      ELSE IF cAnswer = '(ALL)':U THEN
        cAnswer = {fn getDataColumns hSDO}.
      DO iCount2 = 1 TO NUM-ENTRIES(cAnswer):
        ENTRY(iCount2, cAnswer) = ENTRY(iCount, cOneToOneList) + '.' + ENTRY(iCount2, cAnswer).
      END.
      cDisplayColumns = cDisplayColumns
                      + (IF cDisplayColumns = '' THEN '' ELSE ',')
                      + cAnswer.
    END.
    cAnswer = '':U.  /* reset borrowed variable... */
  END.
  ELSE DO:
    {get PromptColumns cDisplayColumns hUpdateTarget}.
    IF cDisplayColumns = '(NONE)':U 
    OR cDisplayColumns = '':U
    OR cDisplayColumns = ? THEN
      cDisplayColumns = '':U.
    ELSE IF cDisplayColumns = '(ALL)':U THEN
    DO:
      lAll = TRUE. 
      /* get list of data columns in the SDO */
      cDisplayColumns = DYNAMIC-FUNCTION("getDataColumns":U IN hUpdateTarget).
    END.
  END.
  
  {get LargeColumns cLargeColumns hUpdateTarget}.

  IF cObjectType = "smartDataBrowser":U THEN 
    {get displayedFields cAllFieldNames}.
  ELSE 
    {get AllFieldNames cAllFieldNames}.
  
  DO iLoop = 1 TO NUM-ENTRIES(cSecuredFields):
    IF ENTRY(iLoop,cSecuredFields) = 'Hidden':U THEN
     cHiddenFields  = cHiddenFields + ',':U + ENTRY(iLoop,cAllFieldNames).
  END.

  DO iLoop = 1 TO NUM-ENTRIES(cDisplayColumns):
    cFieldName = ENTRY(iLoop, cDisplayColumns).
    /* only show non-LargeColumns */
    IF NOT CAN-DO(cLargeColumns,cFieldName) THEN
    DO:
      IF NUM-ENTRIES(cFieldName, '.':U) = 2 THEN 
        ASSIGN
          hSDO = {fnarg dataObjectHandle ENTRY(1,cFieldName,'.':U) hUpdateTarget}
          cFieldName = ENTRY(2, cFieldName, '.':U).
      ELSE
        hSDO = hUpdateTarget.

      IF NOT CAN-DO(cHiddenFields, cFieldName) 
       /* Skip _obj for the all option */
      AND (NOT lAll OR NOT (cFieldName MATCHES '*_obj':U) ) THEN 
      DO:
        ASSIGN cValue = DYNAMIC-FUNCTION("columnStringValue":U IN hSDO,
                                         INPUT cFieldName)
               cLabel = DYNAMIC-FUNCTION("columnLabel":U IN hSDO,
                                         INPUT cFieldName)
                .
          /* If we don't have a label and the value is unknown then
             do not include this field */
        IF cLabel = ? AND cValue = ? THEN
          NEXT.
    
        IF cValue = ? THEN cValue = '?':U.
        IF cLabel = ? THEN cLabel = '':U.
    
        /* Ensure that the string we will display to the user to confirm the record deletion does
           not exceed 15000 characters. This should be more than adequate information for the user
           to identify the record. More data than this causes 4GL errors when trying to display it
           in the message dialog or when passing parameters between procedures. You would expect
           to have a limit of 32000 characters, but strangely, little more than 15000 characters
           in this case causes issues with the message dialog interaction */
        ASSIGN
          cAnswer  = CHR(10) + cLabel + " : ":U + cValue
          cMessage = cMessage              /* -- This is the number of characters we can add --- */
                   + SUBSTRING(cAnswer, 1, MAX(0, MIN((15000 - LENGTH(cMessage)), LENGTH(cAnswer))))
          cAnswer  = '':U.  /* reset borrowed variable... */
      END.
    END. /* not large */
  END.
  
  IF NOT {fnarg IsDialogBoxParent hContainer}
     AND NOT {fn IsFunctionInCallStack}
     AND VALID-HANDLE(gshSessionManager) THEN
  DO:
      
      RUN askQuestion IN gshSessionManager (    
          INPUT cMessage,         /* pcMessageList     */
          INPUT "Yes,No",         /* pcButtonList      */
          INPUT "YES",            /* pcDefaultButton   */
          INPUT "NO",             /* pcCancelButton    */
          INPUT "Record Deletion",   /* pcMessageTitle    */
          INPUT "",               /* pcDataType        */
          INPUT "",               /* pcFormat          */
          INPUT-OUTPUT cAnswer,   /* pcAnswer          */
          OUTPUT cButtonPressed   /* pcButtonPressed   */   
          ) NO-ERROR.
  
      CASE cButtonPressed:
          WHEN "YES" THEN plAnswer = TRUE.
          WHEN "NO"  THEN plAnswer = FALSE.                
      END CASE.             
  END.
  ELSE DO:
      MESSAGE cMessage VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO 
      UPDATE plAnswer.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-confirmExit) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE confirmExit Procedure 
PROCEDURE confirmExit :
/*------------------------------------------------------------------------------
  Purpose:     Checks to make sure there are no unsaved changes 
               or uncommitted data before allowing its container 
               to initiate a "destroy" operation.
  Parameters:  INPUT-OUTPUT plCancel - 
                 If this is returned TRUE the destroyObject will be cancelled.
------------------------------------------------------------------------------*/
  
  DEFINE INPUT-OUTPUT PARAMETER plCancel AS LOGICAL NO-UNDO.

  IF NOT plCancel THEN
  DO:
    RUN okToContinueProcedure IN TARGET-PROCEDURE (
        INPUT 'Exit':U,
        OUTPUT plCancel).
    plCancel = NOT plCancel.
  END.
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
------------------------------------------------------------------------------*/ 
  DEFINE INPUT-OUTPUT PARAMETER plError AS LOGICAL NO-UNDO.
  
  IF NOT plError THEN
  DO:
    RUN okToContinueProcedure IN TARGET-PROCEDURE (
        INPUT 'Ok':U,
        OUTPUT plError).
    plError = NOT plError.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-confirmUndo) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE confirmUndo Procedure 
PROCEDURE confirmUndo :
/*------------------------------------------------------------------------------
  Purpose:     Checks to make sure there are no unsaved changes before allowing 
               its data-source to start an "undoTransaction" operation.
  Parameters:  INPUT-OUTPUT plCancel - 
                 If this is returned TRUE the changes will be undone.
------------------------------------------------------------------------------*/
  DEFINE INPUT-OUTPUT PARAMETER plCancel AS LOGICAL NO-UNDO.
  
  IF NOT plCancel THEN
  DO:
    RUN okToContinueProcedure IN TARGET-PROCEDURE (
        INPUT 'Undo':U,
        OUTPUT plCancel).
    plCancel = NOT plCancel.
  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-copyRecord) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE copyRecord Procedure 
PROCEDURE copyRecord :
/*------------------------------------------------------------------------------
  Purpose:     General code for Copy operation.
  Parameters:  <none>
  Notes:       Invoked when the Copy button is pressed on an Update SmartPanel
               or on a SmartToolbar.
               No Copy operation can be done while there are updates in 
               progress, if so, the user receives a message that current values
               must be saved or cancelled before Copy.
               Sets NewRecord property to 'Copy'.
               PUBLISHes updateState 'Update' to tell Tableio source and 
               Update target that update is in progress.               
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cTarget      AS CHARACTER NO-UNDO.
  DEFINE VARIABLE hGroupSource AS HANDLE    NO-UNDO.
  DEFINE VARIABLE lMod         AS LOGICAL   NO-UNDO.
 
  &SCOPED-DEFINE xp-assign
  {get GroupAssignSource hGroupSource}
  {get UpdateTarget cTarget}
  {get DataModified lMod}.
  &UNDEFINE xp-assign
  IF cTarget = "":U AND hGroupSource = ? THEN
  DO:
    DYNAMIC-FUNCTION('showMessage':U IN TARGET-PROCEDURE, INPUT {fnarg messageNumber 63}).
    RETURN "ADM-ERROR":U.
  END.

  /* Reject the Copy attempt if the current values have been modified
      and not saved. */
   IF lMod THEN
   DO:
      DYNAMIC-FUNCTION('showMessage':U IN TARGET-PROCEDURE, INPUT '2':U).
      /*  "Current values must be saved or cancelled before Add or Copy." */
      RETURN "ADM-ERROR":U. 
   END.
      
   {set NewRecord 'Copy':U}.

   /* If for some reason this object's fields have not been enabled from
      outside, then do it here. */
   RUN enableFields IN TARGET-PROCEDURE.
     
   RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-dataAvailable) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE dataAvailable Procedure 
PROCEDURE dataAvailable :
/*------------------------------------------------------------------------------
  Purpose:     This is invoked whenever the Data source has a new row. 
               Requests the data columns to be displayed in the Data source 
               for that row and displays them.
  Parameters:  pcRelative AS CHARACTER -- record state
               Possible values are:
               ?                - To check if there is a record pending
               FIRST            - First record 
               PREV             - Prev record
               NEXT             - Next record 
               LAST             - Last record
               SAME             - Same record 
               DIFFERENT        - Different record
  Notes:       Parallel to row-available for V8 SmartViewers.
               This version of dataAvailable doesn't care of the value
               of the input parameter received.
               AddRecord and CopyRecord does its own display so we only 
               display if NewRecord = 'NO' in ourselves or GroupAssignSource.  
------------------------------------------------------------------------------*/
 DEFINE INPUT PARAMETER pcRelative AS CHARACTER NO-UNDO.

 DEFINE VARIABLE hAddSource        AS HANDLE    NO-UNDO.
 DEFINE VARIABLE cNewRecord        AS CHARACTER NO-UNDO.
 DEFINE VARIABLE lInitialized      AS LOGICAL   NO-UNDO.

 {get ObjectInitialized lInitialized}.
 IF NOT lInitialized THEN
    RETURN.

 /* The NewRecord is only set at the tableioTarget yet, 
    so check through a potential GroupAssignSource link chain. */ 
 hAddSource = TARGET-PROCEDURE.
 DO WHILE VALID-HANDLE(hAddSource):
   &SCOPED-DEFINE xp-assign
   {get NewRecord cNewRecord hAddSource}
   {get GroupAssignSource hAddSource hAddSource}.
   &UNDEFINE xp-assign
 END.
 
 IF cNewRecord = 'NO':U THEN
   RUN displayRecord IN TARGET-PROCEDURE.
 
 RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-deleteRecord) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE deleteRecord Procedure 
PROCEDURE deleteRecord :
/*------------------------------------------------------------------------------
  Purpose:     General code for Delete operation.
  Parameters:  <none>
  Notes:       Invoked when the Delete button is pressed on an Update SmartPanel
               or a SmartToolbar.
               Invokes deleteRow() in the Update target.
------------------------------------------------------------------------------*/

  DEFINE VARIABLE hUpdateTarget  AS HANDLE    NO-UNDO.
  DEFINE VARIABLE cTarget        AS CHARACTER NO-UNDO.
  DEFINE VARIABLE lSuccess       AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE cRowIdent      AS CHARACTER NO-UNDO.
  DEFINE VARIABLE lAutoCommit    AS LOGICAL   NO-UNDO. 
  DEFINE VARIABLE cDummy         AS CHARACTER NO-UNDO.
  DEFINE VARIABLE lConfirmDelete AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE cUpdateTargetNames  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hSDO                AS HANDLE    NO-UNDO.
 
  {get UpdateTarget cTarget}.
  hUpdateTarget = WIDGET-HANDLE(cTarget).  /* NOTE: Make sure there's just 1? */
  
  IF VALID-HANDLE(hUpdateTarget) THEN
  DO:
    IF {fn getObjectType hUpdateTarget} = 'SmartBusinessObject':U THEN
    DO:
      {get UpdateTargetNames cUpdateTargetNames}.
      hSDO = {fnarg dataObjectHandle ENTRY(1,cUpdateTargetNames) hUpdateTarget}.
      {get PromptOnDelete lConfirmDelete hSDO}.
    END.
    ELSE
      {get PromptOnDelete lConfirmDelete hUpdateTarget}.

    IF lConfirmDelete THEN
      RUN confirmDelete IN TARGET-PROCEDURE(INPUT-OUTPUT lConfirmDelete).
    ELSE
      lConfirmDelete = YES.

    IF lConfirmDelete THEN
    DO:
    {get RowIdent cRowIdent}. 
    lSuccess = dynamic-function("deleteRow":U IN hUpdateTarget,
                                cRowIdent).  
    END. /* lConfirmDelete */
  END.  /* END DO VALID-HANDLE */
  ELSE DO:
    RUN addMessage IN TARGET-PROCEDURE
      ({fnarg messageNumber 64}, ?, ?).
    lSuccess = no.
  END.  /* END ELSE DO (NOT VALID-HANDLE) */
  IF lSuccess = no THEN
  DO:
    /* {fn showDataMessages}. */
    RUN showDataMessagesProcedure IN TARGET-PROCEDURE (OUTPUT cDummy) .
    RETURN "ADM-ERROR":U.
  END.
  RETURN.
 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-destroyObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE destroyObject Procedure 
PROCEDURE destroyObject :
/*------------------------------------------------------------------------------
  Purpose:  override to unregister from object Mapping in an sbo (if necessary)    
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  
  PUBLISH 'unRegisterObject':U FROM TARGET-PROCEDURE.  /* iz 996*/
  RUN SUPER.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-disableFields) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disableFields Procedure 
PROCEDURE disableFields :
/*------------------------------------------------------------------------------
  Purpose:   set ObjectMode    
  Parameters:  <none>
  Notes:    Viewer and browser class has complete override for disabling.       
         -  The ObjectMode is also set in updateMode, but users may call this
            directly. 
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcFieldType AS CHARACTER  NO-UNDO.
  {set ObjectMode 'View':U}.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-displayRecord) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE displayRecord Procedure 
PROCEDURE displayRecord :
/*------------------------------------------------------------------------------
  Purpose:    Display the current datasource's rows 
  Parameters:  <none>
  Notes:      
------------------------------------------------------------------------------*/
 DEFINE VARIABLE cColumns       AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cDisplayed     AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cQueryPosition AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE hSource        AS HANDLE     NO-UNDO.
 DEFINE VARIABLE cSourceNames   AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cUIBmode       AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cLargeColumns  AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cColumn        AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE iCol           AS INTEGER    NO-UNDO.
 DEFINE VARIABLE iPos           AS INTEGER    NO-UNDO.
 DEFINE VARIABLE lNoQual        AS LOGICAL     NO-UNDO.

 {get DataSource hSource}.
 IF VALID-HANDLE(hSource) THEN
 DO:
   {get DisplayedFields cDisplayed}.

   /* colvalues cannot return LargeColumns so replace the name with SKIP */
   {get LargeColumns cLargeColumns hSource}.
   
   lNoQual = INDEX(cDisplayed,'.':U) = 0.

   IF lNoQual THEN
     {get DataSourceNames cSourceNames} NO-ERROR.   

   DO iCol = 1 TO NUM-ENTRIES(cLargeColumns):
     ASSIGN
       cColumn = ENTRY(iCol,cLargeColumns)
       iPos    = LOOKUP(cColumn,cDisplayed).  
     
     IF NUM-ENTRIES(cColumn,".":U) > 1 
     AND iPos = 0 
     AND lNoQual 
     AND NUM-ENTRIES(cSourceNames) = 1 
     AND ENTRY(1,cColumn,".":U) = cSourceNames THEN
       iPos = LOOKUP(ENTRY(2,cColumn,".":U),cDisplayed).  

     IF iPos > 0 THEN
       ENTRY(iPos,cDisplayed) = 'SKIP':U.
   END.
   
/* If the fields are unqualified, we check if we run against an SBO and
      qualify so the SBO can know which SDO to direct the call to.  
      This is both for speed and is also required for data integrity as the SBO 
      does return values on a first found basis. The SBOs addDataTarget will not 
      allow any ambiguity when generating DataSourceNames, but trusts the object
      to qualify correctly if DataSourceNames is set already at start up. */
   IF lNOQual AND NUM-ENTRIES(cSourceNames) = 1 THEN 
      /* The SBOs colValues needs only one qualifer to direct the call to 
         that SDO */
      cDisplayed = cSourceNames + '.':U + cDisplayed. 
   
   cColumns = DYNAMIC-FUNCTION ("colValues":U IN hSource, cDisplayed) NO-ERROR.
          /* error 7351 indicates that a buffer-field is missing */
   IF cColumns = ? AND ERROR-STATUS:GET-NUMBER(1) = 7351 THEN 
     DYNAMIC-FUNC('showMessage' IN TARGET-PROCEDURE, 
              SUBSTITUTE(DYNAMIC-FUNC("messageNumber":U IN TARGET-PROCEDURE,19), 
                       /* The fieldname is the second entry in the message */
                         ENTRY(2,ERROR-STATUS:GET-MESSAGE(1)," ":U),
                         TARGET-PROCEDURE:FILE-NAME)).

   ELSE RUN displayFields IN TARGET-PROCEDURE (cColumns).
 END. /* if valid datasource */
 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-enableFields) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enableFields Procedure 
PROCEDURE enableFields :
/*------------------------------------------------------------------------------
  Purpose:   set ObjectMode    
  Parameters:  <none>
  Notes:    Viewer and browser class has complete override for enabling.       
            The ObjectMode is also set in updateMode, but users may call this
            directly. 
------------------------------------------------------------------------------*/
   DEFINE VARIABLE cObjectMode AS CHARACTER  NO-UNDO.
   /* Ensure we don't override the 'stronger' modal update mode, which 
      is used to enable cancel */ 

   {get ObjectMode cObjectMode}.
   IF cObjectMode <> 'Update':U THEN
     {set ObjectMode 'Modify':U}.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fieldModified) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE fieldModified Procedure 
PROCEDURE fieldModified :
/*------------------------------------------------------------------------------
  Purpose: Run whenever a field is modified. 
           Sets DataModified  to true unless the ModifyFields property is 
           specifed to ignore this field. 
 Paramter: Handle of the field whose value has changed 
    Notes: The passed field must be in the list of EnabledFields or 
           EnabledObjFlds.
         - Called from valueChanged or SDF's setDataModified or Client APIs that
           changes widget values.       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER phField AS HANDLE     NO-UNDO.
  
  DEFINE VARIABLE lSetModified     AS LOGICAL    NO-UNDO.
  
  DEFINE VARIABLE cEnabledHandles  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cEnabledFields   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cEnabledObjHdls  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cEnabledObjFlds  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iFld             AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cName            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cModifyFields    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hUpdateTarget    AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cUpdatableCols   AS CHARACTER  NO-UNDO.    
  DEFINE VARIABLE lResult          AS LOGICAL    NO-UNDO.    
  DEFINE VARIABLE hGASource        AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hUpdateSource    AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cUpdateTargetNames AS CHARACTER  NO-UNDO.
  IF NOT VALID-HANDLE(phField) THEN 
    RETURN.
  
  /* if modified is set already just return */ 
  {get DataModified lResult}.
  IF lResult THEN 
    RETURN.
  
  /* Return if the object's not enabled for input.*/
  {get FieldsEnabled lResult}. 
  IF NOT lResult THEN 
    RETURN.
  
  {get ModifyFields cModifyFields}.
  
  /* Return if no fields should set DataModified.*/ 
  IF cModifyFields = '(None)':U THEN
    RETURN.
  
  /* If for some reason ModifyFields is not set, set default = (all) */ 
  IF cModifyFields = '':U OR cModifyFields = ? THEN
    cModifyFields = '(All)':U.
  
  {get EnabledHandles cEnabledHandles}.
  
  iFld = LOOKUP(STRING(phField),cEnabledHandles).
  IF iFld > 0 THEN 
  DO:
    /* One of the EnabledFields has changed so (All) or (EnabledFields) 
       should set DataModified */
    IF cModifyFields = '(All)':U OR cModifyFields = '(EnabledFields)':U THEN
      lSetModified = TRUE.
    ELSE DO:
      /* get the name of the EnabledField */ 
      {get EnabledFields cEnabledFields}.
      cName = ENTRY(iFld,cEnabledFields).
      /* if (updatable) check if the name is updatable in the updateTarget */
      IF cModifyFields = '(Updatable)':U THEN
      DO:
        /* The UpdateTarget is only linked as the upper GA source, so find the
           real UpdateSource by looping up the GroupAssignSource link chain. */         
        hGASource = TARGET-PROCEDURE. 
        DO WHILE VALID-HANDLE(hGASource):
          hUpdateSource = hGASource.
          {get GroupAssignSource hGASource hUpdateSource}.
        END.
        {get UpdateTarget hUpdateTarget hUpdateSource}.
        IF VALID-HANDLE(hUpdateTarget) THEN
        DO:
          {get UpdatableColumns cUpdatableCols hUpdateTarget}.          
          /* If the datasource has qualified fieldnames and the passed field name 
             is not qualified then qualify the name with UpdateTargetNames 
             (viewer built against SDO but linked to SBO) */
          IF INDEX(cUpdatableCols,'.':U) > 1 AND NUM-ENTRIES(cName, '.':U) = 1 THEN
          DO:
            {get UpdateTargetNames cUpdateTargetNames}.
            /* There should always be only one entry in this case, but ...*/
            IF NUM-ENTRIES(cUpdateTargetNames) = 1 THEN
              cName = cUpdateTargetNames + '.':U + cName.
          END.
          IF LOOKUP(cName,cUpdatableCols) > 0 THEN
            lSetModified = TRUE.
        END.
      END. /* if ModifyFields (Updatable) */
      /* Check if ModifyFields has a list of fields that includes this name */
      ELSE IF LOOKUP(cName,cModifyFields) > 0 THEN
        lSetModified = TRUE.
    END. /* else - NOT '(all)' or '(EnabledFields)' */
  END. /* ifld > 0 (lookup(phField,EnabledHandles) */
  ELSE DO: /* field not found in enabledHandles */
    {get EnabledObjHdls cEnabledObjHdls}.
    iFld = LOOKUP(STRING(phField),cEnabledObjHdls).
    IF iFld > 0 THEN
    DO:
      /* '(All)' means that also local fields should set DataModified*/
      IF cModifyFields = '(All)':U THEN
        lSetModified = TRUE.
       /* else check if the property has a list of objects to modify */    
      ELSE DO:
        {get EnabledObjFlds cEnabledObjFlds}.
        cName = ENTRY(iFld,cEnabledObjFlds).
        IF LOOKUP(cName,cModifyFields) > 0 THEN
          lSetModified = TRUE.
      END.
    END. /* ifld > 0 (lookup(phField,EnabledObjHdls) */
  END. /* else (field not found in enabledHandles) */
  
  IF lSetModified THEN 
    {set DataModified yes}.
  
  RETURN. 

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-initializeObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeObject Procedure 
PROCEDURE initializeObject :
/*------------------------------------------------------------------------------
  Purpose:     Data visualization (Viewers and Browsers) version of 
               initializeObject.
  Parameters:  <none>
  Notes:       Invokes displayObjects to display values of non database fields.
               Sets the value of the SaveSource property which indicates the 
               'PanelType'of the SmartPanel Update or SmartToolbar, if any, 
               we are connected to. (c.f. PanelType 'Update' or 'Save').
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hSource        AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hDataSource    AS HANDLE    NO-UNDO.
  DEFINE VARIABLE cPanelType     AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cState         AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cTarget        AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cUIBMode       AS CHARACTER NO-UNDO.
  
  /* The datasource link is deactivated on add (LinkstateHandler) to avoid 
     messages before needed. */
  {get DataSource hDataSource}.
  IF VALID-HANDLE(hDataSource) THEN
  DO:
    /* The activation of inactive link is done also for the following reason,
       ( must thus remain here if unconditional inactivation is removed
        from LinkStateHandler) : 
        if the datasource is inactive then activate it before the object is 
        initialized as we don't want viewObject -> (data.p)linkState 
       -> LinkstateHandler to run dataAvailable, since it also is run at the end 
          of initialization in viewer and browser. 
         (This is kind of a workaround for the fact that ObjectInitialized is set 
         to true in smart.p initializeObject, somewhat early .. )   

        IF DYNAMIC-FUNCTION("isLinkInactive":U IN TARGET-PROCEDURE,
                          'DataSource':U,hDataSource) THEN
       */

    RUN linkStateHandler IN TARGET-PROCEDURE
                       ('active':U,hDataSource,'DataSource':U). 
  END.
  RUN SUPER.            /* Invoke the standard behavior first. */  
  IF RETURN-VALUE = "ADM-ERROR":U
    THEN RETURN "ADM-ERROR":U. 

  /* The sbo subscribes to this event in order to update ObjectMapping.*/
  PUBLISH 'registerObject':U FROM TARGET-PROCEDURE.
  {get TableIOSource hSource}.  
    /* If there's a TableIO-Source but no Update-Target, this is invalid,
     so setEditable to false in order to disable the update panel. 
     Actions are either checking editable or canNavigate */
  IF VALID-HANDLE(hSource) THEN  /* If no TIO-Source then leave SaveSource '?' */
  DO:
    {get UpdateTarget cTarget}.
    IF cTarget = "":U THEN
    DO:
      {set Editable FALSE}.
    END.
    ELSE DO:
      /* Check save/update mode in the toolbar */
      cPanelType = {fn getTableioType hSource} NO-ERROR.
      
      /* Check save/update mode in the panel (different property) */
      IF cPanelType = ? THEN
        cPanelType = {fn getPanelType hSource} NO-ERROR.
      
      IF cPanelType = 'Save':U THEN 
        {set SaveSource yes}.
      ELSE 
        {set SaveSource no}.
    END. /* END DO IF cTarget NOT "" */
  END.   /* END DO IF VALID-HANDLE */
  ELSE DO:
    /* Ensure that grand-child objects always are disabled in design mode */ 
    {get UIBMode cUIBMode}.
     
    IF cUIBMode BEGINS "design":U THEN
      {set SaveSource no}.
  END.

  /* The DataSource may have published queryPosition before we got created
     and queryPosition also RETURNs when not initialized so retrieve the 
     QueryPosition from the DataSource and pass it to ourselves to ensure 
     correct state and field enabling. */ 
  {get DataSource hDataSource}.
  IF VALID-HANDLE(hDataSource) THEN
  DO:
    ghTargetProcedure = TARGET-PROCEDURE.
    {get QueryPosition cState hDataSource}.
    ghTargetProcedure = ?.
    
    /* An uninitialized SDO/SBO may return blank.. */  
    IF cState = '':U THEN cState = 'NoRecordAvailable':U.
    RUN queryPosition IN TARGET-PROCEDURE (cState).
  END. 

  RUN displayObjects IN TARGET-PROCEDURE NO-ERROR.
  
  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-isUpdateActive) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE isUpdateActive Procedure 
PROCEDURE isUpdateActive :
/*------------------------------------------------------------------------------
  Purpose: Received from container source to check if contained objects have 
           unsaved or uncommitted changes, including addMode.           
    Notes: This is published thru the container link and are used for 
           close logic ( ok, cancel, exit).
          (It is very similar to canNavigate -> isUpdatePending which is 
           published thru the data link)   
         - This can be called directly, but canExit() is the intended API.
           canExit() is used to check an actual container from the toolbar.              
--------------------------------------------------------------------------------*/
  DEFINE INPUT-OUTPUT PARAMETER plActive AS LOGICAL NO-UNDO.

  DEFINE VARIABLE lModified  AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cNewRecord AS CHARACTER  NO-UNDO.

  IF NOT plActive THEN 
  DO:
    &SCOPED-DEFINE xp-assign
    {get DataModified lModified}
    {get NewRecord cNewRecord}.
    &UNDEFINE xp-assign
    plActive = lModified OR cNewRecord <> 'NO':U. 
    
    /* call super with no-error in case this is a container  */
    IF NOT plActive THEN 
      RUN SUPER(INPUT-OUTPUT plActive) NO-ERROR.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-isUpdatePending) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE isUpdatePending Procedure 
PROCEDURE isUpdatePending :
/*------------------------------------------------------------------------------
  Purpose:    Returns true if this object is in update mode 
  Parameters:  I-O plUpdate - Is update pending
               if it is input as true then some other subscriber has a pending 
               update and we must just leave it as is. 
  Notes:    -  DataSources publishes this from canNavigate to check if targets
               have pending updates and return false to indicate that the object
               cannot be navigated if the publish returns true.
            -  It is also called directly from canNavigate in this class.     
------------------------------------------------------------------------------*/
  DEFINE INPUT-OUTPUT PARAMETER plUpdate AS LOGICAL NO-UNDO.
 
  DEFINE VARIABLE cMode         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lModified     AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cNew          AS CHARACTER  NO-UNDO INIT 'no'.
  DEFINE VARIABLE hGaSource     AS HANDLE     NO-UNDO.

  {get GroupAssignSource hGaSource}.

  IF VALID-HANDLE(hGaSource) THEN
    RETURN.

  /* Keep update was found somewhere else */
  IF plUpdate = FALSE THEN
  DO:
    &SCOPED-DEFINE xp-assign
    {get DataModified lModified}
    {get NewRecord cNew}
    {get ObjectMode cMode}.
    &UNDEFINE xp-assign
    plUpdate = lModified OR cNew <> 'NO':U OR (cMode = 'Update':U).  
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-linkStateHandler) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE linkStateHandler Procedure 
PROCEDURE linkStateHandler :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters: pcstate -
                add,remove,inactive,active
              phObject - object to link to 
              pcLink   - Linkname (data-source)  
  Notes:      if you think you get this... think again... 
              Or more precisely ensure you realize that there is an override 
              in viewer.p that runs this in all its GroupAssignTargets while the
              SDO's linkState only runs this in the GroupAssignSource.  
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pcState   AS CHARACTER  NO-UNDO.
  DEFINE INPUT PARAMETER phObject  AS HANDLE     NO-UNDO.
  DEFINE INPUT PARAMETER pcLink    AS CHARACTER  NO-UNDO.
 
  DEFINE VARIABLE lDataInactive   AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lInitialized    AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lQueryObject    AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cQueryPosition  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hUpdateTarget   AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cMyRowident     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSourceRowident AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lSameRecord     AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE hGaSource       AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hUpdateSource   AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hDataSource     AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hToolbarSource  AS HANDLE     NO-UNDO.
  
  {get ObjectInitialized lInitialized}.  
  IF pcLink = 'ToolbarSource':U AND pcState = 'Add':U THEN
  DO:
    {get DataSource hDataSource}.
    IF VALID-HANDLE(hDataSource) THEN
    DO:
      /* If we are dealing with a pass-through link, then
         it may be that the data source is still a container.
         Cannot set these flags until the creation of the 2nd 
         half of the pass-through link.        
       */        
      {get QueryObject lQueryObject hDataSource}.
      IF lQueryObject THEN
      DO:
              &SCOPED-DEFINE xp-assign
              {set FetchHasAudit    TRUE hDataSource}
              {set FetchHasComment  TRUE hDataSource}
              {set FetchAutoComment TRUE hDataSource}.
              &UNDEFINE xp-assign
      END.    /* query object */              
    END.
  END.
  ELSE IF pcLink = 'DataSource':U  AND pcState = 'Add':U THEN
  DO:
    {get ToolbarSource hToolbarSource}.
    IF VALID-HANDLE(hToolbarSource) THEN
    DO:
      /* If we are dealing with a pass-through link, then
         it may be that the data source is still a container.
         Cannot set these flags until the creation of the 2nd 
         half of the pass-through link.        
       */
      {get QueryObject lQueryObject phObject}.
      IF lQueryObject THEN
      DO:
              &SCOPED-DEFINE xp-assign
              {set FetchHasAudit    TRUE phObject}
              {set FetchHasComment  TRUE phObject}
              {set FetchAutoComment TRUE phObject}.
              &UNDEFINE xp-assign
      END.    /* query object */              
    END.
    
    /* Delay subscription until initialize! */
    IF NOT lInitialized THEN
    DO:
      /* It may be that the data source is still a pass-thru container.
         If we add this to inactiveLinks we end up with two disabled links, 
         which currently will confuse other logic (f.ex sbo dataAvailable) */
      {get QueryObject lQueryObject phObject}.
      IF lQueryObject THEN
      DO:
        DYNAMIC-FUNCTION('modifyInactiveLinks':U IN TARGET-PROCEDURE,
                         'ADD':U,pcLink,phObject). 
        RETURN. /* <-------------------------------------------*/
      END.
    END.
  END.

  IF lInitialized 
  AND pcstate = 'active':U 
  AND pcLink = 'DataSource':U THEN
  DO:
    /* if the source is inactive then just wait for the dataavailable
       that it will publish when it becomes active */ 
    IF NOT DYNAMIC-FUNCTION('isLinkInactive':U IN phObject,'DataSource':U,?) THEN 
      lDataInactive = DYNAMIC-FUNCTION('isLinkInactive':U IN TARGET-PROCEDURE,
                                       'DataSource':U,phObject).
 
  END.
 
  RUN SUPER(pcState,phObject,pcLink).
  
  IF lDataInactive THEN
  DO:
    /* (note that we only get here when 'active' 'DataSource' )
       We want to avoid redisplay if we are on the same record, but we are a 
       bit paranoid so we ensure that we're the updateSource, so that it is 
       very unlikely that anything have changed in the source while we were 
       unconscious.. (to find the updatetarget we must find the top in the 
       GA link) */ 
    
    hGaSource = TARGET-PROCEDURE.
    DO WHILE VALID-HANDLE(hGaSource):
      hUpdateSource = hGaSource. 
      {get GroupAssignSource hGaSource hUpdateSource}.
    END.
    {get UpdateTarget hUpdateTarget hUpdateSource}.    
    
    IF hUpdateTarget = phObject THEN
    DO:
      {get Rowident cMyRowident}.
      ASSIGN /* check if we are on the same record (? is not avail or new 
                on ANY parent... so make sure that is not seen as the same ) */
        cSourceRowident = ENTRY(1,{fnarg colValues '':U phObject},CHR(1))
        lSameRecord     = (cMyRowident <> ?) AND (cMyRowident = cSourceRowident)  .
    END.
   
    IF NOT lSameRecord THEN
    DO:
      {get QueryPosition cQueryPosition phObject}.
      RUN queryPosition IN TARGET-PROCEDURE(cQueryPosition).
      RUN dataAvailable IN TARGET-PROCEDURE('different':U).
    END.
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
  Notes:       Supports self and no qualifiers
               A field may be qualified in its field name with an SDO name 
               if the viewer was built against an SBO.  This is first treated 
               as no qualifier before treating it as an instance name qualifier.
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER pcWidget AS CHARACTER  NO-UNDO.
DEFINE OUTPUT PARAMETER phWidget AS HANDLE     NO-UNDO.
DEFINE OUTPUT PARAMETER phTarget AS HANDLE     NO-UNDO.

DEFINE VARIABLE cDataTargets       AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cField             AS CHARACTER  NO-UNDO. 
DEFINE VARIABLE cObjectType        AS CHARACTER  NO-UNDO. 
DEFINE VARIABLE hDataSource        AS HANDLE     NO-UNDO. 
DEFINE VARIABLE hDataTarget        AS HANDLE     NO-UNDO. 
DEFINE VARIABLE iDataTargets       AS INTEGER    NO-UNDO.
DEFINE VARIABLE lQueryObject       AS LOGICAL    NO-UNDO. 

  /* Support for Self qualifier */
  IF NUM-ENTRIES(pcWidget, '.':U) > 1 AND ENTRY(1, pcWidget, '.':U) = 'Self':U THEN
  DO:
    ASSIGN 
      cField     = DYNAMIC-FUNCTION('deleteEntry':U IN TARGET-PROCEDURE,
                                     INPUT 1,
                                     INPUT pcWidget,
                                     INPUT '.':U)
      phWidget   = DYNAMIC-FUNCTION('internalWidgetHandle':U IN TARGET-PROCEDURE,
                                     INPUT cField, INPUT 'ALL':U)
      phTarget = TARGET-PROCEDURE NO-ERROR.
    IF phWidget NE ? THEN RETURN. 
  END.  /* if qualifier is self */
  
  /* Support for searching this object with no qualifier 
     (or qualifier of SDO name for field of viewer built against SBO)
     
     If the number of entries is less than or equal to 2 then the field has
     no qualifier or only has one qualifier which could be an SDO name for a
     field of a viewer built with an SBO, check for a widget in this object 
     first with the passed name.  */  
  IF NUM-ENTRIES(pcWidget, '.':U) <= 2 THEN
  DO:
    ASSIGN
      phWidget = DYNAMIC-FUNCTION('internalWidgetHandle':U IN TARGET-PROCEDURE,
                                  INPUT pcWidget, INPUT 'ALL':U)
      phTarget = TARGET-PROCEDURE NO-ERROR.
    IF phWidget NE ? THEN RETURN.
  END.  /* no qualifier or one qualifier */

  /* Support for searching sibling objects with no qualifier 
     (or qualifier of SDO name for field of viewer built against SBO)
     
     If the widget was not found in this object and there is no qualifier
     or only one qualifier which could be an SDO name for a field of a 
     viewer built with an SBO, check for the widget in objects with the 
     same data source. */
  IF NUM-ENTRIES(pcWidget, '.':U) <= 2 THEN
  DO:
    {get DataSource hDataSource}.
    IF VALID-HANDLE(hDataSource) THEN
    DO:
      {get DataTarget cDataTargets hDataSource}.
      DO iDataTargets = 1 TO NUM-ENTRIES(cDataTargets):
        ASSIGN hDataTarget = WIDGET-HANDLE(ENTRY(iDataTargets, cDataTargets)) NO-ERROR.
        &SCOPED-DEFINE xp-assign
        {get QueryObject lQueryObject hDataTarget}
        {get ObjectType cObjectType hDataTarget}.
        &UNDEFINE xp-assign
        /* Only sibling viewer objects are searched when there is no 
           qualifier */
        IF VALID-HANDLE(hDataTarget) AND hDataTarget NE TARGET-PROCEDURE AND 
           NOT lQueryObject AND cObjectType NE 'SmartDataBrowser':U THEN
        DO:    
          /* When searching for widgets with the same data source, only 
             datafields should be searched so NO is being passed as the 
             second parameter to widgetHandleInSelf.  */
          ASSIGN
            phWidget = DYNAMIC-FUNCTION('internalWidgetHandle':U IN hDataTarget,
                                        INPUT pcWidget, INPUT 'DATA':U)
            phTarget = hDataTarget NO-ERROR.
          IF phWidget NE ? THEN RETURN.
        END.  /* if field found */
      END.  /* do iLoop 1 to number of data targets */
    END.  /* valid data source */
  END.  /* if no qualifier */
  
  /* If there is a qualifier other than self then run SUPER to locate widget
     by datasource or instance name qualifiers */
  IF NUM-ENTRIES(pcWidget, '.':U) > 1 AND ENTRY(1, pcWidget, '.':U) <> 'Self':U THEN
    RUN SUPER (INPUT pcWidget, OUTPUT phWidget, OUTPUT phTarget).  

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-okObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE okObject Procedure 
PROCEDURE okObject :
/* -----------------------------------------------------------------------------
      Purpose: Passes an ok request to its container    
      Parameters:  <none>
      Notes:  The convention is that the standard routine always
              passes an cancel,ok or exit request to its CONTAINER-SOURCE. 
              The container that is actually able to initiate the ok 
              should override this and *not* call SUPER.    
----------------------------------------------------------------------------*/
  PUBLISH 'okObject':U FROM TARGET-PROCEDURE. /* NOTE: MUST go to Container-Source */
     
  RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-okToContinueProcedure) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE okToContinueProcedure Procedure 
PROCEDURE okToContinueProcedure :
/*------------------------------------------------------------------------------
  Purpose:  Check if the visual object have modified screen data or 
            if its data-source has uncommitted changes.
            If any of these conditions are true we issue Yes-No-Cancel 
            questions offering the user to answer 
              YES     to save/commit and continue the action.  TRUE
              NO      to cancel/undo and continue the action.  TRUE
              CANCEL  to NOT continue the action.              FALSE
 Parameters: pcAction (char) - Used to retrieve correct message. 
                     - exit   - Exit/close of application window.
                     - blank  - Continue  
                     - Commit - Commit (yes,no cancel unsaved changes)
                     - Undo   - Undo   (Don't offer save as an option)
                     - Ok     - No question (Save and commit) 
                     - Cancel - No question (cancel and undo)
    Notes:   -  confirmExit and confirmOpenQuery uses this function.
            This is copied from okToContinue function in datavis.p for use
            with Dynamics.  
------------------------------------------------------------------------------*/
   DEFINE INPUT  PARAMETER pcAction AS CHARACTER NO-UNDO.
   DEFINE OUTPUT PARAMETER plContinue AS LOGICAL NO-UNDO.
   
   DEFINE VARIABLE lModified       AS LOGICAL NO-UNDO.
   DEFINE VARIABLE lAnswer         AS LOGICAL NO-UNDO.   
   DEFINE VARIABLE hDataSource     AS HANDLE  NO-UNDO.
   DEFINE VARIABLE cRowObjectState AS CHAR    NO-UNDO.
   DEFINE VARIABLE cOperation      AS CHAR    NO-UNDO.
   DEFINE VARIABLE hGASource       AS HANDLE  NO-UNDO.
   DEFINE VARIABLE cNewRecord      AS CHARACTER NO-UNDO.
   
   cOperation = DYNAMIC-FUNCTION("messageNumber":U IN TARGET-PROCEDURE,
                                  IF pcAction = "Exit":U 
                                  THEN 21  /* Exit */
                                  ELSE IF pcAction = 'Commit':U 
                                  THEN 31  /* Commit */
                                  ELSE 22). /* Continue */

   {get GroupAssignSource hGaSource}.
   
   /* We trust that all checks will be performed against the GA Source */ 
   IF VALID-HANDLE(hGASource) THEN
   DO:
     plContinue = TRUE.
     RETURN.
   END.      

    /* If lModified ask the user what to do. */
   &SCOPED-DEFINE xp-assign
   {get DataModified lModified}
   {get NewRecord cNewRecord}.
   &UNDEFINE xp-assign
   IF lModified OR (cNewRecord <> 'NO':U AND pcAction <> 'Exit':U) THEN    
   DO:
     CASE pcAction:
       WHEN 'Ok':U     THEN lAnswer = YES.
       WHEN 'Cancel':U THEN lAnswer = NO.
       WHEN 'Undo':U  THEN
       DO:
         RUN showMessageProcedure IN TARGET-PROCEDURE 
               (INPUT '32,' + cOperation + ',OkCancel':U,
                OUTPUT lAnswer).
         /* Yes means don't save  
           (will still set plContinue to true at the end) */
         IF lAnswer THEN lAnswer = NO.
         /* Cancel is returned as NO when only 2 choices, so set it to ? */ 
         ELSE lAnswer = ?.
       END.
       OTHERWISE
         RUN showMessageProcedure IN TARGET-PROCEDURE 
               (INPUT '3,' + cOperation + ',YesNoCancel':U,
                OUTPUT lAnswer).

     END CASE.

     /* Yes to save changes */
     IF lAnswer THEN
     DO:
       RUN updateRecord IN TARGET-PROCEDURE.
       /* Do not continue if error */
       IF RETURN-VALUE = "ADM-ERROR":U THEN
       DO:
        plContinue = FALSE.
        RETURN.
       END.
          
     END. /* answer YES */

     /* No; Cancel modified data and continue */
     ELSE IF NOT lAnswer THEN
     DO:
       RUN cancelRecord IN TARGET-PROCEDURE. 
       /* Do not continue if error */
       IF RETURN-VALUE = "ADM-ERROR":U THEN
       DO:
         plContinue = FALSE.
         RETURN.
       END.
     END.

     ELSE /* lAnswer = ? */
     DO:
       plContinue = FALSE.
       RETURN. /* Do NOT continue if Cancel was pressed */    
     END.

   END. /* If lModified */
    /* else if new and exit just cancel silently to make sure the sdo is reset
      if it is in another window thjat is not closed */
   ELSE IF cNewRecord <> 'NO':U AND pcAction = 'EXIT':U THEN
     RUN cancelRecord IN TARGET-PROCEDURE.    

   /* Check if there are any uncommited changes in the data-source. 
      Avoid this for undo and commit of course... */
   IF NOT CAN-DO('Undo,Commit':U,pcAction) THEN
   DO:
       {get DataSource hDataSource}.
       IF VALID-HANDLE(hDataSource) THEN
       DO:
         /* use no-error in case of db query */ 
         cRowObjectState = DYNAMIC-FUNCTION("getRowObjectState":U IN hDataSource) 
                           NO-ERROR.
         IF cRowObjectState = "RowUpdated":U THEN
         DO:
           CASE pcAction:
             WHEN 'Ok':U     THEN lAnswer = YES.
             WHEN 'Cancel':U THEN lAnswer = NO.
             OTHERWISE 
               RUN showMessageProcedure IN TARGET-PROCEDURE (
                   INPUT '20,' + cOperation + ',YesNoCancel':U,
                   OUTPUT lAnswer).

           END CASE.

           IF lAnswer THEN
           DO:
             RUN commitTransaction IN hDataSource.
             /* Do not continue if error */
             IF RETURN-VALUE = "ADM-ERROR":U THEN 
             DO:
                plContinue = FALSE.
                RETURN.
             END.
               
           END. /* answer YES */
           /* if NO undo updates */
           ELSE IF NOT lAnswer THEN
             RUN undoTransaction IN hDataSource.    
           
           ELSE DO: /* lAnswer = ? so don't continue */
             plContinue = FALSE.
             RETURN.
           END.
         END. /* if cRowObjectstate = 'RowUpdated' */
       END. /* if valid-handle(hDataSource) */
   END. /* pcAction <> undo,commit*/
   
   plContinue = TRUE.                          
   RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-queryPosition) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE queryPosition Procedure 
PROCEDURE queryPosition :
/*------------------------------------------------------------------------------
  Purpose:     Captures 'state' events for the associated Query in the object's
               Data source. 
  Parameters:  pcState AS CHARACTER -- queryPosition State
               Possible values are:
               FirstRecord              - First record
               NotFirstOrLast           - Not the first or last record
               LastRecord               - Last record
               NoRecordAvailable        - No record
               OnlyRecord               - Only one
  Notes:       Any state that begins "NoRecordAvail" means disable; all others
               (FirstRecord, etc.) mean enable if we're in 'Save' mode 
               (SaveSource property is set to yes).
               Sets the RecordState property to 'NoRecordAvailable' when the
               state is equivalent to that for any other state, sets the value
               to 'RecordAvilable'.
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER pcState AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cRecordState     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lEnabled         AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lSaveSource      AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE hGASource        AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hContainerSource AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cContainerMode   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lInitialized     AS LOGICAL    NO-UNDO.
  
  /* initializeObject deals with this so ignore if not initilized to avoid 
     unnecessary and incorrect publishing of states */  
  {get ObjectInitialized lInitialized}.

  IF NOT lInitialized THEN
    RETURN.

  /* Save a [No]RecordAvailable flag for others to query. */
  cRecordState = IF pcState BEGINS 'NoRecordAvail':U 
                 THEN pcState
                 ELSE 'RecordAvailable':U.
  
  &SCOPED-DEFINE xp-assign
  {set RecordState cRecordState}
  {get FieldsEnabled lEnabled}.
  &UNDEFINE xp-assign
 
  IF pcState BEGINS 'NoRecordAvail':U THEN
  DO:
    IF lEnabled THEN
      RUN disableFields IN TARGET-PROCEDURE ('All':U).
  END.
  ELSE   /* one of the "record-available" states */
  IF NOT lEnabled THEN
  DO:  
     /* Check SaveSource (Tabelio-SOurce =save ) 
       (Always check this in GA Source) */
    {get GroupAssignSource hGASource}.
    IF VALID-HANDLE(hGASource) THEN
      {get SaveSource lSaveSource hGASource}.
    ELSE   
      {get SaveSource lSaveSource}.
    
    /* The SaveSource is used to check whether to enable at start up 
       The only way to NOT make this happen is with an tableio-target 
       with UPDATE mode (lSaveSource = false).  
       We check NOT (lSaveSource = false) to ensure that we run enableFields 
       also when unknown value and no tableio source. 
       THIS IS INTENTIONAL from 9.1B ! but has been overridden in viewer.i for 
       backwards compatibility ...  
       The updateMode toggles SaveSource on/off to ensure that we don't enable 
       if the user have explicitly set it to view. (This also includes the 
       inititial Containermode = 'view', which the container publishes from 
       its toolbars)  */
    IF NOT (lSaveSource = FALSE) THEN
      RUN updateMode IN TARGET-PROCEDURE ('modify':U).
  END.  /*  NOT lEnabled */
     /* re-send the event to other objects (such as an Update Panel) */
  PUBLISH 'queryPosition':U FROM TARGET-PROCEDURE (pcState).
  PUBLISH 'resetToolbar':U FROM TARGET-PROCEDURE.
  
  RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-resetRecord) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE resetRecord Procedure 
PROCEDURE resetRecord :
/*------------------------------------------------------------------------------
  Purpose:     General code for reset operation.
               Redisplays the original field values retrieved from the 
               SmartDataObject by invoking the colValues() function for the
               fields that are displayed.
  Parameters:  <none>
  Notes:       Invoked when the Reset button is pressed on an Update SmartPanel
               or a SmartToolbar.
               PUBLISHEs 'resetRecord' in case of GroupAssign.
               Sets DataModified property to ?.
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hUpdateTarget AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cRowIdent     AS CHARACTER  NO-UNDO.

  {get UpdateTarget hUpdateTarget}.
  IF VALID-HANDLE(hUpdateTarget) THEN
  DO:
    {get Rowident cRowIdent}.
    {fnarg resetRow cRowident hUpdateTarget}.
  END.
      
  /* In case GroupAssign. This is done before set DataModified to ensure
     that the GATargets are unmodified before updateActive is published
     up the ContainerSources  */
  PUBLISH 'resetRecord':U FROM TARGET-PROCEDURE.  

  /* Normally setting DataModified to 'no' also publishes updateComplete,
     but we want a Reset (to avoid browse rows becoming enabled
     when changing rows after a Reset), so pass special signal of unknown to 
     tell setDataModified to set the property off and pass 'reset' instead of
     'UpdateComplete'.  This will also trigger the dataObject to roll back 
     and delete a potential rowObjUpd record , so display afterwards */ 
  {set DataModified ?}.
  
  RUN displayRecord IN TARGET-PROCEDURE.
   
  RUN applyEntry IN TARGET-PROCEDURE (?).
  
  RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-showDataMessagesProcedure) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE showDataMessagesProcedure Procedure 
PROCEDURE showDataMessagesProcedure :
/*------------------------------------------------------------------------------
  Purpose:     New Astra 2 procedure to replace showDataMessages function and to
               use Astra 2 message handling routines.
               Returns the name of the field (if any) from the first
               error message, to allow the caller to use it to position the 
               cursor.
  Parameters:  <none>
  Notes:       Invokes fetchMessages() to retrieve all Data-related messages
               (normally database update-related error messages), and
               displays them in a alert-box of type error.
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
           * This will ensure that the messages are translated and correctly formatted.           */
          IF VALID-HANDLE(gshSessionManager) THEN
          DO:
              /* We are only interested in getting the summary message here. Ignore all other 
               * parameters.                                                                  */
              RUN afmessagep IN gshSessionManager ( INPUT  cMessage,
                                                    INPUT  "":U,
                                                    INPUT  "":U,
                                                   OUTPUT cSummary,
                                                   OUTPUT cIgnore,
                                                   OUTPUT cIgnore,
                                                   OUTPUT cIgnore,
                                                   OUTPUT lIgnore,
                                                   OUTPUT lIgnore  ).
              ASSIGN cText = cText
                           + (IF cField NE "":U THEN DYNAMIC-FUNCTION("messageNumber":U IN TARGET-PROCEDURE, 10) ELSE "":U)
                           + cField + "   ":U
                           + (IF cTable NE "":U THEN DYNAMIC-FUNCTION('messageNumber':U IN TARGET-PROCEDURE, 11) ELSE "":U)
                           + cTable
                           + (IF cField NE "":U OR cTable NE "":U THEN "~n":U ELSE "":U)
                           + "  ":U + cSummary + "~n":U.
          END. /* Use Dynamics error formatting routine */
          ELSE
              ASSIGN cText = cText + (IF cField NE "":U THEN
                  DYNAMIC-FUNCTION('messageNumber':U IN TARGET-PROCEDURE, 10) ELSE "":U)              
                 + cField + "   ":U +       
                 (IF cTable NE "":U THEN 
                 DYNAMIC-FUNCTION('messageNumber':U IN TARGET-PROCEDURE, 11) ELSE "":U) + cTable + 
                 (IF cField NE "":U OR cTable NE "":U THEN "~n":U ELSE "":U)
                     + "  ":U + ENTRY(1, cMessage, CHR(4)) + "~n":U.
          
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

&IF DEFINED(EXCLUDE-toolbar) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE toolbar Procedure 
PROCEDURE toolbar :
/*------------------------------------------------------------------------------
  Purpose:     Procedure to handle datavisual toolbar actions.
  Parameters:  pcValue AS CHARACTER - action
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pcValue          AS CHARACTER    NO-UNDO.

DEFINE VARIABLE cButton             AS CHARACTER    NO-UNDO.
DEFINE VARIABLE cDataSourceNames    AS CHARACTER    NO-UNDO.
DEFINE VARIABLE cFields             AS CHARACTER    NO-UNDO.
DEFINE VARIABLE cMaxRecords         AS CHARACTER    NO-UNDO.
DEFINE VARIABLE cMessage            AS CHARACTER    NO-UNDO.
DEFINE VARIABLE cProcedureType      AS CHARACTER    NO-UNDO.
DEFINE VARIABLE cStoreFieldName     AS CHARACTER    NO-UNDO.
DEFINE VARIABLE cUpdateTargetNames  AS CHARACTER    NO-UNDO.
DEFINE VARIABLE hBrowse             AS HANDLE       NO-UNDO.
DEFINE VARIABLE hColumn             AS HANDLE       NO-UNDO.
DEFINE VARIABLE hContainerSource    AS HANDLE       NO-UNDO.
DEFINE VARIABLE hDataSource         AS HANDLE       NO-UNDO.
DEFINE VARIABLE hFilterWindow       AS HANDLE       NO-UNDO.
DEFINE VARIABLE hNewObject          AS HANDLE       NO-UNDO.
DEFINE VARIABLE hSDODataSource      AS HANDLE       NO-UNDO.
DEFINE VARIABLE hWindowHandle       AS HANDLE       NO-UNDO.
DEFINE VARIABLE iBrowsePosition     AS INTEGER      NO-UNDO.
DEFINE VARIABLE iFieldsPosition     AS INTEGER      NO-UNDO.
DEFINE VARIABLE lSBO                AS LOGICAL    NO-UNDO.

  {get DataSource hDataSource}.

  /* If we are linked to an SBO then retrieve the SDO handle, try to get
     the only datasourcename first then the only updatetargetname.  Otherwise
     we can't invoke the functionality. */
  IF VALID-HANDLE(hDataSource) AND 
     {fnarg instanceOf 'SBO':U hDataSource} THEN
  DO:
    lSBO = TRUE.
    {get DataSourceNames cDataSourceNames}.
    IF NUM-ENTRIES(cDataSourceNames) = 1 THEN
      hSDODataSource = {fnarg dataObjectHandle cDataSourceNames hDataSource}.  
    ELSE DO:
      {get UpdateTargetNames cUpdateTargetNames}.
      IF NUM-ENTRIES(cUpdateTargetNames) = 1 THEN
        hSDODataSource = {fnarg dataObjectHandle cUpdateTargetNames hDataSource}.
    END.  /* else do */
  END.  /* if SBO */
  ELSE hSDODataSource = hDataSource.

  CASE pcValue:
    WHEN 'Comments':U THEN
    DO:
      IF VALID-HANDLE(hSDODataSource) THEN
      DO:
        {get ContainerSource hContainerSource}.
        {get ContainerHandle hWindowHandle hContainerSource}.        
      
        IF VALID-HANDLE(gshSessionManager) THEN
          RUN launchContainer IN gshSessionManager (                                                    
              INPUT "gsmcmobjcw",     /* pcObjectFileName       */
              INPUT "",               /* pcPhysicalName         */
              INPUT "",               /* pcLogicalName          */
              INPUT TRUE,             /* plOnceOnly             */
              INPUT "",               /* pcInstanceAttributes   */
              INPUT "",               /* pcChildDataKey         */
              INPUT STRING(hSDODataSource), /* pcRunAttribute         */
              INPUT "",               /* container mode         */
              INPUT hWindowHandle,    /* phParentWindow         */
              INPUT hContainerSource, /* phParentProcedure      */
              INPUT TARGET-PROCEDURE, /* phObjectProcedure      */
              OUTPUT hNewObject,      /* phProcedureHandle      */
              OUTPUT cProcedureType   /* pcProcedureType        */       
          ).       
      END.  /* if valid data source */

    END.  /* when comments */
    WHEN 'Export':U THEN
    DO:
      IF NOT lSBO THEN  /* export not supported for SBOs */
      DO:
        {get DisplayedFields cFields}.   

        IF VALID-HANDLE(hSDODataSource) THEN
        DO:
          /* If this is a browser, we already have all the browser field names,
             but we may have them in the wrong order.  
             The user may have moved columns, so make sure they're ordered 
             correctly. */
          hBrowse = DYNAMIC-FUNCTION('getBrowseHandle':U IN TARGET-PROCEDURE) NO-ERROR.   
          IF VALID-HANDLE(hBrowse) THEN
          DO-BLK:
          DO iBrowsePosition = 1 TO hBrowse:NUM-COLUMNS:
              ASSIGN 
                hColumn         = hBrowse:GET-BROWSE-COLUMN(iBrowsePosition)
                iFieldsPosition = LOOKUP(hColumn:BUFFER-FIELD:NAME, cFields) NO-ERROR.

              IF ERROR-STATUS:ERROR 
              OR iFieldsPosition = 0 
              OR iFieldsPosition = ? THEN 
                NEXT do-blk.
        
              /* If the field is out of place, swap it with the field currently in its place */
              IF iBrowsePosition <> iFieldsPosition THEN
                ASSIGN 
                  cStoreFieldName                 = ENTRY(iBrowsePosition, cFields)
                  ENTRY(iBrowsePosition, cFields) = hColumn:BUFFER-FIELD:NAME
                  ENTRY(iFieldsPosition, cFields) = cStoreFieldName.
          END.  /* DO-BLK */
          RUN transferToExcel IN hSDODataSource (INPUT cFields, 
                                                 INPUT NO, 
                                                 INPUT YES, 
                                                 INPUT ?).
        END.  /* if valid data source */
      END.  /* if datasource not SBO */
    END.  /* when export */
    WHEN 'Preview':U THEN
    DO:
      IF NOT lSBO THEN  /* preview not supported for SBOs */
      DO:
        {get DisplayedFields cFields}.            
        RUN printToCrystal IN hSDODataSource (INPUT cFields, 
                                              INPUT NO, 
                                              INPUT ?).
      END.  /* if datasource not SBO */
    END.  /* when preview */

    WHEN 'Filter':U OR WHEN 'Find':U THEN 
    DO:
      {get ContainerSource hContainerSource}.
      {get ContainerHandle hWindowHandle hContainerSource}.              

      IF VALID-HANDLE(hDataSource) THEN DO:
          IF VALID-HANDLE(gshSessionManager) THEN
            RUN launchContainer IN gshSessionManager (                                                    
                INPUT '',                       /* pcObjectFileName     */
                INPUT 'af/sup2/afsdofiltw.w',   /* pcPhysicalName       */
                INPUT '',                       /* pcLogicalName        */
                INPUT TRUE,                     /* plOnceOnly           */
                INPUT '',                       /* pcInstanceAttributes */
                INPUT '',                       /* pcChildDataKey       */
                INPUT '',                       /* pcRunAttribute       */
                INPUT '',                       /* container mode    */
                INPUT hWindowHandle,            /* phParentWindow       */
                INPUT hContainerSource,         /* phParentProcedure    */
                INPUT ?,                        /* phObjectProcedure    */
                OUTPUT hFilterWindow,           /* phProcedureHandle    */
                OUTPUT cProcedureType           /* pcProcedureType      */       
            ).         
              
          IF VALID-HANDLE(hFilterWindow) THEN DO:        
              RUN initializeObject IN hFilterWindow.
              RUN setDataSourceHandle IN hFilterWindow (pcValue, hDataSource, TARGET-PROCEDURE).
          END.  /* if valid filter window */
      END.  /* if valid data source */
    END.  /* when filter or find */

    WHEN 'Audit':U THEN
    DO:
      IF VALID-HANDLE(hSDODataSource) THEN
      DO:
        {get ContainerSource hContainerSource}.
        {get ContainerHandle hWindowHandle hContainerSource}.        

        IF VALID-HANDLE(gshSessionManager) THEN
          RUN launchContainer IN gshSessionManager (                                                    
              INPUT 'gstadobjcw',     /* pcObjectFileName       */
              INPUT '',               /* pcPhysicalName         */
              INPUT '',               /* pcLogicalName          */
              INPUT TRUE,             /* plOnceOnly             */
              INPUT '',               /* pcInstanceAttributes   */
              INPUT '',               /* pcChildDataKey         */
              INPUT STRING(hSDODataSource), /* pcRunAttribute         */
              INPUT '',               /* container mode         */
              INPUT hWindowHandle,    /* phParentWindow         */
              INPUT hContainerSource, /* phParentProcedure      */
              INPUT TARGET-PROCEDURE, /* phObjectProcedure      */
              OUTPUT hNewObject,      /* phProcedureHandle      */
              OUTPUT cProcedureType   /* pcProcedureType        */       
          ).       
      END.  /* if valid data source */
    END.  /* when audit */

  END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-updateMode) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE updateMode Procedure 
PROCEDURE updateMode :
/*------------------------------------------------------------------------------
  Purpose:     Serves to enable/disable fields when the data visualization 
               object is linked to an Update SmartPanel for which the type is
               'Update'.
  Parameters:  pcMode AS CHARACTER -- update mode
               Possible values are:
               updateBegin      - Signals that the user has pressed
                                  the update button. This is a modal update that
                                  only cancel or save can end with UpdateEnd.  
               updateEnd        - Signals that the user has pressed the save
                                  or cancel button 
               view             - Signals that the user has pressed the view
                                  button.                    
               Modify           - Signals that the user has pressed the modify
                                  button. This is less modal than Update and
                                  and is not included in canNavigate                     
  Notes:       'updateBegin' signals that the Update button has been pressed 
               in an Update SmartPanel in Update mode. Enable fields for data 
               entry. 'updateEnd' signals that Save has completed; disable 
               fields. 'update-begin' was a state msg in V8. updateEnd 
               corresponds to the save button dispatching disable-fields in V8.
            -   
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pcMode AS CHARACTER NO-UNDO.

  DEFINE VARIABLE cObjectMode        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cLogicalObjectName AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cRunAttribute      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSecuredTokens     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hTableIOSource     AS HANDLE     NO-UNDO.
  DEFINE VARIABLE lSaveSource        AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE hGASource          AS HANDLE     NO-UNDO. 
  DEFINE VARIABLE cTableioType       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hContainer         AS HANDLE     NO-UNDO.

  &SCOPED-DEFINE xp-assign
  {get TableIOSource hTableIOSource}
  {get SaveSource lSaveSource}. 
  &UNDEFINE xp-assign
  
  /* We change SaveSource to keep track of explicit 'view' and 'modify' requests to be able 
     to avoid the automatic enabling in queryPosition when a record becomes 
     available if the user explicitly pressed view previously. (This also 
     includes the initial ContainerMode 'view' setting, which the dynamic 
     container publishes from its toolbars). 
     queryPosition used to avoid enabling when ContainerMode = view, but the
     ContainerMode now reflects the 'Main' viewer's mode, so it was never enabled 
     again if it was set in view mode automatically when no records existed 
     (i.e due to filter criteria) */       
  IF SOURCE-PROCEDURE = hTableioSource THEN
  DO:
    IF pcMode = 'view':U THEN
      {set SaveSource NO}.
    ELSE IF lSaveSource = NO AND pcMode = 'Modify':U THEN
    DO:
      {get TableIOType cTableioType hTableIOSource}.
      IF cTableioType = 'Save':U THEN
        {set SaveSource YES}.
    END.
  END.

  /* For modes Modify, Enable and UpdateEnd, we check if security has been set for 'Modify'. 
     If it has, we're going into view mode, end of story. :)  */

  IF VALID-HANDLE(gshSecurityManager)
  AND CAN-DO("Modify,Enable,UpdateEnd":U, pcMode) THEN 
  DO:
    {get containerSource hContainer}.
    IF VALID-HANDLE(hContainer) THEN 
    DO:
      &SCOPED-DEFINE xp-assign
      {get LogicalObjectName cLogicalObjectName hContainer}
      {get runAttribute cRunAttribute hContainer}.
      &UNDEFINE xp-assign
        
      RUN tokenSecurityGet IN gshSecurityManager (INPUT hContainer,
                                                  INPUT cLogicalObjectName,
                                                  INPUT cRunAttribute,
                                                  OUTPUT cSecuredTokens).
      ASSIGN cSecuredTokens = REPLACE(cSecuredTokens, "&":U, "":U).
    END.

    /* We're going to set the mode to view and make sure the TableIO type is set to update */
    IF LOOKUP("Modify":U, cSecuredTokens) > 0 THEN 
    DO:
      ASSIGN pcMode = "view":U.
      {set SaveSource NO}.

      IF VALID-HANDLE(hTableIOSource) THEN 
      DO:
        {set TableIOType 'Update' hTableIOSource}.
      END.
    END.
  END.

  /* Set the mode */
  CASE pcMode:
    WHEN 'enable':U OR WHEN 'modify':U THEN  
    DO:
      {set ObjectMode 'Modify':U}.
      RUN enableFields IN TARGET-PROCEDURE.
      PUBLISH 'resetTableio':U FROM TARGET-PROCEDURE.
    END.
    WHEN 'view':U THEN    
    DO:
      {set ObjectMode 'View':U}. 
      RUN disableFields IN TARGET-PROCEDURE ("All":U).
      PUBLISH 'resetTableio':U FROM TARGET-PROCEDURE.
    END.    
    WHEN 'updateBegin':U THEN
    DO:
      RUN enableFields IN TARGET-PROCEDURE.
      {set ObjectMode 'Update':U}.
      PUBLISH 'updateState':U FROM TARGET-PROCEDURE ('update':U).
    END.
    WHEN 'updateEnd':U THEN
    DO:
      /* only disable if SaveSource=no (TablioType=Update) */
      IF lSaveSource = NO THEN
      DO:
        {get GroupAssignSource hGaSource}.
        /* GroupAssignTargets does not have correct SaveSource and 
           are also disabled and enabled from the source */ 
        IF NOT VALID-HANDLE(hGaSource) THEN  
        DO:
          {set ObjectMode 'View':U}. 
          RUN disableFields IN TARGET-PROCEDURE ('All':U).  
        END.
      END.
    END.
  END CASE.
  
  RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-updateRecord) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE updateRecord Procedure 
PROCEDURE updateRecord :
/*------------------------------------------------------------------------------
  Purpose:     General code to start the save operation.
               Procedure to receive a "Save" message from a TableIO source 
               and send the changed values back to the SmartDataObject.
  Parameters:  <none>
  Notes:       Invoked when the Save button is pressed on an Update SmartPanel
               or a SmartToolbar.
               PUBLISHes 'collectChanges' to gather changes made eventually
               in any GroupAssign target.
               Invokes submitRow() in the Data source that actually applies the
               changes to the database.
               If any validations failed or errors occured during the save 
               operation for a field, it brings up the page where the field
               is, if necessary and reposition to it.
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cValues          AS CHARACTER NO-UNDO INIT "":U.
  DEFINE VARIABLE cChangeInfo      AS CHARACTER NO-UNDO INIT "":U.
  DEFINE VARIABLE hFrameField      AS HANDLE    NO-UNDO.
  DEFINE VARIABLE iCnt             AS INTEGER   NO-UNDO.
  DEFINE VARIABLE lSuccess         AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE hUpdateTarget    AS HANDLE    NO-UNDO.
  DEFINE VARIABLE cTarget          AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cErrorField      AS CHARACTER NO-UNDO.
  DEFINE VARIABLE iErrorField      AS INTEGER   NO-UNDO.
  DEFINE VARIABLE iFields          AS INTEGER   NO-UNDO INIT 0.
  DEFINE VARIABLE iPos             AS INTEGER   NO-UNDO.
  DEFINE VARIABLE iCurrentPage     AS INTEGER   NO-UNDO.
  DEFINE VARIABLE iErrorPage       AS INTEGER   NO-UNDO.
  DEFINE VARIABLE hErrorObject     AS HANDLE    NO-UNDO.
  DEFINE VARIABLE iEntries         AS INTEGER   NO-UNDO.
  DEFINE VARIABLE cRowIdent        AS CHARACTER NO-UNDO.
  DEFINE VARIABLE hSource          AS HANDLE    NO-UNDO.
  DEFINE VARIABLE cNoValidFlds     AS CHAR      NO-UNDO.
  DEFINE VARIABLE cNewRecord       AS CHARACTER NO-UNDO.
  DEFINE VARIABLE lModified        AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE cDummy           AS CHARACTER NO-UNDO.
  DEFINE VARIABLE lFound           AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE lSaveSource      AS LOGICAL   NO-UNDO.

  &SCOPED-DEFINE xp-assign
  {get RowIdent cRowIdent}
  {get UpdateTarget cTarget}.
  &UNDEFINE xp-assign
  hUpdateTarget = WIDGET-HANDLE(cTarget).
  IF VALID-HANDLE(hUpdateTarget) THEN
  DO:
    lFound = {fnarg repositionRowObject cRowIdent hUpdateTarget}.
    IF NOT (lFound = TRUE) THEN
       RETURN ERROR RETURN-VALUE.
  END.
    /* Validate the fields */
  RUN validateFields IN TARGET-PROCEDURE (INPUT-OUTPUT cNoValidFlds).

  /* If all the fields are valid go ahead and submit changes */
  IF cNoValidFlds = "":U THEN
  DO:
       /* First get any changed fields from the current object. */
    RUN collectChanges IN TARGET-PROCEDURE (INPUT-OUTPUT cValues,
      INPUT-OUTPUT cChangeInfo).
    /* If there are GroupAssign-Targets for this object, get their changed 
       values and append them to this object's. Using an INPUT-OUTPUT parameter 
       on the PUBLISH allows each target to add its values to the list. */
    PUBLISH 'collectChanges':U FROM TARGET-PROCEDURE (INPUT-OUTPUT cValues,
      INPUT-OUTPUT cChangeInfo).
    {get NewRecord cNewRecord}.  /* Log Add/Copy flag in case of error */
  
    /* DataAvailable checks this to avoid redisplay on add, so set it to 'no'
       in case it was 'add' or' copy' before we call the datasource that 
       publishes DataAvailable  */
    {set NewRecord 'No':U}.   /* Note: this is character 'no', not logical*/  
    IF VALID-HANDLE(hUpdateTarget) THEN
    DO:
      ghTargetProcedure = TARGET-PROCEDURE.
      lSuccess = dynamic-function ("submitRow":U IN hUpdateTarget,
                                    cRowIdent, cValues).
      ghTargetProcedure = ?.
    END.
    ELSE DO:
       RUN addMessage IN TARGET-PROCEDURE
       ({fnarg messageNumber 65}, ?,?).
      lSuccess = no.
    END.   /* END ELSE DO */
     /* If there are no errors set flags */
    IF lSuccess THEN
    DO: 
      /* Post 9.1D the disabling of the object in Update mode is managed
         by the object and not by a publish from the toolbar's updateState */   
      {get SaveSource lSaveSource}.
      IF lSaveSource = FALSE THEN
        RUN updateMode IN TARGET-PROCEDURE ('updateEnd':U).

      /* Ensure that GroupAssign-targets Modified flag is set to FALSE 
         BEFORE setDataModified as it publishes UpdateActive up the container 
         link, and each container checks all targets before republishing  */
      DYNAMIC-FUNCTION('assignLinkProperty':U IN TARGET-PROCEDURE,
                       'GroupAssign-Target':U, 
                       'DataModified':U, 
                       'no':U).

      /* setDatamodifed currently publishes 'updateState' only if the modified 
         property was changed, so check if we need to publish directly */
      {get DataModified lModified}.      
      IF NOT lModified THEN
        PUBLISH 'updateState':U FROM TARGET-PROCEDURE ('updateComplete':U).
      ELSE 
        {set DataModified no}.   /* This will also publish UpdateComplete. */
     
    END.  /* END DO if there are no errors */
    ELSE DO: /* Display error messages */
      /*
      cErrorField = {fn showDataMessages}.  /* Get the first field in error. */
      */
      {set NewRecord cNewRecord}.  /* Keep Add/Copy as it was before submit*/
      /* Make sure the toolbar also gets it (SBOs may publish while newRecored is NO) */
      IF cNewRecord <> 'NO':U THEN
      DO:
        PUBLISH 'resetTableio':U FROM TARGET-PROCEDURE.
        PUBLISH 'updateState':U FROM TARGET-PROCEDURE ('update':U).
      END.
     
      IF lSuccess <> ? THEN
        RUN showDataMessagesProcedure IN TARGET-PROCEDURE (OUTPUT cErrorField) .
/*        cErrorField = {fn showDataMessages}.  */
      ELSE 
        RETURN. /* issue with lSuccess = ? and no errors with appserver partition maintenance */

      IF cErrorField = "":U OR cErrorField = ? THEN 
         RETURN "ADM-ERROR":U.
      
      iErrorField = (LOOKUP(cErrorField, cValues, CHR(1)) + 1) / 2.
      ASSIGN iEntries = NUM-ENTRIES(cChangeInfo)
             iPos = 1.     
      
      /* Add up the number of changed fields in each group of three entries,
         until you get to the group that changed the first field in error. */
      DO iPos = 1 TO iEntries BY 3 WHILE iFields < iErrorField:
        iFields = iFields + INTEGER(ENTRY(iPos, cChangeInfo)).
      END.   /* END DO iPos */

      /* Deal with case where error field is not in list of changed fields, or 
         there are no changed fields (could happen in add/copy) */
      IF iPos > 0 AND NUM-ENTRIES(cChangeInfo) >= 3 THEN 
        ASSIGN                    
          iPos     = iPos - 3 /* DO has incremented iPos, move to prev group */ 
          iErrorPage   = INT(ENTRY(iPos + 1, cChangeInfo))
          hErrorObject = WIDGET-HANDLE(ENTRY(iPos + 2, cChangeInfo)).
      ELSE                    
        ASSIGN                
          iPos = 1            
          iErrorPage = 0      
          hErrorObject = ?.

    END. /* else (If not lSuccess) */
  END. /* NoValifFlds = '' */
  
  /* if NoValidFlds <> '' find fieldname, page and object */ 
  ELSE DO:
      /* add the update cancelled message */
    RUN addMessage IN TARGET-PROCEDURE({fnarg messageNumber 15},?,?).
    
    /*{fn showDataMessages}.    */
    RUN showDataMessagesProcedure IN TARGET-PROCEDURE (OUTPUT cDummy).

    ASSIGN 
      iErrorField  = 1 /* we just pick the first field in the error list*/
      cErrorfield  = ENTRY(iErrorField,cNoValidFlds) 
      iErrorPage   = INT(ENTRY(iErrorField + 1,cNoValidFlds))
      hErrorObject = WIDGET-HANDLE(ENTRY(iErrorField + 2,cNoValidFlds)) NO-ERROR.
    
    IF ERROR-STATUS:ERROR THEN
       RETURN "ADM-ERROR":U.
  END. /* Validate failed */

  IF VALID-HANDLE(hErrorObject) OR iErrorPage > 0 THEN
  DO:
    /* If there's a GroupAssign, then the field in error may be in a different
       object on a different page, select it and then apply entry to the field. 
     */
    ASSIGN 
      iCurrentPage = INT(dynamic-function('linkProperty':U IN TARGET-PROCEDURE, 
                     'Container-Source':U, 
                     'CurrentPage':U)).
      /**If validation error or submit error set focus to the error field */
    IF iErrorPage NE 0 AND iErrorPage NE iCurrentPage THEN
    DO:
      {get ContainerSource hSource}.
      RUN selectPage IN hSource (iErrorPage).
    END.   /* END DO iErrorPage */
    
    RUN applyEntry IN hErrorObject (cErrorField) NO-ERROR.

    RETURN "ADM-ERROR":U. 
  END. /* if cErrorfield <> '' */
  RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-updateState) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE updateState Procedure 
PROCEDURE updateState :
/*------------------------------------------------------------------------------
  Purpose:     Receives the updateState event from DataSources (or GATargets)
  Parameters:  pcState AS CHARACTER -- update state               
               Possible values are:
               
               update           - Signals that update is in progress
               updateComplete   - Signals that update is terminated
               
      Notes: The updateState has a somewhat ambivalent behavior, since it is 
             bidirectional, i.e. a visual DataTarget publishes 'updateState', 
             which is subscribed by tableioSource and DataSource, but it also
             subribes to this event from its DataSource. This means that an 
             'updateState' received form its DataSource actually may originate
             from the object.  The republishing is conditional so this never 
             caused an endless loop, and the main issue was that the toolbar 
             would receive the event twice on this occasion.                             
            
            Since some of the attempts to clean this up has had some undesired 
            effects, the history is kept here for reference: 
            -- Group Assign Targets ----------------------  
             - 9.1B GaTargets caused the SDO to receive the event three times. 
               1. Published from GaSource (addRecord, copyRecord ..) 
               2. Published from the same method in GaTarget
               3. Published from the GASource when received from GaTarget.
             - 9.1C always goes through setDataModified, which only 
               publishes when a change has happened. 
             
             9.1B setdataModified, however did run 'updateState' in GaSource 
             probably to avoid this.
             
             In 9.1C this was changed back to a publish (although we might
             as well have just setDataModifed directly in the GAsource),
             but we certainly did not want to have the run, because we need to 
             identify the GaTargets as explained above, so we can treat their
             events as outbound events and treat the events from dataSources 
             as inbound pass-thru events.  
            -- 'Ricochet' history ----------------------------------------------------
            How a 'ricochet' was avoided in 9.1B :                    
             - The browser always subscribed this from DataSource to be able 
               to disable/enable, but it never republished.  
               It did actually get 'ricochets' when publishing, but avoided 
               problems by a RETURN when modifed or New in browser.p's override. 
               This logic is still there, but probably not required.   
             - The viewer never subscribed to this from DataSource until a late
               9.1B patch.                          
             How this was dealt with in 9.1C (FCS).
             - Filter out the events received from GATargets and always 
               pass them through setDataModifed. 
             - Don't republish otherwise, but publish 'resetTablio', which 
               only goes to the tableioSource.
             - In addition data.p unsubscribed updateState from objects that 
               were DataTargets AND had 'updateState' as DataSourceEvents before
               it republished and subscribed it back after to completely avoid 
               the that the event got published back to us.
             Problems:  
               The removal of the 'ricochet' revealed that there were dependencies
               on the second updateState, as the toolbar state logic depended on
               receiving the event AFTER the visual object's DataSource.
               These timing dependencies were removed and in all cases the 
               result were much 'healthier' code with better encapsulation.
               However, at least one customer were actually relying on 
               updateState being fired back to the originating object.      
             Current solution (9.1C patch) 
               The main change was that the 'ricochet' was reintroduced by 
               getting rid of the unsubscribe/unsubscribe, which actually was a
               relief... instead the DataSource sets a new property 
               CurrentUpdateSource to the handle of the originating object. 
               This is checked here to avoid resetTablieo if we are the 
               originator. The browser's override does the same check and 
               returns immediately.  
Note date: 2002/02/11                           
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pcState AS CHARACTER NO-UNDO.
  
  DEFINE VARIABLE hCurrSource    AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hDataSource    AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cGATarget      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lModified      AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE hRequester     AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hToolbarSource AS HANDLE     NO-UNDO.
  
  IF pcState NE 'Update':U AND pcState NE 'UpdateComplete':U THEN
    RETURN "ADM-ERROR":U.

  {get GroupAssignTarget cGaTarget}.
  /* If this is this an internal change of data, publish to everyone */
  IF CAN-DO(cGaTarget,STRING(SOURCE-PROCEDURE)) THEN
  DO:
    lModified = (pcState = 'Update':U).
    {set DataModified lModified}.
  END.

  ELSE DO:
    /* Received from a dataSource just tell the toolbar, unless we are 
       the publisher's currentUpdateSource, which means that we actually are 
       the original publisher of this event, which then have or will reach the
       toolbar */    
    {get DataSource hDataSource}.

    /* SBOs does run  so SOURCE is incorrect, so unless we know the 
       SOURCE is the dataSource check the special trick property   */  
    IF hDataSource <> SOURCE-PROCEDURE THEN
      hRequester = {fn getTargetProcedure SOURCE-PROCEDURE} NO-ERROR.
    ELSE 
      hRequester = SOURCE-PROCEDURE.
    
    {get CurrentUpdateSource hCurrSource hRequester} NO-ERROR.
    
    IF TARGET-PROCEDURE <> hCurrSource THEN
      PUBLISH 'resetTableio':U FROM TARGET-PROCEDURE.   
  END.

  /* Tableio is only reset for the tablio source linked to this object. 
     Toolbar source needs to be reset when state is updated from 
     objects launched from the toolbar source.   */
  PUBLISH 'resetToolbar':U FROM TARGET-PROCEDURE.     
  RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-updateTitle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE updateTitle Procedure 
PROCEDURE updateTitle :
/*------------------------------------------------------------------------------
  Purpose:     Update window title at end of update - to get rid of - new
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE VARIABLE hSource             AS HANDLE       NO-UNDO.
  DEFINE VARIABLE lDataLinksEnabled   AS LOGICAL      NO-UNDO.
  DEFINE VARIABLE cWindowTitleField   AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE cWindowTitleColumn  AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE cWindowTitleValue   AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE cObjectName         AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE cWindowName         AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE cWindowTitle        AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE hContainerSource    AS HANDLE       NO-UNDO.
  DEFINE VARIABLE hContainerHandle    AS HANDLE       NO-UNDO.
  DEFINE VARIABLE cContainerMode      AS CHARACTER    NO-UNDO.

  &SCOPED-DEFINE xp-assign
  {get DataSource hSource}
  /* get window title if required */
  {get WindowTitleField cWindowTitleField}.
  &UNDEFINE xp-assign

  IF VALID-HANDLE(hSource) AND cWindowTitleField <> "" THEN
  DO:    
    cWindowTitleColumn = DYNAMIC-FUNCTION ("colValues":U IN hSource, cWindowTitleField).
    
    IF NUM-ENTRIES(cWindowTitleColumn, CHR(1)) = 2 THEN
    DO:
        cWindowTitleValue = ENTRY(2,cWindowTitleColumn, CHR(1)).
        IF cWindowTitleValue <> ? THEN
        DO:
          {get ContainerSource hContainerSource}.
          IF VALID-HANDLE(hContainerSource) THEN
          DO:
            &SCOPED-DEFINE xp-assign
            {get LogicalObjectName cObjectName hContainerSource}
            {get WindowName cWindowName hContainerSource}
            {get ContainerHandle hContainerHandle hContainerSource}
            {get ContainerMode cContainerMode hContainerSource}
            {set windowTitleViewer TARGET-PROCEDURE hContainerSource}.
            &UNDEFINE xp-assign
          END.
          
          IF INDEX(cWindowName," - ") = 0 
              THEN cWindowTitle = cWindowName.
              ELSE cWIndowTitle = SUBSTRING(cWindowName,1,INDEX(cWIndowName," - ") - 1).
          cWindowTitle = cWindowTitle + " - " + IF cContainerMode = "add":u OR cContainerMode = "copy":u THEN
                "New" ELSE cWindowTitleValue.

          IF VALID-HANDLE(hContainerSource) THEN
          DO:
              /* Try to run the manual override. If it fails then we use the setWindowName function. */
              RUN updateTitleOverride IN hContainerSource (INPUT cWindowTitle) NO-ERROR.
              IF ERROR-STATUS:ERROR THEN
                  {set WindowName cWindowTitle hContainerSource}.
          END.  /* valid container */
        END.
    END.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-validateFields) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateFields Procedure 
PROCEDURE validateFields :
/*------------------------------------------------------------------------------
  Purpose:     Validate field of a visual object.     
  Parameters:  INPUT-OUTPUT pcNotValidFields (char)
                - Blank if valid data
                - If not valid data comma-separated list of the fieldname, 
                  Objecthandle and page separated with comma. 
                  updateRecord will use this to set focus  
  Notes:     - Called from updateRecord to ensure that data can be saved.
               Field validation on leave cannot be trusted because save can be 
               triggered by accellerators and no-focus buttons (toolbar).
             - currently only one error is returned, because validate() 
               on hidden objects does not give any message we we return 
               immediately for any error. (We could probably find the validation 
               message in the visual RowObject handle? )
                   
             - The validation will always check unmodifed fields, which is 
               useful for add/copy, but maybe not so useful otherwise as 
               those fields will not be saved anyway.  
------------------------------------------------------------------------------*/
  DEFINE INPUT-OUTPUT PARAMETER pcNotValidFields AS CHAR NO-UNDO.
  
  DEFINE VARIABLE lOk         AS LOG     NO-UNDO.
  DEFINE VARIABLE iPage       AS INTEGER NO-UNDO.
  DEFINE VARIABLE hContainer  AS HANDLE  NO-UNDO.
  DEFINE VARIABLE hBrowse     AS HANDLE  NO-UNDO.
  DEFINE VARIABLE hDataSource AS HANDLE  NO-UNDO.
  DEFINE VARIABLE hFld        AS HANDLE  NO-UNDO.
  DEFINE VARIABLE cMsg        AS CHAR    NO-UNDO.
  DEFINE VARIABLE cType       AS CHAR    NO-UNDO.
  DEFINE VARIABLE cTargets    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE i           AS INTEGER    NO-UNDO.
  DEFINE VARIABLE hField      AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cField      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cNewRecord  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lModified   AS LOGICAL    NO-UNDO.

  /* Currently we handle only ONE error, so return if other subscribers 
     have already found non-valid data. */
  IF pcNotValidFields <> "":U THEN 
     RETURN.

  {get ContainerHandle hContainer}.
  
  IF VALID-HANDLE(hContainer) THEN
  DO:
    /* Check if this is a browse. For now at least we don't bother about 
       overriding this for this simple check) */ 
    hBrowse = DYNAMIC-FUNCTION("getBrowseHandle":U IN TARGET-PROCEDURE) NO-ERROR.   
    IF VALID-HANDLE(hBrowse) THEN
       hFld = hBrowse:FIRST-COLUMN.
    ELSE
      ASSIGN 
        hFld = hContainer:FIRST-CHILD /* skip the fieldgroup */
        hFld = hFld:FIRST-CHILD. 
    
    DO WHILE VALID-HANDLE(hFld):
      IF CAN-QUERY(hFld,"validate":U) THEN
      DO:
        lok = hFld:VALIDATE("ENABLED-FIELDS":U) NO-ERROR.
        IF NOT lOk THEN 
        DO:
          {get ObjectPage iPage}.
           pcNotValidFields = 
              pcNotValidFields 
              + (IF pcNotValidFields = "":U THEN "":U ELSE ",":U) 
              /* used to compare with focus so we must also return browsename*/
              + hFld:NAME + ",":U 
              + STRING(iPage) + ",":U 
              + STRING(TARGET-PROCEDURE).
          
          /* Hidden fields does not validate and subsequently the frame compiled
             message is not available in the error-status.              
             The validation is inherited from the SDO so we must retrieve 
             the validation message from there.  
             We check for a local version first, mostly for db based queries,
             (but thids allows other objects to have the messages as locales)*/

          cMsg = {fnarg columnValMsg hFld:NAME} NO-ERROR.
          IF cMsg = ? THEN
          DO:
            {get DataSource hDataSource}.
            /* If the fieldname is qualified with an SDO ObjectName
               (not just RowObject), and our Data-Source is an SBO,
               then pass the qualification on to it. */
             {get ContainerType cType hDataSource}.
             cMsg = DYNAMIC-FUNCTION("columnValMsg":U IN hDataSource,
                    IF cType = 'VIRTUAL':U AND hFld:TABLE NE 'RowObject':U THEN 
                        hFld:TABLE + ".":U + hFld:NAME
                    ELSE hFld:NAME). 
          END. /* if cMsg */
          RUN AddMessage IN TARGET-PROCEDURE (cMsg,hFld:NAME,?).           
        END. /* not ok */
      END.  /* can-query(hfl,validate)*/
      
      IF VALID-HANDLE(hBrowse) THEN
        hFld = Hfld:NEXT-COLUMN.
      ELSE
        hFld = Hfld:NEXT-SIBLING.
    END. /* do while valid hfld */
    {get NewRecord cNewRecord}.

    /* Validate SmartDataFields */
    {get ContainerTarget cTargets} NO-ERROR.
    DO i = 1 TO NUM-ENTRIES(cTargets):
      ASSIGN
        hField    = WIDGET-HANDLE(ENTRY(i,cTargets))
        lModified = NO
        lOk       = TRUE.

      IF cNewRecord = 'NO':U THEN
        {get DataModified lModified hField} NO-ERROR.
      
      IF cNewRecord <> 'NO':U OR lModified THEN
        lOk  = {fn validateField hField} NO-ERROR.

      IF NOT lok THEN
      DO:
        {get ObjectPage iPage}.
         cField = {fn getFieldName hField}.
         
         pcNotValidFields = 
             pcNotValidFields 
              + (IF pcNotValidFields = "":U THEN "":U ELSE ",":U) 
              /* used to compare with focus so we must also return browsename*/
              + ",":U 
              + STRING(iPage) + ",":U 
              + STRING(hField).

        cMsg   = {fn validateMessage hField}.
        RUN AddMessage IN TARGET-PROCEDURE (cMsg,cField,?).           

      END.
    END.
  END.
  
  /* Check GroupAssignTargets  */ 
  PUBLISH "validateFields":U FROM TARGET-PROCEDURE 
                                 (INPUT-OUTPUT pcNotValidFields).

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-valueChanged) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE valueChanged Procedure 
PROCEDURE valueChanged :
/*------------------------------------------------------------------------------
     Purpose:  Value-changed of frame anywhere event     
  Parameters:  
       Notes: Static objects can reach this also by applying U10 event to run it.     
-----------------------------------------------------------------------------*/
  IF NOT VALID-HANDLE(FOCUS) THEN 
    RETURN.    
   
  RUN fieldModified IN TARGET-PROCEDURE(FOCUS).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-canLaunchDetailWindow) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION canLaunchDetailWindow Procedure 
FUNCTION canLaunchDetailWindow RETURNS LOGICAL
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
DEFINE VARIABLE cFolderWindow AS CHARACTER  NO-UNDO.

  {get FolderWindowToLaunch cFolderWindow} NO-ERROR.

  RETURN cFolderWindow > '':U.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-canNavigate) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION canNavigate Procedure 
FUNCTION canNavigate RETURNS LOGICAL
  (  ) :
/*------------------------------------------------------------------------------
  Purpose: Check if the object can allow a navigation 
    Notes: An object cannot navigate if there are uncommited or unsaved
           changes in the updateTarget or unsaved changes in any of the 
           Datatargets of the updatetarget. 
         - The check is used as rule for enabling of toolbar actions. This 
           includes delete and add/copy as navigation is an implicit result 
           of these actions on the client. 
         - See details in the data.p canNavigate        
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hDataObject   AS HANDLE     NO-UNDO.
  DEFINE VARIABLE lNavigate     AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lPending      AS LOGICAL    NO-UNDO.

  /* we call our own isUpdatePending first. 
    (It will be reached from our UpdateTarget also as part of the check of 
     all targets in canNavigate) */ 
  RUN IsUpdatePending IN TARGET-PROCEDURE (INPUT-OUTPUT lPending).
 
  IF lPending THEN
    RETURN FALSE.

  lNavigate = ?.
  {get UpdateTarget hDataObject}.
  IF NOT VALID-HANDLE(hDataObject) THEN
    {get DataSource hDataObject}.
  IF VALID-HANDLE(hDataObject) THEN
  DO:
    ghTargetProcedure = TARGET-PROCEDURE.
    lNavigate = {fn canNavigate hDataObject} NO-ERROR.
    ghTargetProcedure = ?.
  END.  /* if valid data object */

  /* Return false only for active denials. */
  RETURN IF lNavigate = FALSE THEN FALSE ELSE TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getAuditEnabled) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getAuditEnabled Procedure 
FUNCTION getAuditEnabled RETURNS LOGICAL
  ( ) :
/*------------------------------------------------------------------------------
  Purpose:  Get the audit enabled for the data source
    Notes:  
------------------------------------------------------------------------------*/
DEFINE VARIABLE hDataSource   AS HANDLE     NO-UNDO.
DEFINE VARIABLE lAuditEnabled AS LOGICAL    NO-UNDO.

 {get DataSource hDataSource}.
 IF VALID-HANDLE(hDataSource) THEN
 DO:
   ghTargetProcedure = TARGET-PROCEDURE.
   {get AuditEnabled lAuditEnabled hDataSource}.
   ghTargetProcedure = ?.
 END.

 RETURN lAuditEnabled.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getCreateHandles) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getCreateHandles Procedure 
FUNCTION getCreateHandles RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns a character value (in a list form, comma-separated) of the 
            handles of the fields in the data visualization object which should 
            be enabled for an Add or Copy operation.
   Params:  <none>
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cHandles AS CHARACTER NO-UNDO.
  {get CreateHandles cHandles}.
  RETURN cHandles.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDataModified) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getDataModified Procedure 
FUNCTION getDataModified RETURNS LOGICAL
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns a logical value which indicates whether the current 
            SCREEN-VALUES have been modified but not saved.
   Params:  <none>
    Notes:  This property is set when the user modifies some data on
            the screen. 
------------------------------------------------------------------------------*/

  DEFINE VARIABLE lModified AS LOGICAL NO-UNDO.

  &SCOPED-DEFINE xpDataModified
  {get DataModified lModified}.
  &UNDEFINE xpDataModified
  
  RETURN lModified.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDisplayedFields) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getDisplayedFields Procedure 
FUNCTION getDisplayedFields RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns a character value (in a list form, comma-separated) of the 
            columns displayed by the visualization object.
   Params:  <none>
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cFields AS CHARACTER NO-UNDO.
  {get DisplayedFields cFields}.
  RETURN cFields.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDisplayedTables) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getDisplayedTables Procedure 
FUNCTION getDisplayedTables RETURNS CHARACTER
  (   ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the list of SDO table names used by the visualization.
            May be just "RowObject" or if the object was built against an
            SBO, will be the list of SDO ObjectNames whose fields are used.
   Params:  <none>
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cTables AS CHARACTER  NO-UNDO.
  {get DisplayedTables cTables}.
  RETURN cTables.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getEditable) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getEditable Procedure 
FUNCTION getEditable RETURNS LOGICAL
  (  ) :
/*------------------------------------------------------------------------------
  Purpose: Indicates whether this object can be edited (add/copy/save/update) 
    Notes: This defaults to true if any enabled fields is defined here or in 
           any GroupAssingTarget.     
           Used by the toolbar to indicate whether actions like add/copy etc
           should be enabled. 
  ------------------------------------------------------------------------------*/
  DEFINE VARIABLE lEditable      AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE cTargets       AS CHARACTER NO-UNDO.
  DEFINE VARIABLE iTarget        AS INT       NO-UNDO.
  DEFINE VARIABLE hTarget        AS HANDLE    NO-UNDO.
  DEFINE VARIABLE cEnabledFields AS CHARACTER NO-UNDO.
  
  &SCOPED-DEFINE xpEditable   
  {get Editable lEditable}.
  &UNDEFINE xpEditable 
   
  /* If undefined, we check for Enabled fields here and if no found we
     call the same function in all GroupAssignTarget, which then will do
     the same check in it self an all its GroupAssignTargets */     
  IF lEditable = ? THEN 
  DO: 
    {get EnabledFields cEnabledFields}.
    lEditable = cEnabledFields <> '':U.
    IF NOT (lEditable = TRUE) THEN 
    DO:     
      {get GroupAssignTarget cTargets}.   
      DO iTarget = 1 TO NUM-ENTRIES(cTargets):
        hTarget = WIDGET-HANDLE(ENTRY(iTarget,cTargets)).
        {get Editable lEditable hTarget}.
        /* We don't need to look further if an editable target was found */
        IF lEditable THEN
          LEAVE.
      END.
    END.
    /* Store the property so we don't need to perform this loop again */ 
    {set Editable lEditable}.
  END. /* lEditable = ? (Property not defined yet) */

  RETURN lEditable.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getEnabledFields) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getEnabledFields Procedure 
FUNCTION getEnabledFields RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns a character value (in a list form, comma-separated) of the 
            enabled fields (name) in this object which map to fields in the 
            SmartDataObject (&ENABLED-FIELDS).
   Params:  <none>
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cFields AS CHARACTER NO-UNDO.
  {get EnabledFields cFields}.
  RETURN cFields.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getEnabledHandles) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getEnabledHandles Procedure 
FUNCTION getEnabledHandles RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns a character value (in a list form, comma-separared) of the 
            handles of the enabled fields in the visualization object.
   Params:  <none>
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cHandles AS CHARACTER NO-UNDO.
  {get EnabledHandles cHandles}.
  RETURN cHandles.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getEnabledObjFldsToDisable) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getEnabledObjFldsToDisable Procedure 
FUNCTION getEnabledObjFldsToDisable RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose: This property decides whether non-db objects should be disabled
           when the fields are disabled.
           - (None)  - EnabledObjFlds remain enabled when the fields are 
                       disabled.  
           - (All)   - EnabledObjFlds should be disabled in view mode
           - Comma separated list of object names that will be disabled in view
             mode.               
    Notes:  
------------------------------------------------------------------------------*/  
  DEFINE VARIABLE cDisable          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lUseRepository    AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cDataSourceFields AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hTableioSource    AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cUIBMode          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hGaSource         AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hTableioTarget    AS HANDLE     NO-UNDO.

  &SCOPED-DEFINE xpEnabledObjFldsToDisable
  {get EnabledObjFldsToDisable cDisable}.
  &UNDEFINE xpEnabledObjFldsToDisable
    
  
  /* ? or blank means use default */  
  IF cDisable = ? OR cDisable = '':U THEN
  DO:
    /* if design mode just return as-is, postpone the default logic to runtime
       as it may check for links */
    {get UIBMode cUIBmode}.
    IF cUIBmode = 'Design':U THEN
      RETURN cDisable.

      /* Default is (none) for adm2 and (all) for dynamics in order to 
      be backward compatible with both. */
    {get UseRepository lUseRepository}.
    
    IF lUseRepository THEN
    DO:
       /* It also defaults to (none) for dynamics when there are no db fields 
          in order to keep behavior of viewers that relied on the bug that 
          did not disable them. This would be common in viewers with no
          db fields or no tableiosource  */              
      {get DisplayedFields cDataSourceFields}.
      IF cDataSourceFields = '':U THEN
        cDisable = '(None)':U.
      ELSE DO:
        /* Check if the top most GASource is a tableioTarget */ 
        hTableioTarget = TARGET-PROCEDURE. 
        DO WHILE TRUE.
          {get GroupAssignSource hGASource hTableioTarget}.
          IF NOT VALID-HANDLE(hGAsource) THEN
            LEAVE.
          ELSE
            hTableioTarget = hGaSource.
        END.
        {get TableioSource hTableioSource hTableioTarget}.
        IF VALID-HANDLE(hTableioSource) THEN
          cDisable = '(All)':U.
        ELSE
          cDisable = '(None)':U.
      END.
    END.
    ELSE
      cDisable = '(None)':U.

    /* store it for the next time */ 
    {set EnabledObjFldsToDisable cDisable}.
  END.

  /* NOTE: If Design mode the prop was returned as-is above */
  RETURN cDisable.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getFieldHandles) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getFieldHandles Procedure 
FUNCTION getFieldHandles RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns a character value  (in a list form, comma-separated) of the 
            handles of the Data Fields in the visualization object.
   Params:  <none>
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cHandles AS CHARACTER NO-UNDO.
  {get FieldHandles cHandles}.
  RETURN cHandles.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getFieldsEnabled) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getFieldsEnabled Procedure 
FUNCTION getFieldsEnabled RETURNS LOGICAL
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns a logical value indicating whether the fields in this 
            visualization object are enabled or not.
   Params:  <none>
------------------------------------------------------------------------------*/

  DEFINE VARIABLE lEnabled AS LOGICAL NO-UNDO.
  {get FieldsEnabled lEnabled}.
  RETURN lEnabled.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getFilterActive) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getFilterActive Procedure 
FUNCTION getFilterActive RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose: Returns whether the dataSource has a logical filter 
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hSource AS HANDLE     NO-UNDO.
  DEFINE VARIABLE lActive AS LOGICAL    NO-UNDO.

  {get DataSource hSource}.
  IF VALID-HANDLE(hSource) THEN
  DO:
    ghTargetProcedure = TARGET-PROCEDURE.
    {get FilterActive lActive hSource}.
    ghTargetProcedure = ?.
  END.
  RETURN lActive.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getGroupAssignHidden) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getGroupAssignHidden Procedure 
FUNCTION getGroupAssignHidden RETURNS LOGICAL
  (  ) :
/*------------------------------------------------------------------------------
  Purpose: Check if the object is hidden and will remain hidden including 
           ALL GroupAssignTargets
    Notes: Used by the data.p LinkState to check if it can deactivate the link
           and how to republish the message.
           Returns false as soon as any visible object is found.
         - Checks pendingPage in order to return NO if it is becoming visible.             
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cTargets         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iTarget          AS INT        NO-UNDO.
  DEFINE VARIABLE hTarget          AS HANDLE     NO-UNDO.
  DEFINE VARIABLE lHidden          AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE iObjectPage      AS INTEGER    NO-UNDO.
  DEFINE VARIABLE hContainer       AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hGTContainer     AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hTSContainer     AS HANDLE     NO-UNDO.
  DEFINE VARIABLE iPendingPage     AS INTEGER    NO-UNDO.
  DEFINE VARIABLE hTableio         AS HANDLE     NO-UNDO.
  DEFINE VARIABLE lToolbarDisabled AS LOGICAL    NO-UNDO.  
  DEFINE VARIABLE cInactiveLinks   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lContainerHidden AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lTableioHidden   AS LOGICAL    NO-UNDO.
  
  &SCOPED-DEFINE xp-assign
  {get ObjectHidden lHidden}
  {get ContainerHidden lContainerHidden}
  .
  &UNDEFINE xp-assign
  
  IF NOT lHidden AND NOT lContainerHidden THEN
    RETURN FALSE.
  
  /* Also return false if this object is about to become visible 
     PendingPage is set in SelectPage before notify(hideObject) -> linkState
     -> here, and before CurrentPage is set */ 
  &SCOPED-DEFINE xp-assign
  {get ObjectPage iObjectPage}
  {get ContainerSource hContainer}
   .
  &UNDEFINE xp-assign
  
  IF NOT lContainerHidden THEN
  DO:
    {get PendingPage iPendingPage hContainer}.  
    IF iPendingPage = iObjectPage THEN
      RETURN FALSE.
  END.

  /* A visual object with an active tableio toolbar with this as the only 
     tableiotarget on page 0 need to remain active/linked in order to make 
     updateState from the data-source reach the tableio source  */
  {get InactiveLinks cInactiveLinks}.
  IF LOOKUP('TableioSource':U,cInactiveLinks) = 0 THEN
  DO:
    {get TableioSource hTableio}.
    IF VALID-HANDLE(hTableio) THEN
    DO:
      /* if containerhidden and tablio is on this container then we do 
         not care about keeping link active */
      IF lContainerHidden THEN 
      DO:
        {get ContainerSource hTSContainer}.
        lTableioHidden = NOT VALID-HANDLE(hTScontainer) 
                         OR  (hTScontainer = hContainer) 
                         OR {fn getObjectHidden hTScontainer} = TRUE.
      END.
      
      IF NOT lTableioHidden THEN
      DO:
        {get TableioTarget cTargets hTableio}.
        IF cTargets = STRING(TARGET-PROCEDURE) THEN
        DO:
          &SCOPED-DEFINE xp-assign
          {get DeactivateTargetOnHide lToolbarDisabled hTableio}
          {get ObjectPage iObjectPage hTableio}
          .
          &UNDEFINE xp-assign
          /* page 0 and we're the only target. */
          IF iObjectPage = 0 AND NOT lToolbarDisabled THEN
            RETURN FALSE.
        END.
      END. /* if not tableiohidden*/
    END.
  END.

  {get GroupAssignTarget cTargets}. 
  DO iTarget = 1 TO NUM-ENTRIES(cTargets):
    hTarget = WIDGET-HANDLE(ENTRY(iTarget,cTargets)).
    
    IF lContainerHidden THEN
    DO:
      {get ContainerSource hGTContainer}.
      IF hGTContainer <> hContainer THEN
      DO:
        {get ObjectHidden lHidden hGTContainer}.
        IF NOT lHidden THEN
          RETURN FALSE.
      END.
    END.
    
    {get GroupAssignHidden lHidden hTarget}.
    IF NOT lHidden THEN
      RETURN FALSE.
  END.
  
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getGroupAssignSource) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getGroupAssignSource Procedure 
FUNCTION getGroupAssignSource RETURNS HANDLE
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns a handle value representing the handle of the 
            object's GroupAssign source.
   Params:  <none>
------------------------------------------------------------------------------*/

  DEFINE VARIABLE hSource AS HANDLE NO-UNDO.
  {get GroupAssignSource hSource}.
  RETURN hSource.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getGroupAssignSourceEvents) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getGroupAssignSourceEvents Procedure 
FUNCTION getGroupAssignSourceEvents RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns a character value (in a list form, comma-separated) of the 
            events this object wants to subscribe to in its GroupAssign source.
   Params:  <none>
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cEvents AS CHARACTER NO-UNDO.
  {get GroupAssignSourceEvents cEvents}.
  RETURN cEvents.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getGroupAssignTarget) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getGroupAssignTarget Procedure 
FUNCTION getGroupAssignTarget RETURNS CHARACTER
  (  ):
/*------------------------------------------------------------------------------
  Purpose:  Returns a character value of the handle of the 
            object's GroupAssign target.
   Params:  <none>
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cTarget AS CHARACTER NO-UNDO.
  {get GroupAssignTarget cTarget}.
  RETURN cTarget.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getGroupAssignTargetEvents) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getGroupAssignTargetEvents Procedure 
FUNCTION getGroupAssignTargetEvents RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns a character value (in a list form, comma-separated) of the 
            events this object wants to subscribe to in its GroupAssign target.
   Params:  <none>
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cEvents AS CHARACTER NO-UNDO.
  {get GroupAssignTargetEvents cEvents}.
  RETURN cEvents.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getInternalDisplayFromSource) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getInternalDisplayFromSource Procedure 
FUNCTION getInternalDisplayFromSource RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  Decides which fields the displayFields method should retrieve 
            directly from the data source instead of from the input parameter. 
            This attribute's purpose is to support Large data-types in the 
            character based displayFields method, but '(all)'  will give a 
            general performance improvement also for viewers that display very 
            large character data.  
            - (Large) - The DataSource's LargeColumns
            - (All)     - All fields (Ignore input parameter)
            - Comma separated list of columns
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cFromSource AS CHARACTER NO-UNDO.
  {get InternalDisplayFromSource cFromSource}.
  RETURN cFromSource.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getLabel) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getLabel Procedure 
FUNCTION getLabel RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose: Returns the LABEL defined for the DataSource object 
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cLabel          AS CHARACTER NO-UNDO.
  DEFINE VARIABLE hDataSource     AS HANDLE    NO-UNDO.
  DEFINE VARIABLE cSourceNames    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDataSourceName AS CHARACTER  NO-UNDO.
  &SCOPED-DEFINE xpLabel
  {get Label cLabel}.
  &UNDEFINE xpLabel
  
  IF cLabel = ? THEN 
  DO:
    &SCOPED-DEFINE xp-assign
    {get DataSource hDataSource}
    {get DataSourceNames cSourceNames}
     .
    &UNDEFINE xp-assign
    
    IF VALID-HANDLE(hDataSource) THEN
    DO:
      /* The SBO Label is really useless, so if SourceNames is defined we need 
         to get the handle of the actual Source */
      IF cSourceNames > '':U THEN
      DO:
        IF NUM-ENTRIES(cSourceNames) > 1 THEN
          cSourceNames = ENTRY(1,cSourceNames).
        ELSE 
          {get ObjectName cDataSourceName hDataSource}.
        
        IF (cSourceNames <> cDataSourceName)  THEN
          hDataSource = {fnarg DataObjectHandle cSourceNames hDataSource}. 
      END.
      {get LABEL cLabel hDataSource}.
    END. 
    IF cLabel = ? OR cLabel = '' THEN
      cLabel = SUPER().
    
    IF cLabel <> ? AND cLabel <> '' THEN
      {set LABEL cLabel}.
  END.
  
  RETURN cLabel.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getModifyFields) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getModifyFields Procedure 
FUNCTION getModifyFields RETURNS CHARACTER
   (  ) :
/*------------------------------------------------------------------------------
  Purpose: This property decides which enabled fields that should set 
           DataModified when the fields are changed.
           - (All)   - All EnabledObjects should set DataModified
           - (EnabledFields) - Only EnabledFields (Fields from the DataSource) 
                               should set DataModified
           - (Updatable) - Only EnabledFields that are updatable in the 
                           DataSource should set DataModified 
           - (None)  - No EnabledObjects should set DataModified
           - Comma separated list of object names that will set DataModified 
    Notes:  
------------------------------------------------------------------------------*/  
 DEFINE VARIABLE cModifyFields AS CHARACTER  NO-UNDO.

 {get ModifyFields cModifyFields}.
 RETURN cModifyFields.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getNewRecord) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getNewRecord Procedure 
FUNCTION getNewRecord RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns a character value that indicates whether the current record 
            in the visualization object is newly created or not.
            Possible values are: Add, Copy, No          
    Notes:   
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cNew AS CHARACTER NO-UNDO.
  
  &SCOPED-DEFINE xpNewRecord
  {get NewRecord cNew}.
  &UNDEFINE xpNewRecord
  
  RETURN cNew.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getObjectMode) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getObjectMode Procedure 
FUNCTION getObjectMode RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose: Returns the mode of the object 
           - modify (This is a non-modal mode that can be turned off with view
           - update (This is a modal mode that is turned off with save or cancel)
           - view   (not editable) 
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cObjectMode AS CHARACTER  NO-UNDO.
  
  {get ObjectMode cObjectMode}.
  RETURN cObjectMode.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getObjectParent) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getObjectParent Procedure 
FUNCTION getObjectParent RETURNS HANDLE
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns a handle value of the Progress parent container handle 
            for the current visualization object.
   Params:  <none>
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hContainer AS HANDLE NO-UNDO.
  
  {get ContainerHandle hContainer}.
  IF VALID-HANDLE (hContainer) THEN
  DO:
    IF VALID-HANDLE(hContainer:FRAME) THEN
      RETURN hContainer:FRAME.
    ELSE IF VALID-HANDLE(hContainer:PARENT) THEN
      RETURN hContainer:PARENT.
    ELSE RETURN ?.
  END.
  ELSE RETURN ?.

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
  IF lPreviewActive = ? THEN 
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

&IF DEFINED(EXCLUDE-getRecordState) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getRecordState Procedure 
FUNCTION getRecordState RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns a character value indicating if a record is available or not.
            Possible values are: RecordAvailable, NoRecorAvailable
   Params:  <none>
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cState AS CHARACTER NO-UNDO.
  {get RecordState cState}.
  RETURN cState.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getRowIdent) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getRowIdent Procedure 
FUNCTION getRowIdent RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns a character value representing the RowIdent of the current 
            row in the visualization.
  Params:   <none>
  Notes:    The DB rowids may be stored as the second entry of the list, if the 
            updateTarget is an SDO.         
  SBO:      When connected to an SBO the rowids returned are a semi-colon 
            separated list corresponding to the SBOs DataObjectNames, 
            if the SBO is a valid UpdateTarget the rowids are for the 
            UpdateTargetNames, otherwise the DataSourceNames are used.      
          - We want to return only the rowids that uniquely identifies this 
            objects connection to the dataSource/updateTarget and remove 
            unnecessary rowids so the property can be used directly as input 
            to update methods in the SBO. 
            The assumption is of course that all tables that only are displayed 
            in the visual object are on the 'one' side of a one-to-many or 
            many-to-one relation of the table that is updated, so that they are
            uniquely identified through the updateable table and their rowids 
            are not part of this object 'Ident'.  
            We do however return more than one rowid for the case were more
            than one SDO is updated as one-to-one in the SBO. 
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hSBO                  AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cRowIdent             AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDataObjectNames      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cVisualNames          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cObjectName           AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iObject               AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cGATargets            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hGATarget             AS HANDLE     NO-UNDO.
  DEFINE VARIABLE iGa                   AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cGARowident           AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iRowident             AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cRowid                AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cGARowid              AS CHARACTER  NO-UNDO.

  /* define xp preprocessor so the get include gets the value from the prop */ 
  &SCOPED-DEFINE xpRowIdent 
  {get RowIdent cRowIdent}.
  &UNDEFINE xpRowIdent 
  
  /* If we update an SBO with more than one SDO, the property are ';' delimited.*/
  IF NUM-ENTRIES(cRowident,';':U) > 1 THEN
  DO:
    {get UpdateTarget hSBO}.
    
    /* If update link, we use UpdateTargetNames. */ 
    IF VALID-HANDLE(hSBO) THEN      
      {get UpdateTargetNames cVisualNames}.
        /* No update link, we use UpdateTargetNames. */ 
    ELSE DO:
      {get DataSource hSBO}.
      {get DataSourceNames cVisualNames}.
    END.
    
    IF NOT VALID-HANDLE(hSBO) THEN
      RETURN '':U. /* Don't return ? as this means current record in the 
                      update methids */

    {get DataObjectNames cDataObjectNames hSBO}. 
    /* Ensure all entries for not updatable/displayed objects are blanked */
    DO iObject = 1 TO NUM-ENTRIES(cDataObjectNames):
      cObjectName = ENTRY(iObject,cDataObjectNames).
      
      IF NOT CAN-DO(cVisualNames,cObjectName) THEN
        ENTRY(iObject,cRowident,';':U) = '':U.
        
    END. /* do iObject loop  */  
    
    /* Check if groupassign targets have some additional rowids */
    {get GroupAssignTarget cGATargets}.
    DO iGa = 1 TO NUM-ENTRIES(cGATargets):
      hGATarget = WIDGET-HANDLE(ENTRY(iGa,cGaTargets)).    
      {get RowIdent cGARowident hGATarget}.
      IF cGaRowident <> ? THEN
      DO iRowIdent = 1 TO NUM-ENTRIES(cRowident,';':U):
        cRowid   = ENTRY(iRowIdent,cRowident,';':U).
        /* if we have ? unavail or nothing check the GA's rowid */
        IF cRowid = '?':U OR cRowid = '':U THEN
        DO:
          /* if the GA's is neither unavail or nothing then use it. */
          cGARowid = ENTRY(iRowIdent,cGARowident,';':U).
          IF cGARowid <> '?' OR cGARowid <> '':U THEN
             ENTRY(iRowIdent,cRowident,';':U) = cGARowid.
        END.
      END.
    END.  /* loop through GroupAssing targets */  
  END. /* SBO rowids -- num-entries(cRowident,';') > 1 */
  ELSE DO:
     
     /* If rowid was set from rowobject:rowid, which is common for the browse,
        ensure that it is returned in the SBO format if required, in this case 
        the dataSourcename and updatetargetname is the same so we just check
        dataSourcenames */

    {get DataSource hSBO}.
    IF VALID-HANDLE(hSBO) THEN
    DO:
      {get DataObjectNames cDataObjectNames hSBO} NO-ERROR.
      IF NUM-ENTRIES(cDataObjectNames) > 1 THEN 
      DO:
       {get DataSourceNames cVisualNames}.
        ASSIGN
          cRowid = cRowident.
          cRowident = FILL(';':U,NUM-ENTRIES(cDataObjectNames) - 1).
        IF LOOKUP(cVisualNames,cDataObjectNames) > 0 THEN
          ENTRY(LOOKUP(cVisualNames,cDataObjectNames),cRowident,';':U)  = cRowid.        
      END.
    END.
  END.
  RETURN cRowIdent.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getSaveSource) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getSaveSource Procedure 
FUNCTION getSaveSource RETURNS LOGICAL
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns true if the tableiosource is a Save and false if 'Update' 
            ( modal update )
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE lSaveSource AS LOGICAL    NO-UNDO.
  {get SaveSource lSaveSource}.
  RETURN lSaveSource.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getTableIOSource) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getTableIOSource Procedure 
FUNCTION getTableIOSource RETURNS HANDLE
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns a handle value representing the handle of the 
            object's TableIO Source.
   Params:  <none>
------------------------------------------------------------------------------*/

  DEFINE VARIABLE hSource AS HANDLE NO-UNDO.
  {get TableIOSource hSource}.
  RETURN hSource.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getTableIOSourceEvents) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getTableIOSourceEvents Procedure 
FUNCTION getTableIOSourceEvents RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns a character value (in a list form, comma-separated) of the 
            events this object wants to subscribe to in its Tableio source.
   Params:  <none>
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cEvents AS CHARACTER NO-UNDO.
  {get TableIOSourceEvents cEvents}.
  RETURN cEvents.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getTargetProcedure) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getTargetProcedure Procedure 
FUNCTION getTargetProcedure RETURNS HANDLE
  (   ) :
/*------------------------------------------------------------------------------
  Purpose:  Temporary fn to return the source-procedure's target-procedure
            to a function such as addRow in an SBO who needs to know who
            the *real* caller object is.
    Notes:  
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

&IF DEFINED(EXCLUDE-getUpdateTarget) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getUpdateTarget Procedure 
FUNCTION getUpdateTarget RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns a character value of the handle of the 
            object's Update Target.
   Params:  <none>
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cTarget AS CHARACTER NO-UNDO.
  {get UpdateTarget cTarget}.
  RETURN cTarget.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getUpdateTargetNames) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getUpdateTargetNames Procedure 
FUNCTION getUpdateTargetNames RETURNS CHARACTER
  (   ) :
/*------------------------------------------------------------------------------
 Purpose:  Returns the ObjectName of the Data Object to be updated by this
           visual object. This would be set if the Update-Target is an SBO
           or other Container with DataObjects.
  Params:  <none>
   Notes: Currently used when visual objects designed against an SDO with 
          RowObject is linked to an SBO.  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cTargetNames   AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cGaTargetNames AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cGaTargets     AS CHARACTER NO-UNDO.
  DEFINE VARIABLE iGa            AS INTEGER   NO-UNDO.
  DEFINE VARIABLE hGATarget      AS HANDLE    NO-UNDO.
  DEFINE VARIABLE iGaNames       AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cGaName        AS CHARACTER  NO-UNDO.

  &SCOPED-DEFINE xpUpdateTargetNames
  {get UpdateTargetNames cTargetNames}.
  &UNDEFINE xpUpdateTargetNames
  
  {get GroupAssignTarget cGATargets}.
  DO iGa = 1 TO NUM-ENTRIES(cGATargets):
     hGATarget = WIDGET-HANDLE(ENTRY(iGa,cGaTargets)).    
    {get UpdateTargetNames cGATargetNames  hGaTarget}.
    
    IF cGaTargetNAmes <> ? AND cGATargetNames <> "":U THEN
    DO iGaNames = 1 TO NUM-ENTRIES(cGATargetNames):
       cGaName = ENTRY(iGaNames,cGATargetNames).
       IF LOOKUP(cGaName,cTargetNames) = 0 THEN
          cTargetNames = cTargetNames 
                       + (IF cTargetNames = '':U THEN '':U ELSE ',':U)
                       + cGaName.
    END.

  END. /* loop thru GATargets */

  RETURN cTargetNames.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getWindowTitleField) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getWindowTitleField Procedure 
FUNCTION getWindowTitleField RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    DEFINE VARIABLE cWindowTitleField AS CHARACTER.
    {get WindowTitleField cWindowTitleField}.
    
    RETURN cWindowTitleField.   /* Function return value. */

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

&IF DEFINED(EXCLUDE-internalWidgetHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION internalWidgetHandle Procedure 
FUNCTION internalWidgetHandle RETURNS HANDLE
  ( INPUT pcField AS CHARACTER,
    INPUT pcSearchMode AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Return handle of named widget within this object  
    Notes:  This version is for datavisual objects and uses search mode
            to determine whether to search for datafields or invoke 
            the SUPER version to search for local fields as well.
            Valid values are:
            ALL - searches datafields and local fields (if it doesn't find 
                                                        datafield)
            DATA - searches datafields only
            LOCAL - searches local field only
------------------------------------------------------------------------------*/
DEFINE VARIABLE cFieldNames   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cFieldHandles AS CHARACTER  NO-UNDO.
DEFINE VARIABLE iFieldPos     AS INTEGER    NO-UNDO.
DEFINE VARIABLE hField        AS HANDLE     NO-UNDO.

  IF LOOKUP(pcSearchMode, 'ALL,DATA':U) > 0 THEN
  DO:
    &SCOPED-DEFINE xp-assign
    {get DisplayedFields cFieldNames}
    {get FieldHandles cFieldHandles}.
    &UNDEFINE xp-assign
    iFieldPos = LOOKUP(pcField, cFieldNames).
    IF iFieldPos NE 0 AND NUM-ENTRIES(cFieldHandles) >= iFieldPos THEN 
      hField = WIDGET-HANDLE(ENTRY(iFieldPos, cFieldHandles)).  
  END.  /* if mode is all or data */
  IF VALID-HANDLE(hField) THEN RETURN hField.
  ELSE IF LOOKUP(pcSearchMode, 'ALL,LOCAL':U) > 0 THEN
    RETURN SUPER (INPUT pcField, INPUT pcSearchMode).    
  ELSE RETURN ?.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-okToContinue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION okToContinue Procedure 
FUNCTION okToContinue RETURNS LOGICAL
  (pcAction AS CHAR):
/*------------------------------------------------------------------------------
  Purpose:  Check if the visual object have modified screen data or 
            if its data-source has uncommitted changes.
            If any of these conditions are true we issue Yes-No-Cancel 
            questions offering the user to answer 
              YES     to save/commit and continue the action.  TRUE
              NO      to cancel/undo and continue the action.  TRUE
              CANCEL  to NOT continue the action.              FALSE
 Parameters: pcAction (char) - Used to retrieve correct message. 
                     - exit   - Exit/close of application window.
                     - blank  - Continue  
                     - Commit - Commit 
                     - Undo   - Undo (Don't offer save as an option) 
    Notes:   -  confirmExit and confirmOpenQuery uses this function.
------------------------------------------------------------------------------*/
   DEFINE VARIABLE lModified       AS LOGICAL NO-UNDO.
   DEFINE VARIABLE lAnswer         AS LOGICAL NO-UNDO.   
   DEFINE VARIABLE hDataSource     AS HANDLE  NO-UNDO.
   DEFINE VARIABLE cRowObjectState AS CHAR    NO-UNDO.
   DEFINE VARIABLE cOperation      AS CHAR    NO-UNDO.
   DEFINE VARIABLE hGASource       AS HANDLE  NO-UNDO.
   DEFINE VARIABLE cNewRecord      AS CHARACTER NO-UNDO.
   
   cOperation = DYNAMIC-FUNCTION("messageNumber":U IN TARGET-PROCEDURE,
                                  IF pcAction = "Exit":U 
                                  THEN 21  /* Exit */
                                  ELSE IF pcAction = 'Commit':U 
                                  THEN 31  /* Commit */
                                  ELSE 22). /* Continue */

   {get GroupAssignSource hGaSource}.
   
   /* We trust that all checks will be performed against the GA Source */ 
   IF VALID-HANDLE(hGASource) THEN
      RETURN TRUE. 

    /* If lModified ask the user what to do. */
   &SCOPED-DEFINE xp-assign
   {get DataModified lModified}
   {get NewRecord cNewRecord}.
   &UNDEFINE xp-assign
   IF lModified OR (cNewRecord <> 'NO':U AND pcAction <> 'Exit':U) THEN    
   DO:
     IF pcAction <> 'Undo':U THEN
       lAnswer = DYNAMIC-FUNCTION('showMessage':U IN TARGET-PROCEDURE, 
                                  '3,' + cOperation + ',YesNoCancel':U). 
     ELSE DO:
       lAnswer = NOT DYNAMIC-FUNCTION('showMessage':U IN TARGET-PROCEDURE, 
                                       '32,' + 'OkCancel':U). 
       /* Yes means don't save  
         (The function will still return true at the end) */
       IF lAnswer THEN lAnswer = NO.
       /* Cancel is returned as NO when only 2 choices, so set it to ?*/ 
       ELSE lAnswer = ?.
     END.

     /* Yes to save changes */
     IF lAnswer THEN
     DO:
       RUN updateRecord IN TARGET-PROCEDURE.
       /* Do not continue if error */
       IF RETURN-VALUE = "ADM-ERROR":U THEN
          RETURN FALSE.      
     END. /* answer YES */

     /* No; Cancel modified data and continue */
     ELSE IF NOT lAnswer THEN
       RUN cancelRecord IN TARGET-PROCEDURE.    
     
     ELSE /* lAnswer = ? */
       RETURN FALSE. /* Do NOT continue if Cancel was pressed */    

   END. /* If lModified */
   /* else if new and exit just cancel silently to make sure the sdo is reset
      if it is in another window thjat is not closed */
   ELSE IF cNewRecord <> 'NO':U AND pcAction = 'EXIT':U THEN
     RUN cancelRecord IN TARGET-PROCEDURE.    

   /* Check if there are any uncommited changes in the data-source. 
      Avoid this for undo and commit of course... */
   IF NOT CAN-DO('Undo,Commit':U,pcAction) THEN
   DO:
     {get DataSource hDataSource}.
     IF VALID-HANDLE(hDataSource) THEN
     DO:
       /* use no-error in case of db query */ 
       cRowObjectState = DYNAMIC-FUNCTION("getRowObjectState":U IN hDataSource) 
                         NO-ERROR.
       IF cRowObjectState = "RowUpdated":U THEN
       DO:
         lAnswer = DYNAMIC-FUNCTION('showMessage':U IN TARGET-PROCEDURE, 
                                    '20,' + cOperation + ',YesNoCancel':U). 

         IF lAnswer THEN
         DO:
           RUN commitTransaction IN hDataSource.
           /* Do not continue if error */
           IF RETURN-VALUE = "ADM-ERROR":U THEN 
             RETURN FALSE.
         END. /* answer YES */
         /* if NO undo updates */
         ELSE IF NOT lAnswer THEN
           RUN undoTransaction IN hDataSource.    
         ELSE /* lAnswer = ? so don't continue */
           RETURN FALSE. 
       END. /* if cRowObjectstate = 'RowUpdated' */
     END. /* if valid-handle(hDataSource) */
   END. /* pcAction <> undo,commit*/

   RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setDataModified) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setDataModified Procedure 
FUNCTION setDataModified RETURNS LOGICAL
  ( plModified AS LOGICAL ) :
/*------------------------------------------------------------------------------
  Purpose:  Assigns a logical value to the DataModified property indicating 
            that there are unsaved changes in a data visualization object.
   Params:  lModified AS LOGICAL -- TRUE or FALSE 
    Notes:  Also PUBLISHEes the UpdateState event to tell other objects
            unless the special value of Unknown is passed, which means
            to set DataModified to no without doing UpdateComplete, but Reset
            which will ensure that the toolbar/panel does not publish 
            updateMode('UpdateEnd')    
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cState        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hGASource     AS HANDLE     NO-UNDO.
  DEFINE VARIABLE lChanged      AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lDataModified AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lNewModified  AS LOGICAL    NO-UNDO.

  /* We check if this is a change in order to ensure that we don't republish 
     if this is the setting we have, as this obviously means that we already 
     have published the event. The SBO sometimes does/did this, but it seems 
     as a general protection since updateState goes almost everywhere. 
     (So when you read this the SBO may actually not do this anymore, but other
      objects may rely on this protection)*/     

  &SCOPED-DEFINE xpDataModified 
  {get DataModified lDataModified}.
  &UNDEFINE xpDataModified 

  ASSIGN lChanged     = plModified <> lDataModified OR plModified = ?
         lNewModified = IF plModified = ? THEN no ELSE plModified.
         cState       = IF   plModified = ?      THEN 'Reset':U 
                        ELSE IF plModified = yes THEN 'Update':U
                        ELSE                          'UpdateComplete':U.
  
  &SCOPED-DEFINE xpDataModified 
  {set DataModified lNewModified}.
  &UNDEFINE xpDataModified 

  /* If this object has a GroupAssign-Source, then 
     -- if DataModified is being set to no, don't republish updateState,
        because this event will have come from the GA-Source, which will
        take care of it;
     -- if DataModified is being set to yes, then publish the event. */

  {get GroupAssignSource hGASource}.
  IF VALID-HANDLE(hGASource) THEN
  DO:
    IF cState = 'Update':U THEN 
      PUBLISH 'UpdateState':U FROM TARGET-PROCEDURE (cState).
  END.
  ELSE IF lChanged THEN 
  DO:
    /* up the dataSource chain */  
    PUBLISH 'UpdateState':U FROM TARGET-PROCEDURE (cState).
    /* Up the containerSource chain */
    PUBLISH 'UpdateActive':U FROM TARGET-PROCEDURE (IF plModified = ? THEN NO ELSE plModified).
  END.
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setDisplayedFields) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setDisplayedFields Procedure 
FUNCTION setDisplayedFields RETURNS LOGICAL
  ( pcFieldList AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Assigns a character value to the DisplayFields property listing 
            the fields that are displayed in the visualization object.
   Params:  pcFieldList AS CHARACTER  -- comma-separated list of field names
------------------------------------------------------------------------------*/

  {set DisplayedFields pcFieldList}.
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setEditable) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setEditable Procedure 
FUNCTION setEditable RETURNS LOGICAL
  ( plEditable AS LOGICAL) :
/*------------------------------------------------------------------------------
  Purpose: indicates whether this object can be edited (add/copy/save/update) 
Parameter: plEditable - yes, the object can be edited.
                        no, the object only supports delete.
    Notes: The property usually deafaults to true if any enabled fields is 
           defined here or in any GroupAssingTarget and defaults to false if
           no fields are enabled.     
           Used by the toolbar to indicate whether actions like add/copy etc.
           should be enabled. 
           Can be specifically overridden in case add/copy and save should be
           enabled even when no fields are enabled. 
------------------------------------------------------------------------------*/  
  
  &SCOPED-DEFINE xpEditable   
  {set Editable plEditable}.
  &UNDEFINE xpEditable 
  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setEnabledFields) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setEnabledFields Procedure 
FUNCTION setEnabledFields RETURNS LOGICAL
  ( pcFieldList AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Assigns a character value to the EnabledFields property listing 
            the fields that are enabled in the visualization object.
   Params:  pcFieldList AS CHARACTER -- comma-separated list of field names
------------------------------------------------------------------------------*/

  {set EnabledFields pcFieldList}.
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setEnabledHandles) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setEnabledHandles Procedure 
FUNCTION setEnabledHandles RETURNS LOGICAL
  ( pcHandles AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Sets a character value (in a list form, comma-separared) of the 
            handles of the enabled fields in the visualization object.
   Params:  <none>
   Note:   This list must be correspond to the names in EnabledFields! 
------------------------------------------------------------------------------*/
  
  {set EnabledHandles pcHandles}.
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setEnabledObjFldsToDisable) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setEnabledObjFldsToDisable Procedure 
FUNCTION setEnabledObjFldsToDisable RETURNS LOGICAL
  ( pcEnabledObjFldsToDisable AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose: This property decides whether non-db objects should be disabled
           when the fields are disabled.
           - (All)   - All EnabledObjects should be disabled in view mode
           - (None)  - All EnabledObjects should remain enabled when the 
                       fields are disabled.  
           - Comma separated list of object names that will be disabled in view
             mode.               
    Notes:  
------------------------------------------------------------------------------*/  
 &SCOPED-DEFINE xpEnabledObjFldsToDisable
 {set EnabledObjFldsToDisable pcEnabledObjFldsToDisable}.
 &UNDEFINE xpEnabledObjFldsToDisable  
 RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setFieldHandles) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setFieldHandles Procedure 
FUNCTION setFieldHandles RETURNS LOGICAL
  ( pcHandles AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Sets a character value (in a list form, comma-separared) of the 
            handles of the displayed fields in the visualization object.
   Params:  <none>
   Note:   This list must correspond to the names in DisplayedFields  
------------------------------------------------------------------------------*/
  
  {set FieldHandles pcHandles}.
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setGroupAssignSource) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setGroupAssignSource Procedure 
FUNCTION setGroupAssignSource RETURNS LOGICAL
  ( phObject AS HANDLE ) :
/*------------------------------------------------------------------------------
  Purpose:  Assigns a handle value to the GroupAssignSource property 
            representing the handle of GroupAssign Source object.
   Params:  phObject AS HANDLE -- Procedure handle of the GroupAssign source
------------------------------------------------------------------------------*/

  {set GroupAssignSource phObject}.
  RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setGroupAssignSourceEvents) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setGroupAssignSourceEvents Procedure 
FUNCTION setGroupAssignSourceEvents RETURNS LOGICAL
  ( pcEvents AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Assigns a character value to the GroupAssignSourceEvents property
            representing the list of events this objects subscribes to in its 
            GroupAssign Source.
   Params:  pcEvents AS CHARACTER -- The new comma-delimited event list
    Notes:  Because this property may be a comma-separated list of events, this
            function should normally be called only indirectly, from 
            modifyListProperty().
------------------------------------------------------------------------------*/

  {set GroupAssignSourceEvents pcEvents}.
  RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setGroupAssignTarget) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setGroupAssignTarget Procedure 
FUNCTION setGroupAssignTarget RETURNS LOGICAL
  ( pcObject AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Assigns a character value to the GroupAssignTarget property 
            representing the handle of the GroupAssign Target.
   Params:  pcObject AS CHARACTER -- The procedure handle of the 
                                     GroupAssign target
    Notes:  Because this property may be a comma-separated list of Targets, this
            function should normally be called only indirectly, from 
            modifyListProperty().
------------------------------------------------------------------------------*/

  {set GroupAssignTarget pcObject}.
  RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setGroupAssignTargetEvents) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setGroupAssignTargetEvents Procedure 
FUNCTION setGroupAssignTargetEvents RETURNS LOGICAL
  ( pcEvents AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Assigns a character value to GroupAssignTargetEvents property 
            representing the list of events this objects subscribes to in its 
            GroupAssign Target.
   Params:  pcEvents AS CHARACTER -- The new comma-delimited event list.
    Notes:  Because this property may be a comma-separated list of events, this
            function should normally be called only indirectly, from 
            modifyListProperty().
------------------------------------------------------------------------------*/

  {set GroupAssignTargetEvents pcEvents}.
  RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setInternalDisplayFromSource) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setInternalDisplayFromSource Procedure 
FUNCTION setInternalDisplayFromSource RETURNS LOGICAL
  ( pcFromSource AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Decides which fields the displayFields method should retrieve 
            directly from the data source instead of from the input parameter. 
            This attribute's purpose is to support Large data-types in the 
            character based displayFields method, but '(all)'  will give a 
            general performance improvement also for viewers that display very 
            large character data.  
 Parameter: pcFromSource            
            - (Large) - The DataSource's LargeColumns
            - (All)     - All fields (Ignore input parameter)
            - Comma separated list of columns
------------------------------------------------------------------------------*/
  {set InternalDisplayFromSource pcFromSource}.
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setLogicalObjectName) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setLogicalObjectName Procedure 
FUNCTION setLogicalObjectName RETURNS LOGICAL
  ( pcLogicalObjectName AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  
   Params:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE lObjectInitialized AS LOGICAL.
  
  SUPER(pcLogicalObjectName).

  /* the following should only be done if the object has already been constucted */
  /*   RUN createObjects. */
  
  {get ObjectInitialized lObjectInitialized}.
  IF lObjectInitialized THEN 
  DO:
    {set ObjectInitialized NO}.
    RUN initializeObject IN TARGET-PROCEDURE.
  END.

  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setModifyFields) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setModifyFields Procedure 
FUNCTION setModifyFields RETURNS LOGICAL
  ( pcModifyFields AS CHAR ) :
/*------------------------------------------------------------------------------
 Purpose: This property decides which enabled fields that should set 
           DataModified when the fields are changed.
           - (All)   - All EnabledObjects should set DataModified
           - (EnabledFields) - Only EnabledFields (Fields from the DataSource) 
                               should set DataModified
           - (Updatable) - Only EnabledFields that are updatable in the 
                            DataSource should set DataModified 
           - (None)  - No EnabledObjects should set DataModified
           - Comma separated list of object names that will set DataModified 
    Notes:  
------------------------------------------------------------------------------*/  
 {set ModifyFields pcModifyFields}.
 RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setNewRecord) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setNewRecord Procedure 
FUNCTION setNewRecord RETURNS LOGICAL
  ( pcMode AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  Set the NewRecord state 
Parameter:  pcMode   
             - add
             - copy
             - NO
    Notes:  Overridden in order to publish updateActive
------------------------------------------------------------------------------*/
  &SCOPED-DEFINE xpNewRecord
  {set NewRecord pcMode}.
  &UNDEFINE xpNewRecord

  PUBLISH 'UpdateActive':U FROM TARGET-PROCEDURE (pcMode <> 'NO':U).
  RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setObjectMode) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setObjectMode Procedure 
FUNCTION setObjectMode RETURNS LOGICAL
  ( pcObjectMode AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose: Store the mode of the object 
           - modify (This is a non-modal mode that can be turned off with view
           - update (This is a modal mode that is turned off with save or cancel)
           - view   (not editable) 
    Notes: NOTE: This is not actually changing the mode. 
                 This happens with updateMode and sometimes enable and disable   
------------------------------------------------------------------------------*/
  {set ObjectMode pcObjectMode}.
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
  Purpose:  Assigns a handle value to the ObjectParent property representing
            the parent Progress container widget handle for the 
            visualization object. 
   Params:  phParent AS HANDLE -- The handle of the parent object
------------------------------------------------------------------------------*/

  DEFINE VARIABLE hContainer AS HANDLE NO-UNDO.
  
  {get ContainerHandle hContainer}.
  IF VALID-HANDLE (hContainer) THEN
  DO:
    IF CAN-DO("DIALOG-BOX,FRAME":U, phParent:TYPE) THEN
      hContainer:FRAME = phParent.
    ELSE hContainer:PARENT = phParent.
    RETURN TRUE.
  END.
  ELSE RETURN FALSE.
  
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

&IF DEFINED(EXCLUDE-setRowIdent) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setRowIdent Procedure 
FUNCTION setRowIdent RETURNS LOGICAL
  ( pcRowIdent AS CHAR  ) :
/*------------------------------------------------------------------------------
  Purpose:  Store the rowident to pass to update methods in the updatetarget
Parameter:  pcRowident              
            If the target is an SBO the Rowident is received in a semi-colon
            separated list in contained objects order.  
            - with entries for all displayed SDOs, from colValues. 
            - with entries for all SDOs, from colValues with blank as fields . 
            
  Notes:   The getRowIdent does NOT return this the same way
           SEE notes.
           
           setRowident is called for each display/dataavailable, so this is one 
           of the cases were get actually is used far less than set, so we 
           wait until we need to fix this. 
------------------------------------------------------------------------------*/
  &SCOPED-DEFINE xpRowident 
  {set RowIdent pcRowIdent}.
  &UNDEFINE xpRowIdent
  
  RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setSaveSource) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setSaveSource Procedure 
FUNCTION setSaveSource RETURNS LOGICAL
  (plSave AS LOG) :
/*------------------------------------------------------------------------------
  Purpose: Used internally to indicate the state of the tablieo source  
    Notes: Can be set to FALSE to override the default enabling of a viewer 
           that has an update-Source, but has no tableio-source.    
------------------------------------------------------------------------------*/
  {set SaveSource plSave}.
  RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setTableIOSource) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setTableIOSource Procedure 
FUNCTION setTableIOSource RETURNS LOGICAL
  ( phObject AS HANDLE ) :
/*------------------------------------------------------------------------------
  Purpose:  Assigns a handle value to the TableIOSource property representing
            the handle of the Tableio source.
   Params:  phObject AS HANDLE -- The procedure handle of the TableIOSource
------------------------------------------------------------------------------*/

  {set TableIOSource phObject}.
  RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setTableIOSourceEvents) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setTableIOSourceEvents Procedure 
FUNCTION setTableIOSourceEvents RETURNS LOGICAL
  ( pcEvents AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Assigns a character value to the TableioSourceEvents property 
            representing the list of events this objects subscribes to in its
            TableIO Source.
   Params:  pcEvents AS CHARACTER -- The new comma-delimited event list
    Notes:  Because this property may be a comma-separated list of events, this
            function should normally be called only indirectly, from 
            modifyListProperty().
------------------------------------------------------------------------------*/

  {set TableIOSourceEvents pcEvents}.
  RETURN TRUE.
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

&IF DEFINED(EXCLUDE-setUpdateTarget) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setUpdateTarget Procedure 
FUNCTION setUpdateTarget RETURNS LOGICAL
  ( pcObject AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Assigns a character value to UpdateTarget property representing
            the handle of the Data target.
   Params:  pcObject AS CHARACTER -- The procedure handle of the Update target
------------------------------------------------------------------------------*/

  {set UpdateTarget pcObject}.
  RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setUpdateTargetNames) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setUpdateTargetNames Procedure 
FUNCTION setUpdateTargetNames RETURNS LOGICAL
      ( pcTargetNames AS CHAR ) :
/*------------------------------------------------------------------------------
 Purpose: Stores the ObjectName of the Data Object to be updated  by this
          visual object. This would be set if the Update-Target is an SBO
          or other Container with DataObjects.
  Params: pcTargetNames
   Notes: Currently used when visual objects designed against an SDO with 
          RowObject is linked to an SBO.  
          We don't have a global xp because the get also returns values from 
          GaTargets so that addRow can add for both if required 
------------------------------------------------------------------------------*/
  &SCOPED-DEFINE xpUpdateTargetNames
  {set UpdateTargetNames pcTargetNames}.
  &UNDEFINE xpUpdateTargetNames
  
  RETURN TRUE.   

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setWindowTitleField) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setWindowTitleField Procedure 
FUNCTION setWindowTitleField RETURNS LOGICAL
  ( cWindowTitleField AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    {set WindowTitleField cWindowTitleField}.
    RETURN TRUE.   /* Function return value. */

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
   Notes:    Invokes fetchMessages() to retrieve all Data-related messages
             (normally database update-related error messages), and
             displays them in a alert-box of type error.
             This function expects to receive back a single string 
             from fetchMessages with one or more messages delimited by CHR(3),
             and within each message the message text, Fieldname (or blank) +
             a Tablename (or blank), delimited by CHR(4) if present.
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

