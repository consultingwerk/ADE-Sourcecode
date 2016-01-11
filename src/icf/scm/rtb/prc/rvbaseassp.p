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
  File: rvbaseassp.p

  Description:  Baseline RV object code
  
  Purpose:      Procedure to create new baseline data in RV system for selected objects,
                or fix integrity of RVdata to match RTB data.
                Can only modify procedure in procedure editor as they are too big for
                section editor.

  Parameters:

  History:
  --------
  (v:010000)    Task:        6525   UserRef:    
                Date:   21/08/2000  Author:     Anthony Swindells

  Update Notes: Created from Template rytemprocp.p

  (v:010002)    Task:        7361   UserRef:    
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

&scop object-name       rvbaseassp.p
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    010002


/* Astra object identifying preprocessor */
&glob   AstraProcedure    yes

{af/sup2/afglobals.i}

  {rtb/g/rtbglobl.i}

DEFINE TEMP-TABLE ttSmartObjects
       FIELD tfSWorkspace       AS CHARACTER
       FIELD tfSProductModule   AS CHARACTER
       FIELD tfSObjectName      AS CHARACTER
       FIELD tfSBaseOverride    AS LOGICAL
       FIELD tfSDeleteHistory   AS LOGICAL
       INDEX tiSMain            IS PRIMARY UNIQUE
              tfSObjectName
       .

{af/sup2/afcheckerr.i &define-only = YES}

DEFINE VARIABLE cObjectFileName             AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cConfigurationType          AS CHARACTER  NO-UNDO.
DEFINE VARIABLE hScmTool                    AS HANDLE     NO-UNDO.
DEFINE VARIABLE iTransactionId              AS INTEGER    NO-UNDO.
DEFINE VARIABLE lObjectExists               AS LOGICAL    NO-UNDO.
DEFINE VARIABLE lObjectExistsInWorkspace    AS LOGICAL    NO-UNDO.
DEFINE VARIABLE iVersionInWorkspace         AS INTEGER    NO-UNDO.
DEFINE VARIABLE cModuleInWorkspace          AS CHARACTER  NO-UNDO.
DEFINE VARIABLE lCheckedOutInWorkspace      AS LOGICAL    NO-UNDO.
DEFINE VARIABLE iVersionTaskNumber          AS INTEGER    NO-UNDO.
DEFINE VARIABLE iHighestVersion             AS INTEGER    NO-UNDO.
DEFINE VARIABLE cObjectSummary              AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cObjectDescription          AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cObjectUpdNotes             AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cObjectPrevVersions         AS CHARACTER  NO-UNDO.

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
         HEIGHT             = 7.91
         WIDTH              = 49.2.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME




&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-buildBaseline) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE buildBaseline Procedure 
PROCEDURE buildBaseline :
/*------------------------------------------------------------------------------
  Purpose:     Baseline selected objects - fix RV data
  Parameters:  <none>
  Notes:       Only works if object not checked out in SCM tool.
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER TABLE FOR ttSmartObjects.
  DEFINE OUTPUT PARAMETER cErrorOut           AS CHARACTER  NO-UNDO.

  DEFINE BUFFER brvm_workspace_item           FOR rvm_workspace_item.
  DEFINE BUFFER brvm_configuration_item       FOR rvm_configuration_item.
  DEFINE BUFFER brvt_item_version             FOR rvt_item_version.
  DEFINE BUFFER brvt_transaction              FOR rvt_transaction.
  DEFINE BUFFER brvt_action                   FOR rvt_action.
  DEFINE BUFFER brvt_workspace_checkout       FOR rvt_workspace_checkout.

  FIND FIRST rvc_configuration_type NO-LOCK
      WHERE  rvc_configuration_type.configuration_type = "RYCSO":U
      NO-ERROR.
  IF NOT AVAILABLE rvc_configuration_type
  THEN DO:
      ASSIGN cErrorOut = cErrorOut + "configuration type RYCSO does not exist. Baseline process cancelled":U + CHR(10).
      RETURN.
  END.
  ELSE ASSIGN cConfigurationType  = "RYCSO":U.

  RUN rtb/prc/afrtbprocp.p PERSISTENT SET hScmTool NO-ERROR.

  BlkSObase:
  FOR EACH ttSmartObjects NO-LOCK:

    FIND FIRST rvm_workspace NO-LOCK
        WHERE rvm_workspace.workspace_code = ttSmartObjects.tfSWorkspace
        NO-ERROR.
    IF NOT AVAILABLE rvm_workspace
    THEN DO:
        ASSIGN cErrorOut = cErrorOut + "Workspace not selected or not available for build of baseline versions" + CHR(10).
        NEXT BlkSObase.
    END.

    FIND FIRST gsc_product_module NO-LOCK
        WHERE gsc_product_module.product_module_code = ttSmartObjects.tfSProductModule
        NO-ERROR.
    IF NOT AVAILABLE gsc_product_module
    THEN DO:
        ASSIGN cErrorOut = cErrorOut + "Product module does not exist. Baseline cancelled for object " + TRIM(ttSmartObjects.tfSObjectName) + CHR(10).
        NEXT BlkSObase.
    END.

    FIND FIRST ryc_smartobject NO-LOCK
        WHERE ryc_smartobject.object_filename = ttSmartObjects.tfSObjectName
        NO-ERROR.
    IF NOT AVAILABLE ttSmartObjects
    THEN DO:
        ASSIGN cErrorOut = cErrorOut + "Object does not exist in ICFDB repository table. Baseline cancelled for object " + TRIM(ttSmartObjects.tfSObjectName) + CHR(10).
        NEXT BlkSObase.
    END.

    IF NUM-ENTRIES(ttSmartObjects.tfSObjectName,".":U) > 1
    AND LENGTH(ENTRY(NUM-ENTRIES(ttSmartObjects.tfSObjectName,".":U),ttSmartObjects.tfSObjectName,".":U)) <= 3
    THEN ASSIGN cObjectFileName = ttSmartObjects.tfSObjectName.
    ELSE ASSIGN cObjectFileName = ttSmartObjects.tfSObjectName + ".ado":U.

    /* get scm info and ensure not checked out, etc. */
    IF VALID-HANDLE(hScmTool)
    THEN DO:
        RUN scmFullObjectInfo IN hScmTool (
            INPUT  cObjectFileName,                     
            INPUT  ttSmartObjects.tfSWorkspace,                  
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
    END.

    IF NOT lObjectExists
    THEN DO:
        ASSIGN cErrorOut = cErrorOut + "Object does not exist in Roundtable. Baseline not allowed on object " + TRIM(ttSmartObjects.tfSObjectName) + CHR(10).
        NEXT BlkSObase.
    END.

    IF iVersionTaskNumber = 0 THEN
    DO:
      ASSIGN cErrorOut = cErrorOut + "Object version has 0 RTB task. Baseline not allowed on object " + TRIM(ttSmartObjects.tfSObjectName) + CHR(10).
      NEXT BlkSObase.
    END.

    IF lCheckedOutInWorkspace
    THEN DO:
        ASSIGN cErrorOut = cErrorOut + "Object is currently checked out in workspace. Baseline not allowed on object " + TRIM(ttSmartObjects.tfSObjectName) + CHR(10).
        NEXT BlkSObase.
    END.

    IF NOT ttSmartObjects.tfSBaseOverride
    THEN DO:
        FIND FIRST rvm_configuration_item NO-LOCK
            WHERE  rvm_configuration_item.configuration_type   = cConfigurationType
            AND    rvm_configuration_item.scm_object_name      = ttSmartObjects.tfSObjectName
            AND    rvm_configuration_item.product_module_obj   = gsc_product_module.product_module_obj
            NO-ERROR.
        IF AVAILABLE rvm_configuration_item
        THEN DO:
            FIND FIRST rvt_item_version NO-LOCK
                WHERE  rvt_item_version.configuration_type     = cConfigurationType
                AND    rvt_item_version.scm_object_name        = ttSmartObjects.tfSObjectName
                AND    rvt_item_version.item_version_number    = iVersionInWorkspace
                AND    rvt_item_version.product_module_obj     = gsc_product_module.product_module_obj
                NO-ERROR.
            IF AVAILABLE rvt_item_version
            AND rvt_item_version.baseline_version    = YES THEN NEXT BlkSObase.
        END.
    END.

    TrnBlock:
    DO FOR brvm_workspace_item, brvm_configuration_item, brvt_item_version, brvt_transaction, brvt_action TRANSACTION
           ON ERROR UNDO TrnBlock, LEAVE TrnBlock:

      FIND FIRST brvm_configuration_item EXCLUSIVE-LOCK
          WHERE  brvm_configuration_item.configuration_type   = cConfigurationType
          AND    brvm_configuration_item.scm_object_name      = ttSmartObjects.tfSObjectName
          AND    brvm_configuration_item.product_module_obj   = gsc_product_module.product_module_obj
          NO-ERROR.
      IF NOT AVAILABLE brvm_configuration_item
      THEN
      DO:
        CREATE brvm_configuration_item NO-ERROR.
        {af/sup2/afcheckerr.i &no-return = YES}
        IF cMessageList <> "":U THEN 
        DO:
          ASSIGN cErrorOut = cErrorOut + cMessageList + CHR(10).
          UNDO TrnBlock, LEAVE TrnBlock.
        END.
      END.
      ASSIGN
          brvm_configuration_item.configuration_type  = cConfigurationType
          brvm_configuration_item.scm_object_name     = ttSmartObjects.tfSObjectName
          brvm_configuration_item.product_module_obj  = gsc_product_module.product_module_obj
          brvm_configuration_item.item_deployable     = YES
          brvm_configuration_item.scm_registered      = YES
          .

      VALIDATE brvm_configuration_item NO-ERROR.
      {af/sup2/afcheckerr.i &no-return = YES}
      IF cMessageList <> "":U THEN 
      DO:
        ASSIGN cErrorOut = cErrorOut + cMessageList + CHR(10).
        UNDO TrnBlock, LEAVE TrnBlock.
      END.

      FIND FIRST brvt_item_version EXCLUSIVE-LOCK
          WHERE  brvt_item_version.configuration_type     = cConfigurationType
          AND    brvt_item_version.scm_object_name        = ttSmartObjects.tfSObjectName
          AND    brvt_item_version.item_version_number    = iVersionInWorkspace
          AND    brvt_item_version.product_module_obj     = gsc_product_module.product_module_obj
          NO-ERROR.
      IF NOT AVAILABLE brvt_item_version
      THEN
      DO:
        CREATE brvt_item_version NO-ERROR.
        {af/sup2/afcheckerr.i &no-return = YES}
        IF cMessageList <> "":U THEN 
        DO:
          ASSIGN cErrorOut = cErrorOut + cMessageList + CHR(10).
          UNDO TrnBlock, LEAVE TrnBlock.
        END.
      END.
      ASSIGN
          brvt_item_version.configuration_type        = cConfigurationType
          brvt_item_version.scm_object_name           = ttSmartObjects.tfSObjectName
          brvt_item_version.item_version_number       = iVersionInWorkspace
          brvt_item_version.product_module_obj        = gsc_product_module.product_module_obj
          brvt_item_version.task_number               = iVersionTaskNumber
          brvt_item_version.baseline_version          = YES
          brvt_item_version.previous_version_number   = 0
          brvt_item_version.previous_product_module_obj = 0
          brvt_item_version.baseline_version_number   = 0
          brvt_item_version.baseline_product_module_obj = 0
          brvt_item_version.versions_since_baseline   = 0
          .
      IF cObjectSummary <> "":U
      THEN
          ASSIGN
              brvt_item_version.item_description = cObjectSummary.

      VALIDATE brvt_item_version NO-ERROR.
      {af/sup2/afcheckerr.i &no-return = YES}
      IF cMessageList <> "":U THEN 
      DO:
        ASSIGN cErrorOut = cErrorOut + cMessageList + CHR(10).
        UNDO TrnBlock, LEAVE TrnBlock.
      END.

      FOR EACH brvt_transaction EXCLUSIVE-LOCK
          WHERE brvt_transaction.configuration_type   = cConfigurationType
          AND   brvt_transaction.scm_object_name      = ttSmartObjects.tfSObjectName
          AND   brvt_transaction.item_version_number  = brvt_item_version.item_version_number
          AND   brvt_transaction.product_module_obj   = brvt_item_version.product_module_obj
          :
          DELETE brvt_transaction NO-ERROR.
      END.

      /* Create / update transaction record */
      ASSIGN 
          iTransactionId = DBTASKID("RVDB":U).

      CREATE brvt_transaction NO-ERROR.
      {af/sup2/afcheckerr.i &no-return = YES}
      IF cMessageList <> "":U THEN 
      DO:
        ASSIGN cErrorOut = cErrorOut + cMessageList + CHR(10).
        UNDO TrnBlock, LEAVE TrnBlock.
      END.

      ASSIGN 
          brvt_transaction.task_number            = iVersionTaskNumber
          brvt_transaction.transaction_id         = iTransactionId
          brvt_transaction.configuration_type     = cConfigurationType
          brvt_transaction.scm_object_name        = ttSmartObjects.tfSObjectName
          brvt_transaction.item_version_number    = brvt_item_version.item_version_number
          brvt_transaction.product_module_obj   = brvt_item_version.product_module_obj          
          .
      VALIDATE brvt_transaction NO-ERROR.
      {af/sup2/afcheckerr.i &no-return = YES}
      IF cMessageList <> "":U THEN 
      DO:
        ASSIGN cErrorOut = cErrorOut + cMessageList + CHR(10).
        UNDO TrnBlock, LEAVE TrnBlock.
      END.

      CREATE brvt_action NO-ERROR.
      {af/sup2/afcheckerr.i &no-return = YES}
      IF cMessageList <> "":U THEN 
      DO:
        ASSIGN cErrorOut = cErrorOut + cMessageList + CHR(10).
        UNDO TrnBlock, LEAVE TrnBlock.
      END.

      ASSIGN
          brvt_action.task_number         = iVersionTaskNumber
          brvt_action.transaction_id      = iTransactionId
          brvt_action.event_name          = "CREATE":U
          brvt_action.table_name          = "ryc_smartobject"
          brvt_action.primary_key_fields  = "smartobject_obj"
          brvt_action.primary_key_values  = STRING(ryc_smartobject.object_obj)
          .
      RAW-TRANSFER ryc_smartobject TO brvt_action.raw_data.
      VALIDATE brvt_action NO-ERROR.
      {af/sup2/afcheckerr.i &no-return = YES}
      IF cMessageList <> "":U THEN 
      DO:
        ASSIGN cErrorOut = cErrorOut + cMessageList + CHR(10).
        UNDO TrnBlock, LEAVE TrnBlock.
      END.

      /* actions to create related tables */ 
      FOR EACH ryc_object_instance NO-LOCK
          WHERE ryc_object_instance.container_smartobject_obj = ryc_smartobject.smartobject_obj
          :
          CREATE brvt_action NO-ERROR.
          {af/sup2/afcheckerr.i &no-return = YES}
          IF cMessageList <> "":U THEN 
          DO:
            ASSIGN cErrorOut = cErrorOut + cMessageList + CHR(10).
            UNDO TrnBlock, LEAVE TrnBlock.
          END.
          ASSIGN
              brvt_action.task_number         = iVersionTaskNumber
              brvt_action.transaction_id      = iTransactionId
              brvt_action.event_name          = "CREATE":U
              brvt_action.table_name          = "ryc_object_instance"
              brvt_action.primary_key_fields  = "container_smartobject_obj,object_instance_obj"
              brvt_action.primary_key_values  = STRING(ryc_object_instance.container_smartobject_obj) + CHR(3) + STRING(ryc_object_instance.object_instance_obj)
              .
          RAW-TRANSFER ryc_object_instance TO brvt_action.raw_data.
          VALIDATE brvt_action NO-ERROR.
          {af/sup2/afcheckerr.i &no-return = YES}
          IF cMessageList <> "":U THEN 
          DO:
            ASSIGN cErrorOut = cErrorOut + cMessageList + CHR(10).
            UNDO TrnBlock, LEAVE TrnBlock.
          END.
      END.

      FOR EACH ryc_page NO-LOCK 
          WHERE ryc_page.container_smartobject_obj = ryc_smartobject.smartobject_obj
          :
          CREATE brvt_action NO-ERROR.
          {af/sup2/afcheckerr.i &no-return = YES}
          IF cMessageList <> "":U THEN 
          DO:
            ASSIGN cErrorOut = cErrorOut + cMessageList + CHR(10).
            UNDO TrnBlock, LEAVE TrnBlock.
          END.
          ASSIGN
              brvt_action.task_number         = iVersionTaskNumber
              brvt_action.transaction_id      = iTransactionId
              brvt_action.event_name          = "CREATE":U
              brvt_action.table_name          = "ryc_page"
              brvt_action.primary_key_fields  = "container_smartobject_obj,page_obj"
              brvt_action.primary_key_values  = STRING(ryc_page.container_smartobject_obj) + CHR(3) + STRING(ryc_page.page_obj)
              .
          RAW-TRANSFER ryc_page TO brvt_action.raw_data.
          VALIDATE brvt_action NO-ERROR.
          {af/sup2/afcheckerr.i &no-return = YES}
          IF cMessageList <> "":U THEN 
          DO:
            ASSIGN cErrorOut = cErrorOut + cMessageList + CHR(10).
            UNDO TrnBlock, LEAVE TrnBlock.
          END.
      END.

      FOR EACH ryc_page_object NO-LOCK 
          WHERE ryc_page_object.container_smartobject_obj = ryc_smartobject.smartobject_obj
          :
          CREATE brvt_action NO-ERROR.
          {af/sup2/afcheckerr.i &no-return = YES}
          IF cMessageList <> "":U THEN 
          DO:
            ASSIGN cErrorOut = cErrorOut + cMessageList + CHR(10).
            UNDO TrnBlock, LEAVE TrnBlock.
          END.
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
          {af/sup2/afcheckerr.i &no-return = YES}
          IF cMessageList <> "":U THEN 
          DO:
            ASSIGN cErrorOut = cErrorOut + cMessageList + CHR(10).
            UNDO TrnBlock, LEAVE TrnBlock.
          END.
      END.

      FOR EACH ryc_smartlink NO-LOCK
          WHERE ryc_smartlink.container_smartobject_obj = ryc_smartobject.smartobject_obj
          :
          CREATE brvt_action NO-ERROR.
          {af/sup2/afcheckerr.i &no-return = YES}
          IF cMessageList <> "":U THEN 
          DO:
            ASSIGN cErrorOut = cErrorOut + cMessageList + CHR(10).
            UNDO TrnBlock, LEAVE TrnBlock.
          END.
          ASSIGN
              brvt_action.task_number         = iVersionTaskNumber
              brvt_action.transaction_id      = iTransactionId
              brvt_action.event_name          = "CREATE":U
              brvt_action.table_name          = "ryc_smartlink"
              brvt_action.primary_key_fields  = "smartlink_obj"
              brvt_action.primary_key_values  = STRING(ryc_smartlink.smartlink_obj)
              .
          RAW-TRANSFER ryc_smartlink TO brvt_action.raw_data.
          VALIDATE brvt_action NO-ERROR.
          {af/sup2/afcheckerr.i &no-return = YES}
          IF cMessageList <> "":U THEN 
          DO:
            ASSIGN cErrorOut = cErrorOut + cMessageList + CHR(10).
            UNDO TrnBlock, LEAVE TrnBlock.
          END.
      END.

      FOR EACH ryc_smartobject_field NO-LOCK
          WHERE ryc_smartobject_field.smartobject_obj = ryc_smartobject.smartobject_obj
          :
          CREATE brvt_action NO-ERROR.
          {af/sup2/afcheckerr.i &no-return = YES}
          IF cMessageList <> "":U THEN 
          DO:
            ASSIGN cErrorOut = cErrorOut + cMessageList + CHR(10).
            UNDO TrnBlock, LEAVE TrnBlock.
          END.
          ASSIGN
              brvt_action.task_number         = iVersionTaskNumber
              brvt_action.transaction_id      = iTransactionId
              brvt_action.event_name          = "CREATE":U
              brvt_action.table_name          = "ryc_smartobject_field"
              brvt_action.primary_key_fields  = "smartobject_field_obj"
              brvt_action.primary_key_values  = STRING(ryc_smartobject_field.smartobject_field_obj)
              .
          RAW-TRANSFER ryc_smartobject_field TO brvt_action.raw_data.
          VALIDATE brvt_action NO-ERROR.
          {af/sup2/afcheckerr.i &no-return = YES}
          IF cMessageList <> "":U THEN 
          DO:
            ASSIGN cErrorOut = cErrorOut + cMessageList + CHR(10).
            UNDO TrnBlock, LEAVE TrnBlock.
          END.
      END.

      FOR EACH ryc_custom_ui_trigger NO-LOCK
          WHERE ryc_custom_ui_trigger.smartobject_obj = ryc_smartobject.smartobject_obj
          :
          CREATE brvt_action NO-ERROR.
          {af/sup2/afcheckerr.i &no-return = YES}
          IF cMessageList <> "":U THEN 
          DO:
            ASSIGN cErrorOut = cErrorOut + cMessageList + CHR(10).
            UNDO TrnBlock, LEAVE TrnBlock.
          END.
          ASSIGN
              brvt_action.task_number         = iVersionTaskNumber
              brvt_action.transaction_id      = iTransactionId
              brvt_action.event_name          = "CREATE":U
              brvt_action.table_name          = "ryc_custom_ui_trigger"
              brvt_action.primary_key_fields  = "custom_ui_trigger_obj"
              brvt_action.primary_key_values  = STRING(ryc_custom_ui_trigger.custom_ui_trigger_obj)
              .
          RAW-TRANSFER ryc_custom_ui_trigger TO brvt_action.raw_data.
          VALIDATE brvt_action NO-ERROR.
          {af/sup2/afcheckerr.i &no-return = YES}
          IF cMessageList <> "":U THEN 
          DO:
            ASSIGN cErrorOut = cErrorOut + cMessageList + CHR(10).
            UNDO TrnBlock, LEAVE TrnBlock.
          END.
      END.

      /* For attribute values - not supporting collections for now */
      /* Also this should do attributes for smartobject and instances for a container */
      FOR EACH ryc_attribute_value NO-LOCK
          WHERE ryc_attribute_value.primary_smartobject_obj = ryc_smartobject.smartobject_obj:
        CREATE brvt_action NO-ERROR.
        {af/sup2/afcheckerr.i &no-return = YES}
        IF cMessageList <> "":U THEN 
        DO:
          ASSIGN cErrorOut = cErrorOut + cMessageList + CHR(10).
          UNDO TrnBlock, LEAVE TrnBlock.
        END.
        ASSIGN
          brvt_action.task_number         = iVersionTaskNumber
          brvt_action.transaction_id      = iTransactionId
          brvt_action.event_name          = "CREATE":U
          brvt_action.table_name          = "ryc_attribute_value"
          brvt_action.primary_key_fields  = "attribute_value_obj"
          brvt_action.primary_key_values  = STRING(ryc_attribute_value.attribute_value_obj)
          .
        RAW-TRANSFER ryc_attribute_value TO brvt_action.raw_data.
        VALIDATE brvt_action NO-ERROR.
        {af/sup2/afcheckerr.i &no-return = YES}
        IF cMessageList <> "":U THEN 
        DO:
          ASSIGN cErrorOut = cErrorOut + cMessageList + CHR(10).
          UNDO TrnBlock, LEAVE TrnBlock.
        END.
      END.

      /* Create/Update the Workspace Item record */
      FIND FIRST brvm_workspace_item EXCLUSIVE-LOCK
          WHERE  brvm_workspace_item.configuration_type   = cConfigurationType
          AND    brvm_workspace_item.scm_object_name      = ttSmartObjects.tfSObjectName
          AND    brvm_workspace_item.workspace_obj        = rvm_workspace.workspace_obj
          NO-ERROR.
      IF NOT AVAILABLE brvm_workspace_item
      THEN
      DO:
          CREATE brvm_workspace_item NO-ERROR.
          {af/sup2/afcheckerr.i &no-return = YES}
          IF cMessageList <> "":U THEN 
          DO:
            ASSIGN cErrorOut = cErrorOut + cMessageList + CHR(10).
            UNDO TrnBlock, LEAVE TrnBlock.
          END.
      END.
      ASSIGN
          brvm_workspace_item.configuration_type  = cConfigurationType
          brvm_workspace_item.scm_object_name     = ttSmartObjects.tfSObjectName
          brvm_workspace_item.item_version_number = iVersionInWorkspace
          brvm_workspace_item.workspace_obj       = rvm_workspace.workspace_obj
          brvm_workspace_item.product_module_obj  = gsc_product_module.product_module_obj
          brvm_workspace_item.task_version_number = 0
          brvm_workspace_item.task_product_module_obj = 0
          .
      VALIDATE brvm_workspace_item NO-ERROR.
      {af/sup2/afcheckerr.i &no-return = YES}
      IF cMessageList <> "":U THEN 
      DO:
        ASSIGN cErrorOut = cErrorOut + cMessageList + CHR(10).
        UNDO TrnBlock, LEAVE TrnBlock.
      END.

      /* delete workspace checkout record if it exists */
      FOR EACH brvt_workspace_checkout EXCLUSIVE-LOCK
         WHERE brvt_workspace_checkout.workspace_item_obj = brvm_workspace_item.workspace_item_obj:
        DELETE brvt_workspace_checkout NO-ERROR.
      END.

      /* delete all transaction and action records prior to baseline version if specified to do so,
         probably due to schema changes making raw-data obsolete. Assign hook will then prevent
         future use of the item version.
      */
      IF ttSmartObjects.tfSDeleteHistory THEN
      DO:
        FOR EACH brvt_transaction EXCLUSIVE-LOCK
            WHERE brvt_transaction.configuration_type   = cConfigurationType
            AND   brvt_transaction.scm_object_name      = ttSmartObjects.tfSObjectName
            AND   brvt_transaction.item_version_number  <> brvt_item_version.item_version_number
            AND   brvt_transaction.product_module_obj   = brvt_item_version.product_module_obj
            :
            DELETE brvt_transaction NO-ERROR.
        END.
      END.

    END. /* TrnBlock */

    IF ERROR-STATUS:ERROR
    THEN DO:
        ASSIGN cErrorOut = cErrorOut + "Error occured in building of the baseline version for object " + TRIM(ttSmartObjects.tfSObjectName) + CHR(10).
    END.

  END. /* EACH ttSmartobject*/

  IF VALID-HANDLE(hScmTool) THEN RUN killPlip IN hScmTool.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fixIntegrity) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE fixIntegrity Procedure 
PROCEDURE fixIntegrity :
/*------------------------------------------------------------------------------
  Purpose:     Synch RV with RTB
  Parameters:  <none>
  Notes:       If object does not exist in RTB, this procedure
               a) sets scm_registered flag to NO.
               If object does not exist in workspace, this procedure
               a) deletes workspace item record                  
               If object IS NOT checked out in RTB, this procedure
               a) ensures configuration item exists and is SCM registered
               b) ensures the item version for the current checked in version in RTB
                  exists and if not create it and baseline it
               c) Ensures the workspace item exists and if not creates it.
               d) updates the workspace item current version details and deletes
                  the task version value and task product module value.
               e) deletes the workspace checkout record if any exists
               If object IS checked out in RTB, this procedure
               a) ensures configuration item exists and is SCM registered
               b) Ensures the item version exists for the checked out version
                  and if not, creates one and baseline it.
               c) Ensures the workspace item exists and if not, creates one.
               d) Updates check out details on workspace item correctly
               e) creates a workspace checkout record if it doesn't exist
               f) ensures product module on smartobject matches RTB product
                  module.
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER TABLE FOR ttSmartObjects.
  DEFINE OUTPUT PARAMETER cErrorOut           AS CHARACTER  NO-UNDO.

  DEFINE BUFFER bryc_smartobject              FOR ryc_smartobject.
  DEFINE BUFFER brvm_workspace_item           FOR rvm_workspace_item.
  DEFINE BUFFER brvm_configuration_item       FOR rvm_configuration_item.
  DEFINE BUFFER brvt_item_version             FOR rvt_item_version.
  DEFINE BUFFER brvt_transaction              FOR rvt_transaction.
  DEFINE BUFFER brvt_action                   FOR rvt_action.
  DEFINE BUFFER brvt_workspace_checkout       FOR rvt_workspace_checkout.

  DEFINE VARIABLE dRTBModuleObj               AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE dCurrentModuleObj           AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE lNewBaseline                AS LOGICAL    NO-UNDO.

  FIND FIRST rvc_configuration_type NO-LOCK
      WHERE  rvc_configuration_type.configuration_type = "RYCSO":U
      NO-ERROR.
  IF NOT AVAILABLE rvc_configuration_type
  THEN DO:
      ASSIGN cErrorOut = cErrorOut + "configuration type RYCSO does not exist. Integrity process cancelled":U + CHR(10).
      RETURN.
  END.
  ELSE ASSIGN cConfigurationType  = "RYCSO":U.

  RUN rtb/prc/afrtbprocp.p PERSISTENT SET hScmTool NO-ERROR.

  BlkSObase:
  FOR EACH ttSmartObjects NO-LOCK:

    FIND FIRST rvm_workspace NO-LOCK
        WHERE rvm_workspace.workspace_code = ttSmartObjects.tfSWorkspace
        NO-ERROR.
    IF NOT AVAILABLE rvm_workspace
    THEN DO:
        ASSIGN cErrorOut = cErrorOut + "Workspace not selected or not available for integrity fix" + CHR(10).
        NEXT BlkSObase.
    END.

    FIND FIRST gsc_product_module NO-LOCK
        WHERE gsc_product_module.product_module_code = ttSmartObjects.tfSProductModule
        NO-ERROR.
    IF NOT AVAILABLE gsc_product_module
    THEN DO:
        ASSIGN cErrorOut = cErrorOut + "Product module does not exist. Integrity fix cancelled for object " + TRIM(ttSmartObjects.tfSObjectName) + CHR(10).
        NEXT BlkSObase.
    END.

    ASSIGN dCurrentModuleObj = gsc_product_module.product_module_obj.

    FIND FIRST ryc_smartobject NO-LOCK
        WHERE ryc_smartobject.object_filename = ttSmartObjects.tfSObjectName
        NO-ERROR.
    IF NOT AVAILABLE ttSmartObjects
    THEN DO:
        ASSIGN cErrorOut = cErrorOut + "Object does not exist in ICFDB repository table. Integrity fix cancelled for object " + TRIM(ttSmartObjects.tfSObjectName) + CHR(10).
        NEXT BlkSObase.
    END.

    IF INDEX(ttSmartObjects.tfSObjectName,".":U) = 0
    THEN ASSIGN cObjectFileName = ttSmartObjects.tfSObjectName + ".ado":U.
    ELSE ASSIGN cObjectFileName = ttSmartObjects.tfSObjectName.

    /* get scm info to synch with */
    IF VALID-HANDLE(hScmTool)
    THEN DO:
        RUN scmFullObjectInfo IN hScmTool (
            INPUT  cObjectFileName,                     
            INPUT  ttSmartObjects.tfSWorkspace,                  
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
    END.

    /* Use RTB product module if object exists in RTB in workspace */
    IF lObjectExistsInWorkspace THEN
    DO:
      FIND FIRST gsc_product_module NO-LOCK
          WHERE gsc_product_module.product_module_code = cModuleInWorkspace
          NO-ERROR.
      IF NOT AVAILABLE gsc_product_module THEN
      DO:
        ASSIGN cErrorOut = cErrorOut + "RTB Product module does not exist in ICFDB. Integrity fix cancelled for object " + TRIM(ttSmartObjects.tfSObjectName) + CHR(10).
        NEXT BlkSObase.
      END.
      ASSIGN dRTBModuleObj = gsc_product_module.product_module_obj.
    END.
    ELSE ASSIGN dRTBModuleObj = dCurrentModuleObj.

    TrnBlock:
    DO FOR bryc_smartobject, brvm_workspace_item, brvm_configuration_item, brvt_item_version, brvt_transaction, brvt_action TRANSACTION
           ON ERROR UNDO TrnBlock, LEAVE TrnBlock:

      /* Ensure config item exists with correct registered flag */
      FIND FIRST brvm_configuration_item EXCLUSIVE-LOCK
           WHERE brvm_configuration_item.configuration_type = rvc_configuration_type.configuration_type
             AND brvm_configuration_item.scm_object_name = ttSmartObjects.tfSObjectName
             AND brvm_configuration_item.product_module_obj = dRTBModuleObj
           NO-WAIT NO-ERROR.
      IF LOCKED brvm_configuration_item THEN
      DO:
        ASSIGN cErrorOut = cErrorOut + "Configuration item locked in RVDB. Integrity fix cancelled for object " + TRIM(ttSmartObjects.tfSObjectName) + CHR(10).
        UNDO TrnBlock, LEAVE TrnBlock.
      END.
      IF NOT AVAILABLE brvm_configuration_item THEN
      DO:
        CREATE brvm_configuration_item NO-ERROR.
        {af/sup2/afcheckerr.i &no-return = YES}
        IF cMessageList <> "":U THEN 
        DO:
          ASSIGN cErrorOut = cErrorOut + cMessageList + CHR(10).
          UNDO TrnBlock, LEAVE TrnBlock.
        END.
      END.
      ASSIGN
        brvm_configuration_item.configuration_type = rvc_configuration_type.configuration_type
        brvm_configuration_item.scm_object_name = ttSmartObjects.tfSObjectName
        brvm_configuration_item.product_module_obj = dRTBModuleObj
        brvm_configuration_item.ITEM_deployable = YES
        brvm_configuration_item.scm_registered = lObjectExists
        .
      VALIDATE brvm_configuration_item NO-ERROR.
      IF cMessageList <> "":U THEN 
      DO:
        ASSIGN cErrorOut = cErrorOut + cMessageList + CHR(10).
        UNDO TrnBlock, LEAVE TrnBlock.
      END.

      /* If object does not exist in RTB, can't do much more */
      IF NOT lObjectExists THEN NEXT BlkSObase. 

      /* If object not in workspace - zap workspace item record */
      IF NOT lObjectExistsInWorkspace THEN
      DO:
        FOR EACH brvm_workspace_item EXCLUSIVE-LOCK
           WHERE brvm_workspace_item.configuration_type = brvm_configuration_item.configuration_type
             AND brvm_workspace_item.scm_object_name = brvm_configuration_item.scm_object_name
             AND brvm_workspace_item.workspace_obj = rvm_workspace.workspace_obj:
          DELETE brvm_workspace_item NO-ERROR.
        END.
        NEXT BlkSObase. /* cannot do much more */
      END.

      /* object exists in RTB workspace if we get here - check item version exists
         for correct version and module in RTB
      */
      FIND FIRST brvt_item_version EXCLUSIVE-LOCK
           WHERE brvt_item_version.configuration_type = brvm_configuration_item.configuration_type
             AND brvt_item_version.scm_object_name = brvm_configuration_item.scm_object_name
             AND brvt_item_version.product_module_obj = dRTBModuleObj
             AND brvt_item_version.ITEM_version_number = iVersionInWorkspace
           NO-WAIT NO-ERROR.
      IF LOCKED brvt_item_version THEN
      DO:
        ASSIGN cErrorOut = cErrorOut + "Item version locked in RVDB. Integrity fix cancelled for object " + TRIM(ttSmartObjects.tfSObjectName) + CHR(10).
        UNDO TrnBlock, LEAVE TrnBlock.
      END.

      IF NOT AVAILABLE brvt_item_version THEN
      DO:
        ASSIGN
          lNewBaseline = YES.

        CREATE brvt_item_version NO-ERROR.
        {af/sup2/afcheckerr.i &no-return = YES}
        IF cMessageList <> "":U THEN 
        DO:
          ASSIGN cErrorOut = cErrorOut + cMessageList + CHR(10).
          UNDO TrnBlock, LEAVE TrnBlock.
        END.
        ASSIGN
          brvt_item_version.configuration_type = brvm_configuration_item.configuration_type
          brvt_item_version.scm_object_name = brvm_configuration_item.scm_object_name
          brvt_item_version.product_module_obj = dRTBModuleObj
          brvt_item_version.ITEM_version_number = iVersionInWorkspace         
          brvt_item_version.baseline_version = YES
          brvt_item_version.previous_product_module_obj = 0
          brvt_item_version.previous_version_number = 0
          brvt_item_version.baseline_product_module_obj = 0
          brvt_item_version.baseline_version_number = 0
          brvt_item_version.versions_since_baseline = 0
          brvt_item_version.ITEM_description = cObjectSummary
          .
      END.
      ELSE ASSIGN lNewBaseline = NO.

      ASSIGN
        brvt_item_version.task_number = iVersionTaskNumber
        .

      VALIDATE brvt_item_version NO-ERROR.
      {af/sup2/afcheckerr.i &no-return = YES}
      IF cMessageList <> "":U THEN 
      DO:
        ASSIGN cErrorOut = cErrorOut + cMessageList + CHR(10).
        UNDO TrnBlock, LEAVE TrnBlock.
      END.

      /* create new baseline transaction and action records for this item */
      IF lNewBaseline THEN
      DO:
        FOR EACH brvt_transaction EXCLUSIVE-LOCK
            WHERE brvt_transaction.configuration_type   = cConfigurationType
            AND   brvt_transaction.scm_object_name      = ttSmartObjects.tfSObjectName
            AND   brvt_transaction.item_version_number  = brvt_item_version.item_version_number
            AND   brvt_transaction.product_module_obj   = brvt_item_version.product_module_obj:
          DELETE brvt_transaction NO-ERROR.
        END.

        /* Create / update transaction record */
        ASSIGN 
            iTransactionId = DBTASKID("RVDB":U).

        CREATE brvt_transaction NO-ERROR.
        {af/sup2/afcheckerr.i &no-return = YES}
        IF cMessageList <> "":U THEN 
        DO:
          ASSIGN cErrorOut = cErrorOut + cMessageList + CHR(10).
          UNDO TrnBlock, LEAVE TrnBlock.
        END.

        ASSIGN 
            brvt_transaction.task_number            = iVersionTaskNumber
            brvt_transaction.transaction_id         = iTransactionId
            brvt_transaction.configuration_type     = cConfigurationType
            brvt_transaction.scm_object_name        = ttSmartObjects.tfSObjectName
            brvt_transaction.item_version_number    = brvt_item_version.item_version_number
            brvt_transaction.product_module_obj   = brvt_item_version.product_module_obj          
            .
        VALIDATE brvt_transaction NO-ERROR.
        {af/sup2/afcheckerr.i &no-return = YES}
        IF cMessageList <> "":U THEN 
        DO:
          ASSIGN cErrorOut = cErrorOut + cMessageList + CHR(10).
          UNDO TrnBlock, LEAVE TrnBlock.
        END.

        CREATE brvt_action NO-ERROR.
        {af/sup2/afcheckerr.i &no-return = YES}
        IF cMessageList <> "":U THEN 
        DO:
          ASSIGN cErrorOut = cErrorOut + cMessageList + CHR(10).
          UNDO TrnBlock, LEAVE TrnBlock.
        END.

        ASSIGN
            brvt_action.task_number         = iVersionTaskNumber
            brvt_action.transaction_id      = iTransactionId
            brvt_action.event_name          = "CREATE":U
            brvt_action.table_name          = "ryc_smartobject"
            brvt_action.primary_key_fields  = "smartobject_obj"
            brvt_action.primary_key_values  = STRING(ryc_smartobject.object_obj)
            .
        RAW-TRANSFER ryc_smartobject TO brvt_action.raw_data.
        VALIDATE brvt_action NO-ERROR.
        {af/sup2/afcheckerr.i &no-return = YES}
        IF cMessageList <> "":U THEN 
        DO:
          ASSIGN cErrorOut = cErrorOut + cMessageList + CHR(10).
          UNDO TrnBlock, LEAVE TrnBlock.
        END.

        /* actions to create related tables */ 
        FOR EACH ryc_object_instance NO-LOCK
            WHERE ryc_object_instance.container_smartobject_obj = ryc_smartobject.smartobject_obj
            :
            CREATE brvt_action NO-ERROR.
            {af/sup2/afcheckerr.i &no-return = YES}
            IF cMessageList <> "":U THEN 
            DO:
              ASSIGN cErrorOut = cErrorOut + cMessageList + CHR(10).
              UNDO TrnBlock, LEAVE TrnBlock.
            END.
            ASSIGN
                brvt_action.task_number         = iVersionTaskNumber
                brvt_action.transaction_id      = iTransactionId
                brvt_action.event_name          = "CREATE":U
                brvt_action.table_name          = "ryc_object_instance"
                brvt_action.primary_key_fields  = "container_smartobject_obj,object_instance_obj"
                brvt_action.primary_key_values  = STRING(ryc_object_instance.container_smartobject_obj) + CHR(3) + STRING(ryc_object_instance.object_instance_obj)
                .
            RAW-TRANSFER ryc_object_instance TO brvt_action.raw_data.
            VALIDATE brvt_action NO-ERROR.
            {af/sup2/afcheckerr.i &no-return = YES}
            IF cMessageList <> "":U THEN 
            DO:
              ASSIGN cErrorOut = cErrorOut + cMessageList + CHR(10).
              UNDO TrnBlock, LEAVE TrnBlock.
            END.
        END.

        FOR EACH ryc_page NO-LOCK 
            WHERE ryc_page.container_smartobject_obj = ryc_smartobject.smartobject_obj
            :
            CREATE brvt_action NO-ERROR.
            {af/sup2/afcheckerr.i &no-return = YES}
            IF cMessageList <> "":U THEN 
            DO:
              ASSIGN cErrorOut = cErrorOut + cMessageList + CHR(10).
              UNDO TrnBlock, LEAVE TrnBlock.
            END.
            ASSIGN
                brvt_action.task_number         = iVersionTaskNumber
                brvt_action.transaction_id      = iTransactionId
                brvt_action.event_name          = "CREATE":U
                brvt_action.table_name          = "ryc_page"
                brvt_action.primary_key_fields  = "container_smartobject_obj,page_obj"
                brvt_action.primary_key_values  = STRING(ryc_page.container_smartobject_obj) + CHR(3) + STRING(ryc_page.page_obj)
                .
            RAW-TRANSFER ryc_page TO brvt_action.raw_data.
            VALIDATE brvt_action NO-ERROR.
            {af/sup2/afcheckerr.i &no-return = YES}
            IF cMessageList <> "":U THEN 
            DO:
              ASSIGN cErrorOut = cErrorOut + cMessageList + CHR(10).
              UNDO TrnBlock, LEAVE TrnBlock.
            END.
        END.

        FOR EACH ryc_page_object NO-LOCK 
            WHERE ryc_page_object.container_smartobject_obj = ryc_smartobject.smartobject_obj
            :
            CREATE brvt_action NO-ERROR.
            {af/sup2/afcheckerr.i &no-return = YES}
            IF cMessageList <> "":U THEN 
            DO:
              ASSIGN cErrorOut = cErrorOut + cMessageList + CHR(10).
              UNDO TrnBlock, LEAVE TrnBlock.
            END.
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
            {af/sup2/afcheckerr.i &no-return = YES}
            IF cMessageList <> "":U THEN 
            DO:
              ASSIGN cErrorOut = cErrorOut + cMessageList + CHR(10).
              UNDO TrnBlock, LEAVE TrnBlock.
            END.
        END.

        FOR EACH ryc_smartlink NO-LOCK
            WHERE ryc_smartlink.container_smartobject_obj = ryc_smartobject.smartobject_obj
            :
            CREATE brvt_action NO-ERROR.
            {af/sup2/afcheckerr.i &no-return = YES}
            IF cMessageList <> "":U THEN 
            DO:
              ASSIGN cErrorOut = cErrorOut + cMessageList + CHR(10).
              UNDO TrnBlock, LEAVE TrnBlock.
            END.
            ASSIGN
                brvt_action.task_number         = iVersionTaskNumber
                brvt_action.transaction_id      = iTransactionId
                brvt_action.event_name          = "CREATE":U
                brvt_action.table_name          = "ryc_smartlink"
                brvt_action.primary_key_fields  = "smartlink_obj"
                brvt_action.primary_key_values  = STRING(ryc_smartlink.smartlink_obj)
                .
            RAW-TRANSFER ryc_smartlink TO brvt_action.raw_data.
            VALIDATE brvt_action NO-ERROR.
            {af/sup2/afcheckerr.i &no-return = YES}
            IF cMessageList <> "":U THEN 
            DO:
              ASSIGN cErrorOut = cErrorOut + cMessageList + CHR(10).
              UNDO TrnBlock, LEAVE TrnBlock.
            END.
        END.

        FOR EACH ryc_smartobject_field NO-LOCK
            WHERE ryc_smartobject_field.smartobject_obj = ryc_smartobject.smartobject_obj
            :
            CREATE brvt_action NO-ERROR.
            {af/sup2/afcheckerr.i &no-return = YES}
            IF cMessageList <> "":U THEN 
            DO:
              ASSIGN cErrorOut = cErrorOut + cMessageList + CHR(10).
              UNDO TrnBlock, LEAVE TrnBlock.
            END.
            ASSIGN
                brvt_action.task_number         = iVersionTaskNumber
                brvt_action.transaction_id      = iTransactionId
                brvt_action.event_name          = "CREATE":U
                brvt_action.table_name          = "ryc_smartobject_field"
                brvt_action.primary_key_fields  = "smartobject_field_obj"
                brvt_action.primary_key_values  = STRING(ryc_smartobject_field.smartobject_field_obj)
                .
            RAW-TRANSFER ryc_smartobject_field TO brvt_action.raw_data.
            VALIDATE brvt_action NO-ERROR.
            {af/sup2/afcheckerr.i &no-return = YES}
            IF cMessageList <> "":U THEN 
            DO:
              ASSIGN cErrorOut = cErrorOut + cMessageList + CHR(10).
              UNDO TrnBlock, LEAVE TrnBlock.
            END.
        END.

        FOR EACH ryc_custom_ui_trigger NO-LOCK
            WHERE ryc_custom_ui_trigger.smartobject_obj = ryc_smartobject.smartobject_obj
            :
            CREATE brvt_action NO-ERROR.
            {af/sup2/afcheckerr.i &no-return = YES}
            IF cMessageList <> "":U THEN 
            DO:
              ASSIGN cErrorOut = cErrorOut + cMessageList + CHR(10).
              UNDO TrnBlock, LEAVE TrnBlock.
            END.
            ASSIGN
                brvt_action.task_number         = iVersionTaskNumber
                brvt_action.transaction_id      = iTransactionId
                brvt_action.event_name          = "CREATE":U
                brvt_action.table_name          = "ryc_custom_ui_trigger"
                brvt_action.primary_key_fields  = "custom_ui_trigger_obj"
                brvt_action.primary_key_values  = STRING(ryc_custom_ui_trigger.custom_ui_trigger_obj)
                .
            RAW-TRANSFER ryc_custom_ui_trigger TO brvt_action.raw_data.
            VALIDATE brvt_action NO-ERROR.
            {af/sup2/afcheckerr.i &no-return = YES}
            IF cMessageList <> "":U THEN 
            DO:
              ASSIGN cErrorOut = cErrorOut + cMessageList + CHR(10).
              UNDO TrnBlock, LEAVE TrnBlock.
            END.
        END.

        /* For attribute values - not supporting collections for now */
        /* Also this should do attributes for smartobject and instances for a container */
        FOR EACH ryc_attribute_value NO-LOCK
            WHERE ryc_attribute_value.primary_smartobject_obj = ryc_smartobject.smartobject_obj:
          CREATE brvt_action NO-ERROR.
          {af/sup2/afcheckerr.i &no-return = YES}
          IF cMessageList <> "":U THEN 
          DO:
            ASSIGN cErrorOut = cErrorOut + cMessageList + CHR(10).
            UNDO TrnBlock, LEAVE TrnBlock.
          END.
          ASSIGN
            brvt_action.task_number         = iVersionTaskNumber
            brvt_action.transaction_id      = iTransactionId
            brvt_action.event_name          = "CREATE":U
            brvt_action.table_name          = "ryc_attribute_value"
            brvt_action.primary_key_fields  = "attribute_value_obj"
            brvt_action.primary_key_values  = STRING(ryc_attribute_value.attribute_value_obj)
            .
          RAW-TRANSFER ryc_attribute_value TO brvt_action.raw_data.
          VALIDATE brvt_action NO-ERROR.
          {af/sup2/afcheckerr.i &no-return = YES}
          IF cMessageList <> "":U THEN 
          DO:
            ASSIGN cErrorOut = cErrorOut + cMessageList + CHR(10).
            UNDO TrnBlock, LEAVE TrnBlock.
          END.
        END.
      END. /* new baseline */

      /* Item version now exists and has correct transaction and action records if it was created by us */
      /* Create/Update the Workspace Item record */
      FIND FIRST brvm_workspace_item EXCLUSIVE-LOCK
          WHERE  brvm_workspace_item.configuration_type   = cConfigurationType
          AND    brvm_workspace_item.scm_object_name      = ttSmartObjects.tfSObjectName
          AND    brvm_workspace_item.workspace_obj        = rvm_workspace.workspace_obj
          NO-ERROR.
      IF NOT AVAILABLE brvm_workspace_item
      THEN
      DO:
          CREATE brvm_workspace_item NO-ERROR.
          {af/sup2/afcheckerr.i &no-return = YES}
          IF cMessageList <> "":U THEN 
          DO:
            ASSIGN cErrorOut = cErrorOut + cMessageList + CHR(10).
            UNDO TrnBlock, LEAVE TrnBlock.
          END.
      END.
      ASSIGN
        brvm_workspace_item.configuration_type  = cConfigurationType
        brvm_workspace_item.scm_object_name     = ttSmartObjects.tfSObjectName
        brvm_workspace_item.workspace_obj       = rvm_workspace.workspace_obj
        .
      IF NOT lCheckedOutInWorkspace THEN
        ASSIGN
          brvm_workspace_item.item_version_number = iVersionInWorkspace
          brvm_workspace_item.product_module_obj  = dRTBModuleObj
          brvm_workspace_item.task_version_number = 0
          brvm_workspace_item.task_product_module_obj = 0
          .
      ELSE
        ASSIGN
          brvm_workspace_item.task_version_number = iVersionInWorkspace
          brvm_workspace_item.task_product_module_obj = dRTBModuleObj
          .
      IF brvm_workspace_item.item_version_number = 0 THEN /* deal with create when checked out */
        ASSIGN
          brvm_workspace_item.item_version_number = iVersionInWorkspace
          brvm_workspace_item.product_module_obj  = dRTBModuleObj
          .        
      VALIDATE brvm_workspace_item NO-ERROR.
      {af/sup2/afcheckerr.i &no-return = YES}
      IF cMessageList <> "":U THEN 
      DO:
        ASSIGN cErrorOut = cErrorOut + cMessageList + CHR(10).
        UNDO TrnBlock, LEAVE TrnBlock.
      END.

      /* Workspace item now ok, zap checkout record if not checked out, else create one if it is */
      IF NOT lCheckedOutInWorkspace THEN
      FOR EACH brvt_workspace_checkout EXCLUSIVE-LOCK
         WHERE brvt_workspace_checkout.workspace_item_obj = brvm_workspace_item.workspace_item_obj:
        DELETE brvt_workspace_checkout NO-ERROR.
      END.
      ELSE
      DO:
        FIND FIRST brvt_workspace_checkout EXCLUSIVE-LOCK
             WHERE brvt_workspace_checkout.workspace_item_obj = brvm_workspace_item.workspace_item_obj
             NO-ERROR.
        IF NOT AVAILABLE brvt_workspace_checkout THEN
        DO:
          CREATE brvt_workspace_checkout NO-ERROR.        
          IF cMessageList <> "":U THEN 
          DO:
            ASSIGN cErrorOut = cErrorOut + cMessageList + CHR(10).
            UNDO TrnBlock, LEAVE TrnBlock.
          END.
        END.
        ASSIGN
          brvt_workspace_checkout.workspace_item_obj = brvm_workspace_item.workspace_item_obj
          brvt_workspace_checkout.workspace_obj = rvm_workspace.workspace_obj
          brvt_workspace_checkout.task_number = iVersionTaskNumber
          brvt_workspace_checkout.configuration_type = cConfigurationType
          brvt_workspace_checkout.modification_type = "UNK":U
          .
        VALIDATE brvt_workspace_checkout NO-ERROR.
        IF cMessageList <> "":U THEN 
        DO:
          ASSIGN cErrorOut = cErrorOut + cMessageList + CHR(10).
          UNDO TrnBlock, LEAVE TrnBlock.
        END.
      END.

      /* workspace checkouts now ok, if checked out, fix product module on smartobject */
      IF lCheckedOutInWorkspace THEN
      DO:
        IF dRTBModuleObj <> ryc_smartobject.product_module_obj THEN
        DO:
          FIND FIRST bryc_smartobject EXCLUSIVE-LOCK
               WHERE bryc_smartobject.OBJECT_filename = ttSmartObjects.tfSObjectName
               NO-ERROR.
          ASSIGN bryc_smartobject.product_module_obj = dRTBModuleObj.
          VALIDATE bryc_smartobject NO-ERROR.
        END.
      END.

    END. /* TrnBlock */

    IF ERROR-STATUS:ERROR
    THEN DO:
        ASSIGN cErrorOut = cErrorOut + "Error occured in integrity fix for object " + TRIM(ttSmartObjects.tfSObjectName) + CHR(10).
    END.

  END. /* EACH ttSmartobject*/

  IF VALID-HANDLE(hScmTool) THEN RUN killPlip IN hScmTool.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF
