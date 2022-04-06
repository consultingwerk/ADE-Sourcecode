  FIELD audit_obj LIKE gst_audit.audit_obj VALIDATE ~
  FIELD owning_entity_mnemonic LIKE gst_audit.owning_entity_mnemonic VALIDATE ~
  FIELD owning_obj LIKE gst_audit.owning_obj VALIDATE ~
  FIELD audit_date LIKE gst_audit.audit_date VALIDATE ~
  FIELD audit_time LIKE gst_audit.audit_time VALIDATE ~
  FIELD audit_user_obj LIKE gst_audit.audit_user_obj VALIDATE ~
  FIELD program_name LIKE gst_audit.program_name VALIDATE ~
  FIELD program_procedure LIKE gst_audit.program_procedure VALIDATE ~
  FIELD audit_action LIKE gst_audit.audit_action VALIDATE ~
  FIELD old_detail LIKE gst_audit.old_detail VALIDATE ~
  FIELD entity_mnemonic_description LIKE gsc_entity_mnemonic.entity_mnemonic_description VALIDATE ~
  FIELD user_login_name LIKE gsm_user.user_login_name VALIDATE ~
  FIELD audit_time_str AS CHARACTER FORMAT "x(8)" LABEL "Audit Time"~
  FIELD entity_object_field LIKE gsc_entity_mnemonic.entity_object_field VALIDATE ~
  FIELD entity_key_field LIKE gsc_entity_mnemonic.entity_key_field VALIDATE ~
  FIELD owning_reference LIKE gst_audit.owning_reference VALIDATE 
