&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12
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
/*------------------------------------------------------------------------
    File        : 
    Purpose     :

    Syntax      :

    Description :

    Author(s)   :
    Created     :
    Notes       :
  ----------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

DEFINE INPUT PARAMETER ip_object_list_filename AS CHARACTER NO-UNDO.

DEFINE TEMP-TABLE tt_object_list
    FIELD configuration_type        AS CHARACTER
    FIELD object_name               AS CHARACTER
    FIELD scm_object_name           AS CHARACTER
    FIELD object_description        AS CHARACTER
    FIELD scm_code                  AS CHARACTER
    FIELD product_module_code       AS CHARACTER
    FIELD ERROR_text                AS CHARACTER.

DEFINE STREAM str-in.    

DEFINE VARIABLE lv_task_status       AS CHARACTER NO-UNDO.
DEFINE VARIABLE lv_workspace_code    AS CHARACTER NO-UNDO.
DEFINE VARIABLE lv_workspace_obj    AS DECIMAL NO-UNDO.

DEFINE VARIABLE lv_task_number      AS INTEGER INITIAL 0 NO-UNDO.

DEFINE STREAM str-errors.

DEFINE VARIABLE h_afrtbprocp AS HANDLE NO-UNDO.
DEFINE VARIABLE lv_error_status AS LOGICAL.
DEFINE VARIABLE lv_return_value AS CHARACTER.

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
         HEIGHT             = 15
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */


    RUN startPersistentProcs.

    RUN doTheBusiness NO-ERROR.
    lv_error_status = ERROR-STATUS:ERROR.
    lv_return_value = RETURN-VALUE.

    RUN stopPersistentProcs.

    IF lv_error_status 
        THEN RETURN ERROR lv_return_value.
        ELSE RETURN lv_return_value.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-createObjectsInScm) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE createObjectsInScm Procedure 
PROCEDURE createObjectsInScm :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VARIABLE lv_object_exists                AS LOGICAL NO-UNDO.
DEFINE VARIABLE lv_object_exists_in_workspace   AS LOGICAL NO-UNDO.
DEFINE VARIABLE lv_version_in_workspace         AS INTEGER NO-UNDO.
DEFINE VARIABLE lv_checked_out_in_workspace     AS LOGICAL NO-UNDO.
DEFINE VARIABLE lv_version_task_number          AS INTEGER NO-UNDO.    
DEFINE VARIABLE lv_highest_version_number       AS INTEGER NO-UNDO.

DEFINE VARIABLE lv_recid AS RECID NO-UNDO.
DEFINE VARIABLE lv_rejection AS CHARACTER NO-UNDO.                                                    

  FOR EACH tt_object_list:
      RUN scmObjectExists (
          INPUT tt_object_list.scm_object_name,
          INPUT lv_workspace_code,          
          OUTPUT lv_object_exists,
          OUTPUT lv_object_exists_in_workspace,
          OUTPUT lv_version_in_workspace,
          OUTPUT lv_checked_out_in_workspace,
          OUTPUT lv_version_task_number,
          OUTPUT lv_highest_version_number).

      MESSAGE "scmObjectExists ("   tt_object_list.scm_object_name ","  lv_workspace_code ") returned "  lv_object_exists lv_object_exists_in_workspace lv_version_in_workspace lv_checked_out_in_workspace lv_version_task_number lv_highest_version_number VIEW-AS ALERT-BOX.

      IF NOT lv_object_exists
      THEN DO:

          ASSIGN
            lv_rejection = "":U.

          /* create this object in the SCM tool */
          IF VALID-HANDLE(h_afrtbprocp)
          THEN
            RUN scmCreateObjectControl IN h_afrtbprocp (
                INPUT  tt_object_list.scm_object_name,
                INPUT  "PCODE",
                INPUT  tt_object_list.scm_code,
                INPUT  tt_object_list.product_module_code,
                INPUT  tt_object_list.scm_code,
                INPUT  010000,
                INPUT  tt_object_list.object_description,
                INPUT  "",
                INPUT  lv_task_number,
                INPUT  NO,
                INPUT  "CENTRAL",
                INPUT  YES,
                INPUT  "",
                OUTPUT lv_recid,
                OUTPUT lv_rejection
            ).

          IF lv_rejection <> "" 
            THEN RETURN ERROR "scmCreateObjectControl failed:" + lv_rejection.

          /* do something with lv_rejection now */
          ASSIGN
            lv_object_exists_in_workspace = FALSE.

        END.

        IF NOT lv_object_exists_in_workspace
        THEN DO:

          ASSIGN
            lv_rejection = "":U.


          IF VALID-HANDLE(h_afrtbprocp)
          THEN
            RUN scmAssignObjectControl IN h_afrtbprocp(
                INPUT  tt_object_list.product_module_code,
                INPUT "PCODE",
                INPUT  tt_object_list.scm_object_name,
                INPUT  (IF lv_object_exists THEN lv_highest_version_number ELSE 010000),
                OUTPUT lv_recid,
                OUTPUT lv_rejection).       

          IF lv_rejection <> "" 
            THEN RETURN ERROR "scmAssignObjectControl failed:" + lv_rejection.

          ASSIGN
            lv_checked_out_in_workspace = FALSE.

        END.

        IF NOT lv_checked_out_in_workspace
        THEN DO:
          ASSIGN
            lv_rejection = "":U.

          IF VALID-HANDLE(h_afrtbprocp)
          THEN
            RUN scmCheckOutObjectControl IN h_afrtbprocp(
              INPUT  "REVISION":U,
              INPUT  tt_object_list.product_module_code,
              INPUT  "PCODE":U,
              INPUT  tt_object_list.scm_object_name,
              INPUT  lv_task_number,
              INPUT  NO,
              INPUT  NO,
              INPUT  YES,
              OUTPUT lv_recid,
              OUTPUT lv_rejection
          ).

          IF lv_rejection <> "" 
            THEN RETURN ERROR "scmCheckOutObjectControl failed:" + lv_rejection.

        END.

    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-determineScmInfo) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE determineScmInfo Procedure 
PROCEDURE determineScmInfo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/


DEFINE VARIABLE tmp_task_summary     AS CHARACTER NO-UNDO.
DEFINE VARIABLE tmp_task_description AS CHARACTER NO-UNDO.
DEFINE VARIABLE tmp_task_programmer  AS CHARACTER NO-UNDO.
DEFINE VARIABLE tmp_task_userref     AS CHARACTER NO-UNDO.
DEFINE VARIABLE tmp_task_workspace   AS CHARACTER NO-UNDO.
DEFINE VARIABLE tmp_task_entered_date AS DATE NO-UNDO.

IF VALID-HANDLE(h_afrtbprocp)
THEN DO:
  RUN scmGetTaskInfo IN h_afrtbprocp (INPUT-OUTPUT lv_task_number,
                                      OUTPUT tmp_task_summary,
                                      OUTPUT tmp_task_description,
                                      OUTPUT tmp_task_programmer,
                                      OUTPUT tmp_task_userref,
                                      OUTPUT lv_workspace_code,
                                      OUTPUT tmp_task_entered_date,
                                      OUTPUT lv_task_status).
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-doTheBusiness) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE doTheBusiness Procedure 
PROCEDURE doTheBusiness :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DO ON ERROR UNDO, RETURN ERROR RETURN-VALUE.           
        RUN determineScmInfo.
        RUN preliminaryChecks.

        RUN readObjectList.
        RUN perObjectChecks.

        RUN createObjectsInScm.

/*         RUN lockWorkspace. */

        /* all hunky-dory - now we can return and let the load of the data proceed */

        MESSAGE "rvutlimplp.p completed successfully - load may now commence." VIEW-AS ALERT-BOX.

        RETURN.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-lockWorkspace) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE lockWorkspace Procedure 
PROCEDURE lockWorkspace :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DO ON ERROR UNDO, RETURN ERROR RETURN-VALUE:

        FIND CURRENT rvm_workspace EXCLUSIVE-LOCK.

        IF rvm_workspace.workspace_locked 
            THEN RETURN ERROR "Workspace became locked before the Import process tried to lock it.".     
            ELSE ASSIGN rvm_workspace.workspace_locked = TRUE.

        VALIDATE rvm_workspace.
        FIND CURRENT rvm_workspace NO-LOCK.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-perObjectChecks) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE perObjectChecks Procedure 
PROCEDURE perObjectChecks :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VARIABLE lv_object_exists                AS LOGICAL NO-UNDO.
DEFINE VARIABLE lv_object_exists_in_workspace   AS LOGICAL NO-UNDO.
DEFINE VARIABLE lv_version_in_workspace         AS INTEGER NO-UNDO.
DEFINE VARIABLE lv_checked_out_in_workspace     AS LOGICAL NO-UNDO.
DEFINE VARIABLE lv_version_task_number          AS INTEGER NO-UNDO.
DEFINE VARIABLE lv_highest_version_number       AS INTEGER NO-UNDO.

DEFINE VARIABLE lv_error_cnt                    AS INTEGER NO-UNDO.
DEFINE VARIABLE lv_cnt                          AS INTEGER NO-UNDO.

object-blk:    
    FOR EACH tt_object_list ON ERROR UNDO, RETURN ERROR RETURN-VALUE:
        lv_cnt = lv_cnt + 1.
        /* determine that the object is not checked-out under a different task in the Versioning database */

        FIND FIRST rvm_workspace_item NO-LOCK
            WHERE rvm_workspace_item.configuration_type = tt_object_list.configuration_type
            AND   rvm_workspace_item.scm_object_name = tt_object_list.scm_object_name
            AND   rvm_workspace_item.workspace_obj = lv_workspace_obj
            NO-ERROR.

        IF AVAILABLE rvm_workspace_item THEN
        DO:
            FIND FIRST rvt_workspace_checkout NO-LOCK
                WHERE rvt_workspace_checkout.workspace_item_obj = rvm_workspace_item.workspace_item_obj
                NO-ERROR.

            IF AVAILABLE rvt_workspace_checkout THEN
            DO:
                IF rvt_workspace_checkout.task_number <> lv_task_number 
                    THEN RETURN "Checked out in versioning database under a different task.".              
            END.
        END.

        /* determine that the object is not checked-out under a different task in the SCM tool */

        RUN scmObjectExists (
            INPUT tt_object_list.scm_object_name,
            INPUT lv_workspace_code,          
            OUTPUT lv_object_exists,
            OUTPUT lv_object_exists_in_workspace,
            OUTPUT lv_version_in_workspace,
            OUTPUT lv_checked_out_in_workspace,
            OUTPUT lv_version_task_number,
            OUTPUT lv_highest_version_number).

/*         IF lv_object_exists AND NOT lv_object_exists_in_workspace THEN                                                            */
/*         DO:                                                                                                                       */
/*             lv_error_cnt = lv_error_cnt + 1.                                                                                      */
/*             tt_object_list.ERROR_text = "Exists in the SCM tool but has not yet been assigned to workspace " + lv_workspace_code. */
/*             NEXT object-blk.                                                                                                      */
/*         END.                                                                                                                      */

        IF lv_object_exists AND lv_object_exists_in_workspace AND lv_checked_out_in_workspace AND lv_version_task_number <> lv_task_number THEN
        DO:
            lv_error_cnt = lv_error_cnt + 1.
            tt_object_list.ERROR_text = "Is checked out in the SCM tool under task " + STRING(lv_version_task_number) + " instead of task " + STRING(lv_task_number).            
            NEXT object-blk.
        END.
    END.

    IF lv_error_cnt > 0 THEN
    DO:
        MESSAGE "Of the " lv_cnt " objects in this import, " lv_error_cnt " cannot be imported for various reasons.".
        OUTPUT STREAM str-errors TO "import-errors.txt".
        FOR EACH tt_object_list 
            WHERE tt_object_list.error_text <> ""
            BY  tt_object_list.error_text:

            PUT STREAM str-errors UNFORMATTED tt_object_list.scm_object_name ": "  tt_object_list.error_text SKIP.
        END.
        OUTPUT STREAM str-errors CLOSE.

        RUN display-file.w (INPUT "import-errors.txt").
        RETURN ERROR.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-preliminaryChecks) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE preliminaryChecks Procedure 
PROCEDURE preliminaryChecks :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    FIND FIRST rvm_workspace NO-LOCK
        WHERE rvm_workspace.workspace_code = lv_workspace_code NO-ERROR.

    IF NOT AVAILABLE rvm_workspace
        THEN RETURN ERROR "Workspace not found.".        

    lv_workspace_obj = rvm_workspace.workspace_obj.

    IF rvm_workspace.workspace_locked 
        THEN RETURN ERROR "Workspace is locked - Import cannot begin.".     

    IF lv_task_number = 0 
        THEN RETURN ERROR "Not a valid task.".

    IF lv_task_status <> "W" 
        THEN RETURN ERROR "Task is not open.".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-readObjectList) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE readObjectList Procedure 
PROCEDURE readObjectList :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE lv_idx AS INTEGER.
    DEFINE VARIABLE jdx AS INTEGER.

    INPUT STREAM str-in FROM VALUE(ip_object_list_filename).
    REPEAT :
        CREATE tt_object_list.
        IMPORT STREAM str-in tt_object_list EXCEPT error_text scm_object_name.

        ASSIGN
          scm_object_name = tt_object_list.object_name
          lv_idx          = lv_idx + 1
          .
        IF VALID-HANDLE(h_afrtbprocp)
        THEN
          RUN scmADOExtAdd IN h_afrtbprocp (INPUT-OUTPUT scm_object_name).

    END.
    IF AVAILABLE tt_object_list
    AND tt_object_list.object_name = ""
    THEN
      DELETE tt_object_list.

    FOR EACH tt_object_list:
        jdx = jdx + 1.
    END.

    MESSAGE lv_idx " objects in import object list." jdx " tt records exist".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-scmObjectExists) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE scmObjectExists Procedure 
PROCEDURE scmObjectExists :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER ip_object_name                        AS CHARACTER.
DEFINE INPUT  PARAMETER ip_workspace_code                     AS CHARACTER.
DEFINE OUTPUT PARAMETER op_object_exists                      AS LOGICAL.
DEFINE OUTPUT PARAMETER op_object_exists_in_workspace         AS LOGICAL.
DEFINE OUTPUT PARAMETER op_version_in_workspace               AS INTEGER.
DEFINE OUTPUT PARAMETER op_checked_out_in_worpscace           AS LOGICAL.
DEFINE OUTPUT PARAMETER op_version_task_number                AS INTEGER. 
DEFINE OUTPUT PARAMETER op_highest_version_number             AS INTEGER.


  IF VALID-HANDLE(h_afrtbprocp)
  THEN DO:
      RUN scmObjectExists IN h_afrtbprocp (
          INPUT  ip_object_name,                     
          INPUT  ip_workspace_code,                  
          OUTPUT op_object_exists,
          OUTPUT op_object_exists_in_workspace,
          OUTPUT op_version_in_workspace,           
          OUTPUT op_checked_out_in_worpscace,
          OUTPUT op_version_task_number,  
          OUTPUT op_highest_version_number      
      ).
  END.
  ELSE DO:
      RETURN ERROR "h_afrtbproc is not a valid handle!".
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-startPersistentProcs) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE startPersistentProcs Procedure 
PROCEDURE startPersistentProcs :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE lv_proc_hdl AS HANDLE NO-UNDO.

  IF VALID-HANDLE(h_afrtbprocp)
  AND INDEX(h_afrtbprocp:FILE-NAME,"afrtbprocp") <> 0
  THEN DO:
      /* procedure is running */
  END.
  ELSE DO:
    IF SEARCH("rtb/prc/afrtbprocp.p":U) <> ?
    OR SEARCH("rtb/prc/afrtbprocp.r":U) <> ?
    THEN
      RUN rtb/prc/afrtbprocp.p PERSISTENT SET h_afrtbprocp.
      /* did it detect it was a copy and commit harra kiri? */
    IF VALID-HANDLE(h_afrtbprocp)
    THEN DO:
      /* procedure is running and can now be used */
    END.
    ELSE DO:
      RETURN ERROR "Persistent Procedure rtb/prc/afrtbprocp.p did not run or committed suicide on detecing that it was a copy of an already instantiated procedure.".
    END.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-stopPersistentProcs) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE stopPersistentProcs Procedure 
PROCEDURE stopPersistentProcs :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    IF VALID-HANDLE(h_afrtbprocp) THEN
    DO:   
        RUN killPlip IN h_afrtbprocp.                                      
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

