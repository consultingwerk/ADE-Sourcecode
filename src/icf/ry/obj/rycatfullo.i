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
  FIELD attribute_group_name LIKE ryc_attribute_group.attribute_group_name VALIDATE ~
  FIELD attribute_label LIKE ryc_attribute.attribute_label VALIDATE ~
  FIELD attribute_type_tla LIKE ryc_attribute.attribute_type_tla VALIDATE ~
  FIELD system_owned LIKE ryc_attribute.system_owned VALIDATE ~
  FIELD attribute_type_description LIKE ryc_attribute_type.attribute_type_description VALIDATE ~
  FIELD attribute_narrative LIKE ryc_attribute.attribute_narrative VALIDATE ~
  FIELD attribute_group_obj LIKE ryc_attribute.attribute_group_obj VALIDATE ~
  FIELD attribute_obj LIKE ryc_attribute.attribute_obj VALIDATE 
