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
DEFINE VARIABLE dSiteNo   AS DECIMAL  DECIMALS 9  NO-UNDO.
DEFINE VARIABLE iSeqSiteDiv                     AS INTEGER    NO-UNDO.
DEFINE VARIABLE iSeqSiteRev                     AS INTEGER    NO-UNDO.
DEFINE VARIABLE dLastVer   AS DECIMAL    NO-UNDO.
DEFINE VARIABLE dImpVer    AS DECIMAL    NO-UNDO.
DEFINE VARIABLE dVerNo     AS DECIMAL    NO-UNDO.
DEFINE VARIABLE dMaxVer    AS DECIMAL    NO-UNDO.
DEFINE VARIABLE dLastSeq   AS DECIMAL    NO-UNDO.

DISABLE TRIGGERS FOR LOAD OF gst_record_version.


ASSIGN
  iSeqSiteDiv = CURRENT-VALUE(seq_site_division,ICFDB)
  iSeqSiteRev = CURRENT-VALUE(seq_site_reverse,ICFDB)
  dSiteNo = DECIMAL(iSeqSiteRev / iSeqSiteDiv)
.
   
FOR EACH gst_record_version
  BREAK BY gst_record_version.entity_mnemonic:

  IF FIRST-OF(gst_record_version.entity_mnemonic) THEN
  DO:
    FIND gsc_entity_mnemonic NO-LOCK
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
      CREATE BUFFER hBuffer FOR TABLE gsc_entity_mnemonic.entity_mnemonic_description.
    END.
  END.


  /* Lets make sure that the last_version_number_seq is for this site and that its value is greater than anything
     in the current version number seq or import_version_number_seq fields.*/
  ASSIGN
    dImpVer = 0
    dLastVer = 0
    dVerNo = 0
    dMaxVer = 0
  .

  /* If the version_number_seq is of this site number, lets store the last away */
  IF (ABS(gst_record_version.version_number_seq) - TRUNCATE(ABS(gst_record_version.version_number_seq),0)) = dSiteNo THEN
    dVerNo = TRUNCATE(ABS(gst_record_version.version_number_seq),0).

  /* If the import_version_number_seq is of this site number, lets store the last away */
  IF (ABS(gst_record_version.import_version_number_seq) - TRUNCATE(ABS(gst_record_version.import_version_number_seq),0)) = dSiteNo THEN
    dImpVer = TRUNCATE(ABS(gst_record_version.import_version_number_seq),0).

  /* Figure out the last version number seq' top value, and what we expect the highest value to be.*/
  ASSIGN
    dLastVer = INTEGER(ABS(gst_record_version.last_version_number_seq))
    dMaxVer  = MAXIMUM(dVerNo,dImpVer,dLastVer)
    dLastSeq = dMaxVer + dSiteNo
  .

  
  IF dLastSeq > gst_record_version.last_version_number_seq THEN
  ASSIGN
    gst_record_version.last_version_number_seq = dLastSeq + 1
  .

  /* Now we need to make sure that there are no import_version_number_seq
     with a value less than zero. */
  IF gst_record_version.import_version_number_seq < 0 THEN
  DO:
    IF gst_record_version.import_version_number_seq = gst_record_version.version_number_seq THEN
      ASSIGN
        gst_record_version.import_version_number_seq = ABS(gst_record_version.import_version_number_seq)
        gst_record_version.version_number_seq        = ABS(gst_record_version.version_number_seq)
      .
    ELSE
      ASSIGN
        gst_record_version.import_version_number_seq = ABS(gst_record_version.import_version_number_seq)
      .
  END.
  
  IF NOT gst_record_version.deletion_flag THEN
  DO:
    IF lDelete THEN
        DELETE gst_record_version.
    ELSE
    DO:
      /* If the table has an object field then find the parent record based on
         the object field. */
      IF lObj AND
         NOT gst_record_version.deletion_flag THEN
      DO:
        cWhere = "WHERE ":U + hBuffer:NAME + ".":U + cObjField + " = ":U 
               + QUOTER(gst_record_version.key_field_value).
        hBuffer:FIND-UNIQUE(cWhere, NO-LOCK) NO-ERROR.
  
        /* If we don't have a record here, we cannot find our way back to the 
           parent so we might as well whack the gst_record_version */
        IF NOT hBuffer:AVAILABLE THEN
          DELETE gst_record_version.
        ELSE
        DO:
          /* Now we need to build up the secondary key */
          cKeyValue = "":U.
          IF cKeyField <> "":U THEN
          DO:
            IF NUM-ENTRIES(cKeyField) >= 2 THEN
            DO iCount = 1 TO NUM-ENTRIES(cKeyField):
              ASSIGN
                hField  = hBuffer:BUFFER-FIELD(ENTRY(iCount,cKeyField)) NO-ERROR.
              IF VALID-HANDLE(hBuffer) AND VALID-HANDLE(hField) AND hBuffer:AVAILABLE THEN
                ASSIGN
                  cKeyValue = cKeyValue + CHR(1) WHEN cKeyValue <> "":U
                  cKeyValue = cKeyValue + STRING(hField:BUFFER-VALUE).
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
            IF cKeyValue <> gst_record_version.secondary_key_value THEN
              ASSIGN
                gst_record_version.secondary_key_value = cKeyValue
                gst_record_version.last_version_number_seq = gst_record_version.last_version_number_seq + 1
                gst_record_version.version_number_seq = gst_record_version.last_version_number_seq
              .
          END. /* IF cKeyField <> "":U */
          hBuffer:BUFFER-RELEASE().
        END.  /* ELSE IF NOT hBuffer:AVAILABLE */
      END.  /* IF lObj AND NOT gst_record_version.deletion_flag */
    END. /* ELSE IF lDelete */
  END.

  IF LAST-OF(gst_record_version.entity_mnemonic) AND
     VALID-HANDLE(hBuffer) THEN
    DELETE OBJECT hBuffer.
END.

