  FIELD object_type_obj LIKE gsc_object_type.object_type_obj VALIDATE ~
  FIELD object_type_code LIKE gsc_object_type.object_type_code~
  FIELD object_type_description LIKE gsc_object_type.object_type_description~
  FIELD disabled LIKE gsc_object_type.disabled~
  FIELD layout_supported LIKE gsc_object_type.layout_supported~
  FIELD deployment_type LIKE gsc_object_type.deployment_type~
  FIELD static_object LIKE gsc_object_type.static_object~
  FIELD class_smartobject_obj LIKE gsc_object_type.class_smartobject_obj VALIDATE ~
  FIELD extends_object_type_obj LIKE gsc_object_type.extends_object_type_obj VALIDATE ~
  FIELD cache_on_client LIKE gsc_object_type.cache_on_client~
  FIELD custom_object_type_obj LIKE gsc_object_type.custom_object_type_obj~
  FIELD CustomizedLabel AS CHARACTER FORMAT "x(35)"~
  FIELD DataTags AS CHARACTER FORMAT "x(20)" LABEL "Data Tags"
