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
  FIELD category_obj LIKE gsm_category.category_obj VALIDATE ~
  FIELD related_entity_mnemonic LIKE gsm_category.related_entity_mnemonic VALIDATE ~
  FIELD category_type LIKE gsm_category.category_type VALIDATE ~
  FIELD category_group LIKE gsm_category.category_group VALIDATE ~
  FIELD category_subgroup LIKE gsm_category.category_subgroup VALIDATE ~
  FIELD category_group_seq LIKE gsm_category.category_group_seq VALIDATE ~
  FIELD category_label LIKE gsm_category.category_label VALIDATE ~
  FIELD category_description LIKE gsm_category.category_description VALIDATE ~
  FIELD owning_entity_mnemonic LIKE gsm_category.owning_entity_mnemonic VALIDATE ~
  FIELD system_owned LIKE gsm_category.system_owned VALIDATE ~
  FIELD validation_min_length LIKE gsm_category.validation_min_length VALIDATE ~
  FIELD validation_max_length LIKE gsm_category.validation_max_length VALIDATE ~
  FIELD view_as_columns LIKE gsm_category.view_as_columns VALIDATE ~
  FIELD view_as_rows LIKE gsm_category.view_as_rows VALIDATE ~
  FIELD category_mandatory LIKE gsm_category.category_mandatory VALIDATE ~
  FIELD category_active LIKE gsm_category.category_active VALIDATE 
