/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*               PSC                                                  *
*                                                                    *
*********************************************************************/
TRIGGER PROCEDURE FOR REPLICATION-WRITE OF gsm_required_manager OLD BUFFER lb_old.

{af/sup/afreplicat.i  &TABLE-NAME   = "gsm_required_manager"
                      &TABLE-FLA    = "gsmrm"
                      &TABLE-PK     = "required_manager_obj"
                      &OLD-BUFFER   = "lb_old"
                      &ACTION       = "WRITE"
                      
                      
                      &VERSION-DATA = "YES"
}


