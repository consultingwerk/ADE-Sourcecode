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
  FIELD sequence_obj LIKE gsc_sequence.sequence_obj VALIDATE ~
  FIELD company_organisation_obj LIKE gsc_sequence.company_organisation_obj VALIDATE ~
  FIELD login_company_name LIKE gsm_login_company.login_company_name VALIDATE ~
  FIELD owning_entity_mnemonic LIKE gsc_sequence.owning_entity_mnemonic VALIDATE ~
  FIELD sequence_tla LIKE gsc_sequence.sequence_tla VALIDATE ~
  FIELD sequence_short_desc LIKE gsc_sequence.sequence_short_desc VALIDATE ~
  FIELD sequence_description LIKE gsc_sequence.sequence_description VALIDATE ~
  FIELD min_value LIKE gsc_sequence.min_value VALIDATE ~
  FIELD max_value LIKE gsc_sequence.max_value VALIDATE ~
  FIELD sequence_format LIKE gsc_sequence.sequence_format VALIDATE ~
  FIELD auto_generate LIKE gsc_sequence.auto_generate VALIDATE ~
  FIELD multi_transaction LIKE gsc_sequence.multi_transaction VALIDATE ~
  FIELD next_value LIKE gsc_sequence.next_value VALIDATE ~
  FIELD number_of_sequences LIKE gsc_sequence.number_of_sequences VALIDATE ~
  FIELD sequence_active LIKE gsc_sequence.sequence_active VALIDATE 
