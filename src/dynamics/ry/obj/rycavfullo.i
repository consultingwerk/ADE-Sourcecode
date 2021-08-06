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
  FIELD object_type_code LIKE gsc_object_type.object_type_code VALIDATE ~
  FIELD instance_object_filename AS CHARACTER FORMAT "x(20)" LABEL "Instance Filename"~
  FIELD object_filename LIKE ryc_smartobject.object_filename VALIDATE ~
  FIELD inheritted_value LIKE ryc_attribute_value.inheritted_value VALIDATE ~
  FIELD constant_value LIKE ryc_attribute_value.constant_value VALIDATE ~
  FIELD attribute_group_name LIKE ryc_attribute_group.attribute_group_name VALIDATE ~
  FIELD attribute_type_tla LIKE ryc_attribute_value.attribute_type_tla VALIDATE ~
  FIELD attribute_label LIKE ryc_attribute_value.attribute_label VALIDATE ~
  FIELD attribute_value LIKE ryc_attribute_value.attribute_value VALIDATE ~
  FIELD attribute_group_obj LIKE ryc_attribute_value.attribute_group_obj VALIDATE ~
  FIELD collection_sequence LIKE ryc_attribute_value.collection_sequence VALIDATE  LABEL "Collection Sequence"~
  FIELD collect_attribute_value_obj LIKE ryc_attribute_value.collect_attribute_value_obj VALIDATE ~
  FIELD container_smartobject_obj LIKE ryc_attribute_value.container_smartobject_obj VALIDATE ~
  FIELD object_instance_obj LIKE ryc_attribute_value.object_instance_obj VALIDATE ~
  FIELD object_type_obj LIKE ryc_attribute_value.object_type_obj VALIDATE ~
  FIELD primary_smartobject_obj LIKE ryc_attribute_value.primary_smartobject_obj VALIDATE ~
  FIELD smartobject_obj LIKE ryc_attribute_value.smartobject_obj VALIDATE ~
  FIELD lContainer AS LOGICAL FORMAT "YES/NO" LABEL "Container"~
  FIELD attribute_value_obj LIKE ryc_attribute_value.attribute_value_obj VALIDATE ~
  FIELD cContainedObject AS CHARACTER FORMAT "x(70)" LABEL "Contained Object"~
  FIELD layout_position LIKE ryc_object_instance.layout_position VALIDATE 
