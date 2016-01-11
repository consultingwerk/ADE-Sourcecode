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
  FIELD product_code LIKE rym_wizard_fold.product_code VALIDATE ~
  FIELD product_module_code LIKE rym_wizard_fold.product_module_code VALIDATE ~
  FIELD object_name LIKE rym_wizard_fold.object_name VALIDATE ~
  FIELD object_description LIKE rym_wizard_fold.object_description VALIDATE ~
  FIELD page_number LIKE rym_wizard_fold_page.page_number VALIDATE ~
  FIELD page_label LIKE rym_wizard_fold_page.page_label VALIDATE ~
  FIELD viewer_object_name LIKE rym_wizard_fold_page.viewer_object_name VALIDATE ~
  FIELD viewer_data_source_names LIKE rym_wizard_fold_page.viewer_data_source_names VALIDATE ~
  FIELD viewer_update_target_names LIKE rym_wizard_fold_page.viewer_update_target_names VALIDATE ~
  FIELD primary_viewer LIKE rym_wizard_fold_page.primary_viewer VALIDATE ~
  FIELD viewer_toolbar_parent_menu LIKE rym_wizard_fold_page.viewer_toolbar_parent_menu VALIDATE ~
  FIELD link_viewer_to_sdo LIKE rym_wizard_fold_page.link_viewer_to_sdo VALIDATE  LABEL "Link Viewer to Data Object"~
  FIELD browser_object_name LIKE rym_wizard_fold_page.browser_object_name VALIDATE ~
  FIELD browser_toolbar_parent_menu LIKE rym_wizard_fold_page.browser_toolbar_parent_menu VALIDATE ~
  FIELD sdo_object_name LIKE rym_wizard_fold_page.sdo_object_name VALIDATE  LABEL "Data Object Name"~
  FIELD query_sdo_name LIKE rym_wizard_fold_page.query_sdo_name VALIDATE ~
  FIELD parent_sdo_object_name LIKE rym_wizard_fold_page.parent_sdo_object_name VALIDATE ~
  FIELD custom_super_procedure LIKE rym_wizard_fold_page.custom_super_procedure VALIDATE ~
  FIELD static_object LIKE rym_wizard_fold_page.static_object VALIDATE ~
  FIELD window_title_field LIKE rym_wizard_fold_page.window_title_field VALIDATE ~
  FIELD wizard_fold_obj LIKE rym_wizard_fold_page.wizard_fold_obj VALIDATE ~
  FIELD page_layout LIKE rym_wizard_fold_page.page_layout VALIDATE ~
  FIELD sdo_foreign_fields LIKE rym_wizard_fold_page.sdo_foreign_fields VALIDATE ~
  FIELD wizard_fold_page_obj LIKE rym_wizard_fold_page.wizard_fold_page_obj VALIDATE 
