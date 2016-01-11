/* toolbar01.p - fixes toolbar attribute values where the smartobject does not match the instance, due to
                 toolbar conversion issues
*/                 

DISABLE TRIGGERS FOR LOAD OF ryc_attribute_value.
DISABLE TRIGGERS FOR DUMP OF ryc_attribute_value.

DEFINE BUFFER bOld FOR ryc_smartobject.

FIND gsc_object_type NO-LOCK WHERE gsc_object_type.object_type_code = 'smarttoolbar'.

PAUSE 0 BEFORE-HIDE.

/* loop through all attrinutes of all instances of smart toolbars */
FOR EACH ryc_attribute_value EXCLUSIVE-LOCK
   WHERE ryc_attribute_value.object_type_obj = gsc_object_type.object_type_obj
     AND ryc_attribute_value.container_smartobject_obj <> 0
     AND ryc_attribute_value.smartobject_obj <> 0
     AND ryc_attribute_value.object_instance_obj <> 0,
    EACH ryc_object_instance NO-LOCK
   WHERE ryc_object_instance.object_instance_obj = ryc_attribute_value.object_instance_obj 
    AND  ryc_object_instance.smartobject_obj <> ryc_attribute_value.smartobject_obj:
    
    FIND ryc_smartObject NO-LOCK
         WHERE ryc_smartobject.smartobject_obj = ryc_object_instance.smartobject_obj 
         NO-ERROR.
    FIND bold  NO-LOCK
         WHERE bold.smartobject_obj = ryc_attribute_value.smartobject_obj 
         NO-ERROR.
    
    IF AVAIL ryc_smartobject THEN
    DO:
      ASSIGN 
        ryc_attribute_value.smartobject_obj = ryc_smartobject.smartobject_obj.
    END.

END.

