  FIELD container_smartobject_obj LIKE ryc_object_instance.container_smartobject_obj VALIDATE ~
  FIELD object_instance_obj LIKE ryc_object_instance.object_instance_obj VALIDATE ~
  FIELD smartobject_obj LIKE ryc_object_instance.smartobject_obj VALIDATE ~
  FIELD object_filename LIKE ryc_smartobject.object_filename VALIDATE ~
  FIELD instance_x LIKE ryc_object_instance.instance_x VALIDATE ~
  FIELD instance_y LIKE ryc_object_instance.instance_y VALIDATE ~
  FIELD instance_width LIKE ryc_object_instance.instance_width VALIDATE ~
  FIELD instance_height LIKE ryc_object_instance.instance_height VALIDATE ~
  FIELD attribute_list LIKE ryc_object_instance.attribute_list VALIDATE ~
  FIELD system_owned LIKE ryc_object_instance.system_owned VALIDATE ~
  FIELD layout_position LIKE ryc_object_instance.layout_position VALIDATE ~
  FIELD object_type_obj LIKE ryc_smartobject.object_type_obj VALIDATE ~
  FIELD page_obj LIKE ryc_page_object.page_obj VALIDATE ~
  FIELD page_object_sequence LIKE ryc_page_object.page_object_sequence VALIDATE ~
  FIELD dInstancePageObj AS DECIMAL FORMAT ">>>>>>>>>>>>>9.999999999" LABEL "Page"~
  FIELD dObjectTypeObj AS DECIMAL FORMAT ">>>>>>>>>>>>>>9.999999999" LABEL "Object Type"~
  FIELD iCreateSequence AS INTEGER FORMAT "->>9" LABEL "Create Sequence"~
  FIELD dObjectInstanceObj AS DECIMAL FORMAT ">>>>>>>>>>>>>9.999999999" LABEL "Object Instance Obj"
