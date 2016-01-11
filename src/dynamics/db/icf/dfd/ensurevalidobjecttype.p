/* this utility will fix any attribute value records that have an incorrect object
   type, i.e. a different object type to the object type of the smartobject they
   are for.
   If an attribute value for the correct object type can be found, then the record
   with the incorrect object type will just be deleted. If an attribute value for the
   correct object type cannot be found, then the object type will be fixed on the 
   attribute value record to be the same object type as that of the smartobject.
   The reasons for this duff data are tools related (container builder).
*/
disable triggers for dump of ryc_attribute_value.
disable triggers for load of ryc_attribute_value.  

DEFINE VARIABLE lError  AS LOGICAL    NO-UNDO.

DEFINE BUFFER rycat     FOR ryc_attribute_value.

PUBLISH "DCU_WriteLog":U ("AttributeValue object_type_obj fix started.").

/* loop through attribute values that have a different object type to their smartobject object type */
FOR EACH ryc_attribute_value EXCLUSIVE-LOCK,
   FIRST ryc_smartObject NO-LOCK 
   WHERE ryc_smartObject.smartobject_obj = ryc_attribute_value.smartobject_obj 
     AND ryc_smartObject.OBJECT_type_obj NE ryc_attribute_value.OBJECT_type_obj:

    /* see if attribute value exists for correct object type */
    FIND FIRST rycat NO-LOCK
         WHERE rycat.OBJECT_type_obj = ryc_smartObject.OBJECT_type_obj  /* correct object type */
           AND rycat.container_smartobject_obj = ryc_attribute_value.container_smartobject_obj /* same everything else */
           AND rycat.smartobject_obj = ryc_attribute_value.smartobject_obj
           AND rycat.object_instance_obj = ryc_attribute_value.object_instance_obj
           AND rycat.attribute_label = ryc_attribute_value.attribute_label
           AND rycat.render_type_obj = ryc_attribute_value.render_type_obj
         NO-ERROR. 
    
    /* if attribute value for correct object type is available, then delete this attribute value for
       incorrect object type as it is a duplicate record with invalid data
    */
    IF AVAILABLE rycat THEN 
    DO:
      DELETE ryc_attribute_value NO-ERROR.

      IF ERROR-STATUS:ERROR THEN
      DO:
        ASSIGN lError = TRUE.
        PUBLISH "DCU_WriteLog":U ("Unable to delete AttributeValue with attribute_value_obj '" + STRING(ryc_attribute_value.attribute_value_obj) + "'":U).
        ERROR-STATUS:ERROR = FALSE.
      END.
    END.
    ELSE
    /* if a correct record is not found, we need to at least fix the object type to be the correct
       object type on the attribute value record.
    */
    DO:
      ASSIGN 
        ryc_attribute_value.OBJECT_type_obj = ryc_smartObject.OBJECT_type_obj NO-ERROR.

      IF ERROR-STATUS:ERROR THEN
      DO:
        ASSIGN lError = TRUE.
        PUBLISH "DCU_WriteLog":U ("Unable to assign object_type_obj to '" + STRING(ryc_attribute_value.attribute_value_obj) + "'":U).
        ERROR-STATUS:ERROR = FALSE.
      END.
    END.

END.

PUBLISH "DCU_WriteLog":U ("AttributeValue object_type_obj fix completed " + (IF lError THEN "with errors!" ELSE "successfully.")).
