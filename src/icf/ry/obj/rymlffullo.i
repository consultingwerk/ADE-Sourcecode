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
  FIELD lookup_field_name LIKE rym_lookup_field.lookup_field_name VALIDATE ~
  FIELD specific_object_name LIKE rym_lookup_field.specific_object_name VALIDATE ~
  FIELD sdf_filename LIKE rym_lookup_field.sdf_filename VALIDATE  LABEL "SDF Filename"~
  FIELD base_query_string LIKE rym_lookup_field.base_query_string VALIDATE ~
  FIELD disable_lookup LIKE rym_lookup_field.disable_lookup VALIDATE ~
  FIELD query_tables LIKE rym_lookup_field.query_tables VALIDATE ~
  FIELD rows_to_batch LIKE rym_lookup_field.rows_to_batch VALIDATE  FORMAT ">>>>>9"~
  FIELD key_field_name LIKE rym_lookup_field.key_field_name VALIDATE ~
  FIELD key_field_format LIKE rym_lookup_field.key_field_format VALIDATE ~
  FIELD key_field_datatype LIKE rym_lookup_field.key_field_datatype VALIDATE ~
  FIELD displayed_field_name LIKE rym_lookup_field.displayed_field_name VALIDATE ~
  FIELD displayed_field_format LIKE rym_lookup_field.displayed_field_format VALIDATE ~
  FIELD displayed_field_datatype LIKE rym_lookup_field.displayed_field_datatype VALIDATE ~
  FIELD field_label LIKE rym_lookup_field.field_label VALIDATE ~
  FIELD field_tooltip LIKE rym_lookup_field.field_tooltip VALIDATE ~
  FIELD browse_title LIKE rym_lookup_field.browse_title VALIDATE ~
  FIELD browse_field_list LIKE rym_lookup_field.browse_field_list VALIDATE ~
  FIELD browse_field_datatypes LIKE rym_lookup_field.browse_field_datatypes VALIDATE ~
  FIELD browse_field_formats LIKE rym_lookup_field.browse_field_formats VALIDATE ~
  FIELD linked_field_list LIKE rym_lookup_field.linked_field_list VALIDATE ~
  FIELD linked_field_datatypes LIKE rym_lookup_field.linked_field_datatypes VALIDATE ~
  FIELD linked_field_formats LIKE rym_lookup_field.linked_field_formats VALIDATE ~
  FIELD linked_widget_list LIKE rym_lookup_field.linked_widget_list VALIDATE ~
  FIELD lookup_field_obj LIKE rym_lookup_field.lookup_field_obj VALIDATE 
