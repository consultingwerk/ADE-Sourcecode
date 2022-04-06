  FIELD session_service_obj LIKE gsm_session_service.session_service_obj VALIDATE ~
  FIELD session_type_obj LIKE gsm_session_service.session_type_obj VALIDATE ~
  FIELD session_type_code LIKE gsm_session_type.session_type_code VALIDATE ~
  FIELD logical_service_obj LIKE gsm_session_service.logical_service_obj VALIDATE ~
  FIELD logical_service_code LIKE gsc_logical_service.logical_service_code VALIDATE ~
  FIELD physical_service_obj LIKE gsm_session_service.physical_service_obj VALIDATE ~
  FIELD physical_service_code LIKE gsm_physical_service.physical_service_code VALIDATE ~
  FIELD logical_service_type_obj LIKE gsc_logical_service.service_type_obj VALIDATE ~
  FIELD logical_service_type_code AS CHARACTER FORMAT "x(20)" LABEL "Logical Service Type"~
  FIELD physical_service_type_obj LIKE gsm_physical_service.service_type_obj VALIDATE ~
  FIELD physical_service_type_code AS CHARACTER FORMAT "x(20)" LABEL "Physical Service Type"~
  FIELD workaround AS CHARACTER FORMAT "x(8)"
