/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*               PSC                                                  *
*                                                                    *
*********************************************************************/
TRIGGER PROCEDURE FOR REPLICATION-CREATE OF ryc_relationship_field.

{af/sup/afreplicat.i  &TABLE-NAME   = "ryc_relationship_field"
                      &TABLE-FLA    = "rycrf"
                      &TABLE-PK     = "relationship_field_obj"
                      &ACTION       = "CREATE"
                      
                      
                      &VERSION-DATA = "YES"
}
