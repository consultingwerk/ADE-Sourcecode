  FIELD attribute_label LIKE ryc_attribute.attribute_label VALIDATE ~
  FIELD ObjectTypes AS CHARACTER FORMAT "x(200)"~
  FIELD attribute_group_obj LIKE ryc_attribute.attribute_group_obj VALIDATE ~
  FIELD attribute_group_name LIKE ryc_attribute_group.attribute_group_name VALIDATE ~
  FIELD data_type LIKE ryc_attribute.data_type VALIDATE ~
  FIELD attribute_narrative LIKE ryc_attribute.attribute_narrative VALIDATE ~
  FIELD override_type LIKE ryc_attribute.override_type VALIDATE ~
  FIELD runtime_only LIKE ryc_attribute.runtime_only VALIDATE ~
  FIELD is_private LIKE ryc_attribute.is_private VALIDATE ~
  FIELD constant_level LIKE ryc_attribute.constant_level VALIDATE ~
  FIELD derived_value LIKE ryc_attribute.derived_value VALIDATE ~
  FIELD lookup_type LIKE ryc_attribute.lookup_type VALIDATE ~
  FIELD lookup_value LIKE ryc_attribute.lookup_value VALIDATE ~
  FIELD design_only LIKE ryc_attribute.design_only VALIDATE ~
  FIELD system_owned LIKE ryc_attribute.system_owned VALIDATE ~
  FIELD attribute_obj LIKE ryc_attribute.attribute_obj VALIDATE 
