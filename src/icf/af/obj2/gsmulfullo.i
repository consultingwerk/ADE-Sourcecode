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
  FIELD user_obj LIKE gsm_user_allocation.user_obj VALIDATE ~
  FIELD external_userid LIKE gsm_user.external_userid VALIDATE ~
  FIELD user_full_name LIKE gsm_user.user_full_name VALIDATE ~
  FIELD login_organisation_obj LIKE gsm_user_allocation.login_organisation_obj VALIDATE ~
  FIELD owning_entity_mnemonic LIKE gsm_user_allocation.owning_entity_mnemonic VALIDATE ~
  FIELD owning_obj LIKE gsm_user_allocation.owning_obj VALIDATE ~
  FIELD user_allocation_value1 LIKE gsm_user_allocation.user_allocation_value1 VALIDATE ~
  FIELD user_allocation_value2 LIKE gsm_user_allocation.user_allocation_value2 VALIDATE ~
  FIELD user_allocation_obj LIKE gsm_user_allocation.user_allocation_obj VALIDATE ~
