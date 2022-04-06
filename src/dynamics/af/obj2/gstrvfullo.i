  FIELD record_version_obj LIKE gst_record_version.record_version_obj VALIDATE ~
  FIELD entity_mnemonic LIKE gst_record_version.entity_mnemonic VALIDATE  LABEL "Entity"~
  FIELD key_field_value LIKE gst_record_version.key_field_value VALIDATE ~
  FIELD import_version_number_seq LIKE gst_record_version.import_version_number_seq VALIDATE ~
  FIELD version_number_seq LIKE gst_record_version.version_number_seq VALIDATE ~
  FIELD last_version_number_seq LIKE gst_record_version.last_version_number_seq VALIDATE ~
  FIELD version_date LIKE gst_record_version.version_date VALIDATE ~
  FIELD version_time LIKE gst_record_version.version_time VALIDATE ~
  FIELD version_user LIKE gst_record_version.version_user VALIDATE ~
  FIELD deletion_flag LIKE gst_record_version.deletion_flag VALIDATE 
