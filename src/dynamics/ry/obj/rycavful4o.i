  FIELD attribute_value_obj LIKE ryc_attribute_value.attribute_value_obj VALIDATE ~
  FIELD object_type_obj LIKE ryc_attribute_value.object_type_obj VALIDATE ~
  FIELD container_smartobject_obj LIKE ryc_attribute_value.container_smartobject_obj VALIDATE ~
  FIELD smartobject_obj LIKE ryc_attribute_value.smartobject_obj VALIDATE ~
  FIELD object_instance_obj LIKE ryc_attribute_value.object_instance_obj VALIDATE ~
  FIELD constant_value LIKE ryc_attribute_value.constant_value VALIDATE ~
  FIELD attribute_label LIKE ryc_attribute_value.attribute_label VALIDATE ~
  FIELD primary_smartobject_obj LIKE ryc_attribute_value.primary_smartobject_obj VALIDATE ~
  FIELD character_value LIKE ryc_attribute_value.character_value VALIDATE ~
  FIELD date_value LIKE ryc_attribute_value.date_value VALIDATE ~
  FIELD decimal_value LIKE ryc_attribute_value.decimal_value VALIDATE ~
  FIELD integer_value LIKE ryc_attribute_value.integer_value VALIDATE ~
  FIELD logical_value LIKE ryc_attribute_value.logical_value VALIDATE ~
  FIELD raw_value LIKE ryc_attribute_value.raw_value VALIDATE ~
  FIELD data_type LIKE ryc_attribute.data_type VALIDATE ~
  FIELD attribute_group_obj LIKE ryc_attribute.attribute_group_obj VALIDATE ~
  FIELD dAttributeGroupObj AS DECIMAL FORMAT "->>>>>>>>>>>>>>>>>9.999999999" LABEL "Attribute Group Obj"~
  FIELD applies_at_runtime LIKE ryc_attribute_value.applies_at_runtime
