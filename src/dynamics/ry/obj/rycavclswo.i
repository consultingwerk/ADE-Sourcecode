  FIELD object_type_code LIKE gsc_object_type.object_type_code~
  FIELD stringValue AS CHARACTER FORMAT "x(70)" LABEL "Value"~
  FIELD data_type LIKE ryc_attribute.data_type~
  FIELD date_value LIKE ryc_attribute_value.date_value~
  FIELD decimal_value LIKE ryc_attribute_value.decimal_value~
  FIELD integer_value LIKE ryc_attribute_value.integer_value~
  FIELD logical_value LIKE ryc_attribute_value.logical_value~
  FIELD character_value LIKE ryc_attribute_value.character_value
