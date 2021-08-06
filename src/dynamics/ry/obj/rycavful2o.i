  FIELD object_type_code LIKE gsc_object_type.object_type_code VALIDATE ~
  FIELD instance_object_filename AS CHARACTER FORMAT "x(20)" LABEL "Instance Filename"~
  FIELD object_filename LIKE ryc_smartobject.object_filename VALIDATE ~
  FIELD inheritted_value LIKE ryc_attribute_value.inheritted_value VALIDATE ~
  FIELD constant_value LIKE ryc_attribute_value.constant_value VALIDATE ~
  FIELD attribute_group_name LIKE ryc_attribute_group.attribute_group_name VALIDATE ~
  FIELD attribute_type_tla LIKE ryc_attribute_value.attribute_type_tla VALIDATE ~
  FIELD attribute_label LIKE ryc_attribute_value.attribute_label VALIDATE ~
  FIELD attribute_value LIKE ryc_attribute_value.attribute_value VALIDATE ~
  FIELD FormattedAttributeValue AS CHARACTER FORMAT "x(20)" LABEL "Formatted Attribute Value"~
  FIELD attribute_group_obj LIKE ryc_attribute_value.attribute_group_obj VALIDATE ~
  FIELD collection_sequence LIKE ryc_attribute_value.collection_sequence VALIDATE  LABEL "Collection Sequence"~
  FIELD collect_attribute_value_obj LIKE ryc_attribute_value.collect_attribute_value_obj VALIDATE ~
  FIELD container_smartobject_obj LIKE ryc_attribute_value.container_smartobject_obj VALIDATE ~
  FIELD object_instance_obj LIKE ryc_attribute_value.object_instance_obj VALIDATE ~
  FIELD object_type_obj LIKE ryc_attribute_value.object_type_obj VALIDATE ~
  FIELD primary_smartobject_obj LIKE ryc_attribute_value.primary_smartobject_obj VALIDATE ~
  FIELD smartobject_obj LIKE ryc_attribute_value.smartobject_obj VALIDATE ~
  FIELD lContainer AS LOGICAL FORMAT "YES/NO" LABEL "Container"~
  FIELD attribute_value_obj LIKE ryc_attribute_value.attribute_value_obj VALIDATE ~
  FIELD cContainedObject AS CHARACTER FORMAT "x(70)" LABEL "Contained Object"~
  FIELD layout_position LIKE ryc_object_instance.layout_position VALIDATE 
