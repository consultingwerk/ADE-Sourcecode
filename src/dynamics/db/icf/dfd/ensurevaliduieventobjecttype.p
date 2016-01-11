/* this utility will fix any ui event records that have an incorrect object
   type, i.e. a different object type to the object type of the smartobject they
   are for.
   If an ui event for the correct object type can be found, then the record
   with the incorrect object type will just be deleted. If an ui event for the
   correct object type cannot be found, then the object type will be fixed on the 
   ui event record to be the same object type as that of the smartobject.
   The reasons for this duff data are tools related (container builder).
*/
disable triggers for dump of ryc_ui_event.
disable triggers for load of ryc_ui_event.  

DEFINE VARIABLE lError  AS LOGICAL    NO-UNDO.

DEFINE BUFFER rycue     FOR ryc_ui_event.

PUBLISH "DCU_WriteLog":U ("UiEvent object_type_obj fix started.").

/* loop through ui events that have a different object type to their smartobject object type */
FOR EACH ryc_ui_event EXCLUSIVE-LOCK,
   FIRST ryc_smartObject NO-LOCK 
   WHERE ryc_smartObject.smartobject_obj = ryc_ui_event.smartobject_obj 
     AND ryc_smartObject.OBJECT_type_obj NE ryc_ui_event.OBJECT_type_obj:

    /* see if ui event exists for correct object type */
    FIND FIRST rycue NO-LOCK
         WHERE rycue.OBJECT_type_obj           = ryc_smartObject.OBJECT_type_obj  /* correct object type */
           AND rycue.container_smartobject_obj = ryc_ui_event.container_smartobject_obj /* same everything else */
           AND rycue.smartobject_obj           = ryc_ui_event.smartobject_obj
           AND rycue.object_instance_obj       = ryc_ui_event.object_instance_obj
           AND rycue.event_name                = ryc_ui_event.event_name
           AND rycue.render_type_obj           = ryc_ui_event.render_type_obj
         NO-ERROR. 
    
    /* if ui event for correct object type is available, then delete this ui event for
       incorrect object type as it is a duplicate record with invalid data
    */
    IF AVAILABLE rycue THEN 
    DO:
      DELETE ryc_ui_event NO-ERROR.

      IF ERROR-STATUS:ERROR THEN
      DO:
        ASSIGN lError = TRUE.
        PUBLISH "DCU_WriteLog":U ("Unable to delete UiEvent with ui_event_obj '" + STRING(ryc_ui_event.ui_event_obj) + "'":U).
        ERROR-STATUS:ERROR = FALSE.
      END.
    END.
    ELSE
    /* if a correct record is not found, we need to at least fix the object type to be the correct
       object type on the ui event record.
    */
    DO:
      ASSIGN 
        ryc_ui_event.OBJECT_type_obj = ryc_smartObject.OBJECT_type_obj NO-ERROR.

      IF ERROR-STATUS:ERROR THEN
      DO:
        ASSIGN lError = TRUE.
        PUBLISH "DCU_WriteLog":U ("Unable to assign object_type_obj to '" + STRING(ryc_ui_event.ui_event_obj) + "'":U).
        ERROR-STATUS:ERROR = FALSE.
      END.
    END.

END.

PUBLISH "DCU_WriteLog":U ("UiEvent object_type_obj fix completed " + (IF lError THEN "with errors!" ELSE "successfully.")).
