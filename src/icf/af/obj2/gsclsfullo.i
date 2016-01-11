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
  FIELD logical_service_obj LIKE gsc_logical_service.logical_service_obj VALIDATE ~
  FIELD logical_service_code LIKE gsc_logical_service.logical_service_code VALIDATE ~
  FIELD logical_service_description LIKE gsc_logical_service.logical_service_description VALIDATE ~
  FIELD service_type_obj LIKE gsc_logical_service.service_type_obj VALIDATE ~
  FIELD service_type_code LIKE gsc_service_type.service_type_code VALIDATE ~
  FIELD can_run_locally LIKE gsc_logical_service.can_run_locally VALIDATE ~
  FIELD system_owned LIKE gsc_logical_service.system_owned VALIDATE ~
  FIELD write_to_config LIKE gsc_logical_service.write_to_config VALIDATE 
