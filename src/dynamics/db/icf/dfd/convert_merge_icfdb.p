
/* Noddy to remove Astra from ICF data */
/* Pieter Meyer, MIP 26/06/2001 */

/* Noddy to change AFDB,RYDB and ASDB to ICFDB in all data */
/* Pieter Meyer, MIP 02/07/2001 */

DISABLE TRIGGERS FOR DUMP OF gsm_user.                    DISABLE TRIGGERS FOR LOAD OF gsm_user.
DISABLE TRIGGERS FOR DUMP OF gsc_entity_mnemonic.         DISABLE TRIGGERS FOR LOAD OF gsc_entity_mnemonic.

DISABLE TRIGGERS FOR DUMP OF gsc_product_module.          DISABLE TRIGGERS FOR LOAD OF gsc_product_module.

DISABLE TRIGGERS FOR DUMP OF gsc_service_type.            DISABLE TRIGGERS FOR LOAD OF gsc_service_type.
DISABLE TRIGGERS FOR DUMP OF gsc_logical_service.         DISABLE TRIGGERS FOR LOAD OF gsc_logical_service.
DISABLE TRIGGERS FOR DUMP OF gsm_physical_service.        DISABLE TRIGGERS FOR LOAD OF gsm_physical_service.
DISABLE TRIGGERS FOR DUMP OF gsm_session_service.         DISABLE TRIGGERS FOR LOAD OF gsm_session_service.

DISABLE TRIGGERS FOR DUMP OF gsc_default_code.            DISABLE TRIGGERS FOR LOAD OF gsc_default_code.
DISABLE TRIGGERS FOR DUMP OF gsc_error.                   DISABLE TRIGGERS FOR LOAD OF gsc_error.
DISABLE TRIGGERS FOR DUMP OF gsc_object.                  DISABLE TRIGGERS FOR LOAD OF gsc_object.

DISABLE TRIGGERS FOR DUMP OF gsm_report_definition.       DISABLE TRIGGERS FOR LOAD OF gsm_report_definition.
DISABLE TRIGGERS FOR DUMP OF gsm_report_format.           DISABLE TRIGGERS FOR LOAD OF gsm_report_format.
DISABLE TRIGGERS FOR DUMP OF gsm_menu_item.               DISABLE TRIGGERS FOR LOAD OF gsm_menu_item.
DISABLE TRIGGERS FOR DUMP OF gsm_token.                   DISABLE TRIGGERS FOR LOAD OF gsm_token.

DISABLE TRIGGERS FOR DUMP OF gsm_category.                DISABLE TRIGGERS FOR LOAD OF gsm_category.
DISABLE TRIGGERS FOR DUMP OF gsc_custom_procedure.        DISABLE TRIGGERS FOR LOAD OF gsc_custom_procedure.
DISABLE TRIGGERS FOR DUMP OF gst_audit.                   DISABLE TRIGGERS FOR LOAD OF gst_audit.
DISABLE TRIGGERS FOR DUMP OF gst_extract_log.             DISABLE TRIGGERS FOR LOAD OF gst_extract_log.

DISABLE TRIGGERS FOR DUMP OF gsm_status.                  DISABLE TRIGGERS FOR LOAD OF gsm_status.
DISABLE TRIGGERS FOR DUMP OF gsm_status_history.          DISABLE TRIGGERS FOR LOAD OF gsm_status_history.
DISABLE TRIGGERS FOR DUMP OF gst_error_log.               DISABLE TRIGGERS FOR LOAD OF gst_error_log.
DISABLE TRIGGERS FOR DUMP OF gst_batch_job.               DISABLE TRIGGERS FOR LOAD OF gst_batch_job.

DISABLE TRIGGERS FOR DUMP OF gsm_profile.                 DISABLE TRIGGERS FOR LOAD OF gsm_profile.
DISABLE TRIGGERS FOR DUMP OF gsm_profile_history.         DISABLE TRIGGERS FOR LOAD OF gsm_profile_history.
DISABLE TRIGGERS FOR DUMP OF gsm_profile_date_value.      DISABLE TRIGGERS FOR LOAD OF gsm_profile_date_value.
DISABLE TRIGGERS FOR DUMP OF gsm_profile_alpha_value.     DISABLE TRIGGERS FOR LOAD OF gsm_profile_alpha_value.
DISABLE TRIGGERS FOR DUMP OF gsm_profile_alpha_options.   DISABLE TRIGGERS FOR LOAD OF gsm_profile_alpha_options.
DISABLE TRIGGERS FOR DUMP OF gsm_profile_numeric_value.   DISABLE TRIGGERS FOR LOAD OF gsm_profile_numeric_value.
DISABLE TRIGGERS FOR DUMP OF gsm_profile_numeric_options. DISABLE TRIGGERS FOR LOAD OF gsm_profile_numeric_options.

DISABLE TRIGGERS FOR DUMP OF gsc_profile_code.            DISABLE TRIGGERS FOR LOAD OF gsc_profile_code.
DISABLE TRIGGERS FOR DUMP OF gsm_profile_data.            DISABLE TRIGGERS FOR LOAD OF gsm_profile_data.

DISABLE TRIGGERS FOR DUMP OF gsm_comment.                 DISABLE TRIGGERS FOR LOAD OF gsm_comment.
DISABLE TRIGGERS FOR DUMP OF gsc_language_text.           DISABLE TRIGGERS FOR LOAD OF gsc_language_text.
DISABLE TRIGGERS FOR DUMP OF gsc_document_type.           DISABLE TRIGGERS FOR LOAD OF gsc_document_type.
DISABLE TRIGGERS FOR DUMP OF gsm_default_report_format.   DISABLE TRIGGERS FOR LOAD OF gsm_default_report_format.

DISABLE TRIGGERS FOR DUMP OF gsm_entity_field.            DISABLE TRIGGERS FOR LOAD OF gsm_entity_field.
DISABLE TRIGGERS FOR DUMP OF gsm_entity_field_value.      DISABLE TRIGGERS FOR LOAD OF gsm_entity_field_value.

DISABLE TRIGGERS FOR DUMP OF gsm_external_xref.           DISABLE TRIGGERS FOR LOAD OF gsm_external_xref.

DISABLE TRIGGERS FOR DUMP OF gsc_default_code.            DISABLE TRIGGERS FOR LOAD OF gsc_default_code.
DISABLE TRIGGERS FOR DUMP OF gsc_default_set.             DISABLE TRIGGERS FOR LOAD OF gsc_default_set.
DISABLE TRIGGERS FOR DUMP OF gsc_default_set_usage.       DISABLE TRIGGERS FOR LOAD OF gsc_default_set_usage.

DISABLE TRIGGERS FOR DUMP OF gsm_site_specific.           DISABLE TRIGGERS FOR LOAD OF gsm_site_specific.

DISABLE TRIGGERS FOR DUMP OF gsm_server_context.          DISABLE TRIGGERS FOR LOAD OF gsm_server_context.
DISABLE TRIGGERS FOR DUMP OF gst_trigger_override.        DISABLE TRIGGERS FOR LOAD OF gst_trigger_override.
DISABLE TRIGGERS FOR DUMP OF gst_record_version.          DISABLE TRIGGERS FOR LOAD OF gst_record_version.

 
DISABLE TRIGGERS FOR DUMP OF rvm_task_object.             DISABLE TRIGGERS FOR LOAD OF rvm_task_object.

DISABLE TRIGGERS FOR DUMP OF rvc_configuration_type.      DISABLE TRIGGERS FOR LOAD OF rvc_configuration_type.
DISABLE TRIGGERS FOR DUMP OF rvt_item_version.            DISABLE TRIGGERS FOR LOAD OF rvt_item_version.

DISABLE TRIGGERS FOR DUMP OF ryc_attribute_value.         DISABLE TRIGGERS FOR LOAD OF ryc_attribute_value.

DISABLE TRIGGERS FOR DUMP OF rym_data_version.            DISABLE TRIGGERS FOR LOAD OF rym_data_version.

DISABLE TRIGGERS FOR DUMP OF rym_wizard_menc.             DISABLE TRIGGERS FOR LOAD OF rym_wizard_menc.
DISABLE TRIGGERS FOR DUMP OF rym_wizard_objc.             DISABLE TRIGGERS FOR LOAD OF rym_wizard_objc.
DISABLE TRIGGERS FOR DUMP OF rym_wizard_brow.             DISABLE TRIGGERS FOR LOAD OF rym_wizard_brow.
DISABLE TRIGGERS FOR DUMP OF rym_wizard_fold.             DISABLE TRIGGERS FOR LOAD OF rym_wizard_fold.
DISABLE TRIGGERS FOR DUMP OF rym_wizard_view.             DISABLE TRIGGERS FOR LOAD OF rym_wizard_view.
DISABLE TRIGGERS FOR DUMP OF rym_lookup_field.            DISABLE TRIGGERS FOR LOAD OF rym_lookup_field.

DEFINE VARIABLE cUserDeny   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cUserPower  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cUserNormal AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cUserOther  AS CHARACTER  NO-UNDO.

/* This TEMP-TABLE is the same as the one defined in af/sup2/gscemcrrcp.p */
DEFINE TEMP-TABLE ttImport
  FIELD cDatabase           AS CHARACTER
  FIELD cTable              AS CHARACTER
  FIELD cDumpName           AS CHARACTER
  FIELD cDescription        AS CHARACTER
  FIELD lImport             AS LOGICAL.

DEFINE VARIABLE cError      AS CHARACTER  NO-UNDO.

DEFINE VARIABLE cObjectRVDB AS LOGICAL    NO-UNDO.

ASSIGN
  cUserDeny   = "annette,ezan,francois,jay,jean,jenny,kieren,robin,sean"
  cUserPower  = "anthony,jm,mark,peter,pm"
  cUserNormal = "carol,chris,dave,dewald,hiton,jill,leona,marcia,neil,patrick,richard,spiros,stefan,stephen,stuart"
  cUserOther  = "thomas"
  .

/* tidy up gsm_user data for MIP users */
FIND FIRST gsc_language NO-LOCK
  WHERE gsc_language.language_code = "english".
FOR EACH gsm_user:
  IF LOOKUP(gsm_user.user_login_name,cUserDeny)   > 0
  OR LOOKUP(gsm_user.user_login_name,cUserPower)  > 0
  OR LOOKUP(gsm_user.user_login_name,cUserNormal) > 0
  OR LOOKUP(gsm_user.user_login_name,cUserOther)  > 0
  THEN DO:
    IF LOOKUP(gsm_user.user_login_name,cUserDeny) > 0
    THEN
      ASSIGN
        gsm_user.disabled             = YES
        gsm_user.profile_user         = NO
        gsm_user.development_user     = NO
        gsm_user.maintain_system_data = NO
        .
    ELSE
    IF LOOKUP(gsm_user.user_login_name,cUserPower) > 0
    THEN
      ASSIGN
        gsm_user.profile_user         = YES
        gsm_user.development_user     = YES
        gsm_user.maintain_system_data = YES
        .
    ELSE
    IF LOOKUP(gsm_user.user_login_name,cUserNormal) > 0
    THEN
      ASSIGN
        gsm_user.profile_user         = NO
        gsm_user.development_user     = NO
        gsm_user.maintain_system_data = NO
        .

    IF LOOKUP(gsm_user.user_login_name,cUserOther) > 0
    THEN
      ASSIGN
        gsm_user.user_email_address = LC(gsm_user.user_login_name) + "@mip-europe.com".
    ELSE
      ASSIGN
        gsm_user.user_email_address = LC(gsm_user.user_login_name) + "@mip-holdings.com"
        gsm_user.language_obj       = gsc_language.language_obj
        .
  END.
  ASSIGN
    gsm_user.user_email_address = REPLACE(gsm_user.user_email_address,"janus.mipnet","mip-holdings.com")
    gsm_user.user_email_address = REPLACE(gsm_user.user_email_address,"mip.co.za"   ,"mip-holdings.com")
    .
END.

/* Fix entity mnemonic narrations from modified database descriptions fields */
/* Fix entity mnemonic narrations and from modified database descriptions fields and correct entity_dbname */
FOR EACH gsc_entity_mnemonic
  WHERE gsc_entity_mnemonic.entity_mnemonic_description BEGINS "gsm_task":
  ASSIGN
    gsc_entity_mnemonic.entity_mnemonic             = REPLACE(gsc_entity_mnemonic.entity_mnemonic,"GSM","RVM")
    gsc_entity_mnemonic.entity_mnemonic_description = REPLACE(gsc_entity_mnemonic.entity_mnemonic_description,"gsm","rvm")
    .
END.

EMPTY TEMP-TABLE ttImport.

FOR EACH icfdb._file NO-LOCK
  WHERE NOT icfdb._file._file-name BEGINS "_"
  AND icfdb._file._file-number > 0
  AND icfdb._file._file-number < 32768:
  FIND FIRST gsc_entity_mnemonic
    WHERE TRIM(gsc_entity_mnemonic.entity_mnemonic) = CAPS(TRIM(icfdb._file._dump-name)) NO-ERROR.
  IF AVAILABLE gsc_entity_mnemonic
  THEN
    ASSIGN
      gsc_entity_mnemonic.entity_narration    = icfdb._file._desc
      gsc_entity_mnemonic.entity_dbname       = "icfdb"
      gsc_entity_mnemonic.table_prefix_length = 4
      .
  ELSE DO:
    CREATE ttImport.
    ASSIGN
      cDatabase     = "icfdb"
      cTable        = icfdb._file._file-name
      cDumpName     = icfdb._file._dump-name
      cDescription  = icfdb._file._desc
      lImport       = YES
      .
  END.

END.

FOR EACH rvdb._file NO-LOCK
  WHERE NOT rvdb._file._file-name BEGINS "_"
  AND rvdb._file._file-number > 0
  AND rvdb._file._file-number < 32768:
  FIND FIRST gsc_entity_mnemonic
    WHERE TRIM(gsc_entity_mnemonic.entity_mnemonic) = CAPS(TRIM(rvdb._file._dump-name)) NO-ERROR.
  IF AVAILABLE gsc_entity_mnemonic
  THEN
    ASSIGN
      gsc_entity_mnemonic.entity_narration    = rvdb._file._desc
      gsc_entity_mnemonic.entity_dbname       = "rvdb"
      gsc_entity_mnemonic.table_prefix_length = 4
      .
  ELSE DO:
    CREATE ttImport.
    ASSIGN
      cDatabase     = "rvdb"
      cTable        = rvdb._file._file-name
      cDumpName     = rvdb._file._dump-name
      cDescription  = rvdb._file._desc
      lImport       = YES
      .
  END.
END.

DEFINE BUFFER b_gsm_session_service FOR gsm_session_service.

/* Clean up any un-used entity mnemonics */
FOR EACH gsc_entity_mnemonic
  WHERE NOT gsc_entity_mnemonic.entity_dbname = "icfdb"
  AND   NOT gsc_entity_mnemonic.entity_dbname = "rvdb":
  /* What tables is affected */
  DELETE gsc_entity_mnemonic.
END.

/* */
  RUN af/sup2/gscemcrrcp.p
    (INPUT YES
    ,INPUT 4
    ,INPUT "_"
    ,INPUT NO
    ,INPUT TABLE ttImport
    ,OUTPUT cError)
    NO-ERROR.


/* */

/* Clean up gsc_product_module due to moodules merging */
FOR EACH gsc_product_module
  WHERE INDEX(gsc_product_module.product_module_code,"dfd") > 0
  OR    INDEX(gsc_product_module.product_module_code,"trg") > 0
  OR    INDEX(gsc_product_module.product_module_code,"db")  > 0
  :

  IF  NOT CAN-FIND(FIRST gsm_menu_structure     WHERE gsm_menu_structure.product_module_obj      = gsc_product_module.product_module_obj)
  AND NOT CAN-FIND(FIRST gsm_security_structure WHERE gsm_security_structure.product_module_obj  = gsc_product_module.product_module_obj)
  AND NOT CAN-FIND(FIRST gsm_flow               WHERE gsm_flow.product_module_obj                = gsc_product_module.product_module_obj)
  AND NOT CAN-FIND(FIRST gsc_object             WHERE gsc_object.product_module_obj              = gsc_product_module.product_module_obj)
  AND NOT CAN-FIND(FIRST ryc_smartobject        WHERE ryc_smartobject.product_module_obj         = gsc_product_module.product_module_obj)
  AND NOT CAN-FIND(FIRST rvc_configuration_type WHERE rvc_configuration_type.product_module_obj  = gsc_product_module.product_module_obj)
  AND NOT CAN-FIND(FIRST rvm_configuration_item WHERE rvm_configuration_item.product_module_obj  = gsc_product_module.product_module_obj)
  AND NOT CAN-FIND(FIRST rvm_workspace_item     WHERE rvm_workspace_item.product_module_obj      = gsc_product_module.product_module_obj)
  AND NOT CAN-FIND(FIRST rvm_workspace_module   WHERE rvm_workspace_module.product_module_obj    = gsc_product_module.product_module_obj)
  AND NOT CAN-FIND(FIRST rvt_deleted_item       WHERE rvt_deleted_item.product_module_obj        = gsc_product_module.product_module_obj)
  AND NOT CAN-FIND(FIRST rvt_item_version       WHERE rvt_item_version.product_module_obj        = gsc_product_module.product_module_obj)
  AND NOT CAN-FIND(FIRST rvt_transaction        WHERE rvt_transaction.product_module_obj         = gsc_product_module.product_module_obj)
  /* AND NOT CAN-FIND(FIRST rvm_task_object WHERE rvm_task_object.object_product_module = gsc_product_module.product_module_code) */
  THEN
    DELETE gsc_product_module.

END.


/* Clean up gsc_logical_service due to modules merging */
FOR EACH gsc_logical_service:

  CASE gsc_logical_service.logical_service_code:
    WHEN "AFDB"
      THEN DO:
        ASSIGN
          gsc_logical_service.logical_service_code        = REPLACE(gsc_logical_service.logical_service_code       ,"AFDB","ICFDB")
          gsc_logical_service.logical_service_description = REPLACE(gsc_logical_service.logical_service_description,"AFDB","ICFDB")
          .
      END.
    WHEN "ASDB" OR
    WHEN "RYDB"
      THEN DO:
        FIND FIRST gsc_service_type
          WHERE gsc_service_type.default_logical_service_obj  = gsc_logical_service.logical_service_obj
          NO-ERROR.
        IF AVAILABLE gsc_service_type
        THEN DO:
          ASSIGN
            gsc_service_type.default_logical_service_obj = 0.
        END.
        FIND FIRST gsm_session_service
          WHERE gsm_session_service.logical_service_obj = gsc_logical_service.logical_service_obj
          NO-ERROR.
        IF AVAILABLE gsm_session_service
        THEN DO:
          FIND FIRST gsm_physical_service
            WHERE gsm_physical_service.physical_service_obj = gsm_session_service.physical_service_obj
            NO-ERROR.
          IF AVAILABLE gsm_physical_service
          AND NOT CAN-FIND(FIRST b_gsm_session_service
                           WHERE b_gsm_session_service.session_service_obj <> gsm_session_service.session_service_obj
                           AND   b_gsm_session_service.physical_service_obj = gsm_physical_service.physical_service_obj)
          THEN DO:
            DELETE gsm_physical_service.
          END.
          DELETE gsm_session_service.
        END.
        DELETE gsc_logical_service.
      END.
  END CASE.

END.


/* Clean up gsm_physical_service due to modules merging */
FIND FIRST gsc_service_type
  WHERE gsc_service_type.service_type_code = "Database"
  NO-ERROR.
IF AVAILABLE gsc_service_type
THEN
FOR EACH gsm_physical_service
  WHERE gsm_physical_service.service_type_obj = gsc_service_type.service_type_obj
  :
  CASE SUBSTRING(gsm_physical_service.physical_service_code,1,5):
    WHEN "DEVAF"
      THEN DO:
        ASSIGN
          gsm_physical_service.physical_service_code        = REPLACE(gsm_physical_service.physical_service_code       ,"DEVAF","DEVICF")
          gsm_physical_service.physical_service_description = REPLACE(gsm_physical_service.physical_service_description,"DEVAF","DEVICF")
          .
      END.
    WHEN "DEVAS" OR
    WHEN "DEVRY"
      THEN DO:
        FIND FIRST gsm_session_service
          WHERE gsm_session_service.physical_service_obj = gsm_physical_service.physical_service_obj
          NO-ERROR.
        IF AVAILABLE gsm_session_service
        THEN DO:
          DELETE gsm_session_service.
        END.
        DELETE gsm_physical_service.
      END.
  END CASE.
END.


/* Fix default code field to correct db prefix */
FOR EACH gsc_default_code:
  ASSIGN
    gsc_default_code.field_name = REPLACE(gsc_default_code.field_name,"gsdb","icfdb")
    gsc_default_code.field_name = REPLACE(gsc_default_code.field_name,"afdb","icfdb")
    gsc_default_code.field_name = REPLACE(gsc_default_code.field_name,"rydb","icfdb")
    gsc_default_code.field_name = REPLACE(gsc_default_code.field_name,"asdb","icfdb")
    .
END.


/* Fix error_full_description to correct db prefix */
FOR EACH gsc_error:
  ASSIGN
    gsc_error.error_full_description = REPLACE(gsc_error.error_full_description,"GSDB","ICFDB")
    gsc_error.error_full_description = REPLACE(gsc_error.error_full_description,"AFDB","ICFDB")
    gsc_error.error_full_description = REPLACE(gsc_error.error_full_description,"RYDB","ICFDB")
    gsc_error.error_full_description = REPLACE(gsc_error.error_full_description,"ASDB","ICFDB")
    .
END.

/* delete all report definitions and formats - none used currently. Left reporting tools */
FOR EACH gsm_report_definition:
  DELETE gsm_report_definition.
END.

FOR EACH gsm_report_format:
  DELETE gsm_report_format.
END.

/* Fix object descriptions and tooltips to remove Astra */
/* Fix object DB required list to fix db prefix */
FOR EACH gsc_object:
  ASSIGN
    gsc_object.object_description = REPLACE(gsc_object.object_description,"Astra 2","ICF")
    gsc_object.object_description = REPLACE(gsc_object.object_description,"Astra " ,"ICF ")
    .
  IF gsc_object.tooltip_text = ""
  THEN
    ASSIGN
      gsc_object.tooltip_text     = gsc_object.object_description
      .
  ELSE
    ASSIGN
      gsc_object.tooltip_text     = REPLACE(gsc_object.tooltip_text,"Astra 2","ICF")
      gsc_object.tooltip_text     = REPLACE(gsc_object.tooltip_text,"Astra " ,"ICF ")
      .

  IF gsc_object.required_db_list <> "":U
  THEN DO:

    IF LOOKUP(gsc_object.required_db_list,"rvdb") <> 0
    THEN cObjectRVDB = YES.
    ELSE cObjectRVDB = NO.
  
    IF LOOKUP(gsc_object.required_db_list,"afdb,asdb,gsdb,rydb") <> 0
    THEN ASSIGN gsc_object.required_db_list = "icfdb".
    ELSE ASSIGN gsc_object.required_db_list = "".
  
    IF cObjectRVDB = YES
    THEN DO:
      IF gsc_object.required_db_list <> "":U
      THEN ASSIGN gsc_object.required_db_list = "icfdb,rvdb".
      ELSE ASSIGN gsc_object.required_db_list = "rvdb".
    END.

  END.

END.


/* Fix menu item descriptions and menu structure descriptions */
FOR EACH gsm_menu_item:
  ASSIGN
    gsm_menu_item.menu_item_description = REPLACE(gsm_menu_item.menu_item_description,"Astra 2","ICF")
    gsm_menu_item.menu_item_description = REPLACE(gsm_menu_item.menu_item_description,"Astra"  ,"ICF")
    .
END.


FOR EACH gsm_menu_structure:
  ASSIGN
    gsm_menu_structure.menu_structure_description = REPLACE(gsm_menu_structure.menu_structure_description,"Astra 2","ICF")
    gsm_menu_structure.menu_structure_description = REPLACE(gsm_menu_structure.menu_structure_description,"Astra"  ,"ICF")
    .
END.


/* Fix task object descriptions to replace Astra */
FOR EACH rvm_task_object:
  ASSIGN
    rvm_task_object.object_description = REPLACE(rvm_task_object.object_description,"Astra 2","ICF")
    rvm_task_object.object_description = REPLACE(rvm_task_object.object_description,"Astra"  ,"ICF")
    .
END.


/* Fix token descriptions to replace Astra */
FOR EACH gsm_token:
  ASSIGN
    gsm_token.token_description = REPLACE(gsm_token.token_description,"Astra 2","ICF")
    gsm_token.token_description = REPLACE(gsm_token.token_description,"Astra"  ,"ICF")
    .
END.

/* Cleanup any unrelated data in the categories */
FOR EACH gsm_category:

  IF (gsm_category.owning_entity_mnemonic  <> ""
      AND NOT CAN-FIND(FIRST gsc_entity_mnemonic NO-LOCK WHERE gsc_entity_mnemonic.entity_mnemonic = gsm_category.owning_entity_mnemonic )  )
  OR (gsm_category.related_entity_mnemonic <> ""
      AND NOT CAN-FIND(FIRST gsc_entity_mnemonic NO-LOCK WHERE gsc_entity_mnemonic.entity_mnemonic = gsm_category.related_entity_mnemonic ) )
  OR (gsm_category.owning_entity_mnemonic  = ""
   AND gsm_category.related_entity_mnemonic = "" )
  AND NOT CAN-FIND(FIRST gsc_custom_procedure NO-LOCK WHERE gsc_custom_procedure.category_obj = gsm_category.category_obj )
  AND NOT CAN-FIND(FIRST gsc_language_text    NO-LOCK WHERE gsc_language_text.category_obj    = gsm_category.category_obj )
  AND NOT CAN-FIND(FIRST gsm_comment          NO-LOCK WHERE gsm_comment.category_obj          = gsm_category.category_obj )
  AND NOT CAN-FIND(FIRST gsm_control_code     NO-LOCK WHERE gsm_control_code.category_obj     = gsm_category.category_obj )
  AND NOT CAN-FIND(FIRST gsm_multi_media      NO-LOCK WHERE gsm_multi_media.category_obj      = gsm_category.category_obj )
  AND NOT CAN-FIND(FIRST gsm_profile          NO-LOCK WHERE gsm_profile.category_obj          = gsm_category.category_obj )
  AND NOT CAN-FIND(FIRST gsm_status           NO-LOCK WHERE gsm_status.category_obj           = gsm_category.category_obj )
  THEN
    DELETE gsm_category.

  IF  NOT gsm_category.category_type = "STS"
  AND NOT (gsm_category.category_type = "NOT" AND gsm_category.category_subgroup = "NOT")
  THEN DO:

    FOR EACH gsc_custom_procedure
      WHERE gsc_custom_procedure.category_obj = gsm_category.category_obj:
      DELETE
        gsc_custom_procedure.
    END.

    FOR EACH gsm_status
      WHERE gsm_status.category_obj = gsm_category.category_obj:
      DELETE
        gsm_status.
    END.

    DELETE gsm_category.

  END.

END.


/* Clean out all old custom procedure data. */
FOR EACH gsc_custom_procedure:

  IF (gsc_custom_procedure.category_obj <> 0
      AND NOT CAN-FIND(FIRST gsm_category WHERE gsm_category.category_obj = gsc_custom_procedure.category_obj ) )
  OR INDEX(gsc_custom_procedure.procedure_name,"calculate-") > 0
  OR INDEX(gsc_custom_procedure.procedure_name,"mip-")       > 0
  OR INDEX(gsc_custom_procedure.procedure_name,"gs~/")       > 0
  OR INDEX(gsc_custom_procedure.procedure_name,"ac~/")       > 0
  OR INDEX(gsc_custom_procedure.procedure_name,"ac-")        > 0
  OR INDEX(gsc_custom_procedure.procedure_name,"account")    > 0
  OR INDEX(gsc_custom_procedure.procedure_name,"costcentre") > 0
  THEN
    DELETE
      gsc_custom_procedure.
END.


/* Clean out all old audit history. New audit procedure are being written. */
FOR EACH gst_audit:
  DELETE gst_audit.
END.


/* Clean out all old extract log. No reporting is available yet. */
FOR EACH gst_extract_log:
  DELETE gst_extract_log.
END.


/* Clean out all old error log. */
FOR EACH gst_error_log:
  DELETE gst_error_log.
END.


/* Clean out all old batch job log. */
FOR EACH gst_batch_job:
  DELETE gst_batch_job.
END.


/* Clean out all old profile data. */
FOR EACH gsm_profile:
  DELETE gsm_profile.
END.
FOR EACH gsm_profile_history:
  DELETE gsm_profile_history.
END.
FOR EACH gsm_profile_date_value:
  DELETE gsm_profile_date_value.
END.
FOR EACH gsm_profile_alpha_value:
  DELETE gsm_profile_alpha_value.
END.
FOR EACH gsm_profile_alpha_options:
  DELETE gsm_profile_alpha_options.
END.
FOR EACH gsm_profile_numeric_value:
  DELETE gsm_profile_numeric_value.
END.
FOR EACH gsm_profile_numeric_options:
  DELETE gsm_profile_numeric_options.
END.

/* Correct additional profile information if any */
FOR EACH gsc_profile_code:

  IF gsc_profile_code.profile_type_obj = 0 OR (gsc_profile_code.profile_type_obj <> 0 AND NOT CAN-FIND(FIRST gsc_profile_type NO-LOCK WHERE gsc_profile_type.profile_type_obj = gsc_profile_code.profile_type_obj ) )
  THEN
    DELETE
      gsc_profile_code
      .
END.

FOR EACH gsm_profile_data:

  IF gsm_profile_data.user_obj         = 0 OR (gsm_profile_data.user_obj         <> 0 AND NOT CAN-FIND(FIRST gsm_user         NO-LOCK WHERE gsm_user.user_obj                 = gsm_profile_data.user_obj ) )
  OR gsm_profile_data.profile_type_obj = 0 OR (gsm_profile_data.profile_type_obj <> 0 AND NOT CAN-FIND(FIRST gsc_profile_type NO-LOCK WHERE gsc_profile_type.profile_type_obj = gsm_profile_data.profile_type_obj ) )
  OR gsm_profile_data.profile_code_obj = 0 OR (gsm_profile_data.profile_code_obj <> 0 AND NOT CAN-FIND(FIRST gsc_profile_code NO-LOCK WHERE gsc_profile_code.profile_code_obj = gsm_profile_data.profile_code_obj ) )
  THEN
    DELETE
      gsm_profile_data
      .
END.


/* Clean out all old and test comment data. */
FOR EACH gsm_comment:
  DELETE gsm_comment.
END.

/* Clean out all old and test language text data. */
FOR EACH gsc_language_text:
  DELETE gsc_language_text.
END.

/* Clean out all old and test document type data. */
FOR EACH gsc_document_type
  WHERE gsc_document_type.document_type_tla <> "REP"
  AND   gsc_document_type.document_type_tla <> "OTH"
  :
  DELETE gsc_document_type.
END.


/* Clean out all old and test default report format data. */
FOR EACH gsm_default_report_format:
  DELETE gsm_default_report_format.
END.


/* Clean out all old and test entity field format data. */
FOR EACH gsm_entity_field:
  DELETE gsm_entity_field.
END.


/* Clean out all old and test entity field value format data. */
FOR EACH gsm_entity_field_value:
  DELETE gsm_entity_field_value.
END.


/* Clean out all old and test external xref data. */
FOR EACH gsm_external_xref:
  DELETE gsm_external_xref.
END.


/* Clean out all old and test default code data. */
FOR EACH gsc_default_code:
  DELETE gsc_default_code.
END.


/* Clean out all old and test default set data. */
FOR EACH gsc_default_set:
  DELETE gsc_default_set.
END.


/* Clean out all old and test default set usage data. */
FOR EACH gsc_default_set_usage:
  DELETE gsc_default_set_usage.
END.


/* Clean out all old and test site specific data. */
FOR EACH gsm_site_specific:
  DELETE gsm_site_specific.
END.


/* Clean out all old and test server context data. */
FOR EACH gsm_server_context:
  DELETE gsm_server_context.
END.


/* Clean out all old and test trigger override data. */
FOR EACH gst_trigger_override:
  DELETE gst_trigger_override.
END.


/* Clean out all old and test record version data. */
FOR EACH gst_record_version:
  DELETE gst_record_version.
END.







/* Fix RV data to replace Astra */
FOR EACH rvc_configuration_type:
  ASSIGN
    rvc_configuration_type.type_description = REPLACE(rvc_configuration_type.type_description,"Astra 2","ICF")
    rvc_configuration_type.type_description = REPLACE(rvc_configuration_type.type_description,"Astra"  ,"ICF")
    .
END.


FOR EACH rvt_item_version:
  ASSIGN
    rvt_item_version.item_description = REPLACE(rvt_item_version.item_description,"Astra 2","ICF")
    rvt_item_version.item_description = REPLACE(rvt_item_version.item_description,"Astra"  ,"ICF")
    .
END.

FOR EACH rym_data_version:
  IF (rym_data_version.related_entity_mnemonic <> ""
      AND NOT CAN-FIND(FIRST gsc_entity_mnemonic NO-LOCK WHERE gsc_entity_mnemonic.entity_mnemonic = rym_data_version.related_entity_mnemonic ) )
  OR rym_data_version.related_entity_mnemonic = ""
  OR (rym_data_version.related_entity_key <> ""
      AND NOT CAN-FIND(FIRST gsc_object NO-LOCK WHERE gsc_object.object_filename = rym_data_version.related_entity_key ) )
  OR rym_data_version.related_entity_key = ""
  THEN
    DELETE
      rym_data_version
      .
END.


/* Fix window title attribute value to replace out Astra */
FOR EACH ryc_attribute_value
  WHERE attribute_label = "WindowName":
  ASSIGN
    ryc_attribute_value.attribute_value = REPLACE(ryc_attribute_value.attribute_value,"Astra 2","ICF")
    ryc_attribute_value.attribute_value = REPLACE(ryc_attribute_value.attribute_value,"Astra2" ,"ICF")
    ryc_attribute_value.attribute_value = REPLACE(ryc_attribute_value.attribute_value,"Astra"  ,"ICF")
    .
END.


/* Cleanup any un-related wizard record */
FOR EACH rym_wizard_menc:
  IF NOT CAN-FIND(FIRST gsc_object NO-LOCK WHERE gsc_object.object_filename = rym_wizard_menc.object_name)
  AND NOT CAN-FIND(FIRST gsc_entity_mnemonic NO-LOCK WHERE rym_wizard_menc.object_name BEGINS gsc_entity_mnemonic.entity_mnemonic)
  THEN
    DELETE rym_wizard_menc.
END.

/* Cleanup any un-related wizard record */
FOR EACH rym_wizard_objc:
  IF NOT CAN-FIND(FIRST gsc_object NO-LOCK WHERE gsc_object.object_filename = rym_wizard_objc.object_name)
  AND NOT CAN-FIND(FIRST gsc_entity_mnemonic NO-LOCK WHERE rym_wizard_objc.object_name BEGINS gsc_entity_mnemonic.entity_mnemonic)
  THEN
    DELETE rym_wizard_objc.
END.

/* Cleanup any un-related wizard record */
FOR EACH rym_wizard_brow:
  IF NOT CAN-FIND(FIRST gsc_object NO-LOCK WHERE gsc_object.object_filename = rym_wizard_brow.object_name)
  AND NOT CAN-FIND(FIRST gsc_entity_mnemonic NO-LOCK WHERE rym_wizard_brow.object_name BEGINS gsc_entity_mnemonic.entity_mnemonic)
  THEN
    DELETE rym_wizard_brow.
END.

/* Cleanup any un-related wizard record */
FOR EACH rym_wizard_fold:
  IF NOT CAN-FIND(FIRST gsc_object NO-LOCK WHERE gsc_object.object_filename = rym_wizard_fold.object_name)
  AND NOT CAN-FIND(FIRST gsc_entity_mnemonic NO-LOCK WHERE rym_wizard_fold.object_name BEGINS gsc_entity_mnemonic.entity_mnemonic)
  THEN
    DELETE rym_wizard_fold.
END.

/* Cleanup any un-related wizard record */
FOR EACH rym_wizard_view:
  IF NOT CAN-FIND(FIRST gsc_object NO-LOCK WHERE gsc_object.object_filename = rym_wizard_view.object_name)
  AND NOT CAN-FIND(FIRST gsc_entity_mnemonic NO-LOCK WHERE rym_wizard_view.object_name BEGINS gsc_entity_mnemonic.entity_mnemonic)
  THEN
    DELETE rym_wizard_view.
END.

/* Cleanup any un-related lookup record */
FOR EACH rym_lookup_field:
  IF NOT CAN-FIND(FIRST gsc_object NO-LOCK WHERE gsc_object.object_filename = rym_lookup_field.specific_object_name)
  AND NOT CAN-FIND(FIRST gsc_entity_mnemonic NO-LOCK WHERE rym_lookup_field.specific_object_name BEGINS gsc_entity_mnemonic.entity_mnemonic)
  THEN
    DELETE rym_lookup_field.
END.


