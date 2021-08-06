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
  FIELD layout_name LIKE ryc_layout.layout_name VALIDATE ~
  FIELD layout_type LIKE ryc_layout.layout_type VALIDATE ~
  FIELD layout_code LIKE ryc_layout.layout_code VALIDATE ~
  FIELD layout_filename LIKE ryc_layout.layout_filename VALIDATE ~
  FIELD layout_narrative LIKE ryc_layout.layout_narrative VALIDATE ~
  FIELD sample_image_filename LIKE ryc_layout.sample_image_filename VALIDATE ~
  FIELD system_owned LIKE ryc_layout.system_owned VALIDATE ~
  FIELD layout_obj LIKE ryc_layout.layout_obj VALIDATE 
