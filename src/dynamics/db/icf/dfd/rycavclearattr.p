/* This noddy is to be run after loading the ados */

/* Purpose: Remove cascaded attributes.                                  */

/* Overridew the trigger */
DISABLE TRIGGERS FOR DUMP OF ryc_attribute_value.           DISABLE TRIGGERS FOR LOAD OF ryc_attribute_value.


DEFINE VARIABLE lDelete                 AS LOGICAL      NO-UNDO.

DEFINE BUFFER b1_ryc_attribute_value    FOR ryc_attribute_value.
DEFINE BUFFER b2_ryc_attribute_value    FOR ryc_attribute_value.

PUBLISH "DCU_WriteLog":U  ("Normalizing attributes...").


FOR EACH gsc_object_type NO-LOCK:
  FOR EACH ryc_smartobject 
      WHERE ryc_smartobject.object_type_obj = gsc_object_type.object_type_obj
      NO-LOCK:
    FOR EACH ryc_object_instance 
        WHERE ryc_object_instance.smartobject_obj = ryc_smartobject.smartobject_obj
        NO-LOCK:
    /* If instance values match master values, remove them. */
      FOR EACH ryc_attribute_value EXCLUSIVE-LOCK
          WHERE ryc_attribute_value.object_type_obj           = ryc_smartobject.object_type_obj
          AND   ryc_attribute_value.smartobject_obj           = ryc_smartobject.smartobject_obj
          AND   ryc_attribute_value.object_instance_obj       = ryc_object_instance.object_instance_obj
          AND   ryc_attribute_value.container_smartobject_obj = ryc_object_instance.container_smartobject_obj,
          FIRST ryc_attribute 
          WHERE ryc_attribute.attribute_label = ryc_attribute_value.attribute_label
          NO-LOCK:
  
        ASSIGN
          lDelete = NO.
  
        FIND FIRST b1_ryc_attribute_value NO-LOCK
             WHERE b1_ryc_attribute_value.object_type_obj           = ryc_smartobject.object_type_obj
             AND   b1_ryc_attribute_value.smartobject_obj           = ryc_smartobject.smartobject_obj
             AND   b1_ryc_attribute_value.object_instance_obj       = 0
             AND   b1_ryc_attribute_value.container_smartobject_obj = 0
             AND   b1_ryc_attribute_value.attribute_label           = ryc_attribute_value.attribute_label 
             NO-ERROR.
        IF AVAILABLE b1_ryc_attribute_value THEN DO:
          /* Values are the same */
          ASSIGN
            lDelete = (ryc_attribute_value.character_value = b1_ryc_attribute_value.character_value AND
                       ryc_attribute_value.integer_value   = b1_ryc_attribute_value.integer_value   AND
                       ryc_attribute_value.decimal_value   = b1_ryc_attribute_value.decimal_value   AND
                       ryc_attribute_value.date_value      = b1_ryc_attribute_value.date_value      AND
                       ryc_attribute_value.logical_value   = b1_ryc_attribute_value.logical_value   AND
                       ryc_attribute_value.raw_value       = b1_ryc_attribute_value.raw_value).
/*
          /* Attribute doesn't exist at class level. */
          IF NOT lDelete THEN
            ASSIGN
              lDelete = NOT CAN-FIND(FIRST b2_ryc_attribute_value
                                     WHERE b2_ryc_attribute_value.object_type_obj           = ryc_smartobject.object_type_obj
                                     AND   b2_ryc_attribute_value.smartobject_obj           = 0
                                     AND   b2_ryc_attribute_value.object_instance_obj       = 0
                                     AND   b2_ryc_attribute_value.container_smartobject_obj = 0
                                     AND   b2_ryc_attribute_value.attribute_label           = ryc_attribute_value.attribute_label).
                                     */
          IF lDelete THEN DO:
            DELETE ryc_attribute_value NO-ERROR.
            IF ERROR-STATUS:ERROR
            OR RETURN-VALUE <> "":U
            THEN
            DO:
                PUBLISH "DCU_WriteLog":U 
                  ("  Delete failed for Class: " + gsc_object_type.object_type_code
                   + "  Master: " + ryc_smartobject.object_filename
                   + "  Instance: " + ryc_object_instance.instance_name
                   + "  Attribute: " + ryc_attribute.attribute_label
                   + " **RETURN-VALUE: " + RETURN-VALUE
                  ).
                  UNDO, NEXT.
            END.
          END.    /* delete attribute value. */
        END.    /* avail b1_ryc_attribute_value (master of instance) */
      END.    /* each attribute value for instance  */
    END.    /* each object instance. */
    
    /* Clean up master attributes. */
    FOR EACH ryc_attribute_value EXCLUSIVE-LOCK
        WHERE ryc_attribute_value.object_type_obj           = ryc_smartobject.object_type_obj
        AND   ryc_attribute_value.smartobject_obj           = ryc_smartobject.smartobject_obj
        AND   ryc_attribute_value.object_instance_obj       = 0
        AND   ryc_attribute_value.container_smartobject_obj = 0,
        FIRST ryc_attribute 
        WHERE ryc_attribute.attribute_label = ryc_attribute_value.attribute_label
        NO-LOCK:
      ASSIGN
        lDelete = NO.
      FIND FIRST b1_ryc_attribute_value NO-LOCK
        WHERE b1_ryc_attribute_value.object_type_obj           = ryc_smartobject.object_type_obj
        AND   b1_ryc_attribute_value.smartobject_obj           = 0
        AND   b1_ryc_attribute_value.object_instance_obj       = 0
        AND   b1_ryc_attribute_value.container_smartobject_obj = 0
        AND   b1_ryc_attribute_value.attribute_label           = ryc_attribute_value.attribute_label
        NO-ERROR.
      IF AVAILABLE b1_ryc_attribute_value THEN DO:
        /* Values are the same */
        ASSIGN
          lDelete = (ryc_attribute_value.character_value = b1_ryc_attribute_value.character_value AND
                     ryc_attribute_value.integer_value   = b1_ryc_attribute_value.integer_value   AND
                     ryc_attribute_value.decimal_value   = b1_ryc_attribute_value.decimal_value   AND
                     ryc_attribute_value.date_value      = b1_ryc_attribute_value.date_value      AND
                     ryc_attribute_value.logical_value   = b1_ryc_attribute_value.logical_value   AND
                     ryc_attribute_value.raw_value       = b1_ryc_attribute_value.raw_value).
      END.    /* avail b1_ryc_attribute_value (class of master) */
      /*
      ELSE
        ASSIGN
          lDelete = YES.
      */

      IF lDelete THEN DO:
        DELETE ryc_attribute_value NO-ERROR.
        IF ERROR-STATUS:ERROR
        OR RETURN-VALUE <> "":U
        THEN
        DO:
            PUBLISH "DCU_WriteLog":U 
              ("  Delete failed for Class: " + gsc_object_type.object_type_code
               + "  Master: " + ryc_smartobject.object_filename
               + "  Attribute: " + ryc_attribute.attribute_label
               + " **RETURN-VALUE: " + RETURN-VALUE
              ).
            UNDO, NEXT.
        END.
      END.    /* delete attribute value. */
    END.    /* each attribute value  for master object */
  END.    /* each master smartobject */
END.    /* object type. */

