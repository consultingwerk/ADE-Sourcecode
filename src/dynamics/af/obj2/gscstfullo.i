  FIELD service_type_obj LIKE gsc_service_type.service_type_obj VALIDATE ~
  FIELD service_type_code LIKE gsc_service_type.service_type_code VALIDATE ~
  FIELD service_type_description LIKE gsc_service_type.service_type_description VALIDATE ~
  FIELD management_object_obj LIKE gsc_service_type.management_object_obj VALIDATE ~
  FIELD object_filename LIKE ryc_smartobject.object_filename VALIDATE ~
  FIELD mgnt_filename_display AS CHARACTER FORMAT "x(35)" LABEL "Management Object FileName"~
  FIELD maintenance_object_obj LIKE gsc_service_type.maintenance_object_obj VALIDATE ~
  FIELD maint_object_filename AS CHARACTER FORMAT "x(35)" LABEL "Maintenance Object Filename"~
  FIELD default_logical_service_obj LIKE gsc_service_type.default_logical_service_obj VALIDATE ~
  FIELD logical_service_code LIKE gsc_logical_service.logical_service_code VALIDATE ~
  FIELD logical_service_display AS CHARACTER FORMAT "x(35)" LABEL "Default Logical Service"
