  FIELD node_obj LIKE gsm_node.node_obj VALIDATE ~
  FIELD node_code LIKE gsm_node.node_code VALIDATE ~
  FIELD node_description LIKE gsm_node.node_description VALIDATE ~
  FIELD parent_node_obj LIKE gsm_node.parent_node_obj VALIDATE ~
  FIELD node_label LIKE gsm_node.node_label VALIDATE ~
  FIELD node_checked LIKE gsm_node.node_checked VALIDATE ~
  FIELD data_source_type LIKE gsm_node.data_source_type VALIDATE ~
  FIELD data_source LIKE gsm_node.data_source VALIDATE ~
  FIELD primary_sdo LIKE gsm_node.primary_sdo VALIDATE ~
  FIELD logical_object LIKE gsm_node.logical_object VALIDATE ~
  FIELD run_attribute LIKE gsm_node.run_attribute VALIDATE ~
  FIELD fields_to_store LIKE gsm_node.fields_to_store VALIDATE ~
  FIELD node_text_label_expression LIKE gsm_node.node_text_label_expression VALIDATE ~
  FIELD label_text_substitution_fields LIKE gsm_node.label_text_substitution_fields VALIDATE ~
  FIELD foreign_fields LIKE gsm_node.foreign_fields VALIDATE ~
  FIELD image_file_name LIKE gsm_node.image_file_name VALIDATE ~
  FIELD selected_image_file_name LIKE gsm_node.selected_image_file_name VALIDATE ~
  FIELD cMenuStructureCode AS CHARACTER FORMAT "x(35)" LABEL "Menu Structure"~
  FIELD child_field LIKE gsm_node.child_field~
  FIELD cSDODataSource AS CHARACTER FORMAT "x(35)" LABEL "Data Source"~
  FIELD data_type LIKE gsm_node.data_type~
  FIELD parent_field LIKE gsm_node.parent_field~
  FIELD parent_node_filter LIKE gsm_node.parent_node_filter~
  FIELD structured_node LIKE gsm_node.structured_node
