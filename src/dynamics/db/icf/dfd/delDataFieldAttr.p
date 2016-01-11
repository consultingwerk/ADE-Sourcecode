/* delDataFieldAttr.p
   This noddy will remove incorrect Master attributes from
   a migrated V1.1 database's DataFields
   
   Removing these attributes will ensure that the default
   attribute value for the class is used and this is set
   to the correct default.
   
   This noddy will also rename existing extent Data Field
   created prior to V2 to the new naming convention of 
   removing the [ and ] from the extent number.
   
   Mark Davies (MIP) 08/23/2002
   
   */
DISABLE TRIGGERS FOR LOAD OF ryc_smartobject.
DISABLE TRIGGERS FOR DUMP OF ryc_smartobject.
DISABLE TRIGGERS FOR LOAD OF ryc_attribute_value.
DISABLE TRIGGERS FOR DUMP OF ryc_attribute_value.
  
DEFINE BUFFER bryc_smartobject FOR ryc_smartobject.

DEFINE VARIABLE cNewObjectName AS CHARACTER  NO-UNDO.

FIND FIRST gsc_object_type
     WHERE gsc_object_type.object_type_code = "DataField":U.
     NO-LOCK NO-ERROR.
FOR EACH  ryc_smartobject
    WHERE ryc_smartobject.object_type_obj = gsc_object_type.object_type_obj
    EXCLUSIVE-LOCK:
  ASSIGN cNewObjectName = "":U.
  IF INDEX(ryc_smartobject.object_filename,"[":U) > 0 AND
     INDEX(ryc_smartobject.object_filename,"]":U) > 0 THEN DO:
    ASSIGN cNewObjectName = REPLACE(ryc_smartobject.object_filename,"[":U,"":U)
           cNewObjectName = REPLACE(cNewObjectName,"]":U,"":U).
    /* First check is such a field exists - if it does, don't rename it */
    IF NOT CAN-FIND(FIRST bryc_smartobject
                    WHERE bryc_smartobject.object_filename = cNewObjectName)  THEN
      ASSIGN ryc_smartobject.object_filename = cNewObjectName.
  END.
  FIND FIRST ryc_attribute_value
       WHERE ryc_attribute_value.object_type_obj           = gsc_object_type.object_type_obj
       AND   ryc_attribute_value.container_smartobject_obj = 0
       AND   ryc_attribute_value.object_instance_obj       = 0
       AND   ryc_attribute_value.smartobject_obj           = ryc_smartobject.smartobject_obj
       AND   ryc_attribute_value.attribute_label           = "HEIGHT-CHARS":U
       AND   ryc_attribute_value.decimal_value             = 0
       EXCLUSIVE-LOCK NO-ERROR.
  IF AVAILABLE ryc_attribute_value THEN
    DELETE ryc_attribute_value.
  FIND FIRST ryc_attribute_value
       WHERE ryc_attribute_value.object_type_obj           = gsc_object_type.object_type_obj
       AND   ryc_attribute_value.container_smartobject_obj = 0
       AND   ryc_attribute_value.object_instance_obj       = 0
       AND   ryc_attribute_value.smartobject_obj           = ryc_smartobject.smartobject_obj
       AND   ryc_attribute_value.attribute_label           = "WIDTH-CHARS":U
       AND   ryc_attribute_value.decimal_value             = 0
       EXCLUSIVE-LOCK NO-ERROR.
  IF AVAILABLE ryc_attribute_value THEN
    DELETE ryc_attribute_value.
  FIND FIRST ryc_attribute_value
       WHERE ryc_attribute_value.object_type_obj           = gsc_object_type.object_type_obj
       AND   ryc_attribute_value.container_smartobject_obj = 0
       AND   ryc_attribute_value.object_instance_obj       = 0
       AND   ryc_attribute_value.smartobject_obj           = ryc_smartobject.smartobject_obj
       AND   ryc_attribute_value.attribute_label           = "DisplayField":U
       AND   ryc_attribute_value.logical_value             = FALSE
       EXCLUSIVE-LOCK NO-ERROR.
  IF AVAILABLE ryc_attribute_value THEN
    DELETE ryc_attribute_value.
  FIND FIRST ryc_attribute_value
       WHERE ryc_attribute_value.object_type_obj           = gsc_object_type.object_type_obj
       AND   ryc_attribute_value.container_smartobject_obj = 0
       AND   ryc_attribute_value.object_instance_obj       = 0
       AND   ryc_attribute_value.smartobject_obj           = ryc_smartobject.smartobject_obj
       AND   ryc_attribute_value.attribute_label           = "Enabled":U
       AND   ryc_attribute_value.logical_value             = FALSE
       EXCLUSIVE-LOCK NO-ERROR.
  IF AVAILABLE ryc_attribute_value THEN
    DELETE ryc_attribute_value.
END.
