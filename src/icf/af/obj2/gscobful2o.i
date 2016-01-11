  FIELD object_obj LIKE gsc_object.object_obj VALIDATE ~
  FIELD object_type_obj LIKE gsc_object.object_type_obj VALIDATE ~
  FIELD product_obj LIKE gsc_product_module.product_obj VALIDATE ~
  FIELD dProductObj AS DECIMAL FORMAT ">>>>>>>>>>>>>>>>>9.999999999" LABEL "Product Obj"~
  FIELD product_module_obj LIKE gsc_object.product_module_obj VALIDATE ~
  FIELD object_description LIKE gsc_object.object_description VALIDATE ~
  FIELD object_filename LIKE gsc_object.object_filename VALIDATE  LABEL "Object Name"~
  FIELD object_path LIKE gsc_object.object_path VALIDATE ~
  FIELD toolbar_multi_media_obj LIKE gsc_object.toolbar_multi_media_obj VALIDATE ~
  FIELD toolbar_image_filename LIKE gsc_object.toolbar_image_filename VALIDATE ~
  FIELD tooltip_text LIKE gsc_object.tooltip_text VALIDATE ~
  FIELD runnable_from_menu LIKE gsc_object.runnable_from_menu VALIDATE ~
  FIELD disabled LIKE gsc_object.disabled VALIDATE ~
  FIELD run_persistent LIKE gsc_object.run_persistent VALIDATE ~
  FIELD run_when LIKE gsc_object.run_when VALIDATE ~
  FIELD security_object_obj LIKE gsc_object.security_object_obj VALIDATE ~
  FIELD container_object LIKE gsc_object.container_object VALIDATE ~
  FIELD physical_object_obj LIKE gsc_object.physical_object_obj VALIDATE ~
  FIELD logical_object LIKE gsc_object.logical_object VALIDATE ~
  FIELD generic_object LIKE gsc_object.generic_object VALIDATE ~
  FIELD required_db_list LIKE gsc_object.required_db_list VALIDATE ~
  FIELD layout_obj LIKE ryc_smartobject.layout_obj VALIDATE ~
  FIELD custom_super_procedure LIKE ryc_smartobject.custom_super_procedure VALIDATE ~
  FIELD sdo_smartobject_obj LIKE ryc_smartobject.sdo_smartobject_obj VALIDATE ~
  FIELD shutdown_message_text LIKE ryc_smartobject.shutdown_message_text VALIDATE ~
  FIELD static_object LIKE ryc_smartobject.static_object VALIDATE ~
  FIELD system_owned LIKE ryc_smartobject.system_owned VALIDATE ~
  FIELD template_smartobject LIKE ryc_smartobject.template_smartobject VALIDATE ~
  FIELD cCustomSuperProcedure AS CHARACTER FORMAT "x(70)" LABEL "Custom Super Procedure"~
  FIELD smartobject_obj LIKE ryc_smartobject.smartobject_obj VALIDATE ~
  FIELD object_extension LIKE gsc_object.object_extension VALIDATE ~
  FIELD dLayoutObj AS DECIMAL FORMAT ">>>>>>>>>>>>>9.999999999" LABEL "Layout"~
  FIELD product_module_code LIKE gsc_product_module.product_module_code VALIDATE ~
  FIELD dSDOSmartObject AS DECIMAL FORMAT ">>>>>>>>>>>>>9.999999999" LABEL "SDO Smart Object"~
  FIELD product_module_description LIKE gsc_product_module.product_module_description VALIDATE ~
  FIELD edShutdownMessageText AS CHARACTER FORMAT "x(70)" LABEL "Shutdown Message Text"~
  FIELD lStaticObject AS LOGICAL FORMAT "Yes/No" LABEL "Static Object"~
  FIELD lSystemOwned AS LOGICAL FORMAT "Yes/No" LABEL "System Owned"~
  FIELD lTemplateSmartObject AS LOGICAL FORMAT "Yes/No" LABEL "Template Smart Object"
