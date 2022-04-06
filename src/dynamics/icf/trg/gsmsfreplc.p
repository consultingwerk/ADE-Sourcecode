/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*               PSC                                                  *
*                                                                    *
*********************************************************************/
TRIGGER PROCEDURE FOR REPLICATION-CREATE OF gsm_startup_flow.

{af/sup/afreplicat.i  &TABLE-NAME   = "gsm_startup_flow"
                      &TABLE-FLA    = "gsmsf"
                      &TABLE-PK     = "startup_flow_obj"
                      &ACTION       = "CREATE"
                      
                      
                      &VERSION-DATA = "YES"
}
