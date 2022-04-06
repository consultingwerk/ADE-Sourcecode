/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*               PSC                                                  *
*                                                                    *
*********************************************************************/
TRIGGER PROCEDURE FOR REPLICATION-DELETE OF gsm_object_menu_structure.

{af/sup/afreplicat.i  &TABLE-NAME   = "gsm_object_menu_structure"
                      &TABLE-FLA    = "gsmom"
                      &TABLE-PK     = "object_obj,
                                       menu_structure_obj,
                                       instance_attribute_obj"
                      &ACTION       = "DELETE"
                      
                      
                      &VERSION-DATA = "YES"
}
