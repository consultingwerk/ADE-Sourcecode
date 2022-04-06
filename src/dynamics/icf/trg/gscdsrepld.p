/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*               PSC                                                  *
*                                                                    *
*********************************************************************/
TRIGGER PROCEDURE FOR REPLICATION-DELETE OF gsc_default_set.

{af/sup/afreplicat.i  &TABLE-NAME   = "gsc_default_set"
                      &TABLE-FLA    = "gscds"
                      &TABLE-PK     = "default_set_code"
                      &ACTION       = "DELETE"
                      
                      
                      &VERSION-DATA = "YES"
}
