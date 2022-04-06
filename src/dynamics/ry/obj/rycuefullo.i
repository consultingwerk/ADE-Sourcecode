  FIELD ui_event_obj LIKE ryc_ui_event.ui_event_obj VALIDATE ~
  FIELD object_type_obj LIKE ryc_ui_event.object_type_obj VALIDATE ~
  FIELD object_type_code LIKE gsc_object_type.object_type_code VALIDATE ~
  FIELD container_smartobject_obj LIKE ryc_ui_event.container_smartobject_obj VALIDATE ~
  FIELD smartobject_obj LIKE ryc_ui_event.smartobject_obj VALIDATE ~
  FIELD object_filename LIKE ryc_smartobject.object_filename VALIDATE ~
  FIELD object_instance_obj LIKE ryc_ui_event.object_instance_obj VALIDATE ~
  FIELD event_name LIKE ryc_ui_event.event_name VALIDATE ~
  FIELD constant_value LIKE ryc_ui_event.constant_value VALIDATE ~
  FIELD action_type LIKE ryc_ui_event.action_type VALIDATE ~
  FIELD action_target LIKE ryc_ui_event.action_target VALIDATE ~
  FIELD event_action LIKE ryc_ui_event.event_action VALIDATE ~
  FIELD event_parameter LIKE ryc_ui_event.event_parameter VALIDATE ~
  FIELD event_disabled LIKE ryc_ui_event.event_disabled VALIDATE ~
  FIELD primary_smartobject_obj LIKE ryc_ui_event.primary_smartobject_obj VALIDATE 
