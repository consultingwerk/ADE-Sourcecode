/*------------------------------------------------------------------------------
  Purpose:     Writes (recursively) all the data in the temp-table for a dataset
               into the corresponding database tables.
  Parameters:  <none>
  Notes:       This code makes use of several named do blocks. I hate this type 
               of programming, but it needs to happen here. We're using dynamic
               objects and if we need to return the error, we need to make
               sure the objects get properly cleaned up otherwise we'll have
               a memory leak. So if the code leaves a block, the intention is
               that nothing further in that block gets executed.
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER piRequestNo    AS INTEGER    NO-UNDO.
  DEFINE INPUT  PARAMETER phTTBuff       AS HANDLE     NO-UNDO.
  DEFINE INPUT  PARAMETER plOverwrite    AS LOGICAL    NO-UNDO.
  DEFINE PARAMETER BUFFER pbttTable      FOR ttTable.

  DEFINE VARIABLE hQuery          AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hTableBuff      AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hChildBuff      AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cForEach        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cErrMess        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cMessage        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hAttValue       AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hAttDT          AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cKeyField       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cKey            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cObjField       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cObj            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iCount          AS INTEGER    NO-UNDO.
  DEFINE VARIABLE lHasObj         AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lAns            AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lVersion        AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE hRVObj          AS HANDLE     NO-UNDO.
  DEFINE VARIABLE lAccept         AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lOverwrite      AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lError          AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cErrorList      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iRule           AS INTEGER    NO-UNDO.
  DEFINE VARIABLE lSetModified   AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE iFactor         AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cCurrTimeSource AS CHARACTER  NO-UNDO.

  DEFINE BUFFER bttTable            FOR ttTable.
  DEFINE BUFFER bttTableList        FOR ttTableList.
  DEFINE BUFFER bttEntityList       FOR ttEntityList.
  DEFINE BUFFER bttImportVersion    FOR ttImportVersion.
  DEFINE BUFFER bgst_record_version FOR gst_record_version.
  DEFINE BUFFER bttTableProps       FOR ttTableProps.

  /* Check the table override properties */
  FIND FIRST bttTableProps NO-LOCK
    WHERE bttTableProps.cEntityMnemonic = pbttTable.cEntityMnemonic
    NO-ERROR.
  IF AVAILABLE(bttTableProps) THEN
    lOverwrite     = bttTableProps.lOverwrite.
  ELSE
    lOverwrite     = plOverwrite.
  ERROR-STATUS:ERROR = NO.

  /* Get the version record for the temp-table record if there is one */
  hRVObj = phTTBuff:BUFFER-FIELD("oRVObj":U).
  IF hRVObj:BUFFER-VALUE > 0.0 THEN
  DO:
    FIND FIRST bttImportVersion
      WHERE bttImportVersion.record_version_obj = hRVObj:BUFFER-VALUE
      NO-ERROR.
    ERROR-STATUS:ERROR = NO.
  END.

  /* Build a for each statement for this buffer */
  RUN obtainPoolObject /* IN ghObjectPool */
    ("BUFFER":U, 
     pbttTable.cDatabase + ".":U + pbttTable.cTableName, 
     OUTPUT hTableBuff).
      
  /* Disable all the schema triggers on all the tables */
  hTableBuff:DISABLE-LOAD-TRIGGERS(NO).
  hTableBuff:DISABLE-DUMP-TRIGGERS().
  DISABLE TRIGGERS FOR LOAD OF bgst_record_version.
  DISABLE TRIGGERS FOR DUMP OF bgst_record_version.

  iRule   = ?.
  lAccept = ?. /* We set this to ? because we need to know if it falls through
                  all the rules below */

  rule-block:
  DO:
    /* Obtain the key field and obj field values for this record */
    lAns = getEntityData("TT":U,
                         pbttTable.cEntityMnemonic,
                         phTTBuff,
                         CHR(1),
                         OUTPUT cKeyField,
                         OUTPUT cKey,
                         OUTPUT cObjField,
                         OUTPUT cObj,
                         OUTPUT lHasObj,
                         OUTPUT lVersion).
  
    IF NOT lAns THEN
    DO:
      lAccept = NO.
      cErrorList = cErrorList + (IF cErrorList = "":U THEN "":U ELSE CHR(3))
                 + "100|EM=":U + pbttTable.cEntityMnemonic.
      lError = YES.
      LEAVE rule-block.
    END.
  
    /* Try and find the record using the object key if it has one. */
    IF lHasObj THEN
    DO:
      obtainTableRec(CHR(1), 
                     cObjField, 
                     cObj, 
                     hTableBuff,
                     "EXCLUSIVE-LOCK":U).
  
      /* If we find a database record, we need to check if the record has 
         changed. */
      IF hTableBuff:AVAILABLE AND
         cKeyField <> "":U AND
         NOT compareKeys(cKeyField, phTTBuff, hTableBuff) THEN
      DO:
        iRule = 0.
        IF NOT lOverwrite THEN
        DO:
          lAccept = NO.
          cErrorList = cErrorList + (IF cErrorList = "":U THEN "":U ELSE CHR(3))
                     + "000|EM=":U + pbttTable.cEntityMnemonic
                     + "|Obj=":U + cObj
                     + "|Key=":U + cKey.
          lError = YES.
          LEAVE rule-block.

        END.
        ELSE 
          lAccept = YES.
      END.
    END.
  
    /* If we don't have a record available at this point, try and 
       find it on the key value */
    IF NOT hTableBuff:AVAILABLE THEN
    DO:
       IF cKeyField <> "":U AND
          cKeyField <> ? THEN
         obtainTableRec(CHR(1), 
                        cKeyField, 
                        cKey, 
                        hTableBuff,
                        "EXCLUSIVE-LOCK":U).
    END.
  
    /* If the record is available, we need to determine if the data that 
       we are getting in clashes with the data in the target database.
       The rule numbers mentioned in comments in the following code 
       map to rules in the specs. */
    IF hTableBuff:AVAILABLE THEN
    DO:
      /* Get the version record for the database record if there is one */
      obtainDataVersionRec(pbttTable.cEntityMnemonic,
                           hTableBuff,
                           (IF lHasObj THEN cObj ELSE cKey),
                           INPUT BUFFER bgst_record_version:HANDLE,
                           "EXCLUSIVE-LOCK":U).
  
      /* RULE #1. If there is no record version record in either place, we 
         accept the record as we have no way of verifying it. If it does not 
         clash on unique indexes, there is no way to make sure it is not valid. */
      IF NOT AVAILABLE(bttImportVersion) AND
         NOT AVAILABLE(bgst_record_version) THEN
      DO:
        iRule = 1.
        lAccept = YES.
        LEAVE rule-block.
      END.

      /* RULE #2 is the ELSE condition on the IF hTableBuff:AVAILABLE block */

      /* RULE #3. If there is no record version in the target repository, 
         but the data exists in the target repository, reject it unless
         the overwrite flag is on */
      IF AVAILABLE(bttImportVersion) AND
         NOT AVAILABLE(bgst_record_version) THEN
      DO:
        iRule = 3.
        IF NOT lOverwrite THEN
        DO:
          lAccept = NO.
          cErrorList = cErrorList + (IF cErrorList = "":U THEN "":U ELSE CHR(3))
                     + "003|EM=":U + pbttTable.cEntityMnemonic
                     + "|Obj=":U + cObj
                     + "|Key=":U + cKey.
          lError = YES.
        END.
        ELSE 
          lAccept = YES.
        LEAVE rule-block.
      END.

      /* RULE #4. If there is no record version in the Import stuff, but there
         is a record version in the target repository, we're about to overwrite
         old data with new data that has just come in from the dataset. Only
         do this if lOverwrite is on */
      IF NOT AVAILABLE(bttImportVersion) AND
         AVAILABLE(bgst_record_version) THEN
      DO:
        iRule = 4.
        IF NOT lOverwrite THEN
        DO:
          lAccept = NO.
          cErrorList = cErrorList + (IF cErrorList = "":U THEN "":U ELSE CHR(3))
                     + "004|EM=":U + pbttTable.cEntityMnemonic
                     + "|Obj=":U + cObj
                     + "|Key=":U + cKey.
          lError = YES.
        END.
        ELSE
          lAccept = YES.
        LEAVE rule-block.
      END.

      /* Now we deal with the case where both record version records are
         available */
      IF AVAILABLE(bttImportVersion) AND
         AVAILABLE(bgst_record_version) THEN
      DO:
        /* RULE #5: If they both have the same version_number_seq, accept the
           incoming record */
        IF bttImportVersion.version_number_seq = ABS(bgst_record_version.version_number_seq) THEN
        DO:
          lAccept = YES.
          iRule   = 5.
          LEAVE rule-block.
        END.

        /* RULE #6: If the import_version_number_seq matches and the existing
           version_number_seq is the same as the incoming import_version, we are
           simply updating existing data */
        IF bttImportVersion.import_version_number_seq = bgst_record_version.import_version_number_seq AND
           bttImportVersion.import_version_number_seq = ABS(bgst_record_version.version_number_seq) THEN
        DO:
          lAccept = YES.
          iRule   = 6.
          LEAVE rule-block.
        END.

        /* All the other rules result in rejection unless overwrite. We're
           providing the checks to be able to show the users why the record
           was rejected. */
        /* RULE #7: If the import's version matches the target import_version,
           but the version_numbers don't, the data has been updated since it was sent
           out from this repository. */
        IF bttImportVersion.version_number_seq = bgst_record_version.import_version_number_seq AND
           bttImportVersion.version_number_seq <> ABS(bgst_record_version.version_number_seq) THEN
        DO:
          iRule   = 7.
          IF NOT lOverwrite THEN
          DO:
            lAccept = NO.
            cErrorList = cErrorList + (IF cErrorList = "":U THEN "":U ELSE CHR(3))
                       + "007|EM=":U + pbttTable.cEntityMnemonic
                       + "|Obj=":U + cObj
                       + "|Key=":U + cKey.
            lError = YES.
          END.
          ELSE
            lAccept = YES.
          LEAVE rule-block.
        END.

        /* RULE #8: If the import's import_version matches the target import_version,
           but the version_numbers don't, the data has been updated since it was 
           imported into this repository. */
        IF bttImportVersion.import_version_number_seq = bgst_record_version.import_version_number_seq AND
           bttImportVersion.version_number_seq <> ABS(bgst_record_version.version_number_seq) THEN
        DO:
          iRule   = 8.
          IF NOT lOverwrite THEN
          DO:
            lAccept = NO.
            cErrorList = cErrorList + (IF cErrorList = "":U THEN "":U ELSE CHR(3))
                       + "008|EM=":U + pbttTable.cEntityMnemonic
                       + "|Obj=":U + cObj
                       + "|Key=":U + cKey.
            lError = YES.
          END.
          ELSE
            lAccept = YES.
          LEAVE rule-block.
        END.
      END.
    END. /* IF hTableBuff:AVAILABLE */
    ELSE
    DO:
      /* RULE #2. There's no data in the target repository. This is therefore
         new data. We accept the record */
      iRule = 2.
      lAccept = YES.
    END. /* ELSE of IF hTableBuff:AVAILABLE */

    /* This is a catch all. We should never get to this point. Anthony and I could
       not figure a case where you would. But if we hit we reject unless we're
       overwriting */
    IF lAccept = ? THEN
    DO:
      iRule   = 9.
      IF NOT lOverwrite THEN
      DO:
        lAccept = NO.
        cErrorList = cErrorList + (IF cErrorList = "":U THEN "":U ELSE CHR(3))
                   + "009|EM=":U + pbttTable.cEntityMnemonic
                   + "|Obj=":U + cObj
                   + "|Key=":U + cKey.
        lError = YES.
      END.
      ELSE
        lAccept = YES.
      LEAVE rule-block.
    END.
  END. /* END rule-block */


  IF lAccept THEN
  assign-block:
  DO ON ERROR UNDO, LEAVE:
    /* If we didn't find a record for table, create one. */
    IF NOT hTableBuff:AVAILABLE THEN
    DO:
      hTableBuff:BUFFER-CREATE().
      /* IZ 4064 
      setFieldLiteral(hTableBuff, YES). /* Make sure we handle ? properly */
      */
      hTableBuff:BUFFER-COPY(phTTBuff) NO-ERROR.
      /* IZ 4064
      setFieldLiteral(hTableBuff, NO).
      */

    END.
    ELSE IF lOverwrite THEN
    DO:
      /* IZ 4064
      setFieldLiteral(hTableBuff, YES). /* Make sure we handle ? properly */
      */
      hTableBuff:BUFFER-COPY(phTTBuff) NO-ERROR.
      /* IZ 4064
      setFieldLiteral(hTableBuff, NO).
      */
    END.
    
  
    /* If there's an error writing the database record, build up the
       error string and return it */
    IF ERROR-STATUS:ERROR OR 
       ERROR-STATUS:NUM-MESSAGES > 0 THEN
    DO:
      cErrMess = buildErrList().
      cErrorList = cErrorList + (IF cErrorList = "":U THEN "":U ELSE CHR(3))
                 + "101|EM=":U + pbttTable.cEntityMnemonic 
                 + "|Obj=":U + cObj 
                 + "|Key=":U + cKey
                 + "|":U + (IF cErrMess = ? THEN "UNKOWN":U ELSE cErrMess).
      lError = YES.
      LEAVE assign-block.
    END.

    /* We succeeded in writing the data to the database. Now lets update
       the gst_record_version information. */

    /* If neither record is available, we're done. */
    IF NOT AVAILABLE(bttImportVersion) AND
       NOT AVAILABLE(bgst_record_version) THEN
      LEAVE assign-block.
    
    IF hTableBuff:NEW AND
       AVAILABLE(bttImportVersion) THEN
    DO:
      /* If we created a new record, we need to retry getting the version record because
         this may be a deletion that has been re-created in the source database and we have
         will not have found the record version record up until now because we did not
         have the key information to do so. */
      obtainDataVersionRec(pbttTable.cEntityMnemonic,
                           hTableBuff,
                           (IF lHasObj THEN cObj ELSE cKey),
                           INPUT BUFFER bgst_record_version:HANDLE,
                           "EXCLUSIVE-LOCK":U).
      RUN clearRetVal.
    END.
   
    /* If there is no bttImportVersion, but there is a gst_record_version,
       the user has chosen to overwrite the data completely. We need to 
       whack the gst_record_version record. */
    IF NOT AVAILABLE(bttImportVersion) AND
       AVAILABLE(bgst_record_version) THEN
    DO:
      DELETE bgst_record_version.
      LEAVE assign-block.
    END.

    /* If bttImportVersion is available, and there is no
       gst_record_version, we need to create the gst_record_version. */
    IF AVAILABLE(bttImportVersion) AND
       NOT AVAILABLE(bgst_record_version) THEN
    DO:
      /* Make sure that there is no existing record on the database */
      FIND bgst_record_version EXCLUSIVE-LOCK
        WHERE bgst_record_version.record_version_obj = bttImportVersion.record_version_obj
        NO-ERROR.
      IF NOT AVAILABLE(bgst_record_version) THEN
      DO:
        CREATE bgst_record_version.
        ASSIGN
          bgst_record_version.record_version_obj      = bttImportVersion.record_version_obj
          bgst_record_version.last_version_number_seq = DECIMAL(giSiteRev / giSiteDiv)
          .
      END.
    END.

    /* Does the user want to keep track of imported data changes? */
    lSetModified = getAttribute(piRequestNo,
                                 "SetModified":U) = "YES":U.
    IF lSetModified = YES THEN
      iFactor = -1.
    ELSE
      iFactor = 1.
    
    /* Now apply the changes to the version record */
    ASSIGN
      bgst_record_version.entity_mnemonic           = bttImportVersion.entity_mnemonic
      bgst_record_version.key_field_value           = bttImportVersion.key_field_value
      bgst_record_version.secondary_key_value	    = bttImportVersion.secondary_key_value

      /* Imported version_number_seq becomes the import_version_number_seq */
      bgst_record_version.import_version_number_seq = ABS(bttImportVersion.version_number_seq)

      /* Version_number_seq are set the same, unless the user is tracking changes, in 
         which case we multiply it by -1 */
      bgst_record_version.version_number_seq        = ABS(bttImportVersion.version_number_seq)
                                                    * iFactor

      /* Get the date and time from the database */
      bgst_record_version.version_date              = TODAY
      bgst_record_version.version_time              = TIME
      bgst_record_version.version_user              = bttImportVersion.version_user
      NO-ERROR.

    IF ERROR-STATUS:ERROR OR 
       ERROR-STATUS:NUM-MESSAGES > 0 THEN
    DO:
      cErrMess = buildErrList().
      cErrorList = cErrorList + (IF cErrorList = "":U THEN "":U ELSE CHR(3))
                 + "102|EM=":U + pbttTable.cEntityMnemonic 
                 + "|Obj=":U + cObj 
                 + "|Key=":U + cKey
                 + "|":U + (IF cErrMess = ? THEN "UNKOWN":U ELSE cErrMess).
      lError = YES.
      LEAVE assign-block.
    END.
  END. /* IF lAccept -- assign-block */

  IF NOT lError THEN
  DO:
      /* Now we need to copy all the child data into its tables.
       Iterate through all the dependent tables in the dataset and
       remove the data in them from the list */
    FOR EACH bttTable NO-LOCK
      WHERE bttTable.cJoinMnemonic = pbttTable.cEntityMnemonic:
  
      /* Find the entity that is related to this table */
      FIND FIRST bttEntityList NO-LOCK
        WHERE bttEntityList.cEntityMnemonic = bttTable.cEntityMnemonic.
  
      /* Now find the temp-table that contains the data for this table */
      FIND FIRST bttTableList NO-LOCK
        WHERE bttTableList.iRequestNo = piRequestNo
          AND bttTableList.iTableNo   = bttEntityList.iTableNo.
  
      /* Get the handle to the buffer for the temp-table */
      RUN obtainPoolObject /* IN ghObjectPool */
        ("BUFFER":U, 
         STRING(bttTableList.hTable:DEFAULT-BUFFER-HANDLE), 
         OUTPUT hChildBuff).
  
      /* Build a for each statement for this buffer */
      IF VALID-HANDLE(hChildBuff) THEN
        cForEach = buildForEach(hChildBuff, 
                                bttTable.cJoinFieldList, 
                                phTTBuff, 
                                "":U, 
                                "":U,
                                YES).
  
      /* Open a query on the temp-table */
      RUN obtainPoolObject /* IN ghObjectPool */
        ("QUERY":U, 
         "":U, 
         OUTPUT hQuery).
      hQuery:SET-BUFFERS(hChildBuff).
      hQuery:QUERY-PREPARE(cForEach).
      hQuery:QUERY-OPEN().
      hQuery:GET-FIRST().
  
      /* Loop through the query and write the data in. */
      REPEAT WHILE NOT hQuery:QUERY-OFF-END:
  
        /* Write the temp-table contents to the database */
        RUN writeDatasetToDB (piRequestNo,
                              hChildBuff,
                              plOverwrite,
                              BUFFER bttTable) NO-ERROR.
  
        IF ERROR-STATUS:ERROR THEN
          UNDO, LEAVE.
  
        hQuery:GET-NEXT().
  
      END.
      /* Close the query and delete the query object */
      hQuery:QUERY-CLOSE().
      RUN releasePoolObject /* IN ghObjectPool */
        (hQuery).
      hQuery = ?.
      RUN releasePoolObject /* IN ghObjectPool */
        (hChildBuff).
      hChildBuff = ?.
      
      IF ERROR-STATUS:ERROR THEN
        UNDO, LEAVE.
    END.
  END. /* IF NOT lError */
  
  phTTBuff:BUFFER-DELETE().
  phTTBuff:BUFFER-RELEASE().
  hTableBuff:BUFFER-RELEASE().
  RUN releasePoolObject /* IN ghObjectPool */
    (hTableBuff).
  hTableBuff = ?.
  IF lError OR 
     ERROR-STATUS:ERROR THEN
  DO:
    IF cErrorList = "":U THEN
      UNDO, RETURN ERROR RETURN-VALUE.
    ELSE
      UNDO, RETURN ERROR cErrorList.
  END.
  
  RETURN "".




