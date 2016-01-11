/*------------------------------------------------------------------------------

  Purpose:     To correct the attributes on existing SDOs

  Parameters:  No INPUT or OUTPUT Parameters.
               RETURN-VALUE will contain the error log file name if errors
               or RETURN blank if no errors.

  Notes:       Only Object Type of SDO are updated currently.
               Only Attribute of TABLES are assigned to the smartobject fopr the object type.

------------------------------------------------------------------------------*/

  DEFINE VARIABLE cObjectTypeEntries  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iObjectTypeLoop     AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cObjectTypeLabel    AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE cSDOFileName        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSDOPathName        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSDOFullFileName    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSDORcodeFileName   AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE cAttributeEntries   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iAttributeLoop      AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cAttributeLabel     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cAttributeValue     AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE hSmartDataObject    AS HANDLE     NO-UNDO.

  DEFINE VARIABLE iErrorLoop          AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iErrorCount         AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cErrorFile          AS CHARACTER  NO-UNDO.

  DEFINE STREAM sOutput.

  /* Include the NextObj Fuction */
  FUNCTION getNextObj RETURNS DECIMAL
    ( /* parameter-definitions */ )
    FORWARD.

  /*
  Do not change this list.
  These values are referenced in the program.
  If you alter the list ensure to add the processing to the sections below as well
  */
  ASSIGN
    cObjectTypeEntries = "SDO":U
    cAttributeEntries  = "Tables"
    .

  DISABLE TRIGGERS FOR LOAD OF ryc_attribute_value.

  ASSIGN
    cErrorFile  = SESSION:TEMP-DIRECTORY + "~\fixsdoattr.err":U
    iErrorCount = 0.
  OUTPUT STREAM sOutput TO VALUE(cErrorFile).

  ObjectTypeBlock:
  DO iObjectTypeLoop = 1 TO NUM-ENTRIES(cObjectTypeEntries,",":U):

    ASSIGN
      cObjectTypeLabel = ENTRY(iObjectTypeLoop,cObjectTypeEntries,",":U).

    FIND FIRST gsc_object_type NO-LOCK
      WHERE gsc_object_type.object_type_code = cObjectTypeLabel
      NO-ERROR.
    IF NOT AVAILABLE gsc_object_type
    THEN DO:
      PUT STREAM sOutput UNFORMATTED
        "Object type record not available for : "
        cObjectTypeLabel
        SKIP.
      NEXT ObjectTypeBlock.
    END.

    SmartobjectBlock:
    FOR EACH ryc_smartobject NO-LOCK
      WHERE ryc_smartobject.object_type_obj = gsc_object_type.object_type_obj
      :

      IF ryc_smartobject.static_object
      THEN DO:

        ASSIGN
          cSDOPathName      = RIGHT-TRIM(ryc_smartobject.object_path, "/~\":U)
          cSDOFileName      = ryc_smartobject.object_filename
                            + (IF ryc_smartobject.object_extension <> "":U
                               THEN ".":U + ryc_smartobject.object_extension
                               ELSE "":U )
          cSDOFullFileName  = cSDOPathName
                            + (IF cSDOPathName = "":U
                               THEN "":U
                               ELSE "/":U )
                            + cSDOFileName.

        IF cSDOFullFileName <> "":U
        THEN DO:

          IF SEARCH(cSDOFullFileName) = ?
          THEN DO:
            PUT STREAM sOutput UNFORMATTED
              "Unable to find physical file for SDO : "
              cSDOFullFileName
              SKIP.
            NEXT SmartObjectBlock.
          END.

          IF INDEX(cSDOFullFileName,".w":U) = 0
          THEN DO:
            PUT STREAM sOutput UNFORMATTED
              "Unable to find physical file SDO with extention of .w: "
              cSDOFullFileName
              SKIP.
            NEXT SmartObjectBlock.
          END.

          /* Check if SDO File exist and valid */
          FILE-INFO:FILE-NAME = cSDOFullFileName.
          IF FILE-INFO:FULL-PATHNAME        = ?
          OR FILE-INFO:FILE-SIZE            = 0
          OR INDEX(FILE-INFO:FILE-TYPE,"F") = 0
          THEN DO:
            PUT STREAM sOutput UNFORMATTED
              "Physical file information for SDO is not available or empty : "
              cSDOFullFileName
              " Path: " FILE-INFO:FULL-PATHNAME
              " Size: " FILE-INFO:FILE-SIZE
              " Type: " FILE-INFO:FILE-TYPE
              SKIP.
            NEXT SmartObjectBlock.
          END.
          ELSE
            ASSIGN
              cSDOFullFileName  = FILE-INFO:FULL-PATHNAME
              cSDORcodeFileName = FILE-INFO:FILE-NAME.

          ASSIGN
            cSDORcodeFileName = REPLACE(cSDORcodeFileName,".w":U,".r":U).

          /* Check if SDO R-Code File exist */
          FILE-INFO:FILE-NAME = cSDORcodeFileName.
          IF FILE-INFO:FULL-PATHNAME        = ?
          OR FILE-INFO:FILE-SIZE            = 0
          OR INDEX(FILE-INFO:FILE-TYPE,"F") = 0
          THEN ASSIGN cSDORcodeFileName = "":U.
          ELSE ASSIGN cSDORcodeFileName = RIGHT-TRIM(REPLACE(REPLACE(FILE-INFO:FULL-PATHNAME,".r":U,".w":U),cSDOFileName,"":U),"~\~/":U).

          IF cSDORcodeFileName = "":U
          THEN
            COMPILE VALUE(cSDOFullFileName) SAVE NO-ERROR.
          ELSE
            COMPILE VALUE(cSDOFullFileName) SAVE INTO VALUE(cSDORcodeFileName) NO-ERROR.

          IF COMPILER:ERROR
          THEN DO iErrorLoop = 1 TO ERROR-STATUS:NUM-MESSAGES:
            PUT STREAM sOutput UNFORMATTED
              "Error compiling SDO : "
              cSDOFullFileName
              " Error (" iErrorLoop "): "
              ERROR-STATUS:GET-MESSAGE(iErrorLoop)
              SKIP.
            IF iErrorLoop = ERROR-STATUS:NUM-MESSAGES
            THEN
              NEXT SmartObjectBlock.
          END.

        END. /* cSDOFullFileName <> "":U */

      END.

      IF cSDOFullFileName = ""
      OR cSDOFullFileName = ?
      THEN DO:
        PUT STREAM sOutput UNFORMATTED
          "SDO information not available for ryc_smartobject record : "
          ryc_smartobject.object_filename
          " ("
          ryc_smartobject.smartobject_obj
          ")"
          SKIP.
        NEXT SmartobjectBlock.
      END.

      CASE cObjectTypeLabel:
        WHEN "SDO":U /* Static SDO */
          THEN DO:
            ASSIGN
              hSmartDataObject = ?.
            RUN VALUE(cSDOFullFileName) PERSISTENT SET hSmartDataObject NO-ERROR.
            IF NOT VALID-HANDLE(hSmartDataObject)
            OR ERROR-STATUS:ERROR
            THEN DO:
              PUT STREAM sOutput UNFORMATTED
                "Unable to start the SDO : " cSDOFullFileName
                SKIP.
              NEXT SmartObjectBlock.
            END.
            RUN "initializeobject" IN hSmartDataObject NO-ERROR.
            IF ERROR-STATUS:ERROR
            THEN DO:
              PUT STREAM sOutput UNFORMATTED
                "Initialization failed for SDO : " cSDOFullFileName
                SKIP.
              NEXT SmartObjectBlock.
            END.
          END.
        OTHERWISE
          DO:
            NEXT ObjectTypeBlock.
          END.
      END CASE.

      IF NOT VALID-HANDLE(hSmartDataObject)
      THEN DO:
        PUT STREAM sOutput UNFORMATTED
          "Start of SDO failed : " cSDOFullFileName
          SKIP.
        NEXT SmartObjectBlock.
      END.

      AttributeBlock:
      DO iAttributeLoop = 1 TO NUM-ENTRIES(cAttributeEntries,",":U):

        ASSIGN
          cAttributeLabel = ENTRY(iAttributeLoop,cAttributeEntries,",":U)
          cAttributeValue = "":U
          .

        FIND FIRST ryc_attribute NO-LOCK
          WHERE ryc_attribute.attribute_label = cAttributeLabel
          NO-ERROR.
        IF NOT AVAILABLE ryc_attribute
        THEN NEXT AttributeBlock.

        CASE cAttributeLabel:
          WHEN "Tables":U
            THEN DO:
              {get Tables cAttributeValue hSmartDataObject}.
            END.
          OTHERWISE
            DO:
              NEXT AttributeBlock.
            END.
        END CASE.

        FIND FIRST ryc_attribute_value EXCLUSIVE-LOCK
          WHERE ryc_attribute_value.object_type_obj           = gsc_object_type.object_type_obj
          AND   ryc_attribute_value.smartobject_obj           = ryc_smartobject.smartobject_obj
          AND   ryc_attribute_value.object_instance_obj       = 0
          AND   ryc_attribute_value.attribute_label           = cAttributeLabel
          AND   ryc_attribute_value.container_smartobject_obj = 0
          NO-ERROR.
        IF AVAILABLE ryc_attribute_value
        THEN DO:
          ASSIGN
            ryc_attribute_value.character_value = cAttributeValue
            .
        END.
        ELSE DO:
          CREATE ryc_attribute_value.
          ASSIGN
            ryc_attribute_value.attribute_value_obj       = getNextObj()
            ryc_attribute_value.object_type_obj           = gsc_object_type.object_type_obj
            ryc_attribute_value.smartobject_obj           = ryc_smartobject.smartobject_obj
            ryc_attribute_value.object_instance_obj       = 0
            ryc_attribute_value.attribute_label           = cAttributeLabel
            ryc_attribute_value.character_value           = cAttributeValue
            ryc_attribute_value.container_smartobject_obj = 0
            .
        END.

      END.    /* iAttributeLoop */

      IF VALID-HANDLE(hSmartDataObject)
      THEN DO:
        RUN destroyObject IN hSmartDataObject.
        /* DELETE OBJECT hSmartDataObject. */
      END.
      hSmartDataObject = ?.

    END.    /* Smart Object */

  END. /* iObjectTypeLoop */

  OUTPUT STREAM sOutput CLOSE.

  IF iErrorCount > 0
  THEN
    RETURN "ERROR: All error written to the log file. ( " + cErrorFile + " ) ".
  ELSE
    RETURN "":U.


/*------------------------------------------------------------------------------
  FUNCTIONS
------------------------------------------------------------------------------*/

FUNCTION getNextObj RETURNS DECIMAL
  ( /* parameter-definitions */ ) :

  DEFINE VARIABLE dSeqNext    AS DECIMAL  NO-UNDO.
  DEFINE VARIABLE iSeqObj1    AS INTEGER  NO-UNDO.
  DEFINE VARIABLE iSeqObj2    AS INTEGER  NO-UNDO.
  DEFINE VARIABLE iSeqSiteDiv AS INTEGER  NO-UNDO.
  DEFINE VARIABLE iSeqSiteRev AS INTEGER  NO-UNDO.
  DEFINE VARIABLE iSessnId    AS INTEGER  NO-UNDO.

  ASSIGN
    iSeqObj1    = NEXT-VALUE(seq_obj1,ICFDB)
    iSeqObj2    = CURRENT-VALUE(seq_obj2,ICFDB)
    iSeqSiteDiv = CURRENT-VALUE(seq_site_division,ICFDB)
    iSeqSiteRev = CURRENT-VALUE(seq_site_reverse,ICFDB)
    iSessnId    = CURRENT-VALUE(seq_session_id,ICFDB)
    .

  IF iSeqObj1 = 0
  THEN ASSIGN iSeqObj2 = NEXT-VALUE(seq_obj2,ICFDB).

  ASSIGN dSeqNext = DECIMAL((iSeqObj2 * 1000000000.0) + iSeqObj1).

  IF  iSeqSiteDiv <> 0 AND iSeqSiteRev <> 0
  THEN ASSIGN dSeqNext = dSeqNext + (iSeqSiteRev / iSeqSiteDiv).

  RETURN dSeqNext. /* Function return value */

END FUNCTION.

