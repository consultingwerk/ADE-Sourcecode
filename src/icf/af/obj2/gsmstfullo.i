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
  FIELD status_obj LIKE gsm_status.status_obj VALIDATE ~
  FIELD category_obj LIKE gsm_status.category_obj VALIDATE ~
  FIELD category_description LIKE gsm_category.category_description VALIDATE ~
  FIELD status_seq LIKE gsm_status.status_seq VALIDATE ~
  FIELD status_tla LIKE gsm_status.status_tla VALIDATE ~
  FIELD status_short_desc LIKE gsm_status.status_short_desc VALIDATE ~
  FIELD status_description LIKE gsm_status.status_description VALIDATE ~
  FIELD retain_status_history LIKE gsm_status.retain_status_history VALIDATE ~
  FIELD system_owned LIKE gsm_status.system_owned VALIDATE ~
  FIELD auto_display LIKE gsm_status.auto_display VALIDATE 
