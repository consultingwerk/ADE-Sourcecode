/* fixrmdhtmlattr.p
   Remove the dhtml attributes from the gst_record_version table that
   cause failures on load of the ADO.  
   */

DISABLE TRIGGERS FOR LOAD OF gst_record_version.

FOR EACH gst_record_version EXCLUSIVE-LOCK
  WHERE gst_record_version.entity_mnemonic = "RYCAT":U
    AND gst_record_version.key_field_value BEGINS "DHTML":U:

  DELETE gst_record_version.

END.

