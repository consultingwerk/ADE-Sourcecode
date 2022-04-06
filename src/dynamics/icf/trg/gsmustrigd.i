&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Include 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*               PSC                                                  *
*                                                                    *
*********************************************************************/
/*--------------------------------------------------------------------------
    File        : 
    Purpose     :

    Syntax      :

    Description :

    Author(s)   :
    Created     :
    Notes       :
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Include
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: INCLUDE-ONLY
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Include ASSIGN
         HEIGHT             = 2
         WIDTH              = 40.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */

IF NOT gsm_user.security_group 
THEN DO:
    /* Cannot delete at all ! */
    ASSIGN lv-error = YES lv-errgrp = "AF ":U lv-errnum = 105 lv-include = "gsm_user":U.
    RUN error-message (lv-errgrp, lv-errnum, lv-include).
END.
ELSE DO:
    /* If we can find other groups or users linked to this group, we can't delete it */
    IF CAN-FIND(FIRST gsm_group_allocation
                WHERE gsm_group_allocation.user_obj = gsm_user.user_obj)
    OR CAN-FIND(FIRST gsm_group_allocation
                WHERE gsm_group_allocation.group_user_obj = gsm_user.user_obj) 
    THEN DO:
        ASSIGN lv-error = YES lv-errgrp = "AF ":U lv-errnum = 101 lv-include = "security group|links to users/other security groups":U.
        RUN error-message (lv-errgrp, lv-errnum, lv-include).
    END.

    /* Delete gsm_user_allocation records */
    DEFINE BUFFER lbx_gsm_user_allocation FOR gsm_user_allocation.
    DEFINE BUFFER lby_gsm_user_allocation FOR gsm_user_allocation.

    IF CAN-FIND(FIRST lbx_gsm_user_allocation 
                WHERE lbx_gsm_user_allocation.user_obj = gsm_user.user_obj) THEN
        FOR EACH lbx_gsm_user_allocation NO-LOCK
           WHERE lbx_gsm_user_allocation.user_obj = gsm_user.user_obj
           ON STOP UNDO, RETURN ERROR "AF^104^gsmustrigd.p^delete gsm_user_allocation":U:
            FIND FIRST lby_gsm_user_allocation EXCLUSIVE-LOCK
                 WHERE ROWID(lby_gsm_user_allocation) = ROWID(lbx_gsm_user_allocation)
                 NO-ERROR.
            IF AVAILABLE lby_gsm_user_allocation THEN
              DO:
                {af/sup/afvalidtrg.i &action = "DELETE" &table = "lby_gsm_user_allocation"}
              END.
        END.

    /* gst_password_history will not exist for a group, make sure though... */
    DEFINE BUFFER lbx_gst_password_history FOR gst_password_history.
    DEFINE BUFFER lby_gst_password_history FOR gst_password_history.

    IF CAN-FIND(FIRST lbx_gst_password_history 
                WHERE lbx_gst_password_history.user_obj = gsm_user.user_obj) THEN
        FOR EACH lbx_gst_password_history NO-LOCK
           WHERE lbx_gst_password_history.user_obj = gsm_user.user_obj
           ON STOP UNDO, RETURN ERROR "AF^104^gsmustrigd.p^delete gst_password_history":U:
            FIND FIRST lby_gst_password_history EXCLUSIVE-LOCK
                 WHERE ROWID(lby_gst_password_history) = ROWID(lbx_gst_password_history)
                 NO-ERROR.
            IF AVAILABLE lby_gst_password_history THEN
              DO:
                {af/sup/afvalidtrg.i &action = "DELETE" &table = "lby_gst_password_history"}
              END.
        END.

    /* Commented out for performance reasons, we don't have an index.
       Won't be a problem, as we're not going to be running batch jobs against a security group

    DEFINE BUFFER lbx_gst_batch_job FOR gst_batch_job.
    DEFINE BUFFER lby_gst_batch_job FOR gst_batch_job.

    IF CAN-FIND(FIRST lbx_gst_batch_job 
                WHERE lbx_gst_batch_job.user_obj = gsm_user.user_obj) THEN
        FOR EACH lbx_gst_batch_job NO-LOCK
           WHERE lbx_gst_batch_job.user_obj = gsm_user.user_obj
           ON STOP UNDO, RETURN ERROR "AF^104^gsmustrigd.p^delete gst_batch_job":U:
            FIND FIRST lby_gst_batch_job EXCLUSIVE-LOCK
                 WHERE ROWID(lby_gst_batch_job) = ROWID(lbx_gst_batch_job)
                 NO-ERROR.
            IF AVAILABLE lby_gst_batch_job THEN
              DO:
                {af/sup/afvalidtrg.i &action = "DELETE" &table = "lby_gst_batch_job"}
              END.
        END.
    */

    /* gst_extract_log will not exist for a group, make sure though... */
    DEFINE BUFFER lbx_gst_extract_log FOR gst_extract_log.
    DEFINE BUFFER lby_gst_extract_log FOR gst_extract_log.

    IF CAN-FIND(FIRST lbx_gst_extract_log 
                WHERE lbx_gst_extract_log.user_obj = gsm_user.user_obj) THEN
        FOR EACH lbx_gst_extract_log NO-LOCK
           WHERE lbx_gst_extract_log.user_obj = gsm_user.user_obj
           ON STOP UNDO, RETURN ERROR "AF^104^gsmustrigd.p^delete gst_extract_log":U:
            FIND FIRST lby_gst_extract_log EXCLUSIVE-LOCK
                 WHERE ROWID(lby_gst_extract_log) = ROWID(lbx_gst_extract_log)
                 NO-ERROR.
            IF AVAILABLE lby_gst_extract_log THEN
              DO:
                {af/sup/afvalidtrg.i &action = "DELETE" &table = "lby_gst_extract_log"}
              END.
        END.

    /* Commented out for performance reasons, we don't have an index.
       Won't be a problem, as we're not going to be logging runtime errors against a security group
              
    DEFINE BUFFER lbx_gst_error_log FOR gst_error_log.
    DEFINE BUFFER lby_gst_error_log FOR gst_error_log.

    IF CAN-FIND(FIRST lbx_gst_error_log 
                WHERE lbx_gst_error_log.user_obj = gsm_user.user_obj) THEN
        FOR EACH lbx_gst_error_log NO-LOCK
           WHERE lbx_gst_error_log.user_obj = gsm_user.user_obj
           ON STOP UNDO, RETURN ERROR "AF^104^gsmustrigd.p^delete gst_error_log":U:
            FIND FIRST lby_gst_error_log EXCLUSIVE-LOCK
                 WHERE ROWID(lby_gst_error_log) = ROWID(lbx_gst_error_log)
                 NO-ERROR.
            IF AVAILABLE lby_gst_error_log THEN
              DO:
                {af/sup/afvalidtrg.i &action = "DELETE" &table = "lby_gst_error_log"}
              END.
        END.
    */

    /* gsm_profile_data will not exist for a group, make sure though... */
    DEFINE BUFFER lbx_gsm_profile_data FOR gsm_profile_data.
    DEFINE BUFFER lby_gsm_profile_data FOR gsm_profile_data.

    IF CAN-FIND(FIRST lbx_gsm_profile_data 
                WHERE lbx_gsm_profile_data.user_obj = gsm_user.user_obj) THEN
        FOR EACH lbx_gsm_profile_data NO-LOCK
           WHERE lbx_gsm_profile_data.user_obj = gsm_user.user_obj
           ON STOP UNDO, RETURN ERROR "AF^104^gsmustrigd.p^delete gsm_profile_data":U:
            FIND FIRST lby_gsm_profile_data EXCLUSIVE-LOCK
                 WHERE ROWID(lby_gsm_profile_data) = ROWID(lbx_gsm_profile_data)
                 NO-ERROR.
            IF AVAILABLE lby_gsm_profile_data THEN
              DO:
                {af/sup/afvalidtrg.i &action = "DELETE" &table = "lby_gsm_profile_data"}
              END.
        END.

    /* gst_session will not exist for a group, make sure though... */
    DEFINE BUFFER lbx_gst_session FOR gst_session.
    DEFINE BUFFER lby_gst_session FOR gst_session.

    IF CAN-FIND(FIRST lbx_gst_session 
                WHERE lbx_gst_session.user_obj = gsm_user.user_obj) THEN
        FOR EACH lbx_gst_session NO-LOCK
           WHERE lbx_gst_session.user_obj = gsm_user.user_obj
           ON STOP UNDO, RETURN ERROR "AF^104^gsmustrigd.p^delete gst_session":U:
            FIND FIRST lby_gst_session EXCLUSIVE-LOCK
                 WHERE ROWID(lby_gst_session) = ROWID(lbx_gst_session)
                 NO-ERROR.
            IF AVAILABLE lby_gst_session THEN
              DO:
                {af/sup/afvalidtrg.i &action = "DELETE" &table = "lby_gst_session"}
              END.
        END.

    /* ryt_dbupdate_status will not exist for a group, make sure though... */
    DEFINE BUFFER lbx_ryt_dbupdate_status FOR ryt_dbupdate_status.
    DEFINE BUFFER lby_ryt_dbupdate_status FOR ryt_dbupdate_status.

    IF CAN-FIND(FIRST lbx_ryt_dbupdate_status 
                WHERE lbx_ryt_dbupdate_status.run_by_user_obj = gsm_user.user_obj) THEN
        FOR EACH lbx_ryt_dbupdate_status NO-LOCK
           WHERE lbx_ryt_dbupdate_status.run_by_user_obj = gsm_user.user_obj
           ON STOP UNDO, RETURN ERROR "AF^104^gsmustrigd.p^delete ryt_dbupdate_status":U:
            FIND FIRST lby_ryt_dbupdate_status EXCLUSIVE-LOCK
                 WHERE ROWID(lby_ryt_dbupdate_status) = ROWID(lbx_ryt_dbupdate_status)
                 NO-ERROR.
            IF AVAILABLE lby_ryt_dbupdate_status THEN
              DO:
                {af/sup/afvalidtrg.i &action = "DELETE" &table = "lby_ryt_dbupdate_status"}
              END.
        END.

    /* gst_context_scope will not exist for a group, make sure though... */
    DEFINE BUFFER lbx_gst_context_scope FOR gst_context_scope.
    DEFINE BUFFER lby_gst_context_scope FOR gst_context_scope.

    IF CAN-FIND(FIRST lbx_gst_context_scope 
                WHERE lbx_gst_context_scope.user_obj = gsm_user.user_obj) THEN
        FOR EACH lbx_gst_context_scope NO-LOCK
           WHERE lbx_gst_context_scope.user_obj = gsm_user.user_obj
           ON STOP UNDO, RETURN ERROR "AF^104^gsmustrigd.p^delete gst_context_scope":U:
            FIND FIRST lby_gst_context_scope EXCLUSIVE-LOCK
                 WHERE ROWID(lby_gst_context_scope) = ROWID(lbx_gst_context_scope)
                 NO-ERROR.
            IF AVAILABLE lby_gst_context_scope THEN
              DO:
                {af/sup/afvalidtrg.i &action = "DELETE" &table = "lby_gst_context_scope"}
              END.
        END.

    /* Generic comments deletion */
    DEFINE BUFFER lbx_gsm_comment FOR gsm_comment.
    DEFINE BUFFER lby_gsm_comment FOR gsm_comment.

    IF CAN-FIND(FIRST lbx_gsm_comment 
                WHERE lbx_gsm_comment.owning_obj = gsm_user.user_obj) THEN
        FOR EACH lbx_gsm_comment NO-LOCK
           WHERE lbx_gsm_comment.owning_obj = gsm_user.user_obj
           ON STOP UNDO, RETURN ERROR "AF^104^gsmustrigd.p^delete gsm_comment":U:
            FIND FIRST lby_gsm_comment EXCLUSIVE-LOCK
                 WHERE ROWID(lby_gsm_comment) = ROWID(lbx_gsm_comment)
                 NO-ERROR.
            IF AVAILABLE lby_gsm_comment THEN
              DO:
                {af/sup/afvalidtrg.i &action = "DELETE" &table = "lby_gsm_comment"}
              END.
        END.

    /* Generic multi-media deletion */
    DEFINE BUFFER lbx_gsm_multi_media FOR gsm_multi_media.
    DEFINE BUFFER lby_gsm_multi_media FOR gsm_multi_media.

    IF CAN-FIND(FIRST lbx_gsm_multi_media
                WHERE lbx_gsm_multi_media.owning_obj = gsm_user.user_obj) THEN
        FOR EACH lbx_gsm_multi_media NO-LOCK
           WHERE lbx_gsm_multi_media.owning_obj = gsm_user.user_obj
           ON STOP UNDO, RETURN ERROR "AF^104^gsmustrigd.p^delete gsm_multi_media":U:
            FIND FIRST lby_gsm_multi_media EXCLUSIVE-LOCK
                 WHERE ROWID(lby_gsm_multi_media) = ROWID(lbx_gsm_multi_media)
                 NO-ERROR.
            IF AVAILABLE lby_gsm_multi_media THEN
              DO:
                {af/sup/afvalidtrg.i &action = "DELETE" &table = "lby_gsm_multi_media"}
              END.
        END.

    /* Update Audit Log */
    IF CAN-FIND(FIRST gsc_entity_mnemonic
                WHERE gsc_entity_mnemonic.entity_mnemonic = 'gsmus':U
                  AND gsc_entity_mnemonic.auditing_enabled = YES) THEN
      RUN af/app/afauditlgp.p (INPUT "DELETE":U, INPUT "gsmus":U, INPUT BUFFER gsm_user:HANDLE, INPUT BUFFER o_gsm_user:HANDLE).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


