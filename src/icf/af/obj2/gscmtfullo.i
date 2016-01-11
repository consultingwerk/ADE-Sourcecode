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
  FIELD manager_type_obj LIKE gsc_manager_type.manager_type_obj VALIDATE ~
  FIELD manager_type_code LIKE gsc_manager_type.manager_type_code VALIDATE ~
  FIELD manager_type_name LIKE gsc_manager_type.manager_type_name VALIDATE ~
  FIELD system_owned LIKE gsc_manager_type.system_owned VALIDATE ~
  FIELD write_to_config LIKE gsc_manager_type.write_to_config VALIDATE ~
  FIELD static_handle LIKE gsc_manager_type.static_handle VALIDATE ~
  FIELD manager_narration LIKE gsc_manager_type.manager_narration VALIDATE 
