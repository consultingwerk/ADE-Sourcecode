/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*               PSC                                                  *
*                                                                    *
*********************************************************************/
TRIGGER PROCEDURE FOR REPLICATION-DELETE OF gsc_entity_display_field.

{af/sup/afreplicat.i  &TABLE-NAME   = "gsc_entity_display_field"
                      &TABLE-FLA    = "gsced"
                      &TABLE-PK     = "entity_display_field_obj"
                      &ACTION       = "DELETE"
                      
                      
                      &VERSION-DATA = "YES"
}
