/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*               PSC                                                  *
*                                                                    *
*********************************************************************/
TRIGGER PROCEDURE FOR REPLICATION-CREATE OF gsc_manager_type.

{af/sup/afreplicat.i  &TABLE-NAME   = "gsc_manager_type"
                      &TABLE-FLA    = "gscmt"
                      &TABLE-PK     = "manager_type_obj"
                      &ACTION       = "CREATE"
                      
                      
                      &VERSION-DATA = "YES"
}
