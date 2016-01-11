DEFINE VARIABLE cCurrEntity AS CHARACTER  NO-UNDO.
DEFINE VARIABLE lExists     AS LOGICAL    NO-UNDO.


/* Now that we definitely don't have any record version records that have no 
   entity mnemonic, we need to make sure we don't have any record version
   records that are not part of the primary entity in the dataset. */
FOR EACH gst_record_version EXCLUSIVE-LOCK
  BREAK BY gst_record_version.entity_mnemonic:

  IF FIRST-OF(gst_record_version.entity_mnemonic) THEN
  DO:
    cCurrEntity = gst_record_version.entity_mnemonic.
    FIND FIRST gsc_dataset_entity NO-LOCK
      WHERE gsc_dataset_entity.entity_mnemonic = cCurrEntity
        AND gsc_dataset_entity.primary_entity  = YES
      NO-ERROR.
    IF AVAILABLE(gsc_dataset_entity) THEN
      lExists = YES.
    ELSE
      lExists = NO.
  END.

  IF lExists THEN
    NEXT.

  DELETE gst_record_version.

END.


