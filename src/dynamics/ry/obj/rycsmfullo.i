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
  FIELD smartlink_obj LIKE ryc_smartlink.smartlink_obj VALIDATE ~
  FIELD container_smartobject_obj LIKE ryc_smartlink.container_smartobject_obj VALIDATE ~
  FIELD smartlink_type_obj LIKE ryc_smartlink.smartlink_type_obj VALIDATE ~
  FIELD link_name LIKE ryc_smartlink.link_name VALIDATE ~
  FIELD source_object_instance_obj LIKE ryc_smartlink.source_object_instance_obj VALIDATE ~
  FIELD source_object_name AS CHARACTER FORMAT "x(25)" LABEL "Source"~
  FIELD target_object_instance_obj LIKE ryc_smartlink.target_object_instance_obj VALIDATE ~
  FIELD link_name-2 LIKE ryc_smartlink_type.link_name VALIDATE ~
  FIELD target_object_name AS CHARACTER FORMAT "x(25)" LABEL "Target"~
  FIELD smartlink_type_obj-2 LIKE ryc_smartlink_type.smartlink_type_obj VALIDATE ~
  FIELD system_owned LIKE ryc_smartlink_type.system_owned VALIDATE ~
  FIELD user_defined_link LIKE ryc_smartlink_type.user_defined_link VALIDATE ~
  FIELD object_filename LIKE ryc_smartobject.object_filename VALIDATE 
