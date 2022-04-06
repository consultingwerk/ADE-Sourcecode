/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*               PSC                                                  *
*                                                                    *
*********************************************************************/
TRIGGER PROCEDURE FOR REPLICATION-DELETE OF gsc_entity_mnemonic.

{af/sup/afreplicat.i  &TABLE-NAME   = "gsc_entity_mnemonic"
                      &TABLE-FLA    = "gscem"
                      &TABLE-PK     = "entity_mnemonic"
                      &ACTION       = "DELETE"
                      
                      
                      &VERSION-DATA = "YES"
}
