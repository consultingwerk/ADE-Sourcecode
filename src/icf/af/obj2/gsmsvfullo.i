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
  FIELD session_service_obj LIKE gsm_session_service.session_service_obj VALIDATE ~
  FIELD session_type_obj LIKE gsm_session_service.session_type_obj VALIDATE ~
  FIELD session_type_code LIKE gsm_session_type.session_type_code VALIDATE ~
  FIELD logical_service_obj LIKE gsm_session_service.logical_service_obj VALIDATE ~
  FIELD logical_service_code LIKE gsc_logical_service.logical_service_code VALIDATE  FORMAT "X(20)"~
  FIELD physical_service_obj LIKE gsm_session_service.physical_service_obj VALIDATE ~
  FIELD physical_service_code LIKE gsm_physical_service.physical_service_code VALIDATE  FORMAT "X(20)"~
  FIELD logical_service_type_obj LIKE gsc_logical_service.service_type_obj VALIDATE ~
  FIELD logical_service_type_code AS CHARACTER FORMAT "x(20)" LABEL "Logical Service Type"~
  FIELD physical_service_type_obj LIKE gsm_physical_service.service_type_obj VALIDATE ~
  FIELD physical_service_type_code AS CHARACTER FORMAT "x(20)" LABEL "Physical Service Type"~
  FIELD workaround AS CHARACTER FORMAT "x(8)"
