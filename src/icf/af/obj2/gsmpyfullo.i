  FIELD physical_service_obj LIKE gsm_physical_service.physical_service_obj VALIDATE ~
  FIELD physical_service_code LIKE gsm_physical_service.physical_service_code VALIDATE ~
  FIELD physical_service_description LIKE gsm_physical_service.physical_service_description VALIDATE ~
  FIELD service_type_obj LIKE gsm_physical_service.service_type_obj VALIDATE ~
  FIELD service_type_code LIKE gsc_service_type.service_type_code VALIDATE ~
  FIELD connection_parameters LIKE gsm_physical_service.connection_parameters VALIDATE ~
  FIELD maintenance_object_obj LIKE gsc_service_type.maintenance_object_obj VALIDATE ~
  FIELD object_path LIKE ryc_smartobject.object_path VALIDATE ~
  FIELD object_filename LIKE ryc_smartobject.object_filename VALIDATE 
