&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Check Version Notes Wizard" Procedure _INLINE
/* Actions: af/cod/aftemwizcw.w ? ? ? ? */
/* MIP Update Version Notes Wizard
Check object version notes.
af/cod/aftemwizpw.w
*/
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Update-Object-Version" Procedure _INLINE
/* Actions: ? ? ? ? af/sup/afverxftrp.p */
/* This has to go above the definitions sections, as that is what it modifies.
   If its not, then the definitions section will have been saved before the
   XFTR code kicks in and changes it */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Definition Comments Wizard" Procedure _INLINE
/* Actions: ? af/cod/aftemwizcw.w ? ? ? */
/* Program Definition Comment Block Wizard
Welcome to the Program Definition Comment Block Wizard. Press Next to proceed.
af/cod/aftemwizpw.w
*/
/* _UIB-CODE-BLOCK-END */
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
/*---------------------------------------------------------------------------------
  File: rvdbbuildp.p

  Description:  Fix ICFDB and RVDB data from RTB

  Purpose:      Fix ICFDB and RVDB data from RTB

  Parameters:   input temp table of selected objects
                output error text if any

  History:
  --------
  (v:010000)    Task:        7260   UserRef:    
                Date:   07/12/2000  Author:     Anthony Swindells

  Update Notes: Rebuild ICFDB data from RVDB data

  (v:010001)    Task:        7361   UserRef:    
                Date:   20/12/2000  Author:     Anthony Swindells

  Update Notes: Allow product module changes in RV and track changes

  (v:010004)    Task:        7756   UserRef:    
                Date:   30/01/2001  Author:     Anthony Swindells

  Update Notes: ensure deletion_underway records are deleted

-------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       rvdbbuildp.p
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    010004

/* Astra object identifying preprocessor */
&glob   AstraProcedure    yes

{af/sup2/afglobals.i}
{af/sup2/afcheckerr.i &define-only = YES}

DEFINE TEMP-TABLE ttSelectedObjects NO-UNDO
FIELD cRTBObjectName      AS CHARACTER
FIELD cRVObjectName       AS CHARACTER
FIELD cWorkspace          AS CHARACTER
FIELD cRTBProductModule   AS CHARACTER
FIELD cRVProductModule    AS CHARACTER
FIELD iObjectVersion      AS INTEGER
FIELD lFixExistingData    AS LOGICAL
FIELD lRVOnly             AS LOGICAL
FIELD cErrorText          AS CHARACTER
INDEX idxMain             IS PRIMARY UNIQUE cRTBObjectName
.

DEFINE INPUT-OUTPUT PARAMETER TABLE FOR ttSelectedObjects.
DEFINE OUTPUT PARAMETER pcErrorOut AS CHARACTER  NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-deleteBuffer) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD deleteBuffer Procedure 
FUNCTION deleteBuffer RETURNS CHARACTER
  (ip_buffer AS HANDLE)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-exclusiveLockBuffer) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD exclusiveLockBuffer Procedure 
FUNCTION exclusiveLockBuffer RETURNS CHARACTER
  (ip_buffer AS HANDLE) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-updateBufferField) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD updateBufferField Procedure 
FUNCTION updateBufferField RETURNS CHARACTER
  ( ip_buffer_handle AS HANDLE,
    ip_fieldname AS CHARACTER,
    ip_fieldvalue AS CHARACTER )  FORWARD.

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
         HEIGHT             = 8
         WIDTH              = 49.2.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME




&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

DEFINE VARIABLE dCurrentModuleObj               AS DECIMAL    NO-UNDO.
DEFINE VARIABLE dAssignModuleObj                AS DECIMAL    NO-UNDO.
DEFINE VARIABLE cVersionList                    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cModuleList                     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE iPreviousVersion                AS INTEGER    NO-UNDO.
DEFINE VARIABLE dPreviousModule                 AS DECIMAL    NO-UNDO.
DEFINE VARIABLE lBaseline                       AS LOGICAL    NO-UNDO.
DEFINE VARIABLE lFoundCreate                    AS LOGICAL    NO-UNDO.

DEFINE BUFFER lb1_rvt_item_version FOR rvt_item_version.

DEFINE VARIABLE cConfigurationType            AS CHARACTER  NO-UNDO.

FIND FIRST ttSelectedObjects NO-LOCK NO-ERROR.
IF NOT AVAILABLE ttSelectedObjects THEN
DO:
  ASSIGN pcErrorOut = "No objects in temp-table to fix data for".
  RETURN.
END.

FIND FIRST rvc_configuration_type NO-LOCK
    WHERE  rvc_configuration_type.configuration_type = "RYCSO":U
    NO-ERROR.
IF NOT AVAILABLE rvc_configuration_type
THEN DO:
    ASSIGN pcErrorOut = "RYCSO configuration type does not exist. fix of ALL data cancelled":U + CHR(10).
    RETURN.
END.
ELSE 
    ASSIGN
        cConfigurationType  = "RYCSO":U
        .

/* Find workspace and ensure it is not locked */
FIND FIRST rvm_workspace NO-LOCK
     WHERE rvm_workspace.workspace_code = ttSelectedObjects.cWorkspace
     NO-ERROR.
IF NOT AVAILABLE rvm_workspace THEN
DO:
  ASSIGN pcErrorOut = "Fix cancelled, Workspace not found: " + ttSelectedObjects.cWorkspace.
  RETURN.
END.

IF rvm_workspace.workspace_locked THEN
DO:
  ASSIGN pcErrorOut = "Fix cancelled, Workspace locked: " + ttSelectedObjects.cWorkspace.
  RETURN.    
END.

object-loop:
FOR EACH ttSelectedObjects:

  /* Ensure RTB product module exists in ICFDB */
  FIND FIRST gsc_product_module NO-LOCK
       WHERE gsc_product_module.product_module_code = ttSelectedObjects.cRTBProductModule
       NO-ERROR.
  IF NOT AVAILABLE gsc_product_module THEN
  DO:
    ASSIGN ttSelectedObjects.cErrorText = "Product Module does not exist for object: " + ttSelectedObjects.cRVObjectName + " RTB Product Module: " + ttSelectedObjects.cRTBProductModule + CHR(10).
    NEXT object-loop.
  END.

  /* Ensure RVDB configuration item exists for object */
  FIND FIRST rvm_configuration_item NO-LOCK
       WHERE rvm_configuration_item.scm_object_name = ttSelectedObjects.cRVObjectName
         AND rvm_configuration_item.product_module_obj = gsc_product_module.product_module_obj
       NO-ERROR.
  IF NOT AVAILABLE rvm_configuration_item THEN
  DO:
    ASSIGN ttSelectedObjects.cErrorText = "RVDB Configuration item does not exist for object: " + ttSelectedObjects.cRVObjectName + CHR(10).
    NEXT object-loop.
  END.

  /* Ensure an object with same name not already checked out in workspace */
  FIND FIRST rvm_workspace_item NO-LOCK
       WHERE rvm_workspace_item.workspace_obj = rvm_workspace.workspace_obj
         AND rvm_workspace_item.configuration_type = rvm_configuration_item.configuration_type
         AND rvm_workspace_item.scm_object_name = rvm_configuration_item.scm_object_name
       NO-ERROR.

  IF AVAILABLE rvm_workspace_item AND (rvm_workspace_item.task_version_number > 0 OR 
     CAN-FIND(FIRST rvt_workspace_checkout
              WHERE rvt_workspace_checkout.workspace_item_obj = rvm_workspace_item.workspace_item_obj)) THEN
  DO:
    ASSIGN ttSelectedObjects.cErrorText = "Workspace item already checked out for object: " + rvm_configuration_item.scm_object_name + CHR(10).
    NEXT object-loop.    
  END.

  /* Ensure object version being assigned exists and is not WIP in any workspace */
  FIND FIRST rvt_item_version NO-LOCK
       WHERE rvt_item_version.configuration_type = rvm_configuration_item.configuration_type
         AND rvt_item_version.scm_object_name = rvm_configuration_item.scm_object_name
         AND rvt_item_version.item_version_number = ttSelectedObjects.iObjectVersion
         AND rvt_item_version.product_module_obj = gsc_product_module.product_module_obj
       NO-ERROR.
  IF NOT AVAILABLE rvt_item_version THEN
  DO:
    ASSIGN ttSelectedObjects.cErrorText = "Item version does not exist for object: " + rvm_configuration_item.scm_object_name + " Module: " + ttSelectedObjects.cRTBProductModule + " Version: " + STRING(ttSelectedObjects.iObjectVersion) + CHR(10).
    NEXT object-loop.    
  END.

  IF CAN-FIND(FIRST rvm_workspace_item
              WHERE rvm_workspace_item.configuration_type = rvt_item_version.configuration_type
                AND rvm_workspace_item.scm_object_name = rvt_item_version.scm_object_name
                AND rvm_workspace_item.task_product_module_obj = rvt_item_version.product_module_obj
                AND rvm_workspace_item.task_version_number = rvt_item_version.item_version_number) THEN
  DO:
    ASSIGN ttSelectedObjects.cErrorText = "Item version checked out in a workspace for object: " + rvm_configuration_item.scm_object_name + " Version: " + STRING(ttSelectedObjects.iObjectVersion).
    NEXT object-loop.    
  END.

  /* Ensure we can find a baseline for this version to recreate the data */
  ASSIGN
    cVersionList = STRING(rvt_item_version.item_version_number)
    cModuleList = STRING(rvt_item_version.product_module_obj)
    lBaseline = rvt_item_version.baseline_version
    iPreviousVersion = rvt_item_version.previous_version_number
    dPreviousModule = rvt_item_version.previous_product_module_obj
    .
  version-loop:
  DO WHILE lBaseline = NO AND iPreviousVersion > 0:
    FIND FIRST lb1_rvt_item_version NO-LOCK
         WHERE lb1_rvt_item_version.configuration_type = rvt_item_version.configuration_type
           AND lb1_rvt_item_version.scm_object_name = rvt_item_version.scm_object_name
           AND lb1_rvt_item_version.product_module_obj = dPreviousModule
           AND lb1_rvt_item_version.item_version_number = iPreviousVersion
         NO-ERROR.
    IF NOT AVAILABLE lb1_rvt_item_version THEN LEAVE version-loop.

    ASSIGN
      cVersionList = cVersionList + CHR(3) + STRING(lb1_rvt_item_version.item_version_number)
      cModuleList = cModuleList + CHR(3) + STRING(lb1_rvt_item_version.product_module_obj)
      .  

    ASSIGN
      lBaseline = lb1_rvt_item_version.baseline_version
      iPreviousVersion = lb1_rvt_item_version.previous_version_number
      dPreviousModule = lb1_rvt_item_version.previous_product_module_obj
      .
  END.

  IF lBaseline = NO THEN
  DO:
    ASSIGN ttSelectedObjects.cErrorText = "No baseline version exists for object: " + rvm_configuration_item.scm_object_name + " Version: " + STRING(ttSelectedObjects.iObjectVersion).
    NEXT object-loop.    
  END.

  ASSIGN lFoundCreate = NO.
  trans-loop:
  FOR EACH rvt_transaction NO-LOCK
     WHERE rvt_transaction.product_module_obj = rvt_item_version.product_module_obj
       AND rvt_transaction.configuration_type = rvt_item_version.configuration_type
       AND rvt_transaction.scm_object_name = rvt_item_version.scm_object_name:
    IF LOOKUP(STRING(rvt_transaction.ITEM_version_number), cVersionList, CHR(3)) = 0 THEN NEXT trans-loop. 
    IF CAN-FIND(FIRST rvt_action
                WHERE rvt_action.task_number = rvt_transaction.task_number
                  AND rvt_action.TRANSACTION_id = rvt_transaction.TRANSACTION_id
                  AND rvt_action.event_name BEGINS "c":U
                  AND rvt_action.TABLE_name = "ryc_smartobject":U) THEN
    DO:
      ASSIGN lFoundCreate = YES.
      LEAVE trans-loop.
    END.
  END.
  IF NOT lFoundCreate THEN
  DO:
    ASSIGN ttSelectedObjects.cErrorText = "No version data with a create statement exists for object: " + rvm_configuration_item.scm_object_name + " Version: " + STRING(ttSelectedObjects.iObjectVersion).
    NEXT object-loop.    
  END.

  /* Assign new version of data into workspace */
  RUN assignObject (OUTPUT ttSelectedObjects.cErrorText).

END. /* object-loop */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-assignObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE assignObject Procedure 
PROCEDURE assignObject :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE OUTPUT PARAMETER pcError AS CHARACTER NO-UNDO.

transaction-block:
DO TRANSACTION ON ERROR UNDO transaction-block, LEAVE transaction-block:

  /* create/update workspace item record for the version - needed for delete/create */
  RUN assignWorkspaceItem (INPUT rvm_workspace.workspace_obj,
                           INPUT rvt_item_version.configuration_type,
                           INPUT rvt_item_version.scm_object_name,
                           INPUT rvt_item_version.item_version_number,
                           INPUT gsc_product_module.product_module_obj,
                           OUTPUT pcError).
  IF pcError <> "":U THEN UNDO transaction-block, LEAVE transaction-block.

  /* recreate the actual data for this item version */
  IF NOT ttSelectedObjects.lRVOnly THEN
    RUN createDataItem (INPUT ROWID(rvt_item_version),
                        OUTPUT pcError).
  IF pcError <> "":U THEN UNDO transaction-block, LEAVE transaction-block.

  /* RE-create/update workspace item record for the version in case deleted during createdataitem */
  IF NOT ttSelectedObjects.lRVOnly THEN
    RUN assignWorkspaceItem (INPUT rvm_workspace.workspace_obj,
                             INPUT rvt_item_version.configuration_type,
                             INPUT rvt_item_version.scm_object_name,
                             INPUT rvt_item_version.item_version_number,
                             INPUT gsc_product_module.product_module_obj,
                             OUTPUT pcError).
  IF pcError <> "":U THEN UNDO transaction-block, LEAVE transaction-block.

END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-assignWorkspaceItem) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE assignWorkspaceItem Procedure 
PROCEDURE assignWorkspaceItem :
/*------------------------------------------------------------------------------
  Purpose:     To assign a new version of an item into a workspace
  Parameters:  input workspace object number of workspace assigning into
               input configuration type of object being assigned
               input object name of object being assigned
               input version number of object being assigned
               input product module being assigned into
               output error message text if any.
  Notes:       When a workpace item is created, also check there are no pending 
               deleted item records and if there are, get rid of them.
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER  ip_workspace_obj                AS DECIMAL    NO-UNDO.
DEFINE INPUT PARAMETER  ip_configuration_type           AS CHARACTER  NO-UNDO.
DEFINE INPUT PARAMETER  ip_object_name                  AS CHARACTER  NO-UNDO.
DEFINE INPUT PARAMETER  ip_version_number               AS INTEGER    NO-UNDO.
DEFINE INPUT PARAMETER  ip_product_module_obj           AS DECIMAL    NO-UNDO.
DEFINE OUTPUT PARAMETER op_error                        AS CHARACTER  NO-UNDO.

DEFINE BUFFER lb_rvm_workspace_item FOR rvm_workspace_item.
DEFINE BUFFER lb_rvt_deleted_item FOR rvt_deleted_item.

ASSIGN op_error = "":U.
DO FOR lb_rvm_workspace_item, lb_rvt_deleted_item:

  FIND FIRST lb_rvm_workspace_item EXCLUSIVE-LOCK
       WHERE lb_rvm_workspace_item.workspace_obj = ip_workspace_obj
         AND lb_rvm_workspace_item.configuration_type = ip_configuration_type
         AND lb_rvm_workspace_item.scm_object_name = ip_object_name
       NO-WAIT NO-ERROR.
  IF LOCKED lb_rvm_workspace_item THEN
  DO:
    ASSIGN op_error = "Assign of object: " + ip_object_name + " Failed. Workspace item locked by another user".
    RETURN.
  END.
  IF NOT AVAILABLE lb_rvm_workspace_item THEN
  DO:
    CREATE lb_rvm_workspace_item NO-ERROR.
    {af/sup2/afcheckerr.i &no-return = YES}
    IF cMessageList <> "":U THEN 
    DO:
      ASSIGN op_error = cMessageList.
      RETURN.
    END.
  END.

  ASSIGN
     lb_rvm_workspace_item.workspace_obj = ip_workspace_obj
     lb_rvm_workspace_item.configuration_type = ip_configuration_type
     lb_rvm_workspace_item.scm_object_name = ip_object_name
     lb_rvm_workspace_item.item_version_number = ip_version_number
     lb_rvm_workspace_item.product_module_obj = ip_product_module_obj
     lb_rvm_workspace_item.task_product_module_obj = 0
     lb_rvm_workspace_item.task_version_number = 0
     .

  /* Force validation triggers to fire */
  VALIDATE lb_rvm_workspace_item NO-ERROR.
  {af/sup2/afcheckerr.i &no-return = YES}
  IF cMessageList <> "":U THEN 
  DO:
    ASSIGN op_error = cMessageList.
    RETURN.
  END.

  /* Now get rid of any deleted items for this object */

  FOR EACH lb_rvt_deleted_item EXCLUSIVE-LOCK
     WHERE lb_rvt_deleted_item.workspace_obj = ip_workspace_obj
       AND lb_rvt_deleted_item.configuration_type = ip_configuration_type
       AND lb_rvt_deleted_item.scm_object_name = ip_object_name
       AND lb_rvt_deleted_item.product_module_obj = ip_product_module_obj:


    DELETE lb_rvt_deleted_item NO-ERROR.
    {af/sup2/afcheckerr.i &no-return = YES}
    IF cMessageList <> "":U THEN 
    DO:
      ASSIGN op_error = cMessageList.
      RETURN.
    END.
  END.

END.

RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-createDataItem) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE createDataItem Procedure 
PROCEDURE createDataItem :
/*------------------------------------------------------------------------------
  Purpose:     The purpose of this procedure is to recreate an item of data in
               a database for the specified item version, using the data in the
               transaction and action tables, starting from the most recent
               baseline version and applying all changes upto the current
               version being created.
  Parameters:  input rowid of item version to create data for
               output error message text if any
  Notes:       Before an item of data can be created, the original data item
               must first be deleted if it exists.
               We must also ensure the replication triggers do not fire during
               the recreation of the data, as we are simply assigning new
               data into the workspace, rather than modifying data that should
               be versioned.
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER  ip_rowid                  AS ROWID      NO-UNDO.
DEFINE OUTPUT PARAMETER op_error                  AS CHARACTER  NO-UNDO.

DEFINE VARIABLE lv_version_list                   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE lv_module_list                    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE lv_previous_version               AS INTEGER    NO-UNDO.
DEFINE VARIABLE lv_previous_module                AS DECIMAL    NO-UNDO.
DEFINE VARIABLE lv_baseline                       AS LOGICAL    NO-UNDO.
DEFINE VARIABLE lv_loop                           AS INTEGER    NO-UNDO.
DEFINE VARIABLE lv_idx                            AS INTEGER    NO-UNDO.

DEFINE VARIABLE lh_buffer                         AS HANDLE     NO-UNDO.
DEFINE VARIABLE lh_field                          AS HANDLE     NO-UNDO.
DEFINE VARIABLE lh_query                          AS HANDLE     NO-UNDO.
DEFINE VARIABLE lv_query_string                   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE lv_ok                             AS LOGICAL    NO-UNDO.
DEFINE VARIABLE lv_action_underway_rowid          AS ROWID      NO-UNDO.
DEFINE VARIABLE lSame                             AS LOGICAL    NO-UNDO.
DEFINE VARIABLE cError                            AS CHARACTER  NO-UNDO.

DEFINE BUFFER lb1_rvt_item_version FOR rvt_item_version.
DEFINE BUFFER lb2_rvt_item_version FOR rvt_item_version.
DEFINE BUFFER lb_rvt_action_underway FOR rvt_action_underway.

FIND FIRST lb1_rvt_item_version NO-LOCK
     WHERE ROWID(lb1_rvt_item_version) = ip_rowid
     NO-ERROR.
IF NOT AVAILABLE lb1_rvt_item_version THEN
DO:
  ASSIGN op_error = "Re-create data item failed. Could not find item version record for data.".
  RETURN.
END.

FIND FIRST rvc_configuration_type NO-LOCK
     WHERE rvc_configuration_type.configuration_type = lb1_rvt_item_version.configuration_type
     NO-ERROR.
IF NOT AVAILABLE rvc_configuration_type THEN
DO:
  ASSIGN op_error = "Could not find configuaryion type: " + lb1_rvt_item_version.configuration_type.
  RETURN.
END.

/* Initiate the list of versions required to rebuild the data starting with the
   version being created.
*/
ASSIGN
  lv_version_list = STRING(lb1_rvt_item_version.item_version_number)
  lv_module_list = STRING(lb1_rvt_item_version.product_module_obj)
  .

/* If this is not a baseline version, read from the current version through all
   previous versions until we reach a baseline version, keeping a track of all
   the version numbers required
*/
ASSIGN
  lv_baseline = lb1_rvt_item_version.baseline_version
  lv_previous_version = lb1_rvt_item_version.previous_version_number
  lv_previous_module = lb1_rvt_item_version.previous_product_module_obj
  .
version-loop:
DO WHILE lv_baseline = NO AND lv_previous_version > 0:
  FIND FIRST lb2_rvt_item_version NO-LOCK
       WHERE lb2_rvt_item_version.configuration_type = lb1_rvt_item_version.configuration_type
         AND lb2_rvt_item_version.scm_object_name = lb1_rvt_item_version.scm_object_name
         AND lb2_rvt_item_version.product_module_obj = lv_previous_module
         AND lb2_rvt_item_version.item_version_number = lv_previous_version
       NO-ERROR.
  IF NOT AVAILABLE lb2_rvt_item_version THEN LEAVE version-loop.

  ASSIGN
    lv_version_list = lv_version_list + ",":U + STRING(lb2_rvt_item_version.item_version_number)
    lv_module_list = lv_module_list + ",":U + STRING(lb2_rvt_item_version.product_module_obj)
    .  

  ASSIGN
    lv_baseline = lb2_rvt_item_version.baseline_version
    lv_previous_version = lb2_rvt_item_version.previous_version_number
    lv_previous_module = lb2_rvt_item_version.previous_product_module_obj
    .
END.

IF lv_baseline = NO THEN
DO:
  ASSIGN op_error = "Could not find baseline version for object: " + lb1_rvt_item_version.scm_object_name + " Module: " + STRING(lb1_rvt_item_version.product_module_obj) + " Version: " + STRING(lb1_rvt_item_version.ITEM_version_number).
  RETURN.
END.

/* Found list of versions required to rebuild data, process list in reverse sequence,
   i.e. starting from baseline and working forwards
*/

/* but first delete the existing item of data */
ASSIGN
  lv_query_string = "FOR EACH ":U + rvc_configuration_type.type_table_name + " NO-LOCK WHERE ":U +
                    rvc_configuration_type.type_table_name + ".":U + rvc_configuration_type.scm_identifying_fieldname + " = '" +
                    lb1_rvt_item_version.scm_object_name + "'":U.

/* Create a dynamic buffer / query to find the item */
CREATE BUFFER lh_buffer FOR TABLE rvc_configuration_type.type_table_name NO-ERROR.
IF ERROR-STATUS:ERROR THEN
DO:
  ASSIGN op_error = "Could not create buffer for table: " + rvc_configuration_type.type_table_name.
  RETURN.  
END.
CREATE QUERY lh_query.
lh_query:ADD-BUFFER(lh_buffer).
lv_query_string = DYNAMIC-FUNCTION("fixQueryString":U IN gshSessionManager, INPUT lv_query_string).
lh_query:QUERY-PREPARE(lv_query_string) NO-ERROR.
lh_query:QUERY-OPEN() NO-ERROR.
lh_query:GET-FIRST() NO-ERROR.

ASSIGN op_error = "":U.

/* Disable replication during the deletion and recreation of the data */
RUN disableAssignReplication (INPUT lb1_rvt_item_version.configuration_type,
                              INPUT lb1_rvt_item_version.scm_object_name,
                              OUTPUT lv_action_underway_rowid,
                              OUTPUT op_error).
IF op_error <> "":U THEN RETURN.

/* If we have the item - delete it */
IF lh_buffer:AVAILABLE THEN
  op_error = deleteBuffer(lh_buffer).        

/* tidy up */
lh_buffer:BUFFER-RELEASE() NO-ERROR.
lh_query:QUERY-CLOSE() NO-ERROR.
DELETE OBJECT lh_query NO-ERROR.
DELETE OBJECT lh_buffer NO-ERROR.
ASSIGN
  lh_query = ?
  lh_buffer = ?
  .

IF op_error <> "":U THEN
DO:
  RUN enableAssignReplication  (INPUT lv_action_underway_rowid, OUTPUT cError).
  IF cError <> "":U THEN
    ASSIGN op_error = op_error + " ":U + cError.
  RETURN.
END.

/* tidy up deletion underway record - Created by delete trigger */
DO FOR lb_rvt_action_underway:
  FIND FIRST lb_rvt_action_underway EXCLUSIVE-LOCK
       WHERE lb_rvt_action_underway.action_type = "DEL":U
         AND lb_rvt_action_underway.action_table_fla = lb1_rvt_item_version.configuration_type
         AND lb_rvt_action_underway.action_scm_object_name = lb1_rvt_item_version.scm_object_name
       NO-ERROR.
  IF AVAILABLE lb_rvt_action_underway THEN
  DO:
    DELETE lb_rvt_action_underway NO-ERROR.
    {af/sup2/afcheckerr.i &no-return = YES}
    IF cMessageList <> "":U THEN 
    DO:
      ASSIGN op_error = cMessageList.
      RETURN.
    END.
  END.
END.

/* now recreate the data from the baseline */
DO lv_loop = NUM-ENTRIES(lv_version_list) TO 1 BY -1:

  /* get item version from which to read data */
  FIND FIRST lb2_rvt_item_version NO-LOCK
     WHERE lb2_rvt_item_version.configuration_type = lb1_rvt_item_version.configuration_type
       AND lb2_rvt_item_version.scm_object_name = lb1_rvt_item_version.scm_object_name
       AND lb2_rvt_item_version.product_module_obj = DECIMAL(ENTRY(lv_loop, lv_module_list))
       AND lb2_rvt_item_version.item_version_number = INTEGER(ENTRY(lv_loop, lv_version_list))
     NO-ERROR.
  /****
  MESSAGE {&line-number} PROGRAM-NAME(1) SKIP
      "version" INTEGER(ENTRY(lv_loop, lv_version_list)).
  ****/

  /* Reconstruct data for this item version */
  FOR EACH rvt_transaction NO-LOCK
     WHERE rvt_transaction.configuration_type = lb2_rvt_item_version.configuration_type
       AND rvt_transaction.scm_object_name = lb2_rvt_item_version.scm_object_name
       AND rvt_transaction.product_module_obj = lb2_rvt_item_version.product_module_obj
       AND rvt_transaction.item_version_number = lb2_rvt_item_version.item_version_number,
      EACH rvt_action NO-LOCK
     WHERE rvt_action.task_number = rvt_transaction.task_number
       AND rvt_action.transaction_id = rvt_transaction.transaction_id
     BY rvt_transaction.transaction_id
     BY rvt_action.action_obj:  

    /****
    IF  lb2_rvt_item_version.item_version_number > 010000 THEN
      MESSAGE {&line-number} PROGRAM-NAME(1) SKIP
          "table" rvt_action.table_name SKIP
          "event" rvt_action.event_name SKIP
          "key fields" rvt_action.primary_key_fields SKIP
          "key values" rvt_action.primary_key_values.
    ****/

    /* got event, table and data - do something with it */
    IF rvt_action.event_name BEGINS "DEL":U THEN
    DO:
      /* Create a dynamic buffer / query to find the item */
      CREATE BUFFER lh_buffer FOR TABLE rvt_action.table_name NO-ERROR.
      IF ERROR-STATUS:ERROR THEN
      DO:
        RUN enableAssignReplication  (INPUT lv_action_underway_rowid, OUTPUT op_error).
        ASSIGN op_error = op_error + "Could not create buffer for table: " + rvt_action.table_name.
        RETURN.  
      END.

      ASSIGN
        lv_query_string = "FOR EACH ":U + rvt_action.table_name + " NO-LOCK WHERE ":U.

      DO lv_idx = 1 TO NUM-ENTRIES(rvt_action.primary_key_fields):
          IF lv_idx > 1 THEN lv_query_string = lv_query_string + " AND ":U.
          lv_query_string = lv_query_string + rvt_action.table_name + ".":U + ENTRY(lv_idx,rvt_action.primary_key_fields) + " = " + ENTRY(lv_idx,rvt_action.primary_key_values,CHR(3)) + " ".                                                                                                                                  
      END.

      CREATE QUERY lh_query.
      lh_query:ADD-BUFFER(lh_buffer).

      lv_query_string = DYNAMIC-FUNCTION("fixQueryString":U IN gshSessionManager, INPUT lv_query_string).
      lh_query:QUERY-PREPARE(lv_query_string) NO-ERROR.
      lh_query:QUERY-OPEN() NO-ERROR.
      lh_query:GET-FIRST() NO-ERROR.

      ASSIGN op_error = "":U.

      /* If we have the item - delete it */
      IF lh_buffer:AVAILABLE THEN
          op_error = deleteBuffer(lh_buffer).        

      /* tidy up */
      lh_buffer:BUFFER-RELEASE() NO-ERROR.
      lh_query:QUERY-CLOSE() NO-ERROR.
      DELETE OBJECT lh_query NO-ERROR.
      DELETE OBJECT lh_buffer NO-ERROR.
      ASSIGN
        lh_query = ?
        lh_buffer = ?
        .

      IF op_error <> "":U THEN
      DO:
        RUN enableAssignReplication  (INPUT lv_action_underway_rowid, OUTPUT cError).
        IF cError <> "":U THEN
          ASSIGN op_error = op_error + " ":U + cError.
        RETURN.      
      END.

    END. /* delete action */
    ELSE
    DO: /* create / update action */
      ASSIGN
        lh_buffer = BUFFER rvt_action:HANDLE
        lh_field = lh_buffer:BUFFER-FIELD("raw_data":U)
        NO-ERROR
        .
      IF NOT VALID-HANDLE(lh_field) THEN
      DO:
        RUN enableAssignReplication  (INPUT lv_action_underway_rowid, OUTPUT op_error).
        ASSIGN op_error = op_error + "Could not locate raw_data field handle".
        RETURN.  
      END.

      CREATE BUFFER lh_buffer FOR TABLE rvt_action.table_name NO-ERROR.
      IF NOT VALID-HANDLE(lh_buffer) OR ERROR-STATUS:ERROR THEN
      DO:
        RUN enableAssignReplication  (INPUT lv_action_underway_rowid, OUTPUT op_error).
        ASSIGN op_error = op_error + "Could not create buffer for table: " + rvt_action.table_name.
        RETURN.  
      END.

      /* First see if data exists and make buffer available if it does */
      ASSIGN
        lv_query_string = "FOR EACH ":U + rvt_action.table_name + " NO-LOCK WHERE ":U.

      DO lv_idx = 1 TO NUM-ENTRIES(rvt_action.primary_key_fields):
          IF lv_idx > 1 THEN lv_query_string = lv_query_string + " AND ":U.
          lv_query_string = lv_query_string + rvt_action.table_name + ".":U + ENTRY(lv_idx,rvt_action.primary_key_fields) + " = " + ENTRY(lv_idx,rvt_action.primary_key_values,CHR(3)) + " ".                                                                                                                                  
      END.

      CREATE QUERY lh_query.
      lh_query:ADD-BUFFER(lh_buffer).
      lv_query_string = DYNAMIC-FUNCTION("fixQueryString":U IN gshSessionManager, INPUT lv_query_string).
      lh_query:QUERY-PREPARE(lv_query_string) NO-ERROR.
      lh_query:QUERY-OPEN() NO-ERROR.
      lh_query:GET-FIRST() NO-ERROR.

      ASSIGN 
        op_error = "":U
        lSame = NO
        .

      /* If we have the item - exclusive lock it */
      IF lh_buffer:AVAILABLE THEN
      DO:
        /* See if data has changed, and if not, do nothing */
        DEFINE VARIABLE tthandle AS HANDLE.
        DEFINE VARIABLE lh_rawfield AS HANDLE.
        DEFINE VARIABLE bh AS HANDLE.
        CREATE TEMP-TABLE tthandle.
        tthandle:ADD-NEW-FIELD("raw_data","raw").
        tthandle:TEMP-TABLE-PREPARE("ttRaw").
        bh = tthandle:DEFAULT-BUFFER-HANDLE.
        bh:BUFFER-CREATE().     
        lh_buffer:RAW-TRANSFER(TRUE, bh:BUFFER-FIELD("raw_data")).  /* transfer table record into raw field */
        lh_rawfield = bh:BUFFER-FIELD("raw_data").
        IF lh_rawfield:BUFFER-VALUE = lh_field:BUFFER-VALUE THEN lSame = YES. ELSE lSame = NO.
        bh:BUFFER-RELEASE.
        DELETE OBJECT ttHandle NO-ERROR.
        DELETE OBJECT bh NO-ERROR.
        ASSIGN
          ttHandle = ?
          bh = ?.

        IF NOT lSame THEN
          op_error = exclusiveLockBuffer(lh_buffer).        
      END.

      IF op_error <> "":U THEN
      DO:
        RUN enableAssignReplication  (INPUT lv_action_underway_rowid, OUTPUT cError).
        IF cError <> "":U THEN
          ASSIGN op_error = op_error + " ":U + cError.
        RETURN.  
      END.

      /* Raw transfer data into buffer */
      IF NOT lSame AND VALID-HANDLE(lh_buffer) AND VALID-HANDLE(lh_field) THEN
      DO:
        raw-block:  
        DO ON ERROR UNDO raw-block, LEAVE raw-block:
          lv_ok = lh_buffer:RAW-TRANSFER(FALSE, lh_field).  /* transfer raw field into table record */
        END.

        /****
        IF  lb2_rvt_item_version.item_version_number > 010000 THEN DO:

            MESSAGE {&line-number} PROGRAM-NAME(1) SKIP
            ERROR-STATUS:ERROR
                lh_buffer:AVAILABLE
                lh_buffer:NEW
                lh_buffer:TABLE
                lh_buffer:NAME
                lh_buffer:NUM-FIELDS
                lh_buffer:DBNAME
                PDBNAME((lh_buffer:DBNAME)).
            DEFINE VARIABLE lfield AS HANDLE     NO-UNDO.
            IF lh_buffer:NUM-FIELDS = 14 THEN
            DO lv_idx = 1 TO lh_buffer:NUM-FIELDS:
                lfield = lh_buffer:BUFFER-FIELD(lv_idx).
                MESSAGE {&line-number} PROGRAM-NAME(1) SKIP
                    lfield:NAME " = " lfield:BUFFER-VALUE.
            END.
        END.
        ****/        
        IF NOT lv_ok THEN
        DO:
          RUN enableAssignReplication  (INPUT lv_action_underway_rowid, OUTPUT op_error).
          DELETE OBJECT lh_buffer NO-ERROR.
          ASSIGN
            op_error = op_error + "Raw transfer of new data failed"
            lh_buffer = ?.
          RETURN.          
        END.
        ELSE DO: 

            release-block:  
            DO ON ERROR UNDO release-block, LEAVE release-block:
                lv_ok = lh_buffer:BUFFER-RELEASE() NO-ERROR.
            END.

            IF NOT lv_ok OR RETURN-VALUE <> "":U THEN DO:
                IF RETURN-VALUE <> "":U THEN 
                    ASSIGN
                        op_error = RETURN-VALUE.
                    ELSE 
                        ASSIGN
                            op_error = "Error in createDataItem after buffer-release of new data".
                RUN enableAssignReplication  (INPUT lv_action_underway_rowid, OUTPUT cError).
                IF cError <> "":U THEN
                  ASSIGN op_error = op_error + " ":U + cError.
                DELETE OBJECT lh_buffer NO-ERROR.
                ASSIGN lh_buffer = ?.
                RETURN.
            END.

        END.
      END.
      ELSE IF NOT lSame THEN
      DO:
        RUN enableAssignReplication  (INPUT lv_action_underway_rowid, OUTPUT op_error).
        ASSIGN op_error = op_error + "Invalid buffer / field handles".
        RETURN.  
      END.
      DELETE OBJECT lh_buffer NO-ERROR.
      ASSIGN lh_buffer = ?.

    END. /* create / update action */

  END. /* for each */

END. /* loop around version list */

RUN enableAssignReplication  (INPUT lv_action_underway_rowid, OUTPUT op_error).

RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-disableAssignReplication) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disableAssignReplication Procedure 
PROCEDURE disableAssignReplication :
/*------------------------------------------------------------------------------
  Purpose:     To create a record in the assignment action under table indicating
               that an assignment of data for this data item is in progress, and
               therefore ensuring that replication triggers do not fire to create
               a version history of this.
  Parameters:  input action table FLA
               input action scm object name
               output rowid of created record
               output error message text if any
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER  ip_fla                    AS CHARACTER  NO-UNDO.
DEFINE INPUT PARAMETER  ip_scm_object_name        AS CHARACTER  NO-UNDO.
DEFINE OUTPUT PARAMETER op_rowid                  AS ROWID      NO-UNDO.
DEFINE OUTPUT PARAMETER op_error                  AS CHARACTER  NO-UNDO.

DEFINE BUFFER lb_rvt_action_underway FOR rvt_action_underway.

DO FOR lb_rvt_action_underway:

  FIND FIRST lb_rvt_action_underway EXCLUSIVE-LOCK
       WHERE lb_rvt_action_underway.action_type = "ASS":U
         AND lb_rvt_action_underway.action_table_fla = ip_fla
         AND lb_rvt_action_underway.action_scm_object_name = ip_scm_object_name
       NO-ERROR.
  IF NOT AVAILABLE lb_rvt_action_underway THEN
  DO:
    CREATE lb_rvt_action_underway NO-ERROR.
    {af/sup2/afcheckerr.i &no-return = YES}
    IF cMessageList <> "":U THEN 
    DO:
      ASSIGN op_error = cMessageList.
      RETURN.
    END.
  END.

  ASSIGN
    lb_rvt_action_underway.action_type = "ASS":U
    lb_rvt_action_underway.action_table_fla = ip_fla
    lb_rvt_action_underway.action_primary_key = "":U    
    lb_rvt_action_underway.action_scm_object_name = ip_scm_object_name
    .  

  VALIDATE lb_rvt_action_underway NO-ERROR.
  {af/sup2/afcheckerr.i &no-return = YES}
  IF cMessageList <> "":U THEN 
  DO:
    ASSIGN op_error = cMessageList.
    RETURN.
  END.

  ASSIGN
    op_rowid = ROWID(lb_rvt_action_underway)
    .

END.

RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-enableAssignReplication) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enableAssignReplication Procedure 
PROCEDURE enableAssignReplication :
/*------------------------------------------------------------------------------
  Purpose:     To remove an action underway record which was created during
               the assignment of data into a workspace by the
               disableAssignReplication procedure.
  Parameters:  input rowid of action underway table
  Notes:       Ignore any errors if this does not exist anymore.
               Also, the deletion really can not fail in anyway so this code
               does not contain standard error handling, etc.
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER ip_rowid AS ROWID NO-UNDO.
DEFINE OUTPUT PARAMETER op_error AS CHARACTER NO-UNDO.

DEFINE BUFFER lb_rvt_action_underway FOR rvt_action_underway.

DO FOR lb_rvt_action_underway:
  FIND FIRST lb_rvt_action_underway EXCLUSIVE-LOCK
       WHERE ROWID(lb_rvt_action_underway) = ip_rowid
       NO-ERROR.
  IF AVAILABLE lb_rvt_action_underway THEN
  DO:
    DELETE lb_rvt_action_underway NO-ERROR.
    {af/sup2/afcheckerr.i &no-return = YES}
    IF cMessageList <> "":U THEN 
    DO:
      ASSIGN op_error = cMessageList.
      RETURN.
    END.
  END.
END.

RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-deleteBuffer) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION deleteBuffer Procedure 
FUNCTION deleteBuffer RETURNS CHARACTER
  (ip_buffer AS HANDLE) :
/*----------------------------------------------------------------------------
  Purpose: Delete a buffer record - after upgrade lock to exclusive.  
Parameter: The BUFFER's handle.   
    Notes: 
-----------------------------------------------------------------------------*/
  DEFINE VARIABLE lv_error AS CHARACTER NO-UNDO.

  lv_error = exclusiveLockBuffer(ip_buffer).

  DEFINE VARIABLE lv_ok AS LOGICAL NO-UNDO.

  IF lv_error = "":U THEN
  DO:    
    DO ON ERROR UNDO, LEAVE: 
      lv_error = "Failed to delete buffer":U.
      lv_ok = ip_buffer:BUFFER-DELETE NO-ERROR.  
      lv_error = "":U.
    END.
    IF lv_ok = NO THEN
    DO:
      IF RETURN-VALUE <> "":U THEN ASSIGN lv_error = RETURN-VALUE.
    END.

    RETURN lv_error. 
  END. /* if exclusive-lock*/

  ELSE 
    RETURN lv_error.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-exclusiveLockBuffer) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION exclusiveLockBuffer Procedure 
FUNCTION exclusiveLockBuffer RETURNS CHARACTER
  (ip_buffer AS HANDLE):
/*------------------------------------------------------------------------------
  Purpose: Exclusive Lock a buffer in the query.   
Parameter: The BUFFER's handle.   
    Notes: 
------------------------------------------------------------------------------*/    
   DEFINE VARIABLE lv_rowid AS ROWID NO-UNDO.

   IF ip_buffer:ROWID <> ? THEN
   DO:
     lv_rowid = ip_buffer:ROWID.
     ip_buffer:FIND-BY-ROWID(ip_buffer:ROWID, EXCLUSIVE-LOCK, NO-WAIT). 

     IF ip_buffer:CURRENT-CHANGED THEN 
     DO:
       ip_buffer:FIND-BY-ROWID(lv_rowid, NO-LOCK). 
       RETURN "Could not exclusive lock buffer - record changed by another user".
     END. /* changed */

     IF ip_buffer:LOCKED THEN 
     DO:
       ip_buffer:FIND-BY-ROWID(lv_rowid, NO-LOCK). 
       RETURN "Could not exclusive lock buffer - record locked by another user".
     END. /* locked */

     IF ip_buffer:AVAILABLE = FALSE THEN 
     DO:
       RETURN "Could not exclusive lock buffer - record not available".
     END. /* avail = false */ 

     RETURN "":U.   /* Function return value. */
   END. /* rowid <> ? */
   ELSE 
     RETURN "Could not exclusive lock buffer - no record available".

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-updateBufferField) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION updateBufferField Procedure 
FUNCTION updateBufferField RETURNS CHARACTER
  ( ip_buffer_handle AS HANDLE,
    ip_fieldname AS CHARACTER,
    ip_fieldvalue AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  This function will get an exclusive lock on the buffer passed in
            and assign the new field value to the specified field.
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE lv_error AS CHARACTER NO-UNDO.

  DEFINE VARIABLE h_buffer_field AS HANDLE NO-UNDO.

  ASSIGN
      h_buffer_field = ip_buffer_handle:BUFFER-FIELD(ip_fieldname)
      NO-ERROR.

  IF ERROR-STATUS:ERROR THEN RETURN "Field not found in buffer - update of value failed".

  lv_error = exclusiveLockBuffer(ip_buffer_handle).
  IF lv_error <> "":U THEN RETURN lv_error.

  IF VALID-HANDLE(h_buffer_field) THEN
  DO ON ERROR UNDO, LEAVE: 
    lv_error = "Failed to update field":U.

    CASE h_buffer_field:DATA-TYPE:
      WHEN "character":U THEN
      DO:
        h_buffer_field:BUFFER-VALUE() = ip_fieldvalue NO-ERROR.
        IF ERROR-STATUS:ERROR THEN RETURN "Failed to assign field value".
      END.
      WHEN "integer":U THEN
      DO:
        h_buffer_field:BUFFER-VALUE() = INTEGER(ip_fieldvalue) NO-ERROR.
        IF ERROR-STATUS:ERROR THEN RETURN "Failed to assign field value".
      END.
      WHEN "decimal":U THEN
      DO:
        h_buffer_field:BUFFER-VALUE() = DECIMAL(ip_fieldvalue) NO-ERROR.
        IF ERROR-STATUS:ERROR THEN RETURN "Failed to assign field value".
      END.
      WHEN "date":U THEN
      DO:
        h_buffer_field:BUFFER-VALUE() = DATE(ip_fieldvalue) NO-ERROR.
        IF ERROR-STATUS:ERROR THEN RETURN "Failed to assign field value".
      END.
    END CASE.

    lv_error = "":U.
  END.

  RETURN lv_error.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

