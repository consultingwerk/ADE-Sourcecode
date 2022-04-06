/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*               PSC                                                  *
*                                                                    *
*********************************************************************/
TRIGGER PROCEDURE FOR REPLICATION-CREATE OF gsc_delivery_method.

{af/sup/afreplicat.i  &TABLE-NAME   = "gsc_delivery_method"
                      &TABLE-FLA    = "gscdm"
                      &TABLE-PK     = "delivery_method_obj"
                      &ACTION       = "CREATE"
                      
                      
                      &VERSION-DATA = "YES"
}
