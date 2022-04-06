  FIELD deactivated_link_on_hide LIKE ryc_supported_link.deactivated_link_on_hide VALIDATE ~
  FIELD link_source LIKE ryc_supported_link.link_source VALIDATE ~
  FIELD link_target LIKE ryc_supported_link.link_target VALIDATE ~
  FIELD object_type_obj LIKE ryc_supported_link.object_type_obj VALIDATE ~
  FIELD smartlink_type_obj LIKE ryc_supported_link.smartlink_type_obj VALIDATE ~
  FIELD supported_link_obj LIKE ryc_supported_link.supported_link_obj VALIDATE ~
  FIELD link_name LIKE ryc_smartlink_type.link_name VALIDATE ~
  FIELD user_defined_link LIKE ryc_smartlink_type.user_defined_link VALIDATE ~
  FIELD object_type_code LIKE gsc_object_type.object_type_code VALIDATE ~
  FIELD object_type_description LIKE gsc_object_type.object_type_description VALIDATE 
