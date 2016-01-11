DISABLE TRIGGERS FOR LOAD OF gst_audit.

PUBLISH "DCU_SetStatus":U ("Fixing Delimiters in Audit Records").
FOR EACH gst_audit EXCLUSIVE-LOCK
  WHERE NUM-ENTRIES(gst_audit.owning_reference) > 1:
  
  FIND FIRST gsc_entity_mnemonic NO-LOCK
    WHERE gsc_entity_mnemonic.entity_mnemonic EQ gst_audit.owning_entity_mnemonic 
    NO-ERROR.

  IF NUM-ENTRIES(gst_audit.owning_reference) EQ NUM-ENTRIES(gsc_entity_mnemonic.entity_key_field) THEN 
  DO:
    PUBLISH "DCU_WriteLog":U ("Changing Audit Record " + STRING(gst_audit.audit_obj) 
                              + " for " + gst_audit.audit_action + " of " 
                              + gst_audit.owning_entity_mnemonic ).
    ASSIGN
      gst_audit.owning_reference = REPLACE(gst_audit.owning_reference,'~,':U,CHR(2))
      .
  END.
  ELSE 
  DO:
    PUBLISH "DCU_SetStatus":U ("Error found while checking Audit Records ... Check log file").
    PUBLISH "DCU_WriteLog":U ("Error found while fixing audit record " + STRING(gst_audit.audit_obj) + " for " + gst_audit.audit_action + " of " + gst_audit.owning_entity_mnemonic ).
  END.

END.
