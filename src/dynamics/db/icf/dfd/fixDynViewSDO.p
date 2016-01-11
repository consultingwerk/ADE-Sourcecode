/* The procedure will attempt to associate an SDO with
   all existing Dynamic Viewers that do not have an
   SDO already associated.
   
   It should be run after all the deltas have been applied
   and all the ados have been loaded 
   
   Mark Davies (MIP) 07/24/2002 */

DEFINE VARIABLE cSDOName  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE iCnt      AS INTEGER    NO-UNDO.
DEFINE VARIABLE cFileName AS CHARACTER  NO-UNDO.
DEFINE VARIABLE dSDOObj   AS DECIMAL    NO-UNDO.

DEFINE BUFFER bryc_smartobject FOR ryc_smartobject.
DEFINE BUFFER bgsc_object_type FOR gsc_object_type.

FIND FIRST gsc_object_type
     WHERE gsc_object_type.object_type_code = "DynView":U
     NO-LOCK NO-ERROR.
FOR EACH  ryc_smartobject
    WHERE ryc_smartobject.object_type_obj     = gsc_object_type.object_type_obj
    AND   ryc_smartobject.sdo_smartobject_obj = 0
    EXCLUSIVE-LOCK:
    ASSIGN cSDOName = "":U
           dSDOObj  = 0.
  /* First try and find a DataSource attribute on the Master Object */
  FIND FIRST ryc_attribute_value
       WHERE ryc_attribute_value.object_type_obj           = gsc_object_type.object_type_obj
       AND   ryc_attribute_value.smartobject_obj           = ryc_smartobject.smartobject_obj
       AND   ryc_attribute_value.container_smartobject_obj = 0
       AND   ryc_attribute_value.object_instance_obj       = 0
       AND   ryc_attribute_value.attribute_label           = "DataSource":U
       NO-LOCK NO-ERROR.
  IF AVAILABLE ryc_attribute_value THEN
    cSDOName = ryc_attribute_value.character_value.
  
  /* If we couldn't find it on the Master Object we should try and find it
     on one of the Master's Object Instance - DataFields */
  IF cSDOName = "":U OR cSDOName = "?":U OR cSDOName = ? THEN DO:
    ATTR_BLOCK:
    FOR EACH  ryc_attribute_value
        WHERE ryc_attribute_value.smartobject_obj          <> 0
        AND   ryc_attribute_value.container_smartobject_obj = ryc_smartobject.smartobject_obj
        AND   ryc_attribute_value.object_instance_obj      <> 0
        AND   ryc_attribute_value.attribute_label           = "DataSource":U
        NO-LOCK:
      IF ryc_attribute_value.character_value <> "":U AND 
         ryc_attribute_value.character_value <> "?":U AND 
         ryc_attribute_value.character_value <> ? THEN DO:
        cSDOName = ryc_attribute_value.character_value.
        LEAVE ATTR_BLOCK.
      END.
    END.
  END.

  /* If we couldn't find a DataSource on the DataField instance level we
     should try the DataField Master - atleast something */
  IF cSDOName = "":U OR cSDOName = "?":U OR cSDOName = ? THEN DO:
    ATTR_BLOCK2:
    FOR EACH  ryc_object_instance
        WHERE ryc_object_instance.container_smartobject_obj = ryc_smartobject.smartobject_obj
        NO-LOCK:
      FOR EACH  ryc_attribute_value
          WHERE ryc_attribute_value.smartobject_obj           = ryc_object_instance.smartobject_obj
          AND   ryc_attribute_value.container_smartobject_obj = 0
          AND   ryc_attribute_value.object_instance_obj       = 0
          AND   ryc_attribute_value.attribute_label           = "DataSource":U
          NO-LOCK:
        IF ryc_attribute_value.character_value <> "":U AND 
           ryc_attribute_value.character_value <> "?":U AND 
           ryc_attribute_value.character_value <> ? THEN DO:
          cSDOName = ryc_attribute_value.character_value.
          LEAVE ATTR_BLOCK2.
        END.
      END.
    END.
  END.
  
  /* If we still can't find a DataSource attribute we should start guessing
     a file name and hope we get something */
  IF cSDOName = "":U OR cSDOName = "?":U OR cSDOName = ? THEN DO:
    GUESSING_BLOCK:
    DO iCnt = 1 TO LENGTH(ryc_smartobject.object_filename):
      IF LENGTH(ryc_smartobject.object_filename) - iCnt < 5 THEN
        LEAVE GUESSING_BLOCK.
      cFileName = SUBSTRING(ryc_smartobject.object_filename,1,LENGTH(ryc_smartobject.object_filename) - iCnt).
      FOR EACH  bgsc_object_type
          WHERE bgsc_object_type.object_type_code = "SDO":U /* We didn't have Dynamic SDOs for V1 yet */
          OR    bgsc_object_type.object_type_code = "SBO":U
          NO-LOCK,
          FIRST bryc_smartobject
          WHERE bryc_smartobject.object_type_obj = bgsc_object_type.object_type_obj
          AND   bryc_smartobject.object_filename BEGINS cFileName
          NO-LOCK:
        ASSIGN cSDOName = bryc_smartobject.object_filename
               dSDOObj  = bryc_smartobject.smartobject_obj.
      END.
    END.
  END.

  /* If we have a file name we should find the smartobject */
  IF cSDOName <> "":U AND dSDOObj = 0 THEN DO:
    FIND FIRST bryc_smartobject
         WHERE bryc_smartobject.object_filename = cSDOName
         NO-LOCK NO-ERROR.
    IF AVAILABLE bryc_smartobject THEN
      ASSIGN dSDOObj = bryc_smartobject.smartobject_obj.
    ELSE DO:
      IF NUM-ENTRIES(cSDOName,".":U) > 1 THEN DO:
        FIND FIRST bryc_smartobject
             WHERE bryc_smartobject.object_filename  = ENTRY(1,cSDOName,".":U)
             AND   bryc_smartobject.object_extension = ENTRY(2,cSDOName,".":U)
             NO-LOCK NO-ERROR.
        IF AVAILABLE bryc_smartobject THEN
          ASSIGN dSDOObj = bryc_smartobject.smartobject_obj.
        ELSE
          FIND FIRST bryc_smartobject
               WHERE bryc_smartobject.object_filename = ENTRY(1,cSDOName,".":U)
               NO-LOCK NO-ERROR.
          IF AVAILABLE bryc_smartobject THEN
            ASSIGN dSDOObj = bryc_smartobject.smartobject_obj.
      END.
    END.
  END.

  IF dSDOObj <> 0 THEN
    ASSIGN ryc_smartobject.sdo_smartobject_obj = dSDOObj.
END.
