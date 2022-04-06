/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*               PSC                                                  *
*                                                                    *
*********************************************************************/
TRIGGER PROCEDURE FOR REPLICATION-DELETE OF gsm_filter_data.

{af/sup/afreplicat.i  &TABLE-NAME   = "gsm_filter_data"
                      &TABLE-FLA    = "gsmfd"
                      &TABLE-PK     = "filter_data_obj"
                      &ACTION       = "DELETE"
                      
                      
                      &VERSION-DATA = "YES"
}
