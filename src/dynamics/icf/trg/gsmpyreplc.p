/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*               PSC                                                  *
*                                                                    *
*********************************************************************/
TRIGGER PROCEDURE FOR REPLICATION-CREATE OF gsm_physical_service.

{af/sup/afreplicat.i  &TABLE-NAME   = "gsm_physical_service"
                      &TABLE-FLA    = "gsmpy"
                      &TABLE-PK     = "physical_service_obj"
                      &ACTION       = "CREATE"
                      
                      
                      &VERSION-DATA = "YES"
}
