  FIELD container_filename AS CHARACTER FORMAT "x(20)" LABEL "Container Filename"~
  FIELD container_smartobject_obj LIKE ryc_object_instance.container_smartobject_obj VALIDATE ~
  FIELD layout_position LIKE ryc_object_instance.layout_position VALIDATE ~
  FIELD object_instance_obj LIKE ryc_object_instance.object_instance_obj VALIDATE ~
  FIELD smartobject_obj LIKE ryc_object_instance.smartobject_obj VALIDATE ~
  FIELD system_owned LIKE ryc_object_instance.system_owned VALIDATE ~
  FIELD object_filename-5 LIKE ryc_smartobject.object_filename~
  FIELD object_type_code LIKE gsc_object_type.object_type_code VALIDATE ~
  FIELD product_module_code LIKE gsc_product_module.product_module_code VALIDATE ~
  FIELD product_code LIKE gsc_product.product_code VALIDATE ~
  FIELD layout_obj LIKE ryc_smartobject.layout_obj VALIDATE ~
  FIELD object_type_obj-6 LIKE ryc_smartobject.object_type_obj~
  FIELD product_module_obj-6 LIKE ryc_smartobject.product_module_obj~
  FIELD sdo_smartobject_obj LIKE ryc_smartobject.sdo_smartobject_obj VALIDATE ~
  FIELD shutdown_message_text LIKE ryc_smartobject.shutdown_message_text VALIDATE ~
  FIELD smartobject_obj-2 LIKE ryc_smartobject.smartobject_obj VALIDATE ~
  FIELD static_object LIKE ryc_smartobject.static_object VALIDATE ~
  FIELD system_owned-2 LIKE ryc_smartobject.system_owned VALIDATE ~
  FIELD template_smartobject LIKE ryc_smartobject.template_smartobject VALIDATE ~
  FIELD container_object LIKE ryc_smartobject.container_object VALIDATE ~
  FIELD disabled LIKE ryc_smartobject.disabled VALIDATE ~
  FIELD generic_object LIKE ryc_smartobject.generic_object VALIDATE ~
  FIELD object_description LIKE ryc_smartobject.object_description VALIDATE ~
  FIELD object_filename-6 LIKE ryc_smartobject.object_filename~
  FIELD object_path LIKE ryc_smartobject.object_path VALIDATE ~
  FIELD object_type_obj-7 LIKE ryc_smartobject.object_type_obj~
  FIELD product_module_obj-7 LIKE ryc_smartobject.product_module_obj~
  FIELD required_db_list LIKE ryc_smartobject.required_db_list VALIDATE ~
  FIELD runnable_from_menu LIKE ryc_smartobject.runnable_from_menu VALIDATE ~
  FIELD run_persistent LIKE ryc_smartobject.run_persistent VALIDATE ~
  FIELD run_when LIKE ryc_smartobject.run_when VALIDATE ~
  FIELD security_smartobject_obj LIKE ryc_smartobject.security_smartobject_obj VALIDATE ~
  FIELD disabled-2 LIKE gsc_object_type.disabled VALIDATE ~
  FIELD layout_supported LIKE gsc_object_type.layout_supported VALIDATE ~
  FIELD object_type_description LIKE gsc_object_type.object_type_description VALIDATE ~
  FIELD object_type_obj-3 LIKE gsc_object_type.object_type_obj VALIDATE ~
  FIELD db_connection_pf_file LIKE gsc_product_module.db_connection_pf_file VALIDATE ~
  FIELD number_of_users LIKE gsc_product_module.number_of_users VALIDATE ~
  FIELD product_module_description LIKE gsc_product_module.product_module_description VALIDATE ~
  FIELD product_module_installed LIKE gsc_product_module.product_module_installed VALIDATE ~
  FIELD product_module_obj-3 LIKE gsc_product_module.product_module_obj VALIDATE ~
  FIELD product_obj LIKE gsc_product_module.product_obj VALIDATE ~
  FIELD db_connection_pf_file-2 LIKE gsc_product.db_connection_pf_file VALIDATE ~
  FIELD number_of_users-2 LIKE gsc_product.number_of_users VALIDATE ~
  FIELD product_description LIKE gsc_product.product_description VALIDATE ~
  FIELD product_installed LIKE gsc_product.product_installed VALIDATE ~
  FIELD product_obj-2 LIKE gsc_product.product_obj VALIDATE ~
  FIELD supplier_organisation_obj LIKE gsc_product.supplier_organisation_obj VALIDATE ~
  FIELD page_obj LIKE ryc_object_instance.page_obj~
  FIELD object_sequence LIKE ryc_object_instance.object_sequence~
  FIELD container_smartobject_obj-3 LIKE ryc_page.container_smartobject_obj VALIDATE ~
  FIELD enable_on_create LIKE ryc_page.enable_on_create VALIDATE ~
  FIELD enable_on_modify LIKE ryc_page.enable_on_modify VALIDATE ~
  FIELD enable_on_view LIKE ryc_page.enable_on_view VALIDATE ~
  FIELD layout_obj-2 LIKE ryc_page.layout_obj VALIDATE ~
  FIELD page_label LIKE ryc_page.page_label VALIDATE ~
  FIELD page_obj-2 LIKE ryc_page.page_obj VALIDATE ~
  FIELD page_sequence LIKE ryc_page.page_sequence VALIDATE ~
  FIELD security_token LIKE ryc_page.security_token VALIDATE ~
  FIELD object_filename-7 LIKE ryc_smartobject.object_filename~
  FIELD object_type_obj-8 LIKE ryc_smartobject.object_type_obj~
  FIELD product_module_obj-8 LIKE ryc_smartobject.product_module_obj~
  FIELD object_filename-8 LIKE ryc_smartobject.object_filename~
  FIELD object_type_obj-9 LIKE ryc_smartobject.object_type_obj~
  FIELD product_module_obj-9 LIKE ryc_smartobject.product_module_obj~
  FIELD object_filename-3 LIKE ryc_smartobject.object_filename~
  FIELD object_type_obj-4 LIKE ryc_smartobject.object_type_obj~
  FIELD product_module_obj-4 LIKE ryc_smartobject.product_module_obj~
  FIELD object_filename-4 LIKE ryc_smartobject.object_filename~
  FIELD object_type_obj-5 LIKE ryc_smartobject.object_type_obj~
  FIELD product_module_obj-5 LIKE ryc_smartobject.product_module_obj~
  FIELD object_filename LIKE ryc_smartobject.object_filename VALIDATE ~
  FIELD object_type_obj LIKE ryc_smartobject.object_type_obj VALIDATE ~
  FIELD product_module_obj LIKE ryc_smartobject.product_module_obj VALIDATE ~
  FIELD object_filename-2 LIKE ryc_smartobject.object_filename VALIDATE ~
  FIELD object_type_obj-2 LIKE ryc_smartobject.object_type_obj VALIDATE ~
  FIELD product_module_obj-2 LIKE ryc_smartobject.product_module_obj VALIDATE 
