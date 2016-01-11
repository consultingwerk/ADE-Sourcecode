  FIELD smartlink_obj LIKE ryc_smartlink.smartlink_obj VALIDATE ~
  FIELD container_smartobject_obj LIKE ryc_smartlink.container_smartobject_obj VALIDATE ~
  FIELD smartlink_type_obj LIKE ryc_smartlink.smartlink_type_obj VALIDATE ~
  FIELD link_name LIKE ryc_smartlink.link_name VALIDATE ~
  FIELD source_object_instance_obj LIKE ryc_smartlink.source_object_instance_obj VALIDATE ~
  FIELD source_object_name AS CHARACTER FORMAT "x(25)" LABEL "Source"~
  FIELD target_object_instance_obj LIKE ryc_smartlink.target_object_instance_obj VALIDATE ~
  FIELD link_name-2 LIKE ryc_smartlink_type.link_name VALIDATE ~
  FIELD smartlink_type_obj-2 LIKE ryc_smartlink_type.smartlink_type_obj VALIDATE ~
  FIELD target_object_name AS CHARACTER FORMAT "x(25)" LABEL "Target"~
  FIELD system_owned LIKE ryc_smartlink_type.system_owned VALIDATE ~
  FIELD user_defined_link LIKE ryc_smartlink_type.user_defined_link VALIDATE ~
  FIELD object_filename LIKE ryc_smartobject.object_filename VALIDATE 
