&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Check Version Notes Wizard" Include _INLINE
/* Actions: af/cod/aftemwizcw.w ? ? ? ? */
/* MIP Update Version Notes Wizard
Check object version notes.
af/cod/aftemwizpw.w
*/
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Update-Object-Version" Include _INLINE
/* Actions: ? ? ? ? af/sup/afverxftrp.p */
/* This has to go above the definitions sections, as that is what it modifies.
   If its not, then the definitions section will have been saved before the
   XFTR code kicks in and changes it */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Definition Comments Wizard" Include _INLINE
/* Actions: ? af/cod/aftemwizcw.w ? ? ? */
/* Program Definition Comment Block Wizard
Welcome to the Program Definition Comment Block Wizard. Press Next to proceed.
af/cod/aftemwizpw.w
*/
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Include 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*---------------------------------------------------------------------------------
  File: afauditlog.i

  Description:  Include file to update audit log

  Purpose:      Include file used in all triggers to update audit log.

  Parameters:   Takes insertion parameters as follows:
                &action = CREATE or DELETE or WRITE
                &fla = table FLA
                &details = caret delimited list of field names + old values + new values
                &obj = object number of table being audited

  History:
  --------
  (v:010000)    Task:         771   UserRef:    Astra
                Date:   26/11/1998  Author:     Anthony Swindells

  Update Notes: Created from Template afteminclu.i

  (v:010001)    Task:         793   UserRef:    
                Date:   27/11/1998  Author:     Anthony Swindells

  Update Notes: Fix auditing on users - when looging on there are no plips and we do not know
                who we are yet.

  (v:010003)    Task:        6321   UserRef:    
                Date:   20/07/2000  Author:     Jenny Bond

  Update Notes: Modified afauditlog.i to pass lv_audit_details to this procedure, as the fields
                being used before were not defined in the create or delete triggers, only the
                write triggers.  You can imagine the hvoc this caused when a compile was done!

-------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       afauditlog.i
&scop object-version    010003


/* MIP object identifying preprocessor */
&glob   mip-structured-include  yes

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
         HEIGHT             = 5.48
         WIDTH              = 49.2.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME




&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */

DEFINE BUFFER lba_gsm_category FOR gsm_category.
DEFINE BUFFER lba_gst_audit FOR gst_audit.

IF CAN-FIND(FIRST lba_gsm_category 
            WHERE lba_gsm_category.related_entity_mnemonic = "GSTAD":U
              AND lba_gsm_category.category_type = SUBSTRING("{&FLA}",1,2)
              AND lba_gsm_category.category_group = SUBSTRING("{&FLA}",3,1)
              AND lba_gsm_category.category_subgroup = SUBSTRING("{&FLA}",4,2)
              AND lba_gsm_category.category_active = YES) THEN
    DO:   /* Auditing enabled for this table */
    /* 1st get the user performing the action */
        IF VALID-HANDLE(gh_local_app_plip) AND lv_current_user_obj = 0 THEN
            RUN mip-get-user IN gh_local_app_plip ( OUTPUT lv_current_user_obj,
                                                    OUTPUT lv_current_user_login,
                                                    OUTPUT lv_current_user_name,
                                                    OUTPUT lv_current_organisation_obj,
                                                    OUTPUT lv_current_organisation_code,
                                                    OUTPUT lv_current_organisation_name,
                                                    OUTPUT lv_current_organisation_short,
                                                    OUTPUT lv_current_login_values).      
        ELSE IF VALID-HANDLE(gh_remote_app_plip) AND lv_current_user_obj = 0 THEN
            RUN mip-get-user IN gh_remote_app_plip ( OUTPUT lv_current_user_obj,
                                                    OUTPUT lv_current_user_login,
                                                    OUTPUT lv_current_user_name,
                                                    OUTPUT lv_current_organisation_obj,
                                                    OUTPUT lv_current_organisation_code,
                                                    OUTPUT lv_current_organisation_name,
                                                    OUTPUT lv_current_organisation_short,
                                                    OUTPUT lv_current_login_values).      

        /* Specific to login situation the next line */
        IF lv_current_user_obj = 0 AND AVAILABLE gsm_user THEN
            ASSIGN lv_current_user_obj = gsm_user.user_obj.

        /* Get the category object number */
        FIND FIRST lba_gsm_category NO-LOCK
             WHERE lba_gsm_category.related_entity_mnemonic = "GSTAD":U
               AND lba_gsm_category.category_type = SUBSTRING("{&FLA}",1,2)
               AND lba_gsm_category.category_group = SUBSTRING("{&FLA}",3,1)
               AND lba_gsm_category.category_subgroup = SUBSTRING("{&FLA}",4,2)
             NO-ERROR.

        IF AVAILABLE lba_gsm_category AND lv_current_user_obj > 0 THEN DO:
            DEFINE VARIABLE lv_in_trigger_name AS CHARACTER FORMAT "X(60)":U NO-UNDO.
            DEFINE VARIABLE lv_in_procedure_name AS CHARACTER FORMAT "X(60)":U NO-UNDO.
            RUN get-trigger-procedure (OUTPUT lv_in_trigger_name, OUTPUT lv_in_procedure_name).

            {af/sup/afvalidtrg.i &action = "CREATE" &table = "lba_gst_audit"}
            ASSIGN
                lba_gst_audit.owning_obj = {&OBJ}
                lba_gst_audit.category_obj = lba_gsm_category.category_obj
                lba_gst_audit.audit_action = (IF "{&ACTION}":U = "CREATE":U THEN "CRE":U ELSE
                                             IF "{&ACTION}":U = "DELETE":U THEN "DEL":U ELSE
                                             "AME":U)
                lba_gst_audit.audit_date = TODAY
                lba_gst_audit.audit_time = TIME
                lba_gst_audit.audit_user_obj = lv_current_user_obj
                lba_gst_audit.program_name = lv_in_trigger_name
                lba_gst_audit.program_procedure = lv_in_procedure_name
                lba_gst_audit.old_detail = {&DETAILS}                        
                .
            {af/sup/afvalidtrg.i &action = "VALIDATE" &table = "lba_gst_audit"}
    END.         
END.

IF "{&ACTION}":U = "WRITE":U THEN DO:
    IF CAN-FIND(FIRST lba_gsm_category 
                WHERE lba_gsm_category.related_entity_mnemonic = "GSMAW":U /* FLA for gsm_automatic_workflow */
                AND   lba_gsm_category.category_type = SUBSTRING("{&FLA}",1,2)
                AND   lba_gsm_category.category_group = SUBSTRING("{&FLA}",3,1)
                AND   lba_gsm_category.category_subgroup = SUBSTRING("{&FLA}",4,2)
                AND   lba_gsm_category.category_active = YES) THEN DO:   /* Automatic workflow enabled for this table */

        RUN gs/prc/gsmawprocp.p (INPUT lv_audit_details).
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


