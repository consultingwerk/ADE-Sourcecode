/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation ("PSC"),       *
* 14 Oak Park, Bedford, MA 01730, and other contributors as listed   *
* below.  All Rights Reserved.                                       *
*                                                                    *
* The Initial Developer of the Original Code is PSC.  The Original   *
* Code is Progress IDE code released to open source December 1, 2000.*
*                                                                    *
* The contents of this file are subject to the Possenet Public       *
* License Version 1.0 (the "License"); you may not use this file     *
* except in compliance with the License.  A copy of the License is   *
* available as of the date of this notice at                         *
* http://www.possenet.org/license.html                               *
*                                                                    *
* Software distributed under the License is distributed on an "AS IS"*
* basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. You*
* should refer to the License for the specific language governing    *
* rights and limitations under the License.                          *
*                                                                    *
* Contributors:                                                      *
*                                                                    *
*********************************************************************/
  FIELD object_filename LIKE ryc_smartobject.object_filename VALIDATE  FORMAT "X(35)"~
  FIELD product_module_code LIKE gsc_product_module.product_module_code VALIDATE  LABEL "Product Module"~
  FIELD object_type_code LIKE gsc_object_type.object_type_code VALIDATE  LABEL "Object Type"~
  FIELD layout_name LIKE ryc_layout.layout_name VALIDATE ~
  FIELD layout_code LIKE ryc_layout.layout_code VALIDATE ~
  FIELD object_description LIKE gsc_object.object_description VALIDATE ~
  FIELD static_object LIKE ryc_smartobject.static_object VALIDATE  LABEL "Static"~
  FIELD template_smartobject LIKE ryc_smartobject.template_smartobject VALIDATE  LABEL "Template"~
  FIELD system_owned LIKE ryc_smartobject.system_owned VALIDATE ~
  FIELD custom_super_procedure LIKE ryc_smartobject.custom_super_procedure VALIDATE ~
  FIELD shutdown_message_text LIKE ryc_smartobject.shutdown_message_text VALIDATE ~
  FIELD container_object LIKE gsc_object.container_object VALIDATE ~
  FIELD layout_obj LIKE ryc_smartobject.layout_obj VALIDATE ~
  FIELD object_obj LIKE ryc_smartobject.object_obj VALIDATE ~
  FIELD object_type_obj LIKE ryc_smartobject.object_type_obj VALIDATE ~
  FIELD product_module_obj LIKE ryc_smartobject.product_module_obj VALIDATE ~
  FIELD sdo_smartobject_obj LIKE ryc_smartobject.sdo_smartobject_obj VALIDATE ~
  FIELD smartobject_obj LIKE ryc_smartobject.smartobject_obj VALIDATE ~
  FIELD disabled LIKE gsc_object_type.disabled VALIDATE ~
  FIELD layout_supported LIKE gsc_object_type.layout_supported VALIDATE ~
  FIELD object_type_description LIKE gsc_object_type.object_type_description VALIDATE ~
  FIELD object_type_obj-2 LIKE gsc_object_type.object_type_obj VALIDATE ~
  FIELD db_connection_pf_file LIKE gsc_product_module.db_connection_pf_file VALIDATE ~
  FIELD number_of_users LIKE gsc_product_module.number_of_users VALIDATE ~
  FIELD product_module_description LIKE gsc_product_module.product_module_description VALIDATE ~
  FIELD product_module_installed LIKE gsc_product_module.product_module_installed VALIDATE ~
  FIELD product_module_obj-2 LIKE gsc_product_module.product_module_obj VALIDATE ~
  FIELD product_obj LIKE gsc_product_module.product_obj VALIDATE ~
  FIELD disabled-2 LIKE gsc_object.disabled VALIDATE ~
  FIELD generic_object LIKE gsc_object.generic_object VALIDATE ~
  FIELD logical_object LIKE gsc_object.logical_object VALIDATE ~
  FIELD object_filename-2 LIKE gsc_object.object_filename VALIDATE ~
  FIELD object_obj-2 LIKE gsc_object.object_obj VALIDATE ~
  FIELD object_path LIKE gsc_object.object_path VALIDATE ~
  FIELD object_type_obj-3 LIKE gsc_object.object_type_obj VALIDATE ~
  FIELD physical_object_obj LIKE gsc_object.physical_object_obj VALIDATE ~
  FIELD product_module_obj-3 LIKE gsc_object.product_module_obj VALIDATE ~
  FIELD required_db_list LIKE gsc_object.required_db_list VALIDATE ~
  FIELD runnable_from_menu LIKE gsc_object.runnable_from_menu VALIDATE ~
  FIELD run_persistent LIKE gsc_object.run_persistent VALIDATE ~
  FIELD run_when LIKE gsc_object.run_when VALIDATE ~
  FIELD security_object_obj LIKE gsc_object.security_object_obj VALIDATE ~
  FIELD toolbar_image_filename LIKE gsc_object.toolbar_image_filename VALIDATE ~
  FIELD toolbar_multi_media_obj LIKE gsc_object.toolbar_multi_media_obj VALIDATE ~
  FIELD tooltip_text LIKE gsc_object.tooltip_text VALIDATE ~
  FIELD layout_filename LIKE ryc_layout.layout_filename VALIDATE ~
  FIELD layout_narrative LIKE ryc_layout.layout_narrative VALIDATE ~
  FIELD layout_obj-2 LIKE ryc_layout.layout_obj VALIDATE ~
  FIELD layout_type LIKE ryc_layout.layout_type VALIDATE ~
  FIELD sample_image_filename LIKE ryc_layout.sample_image_filename VALIDATE ~
  FIELD system_owned-2 LIKE ryc_layout.system_owned VALIDATE ~
  FIELD multi_media_description LIKE gsm_multi_media.multi_media_description VALIDATE ~
  FIELD product_code LIKE gsc_product.product_code VALIDATE ~
  FIELD db_connection_pf_file-2 LIKE gsc_product.db_connection_pf_file VALIDATE ~
  FIELD securityObject AS DECIMAL FORMAT "999999999999999999.999999" LABEL "Security Object"~
  FIELD toolbarMultiMedia AS DECIMAL FORMAT "999999999999999999.999999" LABEL "Multi Media"~
  FIELD physicalObject AS DECIMAL FORMAT "999999999999999999.999999" LABEL "Physical Object"~
  FIELD dObjectInstance AS DECIMAL FORMAT "999999999999999999.999999" LABEL "Object Instance"~
  FIELD runWhen AS CHARACTER FORMAT "x(8)" LABEL "Run When"~
  FIELD number_of_users-2 LIKE gsc_product.number_of_users VALIDATE ~
  FIELD product_description LIKE gsc_product.product_description VALIDATE ~
  FIELD product_installed LIKE gsc_product.product_installed VALIDATE ~
  FIELD product_obj-2 LIKE gsc_product.product_obj VALIDATE ~
  FIELD supplier_organisation_obj LIKE gsc_product.supplier_organisation_obj VALIDATE ~
  FIELD physical_file_name LIKE gsm_multi_media.physical_file_name VALIDATE ~
  FIELD owning_obj LIKE gsm_multi_media.owning_obj VALIDATE ~
  FIELD multi_media_type_obj LIKE gsm_multi_media.multi_media_type_obj VALIDATE ~
  FIELD multi_media_obj LIKE gsm_multi_media.multi_media_obj VALIDATE ~
  FIELD creation_date LIKE gsm_multi_media.creation_date VALIDATE ~
  FIELD category_obj LIKE gsm_multi_media.category_obj VALIDATE 
