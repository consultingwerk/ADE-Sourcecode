  FIELD required_manager_obj LIKE gsm_required_manager.required_manager_obj VALIDATE ~
  FIELD session_type_obj LIKE gsm_required_manager.session_type_obj VALIDATE ~
  FIELD session_type_code LIKE gsm_session_type.session_type_code VALIDATE ~
  FIELD startup_order LIKE gsm_required_manager.startup_order VALIDATE ~
  FIELD manager_type_obj LIKE gsm_required_manager.manager_type_obj VALIDATE ~
  FIELD manager_type_code LIKE gsc_manager_type.manager_type_code VALIDATE ~
  FIELD object_obj LIKE gsm_required_manager.object_obj VALIDATE ~
  FIELD object_description LIKE ryc_smartobject.object_description VALIDATE ~
  FIELD object_filename LIKE ryc_smartobject.object_filename VALIDATE ~
  FIELD system_owned LIKE gsm_required_manager.system_owned VALIDATE 
