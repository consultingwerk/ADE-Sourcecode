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

/* This variable is needed at least temporarily in 9.1B/C so that a called
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

&IF DEFINED(EXCLUDE-getNewRecord) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getNewRecord Procedure 
FUNCTION getNewRecord RETURNS CHARACTER
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

&IF DEFINED(EXCLUDE-setEnabledFields) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setEnabledFields Procedure 
FUNCTION setEnabledFields RETURNS LOGICAL
  ( pcFieldList AS CHARACTER )  FORWARD.

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

&IF DEFINED(EXCLUDE-setObjectParent) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setObjectParent Procedure 
FUNCTION setObjectParent RETURNS LOGICAL
  ( phParent AS HANDLE )  FORWARD.

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
         HEIGHT             = 15.1
         WIDTH              = 53.8.
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
  
  DEFINE VARIABLE cTarget      AS CHARACTER NO-UNDO.
  DEFINE VARIABLE hGroupSource AS HANDLE    NO-UNDO.
  DEFINE VARIABLE lMod         AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE cGroupTarget AS CHARACTER NO-UNDO.
  DEFINE VARIABLE lHidden      AS LOGICAL   NO-UNDO.

  /* If the visualization is hidden, this effectively disables 
     "TableIO" operations, unless there is a GroupAssign-Source or Target .*/
  {get ObjectHidden lHidden}.
  {get GroupAssignTarget cGroupTarget}.
  {get GroupAssignSource hGroupSource}.           
  IF lHidden AND cGroupTarget = "":U AND hGroupSource = ? THEN 
    RETURN "ADM-ERROR":U. 

  {get UpdateTarget cTarget}.
  IF cTarget = "":U AND hGroupSource = ? THEN
  DO:
    DYNAMIC-FUNCTION ('showMessage':U IN TARGET-PROCEDURE, INPUT "No UpdateTarget present for Add operation.":U).
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
  PUBLISH 'updateState':U FROM TARGET-PROCEDURE ('Update':U). /* Tell panel */
      
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
  DEFINE VARIABLE cGroupTarget  AS CHARACTER NO-UNDO.
  DEFINE VARIABLE lModified     AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE lAutoCommit   AS LOGICAL   NO-UNDO.

  /* If the visualization is hidden, this effectively disables 
     "TableIO" operations, unless there is a GroupAssign-Source or Target.*/
  {get ObjectHidden lHidden}.
  {get GroupAssignTarget cGroupTarget}.
  {get GroupAssignSource hGroupSource}.  
  
  IF lHidden AND cGroupTarget = "":U AND hGroupSource = ? THEN 
    RETURN "ADM-ERROR":U. 
  
  {get NewRecord cNew}.

  /* Cancel the new record in the DataObject */
  {get UpdateTarget hUpdateTarget}.    
  
  IF cNew <> 'NO':U THEN
  DO: 
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
  
   /* NOTE: set DataModifed/updateState must happen AFTER cancelRow() because 
      at the end of the events (depending of the toolbar mode) updatestate may 
      fire back from the toolbar to disable and if this is a viewer the focus 
      will be set to the browse and if 'add' or 'copy' the previous record will 
      become available. When this was done BEFORE cancelRow the 'add' or 'copy'
      would not be undone and these rowObject records would cause error messages
      with the next save */                 
  
    /* toolbar checks this so reset before publish */
    {set NewRecord 'No':U}.    /* Note: this is character 'no', not logical*/
  END. /* cNew = 'no' */
  ELSE
    /* cancelRow publishes 'dataAvailable' for new  */
    RUN displayRecord IN TARGET-PROCEDURE.

  {get DataModified lModified}.
  IF NOT lModified THEN
    PUBLISH 'updateState':U FROM TARGET-PROCEDURE ('updateComplete':U).

  ELSE 
    {set DataModified no}.   /* Turn off the modified flag. */

    /* Disable any fields enabled just for the Add operation. */ 
  {get RecordState cState}.
  IF cState BEGINS "NoRecordAvailable":U AND cNew NE "No":U THEN            /* Could be Add or Copy or No */
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
  
  DEFINE VARIABLE cChange       AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cFieldHandles AS CHARACTER NO-UNDO.
  DEFINE VARIABLE iCnt          AS INTEGER   NO-UNDO.
  DEFINE VARIABLE iChanges      AS INTEGER   NO-UNDO INIT 0.
  DEFINE VARIABLE hFrameField   AS HANDLE    NO-UNDO.
  DEFINE VARIABLE iPage         AS INTEGER   NO-UNDO.  
  DEFINE VARIABLE lMod          AS LOGICAL   NO-UNDO. 
  
  /* As of 9.1A we use the list of all field handles, not just enabled ones,
     to capture changes made programmatically to non-enabled fields. */
  {get FieldHandles cFieldHandles}.
  DO iCnt = 1 TO NUM-ENTRIES(cFieldHandles):
    hFrameField = WIDGET-HANDLE(ENTRY(iCnt, cFieldHandles)).
    /* The "Frame Field" may be a procedure handle for a SmartObject */
    IF hFrameField:TYPE = "PROCEDURE":U THEN
    DO:
      lMod = dynamic-function('getDataModified' IN hFrameField) NO-ERROR.
      IF lMod THEN
       ASSIGN iChanges = iChanges + 1
              pcChanges = pcChanges + (IF pcChanges EQ "":U THEN "":U ELSE CHR(1)) 
                + dynamic-function('getFieldName' IN hFrameField) + CHR(1) + 
                  dynamic-function('getDataValue' IN hFrameField).
    END.  /* END DO IF PROCEDURE */
    ELSE IF hFrameField:MODIFIED THEN
    DO:
      /* Need to try to assign the INPUT-VALUE to see if there is an 
         error with the INPUT-VALUE, for example an invalid date was
         entered by the user, if there is we add a message for this
         field */
      ASSIGN cChange = hFrameField:INPUT-VALUE NO-ERROR.
      IF ERROR-STATUS:GET-MESSAGE(1) NE '':U THEN DO:
        RUN addMessage IN TARGET-PROCEDURE
          (ERROR-STATUS:GET-MESSAGE(1), hFrameField:NAME, ?).
      END.  /* if error with INPUT-VALUE */
      ASSIGN iChanges = iChanges + 1
             pcChanges = pcChanges 
                       + (IF pcChanges EQ "":U THEN "":U ELSE CHR(1)) 
                       + (IF  hFrameField:TABLE NE "RowObject":U 
                          AND hFrameField:TABLE NE ? 
                          THEN hFrameField:TABLE + ".":U 
                          ELSE "":U) 
                       + hFrameField:NAME + CHR(1) 
                       + IF hFrameField:INPUT-VALUE = ? 
                         THEN "?":U
                         ELSE hFrameField:INPUT-VALUE NO-ERROR.
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
    plCancel = NOT {fnarg okToContinue 'Commit':U}.

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
  
  IF NOT plCancel THEN
    plCancel = NOT {fnarg okToContinue 'openQuery':U}.

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
    plCancel = NOT {fnarg okToContinue 'Exit':U}.

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
   plCancel = NOT {fnarg okToContinue 'Undo':U}.

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
  DEFINE VARIABLE lHidden      AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE cGroupTarget AS CHARACTER NO-UNDO.
 
  /* If the visualization is hidden, this effectively disables 
     "TableIO" operations, unless there is a GroupAssign-Source or Target.*/
  {get ObjectHidden lHidden}.
  {get GroupAssignTarget cGroupTarget}.
  {get GroupAssignSource hGroupSource}.
  IF lHidden AND cGroupTarget = "":U AND hGroupSource = ? THEN 
    RETURN "ADM-ERROR":U. 

  {get UpdateTarget cTarget}.
  IF cTarget = "":U AND hGroupSource = ? THEN
  DO:
    DYNAMIC-FUNCTION('showMessage':U IN TARGET-PROCEDURE, INPUT "No UpdateTarget present for Copy operation.":U).
    RETURN "ADM-ERROR":U.
  END.

  /* Reject the Copy attempt if the current values have been modified
      and not saved. */
   {get DataModified lMod}.
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
   PUBLISH 'updateState':U FROM TARGET-PROCEDURE ('Update':U). /* Tell panel */
      
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
               of the input parameter received. In any case it gets the values
               of the displayed fields from the Data source by invoking 
               colValues(), and displays them.
------------------------------------------------------------------------------*/
 DEFINE INPUT PARAMETER pcRelative AS CHARACTER NO-UNDO.

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

  DEFINE VARIABLE hUpdateTarget AS HANDLE    NO-UNDO.
  DEFINE VARIABLE cTarget       AS CHARACTER NO-UNDO.
  DEFINE VARIABLE lSuccess      AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE cRowIdent     AS CHARACTER NO-UNDO.
  DEFINE VARIABLE lAutoCommit   AS LOGICAL   NO-UNDO. 
  DEFINE VARIABLE lHidden      AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE cGroupTarget AS CHARACTER NO-UNDO.
 
  /* If the visualization is hidden, this effectively disables 
     "TableIO" operations, unless there are GroupAssign-Targets .*/
  {get ObjectHidden lHidden}.
  {get GroupAssignTarget cGroupTarget}.
  IF lHidden AND cGroupTarget = "":U THEN 
    RETURN "ADM-ERROR":U. 
    
 {get UpdateTarget cTarget}.
  hUpdateTarget = WIDGET-HANDLE(cTarget).  /* NOTE: Make sure there's just 1? */
  IF VALID-HANDLE(hUpdateTarget) THEN
  DO:
    {get RowIdent cRowIdent}.
    lSuccess = dynamic-function("deleteRow":U IN hUpdateTarget,
                                 cRowIdent).    
  END.  /* END DO VALID-HANDLE */
  ELSE DO:
    RUN addMessage IN TARGET-PROCEDURE
      ("No UpdateTarget present for Delete operation.":U, ?, ?).
    lSuccess = no.
  END.  /* END ELSE DO (NOT VALID-HANDLE) */
  IF lSuccess = no THEN
  DO:
    {fn showDataMessages}.
    RETURN "ADM-ERROR":U.
  END.
  RETURN.
 
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
 DEFINE VARIABLE cColumns       AS CHARACTER NO-UNDO.
 DEFINE VARIABLE cDisplayed     AS CHARACTER NO-UNDO.
 DEFINE VARIABLE cQueryPosition AS CHARACTER NO-UNDO.
 DEFINE VARIABLE hSource        AS HANDLE    NO-UNDO.
 DEFINE VARIABLE cSourceNames   AS CHARACTER NO-UNDO.
 DEFINE VARIABLE cUIBmode       AS CHARACTER NO-UNDO.

 {get DataSource hSource}.
 IF VALID-HANDLE(hSource) THEN
 DO:
   {get DisplayedFields cDisplayed}.
   
   /* If the fields are unqualified, we check if we run against an SBO and
      qualify so the SBO can know which SDO to direct the call to.  
      This is both for speed and is also required for data integrity as the SBO 
      does return values on a first found basis. The SBOs addDataTarget will not 
      allow any ambiguity when generating DataSourceNames, but trusts the object
      to qualify correctly if DataSourceNames is set already at start up. */

   IF INDEX(cDisplayed,'.':U) = 0 THEN
   DO:
      {get DataSourceNames cSourceNames} NO-ERROR.
      /* The SBOs colValues needs only one qualifer to direct the call to 
         that SDO */
      IF NUM-ENTRIES(cSourceNames) = 1 THEN 
         cDisplayed = cSourceNames + '.':U + cDisplayed. 
   END. /* no qualifiers */

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

  DEFINE VARIABLE hSource    AS HANDLE    NO-UNDO.
  DEFINE VARIABLE cPanelType AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cState     AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cTarget    AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cUIBMode   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hDataSource AS HANDLE     NO-UNDO.

  RUN SUPER.            /* Invoke the standard behavior first. */
  
  IF RETURN-VALUE = "ADM-ERROR":U
    THEN RETURN "ADM-ERROR":U. 

  /* The sbo subscribes to this event in order to update ObjectMapping.*/
  PUBLISH 'registerObject':U FROM TARGET-PROCEDURE.

  {get TableIOSource hSource}.  
  {get UpdateTarget cTarget}.
  /* If there's a TableIO-Source but no Update-Target, this is invalid,
     so disable the update panel. */
  IF VALID-HANDLE(hSource) THEN  /* If no TIO-Source then leave SaveSource '?' */
  DO:
    {get UpdateTarget cTarget}.
    IF cTarget = "":U THEN
      RUN disableObject IN hSource.
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

  /* Find out the QueryPosition prop of our Data-Source and apply it to
     ourselves if we are still in our initial RecordState. */
  {get RecordState cState}.
  IF cState = 'NoRecordAvailable':U THEN
    RUN queryPosition IN TARGET-PROCEDURE
      (dynamic-function('linkProperty':U IN TARGET-PROCEDURE, 
        'Data-Source':U, 'QueryPosition':U)).

  RUN displayObjects IN TARGET-PROCEDURE NO-ERROR.
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
  
  DEFINE VARIABLE cRecordState  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lEnabled      AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lSaveSource   AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE hGASource     AS HANDLE     NO-UNDO.

  /* Save a [No]RecordAvailable flag for others to query. */
  cRecordState = IF pcState BEGINS 'NoRecordAvail':U 
                 THEN pcState
                 ELSE 'RecordAvailable':U.
  
  {set RecordState cRecordState}.

  {get FieldsEnabled lEnabled}.
  
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
     
    /* The only way to NOT make this happen is with an tableio-target 
       with UPDATE mode (lSaveSource = false).  
       NOT (lSaveSource = false) ensures that we run enableFields 
       also with no tableio source. THIS IS INTENTIONAL! 
       This Rule was implemented in 9.1B.*/
    IF NOT (lSaveSource = FALSE) THEN
      RUN enableFields IN TARGET-PROCEDURE.
  END.   /* END DO NOT lEnabled */
      
  /* re-send the event to other objects (such as an Update Panel) */
  PUBLISH 'queryPosition':U FROM TARGET-PROCEDURE (pcState).
  
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
  DEFINE VARIABLE lHidden      AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE lSaveSource  AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE cGroupTarget AS CHARACTER NO-UNDO.
  DEFINE VARIABLE hGroupSource AS HANDLE    NO-UNDO.

  /* If the visualization is hidden, this effectively disables 
     "TableIO" operations, unless there is a GroupAssign-Source or Target.*/
  {get ObjectHidden lHidden}.
  {get GroupAssignTarget cGroupTarget}.
  {get GroupAssignSource hGroupSource}.
  
  IF lHidden AND cGroupTarget = "":U AND hGroupSource = ? THEN 
    RETURN "ADM-ERROR":U. 
  
  /* Normally setting DataModified to 'no' also publishes updateComplete,
     but we want a Reset (to avoid browse rows becoming enabled
     when changing rows after a Reset), so pass special signal of unknown to 
     tell setDataModified to set the property off and pass 'reset' instead of
     'UpdateComplete'.  This will also trigger the dataObject to roll back 
     and delete a potential rowObjUpd record , so display afterwards */ 
     
  {set DataModified ?}.
  
  RUN displayRecord IN TARGET-PROCEDURE.

  PUBLISH 'resetRecord':U FROM TARGET-PROCEDURE.  /* In case GroupAssign */
  
  RUN applyEntry IN TARGET-PROCEDURE (?).
  
  RETURN.
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
                                  the update button
               updateEnd        - Signals that the user has pressed the save
                                  button
  Notes:       'updateBegin' signals that the Update button has been pressed 
               in an Update SmartPanel in Update mode. Enable fields for data 
               entry. 'updateEnd' signals that Save has completed; disable 
               fields. 'update-begin' was a state msg in V8. updateEnd 
               corresponds to the save button dispatching disable-fields in V8.
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER pcMode AS CHARACTER NO-UNDO.
  
  DEFINE VARIABLE lHidden      AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE cGroupTarget AS CHARACTER NO-UNDO.
  DEFINE VARIABLE hGroupSource AS HANDLE    NO-UNDO.

  /* If the visualization is hidden, this effectively disables 
     "TableIO" operations, unless this is part of a GroupAssign.*/
  {get ObjectHidden lHidden}.
  IF lHidden THEN 
  DO:
    {get GroupAssignTarget cGroupTarget}.
    {get GroupAssignSource hGroupSource}.    
    IF cGroupTarget = "":U AND hGroupSource = ? THEN 
      RETURN "ADM-ERROR":U. 
  END.   /* END DO IF lHidden */

  CASE pcMode:
    WHEN 'updateBegin':U THEN
    DO:
      RUN enableFields IN TARGET-PROCEDURE.
      PUBLISH 'updateState':U FROM TARGET-PROCEDURE('update').
      /*
      {set DataModified yes}.   /* This will also do updateState('update') */
      */
    END.
    WHEN 'updateEnd':U THEN
      RUN disableFields IN TARGET-PROCEDURE ('All':U).  
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
  DEFINE VARIABLE cValues       AS CHARACTER NO-UNDO INIT "":U.
  DEFINE VARIABLE cChangeInfo   AS CHARACTER NO-UNDO INIT "":U.
  DEFINE VARIABLE hFrameField   AS HANDLE    NO-UNDO.
  DEFINE VARIABLE iCnt          AS INTEGER   NO-UNDO.
  DEFINE VARIABLE lSuccess      AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE hUpdateTarget AS HANDLE    NO-UNDO.
  DEFINE VARIABLE cTarget       AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cErrorField   AS CHARACTER NO-UNDO.
  DEFINE VARIABLE iErrorField   AS INTEGER   NO-UNDO.
  DEFINE VARIABLE iFields       AS INTEGER   NO-UNDO INIT 0.
  DEFINE VARIABLE iPos          AS INTEGER   NO-UNDO.
  DEFINE VARIABLE iCurrentPage  AS INTEGER   NO-UNDO.
  DEFINE VARIABLE iErrorPage    AS INTEGER   NO-UNDO.
  DEFINE VARIABLE hErrorObject  AS HANDLE    NO-UNDO.
  DEFINE VARIABLE iEntries      AS INTEGER   NO-UNDO.
  DEFINE VARIABLE cRowIdent     AS CHARACTER NO-UNDO.
  DEFINE VARIABLE hSource       AS HANDLE    NO-UNDO.
  DEFINE VARIABLE cGroupTarget  AS CHARACTER NO-UNDO.
  DEFINE VARIABLE lHidden       AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE hGroupSource  AS HANDLE    NO-UNDO.
  DEFINE VARIABLE cNoValidFlds  AS CHAR      NO-UNDO.
  DEFINE VARIABLE lModified     AS LOGICAL   NO-UNDO.
  /* If the visualization is hidden, this effectively disables 
     "TableIO" operations, unless there are other objects in a
     Group-Assign, in which case one of them is currently viewed.*/
  {get ObjectHidden lHidden}.
  {get GroupAssignTarget cGroupTarget}.
  {get GroupAssignSource hGroupSource}.
  
  IF lHidden AND cGroupTarget = "":U AND hGroupSource = ? THEN 
    RETURN "ADM-ERROR":U. 

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
  
    {get UpdateTarget cTarget}.
    {get RowIdent cRowIdent}.
    hUpdateTarget = WIDGET-HANDLE(cTarget).
    IF VALID-HANDLE(hUpdateTarget) THEN
    DO:
      lSuccess = DYNAMIC-FUNCTION("submitRow":U IN hUpdateTarget,
                                    cRowIdent, cValues).
    END.
    ELSE DO:
       RUN addMessage IN TARGET-PROCEDURE
       ("No UpdateTarget present for Save operation.":U, ?,?).
      lSuccess = no.
    END.   /* END ELSE DO */
    
    /* If there are no errors set flags */
    IF lSuccess THEN
    DO:
     {set NewRecord 'No':U}.  /* Set Add/Copy flag off in case it was on. */

      /* setDatamodifed currently publishes 'updateState' only if the modified 
         property was changed, so check if we need to publish directly */
      {get DataModified lModified}.
      IF NOT lModified THEN
        PUBLISH 'updateState':U FROM TARGET-PROCEDURE ('updateComplete':U).
      ELSE 
        {set DataModified no}.   /* This will also publish UpdateComplete. */
     
      /* ... also to any GroupAssign-targets */
      dynamic-function('assignLinkProperty':U IN TARGET-PROCEDURE,
                       'GroupAssign-Target':U, 
                       'DataModified':U, 
                       'no':U).

    END.  /* END DO if there are no errors */
    ELSE DO: /* Display error messages */
      cErrorField = {fn showDataMessages}.  /* Get the first field in error. */
      
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
      ASSIGN                    
        iPos     = iPos - 3 /* DO has incremented iPos, move to prev group */ 
        iErrorPage   = INT(ENTRY(iPos + 1, cChangeInfo))
        hErrorObject = WIDGET-HANDLE(ENTRY(iPos + 2, cChangeInfo)).

    END. /* else (If not lSuccess) */
  END. /* NoValifFlds = '' */
  
  /* if NoValidFlds <> '' find fieldname, page and object */ 
  ELSE DO:
      /* add the update cancelled message */
    RUN addMessage IN TARGET-PROCEDURE({fnarg messageNumber 15},?,?).
    
    {fn showDataMessages}.    
    ASSIGN 
      iErrorField  = 1 /* we just pick the first field in the error list*/
      cErrorfield  = ENTRY(iErrorField,cNoValidFlds) 
      iErrorPage   = INT(ENTRY(iErrorField + 1,cNoValidFlds))
      hErrorObject = WIDGET-HANDLE(ENTRY(iErrorField + 2,cNoValidFlds)) NO-ERROR.
    
    IF cErrorField = "" OR ERROR-STATUS:ERROR THEN
       RETURN "ADM-ERROR":U.
  END. /* Validate failed */

  IF cErrorField <> "":U THEN
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
               
      Notes: How a 'ricochet' was avoided in 9.1B:                    
             - The browser always subscribed this from DataSource to be able 
               to disable/enbale, but it never republished.  
               It did actually get 'ricochets' when publishing, but avoided 
               problems by a RETURN when modifed or New in browser.p's override. 
               (Maybe it still does, as this is undecided when this is written ) 
             - The viewer never subscribed to this from DataSource. 
             How we deal with this in 9.1C.
             - Filter out the events received from GATargets and always 
                 pass them through setDataModifed. 
             - Don't republish otherwise, but publish 'resetTablio'
             - In addition data.p filters updateState from objects that 
               are DataTargets AND has 'updateState' as DataSourceEvents
               and does a run in the dataSource instead of a publish, so 
               that the event does not get poublished back to us.
            Group Assign Targets  
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
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pcState AS CHARACTER NO-UNDO.
  
  DEFINE VARIABLE hSource   AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cGATarget AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lModified AS LOGICAL    NO-UNDO.
  
  IF pcState NE 'Update':U AND pcState NE 'UpdateComplete':U THEN
    RETURN "ADM-ERROR":U.

  {get GroupAssignTarget cGaTarget}.
  /* If this is this an internal change of data, publish to everyone */
  IF CAN-DO(cGaTarget,STRING(SOURCE-PROCEDURE)) THEN
  DO:
    lModified = (pcState = 'Update':U).
    {set DataModified lModified}.
  END.
  ELSE /* received from a dataSource just tell the toolbar */
    PUBLISH 'resetTableio':U FROM TARGET-PROCEDURE.   

  RETURN.
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
  END.
  
  /* Check GroupAssignTargets  */ 
  PUBLISH "validateFields":U FROM TARGET-PROCEDURE 
                                 (INPUT-OUTPUT pcNotValidFields).

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

/* ************************  Function Implementations ***************** */

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
 ASSIGN ghProp = WIDGET-HANDLE(ENTRY(1, TARGET-PROCEDURE:ADM-DATA, CHR(1)))
        ghProp = ghProp:BUFFER-FIELD('DataModified':U)
        lModified = ghProp:BUFFER-VALUE.
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

&IF DEFINED(EXCLUDE-getNewRecord) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getNewRecord Procedure 
FUNCTION getNewRecord RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns a character value that indicates whether the current record 
            in the visualization object is newly created or not.
            Possible values are: Add, Copy, No          
   Params:  <none>
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cNew AS CHARACTER NO-UNDO.
  {get NewRecord cNew}.
  RETURN cNew.

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
     
     /* If rowid was set from rowobject:rowid, which is commomn for the browse,
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
          cRowid = cRowident
          cRowident = FILL(';':U,NUM-ENTRIES(cDataObjectNames) - 1)
          ENTRY(LOOKUP(cVisualNames,cDataObjectNames),cRowident,';':U)  = cRowid.        
      END.
    END.
  END.
  RETURN cRowIdent.

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
   {get DataModified lModified}.  
   {get NewRecord cNewRecord}.
   IF lModified OR (cNewRecord <> 'NO':U AND pcAction <> 'Exit':U) THEN    
   DO:
     IF pcAction <> 'Undo':U THEN
       lAnswer = DYNAMIC-FUNCTION('showMessage':U IN TARGET-PROCEDURE, 
                                  '3,' + cOperation + ',YesNoCancel':U). 
     ELSE DO:
       lAnswer = NOT DYNAMIC-FUNCTION('showMessage':U IN TARGET-PROCEDURE, 
                                       '32,' + 'OkCancel':U). 
       IF lAnswer THEN lAnswer = ?.
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
  DEFINE VARIABLE hGASource AS HANDLE     NO-UNDO.
  DEFINE VARIABLE lChanged  AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cState    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lNewMode  AS LOGICAL    NO-UNDO.
  /* We check if this is a change in order to ensure that we don't republish 
     if this is the setting we have, as this obviously means that we already 
     have published the event. The SBO sometimes does/did this, but it seems 
     as a general protection since updateState goes almost everywhere. 
     (So when you read this the SBO may actually not do this anymore, but other
      objects may rely on this protection)*/         
  ASSIGN ghProp   = WIDGET-HANDLE(ENTRY(1, TARGET-PROCEDURE:ADM-DATA, CHR(1)))
         ghProp   = ghProp:BUFFER-FIELD('DataModified':U)
         lChanged = plModified <> ghProp:BUFFER-VALUE OR plModified = ?
         ghProp:BUFFER-VALUE = IF plModified = ? THEN no ELSE plModified.
         cState   = IF   plModified = ?      THEN 'Reset':U 
                    ELSE IF plModified = yes THEN 'Update':U
                    ELSE                          'UpdateComplete':U.

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
    PUBLISH 'UpdateState':U FROM TARGET-PROCEDURE (cState).
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
    Notes: The function is exposed so that it easily can be set to FALSE to 
           override the default enabling of a viewer that has is an update-Source,
           but has no tableio-source.    
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

