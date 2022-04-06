/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*               PSC                                                  *
*                                                                    *
*********************************************************************/
TRIGGER PROCEDURE FOR REPLICATION-WRITE OF gsc_default_code OLD BUFFER lb_old.

{af/sup/afreplicat.i  &TABLE-NAME   = "gsc_default_code"
                      &TABLE-FLA    = "gscdc"
                      &TABLE-PK     = "default_set_code,
                                       owning_entity_mnemonic,
                                       field_name,
                                       effective_date"
                      &OLD-BUFFER   = "lb_old"
                      &ACTION       = "WRITE"
                      
                      
                      &VERSION-DATA = "YES"
}


