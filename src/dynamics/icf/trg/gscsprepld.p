/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*               PSC                                                  *
*                                                                    *
*********************************************************************/
TRIGGER PROCEDURE FOR REPLICATION-DELETE OF gsc_session_property.

{af/sup/afreplicat.i  &TABLE-NAME   = "gsc_session_property"
                      &TABLE-FLA    = "gscsp"
                      &TABLE-PK     = "session_property_obj"
                      &ACTION       = "DELETE"
                      
                      
                      &VERSION-DATA = "YES"
}
