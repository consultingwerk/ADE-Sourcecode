/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*               PSC                                                  *
*                                                                    *
*********************************************************************/
TRIGGER PROCEDURE FOR REPLICATION-CREATE OF gsm_required_manager.

{af/sup/afreplicat.i  &TABLE-NAME   = "gsm_required_manager"
                      &TABLE-FLA    = "gsmrm"
                      &TABLE-PK     = "required_manager_obj"
                      &ACTION       = "CREATE"
                      
                      
                      &VERSION-DATA = "YES"
}
