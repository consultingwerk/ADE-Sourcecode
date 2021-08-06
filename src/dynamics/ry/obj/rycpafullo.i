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
  FIELD container_smartobject_obj LIKE ryc_page.container_smartobject_obj VALIDATE ~
  FIELD page_obj LIKE ryc_page.page_obj VALIDATE ~
  FIELD layout_obj LIKE ryc_page.layout_obj VALIDATE ~
  FIELD layout_code LIKE ryc_layout.layout_code VALIDATE ~
  FIELD page_sequence LIKE ryc_page.page_sequence VALIDATE ~
  FIELD page_label LIKE ryc_page.page_label VALIDATE ~
  FIELD security_token LIKE ryc_page.security_token VALIDATE ~
  FIELD enable_on_create LIKE ryc_page.enable_on_create VALIDATE ~
  FIELD enable_on_modify LIKE ryc_page.enable_on_modify VALIDATE ~
  FIELD enable_on_view LIKE ryc_page.enable_on_view VALIDATE ~
  FIELD object_filename LIKE ryc_smartobject.object_filename VALIDATE 
