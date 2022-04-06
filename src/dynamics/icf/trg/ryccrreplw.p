/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*               PSC                                                  *
*                                                                    *
*********************************************************************/
TRIGGER PROCEDURE FOR REPLICATION-WRITE OF ryc_customization_result OLD BUFFER lb_old.

{af/sup/afreplicat.i  &TABLE-NAME   = "ryc_customization_result"
                      &TABLE-FLA    = "ryccr"
                      &TABLE-PK     = "customization_result_obj"
                      &OLD-BUFFER   = "lb_old"
                      &ACTION       = "WRITE"
                      
                      
                      &VERSION-DATA = "YES"
}


