/*************************************************************/  
/* Copyright (c) 1984-2005 by Progress Software Corporation  */
/*                                                           */
/* All rights reserved.  No part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from PROGRESS Software Corporation. */
/*************************************************************/
  FIELD smartobject_obj LIKE ryc_smartobject.smartobject_obj VALIDATE ~
  FIELD object_type_obj LIKE ryc_smartobject.object_type_obj VALIDATE ~
  FIELD product_obj LIKE gsc_product_module.product_obj VALIDATE ~
  FIELD dProductObj AS DECIMAL FORMAT "->>>>>>>>>>>>>>>>>9.999999999" LABEL "Product Obj"~
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
  FIELD generic_object LIKE ryc_smartobject.generic_object VALIDATE ~
  FIELD required_db_list LIKE ryc_smartobject.required_db_list VALIDATE ~
  FIELD layout_obj LIKE ryc_smartobject.layout_obj VALIDATE ~
  FIELD sdo_smartobject_obj LIKE ryc_smartobject.sdo_smartobject_obj VALIDATE ~
  FIELD shutdown_message_text LIKE ryc_smartobject.shutdown_message_text VALIDATE ~
  FIELD static_object LIKE ryc_smartobject.static_object VALIDATE ~
  FIELD system_owned LIKE ryc_smartobject.system_owned VALIDATE ~
  FIELD template_smartobject LIKE ryc_smartobject.template_smartobject VALIDATE ~
  FIELD object_extension LIKE ryc_smartobject.object_extension VALIDATE ~
  FIELD product_module_code LIKE gsc_product_module.product_module_code VALIDATE ~
  FIELD product_module_description LIKE gsc_product_module.product_module_description VALIDATE ~
  FIELD customization_result_obj LIKE ryc_smartobject.customization_result_obj VALIDATE ~
  FIELD deployment_type LIKE ryc_smartobject.deployment_type VALIDATE ~
  FIELD design_only LIKE ryc_smartobject.design_only VALIDATE ~
  FIELD extends_smartobject_obj LIKE ryc_smartobject.extends_smartobject_obj VALIDATE ~
  FIELD object_type_code LIKE gsc_object_type.object_type_code VALIDATE ~
  FIELD relative_path LIKE gsc_product_module.relative_path~
  FIELD object_is_runnable LIKE ryc_smartobject.object_is_runnable
