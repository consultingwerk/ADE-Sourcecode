  FIELD object_type_code LIKE gsc_object_type.object_type_code VALIDATE ~
  FIELD instance_object_filename AS CHARACTER FORMAT "x(20)" LABEL "Instance Filename"~
  FIELD object_filename LIKE ryc_smartobject.object_filename VALIDATE ~
  FIELD constant_value LIKE ryc_attribute_value.constant_value VALIDATE ~
  FIELD attribute_group_name LIKE ryc_attribute_group.attribute_group_name VALIDATE ~
  FIELD attribute_label LIKE ryc_attribute_value.attribute_label VALIDATE ~
  FIELD AttributeValue AS CHARACTER FORMAT "x(70)" LABEL "Attribute Value"~
  FIELD container_smartobject_obj LIKE ryc_attribute_value.container_smartobject_obj VALIDATE ~
  FIELD object_instance_obj LIKE ryc_attribute_value.object_instance_obj VALIDATE ~
  FIELD object_type_obj LIKE ryc_attribute_value.object_type_obj VALIDATE ~
  FIELD primary_smartobject_obj LIKE ryc_attribute_value.primary_smartobject_obj VALIDATE ~
  FIELD smartobject_obj LIKE ryc_attribute_value.smartobject_obj VALIDATE ~
  FIELD attribute_value_obj LIKE ryc_attribute_value.attribute_value_obj VALIDATE ~
  FIELD layout_position LIKE ryc_object_instance.layout_position VALIDATE ~
  FIELD character_value LIKE ryc_attribute_value.character_value VALIDATE ~
  FIELD date_value LIKE ryc_attribute_value.date_value VALIDATE ~
  FIELD decimal_value LIKE ryc_attribute_value.decimal_value VALIDATE ~
  FIELD integer_value LIKE ryc_attribute_value.integer_value VALIDATE ~
  FIELD logical_value LIKE ryc_attribute_value.logical_value VALIDATE ~
  FIELD raw_value LIKE ryc_attribute_value.raw_value VALIDATE ~
  FIELD lContainer AS LOGICAL FORMAT "YES/NO" LABEL "Container"~
  FIELD data_type LIKE ryc_attribute.data_type VALIDATE ~
  FIELD cContainedObject AS CHARACTER FORMAT "x(70)" LABEL "Contained Object"
