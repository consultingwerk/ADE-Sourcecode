/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*               PSC                                                  *
*                                                                    *
*********************************************************************/
TRIGGER PROCEDURE FOR REPLICATION-CREATE OF gsm_session_type_property.

{af/sup/afreplicat.i  &TABLE-NAME   = "gsm_session_type_property"
                      &TABLE-FLA    = "gsmsy"
                      &TABLE-PK     = "session_type_property_obj"
                      &ACTION       = "CREATE"
                      
                      
                      &VERSION-DATA = "YES"
}
