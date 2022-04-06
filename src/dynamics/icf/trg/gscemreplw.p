/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*               PSC                                                  *
*                                                                    *
*********************************************************************/
TRIGGER PROCEDURE FOR REPLICATION-WRITE OF gsc_entity_mnemonic OLD BUFFER lb_old.

{af/sup/afreplicat.i  &TABLE-NAME   = "gsc_entity_mnemonic"
                      &TABLE-FLA    = "gscem"
                      &TABLE-PK     = "entity_mnemonic"
                      &OLD-BUFFER   = "lb_old"
                      &ACTION       = "WRITE"
                      
                      
                      &VERSION-DATA = "YES"
}


