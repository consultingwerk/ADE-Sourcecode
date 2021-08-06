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
  FIELD help_obj LIKE gsm_help.help_obj VALIDATE ~
  FIELD help_filename LIKE gsm_help.help_filename VALIDATE ~
  FIELD help_container_filename LIKE gsm_help.help_container_filename VALIDATE ~
  FIELD help_object_filename LIKE gsm_help.help_object_filename VALIDATE ~
  FIELD help_fieldname LIKE gsm_help.help_fieldname VALIDATE ~
  FIELD language_obj LIKE gsm_help.language_obj VALIDATE ~
  FIELD language_code LIKE gsc_language.language_code VALIDATE ~
  FIELD help_context LIKE gsm_help.help_context VALIDATE 
