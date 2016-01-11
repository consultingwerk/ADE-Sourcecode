/* remove duplicate attribute values on toolbar master objects */

DISABLE TRIGGERS FOR LOAD OF ryc_attribute_value.
DISABLE TRIGGERS FOR DUMP OF ryc_attribute_value.

DEFINE BUFFER bryc  FOR ryc_smartobject.

FIND gsc_object_type NO-LOCK WHERE gsc_object_type.object_type_code = 'smarttoolbar'.

PAUSE 0 BEFORE-HIDE.

DEFINE VARIABLE cprev AS CHARACTER  NO-UNDO.
DEFINE VARIABLE dprev AS DECIMAL    NO-UNDO.
DEFINE VARIABLE lPrev AS LOGICAL    NO-UNDO.
DEFINE BUFFER bprev FOR ryc_attribute_value.

FOR EACH ryc_smartobject OF gsc_object_type:
 
 DEFINE VARIABLE lDelete AS LOGICAL    NO-UNDO.
 FOR EACH ryc_attribute_value NO-LOCK 
     WHERE ryc_attribute_value.object_type_obj = gsc_object_type.object_type_obj
     AND   ryc_attribute_value.container_smartobject_obj = 0
     AND   ryc_attribute_value.smartobject_obj = ryc_smartobject.smartobject_obj
     AND   ryc_attribute_value.OBJECT_instance_obj = 0
     BY ryc_attribute_value.attribute_label :
    lDelete =false.
    IF cprev = ryc_attribute_value.attribute_label THEN
    DO:            
      IF lprev THEN
        FIND bprev EXCLUSIVE WHERE bprev.attribute_value_obj = dprev.  
      ELSE
        FIND bprev EXCLUSIVE WHERE bprev.attribute_value_obj = ryc_attribute_value.attribute_value_obj.     
      
      lDELETE = AVAIL bprev.
    END.
    
    dprev = ryc_attribute_value.attribute_value_obj.
    cprev = ryc_attribute_value.attribute_label.
    lprev = NOT ryc_attribute_value.constant_VALUE.    
    IF ldelete THEN dELETE bPrev.
 END.
END.
