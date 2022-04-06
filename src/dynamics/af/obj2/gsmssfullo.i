  FIELD security_structure_obj LIKE gsm_security_structure.security_structure_obj VALIDATE ~
  FIELD owning_entity_mnemonic LIKE gsm_security_structure.owning_entity_mnemonic VALIDATE ~
  FIELD owning_obj LIKE gsm_security_structure.owning_obj VALIDATE ~
  FIELD product_module_obj LIKE gsm_security_structure.product_module_obj VALIDATE ~
  FIELD product_module_code LIKE gsc_product_module.product_module_code VALIDATE ~
  FIELD product_module_display AS CHARACTER FORMAT "x(10)" LABEL "Product Module Code"~
  FIELD object_obj LIKE gsm_security_structure.object_obj VALIDATE ~
  FIELD object_filename LIKE ryc_smartobject.object_filename VALIDATE ~
  FIELD object_filename_display AS CHARACTER FORMAT "x(35)" LABEL "Object Filename"~
  FIELD instance_attribute_obj LIKE gsm_security_structure.instance_attribute_obj VALIDATE ~
  FIELD attribute_code LIKE gsc_instance_attribute.attribute_code VALIDATE ~
  FIELD attribute_code_display AS CHARACTER FORMAT "x(35)" LABEL "Attribute Code"~
  FIELD disabled LIKE gsm_security_structure.disabled VALIDATE 
