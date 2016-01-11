/* fixOTDLProc.p
   Fix program to correct the DLProc object type.
    
   Some users may have created a DLProc object type in their repository 
   instead of loading the ADO. This will give them an invalid object_type_obj
   and will cause corruption when ADOs are loaded from the central repository
   
   This program loads the data that the central repository has and then
   updates all related tables to have the same object type obj values. */

DISABLE TRIGGERS FOR LOAD OF gsc_object_type.
DISABLE TRIGGERS FOR LOAD OF gst_record_version.

DEFINE TEMP-TABLE ttObj NO-UNDO
  FIELD deObj AS DECIMAL DECIMALS 9
  INDEX pudx IS UNIQUE PRIMARY
    deObj
  .


DEFINE VARIABLE cTableList AS CHARACTER  INITIAL
  "gsc_object,ryc_smartobject,ryc_attribute_value,ryc_ui_event,ryc_supported_link":U
  NO-UNDO.

DEFINE VARIABLE deOldObj AS DECIMAL    NO-UNDO.
DEFINE VARIABLE iCount   AS INTEGER    NO-UNDO.

trn-block:
DO TRANSACTION:
  /* Find the gsc_object_type record */
  FIND gsc_object_type 
    WHERE gsc_object_type.object_type_code = "DLProc":U NO-ERROR.

  /*If it's not there, create it. */
  IF NOT AVAILABLE(gsc_object_type) THEN
  DO:
    CREATE gsc_object_type.
    PUBLISH "DCU_WriteLog":U ("Created new Object Type DLProc").

  END.
  ELSE
  DO:
    /* Store the old obj - we'll need that later */
    ASSIGN deOldObj = gsc_object_type.object_type_obj.
    PUBLISH "DCU_WriteLog":U ("Changed Object Type DLProc Object ID from " + STRING(gsc_object_type.object_type_obj) 
                              + " to 3000001840.09").

  END.

  /* If the database has the right value, we're all set */
  IF deOldObj = 3000001840.09 THEN
    LEAVE trn-block.
    
  /* Set the values of the object type to the same as the
     central database */
  ASSIGN
    gsc_object_type.object_type_obj         = 3000001840.09
    gsc_object_type.object_type_code        = "DLProc":U
    gsc_object_type.object_type_description = "Data Logic Procedure":U
    gsc_object_type.disabled                = no
    gsc_object_type.layout_supported        = no
  .

  /* Find any gst_record_version record related to the old object
     type and delete it */
  FIND gst_record_version
    WHERE gst_record_version.entity_mnemonic = "GSCOT":U
      AND gst_record_version.key_field_value = STRING(deOldObj)
    NO-ERROR.
  IF AVAILABLE(gst_record_version) THEN
    DELETE gst_record_version.

  /* Find any gst_record_version record related to the central DB 
     object type and delete it */
  FIND gst_record_version
    WHERE gst_record_version.entity_mnemonic = "GSCOT":U
      AND gst_record_version.key_field_value = STRING(gsc_object_type.object_type_obj)
    NO-ERROR.
  IF AVAILABLE(gst_record_version) THEN
    DELETE gst_record_version.

  /* Create a gst_record_version and set the values the same as the
     central db record. */
  CREATE gst_record_version.
  ASSIGN
    gst_record_version.record_version_obj        = 3000001841.09
    gst_record_version.entity_mnemonic           = "GSCOT":U
    gst_record_version.key_field_value           = STRING(gsc_object_type.object_type_obj)
    gst_record_version.version_number_seq        = 2.09
    gst_record_version.version_date              = DATE(02,28,2002)
    gst_record_version.version_time              = 32813
    gst_record_version.version_user              = "admin":U
    gst_record_version.deletion_flag             = NO
    gst_record_version.import_version_number_seq = 0
    gst_record_version.last_version_number_seq   = 0
  .

  /* If we just created a new object type, we're done */
  IF NEW(gsc_object_type) THEN
    LEAVE trn-block.

  /* Loop through the list of tables in cTableList and
     run the internal procedure that fixes the 
     object_type_obj */
  DO iCount = 1 TO NUM-ENTRIES(cTableList):
    RUN replaceObj
      (ENTRY(iCount,cTableList), 
       "object_type_obj":U,
       gsc_object_type.object_type_obj, 
       deOldObj).
  END.

END.


/** DO NOT RUN THIS - THIS SEEMS TO BE UNECESSARY - Mark Davies (MIP) 09/13/2002
/* Loop through the list of tables in cTableList and
   run the internal procedure that fixes the 
   object_type_obj */
DO iCount = 1 TO NUM-ENTRIES(cTableList):
  RUN CheckObj
    (ENTRY(iCount,cTableList), 
     "object_type_obj":U).
END.
********************************************************************************/

PROCEDURE replaceObj:
  DEFINE INPUT  PARAMETER pcTable  AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pcField  AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pdNewObj AS DECIMAL    NO-UNDO.
  DEFINE INPUT  PARAMETER pdOldObj AS DECIMAL    NO-UNDO.

  DEFINE VARIABLE hBuffer AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hQuery  AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hField  AS HANDLE     NO-UNDO.
  DEFINE VARIABLE lFirst AS LOGICAL    NO-UNDO.

  /* Create a buffer for the table name */
  CREATE BUFFER hBuffer FOR TABLE pcTable.

  /* Disable the schema triggers on this buffer */
  hBuffer:DISABLE-LOAD-TRIGGERS(NO).

  /* Get a handle to the field */
  hField = hBuffer:BUFFER-FIELD(pcField).

  /* Create a query and add the buffer to it */
  CREATE QUERY hQuery.
  hQuery:ADD-BUFFER(hBuffer).

  /* Prepare a quert that finds all the records in this table
     with the old obj. */
  hQuery:QUERY-PREPARE(SUBSTITUTE("FOR EACH &1 WHERE &1.&2 = &3", 
                                  hBuffer:NAME, 
                                  hField:NAME, 
                                  STRING(pdOldObj))).

  /* Open the query and find the first record */
  hQuery:QUERY-OPEN().
  lFirst = YES.

  /* Loop through all the records in the query */
  LOOP1:
  REPEAT WHILE NOT hQuery:QUERY-OFF-END:
    IF lFirst THEN
    DO:
      hQuery:GET-FIRST(EXCLUSIVE-LOCK).
      lFirst = NO.
    END.
    IF NOT hBuffer:AVAILABLE THEN
      LEAVE LOOP1.

    /* Set the obj to the new obj */
    hField:BUFFER-VALUE = pdNewObj.

    /* Write the record to the database */
    hBuffer:BUFFER-RELEASE().

    /* Get the next record */
    hQuery:GET-NEXT(EXCLUSIVE-LOCK).

  END.

  /* Close the query */
  hQuery:QUERY-CLOSE().

  /* Whack the query object */
  DELETE OBJECT hQuery.
  hQuery = ?.

  /* Whack the buffer object */
  DELETE OBJECT hBuffer.
  hBuffer = ?.

END.

PROCEDURE CheckObj:
  DEFINE INPUT  PARAMETER pcTable  AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pcField  AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE hBuffer   AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hQuery    AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hField    AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cObjField AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hObjField AS HANDLE     NO-UNDO.
  DEFINE VARIABLE lFirst    AS LOGICAL    NO-UNDO.

  cObjField = SUBSTRING(pcTable,5) + "_obj".

  /* Create a buffer for the table name */
  CREATE BUFFER hBuffer FOR TABLE pcTable.

  /* Disable the schema triggers on this buffer */
  hBuffer:DISABLE-LOAD-TRIGGERS(NO).

  /* Get a handle to the field */
  hField = hBuffer:BUFFER-FIELD(pcField).


  /* Create a query and add the buffer to it */
  CREATE QUERY hQuery.
  hQuery:ADD-BUFFER(hBuffer).

  /* Prepare a query that finds all the records in this table
     with the old obj. */
  hQuery:QUERY-PREPARE(SUBSTITUTE("FOR EACH &1", 
                                  hBuffer:NAME)).

  /* Open the query and find the first record */
  hQuery:QUERY-OPEN().

  lFirst = YES.

  /* Loop through all the records in the query */
  LOOP2:
  REPEAT WHILE lFirst OR NOT hQuery:QUERY-OFF-END TRANSACTION:
    IF lFirst THEN
    DO:
      hQuery:GET-FIRST(EXCLUSIVE-LOCK).
      lFirst = NO.
    END.
    IF NOT hBuffer:AVAILABLE THEN
      LEAVE LOOP2.

    IF NOT CAN-FIND(FIRST gsc_object_type 
                    WHERE gsc_object_type.object_type_obj = hField:BUFFER-VALUE) THEN
    DO:
      FIND ttObj 
        WHERE ttObj.deObj = hField:BUFFER-VALUE
        NO-ERROR.
      IF AVAILABLE(ttObj) THEN
        hField:BUFFER-VALUE = 3000001840.09.
      ELSE
      DO:
        CASE hBuffer:NAME:
          WHEN "gsc_object":U OR
          WHEN "ryc_smartobject":U THEN
          DO:
            
            hObjField = hBuffer:BUFFER-FIELD("object_extension":U) NO-ERROR.
            IF VALID-HANDLE(hObjField) AND
               hObjField:BUFFER-VALUE = "p":U THEN
            DO:
              RUN addObj(hField).
              hField:BUFFER-VALUE = 3000001840.09.
            END.
            ELSE
            DO:
              hObjField = hBuffer:BUFFER-FIELD("object_filename").
              IF ENTRY(NUM-ENTRIES(hObjField:BUFFER-VALUE,".":U), hObjField:BUFFER-VALUE, ".":U) = "p":U THEN
              DO:
                RUN addObj(hField).
                hField:BUFFER-VALUE = 3000001840.09.
              END.
              ELSE IF SUBSTRING(hObjField:BUFFER-VALUE, LENGTH(hObjField:BUFFER-VALUE) - 4) = "logcp":U THEN
              DO:
                RUN addObj(hField).
                hField:BUFFER-VALUE = 3000001840.09.
              END.
            END.
          END.
  
          OTHERWISE
          DO:
            FIND ttObj 
              WHERE ttObj.deObj = hField:BUFFER-VALUE
              NO-ERROR.
            IF AVAILABLE(ttObj) THEN
              hField:BUFFER-VALUE = 3000001840.09.
          END.
        END CASE.
      END.

    END.
    hBuffer:BUFFER-RELEASE().

    /* Get the next record */
    hQuery:GET-NEXT(EXCLUSIVE-LOCK).

  END.

  /* Close the query */
  hQuery:QUERY-CLOSE().
  
  /* Whack the query object */
  DELETE OBJECT hQuery.
  hQuery = ?.

  /* Whack the buffer object */
  DELETE OBJECT hBuffer.
  hBuffer = ?.

END.

PROCEDURE addObj:
  DEFINE INPUT  PARAMETER phField AS HANDLE     NO-UNDO.
  DEFINE BUFFER bttObj FOR ttObj.
  DO FOR bttObj TRANSACTION:
    FIND bttObj 
      WHERE bttObj.deObj = phField:BUFFER-VALUE
      NO-ERROR.
    IF NOT AVAILABLE(ttObj) THEN
    DO:
      CREATE bttObj.
      ASSIGN 
        bttObj.deObj = phField:BUFFER-VALUE
      .
    END.
  END.
END.
