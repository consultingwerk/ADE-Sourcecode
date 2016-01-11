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
  FIELD translation_obj LIKE gsm_translation.translation_obj VALIDATE ~
  FIELD language_obj LIKE gsm_translation.language_obj VALIDATE ~
  FIELD language_code LIKE gsc_language.language_code VALIDATE ~
  FIELD object_filename LIKE gsm_translation.object_filename VALIDATE ~
  FIELD widget_type LIKE gsm_translation.widget_type VALIDATE ~
  FIELD widget_name LIKE gsm_translation.widget_name VALIDATE ~
  FIELD widget_entry LIKE gsm_translation.widget_entry VALIDATE ~
  FIELD original_label LIKE gsm_translation.original_label VALIDATE ~
  FIELD translation_label LIKE gsm_translation.translation_label VALIDATE ~
  FIELD original_tooltip LIKE gsm_translation.original_tooltip VALIDATE ~
  FIELD translation_tooltip LIKE gsm_translation.translation_tooltip VALIDATE 
