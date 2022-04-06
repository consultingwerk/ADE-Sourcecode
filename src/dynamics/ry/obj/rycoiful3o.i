  FIELD container_smartobject_obj LIKE ryc_object_instance.container_smartobject_obj VALIDATE ~
  FIELD object_instance_obj LIKE ryc_object_instance.object_instance_obj VALIDATE ~
  FIELD smartobject_obj LIKE ryc_object_instance.smartobject_obj VALIDATE ~
  FIELD object_filename LIKE ryc_smartobject.object_filename VALIDATE ~
  FIELD system_owned LIKE ryc_object_instance.system_owned VALIDATE ~
  FIELD layout_position LIKE ryc_object_instance.layout_position VALIDATE ~
  FIELD object_type_obj LIKE ryc_smartobject.object_type_obj VALIDATE ~
  FIELD page_obj LIKE ryc_object_instance.page_obj~
  FIELD object_sequence LIKE ryc_object_instance.object_sequence~
  FIELD instance_description LIKE ryc_object_instance.instance_description VALIDATE ~
  FIELD instance_name LIKE ryc_object_instance.instance_name VALIDATE ~
  FIELD dObjectTypeObj AS DECIMAL FORMAT "->>>>>>>>>>>>>>>>>9.999999999" LABEL "Object Type"~
  FIELD dObjectInstanceObj AS DECIMAL FORMAT "->>>>>>>>>>>>>>>>>9.999999999" LABEL "Object Instance Obj"
