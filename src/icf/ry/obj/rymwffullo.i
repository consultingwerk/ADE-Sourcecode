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
  FIELD window_title LIKE rym_wizard_fold.window_title VALIDATE ~
  FIELD default_mode LIKE rym_wizard_fold.default_mode VALIDATE ~
  FIELD no_sdo LIKE rym_wizard_fold.no_sdo VALIDATE  LABEL "No Data Object"~
  FIELD page_layout LIKE rym_wizard_fold.page_layout VALIDATE ~
  FIELD viewer_link_name LIKE rym_wizard_fold.viewer_link_name VALIDATE ~
  FIELD generated_date LIKE rym_wizard_fold.generated_date VALIDATE ~
  FIELD generated_time LIKE rym_wizard_fold.generated_time VALIDATE ~
  FIELD generated_time_str AS CHARACTER FORMAT "x(8)" LABEL "Time"~
  FIELD wizard_fold_obj LIKE rym_wizard_fold.wizard_fold_obj VALIDATE 
