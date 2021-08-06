  FIELD smartobject_obj LIKE ryc_smartobject.smartobject_obj VALIDATE ~
  FIELD object_type_obj LIKE ryc_smartobject.object_type_obj VALIDATE ~
  FIELD product_obj LIKE gsc_product_module.product_obj VALIDATE ~
  FIELD dProductObj AS DECIMAL FORMAT ">>>>>>>>>>>>>>>>>9.999999999" LABEL "Product Obj"~
  FIELD product_module_obj LIKE ryc_smartobject.product_module_obj VALIDATE ~
  FIELD object_description LIKE ryc_smartobject.object_description VALIDATE ~
  FIELD object_filename LIKE ryc_smartobject.object_filename VALIDATE ~
  FIELD object_path LIKE ryc_smartobject.object_path VALIDATE ~
  FIELD runnable_from_menu LIKE ryc_smartobject.runnable_from_menu VALIDATE ~
  FIELD disabled LIKE ryc_smartobject.disabled VALIDATE ~
  FIELD run_persistent LIKE ryc_smartobject.run_persistent VALIDATE ~
  FIELD run_when LIKE ryc_smartobject.run_when VALIDATE ~
  FIELD security_smartobject_obj LIKE ryc_smartobject.security_smartobject_obj VALIDATE ~
  FIELD container_object LIKE ryc_smartobject.container_object VALIDATE ~
  FIELD physical_smartobject_obj LIKE ryc_smartobject.physical_smartobject_obj VALIDATE ~
  FIELD generic_object LIKE ryc_smartobject.generic_object VALIDATE ~
  FIELD required_db_list LIKE ryc_smartobject.required_db_list VALIDATE ~
  FIELD layout_obj LIKE ryc_smartobject.layout_obj VALIDATE ~
  FIELD custom_smartobject_obj LIKE ryc_smartobject.custom_smartobject_obj VALIDATE ~
  FIELD sdo_smartobject_obj LIKE ryc_smartobject.sdo_smartobject_obj VALIDATE ~
  FIELD shutdown_message_text LIKE ryc_smartobject.shutdown_message_text VALIDATE ~
  FIELD static_object LIKE ryc_smartobject.static_object VALIDATE ~
  FIELD system_owned LIKE ryc_smartobject.system_owned VALIDATE ~
  FIELD template_smartobject LIKE ryc_smartobject.template_smartobject VALIDATE ~
  FIELD object_extension LIKE ryc_smartobject.object_extension VALIDATE ~
  FIELD product_module_code LIKE gsc_product_module.product_module_code VALIDATE ~
  FIELD dLayoutObj AS DECIMAL FORMAT ">>>>>>>>>>>>>9.999999999" LABEL "Layout"~
  FIELD product_module_description LIKE gsc_product_module.product_module_description VALIDATE ~
  FIELD dSDOSmartObject AS DECIMAL FORMAT ">>>>>>>>>>>>>9.999999999" LABEL "SDO SmartObject"~
  FIELD edShutdownMessageText AS CHARACTER FORMAT "x(70)" LABEL "Shutdown Message Text"~
  FIELD lStaticObject AS LOGICAL FORMAT "Yes/No" LABEL "Static Object"~
  FIELD lSystemOwned AS LOGICAL FORMAT "Yes/No" LABEL "System Owned"~
  FIELD lTemplateSmartobject AS LOGICAL FORMAT "Yes/No" LABEL "Template Smartobject"
