/* This program verifies that the gst_record_version records all have the
   appropriate secondary key settings. */

DEFINE VARIABLE lDelete   AS LOGICAL    NO-UNDO.
DEFINE VARIABLE hBuffer   AS HANDLE     NO-UNDO.
DEFINE VARIABLE cWhere    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE lObj      AS LOGICAL    NO-UNDO.
DEFINE VARIABLE cObjField AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cKeyField AS CHARACTER  NO-UNDO.
DEFINE VARIABLE iCount    AS INTEGER    NO-UNDO.
DEFINE VARIABLE cKeyValue AS CHARACTER  NO-UNDO.
DEFINE VARIABLE hField    AS HANDLE     NO-UNDO.
   
FOR EACH icfdb.gst_record_version
  WHERE gst_record_version.deletion_flag
     BREAK BY gst_record_version.entity_mnemonic:

  IF FIRST-OF(gst_record_version.entity_mnemonic) THEN
  DO:
    FIND icfdb.gsc_entity_mnemonic NO-LOCK
      WHERE gsc_entity_mnemonic.entity_mnemonic = gst_record_version.entity_mnemonic
      NO-ERROR.
    IF NOT AVAILABLE(gsc_entity_mnemonic) THEN
      ASSIGN
        lDelete   = YES
        lObj      = NO
        cObjField = "":U
        cKeyField = "":U
      .
    ELSE
    DO:
      ASSIGN
        lDelete   = NO
        lObj      = gsc_entity_mnemonic.table_has_object_field
        cObjField = gsc_entity_mnemonic.entity_object_field
        cKeyField = gsc_entity_mnemonic.entity_key_field
      .
      CREATE BUFFER hBuffer FOR TABLE "oldicfdb.":U + gsc_entity_mnemonic.entity_mnemonic_description.
    END.
  END.

  IF lDelete THEN
    DELETE gst_record_version.
  ELSE
  DO:
    /* If the table has an object field then find the parent record based on
       the object field. */
    IF lObj  THEN
    DO:
      cWhere = "WHERE ":U + hBuffer:NAME + ".":U + cObjField + " = ":U 
             + QUOTER(gst_record_version.key_field_value).
      hBuffer:FIND-UNIQUE(cWhere, NO-LOCK) NO-ERROR.

      /* If we don't have a record here, we cannot find our way back to the 
         parent so we might as well whack the gst_record_version */
      IF hBuffer:AVAILABLE THEN
      DO:
        /* Now we need to build up the secondary key */
        cKeyValue = "":U.
        IF cKeyField <> "":U THEN
        DO:
          IF NUM-ENTRIES(cKeyField) >= 2 THEN
          DO iCount = 1 TO NUM-ENTRIES(cKeyField):
            ASSIGN
              hField  = hBuffer:BUFFER-FIELD(ENTRY(iCount,cKeyField)) NO-ERROR.
            ASSIGN
              cKeyValue = cKeyValue + CHR(1) WHEN iCount > 1.
            IF VALID-HANDLE(hBuffer) AND VALID-HANDLE(hField) AND hBuffer:AVAILABLE THEN
              ASSIGN
                cKeyValue = cKeyValue + STRING(hField:BUFFER-VALUE).
            ELSE
              ASSIGN
                cKeyValue = cKeyValue + "":U.
          END.
          ELSE 
          DO:
            ASSIGN
              hField  = hBuffer:BUFFER-FIELD(cKeyField) NO-ERROR
              .       
            IF VALID-HANDLE(hBuffer) AND VALID-HANDLE(hField) AND hBuffer:AVAILABLE THEN
              ASSIGN
                cKeyValue = STRING(hField:BUFFER-VALUE).
          END.
          ASSIGN
            gst_record_version.secondary_key_value = cKeyValue
          .
        END. /* IF cKeyField <> "":U */
        hBuffer:BUFFER-RELEASE().
      END.  /* ELSE IF NOT hBuffer:AVAILABLE */
    END.  /* IF lObj AND NOT gst_record_version.deletion_flag */
  END. /* ELSE IF lDelete */

  IF LAST-OF(gst_record_version.entity_mnemonic) AND
     VALID-HANDLE(hBuffer) THEN
    DELETE OBJECT hBuffer.
END.

