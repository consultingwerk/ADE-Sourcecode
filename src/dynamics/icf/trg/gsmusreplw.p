/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*               PSC                                                  *
*                                                                    *
*********************************************************************/
TRIGGER PROCEDURE FOR REPLICATION-WRITE OF gsm_user OLD BUFFER lb_old.

{af/sup/afreplicat.i  &TABLE-NAME   = "gsm_user"
                      &TABLE-FLA    = "gsmus"
                      &TABLE-PK     = "user_obj"
                      &OLD-BUFFER   = "lb_old"
                      &ACTION       = "WRITE"
                      
                      
                      &VERSION-DATA = "YES"
}


