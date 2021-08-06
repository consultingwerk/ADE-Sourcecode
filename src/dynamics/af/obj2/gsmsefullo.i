  FIELD session_type_obj LIKE gsm_session_type.session_type_obj VALIDATE ~
  FIELD session_type_code LIKE gsm_session_type.session_type_code VALIDATE ~
  FIELD session_type_description LIKE gsm_session_type.session_type_description VALIDATE ~
  FIELD physical_session_list LIKE gsm_session_type.physical_session_list VALIDATE  FORMAT "X(35)"~
  FIELD valid_os_list LIKE gsm_session_type.valid_os_list VALIDATE ~
  FIELD automatic_reconnect LIKE gsm_session_type.automatic_reconnect VALIDATE ~
  FIELD extends_session_type_obj LIKE gsm_session_type.extends_session_type_obj VALIDATE ~
  FIELD inactivity_timeout_period LIKE gsm_session_type.inactivity_timeout_period VALIDATE 
