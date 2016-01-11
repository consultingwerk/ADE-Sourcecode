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
  FIELD service_type_obj LIKE gsc_service_type.service_type_obj VALIDATE ~
  FIELD service_type_code LIKE gsc_service_type.service_type_code VALIDATE ~
  FIELD service_type_description LIKE gsc_service_type.service_type_description VALIDATE ~
  FIELD management_object_obj LIKE gsc_service_type.management_object_obj VALIDATE ~
  FIELD object_filename LIKE gsc_object.object_filename VALIDATE ~
  FIELD mgnt_filename_display AS CHARACTER FORMAT "x(35)" LABEL "Management Object FileName"~
  FIELD maintenance_object_obj LIKE gsc_service_type.maintenance_object_obj VALIDATE ~
  FIELD maint_object_filename AS CHARACTER FORMAT "x(35)" LABEL "Maintenance Object Filename"~
  FIELD default_logical_service_obj LIKE gsc_service_type.default_logical_service_obj VALIDATE ~
  FIELD logical_service_code LIKE gsc_logical_service.logical_service_code VALIDATE ~
  FIELD logical_service_display AS CHARACTER FORMAT "x(35)" LABEL "Default Logical Service"
