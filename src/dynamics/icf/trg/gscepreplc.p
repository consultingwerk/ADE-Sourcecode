/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*               PSC                                                  *
*                                                                    *
*********************************************************************/
TRIGGER PROCEDURE FOR REPLICATION-CREATE OF gsc_entity_mnemonic_procedure.

{af/sup/afreplicat.i  &TABLE-NAME   = "gsc_entity_mnemonic_procedure"
                      &TABLE-FLA    = "gscep"
                      &TABLE-PK     = "custom_procedure_obj,
                                       owning_entity_mnemonic"
                      &ACTION       = "CREATE"
                      
                      
                      &VERSION-DATA = "YES"
}
