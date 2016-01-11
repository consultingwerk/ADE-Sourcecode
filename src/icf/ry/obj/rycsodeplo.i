  FIELD object_type_code LIKE gsc_object_type.object_type_code LABEL "Class Code"~
  FIELD object_path LIKE ryc_smartobject.object_path FORMAT "X(15)"~
  FIELD object_filename LIKE ryc_smartobject.object_filename FORMAT "X(21)" LABEL "Filename"~
  FIELD object_extension LIKE ryc_smartobject.object_extension FORMAT "X(5)" LABEL "Extension"~
  FIELD object_description LIKE ryc_smartobject.object_description FORMAT "X(30)" LABEL "Description"~
  FIELD calcDeplString AS CHARACTER FORMAT "x(20)" LABEL "Deploy To"~
  FIELD disabled-2 LIKE ryc_smartobject.disabled LABEL "Object Disabled"~
  FIELD design_only LIKE ryc_smartobject.design_only LABEL "Development Object"~
  FIELD runnable_from_menu LIKE ryc_smartobject.runnable_from_menu~
  FIELD run_when LIKE ryc_smartobject.run_when~
  FIELD system_owned LIKE ryc_smartobject.system_owned~
  FIELD required_db_list LIKE ryc_smartobject.required_db_list~
  FIELD object_type_description LIKE gsc_object_type.object_type_description FORMAT "X(25)" LABEL "Class Description"~
  FIELD disabled LIKE gsc_object_type.disabled LABEL "Class Disabled"~
  FIELD deployment_type LIKE ryc_smartobject.deployment_type FORMAT "X(25)"
