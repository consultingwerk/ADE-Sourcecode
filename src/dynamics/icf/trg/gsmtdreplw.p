/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*               PSC                                                  *
*                                                                    *
*********************************************************************/
TRIGGER PROCEDURE FOR REPLICATION-WRITE OF gsm_tagged_data OLD BUFFER lb_old.

{af/sup/afreplicat.i  &TABLE-NAME   = "gsm_tagged_data"
                      &TABLE-FLA    = "gsmtd"
                      &TABLE-PK     = "tagged_data_obj"
                      &OLD-BUFFER   = "lb_old"
                      &ACTION       = "WRITE"
                      
                      
                      &VERSION-DATA = "YES"
}


