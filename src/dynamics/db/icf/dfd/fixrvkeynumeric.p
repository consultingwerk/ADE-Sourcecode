/* fixrvkeynumeric.p
   This fix program goes through the Record Version table and standardizes
   the date format and decimal format of all record version records to 
   be American DMY so that the keys are universally retrievable. This program
   was written to correct the problems described in issue 13705 - 
   "Data versioning with numeric format not set to American can cause 
   duplicate record version information" 
   
   This fix program must be run inside the Dynamics environment and it should
   preferrably be run before ADOs have been loaded. After the fix program
   has been run, it is necessary to dump the ADOs of all objects in the 
   framework to synchronize the ADOs with the data in the repository.
   */

{src/adm2/globals.i}


DEFINE TEMP-TABLE ttRV NO-UNDO
  LIKE gst_record_version
  FIELD cNewKeyValue       AS CHARACTER
  FIELD cNewSecondaryValue AS CHARACTER
  FIELD lDelete            AS LOGICAL
  FIELD lDup               AS LOGICAL
  .

DEFINE VARIABLE hBuffer                         AS HANDLE       NO-UNDO.
DEFINE VARIABLE cTable                          AS CHARACTER    NO-UNDO.
DEFINE VARIABLE lProblem                        AS LOGICAL      NO-UNDO.
DEFINE VARIABLE cKeyField                       AS CHARACTER    NO-UNDO.
DEFINE VARIABLE cSecondary                      AS CHARACTER    NO-UNDO.
DEFINE VARIABLE cUserLogin                      AS CHARACTER    NO-UNDO.
DEFINE VARIABLE dSiteNo                         AS DECIMAL      NO-UNDO.
DEFINE VARIABLE dLastVer                        AS DECIMAL      NO-UNDO.
DEFINE VARIABLE dImpVer                         AS DECIMAL      NO-UNDO.
DEFINE VARIABLE dVerNo                          AS DECIMAL      NO-UNDO.
DEFINE VARIABLE dMaxVer                         AS DECIMAL      NO-UNDO.
DEFINE VARIABLE dLastSeq                        AS DECIMAL      NO-UNDO.
DEFINE VARIABLE dRVLastVer                      AS DECIMAL      NO-UNDO.
DEFINE VARIABLE dRVImpVer                       AS DECIMAL      NO-UNDO.
DEFINE VARIABLE dRVVerNo                        AS DECIMAL      NO-UNDO.
DEFINE VARIABLE dRVMaxVer                       AS DECIMAL      NO-UNDO.
DEFINE VARIABLE dRVLastSeq                      AS DECIMAL      NO-UNDO.


/* isProblem */
FUNCTION isProblem RETURNS LOGICAL
  (INPUT pcFields AS CHARACTER,
   INPUT phBuffer AS HANDLE):
/* isProblem finds the first field in a table that is either 
   DATE or DECIMAL and returns TRUE indicating that this is a 
   primary table that needs to be fixed. */
  DEFINE VARIABLE iCount AS INTEGER    NO-UNDO.
  DEFINE VARIABLE hField AS HANDLE     NO-UNDO.

  DO iCount = 1 TO NUM-ENTRIES(pcFields):
    hField = phBuffer:BUFFER-FIELD(ENTRY(iCount, pcFields)).
    IF hField:DATA-TYPE = "DECIMAL":U OR
       hField:DATA-TYPE = "DATE":U THEN
      RETURN TRUE.
  END.
  RETURN FALSE.
END FUNCTION. /* FUNCTION isProblem */

/* checkFieldForInvalidDelimiter */
FUNCTION checkFieldForInvalidDelimiter RETURNS CHARACTER
  (INPUT pcOldValue AS CHARACTER,
   INPUT pcDataType AS CHARACTER,
   OUTPUT pcNewValue AS CHARACTER):
  /* Scans the old field value and if it is a DATE or DECIMAL,
     it looks for a delimiter other than . for decimal 
     or / for date and replaces it. If more than one different
     delimiter is found, the unknown value is returned. 
     The new value is returned in pcNewValue and the
     delimiters are returned in the return value.*/

  DEFINE VARIABLE cChar       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDelim      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE dDate       AS DATE       NO-UNDO.
  DEFINE VARIABLE cDate       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE dDec        AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE iCount      AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cCurrDF     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cCurrNumSep AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cCurrNumDec AS CHARACTER  NO-UNDO.

  IF pcDataType <> "DATE":U AND 
     pcDataType <> "DECIMAL":U THEN
    RETURN "":U.
  
  DO iCount = 1 TO LENGTH(pcOldValue):
    cChar = SUBSTRING(pcOldValue,iCount,1).
    IF ASC(cChar) < 48 OR
       ASC(cChar) > 57 THEN
    DO:
      IF NOT ((pcDataType = "DECIMAL":U AND
               (cChar = "-":U OR cChar = ".":U)) OR
              (pcDataType = "DATE":U AND
               cChar = "/":U)) THEN
        cDelim = cDelim + cChar.
    END.
  END.
  IF LENGTH(cDelim) > 1 THEN
    RETURN "DELIM":U.
  
  IF cDelim <> "":U THEN
  CASE pcDataType:
    WHEN "DECIMAL":U THEN
    DO:
      cCurrNumSep = SESSION:NUMERIC-SEPARATOR.
      cCurrNumDec = SESSION:NUMERIC-DECIMAL-POINT.
      SESSION:SET-NUMERIC-FORMAT(",":U,".":U).
      dDec       = DECIMAL(REPLACE(pcOldValue, cDelim, ".":U)) NO-ERROR.
      pcNewValue = STRING(dDec).
      SESSION:SET-NUMERIC-FORMAT(cCurrNumSep,cCurrNumDec).
    END.
    WHEN "DATE":U    THEN
    DO:
      cDate = REPLACE(pcOldValue, cDelim, "/":U).
      cCurrDF = SESSION:DATE-FORMAT.
      SESSION:DATE-FORMAT = "mdy":U.
      
      ERROR-STATUS:ERROR = NO.
      dDate = DATE(cDate) NO-ERROR.
      
      IF ERROR-STATUS:ERROR THEN
      DO:
        ERROR-STATUS:ERROR = NO.
        SESSION:DATE-FORMAT = "dmy":U.
        dDate = DATE(cDate) NO-ERROR.
      END.

      SESSION:DATE-FORMAT = "ymd":U.
      IF ERROR-STATUS:ERROR THEN
      DO:
        ERROR-STATUS:ERROR = NO.
        dDate = DATE(cDate) NO-ERROR.
      END.

      SESSION:DATE-FORMAT = "mdy":U.
      pcNewValue = STRING(dDate, "99/99/9999":U).
      SESSION:DATE-FORMAT = cCurrDF.
    END.

  END CASE.

  RETURN cDelim.
END FUNCTION /* FUNCTION checkFieldForInvalidDelimiter */.

/* replaceKeyValue */
FUNCTION replaceKeyValue RETURNS CHARACTER
  (INPUT pcFieldList AS CHARACTER,
   INPUT pcKeyValue  AS CHARACTER,
   INPUT phBuffer    AS HANDLE):

  /* Takes a field list and key value and verifies that the
     values are correct */
  DEFINE VARIABLE iCount  AS INTEGER    NO-UNDO.
  DEFINE VARIABLE hField  AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cNewVal AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDelim  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cRetVal AS CHARACTER  NO-UNDO.

  IF NUM-ENTRIES(pcFieldList) <> NUM-ENTRIES(pcKeyValue, CHR(1)) THEN
    RETURN ?.
  
  DO iCount = 1 TO NUM-ENTRIES(pcFieldList):
    hField = phBuffer:BUFFER-FIELD(ENTRY(iCount,pcFieldList)).
    cDelim = checkFieldForInvalidDelimiter(ENTRY(iCount,pcKeyValue,CHR(1)), hField:DATA-TYPE, OUTPUT cNewVal).
    IF cDelim = "DELIM" THEN
      RETURN ?.
    IF cDelim <> "":U THEN
      cRetVal = cRetVal + (IF cRetVal <> "":U THEN CHR(1) ELSE "":U)
              + cNewVal.
    ELSE
      cRetVal = cRetVal + (IF cRetVal <> "":U THEN CHR(1) ELSE "":U)
              + ENTRY(iCount,pcKeyValue,CHR(1)).
  END.

  IF cRetVal <> pcKeyValue THEN
    RETURN cRetVal.
  ELSE 
    RETURN "":U.

END FUNCTION. /* FUNCTION replaceKeyValue */


/*------------------MAIN BLOCK-------------------------*/

/* Loop through all the records in the entity-mnemonic table that have gst_record_version
   records. */
FOR EACH gsc_entity_mnemonic NO-LOCK
  WHERE CAN-FIND(FIRST gst_record_version 
                 WHERE gst_record_version.entity_mnemonic = gsc_entity_mnemonic.entity_mnemonic):

  /* Create the buffer for this table */
  cTable = (IF gsc_entity_mnemonic.entity_db <> "":U THEN gsc_entity_mnemonic.entity_db + ".":U ELSE "":U)
         + gsc_entity_mnemonic.entity_mnemonic_description.

  lProblem = NO.

  CREATE BUFFER hBuffer FOR TABLE cTable.

  lProblem = isProblem(gsc_entity_mnemonic.entity_object_field, hBuffer).
  IF NOT lProblem THEN
    lProblem = isProblem(gsc_entity_mnemonic.entity_key_field, hBuffer).

  IF lProblem THEN
  DO:
    FOR EACH gst_record_version  NO-LOCK
      WHERE gst_record_version.entity_mnemonic = gsc_entity_mnemonic.entity_mnemonic:

      IF gsc_entity_mnemonic.table_has_obj THEN
      DO:
        cKeyField  = replaceKeyValue(gsc_entity_mnemonic.entity_object_field,
                                     gst_record_version.key_field_value,
                                     hBuffer).
        IF gst_record_version.secondary_key_value <> "":U THEN
          cSecondary = replaceKeyValue(gsc_entity_mnemonic.entity_key_field,
                                       gst_record_version.secondary_key_value,
                                       hBuffer).
        ELSE
          cSecondary = "":U.
      END.
      ELSE
      DO:
        cKeyField  = replaceKeyValue(gsc_entity_mnemonic.entity_key_field,
                                     gst_record_version.key_field_value,
                                     hBuffer).
        cSecondary = "":U.
      END.

      IF cKeyField = ? OR 
         cSecondary = ? THEN
      DO:
        CREATE ttRV.
        BUFFER-COPY gst_record_version 
          TO ttRV
          ASSIGN
            ttRV.lDelete = YES
          .

      END.
      ELSE IF cKeyField <> "":U OR
           cSecondary <> "":U THEN
      DO:
        IF cKeyField = "":U THEN
          cKeyField = gst_record_version.key_field_value.
        IF cSecondary = "":U THEN
          cSecondary = gst_record_version.secondary_key_value.
        CREATE ttRV.
        BUFFER-COPY gst_record_version 
          TO ttRV
          ASSIGN
            ttRV.cNewKeyValue = cKeyField
            ttRV.cNewSecondaryValue = cSecondary
          .
      END.
    END.
  END.

  DELETE OBJECT hBuffer.

END.

/* Get the current user's login - we'll need this later and it's cheaper
  to do it once here than on every iteration of record that we need to update */
cUserLogin = DYNAMIC-FUNCTION("getPropertyList":U IN gshSessionManager,
                              INPUT "currentUserLogin":U,
                              INPUT NO).

FOR EACH ttRV TRANSACTION:

  IF ttRV.lDelete THEN
  DO:
    FIND FIRST gst_record_version EXCLUSIVE-LOCK
      WHERE gst_record_version.record_version_obj = ttRV.record_version_obj
      NO-ERROR.
    IF AVAILABLE(gst_record_version) THEN
    DO:
      FOR EACH gst_release_version EXCLUSIVE-LOCK
        WHERE gst_release_version.record_version_obj = gst_record_version.record_version_obj:
        DELETE gst_release_version.
      END.
      DELETE gst_record_version.
    END.
    NEXT.
  END.

  FIND FIRST gst_record_version EXCLUSIVE-LOCK
    WHERE gst_record_version.entity_mnemonic = ttRV.entity_mnemonic
      AND gst_record_version.key_field_value = ttRV.cNewKeyValue
    NO-ERROR.

  IF NOT AVAILABLE(gst_record_version) THEN
  DO:
    FIND FIRST gst_record_version EXCLUSIVE-LOCK
      WHERE gst_record_version.record_version_obj = ttRV.record_version_obj
      NO-ERROR.
    IF AVAILABLE(gst_record_version) THEN
      ASSIGN
        gst_record_version.key_field_value = ttRV.cNewKeyValue
        gst_record_version.secondary_key_value = ttRV.cNewSecondaryValue
      .
  END.
  ELSE
  DO:
    ASSIGN
      dLastSeq   = gst_record_version.last_version_number_seq
      dRVLastSeq = ttRV.last_version_number_seq
    .
    /* Get the last seq. */
    RUN calcLastVersionNo IN gshRIManager
      (INPUT gst_record_version.version_number_seq,
       INPUT gst_record_version.import_version_number_seq,
       INPUT-OUTPUT dLastSeq).

    /* Get the last seq. */
    RUN calcLastVersionNo IN gshRIManager
      (INPUT ttRV.version_number_seq,
       INPUT ttRV.import_version_number_seq,
       INPUT-OUTPUT dRVLastSeq).

    dLastSeq = MAXIMUM(dLastSeq,dRVLastSeq).

    ASSIGN
      gst_record_version.last_version_number_seq = dLastSeq + 1
      gst_record_version.last_version_number_seq = gst_record_version.last_version_number_seq + 1
      gst_record_version.version_number_seq      = gst_record_version.last_version_number_seq
      gst_record_version.key_field_value         = ttRV.cNewKeyValue
      gst_record_version.secondary_key_value     = ttRV.cNewSecondaryValue
    .

    FIND FIRST gst_record_version EXCLUSIVE-LOCK
      WHERE gst_record_version.record_version_obj = ttRV.record_version_obj
      NO-ERROR.
    IF AVAILABLE(gst_record_version) THEN
    DO:
      FOR EACH gst_release_version EXCLUSIVE-LOCK
        WHERE gst_release_version.record_version_obj = gst_record_version.record_version_obj:
        DELETE gst_release_version.
      END.
      DELETE gst_record_version.
    END.
  END.
END.



  
