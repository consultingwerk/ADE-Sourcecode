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
  File: rvbaslinep.p

  Description:  Basline RV object code

  Purpose:      Noddy Procedure to create a new baseline object in RV system. This is
                designed to be run manually from the command line. A utility for baselining
                multiple objects exists called rvbaseassw.w which runs rvbaseassp.p - use
                this if you can rather than this one. To use this one, do the following:
                1. Create a task
                2. Check the logical object out in your task.
                3. Do NOT make any manual changes to the object in this task.
                4. From the procedure window, run rv/prc/rvbaslinep.p passing in an
                input parameter of the object you wish to baseline, e.g.
                RUN rv/prc/rvbaslinep.p (INPUT "rycagobjcw.ado").
                5. Note that you must specify the .ado extension for logical objects.
                6. Note SDO's also have attributes and can be baselined again using this
                method.
                7. Check your object in or complete the task.

  Parameters:   input object name (no path but with .ado extension if logical)

  History:
  --------
  (v:010000)    Task:        6525   UserRef:    
                Date:   21/08/2000  Author:     Anthony Swindells

  Update Notes: Created from Template rytemprocp.p

  (v:010001)    Task:        7361   UserRef:    
                Date:   20/12/2000  Author:     Anthony Swindells

  Update Notes: Allow product module changes in RV and track changes

--------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       rvbaslinep.p
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    010001


/* Astra object identifying preprocessor */
&glob   AstraProcedure    yes

{af/sup2/afglobals.i}

DEFINE INPUT PARAMETER pcObjectName  AS CHARACTER  NO-UNDO.

{rtb/g/rtbglobl.i}

DEFINE VARIABLE cWorkspace                            AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cConfigurationType                    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE hScmTool                              AS HANDLE     NO-UNDO.    
DEFINE VARIABLE iTaskNumber                           AS INTEGER    NO-UNDO. 
DEFINE VARIABLE iTransactionId                        AS INTEGER    NO-UNDO.
DEFINE VARIABLE lObjectExists                         AS LOGICAL    NO-UNDO.
DEFINE VARIABLE lObjectExistsInWorkspace              AS LOGICAL    NO-UNDO.
DEFINE VARIABLE iVersionInWorkspace                   AS INTEGER    NO-UNDO.
DEFINE VARIABLE cModuleInWorkspace                    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE lCheckedOutInWorkspace                AS LOGICAL    NO-UNDO.
DEFINE VARIABLE iVersionTaskNumber                    AS INTEGER    NO-UNDO. 
DEFINE VARIABLE iHighestVersion                       AS INTEGER    NO-UNDO. 

DEFINE VARIABLE cObjectSummary                        AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cObjectDescription                    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cObjectUpdNotes                       AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cObjectPrevVersions                   AS CHARACTER  NO-UNDO.

DEFINE BUFFER brvm_configuration_item FOR rvm_configuration_item.
DEFINE BUFFER brvt_workspace_checkout FOR rvt_workspace_checkout.
DEFINE BUFFER brvm_workspace_item FOR rvm_workspace_item.
DEFINE BUFFER bryc_smartobject FOR ryc_smartobject.
DEFINE BUFFER brvt_item_version FOR rvt_item_version.
DEFINE BUFFER brvt_transaction FOR rvt_transaction.
DEFINE BUFFER brvt_action FOR rvt_action.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



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
         HEIGHT             = 2
         WIDTH              = 40.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME




&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

ASSIGN
  iTaskNumber = grtb-task-num
  cWorkspace = grtb-wspace-id
  cConfigurationType = "RYCSO":U
  .

/* get scm info and ensure checked out, etc. */
RUN rtb/prc/afrtbprocp.p PERSISTENT SET hScmTool.

IF VALID-HANDLE(hScmTool) THEN
DO:
  RUN scmFullObjectInfo IN hScmTool (
      INPUT  pcObjectName,                     
      INPUT  cWorkspace,                  
      INPUT  0,
      OUTPUT lObjectExists,
      OUTPUT lObjectExistsInWorkspace,
      OUTPUT iVersionInWorkspace,           
      OUTPUT cModuleInWorkspace,           
      OUTPUT lCheckedOutInWorkspace,
      OUTPUT iVersionTaskNumber,
      OUTPUT iHighestVersion,      
      OUTPUT cObjectSummary,
      OUTPUT cObjectDescription,
      OUTPUT cObjectUpdNotes,
      OUTPUT cObjectPrevVersions
  ).
  RUN killPlip IN hScmTool.
END.

FIND FIRST rvm_workspace NO-LOCK
     WHERE rvm_workspace.workspace_code = cWorkspace
     NO-ERROR.
IF NOT AVAILABLE rvm_workspace THEN
DO:
  MESSAGE "Workspace could not be found in ICFDB: " + cWorkspace
    VIEW-AS ALERT-BOX.
  RETURN.
END.

FIND FIRST ryc_smartobject NO-LOCK
     WHERE ryc_smartobject.OBJECT_filename = REPLACE(pcObjectName,".ado":U,"":U)
     NO-ERROR.
IF NOT AVAILABLE ryc_smartobject THEN
DO:
  MESSAGE "Smartobject passed in could not be found in ICFDB: " + REPLACE(pcObjectName,".ado":U,"":U)
    VIEW-AS ALERT-BOX.
  RETURN.
END.

/* Try to baseline using product module in RTB */
FIND FIRST gsc_product_module NO-LOCK
     WHERE gsc_product_module.product_module_code = cModuleInWorkspace
     NO-ERROR.
IF NOT AVAILABLE gsc_product_module THEN
DO:
  MESSAGE "Could not find RTB product module in RVDB: " + cModuleInWorkspace.
  RETURN.
END.

IF NOT lCheckedOutInWorkspace THEN
DO:
  MESSAGE "object is not checked out in workspace".
  RETURN.
END.
IF iVersionTaskNumber <> iTaskNumber THEN
DO:
  MESSAGE "version is not checked out under current task".
  RETURN.
END.

trn-block:
DO FOR brvm_configuration_item, bryc_smartobject, brvm_workspace_item, brvt_workspace_checkout, brvt_item_version, brvt_transaction, brvt_action TRANSACTION ON ERROR UNDO trn-block, LEAVE trn-block:

  FIND FIRST brvm_configuration_item EXCLUSIVE-LOCK
       WHERE brvm_configuration_item.configuration_type = cConfigurationType
         AND brvm_configuration_item.scm_object_name = REPLACE(pcObjectName,".ado":U,"":U)
         AND brvm_configuration_item.product_module_obj = gsc_product_module.product_module_obj
       NO-ERROR.
  IF NOT AVAILABLE brvm_configuration_item THEN
    CREATE brvm_configuration_item NO-ERROR.

  ASSIGN
    brvm_configuration_item.configuration_type = cConfigurationType
    brvm_configuration_item.scm_object_name = REPLACE(pcObjectName,".ado":U,"":U)
    brvm_configuration_item.product_module_obj = gsc_product_module.product_module_obj
    brvm_configuration_item.ITEM_deployable = YES
    brvm_configuration_item.scm_registered = YES
    .
  VALIDATE brvm_configuration_item NO-ERROR.

  FIND FIRST brvt_item_version EXCLUSIVE-LOCK
       WHERE brvt_item_version.configuration_type = cConfigurationType
         AND brvt_item_version.scm_object_name = REPLACE(pcObjectName,".ado":U,"":U)
         AND brvt_item_version.ITEM_version_number = iVersionInWorkspace
         AND brvt_item_version.product_module_obj = gsc_product_module.product_module_obj
       NO-ERROR.

  IF NOT AVAILABLE brvt_item_version THEN
    CREATE brvt_item_version NO-ERROR.

  ASSIGN 
    iTransactionId = DBTASKID("RVDB":U).

  ASSIGN
    brvt_item_version.configuration_type = cConfigurationType
    brvt_item_version.scm_object_name = REPLACE(pcObjectName,".ado":U,"":U)
    brvt_item_version.ITEM_version_number = iVersionInWorkspace
    brvt_item_version.product_module_obj = gsc_product_module.product_module_obj
    brvt_item_version.task_number = iVersionTaskNumber
    brvt_item_version.baseline_version = YES
    brvt_item_version.previous_version_number = 0
    brvt_item_version.previous_product_module_obj = 0
    brvt_item_version.baseline_version_number = 0
    brvt_item_version.baseline_product_module_obj = 0
    brvt_item_version.versions_since_baseline = 0
    .
  IF cObjectSummary <> "":U THEN
    ASSIGN brvt_item_version.ITEM_description = cObjectSummary.

  VALIDATE brvt_item_version NO-ERROR.

  /* Update workspace item with correct details */
  FIND FIRST brvm_workspace_item EXCLUSIVE-LOCK
       WHERE brvm_workspace_item.workspace_obj = rvm_workspace.workspace_obj
         AND brvm_workspace_item.configuration_type = brvt_item_version.configuration_type
         AND brvm_workspace_item.scm_object_name = brvt_item_version.scm_object_name
         AND brvm_workspace_item.ITEM_version_number = brvt_item_version.ITEM_version_number
         AND brvm_workspace_item.product_module_obj = brvt_item_version.product_module_obj
       NO-ERROR.  
  IF NOT AVAILABLE brvm_workspace_item THEN
  DO:
    CREATE brvm_workspace_item NO-ERROR.
    ASSIGN
      brvm_workspace_item.workspace_obj = rvm_workspace.workspace_obj
      brvm_workspace_item.configuration_type = brvt_item_version.configuration_type
      brvm_workspace_item.scm_object_name = brvt_item_version.scm_object_name
      brvm_workspace_item.ITEM_version_number = brvt_item_version.ITEM_version_number
      brvm_workspace_item.product_module_obj = brvt_item_version.product_module_obj
      .  
  END.

  ASSIGN
    brvm_workspace_item.task_version_number = brvt_item_version.ITEM_version_number
    brvm_workspace_item.task_product_module_obj = brvt_item_version.product_module_obj
    .

  VALIDATE brvm_workspace_item NO-ERROR.        

  /* Ensure workspace check-out record exists */
  FIND FIRST brvt_workspace_checkout NO-LOCK
       WHERE brvt_workspace_checkout.workspace_item_obj = brvm_workspace_item.workspace_item_obj  
       NO-ERROR.  
  IF NOT AVAILABLE brvt_workspace_checkout THEN
  DO:
    CREATE brvt_workspace_checkout NO-ERROR.
    ASSIGN
       brvt_workspace_checkout.workspace_obj = brvm_workspace_item.workspace_obj
       brvt_workspace_checkout.task_number = iVersionTaskNumber
       brvt_workspace_checkout.configuration_type = brvm_workspace_item.configuration_type 
       brvt_workspace_checkout.workspace_item_obj = brvm_workspace_item.workspace_item_obj
       brvt_workspace_checkout.modification_type = "UNK":U
       .  
    VALIDATE brvt_workspace_checkout NO-ERROR.
  END.

  /* If product module is different then update smartobject for new product module */
  IF gsc_product_module.product_module_obj <> ryc_smartobject.product_module_obj THEN
  DO:
    FIND FIRST bryc_smartobject EXCLUSIVE-LOCK
         WHERE bryc_smartobject.OBJECT_filename = REPLACE(pcObjectName,".ado":U,"":U)
         NO-ERROR.
    ASSIGN bryc_smartobject.product_module_obj = gsc_product_module.product_module_obj.
    VALIDATE bryc_smartobject NO-ERROR.
    FIND FIRST ryc_smartobject EXCLUSIVE-LOCK
         WHERE ryc_smartobject.OBJECT_filename = REPLACE(pcObjectName,".ado":U,"":U)
         NO-ERROR.
  END.

  /* Zap existing transaction records first */
  FOR EACH brvt_transaction EXCLUSIVE-LOCK
      WHERE brvt_transaction.configuration_type   = brvt_item_version.configuration_type
      AND   brvt_transaction.scm_object_name      = brvt_item_version.scm_object_name
      AND   brvt_transaction.product_module_obj   = brvt_item_version.product_module_obj
      AND   brvt_transaction.item_version_number  = brvt_item_version.item_version_number:
    DELETE brvt_transaction NO-ERROR.
  END.

  /* Create / update transaction record */
  CREATE brvt_transaction NO-ERROR.
  ASSIGN 
      brvt_transaction.task_number            = iVersionTaskNumber
      brvt_transaction.transaction_id         = iTransactionId
      brvt_transaction.configuration_type     = brvt_item_version.configuration_type
      brvt_transaction.scm_object_name        = brvt_item_version.scm_object_name
      brvt_transaction.product_module_obj     = brvt_item_version.product_module_obj
      brvt_transaction.item_version_number    = brvt_item_version.item_version_number
      .
  VALIDATE brvt_transaction NO-ERROR.

  /* 1st action to create smartobject itself */

  CREATE brvt_action NO-ERROR.
  ASSIGN
      brvt_action.task_number = iVersionTaskNumber
      brvt_action.transaction_id = iTransactionId
      brvt_action.event_name = "CREATE":U
      brvt_action.TABLE_name = "ryc_smartobject"
      brvt_action.PRIMARY_key_fields = "smartobject_obj"
      brvt_action.PRIMARY_key_values = STRING(ryc_smartobject.object_obj)
      .
  RAW-TRANSFER ryc_smartobject TO brvt_action.raw_data.
  VALIDATE brvt_action NO-ERROR.

  /* actions to create related tables */ 
  FOR EACH ryc_page NO-LOCK 
     WHERE ryc_page.container_smartobject_obj = ryc_smartobject.smartobject_obj: 
    CREATE brvt_action NO-ERROR.
    ASSIGN
        brvt_action.task_number = iVersionTaskNumber
        brvt_action.transaction_id = iTransactionId
        brvt_action.event_name = "CREATE":U
        brvt_action.TABLE_name = "ryc_page"
        brvt_action.PRIMARY_key_fields = "container_smartobject_obj,page_obj"
        brvt_action.PRIMARY_key_values = STRING(ryc_page.container_smartobject_obj) + CHR(3) + STRING(ryc_page.page_obj)
        .
    RAW-TRANSFER ryc_page TO brvt_action.raw_data.
    VALIDATE brvt_action NO-ERROR.
  END.
  FOR EACH ryc_object_instance NO-LOCK
     WHERE ryc_object_instance.container_smartobject_obj = ryc_smartobject.smartobject_obj: 
    CREATE brvt_action NO-ERROR.
    ASSIGN
        brvt_action.task_number = iVersionTaskNumber
        brvt_action.transaction_id = iTransactionId
        brvt_action.event_name = "CREATE":U
        brvt_action.TABLE_name = "ryc_object_instance"
        brvt_action.PRIMARY_key_fields = "container_smartobject_obj,object_instance_obj"
        brvt_action.PRIMARY_key_values = STRING(ryc_object_instance.container_smartobject_obj) + CHR(3) + STRING(ryc_object_instance.object_instance_obj)
        .
    RAW-TRANSFER ryc_object_instance TO brvt_action.raw_data.
    VALIDATE brvt_action NO-ERROR.
  END.
  FOR EACH ryc_page_object NO-LOCK 
      WHERE ryc_page_object.container_smartobject_obj = ryc_smartobject.smartobject_obj:
    CREATE brvt_action NO-ERROR.
    ASSIGN
        brvt_action.task_number         = iVersionTaskNumber
        brvt_action.transaction_id      = iTransactionId
        brvt_action.event_name          = "CREATE":U
        brvt_action.table_name          = "ryc_page_object"
        brvt_action.primary_key_fields  = "page_object_obj"
        brvt_action.primary_key_values  = STRING(ryc_page_object.page_object_obj)
        .
    RAW-TRANSFER ryc_page_object TO brvt_action.raw_data.
    VALIDATE brvt_action NO-ERROR.
  END.
  FOR EACH ryc_smartlink NO-LOCK
     WHERE ryc_smartlink.container_smartobject_obj = ryc_smartobject.smartobject_obj:
    CREATE brvt_action NO-ERROR.
    ASSIGN
        brvt_action.task_number = iVersionTaskNumber
        brvt_action.transaction_id = iTransactionId
        brvt_action.event_name = "CREATE":U
        brvt_action.TABLE_name = "ryc_smartlink"
        brvt_action.PRIMARY_key_fields = "smartlink_obj"
        brvt_action.PRIMARY_key_values = STRING(ryc_smartlink.smartlink_obj)
        .
    RAW-TRANSFER ryc_smartlink TO brvt_action.raw_data.
    VALIDATE brvt_action NO-ERROR.
  END.
  FOR EACH ryc_smartobject_field NO-LOCK
     WHERE ryc_smartobject_field.smartobject_obj = ryc_smartobject.smartobject_obj:
    CREATE brvt_action NO-ERROR.
    ASSIGN
        brvt_action.task_number = iVersionTaskNumber
        brvt_action.transaction_id = iTransactionId
        brvt_action.event_name = "CREATE":U
        brvt_action.TABLE_name = "ryc_smartobject_field"
        brvt_action.PRIMARY_key_fields = "smartobject_field_obj"
        brvt_action.PRIMARY_key_values = STRING(ryc_smartobject_field.smartobject_field_obj)
        .
    RAW-TRANSFER ryc_smartobject_field TO brvt_action.raw_data.
    VALIDATE brvt_action NO-ERROR.
  END.
  FOR EACH ryc_custom_ui_trigger NO-LOCK
     WHERE ryc_custom_ui_trigger.smartobject_obj = ryc_smartobject.smartobject_obj:
    CREATE brvt_action NO-ERROR.
    ASSIGN
        brvt_action.task_number = iVersionTaskNumber
        brvt_action.transaction_id = iTransactionId
        brvt_action.event_name = "CREATE":U
        brvt_action.TABLE_name = "ryc_custom_ui_trigger"
        brvt_action.PRIMARY_key_fields = "custom_ui_trigger_obj"
        brvt_action.PRIMARY_key_values = STRING(ryc_custom_ui_trigger.custom_ui_trigger_obj)
        .
    RAW-TRANSFER ryc_custom_ui_trigger TO brvt_action.raw_data.
    VALIDATE brvt_action NO-ERROR.
  END.

  /* For attribute values - not supporting collections for now */
  /* Also this should do attributes for smartobject and instances for a container */
  FOR EACH ryc_attribute_value NO-LOCK
     WHERE ryc_attribute_value.primary_smartobject_obj = ryc_smartobject.smartobject_obj:
    CREATE brvt_action NO-ERROR.
    ASSIGN
        brvt_action.task_number = iVersionTaskNumber
        brvt_action.transaction_id = iTransactionId
        brvt_action.event_name = "CREATE":U
        brvt_action.TABLE_name = "ryc_attribute_value"
        brvt_action.PRIMARY_key_fields = "attribute_value_obj"
        brvt_action.PRIMARY_key_values = STRING(ryc_attribute_value.attribute_value_obj)
        .
    RAW-TRANSFER ryc_attribute_value TO brvt_action.raw_data.
    VALIDATE brvt_action NO-ERROR.
  END.

/*   do not think this is required */
/*   FOR EACH ryc_object_instance NO-LOCK                                                        */
/*      WHERE ryc_object_instance.container_smartobject_obj = ryc_smartobject.smartobject_obj,   */
/*       EACH ryc_attribute_value NO-LOCK                                                        */
/*      WHERE ryc_attribute_value.OBJECT_type_obj = ryc_smartobject.OBJECT_type_obj              */
/*        AND ryc_attribute_value.smartobject_obj = ryc_smartobject.smartobject_obj              */
/*        AND ryc_attribute_value.OBJECT_instance_obj = ryc_object_instance.OBJECT_instance_obj: */
/*     CREATE brvt_action NO-ERROR.                                                               */
/*     ASSIGN                                                                                    */
/*         brvt_action.task_number = iVersionTaskNumber                                                  */
/*         brvt_action.transaction_id = iTransactionId                                            */
/*         brvt_action.event_name = "CREATE":U                                                    */
/*         brvt_action.TABLE_name = "ryc_attribute_value"                                         */
/*         brvt_action.PRIMARY_key_fields = "attribute_value_obj"                                 */
/*         brvt_action.PRIMARY_key_values = STRING(ryc_attribute_value.attribute_value_obj)       */
/*         .                                                                                     */
/*     RAW-TRANSFER ryc_attribute_value TO brvt_action.raw_data.                                  */
/*     VALIDATE brvt_action NO-ERROR.                                                             */
/*   END.                                                                                        */
/*                                                                                               */

END. /* trn-block */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


