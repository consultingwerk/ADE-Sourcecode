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
  FIELD configuration_type LIKE rvc_configuration_type.configuration_type VALIDATE ~
  FIELD type_table_name LIKE rvc_configuration_type.type_table_name VALIDATE ~
  FIELD type_description LIKE rvc_configuration_type.type_description VALIDATE ~
  FIELD type_locked LIKE rvc_configuration_type.type_locked VALIDATE ~
  FIELD type_deployable LIKE rvc_configuration_type.type_deployable VALIDATE ~
  FIELD baseline_frequency LIKE rvc_configuration_type.baseline_frequency VALIDATE ~
  FIELD scm_code LIKE rvc_configuration_type.scm_code VALIDATE ~
  FIELD scm_identifying_fieldname LIKE rvc_configuration_type.scm_identifying_fieldname VALIDATE ~
  FIELD scm_primary_key_fields LIKE rvc_configuration_type.scm_primary_key_fields VALIDATE ~
  FIELD description_fieldname LIKE rvc_configuration_type.description_fieldname VALIDATE ~
  FIELD product_module_obj LIKE rvc_configuration_type.product_module_obj VALIDATE ~
  FIELD product_module_code LIKE gsc_product_module.product_module_code VALIDATE ~
  FIELD product_module_fieldname LIKE rvc_configuration_type.product_module_fieldname VALIDATE ~
  FIELD configuration_type_obj LIKE rvc_configuration_type.configuration_type_obj VALIDATE ~
  FIELD dataset_code LIKE rvc_configuration_type.dataset_code VALIDATE 
