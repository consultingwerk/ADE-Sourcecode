  FIELD logical_service_obj LIKE gsc_logical_service.logical_service_obj VALIDATE ~
  FIELD logical_service_code LIKE gsc_logical_service.logical_service_code VALIDATE ~
  FIELD logical_service_description LIKE gsc_logical_service.logical_service_description VALIDATE ~
  FIELD service_type_obj LIKE gsc_logical_service.service_type_obj VALIDATE ~
  FIELD service_type_code LIKE gsc_service_type.service_type_code VALIDATE ~
  FIELD can_run_locally LIKE gsc_logical_service.can_run_locally VALIDATE ~
  FIELD system_owned LIKE gsc_logical_service.system_owned VALIDATE ~
  FIELD write_to_config LIKE gsc_logical_service.write_to_config VALIDATE ~
  FIELD connect_at_startup LIKE gsc_logical_service.connect_at_startup
