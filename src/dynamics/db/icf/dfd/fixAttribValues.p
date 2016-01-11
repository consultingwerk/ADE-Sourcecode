/** This procedure needs to be run using the same numeric and date formats
 *  used when the data was written.
 * 
 *  The schema write trigger ensures that the data is written away correctly.
 *  For this reason, please see the notes on issue 3591.
 * 
 *  This fix should be run for all numeric and date formats, since dates are
 *  stored in their integer forms, and not in  99/99/9999 (or similar human-
 *  readable form) form.
 *  ----------------------------------------------------------------------- **/
DEFINE QUERY qAttr FOR ryc_attribute_value.
DEFINE VARIABLE lFirst      AS LOGICAL    NO-UNDO.
DEFINE VARIABLE iTotResults AS INTEGER    NO-UNDO.
DEFINE VARIABLE iResults  AS INTEGER    NO-UNDO.

PAUSE 0 BEFORE-HIDE.
 
FUNCTION FormatAttributeValue RETURNS CHARACTER
    ( INPUT pcAttributeTypeTLA          AS CHARACTER,
      INPUT pcAttributeValue            AS CHARACTER    ) FORWARD.

/* First make sure that the data types of the TabBGColor and TabFGColor are correct */
DO TRANSACTION:
  FIND FIRST ryc_attribute
     WHERE ryc_attribute.attribute_label = "TabBGcolor" 
     EXCLUSIVE-LOCK NO-ERROR.
  IF AVAILABLE(ryc_attribute) AND
     ryc_attribute.attribute_type_tla <> "CHR":U THEN
    ASSIGN ryc_attribute.attribute_type_tla = "CHR":U.
  FIND FIRST ryc_attribute
       WHERE ryc_attribute.attribute_label = "TabFGcolor" 
       EXCLUSIVE-LOCK NO-ERROR.
  IF AVAILABLE(ryc_attribute) AND
     ryc_attribute.attribute_type_tla <> "CHR":U THEN
    ASSIGN ryc_attribute.attribute_type_tla = "CHR":U.
END.

/* Open a query on the attribute values. */
OPEN QUERY qAttr
  PRESELECT EACH ryc_attribute_value EXCLUSIVE-LOCK.
lFirst = YES.
iTotResults = NUM-RESULTS("qAttr").

REPEAT:
  IF lFirst THEN
  DO:
    GET FIRST qAttr EXCLUSIVE-LOCK.
    lFirst = NO.
  END.
  ELSE
    GET NEXT qAttr EXCLUSIVE-LOCK.

  IF QUERY-OFF-END("qAttr") THEN
    LEAVE.

  iResults = iResults + 1.
  IF iResults MOD 100 = 0 THEN
    DISPLAY
      "Processed" iResults "of" iTotResults
      WITH 
        1 DOWN
        NO-LABEL.

  /* Find the ryc_attribute record for the attribute value */
  FIND FIRST ryc_attribute NO-LOCK
    WHERE ryc_attribute.attribute_label = ryc_attribute_value.attribute_label
    NO-ERROR.

  /* Referential integrity. This should never happen. If it does, we need to whack
     the record. */
  IF NOT AVAILABLE(ryc_attribute) THEN
  DO:
    DELETE ryc_attribute_value. 
    NEXT.
  END.
  
  /* If the attribute value's TLA is not the same as the TLA for the attribute, fix it.
     This will happen as a result of the ADO load. */
  IF ryc_attribute_value.attribute_type_tla <> ryc_attribute.attribute_type_tla THEN
    ASSIGN ryc_attribute_value.attribute_type_tla = ryc_attribute.attribute_type_tla.
  
  /* Now make sure that the data is the correct data type. */
  IF ryc_attribute.attribute_type_TLA = "DEC":U OR
     ryc_attribute.attribute_type_TLA = "DAT":U OR
     ryc_attribute.attribute_type_TLA = "INT":U THEN
     ASSIGN ryc_attribute_value.attribute_value = FormatAttributeValue(INPUT ryc_attribute_value.attribute_type_tla,
                                                                       INPUT ryc_attribute_value.attribute_value) NO-ERROR.
END.

FUNCTION FormatAttributeValue RETURNS CHARACTER
    ( INPUT pcAttributeTypeTLA          AS CHARACTER,
      INPUT pcAttributeValue            AS CHARACTER    ):
/*------------------------------------------------------------------------------
  Purpose:  Ensures that decimal attribute values have the correct numeric decimal
    Notes: 
------------------------------------------------------------------------------*/
    DEFINE VARIABLE cAttributeValue         AS CHARACTER                NO-UNDO.
    DEFINE VARIABLE tAttributeValue         AS DATE                     NO-UNDO.
    DEFINE VARIABLE iAttributeValue         AS INTEGER                  NO-UNDO.

    /* Convert decimal attribute values to 'proper' numbers. */
    CASE pcAttributeTypeTLA:
        WHEN "DEC":U THEN
            ASSIGN cAttributeValue = REPLACE(pcAttributeValue, ".":U, SESSION:NUMERIC-DECIMAL-POINT).
        WHEN "DAT":U THEN
        DO:
            /* Dates are stored in integer format */
            ASSIGN iAttributeValue = INTEGER(pcAttributeValue) NO-ERROR.
            IF ERROR-STATUS:ERROR THEN
                ASSIGN cAttributeValue = pcAttributeValue.
            ELSE
                ASSIGN tAttributeValue = DATE(iAttributeValue)
                       cAttributeValue = STRING(tAttributeValue)
                       .
        END.    /* DAT */
        OTHERWISE
            ASSIGN cAttributeValue = pcAttributeValue.
    END CASE.   /* attribute type TLA */

    RETURN cAttributeValue.
END FUNCTION.


/* EOF */
