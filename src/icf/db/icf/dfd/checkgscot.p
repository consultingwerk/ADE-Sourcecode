DEFINE VARIABLE cTableList AS CHARACTER  INITIAL
  "gsc_object,ryc_smartobject,ryc_attribute_value,ryc_ui_event,ryc_supported_link":U
  NO-UNDO.
DEFINE VARIABLE iCount   AS INTEGER    NO-UNDO.


/* Loop through the list of tables in cTableList and
   run the internal procedure that fixes the 
   object_type_obj */
DO iCount = 1 TO NUM-ENTRIES(cTableList):
  RUN CheckObj
    (ENTRY(iCount,cTableList), 
     "object_type_obj":U).
END.


PROCEDURE CheckObj:
  DEFINE INPUT  PARAMETER pcTable  AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pcField  AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE hBuffer   AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hQuery    AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hField    AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cObjField AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hObjField AS HANDLE     NO-UNDO.

  cObjField = SUBSTRING(pcTable,5) + "_obj".

  /* Create a buffer for the table name */
  CREATE BUFFER hBuffer FOR TABLE pcTable.

  /* Disable the schema triggers on this buffer */
  hBuffer:DISABLE-LOAD-TRIGGERS(NO).

  /* Get a handle to the field */
  hField = hBuffer:BUFFER-FIELD(pcField).

  hObjField = hBuffer:BUFFER-FIELD("object_filename") NO-ERROR.
  IF hObjField = ? THEN
    hObjField = hBuffer:BUFFER-FIELD(cObjField).

  /* Create a query and add the buffer to it */
  CREATE QUERY hQuery.
  hQuery:ADD-BUFFER(hBuffer).

  /* Prepare a query that finds all the records in this table
     with the old obj. */
  hQuery:QUERY-PREPARE(SUBSTITUTE("FOR EACH &1 NO-LOCK", 
                                  hBuffer:NAME)).

  /* Open the query and find the first record */
  hQuery:QUERY-OPEN().
  hQuery:GET-FIRST().

  /* Loop through all the records in the query */
  REPEAT WHILE NOT hQuery:QUERY-OFF-END:

    IF NOT CAN-FIND(FIRST gsc_object_type 
                    WHERE gsc_object_type.object_type_obj = hField:BUFFER-VALUE) THEN
      MESSAGE hBuffer:NAME SKIP 
              hField:NAME hField:BUFFER-VALUE SKIP
              hObjField:NAME hObjField:BUFFER-VALUE
        VIEW-AS ALERT-BOX INFO BUTTONS OK.

    /* Get the next record */
    hQuery:GET-NEXT().

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
