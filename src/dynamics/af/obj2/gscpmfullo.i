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
  FIELD product_module_obj LIKE gsc_product_module.product_module_obj VALIDATE ~
  FIELD product_obj LIKE gsc_product_module.product_obj VALIDATE ~
  FIELD product_code LIKE gsc_product.product_code VALIDATE ~
  FIELD product_module_code LIKE gsc_product_module.product_module_code VALIDATE ~
  FIELD product_module_description LIKE gsc_product_module.product_module_description VALIDATE ~
  FIELD product_module_installed LIKE gsc_product_module.product_module_installed VALIDATE ~
  FIELD number_of_users LIKE gsc_product_module.number_of_users VALIDATE ~
  FIELD relative_path LIKE gsc_product_module.relative_path VALIDATE 
