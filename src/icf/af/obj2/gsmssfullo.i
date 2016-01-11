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
  FIELD security_structure_obj LIKE gsm_security_structure.security_structure_obj VALIDATE ~
  FIELD owning_entity_mnemonic LIKE gsm_security_structure.owning_entity_mnemonic VALIDATE ~
  FIELD owning_obj LIKE gsm_security_structure.owning_obj VALIDATE ~
  FIELD product_module_obj LIKE gsm_security_structure.product_module_obj VALIDATE ~
  FIELD product_module_code LIKE gsc_product_module.product_module_code VALIDATE ~
  FIELD product_module_display AS CHARACTER FORMAT "x(10)" LABEL "Product Module Code"~
  FIELD object_obj LIKE gsm_security_structure.object_obj VALIDATE ~
  FIELD object_filename LIKE gsc_object.object_filename VALIDATE ~
  FIELD object_filename_display AS CHARACTER FORMAT "x(35)" LABEL "Object Filename"~
  FIELD instance_attribute_obj LIKE gsm_security_structure.instance_attribute_obj VALIDATE ~
  FIELD attribute_code LIKE gsc_instance_attribute.attribute_code VALIDATE ~
  FIELD attribute_code_display AS CHARACTER FORMAT "x(35)" LABEL "Attribute Code"~
  FIELD disabled LIKE gsm_security_structure.disabled VALIDATE 
