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
  File: rvutlplipp.p

  Description:  ICF Versioning Utility PLIP
  
  Purpose:      ICF Versioning Utility PLIP

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:        5521   UserRef:    astra2
                Date:   25/04/2000  Author:     Anthony Swindells

  Update Notes: Created from Template aftemplipp.p
                This version integrates with the RTB SCM Tool

  (v:010001)    Task:        5564   UserRef:    astra2
                Date:   27/04/2000  Author:     Anthony Swindells

  Update Notes: Fix errors with versioning plip as a result of first tests.

  (v:010002)    Task:        5564   UserRef:    astra2
                Date:   01/05/2000  Author:     Anthony Swindells

  Update Notes: Fix errors with versioning plip as a result of 2nd tests.

  (v:010003)    Task:        5578   UserRef:    astra2
                Date:   02/05/2000  Author:     Anthony Swindells

  Update Notes: Change to scmObjectExists hook - add extra parameter to return the latest
                version available of the obejct, for use by the import procedures.

  (v:010004)    Task:        6435   UserRef:    
                Date:   14/08/2000  Author:     Johan Meyer

  Update Notes: Add messages to track versioning error when an object is deleted and
                re-assigned in a workspace.
                
                Commented message out but left them in the code.

  (v:010006)    Task:        6883   UserRef:    
                Date:   16/10/2000  Author:     Anthony Swindells

  Update Notes: Assign object controller wizard viewer - fix RV errors

  (v:010007)    Task:        7274   UserRef:    
                Date:   08/12/2000  Author:     Anthony Swindells

  Update Notes: Fix RV version system errors

  (v:010008)    Task:        7361   UserRef:    
                Date:   19/12/2000  Author:     Anthony Swindells

  Update Notes: Allow product module changes in RV and track changes

  (v:010009)    Task:        7403   UserRef:    
                Date:   27/12/2000  Author:     Anthony Swindells

  Update Notes: Fix import issues - add extra error handling and duplicate handling to deployments

  (v:010012)    Task:        7435   UserRef:    
                Date:   02/01/2001  Author:     Anthony Swindells

  Update Notes: Fix import issues

  (v:010013)    Task:        7639   UserRef:    
                Date:   23/01/2001  Author:     Anthony Swindells

  Update Notes: baseline new objects on check in.
                Added functionality to check in hook to recreate baseline data if v1 of an
                object, plus ask if want to baseline logical object if > version 1.

  (v:010014)    Task:        7749   UserRef:    
                Date:   29/01/2001  Author:     Anthony Swindells

  Update Notes: Complete task errors

  (v:010015)    Task:        7751   UserRef:    
                Date:   29/01/2001  Author:     Anthony Swindells

  Update Notes: remove debug message

---------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       rvutlplipp.p
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    010003

/* Astra object identifying preprocessor */
&glob   AstraPlip    yes

DEFINE VARIABLE cObjectName         AS CHARACTER NO-UNDO.

ASSIGN cObjectName = "{&object-name}":U.

&scop   mip-notify-user-on-plip-close   NO

{af/sup2/afglobals.i}
{af/sup2/afcheckerr.i &define-only = YES}
{af/sup2/afrun2.i &Define-only = YES}

&SCOPED-DEFINE scm_tool rtb

DEFINE TEMP-TABLE tt_register_item  NO-UNDO
  FIELD scm_object_name             AS CHARACTER
  FIELD configuration_type          AS CHARACTER
  FIELD item_version_number         AS INTEGER
  FIELD register_action             AS CHARACTER  /* DEL or REG */
  FIELD product_module_code         AS CHARACTER
  FIELD object_sub_type             AS CHARACTER
  FIELD object_group                AS CHARACTER
  FIELD object_level                AS INTEGER
  FIELD object_description          AS CHARACTER
  FIELD deleted_item_rowid          AS ROWID
  FIELD configuration_item_rowid    AS ROWID
  INDEX id_primary_key IS PRIMARY scm_object_name.

DEFINE TEMP-TABLE ttObject    NO-UNDO
       FIELD cWorkspace       AS CHARACTER
       FIELD cProductModule   AS CHARACTER
       FIELD cObjectName      AS CHARACTER
       INDEX idxMain          IS PRIMARY UNIQUE
              cObjectName
       .

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

&IF DEFINED(EXCLUDE-getQuotedFieldValue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getQuotedFieldValue Procedure 
FUNCTION getQuotedFieldValue RETURNS CHARACTER
  ( ip_buffer_handle AS HANDLE,
    ip_description_fieldname AS CHARACTER )  FORWARD.

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
         HEIGHT             = 30.86
         WIDTH              = 61.2.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB Procedure 
/* ************************* Included-Libraries *********************** */

{src/adm/method/attribut.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  ******************************* */

{ry/app/ryplipmain.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

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

  ASSIGN
    op_error = "":U.

  DO FOR lb_rvm_workspace_item, lb_rvt_deleted_item:

    FIND FIRST lb_rvm_workspace_item EXCLUSIVE-LOCK
      WHERE lb_rvm_workspace_item.workspace_obj      = ip_workspace_obj
      AND   lb_rvm_workspace_item.configuration_type = ip_configuration_type
      AND   lb_rvm_workspace_item.scm_object_name    = ip_object_name
      NO-WAIT NO-ERROR.
    IF LOCKED lb_rvm_workspace_item
    THEN DO:
      ASSIGN
        op_error = "Assign of object: " + ip_object_name + " Failed. Workspace item locked by another user".
      RETURN.
    END.
    IF NOT AVAILABLE lb_rvm_workspace_item
    THEN DO:
      CREATE lb_rvm_workspace_item NO-ERROR.
      {af/sup2/afcheckerr.i &no-return = YES}
      IF cMessageList <> "":U
      THEN DO:
        ASSIGN
          op_error = cMessageList.
        RETURN.
      END.
    END.

    ASSIGN
      lb_rvm_workspace_item.workspace_obj           = ip_workspace_obj
      lb_rvm_workspace_item.configuration_type      = ip_configuration_type
      lb_rvm_workspace_item.scm_object_name         = ip_object_name
      lb_rvm_workspace_item.item_version_number     = ip_version_number
      lb_rvm_workspace_item.product_module_obj      = ip_product_module_obj
      lb_rvm_workspace_item.task_product_module_obj = 0
      lb_rvm_workspace_item.task_version_number     = 0
      .
  
    /* Force validation triggers to fire */
    VALIDATE lb_rvm_workspace_item NO-ERROR.
    {af/sup2/afcheckerr.i &no-return = YES}
    IF cMessageList <> "":U
    THEN DO:
      ASSIGN
        op_error = cMessageList.
      RETURN.
    END.

    /* Now get rid of any deleted items for this object */
    FOR EACH lb_rvt_deleted_item EXCLUSIVE-LOCK
      WHERE lb_rvt_deleted_item.workspace_obj = ip_workspace_obj
      AND   lb_rvt_deleted_item.configuration_type = ip_configuration_type
      AND   lb_rvt_deleted_item.scm_object_name = ip_object_name
      AND   lb_rvt_deleted_item.product_module_obj = ip_product_module_obj
      :

      DELETE lb_rvt_deleted_item NO-ERROR.
      {af/sup2/afcheckerr.i &no-return = YES}
      IF cMessageList <> "":U
      THEN DO:
        ASSIGN
          op_error = cMessageList.
        RETURN.
      END.
    END.

  END.

  ERROR-STATUS:ERROR = NO.
  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-checkInItem) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE checkInItem Procedure 
PROCEDURE checkInItem :
/*------------------------------------------------------------------------------
  Purpose:     This procedure is run as part of a check-in object hook, before
               the object is checked in in the SCM tool.
               We must delete the rvt_workspace_checkout record for the
               workspace item.
               We must update the item version number equal to the task version
               number and set the task version number of the workspace item to 0.
               We must regenerate the .ado XML file to ensure it is fully up-to-date.
  Parameters:  input workspace item being checked out
               input full object name from SCM Tool (including .ado extension)
               output error message text if any
  Notes:       If the check in into the SCM tool fails, we will not know, so we
               must warn of errors in this procedure, but allow the user to
               continue and tidy up as we go along.

               This procedure now also deals with checking in of objects that
               have .ado parts but that do not yet exist in the versioning database
               and/or the repository - maybe because they were brought in from
               an external system and were loaded via a module load or similar
               process.
               In this case, it will create the repository data if not there,
               from the .ado, and also fix up the RV data.

------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER  ip_workspace_item_obj       AS DECIMAL    NO-UNDO.
  DEFINE INPUT PARAMETER  ip_full_object_name         AS CHARACTER  NO-UNDO.
  DEFINE OUTPUT PARAMETER op_error                    AS CHARACTER  NO-UNDO.

  DEFINE BUFFER lb_rvm_workspace_item FOR rvm_workspace_item.
  DEFINE BUFFER lb_rvt_workspace_checkout FOR rvt_workspace_checkout.

  ASSIGN op_error = "":U.
  DO FOR lb_rvm_workspace_item, lb_rvt_workspace_checkout:
  
    FIND FIRST lb_rvm_workspace_item EXCLUSIVE-LOCK
      WHERE lb_rvm_workspace_item.workspace_item_obj = ip_workspace_item_obj
      NO-WAIT NO-ERROR.
    IF LOCKED lb_rvm_workspace_item
    THEN DO:
      ASSIGN op_error = "Check-in failed. Cannot update workspace item - locked by another user".
      RETURN.    
    END.
    IF NOT AVAILABLE lb_rvm_workspace_item
    THEN DO:
      ASSIGN op_error = "Check-in failed. Cannot update workspace item - deleted by another user".
      RETURN.    
    END.

    /* Update item version number equal to task version number and task version to 0 */
    IF lb_rvm_workspace_item.task_version_number > 0 THEN
      ASSIGN
        lb_rvm_workspace_item.item_version_number = lb_rvm_workspace_item.task_version_number
        lb_rvm_workspace_item.task_version_number = 0
        lb_rvm_workspace_item.product_module_obj = lb_rvm_workspace_item.task_product_module_obj
        lb_rvm_workspace_item.task_product_module_obj = 0
        .

    /* Delete workspace checkout record */
    FIND FIRST lb_rvt_workspace_checkout EXCLUSIVE-LOCK
      WHERE lb_rvt_workspace_checkout.workspace_item_obj = lb_rvm_workspace_item.workspace_item_obj
      NO-WAIT NO-ERROR.
    IF LOCKED lb_rvt_workspace_checkout THEN
    DO:
      ASSIGN op_error = "Cannot delete workspace checkout record - locked by another user".
      RETURN.    
    END.
    IF AVAILABLE lb_rvt_workspace_checkout THEN
    DO:
      DELETE lb_rvt_workspace_checkout NO-ERROR.
      {af/sup2/afcheckerr.i &no-return = YES}
      IF cMessageList <> "":U THEN 
      DO:
        ASSIGN op_error = cMessageList.
        RETURN.
      END.
    END.

    /* Force validation triggers to fire */
    VALIDATE lb_rvm_workspace_item NO-ERROR.
    {af/sup2/afcheckerr.i &no-return = YES}
    IF cMessageList <> "":U THEN 
    DO:
      ASSIGN op_error = cMessageList.
      RETURN.
    END.

    /* Generate/update .ado XML File */
    RUN updateXMLFile (INPUT lb_rvm_workspace_item.workspace_obj,
                       INPUT lb_rvm_workspace_item.product_module_obj,
                       INPUT lb_rvm_workspace_item.configuration_type,
                       INPUT ip_full_object_name,
                       OUTPUT op_error). 
  END.

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-checkOutItemCreate) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE checkOutItemCreate Procedure 
PROCEDURE checkOutItemCreate :
/*------------------------------------------------------------------------------
  Purpose:     This procedure is run as part of a check-out object hook, before
               the object is completely checked out in the SCM tool, i.e. we do
               not know the real new version number.
               We must create a new rvt_workspace_checkout record for the
               workspace item.
               We must update the task version number of the workspace item to
               be the negative of the item version number.
               We must create a new rvt_item_version record for this new
               negative version number.
  Parameters:  input workspace item being checked out
               input current task number
               output error message text if any
  Notes:       The negative version number temporarily used here will be fixed
               in the after check-out hook to be the real new version number.
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER  ip_workspace_item_obj       AS DECIMAL    NO-UNDO.
  DEFINE INPUT PARAMETER  ip_task_number              AS INTEGER    NO-UNDO.
  DEFINE OUTPUT PARAMETER op_error                    AS CHARACTER  NO-UNDO.

  DEFINE BUFFER lb_rvm_workspace_item FOR rvm_workspace_item.
  DEFINE BUFFER lb_rvt_workspace_checkout FOR rvt_workspace_checkout.
  DEFINE BUFFER lb1_rvt_item_version FOR rvt_item_version.
  DEFINE BUFFER lb2_rvt_item_version FOR rvt_item_version.

  ASSIGN op_error = "":U.
  DO FOR lb_rvm_workspace_item, lb_rvt_workspace_checkout, lb1_rvt_item_version, lb2_rvt_item_version:
    FIND FIRST lb_rvm_workspace_item EXCLUSIVE-LOCK
       WHERE lb_rvm_workspace_item.workspace_item_obj = ip_workspace_item_obj
       NO-WAIT NO-ERROR.
    IF LOCKED lb_rvm_workspace_item THEN
    DO:
      ASSIGN op_error = "Cannot update workspace item - locked by another user".
      RETURN.    
    END.
    IF NOT AVAILABLE lb_rvm_workspace_item THEN
    DO:
      ASSIGN op_error = "Cannot update workspace item - deleted by another user".
      RETURN.    
    END.
    /* Update task version number equal to negative of item version number */
    ASSIGN
      lb_rvm_workspace_item.task_version_number = lb_rvm_workspace_item.item_version_number * -1
      lb_rvm_workspace_item.task_product_module_obj = lb_rvm_workspace_item.product_module_obj
      .

    /* Find current item version */
    FIND FIRST lb1_rvt_item_version NO-LOCK
       WHERE lb1_rvt_item_version.configuration_type = lb_rvm_workspace_item.configuration_type
         AND lb1_rvt_item_version.scm_object_name = lb_rvm_workspace_item.scm_object_name
         AND lb1_rvt_item_version.product_module_obj = lb_rvm_workspace_item.product_module_obj
         AND lb1_rvt_item_version.item_version_number = lb_rvm_workspace_item.item_version_number
       NO-ERROR.
    IF NOT AVAILABLE lb1_rvt_item_version THEN
    DO:
      ASSIGN op_error = "Cannot find existing item version for object: " + lb_rvm_workspace_item.scm_object_name + " Module: " + STRING(lb_rvm_workspace_item.product_module_obj) + " version: " + STRING(lb_rvm_workspace_item.item_version_number).
      RETURN.    
    END.
  
    /* Create new rvt_item_version record */

    CREATE lb2_rvt_item_version NO-ERROR.
    {af/sup2/afcheckerr.i &no-return = YES}
    IF cMessageList <> "":U THEN 
    DO:
      ASSIGN op_error = cMessageList.
      RETURN.
    END.
  
    BUFFER-COPY lb1_rvt_item_version EXCEPT lb1_rvt_item_version.item_version_obj TO lb2_rvt_item_version
    ASSIGN
      lb2_rvt_item_version.item_version_number = lb_rvm_workspace_item.task_version_number
      lb2_rvt_item_version.product_module_obj = lb_rvm_workspace_item.task_product_module_obj
      lb2_rvt_item_version.task_number = ip_task_number
      lb2_rvt_item_version.baseline_version = NO
      lb2_rvt_item_version.previous_product_module_obj = lb_rvm_workspace_item.product_module_obj
      lb2_rvt_item_version.previous_version_number = lb_rvm_workspace_item.item_version_number
      lb2_rvt_item_version.versions_since_baseline = lb1_rvt_item_version.versions_since_baseline + 1
      .

    /* Create new rvt_workspace_checkout record */
    CREATE lb_rvt_workspace_checkout NO-ERROR.
    {af/sup2/afcheckerr.i &no-return = YES}
    IF cMessageList <> "":U THEN 
    DO:
      ASSIGN op_error = cMessageList.
      RETURN.
    END.
  
    ASSIGN
     lb_rvt_workspace_checkout.workspace_obj = lb_rvm_workspace_item.workspace_obj
     lb_rvt_workspace_checkout.task_number = ip_task_number
     lb_rvt_workspace_checkout.configuration_type = lb_rvm_workspace_item.configuration_type 
     lb_rvt_workspace_checkout.workspace_item_obj = lb_rvm_workspace_item.workspace_item_obj
     lb_rvt_workspace_checkout.modification_type = "UNK":U
     .  
  
    /* Force validation triggers to fire */
    VALIDATE lb2_rvt_item_version NO-ERROR.
    {af/sup2/afcheckerr.i &no-return = YES}
    IF cMessageList <> "":U THEN 
    DO:
      ASSIGN op_error = cMessageList.
      RETURN.
    END.
  
    VALIDATE lb_rvm_workspace_item NO-ERROR.
    {af/sup2/afcheckerr.i &no-return = YES}
    IF cMessageList <> "":U THEN 
    DO:
      ASSIGN op_error = cMessageList.
      RETURN.
    END.

    VALIDATE lb_rvt_workspace_checkout NO-ERROR.
    {af/sup2/afcheckerr.i &no-return = YES}
    IF cMessageList <> "":U THEN 
    DO:
      ASSIGN op_error = cMessageList.
      RETURN.
    END.

  END.

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-checkOutItemUpdate) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE checkOutItemUpdate Procedure 
PROCEDURE checkOutItemUpdate :
/*------------------------------------------------------------------------------
  Purpose:     This procedure is run as part of a check-out object hook, after
               the object is completely checked out in the SCM tool, i.e. we do
               now know the real new version number.
               We must update the task version number of the workspace item to
               be the real new version number.
               We must update the rvt_item_version record for this new
               version number.
  Parameters:  input workspace item being checked out
               input new version number
               output error message text if any
  Notes:       The negative version number temporarily used here will be fixed
               in the after check-out hook to be the real new version number.
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER  ip_workspace_item_obj       AS DECIMAL    NO-UNDO.
  DEFINE INPUT PARAMETER  ip_new_version_number       AS INTEGER    NO-UNDO.
  DEFINE OUTPUT PARAMETER op_error                    AS CHARACTER  NO-UNDO.

  DEFINE BUFFER lb_rvm_workspace_item FOR rvm_workspace_item.
  DEFINE BUFFER lb_rvt_item_version FOR rvt_item_version.

  ASSIGN op_error = "":U.
  DO FOR lb_rvm_workspace_item, lb_rvt_item_version:
    FIND FIRST lb_rvm_workspace_item EXCLUSIVE-LOCK
       WHERE lb_rvm_workspace_item.workspace_item_obj = ip_workspace_item_obj
       NO-WAIT NO-ERROR.
    IF LOCKED lb_rvm_workspace_item THEN
    DO:
      ASSIGN op_error = "Cannot update workspace item - locked by another user".
      RETURN.    
    END.
    IF NOT AVAILABLE lb_rvm_workspace_item THEN
    DO:
      ASSIGN op_error = "Cannot update workspace item - deleted by another user".
      RETURN.    
    END.
  
    /* Find existing item version for task version number */
    FIND FIRST lb_rvt_item_version EXCLUSIVE-LOCK
       WHERE lb_rvt_item_version.configuration_type = lb_rvm_workspace_item.configuration_type
         AND lb_rvt_item_version.scm_object_name = lb_rvm_workspace_item.scm_object_name
         AND lb_rvt_item_version.product_module_obj = lb_rvm_workspace_item.task_product_module_obj
         AND lb_rvt_item_version.item_version_number = lb_rvm_workspace_item.task_version_number
       NO-WAIT NO-ERROR.
    IF LOCKED lb_rvt_item_version THEN
    DO:
      ASSIGN op_error = "Cannot update existing item version for object: " + lb_rvm_workspace_item.scm_object_name + " Module: " + STRING(lb_rvm_workspace_item.product_module_obj) + " version: " + STRING(lb_rvm_workspace_item.task_version_number) + " - it is locked by another user".
      RETURN.    
    END.
    IF NOT AVAILABLE lb_rvt_item_version THEN
    DO:
      ASSIGN op_error = "Cannot find existing item version for object: " + lb_rvm_workspace_item.scm_object_name + " Module: " + STRING(lb_rvm_workspace_item.product_module_obj) + " version: " + STRING(lb_rvm_workspace_item.task_version_number).
      RETURN.    
    END.

    /* Update task version number equal to new version number */
    ASSIGN
      lb_rvm_workspace_item.task_version_number = ip_new_version_number.

    /* Update item version number to be real new version number */
    ASSIGN
      lb_rvt_item_version.item_version_number = ip_new_version_number.
  
    /* Force validation triggers to fire */
    VALIDATE lb_rvt_item_version NO-ERROR.
    {af/sup2/afcheckerr.i &no-return = YES}
    IF cMessageList <> "":U THEN 
    DO:
      ASSIGN op_error = cMessageList.
      RETURN.
    END.

    VALIDATE lb_rvm_workspace_item NO-ERROR.
    {af/sup2/afcheckerr.i &no-return = YES}
    IF cMessageList <> "":U THEN 
    DO:
      ASSIGN op_error = cMessageList.
      RETURN.
    END.

  END.

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-createProductModule) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE createProductModule Procedure 
PROCEDURE createProductModule :
/*------------------------------------------------------------------------------
  Purpose:     To create a new product module
  Parameters:  input product module code
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER pcModule             AS CHARACTER  NO-UNDO.

  DEFINE BUFFER bgsc_product                  FOR gsc_product.
  DEFINE BUFFER bgsc_product_module           FOR gsc_product_module.

  DEFINE VARIABLE cProductCode                AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cProductDesc                AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cModuleDesc                 AS CHARACTER  NO-UNDO.

  RUN scmGetModuleDetails (INPUT pcModule
                          ,OUTPUT cProductCode
                          ,OUTPUT cProductDesc
                          ,OUTPUT cModuleDesc
                          ).

  IF cModuleDesc = "":U
  THEN
    ASSIGN
      cModuleDesc = pcModule.
  IF cProductCode = "":U
  AND LENGTH(pcModule) > 2
  THEN
    ASSIGN
      cProductCode = SUBSTRING(pcModule,1,2).
  IF cProductDesc = "":U
  THEN
    ASSIGN
      cProductDesc = cProductCode.

  DO FOR bgsc_product_module, bgsc_product:

    FIND FIRST bgsc_product NO-LOCK
      WHERE bgsc_product.product_code = cProductCode
      NO-ERROR.
    IF NOT AVAILABLE bgsc_product
    THEN DO:
      CREATE bgsc_product NO-ERROR.
      ASSIGN
        bgsc_product.product_code         = cProductCode
        bgsc_product.product_description  = cProductDesc
        .
      VALIDATE bgsc_product NO-ERROR.      
    END.

    CREATE bgsc_product_module NO-ERROR.
    ASSIGN
      bgsc_product_module.product_obj                 = bgsc_product.product_obj
      bgsc_product_module.product_module_code         = pcModule
      bgsc_product_module.product_module_description  = cModuleDesc
      .    
    VALIDATE bgsc_product_module NO-ERROR.

  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-deleteDeletedItems) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE deleteDeletedItems Procedure 
PROCEDURE deleteDeletedItems :
/*------------------------------------------------------------------------------
  Purpose:     To tidy up the deleted items records for an object in a workspace
               due to the fact the object was deleted via the SCM tool before
               the deletions had a chance to take affect.
  Parameters:  input workspace object number
               input configuration type
               input object name
               input product module 
               output error message text if it failed
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER  ip_workspace_obj      AS DECIMAL    NO-UNDO.
  DEFINE INPUT PARAMETER  ip_configuration_type AS CHARACTER  NO-UNDO.
  DEFINE INPUT PARAMETER  ip_object_name        AS CHARACTER  NO-UNDO.
  DEFINE INPUT PARAMETER  ip_module             AS CHARACTER  NO-UNDO.
  DEFINE OUTPUT PARAMETER op_error              AS CHARACTER  NO-UNDO.

  FIND FIRST gsc_product_module NO-LOCK
    WHERE gsc_product_module.product_module_code = ip_module
    NO-ERROR.

  ASSIGN
    op_error = "":U.

  FOR EACH rvt_deleted_item EXCLUSIVE-LOCK
    WHERE rvt_deleted_item.workspace_obj      = ip_workspace_obj
    AND   rvt_deleted_item.configuration_type = ip_configuration_type
    AND   rvt_deleted_item.scm_object_name    = ip_object_name
    AND   rvt_deleted_item.product_module_obj = gsc_product_module.product_module_obj
    :

    DELETE rvt_deleted_item NO-ERROR.
    {af/sup2/afcheckerr.i &no-return = YES}
    IF cMessageList <> "":U THEN 
    DO:
      ASSIGN
        op_error = cMessageList.
      RETURN.
    END.

  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-deleteWorkspaceItem) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE deleteWorkspaceItem Procedure 
PROCEDURE deleteWorkspaceItem :
/*------------------------------------------------------------------------------
  Purpose:     To delete a workspace item record.
               Also, if the workspace item had a valid task version number (it was wip),
               then also delete the item version.
  Parameters:  input rowid of workspace item to be deleted
               output error message text if the deletion failed
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER  ip_rowid AS ROWID     NO-UNDO.
  DEFINE OUTPUT PARAMETER op_error AS CHARACTER NO-UNDO.

  DEFINE VARIABLE lv_configuration_type   AS CHARACTER NO-UNDO.
  DEFINE VARIABLE lv_module_obj           AS DECIMAL   NO-UNDO.
  DEFINE VARIABLE lv_scm_object_name      AS CHARACTER NO-UNDO.
  DEFINE VARIABLE lv_task_version_number  AS INTEGER   NO-UNDO.
  DEFINE VARIABLE lv_task_module_obj      AS DECIMAL   NO-UNDO.

  DEFINE BUFFER lb_rvm_workspace_item FOR rvm_workspace_item.
  DEFINE BUFFER lb_rvt_item_version   FOR rvt_item_version.

  ASSIGN
    op_error = "":U
    /* op_error = "Failed to delete workspace item":U  - This were never reset. */
    .

  DO FOR lb_rvm_workspace_item, lb_rvt_item_version:

    FIND FIRST lb_rvm_workspace_item EXCLUSIVE-LOCK
      WHERE ROWID(lb_rvm_workspace_item) = ip_rowid
      NO-WAIT NO-ERROR.
    IF LOCKED lb_rvm_workspace_item
    THEN DO:
      ASSIGN
        op_error = "Cannot delete workspace item - locked by another user".
      RETURN.
    END.

    IF NOT AVAILABLE lb_rvm_workspace_item
    THEN
      RETURN. /* already deleted */

    ASSIGN
      lv_configuration_type   = lb_rvm_workspace_item.configuration_type
      lv_scm_object_name      = lb_rvm_workspace_item.scm_object_name
      lv_module_obj           = lb_rvm_workspace_item.product_module_obj
      lv_task_version_number  = lb_rvm_workspace_item.task_version_number
      lv_task_module_obj      = lb_rvm_workspace_item.task_product_module_obj
      .

    DELETE lb_rvm_workspace_item NO-ERROR.
    {af/sup2/afcheckerr.i &no-return = YES}
    IF cMessageList <> "":U
    THEN DO:
      ASSIGN
        op_error = cMessageList.
      RETURN.
    END.

    /* Delete all traces of WIP version if any */
    IF lv_task_version_number > 0
    THEN DO:

      FIND FIRST lb_rvt_item_version EXCLUSIVE-LOCK
        WHERE lb_rvt_item_version.configuration_type = lv_configuration_type
        AND   lb_rvt_item_version.scm_object_name = lv_scm_object_name
        AND   lb_rvt_item_version.product_module_obj = lv_task_module_obj
        AND   lb_rvt_item_version.item_version_number = lv_task_version_number
        NO-WAIT NO-ERROR.
      IF LOCKED lb_rvt_item_version
      THEN DO:
        ASSIGN
          op_error = "Cannot delete task item version - locked by another user".
        RETURN.
      END.
      IF AVAILABLE lb_rvt_item_version
      THEN DO:
        DELETE lb_rvt_item_version NO-ERROR.
        {af/sup2/afcheckerr.i &no-return = YES}
        IF cMessageList <> "":U
        THEN DO:
          ASSIGN
            op_error = cMessageList.
          RETURN.
        END.
      END.

    END.

  END.

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
      WHERE lb_rvt_action_underway.action_type            = "ASS":U
      AND   lb_rvt_action_underway.action_table_fla       = ip_fla
      AND   lb_rvt_action_underway.action_scm_object_name = ip_scm_object_name
      NO-ERROR.
    IF NOT AVAILABLE lb_rvt_action_underway
    THEN DO:
      CREATE lb_rvt_action_underway NO-ERROR.
      {af/sup2/afcheckerr.i &no-return = YES}
      IF cMessageList <> "":U
      THEN DO:
        ASSIGN op_error = cMessageList.
        RETURN.
      END.
    END.

    ASSIGN
      lb_rvt_action_underway.action_type            = "ASS":U
      lb_rvt_action_underway.action_table_fla       = ip_fla
      lb_rvt_action_underway.action_primary_key     = "":U    
      lb_rvt_action_underway.action_scm_object_name = ip_scm_object_name
      .  

    VALIDATE lb_rvt_action_underway NO-ERROR.
    {af/sup2/afcheckerr.i &no-return = YES}
    IF cMessageList <> "":U
    THEN DO:
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
    IF AVAILABLE lb_rvt_action_underway
    THEN DO:
      DELETE lb_rvt_action_underway NO-ERROR.
      {af/sup2/afcheckerr.i &no-return = YES}
      IF cMessageList <> "":U
      THEN DO:
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

&IF DEFINED(EXCLUDE-getXMLFilename) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getXMLFilename Procedure 
PROCEDURE getXMLFilename :
/*------------------------------------------------------------------------------
  Purpose:     To return full filename for XML file if it exists in
               current workspace, else returns an empty string, plus return
               relative xml filename.
  Parameters:  input product module object number
               input object name with no path
               output relative path to XML Filename
               output full path to xml file if found
  Notes:       XML File must exist in the propath to get its full path.
               Assumes .ado extension for xml file.
------------------------------------------------------------------------------*/

  DEFINE INPUT  PARAMETER pdModuleObj       AS DECIMAL    NO-UNDO.
  DEFINE INPUT  PARAMETER pcObjectName      AS CHARACTER  NO-UNDO.
  DEFINE OUTPUT PARAMETER pcRelativeXMLFile AS CHARACTER  NO-UNDO.
  DEFINE OUTPUT PARAMETER pcFullXMLFile     AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE cRelativePath             AS CHARACTER  NO-UNDO.

  FIND FIRST gsc_product_module NO-LOCK
    WHERE gsc_product_module.product_module_obj = pdModuleObj
    NO-ERROR.

  ASSIGN
    cRelativePath = "":U.

  IF AVAILABLE gsc_product_module
  THEN
    RUN scmGetModuleDir (INPUT gsc_product_module.product_module_code
                        ,OUTPUT cRelativePath
                        ).

  IF cRelativePath <> "":U
  THEN
    ASSIGN cRelativePath = cRelativePath + "/":U.

  ASSIGN
    pcRelativeXMLFile = pcObjectName.
  RUN scmADOExtAdd (INPUT-OUTPUT pcRelativeXMLFile).
  ASSIGN
    pcRelativeXMLFile = cRelativePath + pcRelativeXMLFile.

  ASSIGN
    pcFullXMLFile = SEARCH(pcRelativeXMLFile)
    .

  IF pcFullXMLFile = ?
  THEN
    ASSIGN pcFullXMLFile = "":U.

  ERROR-STATUS:ERROR = NO.
  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-killPlip) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE killPlip Procedure 
PROCEDURE killPlip :
/*------------------------------------------------------------------------------
  Purpose:     entry point to instantly kill the plip if it should get lost in memory
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

{ry/app/ryplipkill.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-moveModule) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE moveModule Procedure 
PROCEDURE moveModule :
/*------------------------------------------------------------------------------
  Purpose:     To check out an object into a new product module and thereby
               creating a new custom variant. This is called from scmMoveModule
               which was called from the create-cv hook in the SCM tool.
  Parameters:  input task number
               input object name (without .ado already if logical)
               input new product module object number
               input new version number
               input current workspace item object number
               input current configuration item object number
               output error text if any
               
  Notes:       (1) See if config item exists for new module, and if not create it
               (2) Set config item to scm_registered = YES
               (3) Find workspace item exclusive lock
               (4) Find current item version record no lock
               (5) Create new item version record from old one and change module
                   and version.
               (6) upate workspace item task version number to point at new
                   item version and task module to point at new module.
               (7) create a workspace checkout record for workspace item.
               (8) with replication OFF (VIA assign in progress) - change product
                   module on actual object to new module.
               (9) create xml .ado file for new item
                   version using current data in ICFDB repository - which will
                   include new module on object.
               NB: Leave product module alone on gsc_object as this is a shared
                   DB so should not reflect the custom variant.
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER piTask                     AS INTEGER    NO-UNDO.
  DEFINE INPUT PARAMETER pcObjectName               AS CHARACTER  NO-UNDO.
  DEFINE INPUT PARAMETER pdNewModuleObj             AS DECIMAL    NO-UNDO.
  DEFINE INPUT PARAMETER piNewVersion               AS INTEGER    NO-UNDO.
  DEFINE INPUT PARAMETER pdWorkspaceItemObj         AS DECIMAL    NO-UNDO.
  DEFINE INPUT PARAMETER pdConfigItemObj            AS DECIMAL    NO-UNDO.
  DEFINE OUTPUT PARAMETER pcError                   AS CHARACTER  NO-UNDO.

  DEFINE BUFFER brvm_configuration_item             FOR rvm_configuration_item.
  DEFINE BUFFER brvm_workspace_item                 FOR rvm_workspace_item.
  DEFINE BUFFER brvt_workspace_checkout             FOR rvt_workspace_checkout.
  DEFINE BUFFER b1rvt_item_version                  FOR rvt_item_version.
  DEFINE BUFFER b2rvt_item_version                  FOR rvt_item_version.

  DEFINE VARIABLE hBuffer                           AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hField                            AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hQuery                            AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cQueryString                      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lOk                               AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cError                            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE rRowid                            AS ROWID      NO-UNDO.

  ASSIGN
    pcError = "":U.

  FIND FIRST rvm_configuration_item NO-LOCK
    WHERE rvm_configuration_item.configuration_item_obj = pdConfigItemObj
    NO-ERROR.

  FIND FIRST rvc_configuration_type NO-LOCK
    WHERE rvc_configuration_type.configuration_type = rvm_configuration_item.configuration_type
    NO-ERROR.

  DO FOR brvm_configuration_item
        ,brvm_workspace_item
        ,brvt_workspace_checkout
        ,b1rvt_item_version
        ,b2rvt_item_version:

    /* See if config item exists for new module, and if not create it */
    FIND FIRST brvm_configuration_item EXCLUSIVE-LOCK
      WHERE brvm_configuration_item.configuration_type  = rvm_configuration_item.configuration_type
      AND   brvm_configuration_item.scm_object_name     = rvm_configuration_item.scm_object_name
      AND   brvm_configuration_item.product_module_obj  = pdNewModuleObj
      NO-WAIT NO-ERROR.
    IF LOCKED brvm_configuration_item
    THEN DO:
      ASSIGN
        pcError = "Move of object: " + pcObjectName + " Failed. Configuration item locked by another user".
      RETURN.
    END.
    IF NOT AVAILABLE brvm_configuration_item
    THEN DO:
      CREATE brvm_configuration_item NO-ERROR.
      {af/sup2/afcheckerr.i &no-return = YES}
      IF cMessageList <> "":U
      THEN DO:
        ASSIGN
          pcError = cMessageList.
        RETURN.
      END.
    END.
    ASSIGN
      brvm_configuration_item.configuration_type  = rvm_configuration_item.configuration_type
      brvm_configuration_item.scm_object_name     = rvm_configuration_item.scm_object_name
      brvm_configuration_item.product_module_obj  = pdNewModuleObj
      brvm_configuration_item.ITEM_deployable     = rvm_configuration_item.ITEM_deployable
      brvm_configuration_item.scm_registered      = YES  /* (2) Set config item to scm_registered = YES */
      .
    VALIDATE brvm_configuration_item NO-ERROR.    
    {af/sup2/afcheckerr.i &no-return = YES}
    IF cMessageList <> "":U
    THEN DO:
      ASSIGN pcError = cMessageList.
      RETURN.
    END.

    /* (3) Find workspace item exclusive lock and update task details */
    FIND FIRST brvm_workspace_item EXCLUSIVE-LOCK
      WHERE brvm_workspace_item.workspace_item_obj = pdWorkspaceItemObj
      NO-WAIT NO-ERROR.
    IF LOCKED brvm_workspace_item
    THEN DO:
      ASSIGN pcError = "Move of object: " + pcObjectName + " Failed. Workspace item locked by another user".
      RETURN.
    END.

    ASSIGN
      brvm_workspace_item.task_version_number     = piNewVersion
      brvm_workspace_item.task_product_module_obj = pdNewModuleObj
      .

    /* (4) Find current item version record no lock */
    FIND FIRST b1rvt_item_version NO-LOCK
      WHERE b1rvt_item_version.configuration_type   = brvm_workspace_item.configuration_type
      AND   b1rvt_item_version.scm_object_name      = brvm_workspace_item.scm_object_name
      AND   b1rvt_item_version.product_module_obj   = brvm_workspace_item.product_module_obj
      AND   b1rvt_item_version.ITEM_version_number  = brvm_workspace_item.ITEM_version_number
      NO-ERROR.

    /* (5) Create new item version record from old one and change module and version. Create as a baseline version. */
    CREATE b2rvt_item_version NO-ERROR.
    {af/sup2/afcheckerr.i &no-return = YES}
    IF cMessageList <> "":U
    THEN DO:
      ASSIGN
        pcError = cMessageList.
      RETURN.
    END.

    BUFFER-COPY b1rvt_item_version EXCEPT b1rvt_item_version.item_version_obj TO b2rvt_item_version
    ASSIGN
      b2rvt_item_version.item_version_number          = piNewVersion
      b2rvt_item_version.product_module_obj           = pdNewModuleObj
      b2rvt_item_version.task_number                  = piTask
      b2rvt_item_version.baseline_version             = YES
      b2rvt_item_version.previous_product_module_obj  = 0
      b2rvt_item_version.previous_version_number      = 0
      b2rvt_item_version.versions_since_baseline      = 0
      b2rvt_item_version.baseline_product_module_obj  = 0
      b2rvt_item_version.baseline_version_number      = 0
      .

    /* (7) create a workspace checkout record for workspace item. */
    CREATE brvt_workspace_checkout NO-ERROR.
    {af/sup2/afcheckerr.i &no-return = YES}
    IF cMessageList <> "":U
    THEN DO:
      ASSIGN pcError = cMessageList.
      RETURN.
    END.

    ASSIGN
       brvt_workspace_checkout.workspace_obj      = brvm_workspace_item.workspace_obj
       brvt_workspace_checkout.task_number        = piTask
       brvt_workspace_checkout.configuration_type = brvm_workspace_item.configuration_type 
       brvt_workspace_checkout.workspace_item_obj = brvm_workspace_item.workspace_item_obj
       brvt_workspace_checkout.modification_type  = "UNK":U
       .  

    /* Force validation triggers to fire */
    VALIDATE b2rvt_item_version NO-ERROR.
    {af/sup2/afcheckerr.i &no-return = YES}
    IF cMessageList <> "":U
    THEN DO:
      ASSIGN pcError = cMessageList.
      RETURN.
    END.

    VALIDATE brvm_workspace_item NO-ERROR.
    {af/sup2/afcheckerr.i &no-return = YES}
    IF cMessageList <> "":U
    THEN DO:
      ASSIGN pcError = cMessageList.
      RETURN.
    END.

    VALIDATE brvt_workspace_checkout NO-ERROR.
    {af/sup2/afcheckerr.i &no-return = YES}
    IF cMessageList <> "":U
    THEN DO:
      ASSIGN pcError = cMessageList.
      RETURN.
    END.

    /* (8) with replication OFF (VIA assign in progress) - change product
       module on actual object to new module.
    */
    RUN disableAssignReplication (INPUT rvc_configuration_type.configuration_type
                                 ,INPUT pcObjectName
                                 ,OUTPUT rRowid
                                 ,OUTPUT pcError
                                 ).
    IF pcError <> "":U
    THEN RETURN.

    /* Update product module on data item */
    ASSIGN
      cQueryString = "FOR EACH ":U       + rvc_configuration_type.type_table_name
                   + " NO-LOCK WHERE ":U + rvc_configuration_type.type_table_name
                   + ".":U               + rvc_configuration_type.scm_identifying_fieldname
                   + " = '"              + pcObjectName + "'":U.
    CREATE BUFFER hBuffer FOR TABLE rvc_configuration_type.type_table_name NO-ERROR.
    IF ERROR-STATUS:ERROR
    THEN DO:
      ASSIGN
        pcError = "Move of product module onto data item failed. Could not create buffer for table: " + rvc_configuration_type.type_table_name.
      RUN enableAssignReplication  (INPUT rRowid, OUTPUT cError).
      IF cError <> "":U
      THEN ASSIGN pcError = pcError + cError.
      RETURN.
    END.
    CREATE QUERY hQuery.
    hQuery:ADD-BUFFER(hBuffer).
    cQueryString = DYNAMIC-FUNCTION("fixQueryString":U IN gshSessionManager, INPUT cQueryString).
    hQuery:QUERY-PREPARE(cQueryString) NO-ERROR.
    hQuery:QUERY-OPEN() NO-ERROR.
    hQuery:GET-FIRST() NO-ERROR.
    ASSIGN pcError = "":U.
    IF hBuffer:AVAILABLE
    THEN
      ASSIGN pcError = updateBufferField(hBuffer, rvc_configuration_type.product_module_fieldname, STRING(pdNewModuleObj) ).
    hBuffer:BUFFER-RELEASE() NO-ERROR.
    hQuery:QUERY-CLOSE() NO-ERROR.
    DELETE OBJECT hQuery NO-ERROR.
    DELETE OBJECT hBuffer NO-ERROR.
    ASSIGN
      hQuery = ?
      hBuffer = ?
      .
    RUN enableAssignReplication  (INPUT rRowid, OUTPUT cError).
    IF cError <> "":U
    THEN ASSIGN pcError = pcError + cError.
    IF pcError <> "":U
    THEN RETURN.

    /* (9) recreate xml .ado file for new item
       version using current data in ICFDB repository - which will
       include new module on object.
    */
    RUN updateXMLFile (INPUT brvm_workspace_item.workspace_obj,
                       INPUT brvm_workspace_item.product_module_obj,
                       INPUT brvm_workspace_item.configuration_type,
                       INPUT pcObjectName,
                       OUTPUT pcError). 
       
  END. /* do for */

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-objectDescription) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE objectDescription Procedure 
PROCEDURE objectDescription :
/*------------------------------------------------------------------------------
  Purpose:     Pass out a description of the PLIP, used in Plip temp-table
  Parameters:  <none>
  Notes:       This should be changed manually for each plip
------------------------------------------------------------------------------*/

  DEFINE OUTPUT PARAMETER cDescription AS CHARACTER NO-UNDO.

  ASSIGN
    cDescription = "Dynamics Versioning Utility PLIP".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-plipSetup) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE plipSetup Procedure 
PROCEDURE plipSetup :
/*------------------------------------------------------------------------------
  Purpose:    Run by main-block of PLIP at startup of PLIP
  Parameters: <none>
  Notes:       
------------------------------------------------------------------------------*/

  {ry/app/ryplipsetu.i}

  /* If SCM database is connected, start SCM Integration PLIP */
  IF CONNECTED("RTB":U)
  THEN DO:

    DEFINE VARIABLE cProcName                   AS CHARACTER    NO-UNDO.
    DEFINE VARIABLE hProcHandle                 AS HANDLE       NO-UNDO.

    ASSIGN
      cProcName   = "rtb/prc/afrtbprocp.p":U
      hProcHandle = SESSION:FIRST-PROCEDURE.

    DO WHILE VALID-HANDLE(hProcHandle)
    AND hProcHandle:FILE-NAME <> cProcName
    :
      hProcHandle = hProcHandle:NEXT-SIBLING.
    END.

    IF NOT VALID-HANDLE(hProcHandle)
    THEN
      RUN VALUE(cProcName) PERSISTENT SET hProcHandle.

    THIS-PROCEDURE:ADD-SUPER-PROCEDURE(hProcHandle, SEARCH-TARGET).

  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-plipShutdown) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE plipShutdown Procedure 
PROCEDURE plipShutdown :
/*------------------------------------------------------------------------------
  Purpose:     This procedure will be run just before the calling program 
               terminates
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cProcName                   AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE hValidHanldles              AS HANDLE       NO-UNDO.
  DEFINE VARIABLE hProcHandle                 AS HANDLE       NO-UNDO.

  ASSIGN
    cProcName      = "rtb/prc/afrtbprocp.p":U
    hValidHanldles = SESSION:FIRST-PROCEDURE.

  DO WHILE VALID-HANDLE(hValidHanldles)
  AND NOT (VALID-HANDLE(hProcHandle))
  :

    IF hValidHanldles:PRIVATE-DATA = cProcName
    THEN
      ASSIGN
        hProcHandle = hValidHanldles.

    ASSIGN
      hValidHanldles = hValidHanldles:NEXT-SIBLING.

  END.

  IF VALID-HANDLE(hProcHandle)
  THEN
    RUN killPlip IN hProcHandle.

  {ry/app/ryplipshut.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-scmHookAssignObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE scmHookAssignObject Procedure 
PROCEDURE scmHookAssignObject :
/*------------------------------------------------------------------------------
  Purpose:     The purpose of this procedure is to assign an object in the 
               versioning database that correponds to the object being assigned
               in the SCM tool.
               This procedure will be called from the SCM tool just after
               the object is assigned in the SCM Repository. If anything
               fails in this procedure we will have a synchronisation

  Parameters:  input  Current workspace code
               input  Current task number
               input  Current User ID
               input  Object name being assigned
               input  Object type being assigned
               input  Object product module being assigned into
               input  Object version being assigned
               output Error Message if it failed

  Notes:       All validation was done in before assign hook to try and eliminate
               the chance of this failing.

               The assignment of an object into a workspace, simply requires that
               we create a new rvm_workspace_item record for the new object 
               version (or update existing one).
               The object version must already exist in rvt_item_version as a
               checked in object. In addition, we must recreate the data the
               object relates to in the database, using the XML File.
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER  ip_workspace            AS CHARACTER  NO-UNDO.
  DEFINE INPUT PARAMETER  ip_task_number          AS INTEGER    NO-UNDO.
  DEFINE INPUT PARAMETER  ip_user_id              AS CHARACTER  NO-UNDO.
  DEFINE INPUT PARAMETER  ip_object_name          AS CHARACTER  NO-UNDO.
  DEFINE INPUT PARAMETER  ip_object_type          AS CHARACTER  NO-UNDO.
  DEFINE INPUT PARAMETER  ip_product_module       AS CHARACTER  NO-UNDO.
  DEFINE INPUT PARAMETER  ip_object_version       AS INTEGER    NO-UNDO.
  DEFINE OUTPUT PARAMETER op_error                AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE dCurrentModuleObj               AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE dAssignModuleObj                AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE cVersionList                    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cModuleList                     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iPreviousVersion                AS INTEGER    NO-UNDO.
  DEFINE VARIABLE dPreviousModule                 AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE lBaseline                       AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lFoundCreate                    AS LOGICAL    NO-UNDO.

  DEFINE VARIABLE cRootDirXMLFile                 AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cRelativeXMLFile                AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFullXMLFile                    AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE hTable01                  AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hTable02                  AS HANDLE     NO-UNDO.

  DEFINE BUFFER lb1_rvt_item_version FOR rvt_item_version.

  ASSIGN
    hTable01 = ?
    hTable02 = ?
    .

  IF ip_product_module <> "":U
  THEN
    RUN scmSitePrefixDel (INPUT-OUTPUT ip_product_module).

  ASSIGN
    ip_object_name = REPLACE(ip_object_name,".ado":U,"":U)
    NO-ERROR.

  /* Find the registered configuration item based on the SCM object name, and
     if it does not exist in the RVDB database then there is nothing to do
     as far as the RVDB and ICFDB databases are concerned for this object
  */
  FIND FIRST rvm_configuration_item NO-LOCK
    WHERE rvm_configuration_item.scm_object_name = ip_object_name
    NO-ERROR.
  IF NOT AVAILABLE rvm_configuration_item
  THEN RETURN.

  FIND FIRST rvm_workspace NO-LOCK
    WHERE rvm_workspace.workspace_code = ip_workspace
    NO-ERROR.

  FIND FIRST rvc_configuration_type NO-LOCK
    WHERE rvc_configuration_type.configuration_type = rvm_configuration_item.configuration_type 
    NO-ERROR.

  FIND FIRST gsc_product_module NO-LOCK
    WHERE gsc_product_module.product_module_code = ip_product_module
    NO-ERROR.
  ASSIGN
    dAssignModuleObj = gsc_product_module.product_module_obj.

  /* Find the correct configuration item for the object being assigned, i.e. the
     correct product module and object version
  */
  FIND FIRST rvm_configuration_item NO-LOCK
    WHERE rvm_configuration_item.scm_object_name    = ip_object_name
    AND   rvm_configuration_item.configuration_type = rvc_configuration_type.configuration_type
    AND   rvm_configuration_item.product_module_obj = dAssignModuleObj
    NO-ERROR.

  /* See if object already exists in the workspace, and check what its current product
     module is in the workspace
  */
  FIND FIRST rvm_workspace_item NO-LOCK
    WHERE rvm_workspace_item.workspace_obj      = rvm_workspace.workspace_obj
    AND   rvm_workspace_item.configuration_type = rvc_configuration_type.configuration_type
    AND   rvm_workspace_item.scm_object_name    = rvm_configuration_item.scm_object_name
    NO-ERROR.
  IF AVAILABLE rvm_workspace_item
  THEN
    ASSIGN dCurrentModuleObj = rvm_workspace_item.product_module_obj.
  ELSE
    ASSIGN dCurrentModuleObj = 0.

  /* Ensure object version being assigned exists */
  FIND FIRST rvt_item_version NO-LOCK
    WHERE rvt_item_version.configuration_type  = rvm_configuration_item.configuration_type
    AND   rvt_item_version.scm_object_name     = rvm_configuration_item.scm_object_name
    AND   rvt_item_version.product_module_obj  = dAssignModuleObj
    AND   rvt_item_version.item_version_number = ip_object_version
    NO-ERROR.

  /* get full path to xml file if it exists and relative path */
  RUN getXMLFilename (INPUT gsc_product_module.product_module_obj,
                      INPUT ip_object_name,
                      OUTPUT cRelativeXMLFile,
                      OUTPUT cFullXMLFile).
  /*
  The .ado file does not exist for all objects.
  IF cFullXMLFile = "":U
  THEN DO:
    MESSAGE "The dynamic data XML file: " + cRelativeXMLFile SKIP
            "does not exist for object: " + ip_object_name SKIP(1)
            "Object data could not be recreated from xml file" SKIP(1)
            "You should try to re-assign a correct and valid version of the object into" SKIP
            "the workspace to fix the situation." SKIP
            VIEW-AS ALERT-BOX WARNING BUTTONS OK.
  END.
  */

  /* Item version exists and is not checked out - assign new version into workspace */
  ASSIGN op_error = "":U.

  transaction-block:
  DO TRANSACTION ON ERROR UNDO transaction-block, LEAVE transaction-block:

    /* create/update workspace item record for the version - needed for delete/create */
    IF AVAILABLE rvt_item_version
    THEN
      RUN assignWorkspaceItem (INPUT rvm_workspace.workspace_obj,
                               INPUT rvt_item_version.configuration_type,
                               INPUT rvt_item_version.scm_object_name,
                               INPUT rvt_item_version.item_version_number,
                               INPUT gsc_product_module.product_module_obj,
                               OUTPUT op_error).
    IF op_error <> "":U
    THEN UNDO transaction-block, LEAVE transaction-block.

    IF cFullXMLFile <> "":U
    THEN DO:

      ASSIGN
        cRootDirXMLFile = REPLACE(cFullXMLFile,cRelativeXMLFile,"").

      /* recreate the actual data for this item version - from the XML file */
      {af/sup2/afrun2.i &PLIP = 'af/app/gscddxmlp.p'
                        &IProc = 'importDeploymentDataset'
                        &PList = "( INPUT cRelativeXMLFile,~
                                    INPUT cRootDirXMLFile,~
                                    INPUT '':U,~
                                    INPUT YES,~
                                    INPUT YES,~
                                    INPUT NO,~
                                    INPUT TABLE-HANDLE hTable01,~
                                    INPUT TABLE-HANDLE hTable02,~
                                    OUTPUT op_error )"
                        &OnApp = 'no'
                        &Autokill = YES}
  
    END.
    IF op_error <> "":U
    THEN UNDO transaction-block, LEAVE transaction-block.

    /* RE-create/update workspace item record for the version in case deleted during createdataitem */
    IF AVAILABLE rvt_item_version
    THEN
      RUN assignWorkspaceItem (INPUT rvm_workspace.workspace_obj,
                               INPUT rvt_item_version.configuration_type,
                               INPUT rvt_item_version.scm_object_name,
                               INPUT rvt_item_version.item_version_number,
                               INPUT gsc_product_module.product_module_obj,
                               OUTPUT op_error).
    IF op_error <> "":U
    THEN UNDO transaction-block, LEAVE transaction-block.

  END.

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-scmHookAssignObjectBefore) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE scmHookAssignObjectBefore Procedure 
PROCEDURE scmHookAssignObjectBefore :
/*------------------------------------------------------------------------------
  Purpose:     The purpose of this procedure is to do all the preliminary checking
               before assigning an object into the workspace.
               This procedure will be called from the SCM tool just prior to
               the object being assigned in the SCM Repository. If anything
               fails in this procedure, an error message will be returned, which
               should cause the SCM tool to abort the assign also.

               If the SCM tool assign fails - we will have an issue.
                              
  Parameters:  input  Current workspace code
               input  Current task number
               input  Current User ID
               input  Object name being assigned
               input  Object type being assigned
               input  Object product module being assigned into
               input  Object version being assigned
               output Error Message if it failed
  
  Notes:       An object cannot be assigned into a workspace if a checked out
               version of the object already exists in the workspace.
               The checked out object must first be deleted - see the delete
               hook.
               The repository data for the object will be recreated from the
               xml .ado file. As this file will only exist after the SCM
               assign, the hook to recreate the data is only in the after
               assign hook, If the recreate of the data fails for some reason,
               then we will have an issue with synchronisation of the SCM tool
               and RTB.
               These issues are because the whole thing can not occur as part of
               a single transaction.
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER  ip_workspace            AS CHARACTER  NO-UNDO.
  DEFINE INPUT PARAMETER  ip_task_number          AS INTEGER    NO-UNDO.
  DEFINE INPUT PARAMETER  ip_user_id              AS CHARACTER  NO-UNDO.
  DEFINE INPUT PARAMETER  ip_object_name          AS CHARACTER  NO-UNDO.
  DEFINE INPUT PARAMETER  ip_object_type          AS CHARACTER  NO-UNDO.
  DEFINE INPUT PARAMETER  ip_product_module       AS CHARACTER  NO-UNDO.
  DEFINE INPUT PARAMETER  ip_object_version       AS INTEGER    NO-UNDO.
  DEFINE OUTPUT PARAMETER op_error                AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE dCurrentModuleObj               AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE dAssignModuleObj                AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE cVersionList                    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cModuleList                     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iPreviousVersion                AS INTEGER    NO-UNDO.
  DEFINE VARIABLE dPreviousModule                 AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE lBaseline                       AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lFoundCreate                    AS LOGICAL    NO-UNDO.

  DEFINE VARIABLE cRelativeXMLFile                AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFullXMLFile                    AS CHARACTER  NO-UNDO.

  DEFINE BUFFER lb1_rvt_item_version FOR rvt_item_version.

  IF ip_product_module <> "":U
  THEN
    RUN scmSitePrefixDel (INPUT-OUTPUT ip_product_module).

  ASSIGN
    ip_object_name = REPLACE(ip_object_name,".ado":U,"":U)
    NO-ERROR.

  /* Find the registered configuration item based on the SCM object name, and
     if it does not exist in the RVDB database then there is nothing to do
     as far as the RVDB and ICFDB databases are concerned for this object
  */
  FIND FIRST rvm_configuration_item NO-LOCK
    WHERE rvm_configuration_item.scm_object_name = ip_object_name
    NO-ERROR.
  IF NOT AVAILABLE rvm_configuration_item
  THEN RETURN.

  /* Find workspace and ensure it is not locked */
  FIND FIRST rvm_workspace NO-LOCK
    WHERE rvm_workspace.workspace_code = ip_workspace
    NO-ERROR.
  IF NOT AVAILABLE rvm_workspace
  THEN DO:
    ASSIGN
      op_error = "Error assigning object: " + ip_object_name
               + " into workspace: " + ip_workspace
               + ". Workspace not created yet in RVDB.".
    RETURN.
  END.

  IF rvm_workspace.workspace_locked
  THEN DO:
    ASSIGN
      op_error = "Error assigning object: " + ip_object_name
               + " into workspace: " + ip_workspace
               + ". Workspace locked in RVDB.".
    RETURN.
  END.

  /* Find configuration type and ensure it is not locked */
  FIND FIRST rvc_configuration_type NO-LOCK
    WHERE rvc_configuration_type.configuration_type = rvm_configuration_item.configuration_type 
    NO-ERROR.
  IF rvc_configuration_type.type_locked
  THEN DO:
    ASSIGN
      op_error = "Error assigning object: " + ip_object_name
               + " into workspace: "        + ip_workspace
               + ". Configuration type: "   + rvm_configuration_item.configuration_type
               + " is locked in RVDB.".
    RETURN.
  END.

  /* Find the product module being assigned into */
  FIND FIRST gsc_product_module NO-LOCK
    WHERE gsc_product_module.product_module_code = ip_product_module
    NO-ERROR.
  IF NOT AVAILABLE gsc_product_module
  THEN DO:
    ASSIGN
      op_error = "Error assigning object: " + ip_object_name
               + " into workspace: "        + ip_workspace
               + ". Product module: "       + ip_product_module
               + " does not exist in ICFDB.".
    RETURN.
  END.
  ELSE
    ASSIGN
      dAssignModuleObj = gsc_product_module.product_module_obj.

  /* Find the correct configuration item for the object being assigned, i.e. the
     correct product module and object version
  */
  FIND FIRST rvm_configuration_item NO-LOCK
     WHERE rvm_configuration_item.scm_object_name    = ip_object_name
     AND   rvm_configuration_item.configuration_type = rvc_configuration_type.configuration_type
     AND   rvm_configuration_item.product_module_obj = dAssignModuleObj
     NO-ERROR.
  IF NOT AVAILABLE rvm_configuration_item
  THEN DO:
    ASSIGN
      op_error = "Error assigning object: " + ip_object_name
               + " into workspace: "        + ip_workspace
               + ". Configuration item does not exist in RVDB with product module: " + ip_product_module.

    RETURN.
  END.

  /* Ensure object is correctlty registered in SCM tool */
  IF rvm_configuration_item.scm_registered = NO
  THEN DO:
    ASSIGN
      op_error = "Error assigning object: " + ip_object_name
               + " into workspace: "        + ip_workspace
               + ". Configuration item not SCM Registered with product module: " + ip_product_module.
    RETURN.
  END.

  /* See if object already exists in the workspace, and check what its current product
     module is in the workspace
  */
  FIND FIRST rvm_workspace_item NO-LOCK
    WHERE rvm_workspace_item.workspace_obj      = rvm_workspace.workspace_obj
    AND   rvm_workspace_item.configuration_type = rvc_configuration_type.configuration_type
    AND   rvm_workspace_item.scm_object_name    = rvm_configuration_item.scm_object_name
    NO-ERROR.
  IF AVAILABLE rvm_workspace_item
  THEN
    ASSIGN
      dCurrentModuleObj = rvm_workspace_item.product_module_obj.
  ELSE
    ASSIGN
      dCurrentModuleObj = 0.

  /* Ensure an object with same name not already checked out in workspace */
  IF AVAILABLE rvm_workspace_item
  AND (rvm_workspace_item.task_version_number > 0
    OR CAN-FIND(FIRST rvt_workspace_checkout
                WHERE rvt_workspace_checkout.workspace_item_obj = rvm_workspace_item.workspace_item_obj))
  THEN DO:
    ASSIGN
      op_error = "Error assigning object: " + ip_object_name
               + " into workspace: "        + ip_workspace
               + ". The object is already checked out in the workspace in RVDB.".
    RETURN.
  END.

  /* Ensure object version being assigned exists and is not WIP in any workspace */
  FIND FIRST rvt_item_version NO-LOCK
    WHERE rvt_item_version.configuration_type   = rvm_configuration_item.configuration_type
    AND   rvt_item_version.scm_object_name      = rvm_configuration_item.scm_object_name
    AND   rvt_item_version.product_module_obj   = dAssignModuleObj
    AND   rvt_item_version.item_version_number  = ip_object_version
    NO-ERROR.
  IF NOT AVAILABLE rvt_item_version
  THEN DO:
    MESSAGE
      "The object version: " ip_object_name
      " Module: " ip_product_module
      " Version: " STRING(ip_object_version)
      " you are assigning into Roundtable does not" SKIP
      "have a valid item version record in the ICF version database RVDB." SKIP(1)
      "If this is a static object, you may not be concerned with this and may wish" SKIP
      "to continue. If you continue, the physical file version will be extracted" SKIP
      "from Roundtable correctly, but the repository data in the ICFDB database will" SKIP
      "not be updated at all. For things like SmartDataFields that really do not have" SKIP
      "any attributes, this is probably not an issue." SKIP(1)
      "For logical objects with no physical file counterpart - you really should not" SKIP
      "continue, as you may be left with wierd results." SKIP(1)
      "You could try assigning a different version into the workspace that is not corrupt." SKIP
      "You could also try to fix the object integrity using the integrity utility from the " SKIP
      "Roundtable desktop under the ICF options from the primary workspace for the object." SKIP
      "This will fix the RVDB version data. Then try the assign again." SKIP(1)
      "Do you wish to ignore the error and continue?" SKIP(1)
      VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO
      UPDATE lChoice AS LOGICAL.
    IF lChoice = YES
    THEN DO:
      ASSIGN
        op_error = "":U.
      RETURN.    
    END.
    ELSE DO:
      ASSIGN
        op_error = "Assign Failed. Item version does not exist for object: " + ip_object_name + " Module: " + ip_product_module + " Version: " + STRING(ip_object_version).
      RETURN.    
    END.
  END.

  IF CAN-FIND(FIRST rvm_workspace_item
              WHERE rvm_workspace_item.configuration_type = rvt_item_version.configuration_type
              AND   rvm_workspace_item.scm_object_name = rvt_item_version.scm_object_name
              AND   rvm_workspace_item.task_product_module_obj = rvt_item_version.product_module_obj
              AND   rvm_workspace_item.task_version_number = rvt_item_version.item_version_number)
  THEN DO:
    ASSIGN
      op_error = "Item version checked out in a workspace for object: " + ip_object_name
               + " Module: "                                            + ip_product_module
               + " Version: "                                           + STRING(ip_object_version).
    RETURN.
  END.

  /* Item version exists and is not checked out - assign new version into workspace */
  ASSIGN
    op_error = "":U.
  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-scmHookBeforeChangeWorkspace) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE scmHookBeforeChangeWorkspace Procedure 
PROCEDURE scmHookBeforeChangeWorkspace :
/*------------------------------------------------------------------------------
  Purpose:     The purpose of this procedure is to trap a before change of workspace
               in the SCM tool.

  Parameters:  input  Current (old) workspace code
               input  New workspace selected
               input  Current User ID
               output Error Message if it failed
  
  Notes:       Not required for now as all code runs client side only.
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER  ip_workspace            AS CHARACTER  NO-UNDO.
  DEFINE INPUT PARAMETER  ip_new_workspace        AS CHARACTER  NO-UNDO.
  DEFINE INPUT PARAMETER  ip_user_id              AS CHARACTER  NO-UNDO.
  DEFINE OUTPUT PARAMETER op_error                AS CHARACTER  NO-UNDO.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-scmHookChangeTask) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE scmHookChangeTask Procedure 
PROCEDURE scmHookChangeTask :
/*------------------------------------------------------------------------------
  Purpose:     The purpose of this procedure is to trap a change of task
               in the SCM tool, and to update the context database used by
               appserver sessions with the newly selected environment details.
               Appserver sessions need to know what workspace is selected, the
               current task and the current user, in order for the replication
               triggers and versioning business logic to correctly manage the
               data versions within the correct context.
                              
  Parameters:  input  Current workspace code
               input  New task selected
               input  Current User ID
               output Error Message if it failed
  
  Notes:       Not required for now as all code runs client side only.
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER  ip_workspace            AS CHARACTER  NO-UNDO.
  DEFINE INPUT PARAMETER  ip_new_task             AS CHARACTER  NO-UNDO.
  DEFINE INPUT PARAMETER  ip_user_id              AS CHARACTER  NO-UNDO.
  DEFINE OUTPUT PARAMETER op_error                AS CHARACTER  NO-UNDO.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-scmHookChangeWorkspace) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE scmHookChangeWorkspace Procedure 
PROCEDURE scmHookChangeWorkspace :
/*------------------------------------------------------------------------------
  Purpose:     The purpose of this procedure is to trap a change of workspace
               in the SCM tool, and to update the context database used by
               appserver sessions with the newly selected environment details.
               Appserver sessions need to know what workspace is selected, the
               current task and the current user, in order for the replication
               triggers and versioning business logic to correctly manage the
               data versions within the correct context.
                              
  Parameters:  input  Current (old) workspace code
               input  New workspace selected
               input  Current User ID
               output Error Message if it failed
  
  Notes:       Not required for now as all code runs client side only.
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER  ip_workspace            AS CHARACTER  NO-UNDO.
  DEFINE INPUT PARAMETER  ip_new_workspace        AS CHARACTER  NO-UNDO.
  DEFINE INPUT PARAMETER  ip_user_id              AS CHARACTER  NO-UNDO.
  DEFINE OUTPUT PARAMETER op_error                AS CHARACTER  NO-UNDO.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-scmHookCheckInObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE scmHookCheckInObject Procedure 
PROCEDURE scmHookCheckInObject :
/*------------------------------------------------------------------------------
  Purpose:     The purpose of this procedure is to check in an object in the 
               versioning database that correponds to the object being checked
               in in the SCM tool.
               This procedure will be called from the SCM tool just prior to
               the object being checked in in the SCM Repository. If anything
               fails in this procedure, an error message will be returned, which
               should cause the SCM tool to abort the check in also.
                              
  Parameters:  input  Current workspace code
               input  Current task number
               input  Current User ID
               input  Object name being checked in
               output Error Message if it failed
  
  Notes:       When a logical object is checked in, the rvt_workspace_checkout
               record must be deleted, plus the workspace item item version 
               number must be set to the task version number, and the task
               version number set back to 0.
               We must also generate the .ado xml file containing the data source
               code for the object version.
               If the check in into the SCM tool fails, we will not know, so we
               must warn of errors in this procedure, but allow the user to
               continue and tidy up as we go along.
               
               Modified this hook to deal with objects with .ado xml parts that
               do not yet exist in the repository. This would be the case for
               objects loaded externally via a module load for example. In this
               case we must actually use the existing .ado to recreate the
               repository data and fix up the version database too.               

                /* ICF-SCM-CHECK-IN */

------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER  ip_workspace            AS CHARACTER  NO-UNDO.
  DEFINE INPUT PARAMETER  ip_task_number          AS INTEGER    NO-UNDO.
  DEFINE INPUT PARAMETER  ip_user_id              AS CHARACTER  NO-UNDO.
  DEFINE INPUT PARAMETER  ip_object_name          AS CHARACTER  NO-UNDO.
  DEFINE OUTPUT PARAMETER op_error                AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE lv_full_object_name             AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lObjectHasData                  AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lImportedObject                 AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cConfigurationType              AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cProductModule                  AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE lv_continue AS LOGICAL INITIAL NO NO-UNDO.

  ASSIGN
    lv_full_object_name = ip_object_name
    ip_object_name      = REPLACE(ip_object_name,".ado":U,"":U)
    lObjectHasData      = NO
    NO-ERROR.

  RUN scmObjectHasData (INPUT ip_workspace
                       ,INPUT lv_full_object_name
                       ,OUTPUT lObjectHasData
                       ,OUTPUT cProductModule
                       ).

  /* Find the registered configuration item based on the SCM object name, and
     if it does not exist in the RVDB database then there is nothing to do
     as far as the RVDB and ICFDB databases are concerned for this object - unless
     this object has data !
  */
  FIND FIRST rvm_configuration_item NO-LOCK
    WHERE rvm_configuration_item.scm_object_name = ip_object_name
    NO-ERROR.
  IF NOT AVAILABLE rvm_configuration_item
  AND lObjectHasData = NO
  THEN RETURN.

  IF NOT AVAILABLE rvm_configuration_item
  THEN ASSIGN lImportedObject = YES.
  ELSE ASSIGN lImportedObject = NO.

  IF lImportedObject = YES
  THEN DO:
    FIND FIRST gsc_product_module NO-LOCK
      WHERE gsc_product_module.product_module_code = cProductModule
      NO-ERROR.
    IF NOT AVAILABLE gsc_product_module
    THEN DO:
      ASSIGN
        op_error = "Error checking in object: " + ip_object_name
                 + " into workspace: "          + ip_workspace
                 + ". Product Module: "         + cProductModule
                 + " does not exist in ICFDB database".
      RETURN.
    END.
  END.

  IF AVAILABLE rvm_configuration_item
  THEN
    ASSIGN cConfigurationType = rvm_configuration_item.configuration_type.
  ELSE
    ASSIGN cConfigurationType = "RYCSO":U.  

  /* Find workspace and ensure it is not locked */
  FIND FIRST rvm_workspace NO-LOCK
    WHERE rvm_workspace.workspace_code = ip_workspace
    NO-ERROR.
  IF NOT AVAILABLE rvm_workspace
  THEN DO:
    ASSIGN op_error = "Error checking in object: " + ip_object_name +
                      " into workspace: " + ip_workspace +
                      ". Workspace not created yet in RVDB.".
    RETURN.
  END.

  IF rvm_workspace.workspace_locked
  THEN DO:
    ASSIGN op_error = "Error checking in object: " + ip_object_name +
                      " into workspace: " + ip_workspace +
                      ". Workspace locked in RVDB.".
    RETURN.
  END.

  /* Find configuration type and ensure it is not locked */
  FIND FIRST rvc_configuration_type NO-LOCK
    WHERE rvc_configuration_type.configuration_type = cConfigurationType 
    NO-ERROR.
  IF rvc_configuration_type.type_locked
  THEN DO:
    ASSIGN op_error = "Error checking in object: " + ip_object_name +
                      " into workspace: " + ip_workspace +
                      ". Configuration type: " + cConfigurationType + " is locked in RVDB.".
    RETURN.
  END.

  IF NOT lImportedObject
  THEN DO:

    /* Find the workspace item record */
    FIND FIRST rvm_workspace_item NO-LOCK
      WHERE rvm_workspace_item.workspace_obj      = rvm_workspace.workspace_obj
      AND   rvm_workspace_item.configuration_type = cConfigurationType
      AND   rvm_workspace_item.scm_object_name    = ip_object_name
      NO-ERROR.
    IF NOT AVAILABLE rvm_workspace_item
    THEN DO:
      ASSIGN op_error = "Error checking in object: " + ip_object_name +
                        " in workspace: " + ip_workspace +
                        ". Workspace item not found in RVDB for object.".
      RETURN.
    END.
  
    /* Find the correct configuration item for the object being checked in, i.e. the
       correct product module and object version
    */
    IF rvm_workspace_item.task_product_module_obj <> 0
    THEN
      FIND FIRST rvm_configuration_item NO-LOCK
        WHERE rvm_configuration_item.scm_object_name = ip_object_name
        AND   rvm_configuration_item.configuration_type = cConfigurationType
        AND   rvm_configuration_item.product_module_obj = rvm_workspace_item.task_product_module_obj
        NO-ERROR.
    ELSE
      FIND FIRST rvm_configuration_item NO-LOCK
        WHERE rvm_configuration_item.scm_object_name = ip_object_name
        AND   rvm_configuration_item.configuration_type = cConfigurationType
        AND   rvm_configuration_item.product_module_obj = rvm_workspace_item.product_module_obj
        NO-ERROR.
    IF NOT AVAILABLE rvm_configuration_item
    THEN DO:
      ASSIGN op_error = "Error checking in object: " + ip_object_name +
                      " in workspace: " + ip_workspace +
                      ". Configuration item does not exist in RVDB with product module: " + 
                      IF rvm_workspace_item.task_product_module_obj <> 0 THEN STRING(rvm_workspace_item.task_product_module_obj) ELSE STRING(rvm_workspace_item.product_module_obj)
                      .
      RETURN.
    END.
  
    IF rvm_configuration_item.scm_registered = NO
    THEN DO:
      ASSIGN op_error = "Error checking in object: " + ip_object_name +
                      " in workspace: " + ip_workspace +
                      ". Configuration item not SCM Registered in RVDB with product module: " + 
                      IF rvm_workspace_item.task_product_module_obj <> 0 THEN STRING(rvm_workspace_item.task_product_module_obj) ELSE STRING(rvm_workspace_item.product_module_obj)
                      .
      RETURN.    
    END.
  
    IF NOT CAN-FIND(FIRST rvt_workspace_checkout
                    WHERE rvt_workspace_checkout.workspace_item_obj = rvm_workspace_item.workspace_item_obj)
    THEN DO:
      MESSAGE "ICF Data Versioning Error" SKIP(1)
              "Workspace item not checked out for object: " + ip_object_name SKIP(1)
              "This is probably because a previous object check in only partially finished" SKIP
              "but may indicate corrupt data. Please check with your manager BEFORE" SKIP
              "saying YES to this continue question." SKIP(1)
              "Continue?"
              VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE lv_continue.
      IF lv_continue = NO
      THEN DO:
        ASSIGN op_error = "Workspace item not checked out for object: " + ip_object_name.
        RETURN.    
      END.
    END.

  END.  /* not lImportedObject */

  /* Item exists in workspace and is checked out, or it is an imported object - check it in */
  ASSIGN op_error = "":U.

  DEFINE BUFFER brvt_item_version FOR rvt_item_version.

  IF NOT lImportedObject
  THEN
  transaction-block:
  DO FOR brvt_item_version TRANSACTION ON ERROR UNDO transaction-block, LEAVE transaction-block:

    FIND FIRST brvt_item_version EXCLUSIVE-LOCK
      WHERE brvt_item_version.configuration_type = rvm_workspace_item.configuration_type
      AND   brvt_item_version.scm_object_name = rvm_workspace_item.scm_object_name
      AND   brvt_item_version.product_module_obj = rvm_workspace_item.task_product_module_obj
      AND   brvt_item_version.ITEM_version_number = rvm_workspace_item.task_version_number
      NO-WAIT NO-ERROR.
    IF LOCKED brvt_item_version
    THEN DO:
      ASSIGN op_error = "Check-in failed. Cannot baseline object as item version record locked by another user".
      UNDO transaction-block, LEAVE transaction-block.    
    END.
    IF NOT AVAILABLE brvt_item_version
    THEN DO:
      ASSIGN op_error = "Check-in failed. Cannot baseline object as item version record deleted by another user".
      UNDO transaction-block, LEAVE transaction-block.    
    END.

    ASSIGN         
      brvt_item_version.baseline_version            = YES
      brvt_item_version.previous_product_module_obj = 0
      brvt_item_version.previous_version_number     = 0
      brvt_item_version.versions_since_baseline     = 0
      brvt_item_version.baseline_product_module_obj = 0
      brvt_item_version.baseline_version_number     = 0
    .
    VALIDATE brvt_item_version NO-ERROR.
    {af/sup2/afcheckerr.i &no-return = YES}
    IF cMessageList <> "":U
    THEN DO:
      ASSIGN op_error = cMessageList.
      UNDO transaction-block, LEAVE transaction-block.
    END.

    RUN checkInItem (INPUT rvm_workspace_item.workspace_item_obj
                    ,INPUT lv_full_object_name
                    ,OUTPUT op_error
                    ).
    IF op_error <> "":U
    THEN UNDO transaction-block, LEAVE transaction-block.

  END.
  ELSE
  import-block:
  DO TRANSACTION ON ERROR UNDO import-block, LEAVE import-block:
    /* load up temp-table for object */
    EMPTY TEMP-TABLE ttObject.
    CREATE ttObject.
    ASSIGN
      ttObject.cWorkspace     = rvm_workspace.workspace_code
      ttObject.cProductModule = cProductModule
      ttObject.cObjectName    = lv_full_object_name
      .

    /* ICF-SCM-CHECK-IN */
    /* This should not be done as the file needs to be generated.
       All other processing would have created the data or loaded and data into the database already
    /* 1st load data into repository from xml file */
    {af/sup2/afrun2.i &PLIP = 'rtb/prc/ryxmlplipp.p'
                      &IProc = 'loadXMLForObjects'
                      &PList = "( INPUT TABLE ttObject, INPUT-OUTPUT TABLE ttError, OUTPUT op_error )"
                      &OnApp = 'no'
                      &Autokill = YES}
    IF op_error <> "":U THEN UNDO import-block, LEAVE import-block.

    /* then fix RV integrity */
    {af/sup2/afrun2.i &PLIP = 'rtb/prc/ryxmlplipp.p'
                      &IProc = 'SynchRVData'
                      &PList = "( INPUT TABLE ttObject, INPUT-OUTPUT TABLE ttError, OUTPUT op_error )"
                      &OnApp = 'no'
                      &Autokill = YES}
    IF op_error <> "":U THEN UNDO import-block, LEAVE import-block.
    */

    /* then check-in object */
    FIND FIRST rvm_workspace_item NO-LOCK
      WHERE rvm_workspace_item.workspace_obj      = rvm_workspace.workspace_obj
      AND   rvm_workspace_item.configuration_type = cConfigurationType
      AND   rvm_workspace_item.scm_object_name    = ip_object_name
      NO-ERROR.
    IF NOT AVAILABLE rvm_workspace_item
    THEN DO:
      ASSIGN
        op_error = "Failed to update RV workspace item for imported object: " + lv_full_object_name.
      UNDO import-block, LEAVE import-block.
    END.
    RUN checkInItem (INPUT rvm_workspace_item.workspace_item_obj,
                     INPUT lv_full_object_name,
                     OUTPUT op_error).
    IF op_error <> "":U
    THEN UNDO import-block, LEAVE import-block.

  END.

  ERROR-STATUS:ERROR = NO.
  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-scmHookCheckOutObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE scmHookCheckOutObject Procedure 
PROCEDURE scmHookCheckOutObject :
/*------------------------------------------------------------------------------
  Purpose:     The purpose of this procedure is to check out an object in the 
               versioning database that correponds to the object being checked
               out in the SCM tool.
               This procedure will be called from the SCM tool just prior to
               the object being checked out in the SCM Repository. If anything
               fails in this procedure, an error message will be returned, which
               should cause the SCM tool to abort the check out also.
                              
  Parameters:  input  Current workspace code
               input  Current task number
               input  Current User ID
               input  Object name being checked out
               input  Object new version number
               output Error Message if it failed
  
  Notes:       When a logical object is checked out, a rvt_workspace_checkout
               record must be created for the checked out object.
               We must ensure that the object is not already checked out.
               In addition, we must update the task version number on the 
               workspace item, and create a new item version record.

               This hook will actually be called twice. The first time in a
               before checkout hook which may be cancelled, and the second time
               in an after checkout hook which cannot be cancelled.
               
               The first time called, the new version number will be passed in as
               0, indicating we must do all the checks, and create records with
               a dummy negative old version number.
               
               The second time called, the new version number will be greater than
               0 and will be the real new version number, so the records updated
               with the negative old version number must then be updated with the
               real new version number.
               
               If the new version number is 999999 we have a problem.
               
               We could potentially have a problem if the update of the real
               new version number fails however - we may later need to tidy up by
               forcing a delete of the wip object in the SCM tool. We will
               leave this mod for later if it is required.
               
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER  ip_workspace            AS CHARACTER  NO-UNDO.
  DEFINE INPUT PARAMETER  ip_task_number          AS INTEGER    NO-UNDO.
  DEFINE INPUT PARAMETER  ip_user_id              AS CHARACTER  NO-UNDO.
  DEFINE INPUT PARAMETER  ip_object_name          AS CHARACTER  NO-UNDO.
  DEFINE INPUT PARAMETER  ip_new_version_number   AS INTEGER    NO-UNDO.
  DEFINE OUTPUT PARAMETER op_error                AS CHARACTER  NO-UNDO.

  ASSIGN
    ip_object_name = REPLACE(ip_object_name,".ado":U,"":U) NO-ERROR.

  /* Find the registered configuration item based on the SCM object name, and
     if it does not exist in the RVDB database then there is nothing to do
     as far as the RVDB and ICFDB databases are concerned for this object
  */
  FIND FIRST rvm_configuration_item NO-LOCK
    WHERE rvm_configuration_item.scm_object_name = ip_object_name
    NO-ERROR.
  IF NOT AVAILABLE rvm_configuration_item
  THEN RETURN.

  /* Find workspace and ensure it is not locked */
  FIND FIRST rvm_workspace NO-LOCK
    WHERE rvm_workspace.workspace_code = ip_workspace
    NO-ERROR.
  IF NOT AVAILABLE rvm_workspace
  THEN DO:
    ASSIGN op_error = "Error checking out object: " + ip_object_name +
                    " in workspace: " + ip_workspace +
                    ". Workspace not created yet in RVDB.".
    RETURN.
  END.

  IF rvm_workspace.workspace_locked
  THEN DO:
    ASSIGN op_error = "Error checking out object: " + ip_object_name +
                    " in workspace: " + ip_workspace +
                    ". Workspace locked in RVDB.".
    RETURN.
  END.

  /* Find configuration type and ensure it is not locked */
  FIND FIRST rvc_configuration_type NO-LOCK
    WHERE rvc_configuration_type.configuration_type = rvm_configuration_item.configuration_type 
    NO-ERROR.
  IF rvc_configuration_type.type_locked
  THEN DO:
    ASSIGN op_error = "Error checking out object: " + ip_object_name +
                    " in workspace: " + ip_workspace +
                    ". Configuration type: " + rvm_configuration_item.configuration_type + " is locked in RVDB.".
    RETURN.
  END.

  /* Find the workspace item record */
  FIND FIRST rvm_workspace_item NO-LOCK
    WHERE rvm_workspace_item.workspace_obj      = rvm_workspace.workspace_obj
    AND   rvm_workspace_item.configuration_type = rvc_configuration_type.configuration_type
    AND   rvm_workspace_item.scm_object_name    = ip_object_name
    NO-ERROR.
  IF NOT AVAILABLE rvm_workspace_item
  THEN DO:
    ASSIGN op_error = "Error checking out object: " + ip_object_name +
                    " in workspace: " + ip_workspace +
                    ". Workspace item not found in RVDB for object.".
    RETURN.
  END.

  /* Find the correct configuration item for the object being checked out, i.e. the
     correct product module and object version
  */
  FIND FIRST rvm_configuration_item NO-LOCK
    WHERE rvm_configuration_item.scm_object_name    = ip_object_name
    AND   rvm_configuration_item.configuration_type = rvc_configuration_type.configuration_type
    AND   rvm_configuration_item.product_module_obj = rvm_workspace_item.product_module_obj
    NO-ERROR.
  IF NOT AVAILABLE rvm_configuration_item
  THEN DO:
    ASSIGN op_error = "Error checking out object: " + ip_object_name +
                      " in workspace: " + ip_workspace +
                      ". Configuration item does not exist in RVDB with product module: " + STRING(rvm_workspace_item.product_module_obj).
    RETURN.
  END.

  IF rvm_configuration_item.scm_registered = NO
  AND ip_new_version_number = 0
  THEN DO:
    ASSIGN op_error = "Error checking out object: " + ip_object_name +
                      " in workspace: " + ip_workspace +
                      ". Configuration item not SCM Registered in RVDB with product module: " + STRING(rvm_workspace_item.product_module_obj).
    RETURN.    
  END.

  IF ip_new_version_number = 0
  AND CAN-FIND(FIRST rvt_workspace_checkout
               WHERE rvt_workspace_checkout.workspace_item_obj = rvm_workspace_item.workspace_item_obj)
  THEN DO:
    ASSIGN op_error = "Workspace item already checked out for object: " + ip_object_name.
    RETURN.    
  END.

  IF ip_new_version_number = 999999
  THEN DO:
    ASSIGN op_error = "Invalid new version number (999999) for object: " + ip_object_name.
    RETURN.    
  END.

  IF ip_new_version_number = 0
  THEN DO:
    FIND FIRST gsc_product_module NO-LOCK
      WHERE gsc_product_module.product_module_obj = rvm_workspace_item.product_module_obj
      NO-ERROR.
    IF NOT AVAILABLE gsc_product_module
    THEN DO:
      ASSIGN op_error = "Check-out failed for object: " + ip_object_name + " because product module: " + STRING(rvm_workspace_item.product_module_obj) +
                        " does not exist in the ICFDB database.".
      RETURN.    
    END.
  END.

  /* Item exists in workspace and is not already checked out - check it out */
  ASSIGN op_error = "":U.

  transaction-block:
  DO TRANSACTION ON ERROR UNDO transaction-block, LEAVE transaction-block:

    IF ip_new_version_number = 0
    THEN DO:
      RUN checkOutItemCreate (INPUT rvm_workspace_item.workspace_item_obj
                             ,INPUT ip_task_number
                             ,OUTPUT op_error
                             ).
      IF op_error <> "":U
      THEN UNDO transaction-block, LEAVE transaction-block.
    END.
    ELSE DO:
      RUN checkOutItemUpdate (INPUT rvm_workspace_item.workspace_item_obj
                             ,INPUT ip_new_version_number
                             ,OUTPUT op_error
                             ).
      IF op_error <> "":U
      THEN UNDO transaction-block, LEAVE transaction-block.
    END.

  END.

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-scmHookCompleteTask) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE scmHookCompleteTask Procedure 
PROCEDURE scmHookCompleteTask :
/*------------------------------------------------------------------------------
  Purpose:     The purpose of this procedure is to do pre-task completion
               procedures, and to abort the task completion if necessary.
               This procedure will be called from the SCM tool just prior to
               the task being completed in the SCM tool. If anything
               fails in this procedure, an error message will be returned, which
               should cause the SCM tool to abort the task completion.
                              
  Parameters:  input  Current workspace code
               input  Task number being completed
               input  Current User ID
               output Error Message if it failed
  
  Notes:       Task completion must first check for any unregistered logical
               items in the versioning database associated with the task, and
               create corresponding SCM objects.
               It must also check for deleted items in the versioning database
               for the task and delete these from the SCM tool.
               Any items flagged as unregistered in the versioning database will
               definitely not exist already in the SCM Tool, as the versioning
               system will check if an object already exists in the SCM tool and
               prevent creation / modification of the data until the item is
               checked out under the same task.
               New logical objects will not exist in the SCM tool as .ado objects
               until the task is completed.
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER  ip_workspace            AS CHARACTER  NO-UNDO.
  DEFINE INPUT PARAMETER  ip_task_number          AS INTEGER    NO-UNDO.
  DEFINE INPUT PARAMETER  ip_user_id              AS CHARACTER  NO-UNDO.
  DEFINE OUTPUT PARAMETER op_error                AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE lv_recid                        AS RECID      NO-UNDO.

  DEFINE VARIABLE lv_continue                     AS LOGICAL INITIAL NO NO-UNDO.

  DEFINE VARIABLE lv_exists_in_rtb                AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lv_exists_in_workspace          AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lv_workspace_version            AS INTEGER    NO-UNDO.
  DEFINE VARIABLE lv_workspace_checked_out        AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lv_version_task_number          AS INTEGER    NO-UNDO.
  DEFINE VARIABLE lv_latest_version               AS INTEGER    NO-UNDO.

  /* Find workspace and ensure it is not locked */
  FIND FIRST rvm_workspace NO-LOCK
    WHERE rvm_workspace.workspace_code = ip_workspace
    NO-ERROR.
  IF NOT AVAILABLE rvm_workspace
  THEN RETURN.

  IF rvm_workspace.workspace_locked
  THEN DO:
    ASSIGN op_error = "Task completion hook aborted. Workspace locked: " + ip_workspace.
    RETURN.    
  END.

  /* Empty temp-table of registered items */
  IF NOT TRANSACTION
  THEN
    EMPTY TEMP-TABLE tt_register_item.
  ELSE DO:
    FOR EACH tt_register_item EXCLUSIVE-LOCK:
      DELETE tt_register_item.
    END.
  END.

  /* Find unregistered objects in task */
  FOR EACH rvt_item_version NO-LOCK
    WHERE rvt_item_version.task_number = ip_task_number
   ,FIRST rvm_configuration_item NO-LOCK
      WHERE rvm_configuration_item.configuration_type = rvt_item_version.configuration_type
      AND rvm_configuration_item.scm_object_name      = rvt_item_version.scm_object_name
      AND rvm_configuration_item.product_module_obj   = rvt_item_version.product_module_obj
      AND rvm_configuration_item.scm_registered       = NO
    :
  
    FIND FIRST rvc_configuration_type NO-LOCK
      WHERE rvc_configuration_type.configuration_type = rvm_configuration_item.configuration_type
      NO-ERROR.
    IF NOT AVAILABLE rvc_configuration_type
    THEN DO:
      ASSIGN op_error = "Invalid unregistered configuration item with configuration type: " + rvm_configuration_item.configuration_type.
      RETURN.    
    END.

    FIND FIRST gsc_product_module NO-LOCK
      WHERE gsc_product_module.product_module_obj = rvm_configuration_item.product_module_obj
      NO-ERROR.
    IF NOT AVAILABLE gsc_product_module
    THEN DO:
      ASSIGN op_error = "Invalid unregistered configuration item product module".
      RETURN.    
    END.

    /* Check if object already exists in SCM Tool */
    ASSIGN lv_exists_in_rtb = NO.

    RUN scmObjectExists (INPUT rvm_configuration_item.scm_object_name
                        ,INPUT ip_workspace
                        ,OUTPUT lv_exists_in_rtb
                        ,OUTPUT lv_exists_in_workspace
                        ,OUTPUT lv_workspace_version
                        ,OUTPUT lv_workspace_checked_out
                        ,OUTPUT lv_version_task_number
                        ,OUTPUT lv_latest_version
                        ).

    IF lv_exists_in_rtb
    THEN DO:
      ASSIGN op_error = "Duplicate object in SCM Tool - task completion aborted, object: " + rvm_configuration_item.scm_object_name.
      RETURN.    
    END.

    FIND FIRST tt_register_item EXCLUSIVE-LOCK
      WHERE tt_register_item.scm_object_name = rvm_configuration_item.scm_object_name
      NO-ERROR. 
    IF NOT AVAILABLE tt_register_item
    THEN
      CREATE tt_register_item.

    ASSIGN
      tt_register_item.scm_object_name          = rvm_configuration_item.scm_object_name
      tt_register_item.configuration_type       = rvm_configuration_item.configuration_type
      tt_register_item.item_version_number      = rvt_item_version.item_version_number
      tt_register_item.register_action          = "CRE":U
      tt_register_item.product_module_code      = gsc_product_module.product_module_code
      tt_register_item.object_sub_type          = rvc_configuration_type.scm_code 
      tt_register_item.object_group             = rvc_configuration_type.scm_code
      tt_register_item.object_level             = 100
      tt_register_item.object_description       = rvt_item_version.item_description
      tt_register_item.configuration_item_rowid = ROWID(rvm_configuration_item)
      .

    END.

    /* Find deleted objects in task */
    FOR EACH rvt_deleted_item NO-LOCK
      WHERE rvt_deleted_item.workspace_obj  = rvm_workspace.workspace_obj
      AND   rvt_deleted_item.task_number    = ip_task_number:

    FIND FIRST rvm_configuration_item NO-LOCK
      WHERE rvm_configuration_item.configuration_type = rvt_deleted_item.configuration_type
      AND   rvm_configuration_item.scm_object_name    = rvt_deleted_item.scm_object_name
      AND   rvm_configuration_item.product_module_obj = rvt_deleted_item.product_module_obj
      NO-ERROR.
    IF NOT AVAILABLE rvm_configuration_item
    THEN DO:
      ASSIGN op_error = "Invalid deleted configuration item for object: " + rvt_deleted_item.scm_object_name.
      RETURN.    
    END.

    FIND FIRST gsc_product_module NO-LOCK
      WHERE gsc_product_module.product_module_obj = rvm_configuration_item.product_module_obj
      NO-ERROR.
    IF NOT AVAILABLE gsc_product_module
    THEN DO:
      ASSIGN op_error = "Invalid deleted configuration item product module".
      RETURN.    
    END.

    FIND FIRST tt_register_item EXCLUSIVE-LOCK
      WHERE tt_register_item.scm_object_name = rvm_configuration_item.scm_object_name
      NO-ERROR. 
    IF NOT AVAILABLE tt_register_item
    THEN CREATE tt_register_item.

    ASSIGN
      tt_register_item.scm_object_name      = rvt_deleted_item.scm_object_name
      tt_register_item.configuration_type   = rvt_deleted_item.configuration_type
      tt_register_item.register_action      = "DEL":U
      tt_register_item.product_module_code  = gsc_product_module.product_module_code
      tt_register_item.deleted_item_rowid   = ROWID(rvt_deleted_item)
      .

  END.

  /* Now we have the information on what to register / delete - call SCM Tool APIs
     and update registered flags / delete deleted items, etc.
  */

  transaction-block:
  DO TRANSACTION ON ERROR UNDO transaction-block, LEAVE transaction-block:

    FOR EACH tt_register_item:

      IF  tt_register_item.register_action = "DEL":U
      THEN DO: /* delete item */
        /* Call SCM Tool API to delete item */
        RUN scmDeleteObjectControl (INPUT tt_register_item.product_module_code
                                   ,INPUT "PCODE":U
                                   ,INPUT tt_register_item.scm_object_name
                                   ,INPUT ip_task_number
                                   ,INPUT "no-prompt"
                                   ,OUTPUT op_error
                                   ).
        IF op_error <> "":U
        THEN op_error = op_error + ", cannot delete object: " + tt_register_item.scm_object_name.
        IF op_error <> "":U
        THEN UNDO transaction-block, LEAVE transaction-block.

        /* get rid of deleted item record */
        RUN deleteDeletedItems (INPUT rvm_workspace.workspace_obj
                               ,INPUT tt_register_item.configuration_type
                               ,INPUT tt_register_item.scm_object_name
                               ,INPUT tt_register_item.product_module_code
                               ,OUTPUT op_error
                               ).
        IF op_error <> "":U
        THEN UNDO transaction-block, LEAVE transaction-block.
      END.
      ELSE DO: /* create / register item */
        /* Call SCM Tool API to create item */
        RUN scmCreateObjectControl (INPUT tt_register_item.scm_object_name
                                   ,INPUT "PCODE":U
                                   ,INPUT tt_register_item.object_sub_type
                                   ,INPUT tt_register_item.product_module_code
                                   ,INPUT tt_register_item.object_group
                                   ,INPUT tt_register_item.object_level
                                   ,INPUT tt_register_item.object_description
                                   ,INPUT "":U           /* options */
                                   ,INPUT ip_task_number
                                   ,INPUT NO             /* no UI */
                                   ,INPUT "central":U    /* share status to use */
                                   ,INPUT YES            /* create physical file on disk */
                                   ,INPUT "":U           /* physical file template */
                                   ,OUTPUT lv_recid
                                   ,OUTPUT op_error).
        IF op_error <> "":U
        THEN UNDO transaction-block, LEAVE transaction-block.
      
        /* Reset registered flag */
        RUN setRegisteredFlag (INPUT tt_register_item.configuration_item_rowid
                              ,OUTPUT op_error
                              ).
        IF op_error <> "":U
        THEN UNDO transaction-block, LEAVE transaction-block.

      END.
    END.
  END.

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-scmHookCreateObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE scmHookCreateObject Procedure 
PROCEDURE scmHookCreateObject :
/*------------------------------------------------------------------------------
  Purpose:     The purpose of this procedure is to ensure it is valid to create
               the object in the SCM repository.
               This procedure will be called from the SCM tool just after
               an object has been created in the SCM Repository. If anything
               fails in this procedure, an error message will be returned, but the
               object has already been created in the SCM tool, so the user must
               manually fix things.

  Parameters:  input  Current workspace code
               input  Current task number
               input  Current User ID
               input  Object name being created
               output Error Message if it failed

  Notes:       Objects can only be created in the SCM tool providing a
               corresponding object exists in the versioning database in
               rvm_configuration_item as unregistered, thus ensuring the data
               already exists and has not already been registered.
               We must also check that the workspace and configuration type are
               not locked.
               As mentioned above, we can only inform the user of the problem and
               ask them to sort it out as the object creation cannot be cancelled.
               The reason for this is the hook is from the after object add rather
               than before object add, as we do not know whether it is a logical
               object in the before hook (we are not given the subtype).
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER  ip_workspace            AS CHARACTER  NO-UNDO.
  DEFINE INPUT PARAMETER  ip_task_number          AS INTEGER    NO-UNDO.
  DEFINE INPUT PARAMETER  ip_user_id              AS CHARACTER  NO-UNDO.
  DEFINE INPUT PARAMETER  ip_object_name          AS CHARACTER  NO-UNDO.
  DEFINE OUTPUT PARAMETER op_error                AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE lExistsInRtb                    AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lExistsInWorkspace              AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE iWorkspaceVersion               AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cWorkspaceModule                AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lWorkspaceCheckedOut            AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE iVersioninTask                  AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iLatestVersion                  AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cObjectSummary                  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cObjectDescription              AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cObjectUpdNotes                 AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cPrevVersions                   AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE cObjectType                     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cModuleDir                      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cAttrNames                      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cAttrValues                     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE dObjectNumber                   AS DECIMAL    NO-UNDO.

  ASSIGN
    ip_object_name = REPLACE(ip_object_name,".ado":U,"":U)
    NO-ERROR.

  /* Find workspace and ensure it is not locked */
  FIND FIRST rvm_workspace NO-LOCK
    WHERE rvm_workspace.workspace_code = ip_workspace
    NO-ERROR.
  IF NOT AVAILABLE rvm_workspace
  THEN DO:
    ASSIGN
      op_error = "Data versioning problem - Workspace not found: " + ip_workspace.
    RETURN.
  END.
  IF rvm_workspace.workspace_locked
  THEN DO:
    ASSIGN
      op_error = "Data versioning problem - Workspace locked: " + ip_workspace.
    RETURN.
  END.

  /* This could be done from the RTB desktop and should not require the file to be in the ICFDB.
     This option must allow the creation of the object in the ICFDB as per a load, assign or module move */

  /* Find the unregistered configuration item based on the SCM object name */
  /* FIND FIRST rvm_configuration_item NO-LOCK                                                       */
  /*      WHERE rvm_configuration_item.scm_object_name = ip_object_name                              */
  /*      NO-ERROR.                                                                                  */
  /* IF NOT AVAILABLE rvm_configuration_item THEN                                                    */
  /* DO:                                                                                             */
  /*   ASSIGN op_error = "Configuration item not found for object: " + ip_object_name + CHR(10) +    */
  /*          "Please delete the object from the SCM tool and correctly create it from" + CHR(10) +  */
  /*          "the ICF Repository Tools where all versioned logical objects should be" + CHR(10) +   */
  /*          "created"                                                                              */
  /*          .                                                                                      */
  /*   RETURN.                                                                                       */
  /* END.                                                                                            */

  /* IF rvm_configuration_item.scm_registered THEN                                                    */
  /* DO:                                                                                              */
  /*   ASSIGN op_error = "Configuration item already SCM registered for object: " + ip_object_name.   */
  /*   RETURN.                                                                                        */
  /* END.                                                                                             */
  /*                                                                                                  */
  /* /* Find configuration type and ensure it is not locked */                                        */
  /* FIND FIRST rvc_configuration_type NO-LOCK                                                        */
  /*      WHERE rvc_configuration_type.configuration_type = rvm_configuration_item.configuration_type */
  /*      NO-ERROR.                                                                                   */
  /* IF rvc_configuration_type.TYPE_locked THEN                                                       */
  /* DO:                                                                                              */
  /*   ASSIGN op_error = "Configuration type locked: " + rvm_configuration_item.configuration_type.   */
  /*   RETURN.                                                                                        */
  /* END.                                                                                             */

  DEFINE VARIABLE hObjApi   AS HANDLE   NO-UNDO.

  RUN scmFullObjectInfo (INPUT  ip_object_name
                        ,INPUT  ip_workspace
                        ,INPUT  ip_task_number
                        ,OUTPUT lExistsInRtb
                        ,OUTPUT lExistsInWorkspace
                        ,OUTPUT iWorkspaceVersion
                        ,OUTPUT cWorkspaceModule
                        ,OUTPUT lWorkspaceCheckedOut
                        ,OUTPUT iVersioninTask
                        ,OUTPUT iLatestVersion
                        ,OUTPUT cObjectSummary
                        ,OUTPUT cObjectDescription
                        ,OUTPUT cObjectUpdNotes
                        ,OUTPUT cPrevVersions
                        ).
  RUN scmGetModuleDir  (INPUT  cWorkspaceModule
                       ,OUTPUT cModuleDir
                       ).

  RUN scmObjectSubType (INPUT  ip_workspace
                       ,INPUT  ip_object_name
                       ,OUTPUT cObjectType /* Actual SubType and not ObjectType of PCODE */
                       ).

  RUN ry/app/ryreposobp.p PERSISTENT SET hObjApi.

  ASSIGN
    cAttrNames  = "ObjectPath,StaticObject":U
    cAttrValues = cModuleDir + CHR(3) + "yes":U + CHR(3)
    .

  RUN storeObject IN hObjApi 
                 (INPUT  cObjectType
                 ,INPUT  cWorkspaceModule
                 ,INPUT  ip_object_name
                 ,INPUT  cObjectDescription
                 ,INPUT  cAttrNames
                 ,INPUT  cAttrValues
                 ,OUTPUT dObjectNumber
                 ).

/*
  IF lExistsinRtb
  THEN DO:

    IF NOT lExistsInWorkspace
    THEN DO:
      ASSIGN
        op_error = "Create Failed. Object exists in SCM Tool, but not in the selected workspace".
      RETURN.    
    END.

    IF lExistsInWorkspace
    THEN DO:
      ASSIGN
        op_error = "Create Failed. Object exists in SCM Tool in the selected workspace".
      RETURN.    
    END.

    ASSIGN
      lSCMOk = NO.

  END.
*/

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-scmHookDeleteObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE scmHookDeleteObject Procedure 
PROCEDURE scmHookDeleteObject :
/*------------------------------------------------------------------------------
  Purpose:     The purpose of this procedure is to delete an object from the 
               versioning database that correponds to the object being deleted
               in the SCM tool, plus the data the object relates to.
               This procedure will be called from the SCM tool just prior to
               an object being deleted from the SCM Repository. If anything
               fails in this procedure, an error message will be returned, which
               should cause the SCM tool to abort the deletion also.
                              
  Parameters:  input  Current workspace code
               input  Current task number
               input  Current User ID
               input  Object name being deleted
               output Error Message if it failed
  
  Notes:       The actual data the object relates to must be deleted,
               then the workspace item must be deleted to remove it from the workspace.
               If the workspace item had a valid task version number
                (i.e. it was a checked out version),
               then the rvt_item_version pointed at by the task version number must also be deleted
                - this will remove all traces of this checked out object version.
               This is correct as if a checked out object is deleted,
               then it should be as if it never existed.
               Checked in object versions however can never be deleted,
               they may only be removed from a workspace.
               Also we may need to tidy up the rvt_deleted_item table if an
               object is deleted in Roundtable before the task is completed
               - as this table contains pending SCM deletions.
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER  ip_workspace            AS CHARACTER  NO-UNDO.
  DEFINE INPUT PARAMETER  ip_task_number          AS INTEGER    NO-UNDO.
  DEFINE INPUT PARAMETER  ip_user_id              AS CHARACTER  NO-UNDO.
  DEFINE INPUT PARAMETER  ip_object_name          AS CHARACTER  NO-UNDO.
  DEFINE OUTPUT PARAMETER op_error                AS CHARACTER  NO-UNDO.

  DEFINE BUFFER brvm_configuration_item FOR rvm_configuration_item.

  ASSIGN
    ip_object_name = REPLACE(ip_object_name,".ado":U,"":U) NO-ERROR.

  DEFINE VARIABLE lv_continue           AS LOGICAL INITIAL NO NO-UNDO.
  DEFINE VARIABLE lv_configuration_type AS CHARACTER  NO-UNDO.

  /* Find the registered configuration item based on the SCM object name, and
     if it does not exist in the RVDB database then there is nothing to do
     as far as the RVDB and ICFDB databases are concerned for this object
  */
  FIND FIRST rvm_configuration_item NO-LOCK
    WHERE rvm_configuration_item.scm_object_name = ip_object_name
    NO-ERROR.
  IF NOT AVAILABLE rvm_configuration_item
  THEN RETURN.

  /* Find workspace and ensure it is not locked */
  FIND FIRST rvm_workspace NO-LOCK
    WHERE rvm_workspace.workspace_code = ip_workspace
    NO-ERROR.
  IF NOT AVAILABLE rvm_workspace
  THEN DO:
    ASSIGN op_error = "Error deleting object: " + ip_object_name +
                      " in workspace: " + ip_workspace +
                      ". Workspace not created yet in RVDB.".
    RETURN.
  END.

  IF rvm_workspace.workspace_locked
  THEN DO:
    ASSIGN op_error = "Error deleting object: " + ip_object_name +
                      " in workspace: " + ip_workspace +
                      ". Workspace locked in RVDB.".
    RETURN.
  END.

  /* Find configuration type and ensure it is not locked */
  FIND FIRST rvc_configuration_type NO-LOCK
    WHERE rvc_configuration_type.configuration_type = rvm_configuration_item.configuration_type 
    NO-ERROR.
  IF rvc_configuration_type.type_locked
  THEN DO:
    ASSIGN op_error = "Error deleting object: " + ip_object_name +
                      " in workspace: " + ip_workspace +
                      ". Configuration type: " + rvm_configuration_item.configuration_type + " is locked in RVDB.".
    RETURN.
  END.

  /* Find the workspace item record */
  FIND FIRST rvm_workspace_item NO-LOCK
    WHERE rvm_workspace_item.workspace_obj = rvm_workspace.workspace_obj
    AND rvm_workspace_item.configuration_type = rvc_configuration_type.configuration_type
    AND rvm_workspace_item.scm_object_name = ip_object_name
    NO-ERROR.
  IF NOT AVAILABLE rvm_workspace_item
  THEN DO:
    ASSIGN op_error = "Error deleting object: " + ip_object_name +
                      " in workspace: " + ip_workspace +
                      ". Workspace item not found in RVDB for object.".
    RETURN.
  END.

  IF rvm_workspace_item.task_product_module_obj <> 0
  THEN
    FIND FIRST gsc_product_module NO-LOCK
      WHERE gsc_product_module.product_module_obj = rvm_workspace_item.task_product_module_obj
      NO-ERROR.
  ELSE
    FIND FIRST gsc_product_module NO-LOCK
      WHERE gsc_product_module.product_module_obj = rvm_workspace_item.product_module_obj
      NO-ERROR.

  /* Find the correct configuration item for the object being deleted, i.e. the
     correct product module and object version
  */
  IF rvm_workspace_item.task_product_module_obj <> 0
  THEN
    FIND FIRST rvm_configuration_item NO-LOCK
      WHERE rvm_configuration_item.scm_object_name = ip_object_name
      AND rvm_configuration_item.configuration_type = rvc_configuration_type.configuration_type
      AND rvm_configuration_item.product_module_obj = rvm_workspace_item.task_product_module_obj
      NO-ERROR.
  ELSE
    FIND FIRST rvm_configuration_item NO-LOCK
      WHERE rvm_configuration_item.scm_object_name = ip_object_name
      AND rvm_configuration_item.configuration_type = rvc_configuration_type.configuration_type
      AND rvm_configuration_item.product_module_obj = rvm_workspace_item.product_module_obj
      NO-ERROR.

  IF NOT AVAILABLE rvm_configuration_item
  THEN DO:
    ASSIGN op_error = "Error deleting object: " + ip_object_name +
                      " in workspace: " + ip_workspace +
                      ". Configuration item does not exist in RVDB with product module: " + 
                      IF rvm_workspace_item.task_product_module_obj <> 0 THEN STRING(rvm_workspace_item.task_product_module_obj) ELSE STRING(rvm_workspace_item.product_module_obj)
                      .
    RETURN.
  END.

  ASSIGN
    lv_configuration_type = rvm_configuration_item.configuration_type.

  IF rvm_configuration_item.scm_registered = NO
  THEN DO:
    ASSIGN op_error = "Error deleting object: " + ip_object_name +
                      " in workspace: " + ip_workspace +
                      ". Configuration item not SCM Registered in RVDB with product module: " + 
                      IF rvm_workspace_item.task_product_module_obj <> 0 THEN STRING(rvm_workspace_item.task_product_module_obj) ELSE STRING(rvm_workspace_item.product_module_obj)
                      .
    RETURN.    
  END.

  /* First we must delete the actual item of data the SCM object relates to */
  DEFINE VARIABLE lh_buffer AS HANDLE NO-UNDO.
  DEFINE VARIABLE lh_query  AS HANDLE NO-UNDO.
  DEFINE VARIABLE lv_query_string AS CHARACTER NO-UNDO.
  DEFINE VARIABLE lv_ok AS LOGICAL NO-UNDO.

  /* Set-up query string to find the item of data */
  ASSIGN
    lv_query_string = "FOR EACH ":U + rvc_configuration_type.type_table_name + " NO-LOCK WHERE ":U +
                      rvc_configuration_type.type_table_name + ".":U + rvc_configuration_type.scm_identifying_fieldname + " = '" +
                      ip_object_name + "'":U.

  /* Create a dynamic buffer / query to find the item */
  CREATE BUFFER lh_buffer FOR TABLE rvc_configuration_type.type_table_name NO-ERROR.
  IF ERROR-STATUS:ERROR
  THEN DO:
    ASSIGN op_error = "Could not create buffer for table: " + rvc_configuration_type.type_table_name.
    RETURN.  
  END.

  CREATE QUERY lh_query.
  lh_query:ADD-BUFFER(lh_buffer).
  lv_query_string = DYNAMIC-FUNCTION("fixQueryString":U IN gshSessionManager, INPUT lv_query_string).
  lh_query:QUERY-PREPARE(lv_query_string) NO-ERROR.
  lh_query:QUERY-OPEN() NO-ERROR.
  lh_query:GET-FIRST() NO-ERROR.

  ASSIGN
    op_error = "":U.

  transaction-block:
  DO FOR brvm_configuration_item TRANSACTION ON ERROR UNDO transaction-block, LEAVE transaction-block:
  
    /* If this is version 010000 of the object and it is the only version of the
     object and it is checked out, then all traces of the object should be
     removed - so set the scm registered flag to NO
    */
    DEFINE VARIABLE lv_object_exists                      AS LOGICAL.
    DEFINE VARIABLE lv_object_exists_in_workspace         AS LOGICAL.
    DEFINE VARIABLE lv_version_in_workspace               AS INTEGER.
    DEFINE VARIABLE lv_checked_out_in_workspace           AS LOGICAL.
    DEFINE VARIABLE lv_version_task_number                AS INTEGER. 
    DEFINE VARIABLE lv_highest_version                    AS INTEGER. 
    
    RUN scmObjectExists (INPUT  ip_object_name
                        ,INPUT  ip_workspace
                        ,OUTPUT lv_object_exists
                        ,OUTPUT lv_object_exists_in_workspace
                        ,OUTPUT lv_version_in_workspace
                        ,OUTPUT lv_checked_out_in_workspace
                        ,OUTPUT lv_version_task_number
                        ,OUTPUT lv_highest_version
                        ).

    IF lv_object_exists_in_workspace
    AND lv_checked_out_in_workspace
    AND lv_version_in_workspace = 010000
    AND lv_highest_version      = lv_version_in_workspace
    THEN DO:
      IF rvm_workspace_item.task_product_module_obj <> 0
      THEN
        FIND FIRST brvm_configuration_item EXCLUSIVE-LOCK
          WHERE brvm_configuration_item.scm_object_name     = ip_object_name
          AND   brvm_configuration_item.product_module_obj  = rvm_workspace_item.task_product_module_obj.
      ELSE
        FIND FIRST brvm_configuration_item EXCLUSIVE-LOCK
          WHERE brvm_configuration_item.scm_object_name     = ip_object_name
          AND   brvm_configuration_item.product_module_obj  = rvm_workspace_item.product_module_obj.

      ASSIGN
        brvm_configuration_item.scm_registered = NO.

      VALIDATE brvm_configuration_item NO-ERROR.
      {af/sup2/afcheckerr.i &no-return = YES}
      IF cMessageList <> "":U
      THEN DO:
        ASSIGN op_error = cMessageList.
        UNDO transaction-block, LEAVE transaction-block.
      END.

      FIND FIRST rvc_configuration_type NO-LOCK
        WHERE rvc_configuration_type.configuration_type = lv_configuration_type 
        NO-ERROR.

    END.

    /* If we have the item - delete it */
    IF lh_buffer:AVAILABLE
    THEN
      op_error = deleteBuffer(lh_buffer).        
    IF op_error = TRIM("ok":U)
    THEN MESSAGE "scmdeleteobject wierd return value 1: " op_error.
    IF op_error <> "":U
    THEN UNDO transaction-block, LEAVE transaction-block.

    /* Item deleted - Find / delete workspace item */
    FIND FIRST rvm_workspace_item NO-LOCK
      WHERE rvm_workspace_item.workspace_obj = rvm_workspace.workspace_obj
      AND rvm_workspace_item.configuration_type = lv_configuration_type
      AND rvm_workspace_item.scm_object_name    = ip_object_name
      NO-ERROR.
    IF AVAILABLE rvm_workspace_item
    THEN DO:
      RUN deleteWorkspaceItem (INPUT ROWID(rvm_workspace_item)
                              ,OUTPUT op_error
                              ).
      IF op_error = TRIM("ok":U)
      THEN MESSAGE "scmdeleteobject wierd return value 2: " op_error.
      IF op_error <> "":U
      THEN UNDO transaction-block, LEAVE transaction-block.
    END.

    /* Finally tidy up deleted items table */
    RUN deleteDeletedItems (INPUT rvm_workspace.workspace_obj
                           ,INPUT lv_configuration_type
                           ,INPUT ip_object_name
                           ,INPUT gsc_product_module.product_module_code
                           ,OUTPUT op_error
                           ).
    IF op_error = TRIM("ok":U)
    THEN MESSAGE "scmdeleteobject wierd return value 3: " op_error.
    IF op_error <> "":U
    THEN UNDO transaction-block, LEAVE transaction-block.

  END.

  /* tidy up */
  lh_buffer:BUFFER-RELEASE() NO-ERROR.
  lh_query:QUERY-CLOSE() NO-ERROR.
  DELETE OBJECT lh_query NO-ERROR.
  DELETE OBJECT lh_buffer NO-ERROR.
  ASSIGN
    lh_query = ?
    lh_buffer = ?
    .

  IF op_error = TRIM("ok":U)
  THEN MESSAGE "scmdeleteobject wierd return value 4: " op_error.

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-scmHookMoveModule) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE scmHookMoveModule Procedure 
PROCEDURE scmHookMoveModule :
/*------------------------------------------------------------------------------
  Purpose:     The purpose of this procedure is to deal with the situation where
               an object is moved to a new product module in the scm tool. It
               is fired from the creat-cv hook, after the object has been fully
               moved to the new module. For this reason, we do not get the
               chance to do anything about the move - i.e. prevent it. 
               
               We do however have a hook from create-cv-before that runs
               scmMoveModuleBefore which performs checks that the workspace is
               not locked, etc. so the chance of something failing should be
               small. The biggest issue would be if the new module did not
               exist - but we could also create it here.
               
               This hooks is like a check-out hook but with a difference - it also
               changes the product module. After the hook, the new object version in
               the new module will be left checked out.
               
               Another difference is we may need to create a new configuration item
               record for the new product module. We should then update the product
               module on the actual data item (without replication triggers).

  Parameters:  input  Current workspace code
               input  Current task number
               input  Current User ID
               input  Object name being moved
               input  new product module
               input  new version
               output Error Message if it failed
  
  Notes:       See above.
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER  ip_workspace            AS CHARACTER  NO-UNDO.
  DEFINE INPUT PARAMETER  ip_task_number          AS INTEGER    NO-UNDO.
  DEFINE INPUT PARAMETER  ip_user_id              AS CHARACTER  NO-UNDO.
  DEFINE INPUT PARAMETER  ip_object_name          AS CHARACTER  NO-UNDO.
  DEFINE INPUT PARAMETER  ip_new_product_module   AS CHARACTER  NO-UNDO.
  DEFINE INPUT PARAMETER  ip_new_object_version   AS INTEGER    NO-UNDO.
  DEFINE OUTPUT PARAMETER op_error                AS CHARACTER  NO-UNDO.

  ASSIGN
    ip_object_name = REPLACE(ip_object_name,".ado":U,"":U)
    NO-ERROR.

  /* Find the registered configuration item based on the SCM object name, and
     if it does not exist in the RVDB database then there is nothing to do
     as far as the RVDB and ICFDB databases are concerned for this object
  */
  FIND FIRST rvm_configuration_item NO-LOCK
    WHERE rvm_configuration_item.scm_object_name = ip_object_name
    NO-ERROR.
  IF NOT AVAILABLE rvm_configuration_item
  THEN RETURN.

  /* Find the workspace */
  FIND FIRST rvm_workspace NO-LOCK
    WHERE rvm_workspace.workspace_code = ip_workspace
    NO-ERROR.
  /* Find the configuration type */
  FIND FIRST rvc_configuration_type NO-LOCK
    WHERE rvc_configuration_type.configuration_type = rvm_configuration_item.configuration_type 
    NO-ERROR.
  /* Find the existing workspace item - must be one as this is a custom variant hook */
  FIND FIRST rvm_workspace_item NO-LOCK
    WHERE rvm_workspace_item.workspace_obj      = rvm_workspace.workspace_obj
    AND   rvm_workspace_item.configuration_type = rvc_configuration_type.configuration_type
    AND   rvm_workspace_item.scm_object_name    = ip_object_name
    NO-ERROR.

  /* Find the correct existing configuration item for the object being moved, i.e. the
     correct product module and object version
  */
  FIND FIRST rvm_configuration_item NO-LOCK
    WHERE rvm_configuration_item.scm_object_name    = ip_object_name
    AND   rvm_configuration_item.configuration_type = rvc_configuration_type.configuration_type
    AND   rvm_configuration_item.product_module_obj = rvm_workspace_item.product_module_obj
    NO-ERROR.

  /* If new product module not in ICFDB - create it with defaults */
  IF NOT CAN-FIND(FIRST gsc_product_module
                  WHERE gsc_product_module.product_module_code = ip_new_product_module)
  THEN
    RUN createProductModule (INPUT ip_new_product_module).                

  /* Find new product module */
  FIND FIRST gsc_product_module NO-LOCK
    WHERE gsc_product_module.product_module_code = ip_new_product_module
    NO-ERROR.

  ASSIGN
    op_error = "":U.

  RUN moveModule (INPUT ip_task_number
                 ,INPUT ip_object_name
                 ,INPUT gsc_product_module.product_module_obj
                 ,INPUT ip_new_object_version
                 ,INPUT rvm_workspace_item.workspace_item_obj
                 ,INPUT rvm_configuration_item.configuration_item_obj
                 ,OUTPUT op_error
                 ).

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-scmHookMoveModuleBefore) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE scmHookMoveModuleBefore Procedure 
PROCEDURE scmHookMoveModuleBefore :
/*------------------------------------------------------------------------------
  Purpose:     The purpose of this procedure is to deal with the situation where
               an object is moved to a new product module in the scm tool. It
               is fired from the creat-cv-before hook, before the object has been
               fully moved to the new module. 
               
               This hook basically does preliminary checks to ensure the asisgnment
               of the object is valid, e.g. checks whether the workspace is
               locked, etc.
               
               If anything is wroong, the new module assignment is cancelled.
               
               The bulk of the work for moving to the new module is then in the
               procedure scmMoveObject which is fired from create-cv after the
               move has taken place in the scm tool. We put our code in there
               because we do not know where the object is moving to until it has
               moved.
                              
  Parameters:  input  Current workspace code
               input  Current task number
               input  Current User ID
               input  Object name to be moved
               output Error Message if it failed
  
  Notes:       See above.
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER  ip_workspace            AS CHARACTER  NO-UNDO.
  DEFINE INPUT PARAMETER  ip_task_number          AS INTEGER    NO-UNDO.
  DEFINE INPUT PARAMETER  ip_user_id              AS CHARACTER  NO-UNDO.
  DEFINE INPUT PARAMETER  ip_object_name          AS CHARACTER  NO-UNDO.
  DEFINE OUTPUT PARAMETER op_error                AS CHARACTER  NO-UNDO.

  ASSIGN
    ip_object_name = REPLACE(ip_object_name,".ado":U,"":U)
    NO-ERROR.

  /* Find the registered configuration item based on the SCM object name, and
     if it does not exist in the RVDB database then there is nothing to do
     as far as the RVDB and ICFDB databases are concerned for this object
  */
  FIND FIRST rvm_configuration_item NO-LOCK
    WHERE rvm_configuration_item.scm_object_name = ip_object_name
    NO-ERROR.
  IF NOT AVAILABLE rvm_configuration_item
  THEN RETURN.

  /* Find workspace and ensure it is not locked */
  FIND FIRST rvm_workspace NO-LOCK
    WHERE rvm_workspace.workspace_code = ip_workspace
    NO-ERROR.
  IF NOT AVAILABLE rvm_workspace
  THEN DO:
    ASSIGN op_error = "Error moving object: " + ip_object_name +
                      " in workspace: " + ip_workspace +
                      ". Workspace not created yet in RVDB.".
    RETURN.
  END.

  IF rvm_workspace.workspace_locked
  THEN DO:
    ASSIGN op_error = "Error moving object: " + ip_object_name +
                      " in workspace: " + ip_workspace +
                      ". Workspace locked in RVDB.".
    RETURN.
  END.

  /* Find configuration type and ensure it is not locked */
  FIND FIRST rvc_configuration_type NO-LOCK
    WHERE rvc_configuration_type.configuration_type = rvm_configuration_item.configuration_type 
    NO-ERROR.
  IF rvc_configuration_type.type_locked
  THEN DO:
    ASSIGN op_error = "Error moving object: " + ip_object_name +
                      " in workspace: " + ip_workspace +
                      ". Configuration type: " + rvm_configuration_item.configuration_type + " is locked in RVDB.".
    RETURN.
  END.

  /* Find the workspace item record - must exist in workspace for it to be a custom variant!! */
  FIND FIRST rvm_workspace_item NO-LOCK
    WHERE rvm_workspace_item.workspace_obj      = rvm_workspace.workspace_obj
    AND   rvm_workspace_item.configuration_type = rvc_configuration_type.configuration_type
    AND   rvm_workspace_item.scm_object_name    = ip_object_name
    NO-ERROR.
  IF NOT AVAILABLE rvm_workspace_item
  THEN DO:
    ASSIGN op_error = "Error moving object: " + ip_object_name
                    + " in workspace: "       + ip_workspace
                    + ". Workspace item not found in RVDB for object.".
    RETURN.
  END.

  /* Find the correct configuration item for the object being checked out, i.e. the
     correct product module and object version
  */
  FIND FIRST rvm_configuration_item NO-LOCK
    WHERE rvm_configuration_item.scm_object_name    = ip_object_name
    AND   rvm_configuration_item.configuration_type = rvc_configuration_type.configuration_type
    AND   rvm_configuration_item.product_module_obj = rvm_workspace_item.product_module_obj
    NO-ERROR.
  IF NOT AVAILABLE rvm_configuration_item
  THEN DO:
    ASSIGN op_error = "Error moving object: " + ip_object_name
                    + " in workspace: "       + ip_workspace
                    + ". Configuration item does not exist in RVDB with product module: " + STRING(rvm_workspace_item.product_module_obj).
    RETURN.
  END.

  IF rvm_configuration_item.scm_registered = NO
  THEN DO:
    ASSIGN op_error = "Error moving object: " + ip_object_name
                    + " in workspace: "       + ip_workspace
                    + ". Configuration item not SCM Registered in RVDB with product module: " + STRING(rvm_workspace_item.product_module_obj).
    RETURN.    
  END.

  IF CAN-FIND(FIRST rvt_workspace_checkout
              WHERE rvt_workspace_checkout.workspace_item_obj = rvm_workspace_item.workspace_item_obj)
  THEN DO:
    ASSIGN op_error = "Error moving object: " + ip_object_name
                    + " in workspace: "       + ip_workspace
                    + ". Object already checked out according to RV version database.".
    RETURN.    
  END.

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setRegisteredFlag) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setRegisteredFlag Procedure 
PROCEDURE setRegisteredFlag :
/*------------------------------------------------------------------------------
  Purpose:     To set the registered flag on a configuration item to YES
  Parameters:  input configuration item rowid
               output error message text if any
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER  ip_rowid              AS ROWID      NO-UNDO.
  DEFINE OUTPUT PARAMETER op_error              AS CHARACTER  NO-UNDO.

  DEFINE BUFFER lb_rvm_configuration_item FOR rvm_configuration_item.

  DO FOR lb_rvm_configuration_item:
    FIND FIRST lb_rvm_configuration_item EXCLUSIVE-LOCK
       WHERE ROWID(lb_rvm_configuration_item) = ip_rowid
       NO-ERROR.
    IF LOCKED lb_rvm_configuration_item THEN
    DO:
      ASSIGN op_error = "Cannot set registered flag on configuration item - locked by another user".
      RETURN.
    END.
    IF NOT AVAILABLE lb_rvm_configuration_item THEN
    DO:
      ASSIGN op_error = "Cannot set registered flag on configuration item - deleted by another user".
      RETURN.
    END.

    ASSIGN
      lb_rvm_configuration_item.scm_registered = YES
      .
  
    VALIDATE lb_rvm_configuration_item NO-ERROR.
    {af/sup2/afcheckerr.i &no-return = YES}
    IF cMessageList <> "":U THEN 
    DO:
      ASSIGN op_error = cMessageList.
      RETURN.
    END.
  END.

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-updateXMLFile) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE updateXMLFile Procedure 
PROCEDURE updateXMLFile :
/*------------------------------------------------------------------------------
  Purpose:     To update .ado XML File
  Parameters:  input workspace object number
               input product module object number for object
               input configuration type
               input full object name with no path (including .ado if any)
               output error text if any
  Notes:       

               /* ICF-SCM-XML */
               Ensure .ado file is not empty.
               If empty populate with template xml file.

------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER pdWorkspaceObj     AS DECIMAL    NO-UNDO.
  DEFINE INPUT PARAMETER pdModuleObj        AS DECIMAL    NO-UNDO.
  DEFINE INPUT PARAMETER pcConfigType       AS CHARACTER  NO-UNDO.
  DEFINE INPUT PARAMETER pcObjectName       AS CHARACTER  NO-UNDO.
  DEFINE OUTPUT PARAMETER pcError           AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE cProductModule            AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE cDatasetCode              AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cRootDir                  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cRelativePath             AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cXMLFileName              AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cXMLRelativeName          AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE hTable01                  AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hTable02                  AS HANDLE     NO-UNDO.

  ASSIGN
    hTable01      = ?
    hTable02      = ?
    cRootDir      = "":U
    cRelativePath = "":U
    .

  FIND FIRST rvm_workspace NO-LOCK
    WHERE rvm_workspace.workspace_obj = pdWorkspaceObj
    NO-ERROR.

  FIND FIRST gsc_product_module NO-LOCK
    WHERE gsc_product_module.product_module_obj = pdModuleObj
    NO-ERROR.

  FIND FIRST rvc_configuration_type NO-LOCK
    WHERE rvc_configuration_type.configuration_type = pcConfigType
    NO-ERROR.
  IF AVAILABLE rvc_configuration_type
  AND rvc_configuration_type.dataset_code <> "":U
  THEN
    ASSIGN cDataSetCode = rvc_configuration_type.dataset_code.

  IF AVAILABLE rvm_workspace
  THEN
    RUN scmGetWorkspaceRoot (INPUT rvm_workspace.workspace_code
                            ,OUTPUT cRootDir
                            ).
  IF cRootDir <> "":U
  THEN
    ASSIGN cRootDir = TRIM(cRootDir,"/":U) + "/":U.

  IF AVAILABLE gsc_product_module
  THEN DO: 
    ASSIGN
      cProductModule = gsc_product_module.product_module_code.
    RUN scmSitePrefixAdd (INPUT-OUTPUT cProductModule).
    RUN scmGetModuleDir  (INPUT cProductModule
                         ,OUTPUT cRelativePath).
  END.
  IF cRelativePath <> "":U
  THEN
    ASSIGN cRelativePath = TRIM(cRelativePath,"/":U) + "/":U.

  ASSIGN
    cXMLFileName = pcObjectName.
  RUN scmADOExtReplace (INPUT-OUTPUT cXMLFileName).

  ASSIGN
    cXMLFileName     = SUBSTRING(pcObjectName,1,R-INDEX(pcObjectName,".":U)) + "ado":U
    cXMLRelativeName = cRelativePath + cXMLFileName.

  {af/sup2/afrun2.i &PLIP = 'af/app/gscddxmlp.p'
                    &IProc = 'writeDeploymentDataset'
                    &PList = "( INPUT cDataSetCode,~
                                INPUT REPLACE(pcObjectName,'.ado':U,'':U),~
                                INPUT cXMLRelativeName,~
                                INPUT cRootDir,~
                                INPUT YES,~
                                INPUT YES,~
                                INPUT TABLE-HANDLE hTable01,~
                                INPUT TABLE-HANDLE hTable02,~
                                OUTPUT pcError )"
                    &OnApp = 'no'
                    &Autokill = YES}

  /* ICF-SCM-XML */
  DEFINE VARIABLE cAdoTemplate              AS CHARACTER  NO-UNDO.
  ASSIGN
    cAdoTemplate = "emptyxml.ado".

  /* Check if the file exist and if the file is not 0 size */
  IF SEARCH(cXMLRelativeName) <> ?
  THEN DO:
    FILE-INFO:FILENAME = SEARCH(cXMLRelativeName).
    IF FILE-INFO:FILE-SIZE = 0
    THEN DO:
      IF cAdoTemplate <> "":U
      AND SEARCH(cAdoTemplate) <> ?
      THEN DO:
        OS-COPY VALUE(SEARCH(cAdoTemplate)) VALUE(SEARCH(cXMLRelativeName)).
      END.
      ELSE DO:
        OUTPUT TO VALUE(SEARCH(cXMLRelativeName)).
        DISPLAY "/* ICF-SCM-XML */ Dynamics Dynamic Object":U.
        OUTPUT CLOSE.  
      END.
    END.
  END.

  ERROR-STATUS:ERROR = NO.
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

&IF DEFINED(EXCLUDE-getQuotedFieldValue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getQuotedFieldValue Procedure 
FUNCTION getQuotedFieldValue RETURNS CHARACTER
  ( ip_buffer_handle AS HANDLE,
    ip_description_fieldname AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    DEFINE VARIABLE h_buffer_field AS HANDLE NO-UNDO.

    ASSIGN
        h_buffer_field = ip_buffer_handle:BUFFER-FIELD(ip_description_fieldname)
        NO-ERROR.
        
    IF ERROR-STATUS:ERROR THEN RETURN "".  /* field not found in buffer */
    
    IF VALID-HANDLE(h_buffer_field) THEN
    DO:
        IF h_buffer_field:DATA-TYPE = "CHARACTER"  
            THEN RETURN "'" + h_buffer_field:BUFFER-VALUE() + "'".
            ELSE RETURN h_buffer_field:BUFFER-VALUE().
    END.
    ELSE RETURN "".

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

