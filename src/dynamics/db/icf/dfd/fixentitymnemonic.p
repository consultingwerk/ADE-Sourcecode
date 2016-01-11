/* Removes all entity data for tables that no longer exist and
   cleans up the gst_record_version table so that it no longer contains data
   for records that are not the primary entity in a dataset. */

DEFINE VARIABLE cEMToDelete AS CHARACTER  NO-UNDO.
DEFINE VARIABLE iCount      AS INTEGER    NO-UNDO.
DEFINE VARIABLE cCurrEM     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE lDelete     AS LOGICAL    NO-UNDO.

FOR EACH gsc_entity_mnemonic EXCLUSIVE-LOCK
  WHERE entity_dbname = "icfdb"
     OR entity_dbname = "rvdb":
  FIND icfdb._file  NO-LOCK
    WHERE _file._file-name = gsc_entity_mnemonic.entity_mnemonic_description
    NO-ERROR.
  IF AVAILABLE(_File) THEN
    NEXT.
  
  FOR EACH gst_record_version EXCLUSIVE-LOCK
    WHERE gst_record_version.entity_mnemonic = gsc_entity_mnemonic.entity_mnemonic:
    DELETE gst_record_version.
  END.
  
  FOR EACH gsc_dataset_entity EXCLUSIVE-LOCK
    WHERE gsc_dataset_entity.entity_mnemonic = gsc_entity_mnemonic.entity_mnemonic:
    DELETE gsc_dataset_entity.
  END.

  FOR EACH gsc_dataset_entity EXCLUSIVE-LOCK
    WHERE gsc_dataset_entity.join_entity_mnemonic = gsc_entity_mnemonic.entity_mnemonic:
    DELETE gsc_dataset_entity.
  END.

  FOR EACH ryc_relationship EXCLUSIVE-LOCK
    WHERE ryc_relationship.parent_entity = gsc_entity_mnemonic.entity_mnemonic:
    FOR EACH ryc_relationship_field EXCLUSIVE-LOCK
      WHERE ryc_relationship_field.relationship_obj = ryc_relationship.relationship_obj:
      DELETE ryc_relationship_field.
    END.
    DELETE ryc_relationship.
  END.

  FOR EACH ryc_relationship EXCLUSIVE-LOCK
    WHERE ryc_relationship.child_entity = gsc_entity_mnemonic.entity_mnemonic:
    FOR EACH ryc_relationship_field EXCLUSIVE-LOCK
      WHERE ryc_relationship_field.relationship_obj = ryc_relationship.relationship_obj:
      DELETE ryc_relationship_field.
    END.
    DELETE ryc_relationship.
  END.

  FOR EACH gsc_default_set_usage EXCLUSIVE-LOCK
    WHERE gsc_default_set_usage.owning_entity_mnemonic = gsc_entity_mnemonic.entity_mnemonic:
    DELETE gsc_default_set_usage.
  END.

  FOR EACH gsc_default_code EXCLUSIVE-LOCK
    WHERE gsc_default_code.owning_entity_mnemonic = gsc_entity_mnemonic.entity_mnemonic:
    DELETE gsc_default_code.
  END.

  FOR EACH gsm_comment EXCLUSIVE-LOCK
    WHERE gsm_comment.owning_entity_mnemonic = gsc_entity_mnemonic.entity_mnemonic:
    DELETE gsm_comment.
  END.

  FOR EACH gsm_category EXCLUSIVE-LOCK
    WHERE gsm_category.owning_entity_mnemonic = gsc_entity_mnemonic.entity_mnemonic:
    DELETE gsm_category.
  END.
  
  FOR EACH gsm_user_allocation EXCLUSIVE-LOCK
    WHERE gsm_user_allocation.owning_entity_mnemonic = gsc_entity_mnemonic.entity_mnemonic:
    DELETE gsm_user_allocation.
  END.
  
  FOR EACH gsm_entity_field EXCLUSIVE-LOCK
    WHERE gsm_entity_field.owning_entity_mnemonic = gsc_entity_mnemonic.entity_mnemonic:
    FOR EACH gsm_entity_field_value EXCLUSIVE-LOCK
      WHERE gsm_entity_field_value.entity_field_obj = gsm_entity_field.entity_field_obj:
      DELETE gsm_entity_field.
    END.
    DELETE gsm_entity_field.
  END.

  FOR EACH gsm_security_structure EXCLUSIVE-LOCK
    WHERE gsm_security_structure.owning_entity_mnemonic = gsc_entity_mnemonic.entity_mnemonic:
    DELETE gsm_security_structure.
  END.

  FOR EACH gsc_entity_mnemonic_procedure EXCLUSIVE-LOCK
    WHERE gsc_entity_mnemonic_procedure.owning_entity_mnemonic = gsc_entity_mnemonic.entity_mnemonic:
    DELETE gsc_entity_mnemonic_procedure.
  END.
  
  FOR EACH gsm_external_xref EXCLUSIVE-LOCK
    WHERE gsm_external_xref.related_entity_mnemonic = gsc_entity_mnemonic.entity_mnemonic:
    DELETE gsm_external_xref.
  END.

  FOR EACH gsm_external_xref EXCLUSIVE-LOCK
    WHERE gsm_external_xref.internal_entity_mnemonic = gsc_entity_mnemonic.entity_mnemonic:
    DELETE gsm_external_xref.
  END.
  
  FOR EACH gsm_external_xref EXCLUSIVE-LOCK
    WHERE gsm_external_xref.external_entity_mnemonic = gsc_entity_mnemonic.entity_mnemonic:
    DELETE gsm_external_xref.
  END.

  FOR EACH gsc_entity_display_field EXCLUSIVE-LOCK
    WHERE gsc_entity_display_field.entity_mnemonic = gsc_entity_mnemonic.entity_mnemonic:
    DELETE gsc_entity_display_field.
  END.

  DELETE gsc_entity_mnemonic.
END.

/* Now that we definitely don't have any record version records that have no 
   entity mnemonic, we need to make sure we don't have any record version
   records that are not part of the primary entity in the dataset. */
FOR EACH gst_record_version EXCLUSIVE-LOCK
  BREAK BY gst_record_version.entity_mnemonic:

  IF FIRST-OF(gst_record_version.entity_mnemonic) THEN
  DO:
    lDelete = NO.
    FIND gsc_entity_mnemonic NO-LOCK
      WHERE gsc_entity_mnemonic.entity_mnemonic = gst_record_version.entity_mnemonic
      NO-ERROR.

    IF NOT AVAILABLE(gsc_entity_mnemonic) THEN
      lDelete = YES.
    ELSE
      IF NOT gsc_entity_mnemonic.version_data THEN
        lDelete = YES.

    IF NOT lDelete THEN
    DO:
      FIND FIRST gsc_dataset_entity NO-LOCK
        WHERE gsc_dataset_entity.entity_mnemonic = gst_record_version.entity_mnemonic
          AND gsc_dataset_entity.primary_entity  = YES
        NO-ERROR.
      IF AVAILABLE(gsc_dataset_entity) THEN
        lDelete = NO.
      ELSE
        lDelete = YES.
    END.
  END.

  IF lDelete THEN
    DELETE gst_record_version.

END.


