/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*               PSC                                                  *
*                                                                    *
*********************************************************************/
TRIGGER PROCEDURE FOR REPLICATION-CREATE OF gsm_toolbar_menu_structure.

{af/sup/afreplicat.i  &TABLE-NAME   = "gsm_toolbar_menu_structure"
                      &TABLE-FLA    = "gsmtm"
                      &TABLE-PK     = "object_obj,
                                       menu_structure_sequence,
                                       menu_structure_obj"
                      &ACTION       = "CREATE"
                      
                      
                      &VERSION-DATA = "YES"
}
